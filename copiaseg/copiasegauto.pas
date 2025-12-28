unit copiasegauto;

{$mode objfpc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ZConnection, ZDataset, LCLType, StdCtrls, ExtCtrls, DB;

type

  { TfCopiaSegAuto }

  TfCopiaSegAuto = class(TForm)
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
    Query: TZQuery;
    Query0: TZQuery;
    Query1: TZQuery;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure GenerarSQL(FicheroDestino: string);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  fCopiaSegAuto: TfCopiaSegAuto;

implementation

uses global, funciones, copiaseg;

{ TfCopiaSegAuto }

procedure TfCopiaSegAuto.FormCreate(Sender: TObject);
begin
  //Conectate(dbConect);    // Utilizamos datamodule1.dbConexión para toda la aplicación.
end;

procedure TfCopiaSegAuto.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
end;

procedure TfCopiaSegAuto.GenerarSQL(FicheroDestino: String);
var
  F:    TFileStream;
  clong, cont, cont2, cont3: integer;
  Cabecera: array[1..7] of string;
  s, Destino, DestinoConf, cString, cEnHex:   ansistring;
  dia, mes, anio: word;
  hora, minuto, segundo, milisegundo: word;
  car: char;
begin
  // ----------
  // Creación del fichero SQL con el script de la Copia de Seguridad
  // al fichero de la copia se añade la fecha en la que se hace
  // el usuario puede cambiar el nombre del fichero a su elección
  // ----------

  label3.Caption := FicheroDestino;

  destino:=FicheroDestino;
  progressBar1.Position := 0;
  if Query.Active then Query.Close;
  if Query0.Active then Query0.Close;
  if Query1.Active then Query1.Close;
  Cabecera[1] := '# --';
  Cabecera[2] := '# -- FacturLinEx 2 -> dump';
  Cabecera[3] := '# -- Script de Copia de Seguridad Automatica';
  Cabecera[4] := '# --';
  Cabecera[5] := '# ------------------------------------------';
  Cabecera[6] := '# -- Fecha: '+DateToStr(date())+ '  Hora: '+TimeToStr(Time());
  Cabecera[7] := '# --';
  // Añadir aqui toda la información de interes a indicar en el fichero de copias
  Application.ProcessMessages;
  F := TFileStream.Create(destino, fmCreate);
  // Creación de la Cabecera del Fichero de copia
  for cont := 1 to 7 do
  begin
    s := Cabecera[cont] + #10;    F.Write(s[1], Length(s));
  end;
  s := #13 + #10;   F.Write(s[1], Length(s)); // Añadimos una linea en blanco para una mejor visualizacio

  // NOTAS
  // * show create database database - regresa la instrucción sql para crear la base (CREATE DATABASE...)
  // * show tables from database - te regresa una tabla con los nombre de las tablas de la base.
  // * show create table database.table - te regresa la instrucción sql para crear la tabla (CREATE TABLE ...)

  Query.SQL.Clear;
  Query.SQL.Add('show create database '+datamodule1.dbConexion.Database);
  Query.Open;
  s := '# --' + Query.FieldByName('Create Database').AsString + ';' + #10;  F.Write(s[1], Length(s));
  Query.Close;

  s := #10;   F.Write(s[1], Length(s));    // Linea en blanco

  Query0.SQL.Clear;
  Query0.SQL.Add('show tables from '+datamodule1.dbConexion.Database);
  Query0.Open;
  Query0.First;
  While not Query0.EOF do begin
     Query.SQL.Clear;
     Query.SQL.Add('show create table '+datamodule1.dbConexion.Database+'.'+Query0.Fields.FieldByNumber(1).AsString);
     Query.Open;
     s := '# --' + #10;     F.Write(s[1], Length(s));
     s := '# -- Estructura de la Tabla '+Query0.Fields.FieldByNumber(1).AsString + #10;     F.Write(s[1], Length(s));
     s := '# --' + #10;     F.Write(s[1], Length(s));
     s := #10;   F.Write(s[1], Length(s));    // Linea en blanco
     s := Query.FieldByName('Create Table').AsString + ';';
     s := fCopiaSeg.LimpiaCadena(s);      // Función para eliminar el carácter #10 LF
     F.Write(s[1], Length(s));
     s := #10;   F.Write(s[1], Length(s));    // Linea en blanco
     s := '# --' + #10;     F.Write(s[1], Length(s));
     s := '# -- Datos Contenidos en la Tabla '+Query0.Fields.FieldByNumber(1).AsString + #10;     F.Write(s[1], Length(s));
     s := '# --' + #10;     F.Write(s[1], Length(s));
     s := #13 + #10;   F.Write(s[1], Length(s));    // Linea en blanco
     Query1.SQL.Clear;
     Query1.SQL.Add('select * from '+Query0.Fields.FieldByNumber(1).AsString);
     Query1.Open;
     Query1.First;
     if Query1.EOF = Query1.BOF then begin
        s := '# -- NO HAY DATOS EN ESTA TABLA...';   F.Write(s[1], Length(s));
        s := #10;   F.Write(s[1], Length(s));    // Linea en blanco
     end else begin
         While not Query1.EOF do begin
            s := 'INSERT INTO `'+Query0.Fields.FieldByNumber(1).AsString+'` VALUES (';
            for cont2 := 1 to Query1.FieldCount do begin
                // Verificamos el tipo de la variable para generar el fichero de salida
                if Query1.Fields.FieldByNumber(cont2).IsNull then     // Contenido NULL
                   s := s + 'NULL'
                else begin
                   CASE Query1.Fields.FieldByNumber(cont2).DataType of
                        ftDate :  begin
                                    DecodeDate(Query1.Fields.FieldByNumber(cont2).AsDateTime,anio,mes,dia);
                                    s := s + '''';
                                    s := s + IntToStr(anio) + '-' + IntToStr(mes) + '-' + IntToStr(dia);
                                    s := s + '''';
                                  end;
                       ftTime :   begin
                                    DecodeTime(Query1.Fields.FieldByNumber(cont2).AsDateTime,hora, minuto, segundo, milisegundo);
                                    s := s + '''';
                                    s := s + IntToStr(hora) + ':' + IntToStr(minuto) + ':' + IntToStr(segundo);
                                    s := s + '''';
                                  end;
                        ftBlob  : begin
                                    if length(Query1.Fields.FieldByNumber(cont2).AsString) > 0 then begin
                                       cEnHex := '0x';
                                       cString := Query1.Fields.FieldByNumber(cont2).AsString;
                                       for cont3 := 1 to length(cString) do begin
                                           car := cString[cont3];
                                           cEnHex := cEnHex + fCopiaSeg.Char2Hex(car);
                                       end;
                                       s := s + cEnHex;
                                    end else
                                       s := s + '''''';
                                  end;
                   else begin
                           s := s + '''';
                           s := s + fCopiaSeg.FiltrarCadena(Query1.Fields.FieldByNumber(cont2).AsString);
                           s := s + '''';
                        end;
                   end;
                end;
                   if cont2 <> Query1.FieldCount then s := s + ',';

            end;
            s := s + ');' + #10;     F.Write(s[1], Length(s));
            Query1.Next;
         end;
     end;
     Query1.Close;
     s := #10;   F.Write(s[1], Length(s));    // Linea en blanco
     Query0.Next;
    ProgressBar1.Position := Round((Query0.RecNo*100)/Query0.RecordCount);
    Application.ProcessMessages;
  end;
  Query.Close;
  Query0.Close;
  Query1.Close;
  F.Free;
  Self.Close;
end;

initialization
  {$I copiasegauto.lrs}

end.

