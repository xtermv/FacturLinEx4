unit uVFSubsanacionSend;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, ZConnection, ZDataset, uVFSenderAEAT, uVFSubsanacionCertificacion, uVFSubsanacionCrypto, uVFSubsanacionXML, Global;

function VF_EnsureSubEnvironment(AConn: TZConnection;
  const ASubID: Int64; out AEnvironment, AURL, AError: string): Boolean;

function VF_SendValidatedSubsanacion(AConn: TZConnection; const ASubID: Int64;
  out AQueueID: Int64; out AFinalState, AResponse, AError: string): Boolean;

implementation

function ExtractTag(const XML, Tag: string): string;
var
  OpenTag, CloseTag: string;
  P1, P2: SizeInt;
begin
  Result := '';
  OpenTag := '<' + Tag + '>';
  CloseTag := '</' + Tag + '>';
  P1 := Pos(OpenTag, XML);
  if P1 = 0 then Exit;
  P1 := P1 + Length(OpenTag);
  P2 := Pos(CloseTag, XML);
  if (P2 = 0) or (P2 <= P1) then Exit;
  Result := Copy(XML, P1, P2 - P1);
end;

function FirstTag(const XML, A, B: string): string;
begin
  Result := ExtractTag(XML, A);
  if Result = '' then
    Result := ExtractTag(XML, B);
end;



function VF_EnsureSubEnvironment(AConn: TZConnection;
  const ASubID: Int64; out AEnvironment, AURL, AError: string): Boolean;
var
  Q: TZQuery;
  OrigQueueID, SubQueueID: Int64;
  OrigEnvironment, SubEnvironment, ConfigEnvironment: string;
begin
  Result := False;
  AEnvironment := '';
  AURL := '';
  AError := '';
  OrigQueueID := 0;
  SubQueueID := 0;

  if (AConn = nil) or (not AConn.Connected) then
  begin
    AError := 'No existe una conexión activa con MariaDB.';
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConn;
    Q.SQL.Text :=
      'SELECT s.queue_id,s.nuevo_queue_id,' +
      'UPPER(TRIM(COALESCE(o.entorno,''''))) AS orig_entorno,' +
      'UPPER(TRIM(COALESCE(n.entorno,''''))) AS sub_entorno ' +
      'FROM verifactu_subsanaciones s ' +
      'LEFT JOIN verifactu_queue o ON o.id=s.queue_id ' +
      'LEFT JOIN verifactu_queue n ON n.id=s.nuevo_queue_id ' +
      'WHERE s.id=:sid LIMIT 1';
    Q.ParamCheck := True;
    Q.ParamByName('sid').AsLargeInt := ASubID;
    Q.Open;

    if Q.EOF then
    begin
      AError := 'No se localiza la subsanación.';
      Exit;
    end;

    OrigQueueID := Q.FieldByName('queue_id').AsLargeInt;
    SubQueueID := Q.FieldByName('nuevo_queue_id').AsLargeInt;
    OrigEnvironment := Q.FieldByName('orig_entorno').AsString;
    SubEnvironment := Q.FieldByName('sub_entorno').AsString;
    Q.Close;

    { Fuente única de verdad: vfMode, la misma variable que usa FacturLinEx
      para barra de estado, menús y selección de modo VeriFactu. La URL se
      obtiene solo con fines informativos/diagnóstico. }
    VF_GetConfiguredAEATEnvironment(AURL);
    ConfigEnvironment := UpperCase(Trim(vfMode));
    if ConfigEnvironment = 'TEST' then
      ConfigEnvironment := 'PRUEBAS';

    if (ConfigEnvironment <> 'PRUEBAS') and
       (ConfigEnvironment <> 'PRODUCCION') then
    begin
      AError := 'La variable global vfMode contiene un valor no válido: ' +
        Trim(vfMode) + '. Se esperaba PRUEBAS o PRODUCCION.';
      Exit;
    end;

    if (OrigEnvironment = 'PRUEBAS') or (OrigEnvironment = 'PRODUCCION') then
      if OrigEnvironment <> ConfigEnvironment then
      begin
        AError := 'El ORIG está marcado como ' + OrigEnvironment +
          ' pero vfMode está configurado como ' + ConfigEnvironment +
          '. Se bloquea el envío por seguridad.';
        Exit;
      end;

    if (SubEnvironment = 'PRUEBAS') or (SubEnvironment = 'PRODUCCION') then
      if SubEnvironment <> ConfigEnvironment then
      begin
        AError := 'El SUB-* está marcado como ' + SubEnvironment +
          ' pero vfMode está configurado como ' + ConfigEnvironment +
          '. Se bloquea el envío por seguridad.';
        Exit;
      end;

    AEnvironment := ConfigEnvironment;

    if OrigQueueID > 0 then
    begin
      Q.SQL.Text :=
        'UPDATE verifactu_queue SET entorno=:e,updated_at=NOW() ' +
        'WHERE id=:qid AND (COALESCE(entorno,'''')='''' OR ' +
        'UPPER(TRIM(entorno))=''SIN_CLASIFICAR'')';
      Q.ParamCheck := True;
      Q.ParamByName('e').AsString := AEnvironment;
      Q.ParamByName('qid').AsLargeInt := OrigQueueID;
      Q.ExecSQL;
    end;

    if SubQueueID > 0 then
    begin
      Q.Close;
      Q.SQL.Text :=
        'UPDATE verifactu_queue SET entorno=:e,updated_at=NOW() ' +
        'WHERE id=:qid AND (COALESCE(entorno,'''')='''' OR ' +
        'UPPER(TRIM(entorno))=''SIN_CLASIFICAR'')';
      Q.ParamCheck := True;
      Q.ParamByName('e').AsString := AEnvironment;
      Q.ParamByName('qid').AsLargeInt := SubQueueID;
      Q.ExecSQL;
    end;

    Q.Close;
    Q.SQL.Text :=
      'UPDATE verifactu_subsanaciones SET entorno=:e,updated_at=NOW() ' +
      'WHERE id=:sid AND (COALESCE(entorno,'''')='''' OR ' +
      'UPPER(TRIM(entorno))=''SIN_CLASIFICAR'')';
    Q.ParamCheck := True;
    Q.ParamByName('e').AsString := AEnvironment;
    Q.ParamByName('sid').AsLargeInt := ASubID;
    Q.ExecSQL;

    Result := True;
  except
    on E: Exception do
      AError := E.Message;
  end;
  Q.Free;
end;

function VF_SendValidatedSubsanacion(AConn: TZConnection; const ASubID: Int64;
  out AQueueID: Int64; out AFinalState, AResponse, AError: string): Boolean;
var
  Q: TZQuery;
  XML, Entorno, UID, Serie, EstadoRegistro, CodError, DescError, TargetURL: string;
  FreshHash, FreshXML, RefreshErr: string;
  FreshQueueID: Int64;
  TransportOK: Boolean;
  TestSubID, TestQueueID: Int64;
  TestDate: TDateTime;
  CertErr: string;
begin
  Result := False;
  AQueueID := 0;
  AFinalState := '';
  AResponse := '';
  AError := '';

  if (AConn = nil) or (not AConn.Connected) then
  begin
    AError := 'No existe una conexión activa con MariaDB.';
    Exit;
  end;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := AConn;
    Q.SQL.Text :=
      'SELECT s.estado,s.xml_preparado,q.id,q.serie,q.numero,q.entorno,' +
      'q.registro_uid,q.hash,q.hash_prev ' +
      'FROM verifactu_subsanaciones s ' +
      'JOIN verifactu_queue q ON q.id=s.nuevo_queue_id ' +
      'WHERE s.id=:sid AND q.origen=''SUBSANACION'' ' +
      'AND q.registro_uid=CONCAT(''SUB-'',s.id) LIMIT 1';
    Q.ParamCheck := True;
    Q.ParamByName('sid').AsLargeInt := ASubID;
    Q.Open;

    if Q.EOF then
    begin
      AError := 'No se localiza el SUB-* vinculado.';
      Exit;
    end;

    if not SameText(Trim(Q.FieldByName('estado').AsString), 'XML_VALIDADO') then
    begin
      AError := 'La subsanación debe estar en estado XML_VALIDADO.';
      Exit;
    end;

    if not VF_EnsureSubEnvironment(
      AConn, ASubID, Entorno, TargetURL, AError) then
      Exit;

    { PRODUCCIÓN no depende de una prueba local previa.
      La selección del destino se controla por vfMode y la UI mantiene
      confirmación reforzada antes de cualquier envío real. }

    AQueueID := Q.FieldByName('id').AsLargeInt;

    { AEAT valida FechaHoraHusoGenRegistro contra su hora actual.
      La huella/XML preparados manualmente pueden haber envejecido mientras
      el usuario revisaba el registro. Por ello, justo antes del HTTP,
      invalidamos SOLO la evidencia técnica del SUB y la reconstruimos con
      una FechaHoraHusoGenRegistro actual. La fecha de expedición fiscal
      permanece intacta dentro del payload. }
    Q.Close;
    Q.SQL.Text :=
      'UPDATE verifactu_queue SET hash=NULL,hash_input=NULL,' +
      'hash_fecha_huso=NULL,updated_at=NOW() WHERE id=:qid';
    Q.ParamCheck := True;
    Q.ParamByName('qid').AsLargeInt := AQueueID;
    Q.ExecSQL;

    Q.Close;
    Q.SQL.Text :=
      'UPDATE verifactu_subsanaciones SET estado=''EN_COLA_PENDIENTE'',' +
      'xml_preparado=NULL,xml_validated_at=NULL,updated_at=NOW() ' +
      'WHERE id=:sid';
    Q.ParamCheck := True;
    Q.ParamByName('sid').AsLargeInt := ASubID;
    Q.ExecSQL;

    FreshQueueID := 0;
    FreshHash := '';
    RefreshErr := '';
    if not VF_PrepareSubsanacionCrypto(
      AConn, ASubID, FreshQueueID, FreshHash, RefreshErr) then
    begin
      AError := 'No se ha podido refrescar la huella/fecha antes del envío: ' +
        RefreshErr;
      Exit;
    end;

    if FreshQueueID <> AQueueID then
    begin
      AError := 'La reconstrucción previa al envío ha cambiado el Queue ID. ' +
        'Se bloquea por seguridad.';
      Exit;
    end;

    FreshXML := '';
    RefreshErr := '';
    if not VF_PrepareAndValidateSubsanacionXML(
      AConn, ASubID, FreshQueueID, FreshXML, RefreshErr) then
    begin
      AError := 'No se ha podido regenerar el XML inmediatamente antes del envío: ' +
        RefreshErr;
      Exit;
    end;

    if FreshQueueID <> AQueueID then
    begin
      AError := 'La validación XML previa al envío ha cambiado el Queue ID. ' +
        'Se bloquea por seguridad.';
      Exit;
    end;

    { Volvemos a leer el registro ya refrescado. }
    Q.Close;
    Q.SQL.Text :=
      'SELECT s.estado,s.xml_preparado,q.id,q.serie,q.numero,q.entorno,' +
      'q.registro_uid,q.hash,q.hash_prev,q.hash_fecha_huso ' +
      'FROM verifactu_subsanaciones s ' +
      'JOIN verifactu_queue q ON q.id=s.nuevo_queue_id ' +
      'WHERE s.id=:sid AND q.id=:qid LIMIT 1';
    Q.ParamCheck := True;
    Q.ParamByName('sid').AsLargeInt := ASubID;
    Q.ParamByName('qid').AsLargeInt := AQueueID;
    Q.Open;

    if Q.EOF then
    begin
      AError := 'No se puede releer el SUB-* después de refrescar fecha/huella.';
      Exit;
    end;

    if not SameText(Trim(Q.FieldByName('estado').AsString), 'XML_VALIDADO') then
    begin
      AError := 'El SUB-* no ha quedado XML_VALIDADO tras refrescarlo.';
      Exit;
    end;
    Serie := Q.FieldByName('serie').AsString;
    UID := Q.FieldByName('registro_uid').AsString;
    XML := Q.FieldByName('xml_preparado').AsString;

    if Trim(XML) = '' then
    begin
      AError := 'No existe xml_preparado.';
      Exit;
    end;

    if Trim(Q.FieldByName('hash').AsString) = '' then
    begin
      AError := 'El SUB-* no contiene huella preparada.';
      Exit;
    end;

    if Trim(Q.FieldByName('hash_fecha_huso').AsString) = '' then
    begin
      AError := 'El SUB-* no contiene FechaHoraHusoGenRegistro actualizada.';
      Exit;
    end;

    Q.Close;

    { Marca transitoria solo del SUB-* exacto. El dispatcher ORIG no interviene. }
    Q.SQL.Text :=
      'UPDATE verifactu_queue SET estado=''EN_PROCESO'',last_attempt_at=NOW(),' +
      'intentos=intentos+1,updated_at=NOW() WHERE id=:qid';
    Q.ParamCheck := True;
    Q.ParamByName('qid').AsLargeInt := AQueueID;
    Q.ExecSQL;

    TransportOK := VF_SendPreparedXML_HTTP(
      Serie + '_' + UID, XML, AResponse);

    if not TransportOK then
    begin
      AFinalState := 'ERROR_TECNICO';
      Q.Close;
      Q.SQL.Text :=
        'UPDATE verifactu_queue SET estado=''PENDIENTE'',last_error=:e,' +
        'respuesta_text=:r,updated_at=NOW() WHERE id=:qid';
      Q.ParamCheck := True;
      Q.ParamByName('e').AsString :=
        Copy('Fallo técnico/transporte en envío SUB-*', 1, 255);
      Q.ParamByName('r').AsString := AResponse;
      Q.ParamByName('qid').AsLargeInt := AQueueID;
      Q.ExecSQL;

      Q.Close;
      Q.SQL.Text :=
        'UPDATE verifactu_subsanaciones SET estado=''ERROR_TECNICO'',' +
        'updated_at=NOW() WHERE id=:sid';
      Q.ParamCheck := True;
      Q.ParamByName('sid').AsLargeInt := ASubID;
      Q.ExecSQL;

      AError := 'Fallo técnico o de transporte. El SUB-* vuelve a PENDIENTE.';
      Exit;
    end;

    EstadoRegistro := FirstTag(AResponse, 'tikR:EstadoRegistro', 'EstadoRegistro');
    CodError := FirstTag(AResponse, 'tikR:CodigoErrorRegistro', 'CodigoErrorRegistro');
    DescError := FirstTag(AResponse, 'tikR:DescripcionErrorRegistro',
      'DescripcionErrorRegistro');

    if SameText(EstadoRegistro, 'Correcto') then
      AFinalState := 'ENVIADA_CORRECTA'
    else if SameText(EstadoRegistro, 'AceptadoConErrores') then
      AFinalState := 'ENVIADA_CON_ERRORES'
    else
      AFinalState := 'ERROR_AEAT';

    { Solo un Correcto real en PRUEBAS abre la puerta de producción.
      AceptadoConErrores no se considera certificación suficiente. }
    if (Entorno = 'PRUEBAS') and SameText(EstadoRegistro, 'Correcto') then
    begin
      CertErr := '';
      if not VF_SubRegisterSuccessfulTest(
        AConn, ASubID, AQueueID, AResponse, CertErr) then
      begin
        { No degradamos la respuesta fiscal correcta, pero dejamos evidencia
          del fallo interno para que el usuario lo vea antes de producción. }
        AResponse := AResponse + LineEnding +
          '[VF AVISO] La prueba fue Correcta, pero no se pudo guardar la ' +
          'certificación local: ' + CertErr;
      end;
    end;

    Q.Close;
    if AFinalState = 'ERROR_AEAT' then
    begin
      Q.SQL.Text :=
        'UPDATE verifactu_queue SET estado=''ERROR'',respuesta_text=:r,' +
        'last_error=:e,updated_at=NOW() WHERE id=:qid';
      Q.ParamCheck := True;
      Q.ParamByName('r').AsString := AResponse;
      Q.ParamByName('e').AsString :=
        Copy(Trim(CodError + ' ' + DescError), 1, 255);
      Q.ParamByName('qid').AsLargeInt := AQueueID;
      Q.ExecSQL;
    end
    else
    begin
      Q.SQL.Text :=
        'UPDATE verifactu_queue SET estado=''ENVIADO'',respuesta_text=:r,' +
        'last_error=NULL,updated_at=NOW() WHERE id=:qid';
      Q.ParamCheck := True;
      Q.ParamByName('r').AsString := AResponse;
      Q.ParamByName('qid').AsLargeInt := AQueueID;
      Q.ExecSQL;
    end;

    Q.Close;
    Q.SQL.Text :=
      'UPDATE verifactu_subsanaciones SET estado=:st,updated_at=NOW() ' +
      'WHERE id=:sid';
    Q.ParamCheck := True;
    Q.ParamByName('st').AsString := AFinalState;
    Q.ParamByName('sid').AsLargeInt := ASubID;
    Q.ExecSQL;

    Result := True;
  except
    on E: Exception do
    begin
      AError := E.Message;
      AFinalState := 'ERROR_INTERNO';
    end;
  end;
  Q.Free;
end;

end.
