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

Unit historicoop;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset, DBGrids,
  StdCtrls, db, EditBtn, MaskEdit, Grids, LR_Class, LR_DBSet, lr_e_pdf;

Type

  { TFLHistoop }

  TFLHistoop = Class(Tform)
    BitBtn26: TBitBtn;
    BitBtn27: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtnCambiable: TBitBtn;
    btPuesto: TBitBtn;
    CheckBox1: TCheckBox;
    cbTodosPuestos: TCheckBox;
    CheckBox2: TCheckBox;
    ComboBox1: TComboBox;
    ComboBoxHoraDesde: TComboBox;
    ComboBoxHoraHasta: TComboBox;
    ComboCambiableNombre: TComboBox;
    Datasource2: TDatasource;
    DateEditDesde: TDateEdit;
    DateEditHasta: TDateEdit;
    dbCambiable: TZQuery;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    dbCreditos: TZQuery;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    DBGrid5: TDBGrid;
    dbHistodd: TZQuery;
    dbMuestrac: TZQuery;
    dbMuestrad: TZQuery;
    dbUsu: TZQuery;
    Edit1: TEdit;
    EditCambiableCodigo: TEdit;
    edCodigoPuesto: TEdit;
    edDescripcionPuesto: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LabelCambiable: TLabel;
    lbPuesto: TLabel;
    LabelTituloDBGrid: TLabel;
    lbCodigoPuesto: TLabel;
    lbDescripcionPuesto: TLabel;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Bitbtn1: Tbitbtn;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    BitBtn4: TBitBtn;
    Datasource1: TDatasource;
    dbOperaciones: TZQuery;
    PanelCambiable: TPanel;
    PanelPuesto: TPanel;
    PanelRadioButton: TPanel;
    PanelLeyenda: TPanel;
    PanelDetalleOperacion: TPanel;
    PanelTituloGrid: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    StaticTextCambiableNombre: TStaticText;
    StaticTextEntregaContado: TStaticText;
    StaticTextLabEntrega1: TStaticText;
    StaticTextLabTotal: TStaticText;
    StaticTextHora: TStaticText;
    StaticTextLabVend: TStaticText;
    StaticTextVend: TStaticText;
    StaticTextTipoPago: TStaticText;
    StaticTextNumOper: TStaticText;
    StaticTextLabNumOper: TStaticText;
    StaticTextCliente: TStaticText;
    StaticTextLabCliente: TStaticText;
    StaticTextLabEntrega: TStaticText;
    StaticTextLabCambio: TStaticText;
    StaticTextTotal: TStaticText;
    StaticTextEntrega: TStaticText;
    StaticTextCambio: TStaticText;
    StaticTextLabFecha: TStaticText;
    StaticTextLabHora: TStaticText;
    StaticTextFecha: TStaticText;
    dbPuesto: TZQuery;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn26Click(Sender: TObject);
    procedure BitBtn27Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure btPuestoClick(Sender: TObject);
    procedure cbTodosPuestosChange(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure DateEditDesdeExit(Sender: TObject);
    procedure DateEditHastaExit(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edCodigoPuestoEnter(Sender: TObject);
    procedure edCodigoPuestoExit(Sender: TObject);
    procedure edDescripcionPuestoExit(Sender: TObject);
    procedure edDescripcionPuestoKeyPress(Sender: TObject; var Key: char);
    Procedure Formcreate(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    procedure Colorea(Column: TColumn;Grid: TDBGrid;dbColor: TZQuery);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure DBGrid4TitleClick(Column: TColumn);
    procedure DBGrid3TitleClick(Column: TColumn);
    procedure DBGrid5TitleClick(Column: TColumn);
    procedure BlancoGrid(Grid: TDBGrid);
    procedure RadioButton1ChangeBounds(Sender: TObject);
    procedure RadioButton2ChangeBounds(Sender: TObject);
    procedure RadioButton3ChangeBounds(Sender: TObject);
    procedure RadioButton4ChangeBounds(Sender: TObject);
    procedure RadioButton5ChangeBounds(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure RadioButton7ChangeBounds(Sender: TObject);
    procedure RadioButton8ChangeBounds(Sender: TObject);
    procedure RadioButton9ChangeBounds(Sender: TObject);
    procedure BitBtnCambiableClick(Sender: TObject);
    procedure ComboCambiableNombreClick(Sender: TObject);
    procedure ComboCambiableNombreKeyPress(Sender: TObject; var Key: char);
    procedure EditCambiableCodigoExit(Sender: TObject);
    procedure EditCambiableCodigoEnter(Sender: TObject);

    procedure OcultarBDGrid();
    procedure DimensionarColocarBDGrid();

    procedure RecuperaOperacion();

    procedure ImpreTicket(regalo: boolean);
    procedure CabeceraTicket();
    procedure TotalTicket(n1,n2,n3,ti1,ti2,ti3,i1,i2,i3: Double);
    procedure PieTicket();

    procedure Corte();


  Private
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormHistoop;
  
Var
  FLHistoop: TFLHistoop;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;
  PrintText: TextFile;
  nPuestoDetalles, nPuestoCabeceras: string;

Implementation

uses
  Global, Funciones, Imprimir, Ventas, busquedas;

//=============== Crea el formulario ================
procedure ShowFormHistoop;
begin
  with TFLHistoop.Create(Application) do
    begin
       ShowModal;
    end;
end;
Procedure TFLHistoop.Formcreate(Sender: Tobject);
Begin
  //----------------- CONEXION -----------------
  //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.

  //---------------------Paneles visibles por defecto
  PanelDetalleOperacion.Visible:=False;
  PanelRadioButton.Visible:=True;
  PanelLeyenda.Visible:=False;
  PanelCambiable.Visible:=True;

  BitBtn2.Enabled:=False; BitBtn3.Enabled:=False; BitBtn5.Enabled:=False;

  DateEditDesde.Date:=Date; // StrToDate('01/01/'+FormatDateTime('YYYY',Date));
  DateEditHasta.Date:=Date;
  LabelCambiable.Caption:='Cliente';
  EditCambiableCodigo.Text:= '';
  nPuestoDetalles:=''; nPuestoCabeceras:='';

  // Ocultamos todos los DBGrid
  DimensionarColocarBDGrid();
  OcultarBDGrid();
End;

//==================== CERRAR ======================
procedure TFLHistoop.BitBtn4Click(Sender: TObject);
begin
  Edit1.Visible:=False;
  Label11.Visible:=False;
  dbOperaciones.Active:=False;
  Close();
end;

//==============GENERACION AUTOMATICA DE UNA VENTA ============
procedure TFLHistoop.BitBtn5Click(Sender: TObject);
var
  multiplicador: string;
begin
  multiplicador:='-1';
  // Confirma la grabación de una nueva venta y solicita el multiplicador
  if Application.MessageBox('PROCESO PARA GENERAR NUEVA VENTA'+#13 + '¿DESEA CONTINUAR?',
                            'FacturLinEx 2', MB_ICONQUESTION + MB_YESNO) = idYes then begin
     InputQuery('FacturLinEx 2','Introducir multiplicador (-1 para abono)',multiplicador);
     fVentas:=TfVentas.Create(Application);    // Creamos el formulario para acceder a su contenido
     fVentas.WindowState:=wsMinimized;
     fVentas.Show;
     fVentas.BitBtn24.Click;    // Ejecutamos aparcar ticket para asignar Numero de Ticket
     fVentas.dbVentas.Open;
     dbHistodd.First;
     while not dbHistodd.EOF do begin
       if dbHistodd.FieldByName('HOD17').AsString='' then begin;
          fVentas.Edit1.Text:=dbOperaciones.FieldByName('HO8').AsString; // Asignamos el valor de CODIGO CLIENTE
          fVentas.Edit3.Text:=dbHistodd.FieldByName('HOD6').AsString;  // Asignamos el valor de CODIGO ARTICULO
          fVentas.Edit4.Text:=dbHistodd.FieldByName('HOD7').AsString;  // Asignamos el valor de DESCRIPCION
          fVentas.Edit5.Text:=FloatToStr(dbHistodd.FieldByName('HOD8').asFloat*StrToFloat(multiplicador));  // Asignamos el valor de CANTIDAD
          fVentas.Edit6.Text:=dbHistodd.FieldByName('HOD9').AsString;   // Asignamos el valor de PVP
          fVentas.Edit7.Text:=dbHistodd.FieldByName('HOD10').AsString;  // Asignamos el valor de PRECIO SIN IVA
          fVentas.Edit8.Text:=dbHistodd.FieldByName('HOD11').AsString;  // Asignamos el valor de DESCUENTO LINEAL
          fVentas.Edit9.Text:=FloatToStr(dbHistodd.FieldByName('HOD12').asFloat*StrToFloat(multiplicador));  // CALCULARLO - Asignamos el valor de IMPORTE SIN IVA
          fVentas.Edit10.Text:=IntToStr(dbHistodd.FieldByName('HOD13').AsInteger);  // Asignamos el valor de TIPO DE IVA
          fVentas.Edit11.Text:=FloatToStr(dbHistodd.FieldByName('HOD14').asFloat*StrToFloat(multiplicador)); // CALCULARLO - Asignamos el valor de IMPORTE CON IVA
          fVentas.WindowState:=wsMinimized;
          fVentas.Show;
          fVentas.BitBtn14.Click;  // Simulamos el CLIC para la inserción de linea de venta
       end;
       dbHistodd.Next;
     end;
     fVentas.dbVentas.Close;
     fVentas.Free;
     ShowMessage('PROCESO FINALIZADO')
  end;
end;

// Selección del puesto a leer en los históricos.

procedure TFLHistoop.btPuestoClick(Sender: TObject);
begin
   edCodigoPuesto.Text:=FBusquedas.IniciaBusquedas('SELECT PT0,PT1 FROM puestos'+Tienda,['Puesto','Descripción'],'PT0');
   edDescripcionPuesto.SetFocus;
   edCodigoPuestoExit(self);
end;

procedure TFLHistoop.cbTodosPuestosChange(Sender: TObject);
begin
  if cbTodosPuestos.Checked then
    begin
     edCodigoPuesto.Enabled:=False;
     edDescripcionPuesto.Enabled:=False;
     btPuesto.Enabled:=False;
     nPuestoDetalles:=''; nPuestoCabeceras:='';
    end else
    begin
     edCodigoPuesto.Enabled:=True;
     edDescripcionPuesto.Enabled:=True;
     btPuesto.Enabled:=True;
    end
end;


procedure TFLHistoop.edDescripcionPuestoExit(Sender: TObject);
begin
  if edDescripcionPuesto.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); edDescripcionPuesto.SetFocus; Exit; end;
  dbPuesto.SQL.Text:='SELECT PT0,PT1 FROM puestos'+Tienda+' WHERE PT1="'+edDescripcionPuesto.Text+'"'; dbPuesto.Active:=True;
  if dbPuesto.RecordCount=0 then
                             begin
                               edCodigoPuesto.Text:=FBusquedas.IniciaBusquedas('SELECT PT0,PT1 FROM puestos'+Tienda+' WHERE PT1 LIKE "'+edDescripcionPuesto.Text+'%"',
                                                         ['Puesto', 'Descripción'],'PT0');
                               edCodigoPuestoExit(self);
                               Exit;
                              end;
  edCodigoPuesto.Text:=dbPuesto.FieldByName('PT0').AsString;
  edCodigoPuestoExit(self);
end;

procedure TFLHistoop.edDescripcionPuestoKeyPress(Sender: TObject; var Key: char
  );
begin
  if (Key=#13) then edDescripcionPuestoExit(self);
  Exit;
end;

procedure TFLHistoop.edCodigoPuestoEnter(Sender: TObject);
begin
  edCodigoPuesto.Text:='';
end;

procedure TFLHistoop.edCodigoPuestoExit(Sender: TObject);
begin
   if edCodigoPuesto.Text='' then Exit;
   dbPuesto.SQL.Text:='SELECT PT0,PT1 FROM puestos'+Tienda+' WHERE PT0="'+edCodigoPuesto.Text+'"';
   dbPuesto.Active:=True;
   If dbPuesto.RecordCount=0 then
                               Begin
                                 btPuestoClick(self);
                                 edDescripcionPuesto.SetFocus; Exit;
                               End;
   edDescripcionPuesto.Text:=dbPuesto.FieldByName('PT1').AsString;
   nPuestoDetalles:= ' AND HOD2="' + edCodigoPuesto.Text + '"';
   nPuestoCabeceras:=' AND HO2="' + edCodigoPuesto.Text + '"';
end;


procedure TFLHistoop.DateEditDesdeExit(Sender: TObject);
begin
   if not EsFechaValida(DateEditDesde.text) Then
     begin
       DateEditDesde.text:='';
       ShowMessage('Formato de Fecha Invalido, debe ser dd/mm/aaaa');
     end
end;

procedure TFLHistoop.DateEditHastaExit(Sender: TObject);
begin
   if not EsFechaValida(DateEditHasta.text) Then
     begin
       DateEditHasta.text:='';
       ShowMessage('Formato de Fecha Invalido, debe ser dd/mm/aaaa');
     end
end;

procedure TFLHistoop.DBGrid1CellClick(Column: TColumn);
begin
  RecuperaOperacion();
end;


//======================== DOBLE CLICK EN GRID DE OPERACIONES ==================
procedure TFLHistoop.DBGrid1DblClick(Sender: TObject);
begin
  RecuperaOperacion();
  //Dejo estas opciones comentadas por si hubiera que sacar distintos paneles, según la operación
  //if dbOperaciones.FieldByName('CRE3').AsString='EN' then RecuperaEntrega();
  //if (dbOperaciones.FieldByName('CRE3').AsString='NS') or
     //(dbOperaciones.FieldByName('CRE3').AsString='NT') then RecuperaTicket();
end;

Procedure TFLHistoop.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//==================== VISUALIZAR ===================
procedure TFLHistoop.BitBtn1Click(Sender: TObject);
Var
  TxtQuery: String;
  FiltroVisual: String;
begin
  FiltroVisual:='';
  if ComboBox1.ItemIndex=0 then FiltroVisual:=' AND HO16="N" ';
  if ComboBox1.ItemIndex=1 then FiltroVisual:=' AND HO16="A" ';

  if FiltroVisual<>'' then
   begin
     DbGrid1.DataSource:=Nil;
     TxtQuery:='SELECT *,HO12+HO14 As ENTRETOTAL from hisopcc'+Tienda+' WHERE '+copy(FiltroVisual,5,10)+nPuestoCabeceras;
     TxtQuery:=TxtQuery + ' ORDER BY HO0,HO1,HO2,HO4,HO3 DESC';
     dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
     if dbOperaciones.RecordCount=0 then
       begin
         Showmessage('No existen documentos en el histórico a visualizar');
         FiltroVisual:='';
         ComboBox1.ItemIndex:=2;
       end;
     dbOperaciones.Active:=False;
     dbGrid1.DataSource:= DataSource1;
   end;
  AntColun:='0';Ordenado:=False;
  BitBtn2.Enabled:=True; BitBtn3.Enabled:=True; BitBtn5.Enabled:=True;
  PanelCambiable.Visible:=False;
  //-------------------------- Todas las operaciones
  if RadioButton1.Checked=True then
    begin
     TituloGrid:='LISTADO DE OPERACIONES';
     //-- MID(HO18,1,250)
     TxtQuery:='SELECT *, CONVERT(HO18 USING UTF8) as NOTAS,HO12+HO14 As ENTRETOTAL from hisopcc'+Tienda+' WHERE';
     TxtQuery:=TxtQuery +' HO0>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND HO0<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"'+
                          FiltroVisual+ nPuestoCabeceras;
     If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND HO8='+EditCambiableCodigo.Text;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY HO0,HO1,HO2,HO4,HO3 DESC';

     dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
     if dbOperaciones.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
     DBGrid1DblClick(Self);
     PanelRadioButton.Visible:=False;// PanelLeyenda.Visible:=True;
     BitBtn2.Enabled:=True; BitBtn3.Enabled:=True; BitBtn5.Enabled:=True; //------ Activar Botones: Imprimir, Seleccionar y Generar Venta
    end;
  //-------------------------- Operaciones normales sin ticket
  if RadioButton2.Checked=True then
    begin
     TituloGrid:='LISTADO DE OPERACIONES SIN TICKET';
     //-- MID(HO18,1,250)
     TxtQuery:='SELECT *, CONVERT(HO18 USING UTF8) as NOTAS, HO12+HO14 As ENTRETOTAL from hisopcc'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' HO0>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND HO0<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"'+
                          ' AND HO5="NS"'+FiltroVisual+ nPuestoCabeceras;
     If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND HO8='+EditCambiableCodigo.Text;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY HO0,HO1,HO2,HO4,HO3 DESC';
     dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
     if dbOperaciones.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     DBGrid1DblClick(Self);
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
     PanelRadioButton.Visible:=False; //PanelLeyenda.Visible:=True;
     BitBtn2.Enabled:=True; BitBtn3.Enabled:=True; BitBtn5.Enabled:=True; //------ Activar Botones: Imprimir, Seleccionar y Generar Venta
    end;
  //-------------------------- Operaciones normales con ticket
  if RadioButton3.Checked=True then
    begin
     TituloGrid:='LISTADO DE OPERACIONES CON TICKET';
     //-- MID(HO18,1,250)
     TxtQuery:='SELECT *, CONVERT(HO18 USING UTF8) as NOTAS, HO12+HO14 As ENTRETOTAL from hisopcc'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' HO0>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND HO0<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"'+
                          ' AND HO5="NT"'+FiltroVisual + nPuestoCabeceras;
     If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND HO8='+EditCambiableCodigo.Text;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY HO0,HO1,HO2,HO4,HO3 DESC';
     dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
     if dbOperaciones.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     DBGrid1DblClick(Self);
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
     PanelRadioButton.Visible:=False; //PanelLeyenda.Visible:=True;
     BitBtn2.Enabled:=True; BitBtn3.Enabled:=True; BitBtn5.Enabled:=True; //------ Activar Botones: Imprimir, Seleccionar y Generar Venta
    end;
  //-------------------------- Operaciones con Albaranes
  if RadioButton4.Checked=True then
    begin
     TituloGrid:='LISTADO DE OPERACIONES CON ALBARANES';
     //-- MID(HO18,1,250)
     TxtQuery:='SELECT *, CONVERT(HO18 USING UTF8) as NOTAS, HO12+HO14 As ENTRETOTAL from hisopcc'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' HO0>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND HO0<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"'+
                          ' AND HO5="AL"'+FiltroVisual + nPuestoCabeceras;
     If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND HO8='+EditCambiableCodigo.Text;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY HO0,HO1,HO2,HO4,HO3 DESC';
     dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
     if dbOperaciones.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     DBGrid1DblClick(Self);
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
     PanelRadioButton.Visible:=False; //PanelLeyenda.Visible:=True;
     BitBtn2.Enabled:=True; BitBtn3.Enabled:=True; BitBtn5.Enabled:=True; //------ Activar Botones: Imprimir, Seleccionar y Generar Venta
    end;
  //-------------------------- Operaciones normales con factura
  if RadioButton5.Checked=True then
    begin
     TituloGrid:='LISTADO DE OPERACIONES CON FACTURA';
     //-- MID(HO18,1,250)
     TxtQuery:='SELECT *, CONVERT(HO18 USING UTF8) as NOTAS, HO12+HO14 As ENTRETOTAL from hisopcc'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' HO0>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND HO0<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"'+
                          ' AND HO5="FA"'+FiltroVisual + nPuestoCabeceras;
     If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND HO8='+EditCambiableCodigo.Text;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY HO0,HO1,HO2,HO4,HO3 DESC';
     dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
     if dbOperaciones.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     DBGrid1DblClick(Self);
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
     PanelRadioButton.Visible:=False;// PanelLeyenda.Visible:=True;
     BitBtn2.Enabled:=True; BitBtn3.Enabled:=True; BitBtn5.Enabled:=True; //------ Activar Botones: Imprimir, Seleccionar y Generar Venta
    end;
  //-------------------------- Operaciones de un Articulo
  if RadioButton6.Checked=True then
    begin
     Edit1.Visible:=True;
     Label11.Visible:=True;
     Label12.Visible:=True;
     TituloGrid:='LISTADO DE OPERACIONES DE UN ARTÍCULO';
     //-- MID(HOD7,1,100)
     TxtQuery:='SELECT *, CONVERT(HOD7 USING UTF8) as DESCRIP from hisopdd'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' HOD0>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND HOD0<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"'+
                          ' AND HOD7 LIKE "'+UpperCase(Edit1.Text)+'"'+ nPuestoDetalles;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY HOD0,HOD1,HOD2,HOD4,HOD3 DESC';
     dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
//-- Prueba doble busqueda     if dbOperaciones.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     if dbOperaciones.RecordCount=0 then
       begin
        //-- MID(HOD7,1,30)
        TxtQuery:='SELECT *, CONVERT(HOD7 USING UTF8) as DESCRIP from hisopdd'+Tienda+' WHERE';
        TxtQuery:=TxtQuery + ' HOD0>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                             ' AND HOD0<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"'+
                             ' AND HOD6 LIKE "'+UpperCase(Edit1.Text)+'"'+ nPuestoDetalles;
        if Ordenado=True then
          TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
        else
          TxtQuery:=TxtQuery + ' ORDER BY HOD0,HOD1,HOD2,HOD4,HOD3 DESC';
        dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
        if dbOperaciones.RecordCount=0 then
          begin
               ShowMessage('CON ESA SELECCION NO HAY DATOS');
               exit;
          end;
       end;

     DBGrid2.BringToFront; DBGrid2.Visible:=True;
     PanelRadioButton.Visible:=False;
     BitBtn2.Enabled:=False; BitBtn3.Enabled:=True; BitBtn5.Enabled:=True; //------ Activar Botones: Imprimir, Seleccionar y Generar Venta
     RadioButton1.Checked:=True;
    end;
  //-------------------------- Operaciones por Horas
  if RadioButton7.Checked=True then
    begin
     TituloGrid:='LISTADO DE OPERACIONES AGRUPADAS POR HORAS';
     TxtQuery:='SELECT HOUR(HO1), COUNT(*) AS NumeroDeVentas, SUM(HO9) AS ImporteTotal from hisopcc'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' HO0>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND HO0<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"'+
                          ' AND HOUR(HO1)>="'+ComboBoxHoraDesde.Text+'"'+
                          ' AND HOUR(HO1)<="'+ComboBoxHoraHasta.Text+'"'+ nPuestoCabeceras;
     TxtQuery:=TxtQuery + ' GROUP BY HOUR(HO1)';
     If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND HO8='+EditCambiableCodigo.Text;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY HOUR(HO1)';

     dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
     if dbOperaciones.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     if FormatDateTime('DD-MM-YYYY',DateEditDesde.Date) <> '' then
       TituloGrid:= TituloGrid + ' DESDE EL DIA '+ FormatDateTime('DD-MM-YYYY',DateEditDesde.Date);
     if FormatDateTime('DD-MM-YYYY',DateEditHasta.Date) <> '' then
       TituloGrid:= TituloGrid + ' HASTA EL DIA '+ FormatDateTime('DD-MM-YYYY',DateEditHasta.Date);

     DBGrid4.BringToFront; DBGrid4.Visible:=True;
     PanelRadioButton.Visible:=False; //PanelLeyenda.Visible:=False;
     BitBtn2.Enabled:=True; BitBtn3.Enabled:=True; BitBtn5.Enabled:=True; //------ Activar Botones: Imprimir, Seleccionar y Generar Venta
    end;
   //-------------------------- Operaciones por Usuarios
  if RadioButton8.Checked=True then
    begin
     TituloGrid:='LISTADO DE OPERACIONES AGRUPADAS POR USUARIOS';
     TxtQuery:='SELECT HO7, COUNT(*) AS NumeroDeVentas, SUM(HO9) AS ImporteTotal, USU1 from hisopcc'+Tienda+', usuarios'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' HO0>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND HO0<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"'+
                          ' AND HOUR(HO1)>="'+ComboBoxHoraDesde.Text+'"'+
                          ' AND HOUR(HO1)<="'+ComboBoxHoraHasta.Text+'"'+
                          ' AND HO7=USU0' + nPuestoCabeceras;
     TxtQuery:=TxtQuery + ' GROUP BY HO7';
     If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND HO8='+EditCambiableCodigo.Text;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY HO7';
     //WriteLn(TxtQuery);
     dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
     if dbOperaciones.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     if FormatDateTime('DD-MM-YYYY',DateEditDesde.Date) <> '' then
       TituloGrid:= TituloGrid + ' DESDE EL DIA '+ FormatDateTime('DD-MM-YYYY',DateEditDesde.Date);
     if FormatDateTime('DD-MM-YYYY',DateEditHasta.Date) <> '' then
       TituloGrid:= TituloGrid + ' HASTA EL DIA '+ FormatDateTime('DD-MM-YYYY',DateEditHasta.Date);

     DBGrid5.BringToFront; DBGrid5.Visible:=True;
     PanelRadioButton.Visible:=False; //PanelLeyenda.Visible:=False;
     BitBtn2.Enabled:=True; BitBtn3.Enabled:=True; BitBtn5.Enabled:=True; //------ Activar Botones: Imprimir, Seleccionar y Generar Venta
    end;
    //-------------------------- Todas las operaciones de crédito
  if RadioButton9.Checked=True then
    begin
     TituloGrid:='LISTADO DE OPERACIONES DE CRÉDITO';
//     TxtQuery:='SELECT HO0,HO1,HO2,HO3,HO4,HO5,HO8,HO11,HO12,HO13,HO14 from hisopcc'+Tienda+', creditos'+Tienda+' WHERE'; //--- Generaba un error, no encontraba HO7
     TxtQuery:='SELECT *, HO12+HO14 As ENTRETOTAL from hisopcc'+Tienda+', creditos'+Tienda+' WHERE';
     TxtQuery:=TxtQuery + ' CRE0=HO8 AND CRE1=HO0 AND CRE2=HO1 AND CRE3=HO5 AND CRE4=HO4 AND CRE5=HO3 AND';
     TxtQuery:=TxtQuery + ' HO0>="'+FormatDateTime('YYYY-MM-DD',DateEditDesde.Date)+'"'+
                          ' AND HO0<="'+FormatDateTime('YYYY-MM-DD',DateEditHasta.Date)+'"'+ nPuestoCabeceras;
     If EditCambiableCodigo.Text<>'' then TxtQuery := TxtQuery + ' AND HO8='+EditCambiableCodigo.Text;
     if Ordenado=True then
       TxtQuery := TxtQuery + ' ORDER BY ' + TituloColumn +' '+ Orden
     else
       TxtQuery:=TxtQuery + ' ORDER BY HO0,HO1,HO2,HO4,HO3 DESC';
     dbOperaciones.Active:=False; dbOperaciones.Sql.Text:=TxtQuery; dbOperaciones.Active:=True;
     if dbOperaciones.RecordCount=0 then begin ShowMessage('CON ESA SELECCION NO HAY DATOS'); exit; end;
     DBGrid1.BringToFront; DBGrid1.Visible:=True;
     PanelRadioButton.Visible:=False; PanelLeyenda.Visible:=True;
     BitBtn2.Enabled:=True; BitBtn3.Enabled:=True; BitBtn5.Enabled:=True; //------ Activar Botones: Imprimir, Seleccionar y Generar Venta
    end
  else
    begin
     Edit1.Visible:=False;
     Label11.Visible:=False;
     Label12.Visible:=False;
    end;
  LabelTituloDBGrid.Caption:=TituloGrid;
  //WriteLn(TxtQuery);
end;


//============ IMPRIMIMOS COPIAS DE DOCUMENTOS/TICKETS ======================
procedure TFLHistoop.BitBtn26Click(Sender: TObject);
var
  TxtQuery: String;
  Documento: String;
begin
  dbUsu.Active:=False;
  dbUsu.SQL.Text:='SELECT * FROM clientes WHERE C0='+
                   dbOperaciones.FieldByName('HO8').AsString;
  dbUsu.Active:=True;

  if (dbOperaciones.FieldByName('HO5').Value='AL') or
     (dbOperaciones.FieldByName('HO5').Value='FA') or
     (dbOperaciones.FieldByName('HO5').Value='PR') or
     (dbOperaciones.FieldByName('HO5').Value='PO')
  then                            // Impresión de albaranes, facturas, presupuestos y proformas.
  begin
                // Si está anulada no se imprime
    if dbOperaciones.FieldByName('HO16').Value='A' then
      begin
        ShowMessage('Este documento fue eliminado de la BBDD,'+#13+'no es posible su reimpresión');
        Exit;
      end;
                 // Cargamos datos en tabla para impresión.
    if dbOperaciones.FieldByName('HO5').Value='FA' then
      begin
        dbMuestrac.Active:=False;
        dbMuestrac.SQL.Text:= 'SELECT * FROM factuc'+Tienda+' WHERE FC0='+ dbOperaciones.FieldByName('HO8').AsString+
        ' AND FC1="'+FormatDateTime('YYYY/MM/DD',dbOperaciones.FieldByName('HO0').AsDateTime)+'" AND FC2="'+dbOperaciones.FieldByName('HO4').AsString+
        '" AND FC3='+dbOperaciones.FieldByName('HO3').AsString;
        dbMuestrac.Active:=True;

        dbMuestrad.Active:=False;
        dbMuestrad.SQL.Text:= 'SELECT * FROM factud'+Tienda+' WHERE FD0='+ dbOperaciones.FieldByName('HO8').AsString+
        ' AND FD1="'+FormatDateTime('YYYY/MM/DD',dbHistodd.FieldByName('HOD0').AsDateTime)+'" AND FD2="'+dbHistodd.FieldByName('HOD4').AsString+
        '" AND FD3='+dbHistodd.FieldByName('HOD3').AsString;
        dbMuestrad.Active:=True;

        Documento:='FACTURA';
      end;

     if dbOperaciones.FieldByName('HO5').Value='AL' then
      begin
        dbMuestrac.Active:=False;
        dbMuestrac.SQL.Text:= 'SELECT * FROM albac'+Tienda+' WHERE AC0='+ dbOperaciones.FieldByName('HO8').AsString+
        ' AND AC1="'+FormatDateTime('YYYY/MM/DD',dbOperaciones.FieldByName('HO0').AsDateTime)+'" AND AC2="'+dbOperaciones.FieldByName('HO4').AsString+
        '" AND AC3='+dbOperaciones.FieldByName('HO3').AsString;
        dbMuestrac.Active:=True;

        dbMuestrad.Active:=False;
        dbMuestrad.SQL.Text:= 'SELECT * FROM albad'+Tienda+' WHERE AD0='+ dbOperaciones.FieldByName('HO8').AsString+
        ' AND AD1="'+FormatDateTime('YYYY/MM/DD',dbHistodd.FieldByName('HOD0').AsDateTime)+'" AND AD2="'+dbHistodd.FieldByName('HOD4').AsString+
        '" AND AD3='+dbHistodd.FieldByName('HOD3').AsString;
        dbMuestrad.Active:=True;

        Documento:='ALBARAN';
      end;

     if dbOperaciones.FieldByName('HO5').Value='PR' then
      begin
        dbMuestrac.Active:=False;
        dbMuestrac.SQL.Text:= 'SELECT * FROM presuc'+Tienda+' WHERE PRC0='+ dbOperaciones.FieldByName('HO8').AsString+
        ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbOperaciones.FieldByName('HO0').AsDateTime)+'" AND PRC2="'+dbOperaciones.FieldByName('HO4').AsString+
        '" AND PRC3='+dbOperaciones.FieldByName('HO3').AsString;
        dbMuestrac.Active:=True;

        dbMuestrad.Active:=False;
        dbMuestrad.SQL.Text:= 'SELECT * FROM presud'+Tienda+' WHERE PRD0='+ dbOperaciones.FieldByName('HO8').AsString+
        ' AND PRD1="'+FormatDateTime('YYYY/MM/DD',dbHistodd.FieldByName('HOD0').AsDateTime)+'" AND PRD2="'+dbHistodd.FieldByName('HOD4').AsString+
        '" AND PRD3='+dbHistodd.FieldByName('HOD3').AsString;
        dbMuestrad.Active:=True;

        Documento:='PRESUPUESTO';
      end;

     if dbOperaciones.FieldByName('HO5').Value='PO' then
      begin
        dbMuestrac.Active:=False;
        dbMuestrac.SQL.Text:= 'SELECT * FROM proforc'+Tienda+' WHERE PRC0='+ dbOperaciones.FieldByName('HO8').AsString+
        ' AND PRC1="'+FormatDateTime('YYYY/MM/DD',dbOperaciones.FieldByName('HO0').AsDateTime)+'" AND PRC2="'+dbOperaciones.FieldByName('HO4').AsString+
        '" AND PRC3='+dbOperaciones.FieldByName('HO3').AsString;
        dbMuestrac.Active:=True;

        dbMuestrad.Active:=False;
        dbMuestrad.SQL.Text:= 'SELECT * FROM proford'+Tienda+' WHERE PRD0='+ dbOperaciones.FieldByName('HO8').AsString+
        ' AND PRD1="'+FormatDateTime('YYYY/MM/DD',dbHistodd.FieldByName('HOD0').AsDateTime)+'" AND PRD2="'+dbHistodd.FieldByName('HOD4').AsString+
        '" AND PRD3='+dbHistodd.FieldByName('HOD3').AsString;
        dbMuestrad.Active:=True;

        Documento:='PROFORMA';
      end;

    FImpresion.Imprime(dbMuestrad, dbMuestrac, dbUsu, Documento, false, 1);
  end;
          // Imprime operaciones con tickets.

  if (dbOperaciones.FieldByName('HO5').Value='NS') or
     (dbOperaciones.FieldByName('HO5').Value='NT') then
    begin
      ImpreTicket(false);
      if CheckBox2.Checked then ImpreTicket(true);
    end;
end;

//=====================================================================
//==================== IMPRIMIR TICKETS ===============================
//=====================================================================
procedure TFLHistoop.ImpreTicket(regalo: boolean);
var
  Texto: String;
  Precio, SubTotal: Double;
  b1,b2,b3,tiva1,tiva2,tiva3,iiva1,iiva2,iiva3: Double;
begin
  b1:=0;
  b2:=0;
  b3:=0;
  tiva1:=0;
  tiva2:=0;
  tiva3:=0;
  iiva1:=0;
  iiva2:=0;
  iiva3:=0;
  OpenDialog1.FileName:=DevTicket;
  AssignFile(PrintText, OpenDialog1.FileName);
  Rewrite(PrintText);

// -- Añadidio por Ticket Regalo
  if Checkbox2.Checked then
    begin
      Writeln(PrintText, ''); WriteLn(PrintText, ''); WriteLn(PrintText, '');
    end;
// -- FIN Añadidio por Ticket Regalo

  CabeceraTicket();
  dbHistodd.First;
  while not dbHistodd.Eof do
    begin
      if (tiva1=0) then tiva1:=dbHistodd.FieldByName('HOD13').AsInteger;
      if ((tiva2=0) and (tiva1<>dbHistodd.FieldByName('HOD13').AsInteger)) then tiva2:=dbHistodd.FieldByName('HOD13').AsInteger;
      if ((tiva3=0) and (tiva1<>dbHistodd.FieldByName('HOD13').AsInteger) and (tiva2<>dbHistodd.FieldByName('HOD13').AsInteger)) then tiva3:=dbHistodd.FieldByName('HOD13').AsInteger;

      if tiva1=dbHistodd.FieldByName('HOD13').AsInteger then
         begin
          b1:=b1+((dbHistodd.FieldByName('HOD14').AsFloat)/(1+(dbHistodd.FieldByName('HOD13').AsInteger/100)));
          {
          showmessage(FloatToStr(b1));
          showmessage(FloatToStr(dbVentas.Fields[11].AsFloat));
          showmessage(FloatToStr(1+(dbVentas.FieldByName('V10').AsInteger/100)));
          }
          iiva1:=iiva1+((dbHistodd.FieldByName('HOD14').AsFloat)-(dbHistodd.FieldByName('HOD14').AsFloat/(1+(dbHistodd.FieldByName('HOD13').AsInteger/100))))
        end;
      if tiva2=dbHistodd.FieldByName('HOD13').AsInteger then
        begin
          b2:=b2+((dbHistodd.FieldByName('HOD14').AsFloat)/(1+(dbHistodd.FieldByName('HOD13').AsInteger/100)));
          iiva2:=iiva2+((dbHistodd.FieldByName('HOD14').AsFloat)-(dbHistodd.FieldByName('HOD14').AsFloat/(1+(dbHistodd.FieldByName('HOD13').AsInteger/100))))
        end;
      if tiva3=dbHistodd.FieldByName('HOD13').AsInteger then
        begin
          b3:=b3+((dbHistodd.FieldByName('HOD14').AsFloat)/(1+(dbHistodd.FieldByName('HOD13').AsInteger/100)));
          iiva3:=iiva3+((dbHistodd.FieldByName('HOD14').AsFloat)-(dbHistodd.FieldByName('HOD14').AsFloat/(1+(dbHistodd.FieldByName('HOD13').AsInteger/100))))
        end;

      if DesgloIva='S' then
           begin
            Precio:=dbHistodd.Fieldbyname('HOD10').AsFloat;
            SubTotal:=dbHistodd.Fieldbyname('HOD12').AsFloat;
           end else
           begin
            Precio:=dbHistodd.Fieldbyname('HOD9').AsFloat;
            SubTotal:=dbHistodd.Fieldbyname('HOD14').AsFloat;
           end;
      //--- Línea con código de artículo
      if CgoEnTicket='S' then Texto:=Copy(dbHistodd.Fieldbyname('HOD6').AsString+'                    ',1,18)+' '
                         else Texto:=Copy(dbHistodd.Fieldbyname('HOD7').AsString+'                    ',1,18)+' ';

      Texto:=Texto + DataModule1.LFill(FormatFloat('##0.00',dbHistodd.FieldByName('HOD8').AsFloat),6,' ') + ' ';

// --  Añadido por Ticket REGALO
      if regalo=False then
        begin

               Texto:=Texto + DataModule1.LFill(FormatFloat('##0.00',Precio),6,' ') + ' ';
               Texto:=Texto + DataModule1.LFill(FormatFloat('###0.00',SubTotal),7,' ');

        end;

// -- FIN Añadidio por Ticket Regalo (OJO, solo el IF, el contenido del if existía antes).


      //--- Cgo Articulo en ticket (Ojo! se imprimen dos lineas por articulo)
      if CgoEnTicket='S' then
        begin
          Writeln(PrintText, Texto);
          Writeln(PrintText, Copy(dbHistodd.Fieldbyname('HOD7').AsString+'                                        ',1,40));

        end else
          Writeln(PrintText, Texto);

      dbHistodd.Next;
     end;

// -- Añadidio por Ticket Regalo

     If regalo=false then TotalTicket(b1,b2,b3,tiva1,tiva2,tiva3,iiva1,iiva2,iiva3) else
       begin
         WriteLn(PrintText, '');
         WriteLn(PrintText, '*** TICKET REGALO ***');
         WriteLn(PrintText, '');
       end;

  PieTicket();
  Corte();
  CloseFile(PrintText);
end;


//============== CABECERA DEL TICKETC ===================================
procedure TFLHistoop.CabeceraTicket();
begin
  if Trim(LCTI1)<>'' then Writeln(PrintText, LCTI1);
  if Trim(LCTI2)<>'' then Writeln(PrintText, LCTI2);
  if Trim(LCTI3)<>'' then Writeln(PrintText, LCTI3);
  if Trim(LCTI4)<>'' then Writeln(PrintText, LCTI4);
  Writeln(PrintText, ' ');

  Writeln(PrintText, 'N.FRA.SIMPL.: (H) :'+DataModule1.LFill(FormatFloat('#######',dbOperaciones.FieldByName('HO3').AsFloat),7,' '));
  {
  Writeln(PrintText, ' ');
  Writeln(PrintText, 'CLIENTE : '+dbOperaciones.FieldByName('HO8').Text);
  Writeln(PrintText, 'Forma de PAGO : '+dbOperaciones.FieldByName('HO6').Text);
  }
  Writeln(PrintText, ' ');
  Writeln(PrintText, 'Fecha.: '+FormatDateTime('dd/mm/yyyy',dbOperaciones.FieldByName('HO0').AsDateTime)+'   Hora.:'+FormatDateTime('hh:mm:ss',dbOperaciones.FieldByName('HO1').AsDateTime));
  Writeln(PrintText, ' ');
  Writeln(PrintText, 'ARTICULO              UND PRECIO   TOTAL');
  Writeln(PrintText, '========================================');
end;

//====================== PIE DEL TICKETC =============================
procedure TFLHistoop.TotalTicket(n1,n2,n3,ti1,ti2,ti3,i1,i2,i3: Double);
Var
  Texto1,Texto2,Texto3: String;
  Conta: Integer;
begin

Writeln(PrintText, ' ');
// --- Writeln(PrintText, '                               ---------'); //-- ANULADO POR JOSE PORQUE NO QUEDA BIEN LA LÍNEA

//---------------------- Desglose de Iva en ticket
if SacaIva='N' then
  begin
    Writeln(PrintText, ' ');
    Writeln(PrintText, '   Base      Tipo       Iva             ');
    Writeln(PrintText, '----------------------------------------');
//--------- IMPLEMENTADO POR JOSE PARA CONTROLAR EL MULTI-IVA
    IF ti1<>0 then
      begin
         Write(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',n1),10,' '));
         Write(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',ti1),10,' '));
         Writeln(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',i1),10,' '));
      end;
    IF ti2<>0 then
      begin
         Write(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',n2),10,' '));
         Write(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',ti2),10,' '));
         Writeln(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',i2),10,' '));
      end;
    IF ti3<>0 then
      begin
         Write(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',n3),10,' '));
         Write(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',ti3),10,' '));
         Writeln(PrintText, ''+DataModule1.LFill( FormatFloat('######0.00',i3),10,' '));
      end;

    Writeln(PrintText, '----------------------------------------');
    Writeln(PrintText, ' ');
 end
    ELSE
        Writeln(PrintText, '                               ---------');

//-------- FIN IMPLEMENTACIÓN JOSE PARA CONTROLAR EL MULTI-IVA

//---------------- Descuento
if (dbOperaciones.FieldByName('HO10').AsFloat<>0)  then
  begin
   Texto1:=DataModule1.LFill( FormatFloat('######0.00',StrToFloat(dbOperaciones.FieldByName('HO9').AsString)),10,' ');
   Texto3:=DataModule1.LFill( FormatFloat('######0.00',StrToFloat(dbOperaciones.FieldByName('HO11').AsString)),10,' ');
   Texto2:=DataModule1.LFill( FormatFloat('##0.00',StrToFloat(dbOperaciones.FieldByName('HO10').AsString)),6,' ');
   Writeln(PrintText, 'TOTAL:'+Texto1+'-'+Texto2+'% Dto ='+Texto3);
  end
else
  begin
   Texto1:=DataModule1.LFill( FormatFloat('######0.00',StrToFloat(dbOperaciones.FieldByName('HO11').AsString)),10,' ');
   Writeln(PrintText, '                    TOTAL     '+Texto1);
  end;
Texto1:=DataModule1.LFill( FormatFloat('######0.00',StrToFloat(dbOperaciones.FieldByName('HO12').AsString)),10,' ');
Writeln(PrintText, '                    ENTREGA   '+Texto1);
Texto1:=DataModule1.LFill( FormatFloat('######0.00',StrToFloat(dbOperaciones.FieldByName('HO13').AsString)),10,' ');
if StrToFloat(dbOperaciones.FieldByName('HO13').AsString)>=0 then
  Writeln(PrintText, '                    CAMBIO    '+Texto1)
else
  Writeln(PrintText, '                    CREDITO   '+Texto1);
Writeln(PrintText, ' ');
//----------------- Sacar iva uncluido en el ticket o no --------------
if SacaIva<>'N' then
  begin
   Writeln(PrintText, '            * IVA INCLUIDO *            ');
   Writeln(PrintText, ' ');
  end;
end;

procedure TFLHistoop.PieTicket();
Var
  Texto1,Texto2,Texto3: String;
  Conta: Integer;
begin

   Writeln(PrintText, 'Cliente: '+dbUsu.FieldByName('C0').AsString);
   Writeln(PrintText, dbUsu.FieldByName('C1').AsString);
   Writeln(PrintText, ' ');

  //----------------- Sacar vendedor en el ticket o no --------------
   if SacaVende<>'N' then Writeln(PrintText, 'LE ATENDIO.: '+ copy(StaticTextVend.Caption, 1, 35));

  //----------------------------------------------------------------
  if Trim(LPTI1)<>'' then Writeln(PrintText, LPTI1);
  if Trim(LPTI2)<>'' then Writeln(PrintText, LPTI2);
  if Trim(LPTI3)<>'' then Writeln(PrintText, LPTI3);
  for Conta:=1 to StrToInt(LiFinTick) do Writeln(PrintText, ' ');
end;

//================== CORTE DE PAPEL ===================
procedure TFLHistoop.Corte();
begin
  if trim(CgoCorte)='' then exit;
  WriteLn(PrintText, PCgoCorte);
end;

//====================== VER TIPOS DE DOCUMENTO =====
procedure TFLHistoop.BitBtn27Click(Sender: TObject);
begin
 if PanelLeyenda.Visible=True then
    begin
       PanelLeyenda.Visible:=False;
       BitBtn27.Caption:='Mostar Tipos';
    end else
    begin
       PanelLeyenda.BringToFront;
       PanelLeyenda.Visible:=True;
       BitBtn27.Caption:='Ocultar Tipos';
    end;
end;

//==================== SELECCIONAR ===================
procedure TFLHistoop.BitBtn3Click(Sender: TObject);
begin
  Ordenado:=False; BitBtn2.Enabled:=False; BitBtn3.Enabled:=False; BitBtn5.Enabled:=False;
  PanelRadioButton.Visible:=True; //PanelLeyenda.Visible:=False;
  PanelDetalleOperacion.Visible:=False;PanelCambiable.Visible:=True;
  LabelTituloDBGrid.Caption:='';
  DBGrid1.SendToBack;
  OcultarBDGrid();
end;

//==================== IMPRIMIR ===================
procedure TFLHistoop.BitBtn2Click(Sender: TObject);
begin
  if (RadioButton1.Checked=True) OR (RadioButton2.Checked=True)
    OR (RadioButton3.Checked=True) OR (RadioButton4.Checked=True)
    OR (RadioButton5.Checked=True) OR
       (RadioButton9.Checked=True) then FImpresion.Imprime(dbOperaciones.SQL.Text, 'ListadoHistoricoOperaciones',TituloGrid);
  if RadioButton6.Checked=True then FImpresion.Imprime(dbOperaciones.SQL.Text, 'ListadoHistoricoOperacionesArticulo',TituloGrid);
  if RadioButton7.Checked=True then FImpresion.Imprime(dbOperaciones.SQL.Text, 'ListadoHistoricoOperacionesHoras',TituloGrid);
  if RadioButton8.Checked=True then FImpresion.Imprime(dbOperaciones.SQL.Text, 'ListadoHistoricoOperacionesUsuarios',TituloGrid);
end;

//================ RECUPERAR UNA OPERACIÓN DE HISOPDDXXXX
procedure TFLHistoop.RecuperaOperacion();
//var
//  TxtQ: String;
//  FiltraHoras: String;
begin
  //TxtQ:='SELECT * FROM hisopcc'+Tienda+' WHERE '+
        //' HO0="'+FormatDateTime('YYYY/MM/DD',dbCreditos.FieldByName('CRE1').AsDateTime)+'"'+
        //' AND HO1="'+FormatDateTime('HH:MM:SS',dbCreditos.FieldByName('CRE2').AsDateTime)+'"'+
        //' AND HO2="'+Puesto+'"'+
        //' AND HO3='+dbCreditos.FieldByName('CRE5').AsString+
        //' AND HO4="'+dbCreditos.FieldByName('CRE4').AsString+'"';
  //dbHistocc.Active:=False; dbHistocc.SQL.Text:=TxtQ; dbHistocc.Active:=True;
  //if dbHistocc.RecordCount=0 then exit;
  StaticTextFecha.Caption:=FormatDateTime('DD/MM/YYYY',dbOperaciones.FieldByName('HO0').AsDateTime);//---Fecha
  StaticTextHora.Caption:=FormatDateTime('HH:MM:SS',dbOperaciones.FieldByName('HO1').AsDateTime);//--Hora
  //--------------- N. Ticket
  StaticTextNumOper.Caption:=dbOperaciones.FieldByName('HO4').AsString+'/'+dbOperaciones.FieldByName('HO3').AsString;
  //--------------- Vendedor de la operacion
  dbUsu.Active:=False;
  dbUsu.SQL.Text:='SELECT USU0, USU1 FROM usuarios'+Tienda+' WHERE USU0='+
                   dbOperaciones.FieldByName('HO7').AsString;
  dbUsu.Active:=True;
  if dbUsu.RecordCount=0 then StaticTextVend.Caption:='' else StaticTextVend.Caption:=dbUsu.FieldByName('USU1').AsString;
  dbUsu.Active:=False;
  //--------------- Cliente de la operacion
  dbUsu.Active:=False;
  dbUsu.SQL.Text:='SELECT C0, C1 FROM clientes WHERE C0='+
                   dbOperaciones.FieldByName('HO8').AsString;
  dbUsu.Active:=True;
  if dbUsu.RecordCount=0 then StaticTextCliente.Caption:='' else StaticTextCliente.Caption:=dbUsu.FieldByName('C1').AsString;
  dbUsu.Active:=False;
  //--------------------
  StaticTextTotal.Caption:=FormatFloat('0.00',dbOperaciones.FieldByName('HO9').AsFloat);//---Total
  StaticTextEntrega.Caption:=FormatFloat('0.00',dbOperaciones.FieldByName('HO12').AsFloat);//--Entrega
  StaticTextEntregaContado.Caption:=FormatFloat('0.00',dbOperaciones.FieldByName('HO14').AsFloat);//--Entrega Tarjeta + Contado
  StaticTextCambio.Caption:=FormatFloat('0.00',dbOperaciones.FieldByName('HO13').AsFloat);//--Cambio
  StaticTextTipoPago.Caption:=dbOperaciones.FieldByName('HO6').AsString;//--- Tipo de pago
  CheckBox1Click(Self);

  PanelDetalleOperacion.Visible:=True;
end;


procedure TFLHistoop.CheckBox1Click(Sender: TObject);
var
   TxtQ: String;
   FiltraHoras: String;
begin
   FiltraHoras:='';

  if (CheckBox1.Checked=False) then FiltraHoras:='AND HOD1="'+FormatDateTime('HH:MM:SS',dbOperaciones.FieldByName('HO1').AsDateTime)+'"';

  //-- MID(HOD7,1,50)
  TxtQ:='SELECT *, CONVERT(HOD7 USING UTF8) As DESCRI FROM hisopdd'+Tienda+' WHERE '+
        ' HOD0="'+FormatDateTime('YYYY/MM/DD',dbOperaciones.FieldByName('HO0').AsDateTime)+'"'+
        FiltraHoras+ nPuestoDetalles +
        ' AND HOD3='+dbOperaciones.FieldByName('HO3').AsString+
        ' AND HOD4="'+dbOperaciones.FieldByName('HO4').AsString+'"';
  dbHistodd.Active:=False; dbHistodd.SQL.Text:=TxtQ; dbHistodd.Active:=True;
end;

procedure TFLHistoop.ComboBox1Change(Sender: TObject);
begin
  BitBtn1Click(Self);
end;


//=============== PONER LINEAS DE CREDITO EN ROJO============
procedure TFLHistoop.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  dbCreditos.SQL.Text:='SELECT * FROM creditos'+Tienda+' WHERE CRE0='+
                    dbOperaciones.FieldByName('HO8').AsString+' AND CRE1="'+
                    FormatDateTime('YYYY/MM/DD',dbOperaciones.FieldByName('HO0').AsDateTime)+'"'+
                    ' AND CRE2="'+FormatDateTime('HH:MM:SS',dbOperaciones.FieldByName('HO1').AsDateTime)+'"'+
                    ' AND CRE3="'+dbOperaciones.FieldByName('HO5').AsString+'"'+
                    ' AND CRE4="'+dbOperaciones.FieldByName('HO4').AsString+'"'+
                    ' AND CRE5='+dbOperaciones.FieldByName('HO3').AsString;
  dbCreditos.Active:=True;
  if dbCreditos.RecordCount<>0 then
    begin
      DBGrid1.Canvas.Font.Color := clRed;
      //DBGrid2.Canvas.Brush.Color := $00CDDAF1;
      DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;
  dbCreditos.Active:=False;
end;

procedure TFLHistoop.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  DBGrid1CellClick( DBGrid1.SelectedColumn );
end;


// ===================== COLOREA EL LISTADO =============================
procedure TFLHistoop.Colorea(Column: TColumn;Grid: TDBGrid;dbColor: TZQuery);
var
 TxtQuery,TxtQuery1: String;
 x,j: integer;
begin
  TxtQuery:=dbColor.Sql.Text;
  j:=length(TxtQuery);
  x:=pos('ORDER',TxtQuery);
  if x=0 then x:=pos('ORDER',TxtQuery);
  delete(TxtQuery,x,j-(x-1));
  BlancoGrid(Grid);
  if AntColun <> '' then
     begin
     If StrToInt(AntColun) = Column.Index Then
        if Orden = ' ASC' then Orden:='DESC' else Orden:=' ASC';
  end;
  AntColun:=IntTostr(Column.Index);
  if Orden = 'DESC' then Column.Color := $00DEDEF5 else Column.Color := $00FDEDDF;
  dbColor.Active:=False;
  TxtQuery1:=' ORDER BY ' + Column.FieldName +' '+ Orden;
  Insert(TxtQuery1,TxtQuery,j);
  dbColor.Sql.Text:=TxtQuery; dbColor.Active:=True;
  dbColor.Refresh; Grid.Refresh; Ordenado:=True;
  TituloColumn:=Column.FieldName;
end;
//-------- Poner las columnas del grid en blanco
procedure TFLHistoop.BlancoGrid(Grid: TDBGrid);
var
  conta:integer;
begin
for conta:=0 to Grid.Columns.Count-1 do
    begin Grid.Columns[conta].Color:= clWindow;
  end;
end;

//===============================================================
//==================== OPCIONES DE LISTADOS =====================
//===============================================================
procedure TFLHistoop.RadioButton1ChangeBounds(Sender: TObject);
begin
  OcultarBDGrid();
end;

procedure TFLHistoop.RadioButton2ChangeBounds(Sender: TObject);
begin
  OcultarBDGrid();
end;

procedure TFLHistoop.RadioButton3ChangeBounds(Sender: TObject);
begin
  OcultarBDGrid();
end;

procedure TFLHistoop.RadioButton4ChangeBounds(Sender: TObject);
begin
  OcultarBDGrid();
end;

procedure TFLHistoop.RadioButton5ChangeBounds(Sender: TObject);
begin
  OcultarBDGrid();
end;

procedure TFLHistoop.RadioButton6Click(Sender: TObject);
begin
  if RadioButton6.Checked=True then
    begin
     Edit1.Visible:=True;
     Label11.Visible:=True;
     Label12.Visible:=True;
    end
  else
    begin
     Edit1.Visible:=False;
     Label11.Visible:=False;
     Label12.Visible:=False;
    end;
  OcultarBDGrid();
end;
procedure TFLHistoop.RadioButton7ChangeBounds(Sender: TObject);
begin
   OcultarBDGrid();
end;
procedure TFLHistoop.RadioButton8ChangeBounds(Sender: TObject);
begin
   OcultarBDGrid();
end;
procedure TFLHistoop.RadioButton9ChangeBounds(Sender: TObject);
begin
   OcultarBDGrid();
end;

//-------- Al pulsar en el titulo de la columna ordenar por ella
procedure TFLHistoop.DBGrid1TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid1,dbOperaciones);
end;
procedure TFLHistoop.DBGrid2TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid2,dbOperaciones);
end;
procedure TFLHistoop.DBGrid4TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid4,dbOperaciones);
end;
procedure TFLHistoop.DBGrid3TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid3,dbOperaciones);
end;
procedure TFLHistoop.DBGrid5TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid5,dbOperaciones);
end;
//========= Boton de busqueda del panel cambiable y seleccion del nombre elejido
procedure TFLHistoop.BitBtnCambiableClick(Sender: TObject);
var
 TxtQuery: String;
begin
 //-- Antigua consulta
 //-- TxtQuery:='SELECT C0, C1 FROM clientes ORDER BY C1';
 //-- CargaValoresEnComboCambiable(TxtQuery, ComboCambiableNombre, dbCambiable, LabelCambiable);
 TxtQuery := FBusquedas.IniciaBusquedas('SELECT C0, C1 FROM clientes ORDER BY C1',
           ['Codigo', ' Razón social '], 'C0' );
 EditCambiableCodigo.Text:=TxtQuery;
 EditCambiableCodigoExit(EditCambiableCodigo);
end;

procedure TFLHistoop.ComboCambiableNombreClick(Sender: TObject);
begin
  EscogeNombreComboCambiable( 'C1', ComboCambiableNombre, dbCambiable, EditCambiableCodigo, StaticTextCambiableNombre)
end;

procedure TFLHistoop.ComboCambiableNombreKeyPress(Sender: TObject;
  var Key: char);
begin
  if key=#13 then ComboCambiableNombreClick(ComboCambiableNombre);
end;

//======================= Despues de introducir un codigo, al salir, si existe,
//======================= completa el StaticText con el nombre oportuno
procedure TFLHistoop.EditCambiableCodigoExit(Sender: TObject);
var
 TxtQuery: String;
begin
  TxtQuery:='SELECT C1 FROM clientes WHERE C0="'+EditCambiableCodigo.Text+'"';
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

procedure TFLHistoop.EditCambiableCodigoEnter(Sender: TObject);
begin
  StaticTextCambiableNombre.Caption:='';
end;

//======================= OCULTA TODOS LOS DBGird y su Titulo
procedure TFLHistoop.OcultarBDGrid();
  begin
    DBGrid1.Visible:=False;
    DBGrid2.Visible:=False;
    DBGrid4.Visible:=False;
    DBGrid5.Visible:=False;
    DimensionarColocarBDGrid();
  end;
//======================= DIMENSIONA LOS DBGrid
// Los DBGrid estan "minimizados" (50x50) para poder trabajar en el resto del
// formulario, con esta funcion los adapto al Panel donde se encuentran
procedure TFLHistoop.DimensionarColocarBDGrid();
  begin
    //DBGrid1 ocupa media pantalla, dejando espacio para la leyenda y el Panel de detalle de operaciones
    DBGrid1.Top:=40;DBGrid1.Left:=0;DBGrid1.Width:=1000;DBGrid1.Height:=264;
    DBGrid4.Top:=45;DBGrid4.Left:=8;DBGrid4.Width:=554;DBGrid4.Height:=544;
    DBGrid5.Top:=45;DBGrid5.Left:=8;DBGrid5.Width:=554;DBGrid5.Height:=544;
    //DBGrid2 no semuy bien lo que hace, la dejo que ocupe toda la pantalla, como estaba
    DBGrid2.Align:=alClient;
  end;

Initialization
  {$I historicoop.lrs}

End.

