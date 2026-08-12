unit uVFSubsanacionEditor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, fpjson, jsonparser, ZConnection, ZDataset, LCLType, uVFJSONPatch;

function VF_EditSubsanacionData(AConn: TZConnection; ASubID: Int64;
  out AChanged: Boolean; out AError: string): Boolean;

implementation

type
  TfrmVFSubsanacionEditor = class(TForm)
  private
    FConn: TZConnection;
    FSubID: Int64;
    FOriginalJSON: string;
    FWorkingJSON: string;
    FTipoFactura: string;
    FClientCode: string;

    Header, Body, Footer: TPanel;
    LbTitle, LbInfo, LbNIFOld, LbNameOld, LbNIFNew, LbNameNew,
      LbErrorAEAT, LbPayload: TLabel;
    RGCase: TRadioGroup;
    EdNIFOld, EdNameOld, EdNIFNew, EdNameNew: TEdit;
    MemoError, MemoPayload: TMemo;
    BtnSave, BtnCancel: TBitBtn;

    procedure BuildUI;
    function LoadData(out AError: string): Boolean;
    function BuildCorrectedJSON(out AJSON, AError: string): Boolean;
    procedure OfferUpdateClientNIF(const ANewNIF: string);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure FormKeyDownHandler(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  public
    Saved: Boolean;
    constructor CreateWith(AConn: TZConnection; ASubID: Int64); reintroduce;
  end;

function JSONChildObject(AObj: TJSONObject; const AName: string): TJSONObject;
var
  D: TJSONData;
begin
  Result := nil;
  D := AObj.Find(AName);
  if (D <> nil) and (D.JSONType = jtObject) then
    Result := TJSONObject(D);
end;

function JSONStr(AObj: TJSONObject; const AName: string): string;
var
  D: TJSONData;
begin
  Result := '';
  if AObj = nil then Exit;
  D := AObj.Find(AName);
  if D <> nil then
    Result := D.AsString;
end;

procedure JSONSetStr(AObj: TJSONObject; const AName, AValue: string);
var
  I: Integer;
begin
  if AObj = nil then Exit;
  I := AObj.IndexOfName(AName);
  if I >= 0 then AObj.Delete(I);
  AObj.Add(AName, AValue);
end;

function VF_EditSubsanacionData(AConn: TZConnection; ASubID: Int64;
  out AChanged: Boolean; out AError: string): Boolean;
var
  F: TfrmVFSubsanacionEditor;
begin
  Result := False;
  AChanged := False;
  AError := '';

  if (AConn = nil) or (not AConn.Connected) then
  begin
    AError := 'No existe una conexión activa con MariaDB.';
    Exit;
  end;

  F := TfrmVFSubsanacionEditor.CreateWith(AConn, ASubID);
  try
    if not F.LoadData(AError) then Exit;
    F.ShowModal;
    AChanged := F.Saved;
    Result := True;
  finally
    F.Free;
  end;
end;

constructor TfrmVFSubsanacionEditor.CreateWith(AConn: TZConnection;
  ASubID: Int64);
begin
  inherited CreateNew(nil, 1);
  FConn := AConn;
  FSubID := ASubID;
  Saved := False;

  Caption := 'Corregir datos de subsanación VeriFactu';
  Position := poScreenCenter;
  Width := 1080;
  Height := 760;
  Color := RGBToColor(244,247,250);
  KeyPreview := True;
  OnKeyDown := @FormKeyDownHandler;

  BuildUI;
end;

procedure TfrmVFSubsanacionEditor.BuildUI;
begin
  Header := TPanel.Create(Self);
  Header.Parent := Self;
  Header.Align := alTop;
  Header.Height := 92;
  Header.BevelOuter := bvNone;
  Header.Color := RGBToColor(28,82,130);
  Header.Caption := '';

  LbTitle := TLabel.Create(Self);
  LbTitle.Parent := Header;
  LbTitle.SetBounds(24,14,900,28);
  LbTitle.Caption := 'CORREGIR DATOS DEL REGISTRO DE SUBSANACIÓN';
  LbTitle.ParentFont := False;
  LbTitle.Font.Height := -20;
  LbTitle.Font.Style := [fsBold];
  LbTitle.Font.Color := clWhite;

  LbInfo := TLabel.Create(Self);
  LbInfo.Parent := Header;
  LbInfo.SetBounds(24,50,1010,34);
  LbInfo.AutoSize := False;
  LbInfo.WordWrap := True;
  LbInfo.Caption :=
    'Se corrige una COPIA para el nuevo registro. La factura y el registro VeriFactu original no se modifican.';
  LbInfo.ParentFont := False;
  LbInfo.Font.Color := RGBToColor(225,238,249);

  Footer := TPanel.Create(Self);
  Footer.Parent := Self;
  Footer.Align := alBottom;
  Footer.Height := 70;
  Footer.BevelOuter := bvNone;
  Footer.Color := RGBToColor(232,240,247);
  Footer.Caption := '';

  BtnSave := TBitBtn.Create(Self);
  BtnSave.Parent := Footer;
  BtnSave.SetBounds(20,15,220,40);
  BtnSave.Caption := 'Guardar corrección';
  BtnSave.Font.Style := [fsBold];
  BtnSave.OnClick := @BtnSaveClick;

  BtnCancel := TBitBtn.Create(Self);
  BtnCancel.Parent := Footer;
  BtnCancel.SetBounds(Footer.Width-140,15,115,40);
  BtnCancel.Anchors := [akTop,akRight];
  BtnCancel.Caption := 'Cancelar';
  BtnCancel.OnClick := @BtnCancelClick;

  Body := TPanel.Create(Self);
  Body.Parent := Self;
  Body.Align := alClient;
  Body.BevelOuter := bvNone;
  Body.Color := RGBToColor(248,250,252);
  Body.Caption := '';

  RGCase := TRadioGroup.Create(Self);
  RGCase.Parent := Body;
  RGCase.SetBounds(20,16,Body.ClientWidth-40,92);
  RGCase.Anchors := [akLeft,akTop,akRight];
  RGCase.Caption := '¿Qué estaba mal?';
  RGCase.Items.Add('La factura emitida era correcta; el error está solo en el registro VeriFactu.');
  RGCase.Items.Add('La propia factura emitida también contiene datos incorrectos.');
  RGCase.ItemIndex := 0;

  LbNIFOld := TLabel.Create(Self);
  LbNIFOld.Parent := Body;
  LbNIFOld.SetBounds(25,126,180,22);
  LbNIFOld.Caption := 'NIF/DNI original';

  EdNIFOld := TEdit.Create(Self);
  EdNIFOld.Parent := Body;
  EdNIFOld.SetBounds(25,150,240,30);
  EdNIFOld.ReadOnly := True;
  EdNIFOld.Color := RGBToColor(235,238,241);

  LbNIFNew := TLabel.Create(Self);
  LbNIFNew.Parent := Body;
  LbNIFNew.SetBounds(290,126,200,22);
  LbNIFNew.Caption := 'NIF/DNI correcto';

  EdNIFNew := TEdit.Create(Self);
  EdNIFNew.Parent := Body;
  EdNIFNew.SetBounds(290,150,240,30);
  EdNIFNew.MaxLength := 30;

  LbNameOld := TLabel.Create(Self);
  LbNameOld.Parent := Body;
  LbNameOld.SetBounds(25,194,260,22);
  LbNameOld.Caption := 'Nombre / razón social original';

  EdNameOld := TEdit.Create(Self);
  EdNameOld.Parent := Body;
  EdNameOld.SetBounds(25,218,505,30);
  EdNameOld.ReadOnly := True;
  EdNameOld.Color := RGBToColor(235,238,241);

  LbNameNew := TLabel.Create(Self);
  LbNameNew.Parent := Body;
  LbNameNew.SetBounds(555,194,290,22);
  LbNameNew.Caption := 'Nombre / razón social correcto';

  EdNameNew := TEdit.Create(Self);
  EdNameNew.Parent := Body;
  EdNameNew.SetBounds(555,218,Body.ClientWidth-580,30);
  EdNameNew.Anchors := [akLeft,akTop,akRight];
  EdNameNew.MaxLength := 160;

  LbErrorAEAT := TLabel.Create(Self);
  LbErrorAEAT.Parent := Body;
  LbErrorAEAT.SetBounds(25,267,320,22);
  LbErrorAEAT.Caption := 'Respuesta / error comunicado por AEAT';
  LbErrorAEAT.Font.Style := [fsBold];

  MemoError := TMemo.Create(Self);
  MemoError.Parent := Body;
  MemoError.SetBounds(25,291,Body.ClientWidth-50,105);
  MemoError.Anchors := [akLeft,akTop,akRight];
  MemoError.ReadOnly := True;
  MemoError.ScrollBars := ssAutoVertical;
  MemoError.Color := clWhite;

  LbPayload := TLabel.Create(Self);
  LbPayload.Parent := Body;
  LbPayload.SetBounds(25,412,500,22);
  LbPayload.Caption := 'Vista del JSON corregido (solo lectura)';
  LbPayload.Font.Style := [fsBold];

  MemoPayload := TMemo.Create(Self);
  MemoPayload.Parent := Body;
  MemoPayload.SetBounds(25,436,Body.ClientWidth-50,Body.ClientHeight-455);
  MemoPayload.Anchors := [akLeft,akTop,akRight,akBottom];
  MemoPayload.ReadOnly := True;
  MemoPayload.ScrollBars := ssAutoBoth;
  MemoPayload.WordWrap := False;
  MemoPayload.Color := clWhite;
end;

function TfrmVFSubsanacionEditor.LoadData(out AError: string): Boolean;
var
  Q: TZQuery;
  D: TJSONData;
  Root, Cab: TJSONObject;
  Existing: string;
begin
  Result := False;
  AError := '';
  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'SELECT s.payload_origen,s.payload_corregido,s.estado,' +
      'q.tipo_factura,q.respuesta_text,q.last_error ' +
      'FROM verifactu_subsanaciones s ' +
      'JOIN verifactu_queue q ON q.id=s.queue_id ' +
      'WHERE s.id=:id LIMIT 1';
    Q.ParamCheck := True;
    Q.ParamByName('id').AsLargeInt := FSubID;
    Q.Open;
    if Q.EOF then
    begin
      AError := 'No se localiza la subsanación.';
      Exit;
    end;

    FTipoFactura := UpperCase(Trim(Q.FieldByName('tipo_factura').AsString));
    FOriginalJSON := Q.FieldByName('payload_origen').AsString;
    Existing := Q.FieldByName('payload_corregido').AsString;

    { Siempre partimos del payload ORIGINAL para conservar exactamente la
      representación de los números. Si una revisión anterior guardó un JSON
      corregido reserializado, solo recuperaremos de él los textos corregidos. }
    FWorkingJSON := FOriginalJSON;

    MemoError.Lines.Text :=
      Trim(Q.FieldByName('last_error').AsString + LineEnding +
           Q.FieldByName('respuesta_text').AsString);

    try
      D := GetJSON(FWorkingJSON);
      try
        if not (D is TJSONObject) then
        begin
          AError := 'El payload guardado no es un objeto JSON.';
          Exit;
        end;
        Root := TJSONObject(D);
        Cab := JSONChildObject(Root, 'cabecera');
        if Cab = nil then
        begin
          AError := 'El payload no contiene el bloque "cabecera".';
          Exit;
        end;

        EdNIFOld.Text := JSONStr(Cab, 'nifCliente');
        EdNameOld.Text := JSONStr(Cab, 'nombreCliente');
        FClientCode := JSONStr(Cab, 'codCliente');

        EdNIFNew.Text := EdNIFOld.Text;
        EdNameNew.Text := EdNameOld.Text;

        { Si ya existía una corrección creada con una revisión anterior,
          recuperamos únicamente sus valores de texto, nunca sus números. }
        if Trim(Existing) <> '' then
        begin
          D.Free;
          D := nil;
          D := GetJSON(Existing);
          if D is TJSONObject then
          begin
            Root := TJSONObject(D);
            Cab := JSONChildObject(Root, 'cabecera');
            if Cab <> nil then
            begin
              EdNIFNew.Text := JSONStr(Cab, 'nifCliente');
              EdNameNew.Text := JSONStr(Cab, 'nombreCliente');
            end;
          end;
        end;

        { IMPORTANTE:
          Al ABRIR el editor no llamamos a BuildCorrectedJSON porque esa función
          realiza las validaciones obligatorias del F1. Precisamente esta ventana
          debe poder abrirse cuando falta el NIF para permitir introducirlo.

          Mostramos el JSON ORIGINAL tal cual está almacenado, sin reserializarlo,
          por lo que tampoco se altera la representación decimal ni aparece
          notación científica por culpa de esta pantalla.

          La validación y construcción léxica del JSON corregido se harán
          exclusivamente al pulsar Guardar corrección. }
        MemoPayload.Lines.Text := FWorkingJSON;
      finally
        D.Free;
      end;
    except
      on E: Exception do
      begin
        AError := 'No se puede leer el JSON: ' + E.Message;
        Exit;
      end;
    end;

    Result := True;
  finally
    Q.Free;
  end;
end;

function TfrmVFSubsanacionEditor.BuildCorrectedJSON(out AJSON,
  AError: string): Boolean;
var
  NIFNew, NameNew, Tmp: string;
begin
  Result := False;
  AJSON := '';
  AError := '';

  if RGCase.ItemIndex = 1 then
  begin
    AError :=
      'Ha indicado que la propia factura emitida también contiene datos incorrectos.' +
      LineEnding +
      'Este caso no debe continuar automáticamente como una simple subsanación VeriFactu. ' +
      'Debe revisarse si corresponde anulación/nueva factura o factura rectificativa.';
    Exit;
  end;

  NIFNew := UpperCase(Trim(EdNIFNew.Text));
  NameNew := Trim(EdNameNew.Text);

  if FTipoFactura = 'F1' then
  begin
    if NIFNew = '' then
    begin
      AError := 'Para este F1 debe indicar el NIF/DNI correcto del destinatario.';
      Exit;
    end;
    if NameNew = '' then
    begin
      AError := 'Para este F1 debe indicar el nombre o razón social correctos.';
      Exit;
    end;
  end;

  

  { MUY IMPORTANTE: no reconstruimos el JSON con TJSONObject.FormatJSON.
    Solo sustituimos los dos valores de texto dentro del JSON original para
    conservar byte a byte la representación de importes y demás números. }
  if not VF_JSONSetStringInObject(FWorkingJSON, 'cabecera', 'nifCliente',
    NIFNew, Tmp, AError) then Exit;
  if not VF_JSONSetStringInObject(Tmp, 'cabecera', 'nombreCliente',
    NameNew, AJSON, AError) then Exit;

  if not VF_JSONValidateObject(AJSON, AError) then Exit;
  Result := True;
end;

procedure TfrmVFSubsanacionEditor.OfferUpdateClientNIF(const ANewNIF: string);
var
  Q: TZQuery;
  CurrentNIF, ClientName, Msg: string;
begin
  if (Trim(FClientCode) = '') or (Trim(ANewNIF) = '') then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text := 'SELECT C1,C5 FROM clientes WHERE C0=:c LIMIT 1';
    Q.ParamCheck := True;
    Q.ParamByName('c').AsString := FClientCode;
    Q.Open;
    if Q.EOF then Exit;

    ClientName := Q.FieldByName('C1').AsString;
    CurrentNIF := Trim(Q.FieldByName('C5').AsString);
    if SameText(CurrentNIF, Trim(ANewNIF)) then Exit;

    if CurrentNIF = '' then
      Msg := 'El cliente ' + FClientCode + ' - ' + ClientName +
        ' no tiene NIF/DNI en su ficha.' + LineEnding + LineEnding +
        'Ha indicado ' + Trim(ANewNIF) + ' para esta subsanación.' +
        LineEnding + LineEnding +
        '¿Desea guardarlo también en la ficha del cliente para evitar que vuelva a ocurrir?'
    else
      Msg := 'La ficha del cliente ' + FClientCode + ' - ' + ClientName +
        ' contiene actualmente el NIF/DNI ' + CurrentNIF + '.' +
        LineEnding + 'En la subsanación ha indicado ' + Trim(ANewNIF) + '.' +
        LineEnding + LineEnding +
        '¿Desea actualizar también la ficha del cliente con el nuevo valor?';

    if MessageDlg('Actualizar ficha del cliente', Msg,
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

    Q.Close;
    Q.SQL.Text := 'UPDATE clientes SET C5=:nif WHERE C0=:c';
    Q.ParamByName('nif').AsString := Trim(ANewNIF);
    Q.ParamByName('c').AsString := FClientCode;
    Q.ExecSQL;

    MessageDlg('Ficha del cliente actualizada',
      'Se ha guardado el NIF/DNI ' + Trim(ANewNIF) +
      ' en la ficha del cliente ' + FClientCode + '.',
      mtInformation, [mbOK], 0);
  except
    on E: Exception do
      MessageDlg('No se ha podido actualizar la ficha del cliente',
        E.Message + LineEnding + LineEnding +
        'La corrección VeriFactu sí permanece guardada.',
        mtWarning, [mbOK], 0);
  end;
  Q.Free;
end;

procedure TfrmVFSubsanacionEditor.BtnSaveClick(Sender: TObject);
var
  Corrected, Err: string;
  Q: TZQuery;
begin
  if not BuildCorrectedJSON(Corrected, Err) then
  begin
    MessageDlg('No se puede guardar la corrección', Err,
      mtWarning, [mbOK], 0);
    Exit;
  end;

  if MessageDlg('Guardar corrección',
    'Se guardará una copia corregida para el NUEVO registro de subsanación.' +
    LineEnding + LineEnding +
    'El registro original y la factura original permanecerán inalterados.' +
    LineEnding + LineEnding + '¿Continuar?',
    mtConfirmation, [mbYes,mbNo], 0) <> mrYes then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := FConn;
    Q.SQL.Text :=
      'UPDATE verifactu_subsanaciones SET ' +
      'payload_corregido=:p,corrected_nif=:cnif,corrected_name=:cname,' +
      'correction_notes=:n,corrected_at=NOW(),' +
      'estado=''DATOS_CORREGIDOS'',updated_at=NOW() WHERE id=:id';
    Q.ParamCheck := True;
    Q.ParamByName('p').AsString := Corrected;
    Q.ParamByName('cnif').AsString := UpperCase(Trim(EdNIFNew.Text));
    Q.ParamByName('cname').AsString := Trim(EdNameNew.Text);
    Q.ParamByName('n').AsString :=
      'Corrección de destinatario: NIF/identificación y nombre/razón social.';
    Q.ParamByName('id').AsLargeInt := FSubID;
    Q.ExecSQL;

    FWorkingJSON := Corrected;
    MemoPayload.Lines.Text := Corrected;

    { Si el NIF/DNI se ha corregido, ofrecer mantener también la ficha maestra. }
    if not SameText(Trim(EdNIFOld.Text), Trim(EdNIFNew.Text)) then
      OfferUpdateClientNIF(UpperCase(Trim(EdNIFNew.Text)));

    Saved := True;
    ModalResult := mrOK;
  finally
    Q.Free;
  end;
end;

procedure TfrmVFSubsanacionEditor.BtnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmVFSubsanacionEditor.FormKeyDownHandler(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    ModalResult := mrCancel;
  end;
end;

end.
