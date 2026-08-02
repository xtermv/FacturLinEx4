{
  Gestion LinEx FacturLinEx 2.0

  Copyright (C) 2000-2010,  Nicolas Lopez de Lerma Aymerich

  PuntoDev <info@puntodev.com>

  Collaborators:
                 Antonio Domínguez Santos (adslinex)
                 Xaime Alvarez Ares
                 Elmo Calatayud Chumbes
                 Fco. Javier Perez Vidal
                 José Belenguer
                 Eduardo Maldonado

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

unit roles;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Buttons, ComCtrls, DB, ZConnection, ZDataset, LCLType
  {$IFDEF LCLGTK2}
  , gtk2, gdk2
  {$ENDIF};

type

  { TFRoles }

  TFRoles = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    CheckGroup1: TCheckGroup;
    CheckGroup10: TCheckGroup;
    CheckGroup11: TCheckGroup;
    CheckGroup12: TCheckGroup;
    CheckGroup13: TCheckGroup;
    CheckGroup2: TCheckGroup;
    CheckGroup3: TCheckGroup;
    CheckGroup4: TCheckGroup;
    CheckGroup5: TCheckGroup;
    CheckGroup6: TCheckGroup;
    CheckGroup7: TCheckGroup;
    CheckGroup8: TCheckGroup;
    CheckGroup9: TCheckGroup;
    dbRoles: TZQuery;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LabelAyudaPermisos: TLabel;
    LabelSubtitulo: TLabel;
    LabelTitulo: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    PanelCabecera: TPanel;
    PanelDatosRol: TPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    BtnR1: TToggleBox;
    BtnR2: TToggleBox;
    BtnR3: TToggleBox;
    BtnR4: TToggleBox;
    BtnR5: TToggleBox;
    BtnR6: TToggleBox;
    BtnR7: TToggleBox;
    BtnR8: TToggleBox;
    BtnR9: TToggleBox;
    BtnR10: TToggleBox;
    BtnR11: TToggleBox;
    BtnR12: TToggleBox;
    BtnR13: TToggleBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BtnR10Change(Sender: TObject);
    procedure BtnR11Change(Sender: TObject);
    procedure BtnR12Change(Sender: TObject);
    procedure BtnR13Change(Sender: TObject);
    procedure BtnR1Change(Sender: TObject);
    procedure BtnR2Change(Sender: TObject);
    procedure BtnR3Change(Sender: TObject);
    procedure BtnR4Change(Sender: TObject);
    procedure BtnR5Change(Sender: TObject);
    procedure BtnR6Change(Sender: TObject);
    procedure BtnR7Change(Sender: TObject);
    procedure BtnR8Change(Sender: TObject);
    procedure BtnR9Change(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Llenareg;
    procedure LimpiaForm;
    procedure Relleno;
  private
    FActualizando: Boolean;
    FCambiosPendientes: Boolean;
    FHayRegistroCargado: Boolean;
    FClaveCargada: string;
    FGruposExtra: array of TCheckGroup;
    FBotonesTodosExtra: array of TToggleBox;
    FScrollExtra: array[2..5] of TScrollBox;
    FTablaPermisosExtraDisponible: Boolean;
    procedure AplicarContrasteSeleccion(AControl: TWinControl);
    procedure AplicarContrasteSeleccionControles(AParent: TWinControl);
    procedure AplicarDisposicionPermisos;
    procedure AplicarDisposicionPermisosExtra;
    procedure AplicarEstiloGrupos;
    procedure AplicarEstiloModerno;
    procedure AsegurarTablaPermisosExtra;
    procedure ActualizarBotonTodos(AIndice: Integer);
    procedure ActualizarEstado;
    procedure ActualizarTodosLosBotones;
    procedure AsignarEventosCambio;
    procedure CambiarTodos(AIndice: Integer; AValor: Boolean);
    procedure CambiarTodosExtra(AIndice: Integer; AValor: Boolean);
    procedure CargarPermisosExtra(const ACodigoRol: string);
    function CampoRol(AIndice: Integer): string;
    procedure CrearPestanasAmpliadas;
    procedure EliminarPermisosExtra(const ACodigoRol: string);
    procedure ExtraPermisoChange(Sender: TObject);
    procedure ExtraTodosChange(Sender: TObject);
    procedure GuardarPermisosExtra(const ACodigoRol: string);
    function ConfirmarDescartarCambios: Boolean;
    procedure EnfocarCodigo(Data: PtrInt);
    function GrupoPermisos(AIndice: Integer): TCheckGroup;
    procedure LimpiarDatos(AConservarCodigo: Boolean);
    procedure LimpiarPermisosExtra;
    procedure MarcarCambios(Sender: TObject);
    function NombreTablaPermisosExtra: string;
    procedure PermisoChange(Sender: TObject);
    procedure RecargarYLocalizar(const ACodigo: string);
    function ToggleTodos(AIndice: Integer): TToggleBox;
    function ValidarDatos: Boolean;
  public
  end;

procedure ShowFormRoles;

var
  FRoles: TFRoles;

implementation

uses
  Global, Funciones;

const
  CANTIDAD_GRUPOS = 13;
  CAMPOS_ROL: array[1..CANTIDAD_GRUPOS] of string =
    ('Tiendas', 'Usuarios', 'Departa', 'Familias', 'Articulos', 'Clientes',
     'Proveed', 'Formapag', 'Rutas', 'Fabrica', 'Envases', 'Puestos',
     'Produccion');
  TITULOS_ROL: array[1..CANTIDAD_GRUPOS] of string =
    ('Tiendas', 'Usuarios', 'Departamentos', 'Familias', 'Artículos',
     'Clientes', 'Proveedores', 'Formas de pago y cobro', 'Rutas',
     'Fabricantes', 'Envases', 'Puestos', 'Producción');

  CANTIDAD_GRUPOS_EXTRA = 41;
  PESTANA_GRUPO_EXTRA: array[1..CANTIDAD_GRUPOS_EXTRA] of Byte =
    (2,2,2,2,2,2,2,2,2,2,2,2,
     3,3,3,3,3,3,3,3,3,3,
     4,4,4,4,4,4,4,4,4,
     5,5,5,5,5,5,5,5,5,5);
  CLAVE_GRUPO_EXTRA: array[1..CANTIDAD_GRUPOS_EXTRA] of string =
    ('VENTAS_TPV','PRESUPUESTOS','PED_CLIENTES','PED_PROVEED','ENTRADAS',
     'FACT_EMITIDAS','FACT_RECIBIDAS','RECTIFICATIVAS','CREDITOS',
     'PROMOCIONES','TARIFAS','STOCKS',
     'LIST_ARTICULOS','LIST_CLIENTES','LIST_PROVEED','LIST_MAESTROS',
     'INFORMES_IVA','MODELO_347','CAJAS_ARQUEOS','PAGOS_COBROS',
     'DASHBOARD','EXPORTACIONES',
     'HIST_VENTAS','HIST_COMPRAS','HIST_FACT_EMI','HIST_FACT_REC',
     'HIST_PEDIDOS','HIST_PRECIOS','HIST_STOCKS','HIST_CAJA','AUDITORIA',
     'CORREO','IMPORTACIONES','COMUNICACIONES','COPIAS_SEGURIDAD',
     'RESTAURACION','ACTUALIZADOR','VERIFACTU','CONFIGURACION',
     'MANTENIMIENTO','INTELIGENCIA');
  TITULO_GRUPO_EXTRA: array[1..CANTIDAD_GRUPOS_EXTRA] of string =
    ('Ventas / TPV','Presupuestos y proformas','Pedidos de clientes',
     'Pedidos a proveedores','Entradas y compras','Facturas emitidas',
     'Facturas recibidas','Abonos y rectificativas','Créditos de clientes',
     'Promociones','Tarifas y precios','Stocks e inventario',
     'Listados de artículos','Listados de clientes','Listados de proveedores',
     'Listados de maestros','Informes de IVA','Modelo 347','Cajas y arqueos',
     'Pagos y cobros','Dashboard y productividad','Exportaciones PDF / CSV',
     'Histórico de ventas','Histórico de compras','Histórico de facturas emitidas',
     'Histórico de facturas recibidas','Histórico de pedidos',
     'Histórico de precios','Histórico de stocks','Histórico de caja',
     'Auditoría y registros','Envío por correo','Importaciones',
     'Comunicaciones tienda / central','Copias de seguridad',
     'Restauración de copias','Actualizador','VeriFactu',
     'Configuración general','Mantenimiento de BBDD','Inteligencia y análisis');

{ TFRoles }

procedure ShowFormRoles;
begin
  with TFRoles.Create(Application) do
    ShowModal;
end;

procedure TFRoles.FormCreate(Sender: TObject);
begin
  FActualizando := True;
  FCambiosPendientes := False;
  FHayRegistroCargado := False;
  FClaveCargada := '';
  try
    dbRoles.SQL.Text := 'SELECT * FROM roles' + Tienda +
      ' ORDER BY CgoRol ASC';
    dbRoles.Open;
    AplicarEstiloModerno;
    AplicarEstiloGrupos;
    CrearPestanasAmpliadas;
    AsegurarTablaPermisosExtra;
    PageControl1.ActivePage := TabSheet1;
    LimpiarDatos(False);
  finally
    FActualizando := False;
  end;
end;

procedure TFRoles.FormShow(Sender: TObject);
begin
  AplicarEstiloModerno;
  AplicarEstiloGrupos;
  AplicarDisposicionPermisos;
  AplicarDisposicionPermisosExtra;
  AsignarEventosCambio;
  AplicarContrasteSeleccionControles(Self);
  Application.QueueAsyncCall(@EnfocarCodigo, 0);
end;

procedure TFRoles.FormResize(Sender: TObject);
begin
  AplicarDisposicionPermisos;
  AplicarDisposicionPermisosExtra;
end;

procedure TFRoles.EnfocarCodigo(Data: PtrInt);
begin
  if Edit1.CanFocus then
  begin
    Edit1.SetFocus;
    Edit1.SelectAll;
  end;
end;

procedure TFRoles.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := ConfirmarDescartarCambios;
end;

procedure TFRoles.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if dbRoles.Active then
    dbRoles.Close;
  CloseAction := caFree;
end;

procedure TFRoles.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

procedure TFRoles.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

function TFRoles.ValidarDatos: Boolean;
begin
  Edit1.Text := UpperCase(Trim(Edit1.Text));
  Edit2.Text := Trim(Edit2.Text);
  Result := False;

  if Edit1.Text = '' then
  begin
    ShowMessage('Debe indicar el código del rol.');
    if Edit1.CanFocus then Edit1.SetFocus;
    Exit;
  end;

  if Edit2.Text = '' then
  begin
    ShowMessage('Debe indicar la descripción del rol.');
    if Edit2.CanFocus then Edit2.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TFRoles.BitBtn2Click(Sender: TObject);
var
  Codigo: string;
begin
  if not ValidarDatos then Exit;
  Codigo := Edit1.Text;

  if dbRoles.Locate('CgoRol', Codigo, []) then
  begin
    ShowMessage('Ese rol ya existe. Utilice “Guardar cambios” para modificarlo.');
    Relleno;
    Exit;
  end;

  try
    dbRoles.Append;
    Llenareg;
    dbRoles.Post;
    GuardarPermisosExtra(Codigo);
    RecargarYLocalizar(Codigo);
    Relleno;
  except
    on E: Exception do
    begin
      if dbRoles.State in dsEditModes then dbRoles.Cancel;
      ShowMessage('No se ha podido crear el rol:' + LineEnding + E.Message);
    end;
  end;
end;

procedure TFRoles.BitBtn3Click(Sender: TObject);
var
  Codigo: string;
begin
  Codigo := Trim(Edit1.Text);
  if Codigo = '' then Exit;

  if not dbRoles.Locate('CgoRol', Codigo, []) then
  begin
    ShowMessage('Ese rol no existe y no puede eliminarse.');
    Exit;
  end;

  if MessageDlg('Eliminar rol',
    '¿Confirma que desea eliminar el rol “' + Codigo + '”?',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  try
    dbRoles.Delete;
    EliminarPermisosExtra(Codigo);
    LimpiarDatos(False);
    Application.QueueAsyncCall(@EnfocarCodigo, 0);
  except
    on E: Exception do
      ShowMessage('No se ha podido eliminar el rol:' + LineEnding + E.Message);
  end;
end;

procedure TFRoles.BitBtn4Click(Sender: TObject);
var
  Codigo: string;
begin
  if not ValidarDatos then Exit;
  Codigo := Edit1.Text;

  if not dbRoles.Locate('CgoRol', Codigo, []) then
  begin
    ShowMessage('Ese rol no existe. Utilice “Crear rol” para darlo de alta.');
    Exit;
  end;

  try
    dbRoles.Edit;
    Llenareg;
    dbRoles.Post;
    GuardarPermisosExtra(Codigo);
    RecargarYLocalizar(Codigo);
    Relleno;
  except
    on E: Exception do
    begin
      if dbRoles.State in dsEditModes then dbRoles.Cancel;
      ShowMessage('No se han podido guardar los cambios:' + LineEnding + E.Message);
    end;
  end;
end;

procedure TFRoles.BitBtn5Click(Sender: TObject);
begin
  if not ConfirmarDescartarCambios then Exit;
  if not dbRoles.Active or dbRoles.IsEmpty then Exit;

  if not FHayRegistroCargado then
    dbRoles.Last
  else
  begin
    dbRoles.Locate('CgoRol', FClaveCargada, []);
    dbRoles.Prior;
    if dbRoles.BOF then dbRoles.First;
  end;
  Relleno;
end;

procedure TFRoles.BitBtn6Click(Sender: TObject);
begin
  if not ConfirmarDescartarCambios then Exit;
  if not dbRoles.Active or dbRoles.IsEmpty then Exit;

  if not FHayRegistroCargado then
    dbRoles.First
  else
  begin
    dbRoles.Locate('CgoRol', FClaveCargada, []);
    dbRoles.Next;
    if dbRoles.EOF then dbRoles.Last;
  end;
  Relleno;
end;

procedure TFRoles.BitBtn7Click(Sender: TObject);
begin
  if not ConfirmarDescartarCambios then Exit;
  LimpiarDatos(False);
  Application.QueueAsyncCall(@EnfocarCodigo, 0);
end;

procedure TFRoles.Edit1Enter(Sender: TObject);
begin
  Edit1.SelectAll;
end;

procedure TFRoles.Edit1Exit(Sender: TObject);
var
  Codigo: string;
begin
  if FActualizando then Exit;

  Codigo := UpperCase(Trim(Edit1.Text));
  Edit1.Text := Codigo;
  if Codigo = '' then Exit;

  if dbRoles.Locate('CgoRol', Codigo, []) then
    Relleno
  else
  begin
    LimpiarDatos(True);
    Edit1.Text := Codigo;
    Edit1.ReadOnly := False;
    ActualizarEstado;
  end;
end;

procedure TFRoles.Relleno;
var
  I, J: Integer;
  Txt: string;
  Grupo: TCheckGroup;
begin
  if not dbRoles.Active or dbRoles.IsEmpty then
  begin
    LimpiarDatos(False);
    Exit;
  end;

  FActualizando := True;
  try
    Edit1.ReadOnly := False;
    Edit1.Text := dbRoles.FieldByName('CgoRol').AsString;
    Edit2.Text := dbRoles.FieldByName('DescriRol').AsString;

    for I := 1 to CANTIDAD_GRUPOS do
    begin
      Grupo := GrupoPermisos(I);
      if dbRoles.FindField(CampoRol(I)) <> nil then
      begin
        Grupo.Enabled := True;
        ToggleTodos(I).Enabled := True;
        Txt := dbRoles.FieldByName(CampoRol(I)).AsString;
        for J := 0 to Grupo.Items.Count - 1 do
          Grupo.Checked[J] := Copy(Txt, J + 1, 1) = '1';
      end
      else
      begin
        Grupo.Enabled := False;
        ToggleTodos(I).Enabled := False;
        for J := 0 to Grupo.Items.Count - 1 do
          Grupo.Checked[J] := False;
      end;
    end;

    CargarPermisosExtra(Edit1.Text);
    FClaveCargada := Edit1.Text;
    FHayRegistroCargado := True;
    FCambiosPendientes := False;
    Edit1.ReadOnly := True;
    ActualizarTodosLosBotones;
    ActualizarEstado;
  finally
    FActualizando := False;
  end;
end;

procedure TFRoles.Llenareg;
var
  I, J: Integer;
  Txt: string;
  Grupo: TCheckGroup;
begin
  dbRoles.FieldByName('CgoRol').AsString := UpperCase(Trim(Edit1.Text));
  dbRoles.FieldByName('DescriRol').AsString := Trim(Edit2.Text);

  for I := 1 to CANTIDAD_GRUPOS do
    if dbRoles.FindField(CampoRol(I)) <> nil then
    begin
      Grupo := GrupoPermisos(I);
      Txt := '';
      for J := 0 to Grupo.Items.Count - 1 do
        if Grupo.Checked[J] then
          Txt := Txt + '1'
        else
          Txt := Txt + '0';
      dbRoles.FieldByName(CampoRol(I)).AsString := Txt;
    end;
end;

procedure TFRoles.LimpiaForm;
begin
  LimpiarDatos(False);
end;

procedure TFRoles.LimpiarDatos(AConservarCodigo: Boolean);
var
  I, J: Integer;
  Codigo: string;
  Grupo: TCheckGroup;
begin
  Codigo := '';
  if AConservarCodigo then Codigo := Edit1.Text;

  FActualizando := True;
  try
    Edit1.ReadOnly := False;
    Edit1.Text := Codigo;
    Edit2.Text := '';
    for I := 1 to CANTIDAD_GRUPOS do
    begin
      Grupo := GrupoPermisos(I);
      for J := 0 to Grupo.Items.Count - 1 do
        Grupo.Checked[J] := False;
      ToggleTodos(I).Checked := False;
    end;
    LimpiarPermisosExtra;
    FHayRegistroCargado := False;
    FClaveCargada := '';
    FCambiosPendientes := False;
    ActualizarEstado;
  finally
    FActualizando := False;
  end;
end;

procedure TFRoles.RecargarYLocalizar(const ACodigo: string);
begin
  dbRoles.DisableControls;
  try
    dbRoles.Close;
    dbRoles.Open;
    dbRoles.Locate('CgoRol', ACodigo, []);
  finally
    dbRoles.EnableControls;
  end;
end;

function TFRoles.ConfirmarDescartarCambios: Boolean;
begin
  Result := True;
  if not FCambiosPendientes then Exit;
  Result := MessageDlg('Cambios pendientes',
    'Hay permisos modificados que todavía no se han guardado.' + LineEnding +
    '¿Desea descartarlos?', mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

procedure TFRoles.MarcarCambios(Sender: TObject);
begin
  if FActualizando then Exit;
  FCambiosPendientes := True;
  ActualizarEstado;
end;

procedure TFRoles.PermisoChange(Sender: TObject);
var
  I: Integer;
  P: TWinControl;
begin
  if FActualizando then Exit;

  P := nil;
  if Sender is TControl then P := TControl(Sender).Parent;
  while Assigned(P) and not (P is TCheckGroup) do
    P := P.Parent;

  if Assigned(P) then
    for I := 1 to CANTIDAD_GRUPOS do
      if GrupoPermisos(I) = P then
      begin
        ActualizarBotonTodos(I);
        Break;
      end;
  MarcarCambios(Sender);
end;

procedure TFRoles.AsignarEventosCambio;
var
  I, J: Integer;
  Grupo: TCheckGroup;
begin
  Edit2.OnChange := @MarcarCambios;
  for I := 1 to CANTIDAD_GRUPOS do
  begin
    Grupo := GrupoPermisos(I);
    Grupo.HandleNeeded;
    for J := 0 to Grupo.ControlCount - 1 do
      if Grupo.Controls[J] is TCheckBox then
        TCheckBox(Grupo.Controls[J]).OnChange := @PermisoChange;
  end;

  for I := 1 to Length(FGruposExtra) do
  begin
    Grupo := FGruposExtra[I - 1];
    Grupo.HandleNeeded;
    for J := 0 to Grupo.ControlCount - 1 do
      if Grupo.Controls[J] is TCheckBox then
        TCheckBox(Grupo.Controls[J]).OnChange := @ExtraPermisoChange;
  end;
end;

procedure TFRoles.ActualizarEstado;
var
  Texto: string;
begin
  if FHayRegistroCargado then
    Texto := 'Rol actual: ' + FClaveCargada + ' — ' + Trim(Edit2.Text)
  else if Trim(Edit1.Text) <> '' then
    Texto := 'Nuevo rol: ' + Trim(Edit1.Text)
  else
    Texto := 'Introduzca un código o navegue por los roles existentes';

  if FCambiosPendientes then
    Texto := Texto + '  •  CAMBIOS PENDIENTES';
  Label16.Caption := Texto;
end;

function TFRoles.CampoRol(AIndice: Integer): string;
begin
  if (AIndice >= 1) and (AIndice <= CANTIDAD_GRUPOS) then
    Result := CAMPOS_ROL[AIndice]
  else
    Result := '';
end;

function TFRoles.GrupoPermisos(AIndice: Integer): TCheckGroup;
begin
  case AIndice of
    1: Result := CheckGroup1;
    2: Result := CheckGroup2;
    3: Result := CheckGroup3;
    4: Result := CheckGroup4;
    5: Result := CheckGroup5;
    6: Result := CheckGroup6;
    7: Result := CheckGroup7;
    8: Result := CheckGroup8;
    9: Result := CheckGroup9;
    10: Result := CheckGroup10;
    11: Result := CheckGroup11;
    12: Result := CheckGroup12;
    13: Result := CheckGroup13;
  else
    Result := nil;
  end;
end;

function TFRoles.ToggleTodos(AIndice: Integer): TToggleBox;
begin
  case AIndice of
    1: Result := BtnR1;
    2: Result := BtnR2;
    3: Result := BtnR3;
    4: Result := BtnR4;
    5: Result := BtnR5;
    6: Result := BtnR6;
    7: Result := BtnR7;
    8: Result := BtnR8;
    9: Result := BtnR9;
    10: Result := BtnR10;
    11: Result := BtnR11;
    12: Result := BtnR12;
    13: Result := BtnR13;
  else
    Result := nil;
  end;
end;

procedure TFRoles.ActualizarBotonTodos(AIndice: Integer);
var
  J: Integer;
  TodosMarcados: Boolean;
  Grupo: TCheckGroup;
  EstadoAnterior: Boolean;
begin
  Grupo := GrupoPermisos(AIndice);
  if not Assigned(Grupo) then Exit;

  TodosMarcados := Grupo.Items.Count > 0;
  for J := 0 to Grupo.Items.Count - 1 do
    if not Grupo.Checked[J] then
    begin
      TodosMarcados := False;
      Break;
    end;

  EstadoAnterior := FActualizando;
  FActualizando := True;
  try
    ToggleTodos(AIndice).Checked := TodosMarcados;
  finally
    FActualizando := EstadoAnterior;
  end;
end;

procedure TFRoles.ActualizarTodosLosBotones;
var
  I, J: Integer;
  TodosMarcados: Boolean;
begin
  for I := 1 to CANTIDAD_GRUPOS do
    ActualizarBotonTodos(I);

  for I := 1 to Length(FGruposExtra) do
  begin
    TodosMarcados := FGruposExtra[I - 1].Items.Count > 0;
    for J := 0 to FGruposExtra[I - 1].Items.Count - 1 do
      if not FGruposExtra[I - 1].Checked[J] then
      begin
        TodosMarcados := False;
        Break;
      end;
    FBotonesTodosExtra[I - 1].Checked := TodosMarcados;
  end;
end;

procedure TFRoles.CambiarTodos(AIndice: Integer; AValor: Boolean);
var
  J: Integer;
  Grupo: TCheckGroup;
begin
  if FActualizando then Exit;
  Grupo := GrupoPermisos(AIndice);
  if not Assigned(Grupo) then Exit;

  FActualizando := True;
  try
    for J := 0 to Grupo.Items.Count - 1 do
      Grupo.Checked[J] := AValor;
  finally
    FActualizando := False;
  end;
  MarcarCambios(nil);
end;

procedure TFRoles.BtnR1Change(Sender: TObject); begin CambiarTodos(1, BtnR1.Checked); end;
procedure TFRoles.BtnR2Change(Sender: TObject); begin CambiarTodos(2, BtnR2.Checked); end;
procedure TFRoles.BtnR3Change(Sender: TObject); begin CambiarTodos(3, BtnR3.Checked); end;
procedure TFRoles.BtnR4Change(Sender: TObject); begin CambiarTodos(4, BtnR4.Checked); end;
procedure TFRoles.BtnR5Change(Sender: TObject); begin CambiarTodos(5, BtnR5.Checked); end;
procedure TFRoles.BtnR6Change(Sender: TObject); begin CambiarTodos(6, BtnR6.Checked); end;
procedure TFRoles.BtnR7Change(Sender: TObject); begin CambiarTodos(7, BtnR7.Checked); end;
procedure TFRoles.BtnR8Change(Sender: TObject); begin CambiarTodos(8, BtnR8.Checked); end;
procedure TFRoles.BtnR9Change(Sender: TObject); begin CambiarTodos(9, BtnR9.Checked); end;
procedure TFRoles.BtnR10Change(Sender: TObject); begin CambiarTodos(10, BtnR10.Checked); end;
procedure TFRoles.BtnR11Change(Sender: TObject); begin CambiarTodos(11, BtnR11.Checked); end;
procedure TFRoles.BtnR12Change(Sender: TObject); begin CambiarTodos(12, BtnR12.Checked); end;
procedure TFRoles.BtnR13Change(Sender: TObject); begin CambiarTodos(13, BtnR13.Checked); end;


function TFRoles.NombreTablaPermisosExtra: string;
var
  I: Integer;
  S: string;
begin
  S := '';
  for I := 1 to Length(Tienda) do
    if Tienda[I] in ['A'..'Z', 'a'..'z', '0'..'9', '_'] then
      S := S + Tienda[I];
  Result := 'rolespermisos' + S;
end;

procedure TFRoles.AsegurarTablaPermisosExtra;
var
  Q: TZQuery;
  P: Integer;
begin
  FTablaPermisosExtraDisponible := False;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := dbRoles.Connection;
    Q.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS `' + NombreTablaPermisosExtra + '` (' +
      'CgoRol VARCHAR(20) NOT NULL, ' +
      'Modulo VARCHAR(40) NOT NULL, ' +
      'Permisos CHAR(4) NOT NULL DEFAULT ''0000'', ' +
      'PRIMARY KEY (CgoRol, Modulo), ' +
      'KEY idx_modulo (Modulo)' +
      ') ENGINE=MyISAM DEFAULT CHARSET=utf8mb4';
    Q.ExecSQL;
    FTablaPermisosExtraDisponible := True;
    for P := 0 to High(FGruposExtra) do
    begin
      FGruposExtra[P].Enabled := True;
      FBotonesTodosExtra[P].Enabled := True;
    end;
  except
    on E: Exception do
    begin
      FTablaPermisosExtraDisponible := False;
      for P := 0 to High(FGruposExtra) do
      begin
        FGruposExtra[P].Enabled := False;
        FBotonesTodosExtra[P].Enabled := False;
      end;
      ShowMessage('No se ha podido preparar la tabla de permisos ampliados:' +
        LineEnding + E.Message + LineEnding + LineEnding +
        'Los permisos históricos siguen disponibles, pero las nuevas pestañas ' +
        'quedarán desactivadas hasta resolverlo.');
    end;
  end;
end;

procedure TFRoles.CrearPestanasAmpliadas;
var
  I, J, P: Integer;
  Grupo: TCheckGroup;
  Boton: TToggleBox;
  Pagina: TTabSheet;
begin
  if Length(FGruposExtra) > 0 then Exit;

  SetLength(FGruposExtra, CANTIDAD_GRUPOS_EXTRA);
  SetLength(FBotonesTodosExtra, CANTIDAD_GRUPOS_EXTRA);

  for P := 2 to 5 do
  begin
    case P of
      2: Pagina := TabSheet2;
      3: Pagina := TabSheet3;
      4: Pagina := TabSheet4;
    else
      Pagina := TabSheet5;
    end;

    FScrollExtra[P] := TScrollBox.Create(Self);
    FScrollExtra[P].Parent := Pagina;
    FScrollExtra[P].Align := alClient;
    FScrollExtra[P].BorderStyle := bsNone;
    FScrollExtra[P].AutoScroll := True;
    FScrollExtra[P].Color := RGBToColor(244, 247, 251);
  end;

  for I := 1 to CANTIDAD_GRUPOS_EXTRA do
  begin
    Grupo := TCheckGroup.Create(Self);
    Grupo.Parent := FScrollExtra[PESTANA_GRUPO_EXTRA[I]];
    Grupo.Caption := TITULO_GRUPO_EXTRA[I];
    Grupo.Items.Add('Lectura');
    Grupo.Items.Add('Escritura');
    Grupo.Items.Add('Borrado');
    Grupo.Items.Add('Estadísticas');
    Grupo.Columns := 4;
    Grupo.Color := clWhite;
    Grupo.Font.Name := 'Sans';
    Grupo.Font.Height := -12;
    Grupo.Font.Color := RGBToColor(24, 36, 48);
    Grupo.Font.Style := [fsBold];
    Grupo.Tag := I;
    Grupo.ShowHint := True;
    Grupo.Hint := 'Permisos para ' + TITULO_GRUPO_EXTRA[I];
    Grupo.HandleNeeded;
    for J := 0 to Grupo.ControlCount - 1 do
      if Grupo.Controls[J] is TCheckBox then
      begin
        TCheckBox(Grupo.Controls[J]).Font.Color := RGBToColor(24, 36, 48);
        TCheckBox(Grupo.Controls[J]).Font.Style := [];
        TCheckBox(Grupo.Controls[J]).Color := clWhite;
        TCheckBox(Grupo.Controls[J]).OnChange := @ExtraPermisoChange;
      end;

    Boton := TToggleBox.Create(Self);
    Boton.Parent := FScrollExtra[PESTANA_GRUPO_EXTRA[I]];
    Boton.Caption := 'Todos';
    Boton.Color := RGBToColor(219, 234, 248);
    Boton.Font.Name := 'Sans';
    Boton.Font.Height := -12;
    Boton.Font.Color := RGBToColor(24, 36, 48);
    Boton.Font.Style := [fsBold];
    Boton.Tag := I;
    Boton.ShowHint := True;
    Boton.Hint := 'Marcar o desmarcar todos los permisos de ' +
      TITULO_GRUPO_EXTRA[I];
    Boton.OnChange := @ExtraTodosChange;

    FGruposExtra[I - 1] := Grupo;
    FBotonesTodosExtra[I - 1] := Boton;
  end;

  AplicarDisposicionPermisosExtra;
end;

procedure TFRoles.AplicarDisposicionPermisosExtra;
var
  P, I, Local, Columna, Fila: Integer;
  Margen, Separacion, AnchoDisponible, AnchoColumna: Integer;
  X, Y, AltoFila, AnchoToggle, AnchoGrupo: Integer;
begin
  if Length(FGruposExtra) = 0 then Exit;

  Margen := 18;
  Separacion := 18;
  AltoFila := 72;
  AnchoToggle := 82;

  for P := 2 to 5 do
  begin
    if not Assigned(FScrollExtra[P]) then Continue;
    AnchoDisponible := FScrollExtra[P].ClientWidth - (Margen * 2) - Separacion;
    if AnchoDisponible < 760 then AnchoDisponible := 760;
    AnchoColumna := AnchoDisponible div 2;
    AnchoGrupo := AnchoColumna - AnchoToggle - 10;
    if AnchoGrupo < 300 then AnchoGrupo := 300;

    Local := 0;
    for I := 1 to CANTIDAD_GRUPOS_EXTRA do
      if PESTANA_GRUPO_EXTRA[I] = P then
      begin
        Columna := Local mod 2;
        Fila := Local div 2;
        X := Margen + Columna * (AnchoColumna + Separacion);
        Y := 16 + Fila * AltoFila;
        FGruposExtra[I - 1].SetBounds(X, Y, AnchoGrupo, 60);
        FBotonesTodosExtra[I - 1].SetBounds(
          X + AnchoColumna - AnchoToggle, Y + 13, AnchoToggle, 34);
        Inc(Local);
      end;
  end;
end;

procedure TFRoles.LimpiarPermisosExtra;
var
  I, J: Integer;
begin
  for I := 0 to High(FGruposExtra) do
  begin
    for J := 0 to FGruposExtra[I].Items.Count - 1 do
      FGruposExtra[I].Checked[J] := False;
    FBotonesTodosExtra[I].Checked := False;
  end;
end;

procedure TFRoles.CargarPermisosExtra(const ACodigoRol: string);
var
  Q: TZQuery;
  I, J: Integer;
  Clave, Txt: string;
begin
  LimpiarPermisosExtra;
  if not FTablaPermisosExtraDisponible then Exit;
  if Trim(ACodigoRol) = '' then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := dbRoles.Connection;
    Q.SQL.Text := 'SELECT Modulo, Permisos FROM `' +
      NombreTablaPermisosExtra + '` WHERE CgoRol=:rol';
    Q.ParamByName('rol').AsString := ACodigoRol;
    Q.Open;
    while not Q.EOF do
    begin
      Clave := Trim(Q.FieldByName('Modulo').AsString);
      Txt := Q.FieldByName('Permisos').AsString;
      for I := 1 to CANTIDAD_GRUPOS_EXTRA do
        if SameText(CLAVE_GRUPO_EXTRA[I], Clave) then
        begin
          for J := 0 to FGruposExtra[I - 1].Items.Count - 1 do
            FGruposExtra[I - 1].Checked[J] := Copy(Txt, J + 1, 1) = '1';
          Break;
        end;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TFRoles.GuardarPermisosExtra(const ACodigoRol: string);
var
  Q: TZQuery;
  I, J: Integer;
  Txt: string;
begin
  if not FTablaPermisosExtraDisponible then Exit;
  if Trim(ACodigoRol) = '' then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := dbRoles.Connection;
    Q.SQL.Text := 'INSERT INTO `' + NombreTablaPermisosExtra +
      '` (CgoRol, Modulo, Permisos) VALUES (:rol,:modulo,:permisos) ' +
      'ON DUPLICATE KEY UPDATE Permisos=VALUES(Permisos)';
    for I := 1 to CANTIDAD_GRUPOS_EXTRA do
    begin
      Txt := '';
      for J := 0 to FGruposExtra[I - 1].Items.Count - 1 do
        if FGruposExtra[I - 1].Checked[J] then
          Txt := Txt + '1'
        else
          Txt := Txt + '0';
      Q.ParamByName('rol').AsString := ACodigoRol;
      Q.ParamByName('modulo').AsString := CLAVE_GRUPO_EXTRA[I];
      Q.ParamByName('permisos').AsString := Txt;
      Q.ExecSQL;
    end;
  finally
    Q.Free;
  end;
end;

procedure TFRoles.EliminarPermisosExtra(const ACodigoRol: string);
var
  Q: TZQuery;
begin
  if not FTablaPermisosExtraDisponible then Exit;
  if Trim(ACodigoRol) = '' then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := dbRoles.Connection;
    Q.SQL.Text := 'DELETE FROM `' + NombreTablaPermisosExtra +
      '` WHERE CgoRol=:rol';
    Q.ParamByName('rol').AsString := ACodigoRol;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TFRoles.ExtraPermisoChange(Sender: TObject);
var
  P: TWinControl;
  I, J: Integer;
  TodosMarcados: Boolean;
begin
  if FActualizando then Exit;
  P := nil;
  if Sender is TControl then P := TControl(Sender).Parent;
  while Assigned(P) and not (P is TCheckGroup) do
    P := P.Parent;
  if not Assigned(P) then Exit;

  I := P.Tag;
  if (I < 1) or (I > Length(FGruposExtra)) then Exit;
  TodosMarcados := FGruposExtra[I - 1].Items.Count > 0;
  for J := 0 to FGruposExtra[I - 1].Items.Count - 1 do
    if not FGruposExtra[I - 1].Checked[J] then
    begin
      TodosMarcados := False;
      Break;
    end;

  FActualizando := True;
  try
    FBotonesTodosExtra[I - 1].Checked := TodosMarcados;
  finally
    FActualizando := False;
  end;
  MarcarCambios(Sender);
end;

procedure TFRoles.ExtraTodosChange(Sender: TObject);
var
  I: Integer;
begin
  if FActualizando then Exit;
  if not (Sender is TToggleBox) then Exit;
  I := TToggleBox(Sender).Tag;
  if (I < 1) or (I > Length(FGruposExtra)) then Exit;
  CambiarTodosExtra(I, TToggleBox(Sender).Checked);
end;

procedure TFRoles.CambiarTodosExtra(AIndice: Integer; AValor: Boolean);
var
  J: Integer;
begin
  if FActualizando then Exit;
  if (AIndice < 1) or (AIndice > Length(FGruposExtra)) then Exit;

  FActualizando := True;
  try
    for J := 0 to FGruposExtra[AIndice - 1].Items.Count - 1 do
      FGruposExtra[AIndice - 1].Checked[J] := AValor;
  finally
    FActualizando := False;
  end;
  MarcarCambios(nil);
end;

procedure TFRoles.AplicarEstiloModerno;
var
  I: Integer;
  Botones: array[0..6] of TBitBtn;
begin
  Color := RGBToColor(244, 247, 251);
  Font.Name := 'Sans';
  Font.Height := -13;

  PanelCabecera.Caption := '';
  PanelCabecera.Color := RGBToColor(31, 78, 121);
  PanelDatosRol.Caption := '';
  PanelDatosRol.Color := RGBToColor(239, 245, 251);
  Panel1.Caption := '';
  Panel1.Color := RGBToColor(232, 239, 247);

  LabelTitulo.Font.Color := clWhite;
  LabelSubtitulo.Font.Color := RGBToColor(221, 235, 248);
  LabelAyudaPermisos.Font.Color := RGBToColor(65, 82, 99);
  Label1.Font.Color := RGBToColor(24, 36, 48);
  Label2.Font.Color := RGBToColor(24, 36, 48);
  Label16.Font.Color := RGBToColor(31, 78, 121);

  Edit1.Color := clWhite;
  Edit2.Color := clWhite;
  Edit1.Font.Color := RGBToColor(24, 36, 48);
  Edit2.Font.Color := RGBToColor(24, 36, 48);

  PageControl1.Font.Color := RGBToColor(24, 36, 48);
  PageControl1.Font.Style := [fsBold];
  TabSheet1.Caption := 'Ficheros maestros';
  TabSheet2.Caption := 'Ventas / Compras';
  TabSheet3.Caption := 'Listados / Cajas';
  TabSheet4.Caption := 'Históricos';
  TabSheet5.Caption := 'Comunicaciones';
  TabSheet2.TabVisible := True;
  TabSheet3.TabVisible := True;
  TabSheet4.TabVisible := True;
  TabSheet5.TabVisible := True;

  Botones[0] := BitBtn1;
  Botones[1] := BitBtn2;
  Botones[2] := BitBtn3;
  Botones[3] := BitBtn4;
  Botones[4] := BitBtn5;
  Botones[5] := BitBtn6;
  Botones[6] := BitBtn7;
  for I := Low(Botones) to High(Botones) do
  begin
    Botones[I].Font.Name := 'Sans';
    Botones[I].Font.Height := -13;
    Botones[I].Font.Style := [fsBold];
    Botones[I].Font.Color := RGBToColor(24, 36, 48);
    Botones[I].Visible := True;
    Botones[I].BringToFront;
  end;

  BitBtn7.Color := RGBToColor(255, 244, 204);
  BitBtn2.Color := RGBToColor(215, 236, 224);
  BitBtn3.Color := RGBToColor(249, 221, 221);
  BitBtn4.Color := RGBToColor(219, 234, 248);
  BitBtn5.Color := RGBToColor(229, 233, 238);
  BitBtn6.Color := RGBToColor(229, 233, 238);
  BitBtn1.Color := RGBToColor(229, 233, 238);
end;

procedure TFRoles.AplicarEstiloGrupos;
var
  I, J: Integer;
  Grupo: TCheckGroup;
  C: TControl;
begin
  for I := 1 to CANTIDAD_GRUPOS do
  begin
    Grupo := GrupoPermisos(I);
    Grupo.Caption := TITULOS_ROL[I];
    Grupo.Color := clWhite;
    Grupo.Font.Color := RGBToColor(24, 36, 48);
    Grupo.Font.Name := 'Sans';
    Grupo.Font.Height := -12;
    Grupo.Font.Style := [fsBold];
    Grupo.Columns := 4;
    Grupo.HandleNeeded;
    for J := 0 to Grupo.ControlCount - 1 do
    begin
      C := Grupo.Controls[J];
      if C is TCheckBox then
      begin
        TCheckBox(C).Font.Color := RGBToColor(24, 36, 48);
        TCheckBox(C).Font.Style := [];
        TCheckBox(C).Color := clWhite;
      end;
    end;

    ToggleTodos(I).Caption := 'Todos';
    ToggleTodos(I).Color := RGBToColor(219, 234, 248);
    ToggleTodos(I).Font.Color := RGBToColor(24, 36, 48);
    ToggleTodos(I).Font.Style := [fsBold];
    ToggleTodos(I).Hint := 'Marcar o desmarcar todos los permisos de ' + TITULOS_ROL[I];
  end;

  Label3.Visible := False;
  Label4.Visible := False;
  Label5.Visible := False;
  Label6.Visible := False;
  Label7.Visible := False;
  Label8.Visible := False;
  Label9.Visible := False;
  Label10.Visible := False;
  Label11.Visible := False;
  Label12.Visible := False;
  Label13.Visible := False;
  Label14.Visible := False;
  Label15.Visible := False;
end;

procedure TFRoles.AplicarDisposicionPermisos;
var
  I, Columna, Fila: Integer;
  Margen, Separacion, AnchoDisponible, AnchoColumna: Integer;
  X, Y, AltoFila, AnchoToggle: Integer;
  Grupo: TCheckGroup;
  Toggle: TToggleBox;
begin
  if not Assigned(TabSheet1) then Exit;

  { Cabecera de datos y barra inferior adaptables a resoluciones menores. }
  Edit2.Width := 540;
  Label16.Left := Edit2.Left + Edit2.Width + 24;
  Label16.Width := PanelDatosRol.ClientWidth - Label16.Left - 24;
  if Label16.Width < 210 then Label16.Width := 210;

  BitBtn7.SetBounds(18, 18, 126, 44);
  BitBtn2.SetBounds(154, 18, 122, 44);
  BitBtn3.SetBounds(286, 18, 118, 44);
  BitBtn4.SetBounds(414, 18, 150, 44);
  BitBtn5.SetBounds(580, 18, 110, 44);
  BitBtn6.SetBounds(700, 18, 110, 44);
  BitBtn1.SetBounds(Panel1.ClientWidth - 138, 18, 120, 44);

  Margen := 18;
  Separacion := 18;
  AltoFila := 62;
  AnchoToggle := 82;
  AnchoDisponible := TabSheet1.ClientWidth - (Margen * 2) - Separacion;
  if AnchoDisponible < 800 then AnchoDisponible := 800;
  AnchoColumna := AnchoDisponible div 2;

  for I := 1 to CANTIDAD_GRUPOS do
  begin
    if I <= 7 then
    begin
      Columna := 0;
      Fila := I - 1;
    end
    else
    begin
      Columna := 1;
      Fila := I - 8;
    end;

    X := Margen + Columna * (AnchoColumna + Separacion);
    Y := 14 + Fila * AltoFila;
    Grupo := GrupoPermisos(I);
    Toggle := ToggleTodos(I);
    Grupo.Anchors := [akTop, akLeft];
    Toggle.Anchors := [akTop, akLeft];
    Grupo.SetBounds(X, Y, AnchoColumna - AnchoToggle - 10, 54);
    Toggle.SetBounds(X + AnchoColumna - AnchoToggle, Y + 10, AnchoToggle, 34);
  end;
end;

procedure TFRoles.AplicarContrasteSeleccion(AControl: TWinControl);
{$IFDEF LCLGTK2}
var
  FondoNormal, TextoNormal, FondoSeleccion, TextoSeleccion: TGdkColor;
  Widget: PGtkWidget;
{$ENDIF}
begin
  if not Assigned(AControl) then Exit;
  AControl.HandleNeeded;
  {$IFDEF LCLGTK2}
  Widget := PGtkWidget(AControl.Handle);
  if Assigned(Widget) then
  begin
    gdk_color_parse(PChar('#FFFFFF'), @FondoNormal);
    gdk_color_parse(PChar('#182430'), @TextoNormal);
    gtk_widget_modify_base(Widget, GTK_STATE_NORMAL, @FondoNormal);
    gtk_widget_modify_text(Widget, GTK_STATE_NORMAL, @TextoNormal);
    gdk_color_parse(PChar('#2A5684'), @FondoSeleccion);
    gdk_color_parse(PChar('#FFFFFF'), @TextoSeleccion);
    gtk_widget_modify_base(Widget, GTK_STATE_SELECTED, @FondoSeleccion);
    gtk_widget_modify_text(Widget, GTK_STATE_SELECTED, @TextoSeleccion);
  end;
  {$ENDIF}
end;

procedure TFRoles.AplicarContrasteSeleccionControles(AParent: TWinControl);
var
  I: Integer;
  C: TControl;
begin
  if not Assigned(AParent) then Exit;
  for I := 0 to AParent.ControlCount - 1 do
  begin
    C := AParent.Controls[I];
    if C is TCustomEdit then
      AplicarContrasteSeleccion(TWinControl(C));
    if C is TWinControl then
      AplicarContrasteSeleccionControles(TWinControl(C));
  end;
end;

initialization
  {$I roles.lrs}

end.
