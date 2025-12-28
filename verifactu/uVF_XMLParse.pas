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
    CSV: string;
  end;

function VF_ParseResponseXML(const XMLText: string): TVFResponse;

implementation

function VF_GetNodeValue(ANode: TDOMNode; const AName: string): string;
var
  I: Integer;
  Child: TDOMNode;
begin
  Result := '';
  if ANode = nil then Exit;
  for I := 0 to ANode.ChildNodes.Count - 1 do
  begin
    Child := ANode.ChildNodes.Item[I];
    if SameText(Child.NodeName, AName) then
    begin
      Result := UTF8Encode(Child.TextContent);
      Exit;
    end;
  end;
end;

function VF_ParseResponseXML(const XMLText: string): TVFResponse;
var
  Doc: TXMLDocument;
  Root, Node: TDOMNode;
begin
  Result.CodigoError := '';
  Result.DescripcionError := '';
  Result.EstadoEnvio := '';
  Result.CSV := '';

  if Trim(XMLText) = '' then Exit;

  try
    ReadXMLFile(Doc, TStringStream.Create(XMLText));
    Root := Doc.DocumentElement;

    if Root = nil then Exit;

    // Localizar nodo <Respuesta>
    Node := Root.FindNode('Respuesta');
    if Node = nil then
      Node := Root.FindNode('ns2:Respuesta'); // fallback

    if Node <> nil then
    begin
      Result.CodigoError := VF_GetNodeValue(Node, 'CodigoErrorRegistro');
      Result.DescripcionError := VF_GetNodeValue(Node, 'DescripcionErrorRegistro');
      Result.EstadoEnvio := VF_GetNodeValue(Node, 'EstadoEnvio');
      Result.CSV := VF_GetNodeValue(Node, 'CSV');
    end;

  finally
    if Assigned(Doc) then Doc.Free;
  end;
end;

end.
