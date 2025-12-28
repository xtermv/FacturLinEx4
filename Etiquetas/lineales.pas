{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2009,

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

Unit lineales;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset, DBGrids,
  StdCtrls, db, LR_DBSet, LR_Class;

Type

  { TFLEtilineales }

  TFLEtilineales = Class(Tform)
    Bevel1: TBevel;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit9: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    LabelTituloDBGrid: TLabel;
    LabelTituloDBGrid1: TLabel;
    ListBoxAnos1: TListBox;
    Panel1: Tpanel;
    Bitbtn1: Tbitbtn;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    BitBtn4: TBitBtn;
    Datasource1: TDatasource;
    dbCambios: TZQuery;
    PanelDesdeHasta: TPanel;
    PanelTituloGrid: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;

    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure DBGrid2TitleClick(Column: TColumn);
    Procedure Formcreate(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);
    //procedure Colorea(Column: TColumn;Grid: TDBGrid;dbColor: TZQuery);
    //procedure RellenaListBoxAnos(TxtQuery: String);
    procedure OcultarBDGrid();
    procedure DBGrid1TitleClick(Column: TColumn);
    //procedure BlancoGrid(Grid: TDBGrid);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    
    procedure DimensionarColocarBDGrid();

  Private
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormEtilineales;
  
Var
  FLEtilineales: TFLEtilineales;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;

Implementation

uses
  Global, Funciones;

//=============== Crea el formulario ================
procedure ShowFormEtilineales;
begin
  with TFLEtilineales.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFLEtilineales.Formcreate(Sender: Tobject);

Begin
  //Conectate(dbConect);    // Utilizamos datamodule1.dbConexión para toda la aplicación.


  //---------------------Paneles visibles por defecto, los de RadioButton1Change

   //Dimensionamos, colocamos y cocultamos todos los DBGrid
   PanelDesdeHasta.Visible:=True;

   BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;

   DimensionarColocarBDGrid();
   OcultarBDGrid();

End;

//==================== CERRAR ======================
procedure TFLEtilineales.BitBtn4Click(Sender: TObject);
begin
  dbCambios.Active:=False;
  Close();
end;

Procedure TFLEtilineales.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//==================== VISUALIZAR ===================
procedure TFLEtilineales.BitBtn1Click(Sender: TObject);
Var
  TxtQuery: String;
begin
  AntColun:='0';Ordenado:=False;
  BitBtn2.Enabled:=True; BitBtn3.Enabled:=True;
  TituloGrid:='ETIQUETAS LINEALES';
  TxtQuery:='SELECT * from cambios WHERE';
  if Edit1.Text<>'' then
    TxtQuery:=TxtQuery + ' CA0>="'+Edit1.Text+'" AND';
  if Edit2.Text<>'' then
    TxtQuery:=TxtQuery +' CA0<="'+Edit2.Text+'" AND';
  TxtQuery:=TxtQuery + ' MID(CA1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+'" AND MID(CA1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
  if Ordenado=True then
    TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
  else
    TxtQuery:=TxtQuery + ' ORDER BY CA0';
  dbCambios.Active:=False; dbCambios.Sql.Text:=TxtQuery; dbCambios.Active:=True;
  DBGrid1.BringToFront; DBGrid1.Visible:=True;
  LabelTituloDBGrid.Caption:=TituloGrid;
end;

//==================== SELECCIONAR ===================
procedure TFLEtilineales.BitBtn3Click(Sender: TObject);
begin
  BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
  Ordenado:=False;
  OcultarBDGrid();
end;

//==================== IMPRIMIR ===================
procedure TFLEtilineales.BitBtn2Click(Sender: TObject);
begin
  //-------------------------- Datos Personales (Direcciones)
  if RadioButton1.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbCambios;
     frReport1.LoadFromFile(RutaReports+'EtiLineales1.lrf');
     frReport1.ShowReport;
    end;

end;
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFLEtilineales.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
  if ParName ='EMPRESA' then ParValue := Empresa;
  if ParName='DIRECCION' then ParValue := Direccion;
  if ParName='LOCALIDAD' then ParValue := Localidad;
  if ParName='CP' then ParValue := CP;
  if ParName='TITULO' then ParValue := TituloGrid;
end;
//======================= LOGOTIPO DEL FORMULARIO ========================
procedure TFLEtilineales.frReport1EnterRect(Memo: TStringList; View: TfrView);
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
//==================== OPCIONES DE LISTADOS =====================
//===============================================================

procedure TFLEtilineales.RadioButton1Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   OcultarBDGrid();
end;
//---------- Estadisticas de usuario
procedure TFLEtilineales.RadioButton2Change(Sender: TObject);
begin
    OcultarBDGrid();
end;

// ====================== Redimensiona y Coloca Todos los DBGrid
procedure TFLEtilineales.DimensionarColocarBDGrid();
  begin
    DBGrid1.Align:=alClient;
  end;
//======================= OCULTA TODOS LOS DBGird
procedure TFLEtilineales.OcultarBDGrid();
  begin
    LabelTituloDBGrid.Caption:='';
    DBGrid1.Visible:=False;
  end;

//-------- Al pulsar en el titulo de la columna ordenar por ella
procedure TFLEtilineales.DBGrid1TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid1,dbCambios, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLEtilineales.DBGrid2TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid1,dbCambios, AntColun, Orden, TituloColumn, Ordenado);
end;
Initialization
  {$I lineales.lrs}

End.

