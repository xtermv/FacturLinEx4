unit uFLXAsociarEAN;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, Buttons,
  Dialogs, Graphics, ComCtrls, DB, ZConnection, ZDataset;

function FLXMostrarAsociarEAN(AOwner: TComponent; ABaseQuery: TZQuery;
  const ATienda, AEAN, ABusquedaInicial, ACantidadInicial: string;
  out AVenderAhora: Boolean): Boolean;

implementation

function FLXSQL(const S: string): string;
begin
  Result := StringReplace(S, '\\', '\\\\', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '\\"', [rfReplaceAll]);
end;

function FLXFloatSQL(const V: Double; const Mascara: string): string;
begin
  Result := StringReplace(FormatFloat(Mascara, V), ',', '.', [rfReplaceAll]);
end;

type
  TFLXEANDlg = class(TForm)
  private
    FBaseQuery: TZQuery;
    FTienda: string;
    FEAN: string;
    FCodSel: string;
    FDesSel: string;
    FSortColumn: Integer;
    FSortAscending: Boolean;
    LbTitulo, LbEAN, LbBuscar, LbSeleccion, LbCantidad, LbTipo, LbInfo: TLabel;
    EdBuscar, EdCantidad: TEdit;
    RbAux, RbPack: TRadioButton;
    Lst: TListView;
    BtnBuscar, BtnGuardar, BtnCancelar: TButton;
    ChVender: TCheckBox;
    procedure BuscarClick(Sender: TObject);
    procedure ListaClick(Sender: TObject);
    procedure ColumnaClick(Sender: TObject; Column: TListColumn);
    procedure OrdenarLista;
    procedure ActualizarCabecerasOrden;
    procedure GuardarClick(Sender: TObject);
    procedure BuscarKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CargarBusqueda;
  public
    VenderAhora: Boolean;
    constructor CreateEAN(AOwner: TComponent; ABaseQuery: TZQuery; const ATienda, AEAN, ABusqueda, ACantidad: string); reintroduce;
  end;

constructor TFLXEANDlg.CreateEAN(AOwner: TComponent; ABaseQuery: TZQuery;
  const ATienda, AEAN, ABusqueda, ACantidad: string);
begin
  inherited CreateNew(AOwner, 0);
  FBaseQuery := ABaseQuery;
  FTienda := ATienda;
  FEAN := AEAN;
  FCodSel := '';
  FDesSel := '';
  FSortColumn := -1;
  FSortAscending := True;
  VenderAhora := False;

  Caption := 'Asociar nuevo EAN';
  Position := poScreenCenter;
  BorderStyle := bsSizeable;
  Width := 860;
  Height := 620;
  Color := $00F7F7F7;

  LbTitulo := TLabel.Create(Self);
  LbTitulo.Parent := Self;
  LbTitulo.Left := 16;
  LbTitulo.Top := 12;
  LbTitulo.Caption := 'ASOCIAR NUEVO EAN';
  LbTitulo.Font.Size := 14;
  LbTitulo.Font.Style := [fsBold];
  LbTitulo.Font.Color := clNavy;

  LbEAN := TLabel.Create(Self);
  LbEAN.Parent := Self;
  LbEAN.Left := 16;
  LbEAN.Top := 46;
  LbEAN.Caption := 'EAN leído: ' + FEAN;
  LbEAN.Font.Style := [fsBold];
  LbEAN.Font.Color := clMaroon;

  LbBuscar := TLabel.Create(Self);
  LbBuscar.Parent := Self;
  LbBuscar.Left := 16;
  LbBuscar.Top := 82;
  LbBuscar.Caption := 'Buscar artículo por código, EAN o descripción:';

  EdBuscar := TEdit.Create(Self);
  EdBuscar.Parent := Self;
  EdBuscar.Left := 16;
  EdBuscar.Top := 104;
  EdBuscar.Width := 620;
  EdBuscar.Text := ABusqueda;
  EdBuscar.OnKeyDown := @BuscarKeyDown;

  BtnBuscar := TButton.Create(Self);
  BtnBuscar.Parent := Self;
  BtnBuscar.Left := 650;
  BtnBuscar.Top := 102;
  BtnBuscar.Width := 150;
  BtnBuscar.Height := 30;
  BtnBuscar.Caption := 'Buscar';
  BtnBuscar.OnClick := @BuscarClick;

  Lst := TListView.Create(Self);
  Lst.Parent := Self;
  Lst.Left := 16;
  Lst.Top := 145;
  Lst.Width := 785;
  Lst.Height := 275;
  Lst.ViewStyle := vsReport;
  Lst.ReadOnly := True;
  Lst.RowSelect := True;
  Lst.HideSelection := False;
  Lst.MultiSelect := False;
  Lst.ColumnClick := True;
  Lst.AutoSort := False;
  Lst.AutoSortIndicator := False;

  with Lst.Columns.Add do
  begin
    Caption := 'Código';
    Width := 110;
  end;
  with Lst.Columns.Add do
  begin
    Caption := 'Descripción';
    Width := 300;
  end;
  with Lst.Columns.Add do
  begin
    Caption := 'Última compra';
    Width := 120;
  end;
  with Lst.Columns.Add do
  begin
    Caption := 'Última venta';
    Width := 120;
  end;
  with Lst.Columns.Add do
  begin
    Caption := 'PVP';
    Width := 90;
    Alignment := taRightJustify;
  end;

  Lst.OnClick := @ListaClick;
  Lst.OnColumnClick := @ColumnaClick;

  LbSeleccion := TLabel.Create(Self);
  LbSeleccion.Parent := Self;
  LbSeleccion.Left := 16;
  LbSeleccion.Top := 430;
  LbSeleccion.Width := 785;
  LbSeleccion.Caption := 'Artículo seleccionado: (ninguno)';
  LbSeleccion.Font.Style := [fsBold];

  LbCantidad := TLabel.Create(Self);
  LbCantidad.Parent := Self;
  LbCantidad.Left := 16;
  LbCantidad.Top := 462;
  LbCantidad.Caption := 'Cantidad equivalente:';

  EdCantidad := TEdit.Create(Self);
  EdCantidad.Parent := Self;
  EdCantidad.Left := 165;
  EdCantidad.Top := 458;
  EdCantidad.Width := 90;
  if (Trim(ACantidad) <> '') and (Trim(ACantidad) <> '0') then
    EdCantidad.Text := Trim(ACantidad)
  else
    EdCantidad.Text := '1';

  LbTipo := TLabel.Create(Self);
  LbTipo.Parent := Self;
  LbTipo.Left := 295;
  LbTipo.Top := 462;
  LbTipo.Caption := 'Tipo:';

  RbAux := TRadioButton.Create(Self);
  RbAux.Parent := Self;
  RbAux.Left := 340;
  RbAux.Top := 460;
  RbAux.Caption := 'Código auxiliar';
  RbAux.Checked := True;

  RbPack := TRadioButton.Create(Self);
  RbPack.Parent := Self;
  RbPack.Left := 470;
  RbPack.Top := 460;
  RbPack.Caption := 'Pack';

  ChVender := TCheckBox.Create(Self);
  ChVender.Parent := Self;
  ChVender.Left := 16;
  ChVender.Top := 493;
  ChVender.Caption := 'Vender este artículo ahora después de asociarlo';
  ChVender.Checked := False;

  LbInfo := TLabel.Create(Self);
  LbInfo.Parent := Self;
  LbInfo.Left := 16;
  LbInfo.Top := 522;
  LbInfo.Width := 785;
  LbInfo.Caption := 'Consejo: use cantidad 1 para un EAN auxiliar normal; use 6, 12, etc. para packs.';
  LbInfo.Font.Color := clGray;

  BtnCancelar := TButton.Create(Self);
  BtnCancelar.Parent := Self;
  BtnCancelar.Left := 560;
  BtnCancelar.Top := 552;
  BtnCancelar.Width := 110;
  BtnCancelar.Height := 32;
  BtnCancelar.Caption := 'Cancelar';
  BtnCancelar.ModalResult := mrCancel;

  BtnGuardar := TButton.Create(Self);
  BtnGuardar.Parent := Self;
  BtnGuardar.Left := 680;
  BtnGuardar.Top := 552;
  BtnGuardar.Width := 140;
  BtnGuardar.Height := 32;
  BtnGuardar.Caption := 'Guardar asociación';
  BtnGuardar.OnClick := @GuardarClick;

  ActiveControl := EdBuscar;
  CargarBusqueda;
end;

procedure TFLXEANDlg.BuscarKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
  begin
    Key := 0;
    CargarBusqueda;
  end;
end;

procedure TFLXEANDlg.BuscarClick(Sender: TObject);
begin
  CargarBusqueda;
end;

procedure TFLXEANDlg.CargarBusqueda;
var
  Q: TZQuery;
  B, Cod, Des, FechaCompra, FechaVenta, PVP: string;
  Item: TListItem;

  function FechaTexto(AField: TField; const ASinDatos: string): string;
  var
    SFecha: string;
  begin
    Result := ASinDatos;
    if (AField = nil) or AField.IsNull then Exit;

    SFecha := Trim(AField.AsString);
    if (SFecha = '') or (Copy(SFecha, 1, 10) = '0000-00-00') then Exit;

    try
      Result := FormatDateTime('dd/mm/yyyy', AField.AsDateTime);
    except
      Result := SFecha;
    end;
  end;

  procedure AnadirResultado(const ACodigo, ADescripcion,
    AFechaCompra, AFechaVenta, APVP: string);
  begin
    if Trim(ACodigo) = '' then Exit;
    Item := Lst.Items.Add;
    Item.Caption := ACodigo;
    Item.SubItems.Add(ADescripcion);
    Item.SubItems.Add(AFechaCompra);
    Item.SubItems.Add(AFechaVenta);
    Item.SubItems.Add(APVP);
  end;

begin
  B := Trim(EdBuscar.Text);
  Lst.Items.Clear;
  FCodSel := '';
  FDesSel := '';
  LbSeleccion.Caption := 'Artículo seleccionado: (ninguno)';

  if B = '' then Exit;

  Lst.Items.BeginUpdate;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FBaseQuery.Connection;
    Q.SQL.Text :=
      'SELECT A0,A1,A2,A12,A13 FROM artitien' + FTienda +
      ' WHERE A0 LIKE "%' + FLXSQL(B) + '%" ' +
      '    OR A1 LIKE "%' + FLXSQL(B) + '%" ' +
      '    OR A19 LIKE "%' + FLXSQL(B) + '%" ' +
      ' ORDER BY A1 LIMIT 150';
    Q.Open;
    while not Q.EOF do
    begin
      Cod := Q.FieldByName('A0').AsString;
      Des := Q.FieldByName('A1').AsString;
      FechaCompra := FechaTexto(Q.FieldByName('A13'), 'Sin compras');
      FechaVenta := FechaTexto(Q.FieldByName('A12'), 'Sin ventas');
      PVP := FormatFloat('0.00', Q.FieldByName('A2').AsFloat);
      AnadirResultado(Cod, Des, FechaCompra, FechaVenta, PVP);
      Q.Next;
    end;

    Q.Close;
    Q.SQL.Text :=
      'SELECT e.EAN1 AS A0, a.A1 AS A1, a.A2 AS A2, ' +
      'a.A12 AS A12, a.A13 AS A13 FROM eans e ' +
      'LEFT JOIN artitien' + FTienda + ' a ON a.A0=e.EAN1 ' +
      'WHERE e.EAN0 LIKE "%' + FLXSQL(B) + '%" ' +
      '   OR e.EAN2 LIKE "%' + FLXSQL(B) + '%" ' +
      'ORDER BY e.EAN2 LIMIT 50';
    Q.Open;
    while not Q.EOF do
    begin
      Cod := Q.FieldByName('A0').AsString;
      Des := Q.FieldByName('A1').AsString;
      FechaCompra := FechaTexto(Q.FieldByName('A13'), 'Sin compras');
      FechaVenta := FechaTexto(Q.FieldByName('A12'), 'Sin ventas');
      PVP := FormatFloat('0.00', Q.FieldByName('A2').AsFloat);
      AnadirResultado(Cod, Des + ' (EAN auxiliar)', FechaCompra, FechaVenta, PVP);
      Q.Next;
    end;

    if FSortColumn >= 0 then
      OrdenarLista;

    if Lst.Items.Count > 0 then
    begin
      Lst.Selected := Lst.Items[0];
      Lst.ItemFocused := Lst.Items[0];
      ListaClick(Lst);
    end;
  finally
    Q.Free;
    Lst.Items.EndUpdate;
  end;
end;

procedure TFLXEANDlg.ListaClick(Sender: TObject);
begin
  if Lst.Selected = nil then Exit;

  FCodSel := Trim(Lst.Selected.Caption);
  if Lst.Selected.SubItems.Count > 0 then
    FDesSel := Lst.Selected.SubItems[0]
  else
    FDesSel := '';

  LbSeleccion.Caption := 'Artículo seleccionado: ' +
    FCodSel + ' - ' + FDesSel;
end;

procedure TFLXEANDlg.ActualizarCabecerasOrden;
const
  Titulos: array[0..4] of string =
    ('Código', 'Descripción', 'Última compra', 'Última venta', 'PVP');
var
  I: Integer;
begin
  for I := 0 to Lst.Columns.Count - 1 do
  begin
    Lst.Columns[I].Caption := Titulos[I];
    if I = FSortColumn then
    begin
      if FSortAscending then
        Lst.Columns[I].Caption := Lst.Columns[I].Caption + ' ▲'
      else
        Lst.Columns[I].Caption := Lst.Columns[I].Caption + ' ▼';
    end;
  end;
end;

procedure TFLXEANDlg.ColumnaClick(Sender: TObject; Column: TListColumn);
begin
  if Column = nil then Exit;

  if FSortColumn = Column.Index then
    FSortAscending := not FSortAscending
  else
  begin
    FSortColumn := Column.Index;
    FSortAscending := True;
  end;

  OrdenarLista;
  ActualizarCabecerasOrden;
end;

procedure TFLXEANDlg.OrdenarLista;
type
  TFilaEAN = record
    Codigo: string;
    Descripcion: string;
    FechaCompra: string;
    FechaVenta: string;
    PVP: string;
  end;
  TFilasEAN = array of TFilaEAN;
var
  Filas: TFilasEAN;
  I: Integer;
  CodigoAnterior, DescripcionAnterior: string;
  Item, ItemSeleccionado: TListItem;

  function ClaveFecha(const SFecha: string): Integer;
  var
    Dia, Mes, Anio: Integer;
  begin
    Result := 0;
    if (Length(SFecha) <> 10) or (SFecha[3] <> '/') or (SFecha[6] <> '/') then Exit;
    Dia := StrToIntDef(Copy(SFecha, 1, 2), 0);
    Mes := StrToIntDef(Copy(SFecha, 4, 2), 0);
    Anio := StrToIntDef(Copy(SFecha, 7, 4), 0);
    if (Dia < 1) or (Dia > 31) or (Mes < 1) or (Mes > 12) or (Anio < 1) then Exit;
    Result := (Anio * 10000) + (Mes * 100) + Dia;
  end;

  function ValorPVP(const SValor: string): Double;
  var
    T: string;
  begin
    T := Trim(SValor);
    Result := StrToFloatDef(T, 0);
    if (Result = 0) and (T <> '') then
      Result := StrToFloatDef(StringReplace(T, '.', DecimalSeparator, [rfReplaceAll]), 0);
  end;

  function CompararFecha(const AFecha, BFecha: string): Integer;
  var
    FA, FB: Integer;
  begin
    FA := ClaveFecha(AFecha);
    FB := ClaveFecha(BFecha);
    if (FA = 0) and (FB <> 0) then Exit(1);
    if (FA <> 0) and (FB = 0) then Exit(-1);
    if FA < FB then Result := -1
    else if FA > FB then Result := 1
    else Result := 0;
  end;

  function CompararFilas(const A, B: TFilaEAN): Integer;
  var
    PA, PB: Double;
  begin
    Result := 0;
    case FSortColumn of
      0: Result := AnsiCompareText(Trim(A.Codigo), Trim(B.Codigo));
      1: Result := AnsiCompareText(Trim(A.Descripcion), Trim(B.Descripcion));
      2: Result := CompararFecha(A.FechaCompra, B.FechaCompra);
      3: Result := CompararFecha(A.FechaVenta, B.FechaVenta);
      4:
        begin
          PA := ValorPVP(A.PVP);
          PB := ValorPVP(B.PVP);
          if PA < PB then Result := -1
          else if PA > PB then Result := 1;
        end;
    end;

    if Result = 0 then
      Result := AnsiCompareText(Trim(A.Codigo), Trim(B.Codigo));

    if not FSortAscending then
      Result := -Result;
  end;

  procedure Intercambiar(var A, B: TFilaEAN);
  var
    T: TFilaEAN;
  begin
    T := A;
    A := B;
    B := T;
  end;

  procedure QuickSort(L, R: Integer);
  var
    II, JJ: Integer;
    Pivote: TFilaEAN;
  begin
    II := L;
    JJ := R;
    Pivote := Filas[(L + R) div 2];
    repeat
      while CompararFilas(Filas[II], Pivote) < 0 do Inc(II);
      while CompararFilas(Filas[JJ], Pivote) > 0 do Dec(JJ);
      if II <= JJ then
      begin
        Intercambiar(Filas[II], Filas[JJ]);
        Inc(II);
        Dec(JJ);
      end;
    until II > JJ;
    if L < JJ then QuickSort(L, JJ);
    if II < R then QuickSort(II, R);
  end;

begin
  if (FSortColumn < 0) or (FSortColumn > 4) or
     (Lst.Items.Count < 2) then Exit;

  CodigoAnterior := FCodSel;
  DescripcionAnterior := FDesSel;
  SetLength(Filas, Lst.Items.Count);

  for I := 0 to Lst.Items.Count - 1 do
  begin
    Filas[I].Codigo := Lst.Items[I].Caption;
    if Lst.Items[I].SubItems.Count > 0 then
      Filas[I].Descripcion := Lst.Items[I].SubItems[0];
    if Lst.Items[I].SubItems.Count > 1 then
      Filas[I].FechaCompra := Lst.Items[I].SubItems[1];
    if Lst.Items[I].SubItems.Count > 2 then
      Filas[I].FechaVenta := Lst.Items[I].SubItems[2];
    if Lst.Items[I].SubItems.Count > 3 then
      Filas[I].PVP := Lst.Items[I].SubItems[3];
  end;

  QuickSort(0, High(Filas));

  ItemSeleccionado := nil;
  Lst.Items.BeginUpdate;
  try
    Lst.Items.Clear;
    for I := 0 to High(Filas) do
    begin
      Item := Lst.Items.Add;
      Item.Caption := Filas[I].Codigo;
      Item.SubItems.Add(Filas[I].Descripcion);
      Item.SubItems.Add(Filas[I].FechaCompra);
      Item.SubItems.Add(Filas[I].FechaVenta);
      Item.SubItems.Add(Filas[I].PVP);

      if (ItemSeleccionado = nil) and
         SameText(Filas[I].Codigo, CodigoAnterior) and
         SameText(Filas[I].Descripcion, DescripcionAnterior) then
        ItemSeleccionado := Item;
    end;
  finally
    Lst.Items.EndUpdate;
  end;

  if (ItemSeleccionado = nil) and (Lst.Items.Count > 0) then
    ItemSeleccionado := Lst.Items[0];

  if ItemSeleccionado <> nil then
  begin
    Lst.Selected := ItemSeleccionado;
    Lst.ItemFocused := ItemSeleccionado;
    ItemSeleccionado.MakeVisible(False);
    ListaClick(Lst);
  end;
end;

procedure TFLXEANDlg.GuardarClick(Sender: TObject);
var
  Q: TZQuery;
  Cant: Double;
  CantTxt: string;
begin
  if Trim(FCodSel) = '' then
  begin
    ShowMessage('Debe seleccionar un artículo.');
    Exit;
  end;

  CantTxt := Trim(EdCantidad.Text);
  if CantTxt = '' then CantTxt := '1';
  Cant := StrToFloatDef(CantTxt, 0);
  if Cant <= 0 then
    Cant := StrToFloatDef(StringReplace(CantTxt, ',', '.', [rfReplaceAll]), 0);
  if Cant <= 0 then
  begin
    ShowMessage('La cantidad equivalente debe ser mayor que cero.');
    Exit;
  end;

  if RbAux.Checked and (Abs(Cant - 1) > 0.0001) then
    if MessageDlg('Confirmar', 'Ha elegido Código auxiliar pero la cantidad no es 1.' + LineEnding +
       '¿Desea guardarlo igualmente?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FBaseQuery.Connection;
    Q.SQL.Text := 'SELECT EAN0,EAN1 FROM eans WHERE EAN0="' + FLXSQL(FEAN) + '" LIMIT 1';
    Q.Open;
    if not Q.EOF then
    begin
      ShowMessage('Este EAN ya existe asociado al artículo ' + Q.FieldByName('EAN1').AsString + '.');
      ModalResult := mrOk;
      VenderAhora := ChVender.Checked;
      Exit;
    end;
    Q.Close;

    Q.SQL.Text := 'SELECT A0,A1 FROM artitien' + FTienda + ' WHERE A0="' + FLXSQL(FCodSel) + '" LIMIT 1';
    Q.Open;
    if Q.EOF then
    begin
      ShowMessage('No se ha podido localizar el artículo seleccionado.');
      Exit;
    end;
    FDesSel := Q.FieldByName('A1').AsString;
    Q.Close;

    Q.SQL.Text :=
      'INSERT INTO eans (EAN0,EAN1,EAN2,EAN3,EAN4,EAN5) VALUES (' +
      '"' + FLXSQL(FEAN) + '",' +
      '"' + FLXSQL(FCodSel) + '",' +
      '"' + FLXSQL(FDesSel) + '",' +
      FLXFloatSQL(Cant, '0.0000') + ',0,0)';
    Q.ExecSQL;

    VenderAhora := ChVender.Checked;
    ModalResult := mrOk;
  finally
    Q.Free;
  end;
end;

function FLXMostrarAsociarEAN(AOwner: TComponent; ABaseQuery: TZQuery;
  const ATienda, AEAN, ABusquedaInicial, ACantidadInicial: string;
  out AVenderAhora: Boolean): Boolean;
var
  F: TFLXEANDlg;
begin
  Result := False;
  AVenderAhora := False;
  if (ABaseQuery = nil) or (ABaseQuery.Connection = nil) or (Trim(AEAN) = '') then Exit;
  F := TFLXEANDlg.CreateEAN(AOwner, ABaseQuery, ATienda, AEAN, ABusquedaInicial, ACantidadInicial);
  try
    Result := (F.ShowModal = mrOk);
    AVenderAhora := F.VenderAhora;
  finally
    F.Free;
  end;
end;

end.
