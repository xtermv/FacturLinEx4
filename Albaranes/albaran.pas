{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2011, Nicolas Lopez de Lerma Aymerich
  
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

unit Albaran;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  Classes, SysUtils, StrUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, ZConnection, ZDataset, DBGrids, Grids, db, StdCtrls, DbCtrls, EditBtn, LR_Class,
  LR_DBSet, LCLType, Menus,  LR_E_CSV, LR_E_HTM, lr_e_pdf;

type

{ TFAlbaran }

TFAlbaran = class(TForm)
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
  BitBtn25: TBitBtn;
  BitBtn3: TBitBtn;
  BitBtn4: TBitBtn;
  BitBtn5: TBitBtn;
  BitBtn6: TBitBtn;
  BitBtn24: TBitBtn;
  btRecibosAceptar: TBitBtn;
  BitBtn8: TBitBtn;
  BitBtn9: TBitBtn;
  btRecibosCancelar: TBitBtn;
  CheckBox1: TCheckBox;
  CheckBox2: TCheckBox;
  CheckBox4: TCheckBox;
  ComboBox1: TComboBox;
  cbHistoricos: TComboBox;
  Datasource1: TDatasource;
  Datasource2: TDatasource;
  Datasource3: TDatasource;
  dbHisopcc: TZQuery;
  dbHisopdd: TZQuery;
  dbTarifas: TZQuery;
  dbTiendas: TZQuery;
  dbBusca: TZQuery;
  dbTrabajo: TZQuery;
  dbSeries: TZQuery;
  dbLista: TZQuery;
  dbAlbac: TZQuery;
  dbAlbad: TZQuery;
  dbClientes: TZQuery;
  dbArti: TZQuery;
  DBGrid1: TDBGrid;
  DBGrid2: TDBGrid;
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
  Edit18: TEdit;
  Edit19: TEdit;
  Edit2: TEdit;
  Edit20: TEdit;
  Edit21: TEdit;
  Edit22: TEdit;
  Edit23: TEdit;
  edRecibos: TEdit;
  Edit3: TDateEdit;
  Edit4: TDateEdit;
  Edit5: TEdit;
  Edit6: TEdit;
  Edit7: TEdit;
  Edit8: TEdit;
  Edit9: TEdit;
  frReport1: TfrReport;
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
  lbHistoricos: TLabel;
  lbActivarPrecios: TLabel;
  lbListaRecibos: TLabel;
  lbRecibos: TLabel;
  LabelTotal: TLabel;
  Label2: TLabel;
  Label3: TLabel;
  Label4: TLabel;
  Label5: TLabel;
  Label6: TLabel;
  Label7: TLabel;
  Label8: TLabel;
  Label9: TLabel;
  ListBox1: TListBox;
  ListBox2: TListBox;
  ListBox3: TListBox;
  Memo1: TMemo;
  MenuItem1: TMenuItem;
  MenuItem2: TMenuItem;
  MenuItem3: TMenuItem;
  MenuItem4: TMenuItem;
  Panel1: TPanel;
  dbMuestrac: TZQuery;
  panelRecibos: TPanel;
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
  RadioGroup2: TRadioGroup;
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
  procedure BitBtn24Click(Sender: TObject);
  procedure BitBtn25Click(Sender: TObject);
  procedure BitBtn2Click(Sender: TObject);
  procedure BitBtn3Click(Sender: TObject);
  procedure BitBtn4Click(Sender: TObject);
  procedure BitBtn5Click(Sender: TObject);
  procedure BitBtn6Click(Sender: TObject);
  procedure BitBtn8Click(Sender: TObject);
  procedure BitBtn9Click(Sender: TObject);
  procedure btRecibosAceptarClick(Sender: TObject);
  procedure btRecibosCancelarClick(Sender: TObject);
  procedure ComboBox1Change(Sender: TObject);
  procedure DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure DBGrid1TitleClick(Column: TColumn);
  procedure DBGrid2TitleClick(Column: TColumn);
  procedure DBGridPrepareCanvas(Sender: TObject; DataCol: Integer;
    Column: TColumn; aState: TGridDrawState);
  procedure DBGrid2DblClick(Sender: TObject);
  procedure DBGrid2KeyDown(Sender: TObject; var Key: Word;
   Shift: TShiftState);
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
  procedure Edit9Enter(Sender: TObject);
  procedure EntraEnEdit(Sender: TObject);
  procedure Edit8Exit(Sender: TObject);
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
  procedure NumeroAlbaran();
  procedure RadioGroup2Click(Sender: TObject);
  procedure RestarStock(Codigo, Cantidad: String);
  procedure SumarStock(Codigo, Cantidad: String);
  procedure RestarEsta(Codigo, Cantidad, Precio: String);
  procedure SumarEsta(Codigo, Cantidad, Precio: String);
  procedure BuscaArticulo();
  procedure ActualizaImporte();
  procedure CargaTarifas(actualiza: integer);
  procedure MuestraTarifas();
  function VerUltimaLinea: Integer;
  procedure CargaSeries();
  procedure ActuHisopcc(Modo: integer);
  procedure ActuHisopdd();
  procedure ActuHistoclie(Modo: integer);
  procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
  procedure CargaValores();
  procedure CargaVariables();
  procedure ActivaPrecios();
  function HayStock: boolean;

  private
    { Diseño moderno conservador. No sustituye controles ni eventos originales. }
    FEstiloModernoAplicado: Boolean;
    FPanelAtajos: TPanel;
    FLabelAtajos: TLabel;
    FOrdenGrid1Campo: String;
    FOrdenGrid1Direccion: String;
    FOrdenGrid2Campo: String;
    FOrdenGrid2Direccion: String;
    FBtnCalEdit3: TSpeedButton;
    FBtnCalEdit4: TSpeedButton;
    procedure AplicarEstiloModerno;
    procedure CrearBotonCalendarioVisible(var AButton: TSpeedButton;
      AFecha: TDateEdit; ATag: Integer);
    procedure PrepararCalendariosVisibles;
    procedure AbrirCalendarioVisible(Sender: TObject);
    procedure AjustarLayoutModerno;
    procedure FormResizeModerno(Sender: TObject);
    procedure CrearPieAtajos;
    procedure ActualizarPieAtajos;
    procedure ConfigurarOrdenacionGrids;
    procedure OrdenarGrid(AQuery: TZQuery; AGrid: TDBGrid; AColumn: TColumn;
      var ACampo, ADireccion: String);
    procedure ActualizarFlechaGrid(AGrid: TDBGrid;
      const ACampo, ADireccion: String);
    function SQLSinOrden(const ASQL: String): String;

    { Sincronización de albaranes con créditos e histórico }
    function SQLTexto(const ATexto: String): String;
    function SQLNumero(const AValor: Double): String;
    function EsCreditoAjuste(const ANotas: String; var ABase: Double): Boolean;
    function NotasConAuditoria(const ANotasAlbaran, ANotasHistorico: String): String;
    procedure InicializarControlAlbaran;
    function ValidarClienteDocumento: Boolean;
    procedure MarcarAlbaranModificado;
    procedure RehacerDetalleCreditoCompleto(const ACliente: Integer;
      const AFecha, AHora: TDateTime; const ASerie: String; const ANumero: Integer);
    procedure RehacerDetalleCreditoAjuste(const ACliente: Integer;
      const AFecha, AHora: TDateTime; const ASerie: String; const ANumero: Integer;
      const ABase, ATotalActual, ADiferencia: Double);
    procedure CrearCreditoCompleto(const ATotal: Double);
    procedure CrearCreditoAjuste(const ABase, ATotalActual: Double);
    function SincronizarCreditoAlbaran(const ATotalActual: Double): String;
    procedure EliminarCreditoAlbaranExistente;
    procedure RegistrarAuditoriaHistorico(const ATotalAnterior, ATotalNuevo: Double;
      const AResultadoCredito: String);
    procedure ObtenerFechaHoraHistorico(var AFecha, AHora: TDateTime);

  public
    { public declarations }
  end;

  procedure ShowFormAlbaranes;
  
const
  MARCA_AJUSTE_ALBARAN = '[FLX_AJUSTE_ALBARAN_BASE=';
  MARCA_AUDITORIA_ALBARAN = '--- MODIFICACIONES DEL ALBARAN ---';

var
  FAlbaran: TFAlbaran;
  SALBARAN: String;
  NALBARAN: Integer;
  BASE1,BASE2,BASE3,IMPOIVA1,IMPOIVA2,IMPOIVA3,TOTAL1,TOTAL2,TOTAL3: Double;
  IRIVA1,IRIVA2,IRIVA3,RECARGO: Double;
  PIVA1,PIVA2,PIVA3,PRIVA1,PRIVA2,PRIVA3:Double;
  lMarcado: integer;  // 0 = todos, 1 = no marcado, 2=marcado
  hora: TDateTime;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;
  AlbaranesPagados: string;
  EstadoImpresion: integer;

//  TotalLinea, CantidadLinea, PrecioConIva, PrecioSinIva,
//  IvaLinea, DescuentoLinea, TotalSinIvaLinea : Double;

  ValorInicial: String;   // Valor de entrada de un edit para controlar si cambió al salir.

  // Estado del albarán que se está gestionando. Permite sincronizar una sola vez
  // al salir, evitando duplicar movimientos por cada línea editada.
  FAlbaranEnGestion: Boolean;
  FAlbaranModificado: Boolean;
  FAlbaranNuevo: Boolean;
  FTotalOriginalAlbaran: Double;
  FClienteAlbaran: Integer;
  FFechaAlbaran: TDateTime;
  FSerieAlbaran: String;
  FNumeroAlbaran: Integer;
  FPuestoHistoricoAlbaran: String;
  FFechaHistoricoAlbaran: TDateTime;
  FHoraHistoricoAlbaran: TDateTime;
  FHistoricoAlbaranLocalizado: Boolean;

implementation

uses
  Global, Funciones, busquedas, Imprimir, calculos, uFLXTemaVisual;
  
 { TFAlbaran }

//================== CALENDARIOS VISIBLES ==================
procedure TFAlbaran.CrearBotonCalendarioVisible(
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
  AButton.Glyph.Assign(AFecha.Glyph);
  AButton.NumGlyphs := 1;
  AButton.Visible := AFecha.Visible;
  AButton.Enabled := AFecha.Enabled;
  AButton.BringToFront;
end;

procedure TFAlbaran.PrepararCalendariosVisibles;
begin
  CrearBotonCalendarioVisible(FBtnCalEdit3, Edit3, 3);
  CrearBotonCalendarioVisible(FBtnCalEdit4, Edit4, 4);
end;

procedure TFAlbaran.AbrirCalendarioVisible(Sender: TObject);
var
  Fecha: TDateEdit;
begin
  Fecha := nil;
  if Sender is TComponent then
    case TComponent(Sender).Tag of
      3: Fecha := Edit3;
      4: Fecha := Edit4;
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
procedure TFAlbaran.AplicarEstiloModerno;
var
  CFondo, CTarjeta, CCabecera, CPrimario: TColor;
  CTexto, CTextoSuave, CVerde, CVerdeSuave: TColor;
  CRojo, CAmbarSuave, CAzulSuave: TColor;
  CCremaSuave, CGrisSuave, CLavandaSuave: TColor;
  I: Integer;

  procedure EstilarPanel(APanel: TPanel; AColor: TColor;
    AConMarco: Boolean = False);
  begin
    if not Assigned(APanel) then Exit;
    APanel.ParentBackground := False;
    APanel.ParentColor := False;
    APanel.Color := AColor;
    APanel.Caption := '';
    APanel.BevelInner := bvNone;
    APanel.BevelOuter := bvNone;
    if AConMarco then
      APanel.BorderWidth := 1
    else
      APanel.BorderWidth := 0;
  end;

  procedure EstilarBoton(ABoton: TBitBtn; AColor, ATexto: TColor;
    AResaltado: Boolean = True);
  begin
    if not Assigned(ABoton) then Exit;
    ABoton.ParentFont := False;
    ABoton.Font.Name := 'Sans';
    ABoton.Font.Height := -10;
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
    // Tamaño compacto y coherente con el resto de formularios.
    // Ocho puntos permite mostrar más filas sin perder legibilidad.
    AGrid.Font.Size := 8;
    AGrid.Font.Color := CTexto;
    AGrid.Color := clWhite;
    AGrid.FixedColor := CCabecera;
    AGrid.AlternateColor := RGBToColor(248, 250, 252);
    AGrid.SelectedColor := RGBToColor(191, 219, 254);
    AGrid.OnPrepareCanvas := @DBGridPrepareCanvas;
    AGrid.GridLineColor := RGBToColor(203, 213, 225);
    AGrid.DefaultRowHeight := 18;
    AGrid.TitleFont.Name := 'Sans';
    AGrid.TitleFont.Size := 8;
    AGrid.TitleFont.Style := [fsBold];
    AGrid.TitleFont.Color := clWhite;

    // Algunas columnas traen una fuente propia definida en el LFM. Se fija
    // también en 8 pt para impedir que sobrescriban el tamaño del grid.
    for K := 0 to AGrid.Columns.Count - 1 do
    begin
      AGrid.Columns[K].Font.Name := 'Sans';
      AGrid.Columns[K].Font.Size := 8;
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

  // Misma familia visual que Ventas y Créditos.
  CFondo         := RGBToColor(239, 244, 249);
  CTarjeta       := clWhite;
  CCabecera      := RGBToColor(6, 55, 86);
  CPrimario      := RGBToColor(37, 99, 235);
  CTexto         := RGBToColor(21, 38, 62);
  CTextoSuave    := RGBToColor(74, 91, 112);
  CVerde         := RGBToColor(0, 128, 72);
  CVerdeSuave    := RGBToColor(222, 247, 232);
  CRojo          := RGBToColor(185, 28, 28);
  CAmbarSuave    := RGBToColor(255, 246, 214);
  CAzulSuave     := RGBToColor(228, 240, 252);
  CCremaSuave    := RGBToColor(255, 248, 225);
  CGrisSuave     := RGBToColor(242, 245, 247);
  CLavandaSuave  := RGBToColor(242, 237, 250);

  KeyPreview := True;
  Color := CFondo;
  ParentFont := False;
  Font.Name := 'Sans';
  Font.Height := -10;
  Font.Color := CTexto;
  Caption := 'FacturLinEx · Gestión de albaranes';

  EstilarPanel(Panel5, CFondo);
  EstilarPanel(Panel1, CCabecera);
  EstilarPanel(Panel2, CAzulSuave, True);
  EstilarPanel(Panel3, CAzulSuave, True);
  EstilarPanel(Panel4, CTarjeta);
  EstilarPanel(Panel6, CCremaSuave);
  EstilarPanel(Panel7, CGrisSuave);
  EstilarPanel(Panel8, CAzulSuave);
  EstilarPanel(Panel9, CLavandaSuave);
  EstilarPanel(panelRecibos, CVerdeSuave);

  EstilarGrid(DBGrid1);
  EstilarGrid(DBGrid2);

  // Tipografía base prudente. No se agrandan indiscriminadamente las etiquetas
  // pequeñas del LFM porque tienen alturas de 9-12 píxeles.
  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TBitBtn then
      with TBitBtn(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -10;
      end
    else if Components[I] is TEdit then
      with TEdit(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -10;
        Font.Color := CTexto;
        Color := clWhite;
      end
    else if Components[I] is TMemo then
      with TMemo(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -10;
        Font.Color := CTexto;
        Color := clWhite;
      end
    else if Components[I] is TComboBox then
      with TComboBox(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -10;
        Font.Color := CTexto;
        Color := clWhite;
      end
    else if Components[I] is TListBox then
      with TListBox(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -9;
        Font.Color := CTexto;
        Color := clWhite;
      end
    else if Components[I] is TRadioGroup then
      with TRadioGroup(Components[I]) do
      begin
        ParentFont := False;
        ParentColor := False;
        Font.Name := 'Sans';
        Font.Height := -10;
        Font.Color := CTexto;
        Color := CTarjeta;
      end
    else if Components[I] is TRadioButton then
      with TRadioButton(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -9;
        Font.Color := CTexto;
      end
    else if Components[I] is TCheckBox then
      with TCheckBox(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Height := -10;
        Font.Color := CTextoSuave;
      end
    else if Components[I] is TLabel then
      with TLabel(Components[I]) do
      begin
        ParentFont := False;
        Font.Name := 'Sans';
        Font.Color := CTexto;
        if Height <= 10 then
          Font.Height := -7
        else if Height <= 12 then
          Font.Height := -8
        else if Height <= 16 then
          Font.Height := -9
        else if Height <= 24 then
          Font.Height := -10;
      end;
  end;

  // Pantalla principal de selección. Tipografía contenida y zonas separadas.
  RadioButton1.ParentFont := False;
  RadioButton2.ParentFont := False;
  RadioButton3.ParentFont := False;
  RadioButton1.Font.Name := 'Sans';
  RadioButton2.Font.Name := 'Sans';
  RadioButton3.Font.Name := 'Sans';
  RadioButton1.Font.Height := -9;
  RadioButton2.Font.Height := -9;
  RadioButton3.Font.Height := -9;
  RadioButton1.Font.Color := CTexto;
  RadioButton2.Font.Color := CTexto;
  RadioButton3.Font.Color := CTexto;

  ComboBox1.ParentFont := False;
  ComboBox1.Font.Name := 'Sans';
  ComboBox1.Font.Height := -9;
  ComboBox1.Font.Color := CTexto;
  ComboBox1.Color := clWhite;

  RadioGroup2.Caption := 'Documentos a visualizar';
  RadioGroup2.ParentFont := False;
  RadioGroup2.Font.Name := 'Sans';
  RadioGroup2.Font.Height := -9;
  RadioGroup2.Font.Color := CTexto;

  Label1.Font.Height := -9;
  Label2.Font.Height := -9;
  Label3.Font.Height := -9;
  Label35.Font.Height := -9;
  Edit1.Font.Height := -9;
  Edit2.Font.Height := -9;
  Edit3.Font.Height := -9;
  Edit4.Font.Height := -9;
  BitBtn3.Caption := 'Aceptar';
  BitBtn4.Caption := 'Aceptar';
  BitBtn3.Font.Height := -9;
  BitBtn4.Font.Height := -9;

  // Cabecera del albarán: texto oscuro sobre tarjeta blanca.
  Bevel1.Visible := False;
  Label4.SetBounds(16, 8, 330, 15);
  Label5.SetBounds(16, 24, 330, 15);
  Label6.SetBounds(16, 40, 70, 15);
  Label7.SetBounds(90, 40, 255, 15);
  Label8.SetBounds(16, 56, 330, 15);
  Label9.SetBounds(16, 72, 145, 15);
  Label10.SetBounds(175, 72, 170, 15);

  EstilarEtiqueta(Label4, CTexto, -10, True);
  EstilarEtiqueta(Label5, CTexto, -9);
  EstilarEtiqueta(Label6, CTextoSuave, -9);
  EstilarEtiqueta(Label7, CTexto, -9);
  EstilarEtiqueta(Label8, CTexto, -9);
  EstilarEtiqueta(Label9, CTextoSuave, -9);
  EstilarEtiqueta(Label10, CTexto, -9);

  CheckBox1.SetBounds(365, 10, 185, 21);
  CheckBox2.SetBounds(365, 34, 165, 21);

  Label29.SetBounds(365, 62, 80, 16);
  Label30.SetBounds(450, 62, 38, 16);
  Label34.SetBounds(491, 62, 8, 16);
  Label31.SetBounds(501, 62, 70, 16);
  Label32.SetBounds(365, 82, 80, 16);
  Label33.SetBounds(450, 82, 120, 16);
  EstilarEtiqueta(Label29, CTextoSuave, -9, True);
  EstilarEtiqueta(Label32, CTextoSuave, -9, True);
  EstilarEtiqueta(Label30, CTexto, -10, True);
  EstilarEtiqueta(Label31, CTexto, -10, True);
  EstilarEtiqueta(Label33, CTexto, -10, True);
  EstilarEtiqueta(Label34, CTexto, -10, True);

  LabelTotal.ParentFont := False;
  LabelTotal.Font.Name := 'Sans';
  LabelTotal.Font.Height := -20;
  LabelTotal.Font.Style := [fsBold];
  LabelTotal.Font.Color := CVerde;
  LabelTotal.Alignment := taRightJustify;
  LabelTotal.Layout := tlCenter;

  // Editor de líneas: cabecera fuerte, cuerpo crema y campos legibles.
  Label28.ParentColor := False;
  Label28.Transparent := False;
  Label28.Color := CCabecera;
  Label28.Font.Color := clWhite;
  Label28.Font.Name := 'Sans';
  Label28.Font.Height := -12;
  Label28.Font.Style := [fsBold];
  Label28.Layout := tlCenter;

  EstilarEtiqueta(Label11, CTextoSuave, -9, True);
  EstilarEtiqueta(Label12, CTextoSuave, -9, True);
  EstilarEtiqueta(Label13, CTextoSuave, -9, True);
  EstilarEtiqueta(Label14, CTextoSuave, -9, True);
  EstilarEtiqueta(Label15, CTextoSuave, -9, True);
  EstilarEtiqueta(Label16, CTextoSuave, -9, True);
  EstilarEtiqueta(Label17, CTextoSuave, -9, True);
  EstilarEtiqueta(Label18, CTextoSuave, -9, True);
  EstilarEtiqueta(Label19, CVerde, -9, True);
  EstilarEtiqueta(Label36, CTextoSuave, -9, True);
  Label12.Caption := 'Descripción';
  Label14.Caption := 'P.V.P.';
  Label15.Caption := 'PRECIO S/IVA';

  Edit13.Color := CVerdeSuave;
  Edit13.Font.Color := CVerde;
  Edit13.Font.Style := [fsBold];
  lbHistoricos.Font.Size := 8;
  lbHistoricos.Font.Color := CTextoSuave;
  lbHistoricos.Font.Style := [fsBold];
  lbActivarPrecios.Font.Size := 7;
  lbActivarPrecios.Font.Color := CRojo;

  // Observaciones.
  Label20.ParentColor := False;
  Label20.Transparent := False;
  Label20.Color := CCabecera;
  Label20.Font.Color := clWhite;
  Label20.Font.Name := 'Sans';
  Label20.Font.Height := -12;
  Label20.Font.Style := [fsBold];
  Label20.Alignment := taCenter;
  Label20.Layout := tlCenter;
  Label20.Caption := 'OBSERVACIONES DEL ALBARÁN';

  // Botones fuertes: texto blanco. Botones pastel: texto oscuro.
  EstilarBoton(BitBtn1,  CPrimario, clWhite);
  EstilarBoton(BitBtn2,  CRojo, clWhite);
  EstilarBoton(BitBtn3,  CAzulSuave, CCabecera);
  EstilarBoton(BitBtn4,  CAzulSuave, CCabecera);
  EstilarBoton(BitBtn5,  CRojo, clWhite);
  EstilarBoton(BitBtn6,  CRojo, clWhite);
  EstilarBoton(BitBtn8,  CVerde, clWhite);
  EstilarBoton(BitBtn9,  CVerde, clWhite);
  EstilarBoton(BitBtn10, CRojo, clWhite);
  EstilarBoton(BitBtn11, CAzulSuave, CCabecera);
  EstilarBoton(BitBtn12, CVerde, clWhite);
  EstilarBoton(BitBtn13, CAmbarSuave, CTexto);
  EstilarBoton(BitBtn14, CRojo, clWhite);
  EstilarBoton(BitBtn15, CVerde, clWhite);
  EstilarBoton(BitBtn16, CPrimario, clWhite);
  EstilarBoton(BitBtn17, CRojo, clWhite);
  EstilarBoton(BitBtn18, CVerde, clWhite);
  EstilarBoton(BitBtn19, CVerde, clWhite);
  EstilarBoton(BitBtn20, CRojo, clWhite);
  EstilarBoton(BitBtn21, CVerde, clWhite);
  EstilarBoton(BitBtn22, CRojo, clWhite);
  EstilarBoton(BitBtn23, CPrimario, clWhite);
  EstilarBoton(BitBtn24, CAzulSuave, CCabecera);
  EstilarBoton(BitBtn25, CAzulSuave, CCabecera);
  EstilarBoton(btRecibosAceptar, CVerde, clWhite);
  EstilarBoton(btRecibosCancelar, CRojo, clWhite);

  // Los botones de los filtros son compactos y deben mostrar el texto completo.
  BitBtn3.Font.Height := -9;
  BitBtn4.Font.Height := -9;

  ConfigurarOrdenacionGrids;
  CrearPieAtajos;
  ActualizarPieAtajos;

  OnResize := @FormResizeModerno;
  AjustarLayoutModerno;
  PrepararCalendariosVisibles;
end;

procedure TFAlbaran.AjustarLayoutModerno;
var
  W, Resto, WNombre, HPanel, AlturaLista: Integer;
begin
  if not FEstiloModernoAplicado then Exit;

  // Zona principal de filtros. Se reserva más altura para evitar solapes.
  RadioButton1.SetBounds(18, 10, 310, 22);
  RadioButton3.SetBounds(18, 36, 245, 22);
  RadioButton2.SetBounds(18, 62, 245, 22);
  ComboBox1.SetBounds(18, 91, 230, 28);
  // Separamos claramente la tarjeta Documentos de los filtros de la izquierda.
  // Los paneles de cliente/fechas se desplazan en el mismo bloque para evitar
  // cualquier solapamiento, incluso con fuentes GTK algo más anchas.
  RadioGroup2.SetBounds(410, 10, 200, 108);

  Panel2.SetBounds(630, 10, Panel5.ClientWidth - 640, 108);
  if Panel2.Width < 450 then Panel2.Width := 450;
  Panel3.SetBounds(630, 10, Panel5.ClientWidth - 640, 86);
  if Panel3.Width < 450 then Panel3.Width := 450;

  Label1.SetBounds(16, 8, 95, 15);
  Edit1.SetBounds(16, 28, 100, 30);
  BitBtn25.SetBounds(123, 28, 32, 30);
  Label35.SetBounds(172, 8, 110, 15);
  BitBtn3.SetBounds(Panel2.ClientWidth - 118, 27, 100, 32);
  Edit2.SetBounds(172, 28, BitBtn3.Left - 184, 30);
  if Edit2.Width < 220 then Edit2.Width := 220;

  Label2.SetBounds(16, 8, 110, 15);
  Edit3.SetBounds(16, 28, 132, 30);
  Label3.SetBounds(170, 8, 110, 15);
  Edit4.SetBounds(170, 28, 132, 30);
  BitBtn4.SetBounds(324, 27, 105, 32);

  // La rejilla empieza bajo toda la zona de filtros.
  DBGrid1.SetBounds(5, 128, Panel5.ClientWidth - 6,
    Panel5.ClientHeight - 129);

  PrepararCalendariosVisibles;

  // Columnas adaptables: se aprovecha el ancho disponible sin perder
  // la posibilidad de redimensionarlas manualmente.
  if DBGrid1.Columns.Count >= 11 then
  begin
    W := DBGrid1.ClientWidth - 34;
    DBGrid1.Columns[0].Width := 82;
    DBGrid1.Columns[1].Width := 52;
    DBGrid1.Columns[2].Width := 70;
    DBGrid1.Columns[3].Width := 86;
    DBGrid1.Columns[4].Width := 68;
    DBGrid1.Columns[6].Width := 34;
    DBGrid1.Columns[7].Width := 72;
    DBGrid1.Columns[8].Width := 94;
    DBGrid1.Columns[9].Width := 70;
    Resto := W - (82 + 52 + 70 + 86 + 68 + 34 + 72 + 94 + 70);
    if Resto < 420 then Resto := 420;
    WNombre := (Resto * 55) div 100;
    DBGrid1.Columns[5].Width := WNombre;
    DBGrid1.Columns[10].Width := Resto - WNombre;
  end;

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
    if Resto < 260 then Resto := 260;
    DBGrid2.Columns[1].Width := Resto;
  end;

  // Total alineado a la derecha de la tarjeta de cabecera.
  LabelTotal.SetBounds(Panel4.ClientWidth - 300, 8, 282, 48);

  // Editor de líneas más amplio, compacto y con campos repartidos.
  // En resoluciones bajas se adapta al ancho disponible sin salir de pantalla.
  W := Panel5.ClientWidth - 24;
  if W > 920 then W := 920;
  if W < 760 then W := 760;

  // El editor mantiene su tamaño normal. Solo al mostrar las coincidencias de
  // artículos se amplía temporalmente para ofrecer, como mínimo, el doble de
  // líneas visibles respecto a la lista anterior.
  HPanel := 340;
  if ListBox3.Visible then
  begin
    HPanel := Panel5.ClientHeight - 145;
    if HPanel > 500 then HPanel := 500;
    if HPanel < 430 then HPanel := 430;
  end;
  Panel6.SetBounds((Panel5.ClientWidth - W) div 2,
    (Panel5.ClientHeight - HPanel) div 2, W, HPanel);
  if Panel6.Left < 8 then Panel6.Left := 8;
  if Panel6.Top < 112 then Panel6.Top := 112;

  Label28.SetBounds(0, 0, Panel6.ClientWidth, 34);

  // Primera fila: identificación del artículo y total de la línea.
  Label11.SetBounds(20, 45, 112, 16);
  Edit5.SetBounds(20, 64, 112, 28);
  BitBtn11.SetBounds(138, 62, 36, 32);
  Label12.SetBounds(190, 45, Panel6.ClientWidth - 410, 16);
  Edit6.SetBounds(190, 64, Panel6.ClientWidth - 410, 28);
  Label19.SetBounds(Panel6.ClientWidth - 198, 45, 174, 16);
  Edit13.SetBounds(Panel6.ClientWidth - 198, 64, 174, 28);

  // Segunda fila: datos económicos distribuidos en siete columnas iguales.
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

  // Tercera fila: históricos y acciones, con margen inferior suficiente.
  lbHistoricos.SetBounds(20, 190, 132, 16);
  cbHistoricos.SetBounds(20, 208, 132, 29);
  BitBtn24.SetBounds(164, 207, 120, 31);
  lbActivarPrecios.SetBounds(304, 213, 280, 16);
  BitBtn8.SetBounds(Panel6.ClientWidth - 214, 286, 94, 34);
  BitBtn6.SetBounds(Panel6.ClientWidth - 108, 286, 94, 34);

  // Lista de coincidencias al buscar artículos por descripción.
  // Cuando está visible ocupa casi toda la altura libre del editor y muestra
  // al menos el doble de artículos simultáneamente.
  if ListBox3.Visible then
    AlturaLista := Panel6.ClientHeight - 118
  else
    AlturaLista := 178;
  if AlturaLista < 220 then AlturaLista := 220;
  ListBox3.SetBounds(190, 99, Panel6.ClientWidth - 214, AlturaLista);
  ListBox2.SetBounds(292, 176, 298, 92);

  // Observaciones amplias y centradas.
  Panel7.SetBounds((Panel5.ClientWidth - 700) div 2,
    (Panel5.ClientHeight - 200) div 2, 700, 190);
  if Panel7.Left < 8 then Panel7.Left := 8;
  if Panel7.Top < 112 then Panel7.Top := 112;
  Label20.SetBounds(0, 0, Panel7.ClientWidth, 34);
  Memo1.SetBounds(16, 48, Panel7.ClientWidth - 32, 92);
  BitBtn18.SetBounds(480, 151, 96, 30);
  BitBtn17.SetBounds(588, 151, 96, 30);

  // Resto de paneles auxiliares, centrados sin alterar su contenido.
  Panel8.Left := (Panel5.ClientWidth - Panel8.Width) div 2;
  Panel8.Top := (Panel5.ClientHeight - Panel8.Height) div 2;
  Panel9.Left := (Panel5.ClientWidth - Panel9.Width) div 2;
  Panel9.Top := (Panel5.ClientHeight - Panel9.Height) div 2;
  panelRecibos.Left := (Panel5.ClientWidth - panelRecibos.Width) div 2;
  panelRecibos.Top := (Panel5.ClientHeight - panelRecibos.Height) div 2;
end;

procedure TFAlbaran.FormResizeModerno(Sender: TObject);
begin
  AjustarLayoutModerno;
end;

procedure TFAlbaran.CrearPieAtajos;
const
  CBarra = TColor($0033210F);
begin
  if Assigned(FPanelAtajos) then Exit;

  FPanelAtajos := TPanel.Create(Self);
  FPanelAtajos.Name := 'pnlAtajosAlbaranModerno';
  FPanelAtajos.Parent := Self;
  FPanelAtajos.Align := alBottom;
  FPanelAtajos.Height := 28;
  FPanelAtajos.BevelOuter := bvNone;
  FPanelAtajos.ParentBackground := False;
  FPanelAtajos.ParentColor := False;
  FPanelAtajos.Color := CBarra;
  FPanelAtajos.Caption := '';

  FLabelAtajos := TLabel.Create(Self);
  FLabelAtajos.Name := 'lblAtajosAlbaranModerno';
  FLabelAtajos.Parent := FPanelAtajos;
  FLabelAtajos.Align := alClient;
  FLabelAtajos.Alignment := taCenter;
  FLabelAtajos.Layout := tlCenter;
  FLabelAtajos.AutoSize := False;
  FLabelAtajos.Transparent := True;
  FLabelAtajos.ParentFont := False;
  FLabelAtajos.Font.Name := 'Sans';
  FLabelAtajos.Font.Height := -10;
  FLabelAtajos.Font.Style := [fsBold];
  FLabelAtajos.Font.Color := clWhite;
end;

procedure TFAlbaran.ActualizarPieAtajos;
begin
  if not Assigned(FLabelAtajos) then Exit;

  if Panel7.Visible then
    FLabelAtajos.Caption :=
      'Ctrl+O Observaciones   ·   F8 Guardar observaciones   ·   ESC Cancelar'
  else if Panel6.Visible then
    FLabelAtajos.Caption :=
      'F5 Cantidad   ·   F6 Descuento   ·   F7 Precio   ·   F8 Aceptar línea   ·   F10 Histórico   ·   F12 Buscar artículo   ·   ESC Finalizar'
  else if DBGrid2.Visible then
    FLabelAtajos.Caption :=
      'Ctrl+O Observaciones   ·   F2 Nueva línea   ·   F3 Borrar línea   ·   F4 Modificar   ·   F10 Observaciones   ·   F11 Imprimir   ·   ESC Volver'
  else
    FLabelAtajos.Caption :=
      'T Todos   ·   C Cliente   ·   F Fechas   ·   F1 Gestionar   ·   F2 Nuevo   ·   F3 Borrar   ·   F11 Listado   ·   F12 Buscar cliente   ·   ESC Cerrar';
end;

//================== ORDENACIÓN DE GRIDS ==================
function TFAlbaran.SQLSinOrden(const ASQL: String): String;
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

procedure TFAlbaran.ActualizarFlechaGrid(AGrid: TDBGrid;
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

procedure TFAlbaran.OrdenarGrid(AQuery: TZQuery; AGrid: TDBGrid;
  AColumn: TColumn; var ACampo, ADireccion: String);
var
  Campo, SQLBase: String;
begin
  if (not Assigned(AQuery)) or (not Assigned(AGrid)) or
     (not Assigned(AColumn)) or (not Assigned(AColumn.Field)) then Exit;

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

procedure TFAlbaran.ConfigurarOrdenacionGrids;
begin
  FOrdenGrid1Campo := '';
  FOrdenGrid1Direccion := 'ASC';
  FOrdenGrid2Campo := '';
  FOrdenGrid2Direccion := 'ASC';
  DBGrid1.OnTitleClick := @DBGrid1TitleClick;
  DBGrid2.OnTitleClick := @DBGrid2TitleClick;
end;

//================== UTILIDADES SQL SEGURAS ==================
function TFAlbaran.SQLTexto(const ATexto: String): String;
begin
  Result:=StringReplace(ATexto, '\', '\\', [rfReplaceAll]);
  Result:=StringReplace(Result, '"', '\"', [rfReplaceAll]);
end;

function TFAlbaran.SQLNumero(const AValor: Double): String;
var
  FS: TFormatSettings;
begin
  FS:=DefaultFormatSettings;
  FS.DecimalSeparator:='.';
  Result:=FloatToStr(AValor, FS);
end;

// Los ajustes de un albarán ya saldado guardan el total base en CRE21.
// De este modo, si vuelve a modificarse, se recalcula la diferencia acumulada
// y no se suman diferencias sucesivas por error.
function TFAlbaran.EsCreditoAjuste(const ANotas: String; var ABase: Double): Boolean;
var
  PInicio, PFin: Integer;
  SBase: String;
  FS: TFormatSettings;
begin
  Result:=False;
  ABase:=0;
  PInicio:=Pos(MARCA_AJUSTE_ALBARAN, ANotas);
  if PInicio=0 then Exit;
  Inc(PInicio, Length(MARCA_AJUSTE_ALBARAN));
  PFin:=PInicio;
  while (PFin<=Length(ANotas)) and (ANotas[PFin]<>']') do Inc(PFin);
  if PFin>PInicio then
    begin
      SBase:=Copy(ANotas, PInicio, PFin-PInicio);
      FS:=DefaultFormatSettings;
      FS.DecimalSeparator:='.';
      Result:=TryStrToFloat(SBase, ABase, FS);
    end;
end;

function TFAlbaran.NotasConAuditoria(const ANotasAlbaran,
  ANotasHistorico: String): String;
var
  P: Integer;
begin
  P:=Pos(MARCA_AUDITORIA_ALBARAN, ANotasHistorico);
  if P=0 then
    Result:=ANotasAlbaran
  else
    begin
      Result:=TrimRight(ANotasAlbaran);
      if Result<>'' then Result:=Result+LineEnding+LineEnding;
      Result:=Result+Copy(ANotasHistorico, P, Length(ANotasHistorico)-P+1);
    end;
end;

procedure TFAlbaran.InicializarControlAlbaran;
begin
  FAlbaranEnGestion:=True;
  FAlbaranModificado:=False;
  FTotalOriginalAlbaran:=dbMuestrac.FieldByName('AC9').AsFloat;
  FClienteAlbaran:=dbMuestrac.FieldByName('AC0').AsInteger;
  FFechaAlbaran:=dbMuestrac.FieldByName('AC1').AsDateTime;
  FSerieAlbaran:=dbMuestrac.FieldByName('AC2').AsString;
  FNumeroAlbaran:=dbMuestrac.FieldByName('AC3').AsInteger;
  FAlbaranNuevo:=(dbMuestrac.FieldByName('AC4').AsInteger=0) and
                 (Abs(FTotalOriginalAlbaran)<0.005);
  FPuestoHistoricoAlbaran:=Puesto;
  FFechaHistoricoAlbaran:=FFechaAlbaran;
  FHoraHistoricoAlbaran:=0;
  FHistoricoAlbaranLocalizado:=False;

  // La identidad documental es serie + número. El puesto solo se conserva
  // como dato histórico y nunca se usa para decidir si el albarán existe.
end;

function TFAlbaran.ValidarClienteDocumento: Boolean;
var
  CuentaHistorico, CuentaCredito: Integer;
  ClienteHistorico, ClienteCredito: Integer;
  DifiereHistorico, DifiereCredito: Boolean;
  Pregunta, Detalle, Notas, Entrada, TxtQ: String;
begin
  Result:=False;
  CuentaHistorico:=0;
  CuentaCredito:=0;
  ClienteHistorico:=FClienteAlbaran;
  ClienteCredito:=FClienteAlbaran;

  // El albarán es único por serie + número dentro de la tienda. Se recuperan
  // una sola vez los datos originales del histórico, incluido el puesto.
  dbHisopcc.Active:=False;
  dbHisopcc.SQL.Text:='SELECT * FROM hisopcc'+Tienda+
    ' WHERE HO3='+IntToStr(FNumeroAlbaran)+' AND HO4="'+
    SQLTexto(FSerieAlbaran)+'" AND HO5="AL" ORDER BY HO0,HO1 LIMIT 2';
  dbHisopcc.Active:=True;
  CuentaHistorico:=dbHisopcc.RecordCount;
  if CuentaHistorico>1 then
    begin
      ShowMessage('Se han encontrado varias cabeceras historicas para el albaran '+
        FSerieAlbaran+'/'+IntToStr(FNumeroAlbaran)+'.'+LineEnding+
        'No se permite editarlo hasta revisar el duplicado.');
      dbHisopcc.Active:=False;
      Exit;
    end;

  if CuentaHistorico=1 then
    begin
      FFechaHistoricoAlbaran:=dbHisopcc.FieldByName('HO0').AsDateTime;
      FHoraHistoricoAlbaran:=dbHisopcc.FieldByName('HO1').AsDateTime;
      FPuestoHistoricoAlbaran:=dbHisopcc.FieldByName('HO2').AsString;
      ClienteHistorico:=dbHisopcc.FieldByName('HO8').AsInteger;
      FHistoricoAlbaranLocalizado:=True;
    end;

  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT CRE0 FROM creditos'+Tienda+
    ' WHERE CRE3="AL" AND CRE4="'+SQLTexto(FSerieAlbaran)+'" AND CRE5='+
    IntToStr(FNumeroAlbaran)+' LIMIT 2';
  dbTrabajo.Active:=True;
  CuentaCredito:=dbTrabajo.RecordCount;
  if CuentaCredito>1 then
    begin
      ShowMessage('Se han encontrado varios movimientos de credito para el albaran '+
        FSerieAlbaran+'/'+IntToStr(FNumeroAlbaran)+'.'+LineEnding+
        'No se permite editarlo hasta revisar el duplicado.');
      dbTrabajo.Active:=False;
      dbHisopcc.Active:=False;
      Exit;
    end;
  if CuentaCredito=1 then
    ClienteCredito:=dbTrabajo.FieldByName('CRE0').AsInteger;
  dbTrabajo.Active:=False;

  DifiereHistorico:=(CuentaHistorico=1) and
    (ClienteHistorico<>FClienteAlbaran);
  DifiereCredito:=(CuentaCredito=1) and
    (ClienteCredito<>FClienteAlbaran);

  if not DifiereHistorico and not DifiereCredito then
    begin
      dbHisopcc.Active:=False;
      Result:=True;
      Exit;
    end;

  Detalle:='El albaran '+FSerieAlbaran+'/'+IntToStr(FNumeroAlbaran)+
    ' pertenece en su cabecera al cliente '+IntToStr(FClienteAlbaran)+'.';
  if DifiereHistorico then
    Detalle:=Detalle+LineEnding+'En el historico figura el cliente '+
      IntToStr(ClienteHistorico)+'.';
  if DifiereCredito then
    Detalle:=Detalle+LineEnding+'En creditos figura el cliente '+
      IntToStr(ClienteCredito)+'.';
  Pregunta:=Detalle+LineEnding+LineEnding+
    '¿Desea trasladar el historico y el credito al cliente '+
    IntToStr(FClienteAlbaran)+'?';

  if Application.MessageBox(PChar(Pregunta),'FacturLinEx',
    MB_ICONQUESTION+MB_YESNO)<>IDYES then
    begin
      ShowMessage('El albaran no se abrira para evitar mezclar movimientos de clientes distintos.');
      dbHisopcc.Active:=False;
      Exit;
    end;

  // Toda corrección de pertenencia queda anotada en la cabecera histórica.
  if CuentaHistorico=1 then
    begin
      Notas:=NotasConAuditoria(dbMuestrac.FieldByName('AC11').AsString,
        dbHisopcc.FieldByName('HO18').AsString);
      if Pos(MARCA_AUDITORIA_ALBARAN, Notas)=0 then
        begin
          if Trim(Notas)<>'' then Notas:=TrimRight(Notas)+LineEnding+LineEnding;
          Notas:=Notas+MARCA_AUDITORIA_ALBARAN;
        end;
      Entrada:=FormatDateTime('DD/MM/YYYY HH:MM:SS',Now)+' - Puesto '+Puesto+': ';
      if DifiereHistorico then
        Entrada:=Entrada+'historico cliente '+IntToStr(ClienteHistorico)+' -> '+
          IntToStr(FClienteAlbaran)
      else
        Entrada:=Entrada+'historico ya pertenecia al cliente '+
          IntToStr(FClienteAlbaran);
      if DifiereCredito then
        Entrada:=Entrada+'; credito cliente '+IntToStr(ClienteCredito)+' -> '+
          IntToStr(FClienteAlbaran);
      Entrada:=Entrada+' (correccion de pertenencia del albaran).';
      Notas:=Notas+LineEnding+Entrada;
      dbHisopcc.Edit;
      if DifiereHistorico then
        dbHisopcc.FieldByName('HO8').AsInteger:=FClienteAlbaran;
      dbHisopcc.FieldByName('HO18').AsString:=Notas;
      dbHisopcc.Post;
    end;
  dbHisopcc.Active:=False;

  if DifiereCredito then
    begin
      TxtQ:='UPDATE creditos'+Tienda+' SET CRE0='+IntToStr(FClienteAlbaran)+
        ' WHERE CRE3="AL" AND CRE4="'+SQLTexto(FSerieAlbaran)+
        '" AND CRE5='+IntToStr(FNumeroAlbaran);
      dbTrabajo.SQL.Text:=TxtQ;
      dbTrabajo.ExecSQL;
      TxtQ:='UPDATE creditosdd'+Tienda+' SET CRED0='+IntToStr(FClienteAlbaran)+
        ' WHERE CRED3="'+SQLTexto(FSerieAlbaran)+'" AND CRED4='+
        IntToStr(FNumeroAlbaran);
      dbTrabajo.SQL.Text:=TxtQ;
      dbTrabajo.ExecSQL;
    end;

  Result:=True;
end;

procedure TFAlbaran.MarcarAlbaranModificado;
begin
  if FAlbaranEnGestion then FAlbaranModificado:=True;
end;

procedure TFAlbaran.RehacerDetalleCreditoCompleto(const ACliente: Integer;
  const AFecha, AHora: TDateTime; const ASerie: String; const ANumero: Integer);
var
  TxtQ, MarcaLinea: String;
  LineasMarcadas: TStringList;
begin
  LineasMarcadas:=TStringList.Create;
  try
    // Conservamos las marcas manuales de las líneas que continúan existiendo.
    dbTrabajo.Active:=False;
    dbTrabajo.SQL.Text:='SELECT CRED5,CRED17 FROM creditosdd'+Tienda+
      ' WHERE CRED3="'+SQLTexto(ASerie)+'" AND CRED4='+IntToStr(ANumero);
    dbTrabajo.Active:=True;
    while not dbTrabajo.EOF do
      begin
        if dbTrabajo.FieldByName('CRED17').AsString='S' then
          LineasMarcadas.Add(dbTrabajo.FieldByName('CRED5').AsString);
        dbTrabajo.Next;
      end;
    dbTrabajo.Active:=False;
    dbTrabajo.SQL.Text:='DELETE FROM creditosdd'+Tienda+
      ' WHERE CRED3="'+SQLTexto(ASerie)+'" AND CRED4='+IntToStr(ANumero);
    dbTrabajo.ExecSQL;

    dbMuestrad.First;
    while not dbMuestrad.EOF do
      begin
        if LineasMarcadas.IndexOf(dbMuestrad.FieldByName('AD4').AsString)>=0 then
          MarcaLinea:='S'
        else
          MarcaLinea:='N';
        TxtQ:='INSERT INTO creditosdd'+Tienda+
          ' (CRED0,CRED1,CRED2,CRED3,CRED4,CRED5,CRED6,CRED7,CRED8,CRED9,CRED10,'+
          'CRED11,CRED12,CRED13,CRED14,CRED15,CRED16,CRED17) VALUES ('+
          IntToStr(ACliente)+',"'+FormatDateTime('YYYY/MM/DD',AFecha)+'","'+
          FormatDateTime('HH:MM:SS',AHora)+'","'+SQLTexto(ASerie)+'",'+
          IntToStr(ANumero)+','+dbMuestrad.FieldByName('AD4').AsString+',"'+
          SQLTexto(dbMuestrad.FieldByName('AD5').AsString)+'","'+
          SQLTexto(dbMuestrad.FieldByName('AD6').AsString)+'",'+
          SQLNumero(dbMuestrad.FieldByName('AD7').AsFloat)+','+
          SQLNumero(dbMuestrad.FieldByName('AD8').AsFloat)+','+
          SQLNumero(dbMuestrad.FieldByName('AD9').AsFloat)+','+
          SQLNumero(dbMuestrad.FieldByName('AD10').AsFloat)+','+
          SQLNumero(dbMuestrad.FieldByName('AD11').AsFloat)+','+
          SQLNumero(dbMuestrad.FieldByName('AD12').AsFloat)+','+
          SQLNumero(dbMuestrad.FieldByName('AD13').AsFloat)+',"'+
          SQLTexto(dbMuestrad.FieldByName('AD14').AsString)+'","'+
          SQLTexto(dbMuestrad.FieldByName('AD15').AsString)+'","'+MarcaLinea+'")';
        dbTrabajo.SQL.Text:=TxtQ;
        dbTrabajo.ExecSQL;
        dbMuestrad.Next;
      end;
  finally
    LineasMarcadas.Free;
  end;
end;

procedure TFAlbaran.RehacerDetalleCreditoAjuste(const ACliente: Integer;
  const AFecha, AHora: TDateTime; const ASerie: String; const ANumero: Integer;
  const ABase, ATotalActual, ADiferencia: Double);
var
  TxtQ, Descripcion, MarcaLinea: String;
begin
  MarcaLinea:='N';
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT CRED17 FROM creditosdd'+Tienda+
    ' WHERE CRED3="'+SQLTexto(ASerie)+'" AND CRED4='+IntToStr(ANumero)+
    ' ORDER BY CRED5 LIMIT 1';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    MarcaLinea:=dbTrabajo.FieldByName('CRED17').AsString;
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='DELETE FROM creditosdd'+Tienda+
    ' WHERE CRED3="'+SQLTexto(ASerie)+'" AND CRED4='+IntToStr(ANumero);
  dbTrabajo.ExecSQL;

  Descripcion:='MODIFICACION ALBARAN '+ASerie+'/'+IntToStr(ANumero)+
    ' (anterior '+FormatFloat('0.00',ABase)+', actual '+
    FormatFloat('0.00',ATotalActual)+')';
  TxtQ:='INSERT INTO creditosdd'+Tienda+
    ' (CRED0,CRED1,CRED2,CRED3,CRED4,CRED5,CRED6,CRED7,CRED8,CRED9,CRED10,'+
    'CRED11,CRED12,CRED13,CRED14,CRED15,CRED16,CRED17) VALUES ('+
    IntToStr(ACliente)+',"'+FormatDateTime('YYYY/MM/DD',AFecha)+'","'+
    FormatDateTime('HH:MM:SS',AHora)+'","'+SQLTexto(ASerie)+'",'+
    IntToStr(ANumero)+',1,"MOD-ALB","'+SQLTexto(Descripcion)+'",1,'+
    SQLNumero(ADiferencia)+','+SQLNumero(ADiferencia)+',0,'+
    SQLNumero(ADiferencia)+',0,'+SQLNumero(ADiferencia)+',"","A","'+
    MarcaLinea+'")';
  dbTrabajo.SQL.Text:=TxtQ;
  dbTrabajo.ExecSQL;
end;

procedure TFAlbaran.ObtenerFechaHoraHistorico(var AFecha, AHora: TDateTime);
begin
  AFecha:=FFechaAlbaran;
  AHora:=Time;

  if FHistoricoAlbaranLocalizado then
    begin
      AFecha:=FFechaHistoricoAlbaran;
      AHora:=FHoraHistoricoAlbaran;
      Exit;
    end;

  dbHisopcc.Active:=False;
  dbHisopcc.SQL.Text:='SELECT HO0,HO1,HO2 FROM hisopcc'+Tienda+
    ' WHERE HO3='+IntToStr(FNumeroAlbaran)+' AND HO4="'+
    SQLTexto(FSerieAlbaran)+'" AND HO5="AL" ORDER BY HO0,HO1 LIMIT 1';
  dbHisopcc.Active:=True;
  if dbHisopcc.RecordCount<>0 then
    begin
      AFecha:=dbHisopcc.FieldByName('HO0').AsDateTime;
      AHora:=dbHisopcc.FieldByName('HO1').AsDateTime;
      FFechaHistoricoAlbaran:=AFecha;
      FHoraHistoricoAlbaran:=AHora;
      FPuestoHistoricoAlbaran:=dbHisopcc.FieldByName('HO2').AsString;
      FHistoricoAlbaranLocalizado:=True;
    end;
  dbHisopcc.Active:=False;
end;

procedure TFAlbaran.CrearCreditoCompleto(const ATotal: Double);
var
  Debe, Haber: Double;
  FechaCredito, HoraCredito: TDateTime;
  TxtQ: String;
begin
  FechaCredito:=0;
  HoraCredito:=0;
  if ATotal>=0 then begin Debe:=ATotal; Haber:=0; end
  else begin Debe:=0; Haber:=Abs(ATotal); end;
  ObtenerFechaHoraHistorico(FechaCredito, HoraCredito);

  TxtQ:='INSERT INTO creditos'+Tienda+
    ' (CRE0,CRE1,CRE2,CRE3,CRE4,CRE5,CRE6,CRE7,CRE8,CRE9,CRE10,CRE11,CRE12,'+
    'CRE13,CRE14,CRE15,CRE16,CRE17,CRE18,CRE21) VALUES ('+
    IntToStr(FClienteAlbaran)+',"'+FormatDateTime('YYYY/MM/DD',FechaCredito)+'","'+
    FormatDateTime('HH:MM:SS',HoraCredito)+'","AL","'+SQLTexto(FSerieAlbaran)+'",'+
    IntToStr(FNumeroAlbaran)+',"ALBARAN '+SQLTexto(FSerieAlbaran)+'/'+
    IntToStr(FNumeroAlbaran)+'",'+SQLNumero(Debe)+','+SQLNumero(Haber)+
    ',"N",1,"'+SQLTexto(FPuestoHistoricoAlbaran)+'","CREDITO",'+SQLNumero(ATotal)+
    ',0,'+SQLNumero(ATotal)+',0,'+SQLNumero(-ATotal)+',0,"'+
    SQLTexto(dbMuestrac.FieldByName('AC11').AsString)+'")';
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:=TxtQ;
  dbTrabajo.ExecSQL;
  RehacerDetalleCreditoCompleto(FClienteAlbaran, FechaCredito, HoraCredito,
    FSerieAlbaran, FNumeroAlbaran);
end;

procedure TFAlbaran.CrearCreditoAjuste(const ABase, ATotalActual: Double);
var
  Debe, Haber, Diferencia: Double;
  FechaCredito, HoraCredito: TDateTime;
  TxtQ, Notas: String;
begin
  FechaCredito:=0;
  HoraCredito:=0;
  Diferencia:=ATotalActual-ABase;
  if Diferencia>=0 then begin Debe:=Diferencia; Haber:=0; end
  else begin Debe:=0; Haber:=Abs(Diferencia); end;
  ObtenerFechaHoraHistorico(FechaCredito, HoraCredito);
  Notas:=MARCA_AJUSTE_ALBARAN+SQLNumero(ABase)+'] '+
    'Diferencia acumulada por modificaciones del albaran.';

  TxtQ:='INSERT INTO creditos'+Tienda+
    ' (CRE0,CRE1,CRE2,CRE3,CRE4,CRE5,CRE6,CRE7,CRE8,CRE9,CRE10,CRE11,CRE12,'+
    'CRE13,CRE14,CRE15,CRE16,CRE17,CRE18,CRE21) VALUES ('+
    IntToStr(FClienteAlbaran)+',"'+FormatDateTime('YYYY/MM/DD',FechaCredito)+'","'+
    FormatDateTime('HH:MM:SS',HoraCredito)+'","AL","'+SQLTexto(FSerieAlbaran)+'",'+
    IntToStr(FNumeroAlbaran)+',"MODIFICACION ALBARAN '+SQLTexto(FSerieAlbaran)+'/'+
    IntToStr(FNumeroAlbaran)+'",'+SQLNumero(Debe)+','+SQLNumero(Haber)+
    ',"N",1,"'+SQLTexto(FPuestoHistoricoAlbaran)+'","CREDITO",'+SQLNumero(Diferencia)+
    ',0,'+SQLNumero(Diferencia)+',0,'+SQLNumero(-Diferencia)+',0,"'+
    SQLTexto(Notas)+'")';
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:=TxtQ;
  dbTrabajo.ExecSQL;
  RehacerDetalleCreditoAjuste(FClienteAlbaran, FechaCredito, HoraCredito,
    FSerieAlbaran, FNumeroAlbaran, ABase, ATotalActual, Diferencia);
end;

function TFAlbaran.SincronizarCreditoAlbaran(const ATotalActual: Double): String;
var
  Cuenta, ClienteCredito: Integer;
  FechaCredito, HoraCredito: TDateTime;
  Debe, Haber, BaseAjuste, ImporteCredito: Double;
  EsAjuste: Boolean;
  Notas, TxtQ, Pregunta: String;
begin
  FechaCredito:=0;
  HoraCredito:=0;
  BaseAjuste:=0;
  Result:='Sin cambios en credito';
  if not FAlbaranModificado then Exit;

  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT COUNT(*) FROM creditos'+Tienda+
    ' WHERE CRE3="AL" AND CRE4="'+SQLTexto(FSerieAlbaran)+'" AND CRE5='+
    IntToStr(FNumeroAlbaran);
  dbTrabajo.Active:=True;
  Cuenta:=dbTrabajo.Fields[0].AsInteger;

  if Cuenta>1 then
    begin
      ShowMessage('Se han encontrado varios movimientos de credito para el albaran '+
        FSerieAlbaran+'/'+IntToStr(FNumeroAlbaran)+'.'+LineEnding+
        'No se ha actualizado ninguno para evitar duplicados.');
      Result:='NO actualizado: existen varios creditos';
      Exit;
    end;

  if Cuenta=1 then
    begin
      dbTrabajo.Active:=False;
      dbTrabajo.SQL.Text:='SELECT * FROM creditos'+Tienda+
        ' WHERE CRE3="AL" AND CRE4="'+SQLTexto(FSerieAlbaran)+'" AND CRE5='+
        IntToStr(FNumeroAlbaran)+' LIMIT 1';
      dbTrabajo.Active:=True;
      ClienteCredito:=dbTrabajo.FieldByName('CRE0').AsInteger;
      if ClienteCredito<>FClienteAlbaran then
        begin
          ShowMessage('El credito del albaran '+FSerieAlbaran+'/'+
            IntToStr(FNumeroAlbaran)+' pertenece al cliente '+
            IntToStr(ClienteCredito)+' y no al cliente '+
            IntToStr(FClienteAlbaran)+'.'+LineEnding+
            'No se ha actualizado para evitar mezclar cuentas.');
          Result:='NO actualizado: credito de otro cliente';
          dbTrabajo.Active:=False;
          Exit;
        end;
      FechaCredito:=dbTrabajo.FieldByName('CRE1').AsDateTime;
      HoraCredito:=dbTrabajo.FieldByName('CRE2').AsDateTime;
      Notas:=dbTrabajo.FieldByName('CRE21').AsString;
      EsAjuste:=EsCreditoAjuste(Notas, BaseAjuste);
      if EsAjuste then ImporteCredito:=ATotalActual-BaseAjuste
                  else ImporteCredito:=ATotalActual;
      if ImporteCredito>=0 then begin Debe:=ImporteCredito; Haber:=0; end
      else begin Debe:=0; Haber:=Abs(ImporteCredito); end;

      dbTrabajo.Active:=False;
      if EsAjuste and (Abs(ImporteCredito)<0.005) then
        begin
          dbTrabajo.SQL.Text:='DELETE FROM creditosdd'+Tienda+
            ' WHERE CRED3="'+SQLTexto(FSerieAlbaran)+'" AND CRED4='+IntToStr(FNumeroAlbaran);
          dbTrabajo.ExecSQL;
          dbTrabajo.SQL.Text:='DELETE FROM creditos'+Tienda+
            ' WHERE CRE3="AL" AND CRE4="'+SQLTexto(FSerieAlbaran)+'" AND CRE5='+
            IntToStr(FNumeroAlbaran);
          dbTrabajo.ExecSQL;
          Result:='Ajuste de credito eliminado al quedar la diferencia a cero';
          Exit;
        end;

      TxtQ:='UPDATE creditos'+Tienda+' SET CRE0='+IntToStr(FClienteAlbaran)+
        ',CRE7='+SQLNumero(Debe)+',CRE8='+SQLNumero(Haber)+
        ',CRE13='+SQLNumero(ImporteCredito)+',CRE14=0,CRE15='+SQLNumero(ImporteCredito)+
        ',CRE16=0,CRE17='+SQLNumero(-ImporteCredito);
      if EsAjuste then
        TxtQ:=TxtQ+',CRE6="MODIFICACION ALBARAN '+SQLTexto(FSerieAlbaran)+'/'+
          IntToStr(FNumeroAlbaran)+'"'
      else
        TxtQ:=TxtQ+',CRE21="'+SQLTexto(dbMuestrac.FieldByName('AC11').AsString)+'"';
      TxtQ:=TxtQ+' WHERE CRE3="AL" AND CRE4="'+SQLTexto(FSerieAlbaran)+
        '" AND CRE5='+IntToStr(FNumeroAlbaran);
      dbTrabajo.SQL.Text:=TxtQ;
      dbTrabajo.ExecSQL;

      if EsAjuste then
        begin
          RehacerDetalleCreditoAjuste(FClienteAlbaran, FechaCredito, HoraCredito,
            FSerieAlbaran, FNumeroAlbaran, BaseAjuste, ATotalActual, ImporteCredito);
          Result:='Ajuste de credito actualizado por '+FormatFloat('0.00',ImporteCredito);
        end
      else
        begin
          RehacerDetalleCreditoCompleto(FClienteAlbaran, FechaCredito, HoraCredito,
            FSerieAlbaran, FNumeroAlbaran);
          Result:='Credito existente actualizado a '+FormatFloat('0.00',ATotalActual);
        end;
      Exit;
    end;

  // No existe crédito. Para un albarán recién creado se ofrece el total completo.
  if FAlbaranNuevo then
    begin
      if Abs(ATotalActual)<0.005 then Exit;
      Pregunta:='El albaran '+FSerieAlbaran+'/'+IntToStr(FNumeroAlbaran)+
        ' no figura en la cuenta de credito.'+LineEnding+
        '¿Desea anotarlo ahora por '+FormatFloat('0.00',ATotalActual)+'?';
      if Application.MessageBox(PChar(Pregunta),'FacturLinEx',
        MB_ICONQUESTION+MB_YESNO)=IDYES then
        begin
          CrearCreditoCompleto(ATotalActual);
          Result:='Credito nuevo creado por '+FormatFloat('0.00',ATotalActual);
        end
      else Result:='Credito nuevo no añadido por decision del usuario';
      Exit;
    end;

  // Si era un albarán anterior y ya no existe el crédito, solo se anota
  // la diferencia de la modificación, nunca el documento completo.
  ImporteCredito:=ATotalActual-FTotalOriginalAlbaran;
  if Abs(ImporteCredito)<0.005 then
    begin
      Result:='Sin diferencia economica que anotar';
      Exit;
    end;
  Pregunta:='El albaran '+FSerieAlbaran+'/'+IntToStr(FNumeroAlbaran)+
    ' no tiene actualmente movimiento de credito.'+LineEnding+
    'La modificacion supone una diferencia de '+FormatFloat('0.00',ImporteCredito)+'.'+
    LineEnding+'¿Desea añadirla como MODIFICACION ALBARAN?';
  if Application.MessageBox(PChar(Pregunta),'FacturLinEx',
    MB_ICONQUESTION+MB_YESNO)=IDYES then
    begin
      CrearCreditoAjuste(FTotalOriginalAlbaran, ATotalActual);
      Result:='Ajuste de credito creado por '+FormatFloat('0.00',ImporteCredito);
    end
  else Result:='Diferencia no añadida por decision del usuario';
end;

procedure TFAlbaran.EliminarCreditoAlbaranExistente;
var
  Cuenta, ClienteCredito: Integer;
begin
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT CRE0 FROM creditos'+Tienda+
    ' WHERE CRE3="AL" AND CRE4="'+SQLTexto(FSerieAlbaran)+'" AND CRE5='+
    IntToStr(FNumeroAlbaran)+' LIMIT 2';
  dbTrabajo.Active:=True;
  Cuenta:=dbTrabajo.RecordCount;
  if Cuenta=0 then begin dbTrabajo.Active:=False; Exit; end;
  if Cuenta>1 then
    begin
      dbTrabajo.Active:=False;
      ShowMessage('El albaran tiene varios movimientos de credito. No se han borrado automaticamente.');
      Exit;
    end;
  ClienteCredito:=dbTrabajo.FieldByName('CRE0').AsInteger;
  dbTrabajo.Active:=False;
  if ClienteCredito<>FClienteAlbaran then
    begin
      ShowMessage('El credito del albaran pertenece al cliente '+
        IntToStr(ClienteCredito)+'. No se ha borrado para evitar afectar otra cuenta.');
      Exit;
    end;
  dbTrabajo.SQL.Text:='DELETE FROM creditosdd'+Tienda+
    ' WHERE CRED3="'+SQLTexto(FSerieAlbaran)+'" AND CRED4='+IntToStr(FNumeroAlbaran);
  dbTrabajo.ExecSQL;
  dbTrabajo.SQL.Text:='DELETE FROM creditos'+Tienda+
    ' WHERE CRE3="AL" AND CRE4="'+SQLTexto(FSerieAlbaran)+'" AND CRE5='+
    IntToStr(FNumeroAlbaran);
  dbTrabajo.ExecSQL;
end;

procedure TFAlbaran.RegistrarAuditoriaHistorico(const ATotalAnterior,
  ATotalNuevo: Double; const AResultadoCredito: String);
var
  Notas, Entrada: String;
begin
  dbHisopcc.Active:=False;
  if FHistoricoAlbaranLocalizado then
    dbHisopcc.SQL.Text:='SELECT * FROM hisopcc'+Tienda+
      ' WHERE HO0="'+FormatDateTime('YYYY/MM/DD',FFechaHistoricoAlbaran)+'"'+
      ' AND HO2="'+SQLTexto(FPuestoHistoricoAlbaran)+'"'+
      ' AND HO3='+IntToStr(FNumeroAlbaran)+' AND HO4="'+
      SQLTexto(FSerieAlbaran)+'" AND HO5="AL"'
  else
    dbHisopcc.SQL.Text:='SELECT * FROM hisopcc'+Tienda+
      ' WHERE HO3='+IntToStr(FNumeroAlbaran)+' AND HO4="'+
      SQLTexto(FSerieAlbaran)+'" AND HO5="AL" AND HO8='+
      IntToStr(FClienteAlbaran)+' ORDER BY HO0,HO1 LIMIT 1';
  dbHisopcc.Active:=True;
  if dbHisopcc.RecordCount=0 then Exit;

  FPuestoHistoricoAlbaran:=dbHisopcc.FieldByName('HO2').AsString;
  Notas:=NotasConAuditoria(dbMuestrac.FieldByName('AC11').AsString,
    dbHisopcc.FieldByName('HO18').AsString);
  if Pos(MARCA_AUDITORIA_ALBARAN, Notas)=0 then
    begin
      if Trim(Notas)<>'' then Notas:=TrimRight(Notas)+LineEnding+LineEnding;
      Notas:=Notas+MARCA_AUDITORIA_ALBARAN;
    end;
  Entrada:=FormatDateTime('DD/MM/YYYY HH:MM:SS',Now)+' - Puesto '+Puesto+
    ': total '+FormatFloat('0.00',ATotalAnterior)+' -> '+
    FormatFloat('0.00',ATotalNuevo)+' (diferencia '+
    FormatFloat('+0.00;-0.00;0.00',ATotalNuevo-ATotalAnterior)+'). Credito: '+
    AResultadoCredito+'.';
  Notas:=Notas+LineEnding+Entrada;

  dbHisopcc.Edit;
  dbHisopcc.FieldByName('HO8').AsInteger:=FClienteAlbaran;
  dbHisopcc.FieldByName('HO9').AsFloat:=ATotalNuevo;
  dbHisopcc.FieldByName('HO11').AsFloat:=ATotalNuevo;
  dbHisopcc.FieldByName('HO12').AsFloat:=ATotalNuevo;
  dbHisopcc.FieldByName('HO18').AsString:=Notas;
  dbHisopcc.Post;
  dbHisopcc.Active:=False;
end;

//=============== Crea el formulario ================
procedure ShowFormAlbaranes;
begin
  with TFAlbaran.Create(Application) do
    begin
       ShowModal;
    end;
end;
//======================= CREAR FORMULARIO ==========================
procedure TFAlbaran.FormCreate(Sender: TObject);
begin
  FEstiloModernoAplicado:=False;
  FPanelAtajos:=nil;
  FLabelAtajos:=nil;
  FOrdenGrid1Campo:='';
  FOrdenGrid1Direccion:='ASC';
  FOrdenGrid2Campo:='';
  FOrdenGrid2Direccion:='ASC';
  FBtnCalEdit3:=nil;
  FBtnCalEdit4:=nil;

  FAlbaranEnGestion:=False;
  FAlbaranModificado:=False;
  FAlbaranNuevo:=False;
  FTotalOriginalAlbaran:=0;
  FPuestoHistoricoAlbaran:=Puesto;
  FFechaHistoricoAlbaran:=0;
  FHoraHistoricoAlbaran:=0;
  FHistoricoAlbaranLocalizado:=False;

  //------------------- Tablas ------------------
  //-- MID(AC11,1,250)
  dbMuestrac.Sql.Text:='SELECT *,CONVERT(AC11 USING UTF8) as ANOTAS,C1 FROM albac'+Tienda+', clientes WHERE AC0=C0 ORDER BY AC2 ASC, AC1 DESC, AC3 DESC';
  dbMuestrac.Active := True;
  //-------------------- Tiendas
  dbTiendas.Active:=False;
  dbTiendas.Sql.Text:='SELECT * FROM tiendas WHERE T0='+NTienda;
  dbTiendas.Active:=True;
  if dbTiendas.Recordcount=0 then begin Showmessage('NO SE EN QUE TIENDA HACER EL ALBARAN'); Close(); end;
  //------------- Chequear ivas
  if IVA1=0 then showmessage('DEBE DEFINIR LOS TIPOS DE IVA EN LA CONFIGURACION');
  //------------- Cargar Series
  CargaSeries();//----- Cargar Series de facturacion
  if dbSeries.RecordCount=0 then begin showmessage('DEBE CREAR UNA SERIE DE FACTURACION'); Close(); end;

  //------------- Sólo documentos de la serie activa
  ComboBox1.Text:=Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString;
  ComboBox1Change(self);

  lMarcado:=0;
  Panel4.SendToBack; Panel4.Visible:=False;
  DBGrid2.SendToBack; DBGrid2.Visible:=False;
  AntColun:='0';Ordenado:=False; Orden:='DESC';

  AplicarEstiloModerno;
  FLXAplicarTemaVisual(Self);
end;


//============== TODAS LOS ALBARANES =====================
procedure TFAlbaran.RadioButton1Click(Sender: TObject);
begin
  Panel2.Visible:=False;
  Panel3.Visible:=False;
  //-- MID(AC11,1,250)
  dbMuestrac.Sql.Text:='SELECT *,CONVERT(AC11 USING UTF8) as ANOTAS,C1 FROM albac'+Tienda+', clientes WHERE AC0=C0 ORDER BY AC2 ASC, AC1 DESC, AC3 DESC';
  dbMuestrac.Active := True;
end;


//============== ALBARANES DE UN CLIENTE ========================
procedure TFAlbaran.RadioButton2Click(Sender: TObject);
begin
  Panel2.Visible:=True; Panel3.Visible:=False; Edit1.SetFocus;
end;
procedure TFAlbaran.BitBtn3Click(Sender: TObject);
begin
  If Edit1.Text='' then Exit;
  //-- MID(AC11,1,250)
  dbMuestrac.Sql.Text:='SELECT *,CONVERT(AC11 USING UTF8) as ANOTAS,C1 FROM albac'+Tienda+', clientes WHERE AC0=C0 AND AC0='+Edit1.Text+' ORDER BY AC2 ASC, AC1 DESC, AC3 DESC';
  dbMuestrac.Active := True;
  If dbMuestrac.RecordCount=0 then
    begin
      Showmessage('NO HAY ALBARANES DE ESTE CLIENTE');
      exit;
    end;

end;

//=================== CGO CLIENTE FLITRADO =======================
procedure TFAlbaran.Edit1Enter(Sender: TObject);
begin
   Edit2.Text:='';
end;
procedure TFAlbaran.Edit1Exit(Sender: TObject);
begin
   if Edit1.Text='' then Exit;
   if not (EsFloat(Edit1.Text)) then begin Edit1.Text:='0'; Edit1.SetFocus; exit; end;
   dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+Edit1.Text;
   dbClientes.Active:=True;
   If dbClientes.RecordCount=0 then
                               Begin    // Showmessage('ESE CLIENTE NO EXISTE.');
                                 BitBtn25Click(self);
                                 Edit2.SetFocus; Exit;
                               End;
   Edit2.Text:=dbClientes.FieldByName('C1').AsString;

   BitBtn3Click(self);  // Solo albaranes de ese cliente.

//   Edit1.SetFocus;
end;

//--------------- Busca Cliente -----------------------
procedure TFAlbaran.BitBtn25Click(Sender: TObject);
begin
   Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT C0,C1,C5 FROM clientes',['Código','Cliente','N.I.F.'],'C0');
   Edit2.SetFocus;
   Edit1Exit(self);
end;


//--------------- Buscar por nombre -----------------
procedure TFAlbaran.Edit2Exit(Sender: TObject);
begin
  if Edit2.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit2.SetFocus; Exit; end;
  dbBusca.SQL.Text:='SELECT C0,C1 FROM clientes WHERE C1="'+Edit2.Text+'"'; dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then
                             begin
                               Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT C0,C1,C5 FROM clientes WHERE C1 LIKE "'+Edit2.Text+'%"',
                                                         ['Código', 'Cliente', 'N.I.F.'],'C0');
                               Edit1Exit(self);
                               Exit;
                              end;
  Edit1.Text:=dbBusca.FieldByName('C0').AsString;
  Edit1Exit(self);
end;
//---------------- Buscar por nombre ------------------
procedure TFAlbaran.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) then Edit2Exit(self);
  Exit;
end;


//============== ALBARANES ENTRE FECHAS ========================
procedure TFAlbaran.RadioButton3Click(Sender: TObject);
begin
  Panel3.Visible:=True;
  Panel2.Visible:=False;
  Edit3.Text:=FormatDateTime('DD/MM/YYYY',Date);
  Edit4.Text:=FormatDateTime('DD/MM/YYYY',Date);
  PrepararCalendariosVisibles;
  Edit3.SetFocus;
end;
procedure TFAlbaran.BitBtn4Click(Sender: TObject);
var
  FechaDesde, FechaHasta: TDateTime;
begin
  if not TryStrToDate(Trim(Edit3.Text), FechaDesde) then
  begin
    ShowMessage('LA FECHA DESDE NO ES VÁLIDA.');
    Edit3.SetFocus;
    Exit;
  end;

  if not TryStrToDate(Trim(Edit4.Text), FechaHasta) then
  begin
    ShowMessage('LA FECHA HASTA NO ES VÁLIDA.');
    Edit4.SetFocus;
    Exit;
  end;

  if FechaDesde > FechaHasta then
  begin
    ShowMessage('LA FECHA DESDE NO PUEDE SER POSTERIOR A LA FECHA HASTA.');
    Edit3.SetFocus;
    Exit;
  end;

  //-- MID(AC11,1,250)
  dbMuestrac.Sql.Text:='SELECT *,CONVERT(AC11 USING UTF8) as ANOTAS,C1 FROM albac'+Tienda+', clientes WHERE AC0=C0 AND AC1>="'+FormatDateTime('YYYY/MM/DD',FechaDesde)+'" AND AC1<="'+FormatDateTime('YYYY/MM/DD',FechaHasta)+'" ORDER BY AC2 ASC, AC1 DESC, AC3 DESC';
  dbMuestrac.Active := True;
  If dbMuestrac.RecordCount=0 then
    begin
      Showmessage('NO HAY ALBARANES ENTRE ESAS FECHAS');
      exit;
    end;
end;

procedure TFAlbaran.RadioGroup2Click(Sender: TObject);
var
  iniMuestrac, finMuestrac: string;
  txtMarcado: string;
  lCambio: integer;        //lCambio copia a lMarcado cuando entra en la función.
begin
  lCambio:= lMarcado;
  iniMuestrac:=dbMuestrac.SQL.Text; finMuestrac:=iniMuestrac;

  if (lMarcado<>0) then
    begin
       Delete(iniMuestrac, pos('ORDER', dbMuestrac.SQL.Text)-14 , length(dbMuestrac.SQL.Text));
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

  if (lMarcado<>lCambio) then dbMuestrac.SQL.Text:= iniMuestrac + ' AND AC10="'+txtMarcado+'" ' + finMuestrac;

  dbMuestrac.Active:= true;

end;

//==================== ORDENAR AL PULSAR EN EL TITULO =======================
procedure TFAlbaran.DBGridPrepareCanvas(Sender: TObject; DataCol: Integer;
  Column: TColumn; aState: TGridDrawState);
begin
  if (Sender is TDBGrid) and (gdSelected in aState) then
    TDBGrid(Sender).Canvas.Font.Color := clBlack;
end;

procedure TFAlbaran.DBGrid1TitleClick(Column: TColumn);
begin
  OrdenarGrid(dbMuestrac, DBGrid1, Column,
    FOrdenGrid1Campo, FOrdenGrid1Direccion);
end;

procedure TFAlbaran.DBGrid2TitleClick(Column: TColumn);
begin
  OrdenarGrid(dbMuestrad, DBGrid2, Column,
    FOrdenGrid2Campo, FOrdenGrid2Direccion);
end;

//===========================================================
//===================== GESTIONAR ALBARANES ==================
//===========================================================
procedure TFAlbaran.BitBtn1Click(Sender: TObject);
begin
  If dbMuestrac.RecordCount=0 then Begin Showmessage('NO HAY NINGUNA ALBARAN PARA GESTIONAR'); Exit; End;
  dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+dbMuestrac.FieldByName('AC0').AsString;
  dbClientes.Active:=True;
  If dbClientes.RecordCount=0 then Begin Showmessage('SE HA BORRADO EL CLIENTE '+dbMuestrac.FieldByName('AC0').AsString+' ?'); Exit; End;
  InicializarControlAlbaran;
  if not ValidarClienteDocumento then
    begin
      FAlbaranEnGestion:=False;
      FAlbaranModificado:=False;
      Exit;
    end;
  Panel4.BringToFront; Panel4.Visible:=True;
  DBGrid2.BringToFront; DBGrid2.Visible:=True;
  MostrarBotonesdd();
  ActualizarPieAtajos;
  LimpiaCliente();
  //-- MID(AD6,1,150)
  dbMuestrad.SQL.Text:='SELECT *, CONVERT(AD6 USING UTF8) As DESCRI FROM albad'+Tienda+' WHERE AD0='+dbMuestrac.FieldByName('AC0').AsString+
                     ' AND AD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('AC1').AsDateTime)+'"'+
                     ' AND AD2="'+dbMuestrac.FieldByName('AC2').AsString+'"'+
                     ' AND AD3='+dbMuestrac.FieldByName('AC3').AsString;
  dbMuestrad.Active:=True;
  PintaCliente();
  Label30.Caption:=dbMuestrac.FieldByName('AC2').AsString;//---- Serie
  Label31.Caption:=dbMuestrac.FieldByName('AC3').AsString;//---- N. Albaran
  Label33.Caption:=dbMuestrac.FieldByName('AC1').AsString;//---- Fecha Fact.
  LabelTotal.Caption:=FormatFloat('0.00',dbMuestrac.FieldByName('AC9').AsFloat);
  DbGrid2.SetFocus;

end;

//--------------------- Salir de gestionar albaranes ------------
procedure TFAlbaran.BitBtn5Click(Sender: TObject);
var
  Posi: Integer;
  TxtQ, TxtTemp, ResultadoCredito: String;
  NuevoTotal: Double;
begin
  Panel7.Visible:=False;
  Panel4.SendToBack; Panel4.Visible:=False;
  DBGrid2.SendToBack; DBGrid2.Visible:=False;
  OcultarBotonesdd();
  dbAlbad.Active:=False;
  //------------- Si el albaran no tiene lineas borrarla?
  If dbMuestrad.RecordCount=0 then
     begin
       boxstyle :=  MB_ICONQUESTION + MB_YESNO;
       If Application.MessageBox('CONFIRME EL BORRADO DEL ALBARAN COMPLETO?','FacturLinEx', boxstyle) = IDNO Then
          Exit;

       ActuHisopcc(2);
       EliminarCreditoAlbaranExistente;

       TxtTemp:=dbMuestrac.SQL.Text;
       TxtQ:='DELETE FROM albac'+Tienda+' WHERE AC0='+dbMuestrac.FieldByName('AC0').AsString+
             ' AND AC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('AC1').AsDateTime)+'"'+
             ' AND AC2="'+dbMuestrac.FieldByName('AC2').AsString+'" AND AC3='+dbMuestrac.FieldByName('AC3').AsString;
       dbAlbac.SQL.Text:=TxtQ; dbAlbac.ExecSQL;
       FAlbaranEnGestion:=False;
       FAlbaranModificado:=False;
       dbMuestrac.Active:=False;
       dbMuestrac.Sql.Text:=TxtTemp;
       dbMuestrac.Active:=True;
       DBGrid1.SetFocus;
       Exit;
     end;
  //------------- Actualizar cabecera albaranes
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT COUNT(*), SUM(AD7), SUM(AD11), SUM(AD13) FROM albad'+Tienda+' WHERE'+
                     ' AD0='+dbMuestrac.FieldByName('AC0').AsString+
                     ' AND AD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('AC1').AsDateTime)+'"'+
                     ' AND AD2="'+dbMuestrac.FieldByName('AC2').AsString+'"'+
                     ' AND AD3='+dbMuestrac.FieldByName('AC3').AsString;
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then exit;
  NuevoTotal:=dbTrabajo.Fields[3].AsFloat;
  TxtQ:='UPDATE albac'+Tienda+' SET AC4='+dbTrabajo.Fields[0].AsString+', AC5='+dbTrabajo.Fields[1].AsString+
        ', AC8='+dbTrabajo.Fields[2].AsString+', AC9='+dbTrabajo.Fields[3].AsString+
        ' WHERE AC0='+dbMuestrac.FieldByName('AC0').AsString+
        ' AND AC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('AC1').AsDateTime)+'"'+
        ' AND AC2="'+dbMuestrac.FieldByName('AC2').AsString+'" AND AC3='+dbMuestrac.FieldByName('AC3').AsString;
  dbAlbac.SQL.Text:=TxtQ; dbAlbac.ExecSQL;

  ResultadoCredito:=SincronizarCreditoAlbaran(NuevoTotal);
  if FAlbaranModificado then
    RegistrarAuditoriaHistorico(FTotalOriginalAlbaran, NuevoTotal, ResultadoCredito);

  FTotalOriginalAlbaran:=NuevoTotal;
  FAlbaranNuevo:=False;
  FAlbaranModificado:=False;
  FAlbaranEnGestion:=False;

  Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;
  DBGrid1.SetFocus;

end;

//===========================================================
//======================= CREAR LINEAS ======================
//===========================================================
procedure TFAlbaran.BitBtn12Click(Sender: TObject);
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
procedure TFAlbaran.BitBtn14Click(Sender: TObject);
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
  SumarStock(dbMuestrad.FieldByName('AD5').AsString, dbMuestrad.FieldByName('AD7').AsString );
  RestarEsta(dbMuestrad.FieldByName('AD5').AsString, dbMuestrad.FieldByName('AD7').AsString,
            dbMuestrad.FieldByName('AD11').AsString);

  ActuHistoclie(1);     // Lo ponemos en modo borrado.
  ActuHisopcc(1);        // Activamos el modo borrado.
  dbMuestrad.Delete;
  MarcarAlbaranModificado;
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
procedure TFAlbaran.DBGrid2DblClick(Sender: TObject);
begin

  ActivaPrecios();

  if (dbMuestrad.Active=False) or (dbMuestrad.RecordCount=0) then exit;
  Panel7.Visible:=False;
  Panel6.BringToFront;Panel6.Visible:=True; Panel1.Enabled:=False; DBGrid2.Enabled:=False;
  label28.Caption:=' Editando línea '; //+ dbMuestrad.FieldByName('AD4').AsString;
  Edit5.Text:=dbMuestrad.FieldByName('AD5').AsString;
  Edit5.Enabled:=False;
  Edit6.Text:=dbMuestrad.FieldByName('AD6').AsString;

  CantidadLinea:=dbMuestrad.FieldByName('AD7').AsFloat;
  PrecioConIva:=dbMuestrad.FieldByName('AD8').AsFloat;
  PrecioSinIva:=dbMuestrad.FieldByName('AD9').AsFloat;
  DescuentoLinea:=dbMuestrad.FieldByName('AD10').AsFloat;
  TotalSinIvaLinea:=dbMuestrad.FieldByName('AD11').AsFloat;
  IvaLinea:=dbMuestrad.FieldByName('AD12').AsFloat;
  TotalLinea:=dbMuestrad.FieldByName('AD13').AsFloat;

  CargaValores();

  Edit23.Text:=FormatFloat('0.00',dbMuestrad.FieldByName('AD17').AsFloat);
  Edit6.SetFocus;
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit5.Text+'"';
  dbArti.Active:=True;
  CargaTarifas(0);
  ActualizarPieAtajos;
end;

procedure TFAlbaran.DBGrid2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if key=VK_RETURN then begin Key:=0; DBGrid2DblClick(self); end;
end;


//----------------- Salir Crear / Modificar Lineas ------------------
procedure TFAlbaran.BitBtn6Click(Sender: TObject);
begin
  ListBox2.Visible:=False;
 // Panel6.SendToBack;
  Panel6.Visible:=False; DBGrid1.Enabled:= True;
  Panel1.Enabled:=True; DBGrid2.Enabled:=True; DBGrid2.SetFocus;
  ActualizarPieAtajos;
end;


//----------------- Aceptar Crear / Modificar Lineas ----------------
procedure TFAlbaran.BitBtn8Click(Sender: TObject);
var
 Posi: Integer;
begin

   HayStock;

   ActivaPrecios();

   if Edit5.Enabled=False then
   begin
    //----- Modificar Linea
    SumarStock(dbMuestrad.FieldByName('AD5').AsString, dbMuestrad.FieldByName('AD7').AsString );
    RestarEsta(dbMuestrad.FieldByName('AD5').AsString, dbMuestrad.FieldByName('AD7').AsString,
              dbMuestrad.FieldByName('AD11').AsString);

    dbMuestrad.Edit; Llenadd(); dbMuestrad.Post;
    MarcarAlbaranModificado;

    RestarStock(Edit5.Text,Edit7.Text);
    SumarEsta(Edit5.Text,Edit7.Text,Edit11.Text);

  //  Panel6.SendToBack;
    Panel6.Visible:=False; DBGrid1.Enabled:= True;
    Panel1.Enabled:=True; DBGrid2.Enabled:=True;
    Posi:=dbMuestrad.RecNo; dbMuestrad.Refresh; dbMuestrad.RecNo:=Posi;
    ActualizaImporte;
    DBGrid2.SetFocus;

    ActuHistoclie(0);         // Actualiza histórico de clientes.
    ActuHisopcc(0);         // Actualiza histórico de operaciones.
    ActualizarPieAtajos;
   end
 else
   begin
    //----- Crear linea
    dbMuestrad.Append; Llenadd(); dbMuestrad.Post;
    MarcarAlbaranModificado;
    RestarStock(Edit5.Text, Edit7.Text);
    SumarEsta(Edit5.Text,Edit7.Text,Edit11.Text);
    Limpiadd(); Edit5.SetFocus;
    Posi:=dbMuestrad.RecNo; dbMuestrad.Refresh; dbMuestrad.RecNo:=Posi;
    ActualizaImporte;
    ActuHistoclie(0);         // Actualiza histórico de clientes.
    ActuHisopcc(0);         // Actualiza histórico de operaciones.
   end;

end;

//===========================================================
//===================== NUEVO ALBARAN =======================
//===========================================================
procedure TFAlbaran.BitBtn9Click(Sender: TObject);
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
end;

procedure TFAlbaran.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then begin key:=0; BitBtn1Click(self); end;

end;

//---------------- Ver series cuando se pasa por ellas (Nuevo Albaran)----------------
procedure TFAlbaran.ListBox1Click(Sender: TObject);
begin
  if dbSeries.Locate('SF0',trim(copy(ListBox1.Items.Strings[ListBox1.ItemIndex],1,3)),[]) then
    Edit21.Text:=dbSeries.FieldByName('SF3').AsString;
end;

procedure TFAlbaran.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then begin key:=0; BitBtn19Click(self); end;
end;
//---------------- En el combo de cabecera
procedure TFAlbaran.ComboBox1Change(Sender: TObject);
var
  SerieAVer,TxtQ: String;
begin
  SerieAVer:=  trim(copy(ComboBox1.Text,1,3));
  //-- MID(AC11,1,250)
  if ComboBox1.Text='TODAS LAS SERIES' then
     TxtQ:='SELECT *,CONVERT(AC11 USING UTF8) as ANOTAS,C1 FROM albac'+Tienda+
           ', clientes WHERE AC0=C0 ORDER BY AC2 ASC, AC1 DESC, AC3 DESC'
  else
     TxtQ:='SELECT *,CONVERT(AC11 USING UTF8) as ANOTAS,C1 FROM albac'+Tienda+
           ', clientes WHERE AC0=C0 AND AC2="'+SerieAVer+'" ORDER BY AC2 ASC, AC1 DESC, AC3 DESC';
  dbMuestrac.Active := False;
  dbMuestrac.Sql.Text:=TxtQ;
  dbMuestrac.Active := True;
end;

//---------------- Aceptar nuevo albaran ----------------
procedure TFAlbaran.BitBtn19Click(Sender: TObject);
var
 iniMuestrac, finMuestrac: string;
 inicioSerie, finalSerie: integer;
begin
  SALBARAN:=dbSeries.FieldByName('SF0').AsString;
  if SALBARAN='' then begin showmessage('DEBE SELECCIONAR UNA SERIE PARA FACTURAR'); Exit; end;
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM albac'+Tienda+' WHERE AC0='+Edit1.Text+' ORDER BY AC0, AC1, AC2, AC3';
  dbTrabajo.Active:=True;
  //if swhueco=0 then NumeroAlbaran();
  NumeroAlbaran();
  dbtrabajo.Append;
  dbtrabajo.FieldByName('AC0').AsString:=Edit1.Text; //-------------- Cliente.
  dbtrabajo.FieldByName('AC1').Value:=StrToDate(Edit22.Text); //----- Fecha Albaran.
  dbtrabajo.FieldByName('AC2').Value:=SALBARAN; //------------------- Serie de la albaran.
  dbtrabajo.FieldByName('AC3').Value:=NALBARAN; //------------------- N. Albaran.
  dbtrabajo.FieldByName('AC4').Value:=0;
  dbtrabajo.FieldByName('AC5').Value:=0;
  dbtrabajo.FieldByName('AC6').Value:=0;
  dbtrabajo.FieldByName('AC7').Value:=dbClientes.Fields[19].AsString;//-- Recargo S/N
  dbtrabajo.FieldByName('AC8').Value:=0;//------------------------------- Imp. Sin IVA
  dbtrabajo.FieldByName('AC9').Value:=0;//------------------------------- Imp. Con IVA
  dbtrabajo.FieldByName('AC10').Value:='N';//---------------------------- Marcada (S/N)
  dbtrabajo.Post;

  if checkbox4.Checked then
        begin
          iniMuestrac:=dbMuestrac.SQL.Text; finMuestrac:=iniMuestrac;
          Delete(iniMuestrac, pos('WHERE', dbMuestrac.SQL.Text)+5 , length(dbMuestrac.SQL.Text));
          Delete(finMuestrac, 1, pos('WHERE',dbMuestrac.SQL.Text)+5  );

          inicioSerie:= pos('AC2="', finMuestrac);  //Eliminamos la serie anterior si la hubiese.
          if inicioSerie <> 0 then
           begin
            finalSerie:=pos(' ', finMuestrac);
            delete(finMuestrac, inicioSerie, finalSerie-inicioSerie+5);
           end;

          dbMuestrac.Active:= false;
          dbMuestrac.SQL.Text:= iniMuestrac + ' AC2="'+SALBARAN+'" AND ' + finMuestrac;
          dbMuestrac.Active:= true;
        end;
//  showmessage(dbMuestrac.SQL.Text);

  dbMuestrac.Refresh; dbMuestrac.First;
  BitBtn20Click(BitBtn20);//--- Cerrar Panel
end;

//---------------- Cancelar nuevo albaran ----------------
procedure TFAlbaran.BitBtn20Click(Sender: TObject);
begin
  Panel8.Visible:=False; Panel1.Enabled:=True; DBGrid1.Enabled:=True;
  dbGrid1.SetFocus;
end;

//===========================================================
//================ BORRAR ALBARAN COMPLETO ==================
//===========================================================
procedure TFAlbaran.BitBtn10Click(Sender: TObject);
var
  TxtQ, TxtTemp: String;
begin
  If dbMuestrac.RecordCount=0 then Begin Showmessage('NO HAY NINGUN ALBARAN PARA GESTIONAR'); Exit; End;
  dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+dbMuestrac.FieldByName('AC0').AsString;
  dbClientes.Active:=True;
  If dbClientes.RecordCount=0 then Begin Showmessage('SE HA BORRADO EL CLIENTE '+dbMuestrac.FieldByName('AC0').AsString+' ?'); Exit; End;
  boxstyle :=  MB_ICONQUESTION + MB_YESNO;
  If Application.MessageBox('CONFIRME EL BORRADO DEL ALBARAN COMPLETO?','FacturLinEx', boxstyle) = IDNO Then Exit;

  //-- MID(AD6,1,150)
  dbMuestrad.SQL.Text:='SELECT *, CONVERT(AD6 USING UTF8) As DESCRI FROM albad'+Tienda+' WHERE AD0='+dbMuestrac.FieldByName('AC0').AsString+
                     ' AND AD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('AC1').AsDateTime)+'"'+
                     ' AND AD2="'+dbMuestrac.FieldByName('AC2').AsString+'"'+
                     ' AND AD3='+dbMuestrac.FieldByName('AC3').AsString;
  dbMuestrad.Active:=True;
  InicializarControlAlbaran;
  if not ValidarClienteDocumento then
    begin
      FAlbaranEnGestion:=False;
      FAlbaranModificado:=False;
      dbMuestrad.Active:=False;
      Exit;
    end;
  if dbMuestrad.RecordCount<>0 then
    begin
      while not dbMuestrad.EOF do
        begin
          //------ Sumar las cantidades al stock
          SumarStock(dbMuestrad.FieldByName('AD5').AsString, dbMuestrad.FieldByName('AD7').AsString );
          RestarEsta(dbMuestrad.FieldByName('AD5').AsString, dbMuestrad.FieldByName('AD7').AsString,
            dbMuestrad.FieldByName('AD11').AsString);

          ActuHistoClie(1);
          ActualizaImporte();
          ActuHisopcc(1);

          dbMuestrad.Next;
        end;

    end;
  //----------------- Borrar detalles de albaranes
  TxtQ:='DELETE FROM albad'+Tienda+' WHERE AD0='+dbMuestrac.FieldByName('AC0').AsString+
        ' AND AD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('AC1').AsDateTime)+'"'+
        ' AND AD2="'+dbMuestrac.FieldByName('AC2').AsString+'" AND AD3='+dbMuestrac.FieldByName('AC3').AsString;
  dbAlbad.SQL.Text:=TxtQ; dbAlbad.ExecSQL;

  //----------------- Borrar cabeceras de albaranes
  ActuHisopcc(2);
  EliminarCreditoAlbaranExistente;
  TxtTemp:=dbMuestrac.SQL.Text;
  TxtQ:='DELETE FROM albac'+Tienda+' WHERE AC0='+dbMuestrac.FieldByName('AC0').AsString+
        ' AND AC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('AC1').AsDateTime)+'"'+
        ' AND AC2="'+dbMuestrac.FieldByName('AC2').AsString+'" AND AC3='+dbMuestrac.FieldByName('AC3').AsString;
  dbAlbac.SQL.Text:=TxtQ; dbAlbac.ExecSQL;

  //dbMuestrac.Refresh;
  dbMuestrac.Active:=False;
  dbMuestrac.Sql.Text:=TxtTemp;
  dbMuestrac.Active:=True;

end;

//===========================================================
//================= LISTADO DE ALBARANES CABECERAS ===========
//===========================================================
procedure TFAlbaran.BitBtn23Click(Sender: TObject);
begin
  Panel9.Visible:=True; Edit14.SetFocus;
  Edit14.Text:='1'; Edit16.Text:=ClienteVario;
  Edit18.Text:=FormatDateTime('DD/MM/YYYY',Date);
  Edit19.Text:=FormatDateTime('DD/MM/YYYY',Date);
end;

//---------- Aceptar listado de albaranes cc ----------
procedure TFAlbaran.BitBtn21Click(Sender: TObject);
begin
  If (Edit14.Text='') or (Edit16.Text='') then Exit;
  dbBusca.Sql.Text:='SELECT *,C1 FROM albac'+Tienda+', clientes WHERE AC0=C0'+
                    ' AND AC1>="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit18.Text))+'"'+
                    ' AND AC1<="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit19.Text))+'"'+
                    ' AND AC0>='+Edit14.Text+' AND AC0<='+Edit16.Text+' ORDER BY AC2 ASC, AC1 DESC, AC3 DESC';
  dbBusca.Active := True;
  If dbBusca.RecordCount=0 then
    begin
      Showmessage('NO HAY ALBARANES ENTRE ESOS DATOS');
      exit;
    end;
  FImpresion.Imprime(dbBusca.SQL.Text, 'ListaAlbaranes','');

end;

//-------------------- Desde cliente ---------------
procedure TFAlbaran.Edit14Enter(Sender: TObject);
begin
   Edit15.Text:='';
end;
procedure TFAlbaran.Edit14Exit(Sender: TObject);
begin
   if Edit14.Text='' then Edit14.Text:='1';
   dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+Edit14.Text;
   dbClientes.Active:=True;
   If dbClientes.RecordCount=0 then Begin Showmessage('ESE CLIENTE NO EXISTE.'); Edit14.SetFocus; Exit; End;
   Edit15.Text:=dbClientes.FieldByName('C1').AsString;
end;

//-------------------- Hasta cliente ---------------
procedure TFAlbaran.Edit16Enter(Sender: TObject);
begin
   Edit17.Text:='';
end;
procedure TFAlbaran.Edit16Exit(Sender: TObject);
begin
   if Edit16.Text='' then Edit16.Text:='99999999';
   dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0='+Edit16.Text;
   dbClientes.Active:=True;
   If dbClientes.RecordCount=0 then Begin Showmessage('ESE CLIENTE NO EXISTE.'); Edit16.SetFocus; Exit; End;
   Edit17.Text:=dbClientes.FieldByName('C1').AsString;
end;

//---------- Cerrar listado de albaranes cc ----------
procedure TFAlbaran.BitBtn22Click(Sender: TObject);
begin
  Panel9.Visible:=False;
end;

//===========================================================
//==================== IMPRIMIR ALBARAN =====================
//===========================================================
procedure TFAlbaran.BitBtn15Click(Sender: TObject);
begin

 EstadoImpresion:=FImpresion.Imprime(dbMuestrad, dbMuestrac, dbClientes, 'ALBARAN', false, 1);

 if (EstadoImpresion=1) then MenuItem3Click(Self);

 if (EstadoImpresion=2) then MenuItem4Click(Self);

 if (EstadoImpresion=3) then
       begin
         MenuItem3Click(Self); EstadoImpresion:=2;
         MenuItem4Click(Self);
       end;

end;

//=================== OBSERVACIONES ==========================
procedure TFAlbaran.BitBtn16Click(Sender: TObject);
begin
  Panel7.BringToFront;
  Panel7.Visible:=True;
  Memo1.Lines.Text:=dbMuestrac.FieldByName('AC11').AsString;
  Memo1.SetFocus;
  ActualizarPieAtajos;
end;
//--------------- Aceptar Observaciones --------
procedure TFAlbaran.BitBtn18Click(Sender: TObject);
var
 Posi: Integer;
 TxtQ: String;
begin
  if Memo1.Lines.Text<>dbMuestrac.FieldByName('AC11').AsString then
    MarcarAlbaranModificado;
  TxtQ:='UPDATE albac'+Tienda+' SET AC11="'+SQLTexto(Memo1.Lines.Text)+'" WHERE AC0='+dbMuestrac.FieldByName('AC0').AsString+
        ' AND AC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('AC1').AsDateTime)+'"'+
        ' AND AC2="'+dbMuestrac.FieldByName('AC2').AsString+'" AND AC3='+dbMuestrac.FieldByName('AC3').AsString;
  dbAlbac.SQL.Text:=TxtQ; dbAlbac.ExecSQL;
  Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;
  Panel7.SendToBack; Panel7.Visible:=False;
  dbGrid2.SetFocus;
  ActualizarPieAtajos;
end;

//--------------- Cancelar Observaciones --------
procedure TFAlbaran.BitBtn17Click(Sender: TObject);
begin
  Panel7.SendToBack; Panel7.Visible:=False; dbGrid2.SetFocus;
  ActualizarPieAtajos;
end;

//=============== SALIR DEL CGO. ARTICULO =====================
procedure TFAlbaran.Edit5Exit(Sender: TObject);
var
  codigotmp: String;
begin
  if (Edit5.Enabled=False) or (Edit5.Text='') then exit;
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
        codigotmp:='';
        codigotmp:=FBusquedas.IniciaBusquedas('SELECT A0, EAN0, A1 FROM artitien'+Tienda+
                                              ', eans WHERE (EAN1=A0) and (A0 LIKE "%'+Edit5.Text+'%")', ['Código','Ean','Referencia'],'A0');
        if codigotmp='-1' then begin Edit5.SetFocus; exit; end;
        Edit5.Text:=codigotmp;
        dbArti.Active:=False;
        dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+edit5.Text+'"';
        dbArti.Active:=True;
      end
     else
      begin
        Edit5.Text:=dbBusca.FieldByName('EAN1').AsString;
        dbArti.Active:=False;
        dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit5.Text+'"';
        dbArti.Active:=True;
      end;
   end;
  Edit6.SetFocus;
  Pintadd();
  CargaTarifas(1);
end;


procedure TFAlbaran.BitBtn11Click(Sender: TObject);
begin
  BuscaArticulo();
end;

//------------------ Buscar Articulos ---------------
procedure TFAlbaran.BuscaArticulo();
begin
  Edit5.Text:=FBusquedas.IniciaBusquedas('SELECT A0, EAN0, A1 FROM artitien'+Tienda+
            ' , eans WHERE (A0=EAN1) and (A0 LIKE "%'+Edit5.Text+'%" )', ['Código','Ean','Referencia'],'A0');
  Edit5Exit(self);
end;

procedure TFAlbaran.Edit6DblClick(Sender: TObject);
var
   key: char;
begin
  if Edit5.Enabled=false then exit;
  key:=#13;
  Edit6KeyPress(self, key);

end;

procedure TFAlbaran.Edit6KeyPress(Sender: TObject; var Key: char);
begin
  if (Key<>#13) or (edit5.Enabled=false) then Exit;
  if Edit6.Text='' then begin ShowMessage('TECLEE EL ARTÍCULO A BUSCAR'); Edit6.SetFocus; Exit; end;
  ListBox3.Items.Clear;
  dbBusca.SQL.Text:='SELECT A0,A1 FROM artitien'+Tienda+' WHERE A1 LIKE "%'+Edit6.Text+'%"'; dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then
    begin
      ShowMessage('NO HAY ARTÍCULOS QUE CONTENGAN ESE CONCEPTO');
      dbBusca.Active:=False; Edit6.SetFocus; Exit;
    end;
  dbBusca.First;
  While not dbBusca.EOF do
    begin
      ListBox3.Items.Add(dbBusca.FieldByName('A1').AsString);
      dbBusca.Next;
    end;
    ListBox3.BringToFront;
    ListBox3.Visible:=True;
    AjustarLayoutModerno;
    ListBox3.ItemIndex:=0;
    ListBox3.SetFocus;

end;

procedure TFAlbaran.ListBox3DblClick(Sender: TObject);
begin
  if not dbBusca.Locate('A1',ListBox3.Items.Strings[ListBox3.ItemIndex],[]) then begin Edit6.Text:=''; Exit; end;
  Edit5.Text:=dbBusca.Fields[0].AsString;
  Edit6.Text:=dbBusca.Fields[1].AsString;
//  Edit5Exit(Edit5);//---- Leer articulo
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit5.Text+'"';
  dbArti.Active:=True;
  Pintadd();
  CargaTarifas(1);
  ListBox3.Visible:=False;
  AjustarLayoutModerno;
  Edit7.SetFocus;
end;

procedure TFAlbaran.ListBox3Exit(Sender: TObject);
begin
  ListBox3.Visible:=False;
  AjustarLayoutModerno;
end;

procedure TFAlbaran.ListBox3KeyPress(Sender: TObject; var Key: char);
begin
   if (Key=#13) then ListBox3DblClick(self);
end;

procedure TFAlbaran.MenuItem1Click(Sender: TObject);
Var
  TxtQ, Marca: String;
  Posi: Integer;
  contador: integer;

begin
   For contador:= 0 to DBGrid1.SelectedRows.Count-1 do
   begin

     Marca:='S';
     if dbMuestrac.FieldByName('AC10').AsString='S' then Marca:='N';
     TxtQ:='UPDATE albac'+Tienda+' SET AC10="'+Marca+'" WHERE AC0='+dbMuestrac.FieldByName('AC0').AsString+
               ' AND AC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('AC1').AsDateTime)+'"'+
          ' AND AC2="'+dbMuestrac.FieldByName('AC2').AsString+'" AND AC3='+dbMuestrac.FieldByName('AC3').AsString;
     dbAlbac.SQL.Text:=TxtQ; dbAlbac.ExecSQL;

   end;
   Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;

end;

procedure TFAlbaran.MenuItem2Click(Sender: TObject);
  Var
  TxtQ, Marca, Basura: String;
  Posi: Integer;
  contador: Integer;
begin
   AlbaranesPagados:='';

   For contador:= 0 to DBGrid1.SelectedRows.Count-1 do
   begin

     dbMuestrac.GotoBookmark(pointer(DBGrid1.SelectedRows.Items[contador]));
     Marca:='S';

     if dbMuestrac.FieldByName('AC12').AsString='S' then  Marca:='N'
      else AlbaranesPagados:= AlbaranesPagados + '  ' + dbMuestrac.FieldByName('AC2').AsString +
                           '-'+dbMuestrac.FieldByName('AC3').AsString;

    TxtQ:='UPDATE albac'+Tienda+' SET AC12="'+Marca+'" WHERE AC0='+dbMuestrac.FieldByName('AC0').AsString+
              ' AND AC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('AC1').AsDateTime)+'"'+
         ' AND AC2="'+dbMuestrac.FieldByName('AC2').AsString+'" AND AC3='+dbMuestrac.FieldByName('AC3').AsString;
     dbAlbac.SQL.Text:=TxtQ; dbAlbac.ExecSQL;
   end;

   Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;

   // Impresión del recibo de pago.

   if (AlbaranesPagados<>'') then
     begin
      edRecibos.Text:=AlbaranesPagados;
      panelRecibos.Visible:=True;
      edRecibos.SetFocus;
    end;
end;

procedure TFAlbaran.MenuItem3Click(Sender: TObject);
  Var
    TxtQ, Marca: String;
    Posi: Integer;
  begin
       Marca:='S';
       if (dbMuestrac.FieldByName('AC13').AsString='S') and (EstadoImpresion=0) then Marca:='N';
       TxtQ:='UPDATE albac'+Tienda+' SET AC13="'+Marca+'" WHERE AC0='+dbMuestrac.FieldByName('AC0').AsString+
                 ' AND AC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('AC1').AsDateTime)+'"'+
            ' AND AC2="'+dbMuestrac.FieldByName('AC2').AsString+'" AND AC3='+dbMuestrac.FieldByName('AC3').AsString;
       dbAlbac.SQL.Text:=TxtQ; dbAlbac.ExecSQL;

       EstadoImpresion:=0;

     Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;

  end;

procedure TFAlbaran.MenuItem4Click(Sender: TObject);
  Var
    TxtQ, Marca: String;
    Posi: Integer;
  begin
       Marca:='S';
       if (dbMuestrac.FieldByName('AC14').AsString='S') and (EstadoImpresion=0) then Marca:='N';
       TxtQ:='UPDATE albac'+Tienda+' SET AC14="'+Marca+'" WHERE AC0='+dbMuestrac.FieldByName('AC0').AsString+
                 ' AND AC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('AC1').AsDateTime)+'"'+
            ' AND AC2="'+dbMuestrac.FieldByName('AC2').AsString+'" AND AC3='+dbMuestrac.FieldByName('AC3').AsString;
       dbAlbac.SQL.Text:=TxtQ; dbAlbac.ExecSQL;

       EstadoImpresion:=0;

       Posi:=dbMuestrac.RecNo; dbMuestrac.Refresh; dbMuestrac.RecNo:=Posi;

  end;

procedure TFAlbaran.frReport1GetValue(const ParName: String; var ParValue: Variant);
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
   if ParName='REGISTRO' then ParValue := REGISTRO;
end;


//===================== JUSTIFICANTES DE PAGO ====================

procedure TFAlbaran.btRecibosCancelarClick(Sender: TObject);
begin
  panelRecibos.Visible:= False;
  Exit;
end;

procedure TFAlbaran.btRecibosAceptarClick(Sender: TObject);
begin
  AlbaranesPagados:= edRecibos.Text;
  panelRecibos.Visible:=False;
  showmessage('Se iniciaría el proceso de impresión del justificante con ' + #13 +
               'los albaranes : '+ AlbaranesPagados);
   // frReport1.LoadFromFile(RutaReports+'.lrf');
   // frReport1.ShowReport;
  Exit;
end;

procedure TFAlbaran.EntraEnEdit(Sender: TObject);
begin
  ValorInicial:= TEdit(ActiveControl).Text;

end;

//===================== CARGA VALORES EN LOS EDIT =====
procedure TFAlbaran.CargaValores();
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
procedure TFAlbaran.CargaVariables();
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
procedure TFAlbaran.ActivaPrecios();
begin
  Edit8.Color:=clWindow;
  Edit9.Color:=clWindow;
  Edit8.Enabled:=True;
  Edit9.Enabled:=True;
  lbActivarPrecios.Visible:=False;
end;

//===================== ENTRAR/SALIR DE LA CANTIDAD ======================

function TFAlbaran.HayStock: boolean;
begin

  if RoturaStock='N' then exit;

  result:= true;

  if (StrToFloat(Edit7.Text)> dbArti.FieldByName('A4').Value) then
      begin
          DataModule1.Mensaje('AVISO','No existe stock suficiente, sólo hay '+
                          dbArti.FieldByName('A4').AsString+ ' unidades', 3000 ,clGray );
          result:=false;
      end;

end;

procedure TFAlbaran.Edit7Enter(Sender: TObject);
begin
  Edit7.Text:= FormatFloat(MascaraDecimales,CantidadLinea);
end;

procedure TFAlbaran.Edit7Exit(Sender: TObject);
begin
  if not (EsFloat(Edit7.Text)) then begin Edit7.Text:='0';Edit7.SetFocus; exit; end;

//  if (Edit7.Text='') or (Edit7.Text='0') then begin Edit13.Text:='0';Edit11.Text:='0'; Exit; end;//------ Cant.
//  if (Edit8.Text='') or (Edit8.Text='0') then begin Edit13.Text:='0';Edit11.Text:='0'; Exit; end;//------ Precio

  HayStock;//  comprobamos que haya cantidad suficiente del articulo.

  CantidadLinea:= StrToFloat(Edit7.Text);

  SalirCantidad(self);

  CargaValores();
//  showmessage('cantidad '+ floatToStr(Cantidadlinea));

end;

procedure TFAlbaran.Edit7KeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) and (Edit5.Enabled=true) then Edit5.SetFocus;
end;


//======================= SALIR DE TARIFA ==================

procedure TFAlbaran.Edit23Exit(Sender: TObject);
begin
   if not (EsFloat(Edit23.Text)) then begin Edit23.Text:='0'; Edit23.SetFocus; exit; end;
end;


//======================= ENTRAR/SALIR DEL PRECIO ==================

procedure TFAlbaran.Edit8Enter(Sender: TObject);
begin
   Edit8.Text:= FormatFloat(MascaraDecimales,PrecioConIva);
   EntraEnEdit(self);
   Edit8.SetFocus;
end;

procedure TFAlbaran.Edit8Exit(Sender: TObject);
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

  CargaValores();

//  showmessage('precioc '+ floatToStr(Cantidadlinea));

end;

procedure TFAlbaran.Edit9DblClick(Sender: TObject);
begin
  MuestraTarifas();
end;

//======================= ENTRAR/SALIR DEL PRECIO SIN IVA ====================
procedure TFAlbaran.Edit9Enter(Sender: TObject);
begin
   Edit9.Text:= FormatFloat(MascaraDecimales,PrecioSinIva);
   EntraEnEdit(self);
   Edit9.SetFocus;
end;

procedure TFAlbaran.Edit9Exit(Sender: TObject);
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

  CargaValores();

//  showmessage('precios '+ floatToStr(Cantidadlinea));

end;

//======================= ENTRAR/SALIR DEL DTO =============================
procedure TFAlbaran.Edit10Enter(Sender: TObject);
begin
   Edit10.Text:= FormatFloat('0.##',DescuentoLinea);
end;

procedure TFAlbaran.Edit10Exit(Sender: TObject);
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
procedure TFAlbaran.Edit12Enter(Sender: TObject);
begin
  Edit11.Text:= FormatFloat('0.##',IvaLinea);
end;

procedure TFAlbaran.Edit12Exit(Sender: TObject);
begin
  if not (EsFloat(Edit12.Text)) then begin Edit12.Text:='0'; Edit12.SetFocus; exit; end;
//  if (Edit7.Text='') or (Edit7.Text='0') then begin Edit7.Text:='0'; Exit; end;//------ Cant.
//  if (Edit8.Text='') or (Edit8.Text='0') then begin Edit8.Text:='0'; Exit; end;//------ Precio
//  if (Edit11.Text='') or (Edit11.Text='0') then begin Edit11.Text:='0'; Exit; end;//--- Importe

  IvaLinea:= StrToFloat(Edit12.Text);

  SalirIva(self);

  CargaValores()

end;

//==================== PINTAR DATOS DE CLIENTES ======================
procedure TFAlbaran.PintaCliente();
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
procedure TFAlbaran.LimpiaCliente();
begin
  Label4.Caption:=''; Label5.Caption:=''; Label6.Caption:='';
  Label7.Caption:=''; Label8.Caption:=''; Label9.Caption:='';
  Label10.Caption:=''; LabelTotal.Caption:='0.00';
end;
//==================== LLENAR DATOS LINEAS =======================
procedure TFAlbaran.Llenadd();
begin
                                 // -- Si esta creando nueva
  if Edit5.Enabled=true then
    begin
     dbMuestrad.FieldByName('AD0').Value:=dbMuestrac.FieldByName('AC0').Value;//---- Cliente
     dbMuestrad.FieldByName('AD1').Value:=dbMuestrac.FieldByName('AC1').Value;//---- Fecha
     dbMuestrad.FieldByName('AD2').Value:=dbMuestrac.FieldByName('AC2').Value;//---- Serie
     dbMuestrad.FieldByName('AD3').Value:=dbMuestrac.FieldByName('AC3').Value;//---- Numero
     dbMuestrad.FieldByName('AD4').Value:=VerUltimaLinea; //--- N. Linea
     label28.Caption:=' Añadiendo nuevas líneas. ';
     dbMuestrad.FieldByName('AD5').AsString:=Edit5.Text;//----- Codigo
    end;

  dbMuestrad.FieldByName('AD6').AsString:=Edit6.Text;//-------- Descripcion

  dbMuestrad.FieldByName('AD7').AsFloat:=CantidadLinea;//-------- Cantidad
  dbMuestrad.FieldByName('AD8').AsFloat:=PrecioConIva;//-------- Precio con IVA
  dbMuestrad.FieldByName('AD9').AsFloat:=PrecioSinIva;//-------- Precio sin IVA
  dbMuestrad.FieldByName('AD10').AsFloat:=DescuentoLinea;//------ Dto. %
  dbMuestrad.FieldByName('AD11').AsFloat:=TotalSinIvaLinea;//------ Importe sin IVA
  dbMuestrad.FieldByName('AD12').AsFloat:=IvaLinea;//------ IVA
  dbMuestrad.FieldByName('AD13').AsFloat:=TotalLinea;//------ Importe con IVA
  dbMuestrad.FieldByName('AD17').AsString:=Edit23.Text;//------ Precio Tarifa.

end;

//=================== SACAR EL ULT N. DE LINEA =====================
function TFAlbaran.VerUltimaLinea: Integer;
begin
  VerUltimaLinea:=1;
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT MAX(AD4) As ULTIMA FROM albad'+Tienda+' WHERE AD0='+dbMuestrac.FieldByName('AC0').AsString+
                     ' AND AD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('AC1').AsDateTime)+'"'+
                     ' AND AD2="'+dbMuestrac.FieldByName('AC2').AsString+'"'+
                     ' AND AD3='+dbMuestrac.FieldByName('AC3').AsString;
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  VerUltimaLinea:=dbBusca.FieldByName('ULTIMA').AsInteger+1;
end;

//======================= PINTAR DATOS LINEAS ==================
procedure TFAlbaran.Pintadd();
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
procedure TFAlbaran.Limpiadd();
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
procedure TFAlbaran.CargaTarifas(actualiza: integer);
begin

  dbTarifas.Active:=false;
  dbTarifas.SQL.Text:='select * from tarifas where TAR0="'+dbarti.FieldByName('A0').AsString +'"';

  if actualiza=0 then dbTarifas.SQL.Text:='select * from tarifas where TAR0="'+dbMuestrad.FieldByName('AD5').AsString +'"';

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

//======================= MOSTRAR LAS DISTINTAS TARIFAS ======================
procedure TFAlbaran.MuestraTarifas();
begin
   ListBox2.Visible:=true; ListBox2.SetFocus;
end;
procedure TFAlbaran.ListBox2DblClick(Sender: TObject);
begin
   ListBox2.Visible:= False;
   if ListBox2.ItemIndex=0 then Edit9.Text:=dbArti.FieldByName('A2').AsString;
   if ListBox2.ItemIndex=1 then Edit9.Text:=dbArti.FieldByName('A21').AsString;
   if ListBox2.ItemIndex=2 then Edit9.Text:=dbTarifas.FieldByName('TAR2').AsString;
   if ListBox2.ItemIndex=3 then Edit9.Text:=dbTarifas.FieldByName('TAR4').AsString;
   if ListBox2.ItemIndex=4 then Edit9.Text:=dbTarifas.FieldByName('TAR6').AsString;
   Edit9Exit(self);
end;

procedure TFAlbaran.ListBox2KeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) then ListBox2DblClick(self);
end;

//================= ACTUALIZA IMPORTE EN PANTALLA ===============
procedure TFAlbaran.ActualizaImporte();
begin
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT SUM(AD13) FROM albad'+Tienda+' WHERE'+
                     ' AD0='+dbMuestrac.FieldByName('AC0').AsString+
                     ' AND AD1="'+FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('AC1').AsDateTime)+'"'+
                     ' AND AD2="'+dbMuestrac.FieldByName('AC2').AsString+'"'+
                     ' AND AD3='+dbMuestrac.FieldByName('AC3').AsString;
  dbBusca.Active:=True;

  LabelTotal.Caption:=FormatFloat('0.00',dbBusca.Fields[0].AsFloat);
end;



//================= N. DE ALBARAN ===========================
procedure TFAlbaran.NumeroAlbaran();
begin
  if SALBARAN='' then begin SALBARAN:='';NALBARAN:=0; Exit; end;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='UPDATE seriesfactu SET SF3=SF3+1 WHERE SF0="'+SALBARAN+'"';
  dbSeries.ExecSql;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF0="'+SALBARAN+'"';
  dbSeries.Active:=True;
  if dbSeries.Recordcount=0 then exit;
//  SALBARAN:=dbSeries.Fields[0].AsString;
  NALBARAN:=dbSeries.FieldByName('SF3').Value;
  dbSeries.Active:=False;
end;

//======================== RESTAR STOCK =======================
procedure TFAlbaran.RestarStock(Codigo, Cantidad: String);
begin
  dbArti.SQL.Text:='UPDATE artitien'+Tienda+' SET A4=A4-'+Cantidad+' WHERE A0="'+Codigo+'"';
  dbArti.ExecSQL;
end;
//======================== SUMAR STOCK =======================
procedure TFAlbaran.SumarStock(Codigo, Cantidad: String);
begin
  dbArti.SQL.Text:='UPDATE artitien'+Tienda+' SET A4=A4+'+Cantidad+' WHERE A0="'+Codigo+'"';
  dbArti.ExecSQL;
end;

//======================== RESTAR ESTADISTICAS =======================
procedure TFAlbaran.RestarEsta(Codigo, Cantidad, Precio: String);
var
  Departa, TxtQ, Costo: String;
begin
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Codigo+'"';
  dbArti.Active:=True;
  if dbArti.RecordCount=0 then Costo:='0' else Costo:=dbArti.FieldByName('A24').AsString;
  Costo:=FloatToStr(StrToFloat(Cantidad)*StrToFloat(Costo));
  //------------------- Articulos
  TxtQ:='UPDATE artitien'+Tienda+' SET A12="'+FormatDateTime('YYYY/MM/DD',Date)+'" WHERE A0="'+Codigo+'"';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  //------------------- Estadistica de articulos
  dbTrabajo.SQL.Text:='SELECT * from estaarti'+Tienda+' WHERE TA0="'+Codigo+'"'+
                     ' AND TA1='+FormatDateTime('YYYY',Date)+' AND TA2='+FormatDateTime('MM',Date);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estaarti'+Tienda+' SET TA5=TA5-'+Cantidad+
          ', TA6=TA6-'+Precio+', TA7=TA7-'+Costo+' WHERE TA0="'+Codigo+'"'+
          ' AND TA1='+FormatDateTime('YYYY',Date)+' AND TA2='+FormatDateTime('MM',Date)
  else
    TxtQ:='INSERT INTO estaarti'+Tienda+' (TA0,TA1,TA2,TA5,TA6,TA7) VALUES ("'+
          Codigo+'",'+FormatDateTime('YYYY',Date)+','+FormatDateTime('MM',Date)+
          ','+FloatToStr(StrToFloat(Cantidad)*-1)+','+FloatToStr(StrToFloat(Precio)*-1)+
          ','+FloatToStr(StrToFloat(Costo)*-1)+')';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  //------------------- Estadistica de clientes
  dbTrabajo.SQL.Text:='SELECT * from estaclie WHERE CC0='+dbMuestrac.FieldByName('AC0').AsString+
                     ' AND CC1='+FormatDateTime('YYYY',Date)+' AND CC2='+FormatDateTime('MM',Date);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estaclie SET CC5=CC5-'+Cantidad+
          ', CC6=CC6-'+Precio+', CC7=CC7-'+Costo+' WHERE CC0="'+dbMuestrac.FieldByName('AC0').AsString+'"'+
          ' AND CC1='+FormatDateTime('YYYY',Date)+' AND CC2='+FormatDateTime('MM',Date)
  else
    TxtQ:='INSERT INTO estaclie (CC0,CC1,CC2,CC5,CC6,CC7) VALUES ("'+
          dbMuestrac.FieldByName('AC0').AsString+'",'+FormatDateTime('YYYY',Date)+','+FormatDateTime('MM',Date)+
          ','+FloatToStr(StrToFloat(Cantidad)*-1)+','+FloatToStr(StrToFloat(Precio)*-1)+
          ','+FloatToStr(StrToFloat(Costo)*-1)+')';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  //------------------- Tiendas
  TxtQ:='UPDATE tiendas SET T9="'+FormatDateTime('YYYY/MM/DD',Date)+'" WHERE T0='+NTienda;
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  //------------------- Estadistica de tiendas
  dbTrabajo.SQL.Text:='SELECT * from estatien'+Tienda+' WHERE TT0='+NTienda+
                     ' AND TT1='+FormatDateTime('YYYY',Date)+' AND TT2='+FormatDateTime('MM',Date);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estatien'+Tienda+' SET TT5=TT5-'+Cantidad+
          ', TT6=TT6-'+Precio+', TT7=TT7-'+Costo+' WHERE TT0='+NTienda+
          ' AND TT1='+FormatDateTime('YYYY',Date)+' AND TT2='+FormatDateTime('MM',Date)
  else
    TxtQ:='INSERT INTO estatien'+Tienda+' (TT0,TT1,TT2,TT5,TT6,TT7) VALUES ('+
          NTienda+','+FormatDateTime('YYYY',Date)+','+FormatDateTime('MM',Date)+
          ','+FloatToStr(StrToFloat(Cantidad)*-1)+','+FloatToStr(StrToFloat(Precio)*-1)+
          ','+FloatToStr(StrToFloat(Costo)*-1)+')';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;

  //TODO: Falta estadistica de usuarios y historico de compras de clientes
  
  //------------------- Proveedores
  if dbArti.FieldByName('A32').AsString<>'' then
    begin
     dbTrabajo.SQL.Text:='SELECT * from proveedores WHERE P0='+dbArti.FieldByName('A32').AsString;
     dbTrabajo.Active:=True;
     if dbTrabajo.RecordCount<>0 then
       begin
         TxtQ:='UPDATE proveedores SET P22="'+FormatDateTime('YYYY/MM/DD',Date)+
               '" WHERE P0='+dbArti.FieldByName('A32').AsString;
         dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
         //------------------- Estadistica de proveedores
         dbTrabajo.SQL.Text:='SELECT * from estaprove WHERE PP0='+dbArti.FieldByName('A32').AsString+
                             ' AND PP1='+FormatDateTime('YYYY',Date)+' AND PP2='+FormatDateTime('MM',Date);
         dbTrabajo.Active:=True;
         if dbTrabajo.RecordCount<>0 then
           TxtQ:='UPDATE estaprove SET PP5=PP5-'+Cantidad+
                 ', PP6=PP6-'+Precio+', PP7=PP7-'+Costo+' WHERE PP0='+dbArti.FieldByName('A32').AsString+
                 ' AND PP1='+FormatDateTime('YYYY',Date)+' AND PP2='+FormatDateTime('MM',Date)
         else
           TxtQ:='INSERT INTO estaprove (PP0,PP1,PP2,PP5,PP6,PP7) VALUES ('+dbArti.FieldByName('A32').AsString+
                 ','+FormatDateTime('YYYY',Date)+','+FormatDateTime('MM',Date)+
                 ','+FloatToStr(StrToFloat(Cantidad)*-1)+','+FloatToStr(StrToFloat(Precio)*-1)+
                 ','+FloatToStr(StrToFloat(Costo)*-1)+')';
         dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
       end;
    end;
  //------------------- Familias
  if dbArti.FieldByName('A14').AsString<>'' then
    begin
     dbTrabajo.SQL.Text:='SELECT * from familias'+Tienda+' WHERE F0='+dbArti.FieldByName('A14').AsString;
     dbTrabajo.Active:=True;
     if dbTrabajo.RecordCount<>0 then
        begin
          Departa:=dbTrabajo.FieldByName('F2').AsString;
          TxtQ:='UPDATE familias'+Tienda+' SET F3="'+FormatDateTime('YYYY/MM/DD',Date)+
                '" WHERE F0='+dbArti.FieldByName('A14').AsString;
          dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
          //------ Departamentos
          if Departa<>'' then
            begin
              dbTrabajo.SQL.Text:='SELECT * from departamentos'+Tienda+' WHERE D0='+Departa;
              dbTrabajo.Active:=True;
              if dbTrabajo.RecordCount<>0 then
                 begin
                   TxtQ:='UPDATE departamentos'+Tienda+' SET D2="'+FormatDateTime('YYYY/MM/DD',Date)+
                      '" WHERE D0='+Departa;
                   dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
                 end;
            end;

          //-----------------Estadisticas Familia
          dbTrabajo.SQL.Text:='SELECT * from estafami'+Tienda+' WHERE FF0='+dbArti.FieldByName('A14').AsString+
                              ' AND FF1='+FormatDateTime('YYYY',Date)+' AND FF2='+FormatDateTime('MM',Date);
          dbTrabajo.Active:=True;
          if dbTrabajo.RecordCount<>0 then
            TxtQ:='UPDATE estafami'+Tienda+' SET FF5=FF5-'+Cantidad+
                  ', FF6=FF6-'+Precio+', FF7=FF7-'+Costo+' WHERE FF0='+dbArti.FieldByName('A14').AsString+
                  ' AND FF1='+FormatDateTime('YYYY',Date)+' AND FF2='+FormatDateTime('MM',Date)
          else
            TxtQ:='INSERT INTO estafami'+Tienda+' (FF0,FF1,FF2,FF5,FF6,FF7) VALUES ('+
                  dbArti.FieldByName('A14').AsString+','+FormatDateTime('YYYY',Date)+','+
                  FormatDateTime('MM',Date)+','+FloatToStr(StrToFloat(Cantidad)*-1)+','+
                  FloatToStr(StrToFloat(Precio)*-1)+','+FloatToStr(StrToFloat(Costo)*-1)+')';
          dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
          //-----------------Estadisticas Departamentos
          if Departa<>'' then
            begin
             dbTrabajo.SQL.Text:='SELECT * from estadepa'+Tienda+' WHERE DD0='+Departa+
                                 ' AND DD1='+FormatDateTime('YYYY',Date)+' AND DD2='+FormatDateTime('MM',Date);
             dbTrabajo.Active:=True;
             if dbTrabajo.RecordCount<>0 then
               TxtQ:='UPDATE estadepa'+Tienda+' SET DD5=DD5-'+Cantidad+
                     ', DD6=DD6-'+Precio+', DD7=DD7-'+Costo+' WHERE DD0='+Departa+
                     ' AND DD1='+FormatDateTime('YYYY',Date)+' AND DD2='+FormatDateTime('MM',Date)
             else
               TxtQ:='INSERT INTO estadepa'+Tienda+' (DD0,DD1,DD2,DD5,DD6,DD7) VALUES ('+
                     Departa+','+FormatDateTime('YYYY',Date)+','+
                     FormatDateTime('MM',Date)+','+FloatToStr(StrToFloat(Cantidad)*-1)+','+
                     FloatToStr(StrToFloat(Precio)*-1)+','+FloatToStr(StrToFloat(Costo)*-1)+')';
             dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
            end;
        end;
    end;
  dbArti.Active:=False;
end;

//======================== SUMAR ESTADISTICAS =======================
procedure TFAlbaran.SumarEsta(Codigo, Cantidad, Precio: String);
var
  Departa, TxtQ, Costo: String;
begin
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Codigo+'"';
  dbArti.Active:=True;
  if dbArti.RecordCount=0 then Costo:='0' else Costo:=dbArti.FieldByName('A24').AsString;
  Costo:=FloatToStr(StrToFloat(Cantidad)*StrToFloat(Costo));
  //------------------- Articulos
  TxtQ:='UPDATE artitien'+Tienda+' SET A12="'+FormatDateTime('YYYY/MM/DD',Date)+'" WHERE A0="'+Codigo+'"';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  //------------------- Estadistica de articulos
  dbTrabajo.SQL.Text:='SELECT * from estaarti'+Tienda+' WHERE TA0="'+Codigo+'"'+
                     ' AND TA1='+FormatDateTime('YYYY',Date)+' AND TA2='+FormatDateTime('MM',Date);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estaarti'+Tienda+' SET TA5=TA5+'+Cantidad+
          ', TA6=TA6+'+Precio+', TA7=TA7+'+Costo+' WHERE TA0="'+Codigo+'"'+
          ' AND TA1='+FormatDateTime('YYYY',Date)+' AND TA2='+FormatDateTime('MM',Date)
  else
    TxtQ:='INSERT INTO estaarti'+Tienda+' (TA0,TA1,TA2,TA5,TA6,TA7) VALUES ("'+
          Codigo+'",'+FormatDateTime('YYYY',Date)+','+FormatDateTime('MM',Date)+
          ','+Cantidad+','+Precio+','+Costo+')';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  //------------------- Clientes
  dbTrabajo.SQL.Text:='SELECT * from estaclie WHERE CC0="'+dbMuestrac.FieldByName('AC0').AsString+'"'+
                     ' AND CC1='+FormatDateTime('YYYY',Date)+' AND CC2='+FormatDateTime('MM',Date);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estaclie SET CC5=CC5+'+Cantidad+
          ', CC6=CC6+'+Precio+', CC7=CC7+'+Costo+' WHERE CC0="'+dbMuestrac.FieldByName('AC0').AsString+'"'+
          ' AND CC1='+FormatDateTime('YYYY',Date)+' AND CC2='+FormatDateTime('MM',Date)
  else
    TxtQ:='INSERT INTO estaclie (CC0,CC1,CC2,CC5,CC6,CC7) VALUES ("'+
          dbMuestrac.FieldByName('AC0').AsString+'",'+FormatDateTime('YYYY',Date)+','+FormatDateTime('MM',Date)+
          ','+Cantidad+','+Precio+','+Costo+')';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  //------------------- Tiendas
  TxtQ:='UPDATE tiendas SET T9="'+FormatDateTime('YYYY/MM/DD',Date)+'" WHERE T0='+NTienda;
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
  //------------------- Estadistica de tiendas
  dbTrabajo.SQL.Text:='SELECT * from estatien'+Tienda+' WHERE TT0='+NTienda+
                     ' AND TT1='+FormatDateTime('YYYY',Date)+' AND TT2='+FormatDateTime('MM',Date);
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    TxtQ:='UPDATE estatien'+Tienda+' SET TT5=TT5+'+Cantidad+
          ', TT6=TT6+'+Precio+', TT7=TT7+'+Costo+' WHERE TT0='+NTienda+
          ' AND TT1='+FormatDateTime('YYYY',Date)+' AND TT2='+FormatDateTime('MM',Date)
  else
    TxtQ:='INSERT INTO estatien'+Tienda+' (TT0,TT1,TT2,TT5,TT6,TT7) VALUES ('+
          NTienda+','+FormatDateTime('YYYY',Date)+','+FormatDateTime('MM',Date)+
          ','+Cantidad+','+Precio+','+Costo+')';
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;

  //TODO: Falta estadistica de usuarios y historico de compras de clientes

  //------------------- Proveedores
  if dbArti.FieldByName('A32').AsString<>'' then
    begin
     dbTrabajo.SQL.Text:='SELECT * from proveedores WHERE P0='+dbArti.FieldByName('A32').AsString;
     dbTrabajo.Active:=True;
     if dbTrabajo.RecordCount<>0 then
       begin
         TxtQ:='UPDATE proveedores SET P22="'+FormatDateTime('YYYY/MM/DD',Date)+
               '" WHERE P0='+dbArti.FieldByName('A32').AsString;
         dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
         //------------------- Estadistica de proveedores
         dbTrabajo.SQL.Text:='SELECT * from estaprove WHERE PP0='+dbArti.FieldByName('A32').AsString+
                             ' AND PP1='+FormatDateTime('YYYY',Date)+' AND PP2='+FormatDateTime('MM',Date);
         dbTrabajo.Active:=True;
         if dbTrabajo.RecordCount<>0 then
           TxtQ:='UPDATE estaprove SET PP5=PP5+'+Cantidad+
                 ', PP6=PP6+'+Precio+', PP7=PP7+'+Costo+' WHERE PP0='+dbArti.FieldByName('A32').AsString+
                 ' AND PP1='+FormatDateTime('YYYY',Date)+' AND PP2='+FormatDateTime('MM',Date)
         else
           TxtQ:='INSERT INTO estaprove (PP0,PP1,PP2,PP5,PP6,PP7) VALUES ('+dbArti.FieldByName('A32').AsString+
                 ','+FormatDateTime('YYYY',Date)+','+FormatDateTime('MM',Date)+
                 ','+Cantidad+','+Precio+','+Costo+')';
         dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
       end;
    end;
  //------------------- Familias
  if dbArti.FieldByName('A14').AsString<>'' then
    begin
     dbTrabajo.SQL.Text:='SELECT * from familias'+Tienda+' WHERE F0='+dbArti.FieldByName('A14').AsString;
     dbTrabajo.Active:=True;
     if dbTrabajo.RecordCount<>0 then
        begin
          Departa:=dbTrabajo.FieldByName('F2').AsString;
          TxtQ:='UPDATE familias'+Tienda+' SET F3="'+FormatDateTime('YYYY/MM/DD',Date)+
                '" WHERE F0='+dbArti.FieldByName('A14').AsString;
          dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
          //------ Departamentos
          if Departa<>'' then
            begin
              dbTrabajo.SQL.Text:='SELECT * from departamentos'+Tienda+' WHERE D0='+Departa;
              dbTrabajo.Active:=True;
              if dbTrabajo.RecordCount<>0 then
                 begin
                   TxtQ:='UPDATE departamentos'+Tienda+' SET D2="'+FormatDateTime('YYYY/MM/DD',Date)+
                      '" WHERE D0='+Departa;
                   dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
                 end;
            end;
          //-----------------Estadisticas Familia
          dbTrabajo.SQL.Text:='SELECT * from estafami'+Tienda+' WHERE FF0='+dbArti.FieldByName('A14').AsString+
                              ' AND FF1='+FormatDateTime('YYYY',Date)+' AND FF2='+FormatDateTime('MM',Date);
          dbTrabajo.Active:=True;
          if dbTrabajo.RecordCount<>0 then
            TxtQ:='UPDATE estafami'+Tienda+' SET FF5=FF5+'+Cantidad+
                  ', FF6=FF6+'+Precio+', FF7=FF7+'+Costo+' WHERE FF0='+dbArti.FieldByName('A14').AsString+
                  ' AND FF1='+FormatDateTime('YYYY',Date)+' AND FF2='+FormatDateTime('MM',Date)
          else

            TxtQ:='INSERT INTO estafami'+Tienda+' (FF0,FF1,FF2,FF5,FF6,FF7) VALUES ('+
                  dbArti.FieldByName('A14').AsString+','+FormatDateTime('YYYY',Date)+','+
                  FormatDateTime('MM',Date)+','+Cantidad+','+Precio+','+Costo+')';
          dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
          //-----------------Estadisticas Departamentos
          if Departa<>'' then
            begin
             dbTrabajo.SQL.Text:='SELECT * from estadepa'+Tienda+' WHERE DD0='+Departa+
                                 ' AND DD1='+FormatDateTime('YYYY',Date)+' AND DD2='+FormatDateTime('MM',Date);
             dbTrabajo.Active:=True;
             if dbTrabajo.RecordCount<>0 then
               TxtQ:='UPDATE estadepa'+Tienda+' SET DD5=DD5+'+Cantidad+
                     ', DD6=DD6+'+Precio+', DD7=DD7+'+Costo+' WHERE DD0='+Departa+
                     ' AND DD1='+FormatDateTime('YYYY',Date)+' AND DD2='+FormatDateTime('MM',Date)
             else
               TxtQ:='INSERT INTO estadepa'+Tienda+' (DD0,DD1,DD2,DD5,DD6,DD7) VALUES ('+
                     Departa+','+FormatDateTime('YYYY',Date)+','+
                     FormatDateTime('MM',Date)+','+Cantidad+','+Precio+','+Costo+')';
             dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
            end;
        end;
    end;
  dbArti.Active:=False;
end;

//================  Muestra histórico de compras del cliente =========
procedure TFAlbaran.BitBtn24Click(Sender: TObject);
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
       0:inutil:=FBusquedas.IniciaBusquedas('SELECT HC0, HC1, HC8, HC9, HC4, CONVERT(HC5 USING UTF8), HC6, (HC7/HC6) as Precio FROM histoclie WHERE HC0='+dbMuestrac.FieldByName('AC0').AsString
                        , ['Cliente','Fecha','Serie','Número','Código','Descripción','Und','Precio'],'HC1');

       1:inutil:=FBusquedas.IniciaBusquedas('SELECT HOD6, CONVERT(HOD7 USING UTF8), HOD8, HOD9,HOD11,HOD4, HOD3 FROM hisopdd'+Tienda+
               ' WHERE HOD6="'+codigo+'"', ['CODIGO','DESCRIPCION','CANTIDAD','PRECIO','DCT%','SERIE','NUMERO'],'HOD6');

       2:inutil:=FBusquedas.IniciaBusquedas('SELECT HC0, HC1, HC8, HC9, HC4, CONVERT(HC5 USING UTF8), HC6, (HC7/HC6) as Precio FROM histoclie '+
                ' WHERE HC0='+dbMuestrac.FieldByName('AC0').AsString + ' and HC4="' + codigo + '"', ['Cliente','Fecha','Serie','Número','Código','Descripción','Und','Precio'],'HC1');

 end;

 Edit8.SetFocus;

end;

//======================= CARGAR SERIES DE FACTURACION ========================
procedure TFAlbaran.CargaSeries();
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

//======================= Hist. Operaciones Cab =====================
procedure TFAlbaran.ActuHisopcc(Modo: integer);   // Modo=1 -> Linea borrada
var
  TxtQ: String;
begin

{ TODO: Falta asignar el numero de usuario que cierra la operacion }

  dbHisopcc.Active:=False;
  if FHistoricoAlbaranLocalizado then
    TxtQ:='SELECT * FROM hisopcc'+Tienda+
          ' WHERE HO0="'+FormatDateTime('YYYY/MM/DD',FFechaHistoricoAlbaran)+'"'+
          ' AND HO2="'+SQLTexto(FPuestoHistoricoAlbaran)+'"'+
          ' AND HO3='+dbMuestrac.FieldByName('AC3').AsString+
          ' AND HO4="'+SQLTexto(dbMuestrac.FieldByName('AC2').AsString)+
          '" AND HO5="AL"'
  else
    TxtQ:='SELECT * FROM hisopcc'+Tienda+
          ' WHERE HO3='+dbMuestrac.FieldByName('AC3').AsString+
          ' AND HO4="'+SQLTexto(dbMuestrac.FieldByName('AC2').AsString)+
          '" AND HO5="AL" AND HO8='+dbMuestrac.FieldByName('AC0').AsString+
          ' ORDER BY HO0,HO1 LIMIT 1';
  dbHisopcc.Sql.Text:=TxtQ; dbHisopcc.Active := True;
  if dbHisopcc.RecordCount<>0 then
    begin
      FFechaHistoricoAlbaran:=dbHisopcc.FieldByName('HO0').AsDateTime;
      FHoraHistoricoAlbaran:=dbHisopcc.FieldByName('HO1').AsDateTime;
      FPuestoHistoricoAlbaran:=dbHisopcc.FieldByName('HO2').AsString;
      FHistoricoAlbaranLocalizado:=True;
    end;

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
          dbHisopcc.FieldByName('HO8').Value:=dbMuestrac.FieldByName('AC0').Value;//-- Cliente del albaran
          dbHisopcc.FieldByName('HO9').Value:=FormatFloat('0.00',dbBusca.Fields[0].AsFloat);//--- Importe total
          dbHisopcc.FieldByName('HO11').Value:=FormatFloat('0.00',dbBusca.Fields[0].AsFloat);//-- Importe total con Dto.
          dbHisopcc.FieldByName('HO12').Value:=FormatFloat('0.00',dbBusca.Fields[0].AsFloat);//-- Entrega
          dbHisopcc.FieldByName('HO18').AsString:=NotasConAuditoria(
            dbMuestrac.FieldByName('AC11').AsString,
            dbHisopcc.FieldByName('HO18').AsString); //--Observaciones y auditoría.
          dbHisopcc.Post;
        end;
      dbHisopdd.Active:=False;
      TxtQ:='SELECT * FROM hisopdd'+Tienda+
            ' WHERE HOD0="'+FormatDateTime('YYYY/MM/DD',FFechaHistoricoAlbaran)+'"'+
            ' AND HOD2="'+SQLTexto(FPuestoHistoricoAlbaran)+'"'+
            ' AND HOD3='+dbMuestrad.FieldByName('AD3').AsString+
            ' AND HOD4="'+SQLTexto(dbMuestrad.FieldByName('AD2').AsString)+
            '" AND HOD5='+dbMuestrad.FieldByName('AD4').AsString+
            ' AND HOD23=0';

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
      ActuHisopdd();    // Es una línea nueva en un albarán ya existente.
      Exit;
   end;

   dbHisopcc.append;

   dbHisopcc.FieldByName('HO0').AsString:=dbMuestrac.FieldByName('AC1').AsString; //FormatDateTime('YYYY/MM/DD',dbMuestrac.FieldByName('AC1').AsDateTime);//-- Fecha
   dbHisopcc.FieldByName('HO1').AsString:=FormatDateTime('HH:MM:SS',Time);//-- Hora
   FPuestoHistoricoAlbaran:=Puesto;
   dbHisopcc.FieldByName('HO2').Value:=FPuestoHistoricoAlbaran;//--- Puesto original
   dbHisopcc.FieldByName('HO3').Value:=dbMuestrac.FieldByName('AC3').Value;//- N.Albarán
   dbHisopcc.FieldByName('HO4').Value:=dbMuestrac.FieldByName('AC2').Value;//- Serie Albarán.
   dbHisopcc.FieldByName('HO5').Value:='AL';//----- Tipo operacion
   dbHisopcc.FieldByName('HO6').Value:='FACTURADO';//------- Tipo de pago.
   dbHisopcc.FieldByName('HO7').Value:=1;//----------------- Usuario
   dbHisopcc.FieldByName('HO8').Value:=dbMuestrac.FieldByName('AC0').Value;//----- Cgo. Cliente
   dbHisopcc.FieldByName('HO9').Value:=dbMuestrac.FieldByName('AC9').AsFloat;//--- Importe total
   dbHisopcc.FieldByName('HO10').Value:=0;//-- % Dto.
   dbHisopcc.FieldByName('HO11').Value:=dbMuestrac.FieldByName('AC9').AsFloat;//-- Importe total con Dto.
   dbHisopcc.FieldByName('HO12').Value:=dbMuestrac.FieldByName('AC9').AsFloat;//-- Entrega
   dbHisopcc.FieldByName('HO13').Value:=0;//-- Cambio
   dbHisopcc.FieldByName('HO14').Value:=0;//-- Entrega Tarjeta
   dbHisopcc.FieldByName('HO15').Value:='N';//-- Marcada S/N
   dbHisopcc.FieldByName('HO16').Value:='N';//-- Estado del documento Normal.
   dbHisopcc.FieldByName('HO18').Value:=dbMuestrac.FieldByName('AC11').Value; //--Observaciones.

   hora:=dbHisopcc.FieldByName('HO1').AsDateTime;
   FFechaHistoricoAlbaran:=dbHisopcc.FieldByName('HO0').AsDateTime;
   FHoraHistoricoAlbaran:=hora;
   FPuestoHistoricoAlbaran:=dbHisopcc.FieldByName('HO2').AsString;
   FHistoricoAlbaranLocalizado:=True;

   dbHisopcc.Post; dbHisopcc.Active:=False;

   ActuHisopdd();


end;

//======================= Hist. Operaciones Det =====================
procedure TFAlbaran.ActuHisopdd();
var
  TxtQ: String;
begin
  //------------------- Historico de operaciones detalles
  dbHisopdd.Active:=False;
  TxtQ:='INSERT INTO hisopdd'+Tienda+' (HOD0,HOD1,HOD2,HOD3,HOD4,HOD5,HOD6,HOD7,HOD8,HOD9,HOD10,HOD11'+
        ',HOD12,HOD13,HOD14,HOD15,HOD16, HOD22) VALUES ("'+FormatDateTime('YYYY/MM/DD',dbMuestrad.FieldByName('AD1').AsDateTime)+'",'+
        '"'+FormatDateTime('HH:MM:SS',Hora)+'","'+FPuestoHistoricoAlbaran+'",'+dbMuestrad.FieldByName('AD3').AsString+',"'+
        SQLTexto(dbMuestrad.FieldByName('AD2').AsString)+'",'+dbMuestrad.FieldByName('AD4').AsString+',"'+
        SQLTexto(dbMuestrad.FieldByName('AD5').AsString)+'","'+SQLTexto(dbMuestrad.FieldByName('AD6').AsString)+'",'+
        dbMuestrad.FieldByName('AD7').AsString+','+dbMuestrad.FieldByName('AD8').AsString+','+
        dbMuestrad.FieldByName('AD9').AsString+','+dbMuestrad.FieldByName('AD10').AsString+','+
        dbMuestrad.FieldByName('AD11').AsString+','+dbMuestrad.FieldByName('AD12').AsString+','+
        dbMuestrad.FieldByName('AD13').AsString+',"","'+SQLTexto(dbMuestrad.FieldByName('AD15').AsString)+'",'+
        dbMuestrad.FieldByName('AD17').AsString+')';
  dbHisopdd.SQL.Text:=TxtQ; dbHisopdd.ExecSQL;
end;


procedure TFAlbaran.ActuHistoclie(Modo: integer);  //Modo=1 borrar línea.
var
   TxtQ: string;
begin
  //------------------- Histórico de compras de clientes
  dbTrabajo.Active:=False;
  TxtQ:='SELECT * FROM histoclie WHERE HC0="'+dbMuestrad.FieldByName('AD0').AsString+
        '" AND HC1="'+FormatDateTime('YYYY/MM/DD',dbMuestrad.FieldByName('AD1').AsDateTime)+
        '" AND HC3="'+dbMuestrad.FieldByName('AD4').AsString+
        '" AND HC8="'+dbMuestrad.FieldByName('AD2').AsString+
        '" AND HC9='+dbMuestrad.FieldByName('AD3').AsString;
  dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.Active:=True;

  if (dbTrabajo.RecordCount=0) then
      begin
         if Modo=1 then exit;
         TxtQ:='INSERT INTO histoclie (HC0,HC1,HC2,HC3,HC4,HC5,HC6,HC7,HC8,HC9) VALUES ("'+
         dbMuestrac.FieldByName('AC0').AsString+'","'+FormatDateTime('YYYY/MM/DD',dbMuestrad.FieldByName('AD1').AsDateTime)+'","'+
         FormatDateTime('HH:MM:SS',Time)+'",'+dbMuestrad.FieldByName('AD4').AsString+
         ',"'+dbMuestrad.FieldByName('AD5').AsString+'","'+dbMuestrad.FieldByName('AD6').AsString+
         '",'+dbMuestrad.FieldByName('AD7').AsString+','+dbMuestrad.FieldByName('AD13').AsString+',"'+
         dbMuestrad.FieldByName('AD2').AsString+'",'+dbMuestrad.FieldByName('AD3').AsString+')';
         dbTrabajo.Active:=False; dbTrabajo.SQL.Text:=TxtQ; dbTrabajo.ExecSQL;
         Exit
      end;

  if Modo=1 then begin dbTrabajo.Delete; Exit; end;

  dbTrabajo.Edit;
  dbTrabajo.FieldByName('HC4').AsString:=dbMuestrad.FieldByName('AD5').AsString;
  dbTrabajo.FieldByName('HC5').AsString:=dbMuestrad.FieldByName('AD6').AsString;
  dbTrabajo.FieldByName('HC6').Value:=dbMuestrad.FieldByName('AD7').AsFloat;
  dbTrabajo.FieldByName('HC7').Value:=dbMuestrad.FieldByName('AD13').AsFloat;
  dbTrabajo.Post;

end;

//====================== MOSTRAR BOTONES DD ====================
procedure TFAlbaran.MostrarBotonesdd();
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
  ActualizarPieAtajos;
end;

//====================== OCULTAR BOTONES DD ====================
procedure TFAlbaran.OcultarBotonesdd();
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
  ActualizarPieAtajos;
end;

//=================== TECLAS RAPIDAS ======================

procedure TFAlbaran.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

 // Ctrl+O abre Observaciones únicamente dentro de un albarán. No interrumpe
 // el editor de líneas y conserva F10 como atajo histórico ya existente.
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
 if (key=VK_F10) and (panel6.Visible=True) then begin key:=0; BitBtn24Click(self); Exit; End;                    // histórico de cliente.
 if (key=VK_ESCAPE) and (panel6.Visible=True) then begin key:=0; BitBtn6Click(self) ; Exit; End;                 // finalizar entradas
 if (key=VK_RETURN) and (panel6.Visible=True)  and                                                               // entrada automática.
                       (Edit5.Focused) then begin key:=0; Edit5Exit(self); BitBtn8Click(self) ; Exit; End;

//     **********  Pantalla cabeceras de albaranes   **********

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
      End;                                                                                                                    // Entra en selección de clientes.
 if (key=VK_F1) and (dbGrid2.Visible=false) then begin key:=0; BitBtn1Click(self); Exit; End;                    // entra en edición del pre/pro
 if (key=VK_F2) and (dbGrid2.Visible=false) then begin key:=0; BitBtn9Click(self); Exit; End;                    // crea un pre/pro nuevo
 if (key=VK_F3) and (dbGrid2.Visible=false) then begin key:=0; BitBtn10Click(self); Exit; End;                   // borra un pre/pro
 if (key=VK_F11) and (dbGrid2.Visible=false) then begin key:=0; BitBtn23Click(self); Exit; End;                  // Listado de pre/pro's
 if (key=VK_F8 ) and (Panel9.Visible=True) then begin key:=0; BitBtn21Click(self); Exit; End;                    // ejecuta el listado
 if (key=VK_F8 ) and (Panel8.Visible=True) then begin key:=0; BitBtn19Click(self); dbGrid1.SetFocus; Exit; End;  // Acepta datos serie/numero pre/pro
 if (key=VK_ESCAPE) and (Panel9.Visible=True) then begin key:=0; BitBtn22Click(self); Exit; End;                 // Cancelar listado
 if (key=VK_ESCAPE) and (Panel8.Visible=True) then begin key:=0; BitBtn20Click(self); Exit; End;                 // Cancelar datos serie/pro.
 if (key=VK_ESCAPE) and (dbGrid2.Visible=false) then begin key:=0; BitBtn2Click(self); Exit; End;                // Salir de tarea de pre/pro
 if (key=VK_F12) and (dbGrid2.Visible=false) and (RadioButton2.Checked) then begin key:=0; BitBtn25Click(self); Exit; End;  // buscar clientes.


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

procedure TFAlbaran.FormShow(Sender: TObject);
begin
  AjustarLayoutModerno;
  PrepararCalendariosVisibles;
  ActualizarPieAtajos;
  dbGrid1.SetFocus;
  FLXAplicarTemaVisual(Self);
end;


//====================== CERRAR FORMULARIO =====================
procedure TFAlbaran.BitBtn2Click(Sender: TObject);
begin
  Close();
end;
procedure TFAlbaran.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
   FAlbaranEnGestion:=False;
   FAlbaranModificado:=False;
   FHistoricoAlbaranLocalizado:=False;
   CloseAction:=CaFree;
end;


initialization

  {$I albaran.lrs}

end.

