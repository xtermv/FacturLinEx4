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

Unit listaproveedores;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset, DBGrids,
  StdCtrls, db, LR_DBSet, LR_Class, ExtDlgs, EditBtn, Grids;

Type

  { TFLProveedores }

  TFLProveedores = Class(Tform)
    BitBtnCambiable: TBitBtn;
    BitBtnCambiable1: TBitBtn;
    ComboCambiableNombre: TComboBox;
    ComboCambiableNombre1: TComboBox;
    DateEditDesde: TDateEdit;
    DateEditHasta: TDateEdit;
    dbCambiable: TZQuery;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    DBGrid5: TDBGrid;
    dbVencimientos: TZQuery;
    Edit1: TEdit;
    Edit2: TEdit;
    EditCambiableCodigo: TEdit;
    EditCambiableCodigo1: TEdit;
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
    Edit3: TEdit;
    Edit30: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
    Edit4: TEdit;
    Bevel1: TBevel;
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
    Label4: TLabel;
    Label5: TLabel;
    LabelCambiable: TLabel;
    LabelCambiable1: TLabel;
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
    PanelCambiable1: TPanel;
    PanelFechaDesdeHasta: TPanel;
    PanelDesdeHasta: TPanel;
    PanelTituloGrid: TPanel;
    RadioButton1: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton5: TRadioButton;
    StaticTextCambiableNombre: TStaticText;
    StaticTextCambiableNombre1: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtnCambiable1Click(Sender: TObject);
    procedure BitBtnCambiableClick(Sender: TObject);
    procedure ComboCambiableNombre1Click(Sender: TObject);
    procedure ComboCambiableNombre1KeyPress(Sender: TObject; var Key: char);
    procedure ComboCambiableNombreClick(Sender: TObject);
    procedure ComboCambiableNombreKeyPress(Sender: TObject; var Key: char);
    procedure DateEditDesdeExit(Sender: TObject);
    procedure DateEditHastaExit(Sender: TObject);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure DBGrid3DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid3TitleClick(Column: TColumn);
    procedure DBGrid4TitleClick(Column: TColumn);
    procedure DBGrid5TitleClick(Column: TColumn);
    procedure EditCambiableCodigo1Enter(Sender: TObject);
    procedure EditCambiableCodigo1Exit(Sender: TObject);
    procedure EditCambiableCodigoEnter(Sender: TObject);
    procedure EditCambiableCodigoExit(Sender: TObject);

    Procedure Formcreate(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);
    //procedure Colorea(Column: TColumn;Grid: TDBGrid;dbColor: TZQuery);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton5Change(Sender: TObject);
    //procedure RellenaListBoxAnos(TxtQuery: String);
    procedure DBGrid1TitleClick(Column: TColumn);
    //procedure BlancoGrid(Grid: TDBGrid);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure RadioButton3Change(Sender: TObject);
    procedure RadioButton4Change(Sender: TObject);
    
    procedure OcultarBDGrid();
    procedure DimensionarColocarBDGrid();

  Private
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormlistaproveedores;
  
Var
  FLProveedores: TFLProveedores;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;

Implementation

uses
  Global, Funciones, busquedas;

//=============== Crea el formulario ================
procedure ShowFormlistaproveedores;
begin
  with TFLProveedores.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFLProveedores.Formcreate(Sender: Tobject);

Begin
//Conectate(dbConect);    // Utilizamos datamodule1.dbConexión para toda la aplicación.

   //---------------------Paneles visibles por defecto, los de RadioButton1Change
   PanelDesdeHasta.Visible:=True;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiable.Visible:=False;
   PanelCambiable1.Visible:=False;
   OcultarBDGrid();

   BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
   DateEditDesde.Date:=Date;
   DateEditHasta.Date:=Date;

   LabelCambiable.Caption:='Tienda';
   LabelCambiable1.Caption:='Proveedor';
   
   //Dimensionamos, colocamos y cocultamos todos los DBGrid
   DimensionarColocarBDGrid();
   OcultarBDGrid();
End;

//==================== CERRAR ======================
procedure TFLProveedores.BitBtn4Click(Sender: TObject);
begin
  dbQuery.Active:=False;
  Close();
end;

//==================== VISUALIZAR ===================
procedure TFLProveedores.BitBtn1Click(Sender: TObject);
Var
  //TituloCampos: array[1..3] of string;
  TxtQuery: String;
begin
  AntColun:='0';Ordenado:=False;
  BitBtn2.Enabled:=True; BitBtn3.Enabled:=True;
  if EditCambiableCodigo.Text<>'' then Tienda:=DataModule1.LFill(EditCambiableCodigo.Text,4,'0')
  else
   begin
    EditCambiableCodigo.Text:= Tienda;
    EditCambiableCodigoExit(EditCambiableCodigo);
   end;
  //-------------------------- LISTADO DE PROVEEDORES
  if RadioButton1.Checked=True then
    begin
      TituloGrid:='LISTADO DE PROVEEDORES';
      TxtQuery := 'SELECT * FROM proveedores WHERE';
      if Edit1.Text<>'' then
        TxtQuery:=TxtQuery + ' P0>='+Edit1.Text+' AND';
      if Edit2.Text<>'' then
        TxtQuery:=TxtQuery + ' P0<='+Edit2.Text+' AND';
      TxtQuery:=TxtQuery + ' MID(P1,1,'+IntToStr(Length(Edit3.text))+')>="'+Edit3.Text+
                      '" AND MID(P1,1,'+IntToStr(Length(Edit4.Text))+')<="'+Edit4.Text+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY P0, P1';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
    end;
 //--------------------------_ LISTADO DE FACTURAS RECIBIDAS
  if RadioButton2.Checked=True then
    begin
      TituloGrid:='LISTADO DE FACTURAS RECIBIDAS';
      TxtQuery := 'SELECT * FROM hipedicc'+Tienda+' WHERE ';
      TxtQuery := TxtQuery + ' HPC28 = "F"'; // Filtrado para que solo aparezcan las facturas
      TxtQuery := TxtQuery + ' AND HPC1>="'+FormatDateTime('YYYY/MM/DD',DateEditDesde.Date)+'" AND HPC1<="'+FormatDateTime('YYYY/MM/DD',DateEditHasta.Date)+'"';
      If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND HPC0='+EditCambiableCodigo.Text;
      If EditCambiableCodigo1.Text<>'' then TxtQuery := TxtQuery + ' AND HPC2='+EditCambiableCodigo1.Text;
      if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
      else
       TxtQuery:=TxtQuery + ' ORDER BY HPC1,HPC2';

     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     DBGrid2.BringToFront; DBGrid2.Visible:=True;
    end;
  //--------------------------_ LISTADO DE VENCIMIENTO DE PAGOS

  if RadioButton3.Checked=True then
    begin
      TituloGrid:='LISTADO DE VENCIMIENTOS DE PAGOS';
      TxtQuery := 'SELECT HPC1,HPC2,HPC29,HPC20,HPC21,HPC22,HPC23,HPC24,HPC25,HPC26, HPC27, P0, P1 FROM hipedicc'+Tienda+', proveedores WHERE';
      TxtQuery := TxtQuery + '( HPC20>="'+FormatDateTime('YYYY/MM/DD',DateEditDesde.Date)+'" AND HPC20<="'+FormatDateTime('YYYY/MM/DD',DateEditHasta.Date)+'"';// AND HPC21 <> 0';
      TxtQuery := TxtQuery + ' OR HPC22>="'+FormatDateTime('YYYY/MM/DD',DateEditDesde.Date)+'" AND HPC22<="'+FormatDateTime('YYYY/MM/DD',DateEditHasta.Date)+'"';// AND HPC23 <> 0';
      TxtQuery := TxtQuery + ' OR HPC24>="'+FormatDateTime('YYYY/MM/DD',DateEditDesde.Date)+'" AND HPC24<="'+FormatDateTime('YYYY/MM/DD',DateEditHasta.Date)+'"';// AND HPC25 <> 0';
      TxtQuery := TxtQuery + ' OR HPC26>="'+FormatDateTime('YYYY/MM/DD',DateEditDesde.Date)+'" AND HPC26<="'+FormatDateTime('YYYY/MM/DD',DateEditHasta.Date)+'")';// AND HPC27 <> 0 )';
      TxtQuery := TxtQuery + ' AND P0 = HPC2 AND HPC28 = "F"'; // Filtrado para que solo aparezcan las facturas
      If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND HPC0='+EditCambiableCodigo.Text;
      If EditCambiableCodigo1.Text<>'' then TxtQuery := TxtQuery + ' AND HPC2='+EditCambiableCodigo1.Text;
      if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
      else
       TxtQuery:=TxtQuery + ' ORDER BY HPC1,HPC2';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     DBGrid3.BringToFront; DBGrid3.Visible:=True;
    end;
  //-------------------------- LISTADO DE COMPRAS REALIZADAS
  if RadioButton4.Checked=True then
    begin
      TituloGrid:='LISTADO DE COMPRAS REALIZADAS';
      TxtQuery:=' SELECT HPC0,HPC1,HPC2,HPC7,HPC9,HPC29,HPC30,P0,P1 from hipedicc'+Tienda+', proveedores WHERE';
      TxtQuery := TxtQuery + ' HPC1>="'+FormatDateTime('YYYY/MM/DD',DateEditDesde.Date)+'" AND HPC1<="'+FormatDateTime('YYYY/MM/DD',DateEditHasta.Date)+'"';
      TxtQuery := TxtQuery + ' AND P0 = HPC2';
      If EditCambiableCodigo1.Text<>'' then TxtQuery := TxtQuery + ' AND HPC2='+EditCambiableCodigo1.Text;
      if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
      else
       TxtQuery:=TxtQuery + ' ORDER BY HPC1,HPC2';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     DBGrid4.BringToFront; DBGrid4.Visible:=True;
    end;
  //-------------------------- LISTADO DE ETIQUETAS Y DIRECCIONES
  // Es el mismo que el 1, lo que cambia es el formato del Report
  if RadioButton5.Checked=True then
    begin
      TituloGrid:='LISTADO DE ETIQUETAS Y DIRECCIONES';
      TxtQuery := 'SELECT * FROM proveedores';
    TxtQuery := TxtQuery + ' WHERE P0 >= '+Edit1.Text+' AND P0 <= '+Edit2.Text+' AND P1>="'+Edit3.Text+'" AND P1<="'+Edit4.Text+'"';
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY P0, P1';
     dbQuery.Active:=False; dbQuery.Sql.Text:=TxtQuery; dbQuery.Active:=True;
     DBGrid5.BringToFront; DBGrid5.Visible:=True;
    end;
    LabelTituloDBGrid.Caption:=TituloGrid;
   WriteLn(TxtQuery);
end;

//==================== SELECCIONAR ===================
procedure TFLProveedores.BitBtn3Click(Sender: TObject);
begin
  BitBtn2.Enabled:=False; BitBtn3.Enabled:=False;
  Ordenado:=False;
  OcultarBDGrid();
 end;

//==================== IMPRIMIR ===================
procedure TFLProveedores.BitBtn2Click(Sender: TObject);
begin
  //-------------------------- Datos Principales
  if RadioButton1.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoProveedoresDatos.lrf');
     frReport1.ShowReport;
    end;

 //--------------------------_ LISTADO DE FACTURAS RECIBIDAS
  if RadioButton2.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoProveedoresFacRec.lrf');
     frReport1.ShowReport;
    end;
  //--------------------------_ LISTADO DE VENCIMIENTO DE PAGOS

  if RadioButton3.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoProveedoresPagVen.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- LISTADO DE COMPRAS REALIZADAS
  if RadioButton4.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoProveedoresCompras.lrf');
     frReport1.ShowReport;
    end;
  //-------------------------- LISTADO DE ETIQUETAS Y DIRECCIONES
  if RadioButton5.Checked=True then
    begin

     frDBDataSet1.DataSet:=dbQuery;
     frReport1.LoadFromFile(RutaReports+'ListadoProveedoresEtiquetas.lrf');
     frReport1.ShowReport;
    end;
end;
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFLProveedores.frReport1GetValue(const ParName: String;
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
procedure TFLProveedores.frReport1EnterRect(Memo: TStringList; View: TfrView);
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

procedure TFLProveedores.RadioButton1Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiable.Visible:=False;
   PanelCambiable1.Visible:=False;
   
   OcultarBDGrid();
end;

procedure TFLProveedores.RadioButton2Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=False;
   PanelFechaDesdeHasta.Visible:=True;
   PanelCambiable.Visible:=True;
   PanelCambiable1.Visible:=True;

   OcultarBDGrid();
end;

procedure TFLProveedores.RadioButton3Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=False;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiable.Visible:=True;
   PanelCambiable1.Visible:=True;

   OcultarBDGrid();
end;

procedure TFLProveedores.RadioButton4Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=False;
   PanelFechaDesdeHasta.Visible:=True;
   PanelCambiable.Visible:=True;
   PanelCambiable1.Visible:=True;

   OcultarBDGrid();
end;

procedure TFLProveedores.RadioButton5Change(Sender: TObject);
begin
   PanelDesdeHasta.Visible:=True;
   PanelFechaDesdeHasta.Visible:=False;
   PanelCambiable.Visible:=False;
   PanelCambiable1.Visible:=False;

   OcultarBDGrid();
end;

// ====================== Redimensiona y Coloca Todos los DBGrid
procedure TFLProveedores.DimensionarColocarBDGrid();
  begin
    DBGrid1.Align:=alClient;
    DBGrid2.Align:=alClient;
    DBGrid3.Align:=alClient;
    DBGrid4.Align:=alClient;
    DBGrid5.Align:=alClient;
    //DBGrid6.Align:=alClient;
    //DBGrid7.Align:=alClient;
  end;

//======================= OCULTA TODOS LOS DBGird
procedure TFLProveedores.OcultarBDGrid();
  begin
    DBGrid1.Visible:=False; DBGrid2.Visible:=False;
    DBGrid3.Visible:=False; DBGrid4.Visible:=False;
    DBGrid5.Visible:=False;
    LabelTituloDBGrid.Caption:='';
  end;
{// ===================== OBTENER AÑOS PARA EL ListBoxAnos
// pasamos como parametro la instrucci´on SQL de donde estan los años buscados
procedure TFLClientes.RellenaListBoxAnos(TxtQuery: String);
begin
     dbAnos.Active:=False;
     dbAnos.SQL.Text:=TxtQuery;
     dbAnos.Active:=True;
     if dbAnos.RecordCount<>0 then
       begin
         dbAnos.First; ListBoxAnos.Items.Clear;
         while not dbAnos.EOF do
          begin
            ListBoxAnos.Items.Add(dbAnos.Fields[0].AsString);
            dbAnos.Next;
          end;
         ListBoxAnos.ItemIndex:=0;
       end;
     PanelSelectAno.Visible:=True;
     PanelDesdeHasta.Visible:=False;
end;
}


//-------- Al pulsar en el titulo de la columna ordenar por ella
procedure TFLProveedores.DBGrid1TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid1,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLProveedores.DBGrid2TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid2,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
//======SEÑALANDO LAS CELDAS DEL GRID====FECHAS VENCIDAS==================
procedure TFLProveedores.DBGrid3DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
MiColor:TBrush;
ColorVerdoso, ColorRojizo:TColor;
MiDate:TDateTime;
begin
  ColorVerdoso:=clLime;
  ColorRojizo:=clRed;
  MiColor:=DBGrid3.Canvas.Brush;
  MiDate:=Date;
  //MiDate:=StrToDate('01/12/2008');
  if dbQuery.Fields[3].AsString <> ''  then
  begin
    //Primer Vencimiento Fecha
    if (column.Field=dbQuery.Fields[3]) and (dbQuery.Fields[3].AsDateTime<=MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[3].AsString+' <= '+FormatDateTime('YYYY/MM/DD',Midate)) ;WriteLn(' Menor y pongo las letras en ROJO');
           DBGrid3.Canvas.Font.Color :=ColorRojizo;
           //DBGrid3.Canvas.Brush.Color:=ColorVerdoso;
           DBGrid3.Canvas.Rectangle(rect)
      end
    else if (column.Field=dbQuery.Fields[3]) and (dbQuery.Fields[3].AsDateTime>MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[3].AsString+' > '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo las letras en VERDE');
           DBGrid3.Canvas.Font.Color :=ColorVerdoso;
           //DBGrid3.Canvas.Brush.Color:=ColorRojizo;
           DBGrid3.Canvas.Rectangle(rect)
      end;
    //Primer Vencimiento Importe
    if (column.Field=dbQuery.Fields[4]) and (dbQuery.Fields[3].AsDateTime<=MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[4].AsString+' <= '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo los Importes en ROJO');
       DBGrid3.Canvas.Font.Color :=ColorRojizo;
       //DBGrid3.Canvas.Brush.Color:=ColorVerdoso;
       DBGrid3.Canvas.Rectangle(rect)
      end
    else if (column.Field=dbQuery.Fields[4]) and (dbQuery.Fields[3].AsDateTime>MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[4].AsString+' > '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo los Importes en VERDE');
           DBGrid3.Canvas.Font.Color :=ColorVerdoso;
           //DBGrid3.Canvas.Brush.Color:=ColorRojizo;
           DBGrid3.Canvas.Rectangle(rect)
      end;
  end;

  if dbQuery.Fields[5].AsString <> ''  then
  begin
    //Segundo Vencimiento Fecha
    if (column.Field=dbQuery.Fields[5]) and (dbQuery.Fields[5].AsDateTime<=MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[5].AsString+' <= '+FormatDateTime('YYYY/MM/DD',Midate)) ;WriteLn(' Menor y pongo las letras en ROJO');
           DBGrid3.Canvas.Font.Color :=ColorRojizo;
           //DBGrid3.Canvas.Brush.Color:=ColorVerdoso;
           DBGrid3.Canvas.Rectangle(rect)
      end
    else if (column.Field=dbQuery.Fields[5]) and (dbQuery.Fields[5].AsDateTime>MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[5].AsString+' > '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo las letras en VERDE');
           DBGrid3.Canvas.Font.Color :=ColorVerdoso;
           //DBGrid3.Canvas.Brush.Color:=ColorRojizo;
           DBGrid3.Canvas.Rectangle(rect)
      end;
    //Segundo Vencimiento Importe
    if (column.Field=dbQuery.Fields[6]) and (dbQuery.Fields[5].AsDateTime<=MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[6].AsString+' <= '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo los Importes en ROJO');
       DBGrid3.Canvas.Font.Color :=ColorRojizo;
       //DBGrid3.Canvas.Brush.Color:=ColorVerdoso;
       DBGrid3.Canvas.Rectangle(rect)
      end
    else if (column.Field=dbQuery.Fields[6]) and (dbQuery.Fields[5].AsDateTime>MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[6].AsString+' > '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo los Importes en VERDE');
           DBGrid3.Canvas.Font.Color :=ColorVerdoso;
           //DBGrid3.Canvas.Brush.Color:=ColorRojizo;
           DBGrid3.Canvas.Rectangle(rect)
      end;
  end;

  if dbQuery.Fields[7].AsString <> ''  then
  begin
    //Tercer Vencimiento Fecha
    if (column.Field=dbQuery.Fields[7]) and (dbQuery.Fields[7].AsDateTime<=MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[7].AsString+' <= '+FormatDateTime('YYYY/MM/DD',Midate)) ;WriteLn(' Menor y pongo las letras en ROJO');
           DBGrid3.Canvas.Font.Color :=ColorRojizo;
           //DBGrid3.Canvas.Brush.Color:=ColorVerdoso;
           DBGrid3.Canvas.Rectangle(rect)
      end
    else if (column.Field=dbQuery.Fields[7]) and (dbQuery.Fields[7].AsDateTime>MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[5].AsString+' > '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo las letras en VERDE');
           DBGrid3.Canvas.Font.Color :=ColorVerdoso;
           //DBGrid3.Canvas.Brush.Color:=ColorRojizo;
           DBGrid3.Canvas.Rectangle(rect)
      end;
    //Tercer Vencimiento Importe
    if (column.Field=dbQuery.Fields[8]) and (dbQuery.Fields[7].AsDateTime<=MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[8].AsString+' <= '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo los Importes en ROJO');
       DBGrid3.Canvas.Font.Color :=ColorRojizo;
       //DBGrid3.Canvas.Brush.Color:=ColorVerdoso;
       DBGrid3.Canvas.Rectangle(rect)
      end
    else if (column.Field=dbQuery.Fields[8]) and (dbQuery.Fields[7].AsDateTime>MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[8].AsString+' > '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo los Importes en VERDE');
           DBGrid3.Canvas.Font.Color :=ColorVerdoso;
           //DBGrid3.Canvas.Brush.Color:=ColorRojizo;
           DBGrid3.Canvas.Rectangle(rect)
      end;
  end;
  if dbQuery.Fields[9].AsString <> ''  then
  begin
    //Cuarto Vencimiento Fecha
    if (column.Field=dbQuery.Fields[9]) and (dbQuery.Fields[9].AsDateTime<=MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[9].AsString+' <= '+FormatDateTime('YYYY/MM/DD',Midate)) ;WriteLn(' Menor y pongo las letras en ROJO');
           DBGrid3.Canvas.Font.Color :=ColorRojizo;
           //DBGrid3.Canvas.Brush.Color:=ColorVerdoso;
           DBGrid3.Canvas.Rectangle(rect)
      end
    else if (column.Field=dbQuery.Fields[9]) and (dbQuery.Fields[9].AsDateTime>MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[9].AsString+' > '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo las letras en VERDE');
           DBGrid3.Canvas.Font.Color :=ColorVerdoso;
           //DBGrid3.Canvas.Brush.Color:=ColorRojizo;
           DBGrid3.Canvas.Rectangle(rect)
      end;
    //Cuarto Vencimiento Importe
    if (column.Field=dbQuery.Fields[10]) and (dbQuery.Fields[9].AsDateTime<=MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[6].AsString+' <= '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo los Importes en ROJO');
       DBGrid3.Canvas.Font.Color :=ColorRojizo;
       //DBGrid3.Canvas.Brush.Color:=ColorVerdoso;
       DBGrid3.Canvas.Rectangle(rect)
      end
    else if (column.Field=dbQuery.Fields[10]) and (dbQuery.Fields[9].AsDateTime>MiDate) then
      begin
      //Write(column.Field.AsString+' = '+dbQuery.Fields[6].AsString+' > '+FormatDateTime('YYYY/MM/DD',Midate));WriteLn(' Mayor y pongo los Importes en VERDE');
           DBGrid3.Canvas.Font.Color :=ColorVerdoso;
           //DBGrid3.Canvas.Brush.Color:=ColorRojizo;
           DBGrid3.Canvas.Rectangle(rect)
      end;
  end;
  DBGrid3.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  DBGrid3.Canvas.brush:=MiColor;
end;

procedure TFLProveedores.DBGrid3TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid3,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLProveedores.DBGrid4TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid4,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;
procedure TFLProveedores.DBGrid5TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid5,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;

//========= Boton de busqueda del panel cambiable y seleccion del nombre elejido

procedure TFLProveedores.BitBtnCambiable1Click(Sender: TObject);
var
 TxtQuery: String;
begin
 TxtQuery:='SELECT P0, P1 FROM proveedores ORDER BY P1';
 CargaValoresEnComboCambiable(TxtQuery, ComboCambiableNombre1, dbCambiable, LabelCambiable1);
end;

procedure TFLProveedores.BitBtnCambiableClick(Sender: TObject);
var
 TxtQuery: String;
begin
 TxtQuery:='SELECT T0, T1 FROM tiendas ORDER BY T1';
 CargaValoresEnComboCambiable(TxtQuery, ComboCambiableNombre, dbCambiable, LabelCambiable);
end;

procedure TFLProveedores.ComboCambiableNombre1Click(Sender: TObject);
begin
  EscogeNombreComboCambiable( 'P1', ComboCambiableNombre1, dbCambiable, EditCambiableCodigo1, StaticTextCambiableNombre1)
end;

procedure TFLProveedores.ComboCambiableNombreClick(Sender: TObject);
begin
  EscogeNombreComboCambiable( 'T1', ComboCambiableNombre, dbCambiable, EditCambiableCodigo, StaticTextCambiableNombre)
end;

procedure TFLProveedores.ComboCambiableNombre1KeyPress(Sender: TObject;
  var Key: char);
begin
  if key=#13 then ComboCambiableNombre1Click(ComboCambiableNombre1);
end;

procedure TFLProveedores.ComboCambiableNombreKeyPress(Sender: TObject;
  var Key: char);
begin
  if key=#13 then ComboCambiableNombreClick(ComboCambiableNombre);
end;

// --------Formateo de fechas entrantes
procedure TFLProveedores.DateEditDesdeExit(Sender: TObject);
begin
   if not EsFechaValida(DateEditDesde.text) Then
     begin
       DateEditDesde.text:='';
       ShowMessage('Formato de Fecha Invalido, debe ser dd/mm/aaaa');
     end
end;

procedure TFLProveedores.DateEditHastaExit(Sender: TObject);
begin
   if not EsFechaValida(DateEditHasta.text) Then
     begin
       DateEditHasta.text:='';
       ShowMessage('Formato de Fecha Invalido, debe ser dd/mm/aaaa');
     end
end;

//======================= Despues de introducir un codigo, al salir, si existe,
//======================= completa el StaticText con el nombre oportuno
procedure TFLProveedores.EditCambiableCodigo1Exit(Sender: TObject);
var
 TxtQuery: String;
begin
  TxtQuery:='SELECT P1 FROM proveedores WHERE P0="'+EditCambiableCodigo1.Text+'"';
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

procedure TFLProveedores.EditCambiableCodigoExit(Sender: TObject);
var
 TxtQuery: String;
begin
  TxtQuery:='SELECT T1 FROM tiendas WHERE T0="'+EditCambiableCodigo.Text+'"';
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

procedure TFLProveedores.EditCambiableCodigoEnter(Sender: TObject);
begin
  StaticTextCambiableNombre.Caption:='';
end;

procedure TFLProveedores.EditCambiableCodigo1Enter(Sender: TObject);
begin
  StaticTextCambiableNombre1.Caption:='';
end;

Procedure TFLProveedores.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

Initialization
  {$I listaproveedores.lrs}

End.

