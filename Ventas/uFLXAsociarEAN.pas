unit uFLXAsociarEAN;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, Buttons,
  Dialogs, Graphics, ZConnection, ZDataset;

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
    LbTitulo, LbEAN, LbBuscar, LbSeleccion, LbCantidad, LbTipo, LbInfo: TLabel;
    EdBuscar, EdCantidad: TEdit;
    RbAux, RbPack: TRadioButton;
    Lst: TListBox;
    BtnBuscar, BtnGuardar, BtnCancelar: TButton;
    ChVender: TCheckBox;
    procedure BuscarClick(Sender: TObject);
    procedure ListaClick(Sender: TObject);
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

  Lst := TListBox.Create(Self);
  Lst.Parent := Self;
  Lst.Left := 16;
  Lst.Top := 145;
  Lst.Width := 785;
  Lst.Height := 275;
  Lst.OnClick := @ListaClick;

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
  B, Cod, Des: string;
begin
  B := Trim(EdBuscar.Text);
  Lst.Items.Clear;
  FCodSel := '';
  FDesSel := '';
  LbSeleccion.Caption := 'Artículo seleccionado: (ninguno)';

  if B = '' then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FBaseQuery.Connection;
    Q.SQL.Text :=
      'SELECT A0,A1,A2 FROM artitien' + FTienda +
      ' WHERE A0 LIKE "%' + FLXSQL(B) + '%" ' +
      '    OR A1 LIKE "%' + FLXSQL(B) + '%" ' +
      '    OR A19 LIKE "%' + FLXSQL(B) + '%" ' +
      ' ORDER BY A1 LIMIT 150';
    Q.Open;
    while not Q.EOF do
    begin
      Cod := Q.FieldByName('A0').AsString;
      Des := Q.FieldByName('A1').AsString;
      Lst.Items.Add(Cod + ' | ' + Des + ' | PVP ' + Q.FieldByName('A2').AsString);
      Q.Next;
    end;

    Q.Close;
    Q.SQL.Text :=
      'SELECT e.EAN1 AS A0, a.A1 AS A1 FROM eans e ' +
      'LEFT JOIN artitien' + FTienda + ' a ON a.A0=e.EAN1 ' +
      'WHERE e.EAN0 LIKE "%' + FLXSQL(B) + '%" ' +
      '   OR e.EAN2 LIKE "%' + FLXSQL(B) + '%" ' +
      'ORDER BY e.EAN2 LIMIT 50';
    Q.Open;
    while not Q.EOF do
    begin
      Cod := Q.FieldByName('A0').AsString;
      Des := Q.FieldByName('A1').AsString;
      if Trim(Cod) <> '' then
        Lst.Items.Add(Cod + ' | ' + Des + ' | encontrado por EAN auxiliar');
      Q.Next;
    end;

    if Lst.Items.Count > 0 then
    begin
      Lst.ItemIndex := 0;
      ListaClick(Lst);
    end;
  finally
    Q.Free;
  end;
end;

procedure TFLXEANDlg.ListaClick(Sender: TObject);
var
  S: string;
  P: Integer;
begin
  if (Lst.ItemIndex < 0) or (Lst.ItemIndex >= Lst.Items.Count) then Exit;
  S := Lst.Items[Lst.ItemIndex];
  P := Pos(' | ', S);
  if P <= 1 then Exit;
  FCodSel := Copy(S, 1, P - 1);
  Delete(S, 1, P + 2);
  P := Pos(' | ', S);
  if P > 0 then
    FDesSel := Copy(S, 1, P - 1)
  else
    FDesSel := S;
  LbSeleccion.Caption := 'Artículo seleccionado: ' + FCodSel + ' - ' + FDesSel;
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
