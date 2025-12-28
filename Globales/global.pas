{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2010, Nicolas Lopez de Lerma Aymerich
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

unit Global;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils, LResources, Forms, Controls, Dialogs, Inifiles, Process,
  LCLType, Graphics, ZConnection;

type

  { TDataModule1 }

  TDataModule1 = class(TDataModule)
    dbConexion: TZConnection;
    procedure DataModuleCreate(Sender: TObject);
    function LFill( SourceStr: String; NewLen: Byte; FillChar: Char): String;
    function StrLFill( SourceStr: PChar;NewLen: Word; FillChar: Char): PChar;
    procedure Mensaje(Titulo, txtMensaje :string; Retardo :integer; clColor: tColor );
    
  private
    { private declarations }
  public
    { public declarations }
   IniReader : TIniFile;
   Sections : TStringList;
//   Contents : TStringList; //quitado por javi no se usa
  end;

var

  DataModule1: TDataModule1; 
  RutaReports, RutaIni, RutaSql, RutaIconos, RutaBin, RutaModulos: String;
  Empresa, Representante, Direccion, Localidad, Nif, CP, Provincia, LogoEmpresa: String;
  Telefono, EMail, Fax, Registro: String;
  Tienda, Puesto, VeTienda, NTienda: String;
  Lopd1, Lopd2: String;

  DatosEmpresa, ImprePrevisu, ImpreDirecto, ImprePdf : String;

  RoturaStock: String;

  ClienteVario: String;
  CgSegCajon: String;
  txtMoneda: string;

  UsuarioActivo: String;
  PedirSiempreUsuario: String;

  nDecimales, MascaraDecimales: String;

  ImprimirLOPD: String;

  APuntos, AProductos: String;
  Porcentaje,Extra,Especial: String;

  CgIdioma, CgApCj, CgCodBal, CgTarVar, CgPvp, CgBenCaj, CgForzAl, CgPFaCr, CgBorrAlFac, CgMOferta : String;
  CgCHora, CgActLote, CgActEnvase, CgAgruEnvase, CgStock0, CgPrDto, CgVPr, CgPrTicket, CgPrRegal : String;
  CgPrAlbV, CgPrAlb, CgPrFraV, CgPrFra, CgFraLetra, CgClaves, CgRol : String;

  TiempoAvisoCliente: Integer;
  AvisoLlamadas,AvisoPedidos: String;
  DiasLlamadas,DiasPedidos: Integer;

  LeyendaSuperiorQR, LeyendaInferiorQR: string;

  DBHost,DBDataBase,DBUsuario,DBPasswd,DBPuerto,DBProtocolo: String;
  ActivarSIC,SICHost,SICDataBase,SICUsuario,SICPasswd,SICPuerto,SICProtocolo: String;

  IVA1,IVA2,IVA3,RIVA1,RIVA2,RIVA3: Double;

  TicketRegalo: String;

  LVIS1, LVIS2, LCTI1, LCTI2, LCTI3, LCTI4, LPTI1, LPTI2, LPTI3: String;
  CgoCajon, PCgoCajon, CgoCorte, PCgoCorte, DevLogo, PDevLogo: String;
  SecNil, Negro, PNegro, Rojo, NegroD, PNegroD, RojoD: String;
  LiFinTick, LiFinTick1, CopiaTicket, CopiaTicket1: String;
  DevTicket, DevTicket1, DevVisor, CmdTicket, CmdTicket1: String;
  HoraEnTicket, SacaVende, SacaIva, DesgloIva, CgoEnTicket: String;
  ColorFondo, ColorBotones: String;

  //---------- Aplicaciones extras -----
  VisorPdf, RutaPdf, RutaImagenes: String;
  AbrirAchivo: String;
  Copia1Activada, Copia1InicioHora, Copia1InicioMinutos, Copia1FinHora, Copia1FinMinutos, Copia1Destino: String;
  Copia2Activada, Copia2InicioHora, Copia2InicioMinutos, Copia2FinHora, Copia2FinMinutos, Copia2Destino: String;
  Copia3Activada, Copia3InicioHora, Copia3InicioMinutos, Copia3FinHora, Copia3FinMinutos, Copia3Destino: String;

  //---------- Módulos -----
  AsistenteAnexos: String;

  AProcess: TProcess;
  AStringList: TStringList;
  boxstyle:Integer;

  //------------ Correo electrónico -------
  CorreoEmisor, CorreoCabecera, CorreoCopia: string;
  CorreoUsuario, CorreoHost, CorreoPuerto, CorreoClave: string;
  CorreoTLS, CorreoSSL: boolean;

  CorreoLOPD1, CorreoLOPD2, CorreoLOPD3: string;
  CorreoMensaje1, CorreoMensaje2, CorreoMensaje3, CorreoMensaje4: string;

  //----------------- VeriFactu ----------------
   vfUrl: String;
   vfUrlTP: String;
   vfUrlTLocal: String;
   vfMode: String;

   vfFacturaTipo: String; //-- Variable que determina el tipo de factura Veri*Factu , F1 = Factura Simplificada, F2 = Factura Completa
   vfTipoFactura: String; //-- Variable que determina el tipo de factura Veri*Factu , F1 = Factura Simplificada, F2 = Factura Completa, ERROR SE HA CAMBIADO NOMBRE EN MODULO uVFSenderAEAT
   GHash: String;         //-- Variable Global para Hash
   GHashPrev: String;     //-- Variable Global para Hash Previo

  //------------- BBDD autocopy
  bbddauto : string;
  mbbdd : string;
  MotorDB: String = 'MyISAM';     // motor bbdd en creación, que será sustituido por un módulo variable ARIA, MyISAM, InnoDB


procedure CargaValoresIniReaderEnVariables(IniReader : TIniFile);

implementation

uses
  Mensajes;

//----------- Carga los valores del IniReader de configuración en las variables
procedure CargaValoresIniReaderEnVariables(IniReader : TIniFile);
var
  I: Integer;
  X: Integer;
  TiempoVisual: String;
  tmpBoolean:string;
begin
  Tienda:=IniReader.ReadString('tienda','codigo','');
    VeTienda:=Tienda; NTienda:=IntToStr(StrToInt(Tienda));
    Puesto:=IniReader.ReadString('tienda','puesto','');
    //-----------------------------------
    Empresa:=IniReader.ReadString('datos','nombre','');
    Representante:=IniReader.ReadString('datos','representante','');
    Direccion:=IniReader.ReadString('datos','direccion','');
    Localidad:=IniReader.ReadString('datos','poblacion','');
    Nif:=IniReader.ReadString('datos','CIF','');
    CP:=IniReader.ReadString('datos','cp','');
    Provincia:=IniReader.ReadString('datos','provincia','');
    Telefono:=IniReader.ReadString('datos','telefono','');
    Fax:=IniReader.ReadString('datos','fax','');
    EMail:=IniReader.ReadString('datos','mail','');
    LogoEmpresa:=IniReader.ReadString('datos','logo','');
    Registro:=IniReader.ReadString('datos','registro','');
    //----------------- CONEXION -----------------
    DBHost:=IniReader.ReadString('BBDD','host','');
    DBDataBase:=IniReader.ReadString('BBDD','database','');
    DBUsuario:=IniReader.ReadString('BBDD','usuario','');
    DBPasswd:=IniReader.ReadString('BBDD','passwd','');
    DBPuerto:=IniReader.ReadString('BBDD','puerto','');
    DBProtocolo:=IniReader.ReadString('BBDD','protocolo','');
    //-------------- CONEXION SIC -----------------
    ActivarSIC:=IniReader.ReadString('BBDD','ActivarSIC','');
    SICHost:=IniReader.ReadString('BBDD','SIChost','');
    SICDataBase:=IniReader.ReadString('BBDD','SICdatabase','');
    SICUsuario:=IniReader.ReadString('BBDD','SICusuario','');
    SICPasswd:=IniReader.ReadString('BBDD','SICpasswd','');
    SICPuerto:=IniReader.ReadString('BBDD','SICpuerto','');
    SICProtocolo:=IniReader.ReadString('BBDD','SICprotocolo','');
    //----------------- IVAS -----------------
    if IniReader.ReadString('Programa','IVA1','')<>'' then
      IVA1:=StrToFloat(IniReader.ReadString('Programa','IVA1','')) else IVA1:=0;
    if IniReader.ReadString('Programa','IVA2','')<>'' then
      IVA2:=StrToFloat(IniReader.ReadString('Programa','IVA2','')) else IVA2:=0;
    if IniReader.ReadString('Programa','IVA3','')<>'' then
      IVA3:=StrToFloat(IniReader.ReadString('Programa','IVA3','')) else IVA3:=0;
    if IniReader.ReadString('Programa','RIVA1','')<>'' then
      RIVA1:=StrToFloat(IniReader.ReadString('Programa','RIVA1','')) else RIVA1:=0;
    if IniReader.ReadString('Programa','RIVA2','')<>'' then
      RIVA2:=StrToFloat(IniReader.ReadString('Programa','RIVA2','')) else RIVA2:=0;
    if IniReader.ReadString('Programa','RIVA3','')<>'' then
      RIVA3:=StrToFloat(IniReader.ReadString('Programa','RIVA3','')) else RIVA3:=0;

    //----------------- TICKETS --------------
    DevTicket:=Trim(IniReader.ReadString('tickets','DevTicket',''));
    DevTicket1:=Trim(IniReader.ReadString('tickets','DevTicket1',''));
    CmdTicket:=Trim(IniReader.ReadString('tickets','CmdTicket',''));
    CmdTicket1:=Trim(IniReader.ReadString('tickets','CmdTicket1',''));
    LCTI1:=IniReader.ReadString('tickets','1LC','');
    LCTI2:=IniReader.ReadString('tickets','2LC','');
    LCTI3:=IniReader.ReadString('tickets','3LC','');
    LCTI4:=IniReader.ReadString('tickets','4LC','');
    LPTI1:=IniReader.ReadString('tickets','1LP','');
    LPTI2:=IniReader.ReadString('tickets','2LP','');
    LPTI3:=IniReader.ReadString('tickets','3LP','');
    DevVisor:=IniReader.ReadString('tickets','DevVisor','');
    LVIS1:=IniReader.ReadString('tickets','1LV','');
    LVIS2:=IniReader.ReadString('tickets','2LV','');
    CgoCajon:=IniReader.ReadString('tickets','AperCajon',''); PCgoCajon:='';x:=1;
    if CgoCajon<>'' then
      for i:=1 to length(CgoCajon) do
        begin
          if i=1 then x:=1 else x:=x+3;
          if x>=length(CgoCajon) then break;
          PCgoCajon:=PCgoCajon+chr(StrToInt(copy(CgoCajon,x,3)));
        end;
    CgoCorte:=IniReader.ReadString('tickets','CortePapel',''); PCgoCorte:='';x:=1;
    if CgoCorte<>'' then
      for i:=1 to length(CgoCorte) do
        begin
          if i=1 then x:=1 else x:=x+3;
          if x>=length(CgoCorte) then break;
          PCgoCorte:=PCgoCorte+chr(StrToInt(copy(CgoCorte,x,3)));
        end;
    SecNil:=IniReader.ReadString('tickets','SecNil','');
//--    Negro:=IniReader.ReadString('tickets','Negro','');
    Negro:=IniReader.ReadString('tickets','Negro',''); PNegro:='';x:=1;
    if Negro<>'' then
      for i:=1 to length(Negro) do
          begin
            if i=1 then x:=1 else x:=x+3;
            if x>=length(Negro) then break;
            PNegro:=PNegro+chr(StrToInt(copy(Negro,x,3)));
          end;

    Rojo:=IniReader.ReadString('tickets','Rojo','');
//--    NegroD:=IniReader.ReadString('tickets','NegroD','');
    NegroD:=IniReader.ReadString('tickets','NegroD',''); PNegroD:='';x:=1;
    if NegroD<>'' then
      for i:=1 to length(NegroD) do
          begin
            if i=1 then x:=1 else x:=x+3;
            if x>=length(NegroD) then break;
            PNegroD:=PNegroD+chr(StrToInt(copy(NegroD,x,3)));
          end;

    RojoD:=IniReader.ReadString('tickets','RojoD','');
    DevLogo:=IniReader.ReadString('tickets','DevLogo',''); PDevLogo:='';x:=1;
    if DevLogo<>'' then
      for i:=1 to length(DevLogo) do
        begin
          if i=1 then x:=1 else x:=x+3;
          if x>=length(DevLogo) then break;
          PDevLogo:=PDevLogo+chr(StrToInt(copy(DevLogo,x,3)));
        end;

    LiFinTick:=IniReader.ReadString('tickets','LiFinTick','');
    if LiFinTick='' then LiFinTick:='1';
    LiFinTick1:=IniReader.ReadString('tickets','LiFinTick1','');
    if LiFinTick1='' then LiFinTick1:='1';
    CopiaTicket:=IniReader.ReadString('tickets','CopiaTicket','');
    CopiaTicket1:=IniReader.ReadString('tickets','CopiaTicket1','');

    HoraEnTicket:= IniReader.ReadString('tickets','HoraEnTicket','');
    SacaVende:= IniReader.ReadString('tickets','SacaVende','');
    SacaIva:= IniReader.ReadString('tickets','SacaIva','');
    DesgloIva:= IniReader.ReadString('tickets','DesgloIva','');
    CgoEnTicket:=IniReader.ReadString('tickets','CgoEnTicket','');

    TicketRegalo:=IniReader.ReadString('CGeneral','Imprimir_Ticket_Regalo','');

    //------------------- Aplicaciones Extras --------------------
    VisorPdf:=IniReader.ReadString('ProExt','Pdf','');
    RutaPdf:=IniReader.ReadString('ProExt','CarpetaPdf','');
    RutaImagenes:=IniReader.ReadString('ProExt','CarpetaImagenes','');

    if IniReader.ReadString('ProExt','Copia1Activada','')='SI' then
       Copia1Activada:='SI'
    else
       Copia1Activada:='NO';
    Copia1InicioHora    :=IniReader.ReadString('ProExt','Copia1InicioHora','');
    Copia1InicioMinutos :=IniReader.ReadString('ProExt','Copia1InicioMinutos','');
    Copia1FinHora       :=IniReader.ReadString('ProExt','Copia1FinHora','');
    Copia1FinMinutos    :=IniReader.ReadString('ProExt','Copia1FinMinutos','');
    Copia1Destino       :=IniReader.ReadString('ProExt','Copia1Destino','');

    if IniReader.ReadString('ProExt','Copia2Activada','')='SI' then
       Copia2Activada:='SI'
    else
       Copia2Activada:='NO';
    Copia2InicioHora    :=IniReader.ReadString('ProExt','Copia2InicioHora','');
    Copia2InicioMinutos :=IniReader.ReadString('ProExt','Copia2InicioMinutos','');
    Copia2FinHora       :=IniReader.ReadString('ProExt','Copia2FinHora','');
    Copia2FinMinutos    :=IniReader.ReadString('ProExt','Copia2FinMinutos','');
    Copia2Destino       :=IniReader.ReadString('ProExt','Copia2Destino','');

    if IniReader.ReadString('ProExt','Copia3Activada','')='SI' then
       Copia3Activada:='SI'
    else
       Copia3Activada:='NO';
    Copia3InicioHora    :=IniReader.ReadString('ProExt','Copia3InicioHora','');
    Copia3InicioMinutos :=IniReader.ReadString('ProExt','Copia3InicioMinutos','');
    Copia3FinHora       :=IniReader.ReadString('ProExt','Copia3FinHora','');
    Copia3FinMinutos    :=IniReader.ReadString('ProExt','Copia3FinMinutos','');
    Copia3Destino       :=IniReader.ReadString('ProExt','Copia3Destino','');

    //----------------------------------- Programa de Puntos ----------------
    APuntos:=IniReader.ReadString('Puntos','Activar_Puntos','');
    AProductos:=IniReader.ReadString('Puntos','Activar_Productos','');
    Porcentaje:=IniReader.ReadString('Puntos','Porcentaje','');
    Extra:=IniReader.ReadString('Puntos','Extra','');
    Especial:=IniReader.ReadString('Puntos','Especial','');

    DatosEmpresa:=IniReader.ReadString('informes','DatosEmpresa','');
    ImprePrevisu:=IniReader.ReadString('informes','ImprePrevisu','');
    ImpreDirecto:=IniReader.ReadString('informes','ImpreDirecto','');
    ImprePdf:=IniReader.ReadString('informes','ImprePdf','');

    //----------------------------------- Configuración General --------------
    CgIdioma:=IniReader.ReadString('CGeneral','Idioma','');
    CgApCj:=IniReader.ReadString('CGeneral','Cod_apertura_cajon','');
    CgCodBal:=IniReader.ReadString('CGeneral','Cod_balanza','');
    CgTarVar:=IniReader.ReadString('CGeneral','Tarjetas_Varios','');
    CgPvp:=IniReader.ReadString('CGeneral','Precio_IVA_Inc','');
    CgBenCaj:=IniReader.ReadString('CGeneral','Benficio_Caja','');
    CgForzAl:=IniReader.ReadString('CGeneral','Forzar_Albaranes','');
    CgPFaCr:=IniReader.ReadString('CGeneral','Permitir_Fras_Credito','');
    CgBorrAlFac:=IniReader.ReadString('CGeneral','Borra_Albaran_Facturado','');
    CgMOferta:=IniReader.ReadString('CGeneral','Mostrar_Oferta','');
    CgCHora:=IniReader.ReadString('CGeneral','Controlar_Horas','');
    CgActLote:=IniReader.ReadString('CGeneral','Activar_Lotes','');
    CgActEnvase:=IniReader.ReadString('CGeneral','Activar_Envases','');
    CgAgruEnvase:=IniReader.ReadString('CGeneral','Agrupar_Envases','');
    CgStock0:=IniReader.ReadString('CGeneral','Avisar_Stock_0','');
    CgPrDto:=IniReader.ReadString('CGeneral','Imprimir_Dto','');
    CgVPr:=IniReader.ReadString('CGeneral','Visualiar_antes_imprimir','');
    CgPrTicket:=IniReader.ReadString('CGeneral','Imprimir_Ticket','');
    CgPrRegal:=IniReader.ReadString('CGeneral','Imprimir_Ticket_Regalo','');
    CgPrAlbV:=IniReader.ReadString('CGeneral','Previsualizar_Albaran_Ventas','');
    CgPrAlb:=IniReader.ReadString('CGeneral','Imprimir_Albaranes','');
    CgPrFraV:=IniReader.ReadString('CGeneral','Previsualizar_Facturas_Ventas','');
    CgPrFra:=IniReader.ReadString('CGeneral','Imprimir_Facturas','');
    CgFraLetra:=IniReader.ReadString('CGeneral','Importe_Letras_Facturas','');
    CgClaves:=IniReader.ReadString('CGeneral','Activar_Claves','');
    PedirSiempreUsuario:= IniReader.ReadString('CGeneral','PedirUsuario','');

    nDecimales:=IniReader.ReadString('CGeneral','NumeroDecimales','');
//    delete(nDecimales,2,length(nDecimales));
    MascaraDecimales:='0.###';
    if copy(nDecimales,1,1)='3' then MascaraDecimales:='0.###';
    if copy(nDecimales,1,1)='4' then MascaraDecimales:='0.####';
    if copy(nDecimales,1,1)='8' then MascaraDecimales:='0.########';

    ImprimirLOPD:=IniReader.ReadString('CGeneral','ImprimirLOPD','');

    TiempoVisual:=IniReader.ReadString('CGeneral','Tiempo_Visualizar_Aviso','');
    TiempoAvisoCliente:=0;        // Asignamos el tiempo de visualización
    if TiempoVisual = '5' then TiempoAvisoCliente:=5;
    if TiempoVisual = '30' then TiempoAvisoCliente:=30;
    if TiempoVisual = '60' then TiempoAvisoCliente:=60;

    AvisoLlamadas:=IniReader.ReadString('CGeneral','Avisar_Llamadas','');
    DiasLlamadas:=0;
    if IniReader.ReadString('CGeneral','Dias_Aviso_Llamadas','')<>'' then
      DiasLlamadas:=StrToInt(IniReader.ReadString('CGeneral','Dias_Aviso_Llamadas',''));
    AvisoPedidos:=IniReader.ReadString('CGeneral','Avisar_Pedidos','');
    DiasPedidos:=0;
    if IniReader.ReadString('CGeneral','Dias_Aviso_Pedidos','')<>'' then
      DiasPedidos:=StrToInt(IniReader.ReadString('CGeneral','Dias_Aviso_Pedidos',''));

    RoturaStock:= IniReader.ReadString('CGeneral','Stock_suficiente','');

    txtMoneda:= IniReader.ReadString('CGeneral','Moneda','');
    if txtMoneda='' then txtMoneda:='Euros';

    ClienteVario:= IniReader.ReadString('CGeneral','CgClienteVario','');
    if ClienteVario='' then ClienteVario:='999999';

    CgSegCajon:= IniReader.ReadString('CGeneral','CgSeguroCajon','');

// -----------------------MODULOS-----------------------------------------
    AsistenteAnexos:=IniReader.ReadString('Modulos','AsistenteAnexos','');

    //------------Correo electrónico -------
  CorreoCopia:=     IniReader.ReadString('Correo','Copia','');
  CorreoEmisor:=    IniReader.ReadString('Correo','Emisor','');
  CorreoCabecera:=  IniReader.ReadString('Correo','Cabecera','');
  CorreoMensaje1:=  IniReader.ReadString('Correo','Mensaje1','');
  CorreoMensaje2:=  IniReader.ReadString('Correo','Mensaje2','');
  CorreoMensaje3:=  IniReader.ReadString('Correo','Mensaje3','');
  CorreoMensaje4:=  IniReader.ReadString('Correo','Mensaje4','');
  CorreoUsuario:=   IniReader.ReadString('Correo','Usuario','');
  CorreoHost:=      IniReader.ReadString('Correo','Host','');
  CorreoClave:=     IniReader.ReadString('Correo','Clave','');
  CorreoPuerto:=    IniReader.ReadString('Correo','Puerto','');

    //--------------- VeriFactu -----------------------------
  vfUrl:=           IniReader.ReadString('VeriFactu','vfUrl','');
  vfUrlTP:=         IniReader.ReadString('VeriFactu','vfUrlTP','');
  vfUrlTLocal:=     IniReader.ReadString('VeriFactu','vfUrlTLocal','');
  vfMode:=          IniReader.ReadString('VeriFactu','vfMode','');

  vfFacturaTipo:='F1';    //-- Por defecto Factura Simplificada
  vfTipoFactura:='F1';    //-- Por defecto Factura Simplificada  en el diseño del modulo se ha cambiado el nombre por error

  GHash:='';
  GHashPrev:='';



  tmpBoolean:=  IniReader.ReadString('Correo','SSL','');
  if tmpBoolean='' then CorreoSSL:=True else CorreoSSL:= StrToBool(IniReader.ReadString('Correo','SSL',''));

  tmpBoolean:=  IniReader.ReadString('Correo','TLS','');
  if tmpBoolean='' then CorreoSSL:=True else CorreoSSL:= StrToBool(IniReader.ReadString('Correo','TLS',''));

        //---------- Sistema de copia automática MONO-USUARIO
  bbddauto:=         IniReader.ReadString('bbdd_copy','MonoUsuario','');
  MotorDB := IniReader.ReadString('MotorBBDD','mbbdd','');
  mbbdd := MotorDB;
  if MotorDB = '' then MotorDB :='MyISAM';

end;

{ TDataModule1 }

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin

   {$IFDEF LINUX}
     DecimalSeparator:='.';

     // Comprobamos si la aplicación es para desarrollo o en producción.
     if ExtractFilePath(ParamStr(0))='/usr/bin/' then
                begin
                   RutaIni:=GetEnvironmentVariable('HOME')+'/.facturlinex2/';
                   RutaSql:='/usr/share/facturlinex2/';
                   RutaBin:='/usr/bin/';
                   RutaIconos:=RutaSql+'Icons/';
                   RutaReports:='/usr/share/facturlinex2/Report/';
                   RutaModulos:=RutaSql+'Extras/';
                end else
                begin
                   RutaIni:=ExtractFilePath(ParamStr(0));
                   RutaSql:=RutaIni;
                   RutaBin:=RutaIni;
                   RutaIconos:=RutaBin+'Imagenes/';
                   RutaReports:=RutaIni+'Report/';
                   RutaModulos:=RutaIni+'Extras/';
                end;

    //----------------- Carga de la variable AbrirAchivo
    //Descubrir que escritorio está utilizando el usuario
    if AbrirAchivo = '' then AbrirAchivo:=GetEnvironmentVariable('DESKTOP_SESSION')+'-open';

  {$ELSE}
     RutaIni:=ExtractFilePath(ParamStr(0));
     RutaSql:= RutaIni+'Tablas\';
     RutaIconos:=RutaIni;
     RutaBin:= RutaIni;
     RutaReports:= RutaIni+'Report\';
     RutaModulos:= RutaIni+'Extras\';
     DecimalSeparator:='.';
     if AbrirAchivo= '' then AbrirAchivo:= 'explorer.exe';
  {$ENDIF}

  ShortDateFormat:='DD/MM/YYYY';
  DateSeparator := '/';
  DecimalSeparator:='.';
  ThousandSeparator:=',';
  boxstyle :=  MB_ICONQUESTION + MB_YESNO;
// Valores por defecto del mensaje legal de la LOPD
  Lopd1:='Le informamos que los datos personales que puedan constar en este documento se encuentran incorporados en un fichero propiedad de ';
  Lopd2:=', con la finalidad de gestionar nuestra relacion profesional y poder informarle de nuestros servicios. Si desea ejercitar  sus derechos de acceso, rectificacion y cancelacion, lo podra hacer dirigiendose por escrito a ';

  CorreoLOPD1:='En cumplimiento de lo dispuesto en el artículo 5 de la Ley Orgánica 15/1999, de 13 de diciembre,'+
            'de Protección de Datos de Carácter Personal, le informamos que los datos personales que puedan '+
            'figurar en esta comunicación están incorporados a un fichero creado por';
  CorreoLOPD2:='con la finalidad de poder gestionar la relación negocial que nos vincula e informarle de nuestros'+
            'servicios. En virtud de lo dispuesto en el artículo 15 y siguientes de la LOPD y en los términos '+
            'que indica su reglamento de desarrollo aprobado por Real Decreto 1720/2007, de 21 de diciembre, en'+
            'cualquier momento usted podrá ejercer sus derechos de acceso, rectificación, cancelación y oposición'+
            ', dirigiéndose por escrito a';
  CorreoLOPD3:='En cumplimiento de lo prevenido en el artículo 21 de la Ley 34/2002 de servicios de la sociedad de'+
            'la información y comercio electrónico, si usted no desea recibir más información sobre nuestros'+
            'servicios, puede darse de baja en la siguiente dirección de correo electrónico :';

  if not FileExists(RutaIni+'FacturConf.ini') then exit; //-- Si entra por primera vez

  IniReader := TIniFile.Create(RutaIni+'FacturConf.ini');  //añadido por javi para quitar opendialog1
  Sections := TStringList.Create;

  IniReader.ReadSections( Sections );
  CargaValoresIniReaderEnVariables(IniReader);
end;

{-----------------------RELLENAR SPACIOS A LA IZQUIERDA --------------------}
function TDataModule1.LFill( SourceStr: String;NewLen: Byte; FillChar: Char): String;
var
  aPChar   : PChar;
  newPChar : PChar;
begin
  DecimalSeparator:='.';
  if NewLen > Length(SourceStr) then
   begin
     aPChar := StrAlloc(NewLen+1);
     StrPCopy(aPChar,SourceStr);
     newPChar := StrLFill(aPChar,NewLen,FillChar);
     Result   := StrPas(newPChar);
     StrDispose(aPChar);
   end
  else
   begin
     Result := SourceStr;
   end;
end;
{--------------------------------------------------------------------------}
function TDataModule1.StrLFill( SourceStr : PChar;
                   NewLen    : Word;
                   FillChar  : Char): PChar;
var
   tempStr : PChar;
   startStr: PChar;
   fillLen : Word;
   oldSize : Word;
   maxSize : Word;
   i       : Word;
begin
  DecimalSeparator:='.';
     maxSize := StrBufSize(SourceStr);
     oldSize := StrLen(SourceStr);
     if NewLen > oldSize then
     begin
          if NewLen > maxSize then
          begin
               fillLen := maxSize - oldSize;
          end
          else
          begin
               fillLen := NewLen - oldSize;
          end;
          tempStr := StrAlloc(maxSize);
          StrCopy(tempStr,SourceStr);
          startStr := SourceStr;
          for i := 1 to fillLen do
          begin
               StartStr^ := FillChar;
               inc(startStr);
          end;
          StartStr^ := #0;
          StrCat(SourceStr,tempStr);
          StrDispose(TempStr);
     end;
     Result := SourceStr;
end;

//-------------- MUESTRA MENSAJES TEMPORALMENTE EN UN FORMULARIO ---------------


procedure TDataModule1.Mensaje(Titulo, txtMensaje :string; Retardo :integer; clColor: tColor );
begin

  if (FMensajes=nil) then
  begin
    FMensajes:=TFMensajes.Create(nil);
    with FMensajes do
      try
        begin
         lbTitulo.Caption := Titulo;
         Position := poScreenCenter;
         Color := clColor;

         Show;
         Application.ProcessMessages;
         lbMensaje.Font.Color:= clBlack;
         lbMensaje.Caption := txtMensaje;
         lbMensaje.Color := Color;
         Application.ProcessMessages;

         Sleep(Retardo);
         Close;
        end;
      except
        Free;
      end;

  end else exit;

end;


initialization
  {$I global.lrs}

end.

