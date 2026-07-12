{
  Gestion LinEx FacturLinEx

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

unit ActAutArt;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, Buttons, StdCtrls, DbCtrls, Grids, ZConnection,
  ZDataset, LCLType;

type

  { TfActAutArt }

  TfActAutArt = class(TForm)
    bbFiltrar: TBitBtn;
    bbFijo: TBitBtn;
    bbPorcentaje: TBitBtn;
    bbAplicar: TBitBtn;
    BitBtnCerrar: TBitBtn;
    cbAutor: TComboBox;
    cbFamilia: TComboBox;
    cbProveedor: TComboBox;
    cgActTarifas: TCheckGroup;
    dsProveedores: TDatasource;
    dsFamilias: TDatasource;
    dsAutoFabri: TDatasource;
    dsArticulos: TDatasource;
    eCodigoD: TEdit;
    eDescrD: TEdit;
    eDescrH: TEdit;
    eCodigoH: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel1: TPanel;
    dbArticulos: TZQuery;
    dbAutoFabri: TZQuery;
    dbFamilias: TZQuery;
    rgPorcentaje: TRadioGroup;
    rgFijo: TRadioGroup;
    sgDatos: TStringGrid;
    Query: TZQuery;
    dbProveedores: TZQuery;
    procedure bbAplicarClick(Sender: TObject);
    procedure bbFijoClick(Sender: TObject);
    procedure bbFiltrarClick(Sender: TObject);
    procedure bbPorcentajeClick(Sender: TObject);
    procedure BitBtnCerrarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sgDatosKeyPress(Sender: TObject; var Key: char);
  private
    { Controles creados en runtime para mantener compatibilidad con el LFM/LRS antiguo }
    pnlCabeceraModerna: TPanel;
    pnlAjusteComercial: TPanel;
    cbAjustarTerminacion: TCheckBox;
    eMargenMinimo: TEdit;
    lblMargenMinimo: TLabel;
    lblAjusteInfo: TLabel;
    FCosteFilas: array of Double;
    FRecargoFilas: array of Double;

    function HistPreciosTableName: string;
    procedure EnsureHistPreciosTable;
    procedure RegistrarCambioPrecio(const ACodigo, ADescripcion, ACampo, AAnterior, ANuevo, AMotivo: string);
    function LeerValorTarifa(const ACodigo, ACampo: string; out AValor: string): Boolean;

    procedure AplicarEstiloModerno;
    procedure RecolocarControlesModernos;
    procedure AjustarTerminacionChange(Sender: TObject);
    function TryFloatFlexible(const S: string; out V: Double): Boolean;
    function EsCodigoSoloNumerico(const S: string): Boolean;
    function EsTerminacionComercial(const ACentimos: Int64): Boolean;
    function TerminacionMasCercana(const APrecio: Double): Double;
    function SiguienteTerminacionSuperior(const APrecio: Double): Double;
    function CalcularMargenSobreVenta(const APvpConIVA, ACoste, AIva, ARecargo: Double; out AMargen: Double): Boolean;
    function AjustarPVPFinal(const AFila: Integer; const APrecioCalculado, AMargenMinimo: Double;
      out AAceptoMenorMargen, ASubioPorMargen: Boolean): Double;
  public
    { public declarations }
  end; 
  procedure ShowFormActAutArt;
  function SumaPorcen(base, porciento: double): double;
  function RestaPorcen(total, porciento: double): double;

var
  fActAutArt: TfActAutArt;

implementation

{ TfActAutArt }

Uses funciones, global;

function FLX_CleanIdentLocal(const S: string): string;
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

function FLX_SQLIdentLocal(const S: string): string;
begin
  Result := '`' + StringReplace(S, '`', '', [rfReplaceAll]) + '`';
end;

function FLX_NormalizaValorPrecioHist(const S: string): string;
var
  V: Double;
  T: string;
begin
  T := Trim(StringReplace(S, ',', '.', [rfReplaceAll]));
  if TryStrToFloat(T, V) then
    Result := FormatFloat('0.0000', V)
  else
    Result := Trim(S);
end;

function TfActAutArt.HistPreciosTableName: string;
begin
  Result := 'flx_hist_precios' + FLX_CleanIdentLocal(Tienda);
end;

procedure TfActAutArt.EnsureHistPreciosTable;
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
    if Assigned(Query.Connection) then
      Q.Connection := Query.Connection;

    Q.SQL.Text :=
      'CREATE TABLE IF NOT EXISTS ' + FLX_SQLIdentLocal(T) + ' (' +
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

procedure TfActAutArt.RegistrarCambioPrecio(const ACodigo, ADescripcion, ACampo, AAnterior, ANuevo, AMotivo: string);
var
  Q: TZQuery;
  T, AntesN, DespuesN: string;
begin
  AntesN := FLX_NormalizaValorPrecioHist(AAnterior);
  DespuesN := FLX_NormalizaValorPrecioHist(ANuevo);
  if AntesN = DespuesN then Exit;

  EnsureHistPreciosTable;
  T := HistPreciosTableName;

  Q := TZQuery.Create(nil);
  try
    if Assigned(Query.Connection) then
      Q.Connection := Query.Connection;

    Q.SQL.Text := 'INSERT INTO ' + FLX_SQLIdentLocal(T) +
      ' (fecha,hora,usuario,codigo,descripcion,campo,valor_anterior,valor_nuevo,motivo) ' +
      ' VALUES (:fecha,:hora,:usuario,:codigo,:descripcion,:campo,:valor_anterior,:valor_nuevo,:motivo)';
    Q.ParamByName('fecha').AsString := FormatDateTime('yyyy-mm-dd', Date);
    Q.ParamByName('hora').AsString := FormatDateTime('hh:nn:ss', Time);
    Q.ParamByName('usuario').AsString := UsuarioActivo;
    Q.ParamByName('codigo').AsString := ACodigo;
    Q.ParamByName('descripcion').AsString := Copy(ADescripcion, 1, 255);
    Q.ParamByName('campo').AsString := ACampo;
    Q.ParamByName('valor_anterior').AsString := AntesN;
    Q.ParamByName('valor_nuevo').AsString := DespuesN;
    Q.ParamByName('motivo').AsString := AMotivo;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

function TfActAutArt.LeerValorTarifa(const ACodigo, ACampo: string; out AValor: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  AValor := '';
  Q := TZQuery.Create(nil);
  try
    if Assigned(Query.Connection) then
      Q.Connection := Query.Connection;

    Q.SQL.Text := 'SELECT ' + FLX_SQLIdentLocal(ACampo) + ' AS V FROM tarifas WHERE TAR0=:codigo LIMIT 1';
    Q.ParamByName('codigo').AsString := ACodigo;
    Q.Open;
    Result := not Q.EOF;
    if Result then
      AValor := Q.FieldByName('V').AsString;
  finally
    Q.Free;
  end;
end;


function TfActAutArt.TryFloatFlexible(const S: string; out V: Double): Boolean;
var
  T: string;
  FS: TFormatSettings;
begin
  T := Trim(S);
  Result := TryStrToFloat(T, V);
  if Result then Exit;

  T := StringReplace(T, ',', '.', [rfReplaceAll]);
  FS := DefaultFormatSettings;
  FS.DecimalSeparator := '.';
  FS.ThousandSeparator := ',';
  Result := TryStrToFloat(T, V, FS);
end;

function TfActAutArt.EsTerminacionComercial(const ACentimos: Int64): Boolean;
var
  D: Integer;
begin
  D := Abs(ACentimos) mod 10;
  Result := D in [0, 5, 9];
end;

function TfActAutArt.TerminacionMasCercana(const APrecio: Double): Double;
var
  BaseCent, Inferior, Superior: Int64;
  Dist: Integer;
begin
  BaseCent := Round(APrecio * 100);
  if BaseCent < 0 then BaseCent := 0;

  if EsTerminacionComercial(BaseCent) then
    Exit(BaseCent / 100);

  { En empate se prefiere la terminacion superior para proteger el margen. }
  for Dist := 1 to 10 do
  begin
    Superior := BaseCent + Dist;
    Inferior := BaseCent - Dist;
    if EsTerminacionComercial(Superior) then
      Exit(Superior / 100);
    if (Inferior >= 0) and EsTerminacionComercial(Inferior) then
      Exit(Inferior / 100);
  end;

  Result := BaseCent / 100;
end;

function TfActAutArt.SiguienteTerminacionSuperior(const APrecio: Double): Double;
var
  C: Int64;
begin
  C := Round(APrecio * 100) + 1;
  while not EsTerminacionComercial(C) do Inc(C);
  Result := C / 100;
end;

function TfActAutArt.CalcularMargenSobreVenta(const APvpConIVA, ACoste, AIva,
  ARecargo: Double; out AMargen: Double): Boolean;
var
  CosteConImpuestos: Double;
begin
  CosteConImpuestos := ACoste * (1 + ((AIva + ARecargo) / 100));
  Result := (CosteConImpuestos > 0) and (APvpConIVA > 0);
  if not Result then
  begin
    AMargen := 0;
    Exit;
  end;

  { Misma formula historica de FacturLinEx para A37: margen sobre la venta
    con impuestos. Equivale a (PVP - coste con impuestos) / PVP * 100. }
  AMargen := ((APvpConIVA - CosteConImpuestos) * 100) / APvpConIVA;
end;

function TfActAutArt.AjustarPVPFinal(const AFila: Integer;
  const APrecioCalculado, AMargenMinimo: Double;
  out AAceptoMenorMargen, ASubioPorMargen: Boolean): Double;
var
  Coste, IVA, Recargo, MargenResultante: Double;
  Propuesto, Candidato: Double;
  Resp: Integer;
  PuedeCalcularMargen: Boolean;
  Msg: string;
begin
  AAceptoMenorMargen := False;
  ASubioPorMargen := False;

  Propuesto := TerminacionMasCercana(APrecioCalculado);
  Result := Propuesto;

  if (AFila < Low(FCosteFilas)) or (AFila > High(FCosteFilas)) then Exit;
  Coste := FCosteFilas[AFila];
  if not TryFloatFlexible(sgDatos.Cells[4, AFila], IVA) then IVA := 0;
  if (AFila >= Low(FRecargoFilas)) and (AFila <= High(FRecargoFilas)) then
    Recargo := FRecargoFilas[AFila]
  else
    Recargo := 0;

  PuedeCalcularMargen := CalcularMargenSobreVenta(Propuesto, Coste, IVA, Recargo, MargenResultante);
  if (not PuedeCalcularMargen) or (MargenResultante >= AMargenMinimo) then Exit;

  Msg :=
    'El ajuste a la terminacion comercial mas proxima deja este articulo por debajo del margen minimo.' + LineEnding + LineEnding +
    'Codigo: ' + sgDatos.Cells[0, AFila] + LineEnding +
    'Articulo: ' + sgDatos.Cells[1, AFila] + LineEnding + LineEnding +
    'Precio calculado: ' + FormatFloat('0.00', APrecioCalculado) + ' EUR' + LineEnding +
    'Precio terminado en 5/9/0: ' + FormatFloat('0.00', Propuesto) + ' EUR' + LineEnding +
    'Margen sobre la venta resultante: ' + FormatFloat('0.00', MargenResultante) + ' %' + LineEnding +
    'Margen minimo solicitado: ' + FormatFloat('0.00', AMargenMinimo) + ' %' + LineEnding + LineEnding +
    'SI = aceptar ' + FormatFloat('0.00', Propuesto) + ' EUR aunque el margen sea inferior.' + LineEnding +
    'NO = respetar el margen minimo y buscar la siguiente terminacion superior.';

  Resp := MessageDlg('FacturLinEx - Margen minimo', Msg, mtWarning, [mbYes, mbNo], 0);
  if Resp = mrYes then
  begin
    AAceptoMenorMargen := True;
    Exit(Propuesto);
  end;

  Candidato := Propuesto;
  repeat
    Candidato := SiguienteTerminacionSuperior(Candidato);
  until (not CalcularMargenSobreVenta(Candidato, Coste, IVA, Recargo, MargenResultante)) or
        (MargenResultante >= AMargenMinimo);

  ASubioPorMargen := True;
  Result := Candidato;
end;

procedure TfActAutArt.AjustarTerminacionChange(Sender: TObject);
begin
  if Assigned(eMargenMinimo) then
    eMargenMinimo.Enabled := Assigned(cbAjustarTerminacion) and cbAjustarTerminacion.Checked;
  if Assigned(lblMargenMinimo) then
    lblMargenMinimo.Enabled := Assigned(cbAjustarTerminacion) and cbAjustarTerminacion.Checked;
end;

procedure TfActAutArt.AplicarEstiloModerno;
var
  lblTitulo, lblSubtitulo, lblBloque: TLabel;
begin
  Caption := 'FacturLinEx - Actualizacion automatica de tarifas';
  BorderStyle := bsSizeable;
  BorderIcons := [biSystemMenu, biMinimize, biMaximize];
  Position := poScreenCenter;
  Constraints.MinWidth := 1100;
  Constraints.MinHeight := 650;
  Width := 1200;
  Height := 760;
  Color := clBtnFace;
  Font.Name := 'Sans';
  Font.Size := 10;

  { Cabecera visual, creada en runtime para no obligar a regenerar el antiguo .lrs. }
  pnlCabeceraModerna := TPanel.Create(Self);
  pnlCabeceraModerna.Parent := Self;
  pnlCabeceraModerna.Align := alTop;
  pnlCabeceraModerna.Height := 68;
  pnlCabeceraModerna.BevelOuter := bvNone;
  pnlCabeceraModerna.Color := $00F4F0EA;

  lblTitulo := TLabel.Create(pnlCabeceraModerna);
  lblTitulo.Parent := pnlCabeceraModerna;
  lblTitulo.Left := 18;
  lblTitulo.Top := 9;
  lblTitulo.Caption := 'ACTUALIZACION AUTOMATICA DE TARIFAS';
  lblTitulo.Font.Name := 'Sans';
  lblTitulo.Font.Size := 15;
  lblTitulo.Font.Style := [fsBold];
  lblTitulo.Font.Color := clBlack;

  lblSubtitulo := TLabel.Create(pnlCabeceraModerna);
  lblSubtitulo.Parent := pnlCabeceraModerna;
  lblSubtitulo.Left := 18;
  lblSubtitulo.Top := 38;
  lblSubtitulo.Caption := 'Filtra articulos, calcula nuevos precios y revisa los cambios antes de aplicarlos.';
  lblSubtitulo.Font.Name := 'Sans';
  lblSubtitulo.Font.Size := 9;
  lblSubtitulo.Font.Color := clBlack;

  GroupBox1.Align := alTop;
  GroupBox1.Height := 205;
  GroupBox1.Caption := '  Seleccion de articulos y tarifas  ';
  GroupBox1.Color := clWhite;
  GroupBox1.ParentColor := False;
  GroupBox1.Font.Style := [fsBold];

  { Los controles internos mantienen nombres y eventos originales. }
  Label1.Font.Style := [];
  Label2.Font.Style := [];
  Label3.Font.Style := [];
  Label4.Font.Style := [];
  Label5.Font.Style := [];
  Label6.Font.Style := [];
  Label7.Font.Style := [];

  eDescrD.Width := 280;
  eDescrH.Width := 280;
  cbAutor.Width := 300;
  cbFamilia.Width := 300;
  cbProveedor.Width := 300;

  cgActTarifas.Left := 700;
  cgActTarifas.Top := 18;
  cgActTarifas.Width := 460;
  cgActTarifas.Height := 68;
  cgActTarifas.Anchors := [akTop];
  cgActTarifas.Font.Style := [];

  pnlAjusteComercial := TPanel.Create(GroupBox1);
  pnlAjusteComercial.Parent := GroupBox1;
  pnlAjusteComercial.Left := 700;
  pnlAjusteComercial.Top := 98;
  pnlAjusteComercial.Width := 460;
  pnlAjusteComercial.Height := 92;
  pnlAjusteComercial.Anchors := [akTop];
  pnlAjusteComercial.BevelOuter := bvNone;
  pnlAjusteComercial.Color := $00F8FBFF;

  lblBloque := TLabel.Create(pnlAjusteComercial);
  lblBloque.Parent := pnlAjusteComercial;
  lblBloque.Left := 12;
  lblBloque.Top := 8;
  lblBloque.Caption := 'AJUSTE COMERCIAL DEL PVP FINAL';
  lblBloque.Font.Style := [fsBold];
  lblBloque.Font.Color := clBlack;

  cbAjustarTerminacion := TCheckBox.Create(pnlAjusteComercial);
  cbAjustarTerminacion.Parent := pnlAjusteComercial;
  cbAjustarTerminacion.Left := 12;
  cbAjustarTerminacion.Top := 31;
  cbAjustarTerminacion.Width := 330;
  cbAjustarTerminacion.Caption := 'Ajustar PVP con IVA a terminacion 5, 9 o 0';
  cbAjustarTerminacion.Checked := False;
  cbAjustarTerminacion.OnChange := @AjustarTerminacionChange;

  lblMargenMinimo := TLabel.Create(pnlAjusteComercial);
  lblMargenMinimo.Parent := pnlAjusteComercial;
  lblMargenMinimo.Left := 12;
  lblMargenMinimo.Top := 62;
  lblMargenMinimo.Caption := 'Margen minimo sobre venta (%)';
  lblMargenMinimo.Enabled := False;

  eMargenMinimo := TEdit.Create(pnlAjusteComercial);
  eMargenMinimo.Parent := pnlAjusteComercial;
  eMargenMinimo.Left := 165;
  eMargenMinimo.Top := 56;
  eMargenMinimo.Width := 75;
  eMargenMinimo.Text := '';
  eMargenMinimo.Enabled := False;

  lblAjusteInfo := TLabel.Create(pnlAjusteComercial);
  lblAjusteInfo.Parent := pnlAjusteComercial;
  lblAjusteInfo.Left := 255;
  lblAjusteInfo.Top := 58;
  lblAjusteInfo.Width := 200;
  lblAjusteInfo.Height := 32;
  lblAjusteInfo.AutoSize := False;
  lblAjusteInfo.WordWrap := True;
  lblAjusteInfo.Caption := 'Se ajusta el PVP final con IVA (A2).';
  lblAjusteInfo.Font.Size := 8;
  lblAjusteInfo.Font.Color := clGrayText;

  Panel1.Align := alBottom;
  Panel1.Height := 104;
  Panel1.BevelOuter := bvNone;
  Panel1.Color := $00F4F0EA;

  rgFijo.Left := 18;
  rgFijo.Top := 8;
  rgFijo.Width := 220;
  rgFijo.Height := 50;
  bbFijo.Left := 18;
  bbFijo.Top := 62;
  bbFijo.Width := 220;
  bbFijo.Height := 28;

  rgPorcentaje.Left := 255;
  rgPorcentaje.Top := 8;
  rgPorcentaje.Width := 240;
  rgPorcentaje.Height := 50;
  bbPorcentaje.Left := 255;
  bbPorcentaje.Top := 62;
  bbPorcentaje.Width := 240;
  bbPorcentaje.Height := 28;
  bbPorcentaje.Font.Style := [fsBold];

  bbFiltrar.Width := 90;
  bbFiltrar.Height := 76;
  bbFiltrar.Top := 10;
  bbFiltrar.Left := 860;
  bbFiltrar.Anchors := [akTop];

  bbAplicar.Width := 90;
  bbAplicar.Height := 76;
  bbAplicar.Top := 10;
  bbAplicar.Left := 960;
  bbAplicar.Anchors := [akTop];
  bbAplicar.Font.Style := [fsBold];

  BitBtnCerrar.Width := 90;
  BitBtnCerrar.Height := 76;
  BitBtnCerrar.Top := 10;
  BitBtnCerrar.Left := 1060;
  BitBtnCerrar.Anchors := [akTop];

  sgDatos.Align := alClient;
  sgDatos.Color := clWhite;
  sgDatos.FixedColor := $00E8E8E8;
  sgDatos.Font.Color := clBlack;
  sgDatos.DefaultRowHeight := 24;
  sgDatos.Options := sgDatos.Options + [goColSizing, goThumbTracking];
  { El grid original usa la coleccion Columns. No escribir cabeceras en Cells[*,0],
    porque eso hace que FormClose pueda interpretar la fila fija como un precio modificado. }
  if sgDatos.Columns.Count >= 7 then
  begin
    sgDatos.Columns[0].Title.Caption := 'CODIGO';
    sgDatos.Columns[1].Title.Caption := 'DESCRIPCION';
    sgDatos.Columns[2].Title.Caption := 'PVP S/IVA';
    sgDatos.Columns[3].Title.Caption := 'NUEVO S/IVA';
    sgDatos.Columns[4].Title.Caption := 'IVA';
    sgDatos.Columns[5].Title.Caption := 'PVP C/IVA';
    sgDatos.Columns[6].Title.Caption := 'NUEVO C/IVA';
  end;

  pnlCabeceraModerna.BringToFront;
  RecolocarControlesModernos;
  WindowState := wsMaximized;
end;

procedure TfActAutArt.RecolocarControlesModernos;
var
  WGrupo, WPanel, XDerecha, AnchoDerecha: Integer;
  AnchoDesc, AnchoDescripcionGrid: Integer;
  AnchoFijoGrid: Integer;
begin
  if (not Assigned(GroupBox1)) or (not Assigned(Panel1)) then Exit;

  { Zona superior derecha: se calcula SIEMPRE respecto al padre real.
    La version anterior mezclaba ClientWidth del formulario con controles anclados
    dentro de GroupBox1/Panel1; al maximizar, Lazarus aplicaba dos desplazamientos
    y los controles terminaban fuera de pantalla. }
  WGrupo := GroupBox1.ClientWidth;
  AnchoDerecha := 460;
  XDerecha := WGrupo - AnchoDerecha - 16;
  if XDerecha < 780 then
  begin
    XDerecha := 780;
    AnchoDerecha := WGrupo - XDerecha - 16;
  end;
  if AnchoDerecha < 300 then AnchoDerecha := 300;

  cgActTarifas.SetBounds(XDerecha, 18, AnchoDerecha, 68);
  if Assigned(pnlAjusteComercial) then
    pnlAjusteComercial.SetBounds(XDerecha, 98, AnchoDerecha, 92);

  if Assigned(lblAjusteInfo) and Assigned(pnlAjusteComercial) then
  begin
    lblAjusteInfo.Left := 255;
    lblAjusteInfo.Width := pnlAjusteComercial.ClientWidth - lblAjusteInfo.Left - 10;
    if lblAjusteInfo.Width < 80 then lblAjusteInfo.Width := 80;
  end;

  { Campos de descripcion: aprovechar el espacio izquierdo sin invadir la zona de tarifas. }
  AnchoDesc := (XDerecha - 500) div 2 + 280;
  if AnchoDesc < 280 then AnchoDesc := 280;
  if AnchoDesc > 360 then AnchoDesc := 360;
  eDescrD.Width := AnchoDesc;
  eDescrH.Left := 480;
  eDescrH.Width := XDerecha - eDescrH.Left - 20;
  if eDescrH.Width < 220 then eDescrH.Width := 220;
  if eDescrH.Width > 360 then eDescrH.Width := 360;

  { Barra inferior: acciones siempre dentro del panel visible. }
  WPanel := Panel1.ClientWidth;
  BitBtnCerrar.Left := WPanel - BitBtnCerrar.Width - 18;
  bbAplicar.Left := BitBtnCerrar.Left - bbAplicar.Width - 12;
  bbFiltrar.Left := bbAplicar.Left - bbFiltrar.Width - 12;

  { El grid ocupa toda la anchura; la descripcion absorbe el espacio sobrante. }
  if sgDatos.Columns.Count >= 7 then
  begin
    sgDatos.Columns[0].Width := 110;
    sgDatos.Columns[2].Width := 105;
    sgDatos.Columns[3].Width := 115;
    sgDatos.Columns[4].Width := 65;
    sgDatos.Columns[5].Width := 105;
    sgDatos.Columns[6].Width := 115;
    AnchoFijoGrid := 110 + 105 + 115 + 65 + 105 + 115 + 36;
    AnchoDescripcionGrid := sgDatos.ClientWidth - AnchoFijoGrid;
    if AnchoDescripcionGrid < 320 then AnchoDescripcionGrid := 320;
    sgDatos.Columns[1].Width := AnchoDescripcionGrid;
  end;
end;

//=============== Crea el formulario ================
procedure ShowFormActAutArt;
begin
  with TFActAutArt.Create(Application) do
    begin
       ShowModal;
    end;
end;

//=========Funciones para sumar y restar un porcentaje========
function SumaPorcen(Base, PorCiento: double): double;
begin
  result := Base+((Base*PorCiento)/100);
end;

function RestaPorcen(Total, PorCiento: double): double;
begin
  result := (100 * Total) / (100 + PorCiento);
end;

procedure TfActAutArt.BitBtnCerrarClick(Sender: TObject);
begin
  Self.Close;
end;

function TfActAutArt.EsCodigoSoloNumerico(const S: string): Boolean;
var
  I: Integer;
  T: string;
begin
  T := Trim(S);
  Result := T <> '';
  if not Result then Exit;
  for I := 1 to Length(T) do
    if not (T[I] in ['0'..'9']) then
      Exit(False);
end;

procedure TfActAutArt.bbFiltrarClick(Sender: TObject);
var
  clausula: string;
  CodigoD, CodigoH: string;
  FiltroCodigoNumerico: Boolean;
  Fila: Integer;
begin
  clausula:='WHERE ';
  CodigoD := Trim(eCodigoD.Text);
  CodigoH := Trim(eCodigoH.Text);

  { Si todos los limites de codigo informados son numericos, comparamos A0
    numericamente. Asi un rango 100..200 no incluye 1000, 15000, etc.
    Si alguno de los limites es alfanumerico, conservamos la comparacion
    textual original para no romper codigos no numericos. }
  FiltroCodigoNumerico :=
    ((CodigoD = '') or EsCodigoSoloNumerico(CodigoD)) and
    ((CodigoH = '') or EsCodigoSoloNumerico(CodigoH)) and
    ((CodigoD <> '') or (CodigoH <> ''));

  if dbArticulos.Active then dbArticulos.Close;
  dbArticulos.SQL.Clear;
  dbArticulos.SQL.Add('SELECT * FROM artitien'+Tienda+' ');

  if FiltroCodigoNumerico then
  begin
    dbArticulos.SQL.Add(clausula+'TRIM(A0) REGEXP ''^[0-9]+$''');
    clausula:=' and ';
    if CodigoD<>'' then begin
       dbArticulos.SQL.Add(clausula+'CAST(TRIM(A0) AS UNSIGNED) >= '+CodigoD);
       clausula:=' and ';
    end;
    if CodigoH<>'' then begin
       dbArticulos.SQL.Add(clausula+'CAST(TRIM(A0) AS UNSIGNED) <= '+CodigoH);
       clausula:=' and ';
    end;
  end
  else
  begin
    if CodigoD<>'' then begin
       dbArticulos.SQL.Add(clausula+'A0 >= '+QuotedStr(CodigoD));
       clausula:=' and ';
    end;
    if CodigoH<>'' then begin
       dbArticulos.SQL.Add(clausula+'A0 <= '+QuotedStr(CodigoH));
       clausula:=' and ';
    end;
  end;

  if Trim(eDescrD.Text)<>'' then begin
     dbArticulos.SQL.Add(clausula+'A1 >= '+QuotedStr(Trim(eDescrD.Text)));
     clausula:=' and ';
  end;
  if Trim(eDescrH.Text)<>'' then begin
     dbArticulos.SQL.Add(clausula+'A1 <= '+QuotedStr(Trim(eDescrH.Text)));
     clausula:=' and ';
  end;
  if cbAutor.Text<>'' then begin
     // Buscamos el código de Autor/Fabricante y lo insertamos en el query
     dbAutoFabri.Open;
     dbAutoFabri.Locate('AUT1', cbAutor.Text, []);
     dbArticulos.SQL.Add(clausula+'A20 = '''+dbAutoFabri.FieldByName('AUT0').AsString +'''');
     clausula:=' and ';
     dbAutoFabri.Close;
  end;
  if cbFamilia.Text<>'' then begin
     // Buscamos el código de la Familia y lo insertamos en el query
     dbFamilias.Open;
     dbFamilias.Locate('F1', cbFamilia.Text, []);
     dbArticulos.SQL.Add(clausula+'A14 = '''+dbFamilias.FieldByName('F0').AsString +'''');
     clausula:=' and ';
     dbFamilias.Close;
  end;
  if cbProveedor.Text<>'' then begin
     // Buscamos el código del Proveedor y lo insertamos en el query
     dbProveedores.Open;
     dbProveedores.Locate('P1', cbProveedor.Text, []);
     dbArticulos.SQL.Add(clausula+'A32 = '''+dbProveedores.FieldByName('P0').AsString +'''');
     clausula:=' and ';
     dbProveedores.Close;
  end;

  if FiltroCodigoNumerico then
    dbArticulos.SQL.Add('ORDER BY CAST(TRIM(A0) AS UNSIGNED), A0')
  else
    dbArticulos.SQL.Add('ORDER BY A0');

  dbArticulos.Open;
  sgDatos.RowCount:=dbArticulos.RecordCount+1;
  SetLength(FCosteFilas, sgDatos.RowCount);
  SetLength(FRecargoFilas, sgDatos.RowCount);
  Fila := 1;
  while not dbArticulos.EOF do begin
        sgDatos.Cells[0,Fila]:=dbArticulos.FieldByName('A0').AsString;
        sgDatos.Cells[1,Fila]:=dbArticulos.FieldByName('A1').AsString;
        sgDatos.Cells[2,Fila]:=FormatFloat('0.000',dbArticulos.FieldByName('A21').AsFloat);
        sgDatos.Cells[4,Fila]:=FormatFloat('0.000',dbArticulos.FieldByName('A3').AsFloat);
        sgDatos.Cells[5,Fila]:=FormatFloat('0.000',dbArticulos.FieldByName('A2').AsFloat);
        FCosteFilas[Fila] := dbArticulos.FieldByName('A24').AsFloat;
        FRecargoFilas[Fila] := dbArticulos.FieldByName('A36').AsFloat;
        Inc(Fila);
        dbArticulos.Next;
  end;
  dbArticulos.Close;
  rgFijo.Enabled:=True;  bbFijo.Enabled:=True;
  rgPorcentaje.Enabled:=True;  bbPorcentaje.Enabled:=True;
  if sgDatos.RowCount > 1 then sgDatos.Row:=1 else sgDatos.Row:=0;
  sgDatos.Col:=3;
  sgDatos.SetFocus;
end;

procedure TfActAutArt.bbPorcentajeClick(Sender: TObject);
var
  imp_porcen: string;
  cont: integer;
  Porcentaje, MargenMinimo: Double;
  BaseSinIVA, BaseConIVA, NuevoSinIVA, NuevoConIVA, IVA: Double;
  UsarAjuste, AceptoMenorMargen, SubioPorMargen: Boolean;
  NumAjustados, NumAceptadosBajo, NumSubidosMargen, NumSinCoste: Integer;
begin
  imp_porcen := InputBox('FacturLinEx 2','Introducir PORCENTAJE','');
  if not TryFloatFlexible(imp_porcen, Porcentaje) then
  begin
    ShowMessage('El porcentaje introducido no es valido.');
    Exit;
  end;

  UsarAjuste := Assigned(cbAjustarTerminacion) and cbAjustarTerminacion.Checked;
  MargenMinimo := 0;
  if UsarAjuste and ((not TryFloatFlexible(eMargenMinimo.Text, MargenMinimo)) or
     (MargenMinimo < 0) or (MargenMinimo >= 100)) then
  begin
    ShowMessage('Indique un margen minimo sobre la venta valido (entre 0 y menos de 100).');
    eMargenMinimo.SetFocus;
    Exit;
  end;

  NumAjustados := 0;
  NumAceptadosBajo := 0;
  NumSubidosMargen := 0;
  NumSinCoste := 0;

  if rgPorcentaje.ItemIndex=0 then begin    // PVP S/IVA
     for cont:=1 to SgDatos.RowCount-1 do begin
         if not TryFloatFlexible(sgDatos.Cells[4,Cont], IVA) then IVA := 0;

         if sgDatos.Cells[3,cont]='' then begin     // No hay datos, se calcula sobre el dato original
            if not TryFloatFlexible(sgDatos.Cells[2,Cont], BaseSinIVA) then Continue;
         end else begin    // Hay datos, se calcula sobre el dato modificado
            if not TryFloatFlexible(sgDatos.Cells[3,Cont], BaseSinIVA) then Continue;
         end;

         NuevoSinIVA := SumaPorcen(BaseSinIVA, Porcentaje);
         NuevoConIVA := SumaPorcen(NuevoSinIVA, IVA);

         if UsarAjuste then
         begin
           if (Cont > High(FCosteFilas)) or (FCosteFilas[Cont] <= 0) then
             Inc(NumSinCoste);
           NuevoConIVA := AjustarPVPFinal(cont, NuevoConIVA, MargenMinimo,
             AceptoMenorMargen, SubioPorMargen);
           NuevoSinIVA := RestaPorcen(NuevoConIVA, IVA);
           Inc(NumAjustados);
           if AceptoMenorMargen then Inc(NumAceptadosBajo);
           if SubioPorMargen then Inc(NumSubidosMargen);
           sgDatos.Cells[6,Cont] := FormatFloat('0.00', NuevoConIVA);
         end
         else
           sgDatos.Cells[6,Cont] := FormatFloat('0.000', NuevoConIVA);

         sgDatos.Cells[3,cont] := FormatFloat('0.000', NuevoSinIVA);
     end;
  end else begin    // PVP C/IVA
     for cont:=1 to SgDatos.RowCount-1 do begin
         if not TryFloatFlexible(sgDatos.Cells[4,Cont], IVA) then IVA := 0;

         if sgDatos.Cells[6,cont]='' then begin     // No hay datos, se calcula sobre el dato original
            if not TryFloatFlexible(sgDatos.Cells[5,Cont], BaseConIVA) then Continue;
         end else begin    // Hay datos, se calcula sobre el dato modificado
            if not TryFloatFlexible(sgDatos.Cells[6,Cont], BaseConIVA) then Continue;
         end;

         NuevoConIVA := SumaPorcen(BaseConIVA, Porcentaje);

         if UsarAjuste then
         begin
           if (Cont > High(FCosteFilas)) or (FCosteFilas[Cont] <= 0) then
             Inc(NumSinCoste);
           NuevoConIVA := AjustarPVPFinal(cont, NuevoConIVA, MargenMinimo,
             AceptoMenorMargen, SubioPorMargen);
           Inc(NumAjustados);
           if AceptoMenorMargen then Inc(NumAceptadosBajo);
           if SubioPorMargen then Inc(NumSubidosMargen);
           sgDatos.Cells[6,Cont] := FormatFloat('0.00', NuevoConIVA);
         end
         else
           sgDatos.Cells[6,Cont] := FormatFloat('0.000', NuevoConIVA);

         NuevoSinIVA := RestaPorcen(NuevoConIVA, IVA);
         sgDatos.Cells[3,Cont] := FormatFloat('0.000', NuevoSinIVA);
     end;
  end;

  if UsarAjuste then
    ShowMessage('Calculo realizado.' + LineEnding +
      'Precios ajustados a terminacion 5/9/0: ' + IntToStr(NumAjustados) + LineEnding +
      'Aceptados expresamente por debajo del margen minimo: ' + IntToStr(NumAceptadosBajo) + LineEnding +
      'Subidos a la siguiente terminacion para respetar el margen: ' + IntToStr(NumSubidosMargen) + LineEnding +
      'Sin coste valido A24 (no se pudo verificar margen): ' + IntToStr(NumSinCoste));
end;

procedure TfActAutArt.bbFijoClick(Sender: TObject);
var
  importe: string;
  cont: integer;
begin
  importe := InputBox('FacturLinEx 2','Introducir IMPORTE','');
  if rgFijo.ItemIndex=0 then begin    // PVP S/IVA
     for cont:=1 to SgDatos.RowCount-1 do begin
         if sgDatos.Cells[3,cont]='' then begin     // No hay datos, se calcula sobre el dato original
            sgDatos.Cells[3,cont]:=FormatFloat('0.000',StrToFloat(sgDatos.Cells[2,Cont])+StrToFloat(importe));
         end else begin    // Hay datos, se calcula sobre el dato modificado
            sgDatos.Cells[3,cont]:=FormatFloat('0.000',StrToFloat(sgDatos.Cells[3,Cont])+StrToFloat(importe));
         end;
         sgDatos.Cells[6,Cont]:=FormatFloat('0.000',SumaPorcen(StrToFloat(sgDatos.Cells[3,Cont]),
                                                               StrToFloat(sgDatos.Cells[4,Cont])));
     end;
  end else begin    // PVP C/IVA
     for cont:=1 to SgDatos.RowCount-1 do begin
         if sgDatos.Cells[6,cont]='' then begin     // No hay datos, se calcula sobre el dato original
            sgDatos.Cells[6,cont]:=FormatFloat('0.000',StrToFloat(sgDatos.Cells[5,Cont])+StrToFloat(importe));
         end else begin    // Hay datos, se calcula sobre el dato modificado
            sgDatos.Cells[6,cont]:=FormatFloat('0.000',StrToFloat(sgDatos.Cells[6,Cont])+StrToFloat(importe));
         end;
         sgDatos.Cells[3,Cont]:=FormatFloat('0.000',RestaPorcen(StrToFloat(sgDatos.Cells[6,Cont]),
                                                                StrToFloat(sgDatos.Cells[4,Cont])));
     end;
  end;
end;

procedure TfActAutArt.bbAplicarClick(Sender: TObject);
var
  cont: integer;
  HistErrorShown, TarExiste: Boolean;
  OldTarSinIVA, OldTarConIVA: string;
begin
  HistErrorShown := False;
  if not cgActTarifas.Checked[0] and
     not cgActTarifas.Checked[1] and
     not cgActTarifas.Checked[2] and
     not cgActTarifas.Checked[3] then begin
         ShowMessage('DEBE SELECCIONAR AL MENOS UNA TARIFA');
         Abort;
     end;
  if Application.MessageBox('SE VA A PROCEDER A ACTUALIZAR LOS DATOS' +
     #13 + '¿DESEA CONTINUAR?', 'FacturLinEx',
     MB_ICONQUESTION + MB_YESNO) = idNo then abort;

  if cgActTarifas.Checked[0] then begin     // Actualizacion de Tarifa General
     for cont:=1 to SgDatos.RowCount-1 do begin
         if sgDatos.Cells[3,cont]<>'' then begin
            if Query.Active then Query.Close;
            Query.SQL.Clear;
            Query.SQL.Add('UPDATE artitien'+global.Tienda+' ');
            Query.SQL.Add('SET A21='''+sgDatos.Cells[3,cont]+''',');
            Query.SQL.Add('    A2 ='''+sgDatos.Cells[6,cont]+''' ');
            Query.SQL.Add('WHERE A0='''+sgDatos.Cells[0,cont]+'''');
            Query.ExecSQL;
            try
              RegistrarCambioPrecio(sgDatos.Cells[0,cont], sgDatos.Cells[1,cont],
                'A21 PVP sin IVA', sgDatos.Cells[2,cont], sgDatos.Cells[3,cont],
                'Actualizacion automatica de articulos / tarifa general');
              RegistrarCambioPrecio(sgDatos.Cells[0,cont], sgDatos.Cells[1,cont],
                'A2 PVP con IVA', sgDatos.Cells[5,cont], sgDatos.Cells[6,cont],
                'Actualizacion automatica de articulos / tarifa general');
            except
              on E: Exception do
              begin
                if not HistErrorShown then
                  ShowMessage('Los precios se han actualizado, pero no se pudo registrar algun historico de precios: ' + E.Message);
                HistErrorShown := True;
              end;
            end;
         end;
     end;
  end;

  if cgActTarifas.Checked[1] then begin     // Actualizacion de Tarifa 1
     for cont:=1 to SgDatos.RowCount-1 do begin
         if sgDatos.Cells[3,cont]<>'' then begin
            TarExiste := LeerValorTarifa(sgDatos.Cells[0,cont], 'TAR2', OldTarSinIVA);
            if TarExiste then
              LeerValorTarifa(sgDatos.Cells[0,cont], 'TAR7', OldTarConIVA)
            else
              OldTarConIVA := '';
            if Query.Active then Query.Close;
            Query.SQL.Clear;
            Query.SQL.Add('UPDATE tarifas');
            Query.SQL.Add('SET TAR2='''+sgDatos.Cells[3,cont]+''',');
            Query.SQL.Add('    TAR7='''+sgDatos.Cells[6,cont]+''' ');
            Query.SQL.Add('WHERE TAR0='''+sgDatos.Cells[0,cont]+'''');
            Query.ExecSQL;
            if TarExiste then
            begin
              try
                RegistrarCambioPrecio(sgDatos.Cells[0,cont], sgDatos.Cells[1,cont],
                  'TAR2 Tarifa 1 sin IVA', OldTarSinIVA, sgDatos.Cells[3,cont],
                  'Actualizacion automatica de articulos / tarifa 1');
                RegistrarCambioPrecio(sgDatos.Cells[0,cont], sgDatos.Cells[1,cont],
                  'TAR7 Tarifa 1 con IVA', OldTarConIVA, sgDatos.Cells[6,cont],
                  'Actualizacion automatica de articulos / tarifa 1');
              except
                on E: Exception do
                begin
                  if not HistErrorShown then
                    ShowMessage('Los precios se han actualizado, pero no se pudo registrar algun historico de precios: ' + E.Message);
                  HistErrorShown := True;
                end;
              end;
            end;
         end;
     end;
  end;

  if cgActTarifas.Checked[2] then begin     // Actualizacion de Tarifa 2
     for cont:=1 to SgDatos.RowCount-1 do begin
         if sgDatos.Cells[3,cont]<>'' then begin
            TarExiste := LeerValorTarifa(sgDatos.Cells[0,cont], 'TAR4', OldTarSinIVA);
            if TarExiste then
              LeerValorTarifa(sgDatos.Cells[0,cont], 'TAR8', OldTarConIVA)
            else
              OldTarConIVA := '';
            if Query.Active then Query.Close;
            Query.SQL.Clear;
            Query.SQL.Add('UPDATE tarifas');
            Query.SQL.Add('SET TAR4='''+sgDatos.Cells[3,cont]+''',');
            Query.SQL.Add('    TAR8='''+sgDatos.Cells[6,cont]+''' ');
            Query.SQL.Add('WHERE TAR0='''+sgDatos.Cells[0,cont]+'''');
            Query.ExecSQL;
            if TarExiste then
            begin
              try
                RegistrarCambioPrecio(sgDatos.Cells[0,cont], sgDatos.Cells[1,cont],
                  'TAR4 Tarifa 2 sin IVA', OldTarSinIVA, sgDatos.Cells[3,cont],
                  'Actualizacion automatica de articulos / tarifa 2');
                RegistrarCambioPrecio(sgDatos.Cells[0,cont], sgDatos.Cells[1,cont],
                  'TAR8 Tarifa 2 con IVA', OldTarConIVA, sgDatos.Cells[6,cont],
                  'Actualizacion automatica de articulos / tarifa 2');
              except
                on E: Exception do
                begin
                  if not HistErrorShown then
                    ShowMessage('Los precios se han actualizado, pero no se pudo registrar algun historico de precios: ' + E.Message);
                  HistErrorShown := True;
                end;
              end;
            end;
         end;
     end;
  end;

  if cgActTarifas.Checked[3] then begin     // Actualizacion de Tarifa 3
     for cont:=1 to SgDatos.RowCount-1 do begin
         if sgDatos.Cells[3,cont]<>'' then begin
            TarExiste := LeerValorTarifa(sgDatos.Cells[0,cont], 'TAR6', OldTarSinIVA);
            if TarExiste then
              LeerValorTarifa(sgDatos.Cells[0,cont], 'TAR9', OldTarConIVA)
            else
              OldTarConIVA := '';
            if Query.Active then Query.Close;
            Query.SQL.Clear;
            Query.SQL.Add('UPDATE tarifas');
            Query.SQL.Add('SET TAR6='''+sgDatos.Cells[3,cont]+''',');
            Query.SQL.Add('    TAR9='''+sgDatos.Cells[6,cont]+''' ');
            Query.SQL.Add('WHERE TAR0='''+sgDatos.Cells[0,cont]+'''');
            Query.ExecSQL;
            if TarExiste then
            begin
              try
                RegistrarCambioPrecio(sgDatos.Cells[0,cont], sgDatos.Cells[1,cont],
                  'TAR6 Tarifa 3 sin IVA', OldTarSinIVA, sgDatos.Cells[3,cont],
                  'Actualizacion automatica de articulos / tarifa 3');
                RegistrarCambioPrecio(sgDatos.Cells[0,cont], sgDatos.Cells[1,cont],
                  'TAR9 Tarifa 3 con IVA', OldTarConIVA, sgDatos.Cells[6,cont],
                  'Actualizacion automatica de articulos / tarifa 3');
              except
                on E: Exception do
                begin
                  if not HistErrorShown then
                    ShowMessage('Los precios se han actualizado, pero no se pudo registrar algun historico de precios: ' + E.Message);
                  HistErrorShown := True;
                end;
              end;
            end;
         end;
     end;
  end;

  ShowMessage('¡¡ PROCESO REALIZADO SATISFACTORIAMENTE !!');
  sgDatos.Clear;
end;

procedure TfActAutArt.FormResize(Sender: TObject);
begin
  RecolocarControlesModernos;
end;

procedure TfActAutArt.FormShow(Sender: TObject);
begin
  { En algunos gestores de ventanas X11, wsMaximized en OnCreate puede ignorarse.
    Reforzamos el estado al mostrarse y recolocamos tras conocer el tamano real. }
  WindowState := wsMaximized;
  RecolocarControlesModernos;
end;

procedure TfActAutArt.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  cont: integer;
  modif: boolean;
begin
  // Si se han modificado precios, se pide confirmación para salir
  if (sgDatos.RowCount > 1) then
  begin
    modif:=false;
    { La fila 0 es la cabecera fija: nunca debe contarse como modificacion. }
    for cont:=1 to SgDatos.RowCount-1 do
    begin
        if (Trim(sgDatos.Cells[3,cont])<>'') or (Trim(sgDatos.Cells[6,cont])<>'') then
        begin
          modif:=true;
          Break;
        end;
    end;
    if (modif=true) then
       if Application.MessageBox('¡ HAY PRECIOS MODIFICADOS !' +
         #13 + '¿DESEA REALMENTE SALIR?', 'FacturLinEx',
         MB_ICONQUESTION + MB_YESNO) = idNo then abort;
  end;

  if dbArticulos.Active then dbArticulos.Close;
  CloseAction:=caFree;
end;

procedure TfActAutArt.FormCreate(Sender: TObject);
begin
  OnShow := @FormShow;
  AplicarEstiloModerno;
  OnResize := @FormResize;
  RecolocarControlesModernos;

  //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.
  // Carga de los datos en el POPUP de Autores / Fabricantes
  dbAutoFabri.SQL.Add('SELECT * FROM autofabri ORDER BY AUT1');
  dbAutoFabri.Open;
  dbAutoFabri.First;
  while not dbAutoFabri.EOF do begin
        cbAutor.Items.Add(dbAutoFabri.FieldByName('AUT1').Text);
        dbAutoFabri.Next;
  end;
  // Carga de los datos en el POPUP de Familias
  dbFamilias.SQL.Add('SELECT * FROM familias'+Tienda+' ORDER BY F1');
  dbFamilias.Open;
  dbFamilias.First;
  while not dbFamilias.EOF do begin
        cbFamilia.Items.Add(dbFamilias.FieldByName('F1').Text);
        dbFamilias.Next;
  end;
  // Carga de los datos en el POPUP de Proveedores
  dbProveedores.SQL.Add('SELECT * FROM proveedores ORDER BY P1');
  dbProveedores.Open;
  dbProveedores.First;
  while not dbProveedores.EOF do begin
        cbProveedor.Items.Add(dbproveedores.FieldByName('P1').Text);
        dbproveedores.Next;
  end;
  dbAutoFabri.Close;
  dbFamilias.Close;
  dbProveedores.Close;
end;

procedure TfActAutArt.sgDatosKeyPress(Sender: TObject; var Key: char);
var
  precio: string;
begin
  if (key=#13) and ((sgDatos.Col=3) or (sgDatos.Col=6)) then
  begin
     precio:=InputBox('FacturLinEx 2','Introducir precio','');
     if not (EsFloat(precio)) then        // Salimos si no hay datos buenos.
     begin
         key:=#0;
         exit;
     end;

     if sgDatos.Col=3 then begin   // INTRO en el cambio de Precio Sin IVA
        sgDatos.Cells[3,sgDatos.Row]:=FormatFloat('0.000',StrToFloat(precio));
        sgDatos.Cells[6,sgDatos.Row]:=FormatFloat('0.000',SumaPorcen(StrToFloat(sgDatos.Cells[3,sgDatos.Row]),
                                                                     StrToFloat(sgDatos.Cells[4,sgDatos.Row])));
     end;
     if sgDatos.Col=6 then begin   // INTRO en el cambio de Precio Con IVA incluido
        sgDatos.Cells[6,sgDatos.Row]:=FormatFloat('0.000',StrToFloat(precio));
        sgDatos.Cells[3,sgDatos.Row]:=FormatFloat('0.000',RestaPorcen(StrToFloat(sgDatos.Cells[6,sgDatos.Row]),
                                                                      StrToFloat(sgDatos.Cells[4,sgDatos.Row])));
     end;
     sgDatos.Row:= sgDatos.Row+1;
     key:=#0;
  end;
end;

initialization
  {$I actautart.lrs}

end.

