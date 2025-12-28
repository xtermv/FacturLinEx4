{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2010,

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

Unit ivaReci;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset, DBGrids,
  StdCtrls, db, LR_DBSet, LR_Class, ExtDlgs, EditBtn;

Type

  { TFLIvaReci }

  TFLIvaReci = Class(Tform)
    DateEditDesde: TDateEdit;
    DateEditHasta: TDateEdit;
    DBGrid1: TDBGrid;
    dbBusca: TZQuery;
    dbTrabajo: TZQuery;
    //Edit5: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
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
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
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
    LabelTituloDBGrid: TLabel;
    Panel1: Tpanel;
    Bitbtn1: Tbitbtn;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    BitBtn4: TBitBtn;
    Datasource1: TDatasource;
    dbQuery: TZQuery;
    Panel2: TPanel;
    PanelFechaDesdeHasta: TPanel;
    PanelTituloGrid: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    StaticText1: TStaticText;
    StaticText10: TStaticText;
    StaticText11: TStaticText;
    StaticText12: TStaticText;
    StaticText13: TStaticText;
    StaticText14: TStaticText;
    StaticText15: TStaticText;
    StaticText16: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure DateEditDesdeExit(Sender: TObject);
    procedure DateEditHastaExit(Sender: TObject);


    Procedure Formcreate(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    //procedure Colorea(Column: TColumn;Grid: TDBGrid;dbColor: TZQuery);
    //procedure RellenaListBoxAnos(TxtQuery: String);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);
    //procedure BlancoGrid(Grid: TDBGrid);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);

    procedure OcultarBDGrid();
    procedure PanelFechaDesdeHastaClick(Sender: TObject);

  Private
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormlistaivaReci;
  
Var
  FLIvaReci: TFLIvaReci;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;
  BASE1,BASE2,BASE3,BASE4,IMPOIVA1,IMPOIVA2,IMPOIVA3,IMPOIVA4: Double;
  TOTAL1,TOTAL2,TOTAL3,TOTAL4: Double;
  IRIVA1,IRIVA2,IRIVA3,IRIVA4,RECARGO: Double;
  PIVA1,PIVA2,PIVA3,PIVA4,PRIVA1,PRIVA2,PRIVA3,PRIVA4:Double;

Implementation

uses
  Global, Funciones;

//=============== Crea el formulario ================
procedure ShowFormlistaivaReci;
begin
  with TFLIvaReci.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFLIvaReci.Formcreate(Sender: Tobject);

Begin
   //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.
   //---------------------Paneles visibles por defecto, los de RadioButton1Change
   PanelFechaDesdeHasta.Visible:=True;

   BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
   DateEditDesde.Date:=StrToDate('01/01/'+FormatDateTime('YYYY',Date));
   DateEditHasta.Date:=Date;

   //ocultamos todos los DBGrid
   OcultarBDGrid();
End;

//==================== CERRAR ======================
procedure TFLIvaReci.BitBtn4Click(Sender: TObject);
begin
  dbQuery.Active:=False;
  Close();
end;

procedure TFLIvaReci.DateEditDesdeExit(Sender: TObject);
begin
   if not EsFechaValida(DateEditDesde.text) Then
     begin
       DateEditDesde.text:='';
       ShowMessage('Formato de Fecha Invalido, debe ser dd/mm/aaaa');
     end
end;

procedure TFLIvaReci.DateEditHastaExit(Sender: TObject);
begin
   if not EsFechaValida(DateEditHasta.text) Then
     begin
       DateEditHasta.text:='';
       ShowMessage('Formato de Fecha Invalido, debe ser dd/mm/aaaa');
     end
end;

Procedure TFLIvaReci.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//==================== VISUALIZAR ===================
procedure TFLIvaReci.BitBtn1Click(Sender: TObject);
Var
  TxtQuery, TxtQ: String;
  Stabla: String; //-- Nombre de la tabla en función de la selección
begin
  AntColun:='0';Ordenado:=False;
  BitBtn2.Enabled:=True; BitBtn3.Enabled:=True;
//---- Consulta para el listado
  TituloGrid:='LISTADO DE IVA RECIBIDO, agrupado por Tipos';
  IMPOIVA1:=0; BASE1:=0; TOTAL1:=0; IRIVA1:=0; PIVA1:=0; PRIVA1:=0;
  IMPOIVA2:=0; BASE2:=0; TOTAL2:=0; IRIVA2:=0; PIVA2:=0; PRIVA2:=0;
  IMPOIVA3:=0; BASE3:=0; TOTAL3:=0; IRIVA3:=0; PIVA3:=0; PRIVA3:=0;
  IMPOIVA4:=0; BASE4:=0; TOTAL4:=0; IRIVA4:=0; PIVA4:=0; PRIVA4:=0;
  //-- Selección de TABLA
  if RadioButton1.Checked=True then Stabla:='hipedicc';
  if RadioButton2.Checked=True then Stabla:='hipedifacc';
  if RadioButton3.Checked=True then Stabla:='hipedicc';
  if RadioButton4.Checked=True then Stabla:='hipedicc';
  if RadioButton5.Checked=True then Stabla:='hipedicc';


  TxtQ:='SELECT SUM(HPC31),SUM(HPC32),SUM(HPC33),SUM(HPC34),SUM(HPC35),SUM(HPC36),'+
        'SUM(HPC37),SUM(HPC38) FROM '+Stabla+Tienda+' WHERE '+
        'HPC1 >="'+FormatDateTime('YY/MM/DD',DateEditDesde.Date)+'" AND HPC1 <="'+FormatDateTime('YY/MM/DD',DateEditHasta.Date)+'"';
  if RadioButton2.Checked=True then TxtQ:=TxtQ+' AND HPC28="F"';//---------------- Facturas
  if RadioButton3.Checked=True then TxtQ:=TxtQ+' AND HPC28="A"';//---------------- Albaranes
  if RadioButton4.Checked=True then TxtQ:=TxtQ+' AND HPC28="P"';//---------------- Pedidos
  if RadioButton5.Checked=True then TxtQ:=TxtQ+' AND HPC28="N"';//---------------- Notas de entregas
  dbTrabajo.Active:=False; dbTrabajo.Sql.Text:=TxtQ; dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then begin showmessage('CON ESTA SELECCION NO HAY DATOS'); exit; end;
  dbTrabajo.First;

  StaticText1.Caption:='IVA '+FloatToStr(IVA1)+'%';
  StaticText2.Caption:='IVA '+FloatToStr(IVA2)+'%';
  StaticText3.Caption:='IVA '+FloatToStr(IVA3)+'%';
  StaticText4.Caption:='IVA 0%';
  dbGrid1.Columns[5].Title.Caption:='BASE I. '+FloatToStr(IVA1)+'%';
  dbGrid1.Columns[6].Title.Caption:='IMP. IVA '+FloatToStr(IVA1)+'%';
  dbGrid1.Columns[7].Title.Caption:='BASE I. '+FloatToStr(IVA2)+'%';
  dbGrid1.Columns[8].Title.Caption:='IMP. IVA '+FloatToStr(IVA2)+'%';
  dbGrid1.Columns[9].Title.Caption:='BASE I. '+FloatToStr(IVA3)+'%';
  dbGrid1.Columns[10].Title.Caption:='IMP. IVA '+FloatToStr(IVA3)+'%';
  dbGrid1.Columns[11].Title.Caption:='BASE I. 0%';
  dbGrid1.Columns[12].Title.Caption:='IMP. IVA 0%';

  StaticText5.Caption:=FormatFloat('0.00',dbTrabajo.Fields[0].AsFloat);
  StaticText6.Caption:=FormatFloat('0.00',dbTrabajo.Fields[1].AsFloat);
  StaticText13.Caption:=FormatFloat('0.00',dbTrabajo.Fields[0].AsFloat+dbTrabajo.Fields[1].AsFloat);
  StaticText7.Caption:=FormatFloat('0.00',dbTrabajo.Fields[2].AsFloat);
  StaticText8.Caption:=FormatFloat('0.00',dbTrabajo.Fields[3].AsFloat);
  StaticText14.Caption:=FormatFloat('0.00',dbTrabajo.Fields[2].AsFloat+dbTrabajo.Fields[3].AsFloat);
  StaticText9.Caption:=FormatFloat('0.00',dbTrabajo.Fields[4].AsFloat);
  StaticText10.Caption:=FormatFloat('0.00',dbTrabajo.Fields[5].AsFloat);
  StaticText15.Caption:=FormatFloat('0.00',dbTrabajo.Fields[4].AsFloat+dbTrabajo.Fields[5].AsFloat);
  StaticText11.Caption:=FormatFloat('0.00',dbTrabajo.Fields[6].AsFloat);
  StaticText12.Caption:=FormatFloat('0.00',dbTrabajo.Fields[7].AsFloat);
  StaticText16.Caption:=FormatFloat('0.00',dbTrabajo.Fields[6].AsFloat+dbTrabajo.Fields[7].AsFloat);
  //-------------------------- Listado -------------------------
  TituloGrid:='LISTADO DE IVA RECIBIDO, DESDE '+DateEditDesde.Text+' HASTA '+DateEditHasta.Text;
  TxtQuery := 'SELECT * FROM '+Stabla+Tienda+',proveedores WHERE HPC2=P0 AND '+
              'HPC1 >="'+FormatDateTime('YY/MM/DD',DateEditDesde.Date)+'" AND HPC1 <="'+FormatDateTime('YY/MM/DD',DateEditHasta.Date)+'"';
  if RadioButton2.Checked=True then TxtQuery:=TxtQuery+' AND HPC28="F"';//---------------- Facturas
  if RadioButton3.Checked=True then TxtQuery:=TxtQuery+' AND HPC28="A"';//---------------- Albaranes
  if RadioButton4.Checked=True then TxtQuery:=TxtQuery+' AND HPC28="P"';//---------------- Pedidos
  if RadioButton5.Checked=True then TxtQuery:=TxtQuery+' AND HPC28="N"';//---------------- Notas de entregas
  if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
  else
       TxtQuery := TxtQuery + ' ORDER BY HPC1,HPC2';

  LabelTituloDBGrid.Caption:=TituloGrid;
  dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
  DBGrid1.BringToFront; DBGrid1.Visible:=True;
  Panel2.Visible:=True;
  //WriteLn(TxtQuery);
end;

//==================== SELECCIONAR ===================
procedure TFLIvaReci.BitBtn3Click(Sender: TObject);
begin
  BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
  Ordenado:=False;
  OcultarBDGrid();
 end;

//==================== IMPRIMIR ===================
procedure TFLIvaReci.BitBtn2Click(Sender: TObject);
begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoIvaReci.lrf');
     frReport1.ShowReport;
  BitBtn2.Enabled:=False; //BitBtn3.Enabled:=False;
end;
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFLIvaReci.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
  if ParName ='EMPRESA' then ParValue := Empresa;
  if ParName='DIRECCION' then ParValue := Direccion;
  if ParName='LOCALIDAD' then ParValue := Localidad;
  if ParName='CP' then ParValue := CP;
  if ParName='TITULO' then ParValue := TituloGrid;
  if ParName='TXTIVA1' then ParValue := 'BASE/IVA '+FloatToStr(IVA1)+'%';
  if ParName='TXTIVA2' then ParValue := 'BASE/IVA '+FloatToStr(IVA2)+'%';
  if ParName='TXTIVA3' then ParValue := 'BASE/IVA '+FloatToStr(IVA3)+'%';
  if ParName='TXTIVA4' then ParValue := 'BASE/IVA 0%';
  if ParName='IMPBASE1' then ParValue := StaticText5.Caption;
  if ParName='IMPIVA1' then ParValue := StaticText6.Caption;
  if ParName='IMPBASE2' then ParValue := StaticText7.Caption;
  if ParName='IMPIVA2' then ParValue := StaticText8.Caption;
  if ParName='IMPBASE3' then ParValue := StaticText9.Caption;
  if ParName='IMPIVA3' then ParValue := StaticText10.Caption;
  if ParName='IMPBASE4' then ParValue := StaticText11.Caption;
  if ParName='IMPIVA4' then ParValue := StaticText12.Caption;

  if ParName='TOTBASE1' then ParValue := StaticText13.Caption;
  if ParName='TOTBASE2' then ParValue := StaticText14.Caption;
  if ParName='TOTBASE3' then ParValue := StaticText15.Caption;
  if ParName='TOTBASE4' then ParValue := StaticText16.Caption;


end;
//======================= LOGOTIPO DEL FORMULARIO ========================
procedure TFLIvaReci.frReport1EnterRect(Memo: TStringList; View: TfrView);
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

//======================= OCULTA TODOS LOS DBGird
procedure TFLIvaReci.OcultarBDGrid();
  begin
     LabelTituloDBGrid.Caption:='';
     DBGrid1.Visible:=False;
     Panel2.Visible:=False;
  end;

procedure TFLIvaReci.PanelFechaDesdeHastaClick(Sender: TObject);
begin

end;


//-------- Al pulsar en el titulo de la columna ordenar por ella
procedure TFLIvaReci.DBGrid1TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid1,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;

Initialization
  {$I ivareci.lrs}

End.

