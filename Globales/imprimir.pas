{
  Gestion LinEx FacturLinEx

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

unit Imprimir;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Buttons, Spin,
  lr_e_pdf, LR_DBSet, LR_Class,
  ZConnection, ZDataset,
  LCLType, Process,
  smtpsend, synacode,
  DB,
  ubarcodes,
  ZAbstractConnection, ZAbstractRODataset, ZExceptions, ZAbstractDataset, ZClasses, // ZEOS
  Crt; // Delay()

type

  { TFImpresion }

  TFImpresion = class(TForm)
    BarcodeQR1: TBarcodeQR;
    btxml: TBitBtn;
    btOk1: TBitBtn;
    btCorreo: TBitBtn;
    btSalir: TBitBtn;
    cbFechasAlbaranes: TCheckBox;
    cbEsCopia: TCheckBox;
    cbDuplicado: TCheckBox;
    cbPVP: TCheckBox;
    cbprecio: TCheckBox;
    CheckBox1: TCheckBox;
    cbObservaciones: TCheckBox;
    cbEnviarCorreo: TCheckBox;
    CheckBoxAnexos: TCheckBox;

    dbCabecera: TZQuery;
    dbDatosCliente: TZQuery;
    dbQueryAnexos: TZQuery;
    dbImprimir: TZQuery;
    dbDetalles: TZQuery;
    dbTemporal: TZQuery;
    edDestinatarioCopia: TEdit;
    Edit1: TEdit;
    edDestinatario: TEdit;
    edAdjunto: TEdit;
    edAsunto: TEdit;

    frDBDataSet: TfrDBDataSet;
    frReport: TfrReport;
    frTNPDFExport: TfrTNPDFExport;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lbGenerando: TLabel;
    Label9: TLabel;
    mmTexto: TMemo;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    lbCopias: TLabel;
    Panel1: TPanel;
    PanelCorreo: TPanel;
    pnCabecera: TPanel;
    Panel10: TPanel;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    sbBuscar: TSpeedButton;
    SpinEdit1: TSpinEdit;

    procedure btCorreoClick(Sender: TObject);
    procedure btOk1Click(Sender: TObject);
    procedure btSalirClick(Sender: TObject);
    procedure btxmlClick(Sender: TObject);
    procedure cbDuplicadoChange(Sender: TObject);
    procedure cbEnviarCorreoChange(Sender: TObject);
    procedure cbEsCopiaChange(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure frReportBeginDoc;
    procedure frReportBeginPage(pgNo: Integer);
    procedure frReportEndPage(pgNo: Integer);

    function Imprime(dbMuestrad: TZQuery; dbMuestrac: TZQuery; dbCliente: TZQuery;
                   TipoDocumento: String; directo: boolean; nCopias: integer): integer;
    procedure Imprime(TxtInforme: String; Informe: String; Titulo: String);
    procedure GeneraImpresion();
    procedure ImpDocumento();

    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);

    procedure CalculaIvas();

    procedure RadioGroup2Click(Sender: TObject);
    procedure sbBuscarClick(Sender: TObject);
    procedure VerRecargo();
    procedure frReportGetValue(const ParName: String; var ParValue: Variant);
    procedure frReportEnterRect(Memo: TStringList; View: TfrView);

    procedure ImpreTicket(dbMuestrad: TZQuery; dbMuestrac: TZQuery; dbCliente: TZQuery; TipoDocumento: String);
    procedure CabeceraTicket();
    procedure PieTicket();
    procedure EsVentas;
    procedure TipoImpreso();

    procedure BuscarAnexos();
    function GeneraKeyDelNodo():string;

    procedure CorreosElectronicos;
    function FirmarFactura(XMLFile: string): string;
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FImpresion: TFImpresion;
  BASE1,BASE2,BASE3,IMPOIVA1,IMPOIVA2,IMPOIVA3,TOTAL1,TOTAL2,TOTAL3: Double;
  IRIVA1,IRIVA2,IRIVA3,RECARGO: Double;
  PIVA1,PIVA2,PIVA3,PRIVA1,PRIVA2,PRIVA3:Double;
  Documento: String;
  DirectorioReport: String;
  Impreso: String;
  NombrePDF: String;
  TituloInforme: String;
  PrintText: TextFile;
  Impresiondirecta: boolean;
  nPagina: integer;                      //  Contador de páginas.
  SubTotalPagina, TotalPagina: Double;    // Variables para subtotales en report
  camposKey: integer;                    // Número de campos clave de la tabla
  CodigoSalida: integer;                 // Significado del código de salida de imprime :
                                         // 0 -> No se imprimió ni se envió por correo electrónico.
                                         // 1 -> Documento imprimido.
                                         // 2 -> Documento enviado por email.
                                         // 3 -> Documento imprimido y enviado por email.
  xml: integer;
  txtQR, DirectorioQR: String;

implementation

uses
  Global, Funciones, uFacturaE_Generator, uFacturaE_Signer;

{ TFImpresion }

function TFImpresion.Imprime(dbMuestrad: TZQuery; dbMuestrac: TZQuery; dbCliente: TZQuery;
                   TipoDocumento: String; directo: boolean; nCopias:integer): integer;
var
  PDFCreado: Boolean;
  InicioContador: integer;

begin
  with TFImpresion.Create(Application) do
    begin
       xml:= 0;

       txtQR:=vfUrl+'nif='+NIF+'&';

       ImpresionDirecta:= directo;
       dbDatosCliente:= dbCliente;
       dbCabecera:= dbMuestrac;
       dbDetalles:= dbMuestrad;
       Documento:=TipoDocumento;
       Impreso:='';

  //  Asigna valor correcto para el QR de verifactu
  //-------------------------------------------------
  //{ //-- Estudiar la posibilidad de poner un if que no lo ejecute en caso de ser Albaran, así podremos seguir usando fieldbyname('FC9') etc
  //     BarcodeQR1.Text:=txtQR+'numserie='+dbCabecera.Fields[2].AsString+'%2F'+dbCabecera.Fields[3].AsString
  //                             +'&fecha='+FormatDateTime('dd-mm-yyyy',dbCabecera.Fields[1].AsDateTime)
  //                             +'&importe='+FormatFloat('0.00',dbCabecera.Fields[9].AsFloat);

 //      BarcodeQR1.Text:= TextoCodigoQR;                    // ' FacturLinEx Veri*factu 4.0 ';

       if (UpperCase(vfMode) = 'PRODUCCION') and (Documento= 'FACTURA') then
         BarcodeQR1.Text:=txtQR+'numserie='+dbCabecera.Fields[2].AsString+'%2F'+dbCabecera.Fields[3].AsString
                           +'&fecha='+FormatDateTime('dd-mm-yyyy',dbCabecera.Fields[1].AsDateTime)
                           +'&importe='+FormatFloat('0.00',dbCabecera.Fields[9].AsFloat)
       else
         BarcodeQR1.Text := TextoCodigoQR;

       DirectorioQR:='';

       if DirectoryExists(RutaPdf) then DirectorioQR:=RutaPdf+'/QR.png'
                                else DirectorioQR:= RutaIni+'QR.png';

       if FileExists(DirectorioQR) then DeleteFile(DirectorioQR);
                                                                // Creamos el fichero QR para incluir en el report.

       BarcodeQR1.SaveToFile(DirectorioQR, TPortableNetworkGraphic);

       if Documento='FACTURA' then
         begin
           cbFechasAlbaranes.Enabled:= True;
           cbObservaciones.Enabled:=False;
         end
       else
         begin
           cbFechasAlbaranes.Enabled:= False;
           cbObservaciones.Enabled:=True;
         end;

       if copy(TipoDocumento,1,1)='V' then begin EsVentas; Exit; end;

 //      showmessage(RutaPDF);

       if DirectoryExists(RutaPdf) then
              NombrePDF:= RutaPdf+'/'+copy(Documento,1,3)+'_'+dbCabecera.Fields[2].AsString
                        +'_'+dbCabecera.Fields[3].AsString+'.pdf' else
              NombrePDF:= RutaIni+copy(Documento,1,3)+'_'+dbCabecera.Fields[2].AsString
                        +'_'+dbCabecera.Fields[3].AsString+'.pdf';
       Caption:='Imprimiendo '+Documento;
       spinEdit1.Value:= dbDatosCliente.FieldByName('C8').AsInteger;
       if spinEdit1.Value=0 then spinEdit1.Value:=1;

 //        cbEnviarCorreo.Checked:= False;
       cbEnviarCorreo.Checked:= dbDatosCliente.FieldByName('C55').AsBoolean;
 //      cbEnviarCorreoChange(self);             // Desactivamos/activamos envíos email.
       CorreosElectronicos;                    // Cargamos datos para envío de email

       if (directo=true) then
         begin
             ImpDocumento();
             TipoImpreso();
             
             // ==== PREPARADO TEMPORAL MIENTRAS LLEGAN LOS CAMBIOS DE XAIME ===
             // ---- IMPRIMIR DE VERDAD EN MODO DIRECTO (sin PDF) ----
             frReport.LoadFromFile(Impreso);
             frReport.PrepareReport;
             //frReport.PrintPreparedReport('', SpinEdit1.Value);
             //SpinEdit1 y nCopias toman sus valores de la ficha de cliente.
             frReport.PrintPreparedReport('',nCopias);
             // ------------------------------------------------------
             
             CodigoSalida := 1;
           Result:= 1;                                 //Código de salida = 1 ( Imprimido )
             Close();
             exit;
         end;

       //Si el módulo AsistenteParaAnexos está instalado,
       //activa el CheckBox para buscar posibles anexos
       if (AsistenteAnexos='S') then
         begin
           CheckBoxAnexos.Visible:=True;
           CheckBoxAnexos.Checked:=True;
         end;

       CodigoSalida := 0;

       ShowModal;

       if CodigoSalida <> -1 then Result:= CodigoSalida;

  end;
end;

procedure TFImpresion.Imprime(TxtInforme: String; Informe: String; Titulo: String);
begin
    with TFImpresion.Create(Application) do
    begin
       dbDetalles.Active:=False;
       dbDetalles.SQL.Text:= TxtInforme;
       dbDetalles.Active:=True;
       TituloInforme:= Titulo;
       Documento:=Informe;
       Impreso:=DirectorioReport+Informe+'.lrf';
       if DirectoryExists(RutaPdf) then
              NombrePDF:= RutaPdf+'/'+'Informe_'+FormatDateTime('yyyymmdd',now)+'.pdf' else
              NombrePDF:= RutaIni+'Informe_'+FormatDateTime('yyyymmdd',now)+'.pdf';
       Caption:='Imprimiendo informe';
       spinEdit1.Value:=1;
       RadioGroup1.Enabled:=False;
       CheckBox1.Enabled:=False;
       cbObservaciones.Enabled:=False;
       cbPVP.Enabled:=False;
       cbPrecio.Enabled:=False;

       CodigoSalida:= 0;

       ShowModal;
    end;
end;

procedure TFImpresion.btOk1Click(Sender: TObject);
begin
   if self.Caption='Imprimiendo informe' then
     begin
       frDBDataSet.DataSet:=dbDetalles;
       GeneraImpresion();
     end else
     begin
      ImpDocumento();
      TipoImpreso();
      GeneraImpresion();
      if (CodigoSalida = 0) or (CodigoSalida = 2) then CodigoSalida:= CodigoSalida + 1;
      btCorreoClick(self);
     end;
      // Imprime Facturas/albaranes
end;

procedure TFImpresion.btCorreoClick(Sender: TObject);
var

  SMTP: TSMTPSend;
  Encabezados, Cuerpo, Adjunto, MensajeCompleto, Boundary: String;
  Archivo: TFileStream;
  Base64Str: AnsiString;
  MemStream: TMemoryStream;
  InputStr: AnsiString;
  Mensaje: TStringList; // Usar TStringList para MailData
  DestinatariosCC: TStringList; // Lista de destinatarios en CC
  ContDest: Integer; // Contador de destinatarios CC
  ArchivoSalida: Text; // Variable para el archivo de texto

begin

  if not cbEnviarCorreo.Checked then exit;

  if CorreoEmisor='' then begin
                                   DataModule1.Mensaje('Información','Falta correo electrónico del EMISOR', 2000 , clRed);
                                   exit;
                                  end;

  if edDestinatario.Text='' then begin
                                   DataModule1.Mensaje('Información','Falta correo electrónico del cliente', 2000 , clRed);
                                   exit;
                                  end;

  // Asociar la variable ArchivoSalida con un archivo físico
  AssignFile(ArchivoSalida, 'salida.txt');

// Definir un boundary único para el mensaje MIME
  Boundary := 'frontier';

  // Lista de destinatarios en CC (separados por comas)
  DestinatariosCC := TStringList.Create;
  try
     DestinatariosCC.CommaText := edDestinatarioCopia.Text; // Destinatarios en CC

    // Construir los encabezados con los valores de las cajas de texto
  Encabezados :=
    'From: ' + CorreoEmisor + #13#10 + // Campo From
    'To: ' + edDestinatario.Text + #13#10 + // Campo To
    'Cc: ' + DestinatariosCC.CommaText + #13#10 + // Encabezado CC
    'Subject: ' + edAsunto.Text + #13#10 + // Campo Subject
    'Date: ' + FormatDateTime('ddd, dd mmm yyyy hh:nn:ss', Now) + ' +0200' + #13#10 +
    'MIME-Version: 1.0' + #13#10 +
    'Content-Type: multipart/mixed; boundary="' + Boundary + '"' + #13#10 +
    #13#10;

  // Construir el cuerpo del mensaje con el contenido del TMemo
   Cuerpo :=
    '--' + Boundary + #13#10 +
    'Content-Type: text/plain; charset=UTF-8' + #13#10 +
    #13#10 +
    mmTexto.Lines.Text + #13#10;

  // Construir la parte del archivo adjunto
    if FileExists(edAdjunto.Text) then // Cambia por la ruta de tu archivo
    begin
      Archivo := TFileStream.Create(edAdjunto.Text, fmOpenRead);
      try
        MemStream := TMemoryStream.Create;
        try
       // Copiar el contenido del archivo al MemoryStream
          MemStream.CopyFrom(Archivo, Archivo.Size);
          MemStream.Position := 0;

          // Convertir el contenido del MemoryStream a AnsiString
          SetLength(InputStr, MemStream.Size);
          MemStream.ReadBuffer(InputStr[1], MemStream.Size);

          // Codificar el contenido en Base64 usando EncodeBase64
          Base64Str := EncodeBase64(InputStr);
        finally
          MemStream.Free;
        end;
      finally
        Archivo.Free;
      end;

      // Agregar el archivo adjunto al mensaje
      Cuerpo := Cuerpo +
        '--' + Boundary + #13#10 +
        'Content-Type: application/pdf; name="'+edAdjunto.Text+'"' + #13#10 +
        'Content-Disposition: attachment; filename="'+edAdjunto.Text+'"' + #13#10 +
        'Content-Transfer-Encoding: base64' + #13#10 +
        #13#10 +
        Base64Str + #13#10;
    end;

    // Cerrar el mensaje MIME
    Cuerpo := Cuerpo + '--' + Boundary + '--' + #13#10;

// Combinar encabezados y cuerpo
    MensajeCompleto := Encabezados + Cuerpo;

  // Mostrar el mensaje en la terminal para verificar (opcional)
  try
    // Abrir el archivo en modo escritura (sobrescribe el archivo si ya existe)
    Rewrite(ArchivoSalida);

    WriteLn(ArchivoSalida, 'Mensaje que se enviará:');
    WriteLn(ArchivoSalida, '---------------------');
    WriteLn(ArchivoSalida, MensajeCompleto);
    WriteLn(ArchivoSalida, '---------------------');
    // Cerrar el archivo
    CloseFile(ArchivoSalida);

    WriteLn('La salida se ha guardado en el archivo "salida.txt".');
  except
    on E: Exception do
    begin
      WriteLn('Error al escribir en el archivo: ', E.Message);
    end;
  end;

  // Convertir el mensaje a TStrings
  Mensaje := TStringList.Create;
  try
    Mensaje.Text := MensajeCompleto; // Asignar el mensaje completo al TStringList

  // Configuración del servidor SMTP (Gmail en este caso)
  SMTP := TSMTPSend.Create;
  try
    // Configuración del servidor SMTP de Gmail
    SMTP.TargetHost := CorreoHost; // Servidor SMTP de Gmail
    SMTP.TargetPort := CorreoPuerto; // Puerto para SSL
    SMTP.AutoTLS := CorreoTLS; // Usar TLS
    SMTP.FullSSL := CorreoSSL; // Usar SSL
    SMTP.Username := CorreoUsuario; // Correo del remitente
    SMTP.Password := CorreoClave; // Contraseña del remitente

    if SMTP.AutoTLS then SMTP.StartTLS else SMTP.StartTLS;

//-- CHEKERS
    if SMTP.AutoTLS then WriteLn('El TLS Está ACTIVO') ELSE WriteLn('El TLS NO Está ACTIVO');
    if SMTP.FullSSL then WriteLn('El SSL Está ACTIVO') ELSE WriteLn('El SSL NO Está ACTIVO');
    WriteLn('CorreoHost.-'+CorreoHost);
    WriteLn('CorreoPuerto.-'+CorreoPuerto);
    WriteLn('CorreoUsuario.-'+CorreoUsuario);
    if SMTP.Login then
    begin
      WriteLn('Conexión exitosa al servidor SMTP.');

      // Especificar el remitente (From)
      if SMTP.MailFrom(CorreoEmisor, Length(MensajeCompleto)) then
      begin
        // Especificar el destinatario (To)  y los destinatarios en CC
        if SMTP.MailTo(edDestinatario.Text) then
        begin
          // Especificar los destinatarios en CC
          for ContDest := 0 to DestinatariosCC.Count - 1 do
              begin
               if not SMTP.MailTo(DestinatariosCC[ContDest]) then
                  begin
                    ShowMessage('Error al especificar el destinatario en CC: ' + DestinatariosCC[ContDest]);
                    Exit;
                  end;
              end;
          // Enviar el mensaje completo (encabezados + cuerpo)
          if SMTP.MailData(Mensaje) then
          begin
            // ShowMessage('Correo enviado correctamente.');
            DataModule1.Mensaje('Información','Correo enviado correctamente', 2000 , clGreen);
            if (CodigoSalida < 2) then CodigoSalida:= CodigoSalida + 2;
          end
          else
          begin
            ShowMessage('Error al enviar el cuerpo del mensaje.');
          end;
        end
        else
        begin
          ShowMessage('Error al especificar el destinatario.');
        end;
      end
      else
      begin
        ShowMessage('Error al especificar el remitente.');
      end;

      SMTP.Logout;
    end
    else
    begin
      ShowMessage('Error al conectar al servidor SMTP.');
    end;
  finally
    SMTP.Free;
  end;

  finally
         Mensaje.Free;
  end;

  finally
         DestinatariosCC.Free;
  end;

end;

procedure TFImpresion.ImpDocumento();    // Imprime Documentos
var
  TxtQ: String;
  tablad:String;
  TxtAux: String;

  DrclnFacturacion, IzqlnFacturacion, lnFacturacion: string;
  posGuion1, posGuion2: integer;
begin

  tablad:='factud'; camposKey:=4;
  if ( Documento = 'ALBARAN' ) or ( Documento = 'VALBARAN' ) then begin tablad:= 'albad'; camposKey:=4; end;
  if Documento = 'PRESUPUESTO' then begin tablad:='presud'; camposKey:=4; end;
  if Documento = 'PROFORMA' then begin tablad:='proford'; camposKey:=4; end;
  if Documento = 'ALBARAN(H)' then begin tablad:='hisalbad'; camposKey:=4; end;

  dbImprimir.Active:=False;
  TxtQ:='DELETE FROM imptmp';                       // Borra todos los registros del temporal.
  dbImprimir.SQL.Text:=TxtQ; 
  try
     dbImprimir.ExecSQL;
  except
     on EDB: EDatabaseError do
     begin
       Showmessage('Error : ' + EDB.Message);
     end;
  end;

 if tablad='factud' then
   begin
     TxtAux:='0';
     TxtQ:='INSERT INTO imptmp SELECT '+tablad+Tienda+'.*, MID('+TxtAux+',1,300) as ANotas,'+dbDetalles.Fields[16].FieldName+' FROM '+tablad+Tienda+
                   ' WHERE '+ dbDetalles.Fields[0].FieldName+'='+dbCabecera.Fields[0].AsString+
                   ' AND '+dbDetalles.Fields[2].FieldName+'="'+dbCabecera.Fields[2].AsString+'"'+
                   ' AND '+dbDetalles.Fields[3].FieldName+'='+dbCabecera.Fields[3].AsString;
     //showmessage(TxtQ);
     dbImprimir.SQL.Text:=TxtQ; 
     try
        dbImprimir.ExecSQL;
     except
        on EDB: EDatabaseError do
        begin
          Showmessage('Error : ' + EDB.Message);
        end;
     end;
   end
 else
   begin
    //-- Inserta Lineas sobre código de Articulos
      TxtQ:='INSERT INTO imptmp SELECT '+tablad+Tienda+'.*, MID(A17,1,300) as ANotas, A0 FROM '+tablad+Tienda+', artitien'+Tienda+' WHERE '+ dbDetalles.Fields[0].FieldName+'='+dbCabecera.Fields[0].AsString+
            ' AND '+dbDetalles.Fields[2].FieldName+'="'+dbCabecera.Fields[2].AsString+'"'+
            ' AND '+dbDetalles.Fields[3].FieldName+'='+dbCabecera.Fields[3].AsString+
            ' AND '+dbDetalles.Fields[5].FieldName+'=A0' ;
      //-- showmessage(TxtQ);
      dbImprimir.SQL.Text:=TxtQ; 
      Try
         dbImprimir.ExecSQL;
      except
         on EDB: EDatabaseError do
         begin
         	Showmessage('Error : ' + EDB.Message);
         end;
      end;
      //-- showmessage(TxtQ);
      //-- Inserta Lineas sobre Código EAN
      TxtQ:='INSERT INTO imptmp SELECT '+tablad+Tienda+'.*, MID(A17,1,300) as ANotas, A0 FROM '+tablad+Tienda+
            ', (Select * from artitien'+Tienda+
            ' RIGHT JOIN eans on A0=EAN1) as eantmp WHERE '+ dbDetalles.Fields[0].FieldName+'='+dbCabecera.Fields[0].AsString+
            ' AND '+dbDetalles.Fields[2].FieldName+'="'+dbCabecera.Fields[2].AsString+'"'+
            ' AND '+dbDetalles.Fields[3].FieldName+'='+dbCabecera.Fields[3].AsString+
            ' AND '+dbDetalles.Fields[5].FieldName+'=EAN0' ;
       dbImprimir.SQL.Text:=TxtQ; dbImprimir.ExecSQL;
      //-- showmessage(TxtQ);
   end;

  dbImprimir.Active:=False; dbImprimir.SQL.Text:= 'SELECT * FROM imptmp';
  try
     dbImprimir.ExecSQL;
  except
     on EDB: EDatabaseError do
     begin
       Showmessage('Error : ' + EDB.Message);
     end;
  end;
  dbImprimir.Active:=True;

    //------------------ Suprimimos fecha de los albaranes en facturación -----------
  if cbFechasAlbaranes.Checked=true  then
     begin
         dbImprimir.First;
         while not dbImprimir.eof do
         begin
            dbImprimir.Edit;

            posGuion1:= 0; posGuion2:= 0;

            lnFacturacion:= dbImprimir.FieldByName('IMP16').AsString;

            posGuion1:= pos('-',lnFacturacion);

            if posGuion1 <> 0 Then
               Begin
                 IzqlnFacturacion:= copy(lnFacturacion,1,posGuion1-1);
                 delete(lnFacturacion,1, posGuion1);
               End;

            posGuion2:= pos('-', lnFacturacion);

            if posGuion2 <> 0 Then
               DrclnFacturacion:= copy(lnFacturacion,posGuion2+1, length(lnFacturacion));

            if (posGuion1<>0) and (posGuion2<>0) then
              begin
                dbImprimir.FieldByName('IMP16').Value:= IzqlnFacturacion+'-'+DrclnFacturacion;
                dbImprimir.Post;
              end;

            dbImprimir.Next;
          end;

  end;

  frDBDataSet.DataSet:=dbImprimir;

  IMPOIVA1:=0; BASE1:=0; TOTAL1:=0; IRIVA1:=0; PIVA1:=0; PRIVA1:=0;
  IMPOIVA2:=0; BASE2:=0; TOTAL2:=0; IRIVA2:=0; PIVA2:=0; PRIVA2:=0;
  IMPOIVA3:=0; BASE3:=0; TOTAL3:=0; IRIVA3:=0; PIVA3:=0; PRIVA3:=0;

    //--------------- Sacar distintos ivas ------------------
  TxtQ:='SELECT DISTINCT(IMP12), (SUM(IMP13-IMP11)) As Ivas, '+
        'SUM(IMP11) As Bases, SUM(IMP13) As Totales, '+
        'SUM(IMP10) As Dtos, (((SUM(IMP11)*SUM(IMP10)) / 100)) As ImpoDtos FROM imptmp '+
        ' WHERE IMP0='+dbCabecera.Fields[0].AsString+
        ' AND IMP1="'+FormatDateTime('yyyy/mm/dd',dbCabecera.Fields[1].asDateTime)+'"'+
        ' AND IMP2="'+dbCabecera.Fields[2].AsString+'"'+
        ' AND IMP3='+dbCabecera.Fields[3].AsString+' GROUP BY IMP12 ORDER BY IMP12 ASC';
  dbTemporal.Active:=False; dbTemporal.Sql.Text:=TxtQ; 
  try
     dbTemporal.ExecSQL; 
  except
     on EDB: EDatabaseError do
     begin
       Showmessage('Error : ' + EDB.Message);
     end;
  end;
  dbTemporal.Active:=True;

  CalculaIvas();

  //  Impuestos incluidos
  if RadioGroup1.ItemIndex=1 then
      begin
         dbImprimir.First;
         while not dbImprimir.eof do
         begin
            dbImprimir.Edit;
            if (dbImprimir.FieldByName('IMP7').Value <> 0) then dbImprimir.FieldByName('IMP9').Value:= FormatFloat('0.000',dbImprimir.FieldByName('IMP13').Value / dbImprimir.FieldByName('IMP7').Value);
            dbImprimir.FieldByName('IMP10').Value:= 0;
            dbImprimir.FieldByName('IMP11').Value:= dbImprimir.FieldByName('IMP13').Value;
            dbImprimir.FieldByName('IMP12').Value:= 0;
            dbImprimir.FieldByName('IMP8').Value := 0;
            try
               dbImprimir.Post;
            except
               on EDB: EDatabaseError do
               begin
                 Showmessage('Error : ' + EDB.Message);
               end;
            end;
            dbImprimir.Next;
          end;
          BASE1:=TOTAL1; PIVA1:=0; IMPOIVA1:=0; PRIVA1:=0; IRIVA1:=0;
          BASE2:=TOTAL2; PIVA2:=0; IMPOIVA2:=0; PRIVA2:=0; IRIVA2:=0;
          BASE3:=TOTAL3; PIVA3:=0; IMPOIVA3:=0; PRIVA3:=0; IRIVA3:=0;
      end;

  //  Sólo PVP
  if RadioGroup1.ItemIndex=2 then
      begin
         dbImprimir.First;
         while not dbImprimir.eof do
         begin
            dbImprimir.Edit;
            dbImprimir.FieldByName('IMP9').Value:= dbImprimir.FieldByName('IMP17').Value;
            dbImprimir.FieldByName('IMP10').Value:= 0;
            dbImprimir.FieldByName('IMP11').Value:= FormatFloat('0.000',dbImprimir.FieldByName('IMP9').Value * dbImprimir.FieldByName('IMP7').Value);
            dbImprimir.FieldByName('IMP13').Value:= dbImprimir.FieldByName('IMP11').Value;
            //------ El orden debe ser este, no tocar
            dbImprimir.FieldByName('IMP8').Value:= 0;
            dbImprimir.FieldByName('IMP12').Value:= 0;
            try
               dbImprimir.Post;
            except
               on EDB: EDatabaseError do
               begin
                 Showmessage('Error : ' + EDB.Message);
               end;
            end;
            dbImprimir.Next;
          end;
          IMPOIVA1:=0; BASE1:=0; TOTAL1:=0; IRIVA1:=0; PIVA1:=0; PRIVA1:=0;
          IMPOIVA2:=0; BASE2:=0; TOTAL2:=0; IRIVA2:=0; PIVA2:=0; PRIVA2:=0;
          IMPOIVA3:=0; BASE3:=0; TOTAL3:=0; IRIVA3:=0; PIVA3:=0; PRIVA3:=0;

          //--------------- Sacar distintos ivas ------------------
         TxtQ:='SELECT DISTINCT(IMP12), (SUM(IMP13-IMP11)) As Ivas, '+
         'SUM(IMP11) As Bases, SUM(IMP13) As Totales, '+
         'SUM(IMP10) As Dtos, (((SUM(IMP11)*SUM(IMP10)) / 100)) As ImpoDtos FROM imptmp '+
         ' WHERE IMP0='+dbCabecera.Fields[0].AsString+
         ' AND IMP1="'+FormatDateTime('yyyy/mm/dd',dbCabecera.Fields[1].asDateTime)+'"'+
         ' AND IMP2="'+dbCabecera.Fields[2].AsString+'"'+
         ' AND IMP3='+dbCabecera.Fields[3].AsString+' GROUP BY IMP12 ORDER BY IMP12 ASC';
         dbTemporal.Active:=False; dbTemporal.Sql.Text:=TxtQ; dbTemporal.ExecSQL; dbTemporal.Active:=True;

         CalculaIvas();

         dbImprimir.First;
         while not dbImprimir.eof do
         begin
            dbImprimir.Edit;
            dbImprimir.FieldByName('IMP12').Value:= 0;
            dbImprimir.FieldByName('IMP8').Value:= 0;
            try
               dbImprimir.Post;
            except
               on EDB: EDatabaseError do
               begin
                 Showmessage('Error : ' + EDB.Message);
               end;
            end;
            dbImprimir.Next;
          end;

          BASE1:=TOTAL1; PIVA1:=0; IMPOIVA1:=0; PRIVA1:=0; IRIVA1:=0;
          BASE2:=TOTAL2; PIVA2:=0; IMPOIVA2:=0; PRIVA2:=0; IRIVA2:=0;
          BASE3:=TOTAL3; PIVA3:=0; IMPOIVA3:=0; PRIVA3:=0; IRIVA3:=0;

      end;

  //  Sin valorar.
  if RadioGroup1.ItemIndex=3 then
      begin
         dbImprimir.First;
         while not dbImprimir.eof do
         begin
            dbImprimir.Edit;
            dbImprimir.FieldByName('IMP8').Value:= 0;
            dbImprimir.FieldByName('IMP9').Value:= 0;
            dbImprimir.FieldByName('IMP10').Value:= 0;
            dbImprimir.FieldByName('IMP11').Value:= 0;
            dbImprimir.FieldByName('IMP12').Value:= 0;
            dbImprimir.FieldByName('IMP13').Value:= 0;
            dbImprimir.FieldByName('IMP17').Value:= 0;
            try
               dbImprimir.Post;
            except
               on EDB: EDatabaseError do
               begin
                 Showmessage('Error : ' + EDB.Message);
               end;
            end;
            dbImprimir.Next;
          end;
          BASE1:=0; PIVA1:=0; IMPOIVA1:=0; PRIVA1:=0; IRIVA1:=0; TOTAL1:=0;
          BASE2:=0; PIVA2:=0; IMPOIVA2:=0; PRIVA2:=0; IRIVA2:=0; TOTAL2:=0;
          BASE3:=0; PIVA3:=0; IMPOIVA3:=0; PRIVA3:=0; IRIVA3:=0; TOTAL3:=0;
      end;

  // Anulamos las columnas de PVP o precio si el checkbox está desactivado.

    if cbprecio.Checked=False then
      begin
        dbImprimir.First;
        while not dbImprimir.eof do
         begin
           dbImprimir.Edit;
           dbImprimir.FieldByName('IMP9').Value:= 0;      //---- precio sin iva
           dbImprimir.FieldByName('IMP11').Value:= 0;     //---- total sin iva
            try
               dbImprimir.Post;
            except
               on EDB: EDatabaseError do
               begin
                 Showmessage('Error : ' + EDB.Message);
               end;
            end;
           dbImprimir.Next;
         end;
      end;

    if cbPVP.Checked=False then
      begin
        dbImprimir.First;
        while not dbImprimir.eof do
         begin
           dbImprimir.Edit;
           dbImprimir.FieldByName('IMP8').Value:= 0;      //---- precio con iva
           try
              dbImprimir.Post;
           except
              on EDB: EDatabaseError do
              begin
                Showmessage('Error : ' + EDB.Message);
              end;
           end;
           dbImprimir.Next;
         end;
      end;

end;

Procedure TFImpresion.cbDuplicadoChange(Sender: TObject);
begin
  if (cbDuplicado.Checked=true) then cbEsCopia.Checked:=False;
end;

procedure TFImpresion.cbEnviarCorreoChange(Sender: TObject);
var
  PDFCreado: Boolean;
  Contador: Integer;
  nuevoPDF: string;
  posNombrePDF: integer;

begin
  if not (cbEnviarCorreo.Checked) then begin
                                        PanelCorreo.Enabled:=False;
                                        exit;
                                       end;
  PanelCorreo.Enabled:=True;

  posNombrePDF := pos('FAC_', NombrePDF);
  if posNombrePDF>0 then
    begin
      nuevoPDF:=NombrePDF; Delete(nuevoPDF, posNombrePDF, 4);       // Eliminamos prefijo nombre factura ( FAC_ ).
    end;

//  if FileExists(NombrePDF) then exit;            // Generamos pdf del documento.
  if (FileExists(NombrePDF)) and ( not (assigned(FImpresion)))  then exit;

  if FileExists(NombrePDF) then
             if Application.MessageBox(' Ya existe un archivo con ese nombre,' +
               #13 + ' Desea reemplazarlo ?', 'FacturLinEx',
               MB_ICONQUESTION + MB_YESNO) = idYes then DeleteFile(NombrePDF)
                                                   else exit;
   if FileExists(nuevoPDF) then
             if Application.MessageBox(' Factura ya existente en otro formato' +
               #13 + ' Utilizar la existente ?', 'FacturLinEx',
               MB_ICONQUESTION + MB_YESNO) = idYes then begin
                                                           NombrePDF:=nuevoPDF;
                                                           exit;
                                                           end;

  ImpDocumento();
  TipoImpreso();

  frReport.LoadFromFile(Impreso);
  frReport.PrepareReport;

  lbGenerando.Visible:=True;

  frReport.ExportTo(TFrTNPDFExportFilter, NombrePDF);

  PDFCreado:= False;   // Esperamos hasta que el archivo está creado.
  Contador:= 0;
  Delay(2000);

 //   if (not PDFCreado) or (FileSize(NombrePDF)=0) then GeneraImpresion();  // Intentamos generar el PDF.

   while (not PDFCreado) and (Contador < 15) do             // Retardo de 15 segundos.
     begin
       if FileExists(NombrePDF) and (FileSize(NombrePDF) > 0) then
           begin
               PDFCreado:=True;
               lbGenerando.Visible:=False;
             end
       else
             Contador:= Contador+1;

       end;

       if not PDFCreado then
         begin
             DataModule1.Mensaje(' Error ','El archivo PDF no se pudo generar.', 2000 , clRed);
             Exit;
          end;

       lbGenerando.Visible:=false;

end;

procedure TFImpresion.cbEsCopiaChange(Sender: TObject);
begin
  if (cbEsCopia.Checked=true) then cbDuplicado.Checked:=False;
end;

//==================== Definimos el report a utilizar ===================
procedure TFImpresion.TipoImpreso();
var
  TImpreso: String;
  ObservacionesArticulos: string;
begin

  if Impreso<>'' then exit;

  if Documento<>'FACTURA' then
    begin
        if ( Documento<>'ALBARAN' ) and ( Documento<>'VALBARAN' ) then DirectorioReport:= DirectorioReport+'Documento'
                                else DirectorioReport:= DirectorioReport+'Albaran';
    end
  else DirectorioReport:= DirectorioReport+'Factura';

  if (cbObservaciones.Checked=true) then ObservacionesArticulos:='2' else
                                         ObservacionesArticulos:='';
  if (CheckBox1.Checked=True) then TImpreso:='P' else TImpreso:='';

  Impreso:= DirectorioReport + ObservacionesArticulos + TImpreso + '.lrf';

end;

procedure TFImpresion.GeneraImpresion();
var
  Contador: Integer;
  PDFCreado: Boolean;
  nuevoPDF: string;
  posNombrePDF: integer;

begin

  frReport.LoadFromFile(Impreso);

  posNombrePDF := pos('FAC_', NombrePDF);
  if posNombrePDF>0 then
    begin
      nuevoPDF:=NombrePDF; Delete(nuevoPDF, posNombrePDF, 4);       // Eliminamos prefijo nombre factura ( FAC_ ).
    end;

 // showmessage(nombrePDF +' ----- '+nuevoPDF);

  if RadioGroup2.ItemIndex=0 then frReport.ShowReport;

  if RadioGroup2.ItemIndex=1 then
      begin
        frReport.PrepareReport;
        frReport.PrintPreparedReport('',SpinEdit1.Value);
      end;

  if RadioGroup2.ItemIndex=2 then
      begin
        frReport.PrepareReport;

        if FileExists(NombrePDF) then
           if Application.MessageBox(' Ya existe un archivo con ese nombre,' +
             #13 + ' Desea reemplazarlo ?', 'FacturLinEx',
             MB_ICONQUESTION + MB_YESNO) = idYes then DeleteFile(NombrePDF);

           if FileExists(nuevoPDF) then
             if Application.MessageBox(' Factura ya existente en otro formato. ' +
               #13 + ' Utilizar la existente ?', 'FacturLinEx',
               MB_ICONQUESTION + MB_YESNO) = idYes then begin
                                                         NombrePDF:=nuevoPDF;
                                                         BuscarAnexos();
                                                         btSalirClick(self);
                                                         exit;
                                                        end;

        lbGenerando.Visible:=True;

        frReport.ExportTo(TFrTNPDFExportFilter, NombrePDF);

        PDFCreado:= False;   // Esperamos hasta que el archivo está creado.
        Contador:= 0;
        Delay(2000);

 //   if (not PDFCreado) or (FileSize(NombrePDF)=0) then GeneraImpresion();  // Intentamos generar el PDF.

        while (not PDFCreado) and (Contador < 15) do             // Retardo de 15 segundos.
        begin
         if FileExists(NombrePDF) and (FileSize(NombrePDF) > 0) then
             begin
               PDFCreado:=True;
               lbGenerando.Visible:=False;
             end
         else
             Contador:= Contador+1;

        end;

        if not PDFCreado then
          begin
             DataModule1.Mensaje(' Error ','El archivo PDF no se pudo generar.', 2000 , clRed);
             Exit;
          end;

        lbGenerando.Visible:=false;

        end;

  //       AProcess := TProcess.Create(nil);
  //       AProcess.CommandLine := VisorPdf+' '+RutaPdf+'\Albaran.pdf';
  //       AProcess.Execute;
  //       AProcess.Destroy;

  BuscarAnexos();
  btSalirClick(self);

end;
//================= BUSCAR DOCUMENTOS ANEXOS ===============
// Si NO está instalado el Asistente para Anexos, el checkBoxAnexos debe estar
// Visible:=False y Checked:=False. En la instalación del asistente estos
// valores guardados en el config.ini pasan a TRUE

procedure TFImpresion.BuscarAnexos();
var
  TxtQuery: string;
  Orden: string;
begin
  if CheckBoxAnexos.Checked then
    begin
      TxtQuery:='SELECT * FROM docuanexos WHERE claveNodo="'+ GeneraKeyDelNodo()+'";';
      dbQueryAnexos.Active:=False; dbQueryAnexos.SQL.Text:=TxtQuery; dbQueryAnexos.Active:=True;
      if dbQueryAnexos.RecordCount<>0 then
        begin
          while not dbQueryAnexos.EOF do
          begin
          AProcess := TProcess.Create(nil);
          Orden:= AbrirAchivo+' '+ dbQueryAnexos.FieldByName('rutaDoc').AsString;
          //showmessage(orden);
          try
            AProcess.CommandLine := Orden;
            AProcess.Execute;
          except
            showmessage('No se pudo abrir el archivo '+ dbQueryAnexos.FieldByName('rutaDoc').AsString);
            showmessage('NO EXISTE EL FICHERO O LA ORDEN PARA ABRIR ARCHIVOS NO ES CORRECTA'+ #13 +
                         '   COMPRUEBE LA ORDEN EN LA CONFIGURACIÓN DE FACTURLINEX2');
            exit;
          end;

          AProcess.Destroy;

          dbQueryAnexos.Next;
          end;
        end;
    end;
end;
//============== GENERA CLAVE DEL NODO =====================
function TFImpresion.GeneraKeyDelNodo():string;
var
  cadena: string;
  cont: integer;
begin
  cadena:='';
  cont:=0;
  while cont < camposKey-1 do
    begin
      cadena:=cadena+dbCabecera.Fields[cont].AsString+'|-|';
      cont:=cont+1;
    end;
  cadena:=cadena+dbCabecera.Fields[cont].AsString;
  //showmessage(cadena);
  Result:=cadena;
end;
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFImpresion.frReportGetValue(const ParName: String;
  var ParValue: Variant);

var
  LeyendaCabeceraQR, LeyendaPieQR: string;

begin

     if UpperCase(vfMode) = 'PRODUCCION' then
     begin
      LeyendaCabeceraQR := ' QR Tributario : ';
      LeyendaPieQR := ' VERI*FACTU ';
     end else
     begin
      LeyendaCabeceraQR := LeyendaSuperiorQR;
      LeyendaPieQR := LeyendaInferiorQR;
     end;

  if ParName ='FechaImpresion' then ParValue := inttostr(frReport.EMFPages.Count) + FormatDateTime('yymmddhhnn', now);

  if ParName='leyenda1' then ParValue := LeyendaCabeceraQR;
  if ParName='leyenda2' then ParValue := LeyendaPieQR;

  if ParName ='EMPRESA' then ParValue := Empresa;
  if ParName='DIRECCION' then ParValue := Direccion;
  if ParName='LOCALIDAD' then ParValue := Localidad;
  if ParName='PROVINCIA' then ParValue := Provincia;
  if ParName='NIF' then ParValue := Nif;
  if ParName='TELEFONO' then ParValue := Telefono;
  if ParName='FAX' then ParValue := Fax;
  if ParName='EMAIL' then ParValue := eMail;
  if ParName='CP' then ParValue := CP;
  if ParName='REGISTRO' then ParValue := REGISTRO;

  if ParName='CCODIGO' then ParValue := dbDatosCliente.FieldByName('C0').AsString;
  if ParName='CCLIENTE' then ParValue := dbDatosCliente.FieldByName('C1').AsString;
  if ParName='CDIRECCION' then ParValue := dbDatosCliente.FieldByName('C3').AsString;
  if ParName='CLOCALIDAD' then ParValue := dbDatosCliente.FieldByName('C4').AsString;
  if ParName='CCIF' then ParValue := dbDatosCliente.FieldByName('C5').AsString;
  if ParName='CCP' then ParValue := dbDatosCliente.FieldByName('C37').AsString;
  if ParName='CPROVINCIA' then ParValue := dbDatosCliente.FieldByName('C38').AsString;

  if ParName='DOCUMENTO' then ParValue := Documento;
  if ParName='FECHA' then ParValue := dbCabecera.Fields[1].AsString;
  if ParName='SERIE' then ParValue := dbCabecera.Fields[2].AsString;
  if ParName='NUMERO' then ParValue := dbCabecera.Fields[3].AsString;

  if nPagina = frReport.EMFPages.Count then
  begin
    if ParName='BASE1' then if BASE1<>0 then ParValue:=FormatFloat('0.000',BASE1) else ParValue:='';
    if ParName='PIVA1' then if PIVA1<>0 then ParValue:=FormatFloat('0',PIVA1) else ParValue:='';
    if ParName='IMPOIVA1' then if IMPOIVA1<>0 then ParValue:=FormatFloat('0.000',IMPOIVA1) else  ParValue:='';
    if ParName='TOTAL1' then if TOTAL1<>0 then ParValue := FormatFloat('0.00',TOTAL1) else  ParValue:='';
    if ParName='PRIVA1' then if PRIVA1<>0 then ParValue := FormatFloat('0',PRIVA1) else  ParValue:='';
    if ParName='IRIVA1' then if IRIVA1<>0 then ParValue := FormatFloat('0.00',IRIVA1) else  ParValue:='';

    if ParName='BASE2' then if BASE2<>0 then ParValue:=FormatFloat('0.000',BASE2) else ParValue:='';
    if ParName='PIVA2' then if PIVA2<>0 then ParValue:=FormatFloat('0',PIVA2) else ParValue:='';
    if ParName='IMPOIVA2' then if IMPOIVA2<>0 then ParValue:=FormatFloat('0.000',IMPOIVA2) else  ParValue:='';
    if ParName='TOTAL2' then if TOTAL2<>0 then ParValue := FormatFloat('0.00',TOTAL2) else  ParValue:='';
    if ParName='PRIVA2' then if PRIVA2<>0 then ParValue := FormatFloat('0',PRIVA2) else  ParValue:='';
    if ParName='IRIVA2' then if IRIVA2<>0 then ParValue := FormatFloat('0.00',IRIVA2) else  ParValue:='';

    if ParName='BASE3' then if BASE3<>0 then ParValue:=FormatFloat('0.000',BASE3) else ParValue:='';
    if ParName='PIVA3' then if PIVA3<>0 then ParValue:=FormatFloat('0',PIVA3) else ParValue:='';
    if ParName='IMPOIVA3' then if IMPOIVA3<>0 then ParValue:=FormatFloat('0.000',IMPOIVA3) else  ParValue:='';
    if ParName='TOTAL3' then if TOTAL3<>0 then ParValue := FormatFloat('0.00',TOTAL3) else  ParValue:='';
    if ParName='PRIVA3' then if PRIVA3<>0 then ParValue := FormatFloat('0',PRIVA3) else  ParValue:='';
    if ParName='IRIVA3' then if IRIVA3<>0 then ParValue := FormatFloat('0.00',IRIVA3) else  ParValue:='';
    if ParName='TOTALGENERAL' then if TOTAL1+TOTAL2+TOTAL3<>0 then ParValue := FormatFloat('0.00',TOTAL1+TOTAL2+TOTAL3) else  ParValue:='';
    if ParName='OBSERVACIONES' then
    if Documento<>'FACTURA' then ParValue := dbCabecera.Fields[11].AsString else
                                  ParValue := dbCabecera.Fields[19].AsString;

    if ParName='FECHAV1' then ParValue:=dbCabecera.Fields[11].AsString;
    if ParName='IMPOV1' then if dbCabecera.Fields[12].AsString<>'0' then ParValue:=dbCabecera.Fields[12].AsString else ParValue:='';
    if ParName='FECHAV2' then ParValue:=dbCabecera.Fields[13].AsString;
    if ParName='IMPOV2' then if dbCabecera.Fields[14].AsString<>'0' then ParValue:=dbCabecera.Fields[14].AsString else ParValue:='';
    if ParName='FECHAV3' then ParValue:=dbCabecera.Fields[15].AsString;
    if ParName='IMPOV3' then if dbCabecera.Fields[16].AsString<>'0' then ParValue:=dbCabecera.Fields[16].AsString else ParValue:='';
    if ParName='FECHAV4' then ParValue:=dbCabecera.Fields[17].AsString;
    if ParName='IMPOV4' then if dbCabecera.Fields[18].AsString<>'0' then ParValue:=dbCabecera.Fields[18].AsString else ParValue:='';
  end else
  begin
    if ParName='BASE1' then ParValue:='';
    if ParName='PIVA1' then ParValue:='';
    if ParName='IMPOIVA1' then ParValue:='';
    if ParName='TOTAL1' then ParValue:='';
    if ParName='PRIVA1' then ParValue:='';
    if ParName='IRIVA1' then ParValue:='';

    if ParName='BASE2' then ParValue:='';
    if ParName='PIVA2' then ParValue:='';
    if ParName='IMPOIVA2' then ParValue:='';
    if ParName='TOTAL2' then ParValue:='';
    if ParName='PRIVA2' then ParValue:='';
    if ParName='IRIVA2' then ParValue:='';

    if ParName='BASE3' then ParValue:='';
    if ParName='PIVA3' then ParValue:='';
    if ParName='IMPOIVA3' then ParValue:='';
    if ParName='TOTAL3' then ParValue:='';
    if ParName='PRIVA3' then ParValue:='';
    if ParName='IRIVA3' then ParValue:='';
    if ParName='TOTALGENERAL' then ParValue:='';
    if ParName='OBSERVACIONES' then ParValue:='';

    if ParName='FECHAV1' then ParValue:='';
    if ParName='IMPOV1' then ParValue:='';
    if ParName='FECHAV2' then ParValue:='';;
    if ParName='IMPOV2' then ParValue:='';
    if ParName='FECHAV3' then ParValue:='';
    if ParName='IMPOV3' then ParValue:='';
    if ParName='FECHAV4' then ParValue:='';
    if ParName='IMPOV4' then ParValue:='';
  end;

  if ParName='TITULO' then ParValue := TituloInforme;

  if ParName = 'SUMAS' then SubTotalPagina := SubTotalPagina + dbImprimir.FieldByName('IMP13').Value;

  if ParName='SUBTOTAL' then ParValue := TotalPagina;

  if ImprimirLOPD='S' then begin
    if ParName='LOPD1' then ParValue := Lopd1;
    if ParName='LOPDEMP' then ParValue := Empresa;
    if ParName='LOPD2' then ParValue := Lopd2;
    if ParName='LOPDDIR' then ParValue := Direccion+', '+CP+' '+Localidad+' ('+Provincia+')';
  end else begin
    if ParName='LOPD1' then ParValue := '';
    if ParName='LOPDEMP' then ParValue := '';
    if ParName='LOPD2' then ParValue := '';
    if ParName='LOPDDIR' then ParValue := '';
  end;

 // BarcodeQR1.Text:=txtQR+'numserie='+dbCabecera.Fields[2].AsString+'%2F'+dbCabecera.Fields[3].AsString
 //                       +'&fecha='+FormatDateTime('dd-mm-yyyy',dbCabecera.Fields[1].AsDateTime)
 //                       +'&importe='+FormatFloat('0.00',dbCabecera.FieldByName('FC9').AsFloat);

end;

//======================= LOGOTIPO DEL FORMULARIO ========================

procedure TFImpresion.frReportEnterRect(Memo: TStringList; View: TfrView);
var
  vImage: TImage;
  RutaLogo: string;
begin

  RutaLogo:=RutaIconos+'Vacio.png';
  if assigned( View ) and  (View is TfrPictureView) then
  begin
     if (view.Name = 'PictureQR') then RutaLogo:=DirectorioQR;
     if (View.Name = 'Picture1') then RutaLogo:= LogoEmpresa;
     if (View.Name = 'EsCopiaDuplicado') then
       begin
          if (cbEsCopia.Checked) then RutaLogo:=RutaIconos+'EsCopia.png';
          if (cbDuplicado.Checked) then RutaLogo:=RutaIconos+'Duplicado.png';
       end;
     if (View.Name = 'Picture2') then RutaLogo:=RutaIconos+'FacturLinExGNU.jpeg';

     try
        vImage := TImage.Create( nil );
        try
           TfrPictureView(View).Picture.Clear;
           TfrPictureView(View).Picture.LoadFromFile(RutaLogo);
        finally
          FreeAndNil(vImage);
        end;
    except
        TfrPictureView(View).Picture.Clear;
    end;
  end;

end;

//=================== CALCULAR TIPOS DE IVAS ==================
procedure TFImpresion.CalculaIvas();
begin

  // Debe cargarse previamente en dbTemporal la consulta de detalles.

  dbTemporal.First;

  //------------------------ Primer tipo de iva
  if dbTemporal.Eof=False then
   begin
    PIVA1:=dbTemporal.Fields[0].AsInteger;
//    IMPOIVA1:=dbTemporal.Fields[1].AsFloat;
//    BASE1:=dbTemporal.Fields[2].AsFloat;
    TOTAL1:=dbTemporal.Fields[3].AsFloat;
    BASE1:=TOTAL1/(1+(dbTemporal.Fields[0].AsInteger/100));
    IMPOIVA1:=BASE1*(dbTemporal.Fields[0].AsInteger/100);
    //---------------- Recargo
    if dbDatosCliente.FieldByName('C19').AsString='S' then
      begin
       VerRecargo();
       PRIVA1:=RECARGO;
       IRIVA1:=dbTemporal.Fields[2].AsFloat-((dbTemporal.Fields[2].AsFloat*100)/(RECARGO+100));
       TOTAL1:=dbTemporal.Fields[3].AsFloat+dbTemporal.Fields[2].AsFloat-((dbTemporal.Fields[2].AsFloat*100)/(RECARGO+100));
      end;
   end;
  dbTemporal.Next;
  //------------------------ Segundo tipo de iva
  if dbTemporal.Eof=False then
   begin
    PIVA2:=dbTemporal.Fields[0].AsInteger;
//    IMPOIVA2:=dbTemporal.Fields[1].AsFloat;
//    BASE2:=dbTemporal.Fields[2].AsFloat;
    TOTAL2:=dbTemporal.Fields[3].AsFloat;
    BASE2:=TOTAL2/(1+(dbTemporal.Fields[0].AsInteger/100));
    IMPOIVA2:=BASE2*(dbTemporal.Fields[0].AsInteger/100);
    //---------------- Recargo
    if dbDatosCliente.FieldByName('C19').AsString='S' then
      begin
       VerRecargo();
       PRIVA2:=RECARGO;
       IRIVA2:=dbTemporal.Fields[2].AsFloat-((dbTemporal.Fields[2].AsFloat*100)/(RECARGO+100));
       TOTAL2:=dbTemporal.Fields[3].AsFloat+dbTemporal.Fields[2].AsFloat-((dbTemporal.Fields[2].AsFloat*100)/(RECARGO+100));
      end;
   end;
  dbTemporal.Next;
  //------------------------ Tercer tipo de iva
  if dbTemporal.Eof=False then
   begin
    PIVA3:=dbTemporal.Fields[0].AsInteger;
//    IMPOIVA3:=dbTemporal.Fields[1].AsFloat;
//    BASE3:=dbTemporal.Fields[2].AsFloat;
    TOTAL3:=dbTemporal.Fields[3].AsFloat;
    BASE3:=TOTAL3/(1+(dbTemporal.Fields[0].AsInteger/100));
    IMPOIVA3:=BASE3*(dbTemporal.Fields[0].AsInteger/100);
    //---------------- Recargo
    if dbDatosCliente.FieldByName('C19').AsString='S' then
      begin
       VerRecargo();
       PRIVA3:=RECARGO;
       IRIVA3:=dbTemporal.Fields[2].AsFloat-((dbTemporal.Fields[2].AsFloat*100)/(RECARGO+100));
       TOTAL3:=dbTemporal.Fields[3].AsFloat+dbTemporal.Fields[2].AsFloat-((dbTemporal.Fields[2].AsFloat*100)/(RECARGO+100));
      end;
   end;
end;

procedure TFImpresion.RadioGroup2Click(Sender: TObject);
begin
  if (RadioGroup2.ItemIndex=2) then
    Begin
         Edit1.Enabled:= True;
         SpinEdit1.Value:=1;
    End
  else
    Begin
         Edit1.Enabled:= False;
//         SpinEdit1.Value:=dbDatosCliente.FieldByName('C8').AsInteger;
         if SpinEdit1.Value=0 then SpinEdit1.Value:=1;
    End;
end;

//================ TIPOS DE RECARGO =====================
procedure TFImpresion.VerRecargo();
begin
   RECARGO:=RIVA1;
   if dbTemporal.Fields[0].AsFloat=IVA1 then RECARGO:=RIVA1;
   if dbTemporal.Fields[0].AsFloat=IVA2 then RECARGO:=RIVA2;
   if dbTemporal.Fields[0].AsFloat=IVA3 then RECARGO:=RIVA3;
end;

procedure TFImpresion.btSalirClick(Sender: TObject);
begin
  Close();
end;

//========================== Creación de .XML para FacturaE ==============
procedure TFImpresion.btxmlClick(Sender: TObject);
var
  Gen: TFacturaEGenerator;
  XMLFile, XMLFirmado: String;
begin
  // Solo FACTURA
  if Documento <> 'FACTURA' then
  begin
    ShowMessage('Solo se genera FacturaE para FACTURAS.');
    Exit;
  end;

  // Asegúrate de que dbImprimir tiene imptmp listo (ya lo haces en ImpDocumento)
  ImpDocumento();       // prepara imptmp y dbImprimir
  TipoImpreso();        // no afecta al XML, pero mantiene tu flujo

  XMLFile := Edit1.Text + '.xml'; // o lo que tú quieras como ruta/nombre

  Gen := TFacturaEGenerator.Create;
  try
    Gen.BuildFacturaE(dbCabecera, dbImprimir, dbDatosCliente, XMLFile);
  finally
    Gen.Free;
  end;

  // Firmar
  XMLFirmado := FirmarFactura(XMLFile);

  ShowMessage('FacturaE generada y firmada: ' + XMLFirmado);
end;

//**********************************
//**** PRUEBA FIRMA XML COPILOT ****
//**********************************
function TFImpresion.FirmarFactura(XMLFile: string): string;
var
  OutputFile: String;
begin
  // Salida: mismo nombre + sufijo _firmada
  OutputFile := ChangeFileExt(XMLFile, '') + '_firmada.xml';

  if SignFacturaEXAdES(XMLFile, OutputFile) then
    Result := OutputFile
  else
    raise Exception.Create('No se pudo firmar la factura FacturaE.');
end;

procedure TFImpresion.Edit1Exit(Sender: TObject);
begin
  NombrePDF:= Edit1.Text;
end;

//=========================== Imprimir con Ticket ==================
procedure TFImpresion.ImpreTicket(dbMuestrad: TZQuery; dbMuestrac: TZQuery; dbCliente: TZQuery;
                                 TipoDocumento: String);
var
  Precio, SubTotal: Double;
  Texto: String;
begin
  with TFImpresion.Create(Application) do
    begin
     Documento:= TipoDocumento;
     dbDatosCliente:= dbCliente;
     dbCabecera:= dbMuestrac;
     dbDetalles:= dbMuestrad;

     AssignFile(PrintText, DevTicket); //añadido por javi para quitar opendialog
     Rewrite(PrintText);
     CabeceraTicket();
     dbMuestrad.First;
     while not dbDetalles.Eof do
       begin
         if DesgloIva='S' then
           begin
            Precio:=dbDetalles.Fields[9].AsFloat;
            SubTotal:=dbDetalles.Fields[11].AsFloat;
           end else
           begin
            Precio:=dbDetalles.Fields[8].AsFloat;
            SubTotal:=dbDetalles.Fields[13].AsFloat;
           end;
         Texto:=Copy(dbMuestrad.Fields[6].AsString+'                    ',1,18)+' ';
         Texto:=Texto + DataModule1.LFill(FormatFloat('##0.00',dbDetalles.Fields[7].AsFloat),6,' ') + ' ';
         Texto:=Texto + DataModule1.LFill(FormatFloat('##0.00',Precio),6,' ') + ' ';
         Texto:=Texto + DataModule1.LFill(FormatFloat('###0.00',SubTotal),7,' ');
         Writeln(PrintText, Texto);
         dbDetalles.Next;
       end;
     PieTicket();
     CloseFile(PrintText);
     Close();
    end;
end;

//============== CABECERA DEL TICKET ===================================
procedure TFImpresion.CabeceraTicket();
var
hora: String;
begin
  if Trim(LCTI1)<>'' then Writeln(PrintText, LCTI1);
  if Trim(LCTI2)<>'' then Writeln(PrintText, LCTI2);
  if Trim(LCTI3)<>'' then Writeln(PrintText, LCTI3);
  if Trim(LCTI4)<>'' then Writeln(PrintText, LCTI4);
  hora:='';
  if HoraEnTicket='S' then hora:='   Hora.:'+FormatDateTime('hh:mm:ss',TIME);

  Writeln(PrintText, ' ');

  Writeln(PrintText, 'N.'+Documento+':'+ dbCabecera.Fields[2].AsString+'/'+DataModule1.LFill(FormatFloat('#######',dbCabecera.Fields[3].AsFloat),7,' '));

  Writeln(PrintText, ' ');
  Writeln(PrintText, 'Fecha.: '+FormatDateTime('dd/mm/yyyy',dbCabecera.Fields[1].AsDateTime)+hora);
  Writeln(PrintText, ' ');
  Writeln(PrintText, 'ARTICULO              UND PRECIO   TOTAL');
  Writeln(PrintText, '========================================');
end;

//====================== PIE DEL TICKETC =============================
procedure TFImpresion.PieTicket();
Var
  Impuestos: Double;
  Conta: Integer;
begin
  Writeln(PrintText, ' ');
  Writeln(PrintText, '                               ---------');

  Impuestos:=dbCabecera.Fields[9].AsFloat - dbCabecera.Fields[8].AsFloat;

  if SacaIva='N' then
    begin
      Writeln(PrintText, '                    NETO      '+DataModule1.LFill( FormatFloat('######0.00',dbCabecera.Fields[8].AsFloat),7,' '));
      Writeln(PrintText, '                    IVA       '+DataModule1.LFill( FormatFloat('######0.00',Impuestos),7,' '));
    end;

  Writeln(PrintText, '                    TOTAL     '+DataModule1.LFill( FormatFloat('######0.00',dbCabecera.Fields[9].AsFloat),7,' '));
  Writeln(PrintText, ' ');
  //----------------- Sacar iva uncluido en el ticket o no --------------
  if SacaIva<>'N' then
    begin

     Writeln(PrintText, '            * IVA INCLUIDO *            ');
     Writeln(PrintText, ' ');
    end;

  Writeln(PrintText, 'Cliente: '+dbDatosCliente.FieldByName('C0').AsString);
  Writeln(PrintText, dbDatosCliente.FieldByName('C1').AsString);
  Writeln(PrintText, ' ');

  //----------------- Sacar vendedor en el ticket o no --------------
   if SacaVende<>'N' then Writeln(PrintText, 'LE ATENDIO.: '+ copy(UsuarioActivo,1,35));

  //----------------------------------------------------------------
  if Trim(LPTI1)<>'' then Writeln(PrintText, LPTI1);
  if Trim(LPTI2)<>'' then Writeln(PrintText, LPTI2);
  if Trim(LPTI3)<>'' then Writeln(PrintText, LPTI3);
  for Conta:=1 to StrToInt(LiFinTick) do Writeln(PrintText, ' ');
end;

procedure TFImpresion.EsVentas;
begin
   Delete(Documento,1,1);
   if Documento='ALBARAN'  then
     if CgPrAlbV='S' then  RadioGroup2.ItemIndex:=0           //previsualización.
                     else  RadioGroup2.ItemIndex:=1;           // Imprime.

   if Documento='FACTURA'  then
     if CgPrFraV='S' then  RadioGroup2.ItemIndex:=0           //previsualización.
                     else  RadioGroup2.ItemIndex:=1;           // Imprime.

   btOk1Click(Self);

   Close();

end;

procedure TFImpresion.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=VK_ESCAPE) then begin key:=0; btSalirClick(self); Exit; End;
  if (key=VK_RETURN) and (btOK1.Enabled=True) and not(mmTexto.Focused) then begin key:=0; btOk1Click(self) ; Exit; End;
end;

procedure TFImpresion.FormShow(Sender: TObject);
begin
  Edit1.Text:= NombrePDF;
  edAdjunto.Text:= NombrePDF;
end;

procedure TFImpresion.frReportBeginDoc;
begin
  nPagina:= 0;              // Inicializamos página.
end;

procedure TFImpresion.frReportBeginPage(pgNo: Integer);
begin
  SubTotalPagina:=0;
end;

procedure TFImpresion.frReportEndPage(pgNo: Integer);
begin
  TotalPagina:= TotalPagina + SubTotalPagina;
  if (frReport.DoublePass) and (not frReport.FinalPass) then Inc(nPagina); // Incrementamos número de página
end;

procedure TFImpresion.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
    CloseAction:=CaFree;
end;

procedure TFImpresion.sbBuscarClick(Sender: TObject);
begin
    if OpenDialog1.Execute then
      begin
       edAdjunto.Text := OpenDialog1.FileName;
      end;
end;

procedure TFImpresion.FormCreate(Sender: TObject);
begin
  // Conectate(dbConect);               // Usamos dbConexion como conexión única para todo el proyecto.

  if DatosEmpresa='S' then CheckBox1.Checked:=False;

  Edit1.Enabled:=False;
  RadioGroup2.ItemIndex:=1;
  if ImprePrevisu='S' then RadioGroup2.ItemIndex:=0;
  if ImprePDF='S' then begin RadioGroup2.ItemIndex:=2; Edit1.Enabled:= True; end;

  DirectorioReport:=RutaReports;

end;

procedure TFImpresion.CorreosElectronicos;
begin

  edDestinatario.Text:= dbdatoscliente.FieldByName('C40').AsString;
  edAsunto.Text:= Documento+' / Cliente # '+ dbdatoscliente.FieldByName('C0').AsString;                                         //CorreoCabecera;
  edDestinatarioCopia.Text:= CorreoCopia;

  mmTexto.lines.Add(CorreoMensaje1);
  mmTexto.lines.Add(CorreoMensaje2);
  mmTexto.lines.Add(CorreoMensaje3);
  mmTexto.lines.Add(CorreoMensaje4);
  mmTexto.lines.Add(chr(13));
  mmTexto.lines.Add(CorreoLOPD1 +' '+empresa );
  mmTexto.lines.Add(CorreoLOPD2 +' '+direccion+' '+localidad +'('+Provincia+')');
  mmTexto.lines.Add(CorreoLOPD3 +' '+Email+chr(13));
  mmTexto.Lines.Add(chr(13)+' *** Mensaje generado por Facturlinex VF 4 *** ');

end;

initialization
  {$I imprimir.lrs}

end.

