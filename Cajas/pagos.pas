unit pagos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ZConnection, ZDataset, EditBtn, DBGrids, db,
  LR_DBSet, LR_Class;

type

  { TFPagos }

  TFPagos = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    CheckBox2: TCheckBox;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    Datasource3: TDatasource;
    DateEdit1: TDateEdit;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    dbPagos: TZQuery;
    dbCambios: TZQuery;
    Panel5: TPanel;
    dbCajas: TZQuery;
    Panel6: TPanel;
    procedure DateEdit1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure LimpiaForm();
    procedure Relleno();
    Procedure Almacena();
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end; 

procedure ShowFormpagos;

var
  FPagos: TFPagos;
  TituloGrid: String;

implementation

Uses
    Global, Funciones;

{ TFPagos }
procedure ShowFormpagos;
begin
  with TFpagos.Create(Application) do
    begin
       ShowModal;
    end;
end;

procedure TFPagos.FormCreate(Sender: TObject);
begin
  ShortDateFormat:='DD/MM/YYYY';
  {$IFDEF LINUX}
     DecimalSeparator:='.';
  {$ELSE}
     DecimalSeparator:=',';
  {$ENDIF}
  //----------------- CONEXION -----------------
  //Conectate(dbConect);  // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Tablas ------------------
  dbPagos.Sql.Text:='SELECT * FROM gpagos'+Tienda+'';
  dbPagos.Active := True;
  dbCambios.Sql.Text:='SELECT * FROM geconomica'+Tienda+'';
  dbCambios.Active := True;
  //------------------- Inicializacion ----------
  DateEdit1.Date:=Date;       // -- Asigna fecha a los campos
  LimpiaForm();
  Relleno();
end;

procedure TFPagos.FormActivate(Sender: TObject);
begin
  Edit7.SetFocus;
end;

procedure TFPagos.DateEdit1Change(Sender: TObject);
begin
  LimpiaForm();
  Relleno();
end;

//========= Limpia DATOS =============
Procedure TFPagos.LimpiaForm();
Begin
  Edit1.Text:='0';            // -- Retirada de Fondos
  Edit2.Text:='0';            // -- Incremento de Cambios
  Edit3.Text:='0';            // -- Saldo Inicial
  Edit4.Text:='0';            // -- Acumulado Saldo Inicial
  Edit5.Text:='0';            // -- Acumulado Incremento de Cambios
  Edit6.Text:='0';            // -- Acumulado Retirada de fondos
  Edit7.Text:='0';            // -- Nueva cantidad a Pagar
  Edit8.Text:='0';            // -- Acumulado Pagado
  Edit9.Text:='';             // -- Concepto del Pago
  Memo1.Lines.Text:='';             // -- Observaciones de Pagos
  Memo2.Lines.Text:='';             // -- Olbsrvaciones de Gestion Economica
End;
//========= Pinta DATOS ==============
Procedure TFPagos.Relleno();
Begin
  dbCajas.Sql.Text:='SELECT * FROM cajas'+Tienda+' where CA0="'+FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text)) +'" and CA1="9999" and CA3="9999" and CA2="'+Puesto+'"';
  dbCajas.Active := True;

  if dbCajas.RecordCount=0 then exit;

  Edit4.Text:=dbCajas.FieldByName('CA16').AsString;            // -- Acumulado Saldo Inicial
  Edit5.Text:=dbCajas.FieldByName('CA17').AsString;            // -- Acumulado Incremento de Cambios
  Edit6.Text:=dbCajas.FieldByName('CA18').AsString;            // -- Acumulado Retirada de fondos
  Edit8.Text:=dbCajas.FieldByName('CA19').AsString;            // -- Acumulado Pagado

End;

//=========== Almacena información en Cajas + tienda ==========
procedure TFPagos.Almacena();
Begin
//--- Almacena Información de pagos/economica en la CAJA
  dbCajas.Sql.Text:='SELECT * FROM cajas'+Tienda+' where CA0="'+FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text)) +'" and CA1="9999" and CA3="9999" and CA2="'+Puesto+'"';
  dbCajas.Active := True;

  if dbCajas.RecordCount=0 then
   begin
     dbCajas.Append;
     dbCajas.FieldByName('CA0').AsDateTime:=DateEdit1.Date;
     dbCajas.FieldByName('CA1').AsString:='9999';
     dbCajas.FieldByName('CA2').AsString:=Puesto;
     dbCajas.FieldByName('CA3').AsString:='9999';
     dbCajas.FieldByName('CA16').AsString:=Edit3.Text;
     dbCajas.FieldByName('CA17').AsString:=Edit2.Text;
     dbCajas.FieldByName('CA18').AsString:=Edit1.Text;
     dbCajas.FieldByName('CA19').AsString:=Edit7.Text;
   end
  Else
   begin
     dbCajas.Edit;
     dbCajas.FieldByName('CA16').AsString:= FloatToStr(StrtoFloat(Edit4.Text)+StrtoFloat(Edit3.Text)); // -- Saldo Inicial
     dbCajas.FieldByName('CA17').AsString:= FloatToStr(StrtoFloat(Edit5.Text)+StrtoFloat(Edit2.Text)); // -- Incremento Salda
     dbCajas.FieldByName('CA18').AsString:= FloatToStr(StrtoFloat(Edit6.Text)+StrtoFloat(Edit1.Text)); // -- Retirada de Fondos
     dbCajas.FieldByName('CA19').AsString:= FloatToStr(StrtoFloat(Edit8.Text)+StrtoFloat(Edit7.Text)); // -- Pagos Varios
   end;
   dbCajas.Post;
   dbCajas.ApplyUpdates;
End;

//============= Control de botones en pantalla ================
//---------- Nuevo ----------------
Procedure TFPagos.Bitbtn1click(Sender: Tobject); //-Nuevo
Begin
     Panel5.Visible:=True;
     Bitbtn1.enabled:=false;
     Bitbtn2.enabled:=false;
     Bitbtn3.enabled:=false;
     Bitbtn4.enabled:=false;
End;

Procedure TFPagos.Bitbtn11click(Sender: Tobject); //-Salir Nuevo
Begin
     Panel5.Visible:=False;
     Bitbtn1.enabled:=true;
     Bitbtn2.enabled:=true;
     Bitbtn3.enabled:=true;
     Bitbtn4.enabled:=true;

End;

Procedure TFPagos.Bitbtn12click(Sender: Tobject); //- Nuevo Pagos
Begin
     Panel5.Visible:=False;
     Bitbtn1.enabled:=true;
     Bitbtn2.enabled:=true;
     Bitbtn3.enabled:=true;
     Bitbtn4.enabled:=true;

  if Edit7.Text='0' then exit;
  if Edit9.Text='' then
    begin
         showmessage('El CONCEPTO no puede estar en blanco');
         Edit9.SetFocus;
         exit;
    end;

  dbPagos.Sql.Text:='SELECT * FROM gpagos'+Tienda+' WHERE Fecha="'+  FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text)) +'" and Importe="'+Edit7.Text+'" and Concepto="'+Edit9.Text+'"';
  dbPagos.Active := True;
  if dbPagos.RecordCount=1 then
   begin
     Showmessage('ESE REGISTRO YA EXISTE');
     dbPagos.Sql.Text:='SELECT * FROM gpagos'+Tienda+'';
     dbPagos.Active := True;
     exit;
   end;
   dbPagos.Append;
//---- Almacena Información en PAGOS
   dbPagos.FieldByName('Fecha').AsDateTime:=DateEdit1.Date;//-------- Fecha de la Anotación del PAGO
   dbPagos.FieldByName('Importe').AsString:=Edit7.Text;//----- Importe del PAGO
   dbPagos.FieldByName('Concepto').AsString:=Edit9.Text;//---------------- Concepto del PAGO
   dbPagos.FieldByName('Observaciones').AsString:=Memo1.Lines.Text;//---------------- Observaciones

   dbPagos.Post;
   showmessage('Almacenado');
   Almacena();
   LimpiaForm();
   Relleno();

End;

Procedure TFPagos.Bitbtn13click(Sender: Tobject); //- Nuevo Cambios
Begin
     Panel5.Visible:=False;
     Bitbtn1.enabled:=true;
     Bitbtn2.enabled:=true;
     Bitbtn3.enabled:=true;
     Bitbtn4.enabled:=true;

  if (Edit3.Text='0') and (Edit2.Text='0') and (Edit1.Text='0') then exit;
  if Memo2.Text='' then
   begin
        showmessage('Debe introducir algún comentario en OBSERVACIONES');
        Memo2.SetFocus;
        exit;
   end;

   dbCambios.Append;
//---- Almacena Información en CAMBIOS
   dbCambios.FieldByName('Fecha').AsDateTime:=DateEdit1.Date;//-------- Fecha de la Anotación del CAMBIO/RETIRADA FONDOS
   dbCambios.FieldByName('SaldoI').AsString:=Edit3.Text;//----- Importe del SALDO INICIAL
   dbCambios.FieldByName('Cambios').AsString:=Edit2.Text;//---------------- Importe del incremento del CAMBIO
   dbCambios.FieldByName('RetiraF').AsString:=Edit1.Text;//---------------- Importe de la RETIRADA DE FONDOS
   dbCambios.FieldByName('Observaciones').AsString:=Memo2.lines.Text;//---------------- Observaciones

   dbCambios.Post;
   dbCambios.ApplyUpdates;
   showmessage('Almacenado');
   Almacena();
   LimpiaForm();
   Relleno();

End;

//---------- Consultar ----------------
Procedure TFPagos.Bitbtn2click(Sender: Tobject); //-Consultar
Begin
     Panel4.Visible:=True;
     Bitbtn1.enabled:=false;
     Bitbtn2.enabled:=false;
     Bitbtn3.enabled:=false;
     Bitbtn4.enabled:=false;
End;

Procedure TFPagos.Bitbtn9click(Sender: Tobject); //- Pagos
Begin
     If CheckBox2.Checked then
        Begin
             dbPagos.Active:=False;
             dbPagos.Sql.Text:='SELECT * FROM gpagos'+Tienda+'';
             dbPagos.Active:=True;
        End
     Else
         Begin
             dbPagos.Active:=False;
             dbPagos.Sql.Text:='SELECT * FROM gpagos'+Tienda+' WHERE Fecha="'+FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text))+'"';
             dbPagos.Active:=True;
         End;
     DBGrid1.visible:=True;
End;

Procedure TFPagos.Bitbtn10click(Sender: Tobject); //- Cambios
Begin
     If CheckBox2.Checked then
        Begin
             dbCambios.Active:=False;
             dbCambios.Sql.Text:='SELECT * FROM geconomica'+Tienda+'';
             dbCambios.Active:=True;
        End
     Else
         Begin
             dbCambios.Active:=False;
             dbCambios.Sql.Text:='SELECT * FROM geconomica'+Tienda+' WHERE Fecha="'+FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text))+'"';
             dbCambios.Active:=True;
         End;
     DBGrid2.visible:=True;
End;

Procedure TFPagos.Bitbtn8click(Sender: Tobject); //-Salir consultar
Begin
     Panel4.Visible:=False;
     Bitbtn1.enabled:=true;
     Bitbtn2.enabled:=true;
     Bitbtn3.enabled:=true;
     Bitbtn4.enabled:=true;
     DBGrid1.Visible:=False;
     DBGrid2.Visible:=False;
End;

//---------- Imprimir ----------------
Procedure TFPagos.Bitbtn3click(Sender: Tobject); //-Imprimir
Begin
     Panel3.Visible:=True;
     Bitbtn1.enabled:=false;
     Bitbtn2.enabled:=false;
     Bitbtn3.enabled:=false;
     Bitbtn4.enabled:=false;
End;

Procedure TFPagos.Bitbtn5click(Sender: Tobject); //-Salir Imprimir
Begin
     Panel3.Visible:=False;
     Bitbtn1.enabled:=true;
     Bitbtn2.enabled:=true;
     Bitbtn3.enabled:=true;
     Bitbtn4.enabled:=true;
End;
//==================== IMPRIMIR ===================
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFPagos.frReport1GetValue(const ParName: String;
var ParValue: Variant);
begin
if ParName='EMPRESA' then ParValue := Empresa;
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

procedure TFPagos.BitBtn6Click(Sender: TObject);
var
  TxtQuery:String;
begin
  //-------------------------- Datos Principales
  //--- PAGOS
      TituloGrid:='Listado de Cajas - PAGOS';
     If CheckBox2.Checked then
        Begin
             TxtQuery:='SELECT * FROM gpagos'+Tienda+'';
        End
     Else
         Begin
             TxtQuery:='SELECT * FROM gpagos'+Tienda+' WHERE Fecha="'+FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text))+'"';
         End;
      dbPagos.Active:=False; dbPagos.Sql.Text:=TxtQuery; dbPagos.Active:=True;
     if dbPagos.RecordCount=0 then
       begin
         Showmessage('NO HAY INFORMACION ENTRE ESOS DATOS');
         exit;
       end;
     frDBDataSet1.DataSet:=dbPagos;
     frReport1.LoadFromFile(RutaReports+'ListaCajasPagos.lrf');
     frReport1.ShowReport;
end;
procedure TFPagos.BitBtn7Click(Sender: TObject);
var
  TxtQuery:String;
begin
  //-------------------------- Datos Principales
  //--- CAMBIOS
      TituloGrid:='Listado de Cajas - CAMBIOS';
     If CheckBox2.Checked then
        Begin
             TxtQuery:='SELECT * FROM geconomica'+Tienda+'';
        End
     Else
         Begin
             TxtQuery:='SELECT * FROM geconomica'+Tienda+' WHERE Fecha="'+FormatDateTime('YYYY/MM/DD',StrToDate(DateEdit1.Text))+'"';
         End;
      dbCambios.Active:=False; dbCambios.Sql.Text:=TxtQuery; dbCambios.Active:=True;
     if dbCambios.RecordCount=0 then
       begin
         Showmessage('NO HAY INFORMACION ENTRE ESOS DATOS');
         exit;
       end;
     frDBDataSet1.DataSet:=dbCambios;
     frReport1.LoadFromFile(RutaReports+'ListaCajasCambios.lrf');
     frReport1.ShowReport;
end;

// ========== Cerrar Formulario de Pagos ===========
Procedure TFPagos.Bitbtn4click(Sender: Tobject);
Begin
     Close;
End;

initialization
  {$I pagos.lrs}

end.
