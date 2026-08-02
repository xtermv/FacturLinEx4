unit uFLXInformeIVAPeriodos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, ComCtrls, Grids, EditBtn, DateUtils, ZAbstractConnection, ZDataset;

procedure FLXInstalarInformeIVAPeriodos(AOwner: TComponent;
  APageControl: TPageControl; AConnection: TZAbstractConnection;
  const ATienda: string);

implementation

uses
  Process, LCLIntf, Global, uFLXPDFSimple;

type
  TFLXIVAItem = record
    Puesto: string;
    TipoIVA: string;
    Base: Double;
    Cuota: Double;
    Total: Double;
  end;

  TFLXIVAArray = array of TFLXIVAItem;

  TFLXCajaItem = record
    Puesto: string;
    NumArqueos: Integer;
    Efectivo: Double;
    TarjetasTalones: Double;
    TotalCaja: Double;
    Entregas: Double;
    Credito: Double;
    CambioAnterior: Double;
    NumTarjetas: Integer;
    NumAlbaranes: Integer;
  end;

  TFLXCajaArray = array of TFLXCajaItem;

  TFLXInformeIVAPeriodos = class(TComponent)
  private
    FConnection: TZAbstractConnection;
    FTienda: string;
    FTab: TTabSheet;
    FHeader: TPanel;
    FFilters: TPanel;
    FKpis: TPanel;
    FMainTabs: TPageControl;
    FTabIVA: TTabSheet;
    FTabGlobal: TTabSheet;
    FTabCaja: TTabSheet;
    FDesde: TDateEdit;
    FHasta: TDateEdit;
    FPuesto: TComboBox;
    FIncluirCaja: TCheckBox;
    FGridIVA: TStringGrid;
    FGridGlobal: TStringGrid;
    FGridCaja: TStringGrid;
    FStatus: TLabel;
    FKPIBase: TLabel;
    FKPIIVA: TLabel;
    FKPITotal: TLabel;
    FKPIPuestos: TLabel;
    FIVA: TFLXIVAArray;
    FGlobal: TFLXIVAArray;
    FCaja: TFLXCajaArray;
    FConsultado: Boolean;
    procedure ConstruirInterfaz(APageControl: TPageControl);
    procedure CargarPuestos;
    procedure ConsultarClick(Sender: TObject);
    procedure PeriodoClick(Sender: TObject);
    procedure VistaPreviaClick(Sender: TObject);
    procedure GuardarPDFClick(Sender: TObject);
    procedure ImprimirClick(Sender: TObject);
    procedure ExportarCSVClick(Sender: TObject);
    procedure IncluirCajaClick(Sender: TObject);
    procedure TabResize(Sender: TObject);
    procedure ConsultarDatos;
    procedure ConsultarIVA;
    procedure ConsultarCaja;
    procedure RellenarGrids;
    procedure ConfigurarGrids;
    procedure ActualizarKpis;
    procedure LimpiarGrid(AGrid: TStringGrid; AColumnas: Integer);
    procedure AgregarFila(AGrid: TStringGrid; const AValores: array of string);
    function TablaSegura(const APrefijo: string): string;
    function PuestoSeleccionado: string;
    function Importe(const AValor: Double): string;
    function Entero(const AValor: Integer): string;
    function GenerarPDF(const AFileName: string): Boolean;
    procedure DibujarCabeceraPDF(APDF: TFLXPDFDocument; var AY: Double;
      const ASubtitulo: string);
    procedure DibujarTablaIVAPDF(APDF: TFLXPDFDocument; var AY: Double;
      const ADatos: TFLXIVAArray; const APuesto: string);
    procedure DibujarCajaPDF(APDF: TFLXPDFDocument; var AY: Double;
      const AItem: TFLXCajaItem; const ATitulo: string);
    function ArchivoTemporalPDF: string;
    function HayDatos: Boolean;
  public
    constructor CreateInforme(AOwner: TComponent; APageControl: TPageControl;
      AConnection: TZAbstractConnection; const ATienda: string); reintroduce;
  end;

const
  FLX_COLOR_OSCURO = $00494332;
  FLX_COLOR_FONDO = $00F5F2EE;
  FLX_COLOR_PANEL = $00FFFFFF;
  FLX_COLOR_SUAVE = $00EEE8E2;

function FLXFechaSQL(const ADate: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-mm-dd', ADate);
end;

function FLXCSV(const ATexto: string): string;
begin
  Result := '"' + StringReplace(ATexto, '"', '""', [rfReplaceAll]) + '"';
end;

procedure FLXWriteUTF8Line(AStream: TStream; const AText: string);
var
  S: UTF8String;
begin
  S := UTF8String(AText + LineEnding);
  if Length(S) > 0 then
    AStream.WriteBuffer(S[1], Length(S));
end;

constructor TFLXInformeIVAPeriodos.CreateInforme(AOwner: TComponent;
  APageControl: TPageControl; AConnection: TZAbstractConnection;
  const ATienda: string);
begin
  inherited Create(AOwner);
  FConnection := AConnection;
  FTienda := ATienda;
  FConsultado := False;
  ConstruirInterfaz(APageControl);
  CargarPuestos;
end;

procedure TFLXInformeIVAPeriodos.ConstruirInterfaz(
  APageControl: TPageControl);
var
  L: TLabel;
  B: TBitBtn;
  Card: TPanel;

  function NuevaEtiqueta(AParent: TWinControl; const ACaption: string;
    X, Y, W, H: Integer): TLabel;
  begin
    Result := TLabel.Create(Self);
    Result.Parent := AParent;
    Result.Caption := ACaption;
    Result.SetBounds(X, Y, W, H);
    Result.Font.Name := 'Sans';
    Result.Font.Height := -11;
  end;

  function NuevoBoton(AParent: TWinControl; const ACaption: string;
    X, Y, W, H, ATag: Integer; AClick: TNotifyEvent): TBitBtn;
  begin
    Result := TBitBtn.Create(Self);
    Result.Parent := AParent;
    Result.Caption := ACaption;
    Result.SetBounds(X, Y, W, H);
    Result.Tag := ATag;
    Result.OnClick := AClick;
    Result.Font.Name := 'Sans';
    Result.Font.Height := -11;
  end;

  function NuevaTarjeta(const ACaption: string; X: Integer;
    out AValueLabel: TLabel): TPanel;
  var
    LTitulo: TLabel;
  begin
    Result := TPanel.Create(Self);
    Result.Parent := FKpis;
    Result.BevelOuter := bvNone;
    Result.Color := FLX_COLOR_PANEL;
    Result.SetBounds(X, 8, 210, 50);

    LTitulo := NuevaEtiqueta(Result, ACaption, 10, 5, 190, 17);
    LTitulo.Font.Color := clGray;
    LTitulo.Font.Height := -10;

    AValueLabel := NuevaEtiqueta(Result, '0,00', 10, 23, 190, 22);
    AValueLabel.Font.Style := [fsBold];
    AValueLabel.Font.Height := -15;
    AValueLabel.Font.Color := FLX_COLOR_OSCURO;
  end;

begin
  FTab := TTabSheet.Create(Self);
  FTab.PageControl := APageControl;
  FTab.Caption := 'Informe IVA / Periodos';
  FTab.Color := FLX_COLOR_FONDO;
  FTab.OnResize := @TabResize;

  FHeader := TPanel.Create(Self);
  FHeader.Parent := FTab;
  FHeader.Align := alTop;
  FHeader.Height := 74;
  FHeader.BevelOuter := bvNone;
  FHeader.Color := FLX_COLOR_OSCURO;

  L := NuevaEtiqueta(FHeader, 'Informe de IVA por periodos', 24, 13, 640, 30);
  L.Font.Height := -21;
  L.Font.Style := [fsBold];
  L.Font.Color := clWhite;

  L := NuevaEtiqueta(FHeader,
    'Resumen por puesto y global, con datos económicos de caja opcionales',
    25, 43, 760, 20);
  L.Font.Height := -11;
  L.Font.Color := $00E7E7E7;

  FFilters := TPanel.Create(Self);
  FFilters.Parent := FTab;
  FFilters.Align := alTop;
  FFilters.Height := 112;
  FFilters.BevelOuter := bvNone;
  FFilters.Color := FLX_COLOR_PANEL;

  NuevaEtiqueta(FFilters, 'Desde', 18, 10, 70, 18);
  FDesde := TDateEdit.Create(Self);
  FDesde.Parent := FFilters;
  FDesde.Left := 18;
  FDesde.Top := 31;
  FDesde.Width := 124;
  FDesde.DateOrder := doDMY;
  FDesde.DateFormat := 'dd/mm/yyyy';
  FDesde.DefaultToday := True;
  FDesde.DirectInput := True;
  FDesde.ButtonOnlyWhenFocused := False;
  FDesde.FocusOnButtonClick := False;
  FDesde.ButtonHint := 'Seleccionar fecha desde';
  FDesde.ShowHint := True;
  FDesde.TabOrder := 0;
  FDesde.Date := StartOfTheMonth(Date);

  NuevaEtiqueta(FFilters, 'Hasta', 155, 10, 70, 18);
  FHasta := TDateEdit.Create(Self);
  FHasta.Parent := FFilters;
  FHasta.Left := 155;
  FHasta.Top := 31;
  FHasta.Width := 124;
  FHasta.DateOrder := doDMY;
  FHasta.DateFormat := 'dd/mm/yyyy';
  FHasta.DefaultToday := True;
  FHasta.DirectInput := True;
  FHasta.ButtonOnlyWhenFocused := False;
  FHasta.FocusOnButtonClick := False;
  FHasta.ButtonHint := 'Seleccionar fecha hasta';
  FHasta.ShowHint := True;
  FHasta.TabOrder := 1;
  FHasta.Date := EndOfTheMonth(Date);

  NuevoBoton(FFilters, 'Mes', 293, 29, 82, 31, 1, @PeriodoClick);
  NuevoBoton(FFilters, 'Trimestre', 381, 29, 104, 31, 2, @PeriodoClick);
  NuevoBoton(FFilters, 'Año', 491, 29, 82, 31, 3, @PeriodoClick);

  NuevaEtiqueta(FFilters, 'Puesto / Terminal', 590, 10, 130, 18);
  FPuesto := TComboBox.Create(Self);
  FPuesto.Parent := FFilters;
  FPuesto.SetBounds(590, 31, 145, 27);
  FPuesto.Style := csDropDownList;

  FIncluirCaja := TCheckBox.Create(Self);
  FIncluirCaja.Parent := FFilters;
  FIncluirCaja.Caption := 'Incluir datos económicos de caja';
  FIncluirCaja.SetBounds(755, 32, 245, 24);
  FIncluirCaja.Checked := True;
  FIncluirCaja.OnClick := @IncluirCajaClick;

  B := NuevoBoton(FFilters, 'Consultar', 18, 72, 120, 32, 0, @ConsultarClick);
  B.Font.Style := [fsBold];
  NuevoBoton(FFilters, 'Vista previa PDF', 148, 72, 150, 32, 0,
    @VistaPreviaClick);
  NuevoBoton(FFilters, 'Guardar PDF', 308, 72, 130, 32, 0,
    @GuardarPDFClick);
  NuevoBoton(FFilters, 'Imprimir', 448, 72, 115, 32, 0,
    @ImprimirClick);
  NuevoBoton(FFilters, 'Exportar CSV', 573, 72, 135, 32, 0,
    @ExportarCSVClick);

  FStatus := NuevaEtiqueta(FFilters,
    'Seleccione el periodo y pulse Consultar.', 730, 78, 420, 22);
  FStatus.Font.Color := clGray;

  FKpis := TPanel.Create(Self);
  FKpis.Parent := FTab;
  FKpis.Align := alTop;
  FKpis.Height := 66;
  FKpis.BevelOuter := bvNone;
  FKpis.Color := FLX_COLOR_SUAVE;

  Card := NuevaTarjeta('Base imponible', 18, FKPIBase);
  Card.Anchors := [akLeft, akTop];
  Card := NuevaTarjeta('Cuota de IVA', 238, FKPIIVA);
  Card.Anchors := [akLeft, akTop];
  Card := NuevaTarjeta('Total con IVA', 458, FKPITotal);
  Card.Anchors := [akLeft, akTop];
  Card := NuevaTarjeta('Puestos incluidos', 678, FKPIPuestos);
  Card.Anchors := [akLeft, akTop];

  FMainTabs := TPageControl.Create(Self);
  FMainTabs.Parent := FTab;
  FMainTabs.Align := alClient;

  FTabIVA := TTabSheet.Create(Self);
  FTabIVA.PageControl := FMainTabs;
  FTabIVA.Caption := 'IVA por puesto';

  FTabGlobal := TTabSheet.Create(Self);
  FTabGlobal.PageControl := FMainTabs;
  FTabGlobal.Caption := 'Resumen global';

  FTabCaja := TTabSheet.Create(Self);
  FTabCaja.PageControl := FMainTabs;
  FTabCaja.Caption := 'Datos de caja';

  FGridIVA := TStringGrid.Create(Self);
  FGridIVA.Parent := FTabIVA;
  FGridIVA.Align := alClient;

  FGridGlobal := TStringGrid.Create(Self);
  FGridGlobal.Parent := FTabGlobal;
  FGridGlobal.Align := alClient;

  FGridCaja := TStringGrid.Create(Self);
  FGridCaja.Parent := FTabCaja;
  FGridCaja.Align := alClient;

  ConfigurarGrids;
  TabResize(FTab);
end;

procedure TFLXInformeIVAPeriodos.ConfigurarGrids;
var
  G: TStringGrid;
  I: Integer;
begin
  for I := 0 to 2 do
  begin
    case I of
      0: G := FGridIVA;
      1: G := FGridGlobal;
    else
      G := FGridCaja;
    end;

    G.FixedRows := 1;
    G.FixedCols := 0;
    G.RowCount := 1;
    G.Color := clWhite;
    G.FixedColor := FLX_COLOR_OSCURO;
    G.Font.Name := 'Sans';
    G.Font.Height := -11;
    G.Options := G.Options + [goFixedVertLine, goFixedHorzLine,
      goVertLine, goHorzLine, goColSizing, goRowSelect];
  end;

  LimpiarGrid(FGridIVA, 5);
  FGridIVA.Cells[0, 0] := 'Puesto';
  FGridIVA.Cells[1, 0] := 'IVA %';
  FGridIVA.Cells[2, 0] := 'Base imponible';
  FGridIVA.Cells[3, 0] := 'Cuota IVA';
  FGridIVA.Cells[4, 0] := 'Total';

  LimpiarGrid(FGridGlobal, 4);
  FGridGlobal.Cells[0, 0] := 'IVA %';
  FGridGlobal.Cells[1, 0] := 'Base imponible';
  FGridGlobal.Cells[2, 0] := 'Cuota IVA';
  FGridGlobal.Cells[3, 0] := 'Total';

  LimpiarGrid(FGridCaja, 10);
  FGridCaja.Cells[0, 0] := 'Puesto';
  FGridCaja.Cells[1, 0] := 'Arqueos';
  FGridCaja.Cells[2, 0] := 'Efectivo';
  FGridCaja.Cells[3, 0] := 'Tarj./Talones';
  FGridCaja.Cells[4, 0] := 'Total caja';
  FGridCaja.Cells[5, 0] := 'Entregas';
  FGridCaja.Cells[6, 0] := 'Crédito';
  FGridCaja.Cells[7, 0] := 'Cambio anterior';
  FGridCaja.Cells[8, 0] := 'N. tarj.';
  FGridCaja.Cells[9, 0] := 'N. albaranes';
end;

procedure TFLXInformeIVAPeriodos.TabResize(Sender: TObject);
var
  W: Integer;
begin
  if not Assigned(FTab) then
    Exit;

  W := FTab.ClientWidth;
  if W < 900 then
    W := 900;
  FStatus.Left := 730;
  FStatus.Width := W - 750;
  if FStatus.Width < 160 then
    FStatus.Width := 160;

  if Assigned(FGridIVA) then
  begin
    FGridIVA.ColWidths[0] := 120;
    FGridIVA.ColWidths[1] := 90;
    FGridIVA.ColWidths[2] := 190;
    FGridIVA.ColWidths[3] := 170;
    FGridIVA.ColWidths[4] := 180;
  end;

  if Assigned(FGridGlobal) then
  begin
    FGridGlobal.ColWidths[0] := 130;
    FGridGlobal.ColWidths[1] := 220;
    FGridGlobal.ColWidths[2] := 210;
    FGridGlobal.ColWidths[3] := 220;
  end;

  if Assigned(FGridCaja) then
  begin
    FGridCaja.ColWidths[0] := 90;
    FGridCaja.ColWidths[1] := 80;
    FGridCaja.ColWidths[2] := 125;
    FGridCaja.ColWidths[3] := 135;
    FGridCaja.ColWidths[4] := 125;
    FGridCaja.ColWidths[5] := 120;
    FGridCaja.ColWidths[6] := 120;
    FGridCaja.ColWidths[7] := 140;
    FGridCaja.ColWidths[8] := 90;
    FGridCaja.ColWidths[9] := 110;
  end;
end;

function TFLXInformeIVAPeriodos.TablaSegura(const APrefijo: string): string;
var
  I: Integer;
  S: string;
begin
  S := '';
  for I := 1 to Length(FTienda) do
    if FTienda[I] in ['A'..'Z', 'a'..'z', '0'..'9', '_'] then
      S := S + FTienda[I];
  Result := APrefijo + S;
end;

procedure TFLXInformeIVAPeriodos.CargarPuestos;
var
  Q: TZQuery;
  P: string;
begin
  FPuesto.Items.Clear;
  FPuesto.Items.Add('Todos');

  if not Assigned(FConnection) or not FConnection.Connected then
  begin
    FPuesto.ItemIndex := 0;
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConnection;
    try
      Q.SQL.Text := 'SELECT Puesto AS P FROM `' + TablaSegura('iva') +
        '` WHERE TRIM(Puesto)<>'''' GROUP BY Puesto ORDER BY Puesto';
      Q.Open;
      while not Q.EOF do
      begin
        P := Trim(Q.FieldByName('P').AsString);
        if (P <> '') and (FPuesto.Items.IndexOf(P) < 0) then
          FPuesto.Items.Add(P);
        Q.Next;
      end;
      Q.Close;
    except
      on E: Exception do
      begin
        Q.Close;
        try
          Q.SQL.Text := 'SELECT CAJA AS P FROM `' + TablaSegura('arqueos') +
            '` WHERE TRIM(CAJA)<>'''' GROUP BY CAJA ORDER BY CAJA';
          Q.Open;
          while not Q.EOF do
          begin
            P := Trim(Q.FieldByName('P').AsString);
            if (P <> '') and (FPuesto.Items.IndexOf(P) < 0) then
              FPuesto.Items.Add(P);
            Q.Next;
          end;
        except
          // La pestaña seguirá siendo utilizable aunque no se puedan precargar puestos.
        end;
      end;
    end;
  finally
    Q.Free;
  end;

  FPuesto.ItemIndex := 0;
end;

procedure TFLXInformeIVAPeriodos.PeriodoClick(Sender: TObject);
var
  Referencia: TDateTime;
  Mes, Trimestre, MesInicio: Word;
begin
  Referencia := FDesde.Date;
  case TControl(Sender).Tag of
    1:
      begin
        FDesde.Date := StartOfTheMonth(Referencia);
        FHasta.Date := EndOfTheMonth(Referencia);
      end;
    2:
      begin
        Mes := MonthOf(Referencia);
        Trimestre := ((Mes - 1) div 3) + 1;
        MesInicio := ((Trimestre - 1) * 3) + 1;
        FDesde.Date := EncodeDate(YearOf(Referencia), MesInicio, 1);
        FHasta.Date := EndOfTheMonth(IncMonth(FDesde.Date, 2));
      end;
    3:
      begin
        FDesde.Date := EncodeDate(YearOf(Referencia), 1, 1);
        FHasta.Date := EncodeDate(YearOf(Referencia), 12, 31);
      end;
  end;
end;

procedure TFLXInformeIVAPeriodos.IncluirCajaClick(Sender: TObject);
begin
  FTabCaja.TabVisible := FIncluirCaja.Checked;
end;

function TFLXInformeIVAPeriodos.PuestoSeleccionado: string;
begin
  Result := '';
  if (FPuesto.ItemIndex > 0) and
     (FPuesto.ItemIndex < FPuesto.Items.Count) then
    Result := Trim(FPuesto.Items[FPuesto.ItemIndex]);
end;

procedure TFLXInformeIVAPeriodos.ConsultarClick(Sender: TObject);
begin
  try
    ConsultarDatos;
  except
    on E: Exception do
      MessageDlg('No se ha podido generar la consulta.' + LineEnding +
        E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TFLXInformeIVAPeriodos.ConsultarDatos;
begin
  if not Assigned(FConnection) or not FConnection.Connected then
    raise Exception.Create('La conexión a la base de datos no está activa.');

  if FDesde.Date > FHasta.Date then
    raise Exception.Create('La fecha Desde no puede ser posterior a Hasta.');

  Screen.Cursor := crHourGlass;
  try
    ConsultarIVA;
    if FIncluirCaja.Checked then
      ConsultarCaja
    else
      SetLength(FCaja, 0);
    RellenarGrids;
    ActualizarKpis;
    FConsultado := True;
    FStatus.Caption := 'Consulta realizada: ' +
      FormatDateTime('dd/mm/yyyy', FDesde.Date) + ' - ' +
      FormatDateTime('dd/mm/yyyy', FHasta.Date);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFLXInformeIVAPeriodos.ConsultarIVA;
var
  Q: TZQuery;
  PuestoFiltro: string;
  N: Integer;
begin
  SetLength(FIVA, 0);
  SetLength(FGlobal, 0);
  PuestoFiltro := PuestoSeleccionado;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConnection;
    Q.SQL.Text :=
      'SELECT Puesto,TIva,SUM(Base) AS BaseIVA,' +
      'SUM(Iva) AS CuotaIVA,SUM(Total) AS TotalIVA ' +
      'FROM `' + TablaSegura('iva') + '` ' +
      'WHERE Fecha>=:D AND Fecha<=:H ';
    if PuestoFiltro <> '' then
      Q.SQL.Add('AND Puesto=:P ');
    Q.SQL.Add('GROUP BY Puesto,TIva ORDER BY Puesto,TIva');
    Q.ParamByName('D').AsString := FLXFechaSQL(FDesde.Date);
    Q.ParamByName('H').AsString := FLXFechaSQL(FHasta.Date);
    if PuestoFiltro <> '' then
      Q.ParamByName('P').AsString := PuestoFiltro;
    Q.Open;

    while not Q.EOF do
    begin
      N := Length(FIVA);
      SetLength(FIVA, N + 1);
      FIVA[N].Puesto := Q.FieldByName('Puesto').AsString;
      FIVA[N].TipoIVA := Q.FieldByName('TIva').AsString;
      FIVA[N].Base := Q.FieldByName('BaseIVA').AsFloat;
      FIVA[N].Cuota := Q.FieldByName('CuotaIVA').AsFloat;
      FIVA[N].Total := Q.FieldByName('TotalIVA').AsFloat;
      Q.Next;
    end;
    Q.Close;

    Q.SQL.Text :=
      'SELECT TIva,SUM(Base) AS BaseIVA,' +
      'SUM(Iva) AS CuotaIVA,SUM(Total) AS TotalIVA ' +
      'FROM `' + TablaSegura('iva') + '` ' +
      'WHERE Fecha>=:D AND Fecha<=:H ';
    if PuestoFiltro <> '' then
      Q.SQL.Add('AND Puesto=:P ');
    Q.SQL.Add('GROUP BY TIva ORDER BY TIva');
    Q.ParamByName('D').AsString := FLXFechaSQL(FDesde.Date);
    Q.ParamByName('H').AsString := FLXFechaSQL(FHasta.Date);
    if PuestoFiltro <> '' then
      Q.ParamByName('P').AsString := PuestoFiltro;
    Q.Open;

    while not Q.EOF do
    begin
      N := Length(FGlobal);
      SetLength(FGlobal, N + 1);
      FGlobal[N].Puesto := '';
      FGlobal[N].TipoIVA := Q.FieldByName('TIva').AsString;
      FGlobal[N].Base := Q.FieldByName('BaseIVA').AsFloat;
      FGlobal[N].Cuota := Q.FieldByName('CuotaIVA').AsFloat;
      FGlobal[N].Total := Q.FieldByName('TotalIVA').AsFloat;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TFLXInformeIVAPeriodos.ConsultarCaja;
var
  Q: TZQuery;
  PuestoFiltro: string;
  N: Integer;
begin
  SetLength(FCaja, 0);
  PuestoFiltro := PuestoSeleccionado;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConnection;
    Q.SQL.Text :=
      'SELECT CAJA AS Puesto,COUNT(*) AS NumArqueos,' +
      'COALESCE(SUM(IEFECTIVO),0) AS Efectivo,' +
      'COALESCE(SUM(ITT),0) AS TarjetasTalones,' +
      'COALESCE(SUM(TOTALC),0) AS TotalCaja,' +
      'COALESCE(SUM(ENTREGAS),0) AS Entregas,' +
      'COALESCE(SUM(DEUDASP),0) AS Credito,' +
      'COALESCE(SUM(CANT),0) AS CambioAnterior,' +
      'COALESCE(SUM(NTT),0) AS NumTarjetas,' +
      'COALESCE(SUM(NALB),0) AS NumAlbaranes ' +
      'FROM `' + TablaSegura('arqueos') + '` ' +
      'WHERE fecha>=:D AND fecha<=:H ';
    if PuestoFiltro <> '' then
      Q.SQL.Add('AND CAJA=:P ');
    Q.SQL.Add('GROUP BY CAJA ORDER BY CAJA');
    Q.ParamByName('D').AsString := FLXFechaSQL(FDesde.Date);
    Q.ParamByName('H').AsString := FLXFechaSQL(FHasta.Date);
    if PuestoFiltro <> '' then
      Q.ParamByName('P').AsString := PuestoFiltro;
    Q.Open;

    while not Q.EOF do
    begin
      N := Length(FCaja);
      SetLength(FCaja, N + 1);
      FCaja[N].Puesto := Q.FieldByName('Puesto').AsString;
      FCaja[N].NumArqueos := Q.FieldByName('NumArqueos').AsInteger;
      FCaja[N].Efectivo := Q.FieldByName('Efectivo').AsFloat;
      FCaja[N].TarjetasTalones :=
        Q.FieldByName('TarjetasTalones').AsFloat;
      FCaja[N].TotalCaja := Q.FieldByName('TotalCaja').AsFloat;
      FCaja[N].Entregas := Q.FieldByName('Entregas').AsFloat;
      FCaja[N].Credito := Q.FieldByName('Credito').AsFloat;
      FCaja[N].CambioAnterior :=
        Q.FieldByName('CambioAnterior').AsFloat;
      FCaja[N].NumTarjetas := Q.FieldByName('NumTarjetas').AsInteger;
      FCaja[N].NumAlbaranes := Q.FieldByName('NumAlbaranes').AsInteger;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TFLXInformeIVAPeriodos.LimpiarGrid(AGrid: TStringGrid;
  AColumnas: Integer);
begin
  AGrid.ColCount := AColumnas;
  AGrid.RowCount := 1;
  AGrid.FixedRows := 1;
end;

procedure TFLXInformeIVAPeriodos.AgregarFila(AGrid: TStringGrid;
  const AValores: array of string);
var
  R, I: Integer;
begin
  R := AGrid.RowCount;
  AGrid.RowCount := R + 1;
  for I := 0 to High(AValores) do
    if I < AGrid.ColCount then
      AGrid.Cells[I, R] := AValores[I];
end;

function TFLXInformeIVAPeriodos.Importe(const AValor: Double): string;
begin
  Result := FormatFloat('#,##0.00', AValor);
end;

function TFLXInformeIVAPeriodos.Entero(const AValor: Integer): string;
begin
  Result := IntToStr(AValor);
end;

procedure TFLXInformeIVAPeriodos.RellenarGrids;
var
  I: Integer;
  PuestoActual: string;
  BaseP, CuotaP, TotalP: Double;
  BaseG, CuotaG, TotalG: Double;
  CajaTotal: TFLXCajaItem;

  procedure AgregarSubtotalPuesto;
  begin
    if PuestoActual = '' then
      Exit;
    AgregarFila(FGridIVA, ['TOTAL ' + PuestoActual, '', Importe(BaseP),
      Importe(CuotaP), Importe(TotalP)]);
  end;

begin
  ConfigurarGrids;

  PuestoActual := '';
  BaseP := 0;
  CuotaP := 0;
  TotalP := 0;
  for I := 0 to High(FIVA) do
  begin
    if (PuestoActual <> '') and
       (not SameText(PuestoActual, FIVA[I].Puesto)) then
    begin
      AgregarSubtotalPuesto;
      BaseP := 0;
      CuotaP := 0;
      TotalP := 0;
    end;

    PuestoActual := FIVA[I].Puesto;
    AgregarFila(FGridIVA, [FIVA[I].Puesto, FIVA[I].TipoIVA,
      Importe(FIVA[I].Base), Importe(FIVA[I].Cuota),
      Importe(FIVA[I].Total)]);
    BaseP := BaseP + FIVA[I].Base;
    CuotaP := CuotaP + FIVA[I].Cuota;
    TotalP := TotalP + FIVA[I].Total;
  end;
  AgregarSubtotalPuesto;

  BaseG := 0;
  CuotaG := 0;
  TotalG := 0;
  for I := 0 to High(FGlobal) do
  begin
    AgregarFila(FGridGlobal, [FGlobal[I].TipoIVA,
      Importe(FGlobal[I].Base), Importe(FGlobal[I].Cuota),
      Importe(FGlobal[I].Total)]);
    BaseG := BaseG + FGlobal[I].Base;
    CuotaG := CuotaG + FGlobal[I].Cuota;
    TotalG := TotalG + FGlobal[I].Total;
  end;
  if Length(FGlobal) > 0 then
    AgregarFila(FGridGlobal, ['TOTAL', Importe(BaseG),
      Importe(CuotaG), Importe(TotalG)]);

  CajaTotal.Puesto := '';
  CajaTotal.NumArqueos := 0;
  CajaTotal.Efectivo := 0;
  CajaTotal.TarjetasTalones := 0;
  CajaTotal.TotalCaja := 0;
  CajaTotal.Entregas := 0;
  CajaTotal.Credito := 0;
  CajaTotal.CambioAnterior := 0;
  CajaTotal.NumTarjetas := 0;
  CajaTotal.NumAlbaranes := 0;
  for I := 0 to High(FCaja) do
  begin
    AgregarFila(FGridCaja, [FCaja[I].Puesto,
      Entero(FCaja[I].NumArqueos), Importe(FCaja[I].Efectivo),
      Importe(FCaja[I].TarjetasTalones), Importe(FCaja[I].TotalCaja),
      Importe(FCaja[I].Entregas), Importe(FCaja[I].Credito),
      Importe(FCaja[I].CambioAnterior), Entero(FCaja[I].NumTarjetas),
      Entero(FCaja[I].NumAlbaranes)]);

    CajaTotal.NumArqueos := CajaTotal.NumArqueos + FCaja[I].NumArqueos;
    CajaTotal.Efectivo := CajaTotal.Efectivo + FCaja[I].Efectivo;
    CajaTotal.TarjetasTalones := CajaTotal.TarjetasTalones +
      FCaja[I].TarjetasTalones;
    CajaTotal.TotalCaja := CajaTotal.TotalCaja + FCaja[I].TotalCaja;
    CajaTotal.Entregas := CajaTotal.Entregas + FCaja[I].Entregas;
    CajaTotal.Credito := CajaTotal.Credito + FCaja[I].Credito;
    CajaTotal.CambioAnterior := CajaTotal.CambioAnterior +
      FCaja[I].CambioAnterior;
    CajaTotal.NumTarjetas := CajaTotal.NumTarjetas +
      FCaja[I].NumTarjetas;
    CajaTotal.NumAlbaranes := CajaTotal.NumAlbaranes +
      FCaja[I].NumAlbaranes;
  end;

  if Length(FCaja) > 0 then
    AgregarFila(FGridCaja, ['TOTAL', Entero(CajaTotal.NumArqueos),
      Importe(CajaTotal.Efectivo), Importe(CajaTotal.TarjetasTalones),
      Importe(CajaTotal.TotalCaja), Importe(CajaTotal.Entregas),
      Importe(CajaTotal.Credito), Importe(CajaTotal.CambioAnterior),
      Entero(CajaTotal.NumTarjetas), Entero(CajaTotal.NumAlbaranes)]);
end;

procedure TFLXInformeIVAPeriodos.ActualizarKpis;
var
  I: Integer;
  BaseG, CuotaG, TotalG: Double;
  Puestos: TStringList;
begin
  BaseG := 0;
  CuotaG := 0;
  TotalG := 0;
  for I := 0 to High(FGlobal) do
  begin
    BaseG := BaseG + FGlobal[I].Base;
    CuotaG := CuotaG + FGlobal[I].Cuota;
    TotalG := TotalG + FGlobal[I].Total;
  end;

  Puestos := TStringList.Create;
  try
    Puestos.Sorted := True;
    Puestos.Duplicates := dupIgnore;
    for I := 0 to High(FIVA) do
      Puestos.Add(FIVA[I].Puesto);

    FKPIBase.Caption := Importe(BaseG);
    FKPIIVA.Caption := Importe(CuotaG);
    FKPITotal.Caption := Importe(TotalG);
    FKPIPuestos.Caption := IntToStr(Puestos.Count);
  finally
    Puestos.Free;
  end;
end;

function TFLXInformeIVAPeriodos.HayDatos: Boolean;
begin
  Result := Length(FGlobal) > 0;
end;

function TFLXInformeIVAPeriodos.ArchivoTemporalPDF: string;
begin
  Result := IncludeTrailingPathDelimiter(GetTempDir(False)) +
    'FacturLinEx_IVA_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.pdf';
end;

procedure TFLXInformeIVAPeriodos.DibujarCabeceraPDF(
  APDF: TFLXPDFDocument; var AY: Double; const ASubtitulo: string);
var
  Periodo: string;
begin
  APDF.NewPage;
  APDF.SetFillColor(0.05, 0.25, 0.28);
  APDF.FillRect(0, 770, APDF.PageWidth, 72);

  APDF.SetFillColor(1, 1, 1);
  APDF.Text(36, 812, 18, Empresa, True);
  APDF.Text(36, 790, 12, 'Informe de IVA por periodos', True);
  if Trim(ASubtitulo) <> '' then
    APDF.TextRight(APDF.PageWidth - 36, 791, 10, ASubtitulo, True);

  APDF.SetFillColor(0.15, 0.18, 0.20);
  Periodo := 'Periodo: ' + FormatDateTime('dd/mm/yyyy', FDesde.Date) +
    ' - ' + FormatDateTime('dd/mm/yyyy', FHasta.Date);
  APDF.Text(36, 748, 10, Periodo, True);
  APDF.TextRight(APDF.PageWidth - 36, 748, 9,
    'Generado: ' + FormatDateTime('dd/mm/yyyy hh:nn', Now), False);

  if Trim(Nif) <> '' then
    APDF.Text(36, 732, 8, 'NIF: ' + Nif, False);
  if Trim(Direccion) <> '' then
    APDF.Text(170, 732, 8, Direccion + ' - ' + Localidad, False);

  APDF.SetStrokeColor(0.75, 0.78, 0.80);
  APDF.SetLineWidth(0.7);
  APDF.Line(36, 720, APDF.PageWidth - 36, 720);
  AY := 698;
end;

procedure TFLXInformeIVAPeriodos.DibujarTablaIVAPDF(
  APDF: TFLXPDFDocument; var AY: Double; const ADatos: TFLXIVAArray;
  const APuesto: string);
var
  I: Integer;
  BaseT, CuotaT, TotalT: Double;
  Titulo: string;
begin
  if APuesto = '' then
    Titulo := 'RESUMEN GLOBAL DE IVA'
  else
    Titulo := 'DATOS DE IVA - PUESTO ' + APuesto;

  APDF.SetFillColor(0.05, 0.25, 0.28);
  APDF.Text(36, AY, 13, Titulo, True);
  AY := AY - 20;

  APDF.SetFillColor(0.91, 0.93, 0.94);
  APDF.FillRect(36, AY - 4, 523, 22);
  APDF.SetFillColor(0.10, 0.12, 0.14);
  APDF.Text(46, AY + 3, 9, 'Tipo IVA', True);
  APDF.TextRight(290, AY + 3, 9, 'Base imponible', True);
  APDF.TextRight(420, AY + 3, 9, 'Cuota IVA', True);
  APDF.TextRight(549, AY + 3, 9, 'Total', True);
  AY := AY - 26;

  BaseT := 0;
  CuotaT := 0;
  TotalT := 0;
  for I := 0 to High(ADatos) do
  begin
    if (APuesto <> '') and (not SameText(ADatos[I].Puesto, APuesto)) then
      Continue;

    APDF.SetFillColor(0.12, 0.14, 0.16);
    APDF.Text(46, AY, 9, ADatos[I].TipoIVA + ' %', False);
    APDF.TextRight(290, AY, 9, Importe(ADatos[I].Base), False);
    APDF.TextRight(420, AY, 9, Importe(ADatos[I].Cuota), False);
    APDF.TextRight(549, AY, 9, Importe(ADatos[I].Total), False);
    APDF.SetStrokeColor(0.88, 0.89, 0.90);
    APDF.Line(36, AY - 5, 559, AY - 5);
    AY := AY - 20;

    BaseT := BaseT + ADatos[I].Base;
    CuotaT := CuotaT + ADatos[I].Cuota;
    TotalT := TotalT + ADatos[I].Total;
  end;

  APDF.SetFillColor(0.05, 0.25, 0.28);
  APDF.FillRect(36, AY - 4, 523, 23);
  APDF.SetFillColor(1, 1, 1);
  APDF.Text(46, AY + 3, 9, 'TOTAL', True);
  APDF.TextRight(290, AY + 3, 9, Importe(BaseT), True);
  APDF.TextRight(420, AY + 3, 9, Importe(CuotaT), True);
  APDF.TextRight(549, AY + 3, 9, Importe(TotalT), True);
  AY := AY - 38;
end;

procedure TFLXInformeIVAPeriodos.DibujarCajaPDF(
  APDF: TFLXPDFDocument; var AY: Double; const AItem: TFLXCajaItem;
  const ATitulo: string);

  procedure Fila(const AConcepto, AValor: string);
  begin
    APDF.SetFillColor(0.12, 0.14, 0.16);
    APDF.Text(46, AY, 9, AConcepto, False);
    APDF.TextRight(549, AY, 9, AValor, False);
    APDF.SetStrokeColor(0.90, 0.91, 0.92);
    APDF.Line(36, AY - 5, 559, AY - 5);
    AY := AY - 19;
  end;

begin
  APDF.SetFillColor(0.05, 0.25, 0.28);
  APDF.Text(36, AY, 13, ATitulo, True);
  AY := AY - 24;

  Fila('Número de arqueos', Entero(AItem.NumArqueos));
  Fila('Importe teórico en efectivo', Importe(AItem.Efectivo));
  Fila('Importe teórico en tarjetas y talones',
    Importe(AItem.TarjetasTalones));
  Fila('Total de caja', Importe(AItem.TotalCaja));
  Fila('Entregas a cuenta', Importe(AItem.Entregas));
  Fila('Ventas a crédito pendientes', Importe(AItem.Credito));
  Fila('Cambio anterior acumulado', Importe(AItem.CambioAnterior));
  Fila('Número de operaciones tarjeta/talón', Entero(AItem.NumTarjetas));
  Fila('Número de albaranes', Entero(AItem.NumAlbaranes));
  AY := AY - 10;
end;

function TFLXInformeIVAPeriodos.GenerarPDF(
  const AFileName: string): Boolean;
var
  PDF: TFLXPDFDocument;
  Y: Double;
  I, J: Integer;
  Puestos: TStringList;
  CajaGlobal: TFLXCajaItem;
begin
  Result := False;
  // Se vuelve a consultar para que el PDF refleje siempre los filtros actuales.
  ConsultarDatos;
  if not HayDatos then
    raise Exception.Create('No hay datos de IVA en el periodo seleccionado.');

  PDF := TFLXPDFDocument.Create;
  Puestos := TStringList.Create;
  try
    Y := 0;
    DibujarCabeceraPDF(PDF, Y, 'Resumen global');
    DibujarTablaIVAPDF(PDF, Y, FGlobal, '');

    CajaGlobal.Puesto := '';
    CajaGlobal.NumArqueos := 0;
    CajaGlobal.Efectivo := 0;
    CajaGlobal.TarjetasTalones := 0;
    CajaGlobal.TotalCaja := 0;
    CajaGlobal.Entregas := 0;
    CajaGlobal.Credito := 0;
    CajaGlobal.CambioAnterior := 0;
    CajaGlobal.NumTarjetas := 0;
    CajaGlobal.NumAlbaranes := 0;
    if FIncluirCaja.Checked and (Length(FCaja) > 0) then
    begin
      for I := 0 to High(FCaja) do
      begin
        CajaGlobal.NumArqueos := CajaGlobal.NumArqueos + FCaja[I].NumArqueos;
        CajaGlobal.Efectivo := CajaGlobal.Efectivo + FCaja[I].Efectivo;
        CajaGlobal.TarjetasTalones := CajaGlobal.TarjetasTalones +
          FCaja[I].TarjetasTalones;
        CajaGlobal.TotalCaja := CajaGlobal.TotalCaja + FCaja[I].TotalCaja;
        CajaGlobal.Entregas := CajaGlobal.Entregas + FCaja[I].Entregas;
        CajaGlobal.Credito := CajaGlobal.Credito + FCaja[I].Credito;
        CajaGlobal.CambioAnterior := CajaGlobal.CambioAnterior +
          FCaja[I].CambioAnterior;
        CajaGlobal.NumTarjetas := CajaGlobal.NumTarjetas +
          FCaja[I].NumTarjetas;
        CajaGlobal.NumAlbaranes := CajaGlobal.NumAlbaranes +
          FCaja[I].NumAlbaranes;
      end;

      if Y < 280 then
        DibujarCabeceraPDF(PDF, Y, 'Datos económicos globales');
      DibujarCajaPDF(PDF, Y, CajaGlobal, 'DATOS ECONÓMICOS GLOBALES');
    end;

    Puestos.Sorted := True;
    Puestos.Duplicates := dupIgnore;
    for I := 0 to High(FIVA) do
      Puestos.Add(FIVA[I].Puesto);

    for I := 0 to Puestos.Count - 1 do
    begin
      DibujarCabeceraPDF(PDF, Y, 'Puesto ' + Puestos[I]);
      DibujarTablaIVAPDF(PDF, Y, FIVA, Puestos[I]);

      if FIncluirCaja.Checked then
      begin
        for J := 0 to High(FCaja) do
          if SameText(FCaja[J].Puesto, Puestos[I]) then
          begin
            if Y < 280 then
              DibujarCabeceraPDF(PDF, Y, 'Puesto ' + Puestos[I]);
            DibujarCajaPDF(PDF, Y, FCaja[J],
              'DATOS ECONÓMICOS - PUESTO ' + Puestos[I]);
            Break;
          end;
      end;
    end;

    PDF.AddPageNumbers;
    PDF.SaveToFile(AFileName);
    Result := FileExists(AFileName);
  finally
    Puestos.Free;
    PDF.Free;
  end;
end;

procedure TFLXInformeIVAPeriodos.VistaPreviaClick(Sender: TObject);
var
  Fichero: string;
begin
  try
    Fichero := ArchivoTemporalPDF;
    if GenerarPDF(Fichero) then
    begin
      if not OpenDocument(Fichero) then
        MessageDlg('El PDF se ha generado en:' + LineEnding + Fichero +
          LineEnding + 'pero no se ha encontrado un visor predeterminado.',
          mtInformation, [mbOK], 0);
    end;
  except
    on E: Exception do
      MessageDlg('No se ha podido generar la vista previa.' + LineEnding +
        E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TFLXInformeIVAPeriodos.GuardarPDFClick(Sender: TObject);
var
  D: TSaveDialog;
  Nombre: string;
begin
  D := TSaveDialog.Create(nil);
  try
    D.Title := 'Guardar informe de IVA';
    D.Filter := 'Documento PDF|*.pdf';
    D.DefaultExt := 'pdf';
    D.FileName := 'Informe_IVA_' +
      FormatDateTime('yyyymmdd', FDesde.Date) + '_' +
      FormatDateTime('yyyymmdd', FHasta.Date) + '.pdf';
    if not D.Execute then
      Exit;

    Nombre := D.FileName;
    if ExtractFileExt(Nombre) = '' then
      Nombre := Nombre + '.pdf';
    if GenerarPDF(Nombre) then
      MessageDlg('Informe guardado correctamente.' + LineEnding + Nombre,
        mtInformation, [mbOK], 0);
  finally
    D.Free;
  end;
end;

procedure TFLXInformeIVAPeriodos.ImprimirClick(Sender: TObject);
var
  Fichero: string;
  P: TProcess;
begin
  try
    Fichero := ArchivoTemporalPDF;
    if not GenerarPDF(Fichero) then
      Exit;

    P := TProcess.Create(nil);
    try
      P.Executable := 'lpr';
      P.Parameters.Add(Fichero);
      P.Options := [poWaitOnExit];
      try
        P.Execute;
        if P.ExitStatus <> 0 then
          raise Exception.Create('El sistema de impresión devolvió el código ' +
            IntToStr(P.ExitStatus) + '.');
        MessageDlg('El informe se ha enviado a la impresora predeterminada.',
          mtInformation, [mbOK], 0);
      except
        on E: Exception do
        begin
          OpenDocument(Fichero);
          MessageDlg('No se ha podido utilizar lpr.' + LineEnding +
            'Se ha abierto el PDF para imprimirlo desde el visor.' +
            LineEnding + E.Message, mtInformation, [mbOK], 0);
        end;
      end;
    finally
      P.Free;
    end;
  except
    on E: Exception do
      MessageDlg('No se ha podido imprimir el informe.' + LineEnding +
        E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TFLXInformeIVAPeriodos.ExportarCSVClick(Sender: TObject);
var
  D: TSaveDialog;
  S: TFileStream;
  I: Integer;
  Bom: array[0..2] of Byte;
begin
  try
    // Se vuelve a consultar para que el CSV refleje siempre los filtros actuales.
    ConsultarDatos;
    if not HayDatos then
      raise Exception.Create('No hay datos que exportar.');

    D := TSaveDialog.Create(nil);
    try
      D.Title := 'Exportar informe de IVA';
      D.Filter := 'Archivo CSV|*.csv';
      D.DefaultExt := 'csv';
      D.FileName := 'Informe_IVA_' +
        FormatDateTime('yyyymmdd', FDesde.Date) + '_' +
        FormatDateTime('yyyymmdd', FHasta.Date) + '.csv';
      if not D.Execute then
        Exit;

      S := TFileStream.Create(D.FileName, fmCreate);
      try
        Bom[0] := $EF;
        Bom[1] := $BB;
        Bom[2] := $BF;
        S.WriteBuffer(Bom[0], SizeOf(Bom));

        FLXWriteUTF8Line(S, 'INFORME IVA POR PUESTO');
        FLXWriteUTF8Line(S, 'Puesto;Tipo IVA;Base imponible;Cuota IVA;Total');
        for I := 0 to High(FIVA) do
          FLXWriteUTF8Line(S, FLXCSV(FIVA[I].Puesto) + ';' +
            FLXCSV(FIVA[I].TipoIVA) + ';' + FLXCSV(Importe(FIVA[I].Base)) +
            ';' + FLXCSV(Importe(FIVA[I].Cuota)) + ';' +
            FLXCSV(Importe(FIVA[I].Total)));

        FLXWriteUTF8Line(S, '');
        FLXWriteUTF8Line(S, 'RESUMEN GLOBAL');
        FLXWriteUTF8Line(S, 'Tipo IVA;Base imponible;Cuota IVA;Total');
        for I := 0 to High(FGlobal) do
          FLXWriteUTF8Line(S, FLXCSV(FGlobal[I].TipoIVA) + ';' +
            FLXCSV(Importe(FGlobal[I].Base)) + ';' +
            FLXCSV(Importe(FGlobal[I].Cuota)) + ';' +
            FLXCSV(Importe(FGlobal[I].Total)));

        if FIncluirCaja.Checked then
        begin
          FLXWriteUTF8Line(S, '');
          FLXWriteUTF8Line(S, 'DATOS ECONÓMICOS DE CAJA');
          FLXWriteUTF8Line(S,
            'Puesto;Arqueos;Efectivo;Tarjetas/Talones;Total caja;' +
            'Entregas;Crédito;Cambio anterior;N. tarjetas;N. albaranes');
          for I := 0 to High(FCaja) do
            FLXWriteUTF8Line(S, FLXCSV(FCaja[I].Puesto) + ';' +
              Entero(FCaja[I].NumArqueos) + ';' +
              FLXCSV(Importe(FCaja[I].Efectivo)) + ';' +
              FLXCSV(Importe(FCaja[I].TarjetasTalones)) + ';' +
              FLXCSV(Importe(FCaja[I].TotalCaja)) + ';' +
              FLXCSV(Importe(FCaja[I].Entregas)) + ';' +
              FLXCSV(Importe(FCaja[I].Credito)) + ';' +
              FLXCSV(Importe(FCaja[I].CambioAnterior)) + ';' +
              Entero(FCaja[I].NumTarjetas) + ';' +
              Entero(FCaja[I].NumAlbaranes));
        end;
      finally
        S.Free;
      end;

      MessageDlg('CSV guardado correctamente.' + LineEnding + D.FileName,
        mtInformation, [mbOK], 0);
    finally
      D.Free;
    end;
  except
    on E: Exception do
      MessageDlg('No se ha podido exportar el CSV.' + LineEnding +
        E.Message, mtError, [mbOK], 0);
  end;
end;

procedure FLXInstalarInformeIVAPeriodos(AOwner: TComponent;
  APageControl: TPageControl; AConnection: TZAbstractConnection;
  const ATienda: string);
begin
  if not Assigned(AOwner) or not Assigned(APageControl) then
    Exit;
  TFLXInformeIVAPeriodos.CreateInforme(AOwner, APageControl,
    AConnection, ATienda);
end;

end.
