{
  Gestion LinEx FacturLinEx-2

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

unit facturaped;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  Buttons, ZConnection, StdCtrls, ZDataset, ExtDlgs, EditBtn, DBGrids, ExtCtrls,
  db, Grids, LCLType, LCLIntf, ComCtrls, LR_Class, LR_DBSet, dateutils, StrUtils, Types;

type

  { TFFacturaped }

  TFFacturaped = class(TForm)
    Bevel2: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn20: TBitBtn;
    BitBtn23: TBitBtn;
    BitBtn3: TBitBtn;
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    CalendarDialog1: TCalendarDialog;
    ComboBox1: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    DateEdit1: TDateEdit;
    dbMuestrad: TZQuery;
    dbFactud: TZQuery;
    dbFactuc: TZQuery;
    dbHisopdd: TZQuery;
    dbBusca: TZQuery;
    dbTrabajo: TZQuery;
    dbMuestraf: TZQuery;
    dbAlbadd: TZQuery;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    dbHisopcc: TZQuery;
    dbSumas: TZQuery;
    dbAlbacc: TZQuery;
    dbTiendas: TZQuery;
    dbSeries: TZQuery;
    dbRutas: TZQuery;
    Edit1: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit3: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label3: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label4: TLabel;
    dbProveedores: TZQuery;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel8: TPanel;
    ProgressBar1: TProgressBar;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn20Click(Sender: TObject);
    procedure BitBtn23Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ActuFactuc();
    procedure ActuFactud();
    procedure ActuFactuVen();
    procedure VerVencimientos();
    function VerUltimaLinea: Integer;

  private
    FPanelSuperior: TPanel;
    FPanelCabecera: TPanel;
    FPanelFiltros: TPanel;
    FLabelTitulo: TLabel;
    FLabelSubtitulo: TLabel;
    FOrdenGrid1Campo: String;
    FOrdenGrid2Campo: String;
    FOrdenGrid1Asc: Boolean;
    FOrdenGrid2Asc: Boolean;
    FArrastrandoPanel: Boolean;
    FPanelMovido: Boolean;
    FInicioArrastre: TPoint;
    FInicioPanel: TPoint;
    procedure ConfigurarAspecto;
    procedure AjustarDiseno;
    procedure FormularioShow(Sender: TObject);
    procedure FormularioResize(Sender: TObject);
    procedure FormularioKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure OrdenarConsulta(AQuery: TZQuery; const ACampo: String;
      AAscendente: Boolean);
    procedure ActualizarFlechas(AGrid: TDBGrid; const ACampo: String;
      AAscendente: Boolean);
    procedure CabeceraPanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CabeceraPanelMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure CabeceraPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CentrarPanelFactura;
    procedure AplicarSeleccionLegible;
  public
    { public declarations }
  end; 

  procedure ShowFormFacturaPedi();

var
  FFacturaped: TFFacturaped;
  SFACTURA,NFACTURA: String;
  BASE1,BASE2,BASE3,IMPOIVA1,IMPOIVA2,IMPOIVA3,TOTAL1,TOTAL2,TOTAL3: Double;
  IRIVA1,IRIVA2,IRIVA3,RECARGO: Double;
  PIVA1,PIVA2,PIVA3,PRIVA1,PRIVA2,PRIVA3:Double;
  Fecha, Hora: TDateTime;
  NLinea: Integer;
  FECHAPAGO1,FECHAPAGO2,FECHAPAGO3,FECHAPAGO4: String;
  IMPOPAGO1,IMPOPAGO2,IMPOPAGO3,IMPOPAGO4: String;

implementation

uses
  Global, Funciones, Busquedas
  {$IFDEF LCLGTK2}, gtk2, gdk2{$ENDIF};

{ TFFacturaped }


const
  COLOR_FONDO_FORM = $00F7F4F1;
  COLOR_AZUL_OSCURO = $00784E1F;
  COLOR_AZUL_MEDIO = $00B9824A;
  COLOR_AZUL_CLARO = $00F3E7D8;
  COLOR_TEXTO = $00413A35;
  COLOR_VERDE_CLARO = $00E8F4E8;
  COLOR_AMARILLO_CLARO = $00EAF7FF;
  COLOR_BLANCO = $00FFFFFF;

function QuitarFlechaOrden(const ATexto: String): String;
begin
  Result := StringReplace(ATexto, ' ▲', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' ▼', '', [rfReplaceAll]);
end;

procedure TFFacturaped.ConfigurarAspecto;
var
  I: Integer;
begin
  Caption := 'Facturación de albaranes de pedidos';
  Color := COLOR_FONDO_FORM;
  WindowState := wsMaximized;
  Position := poScreenCenter;
  KeyPreview := True;
  Font.Name := 'Sans';
  Font.Height := -14;

  FPanelSuperior := TPanel.Create(Self);
  FPanelSuperior.Parent := Self;
  FPanelSuperior.Name := 'PanelSuperiorModerno';
  FPanelSuperior.Caption := '';
  FPanelSuperior.Align := alTop;
  FPanelSuperior.Height := 310;
  FPanelSuperior.BevelOuter := bvNone;
  FPanelSuperior.Color := COLOR_FONDO_FORM;

  FPanelCabecera := TPanel.Create(Self);
  FPanelCabecera.Parent := FPanelSuperior;
  FPanelCabecera.Name := 'PanelCabeceraModerna';
  FPanelCabecera.Caption := '';
  FPanelCabecera.Align := alTop;
  FPanelCabecera.Height := 72;
  FPanelCabecera.BevelOuter := bvNone;
  FPanelCabecera.Color := COLOR_AZUL_OSCURO;

  FLabelTitulo := TLabel.Create(Self);
  FLabelTitulo.Parent := FPanelCabecera;
  FLabelTitulo.Left := 24;
  FLabelTitulo.Top := 10;
  FLabelTitulo.Caption := 'FACTURACIÓN DE ALBARANES DE PEDIDOS';
  FLabelTitulo.Font.Color := clWhite;
  FLabelTitulo.Font.Height := -22;
  FLabelTitulo.Font.Style := [fsBold];
  FLabelTitulo.Transparent := True;

  FLabelSubtitulo := TLabel.Create(Self);
  FLabelSubtitulo.Parent := FPanelCabecera;
  FLabelSubtitulo.Left := 25;
  FLabelSubtitulo.Top := 42;
  FLabelSubtitulo.Caption :=
    'Seleccione los albaranes, revise los totales y genere la factura del proveedor.';
  FLabelSubtitulo.Font.Color := clWhite;
  FLabelSubtitulo.Font.Height := -13;
  FLabelSubtitulo.Transparent := True;

  FPanelFiltros := TPanel.Create(Self);
  FPanelFiltros.Parent := FPanelSuperior;
  FPanelFiltros.Name := 'PanelFiltrosModerno';
  FPanelFiltros.Caption := '';
  FPanelFiltros.Align := alClient;
  FPanelFiltros.BevelOuter := bvNone;
  FPanelFiltros.Color := COLOR_AZUL_CLARO;

  Label1.Parent := FPanelFiltros;
  Label3.Parent := FPanelFiltros;
  Label4.Parent := FPanelFiltros;
  Label5.Parent := FPanelFiltros;
  Label6.Parent := FPanelFiltros;
  Label14.Parent := FPanelFiltros;
  Edit1.Parent := FPanelFiltros;
  Edit3.Parent := FPanelFiltros;
  Edit7.Parent := FPanelFiltros;
  Edit8.Parent := FPanelFiltros;
  ComboBox1.Parent := FPanelFiltros;
  ComboBox4.Parent := FPanelFiltros;
  ComboBox5.Parent := FPanelFiltros;
  Button1.Parent := FPanelFiltros;
  Button3.Parent := FPanelFiltros;
  Button4.Parent := FPanelFiltros;
  BitBtn1.Parent := FPanelFiltros;
  BitBtn2.Parent := FPanelFiltros;
  BitBtn3.Parent := FPanelFiltros;
  Panel1.Parent := FPanelFiltros;

  Label4.Caption := 'Tienda a facturar';
  Label1.Caption := 'Proveedor';
  Label14.Caption := 'Tipo doc. proveedor';
  Label5.Caption := 'Serie de pedidos';
  Label3.Caption := 'Desde fecha';
  Label6.Caption := 'Hasta fecha';

  for I := 0 to FPanelFiltros.ControlCount - 1 do
    if FPanelFiltros.Controls[I] is TLabel then
    begin
      TLabel(FPanelFiltros.Controls[I]).ParentColor := True;
      TLabel(FPanelFiltros.Controls[I]).Font.Color := COLOR_TEXTO;
      TLabel(FPanelFiltros.Controls[I]).Font.Style := [fsBold];
      TLabel(FPanelFiltros.Controls[I]).Transparent := True;
    end;

  Panel1.Caption := '';
  Panel1.Color := COLOR_AMARILLO_CLARO;
  Panel1.BevelOuter := bvNone;
  Panel1.Visible := True;
  Label7.Caption := 'ALBARANES MARCADOS / SIN MARCAR';
  Label7.ParentColor := True;
  Label7.Transparent := True;
  Label7.Font.Color := COLOR_AZUL_OSCURO;
  Label7.Font.Style := [fsBold];
  Label7.Alignment := taCenter;
  RadioButton1.ParentColor := True;
  RadioButton2.ParentColor := True;
  RadioButton3.ParentColor := True;
  RadioButton1.Font.Color := COLOR_TEXTO;
  RadioButton2.Font.Color := COLOR_TEXTO;
  RadioButton3.Font.Color := COLOR_TEXTO;

  Button1.Caption := '...';
  Button1.Hint := 'Buscar proveedor por nombre';
  Button1.ShowHint := True;
  Button3.Caption := '...';
  Button3.Hint := 'Seleccionar fecha inicial';
  Button3.ShowHint := True;
  Button4.Caption := '...';
  Button4.Hint := 'Seleccionar fecha final';
  Button4.ShowHint := True;
  Button1.Color := COLOR_AZUL_MEDIO;
  Button3.Color := COLOR_AZUL_MEDIO;
  Button4.Color := COLOR_AZUL_MEDIO;
  Button1.Font.Color := clWhite;
  Button3.Font.Color := clWhite;
  Button4.Font.Color := clWhite;
  Button1.Font.Style := [fsBold];
  Button3.Font.Style := [fsBold];
  Button4.Font.Style := [fsBold];

  BitBtn2.Caption := 'Consultar albaranes';
  BitBtn3.Caption := 'Facturar albaranes';
  BitBtn1.Caption := 'Cerrar';
  BitBtn2.Color := COLOR_AZUL_MEDIO;
  BitBtn3.Color := RGBToColor(74, 145, 92);
  BitBtn1.Color := RGBToColor(220, 230, 238);
  BitBtn2.Font.Color := clWhite;
  BitBtn3.Font.Color := clWhite;
  BitBtn1.Font.Color := COLOR_TEXTO;
  BitBtn2.Font.Style := [fsBold];
  BitBtn3.Font.Style := [fsBold];
  BitBtn1.Font.Style := [fsBold];
  BitBtn1.Visible := True;
  BitBtn2.Visible := True;
  BitBtn3.Visible := True;

  Panel2.Caption := '';
  Panel2.Align := alBottom;
  Panel2.Height := 96;
  Panel2.BevelOuter := bvNone;
  Panel2.Color := RGBToColor(232, 240, 247);

  Label12.Caption := 'N.º albaranes';
  Label13.Caption := 'N.º facturas';
  Label8.Caption := 'N.º líneas';
  Label9.Caption := 'N.º artículos';
  Label10.Caption := 'Importe';
  Label11.Caption := 'Importe + impuestos';

  for I := 0 to Panel2.ControlCount - 1 do
  begin
    if Panel2.Controls[I] is TLabel then
    begin
      TLabel(Panel2.Controls[I]).ParentColor := True;
      TLabel(Panel2.Controls[I]).Transparent := True;
      TLabel(Panel2.Controls[I]).Font.Color := COLOR_TEXTO;
      TLabel(Panel2.Controls[I]).Font.Style := [fsBold];
      TLabel(Panel2.Controls[I]).Alignment := taCenter;
    end
    else if Panel2.Controls[I] is TStaticText then
    begin
      TStaticText(Panel2.Controls[I]).Color := clWhite;
      TStaticText(Panel2.Controls[I]).Font.Color := COLOR_AZUL_OSCURO;
      TStaticText(Panel2.Controls[I]).Font.Height := -17;
      TStaticText(Panel2.Controls[I]).Font.Style := [fsBold];
      TStaticText(Panel2.Controls[I]).Alignment := taCenter;
    end;
  end;

  PageControl1.Align := alClient;
  PageControl1.TabPosition := tpTop;
  PageControl1.Font.Color := COLOR_TEXTO;
  PageControl1.Font.Style := [fsBold];
  TabSheet1.Caption := '  Albaranes seleccionados  ';
  TabSheet2.Caption := '  Facturas que se generarán  ';

  DBGrid1.DefaultRowHeight := 28;
  DBGrid2.DefaultRowHeight := 28;
  DBGrid1.Color := clWhite;
  DBGrid2.Color := clWhite;
  DBGrid1.Font.Color := COLOR_TEXTO;
  DBGrid2.Font.Color := COLOR_TEXTO;
  DBGrid1.TitleFont.Color := COLOR_AZUL_OSCURO;
  DBGrid2.TitleFont.Color := COLOR_AZUL_OSCURO;
  DBGrid1.TitleFont.Style := [fsBold];
  DBGrid2.TitleFont.Style := [fsBold];
  DBGrid1.OnTitleClick := @DBGrid1TitleClick;
  DBGrid2.OnTitleClick := @DBGrid2TitleClick;
  DBGrid1.OnDrawColumnCell := @DBGridDrawColumnCell;
  DBGrid2.OnDrawColumnCell := @DBGridDrawColumnCell;

  Panel8.Caption := '';
  Panel8.Width := 720;
  Panel8.Height := 400;
  Panel8.BevelOuter := bvNone;
  Panel8.Color := RGBToColor(245, 248, 252);
  Bevel2.Visible := False;
  Label15.Visible := False;
  Label36.Caption := 'DATOS DE LA FACTURA DEL PROVEEDOR';
  Label36.Align := alNone;
  Label36.Left := 0;
  Label36.Top := 0;
  Label36.Width := Panel8.ClientWidth;
  Label36.Height := 54;
  Label36.Alignment := taCenter;
  Label36.Layout := tlCenter;
  Label36.Color := COLOR_AZUL_OSCURO;
  Label36.ParentColor := False;
  Label36.Transparent := False;
  Label36.Font.Color := clWhite;
  Label36.Font.Height := -18;
  Label36.Font.Style := [fsBold];
  Label36.Cursor := crSizeAll;
  Label36.OnMouseDown := @CabeceraPanelMouseDown;
  Label36.OnMouseMove := @CabeceraPanelMouseMove;
  Label36.OnMouseUp := @CabeceraPanelMouseUp;
  Panel8.OnMouseMove := @CabeceraPanelMouseMove;
  Panel8.OnMouseUp := @CabeceraPanelMouseUp;

  Label37.Caption := 'Serie factura';
  Label37.Left := 24;
  Label37.Top := 78;
  Label37.Width := 112;
  Edit22.Left := 150;
  Edit22.Top := 76;
  Edit22.Width := 120;
  Edit22.Height := 30;

  Label33.Caption := 'N.º factura';
  Label33.Left := 302;
  Label33.Top := 78;
  Label33.Width := 100;
  Edit21.Left := 410;
  Edit21.Top := 76;
  Edit21.Width := 180;
  Edit21.Height := 30;

  Label34.Caption := 'Fecha factura';
  Label34.Left := 24;
  Label34.Top := 126;
  Label34.Width := 112;
  DateEdit1.Left := 150;
  DateEdit1.Top := 124;
  DateEdit1.Width := 170;
  DateEdit1.Height := 30;

  Label35.Caption := 'Observaciones';
  Label35.Left := 24;
  Label35.Top := 176;
  Label35.Width := 112;
  Memo1.Left := 150;
  Memo1.Top := 170;
  Memo1.Width := 540;
  Memo1.Height := 92;

  Label16.Left := 24;
  Label16.Top := 278;
  Label16.Width := 300;
  Label16.Caption := 'Procesando documentos...';
  Label16.ParentColor := True;
  Label16.Transparent := True;
  Label16.Font.Color := COLOR_TEXTO;
  ProgressBar1.Left := 24;
  ProgressBar1.Top := 304;
  ProgressBar1.Width := 666;
  ProgressBar1.Height := 22;

  BitBtn23.Left := 24;
  BitBtn23.Top := 344;
  BitBtn23.Width := 190;
  BitBtn23.Height := 44;
  BitBtn23.Caption := 'Aceptar y facturar';
  BitBtn23.Color := RGBToColor(74, 145, 92);
  BitBtn23.Font.Color := clWhite;
  BitBtn23.Font.Style := [fsBold];

  BitBtn20.Left := 520;
  BitBtn20.Top := 344;
  BitBtn20.Width := 170;
  BitBtn20.Height := 44;
  BitBtn20.Caption := 'Cancelar';
  BitBtn20.Color := RGBToColor(220, 230, 238);
  BitBtn20.Font.Color := COLOR_TEXTO;
  BitBtn20.Font.Style := [fsBold];

  Label33.ParentColor := True;
  Label34.ParentColor := True;
  Label35.ParentColor := True;
  Label37.ParentColor := True;
  Label33.Transparent := True;
  Label34.Transparent := True;
  Label35.Transparent := True;
  Label37.Transparent := True;
  Label33.Font.Color := COLOR_TEXTO;
  Label34.Font.Color := COLOR_TEXTO;
  Label35.Font.Color := COLOR_TEXTO;
  Label37.Font.Color := COLOR_TEXTO;
  Label33.Font.Style := [fsBold];
  Label34.Font.Style := [fsBold];
  Label35.Font.Style := [fsBold];
  Label37.Font.Style := [fsBold];

  OnShow := @FormularioShow;
  OnResize := @FormularioResize;
  OnKeyDown := @FormularioKeyDown;

  FOrdenGrid1Campo := '';
  FOrdenGrid2Campo := '';
  FOrdenGrid1Asc := True;
  FOrdenGrid2Asc := True;
  FArrastrandoPanel := False;
  FPanelMovido := False;

  FPanelSuperior.BringToFront;
  Panel2.BringToFront;
  AjustarDiseno;
end;

procedure TFFacturaped.AjustarDiseno;
var
  W, MainRight, Grupo, X, I: Integer;
  Etiquetas: array[0..5] of TLabel;
  Valores: array[0..5] of TStaticText;
begin
  if (FPanelSuperior = nil) or (FPanelFiltros = nil) then Exit;
  W := FPanelFiltros.ClientWidth;

  if W >= 1200 then
  begin
    FPanelSuperior.Height := 310;
    Panel1.Left := W - 390;
    Panel1.Top := 12;
    Panel1.Width := 366;
    Panel1.Height := 170;
    MainRight := Panel1.Left - 20;

    Label4.SetBounds(24, 16, 118, 30);
    ComboBox1.SetBounds(150, 16, 300, 30);
    Label14.SetBounds(470, 16, 126, 30);
    ComboBox5.SetBounds(605, 16, MainRight - 605, 30);

    Label1.SetBounds(24, 60, 118, 30);
    Edit1.SetBounds(150, 60, 90, 30);
    Button1.SetBounds(248, 60, 42, 30);
    Edit3.SetBounds(298, 60, MainRight - 298, 30);

    Label5.SetBounds(24, 104, 118, 30);
    ComboBox4.SetBounds(150, 104, 300, 30);
    Label3.SetBounds(470, 104, 88, 30);
    Edit7.SetBounds(565, 104, 135, 30);
    Button3.SetBounds(708, 104, 42, 30);

    Label6.SetBounds(470, 148, 88, 30);
    Edit8.SetBounds(565, 148, 135, 30);
    Button4.SetBounds(708, 148, 42, 30);

    BitBtn2.SetBounds(24, 184, 200, 44);
    BitBtn3.SetBounds(238, 184, 220, 44);
    BitBtn1.SetBounds(472, 184, 150, 44);
  end
  else
  begin
    FPanelSuperior.Height := 430;
    Panel1.Left := W - 350;
    Panel1.Top := 12;
    Panel1.Width := 326;
    Panel1.Height := 170;
    MainRight := Panel1.Left - 20;

    Label4.SetBounds(24, 16, 118, 30);
    ComboBox1.SetBounds(150, 16, MainRight - 150, 30);
    Label14.SetBounds(24, 58, 118, 30);
    ComboBox5.SetBounds(150, 58, MainRight - 150, 30);

    Label1.SetBounds(24, 100, 118, 30);
    Edit1.SetBounds(150, 100, 90, 30);
    Button1.SetBounds(248, 100, 42, 30);
    Edit3.SetBounds(298, 100, MainRight - 298, 30);

    Label5.SetBounds(24, 142, 118, 30);
    ComboBox4.SetBounds(150, 142, MainRight - 150, 30);

    Label3.SetBounds(24, 190, 118, 30);
    Edit7.SetBounds(150, 190, 145, 30);
    Button3.SetBounds(303, 190, 42, 30);
    Label6.SetBounds(356, 190, 84, 30);
    Edit8.SetBounds(442, 190, 145, 30);
    Button4.SetBounds(595, 190, 42, 30);

    BitBtn2.SetBounds(24, 244, 200, 44);
    BitBtn3.SetBounds(238, 244, 220, 44);
    BitBtn1.SetBounds(472, 244, 150, 44);
  end;

  Label7.SetBounds(12, 10, Panel1.ClientWidth - 24, 28);
  RadioButton1.SetBounds(20, 48, Panel1.ClientWidth - 40, 26);
  RadioButton2.SetBounds(20, 87, Panel1.ClientWidth - 40, 26);
  RadioButton3.SetBounds(20, 126, Panel1.ClientWidth - 40, 26);

  Etiquetas[0] := Label12;
  Etiquetas[1] := Label13;
  Etiquetas[2] := Label8;
  Etiquetas[3] := Label9;
  Etiquetas[4] := Label10;
  Etiquetas[5] := Label11;
  Valores[0] := StaticText4;
  Valores[1] := StaticText5;
  Valores[2] := StaticText2;
  Valores[3] := StaticText3;
  Valores[4] := StaticText7;
  Valores[5] := StaticText8;

  Grupo := (Panel2.ClientWidth - 36) div 6;
  for I := 0 to 5 do
  begin
    X := 18 + (I * Grupo);
    Etiquetas[I].SetBounds(X, 10, Grupo - 12, 22);
    Valores[I].SetBounds(X, 38, Grupo - 12, 36);
  end;

  if Panel8.Visible and (not FPanelMovido) then
    CentrarPanelFactura;
end;

procedure TFFacturaped.FormularioShow(Sender: TObject);
begin
  AjustarDiseno;
  AplicarSeleccionLegible;
end;

procedure TFFacturaped.FormularioResize(Sender: TObject);
begin
  AjustarDiseno;
end;

procedure TFFacturaped.FormularioKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key <> VK_ESCAPE then Exit;
  Key := 0;
  if Panel8.Visible then
  begin
    if Label16.Enabled then Exit;
    BitBtn20Click(BitBtn20);
  end
  else
    Close;
end;

procedure TFFacturaped.DBGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Grid: TDBGrid;
begin
  Grid := TDBGrid(Sender);
  if gdSelected in State then
  begin
    Grid.Canvas.Brush.Color := COLOR_AZUL_OSCURO;
    Grid.Canvas.Font.Color := clWhite;
  end
  else
  begin
    Grid.Canvas.Brush.Color := clWhite;
    Grid.Canvas.Font.Color := COLOR_TEXTO;
  end;
  Grid.Canvas.FillRect(Rect);
  Grid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TFFacturaped.OrdenarConsulta(AQuery: TZQuery;
  const ACampo: String; AAscendente: Boolean);
var
  SQLTexto, SQLMayusculas, Direccion: String;
  P: SizeInt;
begin
  if (AQuery = nil) or (not AQuery.Active) or (ACampo = '') then Exit;

  SQLTexto := Trim(AQuery.SQL.Text);
  if (SQLTexto <> '') and (SQLTexto[Length(SQLTexto)] = ';') then
    Delete(SQLTexto, Length(SQLTexto), 1);
  SQLMayusculas := UpperCase(SQLTexto);
  P := RPos(' ORDER BY ', SQLMayusculas);
  if P > 0 then
    Delete(SQLTexto, P, Length(SQLTexto) - P + 1);

  if AAscendente then
    Direccion := ' ASC'
  else
    Direccion := ' DESC';

  AQuery.DisableControls;
  try
    AQuery.Close;
    AQuery.SQL.Text := TrimRight(SQLTexto) + ' ORDER BY ' + ACampo + Direccion;
    AQuery.Open;
  finally
    AQuery.EnableControls;
  end;
end;

procedure TFFacturaped.ActualizarFlechas(AGrid: TDBGrid;
  const ACampo: String; AAscendente: Boolean);
var
  I: Integer;
  TextoBase: String;
begin
  for I := 0 to AGrid.Columns.Count - 1 do
  begin
    TextoBase := QuitarFlechaOrden(AGrid.Columns[I].Title.Caption);
    if SameText(AGrid.Columns[I].FieldName, ACampo) then
    begin
      if AAscendente then
        AGrid.Columns[I].Title.Caption := TextoBase + ' ▲'
      else
        AGrid.Columns[I].Title.Caption := TextoBase + ' ▼';
    end
    else
      AGrid.Columns[I].Title.Caption := TextoBase;
  end;
end;

procedure TFFacturaped.DBGrid1TitleClick(Column: TColumn);
begin
  if (Column = nil) or (Column.FieldName = '') then Exit;
  if SameText(FOrdenGrid1Campo, Column.FieldName) then
    FOrdenGrid1Asc := not FOrdenGrid1Asc
  else
  begin
    FOrdenGrid1Campo := Column.FieldName;
    FOrdenGrid1Asc := True;
  end;
  OrdenarConsulta(dbMuestraf, FOrdenGrid1Campo, FOrdenGrid1Asc);
  ActualizarFlechas(DBGrid1, FOrdenGrid1Campo, FOrdenGrid1Asc);
end;

procedure TFFacturaped.DBGrid2TitleClick(Column: TColumn);
begin
  if (Column = nil) or (Column.FieldName = '') then Exit;
  if SameText(FOrdenGrid2Campo, Column.FieldName) then
    FOrdenGrid2Asc := not FOrdenGrid2Asc
  else
  begin
    FOrdenGrid2Campo := Column.FieldName;
    FOrdenGrid2Asc := True;
  end;
  OrdenarConsulta(dbAlbacc, FOrdenGrid2Campo, FOrdenGrid2Asc);
  ActualizarFlechas(DBGrid2, FOrdenGrid2Campo, FOrdenGrid2Asc);
end;

procedure TFFacturaped.CabeceraPanelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then Exit;
  FArrastrandoPanel := True;
  FPanelMovido := True;
  GetCursorPos(FInicioArrastre);
  FInicioPanel := Point(Panel8.Left, Panel8.Top);
  SetCapture(Panel8.Handle);
end;

procedure TFFacturaped.CabeceraPanelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
  NovoLeft, NovoTop: Integer;
begin
  if not FArrastrandoPanel then Exit;
  GetCursorPos(P);
  NovoLeft := FInicioPanel.X + (P.X - FInicioArrastre.X);
  NovoTop := FInicioPanel.Y + (P.Y - FInicioArrastre.Y);
  if ClientWidth <= Panel8.Width then
    NovoLeft := 0
  else
  begin
    if NovoLeft < 0 then NovoLeft := 0;
    if NovoLeft > ClientWidth - Panel8.Width then
      NovoLeft := ClientWidth - Panel8.Width;
  end;
  if ClientHeight <= Panel8.Height then
    NovoTop := 0
  else
  begin
    if NovoTop < 0 then NovoTop := 0;
    if NovoTop > ClientHeight - Panel8.Height then
      NovoTop := ClientHeight - Panel8.Height;
  end;
  Panel8.Left := NovoLeft;
  Panel8.Top := NovoTop;
end;

procedure TFFacturaped.CabeceraPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then Exit;
  FArrastrandoPanel := False;
  ReleaseCapture;
end;

procedure TFFacturaped.CentrarPanelFactura;
begin
  Panel8.Left := (ClientWidth - Panel8.Width) div 2;
  Panel8.Top := (ClientHeight - Panel8.Height) div 2;
  if Panel8.Left < 0 then Panel8.Left := 0;
  if Panel8.Top < 0 then Panel8.Top := 0;
  Panel8.BringToFront;
end;

procedure TFFacturaped.AplicarSeleccionLegible;

  procedure AplicarRecursivo(AControl: TWinControl);
  var
    I: Integer;
    WC: TWinControl;
    {$IFDEF LCLGTK2}
    CorFondo, CorTexto: TGdkColor;
    {$ENDIF}
  begin
    {$IFDEF LCLGTK2}
    if AControl.HandleAllocated and
       ((AControl is TCustomEdit) or
        (AControl is TCustomComboBox) or
        (AControl is TCustomMemo)) then
    begin
      gdk_color_parse(PChar('#1F4E78'), @CorFondo);
      gdk_color_parse(PChar('#FFFFFF'), @CorTexto);
      gtk_widget_modify_base(PGtkWidget(AControl.Handle),
        GTK_STATE_SELECTED, @CorFondo);
      gtk_widget_modify_text(PGtkWidget(AControl.Handle),
        GTK_STATE_SELECTED, @CorTexto);
    end;
    {$ENDIF}
    for I := 0 to AControl.ControlCount - 1 do
      if AControl.Controls[I] is TWinControl then
      begin
        WC := TWinControl(AControl.Controls[I]);
        AplicarRecursivo(WC);
      end;
  end;

begin
  AplicarRecursivo(Self);
end;


//====================== CREAR FORMULARIO =======================
procedure ShowFormFacturaPedi();
begin
  with TFFacturaped.Create(Application) do
    begin
       ShowModal;
    end;
end;
procedure TFFacturaped.FormCreate(Sender: TObject);
begin
  ConfigurarAspecto;

  { Protección adicional: esta consulta alimenta el resumen de facturas y
    debe usar la misma conexión común que el resto de consultas del formulario. }
  dbMuestraf.Connection := DataModule1.dbConexion;
  //--------- Conectar con la bbdd e inicializar datos globales
  //Conectate(dbConnect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------------
  Edit7.Text:='01/'+FormatDateTime('MM/YYYY',Date);
  Edit8.Text:=FormatDateTime('DD/MM/YYYY',Date);
  //---------------- Rellenar ComboBox fijos -----------
  RellenaComboBoxCambiableNombre('SELECT T1 FROM tiendas', dbTiendas, ComboBox1);
  RellenaComboBoxCambiableNombre('SELECT SF1 FROM seriesfactu', dbSeries, ComboBox4);
  ComboBox4.Items.Add('TODAS LAS SERIES');
  //------------------- Tienda activa ---------------
  dbTiendas.Active:=False;
  dbTiendas.SQL.Text:='SELECT * FROM tiendas';
  dbTiendas.Active:=True;
  if dbTiendas.RecordCount=0 then begin ShowMessage('NO HAY TIENDAS'); Close(); end;
  if not dbTiendas.Locate('T0',Tienda,[]) then
     begin ShowMessage('LA TIENDA ACTIVA NO EXISTE?'); Close(); end;
  ComboBox1.ItemIndex:=ComboBox1.Items.IndexOf(dbTiendas.FieldByName('T1').AsString);
  //------------------- Serie activa ---------------
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu';
  dbSeries.Active:=True;
  if dbSeries.RecordCount=0 then begin ShowMessage('NO HAY SERIES DE PEDIDOS'); Close(); end;
  if not dbSeries.Locate('SF0',dbTiendas.FieldByName('T11').AsString,[]) then
     begin ShowMessage('NO HAY SERIE DE PEDIDOS ACTIVA?'); Close(); end;
  ComboBox4.ItemIndex:=ComboBox4.Items.IndexOf(dbSeries.FieldByName('SF1').AsString);
end;

//====================== CERRAR FORMULARIO =======================
procedure TFFacturaped.BitBtn1Click(Sender: TObject);
begin
  Close();
end;
procedure TFFacturaped.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;

//=================================================================
//====================== APLICAR FILTROS ==========================
//=================================================================
procedure TFFacturaped.BitBtn2Click(Sender: TObject);
var
  TxtQ: String;
begin
  if (Edit1.Text='') then exit;
  if ComboBox4.Text='' then exit;
  if ComboBox4.Text<>'TODAS LAS SERIES' then
    begin
     if not dbSeries.Locate('SF1',ComboBox4.Text,[]) then
       begin showmessage('La serie activa no existe.'); exit; end;
    end;
  //------------- Albaranes
  TxtQ:='SELECT *,MID(HPC43,1,250) as ANOTAS FROM hipedicc'+Tienda+
        ' WHERE HPC2='+Edit1.Text+
        ' AND HPC1>="'+FormatDateTime('yyyy/mm/dd',StrToDate(Edit7.Text))+'"'+
        ' AND HPC1<="'+FormatDateTime('yyyy/mm/dd',StrToDate(Edit8.Text))+'"';
  if ComboBox4.Text<>'TODAS LAS SERIES' then TxtQ:=TxtQ+' AND HPC3="'+dbSeries.FieldByName('SF0').AsString+'"';
  if ComboBox5.Text<>'' then TxtQ:=TxtQ+' AND HPC28="'+Copy(ComboBox5.Text,1,1)+'"';//-------------- Tipo Doc proveedor
  if RadioButton2.Checked then TxtQ:=TxtQ+' AND HPC46="S"';//---- Los marcados
  if RadioButton3.Checked then TxtQ:=TxtQ+' AND HPC46="N"';//---- Sin Marcar
  TxtQ:=TxtQ+' ORDER BY HPC2,HPC1';
  dbAlbacc.Active:=False; dbAlbacc.Sql.Text:=TxtQ; dbAlbacc.Active:=True;
  dbAlbacc.First;
  //------------- Facturas a realizar
  TxtQ:='SELECT HPC2,COUNT(HPC4),SUM(HPC5),SUM(HPC6),SUM(HPC7),SUM(HPC8),SUM(HPC9),HPC13 FROM hipedicc'+Tienda+
        ' WHERE HPC2='+Edit1.Text+
        ' AND HPC1>="'+FormatDateTime('yyyy/mm/dd',StrToDate(Edit7.Text))+'"'+
        ' AND HPC1<="'+FormatDateTime('yyyy/mm/dd',StrToDate(Edit8.Text))+'"';
  if ComboBox4.Text<>'TODAS LAS SERIES' then TxtQ:=TxtQ+' AND HPC3="'+dbSeries.FieldByName('SF0').AsString+'"';
  if ComboBox5.Text<>'' then TxtQ:=TxtQ+' AND HPC28="'+Copy(ComboBox5.Text,1,1)+'"';//-------------- Tipo Doc proveedor
  if RadioButton2.Checked then TxtQ:=TxtQ+' AND HPC46="S"';//---- Los marcados
  if RadioButton3.Checked then TxtQ:=TxtQ+' AND HPC46="N"';//---- Sin Marcar
  TxtQ:=TxtQ+' GROUP BY HPC2 ORDER BY HPC2';
  dbMuestraf.Active:=False; dbMuestraf.Sql.Text:=TxtQ; dbMuestraf.Active:=True;
  dbMuestraf.First;
  //------------------- Sumas
  TxtQ:='SELECT SUM(HPC5),SUM(HPC6),SUM(HPC7),SUM(HPC8) FROM hipedicc'+Tienda+
        ' WHERE HPC2='+Edit1.Text+
        ' AND HPC1>="'+FormatDateTime('yyyy/mm/dd',StrToDate(Edit7.Text))+'"'+
        ' AND HPC1<="'+FormatDateTime('yyyy/mm/dd',StrToDate(Edit8.Text))+'"';
  if ComboBox4.Text<>'TODAS LAS SERIES' then TxtQ:=TxtQ+' AND HPC3="'+dbSeries.FieldByName('SF0').AsString+'"';
  if ComboBox5.Text<>'' then TxtQ:=TxtQ+' AND HPC28="'+Copy(ComboBox5.Text,1,1)+'"';//-------------- Tipo Doc proveedor
  if RadioButton2.Checked then TxtQ:=TxtQ+' AND HPC46="S"';//---- Los marcados
  if RadioButton3.Checked then TxtQ:=TxtQ+' AND HPC46="N"';//---- Sin Marcar
  dbSumas.Active:=False; dbSumas.Sql.Text:=TxtQ; dbSumas.Active:=True;
  dbSumas.First;
  StaticText4.Caption:=IntToStr(dbAlbacc.RecordCount);//-------- N. Albaranes.
  StaticText5.Caption:=IntToStr(dbMuestraf.RecordCount);//-------- N. Facturas
  StaticText2.Caption:=dbSumas.Fields[0].AsString;//--------- N. Lineas.
  StaticText3.Caption:=FormatFloat('0.00',dbSumas.Fields[1].AsFloat);//--------- N. Articulos.
  StaticText7.Caption:=FormatFloat('0.00',dbSumas.Fields[2].AsFloat);//--------- Importe
  StaticText8.Caption:=FormatFloat('0.00',dbSumas.Fields[3].AsFloat);//--------- Importe + impuestos
  dbSumas.Active:=False;
  BitBtn3.Enabled:=dbAlbacc.RecordCount>0;
end;



//=================================================================
//======================= FACTURAR ALBARANES ======================
//=================================================================
procedure TFFacturaped.BitBtn3Click(Sender: TObject);
var
  TxtQ: String;
begin
  if dbAlbacc.Active=False then exit;
  if dbAlbacc.RecordCount=0 then exit;
  TxtQ:='SE FACTURARAN '+StaticText4.Caption+' ALBARANES, CONTINUAR?';
  if Application.MessageBox(PChar(TxtQ),'FacturLinEx', boxstyle) = IDNO Then Exit;
  Label33.Caption:='N. Factura';  Label34.Caption:='Fecha Factura';
  DateEdit1.Date:=Date; Edit21.Text:='';
  FPanelMovido:=False;
  Panel8.Visible:=True;
  CentrarPanelFactura;
  Application.ProcessMessages;
  AplicarSeleccionLegible;
  PageControl1.Enabled:=False; BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
end;

//======================== ACEPTAR FACTURAR =====================
procedure TFFacturaped.BitBtn23Click(Sender: TObject);
var
  TxtQ: String;
begin
  label16.Enabled:=True; ProgressBar1.Enabled:=True; ProgressBar1.Max:=dbAlbacc.RecordCount;

  SFACTURA:=Edit22.Text;
  NFACTURA:=Edit21.Text;
  if SFACTURA='' then begin showmessage('DEBE PONER UNA SERIE PARA FACTURAR'); Exit; end;
  if NFACTURA='' then begin showmessage('DEBE PONER UN NUMERO DE FACTURA PARA FACTURAR'); Exit; end;
  Hora:=Time; NLinea:=1;
  dbAlbacc.First;
  While not dbAlbacc.Eof do
   begin
      ProgressBar1.Position:= dbAlbacc.RecNo;
      Application.ProcessMessages;
      TxtQ:='SELECT * FROM hipedidd'+Tienda+' WHERE HPD0='+dbAlbacc.Fields[0].AsString+
            ' AND HPD1="'+FormatDateTime('yyyy/mm/dd',dbAlbacc.Fields[1].asDateTime)+'"'+
            ' AND HPD2='+dbAlbacc.Fields[2].AsString+' AND HPD3="'+dbAlbacc.Fields[3].AsString+'"'+
            ' AND HPD4='+dbAlbacc.Fields[4].AsString+' ORDER BY HPD5';
      dbAlbadd.Active:=False; dbAlbadd.Sql.Text:=TxtQ;
      dbAlbadd.Active := True; dbAlbadd.First;
      while not dbAlbadd.Eof do
        begin
           ActuFactud();//---------- Detalles
           dbAlbadd.Next;
        end;
      ActuFactuc(); //------------- Cabeceras
      dbAlbacc.Next;
   end;
  ProgressBar1.Position:=0;label16.Enabled:=False; ProgressBar1.Enabled:=False;
  //------------------- Marcar pedidos/albarenes/Notas como facturados
  dbAlbacc.First;
  While not dbAlbacc.Eof do
   begin
      dbAlbacc.Edit;
      dbAlbacc.FieldByName('HPC47').AsString:='S';
      dbAlbacc.Post;
      dbAlbacc.Next;
   end;
 Close();
end;

//======================== CANCELAR FACTURAR =====================
procedure TFFacturaped.BitBtn20Click(Sender: TObject);
begin
  Panel8.Visible:=False;
  FPanelMovido:=False;
  PageControl1.Enabled:=True; BitBtn2.Enabled:=True; BitBtn3.Enabled:=True;
end;


//======================= CABECERA DE FACTURAS ========================
procedure TFFacturaped.ActuFactuc();
var
  TxtQ: String;
begin
  dbFactuc.Active:=False;
  TxtQ:='SELECT * FROM hipedifacc'+Tienda+' WHERE FC0='+dbAlbacc.FieldByName('AC0').AsString+
        ' AND FC1="'+FormatDateTime('YYYY/MM/DD',DateEdit1.Date)+
        '" AND FC2="'+SFACTURA+'" AND FC3="'+NFACTURA+'"';
  dbFactuc.Sql.Text:=TxtQ; dbFactuc.Active:=True; dbFactuc.First;
  if dbFactuc.Recordcount=0 then
    begin
     dbFactuc.append;
 {
     Tienda............................................................................	INT(4)			HPC0
     Fecha.............................................................................	DATE			HPC1
     Proveedor......................................................................	INT(11)		        HPC2
     Serie Pedido.................................................................	CHAR(3)		        HPC3
     Nº Pedido......................................................................	INT(5)			HPC4
     Nº de líneas......................................................................	INT(6)	 		HPC5
     Nº Artículos......................................................................	INT(7)			HPC6


     Tienda............................................................................	INT(4)			HPC0
     Fecha.............................................................................	DATE			HPC1
     Proveedor......................................................................	INT(11)		HPC2
     Serie Factura.................................................................	CHAR(5)		HPC3
     Nº Factura......................................................................	CHAR(15)		HPC4
     Nº de líneas......................................................................	INT(6)	 		HPC5
     Nº Artículos......................................................................	INT(7)			HPC6
  }


     dbFactuc.FieldByName('HPC0').Value:=dbAlbacc.FieldByName('HPC0').Value;//----- Tienda
     dbFactuc.FieldByName('HPC1').AsString:=FormatDateTime('dd/mm/yyyy',DateEdit1.Date);//-- Fecha Factura
     dbFactuc.FieldByName('HPC2').Value:=dbAlbacc.FieldByName('HPC2').Value;//----- Proveedor

     dbFactuc.FieldByName('HPC2').Value:=SFACTURA;//------------------------------- Serie Factura.
     dbFactuc.FieldByName('HPC3').Value:=NFACTURA;//------------------------------- N. Factura.án
     dbFactuc.FieldByName('HPC4').Value:=NLinea-1;//------------------------------- Nº Lineas
     dbFactuc.FieldByName('HPC5').Value:=dbAlbacc.FieldByName('AC5').AsFloat;//---- Nº Articulos.
     dbFactuc.FieldByName('HPC6').Value:=dbAlbacc.FieldByName('AC6').AsFloat;//---- Dto. Pronto Pago
     dbFactuc.FieldByName('HPC7').Value:=dbAlbacc.FieldByName('AC7').AsString;//--- Recargo Equivalencia.
     dbFactuc.FieldByName('HPC8').Value:=dbAlbacc.FieldByName('AC8').AsFloat;//---- Importe sin IVA
     dbFactuc.FieldByName('HPC9').Value:=dbAlbacc.FieldByName('AC9').AsFloat;//---- Importe con IVA
     dbFactuc.FieldByName('HPC10').Value:='N';//----------------------------------- Marcado S/N.
     dbFactuc.FieldByName('HPC23').Value:='N';//----------------------------------- Pagado S/N.
    end
  else
    begin
     dbFactuc.edit;
     dbFactuc.FieldByName('FC4').Value:=NLinea-1; //----------------------- Nº Lineas
     dbFactuc.FieldByName('FC5').Value:=dbFactuc.FieldByName('FC5').AsFloat+dbAlbacc.FieldByName('AC5').AsFloat;//---- Nº Articulos.
     dbFactuc.FieldByName('FC8').Value:=dbFactuc.FieldByName('FC8').AsFloat + dbAlbacc.FieldByName('AC8').AsFloat;//-- Importe sin IVA
     dbFactuc.FieldByName('FC9').Value:=dbFactuc.FieldByName('FC9').AsFloat + dbAlbacc.FieldByName('AC9').AsFloat;//-- Importe con IVA
    end;
  dbFactuc.Post;
end;

//======================= DETALLES DE FACTURAS ========================
procedure TFFacturaped.ActuFactud();
var
  TxtQ: String;
  Conta: Integer;
begin
  dbFactud.Active:=False;
  TxtQ:='SELECT * FROM hipedifadd'+Tienda+' WHERE FD0='+dbAlbadd.Fields[0].AsString+
        ' AND FD1="'+FormatDateTime('YYYY/MM/DD',DateEdit1.Date)+'" AND FD2="'+SFACTURA+'"'+
        ' AND FD3="'+NFACTURA+'"';
  dbFactud.Sql.Text:=TxtQ; dbFactud.Active:=True;
  dbFactud.append;
  dbFactud.FieldByName('FD0').Value:=dbAlbadd.FieldByName('AD0').Value;//--------------- Cgo. Cliente
  dbFactud.FieldByName('FD1').AsString:=FormatDateTime('dd/mm/yyyy',DateEdit1.Date);//-- Fecha Factura
  dbFactud.FieldByName('FD2').Value:=SFACTURA; //------------------- Serie Factura
  dbFactud.FieldByName('FD3').Value:=NFACTURA; //------------------- N. Factura
  dbFactud.FieldByName('FD4').Value:=VerUltimaLinea;//-------------- Nº Linea
  for conta:=5 to 15 do
    dbFactud.Fields[Conta].Value:=dbAlbadd.Fields[Conta].Value;
  //-------- Observaciones y N. Albaran.
  dbFactud.FieldByName('FD16').Value:='Albaran.: '+
           dbAlbadd.Fields[2].AsString+'/'+dbAlbadd.Fields[3].AsString+
           ' - '+FormatDateTime('dd/mm/yyyy',dbAlbadd.Fields[1].AsDateTime)+
           ' - '+dbAlbacc.FieldByName('AC11').AsString;

  dbFactud.Fields[17].Value:=dbAlbadd.Fields[17].Value;//-------------- precio tarifa.
  dbFactud.Post;
  NLinea:=NLinea+1;
end;

//=================== SACAR EL ULT N. DE LINEA =====================
function TFFacturaped.VerUltimaLinea: Integer;
begin
  VerUltimaLinea:=1;
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT MAX(FD4) As ULTIMA FROM factud'+Tienda+' WHERE FD0='+dbAlbadd.Fields[0].AsString+
                    ' AND FD1="'+FormatDateTime('YYYY/MM/DD',DateEdit1.Date)+'" AND FD2="'+SFACTURA+'"'+
                    ' AND FD3="'+NFACTURA+'"';
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  VerUltimaLinea:=dbBusca.FieldByName('ULTIMA').AsInteger+1;
end;

//===================== Facturas Cab Vencimientos =======================
procedure TFFacturaped.ActuFactuVen();
begin
  if FECHAPAGO1='' then Exit;
  dbFactuc.Edit;
  dbFactuc.FieldByName('FC11').AsString:=FECHAPAGO1;
  dbFactuc.FieldByName('FC12').AsString:=IMPOPAGO1;
  if FECHAPAGO2<>'' then
   begin
    dbFactuc.FieldByName('FC13').AsString:=FECHAPAGO2;
    dbFactuc.FieldByName('FC14').AsString:=IMPOPAGO2;
   end;
  if FECHAPAGO3<>'' then
   begin
    dbFactuc.FieldByName('FC15').AsString:=FECHAPAGO3;
    dbFactuc.FieldByName('FC16').AsString:=IMPOPAGO3;
   end;
  if FECHAPAGO4<>'' then
   begin
    dbFactuc.FieldByName('FC17').AsString:=FECHAPAGO3;
    dbFactuc.FieldByName('FC18').AsString:=IMPOPAGO3;
   end;
  dbFactuc.Post;
end;


//====================== PRIMER PROVEEDOR =======================
procedure TFFacturaped.Edit1Enter(Sender: TObject);
begin
  Edit3.Text:='';
end;
procedure TFFacturaped.Edit1Exit(Sender: TObject);
begin
  if Edit1.Text='' then Edit1.Text:='1';
  dbProveedores.Active:=False;
  dbProveedores.SQL.Text:='SELECT P0,P1 FROM proveedores where P0='+Edit1.Text;
  dbProveedores.Active:=True;
  if dbProveedores.RecordCount=0 then begin Edit3.Text:=''; exit; end;
  Edit3.Text:=dbProveedores.FieldByName('P1').AsString;
end;
//======================== BUSCAR PRIMER PROVEEDOR =========================
procedure TFFacturaped.Button1Click(Sender: TObject);
begin
  if Edit3.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit3.SetFocus; Exit; end;
  Edit1.Text := FBusquedas.IniciaBusquedas('SELECT P0, P1, P2 FROM proveedores WHERE P1 LIKE "'+Edit3.Text+'%"',
           ['Codigo', ' Razón social ', ' Dirección ' ], 'P0' );
  if Edit1.Text<>'' then begin Edit1Exit(Edit1); end;
end;
procedure TFFacturaped.Edit3KeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then Button1Click(Button1);
end;


//====================== PRIMERA FECHA ============================
procedure TFFacturaped.Button3Click(Sender: TObject);
begin
  if Edit7.Text<>'' then CalendarDialog1.Date:=StrToDate(Edit7.Text);
  if CalendarDialog1.Execute then Edit7.Text:=FormatDateTime('DD/MM/YYYY',CalendarDialog1.Date);

end;

//====================== ULTIMA FECHA ============================
procedure TFFacturaped.Button4Click(Sender: TObject);
begin
  if Edit8.Text<>'' then CalendarDialog1.Date:=StrToDate(Edit8.Text);
  if CalendarDialog1.Execute then Edit8.Text:=FormatDateTime('DD/MM/YYYY',CalendarDialog1.Date);
end;


//================== VENCIMIENTOS =======================
procedure TFFacturaped.VerVencimientos();//---------------- Ver si tiene vencimientos
var
  TotalFact: Double;
  Plazos: Integer;
  Dias: TDateTime;
begin
  TotalFact:=dbFactuc.FieldByName('FC9').AsFloat;
  //----------- Plazos de pagos (Vencimientos) --------------------------
  if (TotalFact>dbProveedores.Fields[24].AsFloat) And (dbProveedores.Fields[13].AsInteger>0) then
    begin
      Plazos:=dbProveedores.Fields[15].AsInteger; if Plazos=0 then Plazos:=1;
      Dias:=DateEdit1.Date+dbProveedores.Fields[13].AsInteger;
      FECHAPAGO1:=FormatDateTime('DD/MM/YYYY',Dias);
      IMPOPAGO1:=FormatFloat('0.000',TotalFact/Plazos);
      //------------------- Segundo Plazo
      if Plazos>1 then
        begin
          Dias:=Dias+dbProveedores.Fields[14].AsInteger;
          FECHAPAGO2:=FormatDateTime('DD/MM/YYYY',Dias);
          IMPOPAGO2:=FormatFloat('0.000',TotalFact/Plazos);
        end;
      //------------------- Tercer Plazo
      if Plazos>2 then
        begin
          Dias:=Dias+dbProveedores.Fields[14].AsInteger;
          FECHAPAGO3:=FormatDateTime('DD/MM/YYYY',Dias);
          IMPOPAGO3:=FormatFloat('0.000',TotalFact/Plazos);
        end;
      //------------------- Cuarto Plazo
      if Plazos>3 then
        begin
          Dias:=Dias+dbProveedores.Fields[14].AsInteger;
          FECHAPAGO4:=FormatDateTime('DD/MM/YYYY',Dias);
          IMPOPAGO4:=FormatFloat('0.000',TotalFact/Plazos);
        end;
      ActuFactuVen(); //---------------- Actualizar Vencimientos en factura.
    end;
end;


initialization
  {$I facturaped.lrs}

end.

