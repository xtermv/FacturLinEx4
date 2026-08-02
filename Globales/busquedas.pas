{
  Gestion LinEx FacturLinEx

  Copyright (C) 2008-2009, Equipo de colaboradores.

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

unit Busquedas;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  DBGrids, ZConnection, ZDataset, db, ExtCtrls, StdCtrls, Buttons, LCLType;

type

  { TFBusquedas }

  TFBusquedas = class(TForm)
    BtAplicar: TBitBtn;
    BtCancelar: TBitBtn;
    BtCerrar: TBitBtn;
    CBCampos: TComboBox;
    CBFiltros: TComboBox;
    Datasource1: TDatasource;
    dbBusquedas: TZQuery;
    GridBusquedas: TDBGrid;
    EdTexto: TEdit;
    GBCampo: TGroupBox;
    GBTexto: TGroupBox;
    GroupBox1: TGroupBox;

    procedure BtAplicarClick(Sender: TObject);
    procedure BtCancelarClick(Sender: TObject);
    procedure CBFiltrosChange(Sender: TObject);
    procedure DividirConsulta(TxtConsulta: string);
    procedure BtCerrarClick(Sender: TObject);
    procedure CBCamposChange(Sender: TObject);
    procedure EdTextoChange(Sender: TObject);
    procedure EdTextoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ActualizaGrid;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridBusquedasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridBusquedasTitleClick(Column: TColumn);
    procedure Reordena(nColumna: integer; var AntColund: String; var Orden: String);

    function IniciaBusquedas(TxtConsulta: string; const TituloCampos: Array of string; CampoBusqueda: string ):string;
    function CargaTitulos(var TitulosGrid: TDBGrid): variant;

  private
    { Capa visual moderna. No altera consultas ni tratamiento de datos. }
    FHeaderBar: TPanel;
    FHeaderTitle: TLabel;
    FHeaderSubtitle: TLabel;
    FFilterPanel: TPanel;
    FGridPanel: TPanel;
    FFooterPanel: TPanel;
    FFooterHint: TLabel;

    function CrearPanelVisual(AParent: TWinControl;
      AColor: TColor): TPanel;
    procedure EstilarBoton(ABoton: TBitBtn; AColor: TColor;
      ATextoClaro: Boolean);
    procedure AplicarEstiloModerno;
    procedure ReorganizarFormulario;
    procedure FormResizeModerno(Sender: TObject);
    procedure FormShowModerno(Sender: TObject);
    function PosPalabraSQL(const ASQL, APalabra: String): Integer;
    function EsConsultaArticulos(const ASQL, ACampoBusqueda: String): Boolean;
    function CampoSeleccionado(const ASQL, ACampo: String): Boolean;
    function ExtraerCalificadorArticulos(const ASQL: String): String;
    function AmpliarConsultaArticulos(const ASQL: String;
      out AAnadeUltCompra, AAnadePVP, AAnadeUltVenta: Boolean): String;
    procedure ConfigurarColumnasArticulos;
  public
    { public declarations }
  end; 

    procedure ShowFormBusquedas;

var
  AntColumna, Orden: String;
  FBusquedas: TFBusquedas;
  ConsultaOriginal, Consulta, ConsultaAnterior: string;
  InicioConsulta, FinalConsulta: string;
  CampoBuscar: string;
  modificador: string;
  Comodin: string;
  Resultado: variant;
  TxtCampos: array of string;
  RefCampos: array of string;
  BusquedaArticulosActual: Boolean;

implementation

uses
 Funciones, uFLXTemaVisual;


//============================================================================
//====================== DISEÑO MODERNO Y ADAPTABLE ==========================
//============================================================================
function TFBusquedas.CrearPanelVisual(AParent: TWinControl;
  AColor: TColor): TPanel;
begin
  Result := TPanel.Create(Self);
  Result.Parent := AParent;
  Result.Caption := '';
  Result.BevelOuter := bvNone;
  Result.BevelInner := bvNone;
  Result.ParentColor := False;
  Result.Color := AColor;
  Result.TabStop := False;
end;

procedure TFBusquedas.EstilarBoton(ABoton: TBitBtn;
  AColor: TColor; ATextoClaro: Boolean);
begin
  if not Assigned(ABoton) then
    Exit;

  ABoton.ParentFont := False;
  ABoton.Font.Name := 'Sans';
  ABoton.Font.Height := -12;
  ABoton.Font.Style := [fsBold];
  ABoton.Color := AColor;
  ABoton.ShowHint := True;

  if ATextoClaro then
    ABoton.Font.Color := clWhite
  else
    ABoton.Font.Color := RGBToColor(30, 41, 59);
end;

procedure TFBusquedas.AplicarEstiloModerno;
var
  AnchoDeseado, AltoDeseado: Integer;
begin
  Caption := 'FacturLinEx · Búsqueda y selección';
  Color := RGBToColor(241, 245, 247);
  BorderStyle := bsSizeable;

  { Excepción visual deliberada: este formulario es una ventana auxiliar
    modal. Se abre en tamaño medio para mantener visible el formulario
    que lo invoca, mientras el resto de formularios continúa maximizado. }
  WindowState := wsNormal;
  Position := poMainFormCenter;
  Constraints.MinWidth := 640;
  Constraints.MinHeight := 480;

  AnchoDeseado := (Screen.WorkAreaWidth * 76) div 100;
  if AnchoDeseado > 1120 then
    AnchoDeseado := 1120;
  if AnchoDeseado < 820 then
    AnchoDeseado := 820;
  if AnchoDeseado > Screen.WorkAreaWidth - 140 then
    AnchoDeseado := Screen.WorkAreaWidth - 140;
  if AnchoDeseado < 640 then
    AnchoDeseado := 640;

  AltoDeseado := (Screen.WorkAreaHeight * 76) div 100;
  if AltoDeseado > 720 then
    AltoDeseado := 720;
  if AltoDeseado < 560 then
    AltoDeseado := 560;
  if AltoDeseado > Screen.WorkAreaHeight - 120 then
    AltoDeseado := Screen.WorkAreaHeight - 120;
  if AltoDeseado < 480 then
    AltoDeseado := 480;

  Width := AnchoDeseado;
  Height := AltoDeseado;

  FHeaderBar := CrearPanelVisual(Self, RGBToColor(18, 76, 91));
  FHeaderTitle := TLabel.Create(FHeaderBar);
  FHeaderTitle.Parent := FHeaderBar;
  FHeaderTitle.AutoSize := False;
  FHeaderTitle.Transparent := True;
  FHeaderTitle.ParentFont := False;
  FHeaderTitle.Font.Name := 'Sans';
  FHeaderTitle.Font.Height := -20;
  FHeaderTitle.Font.Style := [fsBold];
  FHeaderTitle.Font.Color := clWhite;
  FHeaderTitle.Caption := 'BÚSQUEDA Y SELECCIÓN';

  FHeaderSubtitle := TLabel.Create(FHeaderBar);
  FHeaderSubtitle.Parent := FHeaderBar;
  FHeaderSubtitle.AutoSize := False;
  FHeaderSubtitle.Transparent := True;
  FHeaderSubtitle.ParentFont := False;
  FHeaderSubtitle.Font.Name := 'Sans';
  FHeaderSubtitle.Font.Height := -11;
  FHeaderSubtitle.Font.Color := RGBToColor(205, 232, 237);
  FHeaderSubtitle.Caption :=
    'Use ↑/↓ para seleccionar · ENTER acepta · F12 alterna entre grid y texto · ESC cancela';

  FFilterPanel := CrearPanelVisual(Self, RGBToColor(225, 233, 236));
  FFilterPanel.BevelOuter := bvNone;

  FGridPanel := CrearPanelVisual(Self, RGBToColor(241, 245, 247));
  FGridPanel.BevelOuter := bvNone;
  FGridPanel.BorderWidth := 10;

  FFooterPanel := CrearPanelVisual(Self, RGBToColor(225, 233, 236));
  FFooterPanel.BevelOuter := bvNone;

  GBCampo.Parent := FFilterPanel;
  GroupBox1.Parent := FFilterPanel;
  GBTexto.Parent := FFilterPanel;

  GBCampo.ParentFont := False;
  GBCampo.Font.Name := 'Sans';
  GBCampo.Font.Height := -11;
  GBCampo.Font.Style := [fsBold];
  GBCampo.Font.Color := RGBToColor(38, 77, 96);
  GBCampo.ParentBackground := False;
  GBCampo.ParentColor := False;
  GBCampo.Color := RGBToColor(226, 238, 242);
  GBCampo.Caption := '  CAMPO DE BÚSQUEDA  ';

  GroupBox1.ParentFont := False;
  GroupBox1.Font.Name := 'Sans';
  GroupBox1.Font.Height := -11;
  GroupBox1.Font.Style := [fsBold];
  GroupBox1.Font.Color := RGBToColor(38, 77, 96);
  GroupBox1.ParentBackground := False;
  GroupBox1.ParentColor := False;
  GroupBox1.Color := RGBToColor(239, 235, 247);
  GroupBox1.Caption := '  FILTRO A APLICAR  ';

  GBTexto.ParentFont := False;
  GBTexto.Font.Name := 'Sans';
  GBTexto.Font.Height := -11;
  GBTexto.Font.Style := [fsBold];
  GBTexto.Font.Color := RGBToColor(38, 77, 96);
  GBTexto.ParentBackground := False;
  GBTexto.ParentColor := False;
  GBTexto.Color := RGBToColor(231, 243, 234);
  GBTexto.Caption := '  TEXTO A BUSCAR  ';

  CBCampos.ParentFont := False;
  CBCampos.Font.Name := 'Sans';
  CBCampos.Font.Height := -12;
  CBCampos.Hint := 'Selecciona la columna por la que buscar u ordenar.';

  CBFiltros.ParentFont := False;
  CBFiltros.Font.Name := 'Sans';
  CBFiltros.Font.Height := -12;
  CBFiltros.Hint := 'Selecciona el tipo de filtro que se aplicará.';

  EdTexto.ParentFont := False;
  EdTexto.Font.Name := 'Sans';
  EdTexto.Font.Height := -12;
  EdTexto.Hint := 'Introduce el texto que deseas localizar.';

  GridBusquedas.Parent := FGridPanel;
  GridBusquedas.Align := alClient;
  GridBusquedas.BorderSpacing.Around := 2;
  GridBusquedas.ParentFont := False;
  GridBusquedas.Font.Name := 'Sans';
  GridBusquedas.Font.Height := -12;
  GridBusquedas.Font.Color := RGBToColor(30, 41, 59);
  GridBusquedas.TitleFont.Name := 'Sans';
  GridBusquedas.TitleFont.Height := -12;
  GridBusquedas.TitleFont.Style := [fsBold];
  GridBusquedas.TitleFont.Color := RGBToColor(30, 41, 59);
  GridBusquedas.Color := clWhite;
  GridBusquedas.FixedColor := RGBToColor(218, 232, 236);
  GridBusquedas.DefaultRowHeight := 28;
  GridBusquedas.TabStop := True;
  GridBusquedas.Hint :=
    'Seleccione una fila con ↑/↓ y pulse ENTER para aceptarla.';

  BtAplicar.Parent := FFooterPanel;
  BtCerrar.Parent := FFooterPanel;
  BtCancelar.Parent := FFooterPanel;

  BtAplicar.Caption := 'Aplicar filtro';
  BtCerrar.Caption := 'Aceptar selección';
  BtCancelar.Caption := 'Cancelar';

  EstilarBoton(BtAplicar, RGBToColor(23, 96, 116), True);
  EstilarBoton(BtCerrar, RGBToColor(47, 143, 87), True);
  EstilarBoton(BtCancelar, RGBToColor(71, 85, 105), True);

  FFooterHint := TLabel.Create(FFooterPanel);
  FFooterHint.Parent := FFooterPanel;
  FFooterHint.AutoSize := False;
  FFooterHint.Transparent := True;
  FFooterHint.ParentFont := False;
  FFooterHint.Font.Name := 'Sans';
  FFooterHint.Font.Height := -10;
  FFooterHint.Font.Color := RGBToColor(71, 85, 105);
  FFooterHint.Alignment := taLeftJustify;
  FFooterHint.Layout := tlCenter;
  FFooterHint.Caption :=
    'F8: aplicar filtro    F12: grid/texto    ENTER: aceptar    ESC: cancelar';

  OnResize := @FormResizeModerno;
  OnShow := @FormShowModerno;

  ReorganizarFormulario;

  { El LFM recibido fija ActiveControl=CBCampos. Se sustituye expresamente
    para que la búsqueda se abra preparada para seleccionar con teclado. }
  ActiveControl := GridBusquedas;
end;

procedure TFBusquedas.ReorganizarFormulario;
var
  W, H, FiltroW, CampoW, TipoW, TextoW: Integer;
  BotonW, BotonH, Separacion, TotalBotones, InicioBotones: Integer;
begin
  if not Assigned(FHeaderBar) then
    Exit;

  W := ClientWidth;
  H := ClientHeight;

  FHeaderBar.SetBounds(0, 0, W, 76);
  FHeaderTitle.SetBounds(24, 12, W - 48, 30);
  FHeaderSubtitle.SetBounds(24, 43, W - 48, 22);

  FFilterPanel.SetBounds(12, 88, W - 24, 92);
  FiltroW := FFilterPanel.ClientWidth - 24;

  CampoW := (FiltroW * 28) div 100;
  if CampoW < 270 then
    CampoW := 270;

  TipoW := (FiltroW * 27) div 100;
  if TipoW < 260 then
    TipoW := 260;

  TextoW := FiltroW - CampoW - TipoW - 16;
  if TextoW < 300 then
  begin
    TextoW := 300;
    CampoW := (FiltroW - TextoW - 16) div 2;
    TipoW := CampoW;
  end;

  GBCampo.SetBounds(12, 8, CampoW, 76);
  GroupBox1.SetBounds(20 + CampoW, 8, TipoW, 76);
  GBTexto.SetBounds(28 + CampoW + TipoW, 8, TextoW, 76);

  CBCampos.SetBounds(12, 23, GBCampo.ClientWidth - 24, 32);
  CBFiltros.SetBounds(12, 23, GroupBox1.ClientWidth - 24, 32);
  EdTexto.SetBounds(12, 23, GBTexto.ClientWidth - 24, 32);

  FFooterPanel.SetBounds(0, H - 76, W, 76);
  FGridPanel.SetBounds(12, 190, W - 24, H - 278);

  BotonW := 170;
  BotonH := 42;
  Separacion := 18;
  TotalBotones := (BotonW * 3) + (Separacion * 2);
  InicioBotones := W - TotalBotones - 24;

  if InicioBotones < 260 then
    InicioBotones := 260;

  BtAplicar.SetBounds(InicioBotones, 17, BotonW, BotonH);
  BtCerrar.SetBounds(InicioBotones + BotonW + Separacion,
    17, BotonW, BotonH);
  BtCancelar.SetBounds(InicioBotones + ((BotonW + Separacion) * 2),
    17, BotonW, BotonH);

  FFooterHint.SetBounds(24, 17, InicioBotones - 48, BotonH);

  FHeaderBar.BringToFront;
  FFilterPanel.BringToFront;
  FFooterPanel.BringToFront;
  FGridPanel.BringToFront;
  GridBusquedas.BringToFront;
end;


function TFBusquedas.PosPalabraSQL(const ASQL, APalabra: String): Integer;
var
  I, L: Integer;
  SQLMayus, PalabraMayus: String;

  function EsIdentificador(C: Char): Boolean;
  begin
    Result := (C in ['A'..'Z', 'a'..'z', '0'..'9', '_']);
  end;

begin
  Result := 0;
  SQLMayus := UpperCase(ASQL);
  PalabraMayus := UpperCase(APalabra);
  L := Length(PalabraMayus);
  if L = 0 then Exit;

  for I := 1 to Length(SQLMayus) - L + 1 do
    if Copy(SQLMayus, I, L) = PalabraMayus then
      if ((I = 1) or not EsIdentificador(SQLMayus[I - 1])) and
         ((I + L > Length(SQLMayus)) or
          not EsIdentificador(SQLMayus[I + L])) then
      begin
        Result := I;
        Exit;
      end;
end;

function TFBusquedas.EsConsultaArticulos(const ASQL,
  ACampoBusqueda: String): Boolean;
var
  SQLMayus: String;
  P: Integer;
begin
  { Solo se considera selector de artículos cuando devuelve A0 y la consulta
    usa realmente una tabla artitienXXXX. Así una consulta de clientes,
    proveedores, familias o históricos queda completamente intacta. }
  if UpperCase(Trim(ACampoBusqueda)) <> 'A0' then
  begin
    Result := False;
    Exit;
  end;

  SQLMayus := UpperCase(ASQL);
  P := Pos('ARTITIEN', SQLMayus);
  Result := P > 0;

  if Result and (P > 1) then
    Result := not (SQLMayus[P - 1] in ['A'..'Z', '0'..'9', '_']);
end;

function TFBusquedas.CampoSeleccionado(const ASQL, ACampo: String): Boolean;
var
  PSelect, PFrom, I: Integer;
  ParteSelect, ParteSelectMayus, Token: String;
  Tokens: TStringList;
begin
  Result := False;
  PSelect := PosPalabraSQL(ASQL, 'SELECT');
  PFrom := PosPalabraSQL(ASQL, 'FROM');
  if (PSelect = 0) or (PFrom = 0) or (PFrom <= PSelect) then Exit;

  ParteSelect := Copy(ASQL, PSelect + Length('SELECT'),
    PFrom - (PSelect + Length('SELECT')));

  { SELECT * ya contiene todos los campos de artitien. }
  if Pos('*', ParteSelect) > 0 then
    Exit(True);

  ParteSelectMayus := UpperCase(ParteSelect);
  Tokens := TStringList.Create;
  try
    ExtractStrings([' ', #9, #10, #13, ',', '.', '(', ')', '`', '+', '-',
      '/', '*'], [], PChar(ParteSelectMayus), Tokens);
    for I := 0 to Tokens.Count - 1 do
    begin
      Token := Trim(Tokens[I]);
      if Token = UpperCase(ACampo) then
        Exit(True);
    end;
  finally
    Tokens.Free;
  end;
end;

function TFBusquedas.ExtraerCalificadorArticulos(const ASQL: String): String;
var
  SQLMayus, Tabla, Palabra, PalabraMayus: String;
  P, I, Inicio: Integer;
  EsReservada: Boolean;

  function EsIdentificador(C: Char): Boolean;
  begin
    Result := C in ['A'..'Z', 'a'..'z', '0'..'9', '_'];
  end;

  procedure SaltarEspacios(var APos: Integer);
  begin
    while (APos <= Length(ASQL)) and
      (ASQL[APos] in [' ', #9, #10, #13]) do Inc(APos);
  end;

  function LeerPalabra(var APos: Integer): String;
  var
    PIni: Integer;
  begin
    SaltarEspacios(APos);
    PIni := APos;
    while (APos <= Length(ASQL)) and EsIdentificador(ASQL[APos]) do
      Inc(APos);
    Result := Copy(ASQL, PIni, APos - PIni);
  end;

begin
  Result := '';
  SQLMayus := UpperCase(ASQL);
  P := Pos('ARTITIEN', SQLMayus);
  if P = 0 then Exit;

  Inicio := P;
  I := P;
  while (I <= Length(ASQL)) and EsIdentificador(ASQL[I]) do Inc(I);
  Tabla := Copy(ASQL, Inicio, I - Inicio);
  if Tabla = '' then Exit;
  Result := Tabla;

  { Si la tabla tiene alias, hay que usarlo al añadir A13/A2/A12. }
  SaltarEspacios(I);
  if (I > Length(ASQL)) or (ASQL[I] = ',') then Exit;

  Palabra := LeerPalabra(I);
  if UpperCase(Palabra) = 'AS' then
  begin
    Palabra := LeerPalabra(I);
    if Palabra <> '' then Result := Palabra;
    Exit;
  end;

  if Palabra = '' then Exit;
  PalabraMayus := UpperCase(Palabra);
  EsReservada :=
    (PalabraMayus = 'WHERE') or (PalabraMayus = 'LEFT') or
    (PalabraMayus = 'RIGHT') or (PalabraMayus = 'INNER') or
    (PalabraMayus = 'OUTER') or (PalabraMayus = 'JOIN') or
    (PalabraMayus = 'ON') or (PalabraMayus = 'GROUP') or
    (PalabraMayus = 'ORDER') or (PalabraMayus = 'LIMIT') or
    (PalabraMayus = 'HAVING') or (PalabraMayus = 'UNION') or
    (PalabraMayus = 'CROSS') or (PalabraMayus = 'STRAIGHT_JOIN');
  if not EsReservada then Result := Palabra;
end;

function TFBusquedas.AmpliarConsultaArticulos(const ASQL: String;
  out AAnadeUltCompra, AAnadePVP, AAnadeUltVenta: Boolean): String;
var
  PFrom: Integer;
  Calificador, CamposExtra: String;
begin
  Result := ASQL;
  AAnadeUltCompra := False;
  AAnadePVP := False;
  AAnadeUltVenta := False;

  PFrom := PosPalabraSQL(ASQL, 'FROM');
  Calificador := ExtraerCalificadorArticulos(ASQL);
  if (PFrom = 0) or (Calificador = '') then Exit;

  CamposExtra := '';
  if not CampoSeleccionado(ASQL, 'A13') then
  begin
    CamposExtra := CamposExtra + ', ' + Calificador + '.A13 AS A13';
    AAnadeUltCompra := True;
  end;
  if not CampoSeleccionado(ASQL, 'A2') then
  begin
    CamposExtra := CamposExtra + ', ' + Calificador + '.A2 AS A2';
    AAnadePVP := True;
  end;
  if not CampoSeleccionado(ASQL, 'A12') then
  begin
    CamposExtra := CamposExtra + ', ' + Calificador + '.A12 AS A12';
    AAnadeUltVenta := True;
  end;

  if CamposExtra <> '' then
    Insert(CamposExtra + ' ', Result, PFrom);
end;

procedure TFBusquedas.ConfigurarColumnasArticulos;
var
  I: Integer;
  Campo: String;
begin
  if not BusquedaArticulosActual then Exit;

  if Assigned(dbBusquedas.FindField('A13')) and
     (dbBusquedas.FieldByName('A13') is TDateTimeField) then
    TDateTimeField(dbBusquedas.FieldByName('A13')).DisplayFormat := 'dd/mm/yyyy';

  if Assigned(dbBusquedas.FindField('A12')) and
     (dbBusquedas.FieldByName('A12') is TDateTimeField) then
    TDateTimeField(dbBusquedas.FieldByName('A12')).DisplayFormat := 'dd/mm/yyyy';

  if Assigned(dbBusquedas.FindField('A2')) and
     (dbBusquedas.FieldByName('A2') is TNumericField) then
    TNumericField(dbBusquedas.FieldByName('A2')).DisplayFormat := '#,##0.00';

  for I := 0 to GridBusquedas.Columns.Count - 1 do
  begin
    Campo := UpperCase(GridBusquedas.Columns[I].FieldName);
    if Campo = 'A0' then
      GridBusquedas.Columns[I].Width := 110
    else if Campo = 'EAN0' then
      GridBusquedas.Columns[I].Width := 125
    else if Campo = 'A1' then
      GridBusquedas.Columns[I].Width := 350
    else if Campo = 'A13' then
    begin
      GridBusquedas.Columns[I].Width := 120;
      GridBusquedas.Columns[I].Alignment := taCenter;
    end
    else if Campo = 'A2' then
    begin
      GridBusquedas.Columns[I].Width := 95;
      GridBusquedas.Columns[I].Alignment := taRightJustify;
    end
    else if Campo = 'A12' then
    begin
      GridBusquedas.Columns[I].Width := 120;
      GridBusquedas.Columns[I].Alignment := taCenter;
    end;
  end;
end;

procedure TFBusquedas.FormResizeModerno(Sender: TObject);
begin
  ReorganizarFormulario;
end;

procedure TFBusquedas.FormShowModerno(Sender: TObject);
begin
  { OnShow es el momento fiable: el grid ya tiene Handle, columnas y dataset. }
  ActiveControl := GridBusquedas;
  if GridBusquedas.CanFocus then
    GridBusquedas.SetFocus;
  FLXAplicarTemaVisual(Self);
end;


{ TFBusquedas }

procedure ShowFormBusquedas;
begin
  with TFBusquedas.Create(Application) do
    begin
      ShowModal;
    end;
end;


function TFBusquedas.IniciaBusquedas(TxtConsulta: string;
  const TituloCampos: Array of string; CampoBusqueda: string): string;
var
  contador, N: Integer;
  AnadeUltCompra, AnadePVP, AnadeUltVenta: Boolean;

  procedure AnadirTitulo(const ATitulo: String);
  begin
    N := Length(TxtCampos);
    SetLength(TxtCampos, N + 1);
    TxtCampos[N] := ATitulo;
  end;

begin
   Resultado:='';
   AntColumna:='';
   Orden:= ' ASC';
   CampoBuscar:= CampoBusqueda;
   modificador:=' LIKE '; Comodin:='%';

   SetLength(TxtCampos, Length(TituloCampos));
   for contador:=High(TituloCampos) downto Low(TituloCampos) do
     TxtCampos[contador]:= TituloCampos[contador];

   { Detección automática: no cambia la firma ni obliga a modificar ninguna
     llamada existente. Solo se amplía una búsqueda que devuelve A0 y consulta
     una tabla artitienXXXX. }
   BusquedaArticulosActual := EsConsultaArticulos(TxtConsulta, CampoBusqueda);
   if BusquedaArticulosActual then
   begin
     TxtConsulta := AmpliarConsultaArticulos(TxtConsulta, AnadeUltCompra,
       AnadePVP, AnadeUltVenta);
     if AnadeUltCompra then AnadirTitulo('Fecha última compra');
     if AnadePVP then AnadirTitulo('PVP');
     if AnadeUltVenta then AnadirTitulo('Fecha última venta');
   end;

   Consulta:= TxtConsulta;
   ConsultaOriginal:= Consulta;

   ShowFormBusquedas;
   Result:= Resultado;
end;

procedure TFBusquedas.BtAplicarClick(Sender: TObject);
begin
  if modificador='' then
     begin
        Showmessage('NO HAY SELECCIONADO UN FILTRO');
        Exit;
     end;
  if modificador = 'N0' then begin
                               CBFiltros.ItemIndex:= 0;
                               Consulta:= ConsultaAnterior ;
                               ActualizaGrid;
                               CBCampos.ItemIndex:= 1;
                               CBCamposChange(Self);
                               exit;
                             end;
  if modificador = 'N1' then begin
                               CBFiltros.ItemIndex:= 0;
                               Consulta:= ConsultaOriginal;
                               ActualizaGrid;
                               CBCampos.ItemIndex:= 1;
                               CBCamposChange(Self);
                               exit;
                             end;
  if  edTexto.Text='' then
     begin
        Showmessage('NO HAY VALOR PARA FILTRAR');
        Exit;
     end;
  ConsultaAnterior:= Consulta;
  DividirConsulta(Consulta);
end;

procedure TFBusquedas.BtCancelarClick(Sender: TObject);
begin
   Resultado:=-1;
   Close();
end;

procedure TFBusquedas.CBFiltrosChange(Sender: TObject);
begin
// Comodin:='';
 case CBFiltros.ItemIndex of
   0: modificador:='=';
   1: modificador:='<>';
   2: modificador:='<=';
   3: modificador:='>=';
   4: begin; modificador:=' LIKE '; Comodin:='%'; end;
   5: modificador:='N0';
   6: modificador:='N1';
 end;
end;

procedure TFBusquedas.BtCerrarClick(Sender: TObject);
begin
  if CampoBuscar='' then Resultado := Consulta
                    else Resultado:= dbBusquedas.FieldByName(CampoBuscar).Value;
  if (Resultado = null) then Resultado:=-1;
  Close();
end;

procedure TFBusquedas.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Closeaction:=CaFree;
end;

procedure TFBusquedas.DividirConsulta(TxtConsulta: string);
var
  comillas: string;
  enlazador: string;
  posWhere, posOtras: integer;
begin
  enlazador:= ' AND ';
  comillas:='"';
  InicioConsulta:= TxtConsulta;
  FinalConsulta := TxtConsulta;
  if pos('WHERE', TxtConsulta)=0 then posWhere:= pos('where', TxtConsulta)
                                 else posWhere:= pos('WHERE', TxtConsulta);
  if posWhere<>0 then  begin
                         Delete(InicioConsulta, posWhere , length(TxtConsulta));
                         Delete(FinalConsulta, 1, posWhere +5  );
                       end
                  else
                      begin
                        enlazador:='';
                        if pos('GROUP BY', TxtConsulta)=0 then posOtras:= pos('group by', TxtConsulta)
                                           else posOtras:= pos('GROUP BY', TxtConsulta);
                        if posOtras = 0 then
                                        begin
                                            if pos('ORDER BY', TxtConsulta)=0 then posOtras:= pos('order by', TxtConsulta)
                                                      else posOtras:= pos('ORDER BY', TxtConsulta);
                                        end;
                        posWhere:= posOtras;
                        if posWhere<>0 then
                                         begin
                                          Delete(InicioConsulta, posWhere , length(TxtConsulta));
                                          Delete(FinalConsulta, 1, posWhere-1 );
                                         end
                                       else
                                         begin
                                           FinalConsulta := '';
                                         end;
                     end;

// Los campos numéricos añadidos a artículos no deben entrecomillarse.
 if dbBusquedas.Fields[CBCampos.ItemIndex].DataType in
      [ftBytes, ftVarBytes, ftBlob, ftMemo, ftGraphic,
       ftSmallint, ftInteger, ftWord, ftFloat, ftCurrency,
       ftBCD, ftFMTBcd, ftLargeint, ftAutoInc]
   then comillas:='';
 Consulta := InicioConsulta + 'WHERE ' + RefCampos[CBCampos.ItemIndex] +
               modificador + comillas + Comodin + edTexto.Text+ comodin + comillas + enlazador + ' '+
               FinalConsulta;
 CBFiltros.ItemIndex:= 4;
 ActualizaGrid;
end;

procedure TFBusquedas.ActualizaGrid;
begin
   dbBusquedas.Active:=False;
   dbBusquedas.Sql.Text:=Consulta;
   dbBusquedas.Active:=True;

   Reordena(CBCampos.ItemIndex, AntColumna, Orden);
end;

procedure TFBusquedas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (key=VK_F8) then begin key:=0; btAplicarClick(self); Exit; End;
 if (key=VK_RETURN) then begin key:=0; btCerrarClick(Self); end;
 if (key=VK_ESCAPE) then begin key:=0; btCancelarClick(Self); end;
 if (key=VK_F12) and (GridBusquedas.Focused) then begin key:=0; EdTexto.SetFocus; Exit; End;
 if (key=VK_F12) and (EdTexto.Focused) then begin key:=0; GridBusquedas.SetFocus; Exit; End;

end;

procedure TFBusquedas.GridBusquedasKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=VK_RETURN) then begin key:=0; btCerrarClick(Self); end;
end;

procedure TFBusquedas.GridBusquedasTitleClick(Column: TColumn);
begin
  if (Column = nil) or (Column.Index < 0) or
     (Column.Index >= GridBusquedas.Columns.Count) then Exit;

  ConsultaAnterior := Consulta;
  if Column.Index < CBCampos.Items.Count then
    CBCampos.ItemIndex := Column.Index;
  Reordena(Column.Index, AntColumna, Orden);
  Consulta := dbBusquedas.SQL.Text;
end;

procedure TFBusquedas.CBCamposChange(Sender: TObject);
begin
    ConsultaAnterior:= Consulta;
    GridBusquedas.SelectedColumn.Index:=CBCampos.ItemIndex;
    Reordena(CBCampos.ItemIndex, AntColumna, Orden);
    Consulta:= dbBusquedas.SQL.Text;
end;

procedure TFBusquedas.EdTextoChange(Sender: TObject);
begin
  dbBusquedas.Locate(RefCampos[CBCampos.ItemIndex], EdTexto.Text, [loPartialkey, loCaseInsensitive] )
end;

procedure TFBusquedas.EdTextoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=VK_RETURN) then btCerrarClick(Self);  //BtAplicarClick(Self);
end;

procedure TFBusquedas.FormCreate(Sender: TObject);
var
  ncontador, columnasvisibles, ncolumnas: Integer;
  NombreCampo, TituloCampo: String;
begin
  //Conectate(dbConect);     // Utilizamos datamodule1.dbConexión para toda la aplicación.
  Self.BorderStyle := bsSizeable;
  dbBusquedas.SQL.Text := ConsultaOriginal;
  Datasource1.DataSet := dbBusquedas;
  dbBusquedas.Active := True;

  { La consulta de artículos puede incorporar columnas adicionales. La relación
    para ordenar se reconstruye desde las columnas reales del grid, no desde
    los índices que tenía la consulta original. }
  columnasvisibles := GridBusquedas.Columns.Count;
  if columnasvisibles = 0 then
    columnasvisibles := dbBusquedas.FieldCount;

  CBCampos.Clear;
  SetLength(RefCampos, columnasvisibles);
  CBCampos.ItemIndex := -1;

  for ncolumnas := 0 to columnasvisibles - 1 do
  begin
    NombreCampo := '';
    if (ncolumnas < GridBusquedas.Columns.Count) and
       (GridBusquedas.Columns[ncolumnas].FieldName <> '') then
      NombreCampo := GridBusquedas.Columns[ncolumnas].FieldName
    else if ncolumnas < dbBusquedas.FieldCount then
      NombreCampo := dbBusquedas.Fields[ncolumnas].FieldName;

    RefCampos[ncolumnas] := NombreCampo;

    if ncolumnas < Length(TxtCampos) then
      TituloCampo := TxtCampos[ncolumnas]
    else if (ncolumnas < dbBusquedas.FieldCount) then
      TituloCampo := dbBusquedas.Fields[ncolumnas].DisplayLabel
    else
      TituloCampo := NombreCampo;

    CBCampos.Items.Add(TituloCampo);
    if SameText(CampoBuscar, NombreCampo) then
      CBCampos.ItemIndex := ncolumnas;
  end;

  if (CBCampos.ItemIndex < 0) and (CBCampos.Items.Count > 0) then
    CBCampos.ItemIndex := 0;

  for ncontador := 0 to GridBusquedas.Columns.Count - 1 do
    if ncontador < CBCampos.Items.Count then
      GridBusquedas.Columns[ncontador].Title.Caption := CBCampos.Items[ncontador];

  { Se asigna expresamente porque algunas revisiones del recurso visual podían
    conservar el grid pero no el evento de clic de la cabecera. }
  GridBusquedas.OnTitleClick := @GridBusquedasTitleClick;

  if CBCampos.ItemIndex >= 0 then
    CBCamposChange(Self);
  AplicarEstiloModerno;
  ConfigurarColumnasArticulos;
  GridBusquedas.OnTitleClick := @GridBusquedasTitleClick;
  FLXAplicarTemaVisual(Self);
end;

procedure TFBusquedas.Reordena(nColumna: integer; var AntColund: String;
  var Orden: String);
var
  TxtQuery, TxtQueryMayus, CampoOrden, Direccion: String;
  ncontador, x: Integer;
begin
  if (nColumna < 0) or (nColumna >= GridBusquedas.Columns.Count) then Exit;

  CampoOrden := GridBusquedas.Columns[nColumna].FieldName;
  if (CampoOrden = '') and (nColumna < Length(RefCampos)) then
    CampoOrden := RefCampos[nColumna];
  if CampoOrden = '' then Exit;

  TxtQuery := dbBusquedas.SQL.Text;
  TxtQueryMayus := UpperCase(TxtQuery);
  x := Pos(' ORDER BY ', TxtQueryMayus);
  if x = 0 then
    x := Pos(#10 + 'ORDER BY ', TxtQueryMayus);
  if x = 0 then
    x := Pos(#13 + 'ORDER BY ', TxtQueryMayus);
  if x > 0 then
    Delete(TxtQuery, x, Length(TxtQuery) - x + 1);
  TxtQuery := TrimRight(TxtQuery);

  BlancoGrid(GridBusquedas);

  if (AntColund <> '') and (StrToIntDef(AntColund, -1) = nColumna) then
  begin
    if SameText(Trim(Orden), 'ASC') then
      Orden := 'DESC'
    else
      Orden := 'ASC';
  end
  else
    Orden := 'ASC';

  Direccion := UpperCase(Trim(Orden));
  dbBusquedas.Active := False;
  dbBusquedas.SQL.Text := TxtQuery + ' ORDER BY ' + CampoOrden + ' ' + Direccion;
  dbBusquedas.Active := True;

  AntColund := IntToStr(nColumna);
  if Direccion = 'DESC' then
    GridBusquedas.Columns[nColumna].Color := $00DEDEF5
  else
    GridBusquedas.Columns[nColumna].Color := clSkyBlue;

  for ncontador := 0 to GridBusquedas.Columns.Count - 1 do
    if ncontador < CBCampos.Items.Count then
      GridBusquedas.Columns[ncontador].Title.Caption := CBCampos.Items[ncontador];

  if Direccion = 'DESC' then
    GridBusquedas.Columns[nColumna].Title.Caption :=
      GridBusquedas.Columns[nColumna].Title.Caption + ' ▼'
  else
    GridBusquedas.Columns[nColumna].Title.Caption :=
      GridBusquedas.Columns[nColumna].Title.Caption + ' ▲';
end;

function TFBusquedas.CargaTitulos(var TitulosGrid: TDBGrid): variant;
var
  ncontador: integer;
  Titulos: array of string;
begin
  setlength(Titulos, TitulosGrid.Columns.VisibleCount);
  for ncontador:=0 to length(TxtCampos)-1 do
      Titulos[ncontador]:=TitulosGrid.Columns.Items[ncontador].Title.Caption;
  Result:= Titulos;
end;

initialization
  {$I busquedas.lrs}

end.

