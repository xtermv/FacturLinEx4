{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2011

  Nicolas Lopez de Lerma Aymerich <nicolas@esdebian.org>

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit entrada;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ZDataset, db, ZConnection, DBGrids, Grids, ExtCtrls, StdCtrls, Buttons,
  EditBtn, LCLType, LCLIntf, ComCtrls, variants
  {$IFDEF LCLGTK2}
  , gtk2, gdk2
  {$ENDIF}
  ;

type

  { TFEntrada }

  TFEntrada = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    BitBtn2: TBitBtn;
    BitBtn29: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn30: TBitBtn;
    BitBtn31: TBitBtn;
    CheckBox1: TCheckBox;
    Datasource1: TDatasource;
    DateEdit10: TDateEdit;
    DateEdit3: TDateEdit;
    DateEdit4: TDateEdit;
    DateEdit5: TDateEdit;
    DateEdit6: TDateEdit;
    dbTrabajo: TZQuery;
    DBGrid1: TDBGrid;
    dbPedic: TZQuery;
    dbPedid: TZQuery;
    dbTotales: TZQuery;
    dbArti: TZQuery;
    dbProve: TZQuery;
    Edit24: TEdit;
    Edit25: TEdit;
    Edit26: TEdit;
    Edit27: TEdit;
    Edit28: TEdit;
    Edit29: TEdit;
    Edit30: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
    Edit34: TEdit;
    Edit35: TEdit;
    Edit36: TEdit;
    EditOtrosGastos: TEdit;
    Label30: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    Label86: TLabel;
    LabelCliente: TLabel;
    LabelCliente1: TLabel;
    LabelCliente2: TLabel;
    LabelCliente3: TLabel;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    ProgressBar1: TProgressBar;
    RadioButton15: TRadioButton;
    RadioButton16: TRadioButton;
    RadioButton17: TRadioButton;
    RadioButton18: TRadioButton;
    StaticText1: TStaticText;
    StaticText10: TStaticText;
    StaticText11: TStaticText;
    StaticText12: TStaticText;
    StaticText13: TStaticText;
    StaticText14: TStaticText;
    StaticText15: TStaticText;
    StaticText16: TStaticText;
    StaticText17: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    procedure BitBtn29Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn30Click(Sender: TObject);
    procedure BitBtn31Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure Datasource1DataChange(Sender: TObject; Field: TField);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure Edit24Exit(Sender: TObject);
    procedure EditOtrosGastosExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure PintarTotalVencimientos();
    procedure PintaLineas();
    procedure ActuArticulos();
    procedure ActuEstaArti();
    procedure LeerDatosArticulo();
    procedure ActuUltimoPedi();
    procedure ActuTiendas();
    procedure ActuDeparta();
    procedure ActuFamilia();
    procedure ActuProveedor();
    procedure ActuEstaProveedor();
    procedure ActuEstaTiendas();
    procedure ActuHistocc();
    procedure ActuHistodd();
    procedure BorrarPedido();
    procedure VerVencimientos();

  private
    { Estado visual y controles creados para la modernización }
    FOrdenGrid1: String;
    FMoviendoPanel11: Boolean;
    FPanel11MovidoPorUsuario: Boolean;
    FPanel11DragOffset: TPoint;
    FCabeceraPrincipal: TPanel;
    FTituloPrincipal: TLabel;
    FSubtituloPrincipal: TLabel;

    { private declarations }
    function TextoAFloat(const S: String): Double;
    function SQLFloat(AValue: Double): String;
    function RedondearCentimos(AValue: Double): Double;
    function TotalPedidoCalculado(): Double;
    function TotalPedidoConGastos(): Double;
    function FechaBaseVencimiento(): TDateTime;
    procedure CargarProveedorActual();
    procedure NormalizarImportesVencimientos();
    procedure AsignarFechaOClear(AField: TField; ADateEdit: TDateEdit);
    procedure RecalcularTotalesSegunSeleccionAceptada();
    procedure AplicarValoresAceptadosAHistoricoDetalle();
    function HistPreciosTableName: string;
    procedure EnsureHistPreciosTable;
    procedure RegistrarCambioPrecioPedido(const ACodigo, ADescripcion, ACampo, AAnterior, ANuevo, AMotivo: string);

    { Modernización visual, ordenación y contraste }
    procedure CrearCabeceraPrincipal;
    procedure AplicarEstiloModerno;
    procedure ConfigurarGridModerno(AGrid: TDBGrid);
    procedure EstiloTitulo(ALabel: TLabel);
    procedure RecolocarPaneles;
    procedure CentrarPanel(APanel: TPanel);
    procedure AplicarOrdenGrid(AGrid: TDBGrid; AQuery: TZQuery;
      Column: TColumn; var AOrden: String);
    procedure MarcarColumnaOrdenada(AGrid: TDBGrid; Column: TColumn;
      const AOrden: String);
    procedure AplicarContrasteSeleccion(AEditControl: TWinControl);
    procedure AplicarContrasteSeleccionControles(AParent: TWinControl);
    procedure Panel11DragMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel11DragMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Panel11DragMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LimitarPanel11AlAreaVisible;
  public
    { public declarations }
  end; 

  procedure ShowFormEntradaPedido(PaTienda,PaFecha,PaProveedor,PaSerie,PaNPedido:String);

var
  FEntrada: TFEntrada;
  PreciohaCambiado: Boolean;
  Codigo, Departa: String;
  Cantidad, Costo, Precio: String;

  //---------- Para saber si viene un pedido ya preseleccionado.
  PasaPD0: Integer;
  PasaPD1: TDateTime;
  PasaPD2: Integer;
  PasaPD3: String;
  PasaPD4: Integer;
  // Control para mantener la actualizacion en todas las lineas del pedido.
  MantenerSeleccion, SeleccionAutomatica: boolean;
  cbDescripcionF, cbCostoF, cbMargenF, cbIvaF, cbRecF, cbPrecioF, cbPvpF: boolean;
  cbDescripcionP, cbCostoP, cbMargenP, cbIvaP, cbRecP, cbPrecioP, cbPvpP: boolean;

implementation

{ TFEntrada }

uses
  Global, Funciones, CambiPrecio;

function FLX_CleanIdentEntrada(const S: string): string;
var
  I: Integer;
  C: Char;
begin
  Result := '';
  for I := 1 to Length(S) do
  begin
    C := S[I];
    if (C in ['A'..'Z']) or (C in ['a'..'z']) or (C in ['0'..'9']) or (C = '_') then
      Result := Result + C;
  end;
end;

function FLX_SQLIdentEntrada(const S: string): string;
begin
  Result := '`' + StringReplace(S, '`', '', [rfReplaceAll]) + '`';
end;

function FLX_NormalizaValorPrecioHistEntrada(const S: string): string;
var
  V: Double;
  T: string;
begin
  T := Trim(S);
  if T = '' then
  begin
    Result := '';
    Exit;
  end;

  if not TryStrToFloat(T, V) then
  begin
    T := StringReplace(T, '.', DefaultFormatSettings.DecimalSeparator, [rfReplaceAll]);
    T := StringReplace(T, ',', DefaultFormatSettings.DecimalSeparator, [rfReplaceAll]);
  end;

  if TryStrToFloat(T, V) then
    Result := FormatFloat('0.0000', V)
  else
    Result := Trim(S);
end;

function FLX_Trim255Entrada(const S: string): string;
begin
  Result := Copy(Trim(S), 1, 255);
end;

//===================== FUNCIONES INTERNAS SEGURAS =====================
function TFEntrada.TextoAFloat(const S: String): Double;
var
  Tmp: String;
begin
  Tmp:=Trim(S);
  if Tmp='' then
    begin
      Result:=0;
      exit;
    end;
  if TryStrToFloat(Tmp,Result) then exit;

  // Soporta textos con punto o coma decimal, independientemente de la locale.
  Tmp:=StringReplace(Tmp,'.',DefaultFormatSettings.DecimalSeparator,[rfReplaceAll]);
  Tmp:=StringReplace(Tmp,',',DefaultFormatSettings.DecimalSeparator,[rfReplaceAll]);
  Result:=StrToFloatDef(Tmp,0);
end;

function TFEntrada.SQLFloat(AValue: Double): String;
var
  FS: TFormatSettings;
begin
  FS:=DefaultFormatSettings;
  FS.DecimalSeparator:='.';
  Result:=FormatFloat('0.###############',AValue,FS);
end;

function TFEntrada.RedondearCentimos(AValue: Double): Double;
begin
  Result:=Round(AValue*100)/100;
end;

function TFEntrada.HistPreciosTableName: string;
begin
  Result := 'flx_hist_precios' + FLX_CleanIdentEntrada(Tienda);
end;

procedure TFEntrada.EnsureHistPreciosTable;
var
  Q: TZQuery;
  T, EngineSQL, Engine: string;
begin
  T := HistPreciosTableName;
  Engine := Trim(MotorDB);
  EngineSQL := '';
  if SameText(Engine, 'MyISAM') then EngineSQL := ' ENGINE=MyISAM'
  else if SameText(Engine, 'Aria') then EngineSQL := ' ENGINE=Aria'
  else if SameText(Engine, 'InnoDB') then EngineSQL := ' ENGINE=InnoDB';

  Q := TZQuery.Create(nil);
  try
    if Assigned(dbTrabajo.Connection) then
      Q.Connection := dbTrabajo.Connection
    else if Assigned(dbArti.Connection) then
      Q.Connection := dbArti.Connection;

    Q.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS ' + FLX_SQLIdentEntrada(T) + ' (' +
      'id BIGINT NOT NULL AUTO_INCREMENT, ' +
      'fecha DATE NOT NULL, ' +
      'hora TIME NOT NULL, ' +
      'usuario VARCHAR(100) NOT NULL DEFAULT '''', ' +
      'codigo VARCHAR(60) NOT NULL DEFAULT '''', ' +
      'descripcion VARCHAR(255) NOT NULL DEFAULT '''', ' +
      'campo VARCHAR(40) NOT NULL DEFAULT '''', ' +
      'valor_anterior VARCHAR(80) NOT NULL DEFAULT '''', ' +
      'valor_nuevo VARCHAR(80) NOT NULL DEFAULT '''', ' +
      'motivo VARCHAR(255) NOT NULL DEFAULT '''', ' +
      'PRIMARY KEY (id), ' +
      'KEY idx_fecha (fecha,hora), ' +
      'KEY idx_codigo (codigo), ' +
      'KEY idx_campo (campo)' +
      ')' + EngineSQL + ' DEFAULT CHARSET=utf8';
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TFEntrada.RegistrarCambioPrecioPedido(const ACodigo, ADescripcion, ACampo, AAnterior, ANuevo, AMotivo: string);
var
  Q: TZQuery;
  T, AntesN, DespuesN: string;
begin
  AntesN := FLX_NormalizaValorPrecioHistEntrada(AAnterior);
  DespuesN := FLX_NormalizaValorPrecioHistEntrada(ANuevo);
  if AntesN = DespuesN then Exit;

  T := HistPreciosTableName;
  Q := TZQuery.Create(nil);
  try
    if Assigned(dbTrabajo.Connection) then
      Q.Connection := dbTrabajo.Connection
    else if Assigned(dbArti.Connection) then
      Q.Connection := dbArti.Connection;

    Q.SQL.Text := 'INSERT INTO ' + FLX_SQLIdentEntrada(T) +
      ' (fecha,hora,usuario,codigo,descripcion,campo,valor_anterior,valor_nuevo,motivo) ' +
      ' VALUES (:fecha,:hora,:usuario,:codigo,:descripcion,:campo,:valor_anterior,:valor_nuevo,:motivo)';
    Q.ParamByName('fecha').AsString := FormatDateTime('yyyy-mm-dd', Date);
    Q.ParamByName('hora').AsString := FormatDateTime('hh:nn:ss', Time);
    Q.ParamByName('usuario').AsString := UsuarioActivo;
    Q.ParamByName('codigo').AsString := ACodigo;
    Q.ParamByName('descripcion').AsString := FLX_Trim255Entrada(ADescripcion);
    Q.ParamByName('campo').AsString := ACampo;
    Q.ParamByName('valor_anterior').AsString := AntesN;
    Q.ParamByName('valor_nuevo').AsString := DespuesN;
    Q.ParamByName('motivo').AsString := FLX_Trim255Entrada(AMotivo);
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

//----------------- Total calculado desde las bases e impuestos mostrados
// IMPORTANTE: no se mezcla PC8 con importes recalculados desde lineas.
function TFEntrada.TotalPedidoCalculado(): Double;
begin
  Result:=TextoAFloat(StaticText1.Caption)+TextoAFloat(StaticText2.Caption);
end;

//----------------- Total mas otros gastos, solo si se han marcado para vencimientos
function TFEntrada.TotalPedidoConGastos(): Double;
begin
  Result:=TotalPedidoCalculado();
  if CheckBox1.Checked then
    Result:=Result+TextoAFloat(EditOtrosGastos.Text);
end;

function TFEntrada.FechaBaseVencimiento(): TDateTime;
begin
  if DateEdit10.Text<>'' then
    Result:=DateEdit10.Date
  else
    Result:=dbPedic.FieldByName('PC1').AsDateTime;
end;

procedure TFEntrada.CargarProveedorActual();
begin
  dbProve.Active:=False;
  dbProve.SQL.Text:='SELECT * FROM proveedores WHERE P0='+dbPedic.FieldByName('PC2').AsString;
  dbProve.Active:=True;
end;

procedure TFEntrada.NormalizarImportesVencimientos();
begin
  if Edit24.Text='' then Edit24.Text:='0.00';
  if Edit26.Text='' then Edit26.Text:='0.00';
  if Edit28.Text='' then Edit28.Text:='0.00';
  if Edit30.Text='' then Edit30.Text:='0.00';
  if EditOtrosGastos.Text='' then EditOtrosGastos.Text:='0.00';
end;

procedure TFEntrada.AsignarFechaOClear(AField: TField; ADateEdit: TDateEdit);
begin
  if ADateEdit.Text='' then
    AField.Clear
  else
    AField.Value:=ADateEdit.Date;
end;

//----------------- Recalcula bases e impuestos con los valores finales aceptados
// linea a linea. Esto es clave porque ShowCambioPrecio puede dejar en la ficha
// los datos nuevos del pedido o conservar los datos antiguos, segun la decision
// tomada en cada linea.
procedure TFEntrada.RecalcularTotalesSegunSeleccionAceptada();
var
  B1, B2, B3, B0: Double;
  I1, I2, I3, I0: Double;
  CantidadLinea, BaseLinea, ImpLinea: Double;
  TipoIva, TipoRec: Integer;

  procedure SumarLinea(AIva: Integer; ABase, AImp: Double);
  begin
    if AIva=Round(IVA1) then
      begin B1:=B1+ABase; I1:=I1+AImp; end
    else if AIva=Round(IVA2) then
      begin B2:=B2+ABase; I2:=I2+AImp; end
    else if AIva=Round(IVA3) then
      begin B3:=B3+ABase; I3:=I3+AImp; end
    else
      begin B0:=B0+ABase; I0:=I0+AImp; end;
  end;

begin
  B1:=0; B2:=0; B3:=0; B0:=0;
  I1:=0; I2:=0; I3:=0; I0:=0;

  if (not dbPedid.Active) or (dbPedid.RecordCount=0) then exit;

  dbPedid.First;
  while not dbPedid.EOF do
    begin
      dbArti.Active:=False;
      dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+dbPedid.FieldByName('PD6').AsString+'"';
      dbArti.Active:=True;
      if dbArti.RecordCount=0 then
        raise Exception.Create('Articulo no encontrado al recalcular totales aceptados: '+dbPedid.FieldByName('PD6').AsString);

      CantidadLinea:=dbPedid.FieldByName('PD8').AsFloat;
      BaseLinea:=dbArti.FieldByName('A24').AsFloat*CantidadLinea;
      TipoIva:=dbArti.FieldByName('A3').AsInteger;
      TipoRec:=dbArti.FieldByName('A36').AsInteger;
      ImpLinea:=BaseLinea*((TipoIva+TipoRec)/100);

      SumarLinea(TipoIva,BaseLinea,ImpLinea);
      dbPedid.Next;
    end;

  Edit25.Text:=FormatFloat('0.000',B1); Edit32.Text:=FormatFloat('0.000',I1);
  Edit27.Text:=FormatFloat('0.000',B2); Edit33.Text:=FormatFloat('0.000',I2);
  Edit29.Text:=FormatFloat('0.000',B3); Edit35.Text:=FormatFloat('0.000',I3);
  Edit31.Text:=FormatFloat('0.000',B0); Edit36.Text:=FormatFloat('0.000',I0);

  StaticText1.Caption:=FormatFloat('0.000',B1+B2+B3+B0);
  StaticText2.Caption:=FormatFloat('0.000',I1+I2+I3+I0);
  PintarTotalVencimientos();
end;

//----------------- Ajusta la linea que se va a copiar al historico con los
// valores finales de la ficha, que ya reflejan la seleccion tomada en el
// dialogo de cambio de precio.
procedure TFEntrada.AplicarValoresAceptadosAHistoricoDetalle();
var
  CantidadLinea, CostoUnitario, TotalUnitario: Double;
begin
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+dbPedid.FieldByName('PD6').AsString+'"';
  dbArti.Active:=True;
  if dbArti.RecordCount=0 then
    raise Exception.Create('Articulo no encontrado al guardar historico de detalle: '+dbPedid.FieldByName('PD6').AsString);

  CantidadLinea:=dbPedid.FieldByName('PD8').AsFloat;
  CostoUnitario:=dbArti.FieldByName('A24').AsFloat;
  TotalUnitario:=CostoUnitario+
                 (CostoUnitario*dbArti.FieldByName('A3').AsFloat/100)+
                 (CostoUnitario*dbArti.FieldByName('A36').AsFloat/100);

  if dbTrabajo.FindField('HPD7')<>nil then
    dbTrabajo.FieldByName('HPD7').AsString:=dbArti.FieldByName('A1').AsString;
  if dbTrabajo.FindField('HPD10')<>nil then
    dbTrabajo.FieldByName('HPD10').AsFloat:=dbArti.FieldByName('A24').AsFloat;
  if dbTrabajo.FindField('HPD11')<>nil then
    dbTrabajo.FieldByName('HPD11').AsFloat:=dbArti.FieldByName('A26').AsFloat;
  if dbTrabajo.FindField('HPD12')<>nil then
    dbTrabajo.FieldByName('HPD12').AsFloat:=dbArti.FieldByName('A21').AsFloat;
  if dbTrabajo.FindField('HPD13')<>nil then
    dbTrabajo.FieldByName('HPD13').AsFloat:=dbArti.FieldByName('A36').AsFloat;
  if dbTrabajo.FindField('HPD14')<>nil then
    dbTrabajo.FieldByName('HPD14').AsFloat:=dbArti.FieldByName('A3').AsFloat;
  if dbTrabajo.FindField('HPD15')<>nil then
    dbTrabajo.FieldByName('HPD15').AsFloat:=TotalUnitario;
  if dbTrabajo.FindField('HPD16')<>nil then
    dbTrabajo.FieldByName('HPD16').AsFloat:=dbArti.FieldByName('A2').AsFloat;
  if dbTrabajo.FindField('HPD17')<>nil then
    dbTrabajo.FieldByName('HPD17').AsFloat:=TotalUnitario*CantidadLinea;
  if dbTrabajo.FindField('HPD19')<>nil then
    dbTrabajo.FieldByName('HPD19').Value:=dbArti.FieldByName('A14').Value;
  if dbTrabajo.FindField('HPD26')<>nil then
    dbTrabajo.FieldByName('HPD26').AsFloat:=dbArti.FieldByName('A28').AsFloat;
  if dbTrabajo.FindField('HPD27')<>nil then
    dbTrabajo.FieldByName('HPD27').AsFloat:=dbArti.FieldByName('A29').AsFloat;
  if dbTrabajo.FindField('HPD28')<>nil then
    dbTrabajo.FieldByName('HPD28').AsFloat:=dbArti.FieldByName('A30').AsFloat;
  if dbTrabajo.FindField('HPD29')<>nil then
    dbTrabajo.FieldByName('HPD29').AsFloat:=dbArti.FieldByName('A31').AsFloat;
  if dbTrabajo.FindField('HPD30')<>nil then
    dbTrabajo.FieldByName('HPD30').AsFloat:=dbArti.FieldByName('A37').AsFloat;
end;

//===================== CREAR EL FORMULARIO =====================
procedure ShowFormEntradaPedido(PaTienda,PaFecha,PaProveedor,PaSerie,PaNPedido:String);
begin
  // Evita arrastrar una seleccion anterior si se abre el formulario sin parametros.
  PasaPD0:=0; PasaPD1:=0; PasaPD2:=0; PasaPD3:=''; PasaPD4:=0;

  if PaTienda<>'' then PasaPD0:=StrToInt(PaTienda);
  if PaFecha<>'' then PasaPD1:=StrToDate(PaFecha);
  if PaProveedor<>'' then PasaPD2:=StrToInt(PaProveedor);
  if PaSerie<>'' then PasaPD3:=PaSerie;
  if PaNPedido<>'' then PasaPD4:=StrToInt(PaNPedido);

  MantenerSeleccion:=False; SeleccionAutomatica:= False;

  with TFEntrada.Create(Application) do
    begin
       ShowModal;
    end;
end;
procedure TFEntrada.FormCreate(Sender: TObject);
begin
  FOrdenGrid1:='ASC';
  FMoviendoPanel11:=False;
  FPanel11MovidoPorUsuario:=False;
  FCabeceraPrincipal:=nil;
  FTituloPrincipal:=nil;
  FSubtituloPrincipal:=nil;

  KeyPreview:=True;
  OnShow:=@FormShow;
  OnResize:=@FormResize;
  OnKeyDown:=@FormKeyDown;
  DBGrid1.OnTitleClick:=@DBGrid1TitleClick;

  // Blindaje del botón Adjuntar documento. La versión original lo enlazaba
  // con BitBtn30Click (Aceptar). Se fuerza aquí el manejador correcto para
  // evitar que un recurso LFM antiguo o una asignación heredada reactive
  // accidentalmente la aceptación del pedido.
  BitBtn31.OnClick:=@BitBtn31Click;
  BitBtn31.ModalResult:=mrNone;
  BitBtn31.Default:=False;
  BitBtn31.Cancel:=False;

  CrearCabeceraPrincipal;
  AplicarEstiloModerno;
  RecolocarPaneles;
  ActiveControl:=DBGrid1;

  //--------- Conectar con la bbdd
  //Conectate(dbConnect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //--------- Pedidos
  dbPedic.SQL.Text:='SELECT * FROM pedicc'+Tienda+
                    ' ORDER BY PC0 ASC, PC1 DESC, PC2 ASC, PC3 ASC, PC4 DESC';
  dbPedic.Active:=True;
  if dbPedic.RecordCount=0 then exit;
  //------------ Cargar pedido seleccionado si viene de gestionar
  if PasaPD2<>0 then
    begin
     if dbPedic.Locate('PC0,PC1,PC2,PC3,PC4',VarArrayof([PasaPD0,PasaPD1,PasaPD2,PasaPD3,PasaPD4]),[locaseinsensitive]) then
       BitBtn3Click(BitBtn3);
    end;

end;

//===================== CERRAR FORMULARIO =======================
procedure TFEntrada.BitBtn2Click(Sender: TObject);
begin
  dbPedic.Active:=False;
  dbPedid.Active:=False;
  dbTotales.Active:=False;
  dbArti.Active:=False;
  dbProve.Active:=False;
  dbTrabajo.Active:=False;
  Close();
end;
procedure TFEntrada.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;

//=================== ENTRADA DE PEDIDOS ===================
procedure TFEntrada.BitBtn3Click(Sender: TObject);
var
  TxtQ: String;
  Dias: TDateTime;
begin
  if dbpedic.RecordCount=0 then exit;
  RecolocarPaneles;
  Panel11.Visible:=True; Panel11.BringToFront; DBGrid1.Enabled:=False;
  BitBtn3.Enabled:=False; BitBtn2.Enabled:=False;
  Label50.Caption:=FloatToStr(IVA1)+'%'; Edit25.Text:='0.00'; Edit32.Text:='0.000';
  Label51.Caption:=FloatToStr(IVA2)+'%'; Edit27.Text:='0.00'; Edit33.Text:='0.000';
  Label52.Caption:=FloatToStr(IVA3)+'%'; Edit29.Text:='0.00'; Edit35.Text:='0.000';
  Label53.Caption:='0%'; Edit31.Text:='0.000'; Edit36.Text:='0.000';
  StaticText1.Caption:='0.000'; StaticText2.Caption:='0.000';
  EditOtrosGastos.Text:='0.00';
  //--------------- Datos del pedido ----------
  Label65.Caption:=dbPedic.FieldByName('PC3').AsString+' - '+dbPedic.FieldByName('PC4').AsString;
  Label66.Caption:=FormatDateTime('DD/MM/YYYY',dbPedic.FieldByName('PC1').AsDateTime);
  Label67.Caption:=dbPedic.FieldByName('PC2').AsString+' - '+dbPedic.FieldByName('PC13').AsString;
  //--------------- Datos documento proveedor ----------
  Edit34.Text:=''; DateEdit10.Clear;
  if (dbPedic.FieldByName('PC28').AsString='P') or (dbPedic.FieldByName('PC28').AsString='') then
     RadioButton17.Checked:=True;//- Pedido del proveedor
  if dbPedic.FieldByName('PC28').AsString='N' then
     RadioButton18.Checked:=True;//- Nota del proveedor
  if dbPedic.FieldByName('PC28').AsString='A' then
     RadioButton15.Checked:=True;//- Albaran del proveedor
  if dbPedic.FieldByName('PC28').AsString='F' then
     RadioButton16.Checked:=True;//- Factura del proveedor

  Edit34.Text:=dbPedic.FieldByName('PC29').AsString;//------------- Numero Documento Proveedor
  if dbPedic.FieldByName('PC30').AsString<>'' then
     DateEdit10.Date:=dbPedic.FieldByName('PC30').AsDateTime;//---- Fecha Documento Proveedor
  //------------------ Totales ----------------
  TxtQ:='SELECT DISTINCT(PD14) As TipoIva, (SUM(PD15*PD8)-SUM(PD10*PD8)) As Ivas, '+
        'SUM(PD10*PD8) As Bases, SUM(PD17) As Totales '+
        'FROM pedidd'+Tienda+
        ' WHERE PD0='+dbPedic.Fields[0].AsString+
        ' AND PD1="'+FormatDateTime('yyyy/mm/dd',dbPedic.Fields[1].asDateTime)+'"'+
        ' AND PD2='+dbPedic.Fields[2].AsString+
        ' AND PD3="'+dbPedic.Fields[3].AsString+'"'+
        ' AND PD4='+dbPedic.Fields[4].AsString+
        ' AND PD23="S"';//------------------Solo lineas recibidas, igual que la aceptacion
  TxtQ:=TxtQ+' GROUP BY PD14 ORDER BY PD14 ASC';
  dbTotales.Active:=False;
  dbTotales.SQL.Text:=TxtQ; dbTotales.Active:=True;
  if dbTotales.RecordCount<>0 then
    begin
      if dbTotales.Locate('TipoIva',IVA1,[]) then
        begin
          Edit25.Text:=FormatFloat('0.000',dbTotales.Fields[2].AsFloat);//-------------- Base Imp.
          Edit32.Text:=FormatFloat('0.000',dbTotales.Fields[1].AsFloat);//-------------- Imp. Iva
        end;
      if dbTotales.Locate('TipoIva',IVA2,[]) then
        begin
          Edit27.Text:=FormatFloat('0.000',dbTotales.Fields[2].AsFloat);//-------------- Base Imp.
          Edit33.Text:=FormatFloat('0.000',dbTotales.Fields[1].AsFloat);//-------------- Imp. Iva
        end;
      if dbTotales.Locate('TipoIva',IVA3,[]) then
        begin
          Edit29.Text:=FormatFloat('0.000',dbTotales.Fields[2].AsFloat);//-------------- Base Imp.
          Edit35.Text:=FormatFloat('0.000',dbTotales.Fields[1].AsFloat);//-------------- Imp. Iva
        end;
      if dbTotales.Locate('TipoIva',0,[]) then
        begin
          Edit31.Text:=FormatFloat('0.000',dbTotales.Fields[2].AsFloat);//-------------- Base Imp.
          Edit36.Text:=FormatFloat('0.000',dbTotales.Fields[1].AsFloat);//-------------- Imp. Iva
        end;
    end;
  StaticText1.Caption:=FormatFloat('0.000',TextoAFloat(Edit25.Text)+
                                          TextoAFloat(Edit27.Text)+
                                          TextoAFloat(Edit29.Text)+
                                          TextoAFloat(Edit31.Text));
  StaticText2.Caption:=FormatFloat('0.000',TextoAFloat(Edit32.Text)+
                                          TextoAFloat(Edit33.Text)+
                                          TextoAFloat(Edit35.Text)+
                                          TextoAFloat(Edit36.Text));
  //---------------- Vencimientos -------------
  DateEdit3.Clear; DateEdit4.Clear;
  DateEdit5.Clear; DateEdit6.Clear;
  Label46.Caption:='0.00'; Label47.Caption:=FormatFloat('0.00',TotalPedidoCalculado());
  if dbPedic.FieldByName('PC20').AsString<>'' then
     DateEdit3.Date:=dbPedic.FieldByName('PC20').AsDateTime;
  Edit24.Text:=FormatFloat('0.00',dbPedic.FieldByName('PC21').AsFloat);
  if dbPedic.FieldByName('PC22').AsString<>'' then
     DateEdit4.Date:=dbPedic.FieldByName('PC22').AsDateTime;
  Edit26.Text:=FormatFloat('0.00',dbPedic.FieldByName('PC23').AsFloat);
  if dbPedic.FieldByName('PC24').AsString<>'' then
     DateEdit5.Date:=dbPedic.FieldByName('PC24').AsDateTime;
  Edit28.Text:=FormatFloat('0.00',dbPedic.FieldByName('PC25').AsFloat);
  if dbPedic.FieldByName('PC26').AsString<>'' then
     DateEdit6.Date:=dbPedic.FieldByName('PC26').AsDateTime;
  Edit30.Text:=FormatFloat('0.00',dbPedic.FieldByName('PC27').AsFloat);
  //------------ Suma de vencimientos
  Label46.Caption:=FormatFloat('0.00',dbPedic.FieldByName('PC21').AsFloat+
                                   dbPedic.FieldByName('PC23').AsFloat+
                                   dbPedic.FieldByName('PC25').AsFloat+
                                   dbPedic.FieldByName('PC27').AsFloat);
  //------ Total Pedido costo+impuestos-suma de vencimientos
  Label47.Caption:=FormatFloat('0.00',TotalPedidoCalculado()-TextoAFloat(Label46.Caption));

    //------------ Si no hay vencimientos ver los del proveedor
  if (DateEdit3.Text='') and (DateEdit4.Text='') and (DateEdit5.Text='') and (DateEdit6.Text='') then
    begin
      CargarProveedorActual();
      if dbProve.RecordCount=0 then begin showmessage('NO EXISTE ESE PROVEEDOR???'); exit; end;
      if dbProve.FieldByName('P15').AsInteger<>0 then
        begin
          VerVencimientos();
          PintarTotalVencimientos();
        end;
    end;
end;

//--------------- Aceptar entrada de pedido ----------------
procedure TFEntrada.BitBtn30Click(Sender: TObject);
var
  TxtQ: String;
  HayTransaccion: Boolean;
  HistPreciosOK: Boolean;
  AvisoHistPrecios: String;
  OldA2, OldA21, OldA24, OldDesc, OldCodArt, MotivoHist: String;
begin
  ProgressBar1.Position:=0; ProgressBar1.Caption:='0';
  HistPreciosOK:=True;
  AvisoHistPrecios:='';
  NormalizarImportesVencimientos();
  PintarTotalVencimientos();

  if Application.MessageBox('DAR ENTRADA AL PEDIDO SELECCIONADO?','FacturLinEx', boxstyle) = IDNO Then
      begin
        Panel1.Visible:=False; Panel11.Visible:=False;
        DBGrid1.Enabled:=True; BitBtn3.Enabled:=True; BitBtn2.Enabled:=True;
        exit;
      end;

  TxtQ:='SELECT * FROM pedidd'+Tienda+' WHERE PD0='+dbPedic.Fields[0].AsString+
        ' AND PD1="'+FormatDateTime('yyyy/mm/dd',dbPedic.Fields[1].asDateTime)+'"'+
        ' AND PD2='+dbPedic.Fields[2].AsString+
        ' AND PD3="'+dbPedic.Fields[3].AsString+'"'+
        ' AND PD4='+dbPedic.Fields[4].AsString+
        ' AND PD23="S"';//------------------Solo las lineas recibidas
  dbPedid.Active:=False;
  dbPedid.SQL.Text:=TxtQ; dbPedid.Active:=True;
  if dbPedid.RecordCount=0 then
     begin
       showmessage('ESTE PEDIDO NO TIENE LINEAS PARA ACEPTAR!');
       Panel1.Visible:=False; Panel11.Visible:=False;
       DBGrid1.Enabled:=True; BitBtn3.Enabled:=True; BitBtn2.Enabled:=True;
       exit;
     end;

  // Seguridad: esta unidad borra el pedido completo al final. Si quedara alguna
  // linea no marcada como recibida, se perderia. Mejor abortar antes de tocar nada.
  TxtQ:='SELECT COUNT(*) AS Pendientes FROM pedidd'+Tienda+
        ' WHERE PD0='+dbPedic.Fields[0].AsString+
        ' AND PD1="'+FormatDateTime('yyyy/mm/dd',dbPedic.Fields[1].asDateTime)+'"'+
        ' AND PD2='+dbPedic.Fields[2].AsString+
        ' AND PD3="'+dbPedic.Fields[3].AsString+'"'+
        ' AND PD4='+dbPedic.Fields[4].AsString+
        ' AND (PD23<>"S" OR PD23 IS NULL)';
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.Active:=True;
  if dbTrabajo.FieldByName('Pendientes').AsInteger>0 then
    begin
      showmessage('NO SE PUEDE ACEPTAR EL PEDIDO COMPLETO: HAY LINEAS NO RECIBIDAS. Revise las lineas antes de aceptar, porque este proceso borra el pedido original al terminar.');
      Panel1.Visible:=False; Panel11.Visible:=False;
      DBGrid1.Enabled:=True; BitBtn3.Enabled:=True; BitBtn2.Enabled:=True;
      exit;
    end;

  // Validacion previa: todos los articulos deben existir antes de actualizar stock,
  // estadisticas, historicos y proveedor.
  dbPedid.First;
  while not dbPedid.EOF do
    begin
      dbArti.Active:=False;
      dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+dbPedid.FieldByName('PD6').AsString+'"';
      dbArti.Active:=True;
      if dbArti.RecordCount=0 then
        begin
          showmessage('NO SE PUEDE ACEPTAR: el articulo '+dbPedid.FieldByName('PD6').AsString+' no existe en la ficha.');
          Panel1.Visible:=False; Panel11.Visible:=False;
          DBGrid1.Enabled:=True; BitBtn3.Enabled:=True; BitBtn2.Enabled:=True;
          exit;
        end;
      dbPedid.Next;
    end;

  // El historico de precios se prepara antes de abrir la transaccion.
  // En MariaDB un CREATE TABLE puede hacer commit implicito; por eso no se
  // mezcla con la aceptacion del pedido.
  try
    EnsureHistPreciosTable;
  except
    on E: Exception do
      begin
        HistPreciosOK:=False;
        AvisoHistPrecios:=E.Message;
      end;
  end;

  HayTransaccion:=False;
  Panel11.Visible:=False; DBGrid1.Repaint;
  RecolocarPaneles;
  Panel1.Visible:=True; Panel1.BringToFront; Panel1.Repaint;
  DBGrid1.Enabled:=False; BitBtn3.Enabled:=False; BitBtn2.Enabled:=False;

  try
    if (dbTrabajo.Connection<>nil) and (not dbTrabajo.Connection.InTransaction) then
      begin
        dbTrabajo.Connection.StartTransaction;
        HayTransaccion:=True;
      end;

    dbPedid.First; ProgressBar1.Max:=dbPedid.RecordCount;
    while not dbPedid.EOF do
      begin
        dbArti.Active:=False;
        dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+dbPedid.FieldByName('PD6').AsString+'"';
        dbArti.Active:=True;
        if dbArti.RecordCount=0 then
          raise Exception.Create('Articulo no encontrado al aceptar: '+dbPedid.FieldByName('PD6').AsString);

        OldCodArt:=dbArti.FieldByName('A0').AsString;
        OldDesc:=dbArti.FieldByName('A1').AsString;
        OldA2:=dbArti.FieldByName('A2').AsString;
        OldA21:=dbArti.FieldByName('A21').AsString;
        OldA24:=dbArti.FieldByName('A24').AsString;

        PreciohaCambiado:=False;
        PintaLineas();//------------ Pintar las lineas conforme se acepta el pedido
        if PreciohaCambiado=True then
           begin
             ShowCambioPrecio(dbPedid.FieldByName('PD0').Value,
                              dbPedid.FieldByName('PD2').Value,
                              dbPedid.FieldByName('PD4').Value,
                              dbPedid.FieldByName('PD5').Value,
                              dbPedid.FieldByName('PD1').Value,
                              dbPedid.FieldByName('PD6').Value,
                              dbPedid.FieldByName('PD3').Value);
           end;

        LeerDatosArticulo();//------ Consultar los datos finales del articulo tras la decision del dialogo
        if dbArti.RecordCount=0 then
          raise Exception.Create('Articulo no encontrado despues del cambio de precio: '+dbPedid.FieldByName('PD6').AsString);

        if HistPreciosOK then
        begin
          try
            MotivoHist:='Entrada/aceptacion de pedido proveedor '+dbPedic.FieldByName('PC2').AsString+
                        ' serie '+dbPedic.FieldByName('PC3').AsString+
                        ' numero '+dbPedic.FieldByName('PC4').AsString;
            RegistrarCambioPrecioPedido(OldCodArt, OldDesc, 'A2 PVP con IVA', OldA2, dbArti.FieldByName('A2').AsString, MotivoHist);
            RegistrarCambioPrecioPedido(OldCodArt, OldDesc, 'A21 PVP sin IVA', OldA21, dbArti.FieldByName('A21').AsString, MotivoHist);
            RegistrarCambioPrecioPedido(OldCodArt, OldDesc, 'A24 coste', OldA24, dbArti.FieldByName('A24').AsString, MotivoHist);
          except
            on E: Exception do
              begin
                HistPreciosOK:=False;
                AvisoHistPrecios:=E.Message;
              end;
          end;
        end;

        ActuArticulos();//---------- Actualizar Articulos
        ActuEstaArti();//----------- Estadistica de articulos
        ActuUltimoPedi();//--------- Ultimo pedido
        ActuEstaTiendas();//-------- Estadistica de Tienda
        ActuFamilia();//------------ Familias y estadistica
        ActuDeparta();//------------ Departamentos y estadistica
        ActuEstaProveedor();//------ Estadistica de Proveedor

        dbPedid.Next;
        ProgressBar1.Position:=ProgressBar1.Position+1;
        ProgressBar1.Caption:=IntToStr(ProgressBar1.Position); ProgressBar1.Repaint;
      end;

    ActuProveedor();//---------- Proveedor
    ActuTiendas();//------------ Tienda
    RecalcularTotalesSegunSeleccionAceptada();//-- Totales finales segun decision linea a linea
    ActuHistocc();//------------ Hist. pedidos cabeceras
    ActuHistodd();//------------ Hist. pedidos detalles
    BorrarPedido();//----------- Borrar pedido

    if HayTransaccion then
      dbTrabajo.Connection.Commit;
    if AvisoHistPrecios<>'' then
      Showmessage('PEDIDO ACEPTADO CORRECTAMENTE, pero no se pudo registrar el historico de precios: '+AvisoHistPrecios)
    else
      Showmessage('PEDIDO ACEPTADO CORRECTAMENTE!');
  except
    on E: Exception do
      begin
        if HayTransaccion and (dbTrabajo.Connection<>nil) and dbTrabajo.Connection.InTransaction then
          dbTrabajo.Connection.Rollback;
        ShowMessage('NO SE HA PODIDO ACEPTAR EL PEDIDO: '+E.Message);
      end;
  end;

  Panel1.Visible:=False; Panel11.Visible:=False;
  DBGrid1.Enabled:=True;
  BitBtn3.Enabled:=True; BitBtn2.Enabled:=True;
end;

//--------------- Adjuntar documento -------------------------
// En la versión original este botón estaba conectado por error al mismo
// evento que Aceptar. Esta unidad no contiene todavía almacenamiento,
// selector de fichero ni campo de BBDD para asociar documentos al pedido.
// Se evita cualquier acción destructiva hasta implementar el sistema de
// adjuntos de forma completa y coherente.
procedure TFEntrada.BitBtn31Click(Sender: TObject);
begin
  ShowMessage('La función Adjuntar documento todavía no está implementada en este formulario.'+
              LineEnding+LineEnding+
              'No se ha aceptado ni modificado el pedido.');
end;

//--------------- Salir entrada de pedidos -----------------
procedure TFEntrada.BitBtn29Click(Sender: TObject);
begin
  Panel11.Visible:=False; DBGrid1.Enabled:=True;
  BitBtn3.Enabled:=True; BitBtn2.Enabled:=True;
end;

//=============================================================================
//======================== ACTUALIZAR LINEAS ==================================
//=============================================================================
//---------------- Articulos (ya esta seleccionado el articulo)
procedure TFEntrada.ActuArticulos();
begin
 dbArti.Edit;
 dbArti.FieldByName('A4').Value:=dbArti.FieldByName('A4').AsFloat+
                                 dbPedid.FieldByName('PD8').AsFloat;//----- Sumar Stock
 dbArti.FieldByName('A4').Value:=dbArti.FieldByName('A4').AsFloat+
                                 dbPedid.FieldByName('PD8B').AsFloat;//----- Sumar Stock con Unidades Bonificadas
 dbArti.FieldByName('A11').Value:=dbArti.FieldByName('A11').AsFloat-
                                 dbPedid.FieldByName('PD8').AsFloat;//----- Restar Und. Pendientes
 dbArti.FieldByName('A13').Value:=dbPedic.FieldByName('PC1').Value;//------ Fecha Ult. Compra
 dbArti.FieldByName('A28').Value:=dbPedid.FieldByName('PD26').AsFloat;//--- Precio Tarifa
 dbArti.FieldByName('A29').Value:=dbPedid.FieldByName('PD27').AsFloat;//--- Dto. Importe
 dbArti.FieldByName('A30').Value:=dbPedid.FieldByName('PD28').AsFloat;//--- Dto %1
 dbArti.FieldByName('A31').Value:=dbPedid.FieldByName('PD29').AsFloat;//--- Dto %2
 dbArti.FieldByName('A32').Value:=dbPedic.FieldByName('PC2').Value;//------ Cgo. ultimo proveedor
 dbArti.FieldByName('A37').Value:=dbPedid.FieldByName('PD30').AsFloat;//--- Margen sobre PVP
 // Familia: trasladar desde la linea del pedido solo si viene informada.
 // Evita borrar la familia existente por una PD19 vacia en pedidos antiguos.
 if (dbPedid.FindField('PD19')<>nil) and
    (Trim(dbPedid.FieldByName('PD19').AsString)<>'') and
    (Trim(dbPedid.FieldByName('PD19').AsString)<>'0') then
   dbArti.FieldByName('A14').Value:=dbPedid.FieldByName('PD19').Value;
 dbArti.Post;
end;
//---------------- Estadistica de articulos
procedure TFEntrada.ActuEstaArti();
var
  TxtQ: String;
begin
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * from estaarti'+Tienda+' WHERE TA0="'+Codigo+'"'+
                     ' AND TA1='+FormatDateTime('YYYY',dbPedid.FieldByName('PD1').AsDateTime)+' AND TA2='+FormatDateTime('MM',dbPedid.FieldByName('PD1').AsDateTime);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estaarti'+Tienda+' SET TA3=TA3+'+Cantidad+
          ', TA4=TA4+'+Costo+' WHERE TA0="'+Codigo+'"'+
          ' AND TA1='+FormatDateTime('YYYY',dbPedid.FieldByName('PD1').AsDateTime)+' AND TA2='+FormatDateTime('MM',dbPedid.FieldByName('PD1').AsDateTime)
  else
    TxtQ:='INSERT INTO estaarti'+Tienda+' (TA0,TA1,TA2,TA3,TA4) VALUES ("'+
          Codigo+'",'+FormatDateTime('YYYY',dbPedid.FieldByName('PD1').AsDateTime)+','+FormatDateTime('MM',dbPedid.FieldByName('PD1').AsDateTime)+
          ','+Cantidad+','+Costo+')';
  dbTrabajo.Active:=False; dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
end;
//---------------- Ultimo pedido
procedure TFEntrada.ActuUltimoPedi();
var
  TxtQ: String;
begin
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * from ultimopedi'+Tienda+' WHERE AP0="'+Codigo+'"'+
                     ' AND AP1="'+FormatDateTime('YYYY/MM/DD',dbPedid.FieldByName('PD1').Value)+'"';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE ultimopedi'+Tienda+' SET AP3='+Cantidad+
          ', AP4='+SQLFloat(dbArti.FieldByName('A24').AsFloat)+' WHERE AP0="'+Codigo+'"'+
          ' AND AP1="'+FormatDateTime('YYYY/MM/DD',dbPedid.FieldByName('PD1').Value)+'"'
  else
    TxtQ:='INSERT INTO ultimopedi'+Tienda+' (AP0,AP1,AP2,AP3,AP4) VALUES ("'+
          Codigo+'","'+FormatDateTime('YYYY/MM/DD',dbPedid.FieldByName('PD1').Value)+'",'+
          dbPedid.FieldByName('PD2').AsString+','+Cantidad+','+
          SQLFloat(dbArti.FieldByName('A24').AsFloat)+')';
  dbTrabajo.Active:=False; dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
end;

//---------------- Tienda y estadisticas tienda
procedure TFEntrada.ActuTiendas();
var
  TxtQ: String;
begin
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * from tiendas WHERE T0='+NTienda;
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
   begin
    TxtQ:='UPDATE tiendas SET T10="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('PC1').Value)+'"'+
          ' WHERE T0='+NTienda;
    dbTrabajo.Active:=False; dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
   end;
end;
//---------------- Estadistica de tienda
procedure TFEntrada.ActuEstaTiendas();
var
  TxtQ: String;
begin
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * from estatien'+Tienda+' WHERE TT0='+NTienda+
                     ' AND TT1='+FormatDateTime('YYYY',dbPedid.FieldByName('PD1').AsDateTime)+' AND TT2='+FormatDateTime('MM',dbPedid.FieldByName('PD1').AsDateTime);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estatien'+Tienda+' SET TT3=TT3+'+Cantidad+
          ', TT4=TT4+'+Costo+' WHERE TT0='+NTienda+
          ' AND TT1='+FormatDateTime('YYYY',dbPedid.FieldByName('PD1').AsDateTime)+' AND TT2='+FormatDateTime('MM',dbPedid.FieldByName('PD1').AsDateTime)
  else
    TxtQ:='INSERT INTO estatien'+Tienda+' (TT0,TT1,TT2,TT3,TT4) VALUES ('+
          NTienda+','+FormatDateTime('YYYY',dbPedid.FieldByName('PD1').AsDateTime)+','+FormatDateTime('MM',dbPedid.FieldByName('PD1').AsDateTime)+
          ','+Cantidad+','+Costo+')';
  dbTrabajo.Active:=False; dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
end;

//---------------- Familias y estadisticas
procedure TFEntrada.ActuFamilia();
var
  TxtQ: String;
begin
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * from familias'+Tienda+' WHERE F0='+dbArti.FieldByName('A14').AsString;
  dbTrabajo.Active:=True; Departa:='';
  if dbTrabajo.RecordCount<>0 then
   begin
    Departa:=dbTrabajo.FieldByName('F2').AsString;//---- Guardo el departamento
    TxtQ:='UPDATE familias'+Tienda+' SET F4="'+FormatDateTime('YYYY/MM/DD',dbPedid.FieldByName('PD1').Value)+'"'+
          ' WHERE F0='+dbArti.FieldByName('A14').AsString;
    dbTrabajo.Active:=False; dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
   end;
  //---------- estadistica
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * from estafami'+Tienda+' WHERE FF0='+dbArti.FieldByName('A14').AsString+
                     ' AND FF1='+FormatDateTime('YYYY',dbPedid.FieldByName('PD1').AsDateTime)+' AND FF2='+FormatDateTime('MM',dbPedid.FieldByName('PD1').AsDateTime);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estafami'+Tienda+' SET FF3=FF3+'+Cantidad+
          ', FF4=FF4+'+Costo+' WHERE FF0='+dbArti.FieldByName('A14').AsString+
          ' AND FF1='+FormatDateTime('YYYY',dbPedid.FieldByName('PD1').AsDateTime)+' AND FF2='+FormatDateTime('MM',dbPedid.FieldByName('PD1').AsDateTime)
  else
    TxtQ:='INSERT INTO estafami'+Tienda+' (FF0,FF1,FF2,FF3,FF4) VALUES ('+
          dbArti.FieldByName('A14').AsString+','+FormatDateTime('YYYY',dbPedid.FieldByName('PD1').AsDateTime)+','+
          FormatDateTime('MM',dbPedid.FieldByName('PD1').AsDateTime)+','+Cantidad+','+Costo+')';
  dbTrabajo.Active:=False; dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
end;

//---------------- Departamentos y estadisticas
procedure TFEntrada.ActuDeparta();
var
  TxtQ: String;
begin
  if Departa='' then exit;
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * from departamentos'+Tienda+' WHERE D0='+Departa;
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
   begin
    TxtQ:='UPDATE departamentos'+Tienda+' SET D3="'+FormatDateTime('YYYY/MM/DD',dbPedid.FieldByName('PD1').Value)+'"'+
          ' WHERE D0='+Departa;
    dbTrabajo.Active:=False; dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
   end;
  //---------- estadistica
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * from estadepa'+Tienda+' WHERE DD0='+Departa+
                     ' AND DD1='+FormatDateTime('YYYY',dbPedid.FieldByName('PD1').AsDateTime)+' AND DD2='+FormatDateTime('MM',dbPedid.FieldByName('PD1').AsDateTime);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estadepa'+Tienda+' SET DD3=DD3+'+Cantidad+
          ', DD4=DD4+'+Costo+' WHERE DD0='+Departa+
          ' AND DD1='+FormatDateTime('YYYY',dbPedid.FieldByName('PD1').AsDateTime)+' AND DD2='+FormatDateTime('MM',dbPedid.FieldByName('PD1').AsDateTime)
  else
    TxtQ:='INSERT INTO estadepa'+Tienda+' (DD0,DD1,DD2,DD3,DD4) VALUES ('+
          Departa+','+FormatDateTime('YYYY',dbPedid.FieldByName('PD1').AsDateTime)+','+FormatDateTime('MM',dbPedid.FieldByName('PD1').AsDateTime)+
          ','+Cantidad+','+Costo+')';
  dbTrabajo.Active:=False; dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
end;

//---------------- Proveedor
procedure TFEntrada.ActuProveedor();
var
  TxtQ: String;
begin
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * from proveedores WHERE P0='+dbPedic.FieldByName('PC2').AsString;
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
   begin
    TxtQ:='UPDATE proveedores SET P23="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('PC1').Value)+'"'+
          ' WHERE P0='+dbPedic.FieldByName('PC2').AsString;
    dbTrabajo.Active:=False; dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
   end;
end;
//---------------- Proveedor Estadisticas
procedure TFEntrada.ActuEstaProveedor();
var
  TxtQ: String;
begin
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * from estaprove WHERE PP0='+dbPedid.FieldByName('PD2').AsString+
                     ' AND PP1='+FormatDateTime('YYYY',dbPedid.FieldByName('PD1').AsDateTime)+' AND PP2='+FormatDateTime('MM',dbPedid.FieldByName('PD1').AsDateTime);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estaprove SET PP3=PP3+'+Cantidad+
          ', PP4=PP4+'+Costo+' WHERE PP0='+dbPedid.FieldByName('PD2').AsString+
          ' AND PP1='+FormatDateTime('YYYY',dbPedid.FieldByName('PD1').AsDateTime)+' AND PP2='+FormatDateTime('MM',dbPedid.FieldByName('PD1').AsDateTime)
  else
    TxtQ:='INSERT INTO estaprove (PP0,PP1,PP2,PP3,PP4) VALUES ('+
          dbPedid.FieldByName('PD2').AsString+','+FormatDateTime('YYYY',dbPedid.FieldByName('PD1').AsDateTime)+','+
          FormatDateTime('MM',dbPedid.FieldByName('PD1').AsDateTime)+','+Cantidad+','+Costo+')';
  dbTrabajo.Active:=False; dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
end;

//------------------- Historico de pedidos cabeceras
procedure TFEntrada.ActuHistocc();
var
  TxtQ, Tabla: String;
  Conta: Integer;
begin
  //----------- Si es factura a la tabla de facturas de proveedor
  Tabla:='hipedicc';
  if RadioButton16.Checked=true then Tabla:='hipedifacc';
  //-------------------------------------------------------------
  TxtQ:='SELECT * FROM '+Tabla+Tienda+' WHERE HPC0='+dbPedic.Fields[0].AsString+
        ' AND HPC1="'+FormatDateTime('yyyy/mm/dd',dbPedic.Fields[1].asDateTime)+'"'+
        ' AND HPC2='+dbPedic.Fields[2].AsString+
        ' AND HPC3="'+dbPedic.Fields[3].AsString+'"'+
        ' AND HPC4='+dbPedic.Fields[4].AsString;
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    raise Exception.Create('ESE PEDIDO YA EXISTE EN EL HISTORICO');

  dbTrabajo.Append;
  for conta:=0 to 27 do
    dbTrabajo.Fields[Conta].Value:=dbPedic.Fields[Conta].Value;

  // Guardamos la cabecera con el mismo total que se muestra y se acepta.
  // PC8 queda solo como valor historico de origen; si venia descuadrado no se arrastra.
  if dbTrabajo.FindField('HPC8')<>nil then
    dbTrabajo.FieldByName('HPC8').AsFloat:=TotalPedidoCalculado();

  //------- Vencimientos
  AsignarFechaOClear(dbTrabajo.FieldByName('HPC20'),DateEdit3);//------- Fecha 1 Vencimiento
  dbTrabajo.FieldByName('HPC21').AsFloat:=TextoAFloat(Edit24.Text);//---- Importe 1 Vencimiento
  AsignarFechaOClear(dbTrabajo.FieldByName('HPC22'),DateEdit4);//------- Fecha 2 Vencimiento
  dbTrabajo.FieldByName('HPC23').AsFloat:=TextoAFloat(Edit26.Text);//---- Importe 2 Vencimiento
  AsignarFechaOClear(dbTrabajo.FieldByName('HPC24'),DateEdit5);//------- Fecha 3 Vencimiento
  dbTrabajo.FieldByName('HPC25').AsFloat:=TextoAFloat(Edit28.Text);//---- Importe 3 Vencimiento
  AsignarFechaOClear(dbTrabajo.FieldByName('HPC26'),DateEdit6);//------- Fecha 4 Vencimiento
  dbTrabajo.FieldByName('HPC27').AsFloat:=TextoAFloat(Edit30.Text);//---- Importe 4 Vencimiento
  //---- Tipo documento prov.
  if RadioButton17.Checked=true then
   dbTrabajo.FieldByName('HPC28').AsString:='P';//--- Pedido
  if RadioButton18.Checked=true then
   dbTrabajo.FieldByName('HPC28').AsString:='N';//--- Nota
  if RadioButton15.Checked=true then
   dbTrabajo.FieldByName('HPC28').AsString:='A';//--- Albaran
  if RadioButton16.Checked=true then
   dbTrabajo.FieldByName('HPC28').AsString:='F';//--- Factura
  dbTrabajo.FieldByName('HPC29').AsString:=Edit34.Text;//---- N.Documento
  AsignarFechaOClear(dbTrabajo.FieldByName('HPC30'),DateEdit10);//--- Fecha documento proveedor
  dbTrabajo.FieldByName('HPC31').AsFloat:=TextoAFloat(Edit25.Text);//---- Base Imp. 1
  dbTrabajo.FieldByName('HPC32').AsFloat:=TextoAFloat(Edit32.Text);//---- Importe IVA 1
  dbTrabajo.FieldByName('HPC33').AsFloat:=TextoAFloat(Edit27.Text);//---- Base Imp. 2
  dbTrabajo.FieldByName('HPC34').AsFloat:=TextoAFloat(Edit33.Text);//---- Importe IVA 2
  dbTrabajo.FieldByName('HPC35').AsFloat:=TextoAFloat(Edit29.Text);//---- Base Imp. 3
  dbTrabajo.FieldByName('HPC36').AsFloat:=TextoAFloat(Edit35.Text);//---- Importe IVA 3
  dbTrabajo.FieldByName('HPC37').AsFloat:=TextoAFloat(Edit31.Text);//---- Base Imp. 4
  dbTrabajo.FieldByName('HPC38').AsFloat:=TextoAFloat(Edit36.Text);//---- Importe IVA 4
  dbTrabajo.FieldByName('HPC43').Value:=dbPedic.FieldByName('PC31').Value;//- Observaciones
  dbTrabajo.FieldByName('HPC44').AsFloat:=TextoAFloat(EditOtrosGastos.Text);//---- Importe otros gastos
  if (dbTrabajo.FindField('HPC45')<>nil) and (dbPedic.FieldCount>32) then
    dbTrabajo.FieldByName('HPC45').AsString:=dbPedic.Fields[32].AsString;//---- Codigo pedido Tienda Virtual
  dbTrabajo.Post;
end;

//------------------- Historico de pedidos detalles
procedure TFEntrada.ActuHistodd();
var
  TxtQ, Tabla: String;
  Conta: Integer;
begin
  //----------- Si es factura a la tabla de facturas de proveedor
  Tabla:='hipedidd';
  if RadioButton16.Checked=true then Tabla:='hipedifadd';
  //-------------------------------------------------------------
  TxtQ:='SELECT * FROM '+Tabla+Tienda+' WHERE HPD0='+dbPedic.Fields[0].AsString+
        ' AND HPD1="'+FormatDateTime('yyyy/mm/dd',dbPedic.Fields[1].asDateTime)+'"'+
        ' AND HPD2='+dbPedic.Fields[2].AsString+
        ' AND HPD3="'+dbPedic.Fields[3].AsString+'"'+
        ' AND HPD4='+dbPedic.Fields[4].AsString;
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    raise Exception.Create('ESE PEDIDO YA EXISTE EN EL HISTORICO');
  dbPedid.First;
  while not dbPedid.EOF do
    begin
      dbTrabajo.Append;
      for conta:=0 to 30 do
        dbTrabajo.Fields[Conta].Value:=dbPedid.Fields[Conta].Value;
      AplicarValoresAceptadosAHistoricoDetalle();
//-- Linea que transfiere a Historico el valor de las unidades Bonificadas - Jose -
      dbTrabajo.FieldByName('HPD8B').Value:=dbPedid.FieldByName('PD8B').Value;
      dbTrabajo.Post;
      dbPedid.Next;
    end;
end;

//====================== BORRAR PEDIDO ACEPTADO ========================
procedure TFEntrada.BorrarPedido();
var
  TxtQ: String;
begin
  //-------------- Cabeceras
  TxtQ:='DELETE FROM pedicc'+Tienda+' WHERE PC0='+dbPedic.Fields[0].AsString+
        ' AND PC1="'+FormatDateTime('yyyy/mm/dd',dbPedic.Fields[1].asDateTime)+'"'+
        ' AND PC2='+dbPedic.Fields[2].AsString+
        ' AND PC3="'+dbPedic.Fields[3].AsString+'"'+
        ' AND PC4='+dbPedic.Fields[4].AsString;
  dbTrabajo.Active:=False; dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  //-------------- Detalles
  TxtQ:='DELETE FROM pedidd'+Tienda+' WHERE PD0='+dbPedic.Fields[0].AsString+
        ' AND PD1="'+FormatDateTime('yyyy/mm/dd',dbPedic.Fields[1].asDateTime)+'"'+
        ' AND PD2='+dbPedic.Fields[2].AsString+
        ' AND PD3="'+dbPedic.Fields[3].AsString+'"'+
        ' AND PD4='+dbPedic.Fields[4].AsString;
  dbTrabajo.Active:=False; dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  dbPedic.Refresh;
end;

//===================================================================================
//==================== Consultar los nuevos datos del articulo que vienen de cambio
procedure TFEntrada.LeerDatosArticulo();
begin
  // IMPORTANTE:
  // No se debe calcular la estadistica directamente desde PD10/PD12,
  // porque al aceptar la entrada el formulario de cambio de precio permite
  // decidir linea a linea si se usan los valores nuevos del pedido o si se
  // conservan los de la ficha del articulo.
  //
  // Esa decision queda reflejada en la ficha artitien: si se aceptan los
  // valores del pedido, ShowCambioPrecio actualiza A24/A21; si se conserva
  // la ficha, A24/A21 quedan como estaban. Por eso recargamos siempre el
  // articulo despues del dialogo y usamos esos valores finales.
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+dbPedid.FieldByName('PD6').AsString+'"';
  dbArti.Active:=True;

  Codigo:=dbPedid.FieldByName('PD6').AsString;//-------- Cgo Articulo
  Cantidad:=SQLFloat(dbPedid.FieldByName('PD8').AsFloat);//------ Unidades
  Precio:=SQLFloat(dbPedid.FieldByName('PD8').AsFloat*dbArti.FieldByName('A21').AsFloat);//-- Importe de la linea sin iva segun valor final aceptado
  Costo:=SQLFloat(dbPedid.FieldByName('PD8').AsFloat*dbArti.FieldByName('A24').AsFloat);//--- Costo de la linea sin iva segun valor final aceptado
end;


//======================= PINTAR LINEAS DEL PEDIDO AL ACEPTARLAS ==============
procedure TFEntrada.PintaLineas();
begin
  StaticText4.Color:=clBtnFace; StaticText12.Color:=clBtnFace; StaticText13.Color:=clBtnFace;
  StaticText14.Color:=clBtnFace; StaticText15.Color:=clBtnFace;
  StaticText16.Color:=clBtnFace; StaticText17.Color:=clBtnFace;
  StaticText12.Font.Color:=clBlack; StaticText13.Font.Color:=clBlack;
  StaticText14.Font.Color:=clBlack; StaticText15.Font.Color:=clBlack;
  StaticText16.Font.Color:=clBlack; StaticText17.Font.Color:=clBlack;
  StaticText12.Repaint; StaticText13.Repaint; StaticText14.Repaint;
  StaticText15.Repaint; StaticText16.Repaint; StaticText17.Repaint;
  //-----------------------
  StaticText3.Caption:=dbPedid.FieldByName('PD6').AsString;//---- Código
  StaticText3.Repaint;
  StaticText4.Caption:=dbPedid.FieldByName('PD7').AsString;//---- Descripcion
  if StaticText4.Caption<> dbArti.FieldByName('A1').AsString then
    begin StaticText4.Color:=$00C5C5F7; PreciohaCambiado:=True; end;;
  StaticText4.Repaint;
  StaticText5.Caption:=FormatFloat('0.00',dbPedid.FieldByName('PD8').AsFloat);//---- Unidades
  StaticText5.Repaint;
  //-----------------------
  StaticText6.Caption:=FormatFloat('0.000',dbPedid.FieldByName('PD10').AsFloat);//---- Costo Pedido
  StaticText12.Caption:=FormatFloat('0.000',dbArti.FieldByName('A24').AsFloat);//----- Costo Articulo
  if (StaticText6.Caption<>StaticText12.Caption) or (StaticText6.Caption='0.000') then
     begin StaticText12.Color:=$00C5C5F7; PreciohaCambiado:=True; end;
  StaticText6.Repaint; StaticText12.Repaint;

  StaticText7.Caption:=FormatFloat('0.00',dbPedid.FieldByName('PD11').AsFloat);//---- Margen Pedido
  StaticText13.Caption:=FormatFloat('0.00',dbArti.FieldByName('A26').AsFloat);//----- Margen Articulo
  if StaticText7.Caption<>StaticText13.Caption then
     begin StaticText13.Color:=$00C5C5F7; PreciohaCambiado:=True; end;
  StaticText7.Repaint; StaticText13.Repaint;

  StaticText8.Caption:=FormatFloat('0.000',dbPedid.FieldByName('PD12').AsFloat);//---- Precio Pedido
  StaticText14.Caption:=FormatFloat('0.000',dbArti.FieldByName('A21').AsFloat);//----- Precio Articulo
  if StaticText8.Caption<>StaticText14.Caption then
     begin StaticText14.Color:=$00C5C5F7; PreciohaCambiado:=True; end;
  StaticText8.Repaint; StaticText14.Repaint;

  StaticText9.Caption:=IntToStr(dbPedid.FieldByName('PD14').AsInteger);//---- % Iva Pedido
  StaticText15.Caption:=IntToStr(dbArti.FieldByName('A3').AsInteger);//------ % Iva Articulo
  if StaticText9.Caption<>StaticText15.Caption then
     begin StaticText15.Color:=$00C5C5F7; PreciohaCambiado:=True; end;
  StaticText9.Repaint; StaticText15.Repaint;

  StaticText10.Caption:=IntToStr(dbPedid.FieldByName('PD13').AsInteger);//---- % Rec Pedido
  StaticText16.Caption:=IntToStr(dbArti.FieldByName('A36').AsInteger);//------- % Rec Articulo
  if StaticText10.Caption<>StaticText16.Caption then
     begin StaticText16.Color:=$00C5C5F7; PreciohaCambiado:=True; end;
  StaticText10.Repaint; StaticText16.Repaint;


  StaticText11.Caption:=FormatFloat('0.00',dbPedid.FieldByName('PD16').AsFloat);//---- P.V.P. Pedido
  StaticText17.Caption:=FormatFloat('0.00',dbArti.FieldByName('A2').AsFloat);//------- P.V.P. Articulo
  if StaticText11.Caption<>StaticText17.Caption then
     begin StaticText17.Color:=$00C5C5F7; PreciohaCambiado:=True; end;
  StaticText11.Repaint; StaticText17.Repaint;

end;


//============= MOSTRAR DATOS DEL PEDIDO AL MOVERSE POR EL GRID ========
procedure TFEntrada.Datasource1DataChange(Sender: TObject; Field: TField);
begin
  Panel10.Visible:=False;
  LabelCliente.Caption:=''; LabelCliente1.Caption:='';
  LabelCliente2.Caption:=''; LabelCliente3.Caption:='';
  if dbPedic.FieldByName('PC15').AsString='' then exit;
  LabelCliente1.Caption:=dbPedic.FieldByName('PC14').AsString;//---- Codigo cliente
  LabelCliente.Caption:=dbPedic.FieldByName('PC15').AsString;//----- Nombre cliente
  LabelCliente2.Caption:=dbPedic.FieldByName('PC16').AsString;//---- Telefono cliente
  LabelCliente3.Caption:=dbPedic.FieldByName('PC18').AsString;//---- Importe entregado
  Panel10.Visible:=True;
end;

//------------ Pintar Linea en azul si es pedido de clientes ----
procedure TFEntrada.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  S: String;
  X, Y, AnchoTexto: Integer;
begin
  // La selección debe ser siempre legible: azul con texto blanco.
  if gdSelected in State then
  begin
    DBGrid1.Canvas.Brush.Color:=RGBToColor(42,86,132);
    DBGrid1.Canvas.Font.Color:=clWhite;
    DBGrid1.Canvas.FillRect(Rect);

    if (Column<>nil) and (Column.Field<>nil) then
      S:=Column.Field.DisplayText
    else
      S:='';

    AnchoTexto:=DBGrid1.Canvas.TextWidth(S);
    X:=Rect.Left+4;
    if Column<>nil then
      case Column.Alignment of
        taCenter:
          X:=Rect.Left+((Rect.Right-Rect.Left-AnchoTexto) div 2);
        taRightJustify:
          X:=Rect.Right-AnchoTexto-4;
      end;
    Y:=Rect.Top+((Rect.Bottom-Rect.Top-DBGrid1.Canvas.TextHeight(S)) div 2);
    DBGrid1.Canvas.TextRect(Rect,X,Y,S);
    Exit;
  end;

  DBGrid1.Canvas.Brush.Color:=clWindow;
  if dbPedic.Active and (dbPedic.RecordCount>0) and
     (dbPedic.FieldByName('PC15').AsString<>'') then
    DBGrid1.Canvas.Font.Color:=RGBToColor(30,92,170)
  else
    DBGrid1.Canvas.Font.Color:=clWindowText;
  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

//========================== TOTALES VENCIMIENTOS =====================
//----------------- Salir de los importes ----------
procedure TFEntrada.Edit24Exit(Sender: TObject);
begin
   NormalizarImportesVencimientos();
   if VersiNumero(Edit24.Text)=False then
     begin showmessage('1º IMPORTE ERRONEO'); Edit24.SetFocus; exit; end;
   if VersiNumero(Edit26.Text)=False then
     begin showmessage('2º IMPORTE ERRONEO'); Edit26.SetFocus; exit; end;
   if VersiNumero(Edit28.Text)=False then
     begin showmessage('3º IMPORTE ERRONEO'); Edit28.SetFocus; exit; end;
   if VersiNumero(Edit30.Text)=False then
     begin showmessage('4º IMPORTE ERRONEO'); Edit30.SetFocus; exit; end;
   Edit24.Text:=FormatFloat('0.00',TextoAFloat(Edit24.Text));
   Edit26.Text:=FormatFloat('0.00',TextoAFloat(Edit26.Text));
   Edit28.Text:=FormatFloat('0.00',TextoAFloat(Edit28.Text));
   Edit30.Text:=FormatFloat('0.00',TextoAFloat(Edit30.Text));
   PintarTotalVencimientos();
end;

//---------------- Totales vencimientos ------------
procedure TFEntrada.PintarTotalVencimientos();
begin
  NormalizarImportesVencimientos();
  //------------ Suma de vencimientos
  Label46.Caption:=FormatFloat('0.00',TextoAFloat(Edit24.Text)+TextoAFloat(Edit26.Text)+
                                   TextoAFloat(Edit28.Text)+
                                   TextoAFloat(Edit30.Text));
  //------ Total Pedido calculado desde bases+impuestos - suma de vencimientos
  Label47.Caption:=FormatFloat('0.00',TotalPedidoConGastos()-TextoAFloat(Label46.Caption));
end;

//================== CALCULAR LOS VENCIMIENTOS =======================
procedure TFEntrada.VerVencimientos();//---------------- Ver si tiene vencimientos
var
  TotalFact, ImportePlazo, Acumulado: Double;
  Plazos: Integer;
  Dias: TDateTime;
begin
  NormalizarImportesVencimientos();
  if not dbProve.Active then CargarProveedorActual();
  if (not dbProve.Active) or (dbProve.RecordCount=0) then exit;

  //-------------- El total del pedido mas los gastos si los hay
  TotalFact:=RedondearCentimos(TotalPedidoConGastos());
  //----------- Plazos de pagos (Vencimientos) --------------------------
  if (TotalFact>dbProve.FieldByName('P21').AsFloat) And (dbProve.FieldByName('P15').AsInteger>0) then
    begin
      Plazos:=dbProve.FieldByName('P17').AsInteger;
      if Plazos<1 then Plazos:=1;
      if Plazos>4 then Plazos:=4;

      Edit24.Text:='0.00'; Edit26.Text:='0.00'; Edit28.Text:='0.00'; Edit30.Text:='0.00';
      DateEdit3.Clear; DateEdit4.Clear; DateEdit5.Clear; DateEdit6.Clear;

      ImportePlazo:=RedondearCentimos(TotalFact/Plazos);
      Acumulado:=0;
      Dias:=FechaBaseVencimiento()+dbProve.FieldByName('P15').AsInteger;

      DateEdit3.Text:=FormatDateTime('DD/MM/YYYY',Dias);
      if Plazos=1 then
        Edit24.Text:=FormatFloat('0.00',TotalFact)
      else
        begin
          Edit24.Text:=FormatFloat('0.00',ImportePlazo);
          Acumulado:=Acumulado+ImportePlazo;
        end;

      //------------------- Segundo Plazo
      if Plazos>1 then
        begin
          Dias:=Dias+dbProve.FieldByName('P16').AsInteger;
          DateEdit4.Text:=FormatDateTime('DD/MM/YYYY',Dias);
          if Plazos=2 then
            Edit26.Text:=FormatFloat('0.00',RedondearCentimos(TotalFact-Acumulado))
          else
            begin
              Edit26.Text:=FormatFloat('0.00',ImportePlazo);
              Acumulado:=Acumulado+ImportePlazo;
            end;
        end;
      //------------------- Tercer Plazo
      if Plazos>2 then
        begin
          Dias:=Dias+dbProve.FieldByName('P16').AsInteger;
          DateEdit5.Text:=FormatDateTime('DD/MM/YYYY',Dias);
          if Plazos=3 then
            Edit28.Text:=FormatFloat('0.00',RedondearCentimos(TotalFact-Acumulado))
          else
            begin
              Edit28.Text:=FormatFloat('0.00',ImportePlazo);
              Acumulado:=Acumulado+ImportePlazo;
            end;
        end;
      //------------------- Cuarto Plazo
      if Plazos>3 then
        begin
          Dias:=Dias+dbProve.FieldByName('P16').AsInteger;
          DateEdit6.Text:=FormatDateTime('DD/MM/YYYY',Dias);
          Edit30.Text:=FormatFloat('0.00',RedondearCentimos(TotalFact-Acumulado));
        end;
    end;
end;
//=======================================================================
//================ TRANSPORTES / GASTOS VARIOS ==========================
//=======================================================================
procedure TFEntrada.EditOtrosGastosExit(Sender: TObject);
begin
   if EditOtrosGastos.Text='' then EditOtrosGastos.Text:='0.00';
   if VersiNumero(EditOtrosGastos.Text)=False then
     begin showmessage('IMPORTE DE GASTOS ERRONEO'); EditOtrosGastos.SetFocus; exit; end;
   EditOtrosGastos.Text:=FormatFloat('0.00',TextoAFloat(EditOtrosGastos.Text));
   PintarTotalVencimientos();
end;

//================ AÑADIR GASTOS A LOS VENCIMIENTOS ======================
procedure TFEntrada.CheckBox1Change(Sender: TObject);
begin
  NormalizarImportesVencimientos();
  VerVencimientos();
  PintarTotalVencimientos();
end;

//=============================================================================
//================ MODERNIZACIÓN VISUAL Y PRODUCTIVIDAD =======================
//=============================================================================

procedure TFEntrada.CrearCabeceraPrincipal;
begin
  if Assigned(FCabeceraPrincipal) then Exit;

  FCabeceraPrincipal:=TPanel.Create(Self);
  FCabeceraPrincipal.Name:='PanelCabeceraModernaEntrada';
  FCabeceraPrincipal.Parent:=Self;
  FCabeceraPrincipal.SetBounds(0,0,ClientWidth,88);
  FCabeceraPrincipal.Anchors:=[akTop,akLeft,akRight];
  FCabeceraPrincipal.BevelOuter:=bvNone;
  FCabeceraPrincipal.Color:=RGBToColor(42,68,96);
  FCabeceraPrincipal.SendToBack;

  FTituloPrincipal:=TLabel.Create(Self);
  FTituloPrincipal.Name:='LabelTituloModernoEntrada';
  FTituloPrincipal.Parent:=FCabeceraPrincipal;
  FTituloPrincipal.SetBounds(18,12,390,32);
  FTituloPrincipal.AutoSize:=False;
  FTituloPrincipal.Caption:='ENTRADA DE PEDIDOS';
  FTituloPrincipal.Font.Name:='Sans';
  FTituloPrincipal.Font.Height:=-20;
  FTituloPrincipal.Font.Style:=[fsBold];
  FTituloPrincipal.Font.Color:=clWhite;
  FTituloPrincipal.Layout:=tlCenter;
  FTituloPrincipal.Transparent:=True;

  FSubtituloPrincipal:=TLabel.Create(Self);
  FSubtituloPrincipal.Name:='LabelSubtituloModernoEntrada';
  FSubtituloPrincipal.Parent:=FCabeceraPrincipal;
  FSubtituloPrincipal.SetBounds(20,46,390,24);
  FSubtituloPrincipal.AutoSize:=False;
  FSubtituloPrincipal.Caption:='Recepción, comprobación y actualización de pedidos';
  FSubtituloPrincipal.Font.Name:='Sans';
  FSubtituloPrincipal.Font.Height:=-12;
  FSubtituloPrincipal.Font.Color:=RGBToColor(220,232,244);
  FSubtituloPrincipal.Layout:=tlCenter;
  FSubtituloPrincipal.Transparent:=True;
end;

procedure TFEntrada.EstiloTitulo(ALabel: TLabel);
begin
  if not Assigned(ALabel) then Exit;
  ALabel.ParentFont:=False;
  ALabel.Font.Name:='Sans';
  ALabel.Font.Height:=-14;
  ALabel.Font.Style:=[fsBold];
  ALabel.Font.Color:=clWhite;
  ALabel.Color:=RGBToColor(42,86,132);
  ALabel.Alignment:=taCenter;
  ALabel.Layout:=tlCenter;
  ALabel.AutoSize:=False;
  ALabel.Transparent:=False;
end;

procedure TFEntrada.ConfigurarGridModerno(AGrid: TDBGrid);
begin
  if not Assigned(AGrid) then Exit;

  AGrid.ParentFont:=False;
  AGrid.Font.Name:='Sans';
  AGrid.Font.Height:=-13;
  AGrid.Font.Color:=clWindowText;
  AGrid.Color:=clWindow;
  AGrid.FixedColor:=RGBToColor(218,231,244);
  AGrid.TitleFont.Name:='Sans';
  AGrid.TitleFont.Height:=-13;
  AGrid.TitleFont.Style:=[fsBold];
  AGrid.TitleFont.Color:=RGBToColor(28,55,82);
  AGrid.DefaultRowHeight:=27;
  AGrid.Scrollbars:=ssAutoBoth;
  AGrid.Options:=AGrid.Options+
    [dgTitles,dgIndicator,dgColumnResize,dgColumnMove,dgColLines,dgRowLines,
     dgTabs,dgRowSelect,dgAlwaysShowSelection,dgConfirmDelete,dgCancelOnExit];
end;

procedure TFEntrada.AplicarEstiloModerno;
var
  I: Integer;
  C: TComponent;
  B: TBitBtn;
  S: String;
begin
  Caption:='Entrada de pedidos - FacturLinEx';
  Color:=RGBToColor(241,246,251);
  Font.Name:='Sans';
  Font.Color:=RGBToColor(35,52,70);

  Panel10.BevelOuter:=bvNone;
  Panel10.Color:=RGBToColor(226,242,247);
  Panel11.BevelOuter:=bvNone;
  Panel11.Color:=RGBToColor(248,250,253);
  Panel1.BevelOuter:=bvNone;
  Panel1.Color:=RGBToColor(248,250,253);

  // Revisión sistemática para que ningún texto, checkbox o radio quede oculto.
  for I:=0 to ComponentCount-1 do
  begin
    C:=Components[I];

    if C is TLabel then
    begin
      TLabel(C).ParentFont:=False;
      TLabel(C).Font.Name:='Sans';
      TLabel(C).Font.Color:=RGBToColor(35,52,70);
      TLabel(C).Transparent:=True;
    end
    else if C is TStaticText then
    begin
      TStaticText(C).ParentFont:=False;
      TStaticText(C).Font.Name:='Sans';
      TStaticText(C).Font.Color:=RGBToColor(30,48,66);
      TStaticText(C).Color:=RGBToColor(238,244,249);
    end
    else if C is TCustomEdit then
    begin
      // TCustomEdit no publica ParentFont en Lazarus 4.x/FPC 3.2.2.
      // La fuente se asigna directamente en las líneas siguientes.
      TCustomEdit(C).Font.Name:='Sans';
      TCustomEdit(C).Font.Height:=-13;
      TCustomEdit(C).Font.Color:=clWindowText;
      TCustomEdit(C).Color:=clWindow;
      AplicarContrasteSeleccion(TWinControl(C));
    end
    else if C is TCheckBox then
    begin
      TCheckBox(C).ParentFont:=False;
      TCheckBox(C).Font.Name:='Sans';
      TCheckBox(C).Font.Height:=-13;
      TCheckBox(C).Font.Style:=[fsBold];
      TCheckBox(C).Font.Color:=RGBToColor(25,55,80);
      TCheckBox(C).Color:=Panel11.Color;
    end
    else if C is TRadioButton then
    begin
      TRadioButton(C).ParentFont:=False;
      TRadioButton(C).Font.Name:='Sans';
      TRadioButton(C).Font.Height:=-13;
      TRadioButton(C).Font.Style:=[fsBold];
      TRadioButton(C).Font.Color:=RGBToColor(25,55,80);
      TRadioButton(C).Color:=Panel11.Color;
    end
    else if C is TBitBtn then
    begin
      B:=TBitBtn(C);
      B.ParentFont:=False;
      B.Font.Name:='Sans';
      B.Font.Height:=-13;
      B.Font.Style:=[fsBold];
      B.Font.Color:=RGBToColor(25,50,75);
      B.Color:=RGBToColor(222,235,248);

      S:=LowerCase(Trim(B.Caption));
      if (S='...') or ((B.Caption='') and (B.Width<=34)) then
      begin
        B.Color:=RGBToColor(36,105,171);
        B.Font.Color:=clWhite;
        if B.Width<32 then B.Width:=32;
        if B.Height<30 then B.Height:=30;
      end
      else if (Pos('cerrar',S)>0) or (Pos('salir',S)>0) or
              (Pos('cancelar',S)>0) then
      begin
        B.Color:=RGBToColor(232,236,240);
        B.Font.Color:=RGBToColor(50,60,70);
      end
      else if (Pos('aceptar',S)>0) or (Pos('entrada',S)>0) then
      begin
        B.Color:=RGBToColor(219,240,230);
        B.Font.Color:=RGBToColor(30,95,65);
      end
      else if Pos('adjuntar',S)>0 then
      begin
        B.Color:=RGBToColor(224,236,250);
        B.Font.Color:=RGBToColor(30,75,125);
      end;
    end;
  end;

  // Cabecera del cliente.
  Label30.Caption:='Pedido para el cliente:';
  Label34.Caption:='Teléfono';
  Label30.Font.Style:=[fsBold];
  Label34.Font.Style:=[fsBold];
  Label42.Font.Style:=[fsBold];
  Label43.Font.Style:=[fsBold];
  LabelCliente.Font.Style:=[fsBold];
  LabelCliente1.Font.Style:=[fsBold];
  LabelCliente2.Font.Style:=[fsBold];
  LabelCliente3.Font.Style:=[fsBold];

  // Panel de aceptación del pedido, ampliado y sin amontonamientos.
  Panel11.SetBounds(0,0,820,640);

  Label48.SetBounds(2,2,816,38);
  Label48.Caption:='ENTRADA DE PEDIDOS';
  EstiloTitulo(Label48);

  Label62.SetBounds(20,50,70,24);
  Label65.SetBounds(92,50,140,24);
  Label63.SetBounds(250,50,70,24);
  Label66.SetBounds(322,50,140,24);
  Label64.SetBounds(20,82,90,24);
  Label67.SetBounds(112,82,680,24);
  Label62.Font.Style:=[fsBold];
  Label63.Font.Style:=[fsBold];
  Label64.Font.Style:=[fsBold];
  Label65.Font.Style:=[fsBold];
  Label66.Font.Style:=[fsBold];
  Label67.Font.Style:=[fsBold];

  Bevel3.SetBounds(16,120,788,132);
  Label61.SetBounds(28,128,230,24);
  Label61.Font.Style:=[fsBold];

  RadioButton17.SetBounds(32,162,92,24);
  RadioButton18.SetBounds(150,162,92,24);
  RadioButton15.SetBounds(270,162,105,24);
  RadioButton16.SetBounds(402,162,105,24);
  RadioButton15.Caption:='Albarán';
  Label59.SetBounds(32,205,130,25);
  Label59.Caption:='N.º documento';
  Edit34.SetBounds(168,204,210,28);
  Label60.SetBounds(410,205,135,25);
  Label60.Caption:='Fecha alb./fact.';
  DateEdit10.SetBounds(550,204,160,28);

  Bevel5.SetBounds(16,264,382,270);
  Bevel4.SetBounds(414,264,390,270);

  Label56.SetBounds(130,274,150,26);
  Label56.Caption:='TOTALES';
  Label56.Font.Style:=[fsBold];
  Label35.SetBounds(532,274,155,26);
  Label35.Font.Style:=[fsBold];

  Label49.SetBounds(75,306,115,24);
  Label54.SetBounds(250,306,90,24);
  Label49.Font.Style:=[fsBold];
  Label54.Font.Style:=[fsBold];

  Label50.SetBounds(34,340,35,25);
  Label51.SetBounds(34,374,35,25);
  Label52.SetBounds(34,408,35,25);
  Label53.SetBounds(34,442,35,25);
  Edit25.SetBounds(78,338,138,28);
  Edit27.SetBounds(78,372,138,28);
  Edit29.SetBounds(78,406,138,28);
  Edit31.SetBounds(78,440,138,28);
  Edit32.SetBounds(240,338,132,28);
  Edit33.SetBounds(240,372,132,28);
  Edit35.SetBounds(240,406,132,28);
  Edit36.SetBounds(240,440,132,28);
  Label55.SetBounds(34,478,38,24);
  StaticText1.SetBounds(78,476,138,24);
  StaticText2.SetBounds(240,476,132,24);

  Label36.SetBounds(485,306,80,24);
  Label37.SetBounds(682,306,90,24);
  Label36.Font.Style:=[fsBold];
  Label37.Font.Style:=[fsBold];
  Label38.SetBounds(435,340,28,25);
  Label39.SetBounds(435,374,28,25);
  Label40.SetBounds(435,408,28,25);
  Label41.SetBounds(435,442,28,25);
  DateEdit3.SetBounds(470,338,155,28);
  DateEdit4.SetBounds(470,372,155,28);
  DateEdit5.SetBounds(470,406,155,28);
  DateEdit6.SetBounds(470,440,155,28);
  Edit24.SetBounds(650,338,130,28);
  Edit26.SetBounds(650,372,130,28);
  Edit28.SetBounds(650,406,130,28);
  Edit30.SetBounds(650,440,130,28);
  Label44.SetBounds(560,476,78,24);
  Label45.SetBounds(560,500,78,24);
  Label46.SetBounds(650,476,130,24);
  Label47.SetBounds(650,500,130,24);
  Label44.Font.Style:=[fsBold];
  Label45.Font.Style:=[fsBold];
  Label46.Font.Style:=[fsBold];
  Label47.Font.Style:=[fsBold];
  Label46.Font.Color:=RGBToColor(25,75,125);
  Label47.Font.Color:=RGBToColor(150,55,45);

  Bevel6.SetBounds(16,544,788,42);
  Label84.SetBounds(30,553,210,24);
  Label84.Font.Style:=[fsBold];
  EditOtrosGastos.SetBounds(242,551,120,28);
  Label86.SetBounds(368,556,20,20);
  CheckBox1.SetBounds(420,551,340,28);
  CheckBox1.Caption:='Incluir gastos en los vencimientos';

  BitBtn30.SetBounds(16,596,145,34);
  BitBtn31.SetBounds(338,596,145,34);
  BitBtn31.Hint:='La función de adjuntar documento está pendiente de implementación';
  BitBtn31.ShowHint:=True;
  BitBtn29.SetBounds(659,596,145,34);

  // Panel de progreso y comparación de datos.
  Panel1.SetBounds(0,0,620,470);
  Label57.SetBounds(2,2,616,38);
  Label57.Caption:='ENTRADA DE LÍNEAS';
  EstiloTitulo(Label57);
  Label58.SetBounds(20,50,140,22);
  StaticText3.SetBounds(20,74,140,25);
  Label69.SetBounds(470,50,130,22);
  StaticText5.SetBounds(490,74,110,25);
  Label68.SetBounds(20,106,160,22);
  StaticText4.SetBounds(20,130,580,26);

  Bevel2.SetBounds(16,170,282,232);
  Bevel1.SetBounds(322,170,282,232);
  Label83.SetBounds(65,180,180,24);
  Label82.SetBounds(370,180,180,24);
  Label83.Font.Style:=[fsBold];
  Label82.Font.Style:=[fsBold];

  Label76.SetBounds(34,216,100,24); StaticText12.SetBounds(150,216,120,24);
  Label77.SetBounds(34,248,100,24); StaticText13.SetBounds(150,248,120,24);
  Label78.SetBounds(34,280,100,24); StaticText14.SetBounds(150,280,120,24);
  Label79.SetBounds(34,312,100,24); StaticText15.SetBounds(150,312,120,24);
  Label80.SetBounds(34,344,100,24); StaticText16.SetBounds(150,344,120,24);
  Label81.SetBounds(34,376,100,24); StaticText17.SetBounds(150,376,120,24);

  Label70.SetBounds(340,216,100,24); StaticText6.SetBounds(456,216,120,24);
  Label71.SetBounds(340,248,100,24); StaticText7.SetBounds(456,248,120,24);
  Label72.SetBounds(340,280,100,24); StaticText8.SetBounds(456,280,120,24);
  Label73.SetBounds(340,312,100,24); StaticText9.SetBounds(456,312,120,24);
  Label74.SetBounds(340,344,100,24); StaticText10.SetBounds(456,344,120,24);
  Label75.SetBounds(340,376,100,24); StaticText11.SetBounds(456,376,120,24);
  ProgressBar1.SetBounds(16,430,588,24);

  // Cabecera del panel como asa para moverlo y consultar el grid inferior.
  Label48.Cursor:=crSizeAll;
  Label48.Hint:='Arrastre esta cabecera para mover el panel';
  Label48.ShowHint:=True;
  Label48.OnMouseDown:=@Panel11DragMouseDown;
  Label48.OnMouseMove:=@Panel11DragMouseMove;
  Label48.OnMouseUp:=@Panel11DragMouseUp;
  Panel11.OnMouseMove:=@Panel11DragMouseMove;
  Panel11.OnMouseUp:=@Panel11DragMouseUp;

  ConfigurarGridModerno(DBGrid1);
  AplicarContrasteSeleccionControles(Self);
end;

procedure TFEntrada.FormShow(Sender: TObject);
begin
  // Reafirmar el evento después de cargar completamente el recurso visual.
  // Así Adjuntar documento nunca puede ejecutar el flujo de Aceptar.
  BitBtn31.OnClick:=@BitBtn31Click;
  BitBtn31.ModalResult:=mrNone;
  BitBtn31.Default:=False;
  BitBtn31.Cancel:=False;

  // En OnShow los controles GTK ya tienen creado su widget nativo.
  AplicarContrasteSeleccionControles(Self);
  RecolocarPaneles;
  if Panel11.Visible then
  begin
    Panel11.BringToFront;
    if Edit34.CanFocus then Edit34.SetFocus;
  end
  else if DBGrid1.CanFocus then
    DBGrid1.SetFocus;
end;

procedure TFEntrada.FormResize(Sender: TObject);
begin
  RecolocarPaneles;
end;

procedure TFEntrada.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key<>VK_ESCAPE then Exit;

  // Durante el proceso de entrada no se permite cerrar accidentalmente.
  if Panel1.Visible then
  begin
    Key:=0;
    Exit;
  end;

  // Primero se cierra el panel auxiliar, después el formulario principal.
  if Panel11.Visible then
  begin
    Key:=0;
    BitBtn29Click(Self);
    Exit;
  end;

  Key:=0;
  BitBtn2Click(Self);
end;

procedure TFEntrada.RecolocarPaneles;
var
  AltGrid: Integer;
begin
  if Assigned(FCabeceraPrincipal) then
  begin
    FCabeceraPrincipal.Width:=ClientWidth;
    if Assigned(FTituloPrincipal) then
      FTituloPrincipal.Width:=390;
    if Assigned(FSubtituloPrincipal) then
      FSubtituloPrincipal.Width:=390;
  end;

  Panel10.SetBounds(ClientWidth-Panel10.Width-16,8,Panel10.Width,72);
  if Panel10.Left<420 then Panel10.Left:=420;
  Panel10.BringToFront;

  DBGrid1.Left:=12;
  DBGrid1.Top:=100;
  DBGrid1.Width:=ClientWidth-24;
  AltGrid:=ClientHeight-176;
  if AltGrid<180 then AltGrid:=180;
  DBGrid1.Height:=AltGrid;

  BitBtn3.Left:=18;
  BitBtn3.Top:=ClientHeight-BitBtn3.Height-18;
  BitBtn2.Left:=ClientWidth-BitBtn2.Width-18;
  BitBtn2.Top:=ClientHeight-BitBtn2.Height-18;

  if not FPanel11MovidoPorUsuario then
    CentrarPanel(Panel11)
  else
    LimitarPanel11AlAreaVisible;
  CentrarPanel(Panel1);

  if Panel11.Visible then Panel11.BringToFront;
  if Panel1.Visible then Panel1.BringToFront;
end;

procedure TFEntrada.CentrarPanel(APanel: TPanel);
var
  W, H: Integer;
begin
  if (not Assigned(APanel)) or (not (APanel.Parent is TWinControl)) then Exit;
  W:=TWinControl(APanel.Parent).ClientWidth;
  H:=TWinControl(APanel.Parent).ClientHeight;
  APanel.Left:=(W-APanel.Width) div 2;
  APanel.Top:=(H-APanel.Height) div 2;
  if APanel.Left<4 then APanel.Left:=4;
  if APanel.Top<4 then APanel.Top:=4;
end;

procedure TFEntrada.MarcarColumnaOrdenada(AGrid: TDBGrid; Column: TColumn;
  const AOrden: String);
var
  I: Integer;
  S: String;
begin
  if not Assigned(AGrid) then Exit;

  for I:=0 to AGrid.Columns.Count-1 do
  begin
    S:=AGrid.Columns[I].Title.Caption;
    S:=StringReplace(S,' ▲','',[rfReplaceAll]);
    S:=StringReplace(S,' ▼','',[rfReplaceAll]);
    AGrid.Columns[I].Title.Caption:=S;
  end;

  if not Assigned(Column) then Exit;
  if SameText(AOrden,'ASC') then
    Column.Title.Caption:=Column.Title.Caption+' ▲'
  else
    Column.Title.Caption:=Column.Title.Caption+' ▼';
end;

procedure TFEntrada.AplicarOrdenGrid(AGrid: TDBGrid; AQuery: TZQuery;
  Column: TColumn; var AOrden: String);
var
  SQLBase, SQLMayus, OrdenUsado: String;
  P: Integer;
  K0, K1, K2, K3, K4: Variant;
  TieneClave: Boolean;
begin
  if (not Assigned(AGrid)) or (not Assigned(AQuery)) or
     (not Assigned(Column)) or (Column.FieldName='') or
     (not AQuery.Active) then Exit;

  TieneClave:=(AQuery=dbPedic) and (AQuery.RecordCount>0);
  if TieneClave then
  begin
    K0:=AQuery.FieldByName('PC0').Value;
    K1:=AQuery.FieldByName('PC1').Value;
    K2:=AQuery.FieldByName('PC2').Value;
    K3:=AQuery.FieldByName('PC3').Value;
    K4:=AQuery.FieldByName('PC4').Value;
  end;

  AGrid.Enabled:=False;
  try
    SQLBase:=Trim(AQuery.SQL.Text);
    SQLMayus:=UpperCase(SQLBase);
    P:=Pos(' ORDER BY ',SQLMayus);
    if P>0 then SQLBase:=Trim(Copy(SQLBase,1,P-1));

    OrdenUsado:=AOrden;
    AQuery.Close;
    AQuery.SQL.Text:=SQLBase+' ORDER BY '+Column.FieldName+' '+OrdenUsado;
    AQuery.Open;

    if TieneClave then
      AQuery.Locate('PC0,PC1,PC2,PC3,PC4',
        VarArrayOf([K0,K1,K2,K3,K4]),[]);

    MarcarColumnaOrdenada(AGrid,Column,OrdenUsado);
    if SameText(AOrden,'ASC') then AOrden:='DESC' else AOrden:='ASC';
    AGrid.Refresh;
  finally
    AGrid.Enabled:=True;
  end;
end;

procedure TFEntrada.DBGrid1TitleClick(Column: TColumn);
begin
  AplicarOrdenGrid(DBGrid1,dbPedic,Column,FOrdenGrid1);
end;

procedure TFEntrada.AplicarContrasteSeleccion(AEditControl: TWinControl);
{$IFDEF LCLGTK2}
var
  FondoNormal, TextoNormal, FondoSeleccion, TextoSeleccion: TGdkColor;
  Widget: PGtkWidget;
{$ENDIF}
begin
  if not Assigned(AEditControl) then Exit;
  AEditControl.HandleNeeded;

  {$IFDEF LCLGTK2}
  Widget:=PGtkWidget(AEditControl.Handle);
  if Assigned(Widget) then
  begin
    // Sin selección: colores normales. Seleccionado: azul con texto blanco.
    gdk_color_parse(PChar('#FFFFFF'),@FondoNormal);
    gdk_color_parse(PChar('#101820'),@TextoNormal);
    gtk_widget_modify_base(Widget,GTK_STATE_NORMAL,@FondoNormal);
    gtk_widget_modify_text(Widget,GTK_STATE_NORMAL,@TextoNormal);

    gdk_color_parse(PChar('#2A5684'),@FondoSeleccion);
    gdk_color_parse(PChar('#FFFFFF'),@TextoSeleccion);
    gtk_widget_modify_base(Widget,GTK_STATE_SELECTED,@FondoSeleccion);
    gtk_widget_modify_text(Widget,GTK_STATE_SELECTED,@TextoSeleccion);
  end;
  {$ENDIF}
end;

procedure TFEntrada.AplicarContrasteSeleccionControles(AParent: TWinControl);
var
  I: Integer;
  C: TControl;
begin
  if not Assigned(AParent) then Exit;

  for I:=0 to AParent.ControlCount-1 do
  begin
    C:=AParent.Controls[I];
    if C is TCustomEdit then
      AplicarContrasteSeleccion(TWinControl(C));
    if C is TWinControl then
      AplicarContrasteSeleccionControles(TWinControl(C));
  end;
end;

procedure TFEntrada.LimitarPanel11AlAreaVisible;
var
  MaxLeft, MaxTop: Integer;
begin
  if (not Assigned(Panel11)) or (not (Panel11.Parent is TWinControl)) then Exit;

  MaxLeft:=TWinControl(Panel11.Parent).ClientWidth-Panel11.Width;
  MaxTop:=TWinControl(Panel11.Parent).ClientHeight-Panel11.Height;
  if MaxLeft<0 then MaxLeft:=0;
  if MaxTop<0 then MaxTop:=0;

  if Panel11.Left<0 then Panel11.Left:=0;
  if Panel11.Top<0 then Panel11.Top:=0;
  if Panel11.Left>MaxLeft then Panel11.Left:=MaxLeft;
  if Panel11.Top>MaxTop then Panel11.Top:=MaxTop;
end;

procedure TFEntrada.Panel11DragMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  P, OrigenPanel: TPoint;
begin
  if Button<>mbLeft then Exit;
  if not (Sender is TControl) then Exit;

  P:=TControl(Sender).ClientToScreen(Point(X,Y));
  OrigenPanel:=Panel11.ClientToScreen(Point(0,0));
  FPanel11DragOffset:=Point(P.X-OrigenPanel.X,P.Y-OrigenPanel.Y);
  FMoviendoPanel11:=True;
  FPanel11MovidoPorUsuario:=True;
  SetCapture(Panel11.Handle);
end;

procedure TFEntrada.Panel11DragMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  P, OrigenPadre: TPoint;
begin
  if (not FMoviendoPanel11) or (not (Sender is TControl)) then Exit;

  P:=TControl(Sender).ClientToScreen(Point(X,Y));
  OrigenPadre:=TWinControl(Panel11.Parent).ClientToScreen(Point(0,0));
  Panel11.Left:=P.X-FPanel11DragOffset.X-OrigenPadre.X;
  Panel11.Top:=P.Y-FPanel11DragOffset.Y-OrigenPadre.Y;
  LimitarPanel11AlAreaVisible;
end;

procedure TFEntrada.Panel11DragMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button<>mbLeft then Exit;
  FMoviendoPanel11:=False;
  ReleaseCapture;
  LimitarPanel11AlAreaVisible;
end;

initialization
  {$I entrada.lrs}

end.

