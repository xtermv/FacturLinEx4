Unit Menu;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, Inifiles, ZConnection, ZDataset, ExtCtrls,
  LCLType, Menus, LR_Class;
Type

  { TFMenu }

  TFMenu = Class(Tform)
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn27: TBitBtn;
    BitBtn52: TBitBtn;
    BitBtn39: TBitBtn;
    BitBtn8: TBitBtn;
    Image1: TImage;
    ImagenLogo: TImage;
    Pagecontrol1: Tpagecontrol;
    TabSheet10: TTabSheet;
    TabSheet2: TTabSheet;
    Tabsheet4: Ttabsheet;
    dbConect: TZConnection;
    dbQuery: TZQuery;

    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn27Click(Sender: TObject);
    procedure BitBtn55Click(Sender: TObject);
    Procedure Bitbtn8click(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    Procedure Formcreate(Sender: Tobject);
    Procedure Iniciar();

  Private
    { Private Declarations }
  Public
    { Public Declarations }
    IniReader : TIniFile;
    Sections : TStringList;
//    Contents : TStringList;//quitado por javi no se usa
  End;

Var
  FMenu: TFMenu;
  //Lee, Empresa, Direccion, Localidad, Nif, Tienda, Puesto: String;
  NTienda: Integer;

Implementation

uses
   Global, gestionar, importar2;

{ TFMenu }

//===================== CREAR APLICACION ==============
Procedure Tfmenu.Formcreate(Sender: Tobject);
Begin
  {$IFDEF LINUX}
     if ExtractFilePath(ParamStr(0))='/usr/bin/' then
                Lee:=GetEnvironmentVariable('HOME')+'/.facturlinex2/' else
                Lee:=ExtractFilePath(ParamStr(0));

    if AbrirAchivo = '' then AbrirAchivo:=GetEnvironmentVariable('DESKTOP_SESSION')+'-open';

  {$ELSE}
     Lee:=ExtractFilePath(ParamStr(0));
     DecimalSeparator:='.';
  {$ENDIF}
  if not FileExists(Lee+'FacturConf.ini') then
    begin
     Showmessage('NO PUEDO ENCONTRAR EL FICHERO FacturConf.ini');
     Exit;
    end;

  Iniciar();
End;

//===================== INICIAR APLICACION ====================
Procedure Tfmenu.Iniciar();
begin

  IniReader := TIniFile.Create(Lee+'FacturConf.ini');
  Sections := TStringList.Create;
  IniReader.ReadSections( Sections );
  Empresa:=IniReader.ReadString('datos','nombre','');
  Direccion:=IniReader.ReadString('datos','direccion','');
  Localidad:=IniReader.ReadString('datos','cp','')+' - '+IniReader.ReadString('datos','poblacion','');
  Nif:=IniReader.ReadString('datos','CIF','');
  Tienda:=IniReader.ReadString('tienda','codigo','');
  if Tienda<>'' then NTienda:=StrToInt(Tienda) else NTienda:=0;
  Puesto:=IniReader.ReadString('tienda','puesto','');
  ColorFondo:=IniReader.ReadString('datos','ColorFondo','');
  ColorBotones:=IniReader.ReadString('datos','ColorBotones','');
  //----------------- Conexion -----------------
  if IniReader.ReadString('BBDD','host','')<>'' then
   begin
      DBHost:=IniReader.ReadString('BBDD','host','');
      DBUsuario:=IniReader.ReadString('BBDD','usuario','');
      DBPasswd:=IniReader.ReadString('BBDD','passwd','');
      DBDataBase:=IniReader.ReadString('BBDD','database','');
      DBPuerto:=IniReader.ReadString('BBDD','puerto','');
      DBProtocolo:=IniReader.ReadString('BBDD','protocolo','');
   end;
 //----------------- Colores del formulario y botones ------------------------

end;


//------------------------- ARTICULOS -----------------------
procedure TFMenu.BitBtn11Click(Sender: TObject);
begin
   ShowFormImportar();
end;

procedure TFMenu.BitBtn14Click(Sender: TObject);
begin
  //ShowFormProveedores();
end;

procedure TFMenu.BitBtn27Click(Sender: TObject);
begin
  ShowFormPedido();
end;

procedure TFMenu.BitBtn10Click(Sender: TObject);
begin
  //ShowFormClientes();
end;

////----------------- Generar pedidos ----------------------
//procedure TFMenu.BitBtn53Click(Sender: TObject);
//begin
// //ShowFormGeneraPed();
//end;
//
////----------------- Unir pedidos ----------------------
//procedure TFMenu.BitBtn52Click(Sender: TObject);
//begin
//  //ShowFormUniPedi();
//end;


//=================== CERRAR APLICACION ==================
Procedure Tfmenu.Bitbtn8click(Sender: Tobject);
Begin
  Close();
End;
Procedure Tfmenu.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
 CloseAction:= CaFree;
End;


//===============================================================
//=================== INICIAR POR PRIMERA VEZ ===================
//===============================================================
//------------ Aceptar panel de configuracion y guardar ------------
//procedure TFMenu.BitBtn19Click(Sender: TObject);
//var
//  Txt: String;
//  F: TextFile;
//  FicheroSql: String;
//begin
//  //Comprueba que el protocolo escogido en el Combo esté soportado
//  if not ServidoresBD[ComboServidoresBD.ItemIndex].soportado then
//  begin
//    ShowMessage('Actualmente este protocolo no está soportado. Solicite más información en la página del proyecto. Gracias');
//    exit;
//  end;
//
//  //----------------- Crear BBDD -------
//  //------- Este es el código propuesto por Fco. Javier Perez Vidal
//  //------- con esto evitamos saber donde esta mysql instalado
//  dbConect.HostName:=Edit21.Text;
//  dbConect.User:=Edit22.Text;
//  dbConect.Password:=Edit23.Text;
//  dbConect.Port:=StrToInt(Edit25.Text);
//  dbConect.Protocol:=ComboServidoresBD.Text;
//  try
//    dbConect.Connect;
//  except
//    begin ShowMessage('NO HE PODIDO CONECTAR CON EL SERVIDOR DE BBDD, REVISE LOS DATOS DE CONEXION!'); exit; end;
//  end;        // A partir de aquí tiene conexión con el servidor, si no la hubiera, vuelve a la pantalla de inicio
//  if ExisteDB(dbConect, Edit24.Text) then  //Si existe la BD
//    begin     // Pregunta si la quiere usar . Si SI pasa a guardar los datos de config (linea 568)
//      If Application.MessageBox('¿DESEA UTILIZAR LA BASE DE DATOS EXISTENTE?','FacturLinEx', boxstyle) = IDNO Then
//      Exit;  // Si no, vuelve a la pantalla de inicio
//    end
//  else       // Si no existe la BD, la intenta crear. Si todo es correcto,
//    begin    //acude al script factirlinex2.sql para crear las tablas
//      dbQuery.SQL.Text:='CREATE DATABASE '+Edit24.Text;
//      try
//        dbQuery.ExecSQL;
//      except
//        begin ShowMessage('ERROR AL CREAR LA BASE DE DATOS'); exit; end;
//    end;
//    //----------------- Crear Tablas -------
//    dbConect.Disconnect;
//    dbConect.Database:=Edit24.Text;
//    dbConect.Connected:=True;
//    {$IFDEF LINUX}
////      Opendialog1.FileName:='/usr/share/facturlinex2/facturlinex2.sql';  //Cambiado por javi para quitar el opendialog
//      FicheroSql:= '/usr/share/facturlinex2/facturlinex2.sql';  //añadido por javi para quitar opendialog
//    {$ELSE}
////      Opendialog1.FileName:='tablas/facturlinex2.sql'; //Cambiado por javi para quitar el opendialog
//      FicheroSql:= 'tablas/facturlinex2.sql';  //añadido por javi para quitar opendialog
//    {$ENDIF}
////    AssignFile(F,Opendialog1.FileName);  //Cambiado por javi para quitar el opendialog
//    AssignFile(F,FicheroSql); //añadido por javi para quitar opendialog
//    Reset(F);
//    while not EOF(F) do
//      begin
//       Readln(F,Txt);
//       if (Txt<>'') and (copy(Txt,1,1)<>'#') then
//         begin
//           //No hay duda de que es la primera vez que se ejecuta, por lo que no
//           // hay miedo de cambiar directamente las XXXX por 0000, así que ...
//           Txt:=StringReplace(Txt,'XXXX','0000',[rfReplaceAll]);
//           dbQuery.SQL.Text:=Txt;
//           dbQuery.ExecSQL; end;
//      end;
//  end;
//  dbConect.Disconnect;
//  //--------------- Guardar datos en el config ---------------
//  if not directoryExists(Lee) then mkdir(Lee);
////  OpenDialog1.FileName:=Lee+'FacturConf.ini';  // cambiado por javi para quitar el opendialog1
////  IniReader := TIniFile.Create(OpenDialog1.FileName); // cambiado por javi para quitar el opendialog1
//  IniReader := TIniFile.Create(Lee+'FacturConf.ini'); //añadido por javi para quitar opendialog
//  Sections := TStringList.Create;
////  Contents := TStringList.Create;//quitado por javi no se usa
//  //---------- Sección Empresa ---------
//  IniReader.WriteString('datos','nombre','PUNTODEV GNU S.L.');
//  IniReader.WriteString('datos','direccion','ARTURO BAREA, 4 - 1 B');
//  IniReader.WriteString('datos','poblacion','BADAJOZ');
//  IniReader.WriteString('datos','cp','06011');
//  IniReader.WriteString('datos','provincia','BADAJOZ');
//  IniReader.WriteString('datos','CIF','B06XXXXXX');
//  IniReader.WriteString('datos','telefono','924-224066');
//  IniReader.WriteString('datos','fax','924-263006');
//  IniReader.WriteString('datos','mail','info@puntodev.com');
//  //----------- Seccion BBDD -----------
//  IniReader.WriteString('BBDD','host',Edit21.Text);
//  IniReader.WriteString('BBDD','usuario',Edit22.Text);
//  IniReader.WriteString('BBDD','passwd',Edit23.Text);
//  IniReader.WriteString('BBDD','database',Edit24.Text);
//  IniReader.WriteString('BBDD','puerto',Edit25.Text);
//  IniReader.WriteString('BBDD','protocolo',ComboServidoresBD.Text);
//  //----------- Seccion Tienda Activa
//  IniReader.WriteString('tienda','codigo','0000');
//  IniReader.WriteString('tienda','puesto','A');
//  //----------- Seccion SicLinEx -----------
//  IniReader.WriteString('BBDD','ActivarSIC','N');
//  IniReader.WriteString('BBDD','SIChost','localhost');
//  IniReader.WriteString('BBDD','SICusuario','root');
//  IniReader.WriteString('BBDD','SICpasswd','');
//  IniReader.WriteString('BBDD','SICdatabase','sicLinex');
//  IniReader.WriteString('BBDD','SICpuerto','3306');
//  IniReader.WriteString('BBDD','SICprotocolo','mysql-5');
//  //----------- IVAS
//  IniReader.WriteString('Programa','IVA1','16');
//  IniReader.WriteString('Programa','IVA2','7');
//  IniReader.WriteString('Programa','IVA3','4');
//  IniReader.WriteString('Programa','RIVA1','4');
//  IniReader.WriteString('Programa','RIVA2','1');
//  IniReader.WriteString('Programa','RIVA3','0.5');
//
//  //---------- Sección Tickets ---------
//  IniReader.WriteString('tickets','HoraEnTicket','S');
//  IniReader.WriteString('tickets','SacaVende','S');
//  IniReader.WriteString('tickets','DesgloIva','N');
//  IniReader.WriteString('tickets','SacaIva','S');
//
//  //---------- Sección Puntos ---------
//  IniReader.WriteString('Puntos','Activar_Puntos','N');
//  IniReader.WriteString('Puntos','Activar_Productos','N');
//  IniReader.WriteString('Puntos','Porcentaje','0');
//  IniReader.WriteString('Puntos','Extra','0');
//  IniReader.WriteString('Puntos','Especial','0');
//
//  //---------- Sección de Configuración General ----------
//  IniReader.WriteString('CGeneral','Idioma','ESP');
//  IniReader.WriteString('CGeneral','Cod_apertura_cajon','000');
//  IniReader.WriteString('CGeneral','Cod_balanza','0000000000000');
//  IniReader.WriteString('CGeneral','Tarjetas_Varios','N');
//  IniReader.WriteString('CGeneral','Precio_IVA_Inc','N');
//  IniReader.WriteString('CGeneral','Benficio_Caja','N');
//  IniReader.WriteString('CGeneral','Forzar_Albaranes','N');
//  IniReader.WriteString('CGeneral','Permitir_Fras_Credito','N');
//  IniReader.WriteString('CGeneral','Borra_Albaran_Facturado','N');
//  IniReader.WriteString('CGeneral','Mostrar_Oferta','N');
//  IniReader.WriteString('CGeneral','Controlar_Horas','N');
//  IniReader.WriteString('CGeneral','Activar_Lotes','N');
//  IniReader.WriteString('CGeneral','Activar_Envases','N');
//  IniReader.WriteString('CGeneral','Agrupar_Envases','N');
//  IniReader.WriteString('CGeneral','Avisar_Stock_0','N');
//  IniReader.WriteString('CGeneral','Imprimir_Dto','N');
//  IniReader.WriteString('CGeneral','Visualiar_antes_imprimir','N');
//  IniReader.WriteString('CGeneral','Imprimir_Ticket','Ticketera');
//  IniReader.WriteString('CGeneral','Imprimir_Ticket_Regalo','N');
//  IniReader.WriteString('CGeneral','Previsualizar_Albaran_Ventas','N');
//  IniReader.WriteString('CGeneral','Imprimir_Albaranes','Impresora');
//  IniReader.WriteString('CGeneral','Previsualizar_Facturas_Ventas','N');
//  IniReader.WriteString('CGeneral','Imprimir_Facturas','Impresora');
//  IniReader.WriteString('CGeneral','Importe_Letras_Facturas','N');
//  IniReader.WriteString('CGeneral','Tiempo_Visualizar_Aviso','SIEMPRE');
//
//  //---- Escribir IniFile
//  IniReader.UpdateFile;
//  Panel1.Visible:=False; Pagecontrol1.Enabled:=True;
//
//  //----------------- Refrescar datos del datamodule
//  Global.Tienda:='0000';
//  Global.VeTienda:='0000';
//  Global.NTienda:='0';
//  Global.Puesto:='A';
//  Global.Empresa:='PUNTODEV GNU S.L.';
//  Global.Direccion:='ARTURO BAREA, 4 - 3.B';
//  Global.Localidad:='BADAJOZ';
//  Global.Nif:='B06XXXXXX';
//  Global.CP:='06011';
//  Global.DBHost:=Edit21.Text;
//  Global.DBUsuario:=Edit22.Text;
//  Global.DBPasswd:=Edit23.Text;
//  Global.DBDataBase:=Edit24.Text;
//  Global.DBPuerto:=Edit25.Text;
//  Global.DBProtocolo:=ComboServidoresBD.Text;
//  Global.ActivarSIC:='N';
//  Global.SICHost:='localhost';
//  Global.SICDataBase:='sicLinex';
//  Global.SICUsuario:='root';
//  Global.SICPasswd:='';
//  Global.SICPuerto:='3306';
//  Global.SICProtocolo:='mysql-5';
//  Global.IVA1:=16;Global.IVA2:=7;Global.IVA3:=4;
//  Global.RIVA1:=4;Global.RIVA2:=1;Global.RIVA3:=0.5;
//  Global.APuntos:='N';
//  Global.AProductos:='N';
//  Global.Porcentaje:='0';
//  Global.Extra:='0';
//  Global.Especial:='0';
//
  //------------- Iniciar normalmente --------
//  Iniciar();

//end;



//============================================================================
//============================ USUARIO Y CLAVE DE ACCESO =====================
//============================================================================
//------------------- Aceptar usuario y clave
procedure TFMenu.BitBtn55Click(Sender: TObject);
begin
  //if Edit27.Text='' then exit;
  //if dbUsuarios.Active=False then exit;
  //if dbUsuarios.RecordCount=0 then exit;
  //if (Copy(Edit27.Text, 1, 8) <>dbUsuarios.FieldByName('USU10').AsString) then
  //  begin
  //     showmessage('ERROR EN EL ACCESO A LA APLICACION.');
  //     Edit26.SetFocus;
  //     //exit;
  //  end;

end;

////========================= USUARIO ==========================
//procedure TFMenu.Edit26Enter(Sender: TObject);
//begin
//   Edit26.Text:=''; Edit27.Text:='';
//end;
//
//procedure TFMenu.Edit26Exit(Sender: TObject);
//begin
//   if Edit26.Text='' then exit;
//   dbUsuarios.SQL.Text:='SELECT * FROM usuarios'+Tienda+' WHERE USU9="'+Edit26.Text+'"';
//   dbUsuarios.Active:=True;
//   if dbUsuarios.RecordCount=0 then exit;
//end;


Initialization
  {$I menu.lrs}

End.

