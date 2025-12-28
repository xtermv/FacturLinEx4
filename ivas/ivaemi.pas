{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2009,  Nicolas Lopez de Lerma Aymerich

  PuntoDev GNU S.L. <info@puntodev.com>

  Collaborators:
                 xxxxxxxxxxxxxxxxxxxxxxxxx
                 xxxxxxxxxxxxxxxxxxxxxxxxx

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

Unit ivaEmi;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset, DBGrids,
  StdCtrls, db, LR_DBSet, LR_Class, ExtDlgs, EditBtn;

Type

  { TFLIvaEmi }

  TFLIvaEmi = Class(Tform)
    BitBtnCambiable: TBitBtn;
    ChkBoxGroup1: TCheckBox;
    ComboCambiableNombre: TComboBox;
    DataSource2: TDataSource;
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    dbCambiable: TZQuery;
    DBGrid1: TDBGrid;
    DBGridIVA: TDBGrid;
    DBGridIVA1: TDBGrid;
    Edit1: TEdit;
    //Edit5: TEdit;
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
    Edit30: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
    Bevel1: TBevel;
    EditCambiableCodigo: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frDBDataSet2: TfrDBDataSet;
    frReport1: TfrReport;
    frReport2: TfrReport;
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
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label5: TLabel;
    LabelCambiable: TLabel;
    LabelTituloDBGrid: TLabel;
    LabelTituloDBGrid1: TLabel;
    Panel1: Tpanel;
    Bitbtn1: Tbitbtn;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    BitBtn4: TBitBtn;
    Datasource1: TDatasource;
    dbQuery: TZQuery;
    PanelCambiable: TPanel;
    PanelFechaDesdeHasta: TPanel;
    PanelDesdeHasta: TPanel;
    PanelTituloGrid: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    StaticTextCambiableNombre: TStaticText;
    dbIva: TZQuery;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure DBGridIVATitleClick(Column: TColumn);


    Procedure Formcreate(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    //procedure Colorea(Column: TColumn;Grid: TDBGrid;dbColor: TZQuery);
    //procedure RellenaListBoxAnos(TxtQuery: String);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);
    //procedure BlancoGrid(Grid: TDBGrid);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure BitBtnCambiableClick(Sender: TObject);
    procedure ComboCambiableNombreClick(Sender: TObject);
    procedure ComboCambiableNombreKeyPress(Sender: TObject; var Key: char);
    procedure EditCambiableCodigoExit(Sender: TObject);
    procedure EditCambiableCodigoEnter(Sender: TObject);

    procedure DimensionarColocarBDGrid();
    procedure OcultarBDGrid();

  Private
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormlistaivaEmi;
  
Var
  FLIvaEmi: TFLIvaEmi;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;

Implementation

uses
  Global, Funciones;

//=============== Crea el formulario ================
procedure ShowFormlistaivaEmi;
begin
  with TFLIvaEmi.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFLIvaEmi.Formcreate(Sender: Tobject);

Begin
   //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.
   //---------------------Paneles visibles por defecto, los de RadioButton1Change
   PanelDesdeHasta.Visible:=True;
   PanelFechaDesdeHasta.Visible:=True;
   PanelCambiable.Visible:=True;


   BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
   DateEdit1.Date:=StrToDate('01/01/'+FormatDateTime('YYYY',Date));
   DateEdit2.Date:=Date;
   LabelCambiable.Caption:='Serie';
   
   //Ococultamos todos los DBGrid
   DimensionarColocarBDGrid();
   OcultarBDGrid();
End;

//==================== CERRAR ======================
procedure TFLIvaEmi.BitBtn4Click(Sender: TObject);
begin
  dbQuery.Active:=False;
  dbIva.Active:=False;
  Close();
end;

Procedure TFLIvaEmi.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//==================== VISUALIZAR ===================
procedure TFLIvaEmi.BitBtn1Click(Sender: TObject);
Var
  TxtQuery: String;
begin
  AntColun:='0';Ordenado:=False;
  BitBtn2.Enabled:=True; BitBtn3.Enabled:=True;
  //if EditCambiableCodigo.Text<>'' then EditCambiableCodigo.Text:='A';
  EditCambiableCodigoExit(EditCambiableCodigo);
  //-------------------------- IVA EMITIDO, Esta instruccion SQL NO se si es la correcta
  TituloGrid:='LISTADO DE IVA EMITIDO';
  //TxtQuery := 'SELECT factud'+Tienda+'.*, FORMAT((SUM(FD13) - ((SUM(FD13)*100) / (FD12+100))),2) As Ivas, FORMAT(SUM(FD11),2) As Bases,';

  if RadioButton1.Checked then
    begin
      TxtQuery := 'SELECT factud'+Tienda+'.*, (SUM(FD13) - ((SUM(FD13)*100) / (FD12+100))) As Ivas, SUM(FD11) As Bases,';
      TxtQuery := TxtQuery + ' SUM(FD13) As Total, C1, C5';
      TxtQuery := TxtQuery + ' FROM factud'+Tienda+', clientes';
      TxtQuery := TxtQuery + ' WHERE FD0=C0 AND FD2 = "'+EditCambiableCodigo.Text+'" AND FD3 >= '+Edit1.Text+' AND FD3 <='+Edit2.Text+' AND ';
      TxtQuery := TxtQuery + ' FD1 >="'+FormatDateTime('YY/MM/DD',DateEdit1.Date)+'" AND FD1 <="'+FormatDateTime('YY/MM/DD',DateEdit2.Date)+'"';
      TxtQuery := TxtQuery + ' GROUP BY FD13, FD0';

      //-- TxtQuery := 'SELECT hisopdd'+Tienda+'.*, sum(HOD12) where HOD13='+IVA1+' and HOD0>='+DateEdit1.Date+' and HOD0<='+DateEdit2.Date;
      dbQuery.Active:=False; dbQuery.sql.Text:=TxtQuery; dbQuery.Active:=True;
      if Ordenado=True then
           TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
      else
           TxtQuery:=TxtQuery + ' ORDER BY FD2,FD3';
      dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
      DBGrid1.BringToFront; DBGrid1.Visible:=True;
    end;
  if RadioButton2.Checked then
    begin
      if ChkBoxGroup1.Checked=False then
        begin
         TxtQuery := 'select * from iva' + Tienda;
         TxtQuery := TxtQuery + ' where Fecha >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text));
         TxtQuery := TxtQuery + '" and Fecha <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text));
         TxtQuery := TxtQuery + '" and TipoOp<>"FM" and TipoOp<>"FA"';
          if Ordenado=True then
               TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
          else
               TxtQuery:=TxtQuery + ' ORDER BY Fecha,Hora';
          dbIva.Active:=False; dbIva.Sql.Text:=TxtQuery; dbIva.Active:=True;
          DBGridIva.BringToFront; DBGridIva.Visible:=True;
        end
      else
        begin
           TxtQuery := 'select sum(Base) as TotBase,sum(Iva) as TotIva,TIva,sum(Total) as Tot from iva' + Tienda;
           TxtQuery := TxtQuery + ' where Fecha >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text));
           TxtQuery := TxtQuery + '" and Fecha <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text));
           TxtQuery := TxtQuery + '" and TipoOp<>"FM" and TipoOp<>"FA" group by TIva Order by TIva';
           if Ordenado=True then showmessage('Lamentamos comunicar que NO se puede modificar la ordenación en listados agrupados');
           dbIva.Active:=False; dbIva.Sql.Text:=TxtQuery; dbIva.Active:=True;
           DBGridIva1.BringToFront; DBGridIva1.Visible:=True;
        end;

      //-- TxtQuery := 'SELECT hisopdd'+Tienda+'.*, sum(HOD12) where HOD13='+IVA1+' and HOD0>='+DateEdit1.Date+' and HOD0<='+DateEdit2.Date;
//--ANULADO PARA PODER MOSTRAR DOS GRID DISTINTOS
      {
      dbIva.Active:=False; dbIva.Sql.Text:=TxtQuery; dbIva.Active:=True;
      DBGridIva.BringToFront; DBGridIva.Visible:=True;
      }
    end;
  if RadioButton3.Checked then
    begin
      TxtQuery := 'select * from iva' + Tienda;
      TxtQuery := TxtQuery + ' where Fecha >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text));
      TxtQuery := TxtQuery + '" and Fecha <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text));
      TxtQuery := TxtQuery + '" and TipoOp="FA"';

      //-- TxtQuery := 'SELECT hisopdd'+Tienda+'.*, sum(HOD12) where HOD13='+IVA1+' and HOD0>='+DateEdit1.Date+' and HOD0<='+DateEdit2.Date;
      dbIva.Active:=False; dbIva.sql.Text:=TxtQuery; dbIva.Active:=True;
      if Ordenado=True then
           TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
      else
           TxtQuery:=TxtQuery + ' ORDER BY Fecha,Hora';
      dbIva.Active:=False; dbIva.Sql.Text:=TxtQuery; dbIva.Active:=True;
      DBGridIva.BringToFront; DBGridIva.Visible:=True;
    end;
  if RadioButton4.Checked then
    begin
      TxtQuery := 'select * from iva' + Tienda;
      TxtQuery := TxtQuery + ' where Fecha >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text));
      TxtQuery := TxtQuery + '" and Fecha <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text));
      TxtQuery := TxtQuery + '" and TipoOp="FM"';

      //-- TxtQuery := 'SELECT hisopdd'+Tienda+'.*, sum(HOD12) where HOD13='+IVA1+' and HOD0>='+DateEdit1.Date+' and HOD0<='+DateEdit2.Date;
      dbIva.Active:=False; dbIva.sql.Text:=TxtQuery; dbIva.Active:=True;
      if Ordenado=True then
           TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
      else
           TxtQuery:=TxtQuery + ' ORDER BY Fecha,Hora';
      dbIva.Active:=False; dbIva.Sql.Text:=TxtQuery; dbIva.Active:=True;
      DBGridIva.BringToFront; DBGridIva.Visible:=True;
    end;
  if RadioButton5.Checked then
    begin
      {
      TxtQuery := 'select * from iva' + Tienda;
      TxtQuery := TxtQuery + ' where Fecha >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text));
      TxtQuery := TxtQuery + '" and Fecha <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text))+'"';
      }
      TxtQuery := 'select TipoOP,sum(Base) as TotBase,sum(Iva) as TotIva,TIva,sum(Total) as Tot FROM iva' + Tienda;
      TxtQuery := TxtQuery + ' where Fecha >= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text));
      TxtQuery := TxtQuery + '" and Fecha <= "'+ FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit2.Text))+'"';
      TxtQuery := TxtQuery + ' group by TipoOP,TIva';


      //-- TxtQuery := 'SELECT hisopdd'+Tienda+'.*, sum(HOD12) where HOD13='+IVA1+' and HOD0>='+DateEdit1.Date+' and HOD0<='+DateEdit2.Date;
      dbIva.Active:=False; dbIva.sql.Text:=TxtQuery; dbIva.Active:=True;
      if Ordenado=True then
           TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
      else
//-- MODIFICADO POR RESUMEN           TxtQuery:=TxtQuery + ' ORDER BY Fecha,Hora';
           TxtQuery:=TxtQuery + ' order by TIva,TipoOP';
      dbIva.Active:=False; dbIva.Sql.Text:=TxtQuery; dbIva.Active:=True;
      DBGridIva1.BringToFront; DBGridIva1.Visible:=True;
    end;
  LabelTituloDBGrid.Caption:=TituloGrid;
  //WriteLn(TxtQuery);
end;

//==================== SELECCIONAR ===================
procedure TFLIvaEmi.BitBtn3Click(Sender: TObject);
begin
  BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
  Ordenado:=False;
  OcultarBDGrid();
 end;

//==================== IMPRIMIR ===================
procedure TFLIvaEmi.BitBtn2Click(Sender: TObject);
begin
   if RadioButton1.Checked then
     begin
//      Showmessage('El RadioButton1 esta activado');
      frDBDataSet1.DataSet:=dbQuery;
      frReport1.LoadFromFile(RutaReports+'ListadoIvaEmi.lrf');
      frReport1.ShowReport;
     end
   else
     begin
//        Showmessage('El RadioButton1 NO esta activado');
        frDBDataSet1.DataSet:=dbIva;
        if ChkBoxGroup1.Checked=False then frReport1.LoadFromFile(RutaReports+'ListadoIvaEmi2.lrf')
           else frReport1.LoadFromFile(RutaReports+'ListadoIvaEmi3.lrf');
        frReport1.ShowReport;
     end;
   BitBtn2.Enabled:=False; //BitBtn3.Enabled:=False;
end;
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFLIvaEmi.frReport1GetValue(const ParName: String;
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
  If ChkBoxGroup1.Checked=True then
    begin
      if ParName='DESDE' then ParValue := DateEdit1.Text;
      if ParName='HASTA' then ParValue := DateEdit2.Text;
    end;
end;
//======================= LOGOTIPO DEL FORMULARIO ========================
procedure TFLIvaEmi.frReport1EnterRect(Memo: TStringList; View: TfrView);
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

// ====================== Redimensiona y Coloca Todos los DBGrid
procedure TFLIvaEmi.DimensionarColocarBDGrid();
  begin
    DBGrid1.Align:=alClient;
    DBGridIVA.Align:=alClient;
    DBGridIVA1.Align:=alClient;
    //DBGrid3.Align:=alClient;
    //DBGrid4.Align:=alClient;
    //DBGrid5.Align:=alClient;
    //DBGrid6.Align:=alClient;
    //DBGrid7.Align:=alClient;
  end;

//======================= OCULTA TODOS LOS DBGird
procedure TFLIvaEmi.OcultarBDGrid();
  begin
    LabelTituloDBGrid.Caption:='';
    DBGrid1.Visible:=False;
    DBGridIVA.Visible:=False;
    DBGridIVA1.Visible:=False;
  end;


//-------- Al pulsar en el titulo de la columna ordenar por ella
procedure TFLIvaEmi.DBGrid1TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid1,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;

procedure TFLIvaEmi.DBGridIVATitleClick(Column: TColumn);
begin
  if ChkBoxGroup1.Checked=False then Colorea(Column,DBGridIVA,dbQuery, AntColun, Orden, TituloColumn, Ordenado)
    else showmessage('Lamentamos comunicar que NO se puede modificar la ordenación en listados agrupados');
end;

//========= Boton de busqueda del panel cambiable y seleccion del nombre elejido
procedure TFLIvaEmi.BitBtnCambiableClick(Sender: TObject);
var
 TxtQuery: String;
begin
 TxtQuery:='SELECT SF0, SF1 FROM seriesfactu ORDER BY SF1';
 CargaValoresEnComboCambiable(TxtQuery, ComboCambiableNombre, dbCambiable, LabelCambiable);
end;

procedure TFLIvaEmi.ComboCambiableNombreClick(Sender: TObject);
begin
  EscogeNombreComboCambiable( 'SF1', ComboCambiableNombre, dbCambiable, EditCambiableCodigo, StaticTextCambiableNombre)
end;

procedure TFLIvaEmi.ComboCambiableNombreKeyPress(Sender: TObject;
  var Key: char);
begin
  if key=#13 then ComboCambiableNombreClick(ComboCambiableNombre);
end;

//======================= Despues de introducir un codigo, al salir, si existe,
//======================= completa el StaticText con el nombre oportuno
procedure TFLIvaEmi.EditCambiableCodigoExit(Sender: TObject);
var
 TxtQuery: String;
begin
  TxtQuery:='SELECT SF1 FROM seriesfactu WHERE SF0="'+EditCambiableCodigo.Text+'"';
  if EditCambiableCodigo.Text<>'' then
    begin
     RellenaPanelCambiableN(TxtQuery,dbCambiable, StaticTextCambiableNombre);
     if dbCambiable.RecordCount=0 then
       begin
         Showmessage('NO HAY '+LabelCambiable.Caption+' CON ESE CODIGO');
         EditCambiableCodigo.Text:='';
         exit;
       end;
    end;
end;

procedure TFLIvaEmi.EditCambiableCodigoEnter(Sender: TObject);
begin
  StaticTextCambiableNombre.Caption:='';
end;

Initialization
  {$I ivaemi.lrs}

End.

