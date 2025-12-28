unit Funciones;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, DBGrids, StdCtrls, Graphics, ExtCtrls, ZConnection,
  ZDataset, Buttons, ComCtrls;

const
Mayuscula = ['A'..'Z'];

  procedure Conectate(dbConect:  TZConnection);
  procedure BlancoGrid(Grid: TDBGrid);
  procedure Colorea(Column: TColumn;Grid: TDBGrid;dbColor: TZQuery; var AntColund: String; var Orden: String; var TituloColumn: String; var Ordenado: Boolean);
  procedure RellenaListBoxAnos(TxtQuery: String; dbAnos: TZQuery; PanelSelectAno: TPanel; ListBoxAnos: TListBox);
  //procedure RellenaPanelCambiable(TxtQuery: String; dbCambiable: TZQuery; StaticTextCambiableNombre: TEdit);
  procedure RellenaPanelCambiableN(TxtQuery: String; dbCambiable: TZQuery; StaticTextCambiableNombre: TStaticText);
  procedure RellenaComboBoxCambiableNombre(TxtQuery: String; dbCambiableComboBox: TZQuery; ComboBoxCambiableNombre: TComboBox);
  //procedure RedimensionaYColocaDBGrid(Grid: TDBGrid);
  procedure EscogeNombreComboCambiable( TxtCampo: String; ComboCambiableNombre: TComboBox;
                                        dbCambiable: TZQuery; EditCambiableCodigo: TEdit;
                                        StaticTextCambiableNombre: TStaticText);
  procedure CargaValoresEnComboCambiable( TxtQuery: String; ComboCambiableNombre: TComboBox;  dbCambiable: TZQuery;
                                          LabelCambiable: TLabel);
  function ExisteDB(MiConexion: TZConnection; MiBD: string): Boolean;
  function VersiNumero(s : string): boolean;
  function EsNumero(valor: string): boolean;
  function EsFloat(valor: string): boolean;
  function IsMayuscula(c : char) : Boolean; inline;
  function EsFechaValida(strFecha: string; boEstrict: Boolean=False): Boolean;
  //-------------------- Para buscar en la bbdd cuando se sale de un edit
  function DevuelveValor(TxtQuery: String; dbCambiable: TZQuery; valor1, campodevuelve:string):string;
  //--------------------
  procedure ColorearFormularios();
  function CheckRoles(dbRoles: TZQuery; CodigoRol:String; Campo:String; Accion: Integer): Boolean;

implementation
uses
  Global;

procedure Conectate(dbConect:  TZConnection);
 //var dbConect:  TZConnection;
 begin
//----------------- CONEXION -----------------
  dbConect.HostName:=DBHost;
  dbConect.Database:=DBDataBase;
  dbConect.User:=DBUsuario;
  dbConect.Password:=DBPasswd;
  dbConect.Port:=StrToInt(DBPuerto);
  dbConect.Protocol:=DBProtocolo;
  dbConect.Connected:=True;
end;

//------------------------ CONTROLAR ROLES ---------------------------
function CheckRoles(dbRoles: TZQuery; CodigoRol:String; Campo:String; Accion: Integer): Boolean;
begin
  if CodigoRol='' then begin Result:=True; exit; end;
  dbRoles.Sql.Text:='SELECT * FROM roles'+Tienda+' WHERE CgoRol='+CodigoRol;
  dbRoles.Active:=True;
  if dbRoles.RecordCount=0 then begin Result:=True; exit; end;
  if Copy(dbRoles.FieldByName(Campo).AsString,Accion,1)='0' then Result:=False else Result:=True;
end;


//-------- Poner las columnas del grid en blanco
procedure BlancoGrid(Grid: TDBGrid);
var
  conta:integer;
begin
for conta:=0 to Grid.Columns.Count-1 do
    begin Grid.Columns[conta].Color:= $00F4E7E7 ; //clWindow;
  end;
end;

procedure Colorea(Column: TColumn;Grid: TDBGrid;dbColor: TZQuery; var AntColund: String; var Orden: String; var TituloColumn: String; var Ordenado: Boolean);
var
 TxtQuery,TxtQuery1: String;
 x,j: integer;
begin
  TxtQuery:=dbColor.Sql.Text;
  j:=length(TxtQuery);
  x:=pos('ORDER',TxtQuery);
  if x=0 then x:=pos('ORDER',TxtQuery);
  delete(TxtQuery,x,j-(x-1));
  BlancoGrid(Grid);
  if AntColund <> '' then
     begin
     If StrToInt(AntColund) = Column.Index Then
        if Orden = ' ASC' then Orden:='DESC' else Orden:=' ASC';
  end;
  AntColund:=IntTostr(Column.Index);
  if Orden = 'DESC' then Column.Color := $00DEDEF5 else Column.Color := $00FDEDDF;
  dbColor.Active:=False;
  TxtQuery1:='ORDER BY ' + Column.FieldName +' '+ Orden;
  Insert(TxtQuery1,TxtQuery,j);
  dbColor.Sql.Text:=TxtQuery; dbColor.Active:=True;
  dbColor.Refresh; Grid.Refresh; Ordenado:=True;
  TituloColumn:=Column.FieldName;
end;

// ===================== OBTENER AÑOS PARA EL ListBoxAnos
// pasamos como parametro la instrucci´on SQL de donde estan los años buscados
procedure RellenaListBoxAnos(TxtQuery: String; dbAnos: TZQuery; PanelSelectAno: TPanel; ListBoxAnos: TListBox);
var cont, indidef: integer;
begin
     //WriteLn('TxtQuery    ->'+TxtQuery);
     dbAnos.Active:=False;
     dbAnos.SQL.Text:=TxtQuery;
     dbAnos.Active:=True;
     if dbAnos.RecordCount<>0 then
       begin
         dbAnos.First; ListBoxAnos.Items.Clear;
         cont:=0; indidef:=0;
         while not dbAnos.EOF do
          begin
            ListBoxAnos.Items.Add(dbAnos.Fields[0].AsString);
            if dbAnos.Fields[0].AsString = FormatDateTime('YYYY',Date) then indidef:=cont;
            dbAnos.Next;
            cont:=cont+1;
          end;
         ListBoxAnos.ItemIndex:=indidef;
       end;
     PanelSelectAno.Visible:=True;
end;
// ===================== OBTENER y CARGAR DE DATOS EL ComboBoxCambiableNombre
// pasamos como parametro la instrucci´on SQL de donde estan los datos buscados
procedure RellenaComboBoxCambiableNombre(TxtQuery: String; dbCambiableComboBox: TZQuery; ComboBoxCambiableNombre: TComboBox);

begin
     dbCambiableComboBox.Active:=False;
     dbCambiableComboBox.SQL.Text:=TxtQuery;
     dbCambiableComboBox.Active:=True;
     if dbCambiableComboBox.RecordCount<>0 then
       begin
         dbCambiableComboBox.First; ComboBoxCambiableNombre.Items.Clear;
         while not dbCambiableComboBox.EOF do
          begin
            ComboBoxCambiableNombre.Items.Add(dbCambiableComboBox.Fields[0].AsString);
            dbCambiableComboBox.Next;
          end;
         ComboBoxCambiableNombre.ItemIndex:=0;
       end;
     //PanelSelectAno.Visible:=True;
end;


//======================= Completa el campo del panelCambiable una vez que tenemos un c´odigo
// pasamos como parametro la instrucci´on SQL de donde estan los buscados
procedure RellenaPanelCambiableN(TxtQuery: String; dbCambiable: TZQuery; StaticTextCambiableNombre: TStaticText);
begin
     dbCambiable.Active:=False;
     dbCambiable.SQL.Text:=TxtQuery;
     dbCambiable.Active:=True;
     if dbCambiable.RecordCount<>0 then
       begin
         dbCambiable.First; StaticTextCambiableNombre.Caption:='';
         StaticTextCambiableNombre.Caption:=dbCambiable.Fields[0].AsString;
         //WriteLn('StaticTextCambiableNombre.Caption    ->'+StaticTextCambiableNombre.Caption);
       end
     else StaticTextCambiableNombre.Caption:='';
end;
//====================== Completa los campos del panelCambiable una vez que tenemos un nombre
//Se le pasan todos los elementos del Panel cambiable y cuando escogemos un item del Combo actualiza todo el panel
procedure EscogeNombreComboCambiable( TxtCampo: String; ComboCambiableNombre: TComboBox;  dbCambiable: TZQuery;
                                      EditCambiableCodigo: TEdit; StaticTextCambiableNombre: TStaticText);
begin
  if ComboCambiableNombre.Text='' then begin ComboCambiableNombre.Visible:=False; EditCambiableCodigo.SetFocus; exit; end;
  if not dbCambiable.Locate(TxtCampo,ComboCambiableNombre.Text,[]) then begin EditCambiableCodigo.Text:=''; Exit; end;
  EditCambiableCodigo.Text:=dbCambiable.Fields[0].AsString;
  //Writeln('dbCambiable  0 '+dbCambiable.Fields[0].AsString+'     1 '+dbCambiable.Fields[1].AsString);
  StaticTextCambiableNombre.Caption:=dbCambiable.Fields[1].AsString;
  ComboCambiableNombre.Visible:=False;
end;

procedure CargaValoresEnComboCambiable(TxtQuery: String; ComboCambiableNombre: TComboBox;  dbCambiable: TZQuery;
                                      LabelCambiable: TLabel);
begin
  ComboCambiableNombre.Clear; ComboCambiableNombre.Text:='';
  dbCambiable.SQL.Text:=TxtQuery; dbCambiable.Active:=True;
  if dbCambiable.RecordCount=0 then
    begin
      ShowMessage('NO HAY NINGUN '+LabelCambiable.Caption+' CREADO');
      dbCambiable.Active:=False; Exit;
    end;
  dbCambiable.First;
  While not dbCambiable.EOF do
    begin
      ComboCambiableNombre.Items.Add(dbCambiable.Fields[1].AsString);
      dbCambiable.Next;
    end;
  ComboCambiableNombre.Visible:=True; ComboCambiableNombre.ItemIndex:=0; ComboCambiableNombre.SetFocus;
end;
//====================== COLOREAR EL FORMULARIO Y SUS COMPONENTES ========================
procedure ColorearFormularios();
var
  cont: Integer;
begin
{  if ColorFondo<>'' then Color:=StringToColor(ColorFondo);
    cont:=0;
  if ColorBotones<>'' then
    begin
     for cont:=0 to ComponentCount-1 do
       begin
        if (Components[cont] is TBitBtn) then
          TBitBtn(FindComponent(Components[cont].Name)).color:=StringToColor(ColorBotones);
       end;
    end;
}
end;


// Devuelve True si la Base de Datos por la que se pregunta existe en ese servidor
function ExisteDB(MiConexion: TZConnection; MiBD: string): Boolean;
  var
    //dbQuery: TZQuery;
    RC: integer;
  begin
    MiConexion.ExecuteDirect('SHOW DATABASES LIKE "'+MiBD+'"', RC);
    //dbQuery.Connection:=MiConexion;
    //dbQuery.SQL.Text:='SHOW DATABASES LIKE '+MiBD;
    //dbQuery.ExecSQL;
    if RC=0 then Result := False else Result := True;
  end;
// Devuelve TRUE si el char que se le pasa es una Mayúscula, No incluye la Ñ
function IsMayuscula(c : char) : Boolean;
  begin
    Result := c in Mayuscula;
  end;
//======================= REDIMENSIONA Y COLOCA LOS DBGrid de los Listados
// Estos paramentros se podian pasar como argumento, pero creo que asi es mas facil
// tambien se podria incluir un centrado horizontal, si supiera como
//procedure RedimensionaYColocaDBGrid(Grid: TDBGrid);
//begin
  //grid.Width:=1100;
  //grid.Height:=600;
  //Grid.Top:=30;
//end;
function VersiNumero(s : string): boolean;
var
    I, Hay, Hay1: Integer;
begin
  DecimalSeparator:='.';
    If S='' then begin Result:=False; exit; end;
    Hay:=0; Hay1:=0;
    for I:=1 to Length(S) do
      begin
        if ((Copy(S,I,1)>='0') and (Copy(S,I,1)<='9')) or (Copy(S,I,1)='.') or (Copy(S,I,1)='-')then
           Hay1:=1 else Hay := 1;
      end;
    if Hay=0 then Result := True else Result := False;
end;

function EsNumero(valor: string): boolean;
begin
  try
    StrToInt(valor);
    EsNumero := true;
  except
    EsNumero := False;
  end;
end;
function EsFloat(valor: string): boolean;
begin
  try
    StrToFloat(valor);
    EsFloat := true;
  except
    EsFloat := False;
    ShowMessage('"'+valor + '" No es un valor válido para este campo');
  end;
end;
//======================== CHEQUEAR FECHAS ==================

// Verifica si el formato de la fecha que se le pasa en strFecha es correcto respecto
// del que tiene defindo el sistema.
// La función admite uno o dos parametros. Si no se le pasa el 2º parametro, éste
// tomará el valor de False (opción por defecto)
// Si el parámetro boEstrict es False admitirá cadenas de texto vacías, de lo
// contrario (True) strFecha deberá ser siempre una fecha válida
function EsFechaValida(strFecha: string; boEstrict: Boolean=False): Boolean;
var
   miFecha: TDateTime;
begin
     Result := True;
     try
        miFecha := StrToDate(strFecha);
     except
        if boEstrict Then Result := False
        else if strFecha<>'' Then Result := False
     end;
end;

//============ PARA BUSCAR EN LA BBDD CUANDO SE SALE DE UN EDIT ===================
function DevuelveValor(TxtQuery: String; dbCambiable: TZQuery; valor1, campodevuelve:string):string;
begin
     result:='';
     if valor1='' then exit;
     dbCambiable.active:=False;
     dbCambiable.sql.text:=TxtQuery;
     dbCambiable.Active:=True;
     if dbCambiable.RecordCount > 0 then begin
          result:=dbCambiable.FieldByName(campodevuelve).AsString;
     end;
     dbCambiable.Active:=False;
end;


end.
