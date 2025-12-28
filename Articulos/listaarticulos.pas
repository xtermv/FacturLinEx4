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

Unit listaarticulos;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset, DBGrids,
  StdCtrls, db, LR_DBSet, LR_Class, ExtDlgs, EditBtn, CheckLst, lr_e_pdf;

Type

  { TFLArticulos }

  TFLArticulos = Class(Tform)
    btManual: TBitBtn;
    btSeleccionFiltrar: TBitBtn;
    btSeleccionTodos: TBitBtn;
    btSeleccionSalir: TBitBtn;
    btSeleccionInvertir: TBitBtn;
    btProveedor: TBitBtn;
    btFamilia: TBitBtn;
    BitBtnCambiable: TBitBtn;
    BitBtnCambiable1: TBitBtn;
    chbSinPrecio: TCheckBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    chbPvp: TCheckBox;
    chbTarifa1: TCheckBox;
    chbTarifa2: TCheckBox;
    chbCoste: TCheckBox;
    chbTarifa3: TCheckBox;
    chbSinIva: TCheckBox;
    chbPorProveedor: TCheckBox;
    chbPorFamilia: TCheckBox;
    clbSeleccionManual: TCheckListBox;
    ComboCambiableNombre: TComboBox;
    ComboCambiableNombre1: TComboBox;
    dsTarifas: TDatasource;
    DateEditDesde: TDateEdit;
    DateEditHasta: TDateEdit;
    dbCambiable: TZQuery;
    DBGrid7: TDBGrid;
    DBGrid8: TDBGrid;
    dbgTarifa: TDBGrid;
    dbTiendas: TZQuery;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    DBGrid5: TDBGrid;
    DBGrid6: TDBGrid;
    dbAnos: TZQuery;
    dbTrabajo: TZQuery;
    Edit1: TEdit;
    edProveedor: TEdit;
    edFamilia: TEdit;
    edCodigoProveedor: TEdit;
    edCodigoFamilia: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    EditCambiableCodigo: TEdit;
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
    EditCambiableCodigo1: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LabelCambiable: TLabel;
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
    LabelCambiable1: TLabel;
    LabelTituloDBGrid: TLabel;
    LabelTituloDBGrid1: TLabel;
    ListBoxAnos: TListBox;
    Panel1: Tpanel;
    Bitbtn1: Tbitbtn;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    BitBtn4: TBitBtn;
    Datasource1: TDatasource;
    dbQuery: TZQuery;
    pSeleccionManual: TPanel;
    PanelTarifas: TPanel;
    PanelCambiable: TPanel;
    PanelCambiable1: TPanel;
    PanelFechaDesdeHasta: TPanel;
    PanelSelectAno: TPanel;
    PanelStock: TPanel;
    PanelDesdeHasta: TPanel;
    PanelTituloGrid: TPanel;
    RadioButton1: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    rbTarifas: TRadioButton;
    StaticTextCambiableNombre: TStaticText;
    StaticTextCambiableNombre1: TStaticText;
    dbSeleccion: TZQuery;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtnCambiable1Click(Sender: TObject);
    procedure BitBtnCambiableClick(Sender: TObject);
    procedure btManualClick(Sender: TObject);
    procedure btProveedorClick(Sender: TObject);
    procedure btFamiliaClick(Sender: TObject);
    procedure btSeleccionFiltrarClick(Sender: TObject);
    procedure btSeleccionInvertirClick(Sender: TObject);
    procedure btSeleccionSalirClick(Sender: TObject);
    procedure btSeleccionTodosClick(Sender: TObject);
    procedure chbPorFamiliaChange(Sender: TObject);
    procedure chbPorProveedorChange(Sender: TObject);
    procedure ComboCambiableNombre1Click(Sender: TObject);
    procedure ComboCambiableNombre1KeyPress(Sender: TObject; var Key: char);
    procedure ComboCambiableNombreClick(Sender: TObject);
    procedure ComboCambiableNombreKeyPress(Sender: TObject; var Key: char);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure DBGrid3TitleClick(Column: TColumn);
    procedure DBGrid4TitleClick(Column: TColumn);
    procedure DBGrid5TitleClick(Column: TColumn);
    procedure DBGrid6TitleClick(Column: TColumn);
    procedure DBGrid7TitleClick(Column: TColumn);
    procedure DBGrid8TitleClick(Column: TColumn);
    procedure dbgTarifaTitleClick(Column: TColumn);
    procedure EditCambiableCodigo1Enter(Sender: TObject);
    procedure EditCambiableCodigo1Exit(Sender: TObject);
    procedure EditCambiableCodigoExit(Sender: TObject);
    procedure EditCambiableCodigoEnter(Sender: TObject);
    procedure edCodigoProveedorExit(Sender: TObject);
    procedure edProveedorExit(Sender: TObject);
    procedure edProveedorKeyPress(Sender: TObject; var Key: char);
    procedure edCodigoFamiliaExit(Sender: TObject);
    procedure edFamiliaExit(Sender: TObject);
    procedure edFamiliaKeyPress(Sender: TObject; var Key: char);

    Procedure Formcreate(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    procedure FormShow(Sender: TObject);
    //procedure Colorea(Column: TColumn;Grid: TDBGrid;dbColor: TZQuery);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton5Change(Sender: TObject);
    procedure RadioButton6Change(Sender: TObject);
    procedure RadioButton7Change(Sender: TObject);
    procedure RadioButton8Change(Sender: TObject);
    //procedure RellenaListBoxAnos(TxtQuery: String);
    procedure DBGrid1TitleClick(Column: TColumn);
    //procedure BlancoGrid(Grid: TDBGrid);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);
    procedure RadioButton3Change(Sender: TObject);
    procedure RadioButton4Change(Sender: TObject);
    procedure OcultarBDGrid();
    procedure DimensionarColocarBDGrid();
    procedure rbTarifasChange(Sender: TObject);
    procedure SeleccionaTarifas(Sender: TObject);

    //procedure EscogeNombreComboCambiable(TxtCampo: String; ComboCambiableNombre: TComboBox;  dbCambiable: TZQuery; EditCambiableNombre: TEdit; StaticTextCambiableNombre: TStaticText);
  Private
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormlistaarticulos;
  
Var
  FLArticulos: TFLArticulos;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;
  TituloCampos: Array of string;

Implementation

uses
  Global, Busquedas, Funciones;

//=============== Crea el formulario ================
procedure ShowFormlistaarticulos;
begin
  with TFLArticulos.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFLArticulos.Formcreate(Sender: Tobject);
var
   TxtQuery: String;
Begin
   //Conectate(dbConect);           // Utilizamos datamodule1.dbConexión para toda la aplicación.
   // Creo la Tabla temporal listaesta, la utilizamos para el calculo de estadisticas

   dbQuery.Active:=False;
   dbQuery.SQL.Text:='DROP TABLE IF EXISTS listaesta';
   dbQuery.ExecSQL;
   TxtQuery :='CREATE TEMPORARY TABLE listaesta ('+
            'LS0 INT(4) NOT NULL, LS1 CHAR(50),'+       // Cod. y Nombre
            'LS2 DOUBLE(10,2) NOT NULL DEFAULT 0.00,'+  // Stock
            'LS3 DOUBLE(10,2) NOT NULL DEFAULT 0.00,'+  // Unid Compr
            'LS4 DOUBLE(10,2) NOT NULL DEFAULT 0.00,'+  // Impor Compr
            'LS5 DOUBLE(10,2) NOT NULL DEFAULT 0.00,'+  // Unid Vend
            'LS6 DOUBLE(10,2) NOT NULL DEFAULT 0.00,'+  // Impor Vend PVP
            'LS7 DOUBLE(10,2) NOT NULL DEFAULT 0.00,'+  // Impor Vend Cost
            'LS8 DOUBLE(10,2) NOT NULL DEFAULT 0.00,'+  // Benef
            'LS9 CHAR(1) NOT NULL DEFAULT "N",'+        // Marcado
            'LS10 INT(11),'+              // Codigo de familia/proveedor/fabricante
            'LS11 CHAR(50),'+             // En familias, Fech Ult Compra
            'LS12 CHAR(50),'+             // Nombre de familia/proveedor/fabricante
            'PRIMARY KEY klft (LS0), UNIQUE (LS0), INDEX klft (LS0))'+
            ' ENGINE=MyISAM DEFAULT CHARSET=latin1';
   //WriteLn('Creacion de la tabla listaesta '+TxtQuery);
   dbQuery.Sql.Text:= TxtQuery;
   dbQuery.ExecSql;

   BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
   DateEditDesde.Date:=Date;
   DateEditHasta.Date:=Date;

   LabelCambiable1.Caption:='Tienda';
   
   //Ocultamos todos los DBGrid
   DimensionarColocarBDGrid();
   OcultarBDGrid();
  
End;

//==================== CERRAR ======================
procedure TFLArticulos.BitBtn4Click(Sender: TObject);
begin
  // Al terminar Borramos la tabla temporal
  dbQuery.Active:=False;
  dbQuery.SQL.Text:='DROP TABLE IF EXISTS listaesta';
  dbQuery.ExecSQL;

  dbQuery.Active:=False;
  Close();
end;

//==================== VISUALIZAR ===================
procedure TFLArticulos.BitBtn1Click(Sender: TObject);
Var
  TxtQuery, LeeTienda: String;
//  nContador, nCampos: integer;
begin
  AntColun:='0';Ordenado:=False; Orden:='DESC';
  BitBtn2.Enabled:=True; BitBtn3.Enabled:=True;
  if EditCambiableCodigo1.Text<>'' then Tienda:=DataModule1.LFill(EditCambiableCodigo1.Text,4,'0')
  else
   begin
    EditCambiableCodigo1.Text:= Tienda;
    EditCambiableCodigo1Exit(EditCambiableCodigo1);
   end;
  //if EditCambiableCodigo1.Text<>'' then Tienda:=EditCambiableCodigo1.Text;
  //-------------------------- LISTADO DE ARTICULOS (STOCKS)
  if RadioButton1.Checked=True then
    begin
      TituloGrid:='LISTADO DE ARTICULOS (STOCKS) DE LA TIENDA "'+StaticTextCambiableNombre1.Caption+'"';
      TxtQuery := 'select A0, A1, A2, A4, A5, A6, A24, (A4*A2) as ImpoArtiPrec, (A4*A24) as ImpoArtiCost from artitien'+Tienda+' WHERE ';
      if Edit1.Text<>'' then
       TxtQuery:=TxtQuery + 'A0 >= "'+Edit1.Text+'" AND';
      if Edit2.Text<>'' then
       TxtQuery:=TxtQuery + ' A0 <= "'+Edit2.Text+'" AND';
      TxtQuery:=TxtQuery + ' MID(A1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                      '" AND MID(A1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
      if CheckBox1.Checked=True then TxtQuery:=TxtQuery+' AND A4<>0';
      if CheckBox2.Checked=True then TxtQuery:=TxtQuery+' AND A4>-1';
      //TxtQuery:=TxtQuery + ' ORDER BY A14, A1, A0';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY A14, A1, A0';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
    end;

 //--------------------------- LISTADO DE TARIFAS
  if rbTarifas.Checked=True then
   begin
     PanelTarifas.Visible:=True;
     if (dbSeleccion.SQL.Text='') then SeleccionaTarifas(self);

     pSeleccionManual.Visible:=False;
     dbgTarifa.BringToFront;
     dbgTarifa.Visible:=True; dbgTarifa.SetFocus;

   end;
 //--------------------------- LISTADO DE ARTICULOS POR FAMILIA
  if RadioButton2.Checked=True then
    begin
     TituloGrid:='LISTADO DE ARTICULOS POR FAMILIA';
     TxtQuery := 'select A0, A1, A2, A4, A5, A6, A14, (A2*A4) as ImpoArtiPrec, (A2*A4) as ImpoArtiCost, F0, F1 from artitien'+Tienda+' LEFT OUTER JOIN familias'+Tienda+' ON A14=F0';
     TxtQuery := TxtQuery + ' WHERE A0 >= "'+Edit1.Text+'" AND A0 <= "'+Edit2.Text+'" AND A1>="'+Edit3.Text+'" AND A1<="'+Edit4.Text+'"';
     if CheckBox1.Checked=True then TxtQuery:=TxtQuery+' AND A4<>0';
     if CheckBox2.Checked=True then TxtQuery:=TxtQuery+' AND A4>-1';
     If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND A14='+EditCambiableCodigo.Text;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY A14, A1, A0';

     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     if StaticTextCambiableNombre.Caption <> '' then
       TituloGrid:= TituloGrid + ' ('+ StaticTextCambiableNombre.Caption+') ';
     DBGrid2.BringToFront; DBGrid2.Visible:=True;
    end;
  //--------------------------_ LISTADO DE ARTICULOS POR PROVEEDOR

  if RadioButton3.Checked=True then
    begin
     TituloGrid:='LISTADO DE ARTICULOS POR PROVEEDOR';
     TxtQuery := 'select distinct A0, A1, A2, A4, A5, A6, A32, (A2*A4) as ImpoArtiPrec, (A2*A4) as ImpoArtiCost, P0, P1 from artitien'+Tienda+' LEFT OUTER JOIN proveedores ON P0=A32';
      TxtQuery := TxtQuery + ' WHERE A0 >= "'+Edit1.Text+'" AND A0 <= "'+Edit2.Text+'" AND A1>="'+Edit3.Text+'" AND A1<="'+Edit4.Text+'"';
      if CheckBox1.Checked=True then TxtQuery:=TxtQuery+' AND A4<>0';
      if CheckBox2.Checked=True then TxtQuery:=TxtQuery+' AND A4>-1';
      If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND A32='+EditCambiableCodigo.Text;
      if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
      else
       TxtQuery:=TxtQuery + ' ORDER BY A32, A14, A1';
     //WriteLn(TxtQuery);
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     if StaticTextCambiableNombre.Caption <> '' then
       TituloGrid:= TituloGrid + ' ('+ StaticTextCambiableNombre.Caption+') ';
     DBGrid3.BringToFront; DBGrid3.Visible:=True;
    end;
  //-------------------------- LISTADO DE VENTAS POR ARTICULOS
  if RadioButton4.Checked=True then
    begin
      TituloGrid:='LISTADO DE VENTAS POR ARTICULOS';
      TxtQuery := 'SELECT HOD6, MID(HOD7,1,20) as Descripcion, SUM(HOD8) As Unid, SUM(HOD9) As ImpoPrec, SUM(HOD8)*A24 As ImpoCos, SUM(HOD9)-((SUM(HOD8)*A24)*((HOD13/100)+1)) As Benef FROM hisopdd'+Tienda+',artitien'+Tienda+' WHERE HOD6=A0';
      TxtQuery := TxtQuery + ' AND HOD6 >= "'+Edit1.Text+'" AND HOD6 <= "'+Edit2.Text+'"';
      TxtQuery := TxtQuery + ' AND MID(HOD7,1,'+IntToStr(Length(Edit3.Text))+')>="'+Edit3.Text+'" AND MID(HOD7,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
      TxtQuery := TxtQuery + ' AND HOD0>="'+FormatDateTime('YYYY/MM/DD',DateEditDesde.Date)+'" AND HOD0<="'+FormatDateTime('YYYY/MM/DD',DateEditHasta.Date)+'"';
      //TxtQuery := TxtQuery + ' AND HOD4<>"C" AND HOD0<>"X"'; //no se a que corresponde así que lo dejo comentado.
      TxtQuery := TxtQuery + ' GROUP BY HOD6';// ORDER BY HOD7';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY HOD7';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     if FormatDateTime('DD-MM-YYYY',DateEditDesde.Date) <> '' then
       TituloGrid:= TituloGrid + ' DESDE EL DIA '+ FormatDateTime('DD-MM-YYYY',DateEditDesde.Date);
     if FormatDateTime('DD-MM-YYYY',DateEditHasta.Date) <> '' then
       TituloGrid:= TituloGrid + ' HASTA EL DIA '+ FormatDateTime('DD-MM-YYYY',DateEditHasta.Date);
     DBGrid4.BringToFront; DBGrid4.Visible:=True;
    end;
      //-------------------------- LISTADO DE COMPRAS POR ARTICULOS
  if RadioButton5.Checked=True then
    begin
      TituloGrid:='LISTADO DE COMPRAS POR ARTICULOS';
      TxtQuery := 'SELECT AP0, A1, SUM(AP3) As Unid, SUM(AP3)*SUM(AP4) As Impor FROM ultimopedi'+Tienda+',artitien'+Tienda+' WHERE AP0=A0';
      TxtQuery := TxtQuery + ' AND AP0 >= "'+Edit1.Text+'" AND AP0 <= "'+Edit2.Text+'"';
      TxtQuery := TxtQuery + ' AND MID(A1,1,'+IntToStr(Length(Edit3.Text))+')>="'+Edit3.Text+'" AND MID(A1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
      TxtQuery := TxtQuery + ' AND AP1>="'+FormatDateTime('YYYY/MM/DD',DateEditDesde.Date)+'" AND AP1<="'+FormatDateTime('YYYY/MM/DD',DateEditHasta.Date)+'"';
      TxtQuery := TxtQuery + ' GROUP BY AP0';// ORDER BY A1';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY A1';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     if FormatDateTime('DD-MM-YYYY',DateEditDesde.Date) <> '' then
       TituloGrid:= TituloGrid + ' DESDE EL DIA '+ FormatDateTime('DD-MM-YYYY',DateEditDesde.Date);
     if FormatDateTime('DD-MM-YYYY',DateEditHasta.Date) <> '' then
       TituloGrid:= TituloGrid + ' HASTA EL DIA '+ FormatDateTime('DD-MM-YYYY',DateEditHasta.Date);
     DBGrid5.BringToFront; DBGrid5.Visible:=True;
    end;
    //-------------------------- ESTADISTICA DE ARTICULOS POR FAMILIA
  if RadioButton6.Checked=True then
    begin
      if dbAnos.RecordCount=0 then begin showmessage('NO HAY DATOS PARA VISUALIZAR'); exit; end;
      TituloGrid:='LISTADO DE ESTADISTICA DE ARTICULOS POR FAMILIA';

      TxtQuery := 'DELETE FROM listaesta';
      dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.ExecSQL;

      TxtQuery := 'INSERT IGNORE INTO listaesta (LS0,LS1,LS2,LS3,LS4,LS5,LS6,LS7,LS8,LS9,LS10,LS11,LS12) '+
      'select A0, A1, A4, SUM(TA3) As UniC, SUM(TA4) As Impor, SUM(TA5) As UniV, SUM(TA6) As ImpoPVP,';
      TxtQuery := TxtQuery + ' SUM(TA7) As ImpoCos, SUM(TA6-TA7) As Benef, A22,A14,F3,F1 from artitien'+Tienda+', estaarti'+Tienda+', familias'+Tienda+' where A0=TA0 AND A14=F0';
      TxtQuery := TxtQuery + ' AND A0 >= "'+Edit1.Text+'" AND A0 <= "'+Edit2.Text+'" AND A1>="'+Edit3.Text+'" AND A1<="'+Edit4.Text+'"';
      TxtQuery := TxtQuery + ' AND TA1='+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex];
      TxtQuery := TxtQuery + ' AND TA2>="'+Edit7.Text+'" AND TA2<="'+Edit8.Text+'"';
      if EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND A14='+EditCambiableCodigo.Text;
      TxtQuery := TxtQuery + ' GROUP BY TA0 ORDER BY A14,A1';
      //WriteLn('Inserción de datos en listaesta '+TxtQuery);
      dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.ExecSQL;
      dbQuery.Active:=False; dbQuery.Sql.Text:='SELECT * FROM listaesta';
      dbQuery.Active:=True;
      if dbQuery.RecordCount=0 then begin ShowMessage('NO HAY DATOS'); exit; end;
      dbTiendas.Active:=False;
      dbTiendas.Sql.Text:='SELECT * FROM tiendas WHERE T0<>'+Tienda;
      dbTiendas.Active:=True;
      if dbTiendas.RecordCount<>0 then
        begin
         dbTiendas.First;
         while not dbTiendas.eof do
         begin
         dbQuery.First;
         while not dbQuery.eof do
           begin
            LeeTienda:=DataModule1.LFill(dbTiendas.Fields[0].AsString,4,'0');
            TxtQuery:='SELECT A0,A1,A4,SUM(TA3) As UniC,SUM(TA4) As Impor,SUM(TA5) As UniV,'+
                   'SUM(TA6) As ImpoPVP,SUM(TA7) As ImpoCos, SUM(TA6-TA7) As Benef, A22 '+
                   'FROM artitien'+LeeTienda+', estaarti'+LeeTienda+', familias'+LeeTienda+' where A0=TA0 AND A14=F0 '+
                   'AND A0="'+dbQuery.Fields[0].AsString+'"'+
                   ' AND TA1='+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex]+
                   ' AND TA2>="'+Edit7.Text+'" AND TA2<="'+Edit8.Text+'"'+
                   ' GROUP BY TA0';
            dbTrabajo.Active:=False; dbTrabajo.Sql.Text:=TxtQuery; dbTrabajo.Active:=True;
            if dbTrabajo.RecordCount<>0 then
              begin
                dbQuery.Edit;
                dbQuery.Fields[2].Value:=dbQuery.Fields[2].AsFloat+dbTrabajo.Fields[2].AsFloat;
                dbQuery.Fields[3].Value:=dbQuery.Fields[3].AsFloat+dbTrabajo.Fields[3].AsFloat;
                dbQuery.Fields[4].Value:=dbQuery.Fields[4].AsFloat+dbTrabajo.Fields[4].AsFloat;
                dbQuery.Fields[5].Value:=dbQuery.Fields[5].AsFloat+dbTrabajo.Fields[5].AsFloat;
                dbQuery.Fields[6].Value:=dbQuery.Fields[6].AsFloat+dbTrabajo.Fields[6].AsFloat;
                dbQuery.Fields[7].Value:=dbQuery.Fields[7].AsFloat+dbTrabajo.Fields[7].AsFloat;
                dbQuery.Fields[8].Value:=dbQuery.Fields[8].AsFloat+dbTrabajo.Fields[8].AsFloat;
                dbQuery.Post;
              end;
            dbQuery.Next;
           end;
          dbTiendas.Next;
         end;
        end;
      TxtQuery:='SELECT * FROM listaesta';//WriteLn(TxtQuery);
      dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;

      if PanelSelectAno.Visible then TituloGrid:=TituloGrid+' ENTRE LOS MESES '+
        Edit7.Text+' Y '+Edit8.Text+' DE '+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex];
     DBGrid6.BringToFront; DBGrid6.Visible:=True;
    end;
      //-------------------------- ESTADISTICA DE ARTICULOS POR AUTOR/FABRICANTE  --
  if RadioButton7.Checked=True then
    begin
      if dbAnos.RecordCount=0 then begin showmessage('NO HAY DATOS PARA VISUALIZAR'); exit; end;
      TituloGrid:='LISTADO DE ESTADISTICA DE ARTICULOS POR AUTOR/FABRICANTE';

      TxtQuery := 'DELETE FROM listaesta';
      dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.ExecSQL;

      TxtQuery := 'INSERT IGNORE INTO listaesta (LS0,LS1,LS2,LS3,LS4,LS5,LS6,LS7,LS8,LS9,LS10,LS11,LS12) '+
      'select A0, A1, A4, SUM(TA3) As UniC, SUM(TA4) As Impor, SUM(TA5) As UniV, SUM(TA6) As ImpoPVP,';
      TxtQuery := TxtQuery + ' SUM(TA7) As ImpoCos, SUM(TA6-TA7) As Benef, A22,A20,AUT1,AUT1 from artitien'+Tienda+', estaarti'+Tienda+', autofabri where A0=TA0 AND A20=AUT0';
      TxtQuery := TxtQuery + ' AND A0 >= "'+Edit1.Text+'" AND A0 <= "'+Edit2.Text+'" AND A1>="'+Edit3.Text+'" AND A1<="'+Edit4.Text+'"';
      TxtQuery := TxtQuery + ' AND TA1='+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex];
      TxtQuery := TxtQuery + ' AND TA2>="'+Edit7.Text+'" AND TA2<="'+Edit8.Text+'"';
      if EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND A20='+EditCambiableCodigo.Text;
      TxtQuery := TxtQuery + ' GROUP BY TA0 ORDER BY A20,A1';
      //WriteLn('Inserción de datos en listaesta '+TxtQuery);
      dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.ExecSQL;
      dbQuery.Active:=False; dbQuery.Sql.Text:='SELECT * FROM listaesta';
      dbQuery.Active:=True;
      if dbQuery.RecordCount=0 then begin ShowMessage('NO HAY DATOS'); exit; end;
      dbTiendas.Active:=False;
      dbTiendas.Sql.Text:='SELECT * FROM tiendas WHERE T0<>'+Tienda;
      dbTiendas.Active:=True;
      if dbTiendas.RecordCount<>0 then
        begin
         dbTiendas.First;
         while not dbTiendas.eof do
         begin
         dbQuery.First;
         while not dbQuery.eof do
           begin
            LeeTienda:=DataModule1.LFill(dbTiendas.Fields[0].AsString,4,'0');
            TxtQuery:='SELECT A0,A1,A4,SUM(TA3) As UniC,SUM(TA4) As Impor,SUM(TA5) As UniV,'+
                   'SUM(TA6) As ImpoPVP,SUM(TA7) As ImpoCos, SUM(TA6-TA7) As Benef, A22 '+
                   'FROM artitien'+LeeTienda+', estaarti'+LeeTienda+', autofabri where A0=TA0 AND A20=AUT0 '+
                   'AND A0="'+dbQuery.Fields[0].AsString+'"'+
                   ' AND TA1='+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex]+
                   ' AND TA2>="'+Edit7.Text+'" AND TA2<="'+Edit8.Text+'"'+
                   ' GROUP BY TA0';
            dbTrabajo.Active:=False; dbTrabajo.Sql.Text:=TxtQuery; dbTrabajo.Active:=True;
            if dbTrabajo.RecordCount<>0 then
              begin
                dbQuery.Edit;
                dbQuery.Fields[2].Value:=dbQuery.Fields[2].AsFloat+dbTrabajo.Fields[2].AsFloat;
                dbQuery.Fields[3].Value:=dbQuery.Fields[3].AsFloat+dbTrabajo.Fields[3].AsFloat;
                dbQuery.Fields[4].Value:=dbQuery.Fields[4].AsFloat+dbTrabajo.Fields[4].AsFloat;
                dbQuery.Fields[5].Value:=dbQuery.Fields[5].AsFloat+dbTrabajo.Fields[5].AsFloat;
                dbQuery.Fields[6].Value:=dbQuery.Fields[6].AsFloat+dbTrabajo.Fields[6].AsFloat;
                dbQuery.Fields[7].Value:=dbQuery.Fields[7].AsFloat+dbTrabajo.Fields[7].AsFloat;
                dbQuery.Fields[8].Value:=dbQuery.Fields[8].AsFloat+dbTrabajo.Fields[8].AsFloat;
                dbQuery.Post;
              end;
            dbQuery.Next;
           end;
          dbTiendas.Next;
         end;
        end;
      TxtQuery:='SELECT * FROM listaesta';//WriteLn(TxtQuery);
      dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;

     if PanelSelectAno.Visible then TituloGrid:=TituloGrid+' ENTRE LOS MESES '+
        Edit7.Text+' Y '+Edit8.Text+' DE '+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex];
     DBGrid7.BringToFront; DBGrid7.Visible:=True;
    end;
      //-------------------------- ESTADISTICA DE ARTICULOS POR PROVEEDOR
  if RadioButton8.Checked=True then
    begin
      if dbAnos.RecordCount=0 then begin showmessage('NO HAY DATOS PARA VISUALIZAR'); exit; end;
      TituloGrid:='LISTADO DE ESTADISTICA DE ARTICULOS POR PROVEEDOR';

      TxtQuery := 'DELETE FROM listaesta';
      dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.ExecSQL;

      TxtQuery := 'INSERT IGNORE INTO listaesta (LS0,LS1,LS2,LS3,LS4,LS5,LS6,LS7,LS8,LS9,LS10,LS11,LS12) '+
      'select A0, A1, A4, SUM(TA3) As UniC, SUM(TA4) As Impor, SUM(TA5) As UniV, SUM(TA6) As ImpoPVP,';
      TxtQuery := TxtQuery + ' SUM(TA7) As ImpoCos, SUM(TA6-TA7) As Benef, A22,A32,P23,P1 from artitien'+Tienda+', estaarti'+Tienda+', proveedores where A0=TA0 AND A32=P0';
      TxtQuery := TxtQuery + ' AND A0 >= "'+Edit1.Text+'" AND A0 <= "'+Edit2.Text+'" AND A1>="'+Edit3.Text+'" AND A1<="'+Edit4.Text+'"';
      TxtQuery := TxtQuery + ' AND TA1='+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex];
      TxtQuery := TxtQuery + ' AND TA2>="'+Edit7.Text+'" AND TA2<="'+Edit8.Text+'"';
      if EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND A32='+EditCambiableCodigo.Text;
      TxtQuery := TxtQuery + ' GROUP BY TA0 ORDER BY A32,A1';
      //WriteLn('Inserción de datos en listaesta '+TxtQuery);
      dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.ExecSQL;
      dbQuery.Active:=False; dbQuery.Sql.Text:='SELECT * FROM listaesta';
      dbQuery.Active:=True;
      if dbQuery.RecordCount=0 then begin ShowMessage('NO HAY DATOS'); exit; end;
      dbTiendas.Active:=False;
      dbTiendas.Sql.Text:='SELECT * FROM tiendas WHERE T0<>'+Tienda;
      dbTiendas.Active:=True;
      if dbTiendas.RecordCount<>0 then
        begin
         dbTiendas.First;
         while not dbTiendas.eof do
         begin
         dbQuery.First;
         while not dbQuery.eof do
           begin
            LeeTienda:=DataModule1.LFill(dbTiendas.Fields[0].AsString,4,'0');
            TxtQuery:='SELECT A0,A1,A4,SUM(TA3) As UniC,SUM(TA4) As Impor,SUM(TA5) As UniV,'+
                   'SUM(TA6) As ImpoPVP,SUM(TA7) As ImpoCos, SUM(TA6-TA7) As Benef, A22 '+
                   'FROM artitien'+LeeTienda+', estaarti'+LeeTienda+', proveedores where A0=TA0 AND A32=P0 '+
                   'AND A0="'+dbQuery.Fields[0].AsString+'"'+
                   ' AND TA1='+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex]+
                   ' AND TA2>="'+Edit7.Text+'" AND TA2<="'+Edit8.Text+'"'+
                   ' GROUP BY TA0';
            dbTrabajo.Active:=False; dbTrabajo.Sql.Text:=TxtQuery; dbTrabajo.Active:=True;
            if dbTrabajo.RecordCount<>0 then
              begin
                dbQuery.Edit;
                dbQuery.Fields[2].Value:=dbQuery.Fields[2].AsFloat+dbTrabajo.Fields[2].AsFloat;
                dbQuery.Fields[3].Value:=dbQuery.Fields[3].AsFloat+dbTrabajo.Fields[3].AsFloat;
                dbQuery.Fields[4].Value:=dbQuery.Fields[4].AsFloat+dbTrabajo.Fields[4].AsFloat;
                dbQuery.Fields[5].Value:=dbQuery.Fields[5].AsFloat+dbTrabajo.Fields[5].AsFloat;
                dbQuery.Fields[6].Value:=dbQuery.Fields[6].AsFloat+dbTrabajo.Fields[6].AsFloat;
                dbQuery.Fields[7].Value:=dbQuery.Fields[7].AsFloat+dbTrabajo.Fields[7].AsFloat;
                dbQuery.Fields[8].Value:=dbQuery.Fields[8].AsFloat+dbTrabajo.Fields[8].AsFloat;
                dbQuery.Post;
              end;
            dbQuery.Next;
           end;
          dbTiendas.Next;
         end;
        end;
      TxtQuery:='SELECT * FROM listaesta';//WriteLn(TxtQuery);
      dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;

     if PanelSelectAno.Visible then TituloGrid:=TituloGrid+' ENTRE LOS MESES '+
        Edit7.Text+' Y '+Edit8.Text+' DE '+ListBoxAnos.Items.Strings[ListBoxAnos.ItemIndex];
     DBGrid8.BringToFront; DBGrid8.Visible:=True;
   end;
  LabelTituloDBGrid.Caption:=TituloGrid;
  //WriteLn(TxtQuery);
end;

//==================== SELECCIONAR ===================
procedure TFLArticulos.BitBtn3Click(Sender: TObject);
begin
  dbSeleccion.Active:=False;dbSeleccion.SQL.Text:='';
  BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
  Ordenado:=False;
  OcultarBDGrid();
 end;

//==================== IMPRIMIR ===================
procedure TFLArticulos.BitBtn2Click(Sender: TObject);
begin
  //-------------------------- Tarifas
  if rbTarifas.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbSeleccion;
     {$IFDEF LINUX}
//**       frReport1.LoadFromFile('/usr/share/facturlinex2/Report/TarifaArticulos.lrf');
       frReport1.LoadFromFile(RutaReports+'TarifaArticulos.lrf');
     {$ELSE}
       frReport1.LoadFromFile(ExtractFilePath(ParamStr(0))+'Report\TarifaArticulos.lrf');
     {$ENDIF}
     frReport1.ShowReport;
     //frReport1.DesignReport;
    end;
  //-------------------------- Datos Principales
  if RadioButton1.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     {$IFDEF LINUX}
//**       frReport1.LoadFromFile('/usr/share/facturlinex2/Report/ListadoArticulosStock.lrf');
       frReport1.LoadFromFile(RutaReports+'ListadoArticulosStock.lrf');
     {$ELSE}
       frReport1.LoadFromFile(ExtractFilePath(ParamStr(0))+'Report\ListadoArticulosStock.lrf');
     {$ENDIF}
     frReport1.ShowReport;
     //frReport1.DesignReport;
    end;
 //--------------------------_ LISTADO DE ARTICULOS POR FAMILIA
 if RadioButton2.Checked=True then
   begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoArticulosFamilia.lrf');
     frReport1.ShowReport;
    end;

  //--------------------------_ LISTADO DE ARTICULOS POR PROVEEDOR
  if RadioButton3.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoArticulosProveedor.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- LISTADO DE VENTAS POR ARTICULOS
  if RadioButton4.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoArticulosVentas.lrf');
     frReport1.ShowReport;
    end;
      //-------------------------- LISTADO DE COMPRAS POR ARTICULOS
  if RadioButton5.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoArticulosCompras.lrf');
     frReport1.ShowReport;
    end;
    //-------------------------- ESTADISTICA DE ARTICULOS POR FAMILIA
  if RadioButton6.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoArticulosEstadisFami.lrf');
     frReport1.ShowReport;
    end;
    //-------------------------- ESTADISTICA DE ARTICULOS POR AUTOR/FABRICANTE
  if RadioButton7.Checked=True then
     begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoArticulosEstadisAutFab.lrf');
     frReport1.ShowReport;
    end;
    //-------------------------- ESTADISTICA DE ARTICULOS POR PROVEEDOR
    if RadioButton8.Checked=True then
     begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoArticulosEstadisProv.lrf');
     frReport1.ShowReport;
    end;

end;
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFLArticulos.frReport1GetValue(const ParName: String;
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
  if ParName='Campo1' then ParValue := TituloCampos[0];
  if ParName='Campo2' then ParValue := TituloCampos[1];
  if ParName='Campo3' then ParValue := TituloCampos[2];
  if ParName='Campo4' then ParValue := TituloCampos[3];
  if ParName='Campo5' then ParValue := TituloCampos[4];
end;
//======================= LOGOTIPO DEL FORMULARIO ========================
procedure TFLArticulos.frReport1EnterRect(Memo: TStringList; View: TfrView);
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

procedure TFLArticulos.rbTarifasChange(Sender: TObject);
begin
 PanelDesdeHasta.Visible:=True;
 PanelFechaDesdeHasta.Visible:=False;
 PanelSelectAno.Visible:=False;
 PanelCambiable.Visible:=False;
 PanelCambiable1.Visible:=True;
 PanelStock.Visible:=False;
 PanelTarifas.Visible:=True;
 OcultarBDGrid();
 EditCambiableCodigo.Text:='';
 StaticTextCambiableNombre.Caption:='';
end;

procedure TFLArticulos.RadioButton1Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelFechaDesdeHasta.Visible:=False;
   PanelSelectAno.Visible:=False;
   PanelCambiable.Visible:=False;
   PanelCambiable1.Visible:=True;
   PanelStock.Visible:=True;
   PanelTarifas.Visible:=False;
   OcultarBDGrid();
   EditCambiableCodigo.Text:='';
   StaticTextCambiableNombre.Caption:='';
end;

procedure TFLArticulos.RadioButton2Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelFechaDesdeHasta.Visible:=False;
   PanelSelectAno.Visible:=False;
   PanelCambiable.Visible:=True;
   PanelCambiable1.Visible:=True;
   PanelStock.Visible:=True;
   PanelTarifas.Visible:=False;
   LabelCambiable.Caption:='Familia';
   OcultarBDGrid();
   EditCambiableCodigo.Text:='';
   StaticTextCambiableNombre.Caption:='';
end;

procedure TFLArticulos.RadioButton3Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelFechaDesdeHasta.Visible:=False;
   PanelSelectAno.Visible:=False;
   PanelCambiable.Visible:=True;
   PanelCambiable1.Visible:=True;
   PanelStock.Visible:=True;
   PanelTarifas.Visible:=False;
   LabelCambiable.Caption:='Proveedor';
   OcultarBDGrid();
   EditCambiableCodigo.Text:='';
   StaticTextCambiableNombre.Caption:='';
end;

procedure TFLArticulos.RadioButton4Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelFechaDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelCambiable1.Visible:=True;
   PanelCambiable.Visible:=False;
   PanelStock.Visible:=False;
   PanelTarifas.Visible:=False;
   OcultarBDGrid();
   EditCambiableCodigo.Text:='';
   StaticTextCambiableNombre.Caption:='';
end;

procedure TFLArticulos.RadioButton5Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelFechaDesdeHasta.Visible:=True;
   PanelSelectAno.Visible:=False;
   PanelCambiable1.Visible:=True;
   PanelCambiable.Visible:=False;
   PanelStock.Visible:=False;
   PanelTarifas.Visible:=False;
   OcultarBDGrid();
   EditCambiableCodigo.Text:='';
   StaticTextCambiableNombre.Caption:='';
end;

procedure TFLArticulos.RadioButton6Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelFechaDesdeHasta.Visible:=False;
   if RadioButton6.Checked=True then
    begin
      RellenaListBoxAnos('SELECT DISTINCT(TA1) FROM estaarti'+Tienda,dbAnos, PanelSelectAno, ListBoxAnos);
    end;
   PanelCambiable1.Visible:=True;
   PanelCambiable.Visible:=True;
   PanelStock.Visible:=False;
   PanelTarifas.Visible:=False;
   LabelCambiable.Caption:='Familia';
   OcultarBDGrid();
   EditCambiableCodigo.Text:='';
   StaticTextCambiableNombre.Caption:='';
end;

procedure TFLArticulos.RadioButton7Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelFechaDesdeHasta.Visible:=False;
   if RadioButton7.Checked=True then
    begin
      RellenaListBoxAnos('SELECT DISTINCT(TA1) FROM estaarti'+Tienda,dbAnos, PanelSelectAno, ListBoxAnos);
    end;
   PanelCambiable1.Visible:=True;
   PanelCambiable.Visible:=True;
   PanelStock.Visible:=False;
   PanelTarifas.Visible:=False;
   LabelCambiable.Caption:='Autor/Fabr.';
   OcultarBDGrid();
   EditCambiableCodigo.Text:='';
   StaticTextCambiableNombre.Caption:='';
end;

procedure TFLArticulos.RadioButton8Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelFechaDesdeHasta.Visible:=False;
   if RadioButton8.Checked=True then
    begin
      RellenaListBoxAnos('SELECT DISTINCT(TA1) FROM estaarti'+Tienda,dbAnos, PanelSelectAno, ListBoxAnos);
    end;
   PanelCambiable1.Visible:=True;
   PanelCambiable.Visible:=True;
   PanelStock.Visible:=False;
   PanelTarifas.Visible:=False;
   LabelCambiable.Caption:='Proveedor';
   OcultarBDGrid();
   EditCambiableCodigo.Text:='';
   StaticTextCambiableNombre.Caption:='';
end;

//======================= OCULTA TODOS LOS DBGird y su Titulo
procedure TFLArticulos.OcultarBDGrid();
  begin
    dbgTarifa.Visible:=False;
    DBGrid1.Visible:=False;
    DBGrid2.Visible:=False;
    DBGrid3.Visible:=False;
    DBGrid4.Visible:=False;
    DBGrid5.Visible:=False;
    DBGrid6.Visible:=False;
    DBGrid7.Visible:=False;
    DBGrid8.Visible:=False;

    LabelTituloDBGrid.Caption:='';
    DimensionarColocarBDGrid();
  end;
//======================= DIMENSIONA LOS DBGrid
// Los DBGrid estan "minimizados" (50x50) para poder trabajar en el resto del
// formulario, con esta funcion los adapto al Panel donde se encuentran
procedure TFLArticulos.DimensionarColocarBDGrid();
  begin
    dbgTarifa.Align:=alClient;
    DBGrid1.Align:=alClient;
    DBGrid2.Align:=alClient;
    DBGrid3.Align:=alClient;
    DBGrid4.Align:=alClient;
    DBGrid5.Align:=alClient;
    DBGrid6.Align:=alClient;
    DBGrid7.Align:=alClient;
    DBGrid8.Align:=alClient;
  end;

//-------- Al pulsar en el titulo de la columna ordenar por ella
procedure TFLArticulos.DBGrid1TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid1,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLArticulos.DBGrid2TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid2,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLArticulos.DBGrid3TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid3,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLArticulos.DBGrid4TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid4,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLArticulos.DBGrid5TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid5,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLArticulos.DBGrid6TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid6,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLArticulos.DBGrid7TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid7,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLArticulos.DBGrid8TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid8,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;

procedure TFLArticulos.dbgTarifaTitleClick(Column: TColumn);
begin
  Colorea(Column,dbgTarifa,dbSeleccion, AntColun, Orden, TituloColumn, Ordenado);
end;

//========= Boton de busqueda del panel cambiable y seleccion del nombre elejido
procedure TFLArticulos.BitBtnCambiable1Click(Sender: TObject);
var
 TxtQuery: String;
begin
 TxtQuery:='SELECT T0, T1 FROM tiendas ORDER BY T1';
 CargaValoresEnComboCambiable(TxtQuery, ComboCambiableNombre1, dbCambiable, LabelCambiable1);
end;

procedure TFLArticulos.BitBtnCambiableClick(Sender: TObject);
var
 TxtQuery: String;
 numero: integer;
begin
  if LabelCambiable.Caption='Autor/Fabr.' then
    TxtQuery:='SELECT AUT0, AUT1 FROM autofabri ORDER BY AUT1'
  else if LabelCambiable.Caption='Familia' then
    TxtQuery:='SELECT F0, F1 FROM familias'+Tienda+' ORDER BY F1'
  else if LabelCambiable.Caption='Proveedor' then
   begin
      try
         numero := strtoint(EditCambiableCodigo.Text);
         TxtQuery:='SELECT P0, P1 FROM proveedores where P1 ORDER BY P1';
      except
         TxtQuery:='SELECT P0, P1 FROM proveedores where P1 like "%'+EditCambiableCodigo.Text+'%" ORDER BY P1';
      end;
   end;
  CargaValoresEnComboCambiable(TxtQuery, ComboCambiableNombre, dbCambiable, LabelCambiable);
end;

// Tarifa por familia.
procedure TFLArticulos.chbPorFamiliaChange(Sender: TObject);
begin
  if chbPorFamilia.Checked then
  begin
    edCodigoFamilia.Enabled:=True; edFamilia.Enabled:=True; btFamilia.Enabled:=True;
    edCodigoFamilia.SetFocus;
  end else
  begin
    edCodigoFamilia.Enabled:=False; edFamilia.Enabled:=False; btFamilia.Enabled:=False;
  end;
end;

// Tarifa por proveedor.
procedure TFLArticulos.chbPorProveedorChange(Sender: TObject);
begin
  if chbPorProveedor.Checked then
  begin
    edCodigoProveedor.Enabled:=True; edProveedor.Enabled:=True; btProveedor.Enabled:=True;
    edCodigoProveedor.SetFocus;
  end else
  begin
    edCodigoProveedor.Enabled:=False; edProveedor.Enabled:=False; btProveedor.Enabled:=False;
  end;
end;

procedure TFLArticulos.ComboCambiableNombre1Click(Sender: TObject);
begin
  EscogeNombreComboCambiable( 'T1', ComboCambiableNombre1, dbCambiable, EditCambiableCodigo1, StaticTextCambiableNombre1)
end;

procedure TFLArticulos.ComboCambiableNombre1KeyPress(Sender: TObject;
  var Key: char);
begin
  if key=#13 then ComboCambiableNombre1Click(ComboCambiableNombre1);
end;

procedure TFLArticulos.ComboCambiableNombreClick(Sender: TObject);
var TxtCampo: string;
begin
  if LabelCambiable.Caption='Autor/Fabr.' then TxtCampo:='AUT1'
  else if LabelCambiable.Caption='Familia' then TxtCampo:='F1'
  else if LabelCambiable.Caption='Proveedor' then TxtCampo:='P1';
  EscogeNombreComboCambiable( TxtCampo, ComboCambiableNombre, dbCambiable, EditCambiableCodigo, StaticTextCambiableNombre)
end;

procedure TFLArticulos.ComboCambiableNombreKeyPress(Sender: TObject;
  var Key: char);
begin
  if key=#13 then ComboCambiableNombreClick(ComboCambiableNombre);
end;

//======================= Despues de introducir un codigo, al salir, si existe,
//======================= completa el StaticText con el nombre oportuno
procedure TFLArticulos.EditCambiableCodigo1Exit(Sender: TObject);
var
 TxtQuery: String;
begin
  TxtQuery:='SELECT T1 FROM tiendas WHERE T0="'+EditCambiableCodigo1.Text+'"';
  if EditCambiableCodigo1.Text<>'' then
    begin
     RellenaPanelCambiableN(TxtQuery,dbCambiable, StaticTextCambiableNombre1);
     if dbCambiable.RecordCount=0 then
       begin
         Showmessage('NO HAY '+LabelCambiable1.Caption+' CON ESE CODIGO');
         EditCambiableCodigo1.Text:='';
         exit;
       end;
    end;
end;

procedure TFLArticulos.EditCambiableCodigoExit(Sender: TObject);
var
 TxtQuery: String;
begin
  if LabelCambiable.Caption='Autor/Fabr.' then
    TxtQuery:='SELECT AUT1 FROM autofabri WHERE AUT0="'+EditCambiableCodigo.Text+'"'
  else if LabelCambiable.Caption='Familia' then
    TxtQuery:='SELECT F1 FROM familias'+tienda+' WHERE F0="'+EditCambiableCodigo.Text+'"'
  else if LabelCambiable.Caption='Proveedor' then
    TxtQuery:='SELECT P1 FROM proveedores WHERE P0="'+EditCambiableCodigo.Text+'"';

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

procedure TFLArticulos.EditCambiableCodigo1Enter(Sender: TObject);
begin
  StaticTextCambiableNombre1.Caption:='';
end;

procedure TFLArticulos.EditCambiableCodigoEnter(Sender: TObject);
begin
  StaticTextCambiableNombre.Caption:='';
end;

//----------------   tarifas a la carta ------------------------------
procedure TFLArticulos.SeleccionaTarifas(Sender: TObject);
var
  TxtQuery: String;
  nContador, nColumnas, nCampos, nTituloCampos: Integer;
  TituloColumnas: array of String;    // Nombre columnas del grid de tarifas.
  Inutil,ValorCero: String;                  // Cláusula para que no sean valor cero los precios.
  ExistenTarifas: Boolean;
  OperadorWhere: String;

begin
   SetLength(TituloCampos, 5);
   for nTituloCampos:=0 to 4 do TituloCampos[nTituloCampos]:='';
   nTituloCampos:=-1;  // Inicializamos contador de columnas para el report

   OperadorWhere:='';

   dbQuery.Active:=False;
   dbQuery.SQL.Text:='DROP TABLE IF EXISTS tmptarifa';
   dbQuery.ExecSQL;
   TxtQuery :='CREATE TEMPORARY TABLE tmptarifa ('+
            'TF0 CHAR(13) NOT NULL, TF1 CHAR(50),'+       // Cod. y Nombre
            'TF2 DOUBLE(10,2) NOT NULL DEFAULT 0.00,'+  // pvp
            'TF3 DOUBLE(10,2) NOT NULL DEFAULT 0.00,'+  // pvp sin iva
            'TF4 DOUBLE(10,2) NOT NULL DEFAULT 0.00,'+  // tarifa 1
            'TF5 DOUBLE(10,2) NOT NULL DEFAULT 0.00,'+  // tarifa 1 sin iva
            'TF6 DOUBLE(10,2) NOT NULL DEFAULT 0.00,'+  // tarifa 2
            'TF7 DOUBLE(10,2) NOT NULL DEFAULT 0.00,'+  // tarifa 2 sin iva
            'TF8 DOUBLE(10,2) NOT NULL DEFAULT 0.00,'+  // tarifa 3
            'TF9 DOUBLE(10,2) NOT NULL DEFAULT 0.00,'+  // tarifa 3 sin iva
            'TF10 DOUBLE(10,2) NOT NULL DEFAULT 0.00,'+  //  Coste
            'PRIMARY KEY klft (TF0), UNIQUE (TF0), INDEX klft (TF0))'+
            ' ENGINE=MyISAM DEFAULT CHARSET=utf8';

    dbQuery.Sql.Text:= TxtQuery;
    dbQuery.ExecSql;

    ValorCero:=' AND (';                // Inicializamos el filtro para los valores a cero
    nColumnas:=1;
    SetLength(TituloColumnas, 11);
    TituloColumnas[nColumnas]:='Código';
    Inc(nColumnas);
    TituloColumnas[nColumnas]:='Referencia';

    TituloGrid:='LISTADO DE TARIFAS';
    txtQuery:='SELECT A0, A1';

    if chbPvp.Checked=True then
    begin
     TxtQuery:= TxtQuery + ',A2';Inc(nColumnas);TituloColumnas[nColumnas]:='PVP';
     ValorCero:= ValorCero+' A2<>0 OR';
     Inc(nTituloCampos); TituloCampos[nTituloCampos]:='PVP';
     if chbSinIva.Checked then
     begin TxtQuery:= TxtQuery + ',A21';Inc(nColumnas);TituloColumnas[nColumnas]:='PVP s/iva';end;
    end;

    if chbTarifa1.Checked=True then
    begin
     TxtQuery:= TxtQuery + ',TAR7';Inc(nColumnas);TituloColumnas[nColumnas]:='Tarifa 1';
     ValorCero:= ValorCero + ' TAR7<>0 OR';
     Inc(nTituloCampos); TituloCampos[nTituloCampos]:='Tarifa 1';
     if chbSinIva.Checked then
     begin TxtQuery:= TxtQuery + ',TAR2';Inc(nColumnas);TituloColumnas[nColumnas]:='Tarifa 1 s/iva';end;
    end;

    if chbTarifa2.Checked=True then
    begin
     TxtQuery:= TxtQuery + ',TAR8';Inc(nColumnas);TituloColumnas[nColumnas]:='Tarifa 2';
     ValorCero:= ValorCero + ' TAR8<>0 OR';
     Inc(nTituloCampos); TituloCampos[nTituloCampos]:='Tarifa 2';
     if chbSinIva.Checked then
     begin TxtQuery:= TxtQuery + ',TAR4';Inc(nColumnas);TituloColumnas[nColumnas]:='Tarifa 2 s/iva';end;
    end;

    if chbTarifa3.Checked=True then
     begin
      TxtQuery:= TxtQuery + ',TAR9';Inc(nColumnas);TituloColumnas[nColumnas]:='Tarifa 3';
      ValorCero:= ValorCero + ' TAR9<>0';
      Inc(nTituloCampos); TituloCampos[nTituloCampos]:='Tarifa 3';
     if chbSinIva.Checked then
     begin TxtQuery:= TxtQuery + ',TAR6';Inc(nColumnas);TituloColumnas[nColumnas]:='Tarifa 3 s/iva';end;
    end;

    Inutil:= ValorCero; Delete(Inutil, 1, Length(Inutil)-2 );
    if  Inutil='OR' then Delete(ValorCero,Length(ValorCero)-2, Length(ValorCero));
    ValorCero:=ValorCero + ')';

    if chbCoste.Checked=True then
     begin
     TxtQuery:= TxtQuery + ',A24';Inc(nColumnas);TituloColumnas[nColumnas]:='Coste';
     Inc(nTituloCampos); TituloCampos[nTituloCampos]:='Coste';
     end;

    TxtQuery:= TxtQuery +' from artitien'+Tienda+' LEFT JOIN tarifas ON TAR0=A0 WHERE ';
    if (Edit1.Text<>'') OR (Edit2.Text<>'') then
     begin
       TxtQuery := TxtQuery + ' (A0 >= "'+Edit1.Text+'" AND A0 <= "'+Edit2.Text+'" )';
       OperadorWhere:=' AND ';
     end;

    if (Edit3.Text<>'') OR (Edit4.Text<>'') then
    begin
       TxtQuery := TxtQuery + OperadorWhere + '(A1>="'+Edit3.Text+'" AND A1<="'+Edit4.Text+'")';
       OperadorWhere:=' AND ';
    end;
    if (chbPorProveedor.Checked=True) and (edCodigoProveedor.Text<>'') then
    begin
       TxtQuery:=TxtQuery + OperadorWhere + 'A32='+edCodigoProveedor.Text;
       OperadorWhere:=' AND ';
    end;

    if (chbPorFamilia.Checked=True) and (edCodigoFamilia.Text<>'') then
    begin
       TxtQuery:=TxtQuery + OperadorWhere + 'A14='+edCodigoFamilia.Text;
       OperadorWhere:=' AND ';
    end;

    if (chbSinPrecio.Checked=True) and (ValorCero<>' AND ()') then TxtQuery:=TxtQuery+ValorCero;

//    showmessage(TxtQuery);
    dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
    if dbQuery.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;

    dbSeleccion.Active:=False;
    dbSeleccion.SQL.Text:='SELECT * FROM tmptarifa ORDER BY TF0';
    dbSeleccion.Active:=True;

    if (sender<>btManual) then
    begin
     nContador:=1;
     dbQuery.First;

     while not dbQuery.EOF do
     begin
        dbSeleccion.Append;
        for nCampos:=1 to dbQuery.FieldCount do
        begin
//        showmessage(IntToStr(nCampos) +' '+ dbQuery.Fields.FieldByNumber(nCampos).AsString);
        if dbQuery.Fields.FieldByNumber(nCampos).AsString= '' then
         dbSeleccion.Fields.FieldByNumber(ncampos).Value :='0'
        else
         dbSeleccion.Fields.FieldByNumber(ncampos).Value :=dbQuery.Fields.FieldByNumber(nCampos).AsString;

        end;

        if dbQuery.FieldCount<> dbSeleccion.FieldCount then
           for nCampos:=(dbQuery.FieldCount+2) to dbSeleccion.FieldCount do dbSeleccion.Fields.FieldByNumber(ncampos).Value :='0';

        dbSeleccion.Post;

        Inc(nContador);
        dbQuery.Next;
     end;

    end;
    if StaticTextCambiableNombre.Caption <> '' then
     TituloGrid:= TituloGrid + ' ('+ StaticTextCambiableNombre.Caption+') ';
     for nContador:=0 to nColumnas-1 do
     begin
       dbgTarifa.Columns.Items[nContador].Title.Caption:= TituloColumnas[nContador+1];
     end;
end;

//  Seleccion de proveedor para tarifas
procedure TFLArticulos.edCodigoProveedorExit(Sender: TObject);
begin
   if edCodigoProveedor.Text='' then Exit;
   if not (EsFloat(edCodigoProveedor.Text)) then begin edCodigoProveedor.Text:='0'; edCodigoProveedor.SetFocus; exit; end;
   dbTrabajo.Active:=False;
   dbTrabajo.SQL.Text:='SELECT * FROM proveedores WHERE P0='+edCodigoProveedor.Text;
   dbTrabajo.Active:=True;
   If dbTrabajo.RecordCount=0 then
                               Begin
                                 btProveedorClick(self);
                                 edProveedor.SetFocus; Exit;
                               End;
   edProveedor.Text:=dbTrabajo.FieldByName('P1').AsString;
end;

procedure TFLArticulos.edProveedorExit(Sender: TObject);
begin
    if edProveedor.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); edProveedor.SetFocus; Exit; end;
  dbTrabajo.SQL.Text:='SELECT P0,P1 FROM proveedores WHERE P1="'+edProveedor.Text+'"'; dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then
                             begin
                               edCodigoProveedor.Text:=FBusquedas.IniciaBusquedas('SELECT P0,P1,P6 FROM proveedores WHERE P1 LIKE "%'+edProveedor.Text+'%"',
                                                         ['Código', 'Proveedor', 'N.I.F.'],'P0');
                               edCodigoProveedorExit(self);
                               Exit;
                              end;
  edCodigoProveedor.Text:=dbTrabajo.FieldByName('P0').AsString;
  edCodigoProveedorExit(self);
end;

procedure TFLArticulos.edProveedorKeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) then edProveedorExit(self);
  Exit;
end;

procedure TFLArticulos.btProveedorClick(Sender: TObject);
begin
   edCodigoProveedor.Text:=FBusquedas.IniciaBusquedas('SELECT P0,P1,P6 FROM proveedores',['Código','Proveedor','N.I.F.'],'P0');
   edProveedor.SetFocus;
   edCodigoProveedorExit(self);
end;

//  Seleccion de familias para tarifas
procedure TFLArticulos.edCodigoFamiliaExit(Sender: TObject);
begin
   if edCodigoFamilia.Text='' then Exit;
   if not (EsFloat(edCodigoFamilia.Text)) then begin edCodigoFamilia.Text:='0'; edCodigoFamilia.SetFocus; exit; end;
   dbTrabajo.Active:=False;
   dbTrabajo.SQL.Text:='SELECT * FROM familias'+tienda+' WHERE F0='+edCodigoFamilia.Text;
   dbTrabajo.Active:=True;
   If dbTrabajo.RecordCount=0 then
                               Begin
                                 btFamiliaClick(self);
                                 edFamilia.SetFocus; Exit;
                               End;
   edFamilia.Text:=dbTrabajo.FieldByName('F1').AsString;
end;

procedure TFLArticulos.edFamiliaExit(Sender: TObject);
begin
    if edFamilia.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); edFamilia.SetFocus; Exit; end;
  dbTrabajo.SQL.Text:='SELECT F0,F1 FROM familias'+tienda+' WHERE F1="'+edFamilia.Text+'"'; dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then
                             begin
                               edCodigoFamilia.Text:=FBusquedas.IniciaBusquedas('SELECT F0,F1 FROM familias'+tienda+' WHERE F1 LIKE "%'+edFamilia.Text+'%"',
                                                         ['Código', 'Familia'],'F0');
                               edCodigoFamiliaExit(self);
                               Exit;
                              end;
  edCodigoFamilia.Text:=dbTrabajo.FieldByName('F0').AsString;
  edCodigoFamiliaExit(self);
end;

procedure TFLArticulos.edFamiliaKeyPress(Sender: TObject; var Key: char);
begin
  if (Key=#13) then edFamiliaExit(self);
  Exit;
end;

procedure TFLArticulos.btFamiliaClick(Sender: TObject);
begin
   edCodigoFamilia.Text:=FBusquedas.IniciaBusquedas('SELECT F0,F1 FROM familias'+tienda+' WHERE F1 LIKE "%'+edFamilia.Text+'%"',['Código','Familia'],'F0');
   edFamilia.SetFocus;
   edCodigoFamiliaExit(self);
end;

procedure TFLArticulos.btSeleccionFiltrarClick(Sender: TObject);
var
 nContador: Integer;
 nCampos: Integer;
begin
  dbQuery.First;

  dbSeleccion.Active:=False;
  dbSeleccion.SQL.Text:='SELECT * FROM tmptarifa ORDER BY TF0';
  dbSeleccion.Active:=True;

  for nContador:= 0 to clbSeleccionManual.Count-1 do
     begin
         if (clbSeleccionManual.Checked[nContador]) then
          begin
          dbSeleccion.Append;
          for nCampos:=1 to dbQuery.FieldCount do
          begin
           if dbQuery.Fields.FieldByNumber(nCampos).AsString= '' then
              dbSeleccion.Fields.FieldByNumber(ncampos).Value :='0'
           else
            dbSeleccion.Fields.FieldByNumber(ncampos).Value := dbQuery.Fields.FieldByNumber(nCampos).AsString;
           end;

          if dbQuery.FieldCount<> dbSeleccion.FieldCount then
          for nCampos:=(dbQuery.FieldCount+1) to dbSeleccion.FieldCount do dbSeleccion.Fields.FieldByNumber(ncampos).Value :='0';

          dbSeleccion.Post;
         end;

          dbQuery.Next;
     end;

  dbQuery.Active:=False;                  // Cambiamos los datos del query a los seleccionados.
  dbQuery.SQL.Text:='SELECT * FROM tmptarifa ORDER BY TF0';
  dbQuery.Active:=True;

  pSeleccionManual.Visible:=False;
  BitBtn1Click(Self);
end;

procedure TFLArticulos.btSeleccionInvertirClick(Sender: TObject);
var
  cont: integer;
begin
  for cont:=0 to clbSeleccionManual.Count-1 do
  begin
       if clbSeleccionManual.Checked[cont]=True then
          clbSeleccionManual.Checked[cont]:=False else clbSeleccionManual.Checked[cont]:=True;
  end;
end;

procedure TFLArticulos.btSeleccionSalirClick(Sender: TObject);
begin
   pSeleccionManual.Visible:=False;
   BitBtn3Click(self);
end;

procedure TFLArticulos.btSeleccionTodosClick(Sender: TObject);
var
  cont: integer;
begin
  for cont:=0 to clbSeleccionManual.Count-1 do
        clbSeleccionManual.Checked[cont]:=True;

end;

procedure TFLArticulos.btManualClick(Sender: TObject);
begin
 SeleccionaTarifas(btManual);

 clbSeleccionManual.Clear;
 while not dbQuery.EOF do
 begin
    clbSeleccionManual.Items.Add(dbQuery.Fields[0].AsString+' '+dbQuery.Fields[1].AsString);
    dbQuery.Next;
 end;
 pSeleccionManual.Visible:=True; clbSeleccionManual.SetFocus;
end;

Procedure TFLArticulos.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

procedure TFLArticulos.FormShow(Sender: TObject);
begin
     //---------------------Paneles visibles por defecto, los de rbTarifas
   PanelDesdeHasta.Visible:=True;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiable.Visible:=False;
   PanelCambiable1.Visible:=True;
   PanelStock.Visible:=False;
   PanelTarifas.Visible:=True;
   rbTarifas.Checked:=True;
end;


Initialization
  {$I listaarticulos.lrs}

End.

