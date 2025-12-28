{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2008,

  Antonio Dominguez
  Xaime Alvarez

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

Unit listausuarios;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset, DBGrids,
  StdCtrls, db, LR_DBSet, LR_Class;

Type

  { TFLUsuario }

  TFLUsuario = Class(Tform)
    Bevel1: TBevel;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    dbAnos: TZQuery;
    Edit1: TEdit;

    Edit10: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;


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
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LabelTituloDBGrid: TLabel;
    LabelTituloDBGrid1: TLabel;
    ListBoxAnos: TListBox;
    ListBoxAnos1: TListBox;
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

  procedure ShowFormlistausuarios;
  
Var
  FLUsuario: TFLUsuario;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;

Implementation

uses
  Global, Funciones;

//=============== Crea el formulario ================
procedure ShowFormlistausuarios;
begin
  with TFLUsuario.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFLUsuario.Formcreate(Sender: Tobject);

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
procedure TFLUsuario.BitBtn4Click(Sender: TObject);
begin
  dbQuery.Active:=False;
  Close();
end;

Procedure TFLUsuario.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//==================== VISUALIZAR ===================
procedure TFLUsuario.BitBtn1Click(Sender: TObject);
Var
  TxtQuery: String;
begin
  AntColun:='0';Ordenado:=False;
  BitBtn2.Enabled:=True; BitBtn3.Enabled:=True;
  //-------------------------- DATOS PERSONALES (DIRECCIONES)
  if RadioButton1.Checked=True then
    begin
     TituloGrid:='LISTADO DE DATOS PERSONALES (DIRECCIONES)';
     TxtQuery:='SELECT * from usuarios'+Tienda+' WHERE';
     if Edit1.Text<>'' then
       TxtQuery:=TxtQuery + ' USU0>='+Edit1.Text+' AND';
     if Edit2.Text<>'' then
       TxtQuery:=TxtQuery +' USU0<='+Edit2.Text+' AND';
     TxtQuery:=TxtQuery + ' MID(USU1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+'" AND MID(USU1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY USU0';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
    end;
  //-------------------------- ESTADISTICAS DE VENTAS
  if RadioButton2.Checked=True then
    begin
     if dbAnos.RecordCount=0 then begin showmessage('NO HAY DATOS PARA VISUALIZAR'); exit; end;
     TituloGrid:='LISTADO DE ESTADISTICA DE VENTAS';
     TxtQuery:='SELECT USU0,USU1,SUM(TUSU5) AS UNDVEND,SUM(TUSU6) AS IMPVENDPRECIO,SUM(TUSU7) AS IMPVENDCOSTO,SUM(TUSU6-TUSU7) AS BENEF '+
     'from usuarios'+Tienda+',estausu'+Tienda+' WHERE';
     if Edit1.Text<>'' then
       TxtQuery:=TxtQuery + ' USU0>='+Edit1.Text+' AND';
     if Edit2.Text<>'' then
       TxtQuery:=TxtQuery + '  USU0<='+Edit2.Text+' AND';
     TxtQuery:=TxtQuery + ' MID(USU1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
     '" AND MID(USU1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"'+
     ' AND TUSU1='+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex]+' AND TUSU2>='+
     Edit7.Text+' AND TUSU2<='+Edit8.Text+' AND USU0=TUSU0 GROUP BY USU0';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY USU0';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     DBGrid2.BringToFront; DBGrid2.Visible:=True;
    end;
   LabelTituloDBGrid.Caption:=TituloGrid;
   //WriteLn(TxtQuery);
end;

//==================== SELECCIONAR ===================
procedure TFLUsuario.BitBtn3Click(Sender: TObject);
begin
  BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
  Ordenado:=False;
  OcultarBDGrid();
end;

//==================== IMPRIMIR ===================
procedure TFLUsuario.BitBtn2Click(Sender: TObject);
begin
  //-------------------------- Datos Personales (Direcciones)
  if RadioButton1.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoUsuariosDatos.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- Estadisticas de ventas
  if RadioButton2.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoUsuariosEsta.lrf');
     frReport1.ShowReport;
    end;

end;
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFLUsuario.frReport1GetValue(const ParName: String;
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
procedure TFLUsuario.frReport1EnterRect(Memo: TStringList; View: TfrView);
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
//==================== OPCIONES DE LISTADOS =====================
//===============================================================

procedure TFLUsuario.RadioButton1Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   OcultarBDGrid();
end;
//---------- Estadisticas de usuario
procedure TFLUsuario.RadioButton2Change(Sender: TObject);
begin
  PanelDesdeHasta.Visible:=True;
  if RadioButton2.Checked=True then
    begin
      RellenaListBoxAnos('SELECT DISTINCT(TUSU1) FROM estausu'+Tienda,dbAnos, PanelSelectAno, ListBoxAnos);
    end
  else
    PanelSelectAno.Visible:=False;
    OcultarBDGrid();
end;

// ====================== Redimensiona y Coloca Todos los DBGrid
procedure TFLUsuario.DimensionarColocarBDGrid();
  begin
    DBGrid1.Align:=alClient;
    DBGrid2.Align:=alClient;
    //DBGrid3.Align:=alClient;
    //DBGrid4.Align:=alClient;
    //DBGrid5.Align:=alClient;
    //DBGrid6.Align:=alClient;
    //DBGrid7.Align:=alClient;
  end;
//======================= OCULTA TODOS LOS DBGird
procedure TFLUsuario.OcultarBDGrid();
  begin
    LabelTituloDBGrid.Caption:='';
    DBGrid1.Visible:=False; DBGrid2.Visible:=False;
  end;

//-------- Al pulsar en el titulo de la columna ordenar por ella
procedure TFLUsuario.DBGrid1TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid1,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLUsuario.DBGrid2TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid1,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
Initialization
  {$I listausuarios.lrs}

End.

