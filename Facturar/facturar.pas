{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2010, Nicolas Lopez de Lerma Aymerich

  PuntoDev GNU S.L. <info@puntodev.com>

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

unit facturar;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  Classes, SysUtils, StrUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  Buttons, ZConnection, StdCtrls, ZDataset, ExtDlgs, EditBtn, DBGrids, Grids, ExtCtrls,
  db, LCLType, ComCtrls, LR_Class, LR_DBSet, dateutils, ZClasses,
  ZAbstractConnection, ZAbstractRODataset, ZExceptions, ZAbstractDataset; //-- Control de errores de la uniad ZEOS

type

  { TFFacturar }

  TFFacturar = class(TForm)
    Bevel2: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn20: TBitBtn;
    BitBtn23: TBitBtn;
    BitBtn3: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    CalendarDialog1: TCalendarDialog;
    CheckBox1: TCheckBox;
    ChkBoxVisualiza: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox4: TComboBox;
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
    Edit2: TEdit;
    Edit21: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
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
    Label2: TLabel;
    Label3: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label4: TLabel;
    dbClientes: TZQuery;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListBox1: TListBox;
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
    dbIva: TZQuery;
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure DBGridPrepareCanvas(Sender: TObject; DataCol: Integer;
      Column: TColumn; AState: TGridDrawState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn20Click(Sender: TObject);
    procedure BitBtn23Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit2Enter(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: char);
    procedure Edit4KeyPress(Sender: TObject; var Key: char);
    procedure Edit5Enter(Sender: TObject);
    procedure Edit5Exit(Sender: TObject);
    procedure Edit6KeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure NumeroFactura();
    procedure ActuFactuc();
    procedure ActuFactud();
    procedure ActuHisopcc();
    procedure ActuHisopdd();
    procedure Imprimir();
    procedure ActuFactuVen();
    procedure VerVencimientos();
    procedure PasaAlbaHistorico();
    procedure PasaAlbaHistoricoD();//-- Hist. Albaranes
    function VerUltimaLinea: Integer;
    Procedure ActualizaIva();

  private
    { Diseño moderno conservador: no sustituye controles ni eventos originales. }
    FEstiloModernoAplicado: Boolean;
    FPanelCabecera: TPanel;
    FLabelCabeceraTitulo: TLabel;
    FLabelCabeceraSubtitulo: TLabel;
    FPanelClientes: TPanel;
    FPanelDocumento: TPanel;
    FLabelClientesTitulo: TLabel;
    FLabelDocumentoTitulo: TLabel;
    FPanelAtajos: TPanel;
    FLabelAtajos: TLabel;
    FPanelProgresoFondo: TPanel;
    FPanelProgresoRelleno: TPanel;
    FOrdenGrid1Campo: String;
    FOrdenGrid1Direccion: String;
    FOrdenGrid2Campo: String;
    FOrdenGrid2Direccion: String;
    procedure AplicarEstiloModerno;
    procedure CrearEstructuraModerna;
    procedure AjustarLayoutModerno;
    procedure FormResizeModerno(Sender: TObject);
    procedure ControlTextoEnter(Sender: TObject);
    procedure ControlTextoExit(Sender: TObject);
    procedure ComboTextoEnter(Sender: TObject);
    procedure ComboTextoExit(Sender: TObject);
    procedure AjustarSeleccionInicial(Data: PtrInt);
    procedure CrearPieAtajos;
    procedure ActualizarPieAtajos;
    procedure CrearProgresoVisible;
    procedure ActualizarProgresoVisible(APosicion, AMaximo: Integer);
    procedure ConfigurarOrdenacionGrids;
    procedure RestaurarOrdenFacturacionSeguro;
    procedure OrdenarGrid(AQuery: TZQuery; AGrid: TDBGrid; AColumn: TColumn;
      var ACampo, ADireccion: String);
    procedure ActualizarFlechaGrid(AGrid: TDBGrid;
      const ACampo, ADireccion: String);
    function SQLSinOrden(const ASQL: String): String;
  public
    { public declarations }
  end; 

  procedure ShowFormFacturar();

var
  FFacturar: TFFacturar;
  SFACTURA,SerieABorrar: String;
  NFACTURA: Integer;
  BASE1,BASE2,BASE3,IMPOIVA1,IMPOIVA2,IMPOIVA3,TOTAL1,TOTAL2,TOTAL3: Double;
  IRIVA1,IRIVA2,IRIVA3,RECARGO: Double;
  PIVA1,PIVA2,PIVA3,PRIVA1,PRIVA2,PRIVA3:Double;
  Fecha, Hora: TDateTime;
  NLinea, AntCliente: Integer;
  FECHAPAGO1,FECHAPAGO2,FECHAPAGO3,FECHAPAGO4: String;
  IMPOPAGO1,IMPOPAGO2,IMPOPAGO3,IMPOPAGO4: String;

implementation

uses
  Global, Funciones, Busquedas, Imprimir, uFLX_FacturaPDF, uFLX_EmailPDF, uFLX_Log, uVeriFactu, uVeriHash;

{ TFFacturar }

//================== PROGRESO VISIBLE E INDEPENDIENTE DEL TEMA GTK ==================
procedure TFFacturar.CrearProgresoVisible;
begin
  if Assigned(FPanelProgresoFondo) then Exit;

  FPanelProgresoFondo := TPanel.Create(Self);
  FPanelProgresoFondo.Name := 'pnlProgresoFacturarFondo';
  FPanelProgresoFondo.Parent := Panel8;
  FPanelProgresoFondo.Caption := '';
  FPanelProgresoFondo.ParentBackground := False;
  FPanelProgresoFondo.ParentColor := False;
  FPanelProgresoFondo.Color := clWhite;
  FPanelProgresoFondo.BevelOuter := bvLowered;
  FPanelProgresoFondo.Visible := False;

  FPanelProgresoRelleno := TPanel.Create(Self);
  FPanelProgresoRelleno.Name := 'pnlProgresoFacturarRelleno';
  FPanelProgresoRelleno.Parent := FPanelProgresoFondo;
  FPanelProgresoRelleno.Caption := '';
  FPanelProgresoRelleno.ParentBackground := False;
  FPanelProgresoRelleno.ParentColor := False;
  FPanelProgresoRelleno.Color := RGBToColor(37, 99, 235);
  FPanelProgresoRelleno.BevelOuter := bvNone;
  FPanelProgresoRelleno.SetBounds(2, 2, 0, 18);

  // ProgressBar1 conserva Max y Position para no alterar la lógica original.
  // Solo se oculta el dibujo nativo, que puede perderse bajo algunos temas GTK.
  ProgressBar1.Visible := False;
end;

procedure TFFacturar.ActualizarProgresoVisible(APosicion, AMaximo: Integer);
var
  PosicionSegura, AnchoUtil, AnchoRelleno, Porcentaje: Integer;
begin
  CrearProgresoVisible;

  if AMaximo <= 0 then
  begin
    FPanelProgresoRelleno.Width := 0;
    FPanelProgresoFondo.Visible := False;
    Label16.Caption := 'Procesando documentos . . .';
    Exit;
  end;

  PosicionSegura := APosicion;
  if PosicionSegura < 0 then PosicionSegura := 0;
  if PosicionSegura > AMaximo then PosicionSegura := AMaximo;

  AnchoUtil := FPanelProgresoFondo.ClientWidth - 4;
  if AnchoUtil < 0 then AnchoUtil := 0;
  AnchoRelleno := Round((Int64(AnchoUtil) * PosicionSegura) / AMaximo);
  Porcentaje := Round((Int64(100) * PosicionSegura) / AMaximo);

  FPanelProgresoRelleno.SetBounds(2, 2, AnchoRelleno,
    FPanelProgresoFondo.ClientHeight - 4);
  Label16.Caption := Format('Procesando documentos: %d de %d  (%d%%)',
    [PosicionSegura, AMaximo, Porcentaje]);
  Label16.Enabled := True;
  FPanelProgresoFondo.Visible := True;
  FPanelProgresoFondo.BringToFront;
  FPanelProgresoFondo.Repaint;
end;

//================== ESTRUCTURA VISUAL MODERNA ==================
procedure TFFacturar.CrearEstructuraModerna;
const
  CCabecera = TColor($00563706);
  CTarjeta = clWhite;
  CAzulSuave = TColor($00FCF0E4);
begin
  if Assigned(FPanelCabecera) then Exit;

  FPanelCabecera := TPanel.Create(Self);
  FPanelCabecera.Name := 'pnlCabeceraFacturarModerno';
  FPanelCabecera.Parent := Self;
  FPanelCabecera.BevelOuter := bvNone;
  FPanelCabecera.ParentBackground := False;
  FPanelCabecera.ParentColor := False;
  FPanelCabecera.Color := CCabecera;
  FPanelCabecera.Caption := '';
  FPanelCabecera.Anchors := [akTop, akLeft, akRight];

  FLabelCabeceraTitulo := TLabel.Create(Self);
  FLabelCabeceraTitulo.Name := 'lblTituloFacturarModerno';
  FLabelCabeceraTitulo.Parent := FPanelCabecera;
  FLabelCabeceraTitulo.AutoSize := False;
  FLabelCabeceraTitulo.Transparent := True;
  FLabelCabeceraTitulo.ParentFont := False;
  FLabelCabeceraTitulo.Font.Name := 'Sans';
  FLabelCabeceraTitulo.Font.Height := -18;
  FLabelCabeceraTitulo.Font.Style := [fsBold];
  FLabelCabeceraTitulo.Font.Color := clWhite;
  FLabelCabeceraTitulo.Caption := 'FACTURACIÓN DE ALBARANES';
  FLabelCabeceraTitulo.Layout := tlCenter;

  FLabelCabeceraSubtitulo := TLabel.Create(Self);
  FLabelCabeceraSubtitulo.Name := 'lblSubtituloFacturarModerno';
  FLabelCabeceraSubtitulo.Parent := FPanelCabecera;
  FLabelCabeceraSubtitulo.AutoSize := False;
  FLabelCabeceraSubtitulo.Transparent := True;
  FLabelCabeceraSubtitulo.ParentFont := False;
  FLabelCabeceraSubtitulo.Font.Name := 'Sans';
  FLabelCabeceraSubtitulo.Font.Height := -10;
  FLabelCabeceraSubtitulo.Font.Color := RGBToColor(220, 235, 245);
  FLabelCabeceraSubtitulo.Caption :=
    'Selección de albaranes, revisión previa y generación controlada de facturas';
  FLabelCabeceraSubtitulo.Layout := tlCenter;

  FPanelClientes := TPanel.Create(Self);
  FPanelClientes.Name := 'pnlClientesFacturarModerno';
  FPanelClientes.Parent := Self;
  FPanelClientes.BevelInner := bvNone;
  FPanelClientes.BevelOuter := bvNone;
  FPanelClientes.BorderWidth := 1;
  FPanelClientes.ParentBackground := False;
  FPanelClientes.ParentColor := False;
  FPanelClientes.Color := CTarjeta;
  FPanelClientes.Caption := '';
  FPanelClientes.SendToBack;

  FLabelClientesTitulo := TLabel.Create(Self);
  FLabelClientesTitulo.Name := 'lblClientesFacturarModerno';
  FLabelClientesTitulo.Parent := FPanelClientes;
  FLabelClientesTitulo.AutoSize := False;
  FLabelClientesTitulo.Transparent := True;
  FLabelClientesTitulo.ParentFont := False;
  FLabelClientesTitulo.Font.Name := 'Sans';
  FLabelClientesTitulo.Font.Height := -11;
  FLabelClientesTitulo.Font.Style := [fsBold];
  FLabelClientesTitulo.Font.Color := RGBToColor(6, 55, 86);
  FLabelClientesTitulo.Caption := 'CLIENTES Y RUTA';
  FLabelClientesTitulo.Layout := tlCenter;

  FPanelDocumento := TPanel.Create(Self);
  FPanelDocumento.Name := 'pnlDocumentoFacturarModerno';
  FPanelDocumento.Parent := Self;
  FPanelDocumento.BevelInner := bvNone;
  FPanelDocumento.BevelOuter := bvNone;
  FPanelDocumento.BorderWidth := 1;
  FPanelDocumento.ParentBackground := False;
  FPanelDocumento.ParentColor := False;
  FPanelDocumento.Color := CAzulSuave;
  FPanelDocumento.Caption := '';
  FPanelDocumento.SendToBack;

  FLabelDocumentoTitulo := TLabel.Create(Self);
  FLabelDocumentoTitulo.Name := 'lblDocumentoFacturarModerno';
  FLabelDocumentoTitulo.Parent := FPanelDocumento;
  FLabelDocumentoTitulo.AutoSize := False;
  FLabelDocumentoTitulo.Transparent := True;
  FLabelDocumentoTitulo.ParentFont := False;
  FLabelDocumentoTitulo.Font.Name := 'Sans';
  FLabelDocumentoTitulo.Font.Height := -11;
  FLabelDocumentoTitulo.Font.Style := [fsBold];
  FLabelDocumentoTitulo.Font.Color := RGBToColor(6, 55, 86);
  FLabelDocumentoTitulo.Caption := 'PERIODO Y SERIE';
  FLabelDocumentoTitulo.Layout := tlCenter;

  // Las etiquetas de los filtros son TLabel (controles gráficos). Si se
  // mantienen como hijas directas del formulario, GTK puede dibujarlas detrás
  // de las tarjetas TPanel aunque los Edit/ComboBox sí queden visibles. Se
  // integran en su tarjeta correspondiente para garantizar su visibilidad.
  Label4.Parent := FPanelClientes;
  Label1.Parent := FPanelClientes;
  Label2.Parent := FPanelClientes;
  Label14.Parent := FPanelClientes;

  Label5.Parent := FPanelDocumento;
  Label3.Parent := FPanelDocumento;
  Label6.Parent := FPanelDocumento;

  // El checkbox pertenece visualmente a la tarjeta PERIODO Y SERIE. Debe ser
  // también hijo real de ella: en GTK, dejarlo como hijo del formulario puede
  // situarlo detrás del panel dinámico y ocultar tanto la casilla como el texto.
  ChkBoxVisualiza.Parent := FPanelDocumento;
  ChkBoxVisualiza.Visible := True;
  ChkBoxVisualiza.BringToFront;

  // Fondo claro = texto oscuro. El fondo de la tarjeta se conserva gracias a
  // Transparent=True; el color no depende del tema GTK.
  Label1.Transparent := True;
  Label2.Transparent := True;
  Label3.Transparent := True;
  Label4.Transparent := True;
  Label5.Transparent := True;
  Label6.Transparent := True;
  Label14.Transparent := True;

  Label1.ParentFont := False;
  Label2.ParentFont := False;
  Label3.ParentFont := False;
  Label4.ParentFont := False;
  Label5.ParentFont := False;
  Label6.ParentFont := False;
  Label14.ParentFont := False;

  Label1.Font.Name := 'Sans'; Label1.Font.Height := -10;
  Label2.Font.Name := 'Sans'; Label2.Font.Height := -10;
  Label3.Font.Name := 'Sans'; Label3.Font.Height := -10;
  Label4.Font.Name := 'Sans'; Label4.Font.Height := -10;
  Label5.Font.Name := 'Sans'; Label5.Font.Height := -10;
  Label6.Font.Name := 'Sans'; Label6.Font.Height := -10;
  Label14.Font.Name := 'Sans'; Label14.Font.Height := -10;

  Label1.Font.Style := [fsBold];
  Label2.Font.Style := [fsBold];
  Label3.Font.Style := [fsBold];
  Label4.Font.Style := [fsBold];
  Label5.Font.Style := [fsBold];
  Label6.Font.Style := [fsBold];
  Label14.Font.Style := [fsBold];

  Label1.Font.Color := RGBToColor(21, 38, 62);
  Label2.Font.Color := RGBToColor(21, 38, 62);
  Label3.Font.Color := RGBToColor(21, 38, 62);
  Label4.Font.Color := RGBToColor(21, 38, 62);
  Label5.Font.Color := RGBToColor(21, 38, 62);
  Label6.Font.Color := RGBToColor(21, 38, 62);
  Label14.Font.Color := RGBToColor(21, 38, 62);

  FPanelCabecera.BringToFront;
end;

//================== DISEÑO MODERNO CONSERVADOR ==================
procedure TFFacturar.AplicarEstiloModerno;
var
  CFondo, CTarjeta, CCabecera, CPrimario, CTexto: TColor;
  CVerde, CVerdeSuave, CRojo, CAzulSuave, CAmbarSuave: TColor;
  I: Integer;

  procedure EstilarBitBtn(ABoton: TBitBtn; AColor, ATexto: TColor);
  begin
    if not Assigned(ABoton) then Exit;
    ABoton.ParentFont := False;
    ABoton.Font.Name := 'Sans';
    ABoton.Font.Height := -12;
    ABoton.Font.Style := [fsBold];
    ABoton.Font.Color := ATexto;
    ABoton.Color := AColor;
  end;

  procedure EstilarBotonAuxiliar(ABoton: TButton);
  begin
    if not Assigned(ABoton) then Exit;
    ABoton.ParentFont := False;
    ABoton.Font.Name := 'Sans';
    ABoton.Font.Height := -12;
    ABoton.Font.Style := [fsBold];
    ABoton.Font.Color := CPrimario;
    ABoton.Color := CAzulSuave;
    ABoton.Caption := '...';
  end;

  procedure EstilarGrid(AGrid: TDBGrid);
  var
    K: Integer;
  begin
    if not Assigned(AGrid) then Exit;
    AGrid.ParentFont := False;
    AGrid.Font.Name := 'Sans';
    AGrid.Font.Height := -10;
    AGrid.Font.Color := CTexto;
    AGrid.Color := clWhite;
    AGrid.FixedColor := CCabecera;
    AGrid.AlternateColor := RGBToColor(248, 250, 252);
    AGrid.SelectedColor := RGBToColor(191, 219, 254);
    AGrid.OnPrepareCanvas := @DBGridPrepareCanvas;
    AGrid.GridLineColor := RGBToColor(203, 213, 225);
    AGrid.DefaultRowHeight := 25;
    AGrid.TitleFont.Name := 'Sans';
    AGrid.TitleFont.Height := -10;
    AGrid.TitleFont.Style := [fsBold];
    AGrid.TitleFont.Color := clWhite;

    for K := 0 to AGrid.Columns.Count - 1 do
    begin
      AGrid.Columns[K].Font.Name := 'Sans';
      AGrid.Columns[K].Font.Height := -10;
      AGrid.Columns[K].Font.Color := CTexto;
      AGrid.Columns[K].MinSize := 20;
      AGrid.Columns[K].MaxSize := 2000;
    end;
  end;

  procedure EstilarResumen(AControl: TStaticText; AColor: TColor);
  begin
    if not Assigned(AControl) then Exit;
    AControl.ParentFont := False;
    AControl.Font.Name := 'Sans';
    AControl.Font.Height := -14;
    AControl.Font.Style := [fsBold];
    AControl.Font.Color := CTexto;
    AControl.Color := AColor;
    AControl.BorderStyle := sbsNone;
  end;

begin
  if FEstiloModernoAplicado then Exit;
  FEstiloModernoAplicado := True;

  CFondo       := RGBToColor(239, 244, 249);
  CTarjeta     := clWhite;
  CCabecera    := RGBToColor(6, 55, 86);
  CPrimario    := RGBToColor(37, 99, 235);
  CTexto       := RGBToColor(21, 38, 62);
  CVerde       := RGBToColor(0, 145, 82);
  CVerdeSuave  := RGBToColor(222, 247, 232);
  CRojo        := RGBToColor(185, 28, 28);
  CAzulSuave   := RGBToColor(228, 240, 252);
  CAmbarSuave  := RGBToColor(255, 246, 214);

  KeyPreview := True;
  Color := CFondo;
  ParentFont := False;
  Font.Name := 'Sans';
  Font.Height := -11;
  Font.Color := CTexto;
  Caption := 'FacturLinEx · Facturación de albaranes';

  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TLabel then
      with TLabel(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -10;
        Font.Color := CTexto;
      end
    else if Components[I] is TEdit then
      with TEdit(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -11;
        Font.Color := CTexto;
        Color := clWhite;
      end
    else if Components[I] is TComboBox then
      with TComboBox(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -11;
        // Estado normal: fondo claro y texto oscuro. El contraste de foco y
        // selección se aplica expresamente en ControlTextoEnter/Exit.
        Font.Color := CTexto;
        Color := clWhite;
      end
    else if Components[I] is TCheckBox then
      with TCheckBox(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -10;
        Font.Color := CTexto;
      end
    else if Components[I] is TRadioButton then
      with TRadioButton(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -10;
        Font.Color := CTexto;
      end
    else if Components[I] is TListBox then
      with TListBox(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -11;
        Font.Color := CTexto;
        Color := clWhite;
      end
    else if Components[I] is TMemo then
      with TMemo(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -11;
        Font.Color := CTexto;
        Color := clWhite;
      end;
  end;

  EstilarBotonAuxiliar(Button1);
  EstilarBotonAuxiliar(Button2);
  EstilarBotonAuxiliar(Button3);
  EstilarBotonAuxiliar(Button4);
  EstilarBotonAuxiliar(Button5);

  EstilarBitBtn(BitBtn2, CPrimario, clWhite);
  EstilarBitBtn(BitBtn3, CVerde, clWhite);
  EstilarBitBtn(BitBtn1, CRojo, clWhite);
  EstilarBitBtn(BitBtn23, CVerde, clWhite);
  EstilarBitBtn(BitBtn20, CRojo, clWhite);

  BitBtn2.Caption := 'Aplicar filtro';
  BitBtn3.Caption := 'Facturar albaranes';

  Panel1.ParentBackground := False;
  Panel1.ParentColor := False;
  Panel1.Color := CAzulSuave;
  Panel1.BevelInner := bvNone;
  Panel1.BevelOuter := bvNone;
  Panel1.BorderWidth := 1;
  Panel1.Caption := '';

  Label7.ParentColor := False;
  Label7.Color := CCabecera;
  Label7.Transparent := False;
  Label7.ParentFont := False;
  Label7.Font.Name := 'Sans';
  Label7.Font.Height := -10;
  Label7.Font.Style := [fsBold];
  Label7.Font.Color := clWhite;
  Label7.Caption := 'ALBARANES MARCADOS / SIN MARCAR';

  ChkBoxVisualiza.ParentColor := False;
  ChkBoxVisualiza.Color := RGBToColor(228, 240, 252);
  ChkBoxVisualiza.ParentFont := False;
  ChkBoxVisualiza.Font.Name := 'Sans';
  ChkBoxVisualiza.Font.Height := -10;
  ChkBoxVisualiza.Font.Style := [fsBold];
  ChkBoxVisualiza.Font.Color := CTexto;
  ChkBoxVisualiza.AutoSize := False;
  ChkBoxVisualiza.Visible := True;
  ChkBoxVisualiza.ShowHint := True;
  ChkBoxVisualiza.BringToFront;

  // Los tres selectores del estado de los albaranes son TRadioButton. Se fija
  // también su contraste para evitar que un tema GTK oscuro los dibuje con
  // texto claro sobre la tarjeta clara.
  RadioButton1.ParentColor := False;
  RadioButton1.Color := CAzulSuave;
  RadioButton1.ParentFont := False;
  RadioButton1.Font.Name := 'Sans';
  RadioButton1.Font.Height := -10;
  RadioButton1.Font.Style := [fsBold];
  RadioButton1.Font.Color := CTexto;
  RadioButton1.AutoSize := False;
  RadioButton1.Visible := True;
  RadioButton1.BringToFront;

  RadioButton2.ParentColor := False;
  RadioButton2.Color := CAzulSuave;
  RadioButton2.ParentFont := False;
  RadioButton2.Font.Name := 'Sans';
  RadioButton2.Font.Height := -10;
  RadioButton2.Font.Style := [fsBold];
  RadioButton2.Font.Color := CTexto;
  RadioButton2.AutoSize := False;
  RadioButton2.Visible := True;
  RadioButton2.BringToFront;

  RadioButton3.ParentColor := False;
  RadioButton3.Color := CAzulSuave;
  RadioButton3.ParentFont := False;
  RadioButton3.Font.Name := 'Sans';
  RadioButton3.Font.Height := -10;
  RadioButton3.Font.Style := [fsBold];
  RadioButton3.Font.Color := CTexto;
  RadioButton3.AutoSize := False;
  RadioButton3.Visible := True;
  RadioButton3.BringToFront;

  Panel2.ParentBackground := False;
  Panel2.ParentColor := False;
  Panel2.Color := CTarjeta;
  Panel2.BevelInner := bvNone;
  Panel2.BevelOuter := bvNone;
  Panel2.Caption := '';

  EstilarResumen(StaticText4, CAzulSuave);
  EstilarResumen(StaticText5, CAzulSuave);
  EstilarResumen(StaticText2, CVerdeSuave);
  EstilarResumen(StaticText3, CVerdeSuave);
  EstilarResumen(StaticText7, CAmbarSuave);
  EstilarResumen(StaticText8, CAmbarSuave);

  PageControl1.ParentFont := False;
  PageControl1.Font.Name := 'Sans';
  PageControl1.Font.Height := -11;
  PageControl1.Font.Style := [fsBold];
  EstilarGrid(DBGrid1);
  EstilarGrid(DBGrid2);

  // Panel auxiliar de selección de serie: fondo pastel claramente
  // diferenciado del fondo general, sin alterar ninguno de sus eventos.
  Panel8.ParentBackground := False;
  Panel8.ParentColor := False;
  Panel8.Color := CVerdeSuave;
  Panel8.BevelInner := bvNone;
  Panel8.BevelOuter := bvNone;
  Panel8.BorderWidth := 2;
  Panel8.Caption := '';
  Bevel2.Visible := False;

  Label36.ParentColor := False;
  Label36.Color := CCabecera;
  Label36.Transparent := False;
  Label36.ParentFont := False;
  Label36.Font.Name := 'Sans';
  Label36.Font.Height := -12;
  Label36.Font.Style := [fsBold];
  Label36.Font.Color := clWhite;
  Label36.Caption := 'SERIE Y DATOS DE LA FACTURA';

  // Etiquetas del panel auxiliar: color y fondo explícitos para que nunca
  // dependan del tema GTK ni queden ilegibles sobre el tono pastel.
  Label33.ParentColor := False;
  Label33.Transparent := False;
  Label33.Color := CVerdeSuave;
  Label33.ParentFont := False;
  Label33.Font.Name := 'Sans';
  Label33.Font.Height := -11;
  Label33.Font.Style := [fsBold];
  Label33.Font.Color := CTexto;

  Label34.ParentColor := False;
  Label34.Transparent := False;
  Label34.Color := CVerdeSuave;
  Label34.ParentFont := False;
  Label34.Font.Name := 'Sans';
  Label34.Font.Height := -11;
  Label34.Font.Style := [fsBold];
  Label34.Font.Color := CTexto;

  Label35.ParentColor := False;
  Label35.Transparent := False;
  Label35.Color := CVerdeSuave;
  Label35.ParentFont := False;
  Label35.Font.Name := 'Sans';
  Label35.Font.Height := -11;
  Label35.Font.Style := [fsBold];
  Label35.Font.Color := CTexto;

  Label16.ParentColor := False;
  Label16.Transparent := False;
  Label16.Color := CVerdeSuave;
  Label16.ParentFont := False;
  Label16.Font.Name := 'Sans';
  Label16.Font.Height := -10;
  Label16.Font.Style := [fsBold];
  Label16.Font.Color := CTexto;

  CheckBox1.ParentColor := False;
  CheckBox1.Color := CVerdeSuave;
  CheckBox1.ParentFont := False;
  CheckBox1.Font.Name := 'Sans';
  CheckBox1.Font.Height := -10;
  CheckBox1.Font.Style := [fsBold];
  CheckBox1.Font.Color := CTexto;
  CheckBox1.AutoSize := False;
  CheckBox1.Visible := True;
  CheckBox1.BringToFront;

  Edit21.ParentFont := False;
  Edit21.Font.Name := 'Sans';
  Edit21.Font.Height := -11;
  Edit21.Font.Color := CTexto;
  Edit21.Color := clWhite;

  ListBox1.ParentFont := False;
  ListBox1.Font.Name := 'Sans';
  ListBox1.Font.Height := -11;
  ListBox1.Font.Color := CTexto;
  ListBox1.Color := clWhite;

  Memo1.ParentFont := False;
  Memo1.Font.Name := 'Sans';
  Memo1.Font.Height := -11;
  Memo1.Font.Color := CTexto;
  Memo1.Color := clWhite;

  DateEdit1.ParentFont := False;
  DateEdit1.Font.Name := 'Sans';
  DateEdit1.Font.Height := -11;
  DateEdit1.Font.Color := CTexto;
  DateEdit1.Color := clWhite;
  DateEdit1.ButtonOnlyWhenFocused := False;
  DateEdit1.Button.Visible := True;
  DateEdit1.Button.Enabled := True;

  ProgressBar1.Font.Name := 'Sans';
  ProgressBar1.Font.Height := -10;
  CrearProgresoVisible;

  CrearEstructuraModerna;
end;

//================== LAYOUT MODERNO ADAPTABLE ==================
procedure TFFacturar.AjustarLayoutModerno;
var
  W, Margen, Espacio, YTarjetas, AltoTarjetas: Integer;
  AnchoClientes, AnchoDocumento, XDocumento, XEstado, AnchoEstado: Integer;
  YAcciones, AnchoBoton, Separacion, XSalir, XFacturar, XAplicar: Integer;
  InicioResumen, AnchoCelda, AnchoDisponible, I: Integer;
  Etiquetas: array[0..5] of TLabel;
  Valores: array[0..5] of TStaticText;
begin
  if not Assigned(FPanelCabecera) then Exit;

  W := ClientWidth;
  Margen := 16;
  Espacio := 14;
  YTarjetas := 74;
  AltoTarjetas := 174;

  if W >= 1600 then
  begin
    AnchoClientes := 620;
    AnchoDocumento := 430;
  end
  else if W >= 1300 then
  begin
    AnchoClientes := 520;
    AnchoDocumento := 360;
  end
  else
  begin
    AnchoClientes := 460;
    AnchoDocumento := 330;
  end;

  XDocumento := Margen + AnchoClientes + Espacio;
  XEstado := XDocumento + AnchoDocumento + Espacio;
  AnchoEstado := W - XEstado - Margen;
  if AnchoEstado < 330 then AnchoEstado := 330;

  FPanelCabecera.SetBounds(0, 0, W, 62);
  FLabelCabeceraTitulo.SetBounds(20, 7, W - 40, 30);
  FLabelCabeceraSubtitulo.SetBounds(21, 35, W - 42, 20);

  FPanelClientes.SetBounds(Margen, YTarjetas, AnchoClientes, AltoTarjetas);
  FLabelClientesTitulo.SetBounds(12, 4, AnchoClientes - 24, 27);

  FPanelDocumento.SetBounds(XDocumento, YTarjetas, AnchoDocumento, AltoTarjetas);
  FLabelDocumentoTitulo.SetBounds(12, 4, AnchoDocumento - 24, 27);

  Panel1.SetBounds(XEstado, YTarjetas, AnchoEstado, AltoTarjetas);
  Label7.SetBounds(8, 8, Panel1.ClientWidth - 16, 30);
  RadioButton1.SetBounds(16, 51, Panel1.ClientWidth - 32, 25);
  RadioButton2.SetBounds(16, 87, Panel1.ClientWidth - 32, 25);
  RadioButton3.SetBounds(16, 123, Panel1.ClientWidth - 32, 25);

  Label4.SetBounds(16, 36, 118, 28);
  ComboBox1.SetBounds(Margen + 140, YTarjetas + 36,
    AnchoClientes - 156, 30);

  Label1.SetBounds(16, 70, 118, 28);
  Edit1.SetBounds(Margen + 140, YTarjetas + 70, 82, 30);
  Button1.SetBounds(Margen + 226, YTarjetas + 70, 36, 30);
  Edit3.SetBounds(Margen + 268, YTarjetas + 70,
    AnchoClientes - 284, 30);

  Label2.SetBounds(16, 104, 118, 28);
  Edit2.SetBounds(Margen + 140, YTarjetas + 104, 82, 30);
  Button2.SetBounds(Margen + 226, YTarjetas + 104, 36, 30);
  Edit4.SetBounds(Margen + 268, YTarjetas + 104,
    AnchoClientes - 284, 30);

  Label14.SetBounds(16, 138, 118, 28);
  Edit5.SetBounds(Margen + 140, YTarjetas + 138, 82, 30);
  Button5.SetBounds(Margen + 226, YTarjetas + 138, 36, 30);
  Edit6.SetBounds(Margen + 268, YTarjetas + 138,
    AnchoClientes - 284, 30);

  Label5.SetBounds(16, 36, 116, 28);
  ComboBox4.SetBounds(XDocumento + 138, YTarjetas + 36,
    AnchoDocumento - 154, 30);

  Label3.SetBounds(16, 72, 116, 28);
  Edit7.SetBounds(XDocumento + 138, YTarjetas + 72, 112, 30);
  Button3.SetBounds(XDocumento + 256, YTarjetas + 72, 36, 30);

  Label6.SetBounds(16, 106, 116, 28);
  Edit8.SetBounds(XDocumento + 138, YTarjetas + 106, 112, 30);
  Button4.SetBounds(XDocumento + 256, YTarjetas + 106, 36, 30);

  // ChkBoxVisualiza es hijo de FPanelDocumento: las coordenadas son locales
  // a la tarjeta, no al formulario.
  ChkBoxVisualiza.SetBounds(16, 140, AnchoDocumento - 32, 26);
  ChkBoxVisualiza.BringToFront;

  // La barra de atajos se inserta encima del resumen inferior. Los botones
  // deben quedar completamente por encima de ella, con un margen visual claro.
  if Assigned(FPanelAtajos) and (FPanelAtajos.Top > 0) then
    YAcciones := FPanelAtajos.Top - 52 - 14
  else
    YAcciones := Panel2.Top - 52 - 14;

  if YAcciones < YTarjetas + AltoTarjetas + 8 then
    YAcciones := YTarjetas + AltoTarjetas + 8;

  AnchoBoton := 170;
  Separacion := 16;
  XSalir := W - Margen - AnchoBoton;
  XFacturar := XSalir - Separacion - AnchoBoton;
  XAplicar := XFacturar - Separacion - AnchoBoton;

  BitBtn2.Anchors := [akTop, akLeft];
  BitBtn3.Anchors := [akTop, akLeft];
  BitBtn1.Anchors := [akTop, akLeft];
  BitBtn2.SetBounds(XAplicar, YAcciones, AnchoBoton, 52);
  BitBtn3.SetBounds(XFacturar, YAcciones, AnchoBoton, 52);
  BitBtn1.SetBounds(XSalir, YAcciones, AnchoBoton, 52);

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

  AnchoCelda := 145;
  InicioResumen := (Panel2.ClientWidth - (6 * AnchoCelda)) div 2;
  if InicioResumen < 8 then InicioResumen := 8;
  for I := 0 to 5 do
  begin
    Etiquetas[I].Alignment := taCenter;
    Etiquetas[I].SetBounds(InicioResumen + (I * AnchoCelda), 6,
      AnchoCelda - 8, 22);
    Valores[I].Alignment := taCenter;
    Valores[I].SetBounds(InicioResumen + (I * AnchoCelda), 32,
      AnchoCelda - 8, 36);
  end;

  Label12.Caption := 'Albaranes';
  Label13.Caption := 'Facturas';
  Label8.Caption := 'Líneas';
  Label9.Caption := 'Artículos';
  Label10.Caption := 'Importe';
  Label11.Caption := 'Importe + IVA';

  // Las columnas descriptivas aprovechan el ancho disponible sin ocultar
  // importes, códigos, marcas ni observaciones.
  if DBGrid2.Columns.Count >= 7 then
  begin
    AnchoDisponible := DBGrid2.ClientWidth - 430;
    if AnchoDisponible < 420 then AnchoDisponible := 420;
    DBGrid2.Columns[5].Width := (AnchoDisponible * 48) div 100;
    DBGrid2.Columns[6].Width := AnchoDisponible - DBGrid2.Columns[5].Width;
  end;
  if DBGrid1.Columns.Count >= 7 then
  begin
    AnchoDisponible := DBGrid1.ClientWidth - 590;
    if AnchoDisponible < 320 then AnchoDisponible := 320;
    DBGrid1.Columns[1].Width := AnchoDisponible;
  end;

  Panel8.SetBounds((W - 620) div 2, (ClientHeight - 530) div 2, 620, 530);
  if Panel8.Left < 8 then Panel8.Left := 8;
  if Panel8.Top < 70 then Panel8.Top := 70;
  Label36.SetBounds(0, 0, Panel8.ClientWidth, 42);
  ListBox1.SetBounds(16, 56, Panel8.ClientWidth - 32, 130);
  Label33.SetBounds(18, 201, 90, 28);
  Edit21.SetBounds(112, 199, 100, 30);
  Label34.SetBounds(248, 201, 112, 28);
  DateEdit1.SetBounds(364, 199, 138, 30);
  CheckBox1.SetBounds(18, 240, 300, 26);
  CheckBox1.BringToFront;
  Label35.SetBounds(18, 276, 150, 26);
  Memo1.SetBounds(16, 304, Panel8.ClientWidth - 32, 92);
  Label16.SetBounds(18, 405, Panel8.ClientWidth - 36, 24);
  ProgressBar1.SetBounds(16, 431, Panel8.ClientWidth - 32, 22);
  if Assigned(FPanelProgresoFondo) then
  begin
    FPanelProgresoFondo.SetBounds(16, 431, Panel8.ClientWidth - 32, 24);
    FPanelProgresoRelleno.Height := FPanelProgresoFondo.ClientHeight - 4;
  end;
  BitBtn23.SetBounds(Panel8.ClientWidth - 240, 474, 106, 40);
  BitBtn20.SetBounds(Panel8.ClientWidth - 122, 474, 106, 40);

  if Panel8.Visible then Panel8.BringToFront;
  FPanelCabecera.BringToFront;
end;

procedure TFFacturar.FormResizeModerno(Sender: TObject);
begin
  AjustarLayoutModerno;
end;

// Contraste explícito e independiente del tema GTK.
// Fondo oscuro = texto claro mientras el control tiene el foco.
// Fondo claro = texto oscuro al perderlo.
procedure TFFacturar.ControlTextoEnter(Sender: TObject);
const
  CFondoFoco = TColor($00563706); // RGB(6,55,86), azul oscuro de cabecera
begin
  if Sender is TComboBox then
    with TComboBox(Sender) do
    begin
      ParentFont := False;
      Color := CFondoFoco;
      Font.Color := clWhite;
    end
  else if Sender is TDateEdit then
    with TDateEdit(Sender) do
    begin
      ParentFont := False;
      Color := CFondoFoco;
      Font.Color := clWhite;
    end
  else if Sender is TCustomEdit then
    with TCustomEdit(Sender) do
    begin
      ParentFont := False;
      Color := CFondoFoco;
      Font.Color := clWhite;
    end;
end;

procedure TFFacturar.ControlTextoExit(Sender: TObject);
const
  CTextoNormal = TColor($003E2615); // RGB(21,38,62), texto oscuro
begin
  if Sender is TComboBox then
    with TComboBox(Sender) do
    begin
      ParentFont := False;
      Color := clWhite;
      Font.Color := CTextoNormal;
    end
  else if Sender is TDateEdit then
    with TDateEdit(Sender) do
    begin
      ParentFont := False;
      Color := clWhite;
      Font.Color := CTextoNormal;
    end
  else if Sender is TCustomEdit then
    with TCustomEdit(Sender) do
    begin
      ParentFont := False;
      Color := clWhite;
      Font.Color := CTextoNormal;
    end;
end;

// Mantiene el comportamiento solicitado: al entrar en un combo se selecciona
// todo su texto, usando fondo oscuro y texto blanco para máxima legibilidad.
procedure TFFacturar.ComboTextoEnter(Sender: TObject);
begin
  ControlTextoEnter(Sender);
  if Sender is TComboBox then
    with TComboBox(Sender) do
    begin
      SelStart := 0;
      SelLength := Length(Text);
    end;
end;

procedure TFFacturar.ComboTextoExit(Sender: TObject);
begin
  ControlTextoExit(Sender);
end;

procedure TFFacturar.AjustarSeleccionInicial(Data: PtrInt);
begin
  if Assigned(ComboBox1) then
    ComboTextoEnter(ComboBox1);
end;

//================== PIE DE ATAJOS ==================
procedure TFFacturar.CrearPieAtajos;
const
  CBarra = TColor($0033210F);
begin
  if Assigned(FPanelAtajos) then Exit;

  FPanelAtajos := TPanel.Create(Self);
  FPanelAtajos.Name := 'pnlAtajosFacturarModerno';
  FPanelAtajos.Parent := Self;
  FPanelAtajos.Align := alBottom;
  FPanelAtajos.Height := 30;
  FPanelAtajos.BevelOuter := bvNone;
  FPanelAtajos.ParentBackground := False;
  FPanelAtajos.ParentColor := False;
  FPanelAtajos.Color := CBarra;
  FPanelAtajos.Caption := '';

  FLabelAtajos := TLabel.Create(Self);
  FLabelAtajos.Name := 'lblAtajosFacturarModerno';
  FLabelAtajos.Parent := FPanelAtajos;
  FLabelAtajos.Align := alClient;
  FLabelAtajos.Alignment := taCenter;
  FLabelAtajos.Layout := tlCenter;
  FLabelAtajos.AutoSize := False;
  FLabelAtajos.Transparent := True;
  FLabelAtajos.ParentFont := False;
  FLabelAtajos.Font.Name := 'Sans';
  FLabelAtajos.Font.Height := -11;
  FLabelAtajos.Font.Style := [fsBold];
  FLabelAtajos.Font.Color := clWhite;
end;

procedure TFFacturar.ActualizarPieAtajos;
begin
  if not Assigned(FLabelAtajos) then Exit;

  if Panel8.Visible and ProgressBar1.Enabled and (not BitBtn23.Enabled) then
    FLabelAtajos.Caption :=
      'Procesando facturación   ·   Espere a que finalice el proceso'
  else if Panel8.Visible then
    FLabelAtajos.Caption :=
      'Ctrl+O Observaciones   ·   F8 Facturar   ·   ESC Cancelar'
  else
    FLabelAtajos.Caption :=
      'F5 Desde cliente   ·   F6 Hasta cliente   ·   F7 Desde fecha   ·   F8 Hasta fecha   ·   F9 Aplicar filtro   ·   F10 Facturar   ·   ESC Cerrar';
end;

//================== ORDENACIÓN DE GRIDS ==================
function TFFacturar.SQLSinOrden(const ASQL: String): String;
var
  P: SizeInt;
  U: String;
begin
  Result := Trim(ASQL);
  U := UpperCase(Result);
  P := RPos(' ORDER BY ', U);
  if P > 0 then
    Result := Trim(Copy(Result, 1, P - 1));
end;

procedure TFFacturar.ActualizarFlechaGrid(AGrid: TDBGrid;
  const ACampo, ADireccion: String);
var
  I: Integer;
  S: String;
begin
  if not Assigned(AGrid) then Exit;

  for I := 0 to AGrid.Columns.Count - 1 do
  begin
    S := AGrid.Columns[I].Title.Caption;
    S := StringReplace(S, ' ▲', '', [rfReplaceAll]);
    S := StringReplace(S, ' ▼', '', [rfReplaceAll]);
    AGrid.Columns[I].Title.Caption := S;

    if Assigned(AGrid.Columns[I].Field) and
       SameText(AGrid.Columns[I].Field.FieldName, ACampo) then
    begin
      if S = '' then S := AGrid.Columns[I].Field.DisplayLabel;
      if SameText(ADireccion, 'ASC') then
        AGrid.Columns[I].Title.Caption := S + ' ▲'
      else
        AGrid.Columns[I].Title.Caption := S + ' ▼';
    end;
  end;
end;

procedure TFFacturar.OrdenarGrid(AQuery: TZQuery; AGrid: TDBGrid;
  AColumn: TColumn; var ACampo, ADireccion: String);
var
  Campo, SQLBase: String;
begin
  if (not Assigned(AQuery)) or (not AQuery.Active) or
     (not Assigned(AGrid)) or (not Assigned(AColumn)) or
     (not Assigned(AColumn.Field)) then Exit;

  Campo := AColumn.Field.FieldName;
  if Trim(Campo) = '' then Exit;

  if SameText(ACampo, Campo) then
  begin
    if SameText(ADireccion, 'ASC') then
      ADireccion := 'DESC'
    else
      ADireccion := 'ASC';
  end
  else
  begin
    ACampo := Campo;
    ADireccion := 'ASC';
  end;

  SQLBase := SQLSinOrden(AQuery.SQL.Text);
  AQuery.DisableControls;
  try
    AQuery.Active := False;
    AQuery.SQL.Text := SQLBase + ' ORDER BY ' + Campo + ' ' + ADireccion;
    AQuery.Active := True;
  finally
    AQuery.EnableControls;
  end;

  ActualizarFlechaGrid(AGrid, ACampo, ADireccion);
  AGrid.Refresh;
end;

procedure TFFacturar.ConfigurarOrdenacionGrids;
begin
  FOrdenGrid1Campo := '';
  FOrdenGrid1Direccion := 'ASC';
  FOrdenGrid2Campo := '';
  FOrdenGrid2Direccion := 'ASC';
  DBGrid1.OnTitleClick := @DBGrid1TitleClick;
  DBGrid2.OnTitleClick := @DBGrid2TitleClick;
end;

// La facturación original necesita los albaranes agrupados por cliente.
// La ordenación visual del grid puede cambiarse libremente, pero antes de
// facturar se recupera siempre AC0, AC1 para no separar documentos del mismo
// cliente ni alterar la lógica económica existente.
procedure TFFacturar.RestaurarOrdenFacturacionSeguro;
var
  SQLBase: String;
begin
  if not dbAlbacc.Active then Exit;
  if Trim(FOrdenGrid2Campo) = '' then Exit;

  SQLBase := SQLSinOrden(dbAlbacc.SQL.Text);
  dbAlbacc.DisableControls;
  try
    dbAlbacc.Active := False;
    dbAlbacc.SQL.Text := SQLBase + ' ORDER BY AC0,AC1';
    dbAlbacc.Active := True;
    dbAlbacc.First;
  finally
    dbAlbacc.EnableControls;
  end;

  FOrdenGrid2Campo := '';
  FOrdenGrid2Direccion := 'ASC';
  ActualizarFlechaGrid(DBGrid2, '', '');
end;

procedure TFFacturar.DBGridPrepareCanvas(Sender: TObject; DataCol: Integer;
  Column: TColumn; AState: TGridDrawState);
begin
  if (Sender is TDBGrid) and (gdSelected in AState) then
    TDBGrid(Sender).Canvas.Font.Color := clBlack;
end;

procedure TFFacturar.DBGrid1TitleClick(Column: TColumn);
begin
  OrdenarGrid(dbMuestraf, DBGrid1, Column,
    FOrdenGrid1Campo, FOrdenGrid1Direccion);
end;

procedure TFFacturar.DBGrid2TitleClick(Column: TColumn);
begin
  OrdenarGrid(dbAlbacc, DBGrid2, Column,
    FOrdenGrid2Campo, FOrdenGrid2Direccion);
end;

//================== ATAJOS DE TECLADO ==================
procedure TFFacturar.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Durante la grabación no se admiten atajos que puedan cerrar o reentrar
  // en el proceso. La lógica original sigue ejecutándose sin interrupciones.
  if Panel8.Visible and ProgressBar1.Enabled and (not BitBtn23.Enabled) then
  begin
    Key := 0;
    Exit;
  end;

  if (ssCtrl in Shift) and (Key = VK_O) then
  begin
    if Panel8.Visible then
    begin
      Key := 0;
      Memo1.SetFocus;
    end;
    Exit;
  end;

  if Key = VK_ESCAPE then
  begin
    Key := 0;
    if Panel8.Visible then
      BitBtn20Click(Self)
    else
      BitBtn1Click(Self);
    Exit;
  end;

  if Panel8.Visible then
  begin
    if Key = VK_F8 then
    begin
      Key := 0;
      BitBtn23Click(Self);
    end;
    Exit;
  end;

  case Key of
    VK_F5:
      begin Key := 0; Edit1.SetFocus; end;
    VK_F6:
      begin Key := 0; Edit2.SetFocus; end;
    VK_F7:
      begin Key := 0; Edit7.SetFocus; end;
    VK_F8:
      begin Key := 0; Edit8.SetFocus; end;
    VK_F9:
      begin Key := 0; BitBtn2Click(Self); end;
    VK_F10:
      begin Key := 0; BitBtn3Click(Self); end;
  end;
end;

//====================== CREAR FORMULARIO =======================
procedure ShowFormFacturar();
begin
  with TFFacturar.Create(Application) do
    begin
       ShowModal;
    end;
end;
procedure TFFacturar.FormCreate(Sender: TObject);
begin

  //--------- Conectar con la bbdd e inicializar datos globales
  //  Conectate(dbConnect);             // Utilizamos datamodule1.dbConexion para toda la aplicacición.

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
  if dbSeries.RecordCount=0 then begin ShowMessage('NO HAY SERIES DE FACTURACION'); Close(); end;
  if not dbSeries.Locate('SF0',dbTiendas.FieldByName('T11').AsString,[]) then
     begin ShowMessage('NO HAY SERIE DE FACTURACION ACTIVA?'); Close(); end;
  ComboBox4.ItemIndex:=ComboBox4.Items.IndexOf(dbSeries.FieldByName('SF1').AsString);

  // Presentación y navegación: se aplican al final para no alterar la
  // inicialización de tienda, series ni el foco definido en el LFM.
  AplicarEstiloModerno;
  CrearPieAtajos;
  ConfigurarOrdenacionGrids;
  OnResize:=@FormResizeModerno;
  OnKeyDown:=@FormKeyDown;
  ComboBox1.OnEnter:=@ComboTextoEnter;
  ComboBox1.OnExit:=@ComboTextoExit;
  ComboBox4.OnEnter:=@ComboTextoEnter;
  ComboBox4.OnExit:=@ComboTextoExit;

  // Controles que no tenían eventos de entrada/salida propios.
  Edit3.OnEnter:=@ControlTextoEnter; Edit3.OnExit:=@ControlTextoExit;
  Edit4.OnEnter:=@ControlTextoEnter; Edit4.OnExit:=@ControlTextoExit;
  Edit6.OnEnter:=@ControlTextoEnter; Edit6.OnExit:=@ControlTextoExit;
  Edit7.OnEnter:=@ControlTextoEnter; Edit7.OnExit:=@ControlTextoExit;
  Edit8.OnEnter:=@ControlTextoEnter; Edit8.OnExit:=@ControlTextoExit;
  Edit21.OnEnter:=@ControlTextoEnter; Edit21.OnExit:=@ControlTextoExit;
  DateEdit1.OnEnter:=@ControlTextoEnter; DateEdit1.OnExit:=@ControlTextoExit;
  Memo1.OnEnter:=@ControlTextoEnter; Memo1.OnExit:=@ControlTextoExit;

  AjustarLayoutModerno;
  ActualizarPieAtajos;
  Application.QueueAsyncCall(@AjustarSeleccionInicial, 0);
end;

//====================== CERRAR FORMULARIO =======================
procedure TFFacturar.BitBtn1Click(Sender: TObject);
begin
  Close();
end;
procedure TFFacturar.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Panel8.Visible and ProgressBar1.Enabled and (not BitBtn23.Enabled) then
  begin
    CloseAction:=caNone;
    Exit;
  end;
  CloseAction:=CaFree;
end;

//=================================================================
//====================== APLICAR FILTROS ==========================
//=================================================================
procedure TFFacturar.BitBtn2Click(Sender: TObject);
var
  TxtQ: String;
begin
  { TODO 1 -oNicolas -cFacturar : Hay que ver la suma de los albaranes y comprobar el minimo a facturar
  }
  if (Edit1.Text='') or (Edit2.Text='') then exit;
  if ComboBox4.Text='' then exit;
  SerieABorrar:='TODAS LAS SERIES';// Me quedo con la serie para borrar albaranes facturados
  if ComboBox4.Text<>'TODAS LAS SERIES' then
    begin
     if not dbSeries.Locate('SF1',ComboBox4.Text,[]) then
       begin showmessage('La serie activa no existe.'); exit; end;
     SerieABorrar:=dbSeries.FieldByName('SF0').AsString;// Me quedo con la serie para borrar albaranes facturados
    end;
  //------------- Albaranes
  TxtQ:='SELECT *,CONVERT(AC11 USING UTF8) as ANOTAS,C1,C5 FROM albac'+Tienda+',clientes'+             //MID(AC11,1,250) as ANOTAS
        ' WHERE AC0=C0 AND AC0>='+Edit1.Text+' AND AC0<='+Edit2.Text+
        ' AND AC1>="'+FormatDateTime('yyyy-mm-dd',StrToDate(Edit7.Text))+'"'+
        ' AND AC1<="'+FormatDateTime('yyyy-mm-dd',StrToDate(Edit8.Text))+'"';
  if ComboBox4.Text<>'TODAS LAS SERIES' then TxtQ:=TxtQ+' AND AC2="'+dbSeries.FieldByName('SF0').AsString+'"';
  if Edit5.Text<>'' then TxtQ:=TxtQ+' AND C10='+Edit5.Text;
  if RadioButton2.Checked then TxtQ:=TxtQ+' AND AC10="S"';//---- Los marcados
  if RadioButton3.Checked then TxtQ:=TxtQ+' AND AC10="N"';//---- Sin Marcar
  TxtQ:=TxtQ+' ORDER BY AC0,AC1';
  dbAlbacc.Active:=False; dbAlbacc.Sql.Text:=TxtQ; dbAlbacc.Active:=True;
  dbAlbacc.First;
  //------------- Facturas a realizar
  TxtQ:='SELECT AC0,COUNT(AC3),SUM(AC4),SUM(AC4),SUM(AC5),SUM(AC8),SUM(AC9),C1 FROM albac'+Tienda+',clientes'+
        ' WHERE AC0=C0 AND AC0>='+Edit1.Text+' AND AC0<='+Edit2.Text+
        ' AND AC1>="'+FormatDateTime('yyyy-mm-dd',StrToDate(Edit7.Text))+'"'+
        ' AND AC1<="'+FormatDateTime('yyyy-mm-dd',StrToDate(Edit8.Text))+'"';
  if ComboBox4.Text<>'TODAS LAS SERIES' then TxtQ:=TxtQ+' AND AC2="'+dbSeries.FieldByName('SF0').AsString+'"';
  if Edit5.Text<>'' then TxtQ:=TxtQ+' AND C10='+Edit5.Text;
  if RadioButton2.Checked then TxtQ:=TxtQ+' AND AC10="S"';//---- Los marcados
  if RadioButton3.Checked then TxtQ:=TxtQ+' AND AC10="N"';//---- Sin Marcar
  TxtQ:=TxtQ+' GROUP BY AC0 ORDER BY AC0';
  dbMuestraf.Active:=False; dbMuestraf.Sql.Text:=TxtQ; dbMuestraf.Active:=True;
  dbMuestraf.First;
  //------------------- Sumas
  TxtQ:='SELECT SUM(AC4),SUM(AC5),SUM(AC8),SUM(AC9) FROM albac'+Tienda+',clientes'+
        ' WHERE AC0=C0 AND AC0>='+Edit1.Text+' AND AC0<='+Edit2.Text+
        ' AND AC1>="'+FormatDateTime('yyyy-mm-dd',StrToDate(Edit7.Text))+'"'+
        ' AND AC1<="'+FormatDateTime('yyyy-mm-dd',StrToDate(Edit8.Text))+'"';
  if ComboBox4.Text<>'TODAS LAS SERIES' then TxtQ:=TxtQ+' AND AC2="'+dbSeries.FieldByName('SF0').AsString+'"';
  if Edit5.Text<>'' then TxtQ:=TxtQ+' AND C10='+Edit5.Text;
  if RadioButton2.Checked then TxtQ:=TxtQ+' AND AC10="S"';//---- Los marcados
  if RadioButton3.Checked then TxtQ:=TxtQ+' AND AC10="N"';//---- Sin Marcar
  dbSumas.Active:=False; dbSumas.Sql.Text:=TxtQ; dbSumas.Active:=True;
  dbSumas.First;
  StaticText4.Caption:=IntToStr(dbAlbacc.RecordCount);//-------- N. Albaranes.
  StaticText5.Caption:=IntToStr(dbMuestraf.RecordCount);//-------- N. Facturas
  StaticText2.Caption:=dbSumas.Fields[0].AsString;//--------- N. Lineas.
  StaticText3.Caption:=FormatFloat('0.00',dbSumas.Fields[1].AsFloat);//--------- N. Articulos.
  StaticText7.Caption:=FormatFloat('0.00',dbSumas.Fields[2].AsFloat);//--------- Importe
  StaticText8.Caption:=FormatFloat('0.00',dbSumas.Fields[3].AsFloat);//--------- Importe + impuestos
  dbSumas.Active:=False;
  if dbAlbacc.RecordCount>0 then BitBtn3.Enabled:=True;

  // Un filtro nuevo restaura las cabeceras, evitando flechas antiguas.
  FOrdenGrid1Campo:='';
  FOrdenGrid2Campo:='';
  ActualizarFlechaGrid(DBGrid1, '', '');
  ActualizarFlechaGrid(DBGrid2, '', '');
end;

//=================================================================
//======================= FACTURAR ALBARANES ======================
//=================================================================
procedure TFFacturar.BitBtn3Click(Sender: TObject);
var
  TxtQ: String;
begin
  if dbAlbacc.Active=False then exit;
  if dbAlbacc.RecordCount=0 then exit;
  RestaurarOrdenFacturacionSeguro;
  TxtQ:='SE FACTURARAN '+StaticText4.Caption+' ALBARANES, CONTINUAR?';
  if Application.MessageBox(PChar(TxtQ),'FacturLinEx', boxstyle) = IDNO Then Exit;
  //--- Ver la tienda activa para saber que serie usa por defecto
  dbTiendas.Active:=False;
  dbTiendas.Sql.Text:='SELECT * FROM tiendas WHERE T0='+NTienda;
  dbTiendas.Active:=True;
  if dbTiendas.Recordcount=0 then begin Showmessage('NO SE EN QUE TIENDA FACTURAR'); Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF5<>"E" AND SF0 LIKE "%'+copy(FormatDateTime('YYYY',(now)),3,2)+'%" ORDER BY SF0';
  dbSeries.Active:=True;
  if dbSeries.RecordCount=0 then
    begin
      CheckBox1.Enabled:=True;
      dbSeries.Active:=False;
      dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF5<>"E" ORDER BY SF0';
      dbSeries.Active:=True;
    end;
  if dbSeries.RecordCount=0 then begin showmessage('DEBE CREAR UNA SERIE DE FACTURACION'); exit; end;
  dbSeries.First; ListBox1.Items.Clear;
  Label33.Caption:='N. Factura';  Label34.Caption:='Fecha Factura';
  DateEdit1.Date:=Date;
  while not dbSeries.EOF do
    begin
     ListBox1.Items.Add(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);
     dbSeries.Next;
    end;
  dbSeries.Locate('SF0', dbTiendas.Fields[11].AsString, [loCaseInsensitive]);
  ListBox1.ItemIndex:= ListBox1.Items.IndexOf(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);
  Edit21.Text:=IntToStr(dbSeries.FieldByName('SF2').AsInteger+1);
  dbTiendas.Active:=False;
  BitBtn23.Enabled:=True;
  BitBtn20.Enabled:=True;
  Panel8.Visible:=True;
  AjustarLayoutModerno;
  Panel8.BringToFront;
  ListBox1.SetFocus;
  PageControl1.Enabled:=False; BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
  BitBtn1.Enabled:=False;
  ActualizarPieAtajos;
end;

//======================== ACEPTAR FACTURAR =====================
procedure TFFacturar.BitBtn23Click(Sender: TObject);
var
  TxtQ: String;
  ok: boolean;
  pdf, Err: string;
  T0, TPrev: QWord;

  // -------------------------------------------------------------
  // PERF / DIAG: marcas de tiempo y consumos (ms) para acotar bloqueos
  // -------------------------------------------------------------
  procedure VF_PerfMark(const ATag: string);
  var
    Dt: QWord;
    Stamp: string;
  begin
    // GetTickCount64 es monotónico (ms desde arranque). Ideal para tiempos.
    Dt := GetTickCount64 - TPrev;
    Stamp := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now);
    FLX_WriteLog('FACTURAR', Stamp + ' | +' + IntToStr(Dt) + ' ms | ' + ATag);
    TPrev := GetTickCount64;
  end;

begin


T0 := GetTickCount64;
TPrev := T0;
FLX_WriteLog('FACTURAR', FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) +
  ' | +0 ms | Inicio facturación (BitBtn23Click). Tienda=' + tienda);

  label16.Enabled:=True; ProgressBar1.Enabled:=True; ProgressBar1.Max:=dbAlbacc.RecordCount;
  SFACTURA:=dbSeries.FieldByName('SF0').AsString;
  if SFACTURA='' then begin showmessage('DEBE SELECCIONAR UNA SERIE PARA FACTURAR'); Exit; end;
  ActualizarProgresoVisible(0, ProgressBar1.Max);
  BitBtn23.Enabled:=False;
  BitBtn20.Enabled:=False;
  ActualizarPieAtajos;
  vfTipoFactura:='F1';
  Hora:=Time; NumeroFactura(); NLinea:=1;
  VF_PerfMark('NumeroFactura()');
  dbAlbacc.First; AntCliente:=dbAlbacc.Fields[0].Value;
  While not dbAlbacc.Eof do
   begin
      ProgressBar1.Position:= dbAlbacc.RecNo;
      ActualizarProgresoVisible(ProgressBar1.Position, ProgressBar1.Max);
      Application.ProcessMessages;
      //---------- Si el cliente cambia, sacar nuevo n. factura.
      if AntCliente<>dbAlbacc.Fields[0].Value then
        begin
          VF_PerfMark('Antes Imprimir() (cambio de cliente)');
          try
            VF_ImprimirFromFacturar := True;
            Imprimir();
          finally
            VF_ImprimirFromFacturar := False;
          end;
          VF_PerfMark('Después Imprimir() (cambio de cliente)');
          //showmessage(IncludeTrailingPathDelimiter(RutaPdf) + 'QR.png');
          //==================================================
          //-- Inserción de la llamada a generación de PDF
          FLX_WriteLog('PDF', 'Generando PDF factura ' + SFACTURA + '-' + IntToStr(NFACTURA) + ' cliente=' + IntToStr(AntCliente));

          ok := FLX_GenerateInvoicePDF_FromDB(
                                              tienda,          // tienda
                                              SFACTURA,        // serie
                                              NFACTURA,        // número
                                              Fecha,           // fecha
                                              IntToStr(AntCliente),      // puede ser '' si es simplificada
                                              IncludeTrailingPathDelimiter(RutaIni) + 'QR.png',      // fichero QR (ya lo guardas ahí)
                                              IncludeTrailingPathDelimiter(RutaIni) + 'barcode.png', // ejemplo para barcode, o el que uses
                                              pdf
                                              );
          

                    VF_PerfMark('Después FLX_GenerateInvoicePDF_FromDB(): ok=' + BoolToStr(ok, True) + ' pdf=' + pdf);
if ok then

            FLX_WriteLog('PDF', 'PDF generado: ' + pdf)

          else

            FLX_WriteLog('PDF', 'ERROR al generar PDF (pdf=' + pdf + ')');
//-- ShowMessage('El fichero se creará en : ' + RutaPdf);

          if not ok then
            ShowMessage('Error al generar PDF')
          else
              begin
               if dbClientes.FieldByName('C55').AsBoolean then
                begin 
                  //==================================================
                  //=============== Envio Pdf por e-mail =============
                  //==================================================
                  try
                                    VF_PerfMark('Antes FLX_SendFacturaPDFMail()');
Ok := FLX_SendFacturaPDFMail(
                                              dbClientes.FieldByName('C40').AsString,
                                              CorreoCopia,
                                              ('Factura Mes Actual / Cliente # '+ dbClientes.FieldByName('C0').AsString),
                                              (' Documento que contendra LOPD y Otros como el cuerpo'),
                                              pdf,
                                              Err
                                              );
                  

                                    VF_PerfMark('Después FLX_SendFacturaPDFMail(): Ok=' + BoolToStr(Ok, True) + ' Err=' + Err);
if Ok then

                    FLX_WriteLog('EMAIL', 'Email enviado OK (pdf=' + pdf + ')')

                  else

                    FLX_WriteLog('EMAIL', 'Email NO enviado: ' + Err + ' (pdf=' + pdf + ')');
except
                    on E: Exception do
                    begin
                       FLX_WriteLog('EMAIL', 'Error al conectar al servidor SMTP: ' + E.Message);
                    end;
                  end;
                end;
                  //==================================================
                  //============FIN Envio Pdf por e-mail =============
                  //==================================================
              end;
          //-- Fin Inserción de la llamada a generación de PDF
          //==================================================
          // =================================================
          // === Veri*Factu: Encolar factura (DB/Archivos) ===
          // =================================================
          try
              VF_PerfMark('Antes VeriFactu_QueueFactura()');
VeriFactu_QueueFactura(
              SFACTURA,
              NFACTURA,
              DateEdit1.Date,
              Hora,
              // *** IMPORTANTE: TotalConIVA = FC9 (cabecera factura) ***
              dbFactuc.FieldByName('FC9').AsFloat
            );
            VF_PerfMark('Después VeriFactu_QueueFactura()');
except
                on E: Exception do
                 begin
                   Writeln('ERROR CAPTURADO: ' + E.Message);
                 end;
          end;
          // =================================================
          //-- Fin del encolado queue de Veri*Factu
          // =================================================

          AntCliente:=dbAlbacc.Fields[0].Value;
          NumeroFactura();
          Hora:=Time;
          NLinea:=1;
        end;
      TxtQ:='SELECT * FROM albad'+Tienda+' WHERE AD0='+dbAlbacc.Fields[0].AsString+
            ' AND AD1="'+FormatDateTime('yyyy-mm-dd',dbAlbacc.Fields[1].asDateTime)+'"'+
            ' AND AD2="'+dbAlbacc.Fields[2].AsString+'" AND AD3='+dbAlbacc.Fields[3].AsString+
            ' ORDER BY AD4';
      dbAlbadd.Active:=False; dbAlbadd.Sql.Text:=TxtQ;
      dbAlbadd.Active := True; dbAlbadd.First;
      while not dbAlbadd.Eof do
        begin
           ActuFactud();//---------- Detalles
           ActualizaIva(); //------- Actualiza los datos en el fichero de IVAS
           ActuHisopdd();//--------- Hist.Op. Detalles
           PasaAlbaHistoricoD();//-- Hist. Albaranes
           dbAlbadd.Next;
        end;
      ActuFactuc(); //------------- Cabeceras
      ActuHisopcc();//------------- Hist.Op. Cabeceras
      PasaAlbaHistorico();//------- Hist. Albaranes
      //------ Pend. de Facturar
      dbClientes.Active:=False;
      dbClientes.Sql.Text:='UPDATE clientes SET C20=C20-'+dbAlbacc.Fields[9].AsString+' WHERE C0='+dbAlbacc.Fields[0].AsString;
      try
        dbClientes.ExecSql;
      except
        on EDB: EDatabaseError do
        begin
          Showmessage('Error : ' + EDB.Message);
        end;
      end;
      dbClientes.Active:=False;
      dbAlbacc.Next;
   end;
  ProgressBar1.Position:=0; ActualizarProgresoVisible(0, 0);
  label16.Enabled:=False; ProgressBar1.Enabled:=False;
  VF_PerfMark('Antes Imprimir() (flush final)');
  try
    VF_ImprimirFromFacturar := True;
    Imprimir();
  finally
    VF_ImprimirFromFacturar := False;
  end;
  VF_PerfMark('Después Imprimir() (flush final)');

  //==================================================
  //-- ULTIMA VEZ O SI SOLO ES UNO (SE REPITE EN DOS PUNTOS )
  //-- Inserción de la llamada a generación de PDF
    FLX_WriteLog('PDF', 'Generando PDF factura ' + SFACTURA + '-' + IntToStr(NFACTURA) + ' cliente=' + IntToStr(AntCliente) + ' (flush final)');
  VF_PerfMark('Antes FLX_GenerateInvoicePDF_FromDB() (flush final)');
ok := FLX_GenerateInvoicePDF_FromDB(
                                      tienda,          // tienda
                                      SFACTURA,        // serie
                                      NFACTURA,        // número
                                      Fecha,           // fecha
                                      IntToStr(AntCliente),      // puede ser '' si es simplificada
                                      IncludeTrailingPathDelimiter(RutaIni) + 'QR.png',      // fichero QR (ya lo guardas ahí)
                                      IncludeTrailingPathDelimiter(RutaIni) + 'barcode.png', // ejemplo para barcode, o el que uses
                                      pdf
                                      );
  VF_PerfMark('Después FLX_GenerateInvoicePDF_FromDB() (flush final): ok=' + BoolToStr(ok, True) + ' pdf=' + pdf);

  // ShowMessage('El fichero se creará en : ' + RutaPdf);
  // =========================================================
  // === Veri*Factu: Encolar PRIMERA factura (DB/Archivos) ===
  // =========================================================
  try
        VF_PerfMark('Antes VeriFactu_QueueFactura() (flush final)');
    VeriFactu_QueueFactura(
                           SFACTURA,
                           NFACTURA,
                           DateEdit1.Date,
                           Hora,
                           // *** IMPORTANTE: TotalConIVA = FC9 (cabecera factura) ***
                           dbFactuc.FieldByName('FC9').AsFloat
                          );
    VF_PerfMark('Después VeriFactu_QueueFactura() (flush final)');

  except
        on E: Exception do
         begin
           Writeln('ERROR CAPTURADO: ' + E.Message);
         end;
  end;
  // =================================================
  //-- Fin del encolado queue de Veri*Factu
  // =================================================

  if not ok then
    ShowMessage('Error al generar PDF')
  else
      begin
           //==================================================
           //=============== Envio Pdf por e-mail =============
           //==================================================
         if dbClientes.FieldByName('C55').AsBoolean then
          begin 
           try
                               VF_PerfMark('Antes FLX_SendFacturaPDFMail() (flush final)');
Ok := FLX_SendFacturaPDFMail(
                                          dbClientes.FieldByName('C40').AsString,
                                          CorreoCopia,
                                          ('Factura Mes Actual / Cliente # '+ dbClientes.FieldByName('C0').AsString),
                                          (' Documento que contendra LOPD y Otros como el cuerpo'),
                                          pdf,
                                          Err
                                          );
                  VF_PerfMark('Después FLX_SendFacturaPDFMail() (flush final): Ok=' + BoolToStr(Ok, True) + ' Err=' + Err);

           except
             on E: Exception do
               begin
                  FLX_WriteLog('EMAIL', 'Error al conectar al servidor SMTP: ' + E.Message);
               end;
             end;
   {          if Ok then
                 //-- DataModule1.Mensaje('Información', 'Correo enviado correctamente', 2000, clGreen)
             else
                 //-- ShowMessage('Error al enviar correo: ' + Err);
                 FLX_WriteLog('EMAIL', 'Error al conectar al servidor SMTP: ' + ErrorText);
             end;
   }          //==================================================
             //============FIN Envio Pdf por e-mail =============
             //==================================================
          end;
        end;
    //-- Fin Inserción de la llamada a generación de PDF
    //==================================================

  //------------------- Borrar albaranes facturados
  //------------- Detalles
  dbAlbacc.First; AntCliente:=dbAlbacc.Fields[0].Value;
  While not dbAlbacc.Eof do
   begin
      TxtQ:='DELETE FROM albad'+Tienda+' WHERE AD0='+dbAlbacc.Fields[0].AsString+
            ' AND AD1="'+FormatDateTime('yyyy-mm-dd',dbAlbacc.Fields[1].asDateTime)+'"'+
            ' AND AD2="'+dbAlbacc.Fields[2].AsString+'" AND AD3='+dbAlbacc.Fields[3].AsString;
            dbTrabajo.SQL.Text:=TxtQ; 
      try
        dbTrabajo.ExecSQL;
      except
        on EDB: EDatabaseError do
        begin
          Showmessage('Error : ' + EDB.Message);
        end;
      end;
      dbAlbacc.Next;
   end;
  //------------- Cabeceras
  label16.Enabled:=True; ProgressBar1.Enabled:=True; ProgressBar1.Max:=dbAlbacc.RecordCount;
  ActualizarProgresoVisible(0, ProgressBar1.Max);
  dbAlbacc.First;
  While not dbAlbacc.Eof do
   begin
      ProgressBar1.Position:= dbAlbacc.RecNo;
      ActualizarProgresoVisible(ProgressBar1.Position, ProgressBar1.Max);
      Application.ProcessMessages;
      TxtQ:='DELETE FROM albac'+Tienda+' WHERE AC0='+dbAlbacc.Fields[0].AsString+
        ' AND AC1="'+FormatDateTime('yyyy-mm-dd',dbAlbacc.Fields[1].asDateTime)+'"'+
        ' AND AC2="'+dbAlbacc.Fields[2].AsString+'" AND AC3='+dbAlbacc.Fields[3].AsString;
        dbTrabajo.SQL.Text:=TxtQ; 
      try
        dbTrabajo.ExecSQL;
      except
        on EDB: EDatabaseError do
        begin
          Showmessage('Error : ' + EDB.Message);
        end;
      end;
    dbAlbacc.Next;
   end;
   ProgressBar1.Position:=0; ActualizarProgresoVisible(0, 0);
   label16.Enabled:=False; ProgressBar1.Enabled:=False;

  DataModule1.Mensaje('Información','La facturación ha sido CORRECTA ', 3000 , clGreen);
  
  vfTipoFactura:='F2'; //-- Devolvemos la variable GLOBAL a F2 - Factura Simplificada

  VF_PerfMark('Fin facturación: total=' + IntToStr(GetTickCount64 - T0) + ' ms');

  Close();

end;

//======================== MOVERSE POR LAS SERIES ==============================
procedure TFFacturar.ListBox1Click(Sender: TObject);
begin
  if dbSeries.Locate('SF0',trim(copy(ListBox1.Items.Strings[ListBox1.ItemIndex],1,3)),[]) then
     Edit21.Text:=IntToStr(dbSeries.FieldByName('SF2').AsInteger+1);
end;

//======================== CANCELAR FACTURAR =====================
procedure TFFacturar.BitBtn20Click(Sender: TObject);
begin
  Panel8.Visible:=False;
  BitBtn23.Enabled:=True;
  BitBtn20.Enabled:=True;
  PageControl1.Enabled:=True; BitBtn2.Enabled:=True; BitBtn3.Enabled:=True;
  BitBtn1.Enabled:=True;
  ActualizarPieAtajos;
end;


//======================= CABECERA DE FACTURAS ========================
procedure TFFacturar.ActuFactuc();
var
  TxtQ: String;
begin
  dbFactuc.Active:=False;
  TxtQ:='SELECT * FROM factuc'+Tienda+' WHERE FC0='+dbAlbacc.FieldByName('AC0').AsString+
        ' AND FC1="'+FormatDateTime('yyyy-mm-dd',DateEdit1.Date)+
        '" AND FC2="'+SFACTURA+'" AND FC3='+IntToStr(NFACTURA);
  dbFactuc.Sql.Text:=TxtQ; dbFactuc.Active:=True; dbFactuc.First;
  if dbFactuc.Recordcount=0 then
    begin
     dbFactuc.append;
     dbFactuc.FieldByName('FC0').Value:=dbAlbacc.FieldByName('AC0').Value;//----- Cgo. Cliente
     dbFactuc.FieldByName('FC1').AsString:=FormatDateTime('dd/mm/yyyy',DateEdit1.Date);//-- Fecha Factura
     dbFactuc.FieldByName('FC2').Value:=SFACTURA;//------------------------------- Serie Factura.
     dbFactuc.FieldByName('FC3').Value:=NFACTURA;//------------------------------- N. Factura.án
     dbFactuc.FieldByName('FC4').Value:=NLinea-1;//------------------------------- Nº Lineas
     dbFactuc.FieldByName('FC5').Value:=dbAlbacc.FieldByName('AC5').AsFloat;//---- Nº Articulos.
     dbFactuc.FieldByName('FC6').Value:=dbAlbacc.FieldByName('AC6').AsFloat;//---- Dto. Pronto Pago
     dbFactuc.FieldByName('FC7').Value:=dbAlbacc.FieldByName('AC7').AsString;//--- Recargo Equivalencia.
     dbFactuc.FieldByName('FC8').Value:=dbAlbacc.FieldByName('AC8').AsFloat;//---- Importe sin IVA
     dbFactuc.FieldByName('FC9').Value:=dbAlbacc.FieldByName('AC9').AsFloat;//---- Importe con IVA
     dbFactuc.FieldByName('FC10').Value:='N';//----------------------------------- Marcado S/N.
     dbFactuc.FieldByName('FC23').Value:='N';//----------------------------------- Pagado S/N.
     dbFactuc.FieldByName('FC24').Value:=dbAlbacc.FieldByName('C5').AsString;//-------------------- CIF
     if dbAlbacc.FieldByName('AC11').AsString<>null then dbFactuc.FieldByName('FC19').Value:=Memo1.Text+#13+#10+dbAlbacc.FieldByName('AC11').AsString else dbFactuc.FieldByName('FC19').Value:=Memo1.Text;//---------------------------- Observaciones
    end
  else
    begin
     dbFactuc.edit;
     dbFactuc.FieldByName('FC4').Value:=NLinea-1; //----------------------- Nº Lineas
     dbFactuc.FieldByName('FC5').Value:=dbFactuc.FieldByName('FC5').AsFloat+dbAlbacc.FieldByName('AC5').AsFloat;//---- Nº Articulos.
     dbFactuc.FieldByName('FC8').Value:=dbFactuc.FieldByName('FC8').AsFloat + dbAlbacc.FieldByName('AC8').AsFloat;//-- Importe sin IVA
     dbFactuc.FieldByName('FC9').Value:=dbFactuc.FieldByName('FC9').AsFloat + dbAlbacc.FieldByName('AC9').AsFloat;//-- Importe con IVA
    end;
    try
      dbFactuc.Post;
    except
      on EDB: EDatabaseError do
      begin
       Showmessage('Error : ' + EDB.Message);
      end;
    end;
end;

//======================= DETALLES DE FACTURAS ========================
procedure TFFacturar.ActuFactud();
var
  TxtQ: String;
  Conta: Integer;
begin
  dbFactud.Active:=False;
  TxtQ:='SELECT * FROM factud'+Tienda+' WHERE FD0='+dbAlbadd.Fields[0].AsString+
        ' AND FD1="'+FormatDateTime('yyyy-mm-dd',DateEdit1.Date)+'" AND FD2="'+SFACTURA+'"'+
        ' AND FD3='+IntToStr(NFACTURA);
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
           ' - '+LeftStr(dbAlbacc.FieldByName('AC11').AsString, 50);

  dbFactud.Fields[17].Value:=dbAlbadd.Fields[17].Value;//-------------- precio tarifa.
  try
    dbFactud.Post;
  except
    on EDB: EDatabaseError do
    begin
     Showmessage('Error : ' + EDB.Message);
    end;
  end;
  NLinea:=NLinea+1;
end;


//--------------------------------------------------------
//================== GRABAR IVA DE VENTAS ================
//--------------------------------------------------------

Procedure TFFacturar.ActualizaIva();
var
  TxtQ, Departa: String;
  Base, Iva, TIva : String;
begin
  //-- showmessage(TIPOOPER);
  //-- IF TIPOOPER='FA' then showmessage('OJO, UNA FACTURA');
  //-- if TIPOOPER='AL' then exit;
  //------------------- Control de Iva    (Id,Fecha, Hora,TIPOOPER,Puesto,Cliente,Operacion;Serie Factura, Base, iva, tipo de iva, total)

  TIva:=dbFactud.FieldByName('FD12').AsString;
  Base:=FloatToStr(StrToFloat(dbFactud.FieldByName('FD13').AsString)/(1+(StrToFloat(dbFactud.FieldByName('FD12').AsString)/100)));
  Iva:=FloatToStr(StrToFloat(Base)*(StrToFloat(TIva)/100));
  TxtQ:='INSERT INTO iva'+Tienda+' (Fecha,Hora,TipoOP,Puesto,Cliente,Operacion,Serie,Base,Iva,TIva,Total) VALUES ("'+FormatDateTime('yyyy-mm-dd',DateEdit1.Date)+'",'+
        '"'+FormatDateTime('HH:MM:SS',Hora)+'","FM","X","'+dbFactud.FieldByName('FD0').AsString+'",'+IntToStr(NFACTURA)+',"'+SFACTURA+
        '",'+Base+','+Iva+','+dbFactud.FieldByName('FD12').AsString+','+dbFactud.FieldByName('FD13').AsString+')';
{
  case QuestionDlg ('Actualizando Datos de IVA','Si has llegado aquí, se van ha almacenar los datos del iva',mtCustom,[mrYes,'Si', mrNo, 'No', mrCancel,'Cancelar'],'La ayuda') of
        mrYes: showmessage(TxtQ);
        mrNo:  QuestionDlg ('Se van ha almacenar igual los datos de IVA',TxtQ,mtCustom,[mrOK,'Exacto'],'');
        mrCancel: exit;
  end;
}
  //-- showmessage(TxtQ);
  dbIva.SQL.Text:=TxtQ;
  try
    dbIva.ExecSQL;
  except
   // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado al insertar IVA : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
end;


//=================== SACAR EL ULT N. DE LINEA =====================
function TFFacturar.VerUltimaLinea: Integer;
begin
  VerUltimaLinea:=1;
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT MAX(FD4) As ULTIMA FROM factud'+Tienda+' WHERE FD0='+dbAlbadd.Fields[0].AsString+
                    ' AND FD1="'+FormatDateTime('yyyy-mm-dd',DateEdit1.Date)+'" AND FD2="'+SFACTURA+'"'+
                    ' AND FD3='+IntToStr(NFACTURA);
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  VerUltimaLinea:=dbBusca.FieldByName('ULTIMA').AsInteger+1;
end;

//===================== Facturas Cab Vencimientos =======================
procedure TFFacturar.ActuFactuVen();
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
  try
    dbFactuc.Post;
  except
    on EDB: EDatabaseError do
    begin
     Showmessage('Error : ' + EDB.Message);
    end;
  end;
end;


//======================= Hist. Operaciones Cab =====================
procedure TFFacturar.ActuHisopcc();
var
  TxtQ: String;
begin

{ TODO: Falta asignar el numero de usuario que cierra la operacion }

  dbHisopcc.Active:=False;
  TxtQ:='SELECT * FROM hisopcc'+Tienda+' WHERE HO0="'+FormatDateTime('yyyy-mm-dd',DateEdit1.Date)+'"'+
        ' AND HO1="'+FormatDateTime('HH:MM:SS',Hora)+'" AND HO2="'+Puesto+'"'+
        ' AND HO3='+IntToStr(NFACTURA)+' AND HO4="'+SFACTURA+'" AND HO5="FA"';
  dbHisopcc.Sql.Text:=TxtQ; dbHisopcc.Active := True; dbHisopcc.First;
  if dbHisopcc.Recordcount=0 then
   begin
    dbHisopcc.append;
    dbHisopcc.FieldByName('HO0').AsString:=FormatDateTime('DD/MM/YYYY',DateEdit1.Date);//-- Fecha
    dbHisopcc.FieldByName('HO1').AsString:=FormatDateTime('HH:MM:SS',Hora);//-- Hora
    dbHisopcc.FieldByName('HO2').Value:=Puesto;//--- Puesto
    dbHisopcc.FieldByName('HO3').Value:=NFACTURA;//- N.Factura
    dbHisopcc.FieldByName('HO4').Value:=SFACTURA;//- Serie Factura
    dbHisopcc.FieldByName('HO5').Value:='FA';//----- Tipo opeacion
    dbHisopcc.FieldByName('HO6').Value:='FACTURADO';//------- Tipo de pago.
    dbHisopcc.FieldByName('HO7').Value:=1;//----------------- Usuario
    dbHisopcc.FieldByName('HO8').Value:=dbAlbacc.FieldByName('AC0').Value;//----- Cgo. Cliente
    dbHisopcc.FieldByName('HO9').Value:=dbAlbacc.FieldByName('AC9').AsFloat;//--- Importe total
    dbHisopcc.FieldByName('HO10').Value:=0;//-- % Dto.
    dbHisopcc.FieldByName('HO11').Value:=dbAlbacc.FieldByName('AC9').AsFloat;//-- Importe total con Dto.
    dbHisopcc.FieldByName('HO12').Value:=dbAlbacc.FieldByName('AC9').AsFloat;//-- Entrega
    dbHisopcc.FieldByName('HO13').Value:=0;//-- Cambio
    dbHisopcc.FieldByName('HO14').Value:=0;//-- Entrega Tarjeta
    dbHisopcc.FieldByName('HO15').Value:='N';//-- Marcada S/N
    dbHisopcc.FieldByName('HO19').Value:=dbAlbacc.FieldByName('C5').AsString;//------------ CIF
   end
  else
   begin
    dbHisopcc.Edit;
    dbHisopcc.FieldByName('HO9').Value:=dbHisopcc.FieldByName('HO9').AsFloat+dbAlbacc.FieldByName('AC9').AsFloat;//--- Importe total
    dbHisopcc.FieldByName('HO11').Value:=dbHisopcc.FieldByName('HO11').AsFloat+dbAlbacc.FieldByName('AC9').AsFloat;//-- Importe total con Dto.
    dbHisopcc.FieldByName('HO12').Value:=dbHisopcc.FieldByName('HO12').AsFloat+dbAlbacc.FieldByName('AC9').AsFloat;//-- Entrega
    end;
   try
     dbHisopcc.Post;
   except
     on EDB: EDatabaseError do
     begin
      Showmessage('Error : ' + EDB.Message);
     end;
   end;
  dbHisopcc.Active:=False;
end;

//======================= Hist. Operaciones Det =====================
procedure TFFacturar.ActuHisopdd();
var
  TxtQ: String;
begin
  //------------------- Historico de operaciones detalles
  TxtQ:='INSERT INTO hisopdd'+Tienda+' (HOD0,HOD1,HOD2,HOD3,HOD4,HOD5,HOD6,HOD7,HOD8,HOD9,HOD10,HOD11'+
        ',HOD12,HOD13,HOD14,HOD15,HOD16, HOD22) VALUES ("'+FormatDateTime('yyyy-mm-dd',DateEdit1.Date)+'",'+
        '"'+FormatDateTime('HH:MM:SS',Hora)+'","'+Puesto+'",'+IntToStr(NFACTURA)+',"'+SFACTURA+
        '",'+IntToStr(NLinea)+',"'+
        dbAlbadd.FieldByName('AD5').AsString+'","'+dbAlbadd.FieldByName('AD6').AsString+'",'+
        dbAlbadd.FieldByName('AD7').AsString+','+dbAlbadd.FieldByName('AD8').AsString+','+
        dbAlbadd.FieldByName('AD9').AsString+','+dbAlbadd.FieldByName('AD10').AsString+','+
        dbAlbadd.FieldByName('AD11').AsString+','+dbAlbadd.FieldByName('AD12').AsString+','+
        dbAlbadd.FieldByName('AD13').AsString+',"","'+dbAlbadd.FieldByName('AD15').AsString+'",'+
        dbAlbadd.FieldByName('AD17').AsString+')';
  //--   showmessage(TxtQ);
  dbHisopdd.SQL.Text:=TxtQ;
    try
    dbHisopdd.ExecSQL;
  except
    // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado al insertar Hisopdd : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
end;

//----------------------- Pasar los albaranes al Histórico Cab ----------------
procedure TFFacturar.PasaAlbaHistorico();
var
  TxtQ: String;
begin
{  TxtQ:='INSERT INTO hisalbac'+Tienda+' SELECT *,'+dbAlbacc.FieldByName('AC0').AsString+
        ',"'+FormatDateTime('yyyy-mm-dd',dbAlbacc.FieldByName('AC1').AsDateTime)+
        '","'+SFACTURA+'",'+IntToStr(NFACTURA)+
        ' FROM albac'+Tienda+' WHERE AC0='+dbAlbacc.FieldByName('AC0').AsString+
        ' AND AC1="'+FormatDateTime('yyyy-mm-dd',dbAlbacc.FieldByName('AC1').AsDateTime)+'"'+
        ' AND AC2="'+dbAlbacc.FieldByName('AC2').AsString+'"'+
        ' AND AC3='+dbAlbacc.FieldByName('AC3').AsString;}

  TxtQ:='INSERT INTO hisalbac'+Tienda+' SELECT ' +
        dbAlbacc.FieldByName('AC0').AsString +',"'+
        FormatDateTime('yyyy-mm-dd',dbAlbacc.FieldByName('AC1').AsDateTime)+ '","'+
        dbAlbacc.FieldByName('AC2').AsString + '",'+
        dbAlbacc.FieldByName('AC3').AsString + ','+
        dbAlbacc.FieldByName('AC4').AsString + ','+
        dbAlbacc.FieldByName('AC5').AsString + ','+
        dbAlbacc.FieldByName('AC6').AsString + ',"'+
        dbAlbacc.FieldByName('AC7').AsString + '",'+
        dbAlbacc.FieldByName('AC8').AsString + ','+
        dbAlbacc.FieldByName('AC9').AsString + ',"'+
        dbAlbacc.FieldByName('AC10').AsString+ '","'+
        dbAlbacc.FieldByName('AC11').AsString+
        '",'+dbAlbacc.FieldByName('AC0').AsString+
        ',"'+FormatDateTime('yyyy-mm-dd',dbAlbacc.FieldByName('AC1').AsDateTime)+
        '","'+SFACTURA+'",'+IntToStr(NFACTURA)+ ',"'+ dbAlbacc.FieldByName('AC12').AsString+ '" '+
        ' FROM albac'+Tienda+' WHERE AC0='+dbAlbacc.FieldByName('AC0').AsString+
        ' AND AC1="'+FormatDateTime('yyyy-mm-dd',dbAlbacc.FieldByName('AC1').AsDateTime)+'"'+
        ' AND AC2="'+dbAlbacc.FieldByName('AC2').AsString+'"'+
        ' AND AC3='+dbAlbacc.FieldByName('AC3').AsString;
  //--  showmessage(TxtQ);
  dbTrabajo.SQL.Text:=TxtQ;
  try
    dbTrabajo.ExecSQL;
  except
   // Capturamos el error específico de la capa de datos
    on EDB: EZSQLException do
    begin
      // El mensaje de EDB contendrá el mensaje de error de MariaDB
      ShowMessage('Error de Base de Datos Inesperado al insertar Hisalbac : ' + EDB.Message);
      // La aplicación sigue desde aquí.
    end;
  end;
end;

//------------------- Pasar los albaranes al historico Det ---------------------
procedure TFFacturar.PasaAlbaHistoricoD();
var
  TxtQ: String;
begin
  TxtQ:='INSERT INTO hisalbad'+Tienda+' SELECT * FROM albad'+Tienda+
        ' WHERE AD0='+dbAlbadd.FieldByName('AD0').AsString+
        ' AND AD1="'+FormatDateTime('yyyy-mm-dd',dbAlbadd.FieldByName('AD1').AsDateTime)+'"'+
        ' AND AD2="'+dbAlbadd.FieldByName('AD2').AsString+'"'+
        ' AND AD3='+dbAlbadd.FieldByName('AD3').AsString+
        ' AND AD4='+dbAlbadd.FieldByName('AD4').AsString;
    //--  showmessage(TxtQ);
  dbTrabajo.SQL.Text:=TxtQ;
  try
    dbTrabajo.ExecSQL;
  except
    // Capturamos el error específico de la capa de datos
     on EDB: EZSQLException do
     begin
       // El mensaje de EDB contendrá el mensaje de error de MariaDB
       ShowMessage('Error de Base de Datos Inesperado al insertar Hisalbad : ' + EDB.Message);
       // La aplicación sigue desde aquí.
     end;
  end;
end;

//====================== PRIMER CLIENTE =======================
procedure TFFacturar.Edit1Enter(Sender: TObject);
begin
  ControlTextoEnter(Sender);
  Edit3.Text:='';
end;
procedure TFFacturar.Edit1Exit(Sender: TObject);
begin
  ControlTextoExit(Sender);
  if Edit1.Text='' then Edit1.Text:='1';
  dbClientes.Active:=False;
  dbClientes.SQL.Text:='SELECT C0,C1,C5 FROM clientes where C0='+Edit1.Text;
  dbClientes.Active:=True;
  if dbClientes.RecordCount=0 then begin Edit3.Text:=''; exit; end;
  Edit3.Text:=dbClientes.FieldByName('C1').AsString;
end;
//======================== BUSCAR PRIMER CLIENTE =========================
procedure TFFacturar.Button1Click(Sender: TObject);
begin
  if Edit3.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit3.SetFocus; Exit; end;
  Edit1.Text := FBusquedas.IniciaBusquedas('SELECT C0, C1, C2 FROM clientes WHERE C1 LIKE "'+Edit3.Text+'%"',
           ['Codigo', ' Razón social ', ' Dirección ' ], 'C0' );
  if Edit1.Text<>'' then begin Edit1Exit(Edit1); end;
end;
procedure TFFacturar.Edit3KeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then Button1Click(Button1);
end;

//====================== ULTIMO CLIENTE =======================
procedure TFFacturar.Edit2Enter(Sender: TObject);
begin
  ControlTextoEnter(Sender);
  Edit4.Text:='';
end;
procedure TFFacturar.Edit2Exit(Sender: TObject);
begin
  ControlTextoExit(Sender);
  if Edit2.Text='' then Edit2.Text:='999998';
  dbClientes.Active:=False;
  dbClientes.SQL.Text:='SELECT C0,C1,C5 FROM clientes where C0='+Edit2.Text;
  dbClientes.Active:=True;
  if dbClientes.RecordCount=0 then begin Edit4.Text:=''; exit; end;
  Edit4.Text:=dbClientes.FieldByName('C1').AsString;
end;
//======================== BUSCAR ULTIMO CLIENTE =========================
procedure TFFacturar.Button2Click(Sender: TObject);
begin
  if Edit4.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit4.SetFocus; Exit; end;
  Edit2.Text := FBusquedas.IniciaBusquedas('SELECT C0, C1, C2 FROM clientes WHERE C1 LIKE "'+Edit4.Text+'%"',
           ['Codigo', ' Razón social ', ' Dirección ' ], 'C0' );
  if Edit2.Text<>'' then begin Edit2Exit(Edit2); end;
end;
procedure TFFacturar.Edit4KeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then Button2Click(Button2);
end;

//========================= RUTA A FACTURAR ==================
procedure TFFacturar.Edit5Enter(Sender: TObject);
begin
  ControlTextoEnter(Sender);
  Edit6.Text:='';
end;
procedure TFFacturar.Edit5Exit(Sender: TObject);
begin
  ControlTextoExit(Sender);
  if Edit5.Text='' then exit;
  dbRutas.Active:=False;
  dbRutas.SQL.Text:='SELECT RUT0,RUT1 FROM rutas'+Tienda+' where RUT0='+Edit5.Text;
  dbRutas.Active:=True;
  if dbRutas.RecordCount=0 then begin Edit6.Text:=''; exit; end;
  Edit6.Text:=dbRutas.FieldByName('RUT1').AsString;
end;
//====================== BUSCAR RUTAS =============================
 procedure TFFacturar.Button5Click(Sender: TObject);
begin
  if Edit6.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit6.SetFocus; Exit; end;
  Edit5.Text := FBusquedas.IniciaBusquedas('SELECT RUT0, RUT1 FROM rutas'+Tienda+' WHERE RUT1 LIKE "'+Edit6.Text+'%"',
           ['Codigo', ' Descripcion ' ], 'RUT0' );
  if Edit5.Text<>'' then begin Edit5Exit(Edit5); end;
end;

procedure TFFacturar.CheckBox1Click(Sender: TObject);
begin
  dbTiendas.Active:=True; Panel8.Visible:=False;
  PageControl1.Enabled:=True; BitBtn2.Enabled:=True; BitBtn3.Enabled:=True;
  BitBtn1.Enabled:=True;
  if CheckBox1.Checked then
    begin
      dbSeries.Active:=False;
      dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF5<>"E" ORDER BY SF0';
      dbSeries.Active:=True;
    end
  else
    begin
      dbSeries.Active:=False;
      dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF5<>"E"  AND SF0 LIKE "%'+copy(FormatDateTime('YYYY',(now)),3,2)+'%" ORDER BY SF0';
      dbSeries.Active:=True;
    end;
   if dbSeries.RecordCount=0 then begin showmessage('DEBE CREAR UNA SERIE DE FACTURACION'); exit; end;
   dbSeries.First; ListBox1.Items.Clear;
    Label33.Caption:='N. Factura';  Label34.Caption:='Fecha Factura';
    DateEdit1.Date:=Date;
    while not dbSeries.EOF do
      begin
       ListBox1.Items.Add(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                          dbSeries.FieldByName('SF1').AsString);
       dbSeries.Next;
      end;
    dbSeries.Locate('SF0', dbTiendas.Fields[11].AsString, [loCaseInsensitive]);
    ListBox1.ItemIndex:= ListBox1.Items.IndexOf(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                          dbSeries.FieldByName('SF1').AsString);
    Edit21.Text:=IntToStr(dbSeries.FieldByName('SF2').AsInteger+1);
    dbTiendas.Active:=False;
    BitBtn23.Enabled:=True;
    BitBtn20.Enabled:=True;
    Panel8.Visible:=True;
    AjustarLayoutModerno;
    Panel8.BringToFront;
    ListBox1.SetFocus;
    PageControl1.Enabled:=False; BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
    BitBtn1.Enabled:=False;
    ActualizarPieAtajos;
end;

procedure TFFacturar.Edit6KeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then Button5Click(Button5);
end;


//====================== PRIMERA FECHA ============================
procedure TFFacturar.Button3Click(Sender: TObject);
begin
  if Edit7.Text<>'' then CalendarDialog1.Date:=StrToDate(Edit7.Text);
  if CalendarDialog1.Execute then Edit7.Text:=FormatDateTime('DD/MM/YYYY',CalendarDialog1.Date);

end;

//====================== ULTIMA FECHA ============================
procedure TFFacturar.Button4Click(Sender: TObject);
begin
  if Edit8.Text<>'' then CalendarDialog1.Date:=StrToDate(Edit8.Text);
  if CalendarDialog1.Execute then Edit8.Text:=FormatDateTime('DD/MM/YYYY',CalendarDialog1.Date);
end;

//================= N. DE FACTURA ===========================
procedure TFFacturar.NumeroFactura();
var
  TStart, TStep: QWord;
begin
  TStart := GetTickCount64;
  TStep  := TStart;
  FLX_WriteLog('FACTURAR', FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) +
    ' | NumeroFactura(): inicio. Serie=' + SFACTURA);

  if SFACTURA='' then begin SFACTURA:='';NFACTURA:=0; Exit; end;

  dbSeries.Active:=False;
  dbSeries.SQL.Text:='UPDATE seriesfactu SET SF2=SF2+1 WHERE SF0="'+SFACTURA+'"';
  try
    dbSeries.ExecSQL;
    FLX_WriteLog('FACTURAR', FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) +
      ' | NumeroFactura(): UPDATE seriesfactu OK. +' + IntToStr(GetTickCount64 - TStep) + ' ms');
    TStep := GetTickCount64;
  except
    on EDB: EDatabaseError do
    begin
      FLX_WriteLog('FACTURAR', FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) +
        ' | NumeroFactura(): ERROR UPDATE seriesfactu: ' + EDB.Message);
      Showmessage('Error : ' + EDB.Message);
    end;
  end;

  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF0="'+SFACTURA+'"';
  dbSeries.Active:=True;

  FLX_WriteLog('FACTURAR', FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) +
    ' | NumeroFactura(): SELECT seriesfactu. +' + IntToStr(GetTickCount64 - TStep) +
    ' ms rc=' + IntToStr(dbSeries.Recordcount));
  TStep := GetTickCount64;

  if dbSeries.Recordcount=0 then exit;
  NFACTURA:=dbSeries.Fields[2].AsInteger;

  FLX_WriteLog('FACTURAR', FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) +
    ' | NumeroFactura(): NFACTURA=' + IntToStr(NFACTURA) +
    ' total=+' + IntToStr(GetTickCount64 - TStart) + ' ms');

  dbSeries.Active:=False;
end;


//==============================================================
//==================== IMPRIMIR FACTURA ========================
//==============================================================
procedure TFFacturar.Imprimir();
var
  EstadoImpresion: integer;
  TxtQ: String;
  Directo: boolean;

begin

  dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+IntToStr(AntCliente);
  dbClientes.Active:=True;
  VerVencimientos();//---------------- Ver si tiene vencimientos

  //TODO: Falta el pie de las facturas
{
  //----------- Pie de factura --------------------------
  //-------- Forma de pago
  if dbCliFac.Fields[9].AsInteger<>0 then
    begin
      dbFormaPago.Active:=False;
      dbFormaPago.SQL.Text:='SELECT * FROM formapago WHERE FPA0='+dbCliFac.Fields[9].AsString;
      dbFormaPago.Active:=True;
      if dbFormaPago.RecordCount=0 then TextoPie:='' else TextoPie:=dbFormaPago.Fields[1].AsString;
    end;
  //-------- Pago por banco/Caja
  if dbCliFac.Fields[42].AsInteger<>0 then
    begin
      TextoPie:=TextoPie+' '+dbCliFac.Fields[30].AsString+'  CC.:'+dbCliFac.Fields[31].AsString;
    end;
  CLXReport1.Report.Params.ParamByName('PIE').Value:=TextoPie;
  //----------- Traspaso a contabilidad ---------------------------------
}

  //--- COMPROBADO QUE DIRECTO TOMA EL VALOR QUE CORRESPONDE, POR DEFECTO EN FACTURAR TRUE
  Directo:= ChkBoxVisualiza.Checked;

  EstadoImpresion:= FImpresion.Imprime(dbFactud, dbFactuc, dbClientes, 'FACTURA', Directo, 1);

  if (EstadoImpresion=1) then             // La factura fue impresa.
     begin
        TxtQ:='UPDATE factuc'+Tienda+' SET FC25="S" WHERE FC0='+dbFactuc.FieldByName('FC0').AsString+
             ' AND FC1="'+FormatDateTime('yyyy-mm-dd',dbFactuc.FieldByName('FC1').AsDateTime)+'"'+
             ' AND FC2="'+dbFactuc.FieldByName('FC2').AsString+'" AND FC3='+dbFactuc.FieldByName('FC3').AsString;

         dbTrabajo.SQL.Text:=TxtQ; 
         try
           dbTrabajo.ExecSQL;
         except
           on EDB: EDatabaseError do
           begin
             Showmessage('Error : ' + EDB.Message);
           end;
         end;
     end;

   if (EstadoImpresion=2) then            // La factura fue enviada por email.
     begin
        TxtQ:='UPDATE factuc'+Tienda+' SET FC26="S" WHERE FC0='+dbFactuc.FieldByName('FC0').AsString+
             ' AND FC1="'+FormatDateTime('yyyy-mm-dd',dbFactuc.FieldByName('FC1').AsDateTime)+'"'+
             ' AND FC2="'+dbFactuc.FieldByName('FC2').AsString+'" AND FC3='+dbFactuc.FieldByName('FC3').AsString;

         dbTrabajo.SQL.Text:=TxtQ; 
         try
           dbTrabajo.ExecSQL;
         except
           on EDB: EDatabaseError do
           begin
             Showmessage('Error : ' + EDB.Message);
           end;
         end;
     end;

   if (EstadoImpresion=3) then            // La factura fue impresa y enviada.
      begin
         TxtQ:='UPDATE factuc'+Tienda+' SET FC25="S", FC26="S" WHERE FC0='+dbFactuc.FieldByName('FC0').AsString+
              ' AND FC1="'+FormatDateTime('yyyy-mm-dd',dbFactuc.FieldByName('FC1').AsDateTime)+'"'+
              ' AND FC2="'+dbFactuc.FieldByName('FC2').AsString+'" AND FC3='+dbFactuc.FieldByName('FC3').AsString;

        dbTrabajo.SQL.Text:=TxtQ; 
        try
          dbTrabajo.ExecSQL;
        except
          on EDB: EDatabaseError do
          begin
            Showmessage('Error : ' + EDB.Message);
          end;
        end;
      end;
end;

//================== VENCIMIENTOS =======================
procedure TFFacturar.VerVencimientos();//---------------- Ver si tiene vencimientos
var
  TotalFact: Double;
  Plazos: Integer;
  Dias: TDateTime;
begin
  TotalFact:=dbFactuc.FieldByName('FC9').AsFloat;
  //----------- Plazos de pagos (Vencimientos) --------------------------
  if (TotalFact>dbClientes.Fields[24].AsFloat) And (dbClientes.Fields[13].AsInteger>0) then
    begin
      Plazos:=dbClientes.Fields[15].AsInteger; if Plazos=0 then Plazos:=1;
      Dias:=DateEdit1.Date+dbClientes.Fields[13].AsInteger;
      FECHAPAGO1:=FormatDateTime('DD/MM/YYYY',Dias);
      IMPOPAGO1:=FormatFloat('0.000',TotalFact/Plazos);
      //------------------- Segundo Plazo
      if Plazos>1 then
        begin
          Dias:=Dias+dbClientes.Fields[14].AsInteger;
          FECHAPAGO2:=FormatDateTime('DD/MM/YYYY',Dias);
          IMPOPAGO2:=FormatFloat('0.000',TotalFact/Plazos);
        end;
      //------------------- Tercer Plazo
      if Plazos>2 then
        begin
          Dias:=Dias+dbCliEntes.Fields[14].AsInteger;
          FECHAPAGO3:=FormatDateTime('DD/MM/YYYY',Dias);
          IMPOPAGO3:=FormatFloat('0.000',TotalFact/Plazos);
        end;
      //------------------- Cuarto Plazo
      if Plazos>3 then
        begin
          Dias:=Dias+dbClientes.Fields[14].AsInteger;
          FECHAPAGO4:=FormatDateTime('DD/MM/YYYY',Dias);
          IMPOPAGO4:=FormatFloat('0.000',TotalFact/Plazos);
        end;
      ActuFactuVen(); //---------------- Actualizar Vencimientos en factura.
    end;
end;


initialization
  {$I facturar.lrs}

end.
