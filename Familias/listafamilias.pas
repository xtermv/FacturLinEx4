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

Unit listafamilias;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset, DBGrids,
  StdCtrls, db, LR_DBSet, LR_Class;

Type

  { TFLFamilias }

  TFLFamilias = Class(Tform)
    dbAnos: TZQuery;
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
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    Edit7: TEdit;
    Edit8: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    Label1: TLabel;
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
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    LabelTituloDBGrid: TLabel;
    LabelTituloDBGrid1: TLabel;
    ListBoxAnos: TListBox;
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
    PanelSelectAno: TPanel;
    PanelTituloGrid: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure DBGrid3TitleClick(Column: TColumn);
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
    //procedure BlancoGrid(Grid: TDBGrid);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure RadioButton3Change(Sender: TObject);

    procedure DimensionarColocarBDGrid();

  Private
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormlistafamilias;
  
Var
  FLFamilias: TFLFamilias;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;

Implementation

uses
  Global, Funciones;

//=============== Crea el formulario ================
procedure ShowFormlistafamilias;
begin
  with TFLFamilias.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFLFamilias.Formcreate(Sender: Tobject);
Begin
//Conectate(dbConect);      // Utilizamos datamodule1.dbConexión para toda la aplicación.

  //---------------------Paneles visibles por defecto, los de RadioButton1Change
  PanelSelectAno.Visible:=False;
  PanelDesdeHasta.Visible:=True;

  BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;

   //Dimensionamos, colocamos y cocultamos todos los DBGrid
   DimensionarColocarBDGrid();
   OcultarBDGrid();
End;

//==================== CERRAR ======================
procedure TFLFamilias.BitBtn4Click(Sender: TObject);
begin
  dbQuery.Active:=False;
  Close();
end;



//==================== VISUALIZAR ===================
procedure TFLFamilias.BitBtn1Click(Sender: TObject);
Var
  TxtQuery: String;
begin
  AntColun:='0';Ordenado:=False;
  BitBtn2.Enabled:=True; BitBtn3.Enabled:=True;
  //-------------------------- DATOS PRINCIPALES
  if RadioButton1.Checked=True then
    begin
     TituloGrid:='LISTADO DE FAMILIAS - DATOS PRINCIPALES';
     TxtQuery := 'select distinct F0, F1, MID(F5,1,30) as OBSER, D1 ';
     TxtQuery := TxtQuery + 'FROM familias'+Tienda+' LEFT OUTER JOIN departamentos'+Tienda+' ON F2=D0 WHERE';
     if Edit1.Text<>'' then
       TxtQuery:=TxtQuery + ' F0>='+Edit1.Text+' AND';
     if Edit2.Text<>'' then
       TxtQuery:=TxtQuery + ' F0<='+Edit2.Text+' AND';
     TxtQuery:=TxtQuery + ' MID(F1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(F1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY F0, F1';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
    end;
 //--------------------------- COMPRAS POR FAMILIAS
  if RadioButton2.Checked=True then
    begin
     TituloGrid:='LISTADO DE COMPRAS POR FAMILIAS';
     TxtQuery:='SELECT F0, F1, SUM(FF3) As Unid, SUM(FF4) As Impor';
     TxtQuery := TxtQuery + ' FROM familias'+Tienda+',estafami'+Tienda+' WHERE';
     if Edit1.Text<>'' then
       TxtQuery:=TxtQuery + ' F0>='+Edit1.Text+' AND';
     if Edit2.Text<>'' then
       TxtQuery:=TxtQuery + ' F0<='+Edit2.Text+' AND';
     TxtQuery:=TxtQuery + ' MID(F1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(F1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     TxtQuery := TxtQuery + ' AND FF1='+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex]+
     ' AND FF2>='+Edit7.Text+' AND FF2<='+Edit8.Text;
     TxtQuery := TxtQuery + ' AND F0=FF0';
     TxtQuery := TxtQuery + ' GROUP BY F0';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY F0';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if PanelSelectAno.Visible then TituloGrid:=TituloGrid+' ENTRE LOS MESES '+
        Edit7.Text+' Y '+Edit8.Text+' DE '+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex];
     DBGrid2.BringToFront; DBGrid2.Visible:=True;
    end;
  //-------------------------- VENTAS POR FAMILIAS

  if RadioButton3.Checked=True then
    begin
     TituloGrid:='LISTADO DE VENTAS POR FAMILIAS';
     TxtQuery:='SELECT F0, F1, SUM(FF5) As Unid, SUM(FF6) As ImporPrc, SUM(FF7) As ImporCOS, SUM(FF6-FF7) As Benef';
     TxtQuery := TxtQuery + ' FROM familias'+Tienda+',estafami'+Tienda+' WHERE';
     if Edit1.Text<>'' then
       TxtQuery:=TxtQuery + ' F0>='+Edit1.Text+' AND';
     if Edit2.Text<>'' then
       TxtQuery:=TxtQuery + ' F0<='+Edit2.Text+' AND';
     TxtQuery:=TxtQuery + ' MID(F1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(F1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     TxtQuery := TxtQuery + ' AND FF1='+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex]+
     ' AND FF2>='+Edit7.Text+' AND FF2<='+Edit8.Text;
     TxtQuery := TxtQuery + ' AND F0=FF0';
     TxtQuery := TxtQuery + ' GROUP BY F0';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + '  ORDER BY F0';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if PanelSelectAno.Visible then TituloGrid:=TituloGrid+' ENTRE LOS MESES '+
        Edit7.Text+' Y '+Edit8.Text+' DE '+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex];
     DBGrid3.BringToFront; DBGrid3.Visible:=True;
    end;
   LabelTituloDBGrid.Caption:=TituloGrid;

end;

//==================== SELECCIONAR ===================
procedure TFLFamilias.BitBtn3Click(Sender: TObject);
begin
  BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
  Ordenado:=False;
  OcultarBDGrid();
end;

//==================== IMPRIMIR ===================
procedure TFLFamilias.BitBtn2Click(Sender: TObject);
begin
  //-------------------------- Datos Principales
  if RadioButton1.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoFamiliasDatos.lrf');
     frReport1.ShowReport;
    end;
    
  //--------------------------_ LISTADO DE FAMILIAS POR COMPRAS
  if RadioButton2.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoFamiliasCompras.lrf');
     frReport1.ShowReport;
    end;

  //--------------------------_ LISTADO DE FAMILIAS POR VENTAS

  if RadioButton3.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoFamiliasVentas.lrf');
     frReport1.ShowReport;
    end;

end;
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFLFamilias.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
  if ParName ='EMPRESA' then ParValue := Empresa;
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
//======================= LOGOTIPO DEL FORMULARIO ========================
procedure TFLFamilias.frReport1EnterRect(Memo: TStringList; View: TfrView);
var
  vImage: TImage;
begin
  frReport1.Title:=TituloGrid;
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

procedure TFLFamilias.RadioButton1Change(Sender: TObject);
begin
   PanelSelectAno.Visible:=False;
   PanelDesdeHasta.Visible:=True;
   OcultarBDGrid();
end;

procedure TFLFamilias.RadioButton2Change(Sender: TObject);
begin
  if RadioButton2.Checked=True then
   RellenaListBoxAnos('SELECT DISTINCT(FF1) FROM estafami'+Tienda,dbAnos, PanelSelectAno, ListBoxAnos);
  OcultarBDGrid();
end;

procedure TFLFamilias.RadioButton3Change(Sender: TObject);
begin
  if RadioButton3.Checked=True then
   RellenaListBoxAnos('SELECT DISTINCT(FF1) FROM estafami'+Tienda,dbAnos, PanelSelectAno, ListBoxAnos);
  OcultarBDGrid();
end;

// ====================== Redimensiona y Coloca Todos los DBGrid
procedure TFLFamilias.DimensionarColocarBDGrid();
  begin
    DBGrid1.Align:=alClient;
    DBGrid2.Align:=alClient;
    DBGrid3.Align:=alClient;
    //DBGrid4.Align:=alClient;
    //DBGrid5.Align:=alClient;
    //DBGrid6.Align:=alClient;
    //DBGrid7.Align:=alClient;
  end;

//======================= OCULTA TODOS LOS DBGird
procedure TFLFamilias.OcultarBDGrid();
  begin
    LabelTituloDBGrid.Caption:='';
    DBGrid1.Visible:=False; DBGrid2.Visible:=False;
    DBGrid3.Visible:=False; //DBGrid4.Visible:=False;
  end;


//-------- Al pulsar en el titulo de la columna ordenar por ella
procedure TFLFamilias.DBGrid1TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid1,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLFamilias.DBGrid2TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid2,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLFamilias.DBGrid3TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid3,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
{procedure TFLFamilias.DBGrid4TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid4,dbQuery);
end;}


Procedure TFLFamilias.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

Initialization
  {$I listafamilias.lrs}

End.

