unit principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ComCtrls, Buttons, IniFiles, StdCtrls, DOS;

type

  { TformPrincipal }

  TformPrincipal = class(TForm)
    bBtnMySQL: TBitBtn;
    bBtnFacturLinEx: TBitBtn;
    bBtnUtils: TBitBtn;
    bBtnSalir: TBitBtn;
    mFacturLinEx2: TMemo;
    mUtilidades: TMemo;
    mMySQL: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure bBtnMySQLClick(Sender: TObject);
    procedure bBtnFacturLinExClick(Sender: TObject);
    procedure bBtnUtilsClick(Sender: TObject);
    procedure bBtnSalirClick(Sender: TObject);
  private
    { private declarations }
    seccion_mysql : array [1..3] of string;
    seccion_factu : array [1..3] of string;
    seccion_utils : array [1..3] of string;
  public
    { public declarations }
    IniReader : TIniFile;
    Sections : TStringList;
    Contents : TStringList;
  end;

var
  formPrincipal: TformPrincipal;

implementation

{ TformPrincipal }

procedure TformPrincipal.FormCreate(Sender: TObject);
begin
  // Lectura del Fichero INI
  IniReader := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'opciones.ini');
  Sections := TStringList.Create;
  Contents := TStringList.Create;
  IniReader.ReadSections( Sections );
  seccion_mysql[1] := IniReader.ReadString('mysql','nombre','');
  seccion_mysql[2] := IniReader.ReadString('mysql','version','');
  seccion_mysql[3] := IniReader.ReadString('mysql','ejecutable','');
  seccion_factu[1] := IniReader.ReadString('facturlinex2','nombre','');
  seccion_factu[2] := IniReader.ReadString('facturlinex2','version','');
  seccion_factu[3] := IniReader.ReadString('facturlinex2','ejecutable','');
  seccion_utils[1] := IniReader.ReadString('utilidades','nombre','');
  seccion_utils[2] := IniReader.ReadString('utilidades','version','');
  seccion_utils[3] := IniReader.ReadString('utilidades','ejecutable','');
  // Datos a visualizar de los programas
  mMySQL.Clear;
  mMySQL.Lines.Add('BBDD: '+seccion_mysql[1]);
  mMySQL.Lines.Add('Versión: '+seccion_mysql[2]);
  // mMySQL.Lines.Add('Ejecutable: '+seccion_mysql[3]);
  mFacturLinEx2.Clear;
  mFacturLinEx2.Lines.Add('Nombre: '+seccion_factu[1]);
  mFacturLinEx2.Lines.Add('Versión: '+seccion_factu[2]);
  // mFacturLinEx2.Lines.Add('Ejecutable: '+seccion_factu[3]);
  mUtilidades.Clear;
  mUtilidades.Lines.Add('Nombre: '+seccion_utils[1]);
  mUtilidades.Lines.Add('Versión: '+seccion_utils[2]);
  // mUtilidades.Lines.Add('Ejecutable: '+seccion_utils[3]);
end;

procedure TformPrincipal.bBtnMySQLClick(Sender: TObject);
begin
  // Instalación del Servidor MySQL
  ShowMessage('Proceso de Instalación de...' + #13 + ExtractFilePath(ParamStr(0))+seccion_mysql[3]);
  Exec(ExtractFilePath(ParamStr(0))+seccion_mysql[3],'');
end;

procedure TformPrincipal.bBtnFacturLinExClick(Sender: TObject);
begin
  // Instalación de FacturLinEx 2
  ShowMessage('Proceso de Instalación de...' + #13 + ExtractFilePath(ParamStr(0))+seccion_factu[3]);
  Exec(ExtractFilePath(ParamStr(0))+seccion_factu[3],'');
end;

procedure TformPrincipal.bBtnUtilsClick(Sender: TObject);
begin
  // Instalación de Utilidades
  ShowMessage('Proceso de Instalación de...' + #13 + ExtractFilePath(ParamStr(0))+seccion_utils[3]);
  Exec(ExtractFilePath(ParamStr(0))+seccion_utils[3],'');
end;

procedure TformPrincipal.bBtnSalirClick(Sender: TObject);
begin
  Application.Terminate;
end;

initialization
  {$I principal.lrs}

end.

