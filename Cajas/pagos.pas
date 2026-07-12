unit pagos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ZConnection, ZDataset, EditBtn, DBGrids, db,
  LR_DBSet, LR_Class, Math;

type

  { TFPagos }

  TFPagos = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    CheckBox2: TCheckBox;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    Datasource3: TDatasource;
    DateEdit1: TDateEdit;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    dbPagos: TZQuery;
    dbCambios: TZQuery;
    Panel5: TPanel;
    dbCajas: TZQuery;
    Panel6: TPanel;
    procedure DateEdit1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure LimpiaForm();
    procedure Relleno();
    Procedure Almacena();
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);

  private
    procedure AplicarEstiloModerno;
    procedure AjustarDisenoModerno(Sender: TObject);
    function TryLeerImporte(const ATexto, ACampo: string; out AValor: Double): Boolean;
    function ExistePagoDuplicado(const AFecha: TDateTime; const AImporte: Double; const AConcepto: string): Boolean;
    procedure HabilitarBotonesPrincipales(AHabilitar: Boolean);
    { private declarations }
  public
    { public declarations }
  end; 

procedure ShowFormpagos;

var
  FPagos: TFPagos;
  TituloGrid: String;

implementation

Uses
    Global, Funciones;

{ TFPagos }
procedure ShowFormpagos;
begin
  with TFpagos.Create(Application) do
    begin
       ShowModal;
    end;
end;

procedure TFPagos.FormCreate(Sender: TObject);
begin
  ShortDateFormat:='DD/MM/YYYY';
  {$IFDEF LINUX}
     DecimalSeparator:='.';
  {$ELSE}
     DecimalSeparator:=',';
  {$ENDIF}
  //----------------- CONEXION -----------------
  //Conectate(dbConect);  // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Tablas ------------------
  dbPagos.Sql.Text:='SELECT * FROM gpagos'+Tienda+'';
  dbPagos.Active := True;
  dbCambios.Sql.Text:='SELECT * FROM geconomica'+Tienda+'';
  dbCambios.Active := True;
  //------------------- Inicializacion ----------
  DateEdit1.Date:=Date;       // -- Asigna fecha a los campos
  LimpiaForm();
  Relleno();
  AplicarEstiloModerno;
end;


function TFPagos.TryLeerImporte(const ATexto, ACampo: string; out AValor: Double): Boolean;
var
  S: string;
begin
  S := Trim(ATexto);
  if S = '' then S := '0';

  { Acepta tanto coma como punto, independientemente de la configuracion local. }
  if DecimalSeparator = '.' then
    S := StringReplace(S, ',', '.', [rfReplaceAll])
  else
    S := StringReplace(S, '.', ',', [rfReplaceAll]);

  Result := TryStrToFloat(S, AValor);
  if not Result then
  begin
    ShowMessage('El importe de "' + ACampo + '" no es valido.');
    Exit;
  end;
end;

function TFPagos.ExistePagoDuplicado(const AFecha: TDateTime;
  const AImporte: Double; const AConcepto: string): Boolean;
var
  Q: TZQuery;
begin
  Result := False;
  Q := TZQuery.Create(nil);
  try
    Q.Connection := dbPagos.Connection;
    Q.SQL.Text := 'SELECT COUNT(*) AS TOTAL FROM gpagos' + Tienda +
      ' WHERE Fecha=:fecha AND Importe=:importe AND Concepto=:concepto';
    Q.ParamByName('fecha').AsDateTime := AFecha;
    Q.ParamByName('importe').AsFloat := AImporte;
    Q.ParamByName('concepto').AsString := AConcepto;
    Q.Open;
    Result := Q.FieldByName('TOTAL').AsInteger > 0;
  finally
    Q.Free;
  end;
end;

procedure TFPagos.HabilitarBotonesPrincipales(AHabilitar: Boolean);
begin
  BitBtn1.Enabled := AHabilitar;
  BitBtn2.Enabled := AHabilitar;
  BitBtn3.Enabled := AHabilitar;
  BitBtn4.Enabled := AHabilitar;
end;

procedure TFPagos.AplicarEstiloModerno;
var
  LSub, LMov, LAcum, LMov2, LAcum2: TLabel;
  I: Integer;

  procedure AsignarIconoBoton(ABoton: TBitBtn; ATipo: Integer; ATamano: Integer = 18);
  var
    B: TBitmap;
    C: TCanvas;
    M: Integer;
  begin
    if not Assigned(ABoton) then Exit;
    B := TBitmap.Create;
    try
      B.SetSize(ATamano, ATamano);
      B.Transparent := True;
      B.TransparentColor := clFuchsia;
      C := B.Canvas;
      C.Brush.Style := bsSolid;
      C.Brush.Color := clFuchsia;
      C.FillRect(Rect(0, 0, ATamano, ATamano));
      C.Pen.Color := clNavy;
      C.Pen.Width := 2;
      C.Brush.Style := bsClear;
      M := ATamano div 2;

      case ATipo of
        1: begin { nuevo }
             C.Rectangle(3, 3, ATamano - 3, ATamano - 3);
             C.MoveTo(M, 6); C.LineTo(M, ATamano - 6);
             C.MoveTo(6, M); C.LineTo(ATamano - 6, M);
           end;
        2: begin { buscar }
             C.Ellipse(2, 2, ATamano - 6, ATamano - 6);
             C.MoveTo(ATamano - 7, ATamano - 7);
             C.LineTo(ATamano - 2, ATamano - 2);
           end;
        3: begin { imprimir }
             C.Rectangle(4, 2, ATamano - 4, 7);
             C.Rectangle(2, 7, ATamano - 2, ATamano - 5);
             C.Rectangle(5, ATamano - 9, ATamano - 5, ATamano - 2);
           end;
        4: begin { cerrar }
             C.MoveTo(3, 3); C.LineTo(ATamano - 3, ATamano - 3);
             C.MoveTo(ATamano - 3, 3); C.LineTo(3, ATamano - 3);
           end;
        5: begin { volver/salir }
             C.MoveTo(ATamano - 3, 4); C.LineTo(6, 4);
             C.LineTo(6, 2); C.LineTo(2, M); C.LineTo(6, ATamano - 2);
             C.LineTo(6, ATamano - 5); C.LineTo(ATamano - 3, ATamano - 5);
           end;
        6: begin { pago }
             C.Ellipse(2, 2, ATamano - 2, ATamano - 2);
             C.MoveTo(M + 3, 5); C.LineTo(M - 2, 5);
             C.LineTo(M - 4, M); C.LineTo(M + 3, M);
             C.LineTo(M + 2, ATamano - 5); C.LineTo(M - 3, ATamano - 5);
           end;
        7: begin { movimiento de efectivo }
             C.MoveTo(3, 5); C.LineTo(ATamano - 5, 5);
             C.LineTo(ATamano - 8, 2);
             C.MoveTo(ATamano - 5, 5); C.LineTo(ATamano - 8, 8);
             C.MoveTo(ATamano - 3, ATamano - 5); C.LineTo(5, ATamano - 5);
             C.LineTo(8, ATamano - 8);
             C.MoveTo(5, ATamano - 5); C.LineTo(8, ATamano - 2);
           end;
        8: begin { guardar/aceptar }
             C.MoveTo(2, M); C.LineTo(M - 2, ATamano - 3);
             C.LineTo(ATamano - 2, 3);
           end;
        9: begin { listado }
             C.Rectangle(3, 2, ATamano - 3, ATamano - 2);
             C.MoveTo(6, 6); C.LineTo(ATamano - 6, 6);
             C.MoveTo(6, M); C.LineTo(ATamano - 6, M);
             C.MoveTo(6, ATamano - 6); C.LineTo(ATamano - 6, ATamano - 6);
           end;
      end;

      ABoton.Glyph.Clear;
      ABoton.Glyph.Assign(B);
      ABoton.NumGlyphs := 1;
      ABoton.Layout := blGlyphLeft;
      ABoton.Spacing := 6;
      ABoton.Margin := -1;
    finally
      B.Free;
    end;
  end;

begin
  Caption := 'Pagos, ingresos y movimientos de caja';
  WindowState := wsMaximized;
  { Fondo general azul grisaceo suave para reducir el blanco sin perder contraste. }
  Color := $00E8E2DC;
  ParentFont := False;
  Font.Name := 'Sans';
  Font.Height := -13;

  Panel1.BevelOuter := bvNone;
  Panel1.Color := clNavy;
  Label1.Align := alNone;
  Label1.Caption := 'PAGOS, INGRESOS Y MOVIMIENTOS DE CAJA';
  Label1.SetBounds(24, 10, 760, 30);
  Label1.ParentFont := False;
  Label1.Font.Name := 'Sans';
  Label1.Font.Height := -22;
  Label1.Font.Style := [fsBold];
  Label1.Font.Color := clWhite;
  Label1.Transparent := True;

  LSub := TLabel.Create(Self);
  LSub.Parent := Panel1;
  LSub.SetBounds(26, 43, 900, 22);
  LSub.Caption := 'Registra saldo inicial, entradas de efectivo, retiradas de fondos y pagos varios del puesto activo.';
  LSub.ParentFont := False;
  LSub.Font.Name := 'Sans';
  LSub.Font.Height := -12;
  LSub.Font.Color := clSilver;
  LSub.Transparent := True;
  LSub.Anchors := [akLeft, akTop, akRight];

  Panel2.BevelOuter := bvNone;
  Panel2.Color := $00E1D8CD;
  Panel6.BevelOuter := bvNone;
  Panel6.Color := $00E7DFD6;
  Panel6.Caption := '';
  Label2.Transparent := True;
  CheckBox2.ParentColor := False;
  CheckBox2.Color := Panel6.Color;

  GroupBox1.Caption := ' MOVIMIENTOS ECONÓMICOS DEL DÍA ';
  GroupBox2.Caption := ' PAGOS EN EFECTIVO (PROVEEDORES Y OTROS) ';
  { Tarjetas ligeramente diferenciadas para descansar la vista. }
  GroupBox1.Color := $00F0EBE4;
  GroupBox2.Color := $00EEE9E2;
  GroupBox1.ParentColor := False;
  GroupBox2.ParentColor := False;
  GroupBox1.ParentFont := False;
  GroupBox2.ParentFont := False;
  GroupBox1.Font.Name := 'Sans';
  GroupBox2.Font.Name := 'Sans';
  GroupBox1.Font.Height := -13;
  GroupBox2.Font.Height := -13;
  GroupBox1.Font.Style := [fsBold];
  GroupBox2.Font.Style := [fsBold];
  GroupBox1.Font.Color := clNavy;
  GroupBox2.Font.Color := clNavy;

  Label3.Caption := 'Saldo inicial';
  Label4.Caption := 'Entrada de efectivo / cambio';
  Label5.Caption := 'Retirada de fondos';
  Label7.Caption := 'Importe';
  Label8.Caption := 'Concepto';
  Label9.Caption := 'Observaciones';
  Label10.Caption := 'Observaciones';

  LMov := TLabel.Create(Self);
  LMov.Parent := GroupBox1;
  LMov.Caption := 'Nuevo movimiento';
  LMov.ParentFont := False;
  LMov.Font.Name := 'Sans';
  LMov.Font.Height := -11;
  LMov.Font.Style := [fsBold];
  LMov.Font.Color := clGray;

  LAcum := TLabel.Create(Self);
  LAcum.Parent := GroupBox1;
  LAcum.Caption := 'Acumulado del día';
  LAcum.ParentFont := False;
  LAcum.Font.Name := 'Sans';
  LAcum.Font.Height := -11;
  LAcum.Font.Style := [fsBold];
  LAcum.Font.Color := clGray;

  LMov2 := TLabel.Create(Self);
  LMov2.Parent := GroupBox2;
  LMov2.Caption := 'Nuevo pago';
  LMov2.ParentFont := False;
  LMov2.Font.Name := 'Sans';
  LMov2.Font.Height := -11;
  LMov2.Font.Style := [fsBold];
  LMov2.Font.Color := clGray;

  LAcum2 := TLabel.Create(Self);
  LAcum2.Parent := GroupBox2;
  LAcum2.Caption := 'Pagado acumulado';
  LAcum2.ParentFont := False;
  LAcum2.Font.Name := 'Sans';
  LAcum2.Font.Height := -11;
  LAcum2.Font.Style := [fsBold];
  LAcum2.Font.Color := clGray;

  { Se reutiliza Tag para localizar las cuatro cabeceras al redimensionar. }
  LMov.Tag := 9101;
  LAcum.Tag := 9102;
  LMov2.Tag := 9103;
  LAcum2.Tag := 9104;

  Memo1.Color := $00FAF8F5;
  Memo2.Color := $00FAF8F5;
  Memo1.BorderStyle := bsSingle;
  Memo2.BorderStyle := bsSingle;

  DBGrid1.Color := clWhite;
  DBGrid2.Color := clWhite;
  DBGrid1.FixedColor := $00DDD3C9;
  DBGrid2.FixedColor := $00DDD3C9;
  DBGrid1.TitleFont.Style := [fsBold];
  DBGrid2.TitleFont.Style := [fsBold];
  DBGrid1.Options := DBGrid1.Options + [dgRowSelect, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines];
  DBGrid2.Options := DBGrid2.Options + [dgRowSelect, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines];

  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TBitBtn then
    begin
      TBitBtn(Components[I]).ParentFont := False;
      TBitBtn(Components[I]).Font.Name := 'Sans';
      TBitBtn(Components[I]).Font.Height := -12;
    end
    else if Components[I] is TEdit then
    begin
      TEdit(Components[I]).ParentFont := False;
      TEdit(Components[I]).Font.Name := 'Sans';
      TEdit(Components[I]).Font.Height := -13;
      if TEdit(Components[I]).ReadOnly then
        TEdit(Components[I]).Color := $00E4E1DD
      else
        TEdit(Components[I]).Color := $00FCFBF9;
    end;
  end;

  BitBtn1.Caption := 'Nuevo movimiento';
  BitBtn2.Caption := 'Consultar';
  BitBtn3.Caption := 'Imprimir';
  BitBtn4.Caption := 'Cerrar';

  BitBtn5.Caption := 'Salir';
  BitBtn6.Caption := 'Pagos';
  BitBtn7.Caption := 'Movimientos';
  BitBtn8.Caption := 'Salir';
  BitBtn9.Caption := 'Pagos';
  BitBtn10.Caption := 'Movimientos';
  BitBtn11.Caption := 'Cancelar';
  BitBtn12.Caption := 'Guardar pago';
  BitBtn13.Caption := 'Guardar movimiento';

  Edit7.Hint := 'Pago en efectivo: positivo registra el pago; negativo corrige o anula parcialmente un pago anterior.';
  Edit7.ShowHint := True;
  Edit9.Hint := 'Indique proveedor y documento, por ejemplo: PROVEEDOR X - FACTURA 1234.';
  Edit9.ShowHint := True;
  Edit2.Hint := 'Entrada de efectivo no procedente de ventas: cambio adicional, aportacion u otro ingreso. Positivo suma; negativo corrige una entrada anterior.';
  Edit2.ShowHint := True;
  Edit1.Hint := 'Retirada de efectivo: positivo registra la salida; negativo corrige una retirada anterior.';
  Edit1.ShowHint := True;
  Edit3.Hint := 'Saldo inicial absoluto. Si ya existe, lo sustituye; para otras entradas use Entrada de efectivo / cambio.';
  Edit3.ShowHint := True;

  AsignarIconoBoton(BitBtn1, 1);
  AsignarIconoBoton(BitBtn2, 2);
  AsignarIconoBoton(BitBtn3, 3);
  AsignarIconoBoton(BitBtn4, 4);
  AsignarIconoBoton(BitBtn5, 5);
  AsignarIconoBoton(BitBtn6, 3);
  AsignarIconoBoton(BitBtn7, 3);
  AsignarIconoBoton(BitBtn8, 5);
  AsignarIconoBoton(BitBtn9, 9);
  AsignarIconoBoton(BitBtn10, 7);
  AsignarIconoBoton(BitBtn11, 5);
  AsignarIconoBoton(BitBtn12, 6);
  AsignarIconoBoton(BitBtn13, 7);

  Panel3.Color := $00E7DFD6;
  Panel4.Color := $00E7DFD6;
  Panel5.Color := $00E7DFD6;
  Panel3.BevelOuter := bvRaised;
  Panel4.BevelOuter := bvRaised;
  Panel5.BevelOuter := bvRaised;
  Panel3.BringToFront;
  Panel4.BringToFront;
  Panel5.BringToFront;

  OnResize := @AjustarDisenoModerno;
  AjustarDisenoModerno(Self);
end;

procedure TFPagos.AjustarDisenoModerno(Sender: TObject);
var
  W, H, G1Top, G2Top, G2H, I: Integer;
  C: TComponent;
begin
  W := ClientWidth;
  H := ClientHeight;
  if (W < 760) or (H < 560) then Exit;

  Panel1.Align := alNone;
  Panel2.Align := alNone;
  Panel6.Align := alNone;
  GroupBox1.Align := alNone;
  GroupBox2.Align := alNone;

  Panel1.SetBounds(0, 0, W, 76);
  Panel6.SetBounds(12, 88, W - 24, 54);
  Panel2.SetBounds(0, H - 72, W, 72);

  G1Top := 154;
  GroupBox1.SetBounds(12, G1Top, W - 24, 246);
  G2Top := G1Top + 258;
  G2H := H - 72 - G2Top - 12;
  if G2H < 210 then G2H := 210;
  GroupBox2.SetBounds(12, G2Top, W - 24, G2H);

  Label2.SetBounds(24, 17, 80, 22);
  DateEdit1.SetBounds(100, 13, 140, 28);
  CheckBox2.SetBounds(260, 15, 180, 25);

  { Bloque de movimientos económicos. }
  Label3.SetBounds(24, 54, 150, 24);
  Label4.SetBounds(24, 88, 150, 24);
  Label5.SetBounds(24, 122, 150, 24);
  Edit3.SetBounds(184, 50, 120, 28);
  Edit2.SetBounds(184, 84, 120, 28);
  Edit1.SetBounds(184, 118, 120, 28);
  Edit4.SetBounds(328, 50, 120, 28);
  Edit5.SetBounds(328, 84, 120, 28);
  Edit6.SetBounds(328, 118, 120, 28);
  Label10.SetBounds(480, 28, 130, 22);
  Memo2.SetBounds(480, 50, GroupBox1.ClientWidth - 500, GroupBox1.ClientHeight - 66);

  { Cabeceras creadas en tiempo de ejecución. }
  for I := 0 to ComponentCount - 1 do
  begin
    C := Components[I];
    if C is TLabel then
      case TLabel(C).Tag of
        9101: TLabel(C).SetBounds(184, 28, 130, 18);
        9102: TLabel(C).SetBounds(328, 28, 140, 18);
        9103: TLabel(C).SetBounds(184, 28, 130, 18);
        9104: TLabel(C).SetBounds(328, 28, 140, 18);
      end;
  end;

  { Bloque de pagos. }
  Label7.SetBounds(24, 54, 145, 24);
  Label8.SetBounds(24, 92, 145, 24);
  Label9.SetBounds(24, 130, 145, 24);
  Edit7.SetBounds(184, 50, 120, 28);
  Edit8.SetBounds(328, 50, 120, 28);
  Edit9.SetBounds(184, 88, GroupBox2.ClientWidth - 208, 28);
  Memo1.SetBounds(184, 126, GroupBox2.ClientWidth - 208, GroupBox2.ClientHeight - 142);

  DBGrid1.SetBounds(10, 28, GroupBox1.ClientWidth - 20, GroupBox1.ClientHeight - 40);
  DBGrid2.SetBounds(10, 28, GroupBox2.ClientWidth - 20, GroupBox2.ClientHeight - 40);

  BitBtn1.SetBounds(24, 17, 164, 38);
  BitBtn2.SetBounds(204, 17, 142, 38);
  BitBtn3.SetBounds(362, 17, 142, 38);
  BitBtn4.SetBounds(W - 166, 17, 142, 38);

  { Los tres paneles contextuales ocupan la misma posición; solo uno se muestra cada vez. }
  Panel3.SetBounds((W - 170) div 2, H - 220, 170, 132);
  { El menu de consulta se abre justo encima del boton Consultar. }
  Panel4.SetBounds(
    Panel2.Left + BitBtn2.Left + ((BitBtn2.Width - 170) div 2),
    Panel2.Top - 132 - 8,
    170, 132);
  Panel5.SetBounds((W - 170) div 2, H - 220, 170, 132);

  BitBtn5.SetBounds(10, 92, 150, 32);
  BitBtn6.SetBounds(10, 52, 150, 32);
  BitBtn7.SetBounds(10, 12, 150, 32);
  BitBtn8.SetBounds(10, 92, 150, 32);
  BitBtn9.SetBounds(10, 52, 150, 32);
  BitBtn10.SetBounds(10, 12, 150, 32);
  BitBtn11.SetBounds(10, 92, 150, 32);
  BitBtn12.SetBounds(10, 52, 150, 32);
  BitBtn13.SetBounds(10, 12, 150, 32);
end;

procedure TFPagos.FormActivate(Sender: TObject);
begin
  Edit7.SetFocus;
end;

procedure TFPagos.DateEdit1Change(Sender: TObject);
begin
  LimpiaForm();
  Relleno();
end;

//========= Limpia DATOS =============
Procedure TFPagos.LimpiaForm();
Begin
  Edit1.Text:='0';            // -- Retirada de Fondos
  Edit2.Text:='0';            // -- Incremento de Cambios
  Edit3.Text:='0';            // -- Saldo Inicial
  Edit4.Text:='0';            // -- Acumulado Saldo Inicial
  Edit5.Text:='0';            // -- Acumulado Incremento de Cambios
  Edit6.Text:='0';            // -- Acumulado Retirada de fondos
  Edit7.Text:='0';            // -- Nueva cantidad a Pagar
  Edit8.Text:='0';            // -- Acumulado Pagado
  Edit9.Text:='';             // -- Concepto del Pago
  Memo1.Lines.Text:='';             // -- Observaciones de Pagos
  Memo2.Lines.Text:='';             // -- Olbsrvaciones de Gestion Economica
End;
//========= Pinta DATOS ==============
Procedure TFPagos.Relleno();
Begin
  dbCajas.Close;
  dbCajas.SQL.Text := 'SELECT * FROM cajas' + Tienda +
    ' WHERE CA0=:fecha AND CA1=''9999'' AND CA3=''9999'' AND CA2=:puesto';
  dbCajas.ParamByName('fecha').AsDateTime := DateEdit1.Date;
  dbCajas.ParamByName('puesto').AsString := Puesto;
  dbCajas.Open;

  if dbCajas.IsEmpty then Exit;

  Edit4.Text := dbCajas.FieldByName('CA16').AsString; { saldo inicial }
  Edit5.Text := dbCajas.FieldByName('CA17').AsString; { incrementos de cambio }
  Edit6.Text := dbCajas.FieldByName('CA18').AsString; { retiradas }
  Edit8.Text := dbCajas.FieldByName('CA19').AsString; { pagos en efectivo }
End;

//=========== Almacena información en Cajas + tienda ==========
procedure TFPagos.Almacena();
var
  VSaldo, VEntrada, VRetirada, VPago: Double;
Begin
  if not TryLeerImporte(Edit3.Text, 'Saldo inicial', VSaldo) then Exit;
  if not TryLeerImporte(Edit2.Text, 'Entrada de efectivo / cambio', VEntrada) then Exit;
  if not TryLeerImporte(Edit1.Text, 'Retirada de fondos', VRetirada) then Exit;
  if not TryLeerImporte(Edit7.Text, 'Pago en efectivo', VPago) then Exit;

  dbCajas.Close;
  dbCajas.SQL.Text := 'SELECT * FROM cajas' + Tienda +
    ' WHERE CA0=:fecha AND CA1=''9999'' AND CA3=''9999'' AND CA2=:puesto';
  dbCajas.ParamByName('fecha').AsDateTime := DateEdit1.Date;
  dbCajas.ParamByName('puesto').AsString := Puesto;
  dbCajas.Open;

  if dbCajas.IsEmpty then
  begin
    dbCajas.Append;
    dbCajas.FieldByName('CA0').AsDateTime := DateEdit1.Date;
    dbCajas.FieldByName('CA1').AsString := '9999';
    dbCajas.FieldByName('CA2').AsString := Puesto;
    dbCajas.FieldByName('CA3').AsString := '9999';
    dbCajas.FieldByName('CA16').AsFloat := VSaldo;
    dbCajas.FieldByName('CA17').AsFloat := VEntrada;
    dbCajas.FieldByName('CA18').AsFloat := VRetirada;
    dbCajas.FieldByName('CA19').AsFloat := VPago;
  end
  else
  begin
    dbCajas.Edit;
    { El saldo inicial es absoluto. Para entradas adicionales se usa CA17. }
    if VSaldo > 0 then
      dbCajas.FieldByName('CA16').AsFloat := VSaldo;
    dbCajas.FieldByName('CA17').AsFloat := dbCajas.FieldByName('CA17').AsFloat + VEntrada;
    dbCajas.FieldByName('CA18').AsFloat := dbCajas.FieldByName('CA18').AsFloat + VRetirada;
    dbCajas.FieldByName('CA19').AsFloat := dbCajas.FieldByName('CA19').AsFloat + VPago;
  end;

  dbCajas.Post;
  dbCajas.ApplyUpdates;
End;

//============= Control de botones en pantalla ================
//---------- Nuevo ----------------
Procedure TFPagos.Bitbtn1click(Sender: Tobject); //-Nuevo
Begin
     Panel5.Visible:=True;
     HabilitarBotonesPrincipales(False);
End;

Procedure TFPagos.Bitbtn11click(Sender: Tobject); //-Salir Nuevo
Begin
     Panel5.Visible:=False;
     HabilitarBotonesPrincipales(True);

End;

Procedure TFPagos.Bitbtn12click(Sender: Tobject); // Guardar pago en efectivo
var
  VPago, VPagoActual: Double;
  Concepto: string;
begin
  if not TryLeerImporte(Edit7.Text, 'Pago en efectivo', VPago) then
  begin
    Edit7.SetFocus;
    Exit;
  end;
  if Abs(VPago) < 0.0001 then
  begin
    ShowMessage('Debe indicar un importe distinto de cero.');
    Edit7.SetFocus;
    Exit;
  end;

  VPagoActual := 0;
  if not TryLeerImporte(Edit8.Text, 'Pagos acumulados', VPagoActual) then Exit;
  if (VPagoActual + VPago) < -0.0001 then
  begin
    ShowMessage('La correccion supera el total de pagos acumulados.' + LineEnding +
      'Pagos acumulados: ' + FormatFloat('0.00', VPagoActual) + LineEnding +
      'Correccion solicitada: ' + FormatFloat('0.00', VPago));
    Edit7.SetFocus;
    Exit;
  end;

  Concepto := Trim(Edit9.Text);
  if Concepto = '' then
  begin
    ShowMessage('El CONCEPTO no puede estar en blanco.' + LineEnding +
      'Para pagos a proveedores indique proveedor y factura o documento.');
    Edit9.SetFocus;
    Exit;
  end;

  if VPago < 0 then
    if MessageDlg('Va a registrar una CORRECCION de pagos por ' +
      FormatFloat('0.00', Abs(VPago)) + '.' + LineEnding +
      'El total pagado acumulado se reducira.' + LineEnding +
      '¿Desea continuar?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      Exit;

  if ExistePagoDuplicado(DateEdit1.Date, VPago, Concepto) then
    if MessageDlg('Ya existe un movimiento con la misma fecha, importe y concepto.' +
      LineEnding + 'Puede ser un movimiento legitimo repetido. ¿Desea guardarlo igualmente?',
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      Exit;

  try
    dbPagos.Close;
    dbPagos.SQL.Text := 'SELECT * FROM gpagos' + Tienda;
    dbPagos.Open;
    dbPagos.Append;
    dbPagos.FieldByName('Fecha').AsDateTime := DateEdit1.Date;
    dbPagos.FieldByName('Importe').AsFloat := VPago;
    dbPagos.FieldByName('Concepto').AsString := Concepto;
    dbPagos.FieldByName('Observaciones').AsString := Memo1.Lines.Text;
    dbPagos.Post;
    dbPagos.ApplyUpdates;

    Almacena;
    if VPago > 0 then
      ShowMessage('Pago almacenado correctamente.')
    else
      ShowMessage('Correccion de pago almacenada correctamente.');
    Panel5.Visible := False;
    HabilitarBotonesPrincipales(True);
    LimpiaForm;
    Relleno;
  except
    on E: Exception do
    begin
      ShowMessage('No se pudo guardar el movimiento:' + LineEnding + E.Message);
      Edit7.SetFocus;
    end;
  end;
end;

Procedure TFPagos.Bitbtn13click(Sender: Tobject); // Guardar saldo/entradas/retiradas
var
  VSaldo, VEntrada, VRetirada: Double;
  VSaldoActual, VEntradaActual, VRetiradaActual: Double;
begin
  if not TryLeerImporte(Edit3.Text, 'Saldo inicial', VSaldo) then begin Edit3.SetFocus; Exit; end;
  if not TryLeerImporte(Edit2.Text, 'Entrada de efectivo / cambio', VEntrada) then begin Edit2.SetFocus; Exit; end;
  if not TryLeerImporte(Edit1.Text, 'Retirada de fondos', VRetirada) then begin Edit1.SetFocus; Exit; end;

  if VSaldo < 0 then
  begin
    ShowMessage('El saldo inicial no puede ser negativo.' + LineEnding +
      'Introduzca el saldo inicial absoluto correcto.');
    Edit3.SetFocus;
    Exit;
  end;

  if (Abs(VSaldo) < 0.0001) and (Abs(VEntrada) < 0.0001) and
     (Abs(VRetirada) < 0.0001) then
  begin
    ShowMessage('Indique al menos un movimiento distinto de cero.');
    Exit;
  end;

  if Trim(Memo2.Text) = '' then
  begin
    ShowMessage('Debe introducir algun comentario en OBSERVACIONES.');
    Memo2.SetFocus;
    Exit;
  end;

  VSaldoActual := 0;
  VEntradaActual := 0;
  VRetiradaActual := 0;
  if not TryLeerImporte(Edit4.Text, 'Saldo inicial acumulado', VSaldoActual) then Exit;
  if not TryLeerImporte(Edit5.Text, 'Entradas acumuladas', VEntradaActual) then Exit;
  if not TryLeerImporte(Edit6.Text, 'Retiradas acumuladas', VRetiradaActual) then Exit;

  if (VEntradaActual + VEntrada) < -0.0001 then
  begin
    ShowMessage('La correccion supera las entradas de efectivo acumuladas.' + LineEnding +
      'Entradas acumuladas: ' + FormatFloat('0.00', VEntradaActual) + LineEnding +
      'Correccion solicitada: ' + FormatFloat('0.00', VEntrada));
    Edit2.SetFocus;
    Exit;
  end;

  if (VRetiradaActual + VRetirada) < -0.0001 then
  begin
    ShowMessage('La correccion supera las retiradas de fondos acumuladas.' + LineEnding +
      'Retiradas acumuladas: ' + FormatFloat('0.00', VRetiradaActual) + LineEnding +
      'Correccion solicitada: ' + FormatFloat('0.00', VRetirada));
    Edit1.SetFocus;
    Exit;
  end;

  if ((VEntrada < 0) or (VRetirada < 0)) then
    if MessageDlg('Ha introducido un importe negativo.' + LineEnding +
      'Se registrara como una CORRECCION del acumulado correspondiente.' + LineEnding +
      '¿Desea continuar?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      Exit;

  if (VSaldo > 0) and (VSaldoActual > 0) and (Abs(VSaldo - VSaldoActual) > 0.0001) then
    if MessageDlg('Ya existe un saldo inicial de ' + FormatFloat('0.00', VSaldoActual) + '.' +
      LineEnding + 'El saldo inicial es un valor absoluto y sera sustituido por ' +
      FormatFloat('0.00', VSaldo) + '.' + LineEnding +
      'Para añadir efectivo sin sustituirlo use Entrada de efectivo / cambio.' +
      LineEnding + '¿Desea continuar?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      Exit;

  try
    dbCambios.Close;
    dbCambios.SQL.Text := 'SELECT * FROM geconomica' + Tienda;
    dbCambios.Open;
    dbCambios.Append;
    dbCambios.FieldByName('Fecha').AsDateTime := DateEdit1.Date;
    dbCambios.FieldByName('SaldoI').AsFloat := VSaldo;
    dbCambios.FieldByName('Cambios').AsFloat := VEntrada;
    dbCambios.FieldByName('RetiraF').AsFloat := VRetirada;
    dbCambios.FieldByName('Observaciones').AsString := Memo2.Lines.Text;
    dbCambios.Post;
    dbCambios.ApplyUpdates;

    Almacena;
    ShowMessage('Movimiento de caja almacenado correctamente.');
    Panel5.Visible := False;
    HabilitarBotonesPrincipales(True);
    LimpiaForm;
    Relleno;
  except
    on E: Exception do
    begin
      ShowMessage('No se pudo guardar el movimiento de caja:' + LineEnding + E.Message);
      Memo2.SetFocus;
    end;
  end;
end;

Procedure TFPagos.Bitbtn2click(Sender: Tobject); //-Consultar
Begin
     AjustarDisenoModerno(Self);
     Panel4.BringToFront;
     Panel4.Visible:=True;
     HabilitarBotonesPrincipales(False);
End;

Procedure TFPagos.Bitbtn9click(Sender: Tobject); //- Pagos
Begin
     dbPagos.Close;
     If CheckBox2.Checked then
       dbPagos.SQL.Text := 'SELECT * FROM gpagos' + Tienda
     Else
       Begin
         dbPagos.SQL.Text := 'SELECT * FROM gpagos' + Tienda +
           ' WHERE Fecha=:fecha';
         dbPagos.ParamByName('fecha').AsDateTime := DateEdit1.Date;
       End;
     dbPagos.Open;
     DBGrid1.Visible:=True;
End;

Procedure TFPagos.Bitbtn10click(Sender: Tobject); //- Cambios
Begin
     dbCambios.Close;
     If CheckBox2.Checked then
       dbCambios.SQL.Text := 'SELECT * FROM geconomica' + Tienda
     Else
       Begin
         dbCambios.SQL.Text := 'SELECT * FROM geconomica' + Tienda +
           ' WHERE Fecha=:fecha';
         dbCambios.ParamByName('fecha').AsDateTime := DateEdit1.Date;
       End;
     dbCambios.Open;
     DBGrid2.Visible:=True;
End;

Procedure TFPagos.Bitbtn8click(Sender: Tobject); //-Salir consultar
Begin
     Panel4.Visible:=False;
     HabilitarBotonesPrincipales(True);
     DBGrid1.Visible:=False;
     DBGrid2.Visible:=False;
End;

//---------- Imprimir ----------------
Procedure TFPagos.Bitbtn3click(Sender: Tobject); //-Imprimir
Begin
     Panel3.Visible:=True;
     HabilitarBotonesPrincipales(False);
End;

Procedure TFPagos.Bitbtn5click(Sender: Tobject); //-Salir Imprimir
Begin
     Panel3.Visible:=False;
     HabilitarBotonesPrincipales(True);
End;
//==================== IMPRIMIR ===================
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFPagos.frReport1GetValue(const ParName: String;
var ParValue: Variant);
begin
if ParName='EMPRESA' then ParValue := Empresa;
if ParName='DIRECCION' then ParValue := Direccion;
if ParName='LOCALIDAD' then ParValue := Localidad;
if ParName='PROVINCIA' then ParValue := Provincia;
if ParName='NIF' then ParValue := Nif;
if ParName='TELEFONO' then ParValue := Telefono;
if ParName='FAX' then ParValue := Fax;
if ParName='EMAIL' then ParValue := EMail;
if ParName='CP' then ParValue := CP;
if ParName='TITULO' then ParValue := TituloGrid;
end;

procedure TFPagos.BitBtn6Click(Sender: TObject);
begin
  //-------------------------- Datos Principales
  //--- PAGOS
  TituloGrid:='Listado de Cajas - PAGOS';
  dbPagos.Close;
  If CheckBox2.Checked then
    dbPagos.SQL.Text := 'SELECT * FROM gpagos' + Tienda
  Else
    Begin
      dbPagos.SQL.Text := 'SELECT * FROM gpagos' + Tienda +
        ' WHERE Fecha=:fecha';
      dbPagos.ParamByName('fecha').AsDateTime := DateEdit1.Date;
    End;
  dbPagos.Open;
  if dbPagos.RecordCount=0 then
    begin
      Showmessage('NO HAY INFORMACION ENTRE ESOS DATOS');
      exit;
    end;
  frDBDataSet1.DataSet:=dbPagos;
  frReport1.LoadFromFile(RutaReports+'ListaCajasPagos.lrf');
  frReport1.ShowReport;
end;

procedure TFPagos.BitBtn7Click(Sender: TObject);
begin
  //-------------------------- Datos Principales
  //--- CAMBIOS
  TituloGrid:='Listado de Cajas - CAMBIOS';
  dbCambios.Close;
  If CheckBox2.Checked then
    dbCambios.SQL.Text := 'SELECT * FROM geconomica' + Tienda
  Else
    Begin
      dbCambios.SQL.Text := 'SELECT * FROM geconomica' + Tienda +
        ' WHERE Fecha=:fecha';
      dbCambios.ParamByName('fecha').AsDateTime := DateEdit1.Date;
    End;
  dbCambios.Open;
  if dbCambios.RecordCount=0 then
    begin
      Showmessage('NO HAY INFORMACION ENTRE ESOS DATOS');
      exit;
    end;
  frDBDataSet1.DataSet:=dbCambios;
  frReport1.LoadFromFile(RutaReports+'ListaCajasCambios.lrf');
  frReport1.ShowReport;
end;

// ========== Cerrar Formulario de Pagos ===========
Procedure TFPagos.Bitbtn4click(Sender: Tobject);
Begin
     Close;
End;

initialization
  {$I pagos.lrs}

end.
