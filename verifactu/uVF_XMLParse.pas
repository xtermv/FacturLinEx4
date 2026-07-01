unit uVF_XMLParse;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DOM, XMLRead;

type
  TVFResponse = record
    CodigoError: string;
    DescripcionError: string;
    EstadoEnvio: string;
    EstadoRegistro: string;
    CSV: string;
  end;

function VF_ParseResponseXML(const XMLText: string): TVFResponse;

implementation

function VF_LocalName(const AName: string): string;
var
  P: Integer;
begin
  P := Pos(':', AName);
  if P > 0 then
    Result := Copy(AName, P + 1, MaxInt)
  else
    Result := AName;
end;

function VF_FindTextByLocalName(ANode: TDOMNode; const AName: string): string;
var
  I: Integer;
  Child: TDOMNode;
begin
  Result := '';
  if ANode = nil then
    Exit;

  if SameText(VF_LocalName(ANode.NodeName), AName) then
  begin
    Result := UTF8Encode(ANode.TextContent);
    Exit;
  end;

  for I := 0 to ANode.ChildNodes.Count - 1 do
  begin
    Child := ANode.ChildNodes.Item[I];
    Result := VF_FindTextByLocalName(Child, AName);
    if Result <> '' then
      Exit;
  end;
end;

function VF_ParseResponseXML(const XMLText: string): TVFResponse;
var
  Doc: TXMLDocument;
  SS: TStringStream;
begin
  Result.CodigoError := '';
  Result.DescripcionError := '';
  Result.EstadoEnvio := '';
  Result.EstadoRegistro := '';
  Result.CSV := '';

  if Trim(XMLText) = '' then
    Exit;

  Doc := nil;
  SS := TStringStream.Create(XMLText);
  try
    try
      ReadXMLFile(Doc, SS);
      if (Doc = nil) or (Doc.DocumentElement = nil) then
        Exit;

      // Búsqueda recursiva por nombre local, ignorando prefijos tikR:, tik:, sum1:, etc.
      Result.CSV := VF_FindTextByLocalName(Doc.DocumentElement, 'CSV');
      Result.EstadoEnvio := VF_FindTextByLocalName(Doc.DocumentElement, 'EstadoEnvio');
      Result.EstadoRegistro := VF_FindTextByLocalName(Doc.DocumentElement, 'EstadoRegistro');
      Result.CodigoError := VF_FindTextByLocalName(Doc.DocumentElement, 'CodigoErrorRegistro');
      Result.DescripcionError := VF_FindTextByLocalName(Doc.DocumentElement, 'DescripcionErrorRegistro');
    except
      // Si AEAT devuelve HTML o XML incompleto, dejamos los campos vacíos
      // y el dispatcher conservará la respuesta completa en last_error/respuesta_text.
    end;
  finally
    SS.Free;
    if Assigned(Doc) then
      Doc.Free;
  end;
end;

end.
