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
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit Presupuestos;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, ZConnection, ZDataset, DBGrids, db, StdCtrls, DbCtrls, LR_Class,
  LR_DBSet, LCLType, Menus, Grids, EditBtn;

type

{ TFPresupuesto }

TFPresupuesto = class(TForm)
  Bevel1: TBevel;
  Bevel2: TBevel;
  BitBtn1: TBitBtn;
  BitBtn10: TBitBtn;
  BitBtn11: TBitBtn;
  BitBtn12: TBitBtn;
  BitBtn13: TBitBtn;
  BitBtn14: TBitBtn;
  BitBtn15: TBitBtn;
  BitBtn16: TBitBtn;
  BitBtn17: TBitBtn;
  BitBtn18: TBitBtn;
  BitBtn19: TBitBtn;
  BitBtn2: TBitBtn;
  BitBtn20: TBitBtn;
  BitBtn21: TBitBtn;
  BitBtn22: TBitBtn;
  BitBtn23: TBitBtn;
  BitBtn3: TBitBtn;
  BitBtn34: TBitBtn;
  BitBtn4: TBitBtn;
  BitBtn5: TBitBtn;
  BitBtn6: TBitBtn;
  BitBtn7: TBitBtn;
  BitBtn8: TBitBtn;
  BitBtn9: TBitBtn;
  Button1: TButton;
  cbHistoricos: TComboBox;
  CheckBox1: TCheckBox;
  CheckBox2: TCheckBox;
  CheckBox4: TCheckBox;
  ComboBox1: TComboBox;
  Datasource1: TDatasource;
  Datasource2: TDatasource;
  Datasource3: TDatasource;
  DBGrid2: TDBGrid;
  dbHisopcc: TZQuery;
  dbHisopdd: TZQuery;
  dbTarifas: TZQuery;
  dbTiendas: TZQuery;
  dbBusca: TZQuery;
  dbTrabajo: TZQuery;
  dbSeries: TZQuery;
  dbLista: TZQuery;
  dbDocuc: TZQuery;
  dbDocud: TZQuery;
  dbClientes: TZQuery;
  dbArti: TZQuery;
  DBGrid1: TDBGrid;
  dbMuestrad: TZQuery;
  Edit1: TEdit;
  Edit10: TEdit;
  Edit11: TEdit;
  Edit12: TEdit;
  Edit13: TEdit;
  Edit14: TEdit;
  Edit15: TEdit;
  Edit16: TEdit;
  Edit17: TEdit;
  Edit18: TDateEdit;
  Edit19: TDateEdit;
  Edit2: TEdit;
  Edit21: TEdit;
  Edit22: TEdit;
  Edit23: TEdit;
  Edit26: TEdit;
  Edit27: TEdit;
  Edit28: TEdit;
  Edit29: TEdit;
  Edit3: TDateEdit;
  Edit4: TDateEdit;
  Edit5: TEdit;
  Edit6: TEdit;
  Edit7: TEdit;
  Edit8: TEdit;
  Edit9: TEdit;
  frDBDataSet1: TfrDBDataSet;
  frReport1: TfrReport;
  GroupBox1: TGroupBox;
  Label1: TLabel;
  Label10: TLabel;
  Label11: TLabel;
  Label12: TLabel;
  Label13: TLabel;
  Label14: TLabel;
  Label15: TLabel;
  Label16: TLabel;
  Label17: TLabel;
  Label18: TLabel;
  Label19: TLabel;
  Label20: TLabel;
  Label21: TLabel;
  Label22: TLabel;
  Label23: TLabel;
  Label24: TLabel;
  Label25: TLabel;
  Label26: TLabel;
  Label27: TLabel;
  Label28: TLabel;
  Label29: TLabel;
  Label30: TLabel;
  Label31: TLabel;
  Label32: TLabel;
  Label33: TLabel;
  Label34: TLabel;
  Label35: TLabel;
  Label36: TLabel;
  Label41: TLabel;
  Label42: TLabel;
  Label43: TLabel;
  Label44: TLabel;
  Label45: TLabel;
  LabelTotal: TLabel;
  Label2: TLabel;
  Label3: TLabel;
  Label4: TLabel;
  Label5: TLabel;
  Label6: TLabel;
  Label7: TLabel;
  Label8: TLabel;
  Label9: TLabel;
  lbActivarPrecios: TLabel;
  lbHistoricos: TLabel;
  ListBox1: TListBox;
  ListBox2: TListBox;
  ListBox3: TListBox;
  Memo1: TMemo;
  MenuItem1: TMenuItem;
  MenuItem2: TMenuItem;
  MenuItem3: TMenuItem;
  MenuItem4: TMenuItem;
  MenuItem5: TMenuItem;
  Panel1: TPanel;
  dbMuestrac: TZQuery;
  Panel11: TPanel;
  Panel2: TPanel;
  Panel3: TPanel;
  Panel4: TPanel;
  Panel5: TPanel;
  Panel6: TPanel;
  Panel7: TPanel;
  Panel8: TPanel;
  Panel9: TPanel;
  PopupMenu1: TPopupMenu;
  RadioButton1: TRadioButton;
  RadioButton2: TRadioButton;
  RadioButton3: TRadioButton;
  RadioButton4: TRadioButton;
  RadioButton5: TRadioButton;
  RadioButton6: TRadioButton;
  RadioGroup2: TRadioGroup;
  StaticText1: TStaticText;
  procedure BitBtn10Click(Sender: TObject);
  procedure BitBtn11Click(Sender: TObject);
  procedure BitBtn12Click(Sender: TObject);
  procedure BitBtn14Click(Sender: TObject);
  procedure BitBtn15Click(Sender: TObject);
  procedure BitBtn16Click(Sender: TObject);
  procedure BitBtn17Click(Sender: TObject);
  procedure BitBtn18Click(Sender: TObject);
  procedure BitBtn19Click(Sender: TObject);
  procedure BitBtn1Click(Sender: TObject);
  procedure BitBtn20Click(Sender: TObject);
  procedure BitBtn21Click(Sender: TObject);
  procedure BitBtn22Click(Sender: TObject);
  procedure BitBtn23Click(Sender: TObject);
  procedure BitBtn2Click(Sender: TObject);
  procedure BitBtn3Click(Sender: TObject);
  procedure BitBtn4Click(Sender: TObject);
  procedure BitBtn5Click(Sender: TObject);
  procedure BitBtn6Click(Sender: TObject);
  procedure BitBtn7Click(Sender: TObject);
  procedure BitBtn8Click(Sender: TObject);
  procedure BitBtn9Click(Sender: TObject);
  procedure Button1Click(Sender: TObject);
  procedure ComboBox1Change(Sender: TObject);
  procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
    DataCol: Integer; Column: TColumn; State: TGridDrawState);
  procedure DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure DBGrid1MouseUp(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
  procedure DBGrid1TitleClick(Column: TColumn);
  procedure DBGrid2DblClick(Sender: TObject);
  procedure DBGrid2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure DBGrid2TitleClick(Column: TColumn);
  procedure Edit10Enter(Sender: TObject);
  procedure Edit10Exit(Sender: TObject);
  procedure Edit12Enter(Sender: TObject);
  procedure Edit12Exit(Sender: TObject);
  procedure Edit14Enter(Sender: TObject);
  procedure Edit14Exit(Sender: TObject);
  procedure Edit16Enter(Sender: TObject);
  procedure Edit16Exit(Sender: TObject);
  procedure Edit1Enter(Sender: TObject);
  procedure Edit1Exit(Sender: TObject);
  procedure Edit23Exit(Sender: TObject);
  procedure Edit2Exit(Sender: TObject);
  procedure Edit2KeyPress(Sender: TObject; var Key: char);
  procedure Edit5Exit(Sender: TObject);
  procedure Edit6DblClick(Sender: TObject);
  procedure Edit6KeyPress(Sender: TObject; var Key: char);
  procedure Edit7Enter(Sender: TObject);
  procedure Edit7Exit(Sender: TObject);
  procedure Edit7KeyPress(Sender: TObject; var Key: char);
  procedure Edit8Enter(Sender: TObject);
  procedure Edit8Exit(Sender: TObject);
  procedure Edit9Enter(Sender: TObject);
  procedure Edit9DblClick(Sender: TObject);
  procedure Edit9Exit(Sender: TObject);
  procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  procedure FormCreate(Sender: TObject);
  procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure FormShow(Sender: TObject);
  procedure ListBox1Click(Sender: TObject);
  procedure ListBox1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure ListBox2DblClick(Sender: TObject);
  procedure ListBox2KeyPress(Sender: TObject; var Key: char);
  procedure ListBox3DblClick(Sender: TObject);
  procedure ListBox3Exit(Sender: TObject);
  procedure ListBox3KeyPress(Sender: TObject; var Key: char);
  procedure MenuItem1Click(Sender: TObject);
  procedure MenuItem2Click(Sender: TObject);
  procedure MenuItem3Click(Sender: TObject);
  procedure MenuItem4Click(Sender: TObject);
  procedure MenuItem5Click(Sender: TObject);
  procedure RadioButton1Click(Sender: TObject);
  procedure RadioButton2Click(Sender: TObject);
  procedure RadioButton3Click(Sender: TObject);
   procedure PintaCliente();
  procedure LimpiaCliente();
  procedure Llenadd();
  procedure Limpiadd();
  procedure Pintadd();
  procedure MostrarBotonesdd();
  procedure OcultarBotonesdd();
  procedure NumeroPresupuesto();
  procedure RadioButton4Click(Sender: TObject);
  procedure RadioButton5Click(Sender: TObject);
  procedure RadioButton6Click(Sender: TObject);
  procedure RadioGroup2Click(Sender: TObject);
  procedure BuscaArticulo();
  procedure ActualizaImporte();
  procedure CargaTarifas(actualiza: integer);
  procedure MuestraTarifas();
  function VerUltimaLinea: Integer;
  procedure CargaSeries();
  procedure ActuHisopcc(Modo: integer);
  procedure ActuHisopdd();
  procedure ActuHistoclie(Modo: integer);
  procedure HistCliente(Sender: TObject);
  procedure CargaValores();
  procedure CargaVariables();
  procedure ActivaPrecios();
  procedure EntraEnEdit(Sender: TObject);
  //-- Creación del procedimiento en 3 partes - parte 1 - definicion
  procedure GridSelectionLight(Sender: TObject; const Rect: TRect;
         DataCol: Integer; Column: TColumn; State: TGridDrawState);


  private
    { Diseño moderno conservador: mantiene controles, nombres y eventos originales. }
    FEstiloModernoAplicado: Boolean;
    FPanelAtajos: TPanel;
    FLabelAtajos: TLabel;
    FLabelCabeceraBusquedaArticulos: TLabel;
    FBtnCalEdit3: TSpeedButton;
    FBtnCalEdit4: TSpeedButton;
    FBtnCalEdit18: TSpeedButton;
    FBtnCalEdit19: TSpeedButton;
    procedure AplicarEstiloModerno;
    procedure CrearBotonCalendarioVisible(var AButton: TSpeedButton;
      AFecha: TDateEdit; ATag: Integer);
    procedure PrepararCalendariosVisibles;
    procedure AbrirCalendarioVisible(Sender: TObject);
    procedure PrepararPanelFiltroCliente;
    procedure AjustarLayoutModerno;
    procedure FormResizeModerno(Sender: TObject);
    procedure CrearPieAtajos;
    procedure ActualizarPieAtajos;
    { private declarations }
  public
    { public declarations }
  end;

  procedure ShowFormPresupuestos(TipoDocumento: string);
  
var
  FPresupuesto: TFPresupuesto;
  SPresupuesto: String;
  NPresupuesto: Integer;

  Tabla: integer;
  Filtro: String;
  Filtro1Txt: string=' Listado de todos los documentos';
  TablaCabecera: array [1..2] of string= ('proforc', 'presuc');
  TablaDetalle: array [1..2] of string= ('proford', 'presud');
  Documento: array [1..2] of string= ('PROFORMA', 'PRESUPUESTO');
  ListaImpreso: array [1..4] of string;
  Impreso: array [1..4] of string;

  lMarcado: integer;  // 0 = todos, 1 = no marcado, 2=marcado

  hora: TDateTime;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;
  AntColun2, TituloColumn2, Orden2: String;
  Ordenado2: Boolean;

  ValorInicial: String;   // Valor de entrada de un edit para controlar si cambió al salir.

  EstadoImpresion: integer;

implementation

uses
  Global, Funciones, Busquedas, Imprimir, calculos;
  
 { TFPresupuesto }

//================== CALENDARIOS VISIBLES ==================
procedure TFPresupuesto.CrearBotonCalendarioVisible(
  var AButton: TSpeedButton; AFecha: TDateEdit; ATag: Integer);
begin
  if not Assigned(AFecha) then Exit;

  AFecha.ButtonOnlyWhenFocused := False;
  AFecha.ButtonWidth := 27;
  AFecha.Button.Visible := True;
  AFecha.Button.Enabled := True;
  AFecha.Button.Flat := False;
  AFecha.Button.Hint := 'Abrir calendario';
  AFecha.Button.ShowHint := True;

  if not Assigned(AButton) then
  begin
    AButton := TSpeedButton.Create(Self);
    AButton.Parent := AFecha.Parent;
    AButton.Tag := ATag;
    AButton.Caption := '▼';
    AButton.ParentFont := False;
    AButton.Font.Name := 'Sans';
    AButton.Font.Height := -10;
    AButton.Hint := 'Abrir calendario';
    AButton.ShowHint := True;
    AButton.Flat := False;
    AButton.OnClick := @AbrirCalendarioVisible;
  end;

  AButton.SetBounds(
    AFecha.Left + AFecha.Width - 28,
    AFecha.Top,
    28,
    AFecha.Height
  );
  AButton.Visible := AFecha.Visible;
  AButton.Enabled := AFecha.Enabled;
  AButton.BringToFront;
end;

procedure TFPresupuesto.PrepararCalendariosVisibles;
begin
  CrearBotonCalendarioVisible(FBtnCalEdit3, Edit3, 3);
  CrearBotonCalendarioVisible(FBtnCalEdit4, Edit4, 4);
  CrearBotonCalendarioVisible(FBtnCalEdit18, Edit18, 18);
  CrearBotonCalendarioVisible(FBtnCalEdit19, Edit19, 19);
end;

procedure TFPresupuesto.AbrirCalendarioVisible(Sender: TObject);
var
  Fecha: TDateEdit;
begin
  Fecha := nil;
  if Sender is TComponent then
    case TComponent(Sender).Tag of
      3: Fecha := Edit3;
      4: Fecha := Edit4;
      18: Fecha := Edit18;
      19: Fecha := Edit19;
    end;

  if not Assigned(Fecha) then Exit;

  Fecha.Enabled := True;
  Fecha.ButtonOnlyWhenFocused := False;
  Fecha.Button.Visible := True;
  Fecha.Button.Enabled := True;
  Fecha.SetFocus;
  Fecha.Button.Click;
end;

//================== DISEÑO MODERNO CONSERVADOR ==================
procedure TFPresupuesto.AplicarEstiloModerno;
var
  CFondo, CTarjeta, CCabecera, CPrimario: TColor;
  CTexto, CTextoSuave, CVerde: TColor;
  CAmbarSuave, CAzulSuave: TColor;
  CCremaSuave, CGrisSuave, CLavandaSuave: TColor;
  I: Integer;

  procedure EstilarPanel(APanel: TPanel; AColor: TColor);
  begin
    if not Assigned(APanel) then Exit;
    APanel.ParentBackground := False;
    APanel.ParentColor := False;
    APanel.Color := AColor;
    APanel.Caption := '';
    APanel.BevelInner := bvNone;
    APanel.BevelOuter := bvNone;
    APanel.BorderWidth := 0;
  end;

  procedure AplicarBoton(ABoton: TBitBtn; AColor, ATexto: TColor;
    AResaltado: Boolean = True);
  begin
    if not Assigned(ABoton) then Exit;
    ABoton.ParentFont := False;
    ABoton.Font.Name := 'Sans';
    ABoton.Font.Height := -12;
    ABoton.Font.Color := ATexto;
    ABoton.Color := AColor;
    if AResaltado then
      ABoton.Font.Style := [fsBold]
    else
      ABoton.Font.Style := [];
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
    AGrid.GridLineColor := RGBToColor(203, 213, 225);
    AGrid.DefaultRowHeight := 24;
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

  procedure EstilarEtiqueta(ALabel: TLabel; AColor: TColor;
    ATamano: Integer; AResaltada: Boolean = False);
  begin
    if not Assigned(ALabel) then Exit;
    ALabel.ParentFont := False;
    ALabel.Font.Name := 'Sans';
    ALabel.Font.Height := ATamano;
    ALabel.Font.Color := AColor;
    if AResaltada then
      ALabel.Font.Style := [fsBold]
    else
      ALabel.Font.Style := [];
  end;

begin
  if FEstiloModernoAplicado then Exit;
  FEstiloModernoAplicado := True;

  CFondo         := RGBToColor(239, 244, 249);
  CTarjeta       := clWhite;
  CCabecera      := RGBToColor(6, 55, 86);
  CPrimario      := RGBToColor(37, 99, 235);
  CTexto         := RGBToColor(21, 38, 62);
  CTextoSuave    := RGBToColor(74, 91, 112);
  CVerde         := RGBToColor(0, 128, 72);
  CAmbarSuave    := RGBToColor(255, 246, 214);
  CAzulSuave     := RGBToColor(228, 240, 252);
  CCremaSuave    := RGBToColor(255, 248, 225);
  CGrisSuave     := RGBToColor(242, 245, 247);
  CLavandaSuave  := RGBToColor(242, 237, 250);

  KeyPreview := True;
  Color := CFondo;
  ParentFont := False;
  Font.Name := 'Sans';
  Font.Height := -12;
  Font.Color := CTexto;
  Caption := 'FacturLinEx · Gestión de ' + LowerCase(Documento[Tabla]) + 's';

  EstilarPanel(Panel5, CFondo);
  EstilarPanel(Panel1, CCabecera);
  EstilarPanel(Panel2, CAzulSuave);
  EstilarPanel(Panel3, CAzulSuave);
  PrepararPanelFiltroCliente;
  EstilarPanel(Panel4, CTarjeta);
  EstilarPanel(Panel6, CCremaSuave);
  EstilarPanel(Panel7, CGrisSuave);
  EstilarPanel(Panel8, CAzulSuave);
  EstilarPanel(Panel9, CLavandaSuave);
  EstilarPanel(Panel11, CAzulSuave);

  EstilarGrid(DBGrid1);
  EstilarGrid(DBGrid2);

  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TBitBtn then
      with TBitBtn(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -12;
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
        Font.Color := CTexto;
        Color := clWhite;
      end
    else if Components[I] is TRadioButton then
      with TRadioButton(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -11;
        Font.Color := CTexto;
      end
    else if Components[I] is TCheckBox then
      with TCheckBox(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -11;
        Font.Color := CTexto;
      end
    else if Components[I] is TListBox then
      with TListBox(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -11;
        Font.Color := CTexto;
      end
    else if Components[I] is TLabel then
      with TLabel(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -11;
        Font.Color := CTexto;
      end
    else if Components[I] is TMemo then
      with TMemo(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -11;
        Font.Color := CTexto;
        Color := clWhite;
      end
    else if Components[I] is TButton then
      with TButton(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -11;
        Font.Style := [fsBold];
      end;
  end;

  Edit3.ParentFont := False;
  Edit3.Font.Name := 'Sans';
  Edit3.Font.Height := -11;
  Edit3.Font.Color := CTexto;
  Edit3.Color := clWhite;
  Edit4.ParentFont := False;
  Edit4.Font.Name := 'Sans';
  Edit4.Font.Height := -11;
  Edit4.Font.Color := CTexto;
  Edit4.Color := clWhite;
  Edit18.ParentFont := False;
  Edit18.Font.Name := 'Sans';
  Edit18.Font.Height := -11;
  Edit18.Font.Color := CTexto;
  Edit18.Color := clWhite;
  Edit19.ParentFont := False;
  Edit19.Font.Name := 'Sans';
  Edit19.Font.Height := -11;
  Edit19.Font.Color := CTexto;
  Edit19.Color := clWhite;

  Panel5.Caption := '';

  GroupBox1.ParentFont := False;
  GroupBox1.Font.Name := 'Sans';
  GroupBox1.Font.Height := -11;
  GroupBox1.Font.Style := [fsBold];
  GroupBox1.Font.Color := CTexto;
  GroupBox1.ParentColor := False;
  GroupBox1.Color := CTarjeta;

  RadioGroup2.ParentFont := False;
  RadioGroup2.Font.Name := 'Sans';
  RadioGroup2.Font.Height := -11;
  RadioGroup2.Font.Style := [fsBold];
  RadioGroup2.Font.Color := CTexto;
  RadioGroup2.ParentColor := False;
  RadioGroup2.Color := CTarjeta;

  StaticText1.ParentFont := False;
  StaticText1.Font.Name := 'Sans';
  StaticText1.Font.Height := -11;
  StaticText1.Font.Style := [fsBold];
  StaticText1.Font.Color := CTextoSuave;
  StaticText1.Color := RGBToColor(224, 235, 242);

  EstilarEtiqueta(Label28, clWhite, -12, True);
  Label28.Color := RGBToColor(89, 94, 99);
  Label28.Transparent := False;
  Label28.Alignment := taCenter;
  Label28.Layout := tlCenter;

  EstilarEtiqueta(Label20, clWhite, -12, True);
  Label20.Color := CCabecera;
  Label20.Transparent := False;
  Label20.Alignment := taCenter;
  Label20.Layout := tlCenter;

  EstilarEtiqueta(Label25, clWhite, -12, True);
  Label25.Color := CCabecera;
  Label25.Transparent := False;
  Label25.Alignment := taCenter;
  Label25.Layout := tlCenter;

  EstilarEtiqueta(Label41, clWhite, -12, True);
  Label41.Color := CCabecera;
  Label41.Transparent := False;
  Label41.Alignment := taCenter;
  Label41.Layout := tlCenter;

  EstilarEtiqueta(LabelTotal, CVerde, -22, True);
  LabelTotal.Alignment := taRightJustify;

  AplicarBoton(BitBtn1, CPrimario, clWhite);
  AplicarBoton(BitBtn9, CVerde, clWhite);
  AplicarBoton(BitBtn10, RGBToColor(220, 38, 38), clWhite);
  AplicarBoton(BitBtn23, CPrimario, clWhite);
  AplicarBoton(BitBtn2, RGBToColor(190, 24, 24), clWhite);

  AplicarBoton(BitBtn12, CVerde, clWhite);
  AplicarBoton(BitBtn14, RGBToColor(220, 38, 38), clWhite);
  AplicarBoton(BitBtn13, CAmbarSuave, CTexto);
  AplicarBoton(BitBtn15, CVerde, clWhite);
  AplicarBoton(BitBtn16, CPrimario, clWhite);
  BitBtn16.Caption := 'Observ.';
  AplicarBoton(BitBtn5, RGBToColor(190, 24, 24), clWhite);

  AplicarBoton(BitBtn3, CPrimario, clWhite);
  AplicarBoton(BitBtn4, CPrimario, clWhite);
  AplicarBoton(BitBtn7, CAzulSuave, CPrimario);
  AplicarBoton(BitBtn8, CVerde, clWhite);
  AplicarBoton(BitBtn6, RGBToColor(220, 38, 38), clWhite);
  AplicarBoton(BitBtn11, CAzulSuave, CPrimario);
  AplicarBoton(BitBtn34, CPrimario, clWhite);
  AplicarBoton(BitBtn17, RGBToColor(220, 38, 38), clWhite);
  AplicarBoton(BitBtn18, CVerde, clWhite);
  AplicarBoton(BitBtn19, CVerde, clWhite);
  AplicarBoton(BitBtn20, RGBToColor(220, 38, 38), clWhite);
  AplicarBoton(BitBtn21, CVerde, clWhite);
  AplicarBoton(BitBtn22, RGBToColor(220, 38, 38), clWhite);

  DBGrid2.OnTitleClick := @DBGrid2TitleClick;

  // Cabecera del desplegable interno de búsqueda por descripción.
  if not Assigned(FLabelCabeceraBusquedaArticulos) then
  begin
    FLabelCabeceraBusquedaArticulos := TLabel.Create(Self);
    FLabelCabeceraBusquedaArticulos.Name := 'lblCabeceraBusquedaArticulos';
    FLabelCabeceraBusquedaArticulos.Parent := Panel6;
    FLabelCabeceraBusquedaArticulos.AutoSize := False;
    FLabelCabeceraBusquedaArticulos.ParentColor := False;
    FLabelCabeceraBusquedaArticulos.Color := TColor($00F4E8D8);
    FLabelCabeceraBusquedaArticulos.Transparent := False;
    FLabelCabeceraBusquedaArticulos.ParentFont := False;
    FLabelCabeceraBusquedaArticulos.Font.Name := 'Monospace';
    FLabelCabeceraBusquedaArticulos.Font.Size := 9;
    FLabelCabeceraBusquedaArticulos.Font.Style := [fsBold];
    FLabelCabeceraBusquedaArticulos.Font.Color := clBlack;
    FLabelCabeceraBusquedaArticulos.Caption :=
      Format('%-12s %-38s %-12s %10s %-12s',
        ['Código', 'Descripción', 'Últ. compra', 'PVP', 'Últ. venta']);
    FLabelCabeceraBusquedaArticulos.Visible := False;
  end;

  ListBox3.ParentFont := False;
  ListBox3.Font.Name := 'Monospace';
  ListBox3.Font.Size := 9;
  ListBox3.Font.Color := clBlack;
  ListBox3.Color := clWhite;

  CrearPieAtajos;
  ActualizarPieAtajos;
  OnResize := @FormResizeModerno;
  AjustarLayoutModerno;
  PrepararCalendariosVisibles;
end;

// Garantiza que el filtro «De un cliente» conserve una jerarquía y
// geometría independientes de los AnchorSide heredados del LFM original.
// Algunos temas/gestores GTK recalculaban esos anclajes al hacer visible
// Panel2 y lo dejaban oculto o fuera de la zona superior.
procedure TFPresupuesto.PrepararPanelFiltroCliente;
const
  CAzulSuave = TColor($00FCF0E4);
  CTexto = TColor($003E2615);
  CPrimario = TColor($00EB6325);
  CVerde = TColor($00488000);

  procedure LimpiarAnclajes(AControl: TControl);
  begin
    if not Assigned(AControl) then Exit;
    AControl.Align := alNone;
    AControl.Anchors := [akTop, akLeft];
    AControl.AnchorSideLeft.Control := nil;
    AControl.AnchorSideTop.Control := nil;
    AControl.AnchorSideRight.Control := nil;
    AControl.AnchorSideBottom.Control := nil;
  end;

begin
  // Se reutilizan los controles originales y sus eventos; solo se normaliza
  // su Parent y sus anclajes para impedir que queden detrás del grid.
  Panel2.Parent := Panel5;
  LimpiarAnclajes(Panel2);
  Panel2.AutoSize := False;
  Panel2.Enabled := True;
  Panel2.ParentBackground := False;
  Panel2.ParentColor := False;
  Panel2.Color := CAzulSuave;
  Panel2.BevelInner := bvNone;
  Panel2.BevelOuter := bvNone;
  Panel2.BorderWidth := 1;
  Panel2.Caption := '';

  Label1.Parent := Panel2;
  Label35.Parent := Panel2;
  Edit1.Parent := Panel2;
  Edit2.Parent := Panel2;
  BitBtn7.Parent := Panel2;
  BitBtn3.Parent := Panel2;

  LimpiarAnclajes(Label1);
  LimpiarAnclajes(Label35);
  LimpiarAnclajes(Edit1);
  LimpiarAnclajes(Edit2);
  LimpiarAnclajes(BitBtn7);
  LimpiarAnclajes(BitBtn3);

  Label1.ParentColor := False;
  Label1.Transparent := False;
  Label1.Color := CAzulSuave;
  Label1.ParentFont := False;
  Label1.Font.Name := 'Sans';
  Label1.Font.Size := 9;
  Label1.Font.Style := [fsBold];
  Label1.Font.Color := CTexto;
  Label1.Caption := 'Código cliente';

  Label35.ParentColor := False;
  Label35.Transparent := False;
  Label35.Color := CAzulSuave;
  Label35.ParentFont := False;
  Label35.Font.Name := 'Sans';
  Label35.Font.Size := 9;
  Label35.Font.Style := [fsBold];
  Label35.Font.Color := CTexto;
  Label35.Caption := 'Razón social';

  Edit1.ParentFont := False;
  Edit1.Font.Name := 'Sans';
  Edit1.Font.Size := 10;
  Edit1.Font.Color := clBlack;
  Edit1.Color := clWhite;
  Edit1.BorderStyle := bsSingle;
  Edit1.Enabled := True;
  Edit1.ReadOnly := False;
  Edit1.TabStop := True;

  Edit2.ParentFont := False;
  Edit2.Font.Name := 'Sans';
  Edit2.Font.Size := 10;
  Edit2.Font.Color := clBlack;
  Edit2.Color := clWhite;
  Edit2.BorderStyle := bsSingle;
  Edit2.Enabled := True;
  Edit2.ReadOnly := False;
  Edit2.TabStop := True;

  BitBtn7.ParentFont := False;
  BitBtn7.Font.Color := CPrimario;
  BitBtn7.Color := clWhite;
  BitBtn7.Enabled := True;

  BitBtn3.ParentFont := False;
  BitBtn3.Font.Color := clWhite;
  BitBtn3.Font.Style := [fsBold];
  BitBtn3.Color := CVerde;
  BitBtn3.Enabled := True;
end;

procedure TFPresupuesto.AjustarLayoutModerno;
var
  W, Resto, WNombre: Integer;
begin
  if not FEstiloModernoAplicado then Exit;

  GroupBox1.SetBounds(18, 10, 175, 108);
  RadioGroup2.SetBounds(205, 10, 175, 108);

  RadioButton1.SetBounds(400, 10, 265, 22);
  RadioButton3.SetBounds(400, 38, 250, 22);
  RadioButton2.SetBounds(400, 66, 230, 22);
  ComboBox1.SetBounds(400, 92, 260, 28);

  PrepararPanelFiltroCliente;

  // Panel de cliente independiente de los anclajes del LFM. El ancho nunca
  // se fuerza más allá de la ventana, evitando que desaparezca en monitores
  // de menor resolución.
  W := Panel5.ClientWidth - 695;
  if W < 320 then W := 320;
  if W > Panel5.ClientWidth - 688 then W := Panel5.ClientWidth - 688;
  if W < 260 then W := 260;
  Panel2.SetBounds(680, 10, W, 108);

  Panel3.Align := alNone;
  Panel3.Anchors := [akTop, akLeft];
  Panel3.AnchorSideLeft.Control := nil;
  Panel3.AnchorSideTop.Control := nil;
  Panel3.AnchorSideRight.Control := nil;
  Panel3.AnchorSideBottom.Control := nil;
  Panel3.SetBounds(680, 10, W, 86);

  Label1.SetBounds(16, 8, 126, 17);
  Edit1.SetBounds(16, 29, 112, 30);
  BitBtn7.SetBounds(136, 29, 36, 30);
  Label35.SetBounds(188, 8, 130, 17);
  BitBtn3.SetBounds(Panel2.ClientWidth - 118, 28, 100, 32);
  Edit2.SetBounds(188, 29, BitBtn3.Left - 200, 30);
  if Edit2.Width < 90 then Edit2.Width := 90;

  Label2.SetBounds(16, 8, 110, 15);
  Edit3.SetBounds(16, 28, 132, 30);
  Label3.SetBounds(170, 8, 110, 15);
  Edit4.SetBounds(170, 28, 132, 30);
  BitBtn4.SetBounds(324, 27, 105, 32);

  StaticText1.SetBounds(10, 128, Panel5.ClientWidth - 20, 26);
  DBGrid1.SetBounds(5, 160, Panel5.ClientWidth - 10,
    Panel5.ClientHeight - 161);

  PrepararCalendariosVisibles;

  if DBGrid1.Columns.Count >= 11 then
  begin
    W := DBGrid1.ClientWidth - 34;
    DBGrid1.Columns[0].Width := 86;
    DBGrid1.Columns[1].Width := 52;
    DBGrid1.Columns[2].Width := 72;
    DBGrid1.Columns[3].Width := 88;
    DBGrid1.Columns[4].Width := 70;
    DBGrid1.Columns[6].Width := 34;
    DBGrid1.Columns[7].Width := 72;
    DBGrid1.Columns[8].Width := 96;
    DBGrid1.Columns[9].Width := 72;
    Resto := W - (86 + 52 + 72 + 88 + 70 + 34 + 72 + 96 + 72);
    if Resto < 420 then Resto := 420;
    WNombre := (Resto * 58) div 100;
    DBGrid1.Columns[5].Width := WNombre;
    DBGrid1.Columns[10].Width := Resto - WNombre;
  end;

  Panel4.SetBounds(8, 3, Panel5.ClientWidth - 16, 160);
  DBGrid2.SetBounds(5, 168, Panel5.ClientWidth - 10,
    Panel5.ClientHeight - 169);

  if DBGrid2.Columns.Count >= 10 then
  begin
    W := DBGrid2.ClientWidth - 34;
    DBGrid2.Columns[0].Width := 92;
    DBGrid2.Columns[2].Width := 72;
    DBGrid2.Columns[3].Width := 74;
    DBGrid2.Columns[4].Width := 74;
    DBGrid2.Columns[5].Width := 84;
    DBGrid2.Columns[6].Width := 62;
    DBGrid2.Columns[7].Width := 84;
    DBGrid2.Columns[8].Width := 54;
    DBGrid2.Columns[9].Width := 86;
    Resto := W - (92 + 72 + 74 + 74 + 84 + 62 + 84 + 54 + 86);
    if Resto < 280 then Resto := 280;
    DBGrid2.Columns[1].Width := Resto;
  end;

  LabelTotal.SetBounds(Panel4.ClientWidth - 300, 8, 282, 48);

  Panel1.Height := 62;
  BitBtn1.SetBounds(12, 12, 112, 38);
  BitBtn9.SetBounds((Panel1.ClientWidth * 28 div 100) - 56, 12, 112, 38);
  BitBtn10.SetBounds((Panel1.ClientWidth * 50 div 100) - 56, 12, 112, 38);
  BitBtn23.SetBounds((Panel1.ClientWidth * 72 div 100) - 56, 12, 112, 38);
  BitBtn2.SetBounds(Panel1.ClientWidth - 124, 12, 112, 38);

  BitBtn12.SetBounds(12, 12, 112, 38);
  BitBtn14.SetBounds((Panel1.ClientWidth * 22 div 100) - 56, 12, 112, 38);
  BitBtn13.SetBounds((Panel1.ClientWidth * 40 div 100) - 56, 12, 112, 38);
  BitBtn15.SetBounds((Panel1.ClientWidth * 58 div 100) - 56, 12, 112, 38);
  BitBtn16.SetBounds((Panel1.ClientWidth * 76 div 100) - 56, 12, 112, 38);
  BitBtn5.SetBounds(Panel1.ClientWidth - 124, 12, 112, 38);

  // Editor de líneas más amplio y con una distribución uniforme.
  // Se adapta al ancho disponible para no salir de pantalla en resoluciones bajas.
  W := Panel5.ClientWidth - 24;
  if W > 920 then W := 920;
  if W < 760 then
  begin
    W := Panel5.ClientWidth - 16;
    if W < 640 then W := 640;
  end;

  Panel6.SetBounds((Panel5.ClientWidth - W) div 2,
    (Panel5.ClientHeight - 350) div 2, W, 340);
  if Panel6.Left < 8 then Panel6.Left := 8;
  if Panel6.Top < 112 then Panel6.Top := 112;

  Label28.SetBounds(0, 0, Panel6.ClientWidth, 34);

  // Primera fila: artículo, descripción y total de la línea.
  Label11.SetBounds(20, 45, 112, 16);
  Edit5.SetBounds(20, 64, 112, 28);
  BitBtn11.SetBounds(138, 62, 36, 32);
  Label12.SetBounds(190, 45, Panel6.ClientWidth - 410, 16);
  Edit6.SetBounds(190, 64, Panel6.ClientWidth - 410, 28);
  Label19.SetBounds(Panel6.ClientWidth - 198, 45, 174, 16);
  Edit13.SetBounds(Panel6.ClientWidth - 198, 64, 174, 28);

  // Segunda fila: datos económicos repartidos en siete columnas iguales.
  Resto := (Panel6.ClientWidth - 40) div 7;
  Label13.SetBounds(20, 112, Resto - 12, 16);
  Edit7.SetBounds(20, 131, Resto - 12, 28);
  Label36.SetBounds(20 + Resto, 112, Resto - 12, 16);
  Edit23.SetBounds(20 + Resto, 131, Resto - 12, 28);
  Label14.SetBounds(20 + (Resto * 2), 112, Resto - 12, 16);
  Edit8.SetBounds(20 + (Resto * 2), 131, Resto - 12, 28);
  Label15.SetBounds(20 + (Resto * 3), 112, Resto - 12, 16);
  Edit9.SetBounds(20 + (Resto * 3), 131, Resto - 12, 28);
  Label16.SetBounds(20 + (Resto * 4), 112, Resto - 12, 16);
  Edit10.SetBounds(20 + (Resto * 4), 131, Resto - 12, 28);
  Label17.SetBounds(20 + (Resto * 5), 112, Resto - 12, 16);
  Edit11.SetBounds(20 + (Resto * 5), 131, Resto - 12, 28);
  Label18.SetBounds(20 + (Resto * 6), 112, Resto - 12, 16);
  Edit12.SetBounds(20 + (Resto * 6), 131, Resto - 12, 28);

  // Tercera fila: históricos, información y acciones.
  lbHistoricos.SetBounds(20, 190, 132, 16);
  cbHistoricos.SetBounds(20, 208, 132, 29);
  BitBtn34.SetBounds(164, 207, 120, 31);
  lbActivarPrecios.SetBounds(304, 213, 280, 16);
  BitBtn8.SetBounds(Panel6.ClientWidth - 214, 286, 94, 34);
  BitBtn6.SetBounds(Panel6.ClientWidth - 108, 286, 94, 34);

  // Búsqueda por descripción: ocupa casi todo el ancho del editor y
  // muestra cabecera y varias columnas comerciales del artículo.
  if Assigned(FLabelCabeceraBusquedaArticulos) then
    FLabelCabeceraBusquedaArticulos.SetBounds(16, 92, Panel6.ClientWidth - 32, 25);
  ListBox3.SetBounds(16, 117, Panel6.ClientWidth - 32, 178);
  ListBox2.SetBounds(292, 176, 298, 92);

  Panel7.SetBounds((Panel5.ClientWidth - 700) div 2,
    (Panel5.ClientHeight - 200) div 2, 700, 190);
  if Panel7.Left < 8 then Panel7.Left := 8;
  if Panel7.Top < 112 then Panel7.Top := 112;
  Label20.SetBounds(0, 0, Panel7.ClientWidth, 34);
  Memo1.SetBounds(16, 48, Panel7.ClientWidth - 32, 92);
  BitBtn18.SetBounds(480, 151, 96, 30);
  BitBtn17.SetBounds(588, 151, 96, 30);

  Panel8.SetBounds((Panel5.ClientWidth - 560) div 2,
    (Panel5.ClientHeight - 245) div 2, 560, 235);
  if Panel8.Left < 8 then Panel8.Left := 8;
  ListBox1.SetBounds(12, 12, Panel8.ClientWidth - 24, 112);
  Label26.SetBounds(18, 136, 100, 18);
  Edit21.SetBounds(120, 132, 105, 30);
  Label27.SetBounds(246, 136, 110, 18);
  Edit22.SetBounds(360, 132, 130, 30);
  CheckBox4.SetBounds(18, 170, 260, 22);
  BitBtn19.SetBounds(340, 190, 96, 32);
  BitBtn20.SetBounds(448, 190, 96, 32);

  Panel9.SetBounds((Panel5.ClientWidth - 720) div 2,
    (Panel5.ClientHeight - 285) div 2, 720, 275);
  if Panel9.Left < 8 then Panel9.Left := 8;
  Label25.SetBounds(0, 0, Panel9.ClientWidth, 34);
  Label21.SetBounds(20, 52, 100, 18);
  Edit14.SetBounds(125, 48, 90, 30);
  Edit15.SetBounds(225, 48, Panel9.ClientWidth - 245, 30);
  Label22.SetBounds(20, 90, 100, 18);
  Edit16.SetBounds(125, 86, 90, 30);
  Edit17.SetBounds(225, 86, Panel9.ClientWidth - 245, 30);
  Label23.SetBounds(20, 138, 90, 18);
  Edit18.SetBounds(125, 134, 145, 30);
  Label24.SetBounds(300, 138, 90, 18);
  Edit19.SetBounds(395, 134, 145, 30);
  BitBtn21.SetBounds(500, 220, 96, 32);
  BitBtn22.SetBounds(608, 220, 96, 32);

  Panel11.Left := (Panel5.ClientWidth - Panel11.Width) div 2;
  Panel11.Top := (Panel5.ClientHeight - Panel11.Height) div 2;

  PrepararCalendariosVisibles;
end;

procedure TFPresupuesto.FormResizeModerno(Sender: TObject);
begin
  AjustarLayoutModerno;
end;

procedure TFPresupuesto.CrearPieAtajos;
const
  CBarra = TColor($0033210F);
begin
  if Assigned(FPanelAtajos) then Exit;

  FPanelAtajos := TPanel.Create(Self);
  FPanelAtajos.Name := 'pnlAtajosPresupuestosModerno';
  FPanelAtajos.Parent := Self;
  FPanelAtajos.Align := alBottom;
  FPanelAtajos.Height := 28;
  FPanelAtajos.BevelOuter := bvNone;
  FPanelAtajos.ParentBackground := False;
  FPanelAtajos.ParentColor := False;
  FPanelAtajos.Color := CBarra;
  FPanelAtajos.Caption := '';

  FLabelAtajos := TLabel.Create(Self);
  FLabelAtajos.Name := 'lblAtajosPresupuestosModerno';
  FLabelAtajos.Parent := FPanelAtajos;
  FLabelAtajos.Align := alClient;
  FLabelAtajos.Alignment := taCenter;
  FLabelAtajos.Layout := tlCenter;
  FLabelAtajos.AutoSize := False;
  FLabelAtajos.Transparent := True;
  FLabelAtajos.ParentFont := False;
  FLabelAtajos.Font.Name := 'Sans';
  FLabelAtajos.Font.Height := -12;
  FLabelAtajos.Font.Style := [fsBold];
  FLabelAtajos.Font.Color := clWhite;
end;

procedure TFPresupuesto.ActualizarPieAtajos;
begin
  if not Assigned(FLabelAtajos) then Exit;

  if Panel11.Visible then
    FLabelAtajos.Caption :=
      'ESC Cerrar información de recuperación'
  else if Panel7.Visible then
    FLabelAtajos.Caption :=
      'Ctrl+O Observaciones   ·   F8 Guardar observaciones   ·   ESC Cancelar'
  else if Panel6.Visible then
    FLabelAtajos.Caption :=
      'F1 Activar precios   ·   F5 Cantidad   ·   F6 Descuento   ·   F7 Precio   ·   F8 Aceptar línea   ·   F11 Tarifas   ·   F12 Buscar artículo   ·   ESC Finalizar'
  else if Panel9.Visible then
    FLabelAtajos.Caption :=
      'F8 Generar listado   ·   ESC Cancelar'
  else if Panel8.Visible then
    FLabelAtajos.Caption :=
      'F8 Aceptar documento   ·   ESC Cancelar'
  else if DBGrid2.Visible then
    FLabelAtajos.Caption :=
      'Ctrl+O Observaciones   ·   F2 Nueva línea   ·   F3 Borrar línea   ·   F4 Modificar   ·   F10 Observaciones   ·   F11 Imprimir   ·   ESC Volver'
  else
    FLabelAtajos.Caption :=
      'T Todos   ·   C Cliente   ·   F Fechas   ·   F1 Gestionar   ·   F2 Nuevo   ·   F3 Borrar   ·   F11 Listado   ·   F12 Buscar cliente   ·   ESC Cerrar';
end;

//=============== Crea el formulario ================
procedure ShowFormPresupuestos(TipoDocumento: string);
begin
  ListaImpreso[1]:='/usr/share/facturlinex2/Report/ListaProformas.lrf';
  ListaImpreso[2]:='/usr/share/facturlinex2/Report/ListaPresupuestos.lrf';
  ListaImpreso[3]:=RutaReports+'ListaProformas.lrf';
  ListaImpreso[4]:=RutaReports+'ListaPresupuestos.lrf';
  Tabla:=2;
  if TipoDocumento='PROFORMA' then Tabla:=1;
  with TFPresupuesto.Create(Application) do
    begin
       ShowModal;
    end;
end;

//=================== CONTROL DE COLOR LINEA SELECCIONADA ===========
//-- Creación del procedimiento en 3 partes - parte 2 - procedimiento
procedure TFPresupuesto.GridSelectionLight(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  G: TDBGrid;
begin
  G := TDBGrid(Sender);

  // Solo cambiamos la fila seleccionada
  if (gdSelected in State) then
  begin
    G.Canvas.Brush.Color := RGBToColor(191, 219, 254);
    G.Canvas.Font.Color := clBlack;
    G.Canvas.FillRect(Rect);
    G.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end
  else
  begin
    // Para el resto, dejamos el comportamiento normal (tema/colores por defecto)
    G.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
end;

//======================= CREAR FORMULARIO ==========================
procedure TFPresupuesto.FormCreate(Sender: TObject);
Var
  i: Integer;
begin
  ShortDateFormat:='DD/MM/YYYY';

  //-- Cambiamos el color por defecto de la linea seleccionada
  //-- Creación del procedimiento en 3 partes - parte 3 - Todos los DBGrid del Form en estas 3 líneas
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TDBGrid then
      TDBGrid(Components[i]).OnDrawColumnCell := @GridSelectionLight;

  // Conectate(dbConect);            // Utilizamos datamodule1.dbConexion para toda la aplicación.

  //------------------- Tablas ------------------
  //-- MID(PRC11,1,250)
  dbMuestrac.Sql.Text:='SELECT *,CONVERT(PRC11 USING UTF8) as PRNOTAS,C1 FROM '+TablaCabecera[Tabla]+Tienda+', clientes WHERE PRC0=C0 ORDER BY PRC2 ASC, PRC1 DESC, PRC3 DESC';
  dbMuestrac.Active := True;
  Panel4.SendToBack; Panel4.Visible:=False;
  DBGrid2.SendToBack; DBGrid2.Visible:=False;
  //------------- Chequear ivas
  if IVA1=0 then showmessage('DEBE DEFINIR LOS TIPOS DE IVA EN LA CONFIGURACION');
  //------------ Configuro etiquetas presupuestos/proformas ------
  self.Caption:= Documento[Tabla] + ' de clientes ';
  label29.Caption:= Documento[Tabla];
  label25.Caption:= 'LISTADO DE '+Documento[Tabla];
  label26.Caption:='N.'+Documento[Tabla];
  label27.Caption:='Fecha '+Documento[Tabla];
  label29.Caption:=Documento[Tabla];
  label32.Caption:='FECHA '+Documento[Tabla];
  Filtro:='';
  if Tabla=1 then GroupBox1.Caption:=' Proformas  ' else GroupBox1.Caption:=' Presupuestos  ';
  StaticText1.Caption:= Filtro1Txt+' ordenados por fechas';
  //-------------------- Tiendas
  dbTiendas.Active:=False;
  dbTiendas.Sql.Text:='SELECT * FROM tiendas WHERE T0='+NTienda;
  dbTiendas.Active:=True;
  if dbTiendas.Recordcount=0 then begin Showmessage('NO SE EN QUE TIENDA HACER EL ALBARAN'); Close(); end;
  //------------- Cargar Series
  CargaSeries();//----- Cargar Series de facturacion
  if dbSeries.RecordCount=0 then begin showmessage('DEBE CREAR UNA SERIE DE FACTURACION'); Close(); end;

  //------------- Sólo documentos de la serie activa
  ComboBox1.Text:=Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                         dbSeries.FieldByName('SF1').AsString;
  ComboBox1Change(self);

  AntColun:='0';Ordenado:=False; Orden:='DESC';
  AntColun2:='0';Ordenado2:=False; Orden2:='DESC';

  AplicarEstiloModerno;
  ActualizarPieAtajos;
end;

//=============  FILTRADO DE DOCUMENTOS A VER ===============

procedure TFPresupuesto.RadioButton4Click(Sender: TObject);
begin
  Filtro:='';
  Filtro1Txt:=' Listado de todos los documentos';
  if RadioButton1.Checked then RadioButton1Click(self);
  if RadioButton2.Checked then RadioButton2Click(self);
  if RadioButton3.Checked then RadioButton3Click(self);
end;

procedure TFPresupuesto.RadioButton5Click(Sender: TObject);
begin
  Filtro:=' AND PRC12<>"SV" AND PRC12<>"" ';
  Filtro1Txt:=' Documentos recuperados';
  if RadioButton1.Checked then RadioButton1Click(self);
  if RadioButton2.Checked then RadioButton2Click(self);
  if RadioButton3.Checked then RadioButton3Click(self);
end;

procedure TFPresupuesto.RadioButton6Click(Sender: TObject);
begin
  Filtro:=' AND (PRC12="SV" OR PRC12="") ';
  Filtro1Txt:=' Documentos pendientes de recuperar';
  if RadioButton1.Checked then RadioButton1Click(self);
  if RadioButton2.Checked then RadioButton2Click(self);
  if RadioButton3.Checked then RadioButton3Click(self);
end;

//============== TODO LOS PRESUPUESTOS =====================
procedure TFPresupuesto.RadioButton1Click(Sender: TObject);
begin
  Panel2.Visible:=False;
  Panel3.Visible:=False;
  //-- MID(PRC11,1,250)
  dbMuestrac.Sql.Text:='SELECT *, CONVERT(PRC11 USING UTF8) as PRNOTAS,C1 FROM '+TablaCabecera[Tabla]+Tienda+', clientes WHERE PRC0=C0 '+Filtro+'ORDER BY PRC2 ASC, PRC1 DESC, PRC3 DESC';
  dbMuestrac.Active := True;
  DBGrid1.SetFocus;
  StaticText1.Caption:= Filtro1Txt+' ordenados por fechas';
end;

//============== PESUPUESTOS DE UN CLIENTE ========================
procedure TFPresupuesto.RadioButton2Click(Sender: TObject);
begin
  // Primero se normalizan Parent y AnchorSide; después se muestra el panel.
  // Este orden evita que GTK recalcule la geometría al hacerlo visible.
  Panel3.Visible:=False;
  PrepararPanelFiltroCliente;
  AjustarLayoutModerno;

  Label1.Show;
  Label35.Show;
  Edit1.Show;
  Edit2.Show;
  BitBtn7.Show;
  BitBtn3.Show;
  Panel2.Enabled:=True;
  Panel2.Show;
  Panel2.BringToFront;

  // Los controles hijos quedan por encima incluso con temas GTK que
  // conservan el orden visual anterior al cambiar Parent.
  Label1.BringToFront;
  Label35.BringToFront;
  Edit1.BringToFront;
  Edit2.BringToFront;
  BitBtn7.BringToFront;
  BitBtn3.BringToFront;
  Panel2.Invalidate;
  Panel2.Repaint;

  StaticText1.Caption:= Filtro1Txt+' de un cliente ordenados por fechas';
  if Edit1.CanFocus then Edit1.SetFocus;
end;
procedure TFPresupuesto.BitBtn3Click(Sender: TObject);
begin
  If Edit1.Text='' then Exit;
  //-- MID(PRC11,1,250)
  dbMuestrac.Sql.Text:='SELECT *,CONVERT(PRC11 USING UTF8) as PRNOTAS,C1 FROM '+TablaCabecera[Tabla]+Tienda+', clientes WHERE PRC0=C0 AND PRC0='+Edit1.Text+ Filtro+ ' ORDER BY PRC2 ASC, PRC1 DESC, PRC3 DESC';
  dbMuestrac.Active := True;
  If dbMuestrac.RecordCount=0 then
    begin
      Showmessage('NO HAY '+Documento[Tabla]+' ES DE ESTE CLIENTE');
      exit;
    end;

end;
//=================== CGO CLIENTE FLITRADO =======================
procedure TFPresupuesto.Edit1Enter(Sender: TObject);
begin
   Edit2.Text:='';
end;
procedure TFPresupuesto.Edit1Exit(Sender: TObject);
begin
   if Edit1.Text='' then Exit;
   if not (EsFloat(Edit1.Text)) then begin Edit1.Text:='0'; Edit1.SetFocus; exit; end;
   dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+Edit1.Text;
   dbClientes.Active:=True;
   If dbClientes.RecordCount=0 then
                               Begin    // Showmessage('ESE CLIENTE NO EXISTE.');
                                 BitBtn7Click(self);
                                 Edit2.SetFocus; Exit;
                               End;
   Edit2.Text:=dbClientes.FieldByName('C1').AsString;

   BitBtn3Click(self);    // Sólo pre/pro del cliente.

//   Edit1.SetFocus;
end;

//--------------- Busca Cliente -----------------------
procedure TFPresupuesto.BitBtn7Click(Sender: TObject);
var
  CodigoCliente: String;
begin
  CodigoCliente:=FBusquedas.IniciaBusquedas(
    'SELECT C0,C1,C5 FROM clientes',
    ['Código','Cliente','N.I.F.'],'C0');

  // Cancelar la búsqueda no debe borrar el cliente ni relanzar el selector.
  if (CodigoCliente='') or (CodigoCliente='-1') then
  begin
    Edit1.SetFocus;
    Exit;
  end;

  Edit1.Text:=CodigoCliente;
  Edit1Exit(Edit1);
  if dbClientes.Active and (dbClientes.RecordCount>0) then
    Edit2.Text:=dbClientes.FieldByName('C1').AsString;
  Edit2.SetFocus;
end;
//--------------- Buscar por nombre -----------------
procedure TFPresupuesto.Edit2Exit(Sender: TObject);
begin
  if Edit2.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit2.SetFocus; Exit; end;
  dbBusca.SQL.Text:='SELECT C0,C1 FROM clientes WHERE C1="'+Edit2.Text+'"'; dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then
                             begin
                               Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT C0,C1,C5 FROM clientes WHERE C1 LIKE "'+Edit2.Text+'%"',
                                                         ['Código', 'Cliente', 'N.I.F.'],'C0');
                               if (Edit1.Text='') or (Edit1.Text='-1') then
                               begin
                                 Edit1.Text:='';
                                 Edit2.SetFocus;
                                 Exit;
                               end;
                               Edit1Exit(Edit1);
                               Exit;
                              end;
  Edit1.Text:=dbBusca.FieldByName('C0').AsString;
  Edit1Exit(self);
end;
//---------------- Buscar por nombre ------------------
procedure TFPresupuesto.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) then Edit2Exit(self);
  Exit;
end;

//============== PESUPUESTOS ENTRE FECHAS ========================
procedure TFPresupuesto.RadioButton3Click(Sender: TObject);
begin
  Panel3.Visible:=True;
  Panel2.Visible:=False;
  Edit3.Text:=FormatDateTime('DD/MM/YYYY',Date);
  Edit4.Text:=FormatDateTime('DD/MM/YYYY',Date);
  Edit3.SetFocus;
  StaticText1.Caption:= Filtro1Txt+' entre fechas y ordenados por fechas';
end;
procedure TFPresupuesto.BitBtn4Click(Sender: TObject);
var
  FechaDesde, FechaHasta: TDateTime;
begin
  if (Trim(Edit3.Text)='') or (Trim(Edit4.Text)='') then Exit;

  if not TryStrToDate(Edit3.Text, FechaDesde) then
  begin
    ShowMessage('La fecha inicial no es válida.');
    Edit3.SetFocus;
    Exit;
  end;

  if not TryStrToDate(Edit4.Text, FechaHasta) then
  begin
    ShowMessage('La fecha final no es válida.');
    Edit4.SetFocus;
    Exit;
  end;

  if FechaDesde > FechaHasta then
  begin
    ShowMessage('La fecha inicial no puede ser posterior a la fecha final.');
    Edit3.SetFocus;
    Exit;
  end;

  dbMuestrac.Sql.Text:='SELECT *,C1 FROM '+TablaCabecera[Tabla]+Tienda+
    ', clientes WHERE PRC0=C0 AND PRC1>="'+
    FormatDateTime('YYYY/MM/DD',FechaDesde)+'" AND PRC1<="'+
    FormatDateTime('YYYY/MM/DD',FechaHasta)+'"'+Filtro+
    ' ORDER BY PRC2 ASC, PRC1 DESC, PRC3 DESC';
  dbMuestrac.Active := True;
  if dbMuestrac.RecordCount=0 then
  begin
    ShowMessage('NO HAY '+Documento[Tabla]+' ENTRE ESAS FECHAS');
    Exit;
  end;
  DBGrid1.SetFocus;
end;

procedure TFPresupuesto.RadioGroup2Click(Sender: TObject);
var
  iniMuestrac, finMuestrac: string;
  txtMarcado: string;
  lCambio: integer;        //lCambio copia a lMarcado cuando entra en la función.
begin
 lCambio:= lMarcado;
  iniMuestrac:=dbMuestrac.SQL.Text; finMuestrac:=iniMuestrac;

  if (lMarcado<>0) then
    begin
       Delete(iniMuestrac, pos('ORDER', dbMuestrac.SQL.Text)-15 , length(dbMuestrac.SQL.Text));
       Delete(finMuestrac, 1, pos('ORDER',dbMuestrac.SQL.Text)-1  );
    end else
    begin
       Delete(iniMuestrac, pos('ORDER', dbMuestrac.SQL.Text)-1 , length(dbMuestrac.SQL.Text));
       Delete(finMuestrac, 1, pos('ORDER',dbMuestrac.SQL.Text)-1 );
    end;

  if (RadioGroup2.ItemIndex=0) and ( lMarcado <>0 ) then
    begin
       dbMuestrac.Active:= false;
       dbMuestrac.SQL.Text:= iniMuestrac +' '+ finMuestrac;
       dbMuestrac.Active:=true;
       lMarcado:=0;
       Exit;
    end;

  dbMuestrac.Active:=false;
  if (RadioGroup2.ItemIndex=1) and (lMarcado<>1) then begin txtMarcado:='S'; lMarcado:=1; end;
  if (RadioGroup2.ItemIndex=2) and (lMarcado<>2) then begin txtMarcado:='N'; lMarcado:=2; end;
  if (lMarcado<>lCambio) then dbMuestrac.SQL.Text:= iniMuestrac + ' AND PRC10="'+txtMarcado+'" ' + finMuestrac;
  dbMuestrac.Active:= true;
end;

//================ ORDENAR EL GRID ==================
procedure TFPresupuesto.DBGrid1TitleClick(Column: TColumn);
begin
 Colorea(Column,DBGrid1,dbMuestrac, AntColun, Orden, TituloColumn, Ordenado);
end;

procedure TFPresupuesto.DBGrid2TitleClick(Column: TColumn);
begin
  Colorea(Column, DBGrid2, dbMuestrad, AntColun2, Orden2,
    TituloColumn2, Ordenado2);
end;

//===========================================================
//===================== GESTIONAR PRESUPUESTOS===============
//===========================================================
procedure TFPresupuesto.BitBtn1Click(Sender: TObject);
begin
  If dbMuestrac.RecordCount=0 then Begin Showmessage('NO HAY NINGUN '+ Documento[Tabla] +' PARA GESTIONAR'); Exit; End;
  dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+dbMuestrac.FieldByName('PRC0').AsString;
  dbClientes.Active:=True;
  If dbClientes.RecordCount=0 then Begin Showmessage('SE HA BORRADO EL CLIENTE '+dbMuestrac.FieldByName('PRC0').AsString+' ?'); Exit; End;
  Panel4.BringToFront; Panel4.Visible:=True;
  DBGrid2.BringToFront; DBGrid2.Visible:=True;
  MostrarBotonesdd();
  LimpiaCliente();
  //-- PRUEBA DE CONVERT SIN QUITAR EL MID
  dbMuestrad.SQL.Text:='SELECT *, CONVERT(MID(PRD6,1,150) USING UTF8) As DESCRI FROM '+TablaDetalle[Tabla]+Tienda+' WHERE PRD0='+dbMuestrac.FieldByName('PRC0').AsString+
                     ' AND PRD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
                     ' AND PRD2="'+dbMuestrac.FieldByName('PRC2').AsString+'"'+
                     ' AND PRD3='+dbMuestrac.FieldByName('PRC3').AsString;
  dbMuestrad.Active:=True;
  PintaCliente();
  Label30.Caption:=dbMuestrac.FieldByName('PRC2').AsString;//---- Serie
  Label31.Caption:=dbMuestrac.FieldByName('PRC3').AsString;//---- N. documento
  Label33.Caption:=dbMuestrac.FieldByName('PRC1').AsString;//---- Fecha Fact.
  LabelTotal.Caption:=FormatFloat('0.00',dbMuestrac.FieldByName('PRC9').AsFloat);
  DbGrid2.SetFocus;
  ActualizarPieAtajos;

end;

//--------------------- Salir de gestionar Presupuestos ------------
procedure TFPresupuesto.BitBtn5Click(Sender: TObject);
var
 Posi: Integer;
 TxtQ: String;
begin
  Panel7.Visible:=False;
  Panel4.SendToBack; Panel4.Visible:=False;
  DBGrid2.SendToBack; DBGrid2.Visible:=False;
  OcultarBotonesdd();
  ActualizarPieAtajos;
  dbDocud.Active:=False;
  //------------- Si el Presupuesto no tiene lineas borrarla?
  If dbMuestrad.RecordCount=0 then
     begin
       boxstyle :=  MB_ICONQUESTION + MB_YESNO;
       If Application.MessageBox('CONFIRME EL BORRADO DEL DOCUMENTO COMPLETO?','FacturLinEx', boxstyle) = IDNO Then
          Exit;

       ActuHisopcc(2);

       TxtQ:='DELETE FROM '+TablaCabecera[Tabla]+Tienda+' WHERE PRC0='+dbMuestrac.FieldByName('PRC0').AsString+
             ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
             ' AND PRC2="'+dbMuestrac.FieldByName('PRC2').AsString+'" AND PRC3='+dbMuestrac.FieldByName('PRC3').AsString;
       dbDocuc.SQL.Text:=TxtQ; dbDocuc.ExecSQL;
       dbMuestrac.Refresh;
       DBGrid1.SetFocus;
       Exit;
     end;
  //------------- Actualizar cabecera Presupuestos
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT COUNT(*), SUM(PRD7), SUM(PRD11), SUM(PRD13) FROM '+TablaDetalle[Tabla]+Tienda+' WHERE'+
                     ' PRD0='+dbMuestrac.FieldByName('PRC0').AsString+
                     ' AND PRD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
                     ' AND PRD2="'+dbMuestrac.FieldByName('PRC2').AsString+'"'+
                     ' AND PRD3='+dbMuestrac.FieldByName('PRC3').AsString;
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then exit;
  TxtQ:='UPDATE '+TablaCabecera[Tabla]+Tienda+' SET PRC4='+dbTrabajo.Fields[0].AsString+', PRC5="'+dbTrabajo.Fields[1].AsString+
        '", PRC8="'+dbTrabajo.Fields[2].AsString+'", PRC9="'+dbTrabajo.Fields[3].AsString+
        '" WHERE PRC0='+dbMuestrac.FieldByName('PRC0').AsString+
        ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
        ' AND PRC2="'+dbMuestrac.FieldByName('PRC2').AsString+'" AND PRC3='+dbMuestrac.FieldByName('PRC3').AsString;
  dbDocuc.SQL.Text:=TxtQ; dbDocuc.ExecSQL;
  Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;

  DBGrid1.SetFocus;
end;

//===========================================================
//======================= CREAR LINEAS ======================
//===========================================================
procedure TFPresupuesto.BitBtn12Click(Sender: TObject);
begin
  Panel6.BringToFront;
  Panel7.Visible:=False;
  Panel6.Visible:=True; Edit5.Enabled:=True;
  Panel1.Enabled:=False; DBGrid2.Enabled:=False; DBGrid1.Enabled:= False;
  Limpiadd(); Edit5.SetFocus;
  ActualizarPieAtajos;
end;

//===========================================================
//======================= BORRAR LINEAS =====================
//===========================================================
procedure TFPresupuesto.BitBtn14Click(Sender: TObject);
begin
  Panel7.Visible:=False;
  if dbMuestrad.Eof=True then
    begin
      Showmessage('ESA LINEA NO EXISTE, NO PUEDE BORRARLA');
      exit;
    end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME EL BORRADO DE LA LINEA?','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  ActuHistoclie(1);     // Lo ponemos en modo borrado.
  ActuHisopcc(1);        // Activamos el modo borrado.
  dbMuestrad.Delete;
  ActualizaImporte();
  dbHisopcc.Active:=True;
  dbHisopcc.Edit;                        // Actualizamos Cabecera de históricos.
  dbHisopcc.FieldByName('HO9').Value:=FormatFloat('0.00',dbBusca.Fields[0].AsFloat);//--- Importe total
  dbHisopcc.FieldByName('HO11').Value:=FormatFloat('0.00',dbBusca.Fields[0].AsFloat);//-- Importe total con Dto.
  dbHisopcc.FieldByName('HO12').Value:=FormatFloat('0.00',dbBusca.Fields[0].AsFloat);//-- Entrega
  dbHisopcc.Post; dbHisopcc.Active:=False;
end;

//===========================================================
//======================= MODIFICAR LINEAS ==================
//===========================================================
procedure TFPresupuesto.DBGrid2DblClick(Sender: TObject);
begin
  if (dbMuestrad.Active=False) or (dbMuestrad.RecordCount=0) then exit;

  ActivaPrecios();

  Panel7.Visible:=False;
  Panel6.BringToFront;Panel6.Visible:=True; Panel1.Enabled:=False; DBGrid2.Enabled:=False;
  label28.Caption:=' Editando línea '; //+dbMuestrad.FieldByName('PRD4').AsString;
  Edit5.Text:=dbMuestrad.FieldByName('PRD5').AsString;
  Edit5.Enabled:=False;
  Edit6.Text:=dbMuestrad.FieldByName('PRD6').AsString;

  CantidadLinea:=dbMuestrad.FieldByName('PRD7').AsFloat;
  PrecioConIva:=dbMuestrad.FieldByName('PRD8').AsFloat;
  PrecioSinIva:=dbMuestrad.FieldByName('PRD9').AsFloat;
  DescuentoLinea:=dbMuestrad.FieldByName('PRD10').AsFloat;
  TotalSinIvaLinea:=dbMuestrad.FieldByName('PRD11').AsFloat;
  IvaLinea:=dbMuestrad.FieldByName('PRD12').AsFloat;
  TotalLinea:=dbMuestrad.FieldByName('PRD13').AsFloat;

  CargaValores();

  Edit23.Text:=FormatFloat('0.00',dbMuestrad.FieldByName('PRD17').AsFloat);
  Edit6.SetFocus;
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit5.Text+'"';
  dbArti.Active:=True;
  CargaTarifas(0);
  ActualizarPieAtajos;
end;

procedure TFPresupuesto.DBGrid2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then begin Key:=0; DBGrid2DblClick(self); end;
end;


//----------------- Salir Crear / Modificar Lineas ------------------
procedure TFPresupuesto.BitBtn6Click(Sender: TObject);
begin
  ListBox2.Visible:=False;
  Panel6.SendToBack;
  Panel6.Visible:=False;DBGrid1.Enabled:= True;
  Panel1.Enabled:=True; DBGrid2.Enabled:=True; DBGrid2.SetFocus;
  ActualizarPieAtajos;
end;

//----------------- Aceptar Crear / Modificar Lineas ----------------
procedure TFPresupuesto.BitBtn8Click(Sender: TObject);
var
  posi: integer;
begin

  ActivaPrecios();

  if Edit5.Enabled=False then
   begin
     dbMuestrad.Edit; Llenadd(); dbMuestrad.Post;
     Panel6.SendToBack;
     Panel6.Visible:=False; DBGrid1.Enabled:= true;
     Panel1.Enabled:=True; DBGrid2.Enabled:=True;
     Posi:=dbMuestrad.RecNo; dbMuestrad.Refresh; dbMuestrad.RecNo:=Posi;
     ActualizaImporte;
     DBGrid2.SetFocus;
    ActuHistoclie(0);         // Actualiza histórico de clientes.
    ActuHisopcc(0);         // Actualiza histórico de operaciones.
   end
  else
   begin
    //----- Crear linea
    dbMuestrad.Append; Llenadd(); dbMuestrad.Post;
    Limpiadd(); Edit5.SetFocus;
    Posi:=dbMuestrad.RecNo; dbMuestrad.Refresh; dbMuestrad.RecNo:=Posi;
    ActualizaImporte;
    ActuHistoclie(0);         // Actualiza histórico de clientes.
    ActuHisopcc(0);         // Actualiza histórico de operaciones.
   end;
  ActualizarPieAtajos;
end;

//===========================================================
//===================== NUEVO Presupuesto =======================
//===========================================================

procedure TFPresupuesto.BitBtn9Click(Sender: TObject);
begin
  if (RadioButton2.Checked=False) or (Edit1.Text='') then
     begin ShowMessage('PRIMERO DEBE SELECCIONAR UN CLIENTE'); exit; end;
  if dbClientes.EOF=True then
     begin showmessage('EL CLIENTE SELECIONADO NO EXISTE'); Exit; end;

  CargaSeries();//----- Cargar Series de facturacion
  if dbSeries.RecordCount=0 then begin showmessage('DEBE CREAR UNA SERIE DE FACTURACION'); exit; end;

  Panel8.Visible:=True; Panel1.Enabled:=False; //DBGrid1.Enabled:=False;
  Edit22.Text:=FormatDateTime('DD/MM/YYYY',Date);
  ListBox1.SetFocus;
  Edit21.Text:=dbSeries.FieldByName('SF3').AsString;
  ListBox1.SetFocus;
  if Tabla=1 then Edit21.Text:=dbSeries.FieldByName('SF8').AsString
             else Edit21.Text:=dbSeries.FieldByName('SF6').AsString;
  ActualizarPieAtajos;
end;

//---------------- Ver series cuando se pasa por ellas ----------------
procedure TFPresupuesto.ListBox1Click(Sender: TObject);
begin
  if dbSeries.Locate('SF0',trim(copy(ListBox1.Items.Strings[ListBox1.ItemIndex],1,3)),[]) then
      if Tabla=1 then Edit21.Text:=dbSeries.FieldByName('SF8').AsString
             else Edit21.Text:=dbSeries.FieldByName('SF6').AsString;
end;

procedure TFPresupuesto.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then begin key:=0; BitBtn19Click(self); end;
end;

//---------------- En el combo de cabecera
procedure TFPresupuesto.ComboBox1Change(Sender: TObject);
var
  SerieAVer,TxtQ: String;
begin
  //-- PRUEBAS CONVERT SIN QUITAR EL MID
  SerieAVer:=  trim(copy(ComboBox1.Text,1,3));
  if ComboBox1.Text='TODAS LAS SERIES' then
     TxtQ:='SELECT *, CONVERT(MID(PRC11,1,250) USING UTF8) as PRNOTAS,C1 FROM '+TablaCabecera[Tabla]+Tienda+
           ', clientes WHERE PRC0=C0 '+Filtro+'ORDER BY PRC2 ASC, PRC1 DESC, PRC3 DESC'
  else
     TxtQ:='SELECT *, CONVERT(MID(PRC11,1,250) USING UTF8) as PRNOTAS,C1 FROM '+TablaCabecera[Tabla]+Tienda+
           ', clientes WHERE PRC0=C0 AND PRC2="'+SerieAVer+'" '+Filtro+'ORDER BY PRC2 ASC, PRC1 DESC, PRC3 DESC';
  dbMuestrac.Active := False;
  dbMuestrac.Sql.Text:=TxtQ;
  dbMuestrac.Active := True;
end;

//============================== MARCAR DESMARCAR ==================
procedure TFPresupuesto.MenuItem1Click(Sender: TObject);
Var
  TxtQ, Marca: String;
  Posi: Integer;
begin
   if dbMuestrac.FieldByName('PRC10').AsString='S' then Marca:='N' else Marca:='S';
   TxtQ:='UPDATE '+TablaCabecera[Tabla]+Tienda+' SET PRC10="'+Marca+'" WHERE PRC0='+dbMuestrac.FieldByName('PRC0').AsString+
             ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
        ' AND PRC2="'+dbMuestrac.FieldByName('PRC2').AsString+'" AND PRC3='+dbMuestrac.FieldByName('PRC3').AsString;
   dbDocuc.SQL.Text:=TxtQ; dbDocuc.ExecSQL;
   Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;
end;

procedure TFPresupuesto.MenuItem2Click(Sender: TObject);
begin
  Edit26.Text:=dbMuestrac.FieldByName('PRC12').AsString;
  if (Edit26.Text='SV') or (Edit26.Text='') then begin showmessage('Documento pendiente de recuperar'); exit; end;
  if Edit26.Text='NS' then Edit26.Text:='Venta';
  if Edit26.Text='NT' then Edit26.Text:='Ticket';
  if Edit26.Text='AL' then Edit26.Text:='Albarán';
  if Edit26.Text='FA' then Edit26.Text:='Factura';
  Edit27.Text:=dbMuestrac.FieldByName('PRC13').AsString;
  Edit28.Text:=dbMuestrac.FieldByName('PRC14').AsString;
  Edit29.Text:=dbMuestrac.FieldByName('PRC15').AsString;
  Panel11.Visible:=True;
  ActualizarPieAtajos;
end;

procedure TFPresupuesto.MenuItem3Click(Sender: TObject);
Var
  TxtQ, Marca: String;
  Posi: Integer;
begin
   Marca:='S';
   if dbMuestrac.FieldByName('PRC16').AsString='S' then Marca:='N';
   TxtQ:='UPDATE '+TablaCabecera[Tabla]+Tienda+' SET PRC16="'+Marca+'" WHERE PRC0='+dbMuestrac.FieldByName('PRC0').AsString+
             ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
        ' AND PRC2="'+dbMuestrac.FieldByName('PRC2').AsString+'" AND PRC3='+dbMuestrac.FieldByName('PRC3').AsString;
   dbDocuc.SQL.Text:=TxtQ; dbDocuc.ExecSQL;
   Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;

end;

procedure TFPresupuesto.MenuItem4Click(Sender: TObject);
Var
  TxtQ, Marca: String;
  Posi: Integer;
begin
   Marca:='S';
   if (dbMuestrac.FieldByName('PRC17').AsString='S') and (EstadoImpresion=0) then Marca:='N';
   TxtQ:='UPDATE '+TablaCabecera[Tabla]+Tienda+' SET PRC17="'+Marca+'" WHERE PRC0='+dbMuestrac.FieldByName('PRC0').AsString+
             ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
        ' AND PRC2="'+dbMuestrac.FieldByName('PRC2').AsString+'" AND PRC3='+dbMuestrac.FieldByName('PRC3').AsString;
   dbDocuc.SQL.Text:=TxtQ; dbDocuc.ExecSQL;

   EstadoImpresion:=0;

   Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;


end;

procedure TFPresupuesto.MenuItem5Click(Sender: TObject);
Var
  TxtQ, Marca: String;
  Posi: Integer;
begin
   Marca:='S';
   if (dbMuestrac.FieldByName('PRC18').AsString='S') and (EstadoImpresion=0) then Marca:='N';
   TxtQ:='UPDATE '+TablaCabecera[Tabla]+Tienda+' SET PRC18="'+Marca+'" WHERE PRC0='+dbMuestrac.FieldByName('PRC0').AsString+
             ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
        ' AND PRC2="'+dbMuestrac.FieldByName('PRC2').AsString+'" AND PRC3='+dbMuestrac.FieldByName('PRC3').AsString;
   dbDocuc.SQL.Text:=TxtQ; dbDocuc.ExecSQL;

   EstadoImpresion:=0;

   Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;


end;

procedure TFPresupuesto.Button1Click(Sender: TObject);
begin
  Panel11.Visible:=False;
  ActualizarPieAtajos;
end;

procedure TFPresupuesto.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if (dbMuestrac.FieldByName('PRC12').AsString<>'SV') and (dbMuestrac.FieldByName('PRC12').AsString<>'') then
     begin
       DBGrid1.Canvas.Font.Color := clBlue;
       DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
     end;
end;

procedure TFPresupuesto.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then begin key:=0; BitBtn1Click(self); end;
end;

//---------------- Aceptar nuevo Presupuesto ----------------
procedure TFPresupuesto.BitBtn19Click(Sender: TObject);
var
 iniMuestrac, finMuestrac: string;
 inicioSerie, finalSerie: integer;
begin
  SPresupuesto:=dbSeries.FieldByName('SF0').AsString;
  if SPresupuesto='' then begin showmessage('DEBE SELECCIONAR UNA SERIE PARA FACTURAR'); Exit; end;
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM '+TablaCabecera[Tabla]+Tienda+' WHERE PRC0='+Edit1.Text+' ORDER BY PRC0, PRC1, PRC2, PRC3';
  dbTrabajo.Active:=True;
  //if swhueco=0 then NumeroPresupuesto();
  NumeroPresupuesto();
  dbtrabajo.Append;
  dbtrabajo.FieldByName('PRC0').AsString:=Edit1.Text; //-------------- Cliente.
  dbtrabajo.FieldByName('PRC1').Value:=StrToDate(Edit22.Text); //----- Fecha Presupuesto.
  dbtrabajo.FieldByName('PRC2').Value:=SPresupuesto; //------------------- Serie de la Presupuesto.
  dbtrabajo.FieldByName('PRC3').Value:=NPresupuesto; //------------------- N. Presupuesto.
  dbtrabajo.FieldByName('PRC4').Value:=0;
  dbtrabajo.FieldByName('PRC5').Value:=0;
  dbtrabajo.FieldByName('PRC6').Value:=0;
  dbtrabajo.FieldByName('PRC7').Value:=dbClientes.Fields[19].AsString;//-- Recargo S/N
  dbtrabajo.FieldByName('PRC8').Value:=0;//------------------------------- Imp. Sin IVA
  dbtrabajo.FieldByName('PRC9').Value:=0;//------------------------------- Imp. Con IVA
  dbtrabajo.FieldByName('PRC10').Value:='N';//---------------------------- Marcada (S/N)
  dbtrabajo.Post;

  if checkbox4.Checked then
        begin
          iniMuestrac:=dbMuestrac.SQL.Text; finMuestrac:=iniMuestrac;
          Delete(iniMuestrac, pos('WHERE', dbMuestrac.SQL.Text)+5 , length(dbMuestrac.SQL.Text));
          Delete(finMuestrac, 1, pos('WHERE',dbMuestrac.SQL.Text)+5  );

          inicioSerie:= pos('PRC2="', finMuestrac);  //Eliminamos la serie anterior si la hubiese.
          if inicioSerie <> 0 then
           begin
            finalSerie:=pos(' ', finMuestrac);
            delete(finMuestrac, inicioSerie, finalSerie-inicioSerie+5);
           end;

          dbMuestrac.Active:= false;
          dbMuestrac.SQL.Text:= iniMuestrac + ' PRC2="'+SPresupuesto+'" AND ' + finMuestrac;
          dbMuestrac.Active:= true;
        end;

  dbMuestrac.Refresh; dbMuestrac.First;
  BitBtn20Click(BitBtn20);//--- Cerrar Panel
end;

//---------------- Cancelar nueva Presupuesto ----------------
procedure TFPresupuesto.BitBtn20Click(Sender: TObject);
begin
  Panel8.Visible:=False; Panel1.Enabled:=True; DBGrid1.Enabled:=True;
  DBGrid1.SetFocus;
  ActualizarPieAtajos;
end;

//===========================================================
//================ BORRAR Presupuesto COMPLETO ==================
//===========================================================
procedure TFPresupuesto.BitBtn10Click(Sender: TObject);
var
  TxtQ: String;
  TxtTmp: String;
begin
  If dbMuestrac.RecordCount=0 then Begin Showmessage('NO HAY NINGUN '+Documento[Tabla]+' PARA GESTIONAR'); Exit; End;
  dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+dbMuestrac.FieldByName('PRC0').AsString;
  dbClientes.Active:=True;
  If dbClientes.RecordCount=0 then Begin Showmessage('SE HA BORRADO EL CLIENTE '+dbMuestrac.FieldByName('PRC0').AsString+' ?'); Exit; End;
  boxstyle :=  MB_ICONQUESTION + MB_YESNO;
  If Application.MessageBox('CONFIRME EL BORRADO DEL DOCUMENTO COMPLETO?','FacturLinEx', boxstyle) = IDNO Then Exit;

  //-- PRUEBAS DE CONVERT SIN QUITAR EL MID
  dbMuestrad.SQL.Text:='SELECT *, CONVERT(MID(PRD6,1,150) USING UTF8) As DESCRI FROM '+TablaDetalle[Tabla]+Tienda+' WHERE PRD0='+dbMuestrac.FieldByName('PRC0').AsString+
                     ' AND PRD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
                     ' AND PRD2="'+dbMuestrac.FieldByName('PRC2').AsString+'"'+
                     ' AND PRD3='+dbMuestrac.FieldByName('PRC3').AsString;
  dbMuestrad.Active:=True;
  if dbMuestrad.RecordCount<>0 then
    begin
      while not dbMuestrad.EOF do
        begin
          ActuHistoClie(1);
          ActualizaImporte();
          ActuHisopcc(1);

          dbMuestrad.Next;
        end;
    end;
  //----------------- Borrar detalles de Presupuestos
  TxtQ:='DELETE FROM '+TablaDetalle[Tabla]+Tienda+' WHERE PRD0='+dbMuestrac.FieldByName('PRC0').AsString+
        ' AND PRD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
        ' AND PRD2="'+dbMuestrac.FieldByName('PRC2').AsString+'" AND PRD3='+dbMuestrac.FieldByName('PRC3').AsString;
  dbDocud.SQL.Text:=TxtQ; dbDocud.ExecSQL;
    //----------------- Borrar cabeceras de Presupuestos
  ActuHisopcc(2);
  TxtTmp:= dbMuestrac.Sql.Text;
  TxtQ:='DELETE FROM '+TablaCabecera[Tabla]+Tienda+' WHERE PRC0='+dbMuestrac.FieldByName('PRC0').AsString+
        ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
        ' AND PRC2="'+dbMuestrac.FieldByName('PRC2').AsString+'" AND PRC3='+dbMuestrac.FieldByName('PRC3').AsString;
  dbDocuc.SQL.Text:=TxtQ; dbDocuc.ExecSQL;

//  dbMuestrac.Refresh;
  dbMuestrac.Active:=False;
  dbMuestrac.Sql.Text:=TxtTmp;
  dbMuestrac.Active:=true;

end;


//===========================================================
//================= LISTADO DE Presupuestos CABECERAS ===========
//===========================================================
procedure TFPresupuesto.BitBtn23Click(Sender: TObject);
begin
  Panel9.Visible:=True; Edit14.SetFocus;
  ActualizarPieAtajos;
  Edit14.Text:='1'; Edit16.Text:=ClienteVario;
  Edit18.Text:=FormatDateTime('DD/MM/YYYY',Date);
  Edit19.Text:=FormatDateTime('DD/MM/YYYY',Date);
end;

//---------- Aceptar listado de Presupuestos cc ----------
procedure TFPresupuesto.BitBtn21Click(Sender: TObject);
var
  FechaDesde, FechaHasta: TDateTime;
begin
  if (Edit14.Text='') or (Edit16.Text='') then Exit;

  if not TryStrToDate(Edit18.Text, FechaDesde) then
  begin
    ShowMessage('La fecha inicial del listado no es válida.');
    Edit18.SetFocus;
    Exit;
  end;

  if not TryStrToDate(Edit19.Text, FechaHasta) then
  begin
    ShowMessage('La fecha final del listado no es válida.');
    Edit19.SetFocus;
    Exit;
  end;

  if FechaDesde > FechaHasta then
  begin
    ShowMessage('La fecha inicial no puede ser posterior a la fecha final.');
    Edit18.SetFocus;
    Exit;
  end;

  dbBusca.Sql.Text:='SELECT *,C1 FROM '+TablaCabecera[Tabla]+Tienda+
                    ', clientes WHERE PRC0=C0'+
                    ' AND PRC1>="'+FormatDateTime('YYYY/MM/DD',FechaDesde)+'"'+
                    ' AND PRC1<="'+FormatDateTime('YYYY/MM/DD',FechaHasta)+'"'+
                    ' AND PRC0>='+Edit14.Text+' AND PRC0<='+Edit16.Text+
                    ' ORDER BY PRC2 ASC, PRC1 DESC, PRC3 DESC';
  dbBusca.Active := True;
  if dbBusca.RecordCount=0 then
  begin
    ShowMessage('NO HAY '+Documento[Tabla]+' ENTRE ESOS DATOS');
    Exit;
  end;
  if Tabla=1 then FImpresion.Imprime(dbBusca.SQL.Text, 'ListaProformas','')
             else FImpresion.Imprime(dbBusca.SQL.Text, 'ListaPresupuestos','');
end;

procedure TFPresupuesto.Edit14Enter(Sender: TObject);
begin
   Edit15.Text:='';
end;
procedure TFPresupuesto.Edit14Exit(Sender: TObject);
begin
   if Edit14.Text='' then Edit14.Text:='1';
   dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+Edit14.Text;
   dbClientes.Active:=True;
   If dbClientes.RecordCount=0 then Begin Showmessage('ESE CLIENTE NO EXISTE.'); Edit14.SetFocus; Exit; End;
   Edit15.Text:=dbClientes.FieldByName('C1').AsString;
end;

//-------------------- Hasta cliente ---------------
procedure TFPresupuesto.Edit16Enter(Sender: TObject);
begin
   Edit17.Text:='';
end;
procedure TFPresupuesto.Edit16Exit(Sender: TObject);
begin
   if Edit16.Text='' then Edit16.Text:=ClienteVario;
   dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+Edit16.Text;
   dbClientes.Active:=True;
   If dbClientes.RecordCount=0 then Begin Showmessage('ESE CLIENTE NO EXISTE.'); Edit16.SetFocus; Exit; End;
   Edit17.Text:=dbClientes.FieldByName('C1').AsString;
end;


//---------- Cerrar listado de Presupuestoes cc ----------
procedure TFPresupuesto.BitBtn22Click(Sender: TObject);
begin
  Panel9.Visible:=False;
  ActualizarPieAtajos;
end;

//===========================================================
//==================== IMPRIMIR Presupuesto =====================
//===========================================================

procedure TFPresupuesto.BitBtn15Click(Sender: TObject);
begin

 EstadoImpresion:= FImpresion.Imprime(dbMuestrad, dbMuestrac, dbClientes, Documento[Tabla], false, 1);

 if (EstadoImpresion=1) then MenuItem4Click(Self);

 if (EstadoImpresion=2) then MenuItem5Click(Self);

 if (EstadoImpresion=3) then
       begin
         MenuItem4Click(Self); EstadoImpresion:=2;
         MenuItem5Click(Self);
       end;

end;

//=================== OBSERVACIONES ==========================
procedure TFPresupuesto.BitBtn16Click(Sender: TObject);
begin
  Panel7.BringToFront;
  Panel7.Visible:=True;
  Memo1.Lines.Text:=dbMuestrac.FieldByName('PRC11').AsString;
  Memo1.SetFocus;
  ActualizarPieAtajos;
end;
//--------------- Aceptar Observaciones --------
procedure TFPresupuesto.BitBtn18Click(Sender: TObject);
var
 Posi: Integer;
 TxtQ: String;
begin
  TxtQ:='UPDATE '+TablaCabecera[Tabla]+Tienda+' SET PRC11="'+Memo1.Lines.Text+'" WHERE PRC0='+dbMuestrac.FieldByName('PRC0').AsString+
        ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
        ' AND PRC2="'+dbMuestrac.FieldByName('PRC2').AsString+'" AND PRC3='+dbMuestrac.FieldByName('PRC3').AsString;
  dbDocuc.SQL.Text:=TxtQ; dbDocuc.ExecSQL;
  Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;
  Panel7.SendToBack;
  Panel7.Visible:=False;
  dbGrid2.SetFocus;
  ActualizarPieAtajos;
end;

//--------------- Cancelar Observaciones --------

procedure TFPresupuesto.BitBtn17Click(Sender: TObject);
begin
  Panel7.SendToBack;
  Panel7.Visible:=False;
  dbGrid2.SetFocus;
  ActualizarPieAtajos;
end;

//==================== MARCAR PresupuestoES ======================
procedure TFPresupuesto.DBGrid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  TxtQ, Marca: String;
  Posi: Integer;
begin
   exit;
   if Button=mbLeft then exit;
   if dbMuestrac.FieldByName('PRC10').AsString='S' then Marca:='N' else Marca:='S';
   TxtQ:='UPDATE '+TablaCabecera[Tabla]+Tienda+' SET PRC10="'+Marca+'" WHERE PRC0='+dbMuestrac.FieldByName('PRC0').AsString+
             ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
        ' AND PRC2="'+dbMuestrac.FieldByName('PRC2').AsString+'" AND PRC3='+dbMuestrac.FieldByName('PRC3').AsString;
   dbDocuc.SQL.Text:=TxtQ; dbDocuc.ExecSQL;
   Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;
end;

//=============== SALIR DEL CGO. ARTICULO =====================
procedure TFPresupuesto.Edit5Exit(Sender: TObject);
var
  codigotmp: String;
begin
  if (Edit5.Enabled=False) or (Trim(Edit5.Text)='') then Exit;

  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit5.Text+'"';
  dbArti.Active:=True;

  if dbArti.RecordCount=0 then
  begin
    dbBusca.Active:=False;
    dbBusca.SQL.Text:='SELECT EAN0, EAN1 FROM eans WHERE EAN0="'+Edit5.Text+'"';
    dbBusca.Active:=True;

    if dbBusca.RecordCount=0 then
    begin
      codigotmp:=FBusquedas.IniciaBusquedas(
        'SELECT A0, EAN0, A1 FROM artitien'+Tienda+
        ', eans WHERE (EAN1=A0) and (A0 LIKE "%'+Edit5.Text+'%")',
        ['Código','Ean','Referencia'],'A0');

      // Un comodín o un texto inexistente nunca puede convertirse en línea.
      // Solo continuamos cuando el usuario ha elegido un código real.
      if (codigotmp='') or (codigotmp='-1') then
      begin
        Edit5.Text:='';
        Edit5.SetFocus;
        Exit;
      end;

      Edit5.Text:=codigotmp;
      dbArti.Active:=False;
      dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+
        ' WHERE A0="'+Edit5.Text+'"';
      dbArti.Active:=True;
    end
    else
    begin
      Edit5.Text:=dbBusca.FieldByName('EAN1').AsString;
      dbArti.Active:=False;
      dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+
        ' WHERE A0="'+Edit5.Text+'"';
      dbArti.Active:=True;
    end;
  end;

  // Protección final: no cargar precios ni descripción si el artículo no existe.
  if dbArti.RecordCount=0 then
  begin
    ShowMessage('EL ARTÍCULO SELECCIONADO NO EXISTE');
    Edit5.Text:='';
    Edit5.SetFocus;
    Exit;
  end;

  Pintadd();
  CargaTarifas(1);
  Edit6.SetFocus;
end;

procedure TFPresupuesto.BitBtn11Click(Sender: TObject);
begin
  BuscaArticulo();
end;


//------------------ Buscar Articulos ---------------
procedure TFPresupuesto.BuscaArticulo();
var
  CodigoArticulo: String;
begin
  CodigoArticulo:=FBusquedas.IniciaBusquedas(
    'SELECT A0, EAN0, A1 FROM artitien'+Tienda+
    ' , eans WHERE (A0=EAN1) and (A0 LIKE "%'+Edit5.Text+'%" )',
    ['Código','Ean','Referencia'],'A0');

  if (CodigoArticulo='') or (CodigoArticulo='-1') then
  begin
    Edit5.SetFocus;
    Exit;
  end;

  Edit5.Text:=CodigoArticulo;
  Edit5Exit(Edit5);
end;

procedure TFPresupuesto.Edit6DblClick(Sender: TObject);
var
   key: char;
begin
  if Edit5.Enabled=false then exit;
  key:=#13;
  Edit6KeyPress(self, key);
end;

procedure TFPresupuesto.Edit6KeyPress(Sender: TObject; var Key: char);
var
  FechaCompra, FechaVenta, TextoPVP, DescripcionCorta: String;
begin
  if (Key<>#13) or (Edit5.Enabled=false) then Exit;

  // Consumimos el Enter que abre el listado. Si no se anula, GTK puede
  // entregarlo también al ListBox recién enfocado y elegir la primera fila.
  Key:=#0;

  if Edit6.Text='' then begin ShowMessage('TECLEE EL ARTÍCULO A BUSCAR'); Edit6.SetFocus; Exit; end;
  ListBox3.Items.Clear;
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT A0,A1,A13,A2,A12 FROM artitien'+Tienda+
    ' WHERE A1 LIKE "%'+Edit6.Text+'%" ORDER BY A1';
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then
    begin
      ShowMessage('NO HAY ARTÍCULOS QUE CONTENGAN ESE CONCEPTO');
      dbBusca.Active:=False; Edit6.SetFocus; Exit;
    end;
  dbBusca.First;
  While not dbBusca.EOF do
    begin
      FechaCompra := Trim(dbBusca.FieldByName('A13').DisplayText);
      FechaVenta := Trim(dbBusca.FieldByName('A12').DisplayText);
      if dbBusca.FieldByName('A2').IsNull then TextoPVP := ''
      else TextoPVP := FormatFloat('0.00', dbBusca.FieldByName('A2').AsFloat);
      DescripcionCorta := Copy(dbBusca.FieldByName('A1').AsString, 1, 38);
      ListBox3.Items.Add(Format('%-12s %-38s %-12s %10s %-12s',
        [Copy(dbBusca.FieldByName('A0').AsString, 1, 12), DescripcionCorta,
         Copy(FechaCompra, 1, 12), TextoPVP, Copy(FechaVenta, 1, 12)]));
      dbBusca.Next;
    end;
  if Assigned(FLabelCabeceraBusquedaArticulos) then
  begin
    FLabelCabeceraBusquedaArticulos.Visible := True;
    FLabelCabeceraBusquedaArticulos.BringToFront;
  end;
  ListBox3.Visible:=True;
  ListBox3.BringToFront;
  ListBox3.ItemIndex:=0;
  ListBox3.SetFocus;
end;

procedure TFPresupuesto.ListBox3DblClick(Sender: TObject);
var
  I: Integer;
begin
  if (ListBox3.ItemIndex < 0) or (dbBusca.RecordCount = 0) then Exit;
  dbBusca.First;
  for I := 1 to ListBox3.ItemIndex do
    if not dbBusca.EOF then dbBusca.Next;
  if dbBusca.EOF then begin Edit6.Text:=''; Exit; end;

  Edit5.Text:=dbBusca.FieldByName('A0').AsString;
  Edit6.Text:=dbBusca.FieldByName('A1').AsString;
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit5.Text+'"';
  dbArti.Active:=True;
  Pintadd();
  CargaTarifas(1);
  ListBox3.Visible:=False;
  if Assigned(FLabelCabeceraBusquedaArticulos) then
    FLabelCabeceraBusquedaArticulos.Visible := False;
  Edit7.SetFocus;
end;

procedure TFPresupuesto.ListBox3Exit(Sender: TObject);
begin
  ListBox3.Visible:=False;
  if Assigned(FLabelCabeceraBusquedaArticulos) then
    FLabelCabeceraBusquedaArticulos.Visible := False;
end;

procedure TFPresupuesto.ListBox3KeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) then
  begin
    Key:=#0;
    ListBox3DblClick(ListBox3);
  end;
end;

procedure TFPresupuesto.EntraEnEdit(Sender: TObject);
begin
  ValorInicial:= TEdit(ActiveControl).Text;

end;

//===================== CARGA VALORES EN LOS EDIT =====
procedure TFPresupuesto.CargaValores();
begin
 Edit13.Text:= FormatFloat('0.##',TotalLinea);
 Edit7.Text:= FormatFloat('0.###',CantidadLinea);
 Edit8.Text:= FormatFloat('0.###',PrecioConIva);
 Edit9.Text:= FormatFloat('0.###',PrecioSinIva);
 Edit12.Text:= FormatFloat('0.##',IvaLinea);
 Edit10.Text:= FormatFloat('0.##',DescuentoLinea);
 Edit11.Text:= FormatFloat('0.##',TotalSinIvaLinea);
end;

//===================== CARGA VALORES EN LAS VARIABLES =====
procedure TFPresupuesto.CargaVariables();
begin
 TotalLinea:= StrToFloat(Edit13.Text);
 CantidadLinea:= StrToFloat(Edit7.Text);
 PrecioConIva:= StrToFloat(Edit8.Text);
 PrecioSinIva:= StrToFloat(Edit9.Text);
 IvaLinea:= StrToFloat(Edit12.Text);
 DescuentoLinea:= StrToFloat(Edit10.Text);
 TotalSinIvaLinea:= StrToFloat(Edit11.Text);
end;

//==================== REACTIVA LA ENTRADA DE LOS PRECIOS =========
procedure TFPresupuesto.ActivaPrecios();
begin
  Edit8.Color:=clWindow;
  Edit9.Color:=clWindow;
  Edit8.Enabled:=True;
  Edit9.Enabled:=True;
  lbActivarPrecios.Visible:=False;
end;

//===================== ENTRAR/SALIR DE LA CANTIDAD ======================

procedure TFPresupuesto.Edit7Enter(Sender: TObject);
begin
  Edit7.Text:= FormatFloat(MascaraDecimales,CantidadLinea);
end;

procedure TFPresupuesto.Edit7Exit(Sender: TObject);
begin
  if not (EsFloat(Edit7.Text)) then begin Edit7.Text:='0';Edit7.SetFocus; exit; end;

//  if (Edit7.Text='') or (Edit7.Text='0') then begin Edit13.Text:='0';Edit11.Text:='0'; Exit; end;//------ Cant.
//  if (Edit8.Text='') or (Edit8.Text='0') then begin Edit13.Text:='0';Edit11.Text:='0'; Exit; end;//------ Precio

  CantidadLinea:= StrToFloat(Edit7.Text);

  SalirCantidad(self);

  CargaValores()

end;

procedure TFPresupuesto.Edit7KeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) and (Edit5.Enabled=true) then Edit5.SetFocus;
end;


//======================= SALIR DE TARIFA ==================

procedure TFPresupuesto.Edit23Exit(Sender: TObject);
begin
   if not (EsFloat(Edit23.Text)) then begin Edit23.Text:='0'; Edit23.SetFocus; exit; end;
end;


//======================= ENTRAR/SALIR DEL PRECIO ==================

procedure TFPresupuesto.Edit8Enter(Sender: TObject);
begin
   Edit8.Text:= FormatFloat(MascaraDecimales,PrecioConIva);
   EntraEnEdit(self);
   Edit8.SetFocus;
end;

procedure TFPresupuesto.Edit8Exit(Sender: TObject);
begin
  if not (EsFloat(Edit8.Text)) then begin Edit8.Text:='0'; Edit8.SetFocus; exit; end;

  if (Edit8.Text<>ValorInicial) and (Edit9.Enabled=True) then
    begin
     Edit9.Color:=clSilver;
     Edit9.Enabled:=False;
     Edit10.SetFocus;
     lbActivarPrecios.Visible:=True;
    End;

  PrecioConIva:= StrToFloat(Edit8.Text);

  SalirPrecio(self);

  CargaValores()

end;

procedure TFPresupuesto.Edit9DblClick(Sender: TObject);
begin
  MuestraTarifas();
end;

//======================= ENTRAR/SALIR DEL PRECIO SIN IVA ====================
procedure TFPresupuesto.Edit9Enter(Sender: TObject);
begin
   Edit9.Text:= FormatFloat(MascaraDecimales,PrecioSinIva);
   EntraEnEdit(self);
   Edit9.SetFocus;
end;

procedure TFPresupuesto.Edit9Exit(Sender: TObject);
begin
  if not Edit9.Enabled then exit;
  if not (EsFloat(Edit9.Text)) then
   begin
    Edit9.Text:=FormatFloat(MascaraDecimales,PrecioSinIva);
    Edit9.SetFocus;
    exit;
   end;
  if Edit7.Text='' then Edit7.Text:='0'; //------ Cant.
  if Edit9.Text='' then Edit9.Text:='0'; //------ Precio

  if (Edit9.Text<>ValorInicial) and (Edit8.Enabled=True) then
   begin
    Edit8.Color:=clSilver;
    Edit8.enabled:=False;
    lbActivarPrecios.Visible:=True;
   End;

  PrecioSinIva:= StrToFloat(Edit9.Text);

  SalirPrecioSinIva(self);

  CargaValores()

end;

//======================= ENTRAR/SALIR DEL DTO =============================
procedure TFPresupuesto.Edit10Enter(Sender: TObject);
begin
   Edit10.Text:= FormatFloat('0.##',DescuentoLinea);
end;

procedure TFPresupuesto.Edit10Exit(Sender: TObject);
begin
  if not (EsFloat(Edit10.Text)) then begin Edit10.Text:='0';Edit10.SetFocus ; exit; end;
  if (Edit7.Text='') or (Edit7.Text='0') then begin Edit7.Text:='0'; Exit; end;//------ Cant.
  if (Edit9.Text='') or (Edit9.Text='0') then begin Edit9.Text:='0'; Exit; end;//------ Precio
  if (Edit10.Text='') or (Edit10.Text='0') then begin Edit10.Text:='0'; Exit; end;//--- Dto

  DescuentoLinea:= StrToFloat(Edit10.Text);

  SalirDescuento(self);

  CargaValores()

end;


//======================= ENTRAR/SALIR DEL IVA ==============================
procedure TFPresupuesto.Edit12Enter(Sender: TObject);
begin
  Edit11.Text:= FormatFloat('0.##',IvaLinea);
end;

procedure TFPresupuesto.Edit12Exit(Sender: TObject);
begin
  if not (EsFloat(Edit12.Text)) then begin Edit12.Text:='0'; Edit12.SetFocus; exit; end;
//  if (Edit7.Text='') or (Edit7.Text='0') then begin Edit7.Text:='0'; Exit; end;//------ Cant.
//  if (Edit8.Text='') or (Edit8.Text='0') then begin Edit8.Text:='0'; Exit; end;//------ Precio
//  if (Edit11.Text='') or (Edit11.Text='0') then begin Edit11.Text:='0'; Exit; end;//--- Importe

  IvaLinea:= StrToFloat(Edit12.Text);

  SalirIva(self);

  CargaValores()

end;

//================  Muestra histórico de compras del cliente =========
procedure TFPresupuesto.HistCliente(Sender: TObject);
var
  inutil: string;
  codigo: string;
begin

  if (Edit5.Enabled=False) then
   begin
     Edit5.Enabled:=True;
     codigo:=Edit5.Text;
     Edit5.Enabled:=False;
   end else
     codigo:= Edit5.Text;

 //-- MID(HC5,1,50) Y MID(HOD7,1,50)
 case cbHistoricos.ItemIndex of
       0:inutil:=FBusquedas.IniciaBusquedas('SELECT HC0, HC1, HC8, HC9, HC4, CONVERT(HC5 USING UTF8), HC6, (HC7/HC6) as Precio FROM histoclie WHERE HC0='+dbMuestrac.FieldByName('PRC0').AsString
                        , ['Cliente','Fecha','Serie','Número','Código','Descripción','Und','Precio'],'HC1');

       1:inutil:=FBusquedas.IniciaBusquedas('SELECT HOD6, CONVERT(HOD7 USING UTF8), HOD8, HOD9,HOD11,HOD4, HOD3 FROM hisopdd'+Tienda+
               ' WHERE HOD6="'+codigo+'"', ['CODIGO','DESCRIPCION','CANTIDAD','PRECIO','DCT%','SERIE','NUMERO'],'HOD6');

       2:inutil:=FBusquedas.IniciaBusquedas('SELECT HC0, HC1, HC8, HC9, HC4, CONVERT(HC5 USING UTF8), HC6, (HC7/HC6) as Precio FROM histoclie '+
                ' WHERE HC0='+dbMuestrac.FieldByName('PRC0').AsString + ' and HC4="' + codigo + '"', ['Cliente','Fecha','Serie','Número','Código','Descripción','Und','Precio'],'HC1');

 end;

 Edit8.SetFocus;

end;

//==================== PINTAR DATOS DE CLIENTES ======================
procedure TFPresupuesto.PintaCliente();
begin
  Label4.Caption:=dbClientes.FieldByName('C1').AsString;
  Label5.Caption:=dbClientes.FieldByName('C3').AsString;
  Label6.Caption:=dbClientes.FieldByName('C37').AsString;
  Label7.Caption:=dbClientes.FieldByName('C4').AsString;
  Label8.Caption:=dbClientes.FieldByName('C38').AsString;
  Label9.Caption:=dbClientes.FieldByName('C5').AsString;
  Label10.Caption:=dbClientes.FieldByName('C6').AsString;
  //------------- Recargo de equivalencia
  if dbClientes.FieldByName('C19').AsString='S' then
    CheckBox1.Checked:=True else CheckBox1.Checked:=False;
  
end;
//==================== LIMPIAR DATOS DE CLIENTES ======================
procedure TFPresupuesto.LimpiaCliente();
begin
  Label4.Caption:=''; Label5.Caption:=''; Label6.Caption:='';
  Label7.Caption:=''; Label8.Caption:=''; Label9.Caption:='';
  Label10.Caption:=''; LabelTotal.Caption:='0.00';

end;
//==================== LLENAR DATOS LINEAS =======================
procedure TFPresupuesto.Llenadd();
begin
  if Edit5.Enabled=true then
    begin
     dbMuestrad.FieldByName('PRD0').Value:=dbMuestrac.FieldByName('PRC0').Value;//---- Cliente
     dbMuestrad.FieldByName('PRD1').Value:=dbMuestrac.FieldByName('PRC1').Value;//---- Fecha
     dbMuestrad.FieldByName('PRD2').Value:=dbMuestrac.FieldByName('PRC2').Value;//---- Serie
     dbMuestrad.FieldByName('PRD3').Value:=dbMuestrac.FieldByName('PRC3').Value;//---- Numero
     dbMuestrad.FieldByName('PRD4').Value:=VerUltimaLinea;//-------------------------- Numero de linea
     label28.Caption:=' Añadiendo nuevas líneas. ';
     dbMuestrad.FieldByName('PRD5').AsString:=Edit5.Text;//----- Codigo
    end;
  dbMuestrad.FieldByName('PRD6').AsString:=Edit6.Text;//-------- Descripcion

  dbMuestrad.FieldByName('PRD7').AsFloat:=CantidadLinea;//-------- Cantidad
  dbMuestrad.FieldByName('PRD8').AsFloat:=PrecioConIva;//-------- Precio con IVA
  dbMuestrad.FieldByName('PRD9').AsFloat:=PrecioSinIva;//-------- Precio sin IVA
  dbMuestrad.FieldByName('PRD10').AsFloat:=DescuentoLinea;//------ Dto. %
  dbMuestrad.FieldByName('PRD11').AsFloat:=TotalSinIvaLinea;//------ Importe sin IVA
  dbMuestrad.FieldByName('PRD12').AsFloat:=IvaLinea;//------ IVA
  dbMuestrad.FieldByName('PRD13').AsFloat:=TotalLinea;//------ Importe con IVA
  dbMuestrad.FieldByName('PRD17').AsString:=Edit23.Text;//------ Precio Tarifa.

end;

//======================= PINTAR DATOS LINEAS ==================
procedure TFPresupuesto.Pintadd();
begin

  CantidadLinea:=1;

  PrecioConIva:=dbArti.FieldByName('A2').AsFloat;//----- PVP

  IvaLinea:=dbArti.FieldByName('A3').AsFloat;//---- IVA

  PrecioSinIva:=PrecioConIva/(1+IvaLinea/100);

  //-----------Ver si se aplica algún precio de tarifa al cliente
  if (dbClientes.FieldByName('C43').AsInteger<>0) and (ListBox2.Items.Count=0) then CargaTarifas(1); // Cargamos tarifas si es primera vez

  //-----------Si tiene descuentos de la ficha de clientes
  DescuentoLinea:=0;
  if dbClientes.FieldByName('C16').AsInteger<>0 then                      //-- Descuento según tipo descuento en ficha cliente
    begin
      if dbClientes.FieldByName('C16').AsInteger=1 then DescuentoLinea:=dbArti.FieldByName('A7').AsFloat;
      if dbClientes.FieldByName('C16').AsInteger=2 then DescuentoLinea:=dbArti.FieldByName('A8').AsFloat;
      if dbClientes.FieldByName('C16').AsInteger=3 then DescuentoLinea:=dbArti.FieldByName('A9').AsFloat;
    end;
  if dbClientes.FieldByName('C17').AsFloat<>0 then DescuentoLinea:=dbClientes.FieldByName('C17').AsFloat;//-- Dto Ficha cliente

  TotalLinea:=PrecioConIva;
  TotalSinIvaLinea:=PrecioSinIva;

  Edit6.Text:=dbArti.FieldByName('A1').AsString;//----- Descripcion
  Edit23.Text:= FormatFloat('0.###',PrecioConIva);//---- Precio Tarifa.

  CargaValores()
end;

//======================= LIMPIAR DATOS LINEAS ==================
procedure TFPresupuesto.Limpiadd();
begin
  label28.Caption:='Editor de líneas ';
  Edit5.Text:=''; Edit6.Text:=''; Edit7.Text:='0';
  Edit8.Text:='0'; Edit9.Text:='0'; Edit10.Text:='0';
  Edit11.Text:='0'; Edit12.Text:='0'; Edit13.Text:='0';
  Edit23.Text:='0';  ListBox2.Items.Clear;
  TotalLinea:= 0;
  CantidadLinea:= 0;
  PrecioConIva:= 0;
  PrecioSinIva:= 0;
  IvaLinea:= 0;
  DescuentoLinea:= 0;
  TotalSinIvaLinea:= 0;
  ActivaPrecios();
end;

//======== CARGA PRECIOS Y DESCUENTOS DEL ARTICULO ==============
procedure TFPresupuesto.CargaTarifas(actualiza: integer);
begin

  dbTarifas.Active:=false;
  dbTarifas.SQL.Text:='select * from tarifas where TAR0="'+dbarti.FieldByName('A0').AsString +'"';

  if actualiza=0 then dbTarifas.SQL.Text:='select * from tarifas where TAR0="'+dbMuestrad.FieldByName('PRD5').AsString +'"';

  dbTarifas.Active:=true;

  ListBox2.Items.Clear;

  ListBox2.Items.Add('PVP        '+dbArti.FieldByName('A2').AsString + ' Euros');
  ListBox2.Items.Add('Precio     '+dbArti.FieldByName('A21').AsString + ' Euros');
  ListBox2.Items.Add('Tarifa 1   '+dbTarifas.FieldByName('TAR2').AsString + ' Euros');
  ListBox2.Items.Add('Tarifa 2   '+dbTarifas.FieldByName('TAR4').AsString + ' Euros');
  ListBox2.Items.Add('Tarifa 3   '+dbTarifas.FieldByName('TAR6').AsString + ' Euros');

  if actualiza=0 then exit;  // --- Si es una edicion de linea no se cargan los valores en las variables.

  //------------------ Tarifa 1
  if (dbClientes.FieldByName('C43').AsInteger=1) and (dbTarifas.FieldByName('TAR7').AsFloat<>0) then
         begin
            PrecioConIva:=dbTarifas.FieldByName('TAR7').AsFloat;//------------ P.V.P.
            PrecioSinIva:=dbTarifas.FieldByName('TAR2').AsFloat;//----------- Precio
         end;
   //------------------ Tarifa 2
   if (dbClientes.FieldByName('C43').AsInteger=2) and (dbTarifas.FieldByName('TAR8').AsFloat<>0) then
         begin
           PrecioConIva:=dbTarifas.FieldByName('TAR8').AsFloat;//------------ P.V.P.
           PrecioSinIva:=dbTarifas.FieldByName('TAR4').AsFloat;//----------- Precio
         end;
    //------------------ Tarifa 3
    if (dbClientes.FieldByName('C43').AsInteger=3) and (dbTarifas.FieldByName('TAR9').AsFloat<>0) then
         begin
          PrecioConIva:=dbTarifas.FieldByName('TAR9').AsFloat;//------------ P.V.P.
          PrecioSinIva:=dbTarifas.FieldByName('TAR6').AsFloat;//----------- Precio
         end;

end;

procedure TFPresupuesto.MuestraTarifas();
begin
   ListBox2.Visible:=true; ListBox2.SetFocus;
end;

procedure TFPresupuesto.ListBox2DblClick(Sender: TObject);
begin
   ListBox2.Visible:= False;

   if ListBox2.ItemIndex=0 then Edit9.Text:=dbArti.FieldByName('A2').AsString;
   if ListBox2.ItemIndex=1 then Edit9.Text:=dbArti.FieldByName('A21').AsString;
   if ListBox2.ItemIndex=2 then Edit9.Text:=dbTarifas.FieldByName('TAR2').AsString;
   if ListBox2.ItemIndex=3 then Edit9.Text:=dbTarifas.FieldByName('TAR4').AsString;
   if ListBox2.ItemIndex=4 then Edit9.Text:=dbTarifas.FieldByName('TAR6').AsString;

   Edit9Exit(self);

end;

procedure TFPresupuesto.ListBox2KeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) then ListBox2DblClick(self);
end;

//================= ACTUALIZA IMPORTE EN PANTALLA ===============
procedure TFPresupuesto.ActualizaImporte();
begin
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT SUM(PRD13) FROM '+TablaDetalle[Tabla]+Tienda+' WHERE'+
                     ' PRD0='+dbMuestrac.FieldByName('PRC0').AsString+
                     ' AND PRD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
                     ' AND PRD2="'+dbMuestrac.FieldByName('PRC2').AsString+'"'+
                     ' AND PRD3='+dbMuestrac.FieldByName('PRC3').AsString;
  dbBusca.Active:=True;

  LabelTotal.Caption:=FormatFloat('0.00',dbBusca.Fields[0].AsFloat);
end;

//================= N. DE Presupuesto ===========================
procedure TFPresupuesto.NumeroPresupuesto();
begin
  if SPresupuesto='' then begin SPresupuesto:='';NPresupuesto:=0; Exit; end;
  dbSeries.Active:=False;
  if Tabla=1 then dbSeries.SQL.Text:='UPDATE seriesfactu SET SF8=SF8+1 WHERE SF0="'+SPresupuesto+'"'
             else dbSeries.SQL.Text:='UPDATE seriesfactu SET SF6=SF6+1 WHERE SF0="'+SPresupuesto+'"';
  dbSeries.ExecSql;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF0="'+SPresupuesto+'"';
  dbSeries.Active:=True;
  if dbSeries.Recordcount=0 then exit;
//  SPresupuesto:=dbSeries.Fields[0].AsString;
  if Tabla=1 then NPresupuesto:=dbSeries.FieldByName('SF8').Value
             else NPresupuesto:=dbSeries.FieldByName('SF6').Value;
  dbSeries.Active:=False;
end;


//======================= CARGAR SERIES DE FACTURACION ========================
procedure TFPresupuesto.CargaSeries();
begin
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF5<>"E" ORDER BY SF0';
  dbSeries.Active:=True;
  if dbSeries.RecordCount=0 then begin showmessage('DEBE CREAR UNA SERIE DE FACTURACION'); exit; end;
  dbSeries.First; ListBox1.Items.Clear;
  ComboBox1.Items.Clear; ComboBox1.Items.Add('TODAS LAS SERIES');
  while not dbSeries.EOF do
    begin
     ListBox1.Items.Add(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);
     ComboBox1.Items.Add(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);
     dbSeries.Next;
    end;
  dbSeries.Locate('SF0', dbTiendas.Fields[11].AsString, [loCaseInsensitive]);
  ListBox1.ItemIndex:= ListBox1.Items.IndexOf(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);

  ComboBox1.ItemIndex:=0;
end;

//====================== MOSTRAR BOTONES DD ====================
procedure TFPresupuesto.MostrarBotonesdd();
begin
  BitBtn5.Visible:=True; BitBtn12.Visible:=True;
  BitBtn13.Visible:=True; BitBtn14.Visible:=True;
  BitBtn15.Visible:=True; BitBtn16.Visible:=True;
  //-------------- cc
  BitBtn1.Visible:=False; BitBtn9.Visible:=False;
  BitBtn10.Visible:=False; BitBtn2.Visible:=False;
  BitBtn23.Visible:=False;

  //--------------- Oculta Filtro de cabeceras.
  RadioGroup2.Visible:=False;

end;

//====================== OCULTAR BOTONES DD ====================
procedure TFPresupuesto.OcultarBotonesdd();
begin
  BitBtn5.Visible:=False; BitBtn12.Visible:=False;
  BitBtn13.Visible:=False; BitBtn14.Visible:=False;
  BitBtn15.Visible:=False; BitBtn16.Visible:=False;
  //-------------- cc
  BitBtn1.Visible:=True; BitBtn9.Visible:=True;
  BitBtn10.Visible:=True; BitBtn2.Visible:=True;
  BitBtn23.Visible:=True;

  //--------------- Muestra Filtro de cabeceras.
  RadioGroup2.Visible:=True;

end;

//======================= Hist. Operaciones Cab =====================
procedure TFPresupuesto.ActuHisopcc(Modo: integer);   // Modo=1 -> Linea borrada
var
  TxtQ: String;
  PrePro: String;
begin

{ TODO: Falta asignar el numero de usuario que cierra la operacion }

  if Tabla=1 then PrePro:='PO' else PrePro:='PR';

  dbHisopcc.Active:=False;
  TxtQ:='SELECT * FROM hisopcc'+Tienda+' WHERE HO0="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
        ' AND HO2="'+Puesto+'"'+
        ' AND HO3='+dbMuestrac.FieldByName('PRC3').AsString+
        ' AND HO4="'+dbMuestrac.FieldByName('PRC2').AsString+
        '" AND HO5="'+PrePro+'"';
  dbHisopcc.Sql.Text:=TxtQ; dbHisopcc.Active := True;
  if (dbHisopcc.Recordcount=0) and (Modo=2) then exit;   // No existe histórico de esta cabecera y entramos en modo borrado.
  if (dbHisopcc.Recordcount<>0) and (Modo=2) then        // Marcamos cabecera como borrada.
     begin
      dbHisopcc.Edit;
      dbHisopcc.FieldByName('HO16').Value:='A';
      dbHisopcc.Post;
      Exit;
     End;

  if (dbHisopcc.Recordcount<>0) then      // Ya existe histórico,
    begin
      if Modo<>1 then
        begin
          dbHisopcc.Edit;
          dbHisopcc.FieldByName('HO9').Value:=FormatFloat('0.00',dbBusca.Fields[0].AsFloat);//--- Importe total
          dbHisopcc.FieldByName('HO11').Value:=FormatFloat('0.00',dbBusca.Fields[0].AsFloat);//-- Importe total con Dto.
          dbHisopcc.FieldByName('HO12').Value:=FormatFloat('0.00',dbBusca.Fields[0].AsFloat);//-- Entrega
          dbHisopcc.FieldByName('HO18').Value:=dbMuestrac.FieldByName('PRC11').Value; //--Observaciones.
          dbHisopcc.Post;
        end;
      dbHisopdd.Active:=False;
      TxtQ:='SELECT * FROM hisopdd'+Tienda+' WHERE HOD0="'+FormatDateTime('YYYY/MM/DD',dbMuestrad.FieldByName('PRD1').AsDateTime)+'"'+
            ' AND HOD2="'+Puesto+'"'+
            ' AND HOD3='+dbMuestrad.FieldByName('PRD3').AsString+
            ' AND HOD4="'+dbMuestrad.FieldByName('PRD2').AsString+
            '" AND HOD5='+dbMuestrad.FieldByName('PRD4').AsString+' AND HOD23=0';

      dbHisopdd.Sql.Text:=TxtQ; dbHisopdd.Active := True;

      Hora:=dbHisopcc.FieldByName('HO1').AsDateTime;

      if (dbHisopdd.RecordCount<>0) then        // Es una modificación, añadimos anotación.
         begin
            if Modo=1 then
               begin
                dbHisopdd.Edit;
                dbHisopdd.FieldByName('HOD7').Value:='(BORRADA) '+dbHisopdd.FieldByName('HOD7').AsString;
                dbHisopdd.FieldByName('HOD17').Value:= dbHisopdd.FieldByName('HOD0').Value;
                dbHisopdd.FieldByName('HOD18').Value:= dbHisopdd.FieldByName('HOD1').Value;
                dbHisopdd.FieldByName('HOD19').Value:= dbHisopdd.FieldByName('HOD2').Value;
                dbHisopdd.FieldByName('HOD20').Value:= dbHisopdd.FieldByName('HOD3').Value;
                dbHisopdd.FieldByName('HOD21').Value:= dbHisopdd.FieldByName('HOD4').Value;
                dbHisopdd.FieldByName('HOD23').Value:= dbHisopdd.FieldByName('HOD5').Value;
                dbHisopdd.FieldByName('HOD1').Value:=  FormatDateTime('HH:MM:SS',Time);
                dbHisopdd.Post;
                Exit;
               end;
            dbHisopdd.Edit;
            dbHisopdd.FieldByName('HOD17').Value:= dbHisopdd.FieldByName('HOD0').Value;
            dbHisopdd.FieldByName('HOD18').Value:= dbHisopdd.FieldByName('HOD1').Value;
            dbHisopdd.FieldByName('HOD19').Value:= dbHisopdd.FieldByName('HOD2').Value;
            dbHisopdd.FieldByName('HOD20').Value:= dbHisopdd.FieldByName('HOD3').Value;
            dbHisopdd.FieldByName('HOD21').Value:= dbHisopdd.FieldByName('HOD4').Value;
            dbHisopdd.FieldByName('HOD23').Value:= dbHisopdd.FieldByName('HOD5').Value;
            dbHisopdd.FieldByName('HOD1').Value:=  FormatDateTime('HH:MM:SS',Time);     // Hora en que se hace la modificación
            Hora:= dbHisopdd.FieldByName('HOD18').Value;
            dbHisopdd.Post;
         end;
      ActuHisopdd();
      Exit;
   end;

   dbHisopcc.append;

   dbHisopcc.FieldByName('HO0').AsString:=dbMuestrac.FieldByName('PRC1').AsString; //FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('AC1').AsDateTime);//-- Fecha
   dbHisopcc.FieldByName('HO1').AsString:=FormatDateTime('HH:MM:SS',Time);//-- Hora
   dbHisopcc.FieldByName('HO2').Value:=Puesto;//--- Puesto
   dbHisopcc.FieldByName('HO3').Value:=dbMuestrac.FieldByName('PRC3').Value;//- N.PRE/PRO
   dbHisopcc.FieldByName('HO4').Value:=dbMuestrac.FieldByName('PRC2').Value;//- Serie PRE/PRO.
   dbHisopcc.FieldByName('HO5').Value:=PrePro;//----- Tipo operacion
   dbHisopcc.FieldByName('HO6').Value:='FACTURADO';//------- Tipo de pago.
   dbHisopcc.FieldByName('HO7').Value:=1;//----------------- Usuario
   dbHisopcc.FieldByName('HO8').Value:=dbMuestrac.FieldByName('PRC0').Value;//----- Cgo. Cliente
   dbHisopcc.FieldByName('HO9').Value:=dbMuestrac.FieldByName('PRC9').AsFloat;//--- Importe total
   dbHisopcc.FieldByName('HO10').Value:=0;//-- % Dto.
   dbHisopcc.FieldByName('HO11').Value:=dbMuestrac.FieldByName('PRC9').AsFloat;//-- Importe total con Dto.
   dbHisopcc.FieldByName('HO12').Value:=dbMuestrac.FieldByName('PRC9').AsFloat;//-- Entrega
   dbHisopcc.FieldByName('HO13').Value:=0;//-- Cambio
   dbHisopcc.FieldByName('HO14').Value:=0;//-- Entrega Tarjeta
   dbHisopcc.FieldByName('HO15').Value:='N';//-- Marcada S/N
   dbHisopcc.FieldByName('HO16').Value:='N';//-- Estado del documento Normal.
   dbHisopcc.FieldByName('HO18').Value:=dbMuestrac.FieldByName('PRC11').Value; //--Observaciones.

   dbHisopcc.Post; dbHisopcc.Active:=False;
   Hora:= Time;

   ActuHisopdd();


end;

//======================= Hist. Operaciones Det =====================
procedure TFPresupuesto.ActuHisopdd();
var
  TxtQ: String;
begin
  //------------------- Historico de operaciones detalles
  dbHisopdd.Active:=False;
  TxtQ:='INSERT INTO hisopdd'+Tienda+' (HOD0,HOD1,HOD2,HOD3,HOD4,HOD5,HOD6,HOD7,HOD8,HOD9,HOD10,HOD11'+
        ',HOD12,HOD13,HOD14,HOD15,HOD16, HOD22) VALUES ("'+FormatDateTime('YYYY/MM/DD',dbMuestrad.FieldByName('PRD1').AsDateTime)+'",'+
        '"'+FormatDateTime('HH:MM:SS',Hora)+'","'+Puesto+'",'+dbMuestrad.FieldByName('PRD3').AsString+',"'+
        dbMuestrad.FieldByName('PRD2').AsString+'",'+dbMuestrad.FieldByName('PRD4').AsString+',"'+
        dbMuestrad.FieldByName('PRD5').AsString+'","'+dbMuestrad.FieldByName('PRD6').AsString+'",'+
        dbMuestrad.FieldByName('PRD7').AsString+','+dbMuestrad.FieldByName('PRD8').AsString+','+
        dbMuestrad.FieldByName('PRD9').AsString+','+dbMuestrad.FieldByName('PRD10').AsString+','+
        dbMuestrad.FieldByName('PRD11').AsString+','+dbMuestrad.FieldByName('PRD12').AsString+','+
        dbMuestrad.FieldByName('PRD13').AsString+',"","'+dbMuestrad.FieldByName('PRD15').AsString+'",'+
        dbMuestrad.FieldByName('PRD17').AsString+')';
  dbHisopdd.SQL.Text:=TxtQ; dbHisopdd.ExecSQL;
end;


procedure TFPresupuesto.ActuHistoclie(Modo: integer);  //Modo=1 borrar línea.
var
   TxtQ: string;
begin
  //------------------- Histórico de compras de clientes
  dbTrabajo.Active:=False;
  TxtQ:='SELECT * FROM histoclie WHERE HC0="'+dbMuestrad.FieldByName('PRD0').AsString+
        '" AND HC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrad.FieldByName('PRD1').AsDateTime)+
        '" AND HC3="'+dbMuestrad.FieldByName('PRD4').AsString+
        '" AND HC8="'+dbMuestrad.FieldByName('PRD2').AsString+
        '" AND HC9='+dbMuestrad.FieldByName('PRD3').AsString;
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.Active:=True;

  if (dbTrabajo.RecordCount=0) then
      begin
         if Modo=1 then exit;
         TxtQ:='INSERT INTO histoclie (HC0,HC1,HC2,HC3,HC4,HC5,HC6,HC7,HC8,HC9) VALUES ("'+
         dbMuestrac.FieldByName('PRC0').AsString+'","'+FormatDateTime('YYYY/MM/DD',dbMuestrad.FieldByName('PRD1').AsDateTime)+'","'+
         FormatDateTime('HH:MM:SS',Time)+'",'+dbMuestrad.FieldByName('PRD4').AsString+
         ',"'+dbMuestrad.FieldByName('PRD5').AsString+'","'+dbMuestrad.FieldByName('PRD6').AsString+
         '",'+dbMuestrad.FieldByName('PRD7').AsString+','+dbMuestrad.FieldByName('PRD13').AsString+',"'+
         dbMuestrad.FieldByName('PRD2').AsString+'",'+dbMuestrad.FieldByName('PRD3').AsString+')';
         dbTrabajo.Active:=False; dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
         Exit
      end;

  if Modo=1 then begin dbTrabajo.Delete; Exit; end;

  dbTrabajo.Edit;
  dbTrabajo.FieldByName('HC4').AsString:=dbMuestrad.FieldByName('PRD5').AsString;
  dbTrabajo.FieldByName('HC5').AsString:=dbMuestrad.FieldByName('PRD6').AsString;
  dbTrabajo.FieldByName('HC6').Value:=dbMuestrad.FieldByName('PRD7').AsFloat;
  dbTrabajo.FieldByName('HC7').Value:=dbMuestrad.FieldByName('PRD13').AsFloat;
  dbTrabajo.Post;

end;

//====================== CERRAR FORMULARIO =====================
procedure TFPresupuesto.BitBtn2Click(Sender: TObject);
begin
  Close();
end;
procedure TFPresupuesto.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;

//=================== TECLAS RAPIDAS ======================

procedure TFPresupuesto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

 // Ctrl+O abre Observaciones únicamente dentro de un presupuesto/proforma.
 // No interrumpe el editor de líneas y conserva F10 como atajo existente.
 if (ssCtrl in Shift) and (Key=VK_O) and DBGrid2.Visible and
    (not Panel6.Visible) then
 begin
   Key:=0;
   if Panel7.Visible then
     Memo1.SetFocus
   else
     BitBtn16Click(Self);
   Exit;
 end;

//     **********  Edición de las líneas del documento   **********

 if (key=VK_F1) and (panel6.Visible=True) and (lbActivarPrecios.Visible=True) then begin Key:=0;ActivaPrecios(); end;  // Activa entrada de precios
 if (key=VK_F12) and (panel6.Visible=True) and (Edit5.Enabled=True) then begin key:=0; BuscaArticulo(); end;     // Buscar artículo.
 if (key=VK_F11) and (panel6.Visible=True) and (Edit9.Focused) then begin key:=0; Edit9DblClick(self); Exit; End;     // Tarifas.
 if (key=VK_F11) and (panel6.Visible=True) and (Edit6.Focused) then begin key:=0; Edit6DblClick(self); Exit; End;
 if (key=VK_F6) and (panel6.Visible=True) then begin key:=0; Edit10.SetFocus; Exit; End;                         // Descuento
 if (key=VK_F7) and (panel6.Visible=True) then begin key:=0; Edit9.SetFocus; Exit; End;                          // Precio
 if (key=VK_F5) and (panel6.Visible=True) then begin key:=0; Edit7.SetFocus; Exit; End;                          // Cantidad
 if (key=VK_F8) and (panel6.Visible=True) then begin key:=0; BitBtn8Click(self); Exit; End;                      // Línea nueva
 //if (key=VK_F10) and (panel6.Visible=True) then begin key:=0; BitBtn24Click(self); Exit; End;                    // histórico de cliente.
 if (key=VK_ESCAPE) and (panel6.Visible=True) then begin key:=0; BitBtn6Click(self) ; Exit; End;                 // finalizar entradas
 if (key=VK_RETURN) and (panel6.Visible=True) and                                  // entrada automática.
                       (Edit5.Focused) then begin key:=0; Edit5Exit(self); BitBtn8Click(self) ; Exit; End;

//     **********  Pantalla cabeceras de presupuestos/proformas   **********

 if (key=VK_ESCAPE) and Panel11.Visible then
 begin
   key:=0;
   Button1Click(Self);
   Exit;
 end;

 if (key=VK_C) and (dbGrid2.Visible=false) and (Panel2.Visible=false) then
      begin
        key:=0;
        RadioButton2.Checked:=True;
        RadioButton2Click(self);
        Exit;
      End;
 if (key=VK_T) and (dbGrid2.Visible=false) and (Panel2.Visible=false) then
      begin
        key:=0;
        RadioButton1.Checked:=True;
        RadioButton1Click(self);
        Exit;
      End;
 if (key=VK_F) and (dbGrid2.Visible=false) and (Panel2.Visible=false) then
      begin
        key:=0;
        RadioButton3.Checked:=True;
        RadioButton3Click(self);
        Exit;
      End;
 if (key=VK_F1) and (dbGrid2.Visible=false) then begin key:=0; BitBtn1Click(self); Exit; End;                    // entra en edición del pre/pro
 if (key=VK_F2) and (dbGrid2.Visible=false) then begin key:=0; BitBtn9Click(self); Exit; End;                    // crea un pre/pro nuevo
 if (key=VK_F3) and (dbGrid2.Visible=false) then begin key:=0; BitBtn10Click(self); Exit; End;                   // borra un pre/pro
 if (key=VK_F11) and (dbGrid2.Visible=false) then begin key:=0; BitBtn23Click(self); Exit; End;                  // Listado de pre/pro's
 if (key=VK_F8 ) and (Panel9.Visible=True) then begin key:=0; BitBtn21Click(self); Exit; End;                    // ejecuta el listado
 if (key=VK_F8 ) and (Panel8.Visible=True) then begin key:=0; BitBtn19Click(self); dbGrid1.SetFocus; Exit; End;  // Acepta datos serie/numero pre/pro
 if (key=VK_ESCAPE) and (Panel9.Visible=True) then begin key:=0; BitBtn22Click(self); Exit; End;                 // Cancelar listado
 if (key=VK_ESCAPE) and (Panel8.Visible=True) then begin key:=0; BitBtn20Click(self); Exit; End;                 // Cancelar datos serie/pro.
 if (key=VK_ESCAPE) and (dbGrid2.Visible=false) then begin key:=0; BitBtn2Click(self); Exit; End;                // Salir de tarea de pre/pro
 if (key=VK_F12) and (dbGrid2.Visible=false) and (RadioButton2.Checked) then begin key:=0; BitBtn7Click(self); Exit; End;  // buscar clientes.

//     **********  Pantalla de detalles de proformas/presupuestos   **********

 if (key=VK_F2) and (dbGrid2.Visible=true) then begin key:=0; BitBtn12Click(self); Exit; End;                     // Crear líneas nuevas.
 if (key=VK_F3) and (dbGrid2.Visible=true) then begin key:=0; BitBtn14Click(self); Exit; End;                     // Borra la línea seleccionada
 if (key=VK_F4) and (dbGrid2.Visible=true) then begin key:=0; DBGrid2DblClick(self); Exit; End;                   // Editar la linea seleccionada
 if (key=VK_F11) and (dbGrid2.Visible=true) then begin key:=0; BitBtn15Click(self); Exit; End;                    // Imprime el pre/pro en uso.
 if (key=VK_F10) and (dbGrid2.Visible=true) then begin key:=0; BitBtn16Click(self); Exit; End;                    // Observaciones / notas
 if (key=VK_ESCAPE) and (panel7.Visible=True) then begin key:=0; BitBtn17Click(self); Exit; End;                  // Salir de observaciones
 if (key=VK_ESCAPE) and (dbGrid2.Visible=true) then begin key:=0; BitBtn5Click(self); Exit; End;                  // salir de la edicion de documentos.
 if (key=VK_F8) and (panel7.Visible=True) then begin key:=0; BitBtn18Click(self); Exit; End;                      // // acepta las observaciones.

end;

procedure TFPresupuesto.FormShow(Sender: TObject);
begin
  dbGrid1.SetFocus;
  ActualizarPieAtajos;
end;

//=================== SACAR EL ULT N. DE LINEA =====================
function TFPresupuesto.VerUltimaLinea: Integer;
begin
  VerUltimaLinea:=1;
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT MAX(PRD4) As ULTIMA FROM '+TablaDetalle[Tabla]+Tienda+' WHERE'+
                    ' PRD0='+dbMuestrac.FieldByName('PRC0').AsString+
                    ' AND PRD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('PRC1').AsDateTime)+'"'+
                    ' AND PRD2="'+dbMuestrac.FieldByName('PRC2').AsString+'"'+
                    ' AND PRD3='+dbMuestrac.FieldByName('PRC3').AsString;
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  VerUltimaLinea:=dbBusca.FieldByName('ULTIMA').AsInteger+1;
end;


initialization

  {$I presupuestos.lrs}

end.

