{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2010,  Nicolas Lopez de Lerma Aymerich

  PuntoDev GNU S.L. <info@puntodev.com>

  Collaborators:
                 F.Javier Pérez Vidal
                 Jaime Alvarez Ares.

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
unit promociones;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, DBGrids, Buttons, ZConnection, ZDataset,
  LCLType;

type

  { TfPromociones }

  TfPromociones = class(TForm)
    btnActualizar: TBitBtn;
    btnBuscar: TBitBtn;
    btnCancelar: TBitBtn;
    btnAceptar: TBitBtn;
    btnCrear: TBitBtn;
    btnBorrar: TBitBtn;
    btnModificar: TBitBtn;
    btnCerrar: TBitBtn;
    dsPromo: TDatasource;
    dbgDatos: TDBGrid;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    rgFiltro: TRadioGroup;
    dbPromo: TZQuery;
    dbArti: TZQuery;
    dbTrabajo: TZQuery;
    procedure ActualizarPromociones;
    procedure btnActualizarClick(Sender: TObject);
    procedure btnAceptarClick(Sender: TObject);
    procedure btnBorrarClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnCerrarClick(Sender: TObject);
    procedure btnCrearClick(Sender: TObject);
    procedure btnModificarClick(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure rgFiltroClick(Sender: TObject);
    procedure ActivarPanel;
    procedure DesactivarPanel;
    procedure LimpiaPanel();
    procedure LlenaReg();
    procedure Relleno();
  private
    { private declarations }
    Operacion: char;        //   A = Alta / M = Modificación
    chkSegundaUnd50: TCheckBox;
    lblInfoSegundaUnd: TLabel;
    FOldPromoArt: string;
    FOldPromoIni: string;
    FOldPromoFin: string;
    FOldPromoWasSegunda: Boolean;
    function ResolverCodigoArticulo(const ACodigo: string): string;
    procedure PromoModeChanged(Sender: TObject);
    procedure EnsurePromoRulesTable;
    function HasSegundaUnidadRule(const AArticulo, AIniDB, AFinDB: string): Boolean;
    procedure DeleteSegundaUnidadRule(const AArticulo, AIniDB, AFinDB: string);
    procedure SaveSegundaUnidadRule(const AArticulo, ADescripcion, AIniDB, AFinDB: string);
  public
    { public declarations }
  end; 

procedure ShowFormPromociones;

var
  fPromociones: TfPromociones;

implementation

uses
  global, funciones, busquedas;

  
function TfPromociones.ResolverCodigoArticulo(const ACodigo: string): string;
var
  Q: TZQuery;
  C: string;
begin
  C := Trim(ACodigo);
  Result := C;
  if C = '' then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := dbPromo.Connection;

    try
      Q.SQL.Text := 'SELECT A0 FROM artitien' + Tienda + ' WHERE A0=:c LIMIT 1';
      Q.ParamByName('c').AsString := C;
      Q.Open;
      if not Q.EOF then Exit(C);
    except
      Q.Close;
    end;

    Q.Close;

    try
      Q.SQL.Text := 'SELECT EAN1 FROM eans WHERE EAN0=:c LIMIT 1';
      Q.ParamByName('c').AsString := C;
      Q.Open;
      if not Q.EOF then
        Result := Trim(Q.FieldByName('EAN1').AsString)
      else
        Result := C;
    except
      Result := C;
    end;
  finally
    Q.Free;
  end;
end;

procedure TfPromociones.PromoModeChanged(Sender: TObject);
begin
  if chkSegundaUnd50=nil then Exit;

  // La promoción de 2ª unidad NO debe bloquear el precio de oferta.
  // Caso real: PVP normal 4,00 -> PVP oferta 3,50 y además 2ª unidad al 50%.
  // Por eso dejamos Edit4/Edit5/Edit6 editables siempre. Si están vacíos,
  // usamos como propuesta los valores actuales, pero sin impedir cambiarlos.
  Edit4.Enabled := True;
  Edit5.Enabled := True;
  Edit6.Enabled := True;

  if chkSegundaUnd50.Checked then
  begin
    if Trim(Edit4.Text) = '' then Edit4.Text := Edit8.Text;
    if Trim(Edit5.Text) = '' then Edit5.Text := Edit9.Text;
    if Trim(Edit6.Text) = '' then Edit6.Text := Edit10.Text;
    if lblInfoSegundaUnd<>nil then
      lblInfoSegundaUnd.Visible := True;
  end
  else
  begin
    if lblInfoSegundaUnd<>nil then
      lblInfoSegundaUnd.Visible := False;
  end;
end;

procedure TfPromociones.EnsurePromoRulesTable;
begin
  dbTrabajo.Active := False;
  dbTrabajo.SQL.Clear;
  dbTrabajo.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS promo_rules' + Tienda + ' ('+
    ' id int(11) NOT NULL AUTO_INCREMENT,'+
    ' activo char(1) NOT NULL DEFAULT ''S'','+
    ' prioridad int(11) NOT NULL DEFAULT 0,'+
    ' tipo char(20) NOT NULL DEFAULT ''PRECIO_FIJO'','+
    ' inicio_dt datetime DEFAULT NULL,'+
    ' fin_dt datetime DEFAULT NULL,'+
    ' articulo char(13) DEFAULT '''','+
    ' familia int(11) DEFAULT -1,'+
    ' cliente char(13) DEFAULT '''','+
    ' descripcion char(80) NOT NULL DEFAULT '''','+
    ' texto_ticket char(60) NOT NULL DEFAULT '''','+
    ' precio_fijo double(10,3) NOT NULL DEFAULT 0.000,'+
    ' dto_pct double(5,2) NOT NULL DEFAULT 0.00,'+
    ' n int(11) NOT NULL DEFAULT 0,'+
    ' m int(11) NOT NULL DEFAULT 0,'+
    ' seg_pct double(5,2) NOT NULL DEFAULT 0.00,'+
    ' pack_code char(20) NOT NULL DEFAULT '''','+
    ' created_at datetime DEFAULT CURRENT_TIMESTAMP,'+
    ' updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,'+
    ' PRIMARY KEY (id),'+
    ' KEY k_activo_rango (activo,inicio_dt,fin_dt),'+
    ' KEY k_articulo_rango (articulo,activo,inicio_dt,fin_dt),'+
    ' KEY k_tipo_prio (tipo,prioridad)'+
    ') ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci';
  try
    dbTrabajo.ExecSQL;
  except
  end;
end;

function TfPromociones.HasSegundaUnidadRule(const AArticulo, AIniDB, AFinDB: string): Boolean;
begin
  Result := False;
  EnsurePromoRulesTable;
  dbTrabajo.Active := False;
  dbTrabajo.SQL.Clear;
  dbTrabajo.SQL.Text :=
    'SELECT id FROM promo_rules' + Tienda + ' ' +
    'WHERE activo=''S'' ' +
    '  AND tipo=''SEGUNDA_UND_PCT'' ' +
    '  AND articulo="' + AArticulo + '" ' +
    '  AND DATE(inicio_dt)="' + AIniDB + '" ' +
    '  AND DATE(fin_dt)="' + AFinDB + '" ' +
    'LIMIT 1';
  try
    dbTrabajo.Active := True;
    Result := dbTrabajo.RecordCount <> 0;
  except
    Result := False;
  end;
end;

procedure TfPromociones.DeleteSegundaUnidadRule(const AArticulo, AIniDB, AFinDB: string);
begin
  if Trim(AArticulo)='' then Exit;
  EnsurePromoRulesTable;
  dbTrabajo.Active := False;
  dbTrabajo.SQL.Clear;
  dbTrabajo.SQL.Text :=
    'DELETE FROM promo_rules' + Tienda + ' ' +
    'WHERE tipo=''SEGUNDA_UND_PCT'' ' +
    '  AND articulo="' + AArticulo + '" ' +
    '  AND DATE(inicio_dt)="' + AIniDB + '" ' +
    '  AND DATE(fin_dt)="' + AFinDB + '"';
  try
    dbTrabajo.ExecSQL;
    if Assigned(dbTrabajo.Connection) then
      dbTrabajo.Connection.Commit;
  except
  end;
end;

procedure TfPromociones.SaveSegundaUnidadRule(const AArticulo, ADescripcion, AIniDB, AFinDB: string);
var
  DescEsc: string;
begin
  if Trim(AArticulo)='' then Exit;
  EnsurePromoRulesTable;
  DeleteSegundaUnidadRule(AArticulo, AIniDB, AFinDB);

  DescEsc := StringReplace(ADescripcion, '"', '\"', [rfReplaceAll]);

  dbTrabajo.Active := False;
  dbTrabajo.SQL.Clear;
  dbTrabajo.SQL.Text :=
    'INSERT INTO promo_rules' + Tienda +
    ' (activo, prioridad, tipo, articulo, inicio_dt, fin_dt, seg_pct, descripcion, texto_ticket) VALUES (' +
    ' ''S'', 100, ''SEGUNDA_UND_PCT'', ' +
    ' "' + AArticulo + '", ' +
    ' "' + AIniDB + ' 00:00:00", ' +
    ' "' + AFinDB + ' 23:59:59", ' +
    ' 50, ' +
    ' "' + DescEsc + '", ' +
    ' ''2ª UND 50%'' )';
  try
    dbTrabajo.ExecSQL;
    if Assigned(dbTrabajo.Connection) then
      dbTrabajo.Connection.Commit;
  except
  end;
end;



//==========================================================================
// Helpers de fechas para promociones
// - La tabla promoXXXX históricamente guarda P5/P6 como texto (a veces DD/MM/YYYY,
//   otras DD-MM-YYYY o YYYY-MM-DD).  Esto hacía que las comparaciones por string
//   fallasen "a veces".
// - Con estas funciones comparamos SIEMPRE como fecha real.
//==========================================================================
function TryPromoStrToDate(const S: string; out D: TDateTime): Boolean;
var
  FS: TFormatSettings;
  Y, M, Day: Integer;
  T: string;
begin
  Result := False;
  D := 0;
  T := Trim(S);
  if T = '' then Exit;

  // 1) Intento con formato regional
  FS := DefaultFormatSettings;
  if TryStrToDate(T, D, FS) then Exit(True);

  // 2) Intento explícito DD/MM/YYYY
  FS.DateSeparator := '/';
  FS.ShortDateFormat := 'dd/mm/yyyy';
  if TryStrToDate(T, D, FS) then Exit(True);

  // 3) Intento explícito DD-MM-YYYY
  FS.DateSeparator := '-';
  FS.ShortDateFormat := 'dd-mm-yyyy';
  if TryStrToDate(T, D, FS) then Exit(True);

  // 4) Intento ISO YYYY-MM-DD (manual)
  if (Length(T) >= 10) and (T[5] = '-') and (T[8] = '-') then
  begin
    try
      Y := StrToInt(Copy(T, 1, 4));
      M := StrToInt(Copy(T, 6, 2));
      Day := StrToInt(Copy(T, 9, 2));
      D := EncodeDate(Y, M, Day);
      Exit(True);
    except
      Exit(False);
    end;
  end;
end;

function PromoDateToDB(const D: TDateTime): string;
begin
  // ISO estable para comparar y ordenar en SQL aunque sea campo texto
  Result := FormatDateTime('yyyy-mm-dd', D);
end;

function PromoStrToDB(const S: string): string;
var
  D: TDateTime;
begin
  if TryPromoStrToDate(S, D) then
    Result := PromoDateToDB(D)
  else
    Result := Trim(S);
end;

function PromoStrToUI(const S: string): string;
var
  D: TDateTime;
begin
  if TryPromoStrToDate(S, D) then
    Result := FormatDateTime('dd/mm/yyyy', D)
  else
    Result := Trim(S);
end;

//=============== Crea el formulario ================
procedure ShowFormPromociones;
begin
  with TFPromociones.Create(Application) do
    begin
       ShowModal;
    end;
end;

//======== Procesa las Promociones para actualizar Artículos ======

procedure TfPromociones.ActualizarPromociones;
begin
  // MODO PRO / SEGURO
  // No modificamos artitienXXXX.
  // Solo marcamos promociones caducadas.

  dbTrabajo.Active := False;
  dbTrabajo.SQL.Clear;
  dbTrabajo.SQL.Text :=
    'UPDATE promo' + Tienda +
    ' SET P10=''F'' ' +
    ' WHERE (P10=''A'' OR P10 IS NULL OR P10='''') ' +
    ' AND P6 < CURDATE()';

  dbTrabajo.ExecSQL;

  try
    if Assigned(dbTrabajo.Connection) then
      dbTrabajo.Connection.Commit;
  except
  end;

  rgFiltroClick(Self);
end;

procedure TfPromociones.btnActualizarClick(Sender: TObject);
begin
  ActualizarPromociones;
  rgFiltroClick(Self);
end;

{ TfPromociones }

// Procedimientos para Activación y Desactivación del Panel
procedure TfPromociones.ActivarPanel;
begin
  rgFiltro.Enabled:=False;
  dbgDatos.Enabled:=False;
  btnCrear.Enabled:=False;
  btnBorrar.Enabled:=False;
  btnModificar.Enabled:=False;
  btnCerrar.Enabled:=False;
  btnActualizar.Enabled:=False;
  Panel1.Visible:=True;
end;
procedure TfPromociones.DesactivarPanel;
begin
  Panel1.Visible:=False;
  rgFiltro.Enabled:=True;
  dbgDatos.Enabled:=True;
  btnCrear.Enabled:=True;
  btnBorrar.Enabled:=True;
  btnModificar.Enabled:=True;
  btnCerrar.Enabled:=True;
  btnActualizar.Enabled:=True;
end;

procedure TfPromociones.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  // Forzamos commit por si hay cambios pendientes y para que Ventas los vea sin reiniciar
try
  if Assigned(dbPromo.Connection) then
    dbPromo.Connection.Commit;
except
end;

Closeaction:=CaFree;
end;

procedure TfPromociones.FormCreate(Sender: TObject);
begin
  //----------------- CONEXION -----------------
  //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Tablas ------------------
  dbPromo.SQL.Text:='SELECT * FROM promo'+Tienda+' WHERE P10=''A'' ORDER BY P0';
  dbPromo.Active := True;
  dbArti.Sql.Text:='SELECT * FROM artitien'+Tienda+' ORDER BY A0';
  dbArti.Active := True;

  FOldPromoArt := '';
  FOldPromoIni := '';
  FOldPromoFin := '';
  FOldPromoWasSegunda := False;

  chkSegundaUnd50 := TCheckBox.Create(Self);
  chkSegundaUnd50.Parent := Panel1;
  chkSegundaUnd50.Caption := '2ª unidad al 50%';
  chkSegundaUnd50.Left := Edit7.Left;
  chkSegundaUnd50.Top := Edit10.Top + Edit10.Height + 8;
  chkSegundaUnd50.Width := 160;
  chkSegundaUnd50.OnClick := @PromoModeChanged;

  lblInfoSegundaUnd := TLabel.Create(Self);
  lblInfoSegundaUnd.Parent := Panel1;
  lblInfoSegundaUnd.Caption := 'Se aplica al totalizar sobre el PVP de oferta indicado.';
  lblInfoSegundaUnd.Left := chkSegundaUnd50.Left + 18;
  lblInfoSegundaUnd.Top := chkSegundaUnd50.Top + 20;
  lblInfoSegundaUnd.Font.Style := [fsItalic];
  lblInfoSegundaUnd.Visible := False;

  EnsurePromoRulesTable;
end;

procedure TfPromociones.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key=VK_ESCAPE) and (Panel1.Visible=False)) then begin; key:=0; btnCerrarClick(Sender); exit; end;
  if ((Key=VK_ESCAPE) and (Panel1.Visible=True)) then begin; key:=0; btnCancelarClick(Sender); exit ; end;
  if (key=VK_F8) and ( Panel1.Visible=True) then begin; key:=0; btnAceptarClick(self); exit; end;
  if (key=VK_F3) and ( Panel1.Visible=False) then begin; key:=0; btnBorrarClick(self); exit; end;
  if (key=VK_F2) and ( Panel1.Visible=False) then begin; key:=0; btnCrearClick(self); exit; end;
end;

procedure TfPromociones.rgFiltroClick(Sender: TObject);
begin
  dbPromo.Active:=False;
  dbPromo.SQL.Clear;
  case rgFiltro.ItemIndex of
       0: dbPromo.SQL.Add('SELECT * FROM promo'+Tienda+' WHERE P10=''A'' ORDER BY P0');
       1: dbPromo.SQL.Add('SELECT * FROM promo'+Tienda+' WHERE P10=''F'' ORDER BY P0');
       2: dbPromo.SQL.Add('SELECT * FROM promo'+Tienda+' ORDER BY P0');
  end;
  dbPromo.Active:=True;
end;

procedure TfPromociones.btnCerrarClick(Sender: TObject);
begin
  dbPromo.Active:=False;
  dbArti.Active:=False;
  Self.Close;
end;

procedure TfPromociones.btnAceptarClick(Sender: TObject);
var
  ArticuloRegla, IniDB, FinDB: string;
  IsSamePromoBeingModified: Boolean;
begin
  ArticuloRegla := ResolverCodigoArticulo(Edit1.Text);
  if ArticuloRegla <> '' then Edit1.Text := ArticuloRegla;

  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM promo'+Tienda+' WHERE '+
                      'P0="'+Edit1.Text+'" and '+
                      'P1="'+Edit2.Text+'" and '+
                      'P5="'+PromoStrToDB(Edit3.Text)+'" and '+
                      'P6="'+PromoStrToDB(Edit7.Text)+'"';
  dbTrabajo.Active:=True;

  IniDB := PromoStrToDB(Edit3.Text);
  FinDB := PromoStrToDB(Edit7.Text);

  IsSamePromoBeingModified :=
    (Operacion='M') and
    (Trim(Edit1.Text)=Trim(FOldPromoArt)) and
    (IniDB=FOldPromoIni) and
    (FinDB=FOldPromoFin);

  if dbTrabajo.RecordCount<>0 then
   begin
    // En modificación, la búsqueda de duplicados encuentra la propia promoción.
    // Antes eso hacía que solo se reactivara y saliera sin guardar cambios.
    // Si es la misma promoción seleccionada, dejamos continuar con dbPromo.Edit.
    if not IsSamePromoBeingModified then
    begin
      showmessage(' Ya existe esa promoción, REACTIVANDO ... ' );
      dbTrabajo.Edit;
      dbTrabajo.FieldByName('P10').AsString:='A';
      dbTrabajo.Post;

      try
        if Assigned(dbTrabajo.Connection) then
          dbTrabajo.Connection.Commit;
      except
      end;

      if chkSegundaUnd50.Checked then
        SaveSegundaUnidadRule(Edit1.Text, Edit2.Text, IniDB, FinDB)
      else
        DeleteSegundaUnidadRule(Edit1.Text, IniDB, FinDB);

      Exit
    end;
   end;

  if (Operacion='M') and FOldPromoWasSegunda then
    DeleteSegundaUnidadRule(FOldPromoArt, FOldPromoIni, FOldPromoFin);

  if Operacion='A' then
     dbPromo.Append
  else
     dbPromo.Edit;
  LlenaReg();
  dbPromo.Post;

  try
    if Assigned(dbPromo.Connection) then
      dbPromo.Connection.Commit;
  except
  end;

  if chkSegundaUnd50.Checked then
    SaveSegundaUnidadRule(Edit1.Text, Edit2.Text, IniDB, FinDB)
  else if Operacion='M' then
    DeleteSegundaUnidadRule(Edit1.Text, IniDB, FinDB);

  dbgDatos.Refresh;
  Operacion:='A';
  FOldPromoArt := '';
  FOldPromoIni := '';
  FOldPromoFin := '';
  FOldPromoWasSegunda := False;
  LimpiaPanel();
  Edit1.SetFocus;
end;

procedure TfPromociones.btnBorrarClick(Sender: TObject);
var
  Art, IniDB, FinDB: string;
begin
  if dbPromo.RecordCount=0 then exit;
  if Application.MessageBox('¿DESEA BORRAR LA PROMOCION SELECCIONADA?',
     'FacturLinEx',
     MB_ICONQUESTION + MB_YESNO) = idYes then
  begin
    Art := dbPromo.FieldByName('P0').AsString;
    IniDB := PromoStrToDB(dbPromo.FieldByName('P5').AsString);
    FinDB := PromoStrToDB(dbPromo.FieldByName('P6').AsString);
    DeleteSegundaUnidadRule(Art, IniDB, FinDB);
    dbPromo.Delete;
  end;
end;

procedure TfPromociones.btnBuscarClick(Sender: TObject);
begin
  Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT A0, A1 FROM artitien'+Tienda+
                  ' WHERE A1 LIKE "%'+Edit2.Text+'%"', ['Código','Referencia'],'A0');
  if Edit1.Text='-1' then begin
     Edit1.Text:='';
     LimpiaPanel();
     Edit1.SetFocus;
  end else begin
      Edit1Exit(Edit1);
      Edit3.SetFocus;
  end;
end;

procedure TfPromociones.btnCancelarClick(Sender: TObject);
begin
  DesactivarPanel;
  Operacion:=' ';
end;

procedure TfPromociones.btnCrearClick(Sender: TObject);
begin
  Operacion:='A';
  FOldPromoArt := '';
  FOldPromoIni := '';
  FOldPromoFin := '';
  FOldPromoWasSegunda := False;
  LimpiaPanel();
  if chkSegundaUnd50<>nil then
    chkSegundaUnd50.Checked := False;
  PromoModeChanged(nil);
  ActivarPanel;
  Edit1.SetFocus;
end;

procedure TfPromociones.btnModificarClick(Sender: TObject);
begin
  if dbPromo.RecordCount=0 then exit;
  Operacion:='M';
  FOldPromoArt := dbPromo.FieldByName('P0').AsString;
  FOldPromoIni := PromoStrToDB(dbPromo.FieldByName('P5').AsString);
  FOldPromoFin := PromoStrToDB(dbPromo.FieldByName('P6').AsString);
  FOldPromoWasSegunda := HasSegundaUnidadRule(FOldPromoArt, FOldPromoIni, FOldPromoFin);
  Relleno();
  ActivarPanel;
  Edit1.SetFocus;
end;

procedure TfPromociones.Edit1Exit(Sender: TObject);
var
  CodReal: string;
begin
  if Edit1.Text='' then exit;
  if Edit3.Text<>Edit7.Text then exit;
  CodReal := ResolverCodigoArticulo(Edit1.Text);
  if CodReal <> '' then
    Edit1.Text := CodReal;

  if dbArti.Locate('A0', Edit1.Text, []) then begin
     Edit2.Text:=dbArti.FieldByName('A1').AsString;
     Edit3.Text:=FormatDateTime('DD/MM/YYYY',Date);
     Edit4.Text:=dbArti.FieldByName('A2').AsString;
     Edit5.Text:=dbArti.FieldByName('A24').AsString;
     Edit6.Text:=dbArti.FieldByName('A3').AsString;
     Edit7.Text:=FormatDateTime('DD/MM/YYYY',Date);
     Edit8.Text:=dbArti.FieldByName('A2').AsString;
     Edit9.Text:=dbArti.FieldByName('A24').AsString;
     Edit10.Text:=dbArti.FieldByName('A3').AsString;
     PromoModeChanged(nil);
     Edit3.SetFocus;
  end else begin
     ShowMessage('ARTICULO NO ENCONTRADO');
     Edit1.SetFocus;
  end;
end;

procedure TfPromociones.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then btnBuscarClick(Sender);
end;

procedure TfPromociones.LimpiaPanel();
begin
  Edit1.Text:='';   Edit2.Text:='';   Edit3.Text:='';
  Edit4.Text:='';   Edit5.Text:='';   Edit6.Text:='';
  Edit7.Text:='';   Edit8.Text:='';   Edit9.Text:='';
  Edit10.Text:='';
  if chkSegundaUnd50<>nil then
    chkSegundaUnd50.Checked := False;
  PromoModeChanged(nil);
end;

procedure TfPromociones.LlenaReg();
var
  D: TDateTime;
begin
  dbPromo.FieldByName('P0').AsString:=Edit1.Text;  //------ Codigo Articulo
  dbPromo.FieldByName('P1').AsString:=Edit2.Text;  //------ Descripcion
  dbPromo.FieldByName('P2').AsString:=Edit8.Text;  //------ PVP actual (para cuando acabe la oferta)
  dbPromo.FieldByName('P3').AsString:=Edit9.Text;  //------ PV Coste actual (para cuando se acabe la oferta)
  dbPromo.FieldByName('P4').AsString:=Edit10.Text; //------ IVA actual (para cuando se acabe la oferta)
  D := StrToDate(Edit3.Text);
  dbPromo.FieldByName('P5').AsDateTime:=Trunc(D);  //------ Fecha Inicio Oferta
  D := StrToDate(Edit7.Text);
  dbPromo.FieldByName('P6').AsDateTime:=Trunc(D);  //------ Fecha Fin Oferta
  // Aunque exista regla de 2ª unidad al 50%, mantenemos el PVP/coste/IVA
  // de oferta indicados por el usuario. Así se permite promoción doble:
  // precio rebajado + segunda unidad calculada sobre ese precio rebajado.
  dbPromo.FieldByName('P7').AsString:=Edit4.Text;  //------ PVP Oferta
  dbPromo.FieldByName('P8').AsString:=Edit5.Text;  //------ PV Coste Oferta
  dbPromo.FieldByName('P9').AsString:=Edit6.Text;  //------ IVA Oferta
  dbPromo.FieldByName('P10').AsString:='A';        //------ Inicialmente la Oferta está (A)ctiva

end;

procedure TfPromociones.Relleno();
var
  IniDB, FinDB: string;
begin
  if dbPromo.RecordCount=0 then exit;
  Edit1.Text:=dbPromo.FieldByName('P0').AsString;  //------ Codigo Articulo
  Edit2.Text:=dbPromo.FieldByName('P1').AsString;  //------ Descripcion
  Edit8.Text:=dbPromo.FieldByName('P2').AsString;  //------ PVP actual (para cuando acabe la oferta)
  Edit9.Text:=dbPromo.FieldByName('P3').AsString;  //------ PV Coste actual (para cuando se acabe la oferta)
  Edit10.Text:=dbPromo.FieldByName('P4').AsString; //------ IVA actual (para cuando se acabe la oferta)
  Edit3.Text:=PromoStrToUI(dbPromo.FieldByName('P5').AsString);  //------ Fecha Inicio Oferta
  Edit7.Text:=PromoStrToUI(dbPromo.FieldByName('P6').AsString);  //------ Fecha Fin Oferta
  Edit4.Text:=dbPromo.FieldByName('P7').AsString;  //------ PVP Oferta
  Edit5.Text:=dbPromo.FieldByName('P8').AsString;  //------ PV Coste Oferta
  Edit6.Text:=dbPromo.FieldByName('P9').AsString;  //------ IVA Oferta

  IniDB := PromoStrToDB(dbPromo.FieldByName('P5').AsString);
  FinDB := PromoStrToDB(dbPromo.FieldByName('P6').AsString);
  if chkSegundaUnd50<>nil then
    chkSegundaUnd50.Checked := HasSegundaUnidadRule(Edit1.Text, IniDB, FinDB);
  PromoModeChanged(nil);
end;

initialization
  {$I promociones.lrs}

end.
