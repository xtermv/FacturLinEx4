{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2008,

  Nicolas Lopez de Lerma Aymerich
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

Unit listapuestos;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset, DBGrids,
  StdCtrls, db, LR_DBSet, LR_Class, Grids
  {$IFDEF LCLGTK2}
  , gtk2, gdk2
  {$ENDIF};

Type

  { TFLPuestos }

  TFLPuestos = Class(Tform)
    Edit1: TEdit;
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
    Edit24: TEdit;
    Edit25: TEdit;
    Edit26: TEdit;
    Edit27: TEdit;
    Edit28: TEdit;
    Edit29: TEdit;
    Edit3: TEdit;
    Edit30: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
    Edit4: TEdit;
    Bevel1: TBevel;
    DBGrid1: TDBGrid;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    Label1: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
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
    Label3: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    LabelTituloDBGrid: TLabel;
    LabelTituloDBGrid1: TLabel;
    ListBoxAnos2: TListBox;
    ListBoxAnos3: TListBox;
    ListBoxAnos4: TListBox;
    ListBoxAnos5: TListBox;
    ListBoxAnos6: TListBox;
    ListBoxAnos7: TListBox;
    ListBoxAnos8: TListBox;
    Panel1: Tpanel;
    Bitbtn1: Tbitbtn;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    BitBtn4: TBitBtn;
    Datasource1: TDatasource;
    dbQuery: TZQuery;
    PanelDesdeHasta: TPanel;
    PanelTituloGrid: TPanel;
    RadioButton1: TRadioButton;
    PanelCabecera: TPanel;
    PanelFiltros: TPanel;
    PanelResultados: TPanel;
    LabelTitulo: TLabel;
    LabelSubtitulo: TLabel;
    LabelFiltrosTitulo: TLabel;
    LabelAyudaFiltros: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    //procedure DBGrid2TitleClick(Column: TColumn);
    //procedure DBGrid3TitleClick(Column: TColumn);
    //procedure DBGrid4TitleClick(Column: TColumn);

    Procedure Formcreate(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);
    //procedure Colorea(Column: TColumn;Grid: TDBGrid;dbColor: TZQuery);
    procedure OcultarBDGrid();
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    //procedure RellenaListBoxAnos(TxtQuery: String);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    //procedure BlancoGrid(Grid: TDBGrid);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure RadioButton3Change(Sender: TObject);

    procedure DimensionarColocarBDGrid();

  Private
    procedure AplicarEstiloModerno;
    procedure AplicarContrasteSeleccion(AControl: TWinControl);
    procedure AplicarContrasteSeleccionControles(AParent: TWinControl);
    procedure ActualizarFlechasOrden;
    function QuitarFlechaOrden(const ATexto: String): String;
    procedure ConfigurarBoton(ABoton: TBitBtn; const ACaption, AHint: String;
      AColor: TColor);
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormlistapuestos;
  
Var
  FLPuestos: TFLPuestos;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;

Implementation

uses
  Global, Funciones;

//=============== Crea el formulario ================
procedure ShowFormlistapuestos;
begin
  with TFLPuestos.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFLPuestos.Formcreate(Sender: Tobject);
Begin
  //Conectate(dbConect);      // Utilizamos datamodule1.dbConexión para toda la aplicación.

  Label10.Caption:=Tienda;

  //---------------------Paneles visibles por defecto, los de RadioButton1Change
  PanelDesdeHasta.Visible:=True;

  BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;

   //Dimensionamos, colocamos y cocultamos todos los DBGrid
   AntColun:='0';
   TituloColumn:='';
   Orden:='ASC';
   Ordenado:=False;
   DimensionarColocarBDGrid();
   OcultarBDGrid();
   AplicarEstiloModerno;
End;

//==================== CERRAR ======================
procedure TFLPuestos.BitBtn4Click(Sender: TObject);
begin
  dbQuery.Active:=False;
  Close();
end;



//==================== VISUALIZAR ===================
procedure TFLPuestos.BitBtn1Click(Sender: TObject);
Var
  TxtQuery: String;
begin
  AntColun:='0';Ordenado:=False;
  BitBtn2.Enabled:=True; BitBtn3.Enabled:=True;
  //-------------------------- DATOS PRINCIPALES
  if RadioButton1.Checked=True then
    begin
     TituloGrid:='DATOS PRINCIPALES';
     TxtQuery := 'select PT0, PT1, PT2, PT3, PT4, PT5, PT6 ';
     TxtQuery := TxtQuery + 'FROM puestos'+Tienda+' WHERE';
     if Edit1.Text<>'' then
       TxtQuery:=TxtQuery + ' PT0>="'+Edit1.Text+'" AND';
     if Edit2.Text<>'' then
       TxtQuery:=TxtQuery + ' PT0<="'+Edit2.Text+'" AND';
     TxtQuery:=TxtQuery + ' MID(PT1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(PT1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY PT0, PT1';
     //WriteLn(TxtQuery);
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
     LabelTituloDBGrid1.Caption:=
       Format('%d puesto(s) encontrado(s). Pulse una cabecera para ordenar.',
         [dbQuery.RecordCount]);
    end;
 //--------------------------- COMPRAS POR DEPARTAMENTOS
  //if RadioButton2.Checked=True then
    //begin
     //if dbAnos.RecordCount=0 then begin showmessage('NO HAY DATOS PARA VISUALIZAR'); exit; end;
     //TituloGrid:='LISTADO DE COMPRAS POR DEPARTAMENTOS';
     //TxtQuery:='SELECT D0, D1, SUM(DD3) As Unid, SUM(DD4) As Impor';
     //TxtQuery := TxtQuery + ' FROM departamentos'+Tienda+',estadepa'+Tienda+' WHERE';
     //if Edit1.Text<>'' then
       //TxtQuery:=TxtQuery + ' D0>='+Edit1.Text+' AND';
     //if Edit2.Text<>'' then
       //TxtQuery:=TxtQuery + ' D0<='+Edit2.Text+' AND';
     //TxtQuery:=TxtQuery + ' MID(D1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     //'" AND MID(D1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     //TxtQuery := TxtQuery + ' AND DD1='+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex]+
     //' AND DD2>='+Edit7.Text+' AND DD2<='+Edit8.Text;
     //TxtQuery := TxtQuery + ' AND D0=DD0';
     //TxtQuery := TxtQuery + ' GROUP BY D0';
     //if Ordenado=True then
       //TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     //else
       //TxtQuery:=TxtQuery + ' ORDER BY D0';
     //dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     //if PanelSelectAno.Visible then TituloGrid:=TituloGrid+' ENTRE LOS MESES '+
        //Edit7.Text+' Y '+Edit8.Text+' DE '+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex];
     //DBGrid2.BringToFront; DBGrid2.Visible:=True; DBGrid2.Caption:='Este es el titulo';
    //end;
  //-------------------------- VENTAS POR DEPARTAMENTOS

  //if RadioButton3.Checked=True then
    //begin
     //TituloGrid:='LISTADO DE VENTAS POR DEPARTAMENTOS';
     //TxtQuery:='SELECT D0, D1, SUM(DD5) As Unid, SUM(DD6) As ImporPrc, SUM(DD7) As ImporCOS, SUM(DD6-DD7) As Benef';
     //TxtQuery := TxtQuery + ' FROM departamentos'+Tienda+',estadepa'+Tienda+' WHERE';
     //if Edit1.Text<>'' then
       //TxtQuery:=TxtQuery + ' D0>='+Edit1.Text+' AND';
     //if Edit2.Text<>'' then
       //TxtQuery:=TxtQuery + ' D0<='+Edit2.Text+' AND';
     //TxtQuery:=TxtQuery + ' MID(D1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     //'" AND MID(D1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     //TxtQuery := TxtQuery + ' AND DD1='+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex]+
     //' AND DD2>='+Edit7.Text+' AND DD2<='+Edit8.Text;
     //TxtQuery := TxtQuery + ' AND D0=DD0';
     //TxtQuery := TxtQuery + ' GROUP BY D0';
     //if Ordenado=True then
       //TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     //else
       //TxtQuery:=TxtQuery + '  ORDER BY D0';
     //dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     //if PanelSelectAno.Visible then TituloGrid:=TituloGrid+' ENTRE LOS MESES '+
        //Edit7.Text+' Y '+Edit8.Text+' DE '+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex];
     //DBGrid3.BringToFront; DBGrid3.Visible:=True;
    //end;

   LabelTituloDBGrid.Caption:=TituloGrid+' DE LOS PUESTOS DE LA TIENDA '+Tienda;
   //WriteLn(TxtQuery);
end;

//==================== SELECCIONAR ===================
procedure TFLPuestos.BitBtn3Click(Sender: TObject);
begin
  BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
  Ordenado:=False;
  OcultarBDGrid();
  LabelTituloDBGrid1.Caption:=
    'Defina los límites de la consulta y pulse Consultar puestos.';
  if Edit1.CanFocus then Edit1.SetFocus;
end;

//==================== IMPRIMIR ===================
procedure TFLPuestos.BitBtn2Click(Sender: TObject);
begin
  //-------------------------- Datos Principales
  if RadioButton1.Checked=True then
    begin
      { TODO : Pendiente de confirmar los campos que hay que mostrar en el report
 }
     //frDBDataSet1.DataSet:=dbQuery;
     //frReport1.LoadFromFile(RutaReports+'ListadoDepartamentosDatos.lrf');
     //frReport1.ShowReport;
    end;
    
  //--------------------------_ LISTADO DE DEPARTAMENTOS POR COMPRAS
  //if RadioButton2.Checked=True then
    //begin

     //frDBDataSet1.DataSet:=dbQuery;
     //frReport1.LoadFromFile(RutaReports+'ListadoDepartamentosCompras.lrf');
      //frReport1.ShowReport;
    //end;

  //--------------------------_ LISTADO DE DEPARTAMENTOS POR VENTAS

  //if RadioButton3.Checked=True then
    //begin

     //frDBDataSet1.DataSet:=dbQuery;
     //frReport1.LoadFromFile(RutaReports+'ListadoDepartamentosVentas.lrf');
     //frReport1.ShowReport;
    //end;

end;
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFLPuestos.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
  if ParName ='EMPRESA' then ParValue := Empresa;
  if ParName='DIRECCION' then ParValue := Direccion;
  if ParName='LOCALIDAD' then ParValue := Localidad;
  if ParName='CP' then ParValue := CP;
  if ParName='TITULO' then ParValue := TituloGrid;
end;
//======================= LOGOTIPO DEL FORMULARIO ========================
procedure TFLPuestos.frReport1EnterRect(Memo: TStringList; View: TfrView);
var
  vImage: TImage;
begin
  if assigned( View ) and
     (View.Name = 'Picture1') and
     (View is TfrPictureView)
  then
    try
      vImage := TImage.Create( nil );
      try
         TfrPictureView(View).Picture.Clear;
         TfrPictureView(View).Picture.LoadFromFile(LogoEmpresa);
      finally
        FreeAndNil(vImage);
      end;
    except
      TfrPictureView(View).Picture.Clear;
    end;
end;


//===============================================================
//==================== OPCIONES DE LISTADOS =========================
//===============================================================

procedure TFLPuestos.RadioButton1Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   OcultarBDGrid();
end;

procedure TFLPuestos.RadioButton2Change(Sender: TObject);
begin
  //if RadioButton2.Checked=True then
    //RellenaListBoxAnos('SELECT DISTINCT(DD1) FROM estadepa'+Tienda,dbAnos, PanelSelectAno, ListBoxAnos);
  //OcultarBDGrid();
end;

procedure TFLPuestos.RadioButton3Change(Sender: TObject);
begin
  //if RadioButton3.Checked=True then
    //RellenaListBoxAnos('SELECT DISTINCT(DD1) FROM estadepa'+Tienda,dbAnos, PanelSelectAno, ListBoxAnos);
  //OcultarBDGrid();
end;

// ====================== Redimensiona y Coloca Todos los DBGrid
procedure TFLPuestos.DimensionarColocarBDGrid();
  begin
    DBGrid1.Align:=alClient;
    //DBGrid2.Align:=alClient;
    //DBGrid3.Align:=alClient;
    //DBGrid4.Align:=alClient;
    //DBGrid5.Align:=alClient;
    //DBGrid6.Align:=alClient;
    //DBGrid7.Align:=alClient;
  end;

//======================= OCULTA TODOS LOS DBGird
procedure TFLPuestos.OcultarBDGrid();
  begin
    LabelTituloDBGrid.Caption:='RESULTADO DE LA CONSULTA';
    DBGrid1.Visible:=False; //DBGrid2.Visible:=False;
    //DBGrid3.Visible:=False; //DBGrid4.Visible:=False;
  end;


//-------- Al pulsar en el titulo de la columna ordenar por ella
procedure TFLPuestos.DBGrid1TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid1,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  ActualizarFlechasOrden;
end;
//procedure TFLPuestos.DBGrid2TitleClick(Column: TColumn);
//begin
  //Colorea(Column,DBGrid2,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
//end;
//procedure TFLPuestos.DBGrid3TitleClick(Column: TColumn);
//begin
  //Colorea(Column,DBGrid3,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
//end;
{procedure TFLPuestos.DBGrid4TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid4,dbQuery);
end;}



procedure TFLPuestos.ConfigurarBoton(ABoton: TBitBtn;
  const ACaption, AHint: String; AColor: TColor);
begin
  if not Assigned(ABoton) then Exit;
  ABoton.Caption:=ACaption;
  ABoton.Hint:=AHint;
  ABoton.ShowHint:=True;
  ABoton.Color:=AColor;
  ABoton.Font.Color:=RGBToColor(24,36,48);
  ABoton.Font.Height:=-13;
  ABoton.Font.Style:=[fsBold];
  ABoton.Visible:=True;
  ABoton.BringToFront;
end;

procedure TFLPuestos.AplicarEstiloModerno;
begin
  Caption:='FacturLinEx - Listado de puestos';
  Color:=clWhite;
  WindowState:=wsMaximized;
  Position:=poDesktopCenter;
  KeyPreview:=True;

  LabelTitulo.Caption:='LISTADO DE PUESTOS';
  LabelSubtitulo.Caption:=
    'Consulta, ordenación y selección de los puestos configurados para la tienda activa.';
  LabelFiltrosTitulo.Caption:='CRITERIOS DE CONSULTA';
  LabelAyudaFiltros.Caption:=
    'Los campos vacíos no limitan la consulta. Puede indicar solo el inicio, solo el final o ambos.';
  Label5.Caption:='Tipo de listado';
  RadioButton1.Caption:='Datos principales del puesto';
  RadioButton1.Font.Color:=RGBToColor(24,36,48);
  RadioButton1.Color:=PanelFiltros.Color;

  Label2.Caption:='Primer código';
  Label1.Caption:='Último código';
  Label3.Caption:='Primer nombre';
  Label4.Caption:='Último nombre';
  Label9.Caption:='Tienda activa';

  ConfigurarBoton(BitBtn1,'Consultar puestos',
    'Ejecutar la consulta con los límites indicados',RGBToColor(207,232,246));
  ConfigurarBoton(BitBtn2,'Imprimir informe',
    'Imprimir el resultado de la consulta',RGBToColor(214,240,222));
  ConfigurarBoton(BitBtn3,'Nueva consulta',
    'Volver a los criterios para preparar otra consulta',RGBToColor(244,232,204));
  ConfigurarBoton(BitBtn4,'Cerrar',
    'Cerrar el listado de puestos',RGBToColor(232,232,232));

  DBGrid1.Color:=clWhite;
  DBGrid1.Font.Color:=RGBToColor(24,36,48);
  DBGrid1.Font.Height:=-13;
  DBGrid1.TitleFont.Color:=RGBToColor(24,36,48);
  DBGrid1.TitleFont.Style:=[fsBold];
  DBGrid1.Options:=DBGrid1.Options+[dgTitles,dgIndicator,dgColumnResize,
    dgColumnMove,dgColLines,dgRowLines,dgRowSelect,dgAlwaysShowSelection];

  if DBGrid1.Columns.Count>=7 then
  begin
    DBGrid1.Columns[0].Title.Caption:='CÓDIGO';
    DBGrid1.Columns[0].Width:=90;
    DBGrid1.Columns[1].Title.Caption:='NOMBRE / DESCRIPCIÓN';
    DBGrid1.Columns[1].Width:=340;
    DBGrid1.Columns[2].Title.Caption:='TELÉFONO';
    DBGrid1.Columns[2].Width:=150;
    DBGrid1.Columns[3].Title.Caption:='DIRECCIÓN IP';
    DBGrid1.Columns[3].Width:=170;
    DBGrid1.Columns[4].Title.Caption:='PUERTO';
    DBGrid1.Columns[4].Width:=100;
    DBGrid1.Columns[5].Title.Caption:='USUARIO';
    DBGrid1.Columns[5].Width:=170;
    DBGrid1.Columns[6].Title.Caption:='CLAVE';
    DBGrid1.Columns[6].Width:=170;
  end;

  LabelTituloDBGrid.Caption:='RESULTADO DE LA CONSULTA';
  LabelTituloDBGrid1.Caption:=
    'Defina los límites de la consulta y pulse Consultar puestos.';
end;

procedure TFLPuestos.FormShow(Sender: TObject);
begin
  AplicarContrasteSeleccionControles(Self);
  if Edit1.CanFocus then Edit1.SetFocus;
end;

procedure TFLPuestos.FormResize(Sender: TObject);
begin
  DimensionarColocarBDGrid;
end;

procedure TFLPuestos.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then
  begin
    Key:=0;
    BitBtn4Click(BitBtn4);
  end;
end;

procedure TFLPuestos.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Grid: TDBGrid;
begin
  Grid:=TDBGrid(Sender);
  if gdSelected in State then
  begin
    Grid.Canvas.Brush.Color:=RGBToColor(42,86,132);
    Grid.Canvas.Font.Color:=clWhite;
  end
  else
  begin
    Grid.Canvas.Brush.Color:=clWhite;
    Grid.Canvas.Font.Color:=RGBToColor(24,36,48);
  end;
  Grid.Canvas.FillRect(Rect);
  Grid.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TFLPuestos.AplicarContrasteSeleccion(AControl: TWinControl);
{$IFDEF LCLGTK2}
var
  FondoNormal, TextoNormal, FondoSeleccion, TextoSeleccion: TGdkColor;
  Widget: PGtkWidget;
{$ENDIF}
begin
  if not Assigned(AControl) then Exit;
  AControl.HandleNeeded;

  {$IFDEF LCLGTK2}
  Widget:=PGtkWidget(AControl.Handle);
  if Assigned(Widget) then
  begin
    gdk_color_parse(PChar('#FFFFFF'),@FondoNormal);
    gdk_color_parse(PChar('#182430'),@TextoNormal);
    gtk_widget_modify_base(Widget,GTK_STATE_NORMAL,@FondoNormal);
    gtk_widget_modify_text(Widget,GTK_STATE_NORMAL,@TextoNormal);

    gdk_color_parse(PChar('#2A5684'),@FondoSeleccion);
    gdk_color_parse(PChar('#FFFFFF'),@TextoSeleccion);
    gtk_widget_modify_base(Widget,GTK_STATE_SELECTED,@FondoSeleccion);
    gtk_widget_modify_text(Widget,GTK_STATE_SELECTED,@TextoSeleccion);
  end;
  {$ENDIF}
end;

procedure TFLPuestos.AplicarContrasteSeleccionControles(AParent: TWinControl);
var
  I: Integer;
  C: TControl;
begin
  if not Assigned(AParent) then Exit;
  for I:=0 to AParent.ControlCount-1 do
  begin
    C:=AParent.Controls[I];
    if C is TCustomEdit then
      AplicarContrasteSeleccion(TWinControl(C));
    if C is TWinControl then
      AplicarContrasteSeleccionControles(TWinControl(C));
  end;
end;

function TFLPuestos.QuitarFlechaOrden(const ATexto: String): String;
var
  P: SizeInt;
begin
  Result:=ATexto;
  P:=Pos(' ▲',Result);
  if P>0 then Delete(Result,P,Length(Result)-P+1);
  P:=Pos(' ▼',Result);
  if P>0 then Delete(Result,P,Length(Result)-P+1);
end;

procedure TFLPuestos.ActualizarFlechasOrden;
var
  I: Integer;
  Base: String;
begin
  for I:=0 to DBGrid1.Columns.Count-1 do
  begin
    Base:=QuitarFlechaOrden(DBGrid1.Columns[I].Title.Caption);
    DBGrid1.Columns[I].Title.Caption:=Base;
    if SameText(DBGrid1.Columns[I].FieldName,TituloColumn) then
    begin
      if SameText(Orden,'DESC') then
        DBGrid1.Columns[I].Title.Caption:=Base+' ▼'
      else
        DBGrid1.Columns[I].Title.Caption:=Base+' ▲';
    end;
  end;
end;

Procedure TFLPuestos.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

Initialization
  {$I listapuestos.lrs}

End.

