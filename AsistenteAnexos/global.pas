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
  LCLType;

type

  { TDataModule1 }

  TDataModule1 = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    function LFill( SourceStr: String; NewLen: Byte; FillChar: Char): String;
    function StrLFill( SourceStr: PChar;NewLen: Word; FillChar: Char): PChar;
    
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
  Lee: String;
  Empresa, Representante, Direccion, Localidad, Nif, CP, Provincia, LogoEmpresa: String;
  Telefono, EMail, Fax, Registro: String;
  Tienda, Puesto, VeTienda, NTienda: String;

  DatosEmpresa, ImprePrevisu, ImpreDirecto, ImprePdf : String;


  APuntos, AProductos: String;
  Porcentaje,Extra,Especial: String;

  CgIdioma, CgApCj, CgCodBal, CgTarVar, CgPvp, CgBenCaj, CgForzAl, CgPFaCr, CgBorrAlFac, CgMOferta : String;
  CgCHora, CgActLote, CgActEnvase, CgAgruEnvase, CgStock0, CgPrDto, CgVPr, CgPrTicket, CgPrRegal : String;
  CgPrAlbV, CgPrAlb, CgPrFraV, CgPrFra, CgFraLetra, CgClaves, CgRol : String;

  TiempoAvisoCliente: Integer;
  AvisoLlamadas,AvisoPedidos: String;
  DiasLlamadas,DiasPedidos: Integer;

  DBHost,DBDataBase,DBUsuario,DBPasswd,DBPuerto,DBProtocolo: String;
  ActivarSIC,SICHost,SICDataBase,SICUsuario,SICPasswd,SICPuerto,SICProtocolo: String;

  IVA1,IVA2,IVA3,RIVA1,RIVA2,RIVA3: Double;

  LVIS1, LVIS2, LCTI1, LCTI2, LCTI3, LCTI4, LPTI1, LPTI2, LPTI3: String;
  CgoCajon, PCgoCajon, CgoCorte, PCgoCorte: String;
  SecNil, Negro, Rojo, NegroD, RojoD: String;
  LiFinTick, LiFinTick1, CopiaTicket, CopiaTicket1: String;
  DevTicket, DevTicket1, DevVisor, CmdTicket, CmdTicket1: String;
  HoraEnTicket, SacaVende, SacaIva, DesgloIva, CgoEnTicket: String;
  ColorFondo, ColorBotones: String;
  //---------- Aplicaciones extras -----
  VisorPdf, RutaPdf, RutaImagenes: String;
  AbrirAchivo: String;
  //---------- Módulos -----
  AsistenteAnexos: String;

  AProcess: TProcess;
  AStringList: TStringList;
  boxstyle:Integer;

procedure CargaValoresIniReaderEnVariables(IniReader : TIniFile);

implementation

//----------- Carga los valores del IniReader de configuración en las variables
procedure CargaValoresIniReaderEnVariables(IniReader : TIniFile);
var
  I: Integer;
  X: Integer;
  TiempoVisual: String;
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
    Negro:=IniReader.ReadString('tickets','Negro','');
    Rojo:=IniReader.ReadString('tickets','Rojo','');
    NegroD:=IniReader.ReadString('tickets','NegroD','');
    RojoD:=IniReader.ReadString('tickets','RojoD','');

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

    //------------------- Aplicaciones Extras --------------------
    VisorPdf:=IniReader.ReadString('ProExt','Pdf','');
    RutaPdf:=IniReader.ReadString('ProExt','CarpetaPdf','');
    RutaImagenes:=IniReader.ReadString('ProExt','CarpetaImagenes','');

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

// -----------------------MODULOS-----------------------------------------
    AsistenteAnexos:=IniReader.ReadString('Modulos','AsistenteAnexos','');
end;

{ TDataModule1 }

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  {$IFDEF LINUX}
     // Comprobamos si la aplicación es para desarrollo o en producción.
  //   Lee:=GetEnvironmentVariable('HOME')+'/.facturlinex2/';


    if ExtractFilePath(ParamStr(0))='/usr/bin/' then
               Lee:=GetEnvironmentVariable('HOME')+'/.facturlinex2/' else
               Lee:=ExtractFilePath(ParamStr(0));

  {$ELSE}
     Lee := ExtractFilePath(ParamStr(0));
  {$ENDIF}
  ShortDateFormat:='DD/MM/YYYY';
  DateSeparator := '/';
///  {$IFDEF LINUX}
     DecimalSeparator:='.';
     ThousandSeparator:=',';
///  {$ELSE}
///     DecimalSeparator:=',';
///     ThousandSeparator:='.';
///  {$ENDIF}
  boxstyle :=  MB_ICONQUESTION + MB_YESNO;

  if not FileExists(Lee+'FacturConf.ini') then exit; //-- Si entra por primera vez

//  OpenDialog1.FileName:=Lee+'FacturConf.ini'; //cambiado por javi para quitar opendialog1
//  IniReader := TIniFile.Create(OpenDialog1.FileName);  //cambiado por javi para quitar opendialog1
  IniReader := TIniFile.Create(Lee+'FacturConf.ini');  //añadido por javi para quitar opendialog1
  Sections := TStringList.Create;
//  Contents := TStringList.Create; //quitado por javi no se usa
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


initialization
  {$I global.lrs}

end.

