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
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

Unit Clientes;

{$mode Objfpc}{$H+}
{$codepage utf8}

Interface

Uses
  Classes, Sysutils, StrUtils, Math, Lresources, Forms, Controls, Graphics, Dialogs,
  ComCtrls, Buttons, ZConnection, ZDataset, StdCtrls, ExtCtrls, LCLType,
  DBGrids, TAGraph, TASeries, LR_DBSet, LR_Class, db, DbCtrls, variants,
  uFLXClienteCoste;


Type

  { TFClientes }

  TFClientes = Class(Tform)
    Bevel1: TBevel;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn15: TBitBtn;
    BitBtn16: TBitBtn;
    BitBtn17: TButton;
    BitBtn18: TBitBtn;
    BitBtn19: TBitBtn;
    BitBtn20: TBitBtn;
    BitBtn21: TBitBtn;
    btCodigo: TBitBtn;
    BitBtn7: TButton;
    BitBtn8: TButton;
    BitBtn9: TBitBtn;
    Chart1: TChart;
    Chart1AreaSeries1: TAreaSeries;
    Chart1BarSeries1: TBarSeries;
    Chart1PieSeries1: TPieSeries;
    Chart1Serie1: TLineSeries;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    cbEmail: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    PanelCoste: TPanel;
    LabelCosteTitulo: TLabel;
    LabelCosteInfo: TLabel;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    Datasource3: TDatasource;
    Datasource4: TDatasource;
    dbClientes1: TZQuery;
    dbCliSic: TZQuery;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    dbRutas: TZQuery;
    dbSubRutas: TZQuery;
    dbTrabajo: TZQuery;
    dbBusca: TZQuery;
    Edit15: TEdit;
    Edit48: TEdit;
    Edit49: TEdit;
    Edit50: TEdit;
    Edit51: TEdit;
    Edit52: TEdit;
    Edit53: TEdit;
    Edit54: TEdit;
    Edit55: TEdit;
    Edit56: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    Label15: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    lbBeneficio: TLabel;
    lbIC: TLabel;
    lbIVC: TLabel;
    lbIVP: TLabel;
    lbUC: TLabel;
    lbUV: TLabel;
    ListBox1: TListBox;
    ListBox3: TListBox;
    ListBox4: TListBox;
    ListBox7: TListBox;
    PanelNuevoCl: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    SicConnect: TZConnection;
    dbGrafica: TZQuery;
    dbHisto: TZQuery;
    DBGrid2: TDBGrid;
    dbPagos: TZQuery;
    DBGrid1: TDBGrid;
    dbEsta: TZQuery;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit23: TEdit;
    Edit24: TEdit;
    Edit25: TEdit;
    Edit26: TEdit;
    Edit27: TEdit;
    Edit28: TEdit;
    Edit29: TEdit;
    Edit30: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
    Edit34: TEdit;
    Edit35: TEdit;
    Edit36: TEdit;
    Edit37: TEdit;
    Edit38: TEdit;
    Edit39: TEdit;
    Edit40: TEdit;
    Edit41: TEdit;
    Edit42: TEdit;
    Edit43: TEdit;
    Edit44: TEdit;
    Edit45: TEdit;
    Edit46: TEdit;
    Edit47: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
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
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label49: TLabel;
    Label57: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListBox2: TListBox;
    ListBox5: TListBox;
    Memo1: TMemo;
    Edit1: Tedit;
    dbClientes: TZQuery;
    Panel1: Tpanel;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    Bitbtn4: Tbitbtn;
    Bitbtn5: Tbitbtn;
    Bitbtn6: Tbitbtn;
    Bitbtn1: Tbitbtn;
    Label7: Tlabel;
    Pagecontrol1: Tpagecontrol;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel5: TPanel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    Tabsheet1: Ttabsheet;
    Tabsheet2: Ttabsheet;
    Tabsheet3: Ttabsheet;
    TabSheet4: TTabSheet;
    Label2: Tlabel;
    Label3: Tlabel;
    Label4: Tlabel;
    Label5: Tlabel;
    Label6: Tlabel;
    Edit2: Tedit;
    Edit3: Tedit;
    Edit4: Tedit;
    Edit5: Tedit;
    Edit6: Tedit;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn15Click(Sender: TObject);
    procedure BitBtn16Click(Sender: TObject);
    procedure BitBtn18Click(Sender: TObject);
    procedure BitBtn19Click(Sender: TObject);
    procedure BitBtn20Click(Sender: TObject);
    procedure BitBtn21Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure btCodigoClick(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure DBGrid3TitleClick(Column: TColumn);
    procedure DBGrid4TitleClick(Column: TColumn);
    procedure Datasource3DataChange(Sender: TObject; Field: TField);
    procedure Edit12Enter(Sender: TObject);
    procedure Edit12Exit(Sender: TObject);
    procedure Edit15Enter(Sender: TObject);
    procedure Edit15Exit(Sender: TObject);
    procedure Edit1MouseEnter(Sender: TObject);
    procedure Edit1MouseLeave(Sender: TObject);
    procedure Edit22Exit(Sender: TObject);
    function ClienteDuplicado(): string;
    function FLX_SQLValorDoble(const S: string): string;
    function FLX_SoloDigitosTexto(const S: string): string;
    function FLX_ClienteCodigoExiste(const ACodigo: string): Boolean;
    function FLX_VerUltimoClienteNormal: string;
    function FLX_VerSiguienteClienteSuperior: string;
    function FLX_CodigoAltaClienteDesdeDocumento(const ADocumento: string; AMostrarAviso: Boolean): string;
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure Edit51Enter(Sender: TObject);
    procedure Edit51Exit(Sender: TObject);
    procedure Edit52Exit(Sender: TObject);
    Procedure Formcreate(Sender: Tobject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    Procedure Edit1enter(Sender: Tobject);
    Procedure Edit1exit(Sender: Tobject);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    Procedure LimpiaForm();
    procedure ListBox2DblClick(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure ListBox4Click(Sender: TObject);
    procedure ListBox5Click(Sender: TObject);
    procedure ListBox7Click(Sender: TObject);
    Procedure Relleno();
    Procedure LlenaReg();
    Procedure VerTipoPago();
    Procedure VerRuta();
    procedure VerSubRuta();
    Procedure Bitbtn1click(Sender: Tobject);
    Procedure Bitbtn6click(Sender: Tobject);
    Procedure Bitbtn5click(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    Procedure Bitbtn4click(Sender: Tobject);
    Procedure Bitbtn2click(Sender: Tobject);
    Procedure Bitbtn3click(Sender: Tobject);
    procedure Graficas();
    procedure CambiarGrafica();
    procedure RellenaEsta(Ano: String);
    procedure GrabarModificarSic();
    procedure BorrarSic();
    procedure RellenaSIC();
    procedure CargaSIC();
    function LeerClienteSic: Boolean;

  Private
    FCampoCosteDisponible: Boolean;

    FHeaderBar: TPanel;
    FHeaderTitle: TLabel;
    FHeaderSubtitle: TLabel;
    FSearchCard: TPanel;
    FSearchCaption: TLabel;

    FGeneralCard: TShape;
    FGeneralTitle: TLabel;
    FOptionsCard: TShape;
    FOptionsTitle: TLabel;
    FNotesCard: TShape;
    FNotesTitle: TLabel;

    FBillingTermsCard: TShape;
    FBillingTermsTitle: TLabel;
    FBillingDocsCard: TShape;
    FBillingDocsTitle: TLabel;
    FDeliveryCard: TShape;
    FDeliveryTitle: TLabel;

    FBankCard: TShape;
    FBankTitle: TLabel;
    FHistoryBand: TPanel;
    FHistoryTitle: TLabel;
    FStatsBand: TPanel;
    FStatsTitle: TLabel;
    FChartBand: TPanel;
    FChartTitle: TLabel;
    FChartOptionsCard: TShape;
    FVirtualCard: TShape;
    FVirtualTitle: TLabel;

    FBtnNombreVisual: TPanel;
    FBtnEmailVisual: TPanel;
    FBtnPagoVisual: TPanel;
    FBtnLOPDVisual: TPanel;
    FBtnFormularioVisual: TPanel;
    FBtnRutaVisual: TPanel;
    FBtnSubRutaVisual: TPanel;
    FBtnCerrarPagosVisual: TPanel;

    FOptionsImportantPanel: TPanel;
    FOptionsImportantTitle: TLabel;
    FFactOptionsPanel: TPanel;
    FFactOptionsTitle: TLabel;

    FOrdenGrid1Campo: string;
    FOrdenGrid1Direccion: string;
    FOrdenGrid2Campo: string;
    FOrdenGrid2Direccion: string;
    FOrdenGrid3Campo: string;
    FOrdenGrid3Direccion: string;
    FOrdenGrid4Campo: string;
    FOrdenGrid4Direccion: string;
    procedure CrearEstructuraVisual;
    procedure AplicarEstiloModerno;
    procedure AplicarTextosUTF8Seguros;
    procedure AjustarDisenoModerno;
    procedure FormResizeModerno(Sender: TObject);
    procedure EstilarPanelSuave(APanel: TPanel; AColor: TColor);
    procedure EstilarCampo(AControl: TControl);
    procedure EstilarBoton(ABoton: TBitBtn; AColor: TColor;
      ATextoClaro: Boolean = True);
    procedure EstilarGrid(AGrid: TDBGrid);
    procedure PrepararBotonVisual(APanel: TPanel;
      AOnClick: TNotifyEvent; const ACaption, AHint: string);
    procedure BotonEmailVisualClick(Sender: TObject);
    procedure BotonFormularioVisualClick(Sender: TObject);
    procedure PrepararPanelPagos;
    procedure PrepararPanelRutas;
    procedure PrepararEtiquetaFacturacion(ALabel: TLabel);
    procedure ConfigurarOrdenacionGrids;
    procedure OrdenarGrid(AQuery: TZQuery; AGrid: TDBGrid;
      AColumn: TColumn; var ACampo, ADireccion: string);
    procedure ActualizarFlechaGrid(AGrid: TDBGrid;
      const ACampo, ADireccion: string);
    function SQLSinOrden(const ASQL: string): string;
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormClientes;
  
Var
  FClientes: TFClientes;
  Cargando, CargaGrafica, NTienda: Integer;
  CodClienteSic: String;
  TituloGrid: String;

Implementation

uses
  Global, Funciones, Busquedas, uFLXTemaVisual;
  


function FLXTextoUTF8Seguro(const ATexto: string): string;
var
  I, Codigo: Integer;
  Hexa: string;
  TextoUnicode: UnicodeString;
begin
  TextoUnicode := '';
  I := 1;

  while I <= Length(ATexto) do
  begin
    if (ATexto[I] = #92) and
       (I + 5 <= Length(ATexto)) and
       (ATexto[I + 1] in ['u', 'U']) then
    begin
      Hexa := Copy(ATexto, I + 2, 4);
      Codigo := StrToIntDef('$' + Hexa, -1);

      if Codigo >= 0 then
      begin
        TextoUnicode := TextoUnicode + UnicodeString(WideChar(Codigo));
        Inc(I, 6);
        Continue;
      end;
    end;

    TextoUnicode := TextoUnicode +
      UnicodeString(WideChar(Ord(ATexto[I])));
    Inc(I);
  end;

  Result := UTF8Encode(TextoUnicode);
end;

function TFClientes.SQLSinOrden(const ASQL: string): string;
var
  P: SizeInt;
begin
  Result := Trim(ASQL);
  P := RPos(' ORDER BY ', UpperCase(Result));
  if P > 0 then
    Result := Trim(Copy(Result, 1, P - 1));

  if (Result <> '') and (Result[Length(Result)] = ';') then
    Delete(Result, Length(Result), 1);
end;

procedure TFClientes.ActualizarFlechaGrid(AGrid: TDBGrid;
  const ACampo, ADireccion: string);
var
  I: Integer;
  Titulo: string;
begin
  if not Assigned(AGrid) then
    Exit;

  for I := 0 to AGrid.Columns.Count - 1 do
  begin
    Titulo := AGrid.Columns[I].Title.Caption;
    Titulo := StringReplace(Titulo, ' ' + FLXTextoUTF8Seguro('\u25B2'), '', [rfReplaceAll]);
    Titulo := StringReplace(Titulo, ' ' + FLXTextoUTF8Seguro('\u25BC'), '', [rfReplaceAll]);

    if SameText(AGrid.Columns[I].FieldName, ACampo) then
    begin
      if SameText(ADireccion, 'DESC') then
        Titulo := Titulo + ' ' + FLXTextoUTF8Seguro('\u25BC')
      else
        Titulo := Titulo + ' ' + FLXTextoUTF8Seguro('\u25B2');
    end;

    AGrid.Columns[I].Title.Caption := Titulo;
  end;
end;

procedure TFClientes.OrdenarGrid(AQuery: TZQuery; AGrid: TDBGrid;
  AColumn: TColumn; var ACampo, ADireccion: string);
var
  Campo, BaseSQL: string;
begin
  if (not Assigned(AQuery)) or (not Assigned(AGrid)) or
     (not Assigned(AColumn)) then
    Exit;

  Campo := Trim(AColumn.FieldName);
  if Campo = '' then
    Exit;

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

  BaseSQL := SQLSinOrden(AQuery.SQL.Text);
  if BaseSQL = '' then
    Exit;

  AQuery.DisableControls;
  try
    AQuery.Close;
    AQuery.SQL.Text :=
      BaseSQL + ' ORDER BY `' + Campo + '` ' + ADireccion;
    AQuery.Open;
  finally
    AQuery.EnableControls;
  end;

  ActualizarFlechaGrid(AGrid, ACampo, ADireccion);
end;

procedure TFClientes.DBGrid1TitleClick(Column: TColumn);
begin
  OrdenarGrid(dbEsta, DBGrid1, Column,
    FOrdenGrid1Campo, FOrdenGrid1Direccion);
end;

procedure TFClientes.DBGrid2TitleClick(Column: TColumn);
begin
  OrdenarGrid(dbHisto, DBGrid2, Column,
    FOrdenGrid2Campo, FOrdenGrid2Direccion);
end;

procedure TFClientes.DBGrid3TitleClick(Column: TColumn);
begin
  OrdenarGrid(dbRutas, DBGrid3, Column,
    FOrdenGrid3Campo, FOrdenGrid3Direccion);
end;

procedure TFClientes.DBGrid4TitleClick(Column: TColumn);
begin
  OrdenarGrid(dbSubRutas, DBGrid4, Column,
    FOrdenGrid4Campo, FOrdenGrid4Direccion);
end;

procedure TFClientes.ConfigurarOrdenacionGrids;
begin
  DBGrid1.OnTitleClick := @DBGrid1TitleClick;
  DBGrid2.OnTitleClick := @DBGrid2TitleClick;
  DBGrid3.OnTitleClick := @DBGrid3TitleClick;
  DBGrid4.OnTitleClick := @DBGrid4TitleClick;

  FOrdenGrid1Campo := 'CC1';
  FOrdenGrid1Direccion := 'ASC';
  FOrdenGrid2Campo := 'HC1';
  FOrdenGrid2Direccion := 'DESC';
  FOrdenGrid3Campo := 'RUT1';
  FOrdenGrid3Direccion := 'ASC';
  FOrdenGrid4Campo := 'SRUT1';
  FOrdenGrid4Direccion := 'ASC';

  ActualizarFlechaGrid(DBGrid1,
    FOrdenGrid1Campo, FOrdenGrid1Direccion);
  ActualizarFlechaGrid(DBGrid2,
    FOrdenGrid2Campo, FOrdenGrid2Direccion);
  ActualizarFlechaGrid(DBGrid3,
    FOrdenGrid3Campo, FOrdenGrid3Direccion);
  ActualizarFlechaGrid(DBGrid4,
    FOrdenGrid4Campo, FOrdenGrid4Direccion);
end;

procedure TFClientes.EstilarPanelSuave(APanel: TPanel; AColor: TColor);
begin
  if not Assigned(APanel) then
    Exit;

  APanel.BevelOuter := bvNone;
  APanel.BevelInner := bvNone;
  APanel.BorderWidth := 1;
  APanel.ParentColor := False;
  APanel.Color := AColor;
end;

procedure TFClientes.EstilarCampo(AControl: TControl);
begin
  if not Assigned(AControl) then
    Exit;

  // TControl no publica ParentFont en la LCL utilizada por FacturLinEx.
  // Aplicamos el estilo despues de convertir al tipo real del componente.
  if AControl is TEdit then
  begin
    TEdit(AControl).ParentFont := False;
    TEdit(AControl).Font.Name := 'Sans';
    TEdit(AControl).Font.Height := -12;
    TEdit(AControl).Font.Color := RGBToColor(30, 41, 59);
    TEdit(AControl).Color := clWhite;
  end
  else if AControl is TMemo then
  begin
    TMemo(AControl).ParentFont := False;
    TMemo(AControl).Font.Name := 'Sans';
    TMemo(AControl).Font.Height := -12;
    TMemo(AControl).Font.Color := RGBToColor(30, 41, 59);
    TMemo(AControl).Color := clWhite;
  end
  else if AControl is TListBox then
  begin
    TListBox(AControl).ParentFont := False;
    TListBox(AControl).Font.Name := 'Sans';
    TListBox(AControl).Font.Height := -12;
    TListBox(AControl).Font.Color := RGBToColor(30, 41, 59);
    TListBox(AControl).Color := clWhite;
  end;
end;

procedure TFClientes.EstilarBoton(ABoton: TBitBtn; AColor: TColor;
  ATextoClaro: Boolean);
begin
  if not Assigned(ABoton) then
    Exit;

  ABoton.ParentFont := False;
  ABoton.Font.Name := 'Sans';
  ABoton.Font.Height := -12;
  ABoton.Font.Style := [fsBold];
  ABoton.Color := AColor;

  if ATextoClaro then
    ABoton.Font.Color := clWhite
  else
    ABoton.Font.Color := RGBToColor(30, 41, 59);
end;

procedure TFClientes.EstilarGrid(AGrid: TDBGrid);
begin
  if not Assigned(AGrid) then
    Exit;

  AGrid.ParentFont := False;
  AGrid.Font.Name := 'Sans';
  AGrid.Font.Height := -12;
  AGrid.Font.Color := RGBToColor(30, 41, 59);
  AGrid.Color := clWhite;
  AGrid.FixedColor := RGBToColor(18, 76, 91);
  AGrid.TitleFont.Name := 'Sans';
  AGrid.TitleFont.Height := -11;
  AGrid.TitleFont.Style := [fsBold];
  AGrid.TitleFont.Color := clWhite;
  AGrid.GridLineColor := RGBToColor(203, 213, 225);
  AGrid.AlternateColor := RGBToColor(248, 250, 252);
  AGrid.SelectedColor := clHighlight;
  AGrid.DefaultRowHeight := 27;
end;

procedure TFClientes.PrepararBotonVisual(APanel: TPanel;
  AOnClick: TNotifyEvent; const ACaption, AHint: string);
var
  LTexto: TLabel;
begin
  if not Assigned(APanel) then
    Exit;

  APanel.Caption := '';
  APanel.BevelOuter := bvRaised;
  APanel.BevelInner := bvNone;
  APanel.BorderWidth := 2;
  APanel.ParentColor := False;
  APanel.Color := RGBToColor(23, 96, 116);
  APanel.Cursor := crHandPoint;
  APanel.Hint := AHint;
  APanel.ShowHint := True;
  APanel.OnClick := AOnClick;
  APanel.Visible := True;
  APanel.Enabled := True;

  if APanel.ControlCount = 0 then
  begin
    LTexto := TLabel.Create(Self);
    LTexto.Parent := APanel;
    LTexto.Align := alClient;
    LTexto.Alignment := taCenter;
    LTexto.Layout := tlCenter;
    LTexto.AutoSize := False;
    LTexto.Transparent := False;
    LTexto.ParentColor := False;
    LTexto.Color := RGBToColor(23, 96, 116);
    LTexto.ParentFont := False;
    LTexto.Font.Name := 'Sans';
    LTexto.Font.Height := -12;
    LTexto.Font.Style := [fsBold];
    LTexto.Font.Color := clWhite;
    LTexto.Cursor := crHandPoint;
  end
  else
    LTexto := TLabel(APanel.Controls[0]);

  LTexto.Caption := ACaption;
  LTexto.Hint := AHint;
  LTexto.ShowHint := True;
  LTexto.OnClick := AOnClick;
  LTexto.BringToFront;
end;

procedure TFClientes.BotonEmailVisualClick(Sender: TObject);
begin
  BitBtn9.Click;
end;

procedure TFClientes.BotonFormularioVisualClick(Sender: TObject);
var
  Dialogo: TOpenDialog;
  RutaInicial: string;
  RutaSeleccionada: string;
  NombreFormulario: string;
begin
  Dialogo := TOpenDialog.Create(Self);
  try
    Dialogo.Title := FLXTextoUTF8Seguro(
      'Seleccionar formulario de facturas'
    );
    Dialogo.Filter :=
      'Formularios Lazarus Report (*.lrf)|*.lrf|' +
      'Todos los archivos (*.*)|*.*';
    Dialogo.FilterIndex := 1;
    Dialogo.Options := [
      ofFileMustExist,
      ofPathMustExist,
      ofEnableSizing
    ];

    RutaInicial := Trim(RutaReports);
    if (RutaInicial <> '') and DirectoryExists(RutaInicial) then
      Dialogo.InitialDir := RutaInicial;

    if Trim(Edit31.Text) <> '' then
    begin
      RutaSeleccionada :=
        IncludeTrailingPathDelimiter(RutaInicial) + Trim(Edit31.Text);

      if FileExists(RutaSeleccionada) then
        Dialogo.FileName := RutaSeleccionada;
    end;

    if not Dialogo.Execute then
      Exit;

    RutaSeleccionada := Dialogo.FileName;

    if not SameText(
      IncludeTrailingPathDelimiter(
        ExpandFileName(ExtractFileDir(RutaSeleccionada))
      ),
      IncludeTrailingPathDelimiter(
        ExpandFileName(RutaInicial)
      )
    ) then
    begin
      ShowMessage(
        FLXTextoUTF8Seguro(
          'El formulario debe seleccionarse dentro de la carpeta de ' +
          'informes configurada en FacturLinEx.'
        )
      );
      Exit;
    end;

    NombreFormulario := ExtractFileName(RutaSeleccionada);

    if Length(NombreFormulario) > Edit31.MaxLength then
    begin
      ShowMessage(
        FLXTextoUTF8Seguro(
          'El nombre del formulario es demasiado largo para el campo ' +
          'del cliente.'
        )
      );
      Exit;
    end;

    Edit31.Text := NombreFormulario;
    Edit31.Hint := RutaSeleccionada;
    Edit31.ShowHint := True;
    Edit31.SetFocus;
  finally
    Dialogo.Free;
  end;
end;

procedure TFClientes.PrepararPanelPagos;
var PW, PH: Integer;
begin
  if not Assigned(Panel5) then Exit;
  PW := Min(660, Max(520, TabSheet1.ClientWidth - 120));
  PH := Min(390, Max(300, TabSheet1.ClientHeight - 170));
  Panel5.SetBounds(Max(20,(TabSheet1.ClientWidth-PW) div 2),
    Max(44,(TabSheet1.ClientHeight-PH) div 2),PW,PH);
  Panel5.ParentColor := False;
  Panel5.Color := RGBToColor(196, 224, 235);
  Panel5.BevelOuter := bvRaised;
  Panel5.BevelInner := bvNone;
  Panel5.BorderWidth := 14;
  Label49.AutoSize := False;
  Label49.SetBounds(16, 12, Panel5.ClientWidth - 32, 32);
  Label49.Caption := 'FORMAS DE PAGO';
  Label49.Alignment := taCenter;
  Label49.Layout := tlCenter;
  Label49.Transparent := False;
  Label49.ParentColor := False;
  Label49.Color := RGBToColor(18,76,91);
  Label49.ParentFont := False;
  Label49.Font.Name := 'Sans';
  Label49.Font.Height := -12;
  Label49.Font.Style := [fsBold];
  Label49.Font.Color := clWhite;
  ListBox2.SetBounds(16, 54, Panel5.ClientWidth - 32,
    Max(150, Panel5.ClientHeight - 126));
  ListBox2.Color := clWhite;
  ListBox2.BorderStyle := bsSingle;
  if Assigned(FBtnCerrarPagosVisual) then
  begin
    FBtnCerrarPagosVisual.SetBounds(Panel5.ClientWidth-96,Panel5.ClientHeight-44,84,30);
    FBtnCerrarPagosVisual.Caption := 'Cerrar';
    FBtnCerrarPagosVisual.BevelOuter := bvRaised;
    FBtnCerrarPagosVisual.ParentColor := False;
    FBtnCerrarPagosVisual.Color := RGBToColor(71,85,105);
    FBtnCerrarPagosVisual.ParentFont := False;
    FBtnCerrarPagosVisual.Font.Name := 'Sans';
    FBtnCerrarPagosVisual.Font.Height := -11;
    FBtnCerrarPagosVisual.Font.Style := [fsBold];
    FBtnCerrarPagosVisual.Font.Color := clWhite;
    FBtnCerrarPagosVisual.Cursor := crHandPoint;
    FBtnCerrarPagosVisual.OnClick := @BitBtn16Click;
    FBtnCerrarPagosVisual.BringToFront;
  end;
  BitBtn16.Visible := False;
  Label49.BringToFront;
  ListBox2.BringToFront;
  Panel5.BringToFront;
end;

procedure TFClientes.PrepararPanelRutas;
var
  PW, PH: Integer;
begin
  if not Assigned(Panel7) then
    Exit;

  PW := Min(720, Max(580, TabSheet4.ClientWidth - 80));
  PH := Min(500, Max(420, TabSheet4.ClientHeight - 80));

  Panel7.SetBounds(
    Max(20, (TabSheet4.ClientWidth - PW) div 2),
    Max(36, (TabSheet4.ClientHeight - PH) div 2),
    PW,
    PH
  );

  Panel7.ParentColor := False;
  Panel7.Color := RGBToColor(196, 224, 235);
  Panel7.BevelOuter := bvRaised;
  Panel7.BevelInner := bvNone;
  Panel7.BorderWidth := 14;

  Label54.AutoSize := False;
  Label54.SetBounds(16, 12, Panel7.ClientWidth - 32, 30);
  Label54.Alignment := taCenter;
  Label54.Layout := tlCenter;
  Label54.Transparent := False;
  Label54.ParentColor := False;
  Label54.Color := RGBToColor(18, 76, 91);
  Label54.ParentFont := False;
  Label54.Font.Name := 'Sans';
  Label54.Font.Height := -12;
  Label54.Font.Style := [fsBold];
  Label54.Font.Color := clWhite;

  DBGrid3.SetBounds(16, 50, Panel7.ClientWidth - 32, 126);
  DBGrid3.Color := clWhite;
  DBGrid3.BringToFront;

  Label56.AutoSize := False;
  Label56.SetBounds(16, 188, Panel7.ClientWidth - 32, 30);
  Label56.Alignment := taCenter;
  Label56.Layout := tlCenter;
  Label56.Transparent := False;
  Label56.ParentColor := False;
  Label56.Color := RGBToColor(18, 76, 91);
  Label56.ParentFont := False;
  Label56.Font.Name := 'Sans';
  Label56.Font.Height := -12;
  Label56.Font.Style := [fsBold];
  Label56.Font.Color := clWhite;

  DBGrid4.SetBounds(
    16,
    226,
    Panel7.ClientWidth - 32,
    Max(104, Panel7.ClientHeight - 296)
  );
  DBGrid4.Color := clWhite;
  DBGrid4.BringToFront;

  BitBtn19.SetBounds(16, Panel7.ClientHeight - 46, 96, 32);
  BitBtn20.SetBounds(Panel7.ClientWidth - 112, Panel7.ClientHeight - 46, 96, 32);

  Label54.BringToFront;
  Label56.BringToFront;
  BitBtn19.BringToFront;
  BitBtn20.BringToFront;
  Panel7.BringToFront;
end;

procedure TFClientes.PrepararEtiquetaFacturacion(ALabel: TLabel);
begin
  if not Assigned(ALabel) then
    Exit;

  ALabel.AutoSize := False;
  ALabel.WordWrap := False;
  ALabel.Layout := tlCenter;
  ALabel.Alignment := taLeftJustify;
  ALabel.ParentFont := False;
  ALabel.Font.Name := 'Sans';
  ALabel.Font.Height := -11;
  ALabel.Font.Style := [fsBold];
  ALabel.Font.Color := RGBToColor(51, 65, 85);
end;

procedure TFClientes.CrearEstructuraVisual;

  procedure CrearTarjeta(AParent: TWinControl; out APanel: TShape;
    out ATitulo: TLabel; const ATexto: string; AColorTitulo: TColor);
  begin
    APanel := TShape.Create(Self);
    APanel.Parent := AParent;
    APanel.Shape := stRectangle;
    APanel.Brush.Color := clWhite;
    APanel.Pen.Color := RGBToColor(218, 226, 230);
    APanel.Pen.Width := 1;
    APanel.SendToBack;

    ATitulo := TLabel.Create(Self);
    ATitulo.Parent := AParent;
    ATitulo.AutoSize := False;
    ATitulo.Caption := ATexto;
    ATitulo.Alignment := taLeftJustify;
    ATitulo.Layout := tlCenter;
    ATitulo.Transparent := False;
    ATitulo.ParentColor := False;
    ATitulo.Color := AColorTitulo;
    ATitulo.Font.Name := 'Sans';
    ATitulo.Font.Height := -11;
    ATitulo.Font.Style := [fsBold];
    ATitulo.Font.Color := RGBToColor(18, 76, 91);
  end;

begin
  if Assigned(FHeaderBar) then
    Exit;

  FHeaderBar := TPanel.Create(Self);
  FHeaderBar.Parent := Self;
  FHeaderBar.Align := alTop;
  FHeaderBar.Height := 84;
  FHeaderBar.BevelOuter := bvNone;
  FHeaderBar.ParentColor := False;
  FHeaderBar.Color := RGBToColor(18, 76, 91);

  FHeaderTitle := TLabel.Create(Self);
  FHeaderTitle.Parent := FHeaderBar;
  FHeaderTitle.AutoSize := False;
  FHeaderTitle.Caption := 'GESTION DE CLIENTES';
  FHeaderTitle.Transparent := True;
  FHeaderTitle.Layout := tlCenter;
  FHeaderTitle.Font.Name := 'Sans';
  FHeaderTitle.Font.Height := -20;
  FHeaderTitle.Font.Style := [fsBold];
  FHeaderTitle.Font.Color := clWhite;

  FHeaderSubtitle := TLabel.Create(Self);
  FHeaderSubtitle.Parent := FHeaderBar;
  FHeaderSubtitle.AutoSize := False;
  FHeaderSubtitle.Caption :=
    'Ficha comercial, facturacion, bancos, historicos y estadisticas';
  FHeaderSubtitle.Transparent := True;
  FHeaderSubtitle.Layout := tlCenter;
  FHeaderSubtitle.Font.Name := 'Sans';
  FHeaderSubtitle.Font.Height := -11;
  FHeaderSubtitle.Font.Color := RGBToColor(205, 232, 237);

  FSearchCard := TPanel.Create(Self);
  FSearchCard.Parent := FHeaderBar;
  FSearchCard.BevelOuter := bvNone;
  FSearchCard.BorderWidth := 1;
  FSearchCard.ParentColor := False;
  FSearchCard.Color := RGBToColor(247, 250, 251);

  FSearchCaption := TLabel.Create(Self);
  FSearchCaption.Parent := FSearchCard;
  FSearchCaption.AutoSize := False;
  FSearchCaption.Caption := 'CLIENTE ACTIVO';
  FSearchCaption.Transparent := True;
  FSearchCaption.Font.Name := 'Sans';
  FSearchCaption.Font.Height := -9;
  FSearchCaption.Font.Style := [fsBold];
  FSearchCaption.Font.Color := RGBToColor(18, 76, 91);

  Label1.Parent := FSearchCard;
  Edit1.Parent := FSearchCard;
  btCodigo.Parent := FSearchCard;
  Label7.Parent := FSearchCard;
  PanelNuevoCl.Parent := FSearchCard;
  BitBtn15.Parent := FHeaderBar;

  Panel1.Align := alBottom;
  Panel1.Height := 68;
  PageControl1.Align := alClient;

  CrearTarjeta(TabSheet1, FGeneralCard, FGeneralTitle,
    'DATOS GENERALES Y CONTACTO', RGBToColor(226, 238, 242));
  CrearTarjeta(TabSheet1, FOptionsCard, FOptionsTitle,
    'OPCIONES DEL CLIENTE', RGBToColor(231, 243, 234));
  CrearTarjeta(TabSheet1, FNotesCard, FNotesTitle,
    'AVISOS Y OBSERVACIONES', RGBToColor(239, 235, 247));

  CrearTarjeta(TabSheet4, FBillingTermsCard, FBillingTermsTitle,
    'CONDICIONES COMERCIALES', RGBToColor(226, 238, 242));
  CrearTarjeta(TabSheet4, FBillingDocsCard, FBillingDocsTitle,
    'CONFIGURACION DE FACTURACION', RGBToColor(242, 238, 226));
  CrearTarjeta(TabSheet4, FDeliveryCard, FDeliveryTitle,
    'RUTAS, TRANSPORTE Y ENTREGA', RGBToColor(231, 243, 234));

  CrearTarjeta(TabSheet5, FBankCard, FBankTitle,
    'DATOS BANCARIOS', RGBToColor(226, 238, 242));

  FHistoryBand := TPanel.Create(Self);
  FHistoryBand.Parent := TabSheet6;
  FHistoryBand.BevelOuter := bvNone;
  FHistoryBand.ParentColor := False;
  FHistoryBand.Color := RGBToColor(226, 238, 242);

  FHistoryTitle := TLabel.Create(Self);
  FHistoryTitle.Parent := FHistoryBand;
  FHistoryTitle.AutoSize := False;
  FHistoryTitle.Caption :=
    'HISTORICO DE VENTAS    Pulse una cabecera para ordenar';
  FHistoryTitle.Transparent := True;
  FHistoryTitle.Layout := tlCenter;
  FHistoryTitle.Font.Name := 'Sans';
  FHistoryTitle.Font.Height := -11;
  FHistoryTitle.Font.Style := [fsBold];
  FHistoryTitle.Font.Color := RGBToColor(18, 76, 91);

  FStatsBand := TPanel.Create(Self);
  FStatsBand.Parent := TabSheet2;
  FStatsBand.BevelOuter := bvNone;
  FStatsBand.ParentColor := False;
  FStatsBand.Color := RGBToColor(226, 238, 242);

  FStatsTitle := TLabel.Create(Self);
  FStatsTitle.Parent := FStatsBand;
  FStatsTitle.AutoSize := False;
  FStatsTitle.Caption :=
    'ESTADISTICAS DEL CLIENTE    Pulse una cabecera para ordenar';
  FStatsTitle.Transparent := True;
  FStatsTitle.Layout := tlCenter;
  FStatsTitle.Font.Name := 'Sans';
  FStatsTitle.Font.Height := -11;
  FStatsTitle.Font.Style := [fsBold];
  FStatsTitle.Font.Color := RGBToColor(18, 76, 91);

  FChartBand := TPanel.Create(Self);
  FChartBand.Parent := TabSheet3;
  FChartBand.BevelOuter := bvNone;
  FChartBand.ParentColor := False;
  FChartBand.Color := RGBToColor(226, 238, 242);

  FChartTitle := TLabel.Create(Self);
  FChartTitle.Parent := FChartBand;
  FChartTitle.AutoSize := False;
  FChartTitle.Caption := 'EVOLUCION Y GRAFICAS DEL CLIENTE';
  FChartTitle.Transparent := True;
  FChartTitle.Layout := tlCenter;
  FChartTitle.Font.Name := 'Sans';
  FChartTitle.Font.Height := -11;
  FChartTitle.Font.Style := [fsBold];
  FChartTitle.Font.Color := RGBToColor(18, 76, 91);

  FChartOptionsCard := TShape.Create(Self);
  FChartOptionsCard.Parent := TabSheet3;
  FChartOptionsCard.Shape := stRectangle;
  FChartOptionsCard.Brush.Color := RGBToColor(247, 249, 250);
  FChartOptionsCard.Pen.Color := RGBToColor(218, 226, 230);
  FChartOptionsCard.Pen.Width := 1;
  FChartOptionsCard.SendToBack;

  CrearTarjeta(TabSheet7, FVirtualCard, FVirtualTitle,
    'ACCESO A TIENDA VIRTUAL', RGBToColor(231, 243, 234));

  FBtnNombreVisual := TPanel.Create(Self);
  FBtnNombreVisual.Parent := TabSheet1;
  PrepararBotonVisual(
    FBtnNombreVisual, @BitBtn18Click, '...', 'Buscar cliente por nombre'
  );

  FBtnEmailVisual := TPanel.Create(Self);
  FBtnEmailVisual.Parent := TabSheet1;
  PrepararBotonVisual(
    FBtnEmailVisual, @BotonEmailVisualClick, '...', 'Accion de e-mail'
  );

  FBtnPagoVisual := TPanel.Create(Self);
  FBtnPagoVisual.Parent := TabSheet1;
  PrepararBotonVisual(
    FBtnPagoVisual, @BitBtn7Click, '...', 'Buscar tipo de pago'
  );

  FBtnLOPDVisual := TPanel.Create(Self);
  FBtnLOPDVisual.Parent := TabSheet1;
  PrepararBotonVisual(
    FBtnLOPDVisual, @BitBtn21Click, 'LOPD', 'Documento LOPD'
  );

  FBtnFormularioVisual := TPanel.Create(Self);
  FBtnFormularioVisual.Parent := TabSheet4;
  PrepararBotonVisual(
    FBtnFormularioVisual, @BotonFormularioVisualClick,
    '...', 'Seleccionar formulario de facturas'
  );

  FBtnRutaVisual := TPanel.Create(Self);
  FBtnRutaVisual.Parent := TabSheet4;
  PrepararBotonVisual(
    FBtnRutaVisual, @BitBtn8Click, '...', 'Buscar ruta de facturacion'
  );

  FBtnSubRutaVisual := TPanel.Create(Self);
  FBtnSubRutaVisual.Parent := TabSheet4;
  PrepararBotonVisual(
    FBtnSubRutaVisual, @BitBtn8Click, '...', 'Buscar subruta de facturacion'
  );

  FBtnCerrarPagosVisual := TPanel.Create(Self);
  FBtnCerrarPagosVisual.Parent := Panel5;

  FOptionsImportantPanel := TPanel.Create(Self);
  FOptionsImportantPanel.Parent := TabSheet1;
  FOptionsImportantPanel.Caption := '';
  FOptionsImportantPanel.BevelOuter := bvNone;
  FOptionsImportantPanel.BorderWidth := 1;
  FOptionsImportantPanel.ParentColor := False;
  FOptionsImportantPanel.Color := RGBToColor(226,238,242);
  FOptionsImportantTitle := TLabel.Create(Self);
  FOptionsImportantTitle.Parent := FOptionsImportantPanel;
  FOptionsImportantTitle.AutoSize := False;
  FOptionsImportantTitle.Caption := 'DOCUMENTOS Y VENTAS';
  FOptionsImportantTitle.Transparent := True;
  FOptionsImportantTitle.ParentFont := False;
  FOptionsImportantTitle.Font.Name := 'Sans';
  FOptionsImportantTitle.Font.Height := -11;
  FOptionsImportantTitle.Font.Style := [fsBold];
  FOptionsImportantTitle.Font.Color := RGBToColor(18,76,91);
  cbEmail.Parent := FOptionsImportantPanel;
  CheckBox7.Parent := FOptionsImportantPanel;

  FFactOptionsPanel := TPanel.Create(Self);
  FFactOptionsPanel.Parent := TabSheet4;
  FFactOptionsPanel.Caption := '';
  FFactOptionsPanel.BevelOuter := bvNone;
  FFactOptionsPanel.BevelInner := bvNone;
  FFactOptionsPanel.BorderWidth := 1;
  FFactOptionsPanel.ParentColor := False;
  FFactOptionsPanel.Color := RGBToColor(231, 243, 234);

  FFactOptionsTitle := TLabel.Create(Self);
  FFactOptionsTitle.Parent := FFactOptionsPanel;
  FFactOptionsTitle.AutoSize := False;
  FFactOptionsTitle.Caption := 'RECIBOS E IMPRESION';
  FFactOptionsTitle.Transparent := True;
  FFactOptionsTitle.ParentFont := False;
  FFactOptionsTitle.Font.Name := 'Sans';
  FFactOptionsTitle.Font.Height := -11;
  FFactOptionsTitle.Font.Style := [fsBold];
  FFactOptionsTitle.Font.Color := RGBToColor(22, 101, 52);

  CheckBox1.Parent := FFactOptionsPanel;
  CheckBox2.Parent := FFactOptionsPanel;

  OnResize := @FormResizeModerno;
end;

procedure TFClientes.AplicarTextosUTF8Seguros;
begin
  Caption := FLXTextoUTF8Seguro(
    'FacturLinEx \u00B7 Gesti\u00F3n de clientes'
  );

  if Assigned(FHeaderTitle) then
    FHeaderTitle.Caption :=
      FLXTextoUTF8Seguro('GESTI\u00D3N DE CLIENTES');

  if Assigned(FHeaderSubtitle) then
    FHeaderSubtitle.Caption := FLXTextoUTF8Seguro(
      'Ficha comercial, facturaci\u00F3n, bancos, ' +
      'hist\u00F3ricos y estad\u00EDsticas'
    );

  if Assigned(FBillingDocsTitle) then
    FBillingDocsTitle.Caption :=
      FLXTextoUTF8Seguro('CONFIGURACI\u00D3N DE FACTURACI\u00D3N');

  if Assigned(FHistoryTitle) then
    FHistoryTitle.Caption := FLXTextoUTF8Seguro(
      'HIST\u00D3RICO DE VENTAS  \u00B7  ' +
      'Pulse una cabecera para ordenar'
    );

  if Assigned(FStatsTitle) then
    FStatsTitle.Caption := FLXTextoUTF8Seguro(
      'ESTAD\u00CDSTICAS DEL CLIENTE  \u00B7  ' +
      'Pulse una cabecera para ordenar'
    );

  if Assigned(FChartTitle) then
    FChartTitle.Caption :=
      FLXTextoUTF8Seguro('EVOLUCI\u00D3N Y GR\u00C1FICAS DEL CLIENTE');

  TabSheet4.Caption := FLXTextoUTF8Seguro('Facturaci\u00F3n');
  TabSheet6.Caption := FLXTextoUTF8Seguro('Hist\u00F3rico');
  TabSheet2.Caption := FLXTextoUTF8Seguro('Estad\u00EDsticas');
  TabSheet3.Caption := FLXTextoUTF8Seguro('Gr\u00E1ficas');

  Label1.Caption := FLXTextoUTF8Seguro('C\u00F3digo');
  Label14.Caption := FLXTextoUTF8Seguro('D\u00EDas hasta 1\u00BA plazo');
  Label18.Caption := FLXTextoUTF8Seguro('N\u00FAmero de plazos');
  Label26.Caption := FLXTextoUTF8Seguro('Importe cr\u00E9dito act.');
  Label28.Caption := FLXTextoUTF8Seguro('Riesgo m\u00E1ximo');
  Label29.Caption := FLXTextoUTF8Seguro('Fecha \u00FAlt. entrega');
  Label30.Caption := FLXTextoUTF8Seguro('M\u00EDnimo a facturar');
  Label31.Caption := FLXTextoUTF8Seguro('M\u00EDnimo 1\u00BA plazo');
  Label32.Caption := FLXTextoUTF8Seguro('Importe \u00FAlt. entrega');
  Label15.Caption := FLXTextoUTF8Seguro('Ruta de facturaci\u00F3n');
  Label55.Caption := FLXTextoUTF8Seguro('Tipo de gr\u00E1fica');
  Label63.Caption := FLXTextoUTF8Seguro('Contrase\u00F1a');
  Label17.Caption :=
    FLXTextoUTF8Seguro('Observaciones (escriba aqu\u00ED)');

  LabelCosteInfo.Caption := FLXTextoUTF8Seguro(
    'Usa A24 como base sin IVA y aplica el IVA del art\u00EDculo. ' +
    'Si no hay coste v\u00E1lido, conserva el precio normal.'
  );

  BitBtn7.Caption := 'Buscar';
  BitBtn7.Hint := FLXTextoUTF8Seguro('Buscar tipo de pago');
  BitBtn17.Caption := 'Buscar';
  BitBtn17.Hint :=
    FLXTextoUTF8Seguro('Buscar ruta de facturaci\u00F3n');
  BitBtn8.Caption := 'Buscar';
  BitBtn8.Hint :=
    FLXTextoUTF8Seguro('Buscar subruta de facturaci\u00F3n');

  btCodigo.Hint :=
    FLXTextoUTF8Seguro('Genera n\u00FAmero de cliente nuevo.');

  if DBGrid1.Columns.Count > 0 then
    DBGrid1.Columns[0].Title.Caption :=
      FLXTextoUTF8Seguro('A\u00D1O');
end;

procedure TFClientes.AjustarDisenoModerno;
var
  W, H, SearchLeft, SearchWidth, StartX, Gap, ButtonWidth: Integer;
  RightLeft, RightWidth, GridWidth, ColWidth, I: Integer;
  Col1, Col2, Col3, LabelWidth, EditY, RowGap: Integer;
  Botones: array[0..5] of TBitBtn;
  Etiquetas: array[0..5] of TLabel;
  Valores: array[0..5] of TLabel;
begin
  if not Assigned(FHeaderBar) then
    Exit;

  W := ClientWidth;

  SearchLeft := Max(390, W - 640);
  SearchWidth := W - SearchLeft - 100;
  if SearchWidth < 360 then
  begin
    SearchLeft := Max(330, W - 470);
    SearchWidth := W - SearchLeft - 88;
  end;

  FHeaderTitle.SetBounds(24, 12, Max(260, SearchLeft - 48), 31);
  FHeaderSubtitle.SetBounds(24, 44, Max(260, SearchLeft - 48), 23);
  FSearchCard.SetBounds(SearchLeft, 12, SearchWidth, 60);

  FSearchCaption.SetBounds(14, 5, 130, 15);
  Label1.SetBounds(14, 31, 48, 18);
  Label1.Caption := 'Codigo';
  Edit1.SetBounds(66, 24, 82, 29);
  btCodigo.SetBounds(154, 24, 78, 29);
  Label7.SetBounds(244, 21, Max(100, SearchWidth - 254), 34);
  PanelNuevoCl.SetBounds(240, 17, Max(110, SearchWidth - 248), 40);
  BitBtn15.SetBounds(W - 84, 25, 68, 32);

  Botones[0] := BitBtn2;
  Botones[1] := BitBtn4;
  Botones[2] := BitBtn3;
  Botones[3] := BitBtn5;
  Botones[4] := BitBtn6;
  Botones[5] := BitBtn1;

  ButtonWidth := 112;
  Gap := 10;
  StartX := Max(12,
    (Panel1.ClientWidth - (6 * ButtonWidth + 5 * Gap)) div 2);

  for I := 0 to 5 do
    Botones[I].SetBounds(
      StartX + I * (ButtonWidth + Gap), 16, ButtonWidth, 36
    );

  BitBtn2.Caption := 'Nuevo';
  BitBtn4.Caption := 'Modificar';
  BitBtn3.Caption := 'Borrar';
  BitBtn5.Caption := 'Anterior';
  BitBtn6.Caption := 'Siguiente';
  BitBtn1.Caption := 'Cerrar';

  { General }
  W := TabSheet1.ClientWidth;
  H := TabSheet1.ClientHeight;
  RightLeft := Max(720, W - 328);
  RightWidth := W - RightLeft - 8;

  FGeneralCard.SetBounds(8, 10, RightLeft - 16, 382);
  FGeneralTitle.SetBounds(22, 16, 300, 22);
  FOptionsCard.SetBounds(RightLeft, 10, RightWidth, 382);
  FOptionsTitle.SetBounds(
    RightLeft + 14, 16, RightWidth - 28, 22
  );

  { Fila 1: Nombre y busqueda }
  Label2.SetBounds(24, 52, 92, 18);
  Edit2.SetBounds(124, 46, Max(260, RightLeft - 196), 28);
  FBtnNombreVisual.SetBounds(RightLeft - 62, 46, 42, 28);
  BitBtn18.Visible := False;
  FBtnNombreVisual.BringToFront;

  { Fila 2: Representante }
  Label22.SetBounds(24, 90, 92, 18);
  Edit3.SetBounds(124, 84, Max(260, RightLeft - 152), 28);

  { Fila 3: Direccion }
  Label3.SetBounds(24, 128, 92, 18);
  Edit4.SetBounds(124, 122, Max(260, RightLeft - 152), 28);

  { Fila 4: Localidad }
  Label4.SetBounds(24, 166, 92, 18);
  Edit5.SetBounds(124, 160, Max(260, RightLeft - 152), 28);

  { Fila 5: Codigo postal y provincia }
  Label5.SetBounds(24, 204, 92, 18);
  Edit6.SetBounds(124, 198, 90, 28);
  Label6.SetBounds(236, 204, 68, 18);
  Edit7.SetBounds(310, 198, Max(190, RightLeft - 338), 28);

  { Fila 6: NIF/CIF y correo }
  Label8.SetBounds(24, 242, 92, 18);
  Edit8.SetBounds(124, 236, 176, 28);
  Label23.SetBounds(322, 242, 58, 18);
  Edit9.SetBounds(386, 236, Max(150, RightLeft - 414), 28);
  FBtnEmailVisual.SetBounds(RightLeft - 62, 236, 42, 28);
  BitBtn9.Visible := False;
  FBtnEmailVisual.BringToFront;

  { Fila 7: Telefono y fax }
  Label10.SetBounds(24, 280, 92, 18);
  Edit10.SetBounds(124, 274, 150, 28);
  Label9.SetBounds(306, 280, 42, 18);
  Edit11.SetBounds(354, 274, 150, 28);

  { Fila 8: Forma de pago }
  Label13.SetBounds(24, 318, 92, 18);
  Edit12.SetBounds(124, 312, 54, 30);
  FBtnPagoVisual.SetBounds(184, 312, 42, 30);
  StaticText1.SetBounds(234, 312, Max(160, RightLeft - 262), 30);
  BitBtn7.Visible := False;
  FBtnPagoVisual.BringToFront;

  { Fila 9: Vacaciones y dias de pago }
  Label11.SetBounds(24, 356, 96, 18);
  Edit13.SetBounds(124, 350, 54, 28);
  Label12.SetBounds(224, 356, 82, 18);
  Edit14.SetBounds(312, 350, 126, 28);

  { Panel lateral: opciones reales, sin huecos muertos }
  FBtnLOPDVisual.SetBounds(RightLeft + 16, 48, 110, 32);
  BitBtn21.Visible := False;
  FBtnLOPDVisual.BringToFront;

  PanelCoste.SetBounds(
    RightLeft + 14, 94, Max(230, RightWidth - 28), 148
  );
  LabelCosteTitulo.SetBounds(
    16, 12, PanelCoste.ClientWidth - 32, 22
  );
  CheckBox8.SetBounds(
    16, 42, PanelCoste.ClientWidth - 32, 24
  );
  LabelCosteInfo.SetBounds(
    16, 72, PanelCoste.ClientWidth - 32, 62
  );

  FOptionsImportantPanel.SetBounds(RightLeft+14,250,Max(230,RightWidth-28),118);
  FOptionsImportantTitle.SetBounds(14,8,FOptionsImportantPanel.ClientWidth-28,20);
  cbEmail.SetBounds(14,36,FOptionsImportantPanel.ClientWidth-28,24);
  cbEmail.Caption := 'Enviar documentos por e-mail';
  cbEmail.Visible := True;
  cbEmail.Enabled := True;
  CheckBox7.SetBounds(14,68,FOptionsImportantPanel.ClientWidth-28,36);
  CheckBox7.Caption := 'Capturar observaciones en Ventas';
  CheckBox7.Visible := True;
  CheckBox7.Enabled := True;
  FOptionsImportantPanel.BringToFront;
  FOptionsImportantTitle.BringToFront;
  cbEmail.BringToFront;
  CheckBox7.BringToFront;

  { Avisos y observaciones }
  FNotesCard.SetBounds(8, 402, W - 16, Max(154, H - 410));
  FNotesTitle.SetBounds(22, 408, 260, 22);

  Label61.Caption := 'Aviso breve en Ventas';
  Label61.AutoSize := False;
  Label61.SetBounds(22, 446, 150, 22);
  Edit54.SetBounds(180, 440, Max(240, W - 204), 30);

  Label17.Caption := 'Observaciones (escriba aqui)';
  Label17.AutoSize := False;
  Label17.SetBounds(22, 486, 150, 22);
  Memo1.SetBounds(
    180, 480, Max(240, W - 204), Max(96, H - 504)
  );

  { Los fondos TShape deben quedar detras y los controles delante. }
  FGeneralCard.SendToBack;
  FOptionsCard.SendToBack;
  FNotesCard.SendToBack;

  FGeneralTitle.BringToFront;
  FOptionsTitle.BringToFront;
  FNotesTitle.BringToFront;

  Label2.BringToFront;
  FBtnNombreVisual.BringToFront;
  FBtnEmailVisual.BringToFront;
  FBtnLOPDVisual.BringToFront;
  Label22.BringToFront;
  Label3.BringToFront;
  Label4.BringToFront;
  Label5.BringToFront;
  Label6.BringToFront;
  Label8.BringToFront;
  Label23.BringToFront;
  Label10.BringToFront;
  Label9.BringToFront;
  Label13.BringToFront;
  Edit12.BringToFront;
  FBtnPagoVisual.BringToFront;
  StaticText1.BringToFront;
  Label11.BringToFront;
  Label12.BringToFront;
  Label61.BringToFront;
  Label17.BringToFront;
  Edit54.BringToFront;
  Memo1.BringToFront;

  { Facturacion: distribucion completa, sin posiciones heredadas }
  W := TabSheet4.ClientWidth;
  H := TabSheet4.ClientHeight;

  Bevel1.Visible := False;

  { Preparar todas las etiquetas para que GTK no las expanda sobre
    los campos vecinos. }
  PrepararEtiquetaFacturacion(Label14);
  PrepararEtiquetaFacturacion(Label16);
  PrepararEtiquetaFacturacion(Label18);
  PrepararEtiquetaFacturacion(Label19);
  PrepararEtiquetaFacturacion(Label20);
  PrepararEtiquetaFacturacion(Label21);
  PrepararEtiquetaFacturacion(Label24);
  PrepararEtiquetaFacturacion(Label25);
  PrepararEtiquetaFacturacion(Label26);
  PrepararEtiquetaFacturacion(Label27);
  PrepararEtiquetaFacturacion(Label28);
  PrepararEtiquetaFacturacion(Label29);
  PrepararEtiquetaFacturacion(Label30);
  PrepararEtiquetaFacturacion(Label31);
  PrepararEtiquetaFacturacion(Label32);
  PrepararEtiquetaFacturacion(Label53);
  PrepararEtiquetaFacturacion(Label33);
  PrepararEtiquetaFacturacion(Label15);
  PrepararEtiquetaFacturacion(Label58);
  PrepararEtiquetaFacturacion(Label34);
  PrepararEtiquetaFacturacion(Label35);
  PrepararEtiquetaFacturacion(Label36);
  PrepararEtiquetaFacturacion(Label37);
  PrepararEtiquetaFacturacion(Label59);
  PrepararEtiquetaFacturacion(Label60);

  { Tarjeta 1: condiciones comerciales }
  FBillingTermsCard.SetBounds(8, 8, W - 16, 246);
  FBillingTermsTitle.SetBounds(22, 16, 250, 22);

  ColWidth := (W - 48) div 3;
  Col1 := 24;
  Col2 := 24 + ColWidth;
  Col3 := 24 + ColWidth * 2;
  LabelWidth := Max(122, ColWidth - 142);
  EditY := 52;
  RowGap := 38;

  Label14.SetBounds(Col1, EditY, LabelWidth, 24);
  Edit16.SetBounds(Col1 + LabelWidth + 8, EditY - 2, 78, 28);
  Label16.SetBounds(Col2, EditY, LabelWidth, 24);
  Edit17.SetBounds(Col2 + LabelWidth + 8, EditY - 2, 78, 28);
  Label18.SetBounds(Col3, EditY, LabelWidth, 24);
  Edit18.SetBounds(Col3 + LabelWidth + 8, EditY - 2, 78, 28);

  Label19.SetBounds(Col1, EditY + RowGap, LabelWidth, 24);
  Edit19.SetBounds(Col1 + LabelWidth + 8, EditY + RowGap - 2, 52, 28);
  Label20.SetBounds(Col2, EditY + RowGap, LabelWidth, 24);
  Edit20.SetBounds(Col2 + LabelWidth + 8, EditY + RowGap - 2, 84, 28);
  Label21.SetBounds(Col3, EditY + RowGap, LabelWidth, 24);
  Edit21.SetBounds(Col3 + LabelWidth + 8, EditY + RowGap - 2, 84, 28);

  Label24.SetBounds(Col1, EditY + RowGap * 2, LabelWidth, 24);
  Edit22.SetBounds(Col1 + LabelWidth + 8, EditY + RowGap * 2 - 2, 52, 28);
  Label25.SetBounds(Col2, EditY + RowGap * 2, LabelWidth, 24);
  Edit23.SetBounds(Col2 + LabelWidth + 8, EditY + RowGap * 2 - 2, 52, 28);
  Label26.SetBounds(Col3, EditY + RowGap * 2, LabelWidth, 24);
  Edit24.SetBounds(Col3 + LabelWidth + 8, EditY + RowGap * 2 - 2, 104, 28);

  Label27.SetBounds(Col1, EditY + RowGap * 3, LabelWidth, 24);
  Edit25.SetBounds(Col1 + LabelWidth + 8, EditY + RowGap * 3 - 2, 104, 28);
  Label28.SetBounds(Col2, EditY + RowGap * 3, LabelWidth, 24);
  Edit26.SetBounds(Col2 + LabelWidth + 8, EditY + RowGap * 3 - 2, 104, 28);
  Label29.SetBounds(Col3, EditY + RowGap * 3, LabelWidth, 24);
  Edit27.SetBounds(Col3 + LabelWidth + 8, EditY + RowGap * 3 - 2, 104, 28);

  Label30.SetBounds(Col1, EditY + RowGap * 4, LabelWidth, 24);
  Edit28.SetBounds(Col1 + LabelWidth + 8, EditY + RowGap * 4 - 2, 104, 28);
  Label31.SetBounds(Col2, EditY + RowGap * 4, LabelWidth, 24);
  Edit29.SetBounds(Col2 + LabelWidth + 8, EditY + RowGap * 4 - 2, 104, 28);
  Label32.SetBounds(Col3, EditY + RowGap * 4, LabelWidth, 24);
  Edit30.SetBounds(Col3 + LabelWidth + 8, EditY + RowGap * 4 - 2, 104, 28);

  { Tarjeta 2: configuracion y rutas }
  FBillingDocsCard.SetBounds(8, 264, W - 16, 126);
  FBillingDocsTitle.SetBounds(22, 272, 280, 22);

  Label53.SetBounds(24, 306, 122, 24);
  Edit50.SetBounds(154, 304, 48, 28);

  Label33.SetBounds(230, 306, 142, 24);
  FBtnFormularioVisual.SetBounds(380, 304, 42, 28);
  Edit31.SetBounds(430, 304, Max(220, W - 458), 28);
  BitBtn10.Visible := False;
  FBtnFormularioVisual.BringToFront;
  Edit31.BringToFront;

  Label15.SetBounds(24, 346, 122, 24);
  Edit15.SetBounds(154, 344, 58, 30);
  FBtnRutaVisual.SetBounds(218, 344, 42, 30);
  Label58.SetBounds(274, 346, 60, 24);
  Edit51.SetBounds(340, 344, 58, 30);
  FBtnSubRutaVisual.SetBounds(404, 344, 42, 30);
  StaticText2.SetBounds(460, 344, Max(184, W - 542), 30);
  BitBtn17.Visible := False;
  BitBtn8.Visible := False;
  FBtnRutaVisual.BringToFront;
  FBtnSubRutaVisual.BringToFront;

  { Tarjeta 3: transporte, entrega, recibos y puntos }
  FDeliveryCard.SetBounds(8, 400, W - 16, Max(190, H - 408));
  FDeliveryTitle.SetBounds(22, 408, 320, 22);

  RightLeft := Max(530, (W * 3) div 5);
  RightWidth := W - RightLeft - 32;

  Label34.SetBounds(24, 448, 142, 24);
  Edit32.SetBounds(174, 446, Max(250, RightLeft - 198), 28);

  Label35.SetBounds(24, 488, 142, 24);
  Edit33.SetBounds(174, 486, Max(250, RightLeft - 198), 28);

  Label36.SetBounds(24, 528, 142, 24);
  Edit34.SetBounds(174, 526, Max(170, RightLeft - 310), 28);
  Label37.SetBounds(RightLeft - 120, 528, 72, 24);
  Edit35.SetBounds(RightLeft - 42, 526, 42, 28);

  FFactOptionsPanel.SetBounds(
    RightLeft + 12,
    438,
    Max(300, RightWidth - 4),
    112
  );
  FFactOptionsTitle.SetBounds(
    14, 8, FFactOptionsPanel.ClientWidth - 28, 20
  );

  CheckBox1.SetBounds(
    14, 38, FFactOptionsPanel.ClientWidth - 28, 24
  );
  CheckBox1.Caption := 'Generar recibos bancarios al facturar';
  CheckBox1.Visible := True;
  CheckBox1.Enabled := True;

  CheckBox2.SetBounds(
    14, 70, FFactOptionsPanel.ClientWidth - 28, 24
  );
  CheckBox2.Caption := 'Imprimir banco/caja en las facturas';
  CheckBox2.Visible := True;
  CheckBox2.Enabled := True;

  FFactOptionsPanel.BringToFront;
  FFactOptionsTitle.BringToFront;
  CheckBox1.BringToFront;
  CheckBox2.BringToFront;

  Label59.SetBounds(RightLeft + 20, 566, Max(170, RightWidth - 112), 24);
  Edit52.SetBounds(W - 104, 564, 72, 28);
  Label60.SetBounds(RightLeft + 20, 606, Max(170, RightWidth - 112), 24);
  Edit53.SetBounds(W - 104, 604, 72, 28);

  { Fondos al fondo. }
  FBillingTermsCard.SendToBack;
  FBillingDocsCard.SendToBack;
  FDeliveryCard.SendToBack;

  { Titulos y todos los controles al frente. }
  FBillingTermsTitle.BringToFront;
  FBillingDocsTitle.BringToFront;
  FDeliveryTitle.BringToFront;

  Label14.BringToFront; Edit16.BringToFront;
  Label16.BringToFront; Edit17.BringToFront;
  Label18.BringToFront; Edit18.BringToFront;
  Label19.BringToFront; Edit19.BringToFront;
  Label20.BringToFront; Edit20.BringToFront;
  Label21.BringToFront; Edit21.BringToFront;
  Label24.BringToFront; Edit22.BringToFront;
  Label25.BringToFront; Edit23.BringToFront;
  Label26.BringToFront; Edit24.BringToFront;
  Label27.BringToFront; Edit25.BringToFront;
  Label28.BringToFront; Edit26.BringToFront;
  Label29.BringToFront; Edit27.BringToFront;
  Label30.BringToFront; Edit28.BringToFront;
  Label31.BringToFront; Edit29.BringToFront;
  Label32.BringToFront; Edit30.BringToFront;

  Label53.BringToFront; Edit50.BringToFront;
  Label33.BringToFront; Edit31.BringToFront;
  FBtnFormularioVisual.BringToFront;
  Label15.BringToFront; Edit15.BringToFront;
  FBtnRutaVisual.BringToFront;
  Label58.BringToFront; Edit51.BringToFront;
  FBtnSubRutaVisual.BringToFront;
  StaticText2.BringToFront;

  Label34.BringToFront; Edit32.BringToFront;
  Label35.BringToFront; Edit33.BringToFront;
  Label36.BringToFront; Edit34.BringToFront;
  Label37.BringToFront; Edit35.BringToFront;
  CheckBox1.BringToFront; CheckBox2.BringToFront;
  Label59.BringToFront; Edit52.BringToFront;
  Label60.BringToFront; Edit53.BringToFront;

  { Bancos }
  W := TabSheet5.ClientWidth;
  H := TabSheet5.ClientHeight;
  FBankCard.SetBounds(8, 8, W - 16, Max(390, H - 16));
  FBankTitle.SetBounds(22, 16, 220, 22);
  Edit37.Width := Max(280, W - Edit37.Left - 28);
  Edit39.Width := Edit37.Width;
  Edit40.Width := Edit37.Width;
  FBankCard.SendToBack;
  FBankTitle.BringToFront;

  { Historico }
  W := TabSheet6.ClientWidth;
  H := TabSheet6.ClientHeight;
  FHistoryBand.SetBounds(8, 8, W - 16, 34);
  FHistoryTitle.SetBounds(14, 0, FHistoryBand.ClientWidth - 28, 34);
  Panel2.Align := alNone;
  Panel2.SetBounds(W - 190, 50, 182, Max(330, H - 58));
  DBGrid2.Align := alNone;
  DBGrid2.SetBounds(8, 50, Max(300, W - 206), Max(300, H - 58));

  { Estadisticas }
  W := TabSheet2.ClientWidth;
  H := TabSheet2.ClientHeight;
  FStatsBand.SetBounds(8, 8, W - 16, 34);
  FStatsTitle.SetBounds(14, 0, FStatsBand.ClientWidth - 28, 34);
  Panel3.Align := alNone;
  Panel3.SetBounds(W - 190, 50, 182, Max(330, H - 58));
  DBGrid1.Align := alNone;
  DBGrid1.SetBounds(8, 50, Max(300, W - 206), Max(250, H - 102));

  Etiquetas[0] := Label76;
  Etiquetas[1] := Label75;
  Etiquetas[2] := Label68;
  Etiquetas[3] := Label65;
  Etiquetas[4] := Label66;
  Etiquetas[5] := Label67;

  Valores[0] := lbUC;
  Valores[1] := lbIC;
  Valores[2] := lbUV;
  Valores[3] := lbIVP;
  Valores[4] := lbIVC;
  Valores[5] := lbBeneficio;

  GridWidth := Max(300, W - 206);
  ColWidth := Max(70, GridWidth div 6);
  for I := 0 to 5 do
  begin
    Etiquetas[I].AutoSize := False;
    Etiquetas[I].Alignment := taCenter;
    Etiquetas[I].SetBounds(
      8 + I * ColWidth, H - 43, ColWidth - 4, 17
    );
    Valores[I].SetBounds(
      8 + I * ColWidth, H - 25, ColWidth - 4, 22
    );
  end;

  { Graficas }
  W := TabSheet3.ClientWidth;
  H := TabSheet3.ClientHeight;
  FChartBand.SetBounds(8, 8, W - 16, 34);
  FChartTitle.SetBounds(14, 0, FChartBand.ClientWidth - 28, 34);
  FChartOptionsCard.SetBounds(W - 190, 50, 182, Max(330, H - 58));
  Chart1.Align := alNone;
  Chart1.SetBounds(8, 50, Max(300, W - 206), Max(300, H - 58));

  Label47.SetBounds(W - 174, 65, 150, 17);
  ListBox3.SetBounds(W - 174, 86, 150, 60);
  Label48.SetBounds(W - 174, 158, 150, 17);
  ListBox4.SetBounds(W - 174, 179, 150, 158);
  Label55.SetBounds(W - 174, 348, 150, 17);
  ListBox7.SetBounds(W - 174, 369, 150, Max(75, H - 385));
  FChartOptionsCard.SendToBack;

  { Tienda virtual }
  W := TabSheet7.ClientWidth;
  H := TabSheet7.ClientHeight;
  FVirtualCard.SetBounds(8, 8, W - 16, Max(180, H - 16));
  FVirtualTitle.SetBounds(22, 16, 250, 22);
  FVirtualCard.SendToBack;
  FVirtualTitle.BringToFront;
end;

procedure TFClientes.FormResizeModerno(Sender: TObject);
begin
  AjustarDisenoModerno;
end;

procedure TFClientes.AplicarEstiloModerno;
var
  I: Integer;
begin
  CrearEstructuraVisual;

  Caption := 'FacturLinEx  Gestion de clientes';
  Color := RGBToColor(241, 245, 247);
  Font.Name := 'Sans';
  Font.Height := -12;

  Panel1.BevelOuter := bvNone;
  Panel1.ParentColor := False;
  Panel1.Color := RGBToColor(225, 233, 236);

  PageControl1.ParentFont := False;
  PageControl1.Font.Name := 'Sans';
  PageControl1.Font.Height := -12;
  PageControl1.Font.Style := [fsBold];
  PageControl1.Color := RGBToColor(241, 245, 247);

  TabSheet1.Caption := 'General';
  TabSheet4.Caption := 'Facturacion';
  TabSheet5.Caption := 'Bancos';
  TabSheet6.Caption := 'Historico';
  TabSheet2.Caption := 'Estadisticas';
  TabSheet3.Caption := 'Graficas';
  TabSheet7.Caption := 'Tienda virtual';

  TabSheet1.Color := RGBToColor(241, 245, 247);
  TabSheet4.Color := RGBToColor(241, 245, 247);
  TabSheet5.Color := RGBToColor(241, 245, 247);
  TabSheet6.Color := RGBToColor(241, 245, 247);
  TabSheet2.Color := RGBToColor(241, 245, 247);
  TabSheet3.Color := RGBToColor(241, 245, 247);
  TabSheet7.Color := RGBToColor(241, 245, 247);

  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TEdit then
      EstilarCampo(TEdit(Components[I]))
    else if Components[I] is TMemo then
      EstilarCampo(TMemo(Components[I]))
    else if Components[I] is TListBox then
      EstilarCampo(TListBox(Components[I]))
    else if Components[I] is TComboBox then
    begin
      TComboBox(Components[I]).ParentFont := False;
      TComboBox(Components[I]).Font.Name := 'Sans';
      TComboBox(Components[I]).Font.Height := -12;
    end
    else if Components[I] is TCheckBox then
    begin
      TCheckBox(Components[I]).ParentFont := False;
      TCheckBox(Components[I]).Font.Name := 'Sans';
      TCheckBox(Components[I]).Font.Height := -12;
      TCheckBox(Components[I]).Font.Color := RGBToColor(51, 65, 85);
    end
    else if Components[I] is TLabel then
    begin
      TLabel(Components[I]).ParentFont := False;
      TLabel(Components[I]).Font.Name := 'Sans';
      if TLabel(Components[I]).Font.Height > -12 then
        TLabel(Components[I]).Font.Height := -12;
      TLabel(Components[I]).Font.Color := RGBToColor(51, 65, 85);
    end;
  end;

  EstilarPanelSuave(Panel2, RGBToColor(235, 241, 243));
  EstilarPanelSuave(Panel3, RGBToColor(235, 241, 243));
  EstilarPanelSuave(Panel5, RGBToColor(205,225,233));
  EstilarPanelSuave(Panel6, clWhite);
  EstilarPanelSuave(Panel7, RGBToColor(205,225,233));
  EstilarPanelSuave(PanelCoste, RGBToColor(231, 243, 234));
  EstilarPanelSuave(PanelNuevoCl, RGBToColor(220, 252, 231));

  LabelCosteTitulo.Font.Name := 'Sans';
  LabelCosteTitulo.Font.Height := -13;
  LabelCosteTitulo.Font.Style := [fsBold];
  LabelCosteTitulo.Font.Color := RGBToColor(22, 101, 52);

  LabelCosteInfo.Font.Name := 'Sans';
  LabelCosteInfo.Font.Height := -10;
  LabelCosteInfo.Font.Color := RGBToColor(63, 98, 75);
  LabelCosteInfo.WordWrap := True;

  CheckBox8.Font.Name := 'Sans';
  CheckBox8.Font.Height := -12;
  CheckBox8.Font.Style := [fsBold];
  CheckBox8.Font.Color := RGBToColor(22, 101, 52);

  Label7.ParentFont := False;
  Label7.Font.Name := 'Sans';
  Label7.Font.Height := -14;
  Label7.Font.Style := [fsBold];
  Label7.Font.Color := RGBToColor(18, 76, 91);
  Label7.Layout := tlCenter;

  { Etiquetas de ficha: legibles y con anchura estable }
  Label2.Font.Style := [fsBold];
  Label3.Font.Style := [fsBold];
  Label4.Font.Style := [fsBold];
  Label5.Font.Style := [fsBold];
  Label6.Font.Style := [fsBold];
  Label8.Font.Style := [fsBold];
  Label9.Font.Style := [fsBold];
  Label10.Font.Style := [fsBold];
  Label11.Font.Style := [fsBold];
  Label12.Font.Style := [fsBold];
  Label13.Font.Style := [fsBold];
  Label17.Font.Style := [fsBold];
  Label22.Font.Style := [fsBold];
  Label23.Font.Style := [fsBold];
  Label61.Font.Style := [fsBold];

  Label2.Font.Color := RGBToColor(51, 65, 85);
  Label3.Font.Color := RGBToColor(51, 65, 85);
  Label4.Font.Color := RGBToColor(51, 65, 85);
  Label5.Font.Color := RGBToColor(51, 65, 85);
  Label6.Font.Color := RGBToColor(51, 65, 85);
  Label8.Font.Color := RGBToColor(51, 65, 85);
  Label9.Font.Color := RGBToColor(51, 65, 85);
  Label10.Font.Color := RGBToColor(51, 65, 85);
  Label11.Font.Color := RGBToColor(51, 65, 85);
  Label12.Font.Color := RGBToColor(51, 65, 85);
  Label13.Font.Color := RGBToColor(51, 65, 85);
  Label17.Font.Color := RGBToColor(51, 65, 85);
  Label22.Font.Color := RGBToColor(51, 65, 85);
  Label23.Font.Color := RGBToColor(51, 65, 85);
  Label61.Font.Color := RGBToColor(51, 65, 85);

  StaticText1.Font.Name := 'Sans';
  StaticText1.Font.Height := -12;
  StaticText1.Font.Color := RGBToColor(51, 65, 85);
  StaticText1.Color := RGBToColor(248, 250, 252);

  Edit54.Color := RGBToColor(255, 251, 235);
  Edit54.Font.Color := RGBToColor(30, 41, 59);
  Memo1.Color := RGBToColor(239, 246, 255);
  Memo1.Font.Color := RGBToColor(15, 23, 42);
  Memo1.BorderStyle := bsSingle;
  Memo1.ScrollBars := ssAutoVertical;

  Edit27.Color := RGBToColor(241, 245, 249);
  Edit30.Color := RGBToColor(241, 245, 249);
  Edit53.Color := RGBToColor(241, 245, 249);

  Label1.ParentFont := False;
  Label1.Font.Name := 'Sans';
  Label1.Font.Height := -10;
  Label1.Font.Style := [fsBold];
  Label1.Font.Color := RGBToColor(71, 85, 105);

  Edit1.ParentFont := False;
  Edit1.Font.Name := 'Sans';
  Edit1.Font.Height := -13;
  Edit1.Font.Style := [fsBold];
  Edit1.Font.Color := RGBToColor(18, 76, 91);
  Edit1.Color := clWhite;

  EstilarBoton(BitBtn2, RGBToColor(5, 150, 105), True);
  EstilarBoton(BitBtn4, RGBToColor(18, 76, 91), True);
  EstilarBoton(BitBtn3, RGBToColor(185, 28, 28), True);
  EstilarBoton(BitBtn5, RGBToColor(226, 232, 240), False);
  EstilarBoton(BitBtn6, RGBToColor(226, 232, 240), False);
  EstilarBoton(BitBtn1, RGBToColor(71, 85, 105), True);
  EstilarBoton(btCodigo, RGBToColor(219, 234, 254), False);
  EstilarBoton(BitBtn15, RGBToColor(30, 64, 79), True);

  BitBtn7.Caption := 'Buscar';
  BitBtn7.ParentFont := False;
  BitBtn7.Font.Name := 'Sans';
  BitBtn7.Font.Height := -11;
  BitBtn7.Font.Style := [fsBold];
  BitBtn7.Font.Color := clBlack;
  BitBtn7.Color := RGBToColor(191, 219, 254);
  BitBtn7.ShowHint := True;
  BitBtn7.Visible := True;
  BitBtn7.Enabled := True;
  BitBtn7.TabStop := True;

  // TButton resulta mas fiable que TBitBtn con los temas GTK actuales:
  // el texto permanece visible y conserva el mismo evento original.
  BitBtn17.Caption := 'Buscar';
  BitBtn17.ParentFont := False;
  BitBtn17.Font.Name := 'Sans';
  BitBtn17.Font.Height := -11;
  BitBtn17.Font.Style := [fsBold];
  BitBtn17.Font.Color := clBlack;
  BitBtn17.Color := RGBToColor(191, 219, 254);
  BitBtn17.Hint := 'Buscar ruta de facturacion';
  BitBtn17.ShowHint := True;
  BitBtn17.Visible := True;
  BitBtn17.Enabled := True;
  BitBtn17.TabStop := True;

  BitBtn8.Caption := 'Buscar';
  BitBtn8.ParentFont := False;
  BitBtn8.Font.Name := 'Sans';
  BitBtn8.Font.Height := -11;
  BitBtn8.Font.Style := [fsBold];
  BitBtn8.Font.Color := clBlack;
  BitBtn8.Color := RGBToColor(191, 219, 254);
  BitBtn8.Hint := 'Buscar subruta de facturacion';
  BitBtn8.ShowHint := True;
  BitBtn8.Visible := True;
  BitBtn8.Enabled := True;
  BitBtn8.TabStop := True;

  PrepararPanelPagos;
  PrepararPanelRutas;

  EstilarBoton(BitBtn9, RGBToColor(219, 234, 254), False);
  EstilarBoton(BitBtn10, RGBToColor(219, 234, 254), False);
  BitBtn10.OnClick := @BotonFormularioVisualClick;
  EstilarBoton(BitBtn11, RGBToColor(18, 76, 91), True);
  EstilarBoton(BitBtn12, RGBToColor(5, 150, 105), True);
  EstilarBoton(BitBtn13, RGBToColor(18, 76, 91), True);
  EstilarBoton(BitBtn14, RGBToColor(185, 28, 28), True);
  EstilarBoton(BitBtn16, RGBToColor(185, 28, 28), True);
  EstilarBoton(BitBtn18, RGBToColor(219, 234, 254), False);
  EstilarBoton(BitBtn19, RGBToColor(5, 150, 105), True);
  EstilarBoton(BitBtn20, RGBToColor(71, 85, 105), True);
  EstilarBoton(BitBtn21, RGBToColor(30, 64, 79), True);

  EstilarGrid(DBGrid1);
  EstilarGrid(DBGrid2);
  EstilarGrid(DBGrid3);
  EstilarGrid(DBGrid4);

  Chart1.Color := clWhite;
  Chart1.Title.Font.Color := RGBToColor(18, 76, 91);
  Chart1.Title.Font.Style := [fsBold];

  lbUC.Font.Style := [fsBold];
  lbIC.Font.Style := [fsBold];
  lbUV.Font.Style := [fsBold];
  lbIVP.Font.Style := [fsBold];
  lbIVC.Font.Style := [fsBold];
  lbBeneficio.Font.Style := [fsBold];
  lbBeneficio.Font.Color := RGBToColor(5, 150, 105);

  FHeaderTitle.Font.Color := clWhite;
  FHeaderTitle.Font.Height := -20;
  FHeaderTitle.Font.Style := [fsBold];
  FHeaderSubtitle.Font.Color := RGBToColor(205, 232, 237);
  FSearchCaption.Font.Color := RGBToColor(18, 76, 91);

  FGeneralTitle.Font.Color := RGBToColor(18, 76, 91);
  FOptionsTitle.Font.Color := RGBToColor(22, 101, 52);
  FNotesTitle.Font.Color := RGBToColor(88, 65, 115);
  FBillingTermsTitle.Font.Color := RGBToColor(18, 76, 91);
  FBillingDocsTitle.Font.Color := RGBToColor(120, 86, 26);
  FDeliveryTitle.Font.Color := RGBToColor(22, 101, 52);
  FBankTitle.Font.Color := RGBToColor(18, 76, 91);
  FVirtualTitle.Font.Color := RGBToColor(22, 101, 52);

  { La distribucion final tambien restaura el orden visual de etiquetas. }
  AjustarDisenoModerno;
  AplicarTextosUTF8Seguros;
end;

//=============== CREAR EL FORMULARIO ================
procedure ShowFormClientes;
begin
  with TFClientes.Create(Application) do
    begin
       ShowModal;
    end;
end;
Procedure TFClientes.Formcreate(Sender: Tobject);
var
  ErrorCoste: string;
Begin
  FCampoCosteDisponible :=
    FLX_AsegurarCampoClienteCoste(dbClientes.Connection, ErrorCoste);

  AplicarEstiloModerno;

  if not FCampoCosteDisponible then
  begin
    CheckBox8.Enabled := False;
    LabelCosteInfo.Caption :=
      FLXTextoUTF8Seguro('La opcion no esta disponible: ') +
      ErrorCoste;
  end;

  ConfigurarOrdenacionGrids;

  //----------------- CONEXION -----------------
  //Conectate(dbConect);   // Utilizamos datamodule1.dbConexion para toda la aplicacion.
  //------------------- Tablas ------------------
  dbClientes.Sql.Text:='SELECT * FROM clientes ORDER BY C0';
  dbClientes.Active := True;
  //---------------- CONEXION SIC -----------------
  if ActivarSIC='S' then
   begin
    SicConnect.HostName:=SICHost;
    SicConnect.Database:=SICDataBase;
    SicConnect.User:=SICUsuario;
    SicConnect.Password:=SICPasswd;
    SicConnect.Port:=StrToInt(SICPuerto);
    SicConnect.Protocol:=SICProtocolo;
    SicConnect.Connected:=True;
    BitBtn15.Visible:=True;
   end;

  { Al abrir el formulario, dejar preparado el campo Codigo. }
  ActiveControl := Edit1;

  { ESC actua antes que el control activo y respeta los paneles auxiliares. }
  KeyPreview := True;
  OnKeyDown := @FormKeyDown;
  FLXAplicarTemaVisual(Self);
End;

procedure TFClientes.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key <> VK_ESCAPE then Exit;

  { Si hay un selector auxiliar abierto, ESC lo cierra primero. }
  if Panel5.Visible then
  begin
    BitBtn16Click(nil);
    Key := 0;
    Exit;
  end;

  if Panel7.Visible then
  begin
    BitBtn20Click(nil);
    Key := 0;
    Exit;
  end;

  { En la pantalla principal equivale exactamente al boton Cerrar. }
  Key := 0;
  BitBtn1Click(nil);
end;

//==================== CERRAR ======================
Procedure TFClientes.Bitbtn1click(Sender: Tobject);
Begin
  Close();
End;
Procedure TFClientes.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;
//=================== REGISTRO NUEVO ===================
Procedure TFClientes.Bitbtn2click(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
  if dbClientes.Locate('C0', Edit1.Text, []) then
    begin
      DataModule1.Mensaje(FLXTextoUTF8Seguro('Informaci\u00F3n'),'Ya existe ese cliente', 3000 , clGray);
      exit;
    end;

  if ClienteDuplicado<>'' then
    if Application.MessageBox('Grabar cliente','FacturLinEx', boxstyle) = IDNO Then Exit;

  dbClientes.Append; LlenaReg(); dbClientes.Post;
  Label7.Caption:=dbClientes.Fields[1].AsString;//--- Refrescar nombre.
  if ActivarSIC='S' then GrabarModificarSic();//------ Comprobar si se crea cliente en el SIC.
End;
//=================== BORRAR REGISTRO ===================
Procedure TFClientes.Bitbtn3click(Sender: Tobject);
Begin
   if Edit1.Text='' then exit;
   if not dbClientes.Locate('C0', Edit1.Text, []) then
     begin
       Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
       exit;
     end;
   CodClienteSic:=dbClientes.FieldByName('C47').AsString;//---- Para leer cliente en el sic.
   if Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
       Exit;
   dbClientes.Delete; Edit1.Text := ''; LimpiaForm();
   if ActivarSIC='S' then BorrarSic();//------ Comprobar si se crea cliente en el SIC.
End;

//=================== MODIFICAR ===================
Procedure TFClientes.Bitbtn4click(Sender: Tobject);
Begin
   if (Edit1.Text='') or (dbClientes.Recordcount=0) then exit;
   if not dbClientes.Locate('C0,', Edit1.Text, []) then
     begin
       Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO!');
       exit;
     end;
   If Application.MessageBox('CONFIRME LA MODIFICACION DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
   dbClientes.Edit; LlenaReg(); dbClientes.Post;
   Label7.Caption:=dbClientes.Fields[1].AsString;//--- Refrescar nombre.
   if ActivarSIC='S' then GrabarModificarSic();//------ Comprobar si se modifica cliente en el SIC.
End;


//==================== REG. ANTERIOR ===============
Procedure TFClientes.Bitbtn5click(Sender: Tobject);
Begin
  dbClientes.Prior;
  LimpiaForm(); Relleno();
End;

//==================== REG. POSTERIOR ===============
Procedure TFClientes.Bitbtn6click(Sender: Tobject);
Begin
   dbClientes.Next;
   LimpiaForm(); Relleno();
End;


//=================== CODIGO DEL CLIENTE ================
Procedure TFClientes.Edit1enter(Sender: Tobject);
Begin
 Edit1.Text := '';
 LimpiaForm();
End;

Procedure TFClientes.Edit1exit(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
   if dbClientes.Locate('C0', Edit1.Text, []) then
     Relleno() else LimpiaForm();
End;

//=================== BOTON LOPD ================
procedure TFClientes.frReport1GetValue(const ParName: String;
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
   if ParName='REGISTRO' then ParValue := REGISTRO;
end;

procedure TFClientes.BitBtn21Click(Sender: TObject);
var
  TxtQuery:String;
begin
      TituloGrid:='LOPD - Toma de datos de Cliente';
      TxtQuery:='SELECT * FROM clientes WHERE C0="'+Edit1.Text+'"';
      dbClientes1.Active:=False; dbClientes1.Sql.Text:=TxtQuery; dbClientes1.Active:=True;
     if (dbClientes1.RecordCount=0) then
       begin
         Showmessage(FLXTextoUTF8Seguro('NO HA SELECCIONADO NING\u00DAN CLIENTE'));
         exit;
       end;
     frDBDataSet1.DataSet:=dbClientes1;
     frReport1.LoadFromFile(RutaReports+'LopdClientes.lrf');
     frReport1.ShowReport;
end;

//================== Comprobaciones de duplicidad de cliente ========

function TFClientes.ClienteDuplicado(): string;
var
  txtQuery: string;
  Duplicado: string;
begin
 Duplicado:='';

 if Edit2.Text<>'' then
   begin
     txtQuery:='SELECT * FROM clientes WHERE C1="'+Edit2.Text+'"';
     dbBusca.Active:=False; dbBusca.Sql.Text:=txtQuery; dbBusca.Active:=True;
     if (dbBusca.RecordCount>0) then Duplicado:=' RAZON SOCIAL,';
   end;

 if Edit8.Text<>'' then
   begin
     txtQuery:='SELECT * FROM clientes WHERE C5="'+Edit8.Text+'"';
     dbBusca.Active:=False; dbBusca.Sql.Text:=txtQuery; dbBusca.Active:=True;
     if (dbBusca.RecordCount>0) then Duplicado:= Duplicado +' CIF/NIF,';
   end;

 Result:= Duplicado;
 if Duplicado='' then exit;

 DataModule1.Mensaje(FLXTextoUTF8Seguro('Informaci\u00F3n'),'Duplicidad en'+Duplicado+' Cliente :' +
                        dbClientes.FieldByName('C0').AsString+' ', 3000 , clGray);

end;

//================== CODIGO NUEVO CLIENTE CONFIGURABLE ==========
function TFClientes.FLX_SQLValorDoble(const S: string): string;
begin
  // Escape minimo para consultas que usan comillas dobles, siguiendo el estilo existente.
  Result := StringReplace(S, '\', '\\', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '\"', [rfReplaceAll]);
end;

function TFClientes.FLX_SoloDigitosTexto(const S: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(S) do
    if S[I] in ['0'..'9'] then
      Result := Result + S[I];
end;

function TFClientes.FLX_ClienteCodigoExiste(const ACodigo: string): Boolean;
begin
  Result := False;
  if Trim(ACodigo)='' then Exit;
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT C0 FROM clientes WHERE C0="'+FLX_SQLValorDoble(Trim(ACodigo))+'" LIMIT 1';
  dbTrabajo.Active:=True;
  Result := dbTrabajo.RecordCount>0;
end;

function TFClientes.FLX_VerUltimoClienteNormal: string;
var
  Nuevocl, Limite: integer;
begin
  // Mantiene la regla historica de la instalacion: buscar el siguiente codigo
  // por debajo de la zona reservada del cliente contado/especial.
  Limite := StrToIntDef(ClienteVario,999999)-9;
  dbTrabajo.Active:=False;
  dbTrabajo.Sql.Text:='SELECT * FROM clientes WHERE C0<"'+IntToStr(Limite)+'" ORDER BY C0 DESC LIMIT 1';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then Nuevocl:=1 else Nuevocl:=StrToIntDef(dbTrabajo.FieldByName('C0').AsString,0)+1;
  if Nuevocl<=0 then Nuevocl:=1;
  Result:=IntToStr(Nuevocl);
end;

function TFClientes.FLX_VerSiguienteClienteSuperior: string;
var
  Base: Integer;
  Ultimo: Int64;
begin
  Base := ClientesCodigoSuperiorDesde;
  if Base<=0 then Base:=999999;
  Ultimo := Base;

  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT C0 FROM clientes '+
    'WHERE C0 REGEXP "^[0-9]+$" '+
    'AND CAST(C0 AS UNSIGNED) > '+IntToStr(Base)+' '+
    'ORDER BY CAST(C0 AS UNSIGNED) DESC LIMIT 1';
  dbTrabajo.Active:=True;

  if dbTrabajo.RecordCount>0 then
    if not TryStrToInt64(dbTrabajo.FieldByName('C0').AsString, Ultimo) then
      Ultimo := Base;

  Result := IntToStr(Ultimo+1);
end;

function TFClientes.FLX_CodigoAltaClienteDesdeDocumento(const ADocumento: string; AMostrarAviso: Boolean): string;
var
  Modo, Digitos: string;
begin
  Modo := UpperCase(Trim(ClientesModoCodigoAltaNIF));
  if Modo='' then Modo:='SIGUIENTE_NORMAL';

  if Modo='NIF_SIN_LETRA' then
  begin
    Digitos := FLX_SoloDigitosTexto(ADocumento);
    if Digitos<>'' then
    begin
      if not FLX_ClienteCodigoExiste(Digitos) then
      begin
        Result := Digitos;
        Exit;
      end;
      if AMostrarAviso then
        DataModule1.Mensaje(FLXTextoUTF8Seguro('Informaci\u00F3n'),
          'El codigo derivado del NIF/CIF ya existe. Se propone el siguiente codigo normal.',
          3000, clGray);
    end;
    Result := FLX_VerUltimoClienteNormal;
    Exit;
  end;

  if Modo='SIGUIENTE_SUPERIOR' then
  begin
    Result := FLX_VerSiguienteClienteSuperior;
    Exit;
  end;

  // Modo por defecto: exactamente la numeracion normal/historica de la instalacion.
  Result := FLX_VerUltimoClienteNormal;
end;

//================== BUSCAR CLIENTES =========================
procedure TFClientes.BitBtn18Click(Sender: TObject);
begin
  if Edit2.Text='' then begin
     ShowMessage('DEBE TECLEAR EL TEXTO A BUSCAR');
     Edit2.SetFocus;
     Exit;
  end;
  Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT C0,C1,C5 FROM clientes WHERE C1 LIKE "%'+Edit2.Text+'%"',
              [FLXTextoUTF8Seguro('C\u00F3digo'),'Nombre','Nif'],'C0');
  if Edit1.Text<>'' then Edit1Exit(Edit1);
end;

procedure TFClientes.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (key=#13) then BitBtn18Click(BitBtn18);
end;

//===================== LIMPIAR DATOS =======================
Procedure TFClientes.LimpiaForm();
Begin
  Edit2.Text:=''; Edit3.Text:=''; Edit4.Text:=''; Edit5.Text:='';
  Edit6.Text:=''; Label7.Caption:='';
  Edit7.Text:=''; Edit8.Text:=''; Edit9.Text:=''; Edit10.Text:='';
  Edit11.Text:=''; Edit12.Text:=''; Edit13.Text:='';
  Edit14.Text:=''; Memo1.Lines.Text:=''; Edit15.Text:='';
  Edit16.Text:=''; Edit17.Text:=''; Edit18.Text:='';
  Edit19.Text:=''; Edit20.Text:=''; Edit21.Text:='';
  Edit22.Text:='N'; Edit23.Text:=''; Edit24.Text:='';
  Edit25.Text:=''; Edit26.Text:=''; Edit27.Text:='';
  Edit28.Text:=''; Edit29.Text:=''; Edit30.Text:='';
  Edit31.Text:=''; Edit32.Text:=''; Edit33.Text:='';
  Edit34.Text:=''; Edit35.Text:=''; Edit36.Text:='';
  Edit37.Text:=''; Edit38.Text:=''; Edit39.Text:='';
  Edit40.Text:=''; Edit41.Text:=''; Edit42.Text:='';
  Edit43.Text:=''; Edit44.Text:=''; Edit45.Text:='';
  Edit46.Text:=''; Edit47.Text:=''; Edit50.Text:='';
  Edit51.Text:=''; Edit52.Text:=''; Edit53.Text:='';
  Edit54.Text:=''; Edit55.Text:=''; Edit56.Text:='';
  CheckBox1.Checked:=False; CheckBox2.Checked:=False;
  CheckBox3.Checked:=False; CheckBox4.Checked:=False;
  CheckBox5.Checked:=False; CheckBox6.Checked:=False;
  StaticText1.Caption:='';  StaticText2.Caption:='';
  cbEmail.Checked:= False;
  CheckBox7.Checked:=False;
  CheckBox8.Checked:=False;
End;

//===================== PINTAR DATOS =======================
Procedure TFClientes.Relleno();
Begin
  if dbClientes.RecordCount=0 then exit;
  Label7.Caption:=dbClientes.Fields[1].AsString;
  Edit1.Text:=dbClientes.FieldByName('C0').AsString;//-------------- Cgo. Tienda
  Edit2.Text:=dbClientes.FieldByName('C1').AsString;//-------------- Nombre
  Edit3.Text:=dbClientes.FieldByName('C2').AsString;//-------------- Representante
  Edit4.Text:=dbClientes.FieldByName('C3').AsString;//-------------- Direccion
  Edit5.Text:=dbClientes.FieldByName('C4').AsString;//-------------- Localidad
  Edit6.Text:=dbClientes.FieldByName('C37').AsString;//------------- C.Postal
  Edit7.Text:=dbClientes.FieldByName('C38').AsString;//------------- Provincia
  Edit8.Text:=dbClientes.FieldByName('C5').AsString;//-------------- N.I.F.
  Edit9.Text:=dbClientes.FieldByName('C40').AsString;//------------- E-Mail
  cbEmail.Checked:=dbClientes.FieldByName('C55').AsBoolean; //------ Envio de facturas por email.
  CheckBox7.Checked:=dbClientes.FieldByName('C56').AsBoolean; //------ Captura Observaciones en VENTAS
  if Assigned(dbClientes.FindField('C57')) then
    CheckBox8.Checked:=dbClientes.FieldByName('C57').AsBoolean
  else
    CheckBox8.Checked:=False; //--------- Autoconsumo / precio de coste
  Edit10.Text:=dbClientes.FieldByName('C6').AsString;//------------- Telef.
  Edit11.Text:=dbClientes.FieldByName('C7').AsString;//------------- Fax
  Edit12.Text:=dbClientes.FieldByName('C9').AsString;//------------- Tipo de pago
  if Edit12.Text<>'' then VerTipoPago();//-------------------------- Nombre tipo de pago
  Edit13.Text:=dbClientes.FieldByName('C11').AsString;//------------ Mes de vacaciones
  Edit14.Text:=dbClientes.FieldByName('C12').AsString;//------------ Dias de pago
  Memo1.Lines.Text:=dbClientes.FieldByName('C36').AsString;//------- Observaciones
  Edit16.Text:=dbClientes.FieldByName('C13').AsString;//------------ Dias hasta 1o plazo
  Edit17.Text:=dbClientes.FieldByName('C14').AsString;//------------ Dias entre plazos
  Edit18.Text:=dbClientes.FieldByName('C15').AsString;//------------ Numero de plazos
  Edit19.Text:=dbClientes.FieldByName('C16').AsString;//------------ Tipo de Dto.
  Edit20.Text:=dbClientes.FieldByName('C17').AsString;//------------ Dto. comercial
  Edit21.Text:=dbClientes.FieldByName('C18').AsString;//------------ Dto. pronto pago
  Edit22.Text:=dbClientes.FieldByName('C19').AsString;//------------ Recargo equivalencia S/N
  Edit23.Text:=dbClientes.FieldByName('C43').AsString;//------------ Tipo de tarifa
  Edit24.Text:=dbClientes.FieldByName('C20').AsString;//------------ Importe credito actual
  Edit25.Text:=dbClientes.FieldByName('C21').AsString;//------------ Entregas a cuenta
  Edit26.Text:=dbClientes.FieldByName('C22').AsString;//------------ Riesgo maximo
  Edit27.Text:=dbClientes.FieldByName('C44').AsString;//------------ Fecha ultima entrega
  Edit28.Text:=dbClientes.FieldByName('C23').AsString;//------------ Minimo a facturar
  Edit29.Text:=dbClientes.FieldByName('C24').AsString;//------------ Minimo primer plazo
  Edit30.Text:=dbClientes.FieldByName('C45').AsString;//------------ Importe ultima entrega
  Edit50.Text:=dbClientes.FieldByName('C8').AsString;//------------- N. Copias Facturas
  Edit31.Text:=dbClientes.FieldByName('C39').AsString;//------------ Formulario de facturas
  Edit15.Text:=dbClientes.FieldByName('C10').AsString;//------------ Ruta de facturacion
  if Edit15.Text<>'' then VerRuta();//------------------------------ Nombre Ruta Facturacion
  Edit51.Text:=dbClientes.FieldByName('C48').AsString;//------------ Sub Ruta de facturacion
  if Edit51.Text<>'' then VerSubRuta();//--------------------------- Nombre Sub Ruta Facturacion
  Edit32.Text:=dbClientes.FieldByName('C25').AsString;//------------ Agencia de transportes
  Edit33.Text:=dbClientes.FieldByName('C27').AsString;//------------ Domicilio de entrega
  Edit34.Text:=dbClientes.FieldByName('C28').AsString;//------------ Localidad de entrega
  Edit35.Text:=dbClientes.FieldByName('C26').AsString;//------------ Portes D/P
  if dbClientes.FieldByName('C41').AsInteger=1 then
   CheckBox1.Checked:=True else CheckBox1.Checked:=False;//----- Generar Recibos bancarios
  if dbClientes.FieldByName('C42').AsInteger=1 then
   CheckBox2.Checked:=True else CheckBox2.Checked:=False;//----- Imprimir banco / Caja en facturas

  Edit36.Text:=dbClientes.FieldByName('C29').AsString;//------------ Cliente a facturar
  Edit37.Text:=dbClientes.FieldByName('C30').AsString;//------------ Nombre banco / caja
  Edit38.Text:=dbClientes.FieldByName('C31').AsString;//------------ N. Cuenta
  Edit39.Text:=dbClientes.FieldByName('C32').AsString;//------------ Domicilio banco
  Edit40.Text:=dbClientes.FieldByName('C33').AsString;//------------ Localidad banco
  Edit41.Text:=dbClientes.FieldByName('C34').AsString;//------------ Cuenta de cargo
  Edit42.Text:=dbClientes.FieldByName('C35').AsString;//------------ Cuenta de abono

  Edit52.Text:=dbClientes.FieldByName('C49').AsString;//------------ Sistema de puntos activado
  Edit53.Text:=dbClientes.FieldByName('C50').AsString;//------------ Total de puntos acumulados

  Edit54.Text:=dbClientes.FieldByName('C51').AsString;//------------ Avisos en las ventas.
  Edit55.Text:=dbClientes.FieldByName('C52').AsString;//------------ Usuario en Tienda Virtual
  Edit56.Text:=dbClientes.FieldByName('C53').AsString;//------------ Contrasena en Tienda Virtual
  If dbClientes.FieldByName('C54').AsInteger=0 then
  CheckBox6.Checked:=True else CheckBox6.Checked:=False;//----- Usuario activo en Tienda Virtual

  //-------------- Estadisticas --------------------
  RellenaEsta(FormatDateTime('YYYY',Date));//--------- Rellenar los meses que esten a 0
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT *, CC6-CC7 As BENEF FROM estaclie WHERE CC0="'+Edit1.Text+'"'+
                   ' AND CC1='+FormatDateTime('YYYY',Date)+
                   ' ORDER BY CC1 ASC, CC2 ASC';
  dbEsta.Active:=True;
  //------------------------------------------------
  CargaGrafica:=1; Graficas(); CargaGrafica:=0;//---------------- Pintar Graficas
  //-------------- Historico de compras --------------------
  Edit43.Text:='01/'+FormatDateTime('MM/YYYY',Date);
  Edit44.Text:=FormatDateTime('DD/MM/YYYY',Date);
  dbHisto.Active:=False;
  dbHisto.SQL.Text:='SELECT * FROM histoclie WHERE HC0='+Edit1.Text+
                    ' AND HC1>="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit43.Text))+'"'+
                    ' AND HC1<="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit44.Text))+'"'+
                    ' ORDER BY HC1 DESC, HC2 DESC';
  dbHisto.Active:=True;
  //-------------- Ver si esta es la misma version que la del SIC
  CodClienteSic:=dbClientes.FieldByName('C47').AsString;
  if (ActivarSIC='S') and (LeerClienteSic=true) then
    begin
      if (dbCliSic.FieldByName('ES_CLIENTE').AsString='1') and
         (dbClientes.FieldByName('C46').AsInteger<dbCliSic.FieldByName('version').AsInteger) then
         If Application.MessageBox('EXISTE DATOS ACTUALIZADOS DE ESTE CLIENTE EN EL SISTEMA SIC, LOS ACTUALIZO AQUI?','FacturLinEx - SIC (Sistema de informacion comun)', boxstyle) = IDNO Then
            Exit
         else
          begin
            CargaSic();
            If Application.MessageBox('CONFIRME LA MODIFICACION DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
               Exit;
            dbClientes.Edit; LlenaReg(); dbClientes.Post;
            Label7.Caption:=dbClientes.Fields[1].AsString;//--- Refrescar nombre.
            dbClientes.Edit;
            dbClientes.FieldByName('C46').Value:=dbCliSic.FieldByName('version').Value;//------- Control de Version
            dbClientes.Post;
          end;
    end;
  
End;
//===================== RELLENAR DATOS =======================
Procedure TFClientes.LlenaReg();
Begin
  dbClientes.FieldByName('C0').AsString:=Edit1.Text;//-------------- Cgo. Tienda
  dbClientes.FieldByName('C1').AsString:=Edit2.Text;//-------------- Nombre
  dbClientes.FieldByName('C2').AsString:=Edit3.Text;//-------------- Representante
  dbClientes.FieldByName('C3').AsString:=Edit4.Text;//-------------- Direccion
  dbClientes.FieldByName('C4').AsString:=Edit5.Text;//-------------- Localidad
  dbClientes.FieldByName('C37').AsString:=Edit6.Text;//------------- C.Postal
  dbClientes.FieldByName('C38').AsString:=Edit7.Text;//------------- Provincia
  dbClientes.FieldByName('C5').AsString:=Edit8.Text;//-------------- N.I.F.
  dbClientes.FieldByName('C40').AsString:=Edit9.Text;//------------- E-Mail
  dbClientes.FieldByName('C55').AsBoolean:=cbEmail.Checked;//------- Envio facturas por E-Mail
  dbClientes.FieldByName('C56').AsBoolean:=CheckBox7.Checked;//------- Captura datos Observaciones para VENTAS
  if Assigned(dbClientes.FindField('C57')) then
    dbClientes.FieldByName('C57').AsBoolean:=CheckBox8.Checked;//---- Autoconsumo / precio de coste
  dbClientes.FieldByName('C6').AsString:=Edit10.Text;//------------- Telef.
  dbClientes.FieldByName('C7').AsString:=Edit11.Text;//------------- Fax
  dbClientes.FieldByName('C9').AsString:=Edit12.Text;//------------- Tipo de pago
  dbClientes.FieldByName('C11').AsString:=Edit13.Text;//------------ Mes de vacaciones
  dbClientes.FieldByName('C12').AsString:=Edit14.Text;//------------ Dias de pago
  dbClientes.FieldByName('C36').AsString:=Memo1.Lines.Text;//------- Observaciones

  dbClientes.FieldByName('C13').AsString:=Edit16.Text;//------------ Dias hasta 1o plazo
  dbClientes.FieldByName('C14').AsString:=Edit17.Text;//------------ Dias entre plazos
  dbClientes.FieldByName('C15').AsString:=Edit18.Text;//------------ Numero de plazos
  dbClientes.FieldByName('C16').AsString:=Edit19.Text;//------------ Tipo de Dto.
  dbClientes.FieldByName('C17').AsString:=Edit20.Text;//------------ Dto. comercial
  dbClientes.FieldByName('C18').AsString:=Edit21.Text;//------------ Dto. pronto pago
  dbClientes.FieldByName('C19').AsString:=Edit22.Text;//------------ Recargo equivalencia S/N
  dbClientes.FieldByName('C43').AsString:=Edit23.Text;//------------ Tipo de tarifa
  dbClientes.FieldByName('C20').AsString:=Edit24.Text;//------------ Importe credito actual
  dbClientes.FieldByName('C21').AsString:=Edit25.Text;//------------ Entregas a cuenta
  dbClientes.FieldByName('C22').AsString:=Edit26.Text;//------------ Riesgo maximo
  //----- Fecha ultima entrega
  if Edit27.Text='' then
    dbClientes.FieldByName('C44').Value:=Null
  else
    dbClientes.FieldByName('C44').AsString:=Edit27.Text;//---------- Fecha ultima entrega
  dbClientes.FieldByName('C23').AsString:=Edit28.Text;//------------ Minimo a facturar
  dbClientes.FieldByName('C24').AsString:=Edit29.Text;//------------ Minimo primer plazo
  dbClientes.FieldByName('C45').AsString:=Edit30.Text;//------------ Importe ultima entrega
  dbClientes.FieldByName('C8').AsString:=Edit50.Text;//------------- N. Copias Facturas
  dbClientes.FieldByName('C39').AsString:=Edit31.Text;//------------ Formulario de facturas
  dbClientes.FieldByName('C10').AsString:=Edit15.Text;//------------ Ruta de facturacion
  dbClientes.FieldByName('C48').AsString:=Edit51.Text;//------------ Sub ruta de facturacion
  dbClientes.FieldByName('C25').AsString:=Edit32.Text;//------------ Agencia de transportes
  dbClientes.FieldByName('C27').AsString:=Edit33.Text;//------------ Domicilio de entrega
  dbClientes.FieldByName('C28').AsString:=Edit34.Text;//------------ Localidad de entrega
  dbClientes.FieldByName('C26').AsString:=Edit35.Text;//------------ Portes D/P
  if  CheckBox1.Checked=True then
    dbClientes.FieldByName('C41').AsString:='1' else
    dbClientes.FieldByName('C41').AsString:='0';//----- Generar Recibos bancarios
  if CheckBox2.Checked=True then
    dbClientes.FieldByName('C42').AsString:='1' else
    dbClientes.FieldByName('C42').AsString:='0';//----- Imprimir banco / Caja en facturas

  dbClientes.FieldByName('C29').AsString:=Edit36.Text;//------------ Cliente a facturar
  dbClientes.FieldByName('C30').AsString:=Edit37.Text;//------------ Nombre banco / caja
  dbClientes.FieldByName('C31').AsString:=Edit38.Text;//------------ N. Cuenta
  dbClientes.FieldByName('C32').AsString:=Edit39.Text;//------------ Domicilio banco
  dbClientes.FieldByName('C33').AsString:=Edit40.Text;//------------ Localidad banco
  dbClientes.FieldByName('C34').AsString:=Edit41.Text;//------------ Cuenta de cargo
  dbClientes.FieldByName('C35').AsString:=Edit42.Text;//------------ Cuenta de abono

  dbClientes.FieldByName('C49').AsString:=Edit52.Text;//------------ Sistema de puntos activado
  dbClientes.FieldByName('C50').AsString:=Edit53.Text;//------------ Total de puntos acumulados

  dbClientes.FieldByName('C51').AsString:=Edit54.Text;//------------ Aviso en ventas.
  dbClientes.FieldByName('C52').AsString:=Edit55.Text;//------------ Usuario en Tienda Virtual
  dbClientes.FieldByName('C53').AsString:=Edit56.Text;//------------ Contrasena en Tienda Virtual
  If CheckBox6.Checked=True then
    dbClientes.FieldByName('C54').AsString:='0' else
    dbClientes.FieldByName('C54').AsString:='1';//----- Usuario activo en Tienda Virtual
End;
//========================================================
//=================== TIPOS DE PAGOS =====================
//========================================================
procedure TFClientes.BitBtn7Click(Sender: TObject);
begin
  dbPagos.SQL.Text:='SELECT * FROM formapago ORDER BY FPA1 ASC';
  dbPagos.Active:=True;
  if dbPagos.RecordCount=0 then exit;
  dbPagos.First; ListBox2.Items.Clear;
  while not dbPagos.EOF do
    begin
      ListBox2.Items.Add(Space(4-length(dbPagos.FieldByName('FPA0').AsString))+
                         dbPagos.FieldByName('FPA0').AsString+' '+
                         dbPagos.FieldByName('FPA1').AsString);
      dbPagos.Next;
    end;
  dbPagos.Active := False;
  PrepararPanelPagos;
  Panel5.Visible := True;
  Panel5.BringToFront;
end;

//----------------- SELECCIONAR TIPO DE PAGO ------------
procedure TFClientes.ListBox2DblClick(Sender: TObject);
begin
  Edit12.Text:=trim(copy(ListBox2.Items.Strings[ListBox2.ItemIndex],1,4));
  if Edit12.Text<>'' then Edit12Exit(Edit12);
  Panel5.Visible:=False;
end;
//--------------- CERRAR TIPOS DE PAGOS / COBROS ------
procedure TFClientes.BitBtn16Click(Sender: TObject);
begin
  Panel5.Visible:=False;
end;

//==================== VER TIPOS DE PAGO ===============
procedure TFClientes.Edit12Enter(Sender: TObject);
begin
  StaticText1.Caption:=''
end;
procedure TFClientes.Edit12Exit(Sender: TObject);
begin
  if Edit12.Text<>'' then VerTipoPago();
end;
Procedure TFClientes.VerTipoPago();
Begin
  dbPagos.Active:=False;
  dbPagos.SQL.Text:='SELECT * FROM formapago WHERE FPA0='+Edit12.Text;
  dbPagos.Active:=True;
  if dbPagos.RecordCount=0 then
   StaticText1.Caption:=''
  else
   StaticText1.Caption:=dbPagos.Fields[1].AsString;
  dbPagos.Active:=False;
end;

//================ REC. EQUIVALENCIA ======================
procedure TFClientes.Edit22Exit(Sender: TObject);
begin
  if Edit22.Text='' then Edit22.Text:='N';
  if (Edit22.Text='S') or (Edit22.Text='N') then exit;
  showmessage('Debe teclear S o N en este campo.');
  Edit22.SetFocus;
end;


//===================================================
//================ RUTA DE FACTURACION ==============
//===================================================
procedure TFClientes.BitBtn8Click(Sender: TObject);
Var
 Campo: Array [1..2] of variant;
begin
  cargando:=1;
  dbRutas.SQL.Text:='SELECT * FROM rutas'+Tienda+' ORDER BY RUT1 ASC';
  dbRutas.Active:=True;
  if dbRutas.RecordCount=0 then exit;
  cargando:=0;
  dbRutas.First;
  if Edit15.Text<>'' then dbRutas.Locate('RUT0',Edit15.Text,[locaseinsensitive]);
  if (Edit15.Text<>'') and (Edit51.Text<>'') then
    begin
     Campo[1]:=Edit15.Text; Campo[2]:=Edit51.Text;
     dbSubRutas.Locate('SRUT0,SRUT1',VarArrayof([Edit15.Text,Edit51.Text]),[locaseinsensitive]);
    end;
  PrepararPanelRutas;
  Panel7.Visible := True;
  Panel7.BringToFront;
end;

//------- GENERAR CLIENTE NUEVO
procedure TFClientes.btCodigoClick(Sender: TObject);
begin
  // Usar exactamente la misma logica que el aviso flotante y que ventas.
  // Si en esta ficha ya se ha escrito NIF/CIF en Edit8 y el modo configurado
  // es NIF_SIN_LETRA, se podra proponer ese codigo; si no, aplica el modo normal/superior.
  Edit1.Text:=FLX_CodigoAltaClienteDesdeDocumento(Edit8.Text, True);
  edit2.SetFocus;   // pasamos el foco a la descripcion
end;

//------------------- CERRAR PANEL RUTAS ---------
procedure TFClientes.BitBtn20Click(Sender: TObject);
begin
   dbRutas.Active:=False; dbSubRutas.Active:=False;
   Panel7.Visible:=False;
end;

//----------------- SELECCIONAR RUTA ---------
procedure TFClientes.BitBtn19Click(Sender: TObject);
begin
  Edit15.Text:=dbSubRutas.FieldByName('SRUT0').AsString;
  if Edit15.Text<>'' then Edit15Exit(Edit15);
  Edit51.Text:=dbSubRutas.FieldByName('SRUT1').AsString;
  if Edit51.Text<>'' then Edit51Exit(Edit51);
  Panel7.Visible:=False;
end;



//----------------- LEER RUTA ------------
procedure TFClientes.Edit15Enter(Sender: TObject);
begin
  StaticText2.Caption:='';
end;
procedure TFClientes.Edit15Exit(Sender: TObject);
begin
  if Edit15.Text<>'' then VerRuta();
end;

procedure TFClientes.Edit1MouseEnter(Sender: TObject);
begin
  PanelNuevoCl.Visible:=True;
  // Mismo codigo propuesto que aplicara el boton de crear codigo.
  // AMostrarAviso=False evita mensajes emergentes solo por pasar el raton.
  PanelNuevoCl.Caption:=FLX_CodigoAltaClienteDesdeDocumento(Edit8.Text, False);
end;

procedure TFClientes.Edit1MouseLeave(Sender: TObject);
begin
  PanelNuevoCl.Visible:=False;
end;

Procedure TFClientes.VerRuta();
begin
  cargando:=1;
  dbRutas.Active:=False;
  dbRutas.SQL.Text:='SELECT * FROM rutas'+Tienda+' WHERE RUT0='+Edit15.Text;
  dbRutas.Active:=True;
  if dbRutas.RecordCount=0 then
   StaticText2.Caption:=''
  else
   StaticText2.Caption:=dbRutas.Fields[1].AsString;
  dbRutas.Active:=False;
  cargando:=0;
end;

//----------------- LEER SUB RUTA ------------
procedure TFClientes.Edit51Enter(Sender: TObject);
begin
  StaticText2.Caption:='';
end;
procedure TFClientes.Edit51Exit(Sender: TObject);
begin
  if Edit51.Text<>'' then
   begin
    if Edit15.Text='' then begin showmessage('PRIMERO DEBE DEFINIR LA RUTA'); exit; end;
    VerSubRuta();
   end;
end;

procedure TFClientes.Edit52Exit(Sender: TObject);
begin
  Edit52.Text:=UpperCase(Edit52.Text);
end;

Procedure TFClientes.VerSubRuta();
begin
  cargando:=1;
  dbSubRutas.Active:=False;
  dbSubRutas.SQL.Text:='SELECT * FROM subrutas'+Tienda+' WHERE SRUT0='+Edit15.Text+
                       ' AND SRUT1='+Edit51.Text;
  dbSubRutas.Active:=True;
  if dbSubRutas.RecordCount=0 then
   StaticText2.Caption:=''
  else
   StaticText2.Caption:=dbSubRutas.Fields[2].AsString;
  dbSubRutas.Active:=False;
  cargando:=0;
end;


//============== MOSTRAR SUB RUTAS AL SELECCIONAR UNA RUTA ===============
procedure TFClientes.Datasource3DataChange(Sender: TObject; Field: TField);
begin
  if cargando=1 then exit;
  if dbRutas.FieldByName('RUT0').AsString='' then exit;
  dbSubRutas.Active:=False;
  dbSubRutas.SQL.Text:='SELECT * FROM subrutas'+Tienda+
                      ' WHERE SRUT0='+dbRutas.FieldByName('RUT0').AsString+
                      ' ORDER BY SRUT1';
  dbSubRutas.Active:=True;
end;


//=======================================================
//============= FILTRO HIST. COMPRAS ====================
//=======================================================
//------------- Buscar codigo ------------
procedure TFClientes.CheckBox3Click(Sender: TObject);
begin
  if CheckBox3.Checked=True then
    Edit45.Enabled:=True else Edit45.Enabled:=False;
end;
//------------- Buscar unidades ----------
procedure TFClientes.CheckBox4Click(Sender: TObject);
begin
  if CheckBox4.Checked=True then
    Edit46.Enabled:=True else Edit46.Enabled:=False;
end;
//------------- Buscar importe ----------
procedure TFClientes.CheckBox5Click(Sender: TObject);
begin
  if CheckBox5.Checked=True then
    Edit47.Enabled:=True else Edit47.Enabled:=False;
end;

//------------ APLICAR FILTRO -----------
procedure TFClientes.BitBtn11Click(Sender: TObject);
var
  Codigo,Unidades,Importe: String;
begin
  if Edit43.Text='' then Edit43.Text:='01/'+FormatDateTime('MM/YYYY',Date);
  if Edit44.Text='' then Edit44.Text:=FormatDateTime('DD/MM/YYYY',Date);
  if StrToDate(Edit43.Text) > StrToDate(Edit44.Text) then
    begin ShowMessage('LA PRIMERA FECHA NO PUEDE SER MAYOR QUE LA ULTIMA'); exit; end;
  //------- Ver si buscar por codigo
  if (CheckBox3.Checked=True) and (Edit45.Text<>'') then
    Codigo:=' AND HC4="'+Edit45.Text+'"' else Codigo:='';
  //------- Ver si buscar por unidades
  if (CheckBox4.Checked=True) and (Edit46.Text<>'') then
    Unidades:=' AND HC6='+Edit46.Text else Unidades:='';
  //------- Ver si buscar por importe
  if (CheckBox5.Checked=True) and (Edit47.Text<>'') then
    Importe:=' AND HC7='+Edit47.Text else Importe:='';
  //-------------------------------------
  dbHisto.Active:=False;
  dbHisto.SQL.Text:='SELECT * FROM histoclie WHERE HC0='+Edit1.Text+
                    ' AND HC1>="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit43.Text))+'"'+
                    ' AND HC1<="'+FormatDateTime('YYYY/MM/DD',StrToDate(Edit44.Text))+'"'+
                    Codigo + Unidades + Importe +
                    ' ORDER BY HC1 DESC, HC2 DESC';
  dbHisto.Active:=True;
end;

//============================================================
//===================== GRAFICAS =============================
//============================================================
procedure TFClientes.Graficas();
Var
  Conta: Integer;
begin
  //-------------- Mostrar los distintos anos ------------------
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT DISTINCT CC1 FROM estaclie WHERE CC0="'+Edit1.Text+'" ORDER BY CC1 DESC';
  dbGrafica.Active:=True;
  ListBox3.Items.Clear; ListBox5.Items.Clear;
  dbGrafica.First;
  while not dbGrafica.EOF do
    begin
      ListBox3.Items.Add(dbGrafica.FieldByName('CC1').AsString);
      ListBox5.Items.Add(dbGrafica.FieldByName('CC1').AsString);
      dbGrafica.Next;
    end;
  ListBox4.ItemIndex:=0;
  //-------------- Mostrar las unidades compradas ------------------
  if ListBox3.Items.Count<>0 then
    begin
     ListBox3.ItemIndex:=0;
     Chart1Serie1.Clear; Chart1AreaSeries1.Clear;
     Chart1BarSeries1.Clear; Chart1PieSeries1.Clear;
     dbGrafica.Active:=False;
     dbGrafica.SQL.Text:='SELECT *, CC6-CC7 As BENEF FROM estaclie WHERE CC0="'+Edit1.Text+'"'+
                         ' AND CC1='+ListBox3.Items.Strings[ListBox3.ItemIndex]+
                         ' ORDER BY CC1 ASC, CC2 ASC';
     dbGrafica.Active:=True; ListBox7.ItemIndex:=0;
     dbGrafica.First; Chart1.Title.Text.Text:='Unidades Compradas';
     for conta:=1 to dbGrafica.RecordCount do
       begin
        Chart1Serie1.AddXY(conta,dbGrafica.Fields[3].AsInteger, FloatToStr(dbGrafica.Fields[3].AsFloat), clred);
        Chart1AreaSeries1.AddXY(conta,dbGrafica.Fields[3].AsInteger, FloatToStr(dbGrafica.Fields[3].AsFloat), clred);
        Chart1BarSeries1.AddXY(conta,dbGrafica.Fields[3].AsInteger, FloatToStr(dbGrafica.Fields[3].AsFloat), clred);
        Chart1PieSeries1.AddXY(conta,dbGrafica.Fields[3].AsInteger, FloatToStr(dbGrafica.Fields[3].AsFloat), clred);
        dbGrafica.Next;
       end;
    end;
end;
//------------------ Cambiar anos grafica -------------------
procedure TFClientes.ListBox3Click(Sender: TObject);
begin
  CambiarGrafica();
end;
//------------------ Cambiar datos grafica -------------------
procedure TFClientes.ListBox4Click(Sender: TObject);
begin
  CambiarGrafica();
end;
//----------------- Cambiar tipo de grafica ----------------
procedure TFClientes.ListBox7Click(Sender: TObject);
begin
 Chart1Serie1.Active:=False; Chart1AreaSeries1.Active:=False;
 Chart1BarSeries1.Active:=False; Chart1PieSeries1.Active:=False;
 case ListBox7.ItemIndex of
   0: Chart1Serie1.Active:=True;
   1: Chart1BarSeries1.Active:=True;
   2: Chart1AreaSeries1.Active:=True;
   3: Chart1PieSeries1.Active:=True;
 end;
end;

//--------------- Cambiar Grafica -----------------
procedure TFClientes.CambiarGrafica();
var
  Conta: Integer;
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox3.Items.Count=0 then exit;//----- Si no hay anos
  if ListBox3.ItemIndex=-1 then ListBox3.ItemIndex:=0;
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT *, CC6-CC7 As BENEF FROM estaclie WHERE CC0="'+Edit1.Text+'"'+
                      ' AND CC1='+ListBox3.Items.Strings[ListBox3.ItemIndex]+
                      ' ORDER BY CC1 ASC, CC2 ASC';
  dbGrafica.Active:=True;
  Chart1Serie1.Clear; Chart1AreaSeries1.Clear;
  Chart1BarSeries1.Clear; Chart1PieSeries1.Clear;
  if ListBox4.ItemIndex=-1 then ListBox4.ItemIndex:=0;
  dbGrafica.First; Chart1.Title.Text.Text:=ListBox4.Items.Strings[ListBox4.ItemIndex];
  for conta:=1 to dbGrafica.RecordCount do
    begin
     Chart1Serie1.AddXY(conta,dbGrafica.Fields[ListBox4.ItemIndex+3].AsInteger, FloatToStr(dbGrafica.Fields[ListBox4.ItemIndex+3].AsFloat), clred);
     Chart1AreaSeries1.AddXY(conta,dbGrafica.Fields[ListBox4.ItemIndex+3].AsInteger, FloatToStr(dbGrafica.Fields[ListBox4.ItemIndex+3].AsFloat), clred);
     Chart1BarSeries1.AddXY(conta,dbGrafica.Fields[ListBox4.ItemIndex+3].AsInteger, FloatToStr(dbGrafica.Fields[ListBox4.ItemIndex+3].AsFloat), clred);
     Chart1PieSeries1.AddXY(conta,dbGrafica.Fields[ListBox4.ItemIndex+3].AsInteger, FloatToStr(dbGrafica.Fields[ListBox4.ItemIndex+3].AsFloat), clred);
     dbGrafica.Next;
    end;
end;
//----------------- Cambiar estadisticas ---------------
procedure TFClientes.ListBox5Click(Sender: TObject);
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox5.Items.Count=0 then exit;//----- Si no hay anos
  if ListBox5.ItemIndex=-1 then ListBox5.ItemIndex:=0;
  RellenaEsta(ListBox5.Items.Strings[ListBox5.ItemIndex]);//--------- Rellenar los meses que esten a 0
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT *, CC6-CC7 As BENEF FROM estaclie WHERE CC0="'+Edit1.Text+'"'+
                   ' AND CC1='+ListBox5.Items.Strings[ListBox5.ItemIndex]+
                   ' ORDER BY CC1 ASC, CC2 ASC';
  dbEsta.Active:=True;
end;

//==========================================================
//============= RELLENAR MESES QUE ESTEN A 0 ===============
//==========================================================
procedure TFClientes.RellenaEsta(Ano: String);
var
  Conta: Integer;
  UC,IC,UV,IVP,IVC,Beneficio : Double;
begin
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT * FROM estaclie WHERE CC0="'+Edit1.Text+'"'+
                   ' AND CC1='+Ano+
                   ' ORDER BY CC1 ASC, CC2 ASC';
  dbEsta.Active:=True;
  dbEsta.First;

  //*********** IMPLEMENTACION DE MUESTREO DE TOTALES
    UC:=0; IC:=0; UV:=0; IVP:=0; IVC:=0; Beneficio:=0;
    While not dbEsta.EOF do
      begin
        UC := UC + dbEsta.FieldByName('CC3').Value;
        IC := IC + dbEsta.FieldByName('CC4').Value;
        UV := UV + dbEsta.FieldByName('CC5').Value;
        IVP := IVP + dbEsta.FieldByName('CC6').Value;
        IVC := IVC + dbEsta.FieldByName('CC7').Value;
        Beneficio := Beneficio + ( dbEsta.FieldByName('CC6').Value - dbEsta.FieldByName('CC7').Value );
        dbEsta.Next;
      end;

    lbUC.Caption := FormatFloat('#0.00',UC);
    lbIC.Caption := FormatFloat('#0.00',IC);
    lbUV.Caption := FormatFloat('#0.00',UV);
    lbIVP.Caption := FormatFloat('#0.00',IVP);
    lbIVC.Caption := FormatFloat('#0.00',IVC);
    lbBeneficio.Caption := FormatFloat('#0.00',Beneficio);

    dbEsta.First;
  //*********** FIN IMPLEMENTACION DE MUESTREO DE TOTALES

  for Conta:=1 to 12 do
    begin
      if not dbEsta.Locate('CC2',Conta,[]) then
        begin
           dbEsta.Append;
           dbEsta.FieldByName('CC0').AsString:=Edit1.Text;
           dbEsta.FieldByName('CC1').AsString:=Ano;
           dbEsta.FieldByName('CC2').AsString:=IntToStr(Conta);
           dbEsta.Post;
        end;
    end;
end;

//============================================================================
//======================== SISTEMA DE INFORMACION COMUN ======================
//============================================================================

//============= COMPROBAR CLIENTE EN SIC ==============
procedure TFClientes.GrabarModificarSic();
begin
   CodClienteSic:=dbClientes.FieldByName('C47').AsString;
   if LeerClienteSic=False then
     begin
        If Application.MessageBox('ESTE CLIENTE NO EXISTE EN EL S.I.C. (SISTEMA DE INFORMACION COMUN),    LO CREAMOS?','FacturLinEx - SIC (Sistema de informacion comun)', boxstyle) = IDNO Then
           Exit;
        dbCliSic.Append;
        RellenaSIC();
        dbCliSic.FieldByName('version').Value:=1;
        dbCliSic.Post;
        dbClientes.Edit;
        dbClientes.FieldByName('C46').AsString:='1';//------- Control de Version
        dbClientes.FieldByName('C47').AsString:=Edit1.Text;//-- Codigo siclinex
        dbClientes.Post;
     end
   else
     begin
        If Application.MessageBox('QUIERE ACTUALIZAR LOS CAMBIOS EN EL S.I.C.  (SISTEMA DE INFORMACION COMUN)?','FacturLinEx - SIC (Sistema de informacion comun)', boxstyle) = IDNO Then
           Exit;
        dbCliSic.Edit;
        dbCliSic.FieldByName('version').Value:=dbCliSic.FieldByName('version').AsInteger+1;
        RellenaSIC();
        dbCliSic.Post;
        dbClientes.Edit;
        dbClientes.FieldByName('C46').Value:=dbCliSic.FieldByName('version').Value;//------- Control de Version
        dbClientes.Post;
     end;
end;
//============= BORRAR CLIENTE EN SIC ==============
procedure TFClientes.BorrarSic();
begin
   if LeerClienteSic=False then exit;
     begin
        If Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO EN EL S.I.C.  (SISTEMA DE INFORMACION COMUN)?','FacturLinEx - SIC (Sistema de informacion comun)', boxstyle) = IDNO Then
           Exit;
        dbCliSic.Delete;
     end;
end;

//============= LOCALIZAR CLIENTE EN SIC POR CODIGO INTERNO ==============
function TFClientes.LeerClienteSic: Boolean;
begin
  LeerClienteSic:=False;
  //------ Buscar por codigo interno
  if dbClientes.FieldByName('C47').AsString<>'' then
    begin
     dbCliSic.Active:=False;
     dbCliSic.SQL.Text:='SELECT * FROM clientes_proveedores WHERE CODIGO="'+CodClienteSic+'"'+
                        ' AND ES_CLIENTE=1';
     dbCliSic.Active:=True;
     if dbCliSIc.RecordCount<>0 then begin LeerClienteSic:=True; exit; end;
    end
  else
    begin
     //----- De todas maneras abro el dataset para grabar el cliente si no existe
     dbCliSic.Active:=False;
     dbCliSic.SQL.Text:='SELECT * FROM clientes_proveedores WHERE CODIGO="'+CodClienteSic+'"'+
                        ' AND ES_CLIENTE=1';
     dbCliSic.Active:=True;
    end;
end;

//=============== MOSTRAR PANEL DE BUSQUEDA CLIENTES SIC ===============
procedure TFClientes.BitBtn15Click(Sender: TObject);
begin
  Panel6.Visible:=True;
end;

//=================== BUSCAR CLIENTES DEL SIC PARA IMPORTAR ============
procedure TFClientes.BitBtn13Click(Sender: TObject);
var
  TxtQ: String;
begin
  BitBtn12.Enabled:=False; ListBox1.Items.Clear;
  if (Edit48.Text='') and (Edit49.Text='') then exit;
  TxtQ:='SELECT * FROM clientes_proveedores WHERE ES_CLIENTE=1 AND ';
  if Edit49.Text<>'' then TxtQ:=TxtQ+'NOMBRE LIKE "'+Edit49.Text+'%" ';
  if (Edit49.Text<>'') and (Edit48.Text<>'') then TxtQ:=TxtQ+'AND ';
  if Edit48.Text<>'' then TxtQ:=TxtQ+'NIF LIKE "'+Edit48.Text+'%"';
  dbCliSic.Active:=False;
  dbCliSic.SQL.Text:=TxtQ;
  dbCliSic.Active:=True;
  if dbCliSIc.RecordCount=0 then begin showmessage('NO EXISTEN DATOS CON ESE FILTRO.'); exit; end;
  dbCliSic.First;
  while not dbCliSic.EOF do
    begin
      ListBox1.Items.Add(dbCliSic.FieldByName('NOMBRE').AsString);
      dbCliSic.Next;
    end;
  ListBox1.ItemIndex:=0;
  BitBtn12.Enabled:=True;
end;

//=================== IMPORTAR CLIENTES DEL SIC ===============
procedure TFClientes.BitBtn12Click(Sender: TObject);
var
  Ultimo: Integer;
begin
  if ListBox1.Items.Count=0 then exit;//----- Si no hay clientes en la lista
  if ListBox1.ItemIndex=-1 then ListBox1.ItemIndex:=0; //--- Si no hay selecionado ninguno
  dbCliSic.Locate('Nombre',ListBox1.Items.Strings[ListBox1.ItemIndex],[]);
  //----- Buscar si existe en nuestro fichero
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM clientes WHERE C47="'+dbCliSic.FieldByName('CODIGO').AsString+'"';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount<>0 then
    begin
       ShowMessage('ESTE CLIENTE DEL SIC YA EXISTE EN NUESTRO FICHERO CON EL CGO.:'+dbTrabajo.FieldByName('C0').AsString);
       Exit;
    end;
  //------ Ver cual es el ultimo cliente en nuestro file
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT C0 FROM clientes where C0<999990 ORDER BY C0 DESC';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then Ultimo:=1 else Ultimo:=dbTRabajo.FieldByName('C0').AsInteger+1;
  //------ Cargar datos en pantalla
  Edit1.Text:=IntToStr(Ultimo);
  CargaSIC();
  //------ Crear cliente en nuestro file
  if Application.MessageBox('CREAMOS EL REGISTRO EN NUESTRO FICHERO?','FacturLinEx', boxstyle) = IDYES Then
    begin
     dbClientes.Append;
     LlenaReg();
     dbClientes.FieldByName('C46').AsInteger:=dbCliSic.FieldByName('version').AsInteger;//- Control de Version
     dbClientes.FieldByName('C47').AsString:=dbCliSic.FieldByName('CODIGO').AsString;//--- Codigo siclinex
     dbClientes.Post;
     Label7.Caption:=dbClientes.FieldByName('C1').AsString;//--- Refrescar nombre.
    end
  else LimpiaForm();
  //---------------------
  dbTrabajo.Active:=False; ListBox1.Items.Clear;
  BitBtn12.Enabled:=False; Panel6.Visible:=False;
  Tabsheet1.SetFocus;
end;

//============== CERRAR PANEL IMPORTAR CLIENTES SIC ===========
procedure TFClientes.BitBtn14Click(Sender: TObject);
begin
  Panel6.Visible:=False; BitBtn12.Enabled:=False;
end;

//================== RELLENAR CAMPOS DEL SIC ===================
procedure TFClientes.RellenaSIC();
begin
  dbCliSic.FieldByName('NOMBRE').AsString:=Edit2.Text;
  dbCliSic.FieldByName('NIF').AsString:=Edit8.Text;
  dbCliSic.FieldByName('CODIGO').AsString:=Edit1.Text;
  dbCliSic.FieldByName('DIRECCION').AsString:=Edit4.Text;
  dbCliSic.FieldByName('CODPOSTAL').AsString:=Edit6.Text;
  dbCliSic.FieldByName('TELEFONO1').AsString:=Edit10.Text;
  dbCliSic.FieldByName('FAX').AsString:=Edit11.Text;
  dbCliSic.FieldByName('EMAIL').AsString:=Edit9.Text;
  dbCliSic.FieldByName('RESPONSABLE').AsString:=Edit3.Text;
  dbCliSic.FieldByName('ES_CLIENTE').AsString:='1';
end;

//================== RELLENAR CAMPOS DEL SIC ===================
procedure TFClientes.CargaSIC();
begin
  Edit2.Text:=dbCliSic.FieldByName('NOMBRE').AsString;
  Edit8.Text:=dbCliSic.FieldByName('NIF').AsString;
  Edit4.Text:=dbCliSic.FieldByName('DIRECCION').AsString;
  Edit6.Text:=dbCliSic.FieldByName('CODPOSTAL').AsString;
  Edit10.Text:=dbCliSic.FieldByName('TELEFONO1').AsString;
  Edit11.Text:=dbCliSic.FieldByName('FAX').AsString;
  Edit9.Text:=dbCliSic.FieldByName('EMAIL').AsString;
  Edit3.Text:=dbCliSic.FieldByName('RESPONSABLE').AsString;
end;

Initialization
  {$I clientes.lrs}

End.

