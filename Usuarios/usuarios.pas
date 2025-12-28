{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2010

  Antonio Dominguez
  Equipo de colaboradores.

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

Unit Usuarios;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, Inifiles, ZConnection, ZDataset, StdCtrls, ExtCtrls, LCLType,
  Process, DBGrids, TAGraph, TASeries, LR_DBSet, LR_Class, db, DbCtrls, ExtDlgs;


Type

  { TFUsuarios }

  TFUsuarios = Class(Tform)
    Bevel1: TBevel;
    BitBtn12: TBitBtn;
    BitBtn21: TBitBtn;
    BitBtn7: TBitBtn;
    Chart1: TChart;
    Chart1AreaSeries1: TAreaSeries;
    Chart1BarSeries1: TBarSeries;
    Chart1PieSeries1: TPieSeries;
    Chart1Serie1: TLineSeries;
    Datasource1: TDatasource;
    dbGrafica: TZQuery;
    dbEsta: TZQuery;
    DBGrid1: TDBGrid;
    dbUsuarios: TZQuery;
    dbUsuarios1: TZQuery;
    dbRoles: TZQuery;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
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
    Image1: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label57: TLabel;
    Label65: TLabel;
    Label68: TLabel;
    Label7: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lbBeneficio: TLabel;
    lbIC: TLabel;
    lbIVC: TLabel;
    lbIVP: TLabel;
    lbUC: TLabel;
    lbUV: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    ListBox6: TListBox;
    Memo1: TMemo;
    Edit1: Tedit;
    OpenPictureDialog1: TOpenPictureDialog;
    Panel1: Tpanel;
    Bitbtn2: Tbitbtn;
    Bitbtn3: Tbitbtn;
    Bitbtn4: Tbitbtn;
    Bitbtn5: Tbitbtn;
    Bitbtn6: Tbitbtn;
    Bitbtn1: Tbitbtn;
    Label2: TLabel;
    Pagecontrol1: Tpagecontrol;
    PanelNuevoUs: TPanel;
    Panel3: TPanel;
    Tabsheet2: Ttabsheet;
    Tabsheet3: Ttabsheet;
    TabSheet4: TTabSheet;
    dbTrabajo: TZQuery;

    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn21Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure Edit13Enter(Sender: TObject);
    procedure Edit13Exit(Sender: TObject);
    procedure Edit1MouseEnter(Sender: TObject);
    procedure Edit1MouseLeave(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure Edit9Exit(Sender: TObject);
    Procedure Formcreate(Sender: Tobject);
    Procedure Edit1enter(Sender: Tobject);
    Procedure Edit1exit(Sender: Tobject);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    Procedure LimpiaForm();
    procedure ListBox6Click(Sender: TObject);
    Procedure Relleno();
    Procedure LlenaReg();
    Procedure Bitbtn1click(Sender: Tobject);
    Procedure Bitbtn6click(Sender: Tobject);
    Procedure Bitbtn5click(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    Procedure Bitbtn4click(Sender: Tobject);
    Procedure Bitbtn2click(Sender: Tobject);
    Procedure Bitbtn3click(Sender: Tobject);
    
    procedure ListBox1Click(Sender: TObject);
    procedure RellenaEsta(Ano: String);

    procedure Graficas();
    procedure ListBox2Click(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure CambiarGrafica();


  Private
    { Private Declarations }
  Public
    { Public Declarations }
//   IniReader : TIniFile; //quitado por javi no se usa
//   Sections : TStringList;//quitado por javi no se usa
//   Contents : TStringList; //quitado por javi no se usa
  End;

  procedure ShowFormUsuarios;
  
Var
  FUsuarios: TFUsuarios;
  CargaGrafica,NTienda: Integer;
  s: TBarSeries;
  CodUsuSic: String;
  TituloGrid: String;


Implementation

uses
  Global, Funciones, Busquedas;

//=============== Crea el formulario ================
procedure ShowFormUsuarios;
begin
  with TFUsuarios.Create(Application) do
    begin
       ShowModal;
    end;
end;

//============ Conexion a la bbdd y carga de datos =========
Procedure TFUsuarios.Formcreate(Sender: Tobject);
Begin
  //----------------- CONEXION -----------------
  //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.

  //------------------- Tablas ------------------
  dbUsuarios.Sql.Text:='SELECT * FROM usuarios0000 ORDER BY USU0';
  dbUsuarios.Active := True;
  //------------------- Roles ---------------------
  BitBtn4.Enabled:=CheckRoles(dbRoles, CgRol, 'Usuarios', 2);//------------------ Boton Modificar
  BitBtn3.Enabled:=CheckRoles(dbRoles, CgRol, 'Usuarios', 3);//------------------ Boton Borrar
  if CheckRoles(dbRoles, CgRol, 'Usuarios', 4)=False then Tabsheet2.Destroy;//--- Estadisticas
  if CheckRoles(dbRoles, CgRol, 'Usuarios', 4)=False then Tabsheet3.Destroy;//--- Graficas
End;

//==================== IMAGEN =======================
procedure TFUsuarios.Edit9Exit(Sender: TObject);
begin
  if Edit9.Text='' then
    begin
      Image1.Picture:=Nil; Image1.Refresh;
    end;
  if FileExists(Edit9.Text) then
    Image1.Picture.LoadFromFile(Edit9.Text)
  else
    begin
     Image1.Picture:=Nil; Image1.Refresh;
    end;
end;
procedure TFUsuarios.BitBtn12Click(Sender: TObject);
begin
 if openPictureDialog1.Execute then
   begin
     Edit9.Text:=openPictureDialog1.FileName;
     if FileExists(openPictureDialog1.FileName) then
       Image1.Picture.LoadFromFile(openPictureDialog1.FileName)
   end;
end;

//=================== BOTON LOPD ================
procedure TFUsuarios.frReport1GetValue(const ParName: String;
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
   if ParName='REGISTRO' then ParValue := REGISTRO;
end;

procedure TFUsuarios.BitBtn21Click(Sender: TObject);
var
  TxtQuery:String;
begin
      TituloGrid:='LOPD - Firma de privacidad de datos';
      TxtQuery:='SELECT * FROM usuarios'+tienda+' WHERE USU0="'+Edit1.Text+'"';
      dbUsuarios1.Active:=False; dbUsuarios1.Sql.Text:=TxtQuery; dbUsuarios1.Active:=True;
     if (dbUsuarios1.RecordCount=0) then
       begin
         Showmessage('NO HA SELECCIONADO NINGÚN USUARIO');
         exit;
       end;
     frDBDataSet1.DataSet:=dbUsuarios1;
     frReport1.LoadFromFile(RutaReports+'LopdUsuarios.lrf');
     frReport1.ShowReport;
end;

//================= BUSCAR USUARIOS ==================
procedure TFUsuarios.BitBtn7Click(Sender: TObject);
begin
  if Edit2.Text='' then begin
     ShowMessage('DEBE TECLEAR EL TEXTO A BUSCAR');
     Edit2.SetFocus;
     Exit;
  End;
  Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT USU0,USU1 FROM usuarios'+Tienda+' WHERE USU1 LIKE "%'+Edit2.Text+'%"',
                                          ['Código','Nombre'],'USU0');
  if Edit1.Text='-1' then Edit1.Text:='' else Edit1Exit(Edit1);
End;
procedure TFUsuarios.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if (key=#13) then BitBtn7Click(BitBtn7);
end;

//==================== CERRAR ======================
Procedure TFUsuarios.Bitbtn1click(Sender: Tobject);
Begin
  Close();
End;
Procedure TFUsuarios.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;
//=================== REGISTRO NUEVO ===================
Procedure TFUsuarios.Bitbtn2click(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
  if dbUsuarios.Locate('USU0', Edit1.Text, []) then
    begin
      Showmessage('ESE REGISTRO YA EXISTE');
      exit;
    end;
   dbUsuarios.Append;
   LlenaReg();
   dbUsuarios.Post;
   Label2.Caption:=dbUsuarios.Fields[1].AsString;//--- Refrescar nombre.}
End;
//=================== BORRAR REGISTRO ===================
Procedure TFUsuarios.Bitbtn3click(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
  if not dbUsuarios.Locate('USU0', Edit1.Text, []) then
    begin
      Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE BORRARLO!');
      exit;
    end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME EL BORRADO DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
  dbUsuarios.Delete;
  Edit1.Text := '';
  LimpiaForm();
End;

//=================== MODIFICAR ===================
Procedure TFUsuarios.Bitbtn4click(Sender: Tobject);
Begin
   if (Edit1.Text='') or (dbUsuarios.Recordcount=0) then exit;
   if not dbUsuarios.Locate('USU0,', Edit1.Text, []) then
     begin
       Showmessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO!');
       exit;
     end;
   boxstyle :=  MB_ICONQUESTION + MB_YESNO;
   If Application.MessageBox('CONFIRME LA MODIFICACION DEL REGISTRO','FacturLinEx', boxstyle) = IDNO Then
      Exit;
   dbUsuarios.Edit; LlenaReg(); dbUsuarios.Post;
   Label2.Caption:=dbUsuarios.Fields[1].AsString;//--- Refrescar nombre.}
End;


//==================== REG. ANTERIOR ===============
Procedure TFUsuarios.Bitbtn5click(Sender: Tobject);
Begin
  dbUsuarios.Prior;
  LimpiaForm(); Relleno();
End;

//==================== REG. POSTERIOR ===============
Procedure TFUsuarios.Bitbtn6click(Sender: Tobject);
Begin
   dbUsuarios.Next;
   LimpiaForm(); Relleno();
End;


//=================== CODIGO DE USUARIO ================
Procedure TFUsuarios.Edit1enter(Sender: Tobject);
Begin
 Edit1.Text := '';
 LimpiaForm();
End;
Procedure TFUsuarios.Edit1exit(Sender: Tobject);
Begin
  if Edit1.Text='' then exit;
   if dbUsuarios.Locate('USU0', Edit1.Text, []) then
     Relleno() else LimpiaForm();
End;


//==================== CODIGO DE ROL ======================
procedure TFUsuarios.Edit13Enter(Sender: TObject);
begin
  Label17.Caption:='';
end;
procedure TFUsuarios.Edit13Exit(Sender: TObject);
begin
  if Edit13.Text='' then exit;
  dbRoles.SQL.Text:='SELECT * FROM roles'+Tienda+' WHERE CgoRol='+Edit13.Text;
  dbRoles.Active:=True;
  if dbRoles.RecordCount=0 then exit;
  Label17.Caption:=dbRoles.FieldByName('Descrirol').AsString;
  dbRoles.Active:=False;
end;

procedure TFUsuarios.Edit1MouseEnter(Sender: TObject);
var
  Ultimo : Integer;
begin
  PanelNuevoUs.Visible:=True;
  //------ Ver cual es el ultimo proveedor en nuestro file
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT USU0 FROM usuarios'+Tienda+' where USU0<999990 ORDER BY USU0 DESC';
  dbTrabajo.Active:=True;
  if dbTrabajo.RecordCount=0 then Ultimo:=1 else Ultimo:=dbTRabajo.FieldByName('USU0').AsInteger+1;
  //------ Cargar datos en pantalla
  PanelNuevoUs.Caption:=IntToStr(Ultimo);
end;

procedure TFUsuarios.Edit1MouseLeave(Sender: TObject);
begin
  PanelNuevoUs.Visible:=False;
end;



//===================== LIMPIAR DATOS =======================
Procedure TFUsuarios.LimpiaForm();
Begin
  Edit2.Text:=''; Edit3.Text:=''; Edit4.Text:=''; Edit5.Text:='';
  Edit6.Text:=''; Label2.Caption:='';
  Edit7.Text:=''; Edit8.Text:=''; Edit9.Text:=''; Edit10.Text:='';
  Edit11.Text:=''; Edit12.Text:=''; Edit13.Text:='0';
  Memo1.Lines.Text:='';
  Image1.Picture:=Nil;
End;

//===================== PINTAR DATOS =======================
Procedure TFUsuarios.Relleno();
Begin
  if dbUsuarios.RecordCount=0 then exit;
  Label2.Caption:=dbUsuarios.FieldByName('USU1').AsString;
  Edit1.Text:=dbUsuarios.FieldByName('USU0').AsString;//------------ Cgo. Usuario
  Edit2.Text:=dbUsuarios.FieldByName('USU1').AsString;//------------ Nombre
  Edit3.Text:=dbUsuarios.FieldByName('USU2').AsString;//------------ Direccion
  Edit4.Text:=dbUsuarios.FieldByName('USU3').AsString;//------------ Localidad
  Edit5.Text:=dbUsuarios.FieldByName('USU4').AsString;//------------ Codigo p.
  Edit6.Text:=dbUsuarios.FieldByName('USU5').AsString;//------------ Provincia
  Edit7.Text:=dbUsuarios.FieldByName('USU7').AsString;//------------ NIF
  Edit8.Text:=dbUsuarios.FieldByName('USU6').AsString;//------------ Telefono
  Edit10.Text:=dbUsuarios.FieldByName('USU8').AsString;//----------- E-Mail
  Edit11.Text:=dbUsuarios.FieldByName('USU9').AsString;//----------- Usuario
  Edit12.Text:=dbUsuarios.FieldByName('USU10').AsString;//---------- Clave Usuario
  Edit13.Text:=dbUsuarios.FieldByName('USU11').AsString;//---------- Cgo. Rol
  Edit13Exit(Edit13);
  Edit9.Text:=dbUsuarios.FieldByName('USU13').AsString;//------------ Imagen
  if (Edit9.Text<>'') and (FileExists(Edit9.Text)) then
    Image1.Picture.LoadFromFile(Edit9.Text);
  Memo1.Lines.Text:=dbUsuarios.FieldByName('USU12').AsString;//----- Observaciones


  //-------------- Estadisticas --------------------

  RellenaEsta(FormatDateTime('YYYY',Date));//--------- Rellenar los meses que esten a 0
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT *, TUSU6-TUSU7 As BENEF FROM estausu'+Tienda+' WHERE TUSU0="'+Edit1.Text+'"'+
                   ' AND TUSU1='+FormatDateTime('YYYY',Date)+
                   ' ORDER BY TUSU1 ASC, TUSU2 ASC';
  dbEsta.Active:=True;
  //------------------------------------------------
  CargaGrafica:=1; Graficas(); CargaGrafica:=0;//---------------- Pintar Graficas
end;

//===================== RELLENAR DATOS =======================
Procedure TFUsuarios.LlenaReg();
Begin
  dbUsuarios.FieldByName('USU0').AsString:=Edit1.Text;//------------ Cgo. Usuario
  dbUsuarios.FieldByName('USU1').AsString:=Edit2.Text;//------------ Nombre
  dbUsuarios.FieldByName('USU2').AsString:=Edit3.Text;//------------ Direccion
  dbUsuarios.FieldByName('USU3').AsString:=Edit4.Text;//------------ Localidad
  dbUsuarios.FieldByName('USU4').AsString:=Edit5.Text;//------------ Codigo p.
  dbUsuarios.FieldByName('USU5').AsString:=Edit6.Text;//------------ Provincia
  dbUsuarios.FieldByName('USU7').AsString:=Edit7.Text;//------------ NIF
  dbUsuarios.FieldByName('USU6').AsString:=Edit8.Text;//------------ Telefono
  dbUsuarios.FieldByName('USU8').AsString:=Edit10.Text;//----------- E-Mail
  dbUsuarios.FieldByName('USU9').AsString:=Edit11.Text;//----------- Usuario
  dbUsuarios.FieldByName('USU10').AsString:=Edit12.Text;;//---------- Clave Usuario
  dbUsuarios.FieldByName('USU11').AsString:=Edit13.Text;;//---------- Nivel de acceso

  dbUsuarios.FieldByName('USU12').AsString:=Memo1.Lines.Text;//----- Observaciones
  dbUsuarios.FieldByName('USU13').AsString:=Edit9.Text;//----------- Imagen


End;


//----------------- Cambiar estadisticas ---------------
procedure TFUsuarios.ListBox1Click(Sender: TObject);
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox1.Items.Count=0 then exit;//----- Si no hay años
  if ListBox1.ItemIndex=-1 then ListBox1.ItemIndex:=0;
  RellenaEsta(ListBox1.Items.Strings[ListBox1.ItemIndex]);//--------- Rellenar los meses que esten a 0
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT *, TUSU6-TUSU7 As BENEF FROM estausu'+Tienda+' WHERE TUSU0="'+Edit1.Text+'"'+
                   ' AND TUSU1='+ListBox1.Items.Strings[ListBox1.ItemIndex]+
                   ' ORDER BY TUSU1 ASC, TUSU2 ASC';
  dbEsta.Active:=True;
end;

//==========================================================
//============= RELLENAR MESES QUE ESTEN A 0 ===============
//==========================================================
procedure TFUsuarios.RellenaEsta(Ano: String);
var
  Conta: Integer;
  UC,IC,UV,IVP,IVC,Beneficio : Double;
begin
  dbEsta.Active:=False;
  dbEsta.SQL.Text:='SELECT * FROM estausu'+Tienda+' WHERE TUSU0="'+Edit1.Text+'"'+
                   ' AND TUSU1='+Ano+
                   ' ORDER BY TUSU1 ASC, TUSU2 ASC';
  dbEsta.Active:=True;
  dbEsta.First;

  //*********** IMPLEMENTACIÓN DE MUESTREO DE TOTALES
    UC:=0; IC:=0; UV:=0; IVP:=0; IVC:=0; Beneficio:=0;
    While not dbEsta.EOF do
      begin
        UC := UC + dbEsta.FieldByName('TUSU3').Value;
        IC := IC + dbEsta.FieldByName('TUSU4').Value;
        UV := UV + dbEsta.FieldByName('TUSU5').Value;
        IVP := IVP + dbEsta.FieldByName('TUSU6').Value;
        IVC := IVC + dbEsta.FieldByName('TUSU7').Value;
        Beneficio := Beneficio + ( dbEsta.FieldByName('TUSU6').Value - dbEsta.FieldByName('TUSU7').Value );
        dbEsta.Next;
      end;

    lbUC.Caption := FormatFloat('#0.00',UC);
    lbIC.Caption := FormatFloat('#0.00',IC);
    lbUV.Caption := FormatFloat('#0.00',UV);
    lbIVP.Caption := FormatFloat('#0.00',IVP);
    lbIVC.Caption := FormatFloat('#0.00',IVC);
    lbBeneficio.Caption := FormatFloat('#0.00',Beneficio);

    dbEsta.First;
  //*********** FIN IMPLEMENTACIÓN DE MUESTREO DE TOTALES

  for Conta:=1 to 12 do
    begin
      if not dbEsta.Locate('TUSU2',Conta,[]) then
        begin
           dbEsta.Append;
           dbEsta.FieldByName('TUSU0').AsString:=Edit1.Text;
           dbEsta.FieldByName('TUSU1').AsString:=Ano;
           dbEsta.FieldByName('TUSU2').AsString:=IntToStr(Conta);
           dbEsta.Post;
        end;
    end;
end;



//============================================================
//===================== GRAFICAS =============================
//============================================================

procedure TFUsuarios.Graficas();
Var
  Conta: Integer;
begin

  //-------------- Mostrar los distintos años ------------------
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT DISTINCT TUSU1 FROM estausu'+Tienda+' WHERE TUSU0="'+Edit1.Text+'" ORDER BY TUSU1 DESC';
  dbGrafica.Active:=True;
  ListBox1.Items.Clear; ListBox2.Items.Clear;
  dbGrafica.First;
  while not dbGrafica.EOF do
    begin
      ListBox1.Items.Add(dbGrafica.FieldByName('TUSU1').AsString);
      ListBox2.Items.Add(dbGrafica.FieldByName('TUSU1').AsString);
      dbGrafica.Next;
    end;
  ListBox2.ItemIndex:=0;

  //-------------- Mostrar las unidades compradas ------------------

  if ListBox2.Items.Count<>0 then
    begin
     ListBox2.ItemIndex:=0;
     Chart1Serie1.Clear; Chart1AreaSeries1.Clear;
     Chart1BarSeries1.Clear; Chart1PieSeries1.Clear;
     dbGrafica.Active:=False;
     dbGrafica.SQL.Text:='SELECT *, TUSU6-TUSU7 As BENEF FROM estausu'+Tienda+' WHERE TUSU0="'+Edit1.Text+'"'+
                         ' AND TUSU1='+ListBox2.Items.Strings[ListBox2.ItemIndex]+
                         ' ORDER BY TUSU1 ASC, TUSU2 ASC';
     dbGrafica.Active:=True; ListBox6.ItemIndex:=0;
     dbGrafica.First; Chart1.Title.Text.Text:='Unidades Compradas';
     for conta:=1 to dbGrafica.RecordCount do
       begin
        Chart1Serie1.AddXY(conta,dbGrafica.Fields[3].AsInteger, FloatToStr(dbGrafica.Fields[3].AsFloat), clred);
        Chart1AreaSeries1.AddXY(conta,dbGrafica.Fields[3].AsInteger, FloatToStr(dbGrafica.Fields[3].AsFloat), clred);
        Chart1BarSeries1.AddXY(conta,dbGrafica.Fields[3].AsInteger, FloatToStr(dbGrafica.Fields[3].AsFloat), clred);
        Chart1PieSeries1.AddXY(conta,dbGrafica.Fields[3].AsInteger, FloatToStr(dbGrafica.Fields[3].AsFloat), clred);
        dbGrafica.Next;
       end;
    end;
end;

//------------------ Cambiar años grafica -------------------
procedure TFUsuarios.ListBox2Click(Sender: TObject);
begin
  CambiarGrafica();
end;

//------------------ Cambiar datos grafica -------------------
procedure TFUsuarios.ListBox3Click(Sender: TObject);
begin
  CambiarGrafica();
end;

//----------------- Cambiar tipo de grafica ----------------
procedure TFUsuarios.ListBox6Click(Sender: TObject);
begin
 Chart1Serie1.Active:=False; Chart1AreaSeries1.Active:=False;
 Chart1BarSeries1.Active:=False; Chart1PieSeries1.Active:=False;
 case ListBox6.ItemIndex of
   0: Chart1Serie1.Active:=True;
   1: Chart1BarSeries1.Active:=True;
   2: Chart1AreaSeries1.Active:=True;
   3: Chart1PieSeries1.Active:=True;
 end;
end;

//--------------- Cambiar Grafica -----------------

procedure TFUsuarios.CambiarGrafica();
var
  Conta: Integer;
begin
  if CargaGrafica=1 then exit;//------- Si esta cargando datos
  if ListBox2.Items.Count=0 then exit;//----- Si no hay años
  if ListBox2.ItemIndex=-1 then ListBox2.ItemIndex:=0;
  dbGrafica.Active:=False;
  dbGrafica.SQL.Text:='SELECT *, TUSU6-TUSU7 As BENEF FROM estausu'+Tienda+' WHERE TUSU0="'+Edit1.Text+'"'+
                      ' AND TUSU1='+ListBox2.Items.Strings[ListBox2.ItemIndex]+
                      ' ORDER BY TUSU1 ASC, TUSU2 ASC';
  dbGrafica.Active:=True;
  Chart1Serie1.Clear; Chart1AreaSeries1.Clear;
  Chart1BarSeries1.Clear; Chart1PieSeries1.Clear;
  if ListBox3.ItemIndex=-1 then ListBox3.ItemIndex:=0;
  dbGrafica.First; Chart1.Title.Text.Text:=ListBox3.Items.Strings[ListBox3.ItemIndex];
  for conta:=1 to dbGrafica.RecordCount do
    begin
     Chart1Serie1.AddXY(conta,dbGrafica.Fields[ListBox3.ItemIndex+3].AsInteger, FloatToStr(dbGrafica.Fields[ListBox3.ItemIndex+3].AsFloat), clred);
     Chart1AreaSeries1.AddXY(conta,dbGrafica.Fields[ListBox3.ItemIndex+3].AsInteger, FloatToStr(dbGrafica.Fields[ListBox3.ItemIndex+3].AsFloat), clred);
     Chart1BarSeries1.AddXY(conta,dbGrafica.Fields[ListBox3.ItemIndex+3].AsInteger, FloatToStr(dbGrafica.Fields[ListBox3.ItemIndex+3].AsFloat), clred);
     Chart1PieSeries1.AddXY(conta,dbGrafica.Fields[ListBox3.ItemIndex+3].AsInteger, FloatToStr(dbGrafica.Fields[ListBox3.ItemIndex+3].AsFloat), clred);
     dbGrafica.Next;
    end;
end;


Initialization
  {$I usuarios.lrs}

End.

