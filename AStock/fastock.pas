unit FAStock;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ZDataset, ZConnection, ComCtrls, LCLType, DBGrids,
  db, DbCtrls, EditBtn, LR_DBSet, LR_Class, ExtDlgs, Process;

type

  { TFastock }

  TFastock = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Datasource1: TDatasource;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    LabelBusqueda: TLabel;
    LabelAyudaArticulo: TLabel;
    LabelAyudaStock: TLabel;
    LabelTitulo: TLabel;
    LabelSubtitulo: TLabel;
    LabelHistorialTitulo: TLabel;
    LabelHistorialAyuda: TLabel;
    LabelHistorialVacio: TLabel;
    LabelPie: TLabel;
    GroupArticulo: TGroupBox;
    GroupStock: TGroupBox;
    PanelCabecera: TPanel;
    PanelHistorialCab: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    dbAStock: TZQuery;
    dbHiststock: TZQuery;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure Edit5Exit(Sender: TObject);
    procedure Edit5KeyPress(Sender: TObject; var Key: char);
    procedure Edit6Exit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Limpiar();

    function compruebatecla(key: char):char;

  private
    { Devuelve vacío cuando el campo Código/EAN está vacío. Si se ha
      introducido un EAN y el artículo está localizado, devuelve su A0. }
    function CodigoFiltroHistorial: string;
    procedure CargarHistorial(const ACampoOrden, ASentido: string);
  public
    { public declarations }
  end;

  Procedure ShowFormStock;

var
  stock: TFastock;
  Inicio: Boolean;
  sOrden: string;
  sCampoOrden: string;

implementation

uses
  Global, Funciones, Busquedas;

{ TFastock }

//=============== Crea el formulario ================
procedure ShowFormStock;
begin
  with TFastock.Create(Application) do
    begin
       ShowModal;
       Inicio:=True;
    end;
end;

procedure TFastock.FormActivate(Sender: TObject);
begin
    if Inicio then
     Begin
          Edit1.SetFocus;
          Inicio:=False;
     End;
end;

procedure TFastock.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := CaFree;
end;

procedure TFastock.FormShow(Sender: TObject);
begin
    if Inicio then
     Begin
          Edit1.SetFocus;
          Inicio:=False;
     End;
end;

procedure TFastock.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key <> VK_ESCAPE then Exit;

  Key := 0;

  { Si el historial está desplegado, ESC retrocede al formulario principal
    usando exactamente la misma acción que el botón Ocultar historial. }
  if DBGrid1.Visible then
  begin
    BitBtn2Click(BitBtn2);
    if Edit1.CanFocus then Edit1.SetFocus;
    Exit;
  end;

  { En la pantalla principal, ESC ejecuta el cierre normal existente. }
  BitBtn3Click(BitBtn3);
end;

Procedure TFastock.Formcreate(Sender: Tobject);
Begin
  ShortDateFormat:='DD/MM/YYYY';
  {$IFDEF LINUX}
     DecimalSeparator:='.';
  {$ELSE}
     DecimalSeparator:=',';
  {$ENDIF}
  //----------------- CONEXION -----------------
  //Conectate(dbConect);     // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Tablas ------------------
  dbAStock.Sql.Text := 'SELECT * FROM artitien'+Tienda+'';
  dbAStock.Active := True;
  dbHiststock.SQL.Text := 'SELECT * FROM histstock'+Tienda+'';
  dbHiststock.Active := True;
  sOrden:='DESC';
  sCampoOrden:='';
end;

procedure TFastock.Edit1KeyPress(Sender: TObject; var Key: char);
begin
     key:=compruebatecla(key); // -- Las funciones OnKeyPress de todos los campos Edit, estan asociados a este mismo procedimiento, no siendo necesario crear un procedimiento por cada campo
end;

procedure TFastock.Edit2KeyPress(Sender: TObject; var Key: char);
begin
      if ( key = Char(VK_RETURN) ) then // -- En caso de pulsar enter, pasa al siguiente campo
         begin
              key:=#0;
              if Edit2.Text='' then
               begin
                    showmessage('Debe escribir texto a buscar');
                    Exit;
               end;
              Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT A0,A1 FROM artitien'+Tienda+' WHERE A1 LIKE "%'+Edit2.Text+'%"',['Código','Descripción'],'A0');
              if Edit1.Text<>'' then Edit1Exit(Edit1);
         end;
end;

procedure TFastock.Edit5Exit(Sender: TObject);
begin
  Edit6.SetFocus;
end;

procedure TFastock.Edit5KeyPress(Sender: TObject; var Key: char);
begin
     // -- Solo permite la insercion de numeros y la pulsacion de enter o teclas especiales -------
      if ( StrScan('0123456789',Key) <> nil ) or ( Key = Char(VK_BACK) )
           or  ( Key = Char(VK_TAB) )  or  ( Key = Char(VK_RETURN) ) or  ( Key = Char(VK_UP) )
           or  ( Key = Char(VK_DOWN) ) then
      else
          begin
               Key := #0;
          end;
       if ( key = Char(VK_RETURN) ) then // -- En caso de pulsar enter, pasa al siguiente campo
         begin
              key:=#0;
              BitBtn1.SetFocus;
         end;
      if ( key = Char(VK_UP) ) then // -- Si pulsamos la flecha arriba, vuelve al campo anterior
         begin
              key:=#0;
              SelectNext(activecontrol,false,true);
         end;
      if ( key = Char(VK_DOWN) ) then // -- Si pulsamos la flecha abajo, pasa al campo siguiente
         begin
              key:=#0;
              SelectNext(activecontrol,true,true);
         end;
end;

procedure TFastock.Edit6Exit(Sender: TObject);
begin
    BitBtn1.SetFocus;
end;

procedure TFastock.Edit1Exit(Sender: TObject);
var
  Temporal, CodigoIntroducido: string;
begin
  CodigoIntroducido := Trim(Edit1.Text);
  if CodigoIntroducido = '' then Exit;

  dbAStock.Close;
  dbAStock.SQL.Text := 'SELECT * FROM artitien' + Tienda + ' WHERE A0=:codigo';
  dbAStock.ParamByName('codigo').AsString := CodigoIntroducido;
  dbAStock.Open;

  if dbAStock.IsEmpty then
  begin
    dbAStock.Close;
    dbAStock.SQL.Text := 'SELECT EAN0,EAN1 FROM eans WHERE EAN0=:ean';
    dbAStock.ParamByName('ean').AsString := CodigoIntroducido;
    dbAStock.Open;

    Temporal := '';
    if not dbAStock.IsEmpty then
      Temporal := Trim(dbAStock.FieldByName('EAN1').AsString);

    dbAStock.Close;
    dbAStock.SQL.Text := 'SELECT * FROM artitien' + Tienda + ' WHERE A0=:codigo';
    dbAStock.ParamByName('codigo').AsString := Temporal;
    dbAStock.Open;
  end;

  if dbAStock.IsEmpty then Exit;

  { Normaliza siempre el campo al código principal A0. De este modo,
    la consulta del historial funciona igual al introducir código o EAN. }
  Edit1.Text := dbAStock.FieldByName('A0').AsString;
  Edit2.Text := dbAStock.FieldByName('A1').AsString;
  Edit3.Text := dbAStock.FieldByName('A4').AsString;
  Edit4.Text := dbAStock.FieldByName('A5').AsString;
  Edit5.Text := dbAStock.FieldByName('A6').AsString;
end;

procedure TFastock.BitBtn1Click(Sender: TObject);
begin
  dbHiststock.Append;
  dbHiststock.FieldByName('fecha').AsDateTime:=Date;
  dbHiststock.FieldByName('hora').AsDateTime:=Time;
  dbHiststock.FieldByName('codigo').AsString:=dbAStock.FieldByName('A0').AsString;
  dbHiststock.FieldByName('puesto').AsString:=Puesto;
  dbHiststock.FieldByName('descripcion').AsString:=dbAStock.FieldByName('A1').AsString;
  dbHiststock.FieldByName('stock').AsString:=dbAStock.FieldByName('A4').AsString;
  dbHiststock.FieldByName('stockmin').AsString:=dbAStock.FieldByName('A5').AsString;
  dbHiststock.FieldByName('stockmax').AsString:=dbAStock.FieldByName('A6').AsString;
  dbHiststock.FieldByName('newstock').AsString:=Edit3.Text;
  dbHiststock.FieldByName('newmin').AsString:=Edit4.Text;
  dbHiststock.FieldByName('newmax').AsString:=Edit5.Text;
  dbHiststock.FieldByName('motivo').AsString:=Edit6.Text;
  dbHiststock.Post;
  dbAstock.Edit;
  dbAStock.FieldByName('A1').AsString:=Edit2.Text;//---------------- Descripción
  dbAStock.FieldByName('A4').AsString:=Edit3.Text;//---------------- Stock Actual (Nuevo)
  dbAStock.FieldByName('A5').AsString:=Edit4.Text;//---------------- Stock Minimo (Nuevo)
  dbAStock.FieldByName('A6').AsString:=Edit5.Text;//---------------- Stock Maximo (Nuevo)
  dbAStock.Post;
  ShowMessage('CAMBIOS ALMACENADOS CORRECTAMENTE');
  Limpiar();
  Edit1.SetFocus;
end;

function TFastock.CodigoFiltroHistorial: string;
begin
  { Regla principal: sin texto en Código/EAN no se aplica ningún filtro,
    aunque dbAStock conserve internamente el último artículo consultado. }
  Result := Trim(Edit1.Text);
  if Result = '' then Exit;

  { Edit1Exit normaliza el EAN a A0. Esta comprobación adicional mantiene
    el filtro correcto si el control todavía no ha perdido el foco. }
  if dbAStock.Active and (not dbAStock.IsEmpty) then
    Result := Trim(dbAStock.FieldByName('A0').AsString);
end;

procedure TFastock.CargarHistorial(const ACampoOrden, ASentido: string);
var
  CodigoFiltro, CampoOrden, Sentido: string;
begin
  CodigoFiltro := CodigoFiltroHistorial;
  CampoOrden := Trim(ACampoOrden);
  Sentido := UpperCase(Trim(ASentido));

  if (Sentido <> 'ASC') and (Sentido <> 'DESC') then
    Sentido := 'DESC';

  dbHiststock.Close;
  dbHiststock.SQL.Clear;
  dbHiststock.SQL.Add('SELECT * FROM histstock' + Tienda);

  if CodigoFiltro <> '' then
  begin
    dbHiststock.SQL.Add('WHERE codigo=:codigo');
    dbHiststock.ParamByName('codigo').AsString := CodigoFiltro;
  end;

  if CampoOrden <> '' then
    dbHiststock.SQL.Add('ORDER BY ' + CampoOrden + ' ' + Sentido)
  else
    dbHiststock.SQL.Add('ORDER BY fecha DESC, hora DESC');

  dbHiststock.Open;
  DBGrid1.Refresh;
end;

procedure TFastock.BitBtn2Click(Sender: TObject);
begin
  DBGrid1.Visible := not DBGrid1.Visible;
  LabelHistorialVacio.Visible := not DBGrid1.Visible;

  if DBGrid1.Visible then
  begin
    BitBtn2.Caption := 'Ocultar historial';
    { Con Código/EAN vacío se cargan TODOS los registros. }
    CargarHistorial('', '');
  end
  else
    BitBtn2.Caption := 'Ver historial';
end;

procedure TFastock.DBGrid1TitleClick(Column: TColumn);
var
  Campo, SentidoAplicado: string;
begin
  if (Column = nil) or (Trim(Column.FieldName) = '') then Exit;

  Campo := Column.FieldName;

  { Una columna nueva comienza en ascendente. Pulsaciones sucesivas sobre
    la misma cabecera alternan ASC/DESC. }
  if not SameText(sCampoOrden, Campo) then
  begin
    sCampoOrden := Campo;
    sOrden := 'ASC';
  end;

  SentidoAplicado := sOrden;
  DBGrid1.Enabled := False;
  try
    CargarHistorial(Campo, SentidoAplicado);
    if sOrden = 'ASC' then
      sOrden := 'DESC'
    else
      sOrden := 'ASC';
  finally
    DBGrid1.Enabled := True;
  end;
end;

//================== INSERCION SOLO DE NUMEROS JUNTO A CONTROL TECLAS PULSADAS  ====================
function TFastock.compruebatecla(key:char):char;
begin
      // -- Solo permite la insercion de numeros y la pulsacion de enter o teclas especiales -------
      if ( StrScan('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',Key) <> nil ) or ( Key = Char(VK_BACK) )
           or  ( Key = Char(VK_TAB) )  or  ( Key = Char(VK_RETURN) ) or  ( Key = Char(VK_UP) )
           or  ( Key = Char(VK_DOWN) ) then
      else
          begin
               Key := #0;
          end;
      if ( key = Char(VK_RETURN) ) then // -- En caso de pulsar enter, pasa al siguiente campo
         begin
              key:=#0;
              SelectNext(activecontrol,true,true);
         end;
      if ( key = Char(VK_UP) ) then // -- Si pulsamos la flecha arriba, vuelve al campo anterior
         begin
              key:=#0;
              SelectNext(activecontrol,false,true);
         end;
      if ( key = Char(VK_DOWN) ) then // -- Si pulsamos la flecha abajo, pasa al campo siguiente
         begin
              key:=#0;
              SelectNext(activecontrol,true,true);
         end;
      compruebatecla:=(key);
end;

procedure TFastock.LImpiar();
Begin
     Edit1.Text:='';Edit2.Text:='';Edit3.Text:='';Edit4.Text:='';Edit5.Text:='';Edit6.Text:='';
     Edit1.SetFocus;
end;

//==================== CERRAR ======================
procedure TFastock.BitBtn3Click(Sender: TObject);
Begin
  BitBtn2.Click;
  dbAStock.Active:=False;
  Close();
End;

initialization
  {$I fastock.lrs}

end.

