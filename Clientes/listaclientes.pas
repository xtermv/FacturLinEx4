{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2008,

  Antonio Dominguez

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

Unit listaclientes;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset, DBGrids,
  StdCtrls, db, LR_DBSet, LR_Class, EditBtn;

Type

  { TFLClientes }

  TFLClientes = Class(Tform)
    Bevel1: TBevel;
    BitBtnCambiableRuta: TBitBtn;
    ComboCambiableNombreRuta: TComboBox;
    ComboCambiableNombreProvincia: TComboBox;
    ComboCambiableNombreLocalidad: TComboBox;
    DateEditDesde: TDateEdit;
    DateEditHasta: TDateEdit;
    dbCambiable: TZQuery;
    DBGrid1: TDBGrid;
    DBGrid11: TDBGrid;
    DBGrid7: TDBGrid;
    DBGrid4: TDBGrid;
    DBGrid5: TDBGrid;
    DBGrid6: TDBGrid;
    DBGrid8: TDBGrid;
    DBGrid10: TDBGrid;
    DBGrid3: TDBGrid;
    DBGrid9: TDBGrid;
    dbQuery1: TZQuery;
    Edit1: TEdit;
    EditEntregasCuenta: TEdit;
    EditRiesgoMaximo: TEdit;
    EditPendFacturar: TEdit;
    EditCodVendedor: TEdit;
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
    dbAnos: TZQuery;
    Edit7: TEdit;
    Edit8: TEdit;
    EditCambiableCodigo: TEdit;
    EditCambiableCodigoRuta: TEdit;
    EditCambiableNombre: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    LabelPendFacutar: TLabel;
    LabelEntreCuenta: TLabel;
    LabelVendedor: TLabel;
    LabelRiesgoMax: TLabel;
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
    LabelCambiable: TLabel;
    LabelCambiableRuta: TLabel;
    LabelCambiableProvincia: TLabel;
    LabelCambiableLocalidad: TLabel;
    LabelTituloDBGrid: TLabel;
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
    PanelCambiableRuta: TPanel;
    PanelCambiableProvincia: TPanel;
    PanelCambiableLocalidad: TPanel;
    PanelFechaDesdeHasta: TPanel;
    PanelSelectAno: TPanel;
    PanelRiesgoMax: TPanel;
    PanelVendedor: TPanel;
    PanelTituloGrid: TPanel;
    PanelDesdeHasta: TPanel;
    RadioButton1: TRadioButton;
    RadioButton11: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    StaticTextCambiableNombreRuta: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);

    procedure DateEditDesdeExit(Sender: TObject);
    procedure DateEditHastaExit(Sender: TObject);
    procedure DBGrid11TitleClick(Column: TColumn);
    procedure DBGrid7TitleClick(Column: TColumn);
    procedure DBGrid4TitleClick(Column: TColumn);
    procedure DBGrid5TitleClick(Column: TColumn);
    procedure DBGrid6TitleClick(Column: TColumn);
    procedure DBGrid8TitleClick(Column: TColumn);
    procedure DBGrid10TitleClick(Column: TColumn);
    procedure DBGrid3TitleClick(Column: TColumn);
    procedure DBGrid9TitleClick(Column: TColumn);


    Procedure Formcreate(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);
    procedure OcultarBDGrid();
    procedure RadioButton10Change(Sender: TObject);
    procedure RadioButton11Change(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton3Change(Sender: TObject);
    procedure RadioButton4Change(Sender: TObject);
    procedure RadioButton5Change(Sender: TObject);
    procedure RadioButton6Change(Sender: TObject);
    procedure RadioButton7Change(Sender: TObject);
    procedure RadioButton8Change(Sender: TObject);
    procedure RadioButton9Change(Sender: TObject);

    procedure EditCambiableCodigoRutaEnter(Sender: TObject);
    procedure EditCambiableCodigoRutaExit(Sender: TObject);
    procedure ComboCambiableNombreRutaClick(Sender: TObject);
    procedure ComboCambiableNombreRutaKeyPress(Sender: TObject; var Key: char);
    procedure BitBtnCambiableRutaClick(Sender: TObject);
    procedure ComboCambiableNombreLocalidadDropDown(Sender: TObject);
    procedure ComboCambiableNombreProvinciaDropDown(Sender: TObject);

    procedure DBGrid1TitleClick(Column: TColumn);

    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);

    procedure DimensionarColocarBDGrid();

  Private
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormlistaclientes;
  
Var
  FLClientes: TFLClientes;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;

Implementation

Uses
  Global, Funciones;

//=============== Crea el formulario ================
procedure ShowFormlistaclientes;
begin
  with TFLClientes.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFLClientes.Formcreate(Sender: Tobject);

Begin
    //Conectate(dbConect);         // Utilizamos datamodule1.dbConexión para toda la aplicación.

  //---------------------Paneles visibles por defecto, los de RadioButton1Change
   PanelDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiableRuta.Visible:=True;
   PanelCambiableProvincia.Visible:=False;
   PanelCambiableLocalidad.Visible:=False;
   PanelVendedor.Visible:=False;
   PanelRiesgoMax.Visible:=False;

   LabelCambiableRuta.Caption:='Ruta/Distintivo';
   EditCambiableCodigoRuta.Text:='';
   StaticTextCambiableNombreRuta.Caption:='';
   LabelCambiableProvincia.Caption:='Provincia';
   LabelCambiableLocalidad.Caption:='Localidad';

   DateEditDesde.Date:=StrToDate('01/01/'+FormatDateTime('YYYY',Date));
   DateEditHasta.Date:=Date;
   BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;

  // Ocultamos todos los DBGrid
  DimensionarColocarBDGrid();
  OcultarBDGrid();
End;

//==================== CERRAR ======================
procedure TFLClientes.BitBtn4Click(Sender: TObject);
begin
  dbQuery.Active:=False;
  Close();
end;

// --------Formateo de fechas entrantes
procedure TFLClientes.DateEditDesdeExit(Sender: TObject);
begin
   if not EsFechaValida(DateEditDesde.text) Then
     begin
       DateEditDesde.text:='';
       ShowMessage('Formato de Fecha Invalido, debe ser dd/mm/aaaa');
     end
end;

procedure TFLClientes.DateEditHastaExit(Sender: TObject);
begin
   if not EsFechaValida(DateEditHasta.text) Then
     begin
       DateEditHasta.text:='';
       ShowMessage('Formato de Fecha Invalido, debe ser dd/mm/aaaa');
     end
end;

Procedure TFLClientes.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//==================== VISUALIZAR ===================
procedure TFLClientes.BitBtn1Click(Sender: TObject);
Var
  TxtQuery: String;
begin
  AntColun:='0';Ordenado:=False;
  BitBtn2.Enabled:=True; BitBtn3.Enabled:=True;
  //-------------------------- DATOS PERSONALES (DIRECCIONES) Y ETIQUETAS
  if (RadioButton1.Checked=True) or (RadioButton2.Checked=True) then
    begin
     TituloGrid:='LISTADO DE DATOS PERSONALES (DIRECCIONES)';
     TxtQuery:='SELECT C0, C1, C3, C4, C5, C6, C37, C38 from clientes WHERE';
     if EditCambiableCodigoRuta.Text<>'' then
      TxtQuery:=TxtQuery + ' C10 >= "'+EditCambiableCodigoRuta.Text+'" AND';
     if Edit1.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 >= "'+Edit1.Text+'" AND';
     if Edit2.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 <= "'+Edit2.Text+'" AND';
     TxtQuery:=TxtQuery + ' MID(C1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(C1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY C0';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     if EditCambiableCodigoRuta.Text<>'' then TituloGrid:=TituloGrid +' DE LA RUTA '+StaticTextCambiableNombreRuta.Caption;
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
    end;
  //-------------------------- CREDITOS
  if RadioButton3.Checked=True then
    begin
     TituloGrid:='LISTADO DE CREDITOS';
     TxtQuery:='SELECT C0, C1, C10 ,CRE1, CRE2, CRE3, CRE10, HO11, HO12, CRE7, CRE8 from clientes, creditos'+Tienda+', hisopcc'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' C0=CRE0 AND HO0=CRE1 AND HO1=CRE2 AND HO4=CRE4 AND HO3=CRE5 AND';
     if EditCambiableCodigoRuta.Text<>'' then
      TxtQuery:=TxtQuery + ' C10 >= "'+EditCambiableCodigoRuta.Text+'" AND';
     if EditCodVendedor.Text<>'' then
      TxtQuery:=TxtQuery + ' CRE10 >= "'+EditCodVendedor.Text+'" AND';
     if Edit1.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 >= "'+Edit1.Text+'" AND';
     if Edit2.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 <= "'+Edit2.Text+'" AND';
      TxtQuery:=TxtQuery + ' MID(C1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(C1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
      TxtQuery:=TxtQuery + ' AND CRE1>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND CRE1<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY C10, C0';
       //WriteLn(TxtQuery);
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     TituloGrid:=TituloGrid+' ENTRE EL '+FormatDateTime('DD-MM-YYYY',DateEditDesde.Date)+
        ' Y EL '+FormatDateTime('DD-MM-YYYY',DateEditHasta.Date);
     DBGrid3.BringToFront; DBGrid3.Visible:=True;
    end;
  //-------------------------- CREDITOS AGUPADOS
  if RadioButton4.Checked=True then
    begin
     TituloGrid:='LISTADO DE CREDITOS AGRUPADOS';
     TxtQuery:='SELECT C10, C0, C1, SUM(HO11) as ImporteTotal, SUM(CRE7) as Debe, SUM(CRE8) as Haber from clientes, creditos'+Tienda+', hisopcc'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' C0=CRE0 AND HO0=CRE1 AND HO1=CRE2 AND HO4=CRE4 AND HO3=CRE5 AND';
     if EditCambiableCodigoRuta.Text<>'' then
      TxtQuery:=TxtQuery + ' C10 >= "'+EditCambiableCodigoRuta.Text+'" AND';
     if Edit1.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 >= "'+Edit1.Text+'" AND';
     if Edit2.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 <= "'+Edit2.Text+'" AND';
      TxtQuery:=TxtQuery + ' MID(C1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(C1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
      TxtQuery:=TxtQuery + ' AND CRE1>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND CRE1<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"';
     TxtQuery:=TxtQuery + ' GROUP BY C0';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY C10, C0';
       //WriteLn(TxtQuery);
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     TituloGrid:=TituloGrid+' ENTRE EL '+FormatDateTime('DD-MM-YYYY',DateEditDesde.Date)+
        ' Y EL '+FormatDateTime('DD-MM-YYYY',DateEditHasta.Date);
     DBGrid4.BringToFront; DBGrid4.Visible:=True;
    end;
  //----------- Créditos por Localidad, Provincia o Ruta
  if RadioButton5.Checked=True then
    begin
     TituloGrid:='LISTADO DE CREDITOS POR LOCALIDAD, PROVINCIA O RUTA';
     TxtQuery:='SELECT C10, C0, C1, C3, C4, C38, C44, C45, SUM(CRE7) as Debe, SUM(CRE8) as Haber from clientes, creditos'+Tienda+' WHERE C0=CRE0 AND';
     if EditCambiableCodigoRuta.Text<>'' then
      TxtQuery:=TxtQuery + ' C10 >= "'+EditCambiableCodigoRuta.Text+'" AND';
     if ComboCambiableNombreProvincia.Text<>'' then
      TxtQuery:=TxtQuery + ' C38 = "'+ComboCambiableNombreProvincia.Text+'" AND';
     if ComboCambiableNombreLocalidad.Text<>'' then
      TxtQuery:=TxtQuery + ' C4 = "'+ComboCambiableNombreLocalidad.Text+'" AND';
     if Edit1.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 >= "'+Edit1.Text+'" AND';
     if Edit2.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 <= "'+Edit2.Text+'" AND';
      TxtQuery:=TxtQuery + ' MID(C1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(C1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     TxtQuery:=TxtQuery + ' GROUP BY C0';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY C10, C0';
       //WriteLn(TxtQuery);
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     DBGrid5.BringToFront; DBGrid5.Visible:=True;
    end;
  //-------------------------- Prestamos // De momento es igual que créditos, según Nico sale de esta misma tabla pero no se como
  if RadioButton6.Checked=True then
    begin
     TituloGrid:='LISTADO DE PRESTAMO';
     TxtQuery:='SELECT C0, C1, C10 ,CRE1, CRE2, CRE3, HO11, HO12, CRE7, CRE8 from clientes, creditos'+Tienda+', hisopcc'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' C0=CRE0 AND HO0=CRE1 AND HO1=CRE2 AND HO4=CRE4 AND HO3=CRE5 AND';
     if EditCambiableCodigoRuta.Text<>'' then
      TxtQuery:=TxtQuery + ' C10 >= "'+EditCambiableCodigoRuta.Text+'" AND';
     if EditCodVendedor.Text<>'' then
      TxtQuery:=TxtQuery + ' CRE10 >= "'+EditCodVendedor.Text+'" AND';
     if Edit1.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 >= "'+Edit1.Text+'" AND';
     if Edit2.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 <= "'+Edit2.Text+'" AND';
      TxtQuery:=TxtQuery + ' MID(C1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(C1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
      TxtQuery:=TxtQuery + ' AND CRE1>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND CRE1<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY C10, C0';
       //WriteLn(TxtQuery);
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     TituloGrid:=TituloGrid+' ENTRE EL '+FormatDateTime('DD-MM-YYYY',DateEditDesde.Date)+
        ' Y EL '+FormatDateTime('DD-MM-YYYY',DateEditHasta.Date);
     DBGrid6.BringToFront; DBGrid6.Visible:=True;
    end;
//--------------------------- Listado de Riesgo máximo
  if RadioButton7.Checked=True then
    begin
     TituloGrid:='LISTADO DE RIESGO MAXIMO';
     TxtQuery:='SELECT C0, C1, C20, C21, C22 from clientes WHERE';
     if Edit1.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 >= "'+Edit1.Text+'" AND';
     if Edit2.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 <= "'+Edit2.Text+'" AND';
     if EsFloat(EditPendFacturar.Text) then   // Pendiente de facturacion es un valor negativo
      TxtQuery:=TxtQuery + ' C20 <= "'+EditPendFacturar.Text+'" AND';
     if EsFloat(EditEntregasCuenta.Text) then
      TxtQuery:=TxtQuery + ' C21 >= "'+EditEntregasCuenta.Text+'" AND';
     if EsFloat(EditRiesgoMaximo.Text) then   // 0 por defecto, los clientes con riesgo 0 no salen
      TxtQuery:=TxtQuery + ' C22 > "'+EditRiesgoMaximo.Text+'" AND';
     TxtQuery:=TxtQuery + ' MID(C1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(C1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY C1';
       //WriteLn(TxtQuery);
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     DBGrid7.BringToFront; DBGrid7.Visible:=True;
    end;
//--------------------------- Listado de Riesgo máximo
  if RadioButton8.Checked=True then
    begin
     TituloGrid:='LISTADO DE DESCUENTOS';
     TxtQuery:='SELECT C0, C1, C6, C16, C17, C18, C19, C22 from clientes WHERE';
     if Edit1.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 >= "'+Edit1.Text+'" AND';
     if Edit2.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 <= "'+Edit2.Text+'" AND';
     TxtQuery:=TxtQuery + ' MID(C1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(C1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY C1';
       //WriteLn(TxtQuery);
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     DBGrid8.BringToFront; DBGrid8.Visible:=True;
    end;
  //-------------------------- LISTADOS DE ALBARANES PENDIENES
  if RadioButton9.Checked=True then
    begin
     TituloGrid:='LISTADO DE ALBARANES PENDIENES';
     TxtQuery:='SELECT C0, C1, C10 ,AC1, AC3, AC4, AC5, AC6, AC7, AC8, AC9 from clientes, albac'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' C0=AC0 AND';
     if EditCambiableCodigoRuta.Text<>'' then
      TxtQuery:=TxtQuery + ' C10 >= "'+EditCambiableCodigoRuta.Text+'" AND';
     if Edit1.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 >= "'+Edit1.Text+'" AND';
     if Edit2.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 <= "'+Edit2.Text+'" AND';
      TxtQuery:=TxtQuery + ' MID(C1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(C1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
      TxtQuery:=TxtQuery + ' AND AC1>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND AC1<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY C10, C0';
       //WriteLn(TxtQuery);
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     TituloGrid:=TituloGrid+' ENTRE EL '+FormatDateTime('DD-MM-YYYY',DateEditDesde.Date)+
        ' Y EL '+FormatDateTime('DD-MM-YYYY',DateEditHasta.Date);
     DBGrid9.BringToFront; DBGrid9.Visible:=True;
    end;

  //-------------------------- LISTADOS DE Facturas
  if RadioButton11.Checked=True then
    begin
     TituloGrid:='LISTADO DE Facturas';
     TxtQuery:='SELECT C0, C1, C10 ,FC1, FC3, FC4, FC5, FC6, FC7, FC8, FC9 from clientes, factuc'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' C0=FC0 AND';
     if EditCambiableCodigoRuta.Text<>'' then
      TxtQuery:=TxtQuery + ' C10 >= "'+EditCambiableCodigoRuta.Text+'" AND';
     if Edit1.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 >= "'+Edit1.Text+'" AND';
     if Edit2.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 <= "'+Edit2.Text+'" AND';
      TxtQuery:=TxtQuery + ' MID(C1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(C1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
      TxtQuery:=TxtQuery + ' AND FC1>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND FC1<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY C10, C0';
       //WriteLn(TxtQuery);
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     TituloGrid:=TituloGrid+' ENTRE EL '+FormatDateTime('DD-MM-YYYY',DateEditDesde.Date)+
        ' Y EL '+FormatDateTime('DD-MM-YYYY',DateEditHasta.Date);
     DBGrid11.BringToFront; DBGrid11.Visible:=True;
    end;


  //-------------------------- ESTADISTICAS DE VENTAS
  if RadioButton10.Checked=True then
    begin
     if dbAnos.RecordCount=0 then begin showmessage('NO HAY DATOS PARA VISUALIZAR'); exit; end;
     TituloGrid:='LISTADO DE ESTADISTICAS DE VENTAS';
     TxtQuery:='SELECT C0,C1,SUM(CC5) AS UNIVND,SUM(CC6) AS IMPUNIVND,SUM(CC7) AS IMPVENCOST,SUM(CC6-CC7) AS BENEF '+
     'from clientes,estaclie WHERE';
     if Edit1.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 >= "'+Edit1.Text+'" AND';
     if Edit2.Text<>'' then
      TxtQuery:=TxtQuery + ' C0 <= "'+Edit2.Text+'" AND';
     TxtQuery:=TxtQuery + ' MID(C1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                     '" AND MID(C1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     TxtQuery:=TxtQuery +' AND CC1='+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex]+' AND CC2>='+
     Edit7.Text+' AND CC2<='+Edit8.Text+' AND C0=CC0 GROUP BY C0';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY C0';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     if PanelSelectAno.Visible then TituloGrid:=TituloGrid+' ENTRE LOS MESES '+
        Edit7.Text+' Y '+Edit8.Text+' DE '+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex];
     DBGrid10.BringToFront; DBGrid10.Visible:=True;
    end;
  LabelTituloDBGrid.Caption:=TituloGrid;
  //WriteLn(TxtQuery);
end;

//==================== SELECCIONAR ===================
procedure TFLClientes.BitBtn3Click(Sender: TObject);
begin
  BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
  Ordenado:=False;
  OcultarBDGrid();
end;

//==================== IMPRIMIR ===================
procedure TFLClientes.BitBtn2Click(Sender: TObject);
begin
  //-------------------------- Datos Personales (Direcciones)
  if (RadioButton1.Checked=True) then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoClientesDirec.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- Etiquetas
  if RadioButton2.Checked=True then
    begin
     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoClientesEtiquetas.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- Listado de Créditos
  if RadioButton3.Checked=True then
    begin
     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoClientesCreditos.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- Listado de Créditos Agrupados
  if RadioButton4.Checked=True then
    begin
     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoClientesCredAgrup.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- Listado de Créditos por Localidades
  if RadioButton5.Checked=True then
    begin
     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoClientesCredLocalid.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- Listado de Créditos por Riesgo Máximo
  if RadioButton7.Checked=True then
    begin
     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoClientesRiesgMax.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- Listado de Créditos Descuentos
  if RadioButton8.Checked=True then
    begin
     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoClientesDescuentos.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- Listado de Créditos Albaranes
  if RadioButton9.Checked=True then
    begin
     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoClientesAlbaranes.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- Listado de Facturas
  if RadioButton11.Checked=True then
    begin
     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoClientesFacturas.lrf');
     frReport1.ShowReport;
    end;
  if RadioButton10.Checked=True then
    begin
     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoClientesEsta.lrf');
     frReport1.ShowReport;
    end;
end;
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFLClientes.frReport1GetValue(const ParName: String;
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
procedure TFLClientes.frReport1EnterRect(Memo: TStringList; View: TfrView);
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

//---------- Datos Generales
procedure TFLClientes.RadioButton1Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiableRuta.Visible:=True;
   PanelCambiableProvincia.Visible:=False;
   PanelCambiableLocalidad.Visible:=False;
   PanelVendedor.Visible:=False;
   PanelRiesgoMax.Visible:=False;
   OcultarBDGrid();
end;
//---------- Etiquetas
procedure TFLClientes.RadioButton2Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiableRuta.Visible:=True;
   PanelCambiableProvincia.Visible:=False;
   PanelCambiableLocalidad.Visible:=False;
   PanelVendedor.Visible:=False;
   PanelRiesgoMax.Visible:=False;
   OcultarBDGrid();
end;
//---------- Creditos
procedure TFLClientes.RadioButton3Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=True;
   PanelCambiableRuta.Visible:=True;
   PanelCambiableProvincia.Visible:=False;
   PanelCambiableLocalidad.Visible:=False;
   PanelVendedor.Visible:=True;
   PanelRiesgoMax.Visible:=False;
   OcultarBDGrid();
end;
//---------- Creditos Agrupados
procedure TFLClientes.RadioButton4Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=True;
   PanelCambiableRuta.Visible:=True;
   PanelCambiableProvincia.Visible:=False;
   PanelCambiableLocalidad.Visible:=False;
   PanelVendedor.Visible:=False;
   PanelRiesgoMax.Visible:=False;
   OcultarBDGrid();
end;
//----------- Clientes por Localidad, Provincia o Ruta
procedure TFLClientes.RadioButton5Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiableRuta.Visible:=True;
   PanelCambiableProvincia.Visible:=True;
   PanelCambiableLocalidad.Visible:=True;
   PanelVendedor.Visible:=False;
   PanelRiesgoMax.Visible:=False;
   OcultarBDGrid();
end;
//---------- Prestamos
procedure TFLClientes.RadioButton6Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=True;
   PanelCambiableRuta.Visible:=True;
   PanelCambiableProvincia.Visible:=False;
   PanelCambiableLocalidad.Visible:=False;
   PanelVendedor.Visible:=True;
   PanelRiesgoMax.Visible:=False;
   OcultarBDGrid();
end;
//---------- Listado de Riesgo Maximo
procedure TFLClientes.RadioButton7Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiableRuta.Visible:=False;
   PanelCambiableProvincia.Visible:=False;
   PanelCambiableLocalidad.Visible:=False;
   PanelVendedor.Visible:=False;
   PanelRiesgoMax.Visible:=True;
   OcultarBDGrid();
end;
//---------- Listado de Descuentos
procedure TFLClientes.RadioButton8Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiableRuta.Visible:=False;
   PanelCambiableProvincia.Visible:=False;
   PanelCambiableLocalidad.Visible:=False;
   PanelVendedor.Visible:=False;
   PanelRiesgoMax.Visible:=False;
   OcultarBDGrid();
end;
procedure TFLClientes.RadioButton9Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelFechaDesdeHasta.Visible:=True;
   PanelCambiableRuta.Visible:=True;
   PanelCambiableProvincia.Visible:=False;
   PanelCambiableLocalidad.Visible:=False;
   PanelVendedor.Visible:=False;
   PanelRiesgoMax.Visible:=False;
   OcultarBDGrid();
end;
//---------- Estadisticas de cliente
procedure TFLClientes.RadioButton10Change(Sender: TObject);
begin
  if RadioButton10.Checked=True then RellenaListBoxAnos('SELECT DISTINCT(CC1) FROM estaclie',dbAnos, PanelSelectAno, ListBoxAnos)
  else PanelSelectAno.Visible:=False;
  PanelDesdeHasta.Visible:=True;
  PanelFechaDesdeHasta.Visible:=False;
  OcultarBDGrid();
end;

procedure TFLClientes.RadioButton11Change(Sender: TObject);
begin
  PanelDesdeHasta.Visible:=True;
  PanelSelectAno.Visible:=False;
  PanelFechaDesdeHasta.Visible:=True;
  PanelCambiableRuta.Visible:=True;
  PanelCambiableProvincia.Visible:=False;
  PanelCambiableLocalidad.Visible:=False;
  PanelVendedor.Visible:=False;
  PanelRiesgoMax.Visible:=False;
  OcultarBDGrid();
end;

// ====================== Redimensiona y Coloca Todos los DBGrid
procedure TFLClientes.DimensionarColocarBDGrid();
  begin
    DBGrid1.Align:=alClient;
    DBGrid3.Align:=alClient;
    DBGrid4.Align:=alClient;
    DBGrid5.Align:=alClient;
    DBGrid6.Align:=alClient;
    DBGrid7.Align:=alClient;
    DBGrid8.Align:=alClient;
    DBGrid9.Align:=alClient;
    DBGrid10.Align:=alClient;
    DBGrid11.Align:=alClient;
  end;

//======================= OCULTA TODOS LOS DBGird
procedure TFLClientes.OcultarBDGrid();
  begin
    LabelTituloDBGrid.Caption:='';
    DBGrid1.Visible:=False; DBGrid3.Visible:=False; DBGrid4.Visible:=False;
    DBGrid5.Visible:=False; DBGrid6.Visible:=False; DBGrid7.Visible:=False;
    DBGrid8.Visible:=False; DBGrid9.Visible:=False; DBGrid10.Visible:=False;
    DBGrid11.Visible:=False;
  end;


//======================== Metodos de los Paneles Cambiables
procedure TFLClientes.ComboCambiableNombreRutaClick(Sender: TObject);
begin
  EscogeNombreComboCambiable('RUT1', ComboCambiableNombreRuta, dbCambiable, EditCambiableCodigoRuta, StaticTextCambiableNombreRuta)
end;

procedure TFLClientes.ComboCambiableNombreRutaKeyPress(Sender: TObject;
  var Key: char);
begin
  if key=#13 then ComboCambiableNombreRutaClick(ComboCambiableNombreRuta);
end;

//======================= Despues de introducir un codigo, al salir, si existe,
//======================= completa el StaticText con el nombre oportuno
procedure TFLClientes.EditCambiableCodigoRutaExit(Sender: TObject);
var
 TxtQuery: String;
begin
  TxtQuery:='SELECT RUT1 FROM rutas WHERE RUT0="'+EditCambiableCodigoRuta.Text+'"';
  if EditCambiableCodigoRuta.Text<>'' then
    begin
     RellenaPanelCambiableN(TxtQuery,dbCambiable, StaticTextCambiableNombreRuta);
     if dbCambiable.RecordCount=0 then
       begin
         Showmessage('NO HAY '+LabelCambiableRuta.Caption+' CON ESE CODIGO');
         EditCambiableCodigoRuta.Text:='';
         exit;
       end;
    end;
end;

procedure TFLClientes.EditCambiableCodigoRutaEnter(Sender: TObject);
begin
  StaticTextCambiableNombreRuta.Caption:='';
end;

//procedure TFLClientes.EditCambiableCodigo2Enter(Sender: TObject);
//begin
  //StaticTextCambiableNombre2.Caption:='';
//end;
//procedure TFLClientes.EditCambiableCodigo3Enter(Sender: TObject);
//begin
  //StaticTextCambiableNombre3.Caption:='';
//end;
//========= Botones de carga de los paneles cambiables
procedure TFLClientes.BitBtnCambiableRutaClick(Sender: TObject);
var
 TxtQuery: String;
begin
 TxtQuery:='SELECT RUT0, RUT1 FROM rutas'+Tienda+' ORDER BY RUT1';
 CargaValoresEnComboCambiable(TxtQuery, ComboCambiableNombreRuta, dbCambiable, LabelCambiableRuta);
end;

procedure TFLClientes.ComboCambiableNombreLocalidadDropDown(Sender: TObject);
var
 TxtQuery: String;
begin //Que se repita C4 solo obedece a la compatibilidad con la función CargaValoresEnComboCambiable
 TxtQuery:='SELECT DISTINCT C4, C4 FROM clientes WHERE C4<>"" ORDER BY C4';
 CargaValoresEnComboCambiable(TxtQuery, ComboCambiableNombreLocalidad, dbCambiable, LabelCambiableLocalidad);
end;

procedure TFLClientes.ComboCambiableNombreProvinciaDropDown(Sender: TObject);
var
 TxtQuery: String;
begin //Que se repita C38 solo obedece a la compatibilidad con la función CargaValoresEnComboCambiable
 TxtQuery:='SELECT DISTINCT C38, C38 FROM clientes WHERE C38<>"" ORDER BY C38';
 CargaValoresEnComboCambiable(TxtQuery, ComboCambiableNombreProvincia, dbCambiable, LabelCambiableProvincia);
end;

//-------- Al pulsar en el titulo de la columna ordenar por ella
procedure TFLClientes.DBGrid1TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid1,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLClientes.DBGrid10TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid10,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLClientes.DBGrid3TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid3,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLClientes.DBGrid4TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid4,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLClientes.DBGrid5TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid5,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLClientes.DBGrid6TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid6,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLClientes.DBGrid7TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid7,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLClientes.DBGrid8TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid8,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLClientes.DBGrid9TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid9,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLClientes.DBGrid11TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid11,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;

Initialization
  {$I listaclientes.lrs}

End.

