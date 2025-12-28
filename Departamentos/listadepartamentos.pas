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

Unit listadepartamentos;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset, DBGrids,
  StdCtrls, db, LR_DBSet, LR_Class;

Type

  { TFLDepartamentos }

  TFLDepartamentos = Class(Tform)
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
    dbAnos: TZQuery;
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
    //ListBoxAnos2: TListBox;
    //ListBoxAnos3: TListBox;
    //ListBoxAnos4: TListBox;
    //ListBoxAnos5: TListBox;
    //ListBoxAnos6: TListBox;
    //ListBoxAnos7: TListBox;
    //ListBoxAnos8: TListBox;
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

  procedure ShowFormlistadepartamentos;
  
Var
  FLDepartamentos: TFLDepartamentos;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;

Implementation

uses
  Global, Funciones;

//=============== Crea el formulario ================
procedure ShowFormlistadepartamentos;
begin
  with TFLDepartamentos.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFLDepartamentos.Formcreate(Sender: Tobject);
Begin
//Conectate(dbConect);          // Utilizamos datamodule1.dbConexión para toda la aplicación.

  //---------------------Paneles visibles por defecto, los de RadioButton1Change
  PanelSelectAno.Visible:=False;
  PanelDesdeHasta.Visible:=True;

  BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;

   //Dimensionamos, colocamos y cocultamos todos los DBGrid
   DimensionarColocarBDGrid();
   OcultarBDGrid();
End;

//==================== CERRAR ======================
procedure TFLDepartamentos.BitBtn4Click(Sender: TObject);
begin
  dbQuery.Active:=False;
  Close();
end;



//==================== VISUALIZAR ===================
procedure TFLDepartamentos.BitBtn1Click(Sender: TObject);
Var
  TxtQuery: String;
begin
  AntColun:='0';Ordenado:=False;
  BitBtn2.Enabled:=True; BitBtn3.Enabled:=True;
  //-------------------------- DATOS PRINCIPALES
  if RadioButton1.Checked=True then
    begin
     TituloGrid:='LISTADO DE DEPARTAMENTOS - DATOS PRINCIPALES';
     TxtQuery := 'select D0, D1, MID(D4,1,30) as OBSER ';
     TxtQuery := TxtQuery + 'FROM departamentos'+Tienda+' WHERE';
     if Edit1.Text<>'' then
       TxtQuery:=TxtQuery + ' D0>='+Edit1.Text+' AND';
     if Edit2.Text<>'' then
       TxtQuery:=TxtQuery + ' D0<='+Edit2.Text+' AND';
     TxtQuery:=TxtQuery + ' MID(D1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(D1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY D0, D1';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
    end;
 //--------------------------- COMPRAS POR DEPARTAMENTOS
  if RadioButton2.Checked=True then
    begin
     if dbAnos.RecordCount=0 then begin showmessage('NO HAY DATOS PARA VISUALIZAR'); exit; end;
     TituloGrid:='LISTADO DE COMPRAS POR DEPARTAMENTOS';
     TxtQuery:='SELECT D0, D1, SUM(DD3) As Unid, SUM(DD4) As Impor';
     TxtQuery := TxtQuery + ' FROM departamentos'+Tienda+',estadepa'+Tienda+' WHERE';
     if Edit1.Text<>'' then
       TxtQuery:=TxtQuery + ' D0>='+Edit1.Text+' AND';
     if Edit2.Text<>'' then
       TxtQuery:=TxtQuery + ' D0<='+Edit2.Text+' AND';
     TxtQuery:=TxtQuery + ' MID(D1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(D1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     TxtQuery := TxtQuery + ' AND DD1='+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex]+
     ' AND DD2>='+Edit7.Text+' AND DD2<='+Edit8.Text;
     TxtQuery := TxtQuery + ' AND D0=DD0';
     TxtQuery := TxtQuery + ' GROUP BY D0';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY D0';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if PanelSelectAno.Visible then TituloGrid:=TituloGrid+' ENTRE LOS MESES '+
        Edit7.Text+' Y '+Edit8.Text+' DE '+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex];
     DBGrid2.BringToFront; DBGrid2.Visible:=True;
    end;
  //-------------------------- VENTAS POR DEPARTAMENTOS

  if RadioButton3.Checked=True then
    begin
     TituloGrid:='LISTADO DE VENTAS POR DEPARTAMENTOS';
     TxtQuery:='SELECT D0, D1, SUM(DD5) As Unid, SUM(DD6) As ImporPrc, SUM(DD7) As ImporCOS, SUM(DD6-DD7) As Benef';
     TxtQuery := TxtQuery + ' FROM departamentos'+Tienda+',estadepa'+Tienda+' WHERE';
     if Edit1.Text<>'' then
       TxtQuery:=TxtQuery + ' D0>='+Edit1.Text+' AND';
     if Edit2.Text<>'' then
       TxtQuery:=TxtQuery + ' D0<='+Edit2.Text+' AND';
     TxtQuery:=TxtQuery + ' MID(D1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(D1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     TxtQuery := TxtQuery + ' AND DD1='+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex]+
     ' AND DD2>='+Edit7.Text+' AND DD2<='+Edit8.Text;
     TxtQuery := TxtQuery + ' AND D0=DD0';
     TxtQuery := TxtQuery + ' GROUP BY D0';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + '  ORDER BY D0';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if PanelSelectAno.Visible then TituloGrid:=TituloGrid+' ENTRE LOS MESES '+
        Edit7.Text+' Y '+Edit8.Text+' DE '+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex];
     DBGrid3.BringToFront; DBGrid3.Visible:=True;
    end;

   LabelTituloDBGrid.Caption:=TituloGrid;
   //WriteLn(TxtQuery);
end;

//==================== SELECCIONAR ===================
procedure TFLDepartamentos.BitBtn3Click(Sender: TObject);
begin
  BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
  Ordenado:=False;
  OcultarBDGrid();
end;

//==================== IMPRIMIR ===================
procedure TFLDepartamentos.BitBtn2Click(Sender: TObject);
begin
  //-------------------------- Datos Principales
  if RadioButton1.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoDepartamentosDatos.lrf');
     frReport1.ShowReport;
    end;
    
  //--------------------------_ LISTADO DE DEPARTAMENTOS POR COMPRAS
  if RadioButton2.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoDepartamentosCompras.lrf');
     frReport1.ShowReport;
    end;

  //--------------------------_ LISTADO DE DEPARTAMENTOS POR VENTAS

  if RadioButton3.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoDepartamentosVentas.lrf');
     frReport1.ShowReport;
    end;

end;
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFLDepartamentos.frReport1GetValue(const ParName: String;
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
procedure TFLDepartamentos.frReport1EnterRect(Memo: TStringList; View: TfrView);
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

procedure TFLDepartamentos.RadioButton1Change(Sender: TObject);
begin
   PanelSelectAno.Visible:=False;
   PanelDesdeHasta.Visible:=True;
   OcultarBDGrid();
end;

procedure TFLDepartamentos.RadioButton2Change(Sender: TObject);
begin
  if RadioButton2.Checked=True then
    RellenaListBoxAnos('SELECT DISTINCT(DD1) FROM estadepa'+Tienda,dbAnos, PanelSelectAno, ListBoxAnos);
  OcultarBDGrid();
end;

procedure TFLDepartamentos.RadioButton3Change(Sender: TObject);
begin
  if RadioButton3.Checked=True then
    RellenaListBoxAnos('SELECT DISTINCT(DD1) FROM estadepa'+Tienda,dbAnos, PanelSelectAno, ListBoxAnos);
  OcultarBDGrid();
end;

// ====================== Redimensiona y Coloca Todos los DBGrid
procedure TFLDepartamentos.DimensionarColocarBDGrid();
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
procedure TFLDepartamentos.OcultarBDGrid();
  begin
    LabelTituloDBGrid.Caption:='';
    DBGrid1.Visible:=False; DBGrid2.Visible:=False;
    DBGrid3.Visible:=False; //DBGrid4.Visible:=False;
  end;


//-------- Al pulsar en el titulo de la columna ordenar por ella
procedure TFLDepartamentos.DBGrid1TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid1,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLDepartamentos.DBGrid2TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid2,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLDepartamentos.DBGrid3TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid3,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
{procedure TFLDepartamentos.DBGrid4TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid4,dbQuery);
end;}


Procedure TFLDepartamentos.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

Initialization
  {$I listadepartamentos.lrs}

End.

