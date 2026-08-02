{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2009, Nicolas Lopez de Lerma Aymerich

  PuntoDev GNU S.L. <info@puntodev.com>

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

unit Series;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  Classes, SysUtils, Math, StrUtils, LResources, Forms, Controls, Graphics, Dialogs, LCLType,
  DBGrids, db, ZConnection, ZDataset, Buttons, ExtCtrls, StdCtrls;

type

  { TFSeries }

  TFSeries = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    Datasource1: TDatasource;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    dbSeries: TZQuery;
    Label7: TLabel;
    Label8: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure PintaDatos();
    procedure LimpiaDatos();
    procedure Relleno();

  private
    FHeaderBar: TPanel;
    FHeaderTitle: TLabel;
    FHeaderSubtitle: TLabel;
    FEditTitle: TLabel;
    FCountersCard: TShape;
    FOrdenGridCampo: string;
    FOrdenGridDireccion: string;
    function CrearPanelVisual(AParent: TWinControl; AColor: TColor): TPanel;
    function CrearTituloVisual(AParent: TWinControl; const ACaption: string): TLabel;
    procedure EstilarBoton(ABoton: TBitBtn; AColor: TColor; ATextoClaro: Boolean);
    procedure AplicarEstiloModerno;
    procedure RecolocarControles(Sender: TObject);
    function SQLSinOrden(const ASQL: string): string;
    procedure ActualizarFlechaGrid(AGrid: TDBGrid; const ACampo, ADireccion: string);
    procedure DBGrid1TitleClick(Column: TColumn);
    { private declarations }
  public
    { public declarations }
  end;

  procedure ShowFormSeries;

var
  FSeries: TFSeries;

implementation

uses
  Global, Funciones;
  

//============================================================================
//====================== DISEÑO MODERNO Y ADAPTABLE ==========================
//============================================================================
function TFSeries.CrearPanelVisual(AParent: TWinControl;
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

function TFSeries.CrearTituloVisual(AParent: TWinControl;
  const ACaption: string): TLabel;
begin
  Result := TLabel.Create(AParent);
  Result.Parent := AParent;
  Result.AutoSize := False;
  Result.Caption := ACaption;
  Result.Transparent := True;
  Result.Layout := tlCenter;
  Result.ParentFont := False;
  Result.Font.Name := 'Sans';
  Result.Font.Height := -13;
  Result.Font.Style := [fsBold];
  Result.Font.Color := RGBToColor(36, 76, 94);
end;

procedure TFSeries.EstilarBoton(ABoton: TBitBtn;
  AColor: TColor; ATextoClaro: Boolean);
begin
  if not Assigned(ABoton) then Exit;
  ABoton.ParentFont := False;
  ABoton.Font.Name := 'Sans';
  ABoton.Font.Height := -12;
  ABoton.Font.Style := [fsBold];
  ABoton.Color := AColor;
  if ATextoClaro then ABoton.Font.Color := clWhite
  else ABoton.Font.Color := RGBToColor(30, 41, 59);
end;

function TFSeries.SQLSinOrden(const ASQL: string): string;
var
  P: SizeInt;
begin
  Result := Trim(ASQL);
  P := RPos(' ORDER BY ', UpperCase(Result));
  if P > 0 then Result := Trim(Copy(Result, 1, P - 1));
  if (Result <> '') and (Result[Length(Result)] = ';') then
    Delete(Result, Length(Result), 1);
end;

procedure TFSeries.ActualizarFlechaGrid(AGrid: TDBGrid;
  const ACampo, ADireccion: string);
var
  I: Integer;
  Titulo: string;
begin
  for I := 0 to AGrid.Columns.Count - 1 do
  begin
    Titulo := AGrid.Columns[I].Title.Caption;
    Titulo := StringReplace(Titulo, ' ▲', '', [rfReplaceAll]);
    Titulo := StringReplace(Titulo, ' ▼', '', [rfReplaceAll]);
    if SameText(AGrid.Columns[I].FieldName, ACampo) then
      if SameText(ADireccion, 'DESC') then Titulo := Titulo + ' ▼'
      else Titulo := Titulo + ' ▲';
    AGrid.Columns[I].Title.Caption := Titulo;
  end;
end;

procedure TFSeries.DBGrid1TitleClick(Column: TColumn);
var
  Campo, BaseSQL: string;
begin
  if not Assigned(Column) then Exit;
  Campo := Trim(Column.FieldName);
  if Campo = '' then Exit;
  if SameText(FOrdenGridCampo, Campo) then
  begin
    if SameText(FOrdenGridDireccion, 'ASC') then
      FOrdenGridDireccion := 'DESC'
    else
      FOrdenGridDireccion := 'ASC';
  end
  else
  begin
    FOrdenGridCampo := Campo;
    FOrdenGridDireccion := 'ASC';
  end;
  BaseSQL := SQLSinOrden(dbSeries.SQL.Text);
  dbSeries.DisableControls;
  try
    dbSeries.Close;
    dbSeries.SQL.Text := BaseSQL + ' ORDER BY `' + Campo + '` ' +
      FOrdenGridDireccion;
    dbSeries.Open;
  finally
    dbSeries.EnableControls;
  end;
  ActualizarFlechaGrid(DBGrid1, FOrdenGridCampo, FOrdenGridDireccion);
end;

procedure TFSeries.AplicarEstiloModerno;
var
  I: Integer;
  C: TComponent;
begin
  Caption := 'FacturLinEx · Series de facturación';
  Color := RGBToColor(241, 245, 247);
  Font.Name := 'Sans';
  Font.Height := -12;
  Position := poDesktopCenter;
  Constraints.MinWidth := 900;
  Constraints.MinHeight := 540;
  Width := Max(Width, 920);
  Height := Max(Height, 580);

  FHeaderBar := CrearPanelVisual(Self, RGBToColor(18, 76, 91));
  FHeaderBar.Align := alTop;
  FHeaderBar.Height := 82;
  FHeaderTitle := CrearTituloVisual(FHeaderBar, 'SERIES DE FACTURACIÓN');
  FHeaderTitle.Font.Height := -20;
  FHeaderTitle.Font.Color := clWhite;
  FHeaderSubtitle := CrearTituloVisual(FHeaderBar,
    'Numeración independiente para facturas, albaranes, tickets y documentos');
  FHeaderSubtitle.Font.Height := -11;
  FHeaderSubtitle.Font.Style := [];
  FHeaderSubtitle.Font.Color := RGBToColor(205, 232, 237);

  Panel2.Align := alBottom;
  Panel2.Height := 68;
  Panel2.Caption := '';
  Panel2.BevelOuter := bvNone;
  Panel2.Color := RGBToColor(225, 233, 236);
  DBGrid1.Align := alClient;
  DBGrid1.BorderSpacing.Around := 16;
  DBGrid1.DefaultRowHeight := 28;
  DBGrid1.Font.Name := 'Sans';
  DBGrid1.Font.Height := -11;
  DBGrid1.TitleFont.Name := 'Sans';
  DBGrid1.TitleFont.Style := [fsBold];
  DBGrid1.FixedColor := RGBToColor(211, 225, 231);
  DBGrid1.OnTitleClick := @DBGrid1TitleClick;
  FOrdenGridCampo := 'SF0';
  FOrdenGridDireccion := 'ASC';
  ActualizarFlechaGrid(DBGrid1, FOrdenGridCampo, FOrdenGridDireccion);

  Panel1.Caption := '';
  Panel1.BevelOuter := bvRaised;
  Panel1.BevelWidth := 2;
  Panel1.ParentColor := False;
  Panel1.Color := RGBToColor(235, 241, 244);
  Panel1.Visible := False;
  FEditTitle := CrearTituloVisual(Panel1, 'CREAR O MODIFICAR SERIE');
  FEditTitle.Font.Height := -16;
  FCountersCard := TShape.Create(Self);
  FCountersCard.Parent := Panel1;
  FCountersCard.Shape := stRectangle;
  FCountersCard.Brush.Color := RGBToColor(231, 243, 234);
  FCountersCard.Pen.Color := RGBToColor(199, 219, 205);
  FCountersCard.SendToBack;

  Label1.Caption := 'Código de serie';
  Label2.Caption := 'Descripción';
  Label3.Caption := 'N.º factura';
  Label4.Caption := 'N.º albarán';
  Label5.Caption := 'N.º ticket';
  Label6.Caption := 'N.º presupuesto';
  Label7.Caption := 'N.º pedido';
  Label8.Caption := 'N.º proforma';

  for I := 0 to ComponentCount - 1 do
  begin
    C := Components[I];
    if C is TLabel then
    begin
      TLabel(C).ParentFont := False;
      TLabel(C).Font.Name := 'Sans';
      if TLabel(C).Font.Height > -11 then TLabel(C).Font.Height := -11;
      if (C <> FHeaderTitle) and (C <> FHeaderSubtitle) then
        TLabel(C).Font.Color := RGBToColor(37, 52, 61);
    end
    else if C is TEdit then
    begin
      TEdit(C).ParentFont := False;
      TEdit(C).Font.Name := 'Sans';
      TEdit(C).Font.Height := -12;
    end;
  end;

  EstilarBoton(BitBtn2, RGBToColor(58, 138, 92), True);
  EstilarBoton(BitBtn3, RGBToColor(190, 68, 68), True);
  EstilarBoton(BitBtn4, RGBToColor(23, 96, 116), True);
  EstilarBoton(BitBtn1, RGBToColor(73, 83, 91), True);
  EstilarBoton(BitBtn5, RGBToColor(58, 138, 92), True);
  EstilarBoton(BitBtn6, RGBToColor(73, 83, 91), True);
  BitBtn4.Caption := 'Modificar';
  BitBtn5.Caption := 'Aceptar';
  BitBtn6.Caption := 'Cancelar';

  OnResize := @RecolocarControles;
  RecolocarControles(Self);
end;

procedure TFSeries.RecolocarControles(Sender: TObject);
var
  W, X, Y, ColW, I: Integer;
  Lbls: array[0..5] of TLabel;
  Edits: array[0..5] of TEdit;
begin
  FHeaderTitle.SetBounds(22, 10, 520, 30);
  FHeaderSubtitle.SetBounds(24, 42, 700, 22);

  BitBtn2.SetBounds(18, 13, 132, 42);
  BitBtn3.SetBounds(164, 13, 132, 42);
  BitBtn4.SetBounds(310, 13, 132, 42);
  BitBtn1.SetBounds(Panel2.ClientWidth - 150, 13, 132, 42);

  W := Min(820, ClientWidth - 80);
  Panel1.SetBounds((ClientWidth - W) div 2, 104, W,
    Max(330, Min(390, ClientHeight - Panel2.Height - 128)));
  FEditTitle.SetBounds(22, 12, Panel1.ClientWidth - 44, 30);
  Label1.SetBounds(28, 62, 110, 24);
  Edit1.SetBounds(146, 58, 100, 30);
  Label2.SetBounds(276, 62, 92, 24);
  Edit2.SetBounds(374, 58, Panel1.ClientWidth - 402, 30);
  FCountersCard.SetBounds(22, 112, Panel1.ClientWidth - 44, 154);

  Lbls[0] := Label3; Edits[0] := Edit3;
  Lbls[1] := Label4; Edits[1] := Edit4;
  Lbls[2] := Label5; Edits[2] := Edit5;
  Lbls[3] := Label6; Edits[3] := Edit6;
  Lbls[4] := Label7; Edits[4] := Edit7;
  Lbls[5] := Label8; Edits[5] := Edit8;
  ColW := (Panel1.ClientWidth - 64) div 3;
  for I := 0 to 5 do
  begin
    X := 34 + (I mod 3) * ColW;
    Y := 132 + (I div 3) * 62;
    Lbls[I].SetBounds(X, Y, ColW - 104, 22);
    Edits[I].SetBounds(X + ColW - 96, Y - 4, 82, 30);
  end;
  BitBtn5.SetBounds(Panel1.ClientWidth - 292, Panel1.ClientHeight - 58, 128, 40);
  BitBtn6.SetBounds(Panel1.ClientWidth - 150, Panel1.ClientHeight - 58, 128, 40);
  FCountersCard.SendToBack;
  if Panel1.Visible then Panel1.BringToFront;
end;


{ TFSeries }

//=============== Crea el formulario ================
procedure ShowFormSeries;
begin
  with TFSeries.Create(Application) do
    begin
       ShowModal;
    end;
end;
procedure TFSeries.FormCreate(Sender: TObject);
begin
   //--------- Conectar con la bbdd e inicializar datos globales
  //Conectate(dbConect);     // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Tablas ------------------
  dbSeries.Sql.Text:='SELECT * FROM seriesfactu ORDER BY SF0';
  dbSeries.Active := True;
  AplicarEstiloModerno;
end;

//====================== CERRAR FORMULARIO =======================
procedure TFSeries.BitBtn1Click(Sender: TObject);
begin
   Close();
end;
procedure TFSeries.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;

//================== CREAR NUEVA SERIE ============
procedure TFSeries.BitBtn2Click(Sender: TObject);
begin
  Panel1.Visible:=True; Panel1.BringToFront;
  RecolocarControles(Self);
  DBGrid1.Enabled:=False; Panel2.Enabled:=False;
  Edit1.Text:=''; LimpiaDatos();
  Edit1.Enabled:=True; Edit1.SetFocus;
end;

//================ BORRAR SERIES ====================
procedure TFSeries.BitBtn3Click(Sender: TObject);
begin
  if (dbSeries.RecordCount=0) or (dbSeries.EOF) then
    begin
      ShowMessage('ESA SERIE NO EXISTE, NO PUEDE BORRARLA');
      exit;
    end;
  boxstyle :=  MB_ICONQUESTION + MB_YESNO;
  If Application.MessageBox('CONFIRME EL BORRADO DE LA SERIE','FacturLinEx', boxstyle) = IDNO Then
    Exit;
  dbSeries.Delete;
end;

//================= MODIFICAR SERIE =====================
procedure TFSeries.DBGrid1DblClick(Sender: TObject);
begin
  Panel1.Visible:=True; Panel1.BringToFront;
  RecolocarControles(Self);
  DBGrid1.Enabled:=False; Panel2.Enabled:=False;
  LimpiaDatos(); PintaDatos();
  Edit1.Enabled:=False; Edit2.SetFocus;
end;

//================ CODIGO DE LA SERIE ===================
procedure TFSeries.Edit1Exit(Sender: TObject);
begin
  if Edit1.Enabled=False then exit;
  if Edit1.Text='' then begin Edit1.SetFocus; exit; end;
  if dbSeries.Locate('SF0',Edit1.Text,[]) then
    begin
      PintaDatos();
      ShowMessage('ESA SERIE YA EXISTE');
      LimpiaDatos(); Edit1.Text:=''; Edit1.SetFocus;
      exit;
    end
end;

//=============== ACEPTAR MODIFCAR / CREAR ================
procedure TFSeries.BitBtn5Click(Sender: TObject);
begin
  //------------- Crear o Modificar Registros --------
  if Edit1.Enabled=true then
    begin
     if (Edit1.Text='') or (Edit2.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;
     if dbSeries.Locate('SF0',Edit1.Text,[]) then
       begin ShowMessage('ESE REGISTRO YA EXISTE'); exit; end;
     dbSeries.Append;
    end
  else
    begin
     if (Edit1.Text='') or (Edit2.Text='') then
       begin showmessage('NO PUEDE CREAR REGISTROS EN BLANCO'); exit; end;
     if not dbSeries.Locate('SF0',Edit1.Text,[]) then
       begin ShowMessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO'); exit; end;
     dbSeries.Edit;
    end;
  Relleno();//---- Rellenar datos
  dbSeries.Post;
  BitBtn6Click(BitBtn6);//--- Cerrar Panel
end;

//================= CERRAR CREAR / MODIFICAR ==============
procedure TFSeries.BitBtn6Click(Sender: TObject);
begin
  Panel1.Visible:=False; Edit1.Enabled:=True;
  DBGrid1.Enabled:=True; Panel2.Enabled:=True;
end;

//================ PINTAR DATOS EN EL PANEL =============
procedure TFSeries.PintaDatos();
begin
  Edit1.Text:=dbSeries.FieldByName('SF0').AsString;//---- Codigo
  Edit2.Text:=dbSeries.FieldByName('SF1').AsString;//---- Nombre
  Edit3.Text:=dbSeries.FieldByName('SF2').AsString;//---- N.Facturas
  Edit4.Text:=dbSeries.FieldByName('SF3').AsString;//---- N.Albaranes
  Edit5.Text:=dbSeries.FieldByName('SF4').AsString;//---- N.Tickets
  Edit6.Text:=dbSeries.FieldByName('SF6').AsString;//---- N.Presupuestos
  Edit7.Text:=dbSeries.FieldByName('SF7').AsString;//---- N.Pedidos
  Edit8.Text:=dbSeries.FieldByName('SF8').AsString;//---- N.Proformas
end;

//================ PINTAR DATOS EN EL PANEL =============
procedure TFSeries.Relleno();
begin
  dbSeries.FieldByName('SF0').AsString:=Edit1.Text;//---- Codigo
  dbSeries.FieldByName('SF1').AsString:=Edit2.Text;//---- Nombre
  dbSeries.FieldByName('SF2').AsString:=Edit3.Text;//---- N.Facturas
  dbSeries.FieldByName('SF3').AsString:=Edit4.Text;//---- N.Albaranes
  dbSeries.FieldByName('SF4').AsString:=Edit5.Text;//---- N.Tickets
  dbSeries.FieldByName('SF5').AsString:='N';//----------- Especial o Normal
  dbSeries.FieldByName('SF6').AsString:=Edit6.Text;//---- N.Presupuestos
  dbSeries.FieldByName('SF7').AsString:=Edit7.Text;//---- N.Pedidos
  dbSeries.FieldByName('SF8').AsString:=Edit8.Text;//---- N.Proformas
end;

//================ LIMPIAR DATOS DEL PANEL =============
procedure TFSeries.LimpiaDatos();
begin
  Edit2.Text:='';
  Edit3.Text:='0'; Edit4.Text:='0';
  Edit5.Text:='0'; Edit6.Text:='0'; Edit7.Text:='0'; Edit8.Text:='0';
end;


initialization
  {$I series.lrs}

end.

