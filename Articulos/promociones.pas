{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2010,  Nicolas Lopez de Lerma Aymerich

  PuntoDev GNU S.L. <info@puntodev.com>

  Collaborators:
                 F.Javier Pérez Vidal
                 Jaime Alvarez Ares.

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
unit promociones;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, DBGrids, Buttons, EditBtn, ZConnection, ZDataset,
  LCLType, Grids, Math
  {$IFDEF LCLGTK2}
  , gtk2, gdk2
  {$ENDIF}
  ;

type

  { TfPromociones }

  TfPromociones = class(TForm)
    btnActualizar: TBitBtn;
    btnBuscar: TBitBtn;
    btnCancelar: TBitBtn;
    btnAceptar: TBitBtn;
    btnCrear: TBitBtn;
    btnBorrar: TBitBtn;
    btnModificar: TBitBtn;
    btnCerrar: TBitBtn;
    dsPromo: TDatasource;
    dbgDatos: TDBGrid;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit2: TEdit;
    Edit3: TDateEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TDateEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    rgFiltro: TRadioGroup;
    dbPromo: TZQuery;
    dbArti: TZQuery;
    dbTrabajo: TZQuery;
    procedure ActualizarPromociones;
    procedure btnActualizarClick(Sender: TObject);
    procedure btnImportarXLSXClick(Sender: TObject);
    procedure btnAceptarClick(Sender: TObject);
    procedure btnBorrarClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnCerrarClick(Sender: TObject);
    procedure btnCrearClick(Sender: TObject);
    procedure btnModificarClick(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CabeceraPanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CabeceraPanelMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure CabeceraPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure dbgDatosDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgDatosTitleClick(Column: TColumn);
    procedure rgFiltroClick(Sender: TObject);
    procedure ActivarPanel;
    procedure DesactivarPanel;
    procedure LimpiaPanel();
    procedure LlenaReg();
    procedure Relleno();
  private
    { private declarations }
    Operacion: char;        //   A = Alta / M = Modificación
    btnImportarXLSX: TBitBtn;
    chkSegundaUnd50: TCheckBox;
    lblInfoSegundaUnd: TLabel;
    FOldPromoArt: string;
    FOldPromoIni: string;
    FOldPromoFin: string;
    FOldPromoWasSegunda: Boolean;
    FHeaderPanel: TPanel;
    FHeaderTitle: TLabel;
    FHeaderSubtitle: TLabel;
    FStatusLabel: TLabel;
    FSortField: string;
    FSortAsc: Boolean;
    FMoviendoPanel: Boolean;
    FPanelMovidoPorUsuario: Boolean;
    FPanelDragOffset: TPoint;
    procedure AplicarEstiloModerno;
    procedure AplicarContrasteSeleccion(AEditControl: TWinControl);
    procedure AplicarContrasteSeleccionControles(AParent: TWinControl);
    procedure ActualizarEstado;
    procedure ConfigurarBoton(ABoton: TBitBtn; const ACaption, AHint: string;
      AColor: TColor);
    procedure MarcarColumnaOrdenada(Column: TColumn);
    procedure LimitarPanelAlAreaVisible;
    procedure RecolocarControles;
    function ResolverCodigoArticulo(const ACodigo: string): string;
    procedure ImportarPromocionesDesdeXLSX(const AFichero: string);
    function BuscarArticuloDesdeDocumento(const ACodigo, AEan: string; out AArticulo, ADescripcion: string; out APvpFicha, ACosteFicha, AIvaFicha: Double): Boolean;
    function PedirPrecioPromoLinea(const AArticulo, ADescripcion, ACodigoDoc, AEanDoc: string; const APvpFicha: Double; out APvpPromo: Double; out ASegundaUnd50: Boolean): Boolean;
    procedure GuardarPromocionDirecta(const AArticulo, ADescripcion: string; const AIni, AFin: TDateTime; const APvpPromo, APvpFicha, ACosteFicha, AIvaFicha: Double; const ASegundaUnd50: Boolean);
    procedure PromoModeChanged(Sender: TObject);
    procedure EnsurePromoRulesTable;
    function HasSegundaUnidadRule(const AArticulo, AIniDB, AFinDB: string): Boolean;
    procedure DeleteSegundaUnidadRule(const AArticulo, AIniDB, AFinDB: string);
    procedure SaveSegundaUnidadRule(const AArticulo, ADescripcion, AIniDB, AFinDB: string);
  public
    { public declarations }
  end; 

procedure ShowFormPromociones;

var
  fPromociones: TfPromociones;

implementation

uses
  global, funciones, busquedas, StrUtils, Zipper, DOM, XMLRead;

type
  TXLSXRow = array of string;
  TXLSXTable = array of TXLSXRow;
  TXLSXSharedStrings = array of string;

function FLX_EsFicheroXLSX(const AFichero: string): Boolean;
begin
  Result := LowerCase(ExtractFileExt(AFichero)) = '.xlsx';
end;

function FLX_NormalizaRutaXLSX(const S: string): string;
begin
  Result := StringReplace(S, '\', '/', [rfReplaceAll]);
  while Pos('//', Result) > 0 do
    Result := StringReplace(Result, '//', '/', [rfReplaceAll]);
end;

function FLX_Atributo(const Nodo: TDOMNode; const Nombre: string): string;
var
  I: Integer;
  Attr: TDOMNode;
  Nom: string;
begin
  Result := '';
  if (Nodo = nil) or (Nodo.Attributes = nil) then Exit;

  for I := 0 to Nodo.Attributes.Length - 1 do
  begin
    Attr := Nodo.Attributes.Item[I];
    Nom := Attr.NodeName;
    if SameText(Nom, Nombre) or SameText(Copy(Nom, Pos(':', Nom) + 1, MaxInt), Nombre) then
    begin
      Result := Attr.NodeValue;
      Exit;
    end;
  end;
end;

function FLX_NombreNodoSimple(const Nodo: TDOMNode): string;
var
  P: Integer;
begin
  Result := '';
  if Nodo = nil then Exit;
  Result := Nodo.NodeName;
  P := Pos(':', Result);
  if P > 0 then
    Result := Copy(Result, P + 1, MaxInt);
end;

function FLX_NodoEs(const Nodo: TDOMNode; const Nombre: string): Boolean;
begin
  Result := SameText(FLX_NombreNodoSimple(Nodo), Nombre);
end;

function FLX_HijoPorNombre(const Nodo: TDOMNode; const Nombre: string): TDOMNode;
var
  Hijo: TDOMNode;
begin
  Result := nil;
  if Nodo = nil then Exit;

  Hijo := Nodo.FirstChild;
  while Hijo <> nil do
  begin
    if FLX_NodoEs(Hijo, Nombre) then
    begin
      Result := Hijo;
      Exit;
    end;
    Hijo := Hijo.NextSibling;
  end;
end;

function FLX_TextoRecursivo(const Nodo: TDOMNode): string;
var
  Hijo: TDOMNode;
begin
  Result := '';
  if Nodo = nil then Exit;

  if (Nodo.NodeType = TEXT_NODE) or (Nodo.NodeType = CDATA_SECTION_NODE) then
    Result := Nodo.NodeValue;

  Hijo := Nodo.FirstChild;
  while Hijo <> nil do
  begin
    Result := Result + FLX_TextoRecursivo(Hijo);
    Hijo := Hijo.NextSibling;
  end;
end;

function FLX_TextoHijo(const Nodo: TDOMNode; const Nombre: string): string;
var
  Hijo: TDOMNode;
begin
  Result := '';
  Hijo := FLX_HijoPorNombre(Nodo, Nombre);
  if Hijo <> nil then
    Result := FLX_TextoRecursivo(Hijo);
end;

function FLX_QuitarCerosIzquierdaSeguro(const S: string): string;
begin
  Result := Trim(S);
  while (Length(Result) > 1) and (Result[1] = '0') do
    Delete(Result, 1, 1);
end;

function FLX_NormalizaCabeceraExcel(const S: string): string;
begin
  Result := LowerCase(Trim(S));
  Result := StringReplace(Result, 'á', 'a', [rfReplaceAll]);
  Result := StringReplace(Result, 'é', 'e', [rfReplaceAll]);
  Result := StringReplace(Result, 'í', 'i', [rfReplaceAll]);
  Result := StringReplace(Result, 'ó', 'o', [rfReplaceAll]);
  Result := StringReplace(Result, 'ú', 'u', [rfReplaceAll]);
  Result := StringReplace(Result, 'à', 'a', [rfReplaceAll]);
  Result := StringReplace(Result, 'è', 'e', [rfReplaceAll]);
  Result := StringReplace(Result, 'ì', 'i', [rfReplaceAll]);
  Result := StringReplace(Result, 'ò', 'o', [rfReplaceAll]);
  Result := StringReplace(Result, 'ù', 'u', [rfReplaceAll]);
  Result := StringReplace(Result, 'ü', 'u', [rfReplaceAll]);
  Result := StringReplace(Result, 'ñ', 'n', [rfReplaceAll]);
  Result := StringReplace(Result, '.', '', [rfReplaceAll]);
  Result := StringReplace(Result, '-', '', [rfReplaceAll]);
  Result := StringReplace(Result, '_', '', [rfReplaceAll]);
  Result := StringReplace(Result, '/', '', [rfReplaceAll]);
  Result := StringReplace(Result, '%', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' ', '', [rfReplaceAll]);
end;

function FLX_NormalizaTextoExcel(const S: string): string;
begin
  Result := Trim(S);
  Result := StringReplace(Result, #9, ' ', [rfReplaceAll]);
  while Pos('  ', Result) > 0 do
    Result := StringReplace(Result, '  ', ' ', [rfReplaceAll]);
end;

function FLX_NormalizaCodigoExcel(const S: string; const AQuitarCerosIzquierda: Boolean): string;
var
  P: Integer;
  Decs: string;
begin
  Result := Trim(S);
  Result := StringReplace(Result, ' ', '', [rfReplaceAll]);
  Result := StringReplace(Result, #160, '', [rfReplaceAll]);

  // En Excel algunos códigos pueden salir como 1234.0000.
  // Sólo quitamos la parte decimal si son todo ceros.
  P := LastDelimiter('.,', Result);
  if P > 0 then
  begin
    Decs := Copy(Result, P + 1, MaxInt);
    if (Decs <> '') and (StringReplace(Decs, '0', '', [rfReplaceAll]) = '') then
      Delete(Result, P, MaxInt);
  end;

  if AQuitarCerosIzquierda then
    Result := FLX_QuitarCerosIzquierdaSeguro(Result);
end;

function FLX_NormalizaNumeroExcel(const S: string): string;
var
  Sep: Char;
  PComa, PPunto: Integer;
begin
  Result := Trim(S);
  Result := StringReplace(Result, ' ', '', [rfReplaceAll]);
  Result := StringReplace(Result, #160, '', [rfReplaceAll]);
  Result := StringReplace(Result, '€', '', [rfReplaceAll]);
  if Result = '' then Exit;

  Sep := DefaultFormatSettings.DecimalSeparator;
  PComa := LastDelimiter(',', Result);
  PPunto := LastDelimiter('.', Result);

  if (PComa > 0) and (PPunto > 0) then
  begin
    if PComa > PPunto then
    begin
      Result := StringReplace(Result, '.', '', [rfReplaceAll]);
      Result := StringReplace(Result, ',', Sep, [rfReplaceAll]);
    end
    else
    begin
      Result := StringReplace(Result, ',', '', [rfReplaceAll]);
      Result := StringReplace(Result, '.', Sep, [rfReplaceAll]);
    end;
  end
  else if PComa > 0 then
    Result := StringReplace(Result, ',', Sep, [rfReplaceAll])
  else if PPunto > 0 then
    Result := StringReplace(Result, '.', Sep, [rfReplaceAll]);
end;

function FLX_StrToFloatPromo(const S: string; out V: Double): Boolean;
var
  T: string;
  FS: TFormatSettings;
begin
  T := FLX_NormalizaNumeroExcel(S);
  Result := TryStrToFloat(T, V);
  if Result then Exit;

  FS := DefaultFormatSettings;
  FS.DecimalSeparator := '.';
  T := StringReplace(Trim(S), '€', '', [rfReplaceAll]);
  T := StringReplace(T, ' ', '', [rfReplaceAll]);
  T := StringReplace(T, ',', '.', [rfReplaceAll]);
  Result := TryStrToFloat(T, V, FS);
end;

function FLX_ColumnaDesdeReferenciaCelda(const Ref: string): Integer;
var
  I: Integer;
  C: Char;
begin
  Result := 0;
  for I := 1 to Length(Ref) do
  begin
    C := UpCase(Ref[I]);
    if not (C in ['A'..'Z']) then Break;
    Result := (Result * 26) + (Ord(C) - Ord('A') + 1);
  end;
  Dec(Result); // 0-based
  if Result < 0 then Result := 0;
end;

function FLX_DirTemporalXLSX: string;
var
  Base: string;
begin
  Base := GetEnvironmentVariable('TMPDIR');
  if Base = '' then Base := '/tmp';
  Result := IncludeTrailingPathDelimiter(Base) +
            'flx_promo_xlsx_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '_' + IntToStr(Random(1000000));
  ForceDirectories(Result);
end;

procedure FLX_DescomprimirXLSX(const AFichero, ADir: string);
var
  UnZipper: TUnZipper;
begin
  UnZipper := TUnZipper.Create;
  try
    UnZipper.FileName := AFichero;
    UnZipper.OutputPath := IncludeTrailingPathDelimiter(ADir);
    UnZipper.UnZipAllFiles;
  finally
    UnZipper.Free;
  end;
end;

function FLX_PrimeraHojaXLSX(const ADir: string): string;
var
  Doc, Rels: TXMLDocument;
  Sheets, Sheet, Rel: TDOMNode;
  RelId, Target, Id: string;
  WorkbookFile, RelsFile: string;
begin
  Result := 'xl/worksheets/sheet1.xml';
  WorkbookFile := IncludeTrailingPathDelimiter(ADir) + 'xl/workbook.xml';
  RelsFile := IncludeTrailingPathDelimiter(ADir) + 'xl/_rels/workbook.xml.rels';

  if (not FileExists(WorkbookFile)) or (not FileExists(RelsFile)) then Exit;

  Doc := nil;
  Rels := nil;
  try
    ReadXMLFile(Doc, WorkbookFile);
    Sheets := FLX_HijoPorNombre(Doc.DocumentElement, 'sheets');
    if Sheets = nil then Exit;

    Sheet := Sheets.FirstChild;
    while (Sheet <> nil) and (not FLX_NodoEs(Sheet, 'sheet')) do
      Sheet := Sheet.NextSibling;
    if Sheet = nil then Exit;

    RelId := FLX_Atributo(Sheet, 'id');
    if RelId = '' then Exit;

    ReadXMLFile(Rels, RelsFile);
    Rel := Rels.DocumentElement.FirstChild;
    while Rel <> nil do
    begin
      if FLX_NodoEs(Rel, 'Relationship') then
      begin
        Id := FLX_Atributo(Rel, 'Id');
        if Id = RelId then
        begin
          Target := FLX_Atributo(Rel, 'Target');
          if Target <> '' then
          begin
            if Pos('/', Target) = 1 then
              Result := Copy(Target, 2, MaxInt)
            else if Pos('xl/', Target) = 1 then
              Result := Target
            else
              Result := 'xl/' + Target;
            Result := FLX_NormalizaRutaXLSX(Result);
            Exit;
          end;
        end;
      end;
      Rel := Rel.NextSibling;
    end;
  finally
    if Rels <> nil then Rels.Free;
    if Doc <> nil then Doc.Free;
  end;
end;

procedure FLX_CargarSharedStrings(const ADir: string; var AShared: TXLSXSharedStrings);
var
  Doc: TXMLDocument;
  NodoSI: TDOMNode;
  Fichero: string;
  N: Integer;
begin
  SetLength(AShared, 0);
  Fichero := IncludeTrailingPathDelimiter(ADir) + 'xl/sharedStrings.xml';
  if not FileExists(Fichero) then Exit;

  Doc := nil;
  try
    ReadXMLFile(Doc, Fichero);
    NodoSI := Doc.DocumentElement.FirstChild;
    while NodoSI <> nil do
    begin
      if FLX_NodoEs(NodoSI, 'si') then
      begin
        N := Length(AShared);
        SetLength(AShared, N + 1);
        AShared[N] := FLX_TextoRecursivo(NodoSI);
      end;
      NodoSI := NodoSI.NextSibling;
    end;
  finally
    if Doc <> nil then Doc.Free;
  end;
end;

function FLX_ValorCeldaXLSX(const Celda: TDOMNode; const AShared: TXLSXSharedStrings): string;
var
  Tipo, V: string;
  Idx: Integer;
  NodoIS: TDOMNode;
begin
  Result := '';
  if Celda = nil then Exit;

  Tipo := LowerCase(FLX_Atributo(Celda, 't'));

  if Tipo = 's' then
  begin
    V := Trim(FLX_TextoHijo(Celda, 'v'));
    Idx := StrToIntDef(V, -1);
    if (Idx >= 0) and (Idx < Length(AShared)) then
      Result := AShared[Idx];
    Exit;
  end;

  if Tipo = 'inlinestr' then
  begin
    NodoIS := FLX_HijoPorNombre(Celda, 'is');
    Result := FLX_TextoRecursivo(NodoIS);
    Exit;
  end;

  Result := FLX_TextoHijo(Celda, 'v');
end;

procedure FLX_CargarHojaXLSX(const ADir, AHojaRelativa: string;
  const AShared: TXLSXSharedStrings; var ATabla: TXLSXTable);
var
  Doc: TXMLDocument;
  SheetData, RowNode, CellNode: TDOMNode;
  Fichero, Ref: string;
  RowIdx, ColIdx, UltCol: Integer;
  Valor: string;
begin
  SetLength(ATabla, 0);
  Fichero := IncludeTrailingPathDelimiter(ADir) + StringReplace(AHojaRelativa, '/', PathDelim, [rfReplaceAll]);
  if not FileExists(Fichero) then
    raise Exception.Create('No se encuentra la hoja interna del XLSX: ' + AHojaRelativa);

  Doc := nil;
  try
    ReadXMLFile(Doc, Fichero);
    SheetData := FLX_HijoPorNombre(Doc.DocumentElement, 'sheetData');
    if SheetData = nil then Exit;

    RowNode := SheetData.FirstChild;
    while RowNode <> nil do
    begin
      if FLX_NodoEs(RowNode, 'row') then
      begin
        RowIdx := StrToIntDef(FLX_Atributo(RowNode, 'r'), 0) - 1;
        if RowIdx < 0 then RowIdx := Length(ATabla);
        if Length(ATabla) <= RowIdx then
          SetLength(ATabla, RowIdx + 1);

        UltCol := -1;
        CellNode := RowNode.FirstChild;
        while CellNode <> nil do
        begin
          if FLX_NodoEs(CellNode, 'c') then
          begin
            Ref := FLX_Atributo(CellNode, 'r');
            if Ref <> '' then
              ColIdx := FLX_ColumnaDesdeReferenciaCelda(Ref)
            else
              ColIdx := UltCol + 1;
            UltCol := ColIdx;

            if Length(ATabla[RowIdx]) <= ColIdx then
              SetLength(ATabla[RowIdx], ColIdx + 1);

            Valor := FLX_ValorCeldaXLSX(CellNode, AShared);
            ATabla[RowIdx][ColIdx] := Valor;
          end;
          CellNode := CellNode.NextSibling;
        end;
      end;
      RowNode := RowNode.NextSibling;
    end;
  finally
    if Doc <> nil then Doc.Free;
  end;
end;

function FLX_CeldaTabla(const ATabla: TXLSXTable; const Fila, Col: Integer): string;
begin
  Result := '';
  if (Fila < 0) or (Fila >= Length(ATabla)) then Exit;
  if (Col < 0) or (Col >= Length(ATabla[Fila])) then Exit;
  Result := ATabla[Fila][Col];
end;

function FLX_UltimaColumnaFila(const AFila: TXLSXRow): Integer;
begin
  Result := Length(AFila) - 1;
end;

function FLX_BuscarColumnaExcelEnFila(const AFila: TXLSXRow; const ANombres: array of string): Integer;
var
  C, I: Integer;
  Cab, Nom: string;
begin
  Result := -1;
  for C := 0 to FLX_UltimaColumnaFila(AFila) do
  begin
    Cab := FLX_NormalizaCabeceraExcel(AFila[C]);
    for I := Low(ANombres) to High(ANombres) do
    begin
      Nom := FLX_NormalizaCabeceraExcel(ANombres[I]);
      if Cab = Nom then
      begin
        Result := C;
        Exit;
      end;
    end;
  end;
end;

function FLX_BuscarFilaCabeceraExcel(const ATabla: TXLSXTable): Integer;
var
  R, MaxFila: Integer;
  ColCod, ColEAN, ColDes: Integer;
begin
  Result := -1;
  MaxFila := Length(ATabla) - 1;
  if MaxFila > 20 then MaxFila := 20;

  for R := 0 to MaxFila do
  begin
    ColCod := FLX_BuscarColumnaExcelEnFila(ATabla[R], ['Artículo', 'Articulo', 'Código', 'Codigo', 'Referencia']);
    ColEAN := FLX_BuscarColumnaExcelEnFila(ATabla[R], ['Ean', 'EAN', 'Código EAN', 'Codigo EAN', 'Código de barras', 'Codigo de barras']);
    ColDes := FLX_BuscarColumnaExcelEnFila(ATabla[R], ['Descripción', 'Descripcion', 'Nombre', 'Artículo descripción', 'Articulo descripcion']);

    if ((ColCod >= 0) or (ColEAN >= 0)) and (ColDes >= 0) then
    begin
      Result := R;
      Exit;
    end;
  end;
end;

function FLX_TryStrToDatePromoLocal(const S: string; out D: TDateTime): Boolean;
var
  FS: TFormatSettings;
  Y, M, Day: Integer;
  T: string;
begin
  Result := False;
  D := 0;
  T := Trim(S);
  if T = '' then Exit;

  FS := DefaultFormatSettings;
  if TryStrToDate(T, D, FS) then Exit(True);

  FS.DateSeparator := '/';
  FS.ShortDateFormat := 'dd/mm/yyyy';
  if TryStrToDate(T, D, FS) then Exit(True);

  FS.DateSeparator := '-';
  FS.ShortDateFormat := 'dd-mm-yyyy';
  if TryStrToDate(T, D, FS) then Exit(True);

  if (Length(T) >= 10) and (T[5] = '-') and (T[8] = '-') then
  begin
    try
      Y := StrToInt(Copy(T, 1, 4));
      M := StrToInt(Copy(T, 6, 2));
      Day := StrToInt(Copy(T, 9, 2));
      D := EncodeDate(Y, M, Day);
      Exit(True);
    except
      Exit(False);
    end;
  end;
end;

function FLX_PreguntarFechaPromo(const APrompt: string; const ADefault: TDateTime; out AFecha: TDateTime): Boolean;
var
  S: string;
begin
  S := FormatDateTime('dd/mm/yyyy', ADefault);
  Result := InputQuery('Importar promociones', APrompt, S);
  if not Result then Exit;

  if not FLX_TryStrToDatePromoLocal(S, AFecha) then
  begin
    ShowMessage('Fecha no válida: ' + S);
    Result := False;
  end
  else
    AFecha := Trunc(AFecha);
end;


  
function TfPromociones.ResolverCodigoArticulo(const ACodigo: string): string;
var
  Q: TZQuery;
  C: string;
begin
  C := Trim(ACodigo);
  Result := C;
  if C = '' then Exit;

  Q := TZQuery.Create(nil);
  try
    Q.Connection := dbPromo.Connection;

    try
      Q.SQL.Text := 'SELECT A0 FROM artitien' + Tienda + ' WHERE A0=:c LIMIT 1';
      Q.ParamByName('c').AsString := C;
      Q.Open;
      if not Q.EOF then Exit(C);
    except
      Q.Close;
    end;

    Q.Close;

    try
      Q.SQL.Text := 'SELECT EAN1 FROM eans WHERE EAN0=:c LIMIT 1';
      Q.ParamByName('c').AsString := C;
      Q.Open;
      if not Q.EOF then
        Result := Trim(Q.FieldByName('EAN1').AsString)
      else
        Result := C;
    except
      Result := C;
    end;
  finally
    Q.Free;
  end;
end;


procedure TfPromociones.btnImportarXLSXClick(Sender: TObject);
var
  Dlg: TOpenDialog;
  Fichero: string;
begin
  Dlg := TOpenDialog.Create(Self);
  try
    Dlg.Title := 'Importar documento XLSX para promociones';
    Dlg.InitialDir := ExtractFilePath(ParamStr(0));
    Dlg.Filter := 'Excel XLSX (*.xlsx)|*.xlsx|Todos los ficheros (*.*)|*.*';
    if not Dlg.Execute then Exit;
    Fichero := Dlg.FileName;
  finally
    Dlg.Free;
  end;

  ImportarPromocionesDesdeXLSX(Fichero);
end;

function TfPromociones.BuscarArticuloDesdeDocumento(const ACodigo, AEan: string;
  out AArticulo, ADescripcion: string; out APvpFicha, ACosteFicha, AIvaFicha: Double): Boolean;

  function CargarArticuloPorCodigo(const ACod: string): Boolean;
  begin
    Result := False;
    if Trim(ACod) = '' then Exit;

    dbTrabajo.Active := False;
    dbTrabajo.SQL.Clear;
    dbTrabajo.SQL.Text :=
      'SELECT A0, A1, A2, A24, A3 FROM artitien' + Tienda +
      ' WHERE A0=:cod LIMIT 1';
    dbTrabajo.ParamByName('cod').AsString := Trim(ACod);
    try
      dbTrabajo.Active := True;
      if not dbTrabajo.EOF then
      begin
        AArticulo := Trim(dbTrabajo.FieldByName('A0').AsString);
        ADescripcion := dbTrabajo.FieldByName('A1').AsString;
        APvpFicha := dbTrabajo.FieldByName('A2').AsFloat;
        ACosteFicha := dbTrabajo.FieldByName('A24').AsFloat;
        AIvaFicha := dbTrabajo.FieldByName('A3').AsFloat;
        Result := True;
      end;
    except
      Result := False;
    end;
  end;

var
  CodPrincipal: string;
begin
  Result := False;
  AArticulo := '';
  ADescripcion := '';
  APvpFicha := 0;
  ACosteFicha := 0;
  AIvaFicha := 0;

  // 1) Código del documento contra código principal de la ficha.
  if CargarArticuloPorCodigo(ACodigo) then Exit(True);

  // 2) EAN del documento por si coincide directamente con A0.
  if CargarArticuloPorCodigo(AEan) then Exit(True);

  // 3) EAN auxiliar: eans.EAN0 -> eans.EAN1 -> artitienXXXX.A0.
  if Trim(AEan) <> '' then
  begin
    dbTrabajo.Active := False;
    dbTrabajo.SQL.Clear;
    dbTrabajo.SQL.Text := 'SELECT EAN1 FROM eans WHERE EAN0=:ean LIMIT 1';
    dbTrabajo.ParamByName('ean').AsString := Trim(AEan);
    try
      dbTrabajo.Active := True;
      if not dbTrabajo.EOF then
      begin
        CodPrincipal := Trim(dbTrabajo.FieldByName('EAN1').AsString);
        if CargarArticuloPorCodigo(CodPrincipal) then Exit(True);
      end;
    except
      // Si la tabla eans no existiera o fallara, simplemente se ignora esta vía.
    end;
  end;

  // 4) Código del proveedor por si también está dado de alta como EAN auxiliar.
  if Trim(ACodigo) <> '' then
  begin
    dbTrabajo.Active := False;
    dbTrabajo.SQL.Clear;
    dbTrabajo.SQL.Text := 'SELECT EAN1 FROM eans WHERE EAN0=:ean LIMIT 1';
    dbTrabajo.ParamByName('ean').AsString := Trim(ACodigo);
    try
      dbTrabajo.Active := True;
      if not dbTrabajo.EOF then
      begin
        CodPrincipal := Trim(dbTrabajo.FieldByName('EAN1').AsString);
        if CargarArticuloPorCodigo(CodPrincipal) then Exit(True);
      end;
    except
    end;
  end;
end;

function TfPromociones.PedirPrecioPromoLinea(const AArticulo, ADescripcion, ACodigoDoc,
  AEanDoc: string; const APvpFicha: Double; out APvpPromo: Double;
  out ASegundaUnd50: Boolean): Boolean;
var
  F: TForm;
  LInfo, LPrecio: TLabel;
  EPrecio: TEdit;
  CkSegunda: TCheckBox;
  BOk, BCancel: TButton;
  S: string;
  CheckedDefault: Boolean;
  Modal: Integer;
begin
  Result := False;
  APvpPromo := 0;
  ASegundaUnd50 := False;
  S := FormatFloat('0.00', APvpFicha);
  CheckedDefault := False;

  while True do
  begin
    F := TForm.Create(Self);
    try
      F.Caption := 'Precio de promoción';
      F.BorderStyle := bsDialog;
      F.Position := poScreenCenter;
      F.Width := 590;
      F.Height := 255;

      LInfo := TLabel.Create(F);
      LInfo.Parent := F;
      LInfo.Left := 12;
      LInfo.Top := 12;
      LInfo.Width := F.ClientWidth - 24;
      LInfo.Height := 92;
      LInfo.AutoSize := False;
      LInfo.WordWrap := True;
      LInfo.Caption :=
        'Artículo: ' + AArticulo + LineEnding +
        'Descripción: ' + ADescripcion + LineEnding +
        'Código doc.: ' + ACodigoDoc + LineEnding +
        'EAN doc.: ' + AEanDoc + LineEnding +
        'PVP ficha actual: ' + FormatFloat('0.00', APvpFicha);

      LPrecio := TLabel.Create(F);
      LPrecio.Parent := F;
      LPrecio.Left := 12;
      LPrecio.Top := 112;
      LPrecio.Caption := 'PVP promoción con IVA:';

      EPrecio := TEdit.Create(F);
      EPrecio.Parent := F;
      EPrecio.Left := 170;
      EPrecio.Top := 108;
      EPrecio.Width := 100;
      EPrecio.Text := S;
      EPrecio.SelectAll;

      CkSegunda := TCheckBox.Create(F);
      CkSegunda.Parent := F;
      CkSegunda.Left := 12;
      CkSegunda.Top := 145;
      CkSegunda.Width := F.ClientWidth - 24;
      CkSegunda.Caption := 'Activar también 2ª unidad al 50%';
      CkSegunda.Checked := CheckedDefault;

      BOk := TButton.Create(F);
      BOk.Parent := F;
      BOk.Caption := 'Aceptar';
      BOk.Left := F.ClientWidth - 190;
      BOk.Top := F.ClientHeight - 42;
      BOk.Width := 82;
      BOk.Height := 28;
      BOk.Default := True;
      BOk.ModalResult := mrOk;

      BCancel := TButton.Create(F);
      BCancel.Parent := F;
      BCancel.Caption := 'Cancelar';
      BCancel.Left := F.ClientWidth - 100;
      BCancel.Top := F.ClientHeight - 42;
      BCancel.Width := 82;
      BCancel.Height := 28;
      BCancel.Cancel := True;
      BCancel.ModalResult := mrCancel;

      F.ActiveControl := EPrecio;
      Modal := F.ShowModal;
      if Modal <> mrOk then
        Exit(False);

      S := EPrecio.Text;
      CheckedDefault := CkSegunda.Checked;
      ASegundaUnd50 := CheckedDefault;
    finally
      F.Free;
    end;

    if FLX_StrToFloatPromo(S, APvpPromo) and (APvpPromo > 0) then
      Exit(True);

    ShowMessage('Precio de promoción no válido: ' + S);
  end;
end;

procedure TfPromociones.GuardarPromocionDirecta(const AArticulo, ADescripcion: string;
  const AIni, AFin: TDateTime; const APvpPromo, APvpFicha, ACosteFicha, AIvaFicha: Double;
  const ASegundaUnd50: Boolean);
var
  IniDB, FinDB: string;
  ExistePromo: Boolean;
begin
  IniDB := FormatDateTime('yyyy-mm-dd', AIni);
  FinDB := FormatDateTime('yyyy-mm-dd', AFin);

  dbTrabajo.Active := False;
  dbTrabajo.SQL.Clear;
  dbTrabajo.SQL.Text :=
    'SELECT P0 FROM promo' + Tienda + ' ' +
    'WHERE P0=:art AND DATE(P5)=:ini AND DATE(P6)=:fin LIMIT 1';
  dbTrabajo.ParamByName('art').AsString := AArticulo;
  dbTrabajo.ParamByName('ini').AsString := IniDB;
  dbTrabajo.ParamByName('fin').AsString := FinDB;
  dbTrabajo.Active := True;
  ExistePromo := not dbTrabajo.EOF;
  dbTrabajo.Active := False;

  if ExistePromo then
  begin
    dbTrabajo.SQL.Clear;
    dbTrabajo.SQL.Text :=
      'UPDATE promo' + Tienda + ' SET ' +
      ' P1=:des, P2=:pvpfic, P3=:coste, P4=:iva, ' +
      ' P5=:fini, P6=:ffin, P7=:pvppromo, P8=:costepromo, P9=:ivapromo, P10=''A'' ' +
      'WHERE P0=:art AND DATE(P5)=:iniw AND DATE(P6)=:finw';
    dbTrabajo.ParamByName('des').AsString := ADescripcion;
    dbTrabajo.ParamByName('pvpfic').AsFloat := APvpFicha;
    dbTrabajo.ParamByName('coste').AsFloat := ACosteFicha;
    dbTrabajo.ParamByName('iva').AsFloat := AIvaFicha;
    dbTrabajo.ParamByName('fini').AsDateTime := Trunc(AIni);
    dbTrabajo.ParamByName('ffin').AsDateTime := Trunc(AFin);
    dbTrabajo.ParamByName('pvppromo').AsFloat := APvpPromo;
    dbTrabajo.ParamByName('costepromo').AsFloat := ACosteFicha;
    dbTrabajo.ParamByName('ivapromo').AsFloat := AIvaFicha;
    dbTrabajo.ParamByName('art').AsString := AArticulo;
    dbTrabajo.ParamByName('iniw').AsString := IniDB;
    dbTrabajo.ParamByName('finw').AsString := FinDB;
    dbTrabajo.ExecSQL;
  end
  else
  begin
    dbPromo.Append;
    dbPromo.FieldByName('P0').AsString := AArticulo;                         // Código artículo
    dbPromo.FieldByName('P1').AsString := ADescripcion;                      // Descripción
    dbPromo.FieldByName('P2').AsFloat := APvpFicha;                          // PVP actual ficha
    dbPromo.FieldByName('P3').AsFloat := ACosteFicha;                        // Coste ficha
    dbPromo.FieldByName('P4').AsFloat := AIvaFicha;                          // IVA ficha
    dbPromo.FieldByName('P5').AsDateTime := Trunc(AIni);                     // Inicio promo
    dbPromo.FieldByName('P6').AsDateTime := Trunc(AFin);                     // Fin promo
    dbPromo.FieldByName('P7').AsFloat := APvpPromo;                          // PVP oferta indicado
    dbPromo.FieldByName('P8').AsFloat := ACosteFicha;                        // Coste oferta = coste ficha
    dbPromo.FieldByName('P9').AsFloat := AIvaFicha;                          // IVA oferta = IVA ficha
    dbPromo.FieldByName('P10').AsString := 'A';                              // Activa
    dbPromo.Post;
  end;

  try
    if Assigned(dbPromo.Connection) then
      dbPromo.Connection.Commit;
  except
  end;

  if ASegundaUnd50 then
    SaveSegundaUnidadRule(AArticulo, ADescripcion, IniDB, FinDB)
  else
    DeleteSegundaUnidadRule(AArticulo, IniDB, FinDB);
end;

procedure TfPromociones.ImportarPromocionesDesdeXLSX(const AFichero: string);
var
  TempDir, HojaRelativa: string;
  Shared: TXLSXSharedStrings;
  Tabla: TXLSXTable;
  FilaCabecera, R: Integer;
  ColCodigo, ColEAN, ColDescripcion, ColUnidades, ColPrecioNeto, ColIVA, ColPrecioConIVA: Integer;
  IniPromo, FinPromo: TDateTime;
  CodigoDoc, EanDoc, DescDoc, UdsDoc, NetoDoc, IvaDoc, PvpConIvaDoc: string;
  Articulo, DescFicha: string;
  PvpFicha, CosteFicha, IvaFicha, PvpPromo: Double;
  Leidas, Encontradas, Insertadas, NoEncontradas, Saltadas: Integer;
  SegundaUnd50: Boolean;
begin
  if not FLX_EsFicheroXLSX(AFichero) then
  begin
    ShowMessage('Esta importación sólo lee documentos .XLSX.' + LineEnding +
                'El fichero seleccionado no es XLSX: ' + ExtractFileName(AFichero));
    Exit;
  end;

  if not FileExists(AFichero) then
  begin
    ShowMessage('No existe el fichero seleccionado: ' + AFichero);
    Exit;
  end;

  if not FLX_PreguntarFechaPromo('Fecha de INICIO de la promoción para todo el documento:', Date, IniPromo) then
    Exit;

  if not FLX_PreguntarFechaPromo('Fecha de FIN de la promoción para todo el documento:', Date, FinPromo) then
    Exit;

  if FinPromo < IniPromo then
  begin
    ShowMessage('La fecha de fin no puede ser anterior a la fecha de inicio.');
    Exit;
  end;

  TempDir := '';
  Randomize;
  Leidas := 0;
  Encontradas := 0;
  Insertadas := 0;
  NoEncontradas := 0;
  Saltadas := 0;

  try
    try
      TempDir := FLX_DirTemporalXLSX;
      FLX_DescomprimirXLSX(AFichero, TempDir);
      FLX_CargarSharedStrings(TempDir, Shared);
      HojaRelativa := FLX_PrimeraHojaXLSX(TempDir);
      FLX_CargarHojaXLSX(TempDir, HojaRelativa, Shared, Tabla);
    except
      on E: Exception do
      begin
        ShowMessage('No se ha podido leer el fichero XLSX:' + LineEnding +
                    AFichero + LineEnding + LineEnding + E.Message);
        Exit;
      end;
    end;

    FilaCabecera := FLX_BuscarFilaCabeceraExcel(Tabla);
    if FilaCabecera < 0 then
    begin
      ShowMessage('No se han encontrado las cabeceras esperadas en el XLSX.' + LineEnding +
                  'Se necesita al menos Descripción y Artículo o EAN.');
      Exit;
    end;

    ColCodigo       := FLX_BuscarColumnaExcelEnFila(Tabla[FilaCabecera], ['Artículo', 'Articulo', 'Código', 'Codigo', 'Referencia']);
    ColEAN          := FLX_BuscarColumnaExcelEnFila(Tabla[FilaCabecera], ['Ean', 'EAN', 'Código EAN', 'Codigo EAN', 'Código de barras', 'Codigo de barras']);
    ColDescripcion  := FLX_BuscarColumnaExcelEnFila(Tabla[FilaCabecera], ['Descripción', 'Descripcion', 'Nombre', 'Artículo descripción', 'Articulo descripcion']);
    ColUnidades     := FLX_BuscarColumnaExcelEnFila(Tabla[FilaCabecera], ['Uds', 'Unidades', 'Cantidad', 'Cant']);
    ColPrecioNeto   := FLX_BuscarColumnaExcelEnFila(Tabla[FilaCabecera], ['Precio Neto', 'Precio neto', 'Coste', 'Costo', 'Precio coste', 'Precio costo']);
    ColIVA          := FLX_BuscarColumnaExcelEnFila(Tabla[FilaCabecera], ['Iva', 'IVA', '% IVA', 'Tipo IVA']);
    ColPrecioConIVA := FLX_BuscarColumnaExcelEnFila(Tabla[FilaCabecera], ['Precio con Iva', 'Precio con IVA', 'PVP', 'Precio venta']);

    if (ColCodigo < 0) and (ColEAN < 0) then
    begin
      ShowMessage('Faltan columnas de identificación. Debe existir Artículo/Código o EAN.');
      Exit;
    end;

    for R := FilaCabecera + 1 to Length(Tabla) - 1 do
    begin
      CodigoDoc := '';
      EanDoc := '';
      DescDoc := '';
      UdsDoc := '';
      NetoDoc := '';
      IvaDoc := '';
      PvpConIvaDoc := '';

      if ColCodigo >= 0 then
        CodigoDoc := FLX_NormalizaCodigoExcel(FLX_CeldaTabla(Tabla, R, ColCodigo), True);
      if ColEAN >= 0 then
        EanDoc := FLX_NormalizaCodigoExcel(FLX_CeldaTabla(Tabla, R, ColEAN), False);
      if ColDescripcion >= 0 then
        DescDoc := FLX_NormalizaTextoExcel(FLX_CeldaTabla(Tabla, R, ColDescripcion));
      if ColUnidades >= 0 then
        UdsDoc := FLX_NormalizaNumeroExcel(FLX_CeldaTabla(Tabla, R, ColUnidades));
      if ColPrecioNeto >= 0 then
        NetoDoc := FLX_NormalizaNumeroExcel(FLX_CeldaTabla(Tabla, R, ColPrecioNeto));
      if ColIVA >= 0 then
        IvaDoc := FLX_NormalizaNumeroExcel(FLX_CeldaTabla(Tabla, R, ColIVA));
      if ColPrecioConIVA >= 0 then
        PvpConIvaDoc := FLX_NormalizaNumeroExcel(FLX_CeldaTabla(Tabla, R, ColPrecioConIVA));

      if (CodigoDoc = '') and (EanDoc = '') and (DescDoc = '') then
        Continue;

      Inc(Leidas);

      if not BuscarArticuloDesdeDocumento(CodigoDoc, EanDoc, Articulo, DescFicha, PvpFicha, CosteFicha, IvaFicha) then
      begin
        Inc(NoEncontradas);
        Continue;
      end;

      Inc(Encontradas);

      if not PedirPrecioPromoLinea(Articulo, DescFicha, CodigoDoc, EanDoc, PvpFicha, PvpPromo, SegundaUnd50) then
      begin
        Inc(Saltadas);
        Continue;
      end;

      GuardarPromocionDirecta(Articulo, DescFicha, IniPromo, FinPromo,
        PvpPromo, PvpFicha, CosteFicha, IvaFicha, SegundaUnd50);

      Inc(Insertadas);
      Application.ProcessMessages;
    end;

    rgFiltro.ItemIndex := 0;
    rgFiltroClick(Self);

    ShowMessage('Importación de promociones finalizada.' + LineEnding + LineEnding +
                'Documento: ' + ExtractFileName(AFichero) + LineEnding +
                'Líneas leídas: ' + IntToStr(Leidas) + LineEnding +
                'Artículos encontrados: ' + IntToStr(Encontradas) + LineEnding +
                'Promociones insertadas/actualizadas: ' + IntToStr(Insertadas) + LineEnding +
                'No encontrados: ' + IntToStr(NoEncontradas) + LineEnding +
                'Saltadas/canceladas: ' + IntToStr(Saltadas));

  finally
    SetLength(Shared, 0);
    SetLength(Tabla, 0);
    if (TempDir <> '') and DirectoryExists(TempDir) then
    begin
      try
        DeleteDirectory(TempDir, False);
      except
      end;
    end;
  end;
end;


procedure TfPromociones.PromoModeChanged(Sender: TObject);
begin
  if chkSegundaUnd50=nil then Exit;

  // La promoción de 2ª unidad NO debe bloquear el precio de oferta.
  // Caso real: PVP normal 4,00 -> PVP oferta 3,50 y además 2ª unidad al 50%.
  // Por eso dejamos Edit4/Edit5/Edit6 editables siempre. Si están vacíos,
  // usamos como propuesta los valores actuales, pero sin impedir cambiarlos.
  Edit4.Enabled := True;
  Edit5.Enabled := True;
  Edit6.Enabled := True;

  if chkSegundaUnd50.Checked then
  begin
    if Trim(Edit4.Text) = '' then Edit4.Text := Edit8.Text;
    if Trim(Edit5.Text) = '' then Edit5.Text := Edit9.Text;
    if Trim(Edit6.Text) = '' then Edit6.Text := Edit10.Text;
    if lblInfoSegundaUnd<>nil then
      lblInfoSegundaUnd.Visible := True;
  end
  else
  begin
    if lblInfoSegundaUnd<>nil then
      lblInfoSegundaUnd.Visible := False;
  end;
end;

procedure TfPromociones.EnsurePromoRulesTable;
begin
  dbTrabajo.Active := False;
  dbTrabajo.SQL.Clear;
  dbTrabajo.SQL.Text :=
    'CREATE TABLE IF NOT EXISTS promo_rules' + Tienda + ' ('+
    ' id int(11) NOT NULL AUTO_INCREMENT,'+
    ' activo char(1) NOT NULL DEFAULT ''S'','+
    ' prioridad int(11) NOT NULL DEFAULT 0,'+
    ' tipo char(20) NOT NULL DEFAULT ''PRECIO_FIJO'','+
    ' inicio_dt datetime DEFAULT NULL,'+
    ' fin_dt datetime DEFAULT NULL,'+
    ' articulo char(13) DEFAULT '''','+
    ' familia int(11) DEFAULT -1,'+
    ' cliente char(13) DEFAULT '''','+
    ' descripcion char(80) NOT NULL DEFAULT '''','+
    ' texto_ticket char(60) NOT NULL DEFAULT '''','+
    ' precio_fijo double(10,3) NOT NULL DEFAULT 0.000,'+
    ' dto_pct double(5,2) NOT NULL DEFAULT 0.00,'+
    ' n int(11) NOT NULL DEFAULT 0,'+
    ' m int(11) NOT NULL DEFAULT 0,'+
    ' seg_pct double(5,2) NOT NULL DEFAULT 0.00,'+
    ' pack_code char(20) NOT NULL DEFAULT '''','+
    ' created_at datetime DEFAULT CURRENT_TIMESTAMP,'+
    ' updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,'+
    ' PRIMARY KEY (id),'+
    ' KEY k_activo_rango (activo,inicio_dt,fin_dt),'+
    ' KEY k_articulo_rango (articulo,activo,inicio_dt,fin_dt),'+
    ' KEY k_tipo_prio (tipo,prioridad)'+
    ') ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci';
  try
    dbTrabajo.ExecSQL;
  except
  end;
end;

function TfPromociones.HasSegundaUnidadRule(const AArticulo, AIniDB, AFinDB: string): Boolean;
begin
  Result := False;
  EnsurePromoRulesTable;
  dbTrabajo.Active := False;
  dbTrabajo.SQL.Clear;
  dbTrabajo.SQL.Text :=
    'SELECT id FROM promo_rules' + Tienda + ' ' +
    'WHERE activo=''S'' ' +
    '  AND tipo=''SEGUNDA_UND_PCT'' ' +
    '  AND articulo="' + AArticulo + '" ' +
    '  AND DATE(inicio_dt)="' + AIniDB + '" ' +
    '  AND DATE(fin_dt)="' + AFinDB + '" ' +
    'LIMIT 1';
  try
    dbTrabajo.Active := True;
    Result := dbTrabajo.RecordCount <> 0;
  except
    Result := False;
  end;
end;

procedure TfPromociones.DeleteSegundaUnidadRule(const AArticulo, AIniDB, AFinDB: string);
begin
  if Trim(AArticulo)='' then Exit;
  EnsurePromoRulesTable;
  dbTrabajo.Active := False;
  dbTrabajo.SQL.Clear;
  dbTrabajo.SQL.Text :=
    'DELETE FROM promo_rules' + Tienda + ' ' +
    'WHERE tipo=''SEGUNDA_UND_PCT'' ' +
    '  AND articulo="' + AArticulo + '" ' +
    '  AND DATE(inicio_dt)="' + AIniDB + '" ' +
    '  AND DATE(fin_dt)="' + AFinDB + '"';
  try
    dbTrabajo.ExecSQL;
    if Assigned(dbTrabajo.Connection) then
      dbTrabajo.Connection.Commit;
  except
  end;
end;

procedure TfPromociones.SaveSegundaUnidadRule(const AArticulo, ADescripcion, AIniDB, AFinDB: string);
var
  DescEsc: string;
begin
  if Trim(AArticulo)='' then Exit;
  EnsurePromoRulesTable;
  DeleteSegundaUnidadRule(AArticulo, AIniDB, AFinDB);

  DescEsc := StringReplace(ADescripcion, '"', '\"', [rfReplaceAll]);

  dbTrabajo.Active := False;
  dbTrabajo.SQL.Clear;
  dbTrabajo.SQL.Text :=
    'INSERT INTO promo_rules' + Tienda +
    ' (activo, prioridad, tipo, articulo, inicio_dt, fin_dt, seg_pct, descripcion, texto_ticket) VALUES (' +
    ' ''S'', 100, ''SEGUNDA_UND_PCT'', ' +
    ' "' + AArticulo + '", ' +
    ' "' + AIniDB + ' 00:00:00", ' +
    ' "' + AFinDB + ' 23:59:59", ' +
    ' 50, ' +
    ' "' + DescEsc + '", ' +
    ' ''2ª UND 50%'' )';
  try
    dbTrabajo.ExecSQL;
    if Assigned(dbTrabajo.Connection) then
      dbTrabajo.Connection.Commit;
  except
  end;
end;



//==========================================================================
// Helpers de fechas para promociones
// - La tabla promoXXXX históricamente guarda P5/P6 como texto (a veces DD/MM/YYYY,
//   otras DD-MM-YYYY o YYYY-MM-DD).  Esto hacía que las comparaciones por string
//   fallasen "a veces".
// - Con estas funciones comparamos SIEMPRE como fecha real.
//==========================================================================
function TryPromoStrToDate(const S: string; out D: TDateTime): Boolean;
var
  FS: TFormatSettings;
  Y, M, Day: Integer;
  T: string;
begin
  Result := False;
  D := 0;
  T := Trim(S);
  if T = '' then Exit;

  // 1) Intento con formato regional
  FS := DefaultFormatSettings;
  if TryStrToDate(T, D, FS) then Exit(True);

  // 2) Intento explícito DD/MM/YYYY
  FS.DateSeparator := '/';
  FS.ShortDateFormat := 'dd/mm/yyyy';
  if TryStrToDate(T, D, FS) then Exit(True);

  // 3) Intento explícito DD-MM-YYYY
  FS.DateSeparator := '-';
  FS.ShortDateFormat := 'dd-mm-yyyy';
  if TryStrToDate(T, D, FS) then Exit(True);

  // 4) Intento ISO YYYY-MM-DD (manual)
  if (Length(T) >= 10) and (T[5] = '-') and (T[8] = '-') then
  begin
    try
      Y := StrToInt(Copy(T, 1, 4));
      M := StrToInt(Copy(T, 6, 2));
      Day := StrToInt(Copy(T, 9, 2));
      D := EncodeDate(Y, M, Day);
      Exit(True);
    except
      Exit(False);
    end;
  end;
end;

function PromoDateToDB(const D: TDateTime): string;
begin
  // ISO estable para comparar y ordenar en SQL aunque sea campo texto
  Result := FormatDateTime('yyyy-mm-dd', D);
end;

function PromoStrToDB(const S: string): string;
var
  D: TDateTime;
begin
  if TryPromoStrToDate(S, D) then
    Result := PromoDateToDB(D)
  else
    Result := Trim(S);
end;

function PromoStrToUI(const S: string): string;
var
  D: TDateTime;
begin
  if TryPromoStrToDate(S, D) then
    Result := FormatDateTime('dd/mm/yyyy', D)
  else
    Result := Trim(S);
end;

//=============== Crea el formulario ================
procedure ShowFormPromociones;
begin
  with TFPromociones.Create(Application) do
    begin
       ShowModal;
    end;
end;

//======== Procesa las Promociones para actualizar Artículos ======

procedure TfPromociones.ActualizarPromociones;
begin
  // MODO PRO / SEGURO
  // No modificamos artitienXXXX.
  // Solo marcamos promociones caducadas.

  dbTrabajo.Active := False;
  dbTrabajo.SQL.Clear;
  dbTrabajo.SQL.Text :=
    'UPDATE promo' + Tienda +
    ' SET P10=''F'' ' +
    ' WHERE (P10=''A'' OR P10 IS NULL OR P10='''') ' +
    ' AND P6 < CURDATE()';

  dbTrabajo.ExecSQL;

  try
    if Assigned(dbTrabajo.Connection) then
      dbTrabajo.Connection.Commit;
  except
  end;

  rgFiltroClick(Self);
end;

procedure TfPromociones.btnActualizarClick(Sender: TObject);
begin
  ActualizarPromociones;
  rgFiltroClick(Self);
end;

{ TfPromociones }

// Procedimientos para Activación y Desactivación del Panel
procedure TfPromociones.ActivarPanel;
begin
  rgFiltro.Enabled:=False;
  dbgDatos.Enabled:=False;
  btnCrear.Enabled:=False;
  btnBorrar.Enabled:=False;
  btnModificar.Enabled:=False;
  btnCerrar.Enabled:=False;
  btnActualizar.Enabled:=False;
  if btnImportarXLSX<>nil then
    btnImportarXLSX.Enabled:=False;
  Panel1.Visible:=True;
  if Operacion='A' then
    Label13.Caption:='NUEVA PROMOCIÓN'
  else
    Label13.Caption:='MODIFICAR PROMOCIÓN';
  RecolocarControles;
  Panel1.BringToFront;
  AplicarContrasteSeleccionControles(Panel1);
end;
procedure TfPromociones.DesactivarPanel;
begin
  FMoviendoPanel := False;
  Panel1.Visible:=False;
  rgFiltro.Enabled:=True;
  dbgDatos.Enabled:=True;
  btnCrear.Enabled:=True;
  btnBorrar.Enabled:=True;
  btnModificar.Enabled:=True;
  btnCerrar.Enabled:=True;
  btnActualizar.Enabled:=True;
  if btnImportarXLSX<>nil then
    btnImportarXLSX.Enabled:=True;
  dbgDatos.SetFocus;
  ActualizarEstado;
end;

procedure TfPromociones.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  // Forzamos commit por si hay cambios pendientes y para que Ventas los vea sin reiniciar
try
  if Assigned(dbPromo.Connection) then
    dbPromo.Connection.Commit;
except
end;

Closeaction:=CaFree;
end;


procedure TfPromociones.ConfigurarBoton(ABoton: TBitBtn;
  const ACaption, AHint: string; AColor: TColor);
begin
  if not Assigned(ABoton) then Exit;
  ABoton.Caption := ACaption;
  ABoton.Hint := AHint;
  ABoton.ShowHint := True;
  ABoton.Color := AColor;
  ABoton.Font.Color := RGBToColor(24, 36, 48);
  ABoton.Font.Height := -14;
  ABoton.Font.Style := [fsBold];
  ABoton.Visible := True;
  ABoton.BringToFront;
end;

procedure TfPromociones.AplicarEstiloModerno;
var
  I: Integer;
  C: TComponent;
begin
  Color := RGBToColor(244, 247, 250);
  Font.Name := 'Sans';
  Font.Height := -13;
  Constraints.MinWidth := 1120;
  Constraints.MinHeight := 650;

  if not Assigned(FHeaderPanel) then
  begin
    FHeaderPanel := TPanel.Create(Self);
    FHeaderPanel.Parent := Self;
    FHeaderPanel.Caption := '';
    FHeaderPanel.BevelOuter := bvNone;
    FHeaderPanel.Color := RGBToColor(36, 78, 118);
    FHeaderPanel.Left := 0;
    FHeaderPanel.Top := 0;
    FHeaderPanel.Height := 88;
    FHeaderPanel.Width := ClientWidth;
    FHeaderPanel.Anchors := [akLeft, akTop, akRight];
    FHeaderPanel.SendToBack;

    FHeaderTitle := TLabel.Create(Self);
    FHeaderTitle.Parent := FHeaderPanel;
    FHeaderTitle.Caption := 'GESTIÓN DE PROMOCIONES';
    FHeaderTitle.Left := 26;
    FHeaderTitle.Top := 16;
    FHeaderTitle.Font.Name := 'Sans';
    FHeaderTitle.Font.Height := -22;
    FHeaderTitle.Font.Style := [fsBold];
    FHeaderTitle.Font.Color := clWhite;
    FHeaderTitle.ParentColor := True;

    FHeaderSubtitle := TLabel.Create(Self);
    FHeaderSubtitle.Parent := FHeaderPanel;
    FHeaderSubtitle.Caption :=
      'Consulta, crea y actualiza ofertas por artículo y periodo de vigencia';
    FHeaderSubtitle.Left := 28;
    FHeaderSubtitle.Top := 51;
    FHeaderSubtitle.Font.Name := 'Sans';
    FHeaderSubtitle.Font.Height := -13;
    FHeaderSubtitle.Font.Color := RGBToColor(225, 237, 248);
    FHeaderSubtitle.ParentColor := True;
  end;

  if not Assigned(FStatusLabel) then
  begin
    FStatusLabel := TLabel.Create(Self);
    FStatusLabel.Parent := Self;
    FStatusLabel.AutoSize := False;
    FStatusLabel.Alignment := taLeftJustify;
    FStatusLabel.Font.Name := 'Sans';
    FStatusLabel.Font.Height := -13;
    FStatusLabel.Font.Style := [fsBold];
    FStatusLabel.Font.Color := RGBToColor(42, 67, 88);
    FStatusLabel.ParentColor := True;
  end;

  rgFiltro.Caption := ' PROMOCIONES A MOSTRAR ';
  rgFiltro.Font.Name := 'Sans';
  rgFiltro.Font.Height := -14;
  rgFiltro.Font.Color := RGBToColor(30, 47, 63);
  rgFiltro.Color := RGBToColor(231, 241, 249);
  rgFiltro.ParentColor := False;

  dbgDatos.Color := clWhite;
  dbgDatos.Font.Name := 'Sans';
  dbgDatos.Font.Height := -13;
  dbgDatos.TitleFont.Name := 'Sans';
  dbgDatos.TitleFont.Height := -13;
  dbgDatos.TitleFont.Style := [fsBold];
  dbgDatos.TitleFont.Color := RGBToColor(24, 52, 78);
  dbgDatos.Options := dbgDatos.Options + [dgRowSelect, dgAlwaysShowSelection];
  dbgDatos.OnTitleClick := @dbgDatosTitleClick;
  dbgDatos.OnDrawColumnCell := @dbgDatosDrawColumnCell;

  ConfigurarBoton(btnCrear, 'Nueva promoción',
    'Crear una promoción nueva (F2)', RGBToColor(199, 235, 210));
  ConfigurarBoton(btnModificar, 'Modificar',
    'Modificar la promoción seleccionada', RGBToColor(205, 226, 246));
  ConfigurarBoton(btnBorrar, 'Eliminar',
    'Eliminar la promoción seleccionada (F3)', RGBToColor(249, 213, 213));
  ConfigurarBoton(btnActualizar, 'Finalizar caducadas',
    'Marca como finalizadas las promociones cuya fecha ya ha vencido',
    RGBToColor(255, 232, 184));
  ConfigurarBoton(btnCerrar, 'Cerrar',
    'Cerrar la gestión de promociones', RGBToColor(224, 229, 234));

  Panel1.Caption := '';
  Panel1.Color := RGBToColor(246, 249, 252);
  Panel1.BevelOuter := bvNone;

  Label13.Caption := 'DATOS DE LA PROMOCIÓN';
  Label13.Color := RGBToColor(36, 78, 118);
  Label13.Font.Name := 'Sans';
  Label13.Font.Height := -17;
  Label13.Font.Style := [fsBold];
  Label13.Font.Color := clWhite;
  Label13.Transparent := False;
  Label13.Cursor := crSizeAll;
  Label13.Hint := 'Arrastre esta cabecera para mover el panel';
  Label13.ShowHint := True;
  Label13.OnMouseDown := @CabeceraPanelMouseDown;
  Label13.OnMouseMove := @CabeceraPanelMouseMove;
  Label13.OnMouseUp := @CabeceraPanelMouseUp;

  Label1.Caption := 'Código del artículo';
  Label2.Caption := 'Descripción';
  Label3.Caption := 'INICIO Y VALORES DE OFERTA';
  Label4.Caption := 'Fecha de inicio';
  Label5.Caption := 'PVP de oferta';
  Label6.Caption := 'Coste de oferta';
  Label7.Caption := '% IVA oferta';
  Label8.Caption := 'FIN Y VALORES A RESTAURAR';
  Label9.Caption := 'Fecha de fin';
  Label10.Caption := 'PVP normal';
  Label11.Caption := 'Coste normal';
  Label12.Caption := '% IVA normal';

  for I := 1 to 12 do
    with TLabel(FindComponent('Label' + IntToStr(I))) do
    begin
      Font.Name := 'Sans';
      Font.Height := -13;
      Font.Color := RGBToColor(32, 49, 64);
      ParentColor := True;
    end;
  Label3.Font.Style := [fsBold];
  Label3.Font.Color := RGBToColor(35, 93, 137);
  Label8.Font.Style := [fsBold];
  Label8.Font.Color := RGBToColor(35, 93, 137);

  for I := 1 to 10 do
  begin
    C := FindComponent('Edit' + IntToStr(I));
    if C is TEdit then
    begin
      TEdit(C).Color := clWhite;
      TEdit(C).Font.Name := 'Sans';
      TEdit(C).Font.Height := -14;
      TEdit(C).Font.Color := RGBToColor(16, 24, 32);
    end
    else if C is TDateEdit then
    begin
      TDateEdit(C).Color := clWhite;
      TDateEdit(C).Font.Name := 'Sans';
      TDateEdit(C).Font.Height := -14;
      TDateEdit(C).Font.Color := RGBToColor(16, 24, 32);
      TDateEdit(C).DefaultToday := True;
      TDateEdit(C).DateOrder := doNone;
      TDateEdit(C).ButtonWidth := 30;
    end;
  end;

  ConfigurarBoton(btnAceptar, 'Guardar promoción',
    'Guardar los datos de la promoción (F8)', RGBToColor(190, 231, 202));
  ConfigurarBoton(btnCancelar, 'Cancelar',
    'Cancelar la edición y volver al listado (ESC)', RGBToColor(231, 235, 239));
  ConfigurarBoton(btnBuscar, '...',
    'Buscar un artículo', RGBToColor(184, 218, 244));

  RecolocarControles;
end;

procedure TfPromociones.AplicarContrasteSeleccion(AEditControl: TWinControl);
{$IFDEF LCLGTK2}
var
  FondoNormal, TextoNormal, FondoSeleccion, TextoSeleccion: TGdkColor;
  Widget: PGtkWidget;
{$ENDIF}
begin
  if not Assigned(AEditControl) then Exit;
  AEditControl.HandleNeeded;

  {$IFDEF LCLGTK2}
  Widget := PGtkWidget(AEditControl.Handle);
  if Assigned(Widget) then
  begin
    gdk_color_parse(PChar('#FFFFFF'), @FondoNormal);
    gdk_color_parse(PChar('#101820'), @TextoNormal);
    gtk_widget_modify_base(Widget, GTK_STATE_NORMAL, @FondoNormal);
    gtk_widget_modify_text(Widget, GTK_STATE_NORMAL, @TextoNormal);

    gdk_color_parse(PChar('#2A5684'), @FondoSeleccion);
    gdk_color_parse(PChar('#FFFFFF'), @TextoSeleccion);
    gtk_widget_modify_base(Widget, GTK_STATE_SELECTED, @FondoSeleccion);
    gtk_widget_modify_text(Widget, GTK_STATE_SELECTED, @TextoSeleccion);
  end;
  {$ENDIF}
end;

procedure TfPromociones.AplicarContrasteSeleccionControles(AParent: TWinControl);
var
  I: Integer;
  C: TControl;
begin
  if not Assigned(AParent) then Exit;
  for I := 0 to AParent.ControlCount - 1 do
  begin
    C := AParent.Controls[I];
    if C is TCustomEdit then
      AplicarContrasteSeleccion(TWinControl(C));
    if C is TWinControl then
      AplicarContrasteSeleccionControles(TWinControl(C));
  end;
end;

procedure TfPromociones.ActualizarEstado;
var
  Tipo: string;
begin
  if not Assigned(FStatusLabel) then Exit;
  case rgFiltro.ItemIndex of
    0: Tipo := 'activas';
    1: Tipo := 'finalizadas';
  else
    Tipo := 'totales';
  end;
  if dbPromo.Active then
    FStatusLabel.Caption := Format('%d promociones %s.  Pulse una cabecera para ordenar.',
      [dbPromo.RecordCount, Tipo])
  else
    FStatusLabel.Caption := 'Sin datos cargados.';
end;

procedure TfPromociones.MarcarColumnaOrdenada(Column: TColumn);
var
  I: Integer;
  S, Flecha: string;
begin
  for I := 0 to dbgDatos.Columns.Count - 1 do
  begin
    S := StringReplace(dbgDatos.Columns[I].Title.Caption, ' ▲', '', [rfReplaceAll]);
    S := StringReplace(S, ' ▼', '', [rfReplaceAll]);
    dbgDatos.Columns[I].Title.Caption := S;
  end;

  if not Assigned(Column) then Exit;
  if FSortAsc then Flecha := ' ▲' else Flecha := ' ▼';
  Column.Title.Caption := Column.Title.Caption + Flecha;
end;

procedure TfPromociones.dbgDatosTitleClick(Column: TColumn);
var
  SQLBase, SQLMayus, Direccion: string;
  P: Integer;
begin
  if (not Assigned(Column)) or (Column.FieldName = '') or
     (not dbPromo.Active) then Exit;

  if SameText(FSortField, Column.FieldName) then
    FSortAsc := not FSortAsc
  else
  begin
    FSortField := Column.FieldName;
    FSortAsc := True;
  end;

  SQLBase := Trim(dbPromo.SQL.Text);
  SQLMayus := UpperCase(SQLBase);
  P := Pos(' ORDER BY ', SQLMayus);
  if P > 0 then
    SQLBase := Trim(Copy(SQLBase, 1, P - 1));

  if FSortAsc then Direccion := 'ASC' else Direccion := 'DESC';

  dbgDatos.Enabled := False;
  try
    dbPromo.Close;
    dbPromo.SQL.Text := SQLBase + ' ORDER BY ' + FSortField + ' ' + Direccion;
    dbPromo.Open;
    MarcarColumnaOrdenada(Column);
    ActualizarEstado;
  finally
    dbgDatos.Enabled := True;
  end;
end;

procedure TfPromociones.dbgDatosDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  S: string;
begin
  if gdSelected in State then
  begin
    dbgDatos.Canvas.Brush.Color := RGBToColor(42, 86, 132);
    dbgDatos.Canvas.Font.Color := clWhite;
    dbgDatos.Canvas.FillRect(Rect);
    if Assigned(Column) and Assigned(Column.Field) then
      S := Column.Field.DisplayText
    else
      S := '';
    dbgDatos.Canvas.TextRect(Rect, Rect.Left + 5, Rect.Top + 3, S);
    Exit;
  end;
  dbgDatos.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TfPromociones.RecolocarControles;
const
  Margen = 24;
  Separacion = 12;
var
  YBotones, AnchoBoton, TotalBotones, X: Integer;
begin
  if Assigned(FHeaderPanel) then
    FHeaderPanel.Width := ClientWidth;

  rgFiltro.Left := Margen;
  rgFiltro.Top := 104;
  rgFiltro.Width := 500;
  rgFiltro.Height := 72;

  if Assigned(btnImportarXLSX) then
  begin
    btnImportarXLSX.Left := rgFiltro.Left + rgFiltro.Width + 18;
    btnImportarXLSX.Top := 118;
    btnImportarXLSX.Width := 190;
    btnImportarXLSX.Height := 44;
  end;

  YBotones := ClientHeight - 58;
  AnchoBoton := 170;
  TotalBotones := (AnchoBoton * 5) + (Separacion * 4);
  X := Max(Margen, (ClientWidth - TotalBotones) div 2);

  btnCrear.SetBounds(X, YBotones, AnchoBoton, 42);
  Inc(X, AnchoBoton + Separacion);
  btnModificar.SetBounds(X, YBotones, AnchoBoton, 42);
  Inc(X, AnchoBoton + Separacion);
  btnBorrar.SetBounds(X, YBotones, AnchoBoton, 42);
  Inc(X, AnchoBoton + Separacion);
  btnActualizar.SetBounds(X, YBotones, AnchoBoton, 42);
  Inc(X, AnchoBoton + Separacion);
  btnCerrar.SetBounds(X, YBotones, AnchoBoton, 42);

  if Assigned(FStatusLabel) then
    FStatusLabel.SetBounds(Margen, YBotones - 28, ClientWidth - (Margen * 2), 20);

  dbgDatos.SetBounds(Margen, 192, ClientWidth - (Margen * 2),
    Max(180, YBotones - 228));

  if Panel1.Visible then
  begin
    if not FPanelMovidoPorUsuario then
    begin
      Panel1.Left := Max(12, (ClientWidth - Panel1.Width) div 2);
      Panel1.Top := Max(100, (ClientHeight - Panel1.Height) div 2);
    end;
    LimitarPanelAlAreaVisible;
    Panel1.BringToFront;
  end;
end;

procedure TfPromociones.LimitarPanelAlAreaVisible;
var
  MaxLeft, MaxTop: Integer;
begin
  if (not Assigned(Panel1)) or (not (Panel1.Parent is TWinControl)) then Exit;

  MaxLeft := TWinControl(Panel1.Parent).ClientWidth - Panel1.Width;
  MaxTop := TWinControl(Panel1.Parent).ClientHeight - Panel1.Height;
  if MaxLeft < 0 then MaxLeft := 0;
  if MaxTop < 0 then MaxTop := 0;

  if Panel1.Left < 0 then Panel1.Left := 0;
  if Panel1.Top < 88 then Panel1.Top := 88;
  if Panel1.Left > MaxLeft then Panel1.Left := MaxLeft;
  if Panel1.Top > MaxTop then Panel1.Top := MaxTop;
end;

procedure TfPromociones.CabeceraPanelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  P, OrigenPanel: TPoint;
begin
  if Button <> mbLeft then Exit;
  if not (Sender is TControl) then Exit;

  P := TControl(Sender).ClientToScreen(Point(X, Y));
  OrigenPanel := Panel1.ClientToScreen(Point(0, 0));
  FPanelDragOffset := Point(P.X - OrigenPanel.X, P.Y - OrigenPanel.Y);
  FMoviendoPanel := True;
  FPanelMovidoPorUsuario := True;
end;

procedure TfPromociones.CabeceraPanelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  P, OrigenPadre: TPoint;
begin
  if not FMoviendoPanel then Exit;
  if not (ssLeft in Shift) then
  begin
    FMoviendoPanel := False;
    Exit;
  end;
  if not (Sender is TControl) then Exit;

  P := TControl(Sender).ClientToScreen(Point(X, Y));
  OrigenPadre := TWinControl(Panel1.Parent).ClientToScreen(Point(0, 0));
  Panel1.Left := P.X - FPanelDragOffset.X - OrigenPadre.X;
  Panel1.Top := P.Y - FPanelDragOffset.Y - OrigenPadre.Y;
  LimitarPanelAlAreaVisible;
end;

procedure TfPromociones.CabeceraPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then Exit;
  FMoviendoPanel := False;
  LimitarPanelAlAreaVisible;
end;

procedure TfPromociones.FormResize(Sender: TObject);
begin
  RecolocarControles;
end;

procedure TfPromociones.FormShow(Sender: TObject);
begin
  AplicarContrasteSeleccionControles(Self);
  RecolocarControles;
end;

procedure TfPromociones.FormCreate(Sender: TObject);
begin
  //----------------- CONEXION -----------------
  //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Tablas ------------------
  dbPromo.SQL.Text:='SELECT * FROM promo'+Tienda+' WHERE P10=''A'' ORDER BY P0';
  dbPromo.Active := True;
  dbArti.Sql.Text:='SELECT * FROM artitien'+Tienda+' ORDER BY A0';
  dbArti.Active := True;

  btnImportarXLSX := TBitBtn.Create(Self);
  btnImportarXLSX.Parent := Self;
  btnImportarXLSX.Caption := 'Importar promociones XLSX';
  btnImportarXLSX.Hint := 'Importa un documento XLSX de proveedor y crea promociones línea por línea';
  btnImportarXLSX.ShowHint := True;
  btnImportarXLSX.OnClick := @btnImportarXLSXClick;


  FOldPromoArt := '';
  FOldPromoIni := '';
  FOldPromoFin := '';
  FOldPromoWasSegunda := False;

  chkSegundaUnd50 := TCheckBox.Create(Self);
  chkSegundaUnd50.Parent := Panel1;
  chkSegundaUnd50.Caption := '2ª unidad al 50%';
  chkSegundaUnd50.Left := Edit7.Left;
  chkSegundaUnd50.Top := Edit10.Top + Edit10.Height + 8;
  chkSegundaUnd50.Width := 160;
  chkSegundaUnd50.OnClick := @PromoModeChanged;

  lblInfoSegundaUnd := TLabel.Create(Self);
  lblInfoSegundaUnd.Parent := Panel1;
  lblInfoSegundaUnd.Caption := 'Se aplica al totalizar sobre el PVP de oferta indicado.';
  lblInfoSegundaUnd.Left := chkSegundaUnd50.Left + 18;
  lblInfoSegundaUnd.Top := chkSegundaUnd50.Top + 20;
  lblInfoSegundaUnd.Font.Style := [fsItalic];
  lblInfoSegundaUnd.Visible := False;

  FSortField := 'P0';
  FSortAsc := True;
  FMoviendoPanel := False;
  FPanelMovidoPorUsuario := False;

  Edit3.DefaultToday := True;
  Edit3.DateOrder := doNone;
  Edit3.ButtonWidth := 30;
  Edit7.DefaultToday := True;
  Edit7.DateOrder := doNone;
  Edit7.ButtonWidth := 30;

  AplicarEstiloModerno;

  chkSegundaUnd50.Left := 28;
  chkSegundaUnd50.Top := 360;
  chkSegundaUnd50.Width := 190;
  lblInfoSegundaUnd.Left := 220;
  lblInfoSegundaUnd.Top := 363;

  chkSegundaUnd50.Font.Name := 'Sans';
  chkSegundaUnd50.Font.Height := -14;
  chkSegundaUnd50.Font.Color := RGBToColor(28, 46, 62);
  chkSegundaUnd50.Color := Panel1.Color;
  lblInfoSegundaUnd.Font.Name := 'Sans';
  lblInfoSegundaUnd.Font.Height := -12;
  lblInfoSegundaUnd.Font.Color := RGBToColor(65, 86, 104);
  lblInfoSegundaUnd.ParentColor := True;

  ConfigurarBoton(btnImportarXLSX, 'Importar promociones XLSX',
    'Importa promociones desde un documento XLSX del proveedor',
    RGBToColor(215, 226, 246));

  MarcarColumnaOrdenada(dbgDatos.Columns[0]);
  ActualizarEstado;
  EnsurePromoRulesTable;
end;

procedure TfPromociones.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key=VK_ESCAPE) and (Panel1.Visible=False)) then begin; key:=0; btnCerrarClick(Sender); exit; end;
  if ((Key=VK_ESCAPE) and (Panel1.Visible=True)) then begin; key:=0; btnCancelarClick(Sender); exit ; end;
  if (key=VK_F8) and ( Panel1.Visible=True) then begin; key:=0; btnAceptarClick(self); exit; end;
  if (key=VK_F3) and ( Panel1.Visible=False) then begin; key:=0; btnBorrarClick(self); exit; end;
  if (key=VK_F2) and ( Panel1.Visible=False) then begin; key:=0; btnCrearClick(self); exit; end;
end;

procedure TfPromociones.rgFiltroClick(Sender: TObject);
begin
  dbPromo.Active:=False;
  dbPromo.SQL.Clear;
  case rgFiltro.ItemIndex of
       0: dbPromo.SQL.Add('SELECT * FROM promo'+Tienda+' WHERE P10=''A'' ORDER BY P0');
       1: dbPromo.SQL.Add('SELECT * FROM promo'+Tienda+' WHERE P10=''F'' ORDER BY P0');
       2: dbPromo.SQL.Add('SELECT * FROM promo'+Tienda+' ORDER BY P0');
  end;
  dbPromo.Active:=True;
  FSortField:='P0';
  FSortAsc:=True;
  if dbgDatos.Columns.Count>0 then
    MarcarColumnaOrdenada(dbgDatos.Columns[0]);
  ActualizarEstado;
end;

procedure TfPromociones.btnCerrarClick(Sender: TObject);
begin
  dbPromo.Active:=False;
  dbArti.Active:=False;
  Self.Close;
end;

procedure TfPromociones.btnAceptarClick(Sender: TObject);
var
  ArticuloRegla, IniDB, FinDB: string;
  IsSamePromoBeingModified: Boolean;
begin
  ArticuloRegla := ResolverCodigoArticulo(Edit1.Text);
  if ArticuloRegla <> '' then Edit1.Text := ArticuloRegla;

  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM promo'+Tienda+' WHERE '+
                      'P0="'+Edit1.Text+'" and '+
                      'P1="'+Edit2.Text+'" and '+
                      'P5="'+PromoStrToDB(Edit3.Text)+'" and '+
                      'P6="'+PromoStrToDB(Edit7.Text)+'"';
  dbTrabajo.Active:=True;

  IniDB := PromoStrToDB(Edit3.Text);
  FinDB := PromoStrToDB(Edit7.Text);

  IsSamePromoBeingModified :=
    (Operacion='M') and
    (Trim(Edit1.Text)=Trim(FOldPromoArt)) and
    (IniDB=FOldPromoIni) and
    (FinDB=FOldPromoFin);

  if dbTrabajo.RecordCount<>0 then
   begin
    // En modificación, la búsqueda de duplicados encuentra la propia promoción.
    // Antes eso hacía que solo se reactivara y saliera sin guardar cambios.
    // Si es la misma promoción seleccionada, dejamos continuar con dbPromo.Edit.
    if not IsSamePromoBeingModified then
    begin
      showmessage(' Ya existe esa promoción, REACTIVANDO ... ' );
      dbTrabajo.Edit;
      dbTrabajo.FieldByName('P10').AsString:='A';
      dbTrabajo.Post;

      try
        if Assigned(dbTrabajo.Connection) then
          dbTrabajo.Connection.Commit;
      except
      end;

      if chkSegundaUnd50.Checked then
        SaveSegundaUnidadRule(Edit1.Text, Edit2.Text, IniDB, FinDB)
      else
        DeleteSegundaUnidadRule(Edit1.Text, IniDB, FinDB);

      Exit
    end;
   end;

  if (Operacion='M') and FOldPromoWasSegunda then
    DeleteSegundaUnidadRule(FOldPromoArt, FOldPromoIni, FOldPromoFin);

  if Operacion='A' then
     dbPromo.Append
  else
     dbPromo.Edit;
  LlenaReg();
  dbPromo.Post;

  try
    if Assigned(dbPromo.Connection) then
      dbPromo.Connection.Commit;
  except
  end;

  if chkSegundaUnd50.Checked then
    SaveSegundaUnidadRule(Edit1.Text, Edit2.Text, IniDB, FinDB)
  else if Operacion='M' then
    DeleteSegundaUnidadRule(Edit1.Text, IniDB, FinDB);

  dbgDatos.Refresh;
  ActualizarEstado;
  Operacion:='A';
  FOldPromoArt := '';
  FOldPromoIni := '';
  FOldPromoFin := '';
  FOldPromoWasSegunda := False;
  LimpiaPanel();
  Edit1.SetFocus;
end;

procedure TfPromociones.btnBorrarClick(Sender: TObject);
var
  Art, IniDB, FinDB: string;
begin
  if dbPromo.RecordCount=0 then exit;
  if Application.MessageBox('¿DESEA BORRAR LA PROMOCION SELECCIONADA?',
     'FacturLinEx',
     MB_ICONQUESTION + MB_YESNO) = idYes then
  begin
    Art := dbPromo.FieldByName('P0').AsString;
    IniDB := PromoStrToDB(dbPromo.FieldByName('P5').AsString);
    FinDB := PromoStrToDB(dbPromo.FieldByName('P6').AsString);
    DeleteSegundaUnidadRule(Art, IniDB, FinDB);
    dbPromo.Delete;
    ActualizarEstado;
  end;
end;

procedure TfPromociones.btnBuscarClick(Sender: TObject);
begin
  Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT A0, A1 FROM artitien'+Tienda+
                  ' WHERE A1 LIKE "%'+Edit2.Text+'%"', ['Código','Referencia'],'A0');
  if Edit1.Text='-1' then begin
     Edit1.Text:='';
     LimpiaPanel();
     Edit1.SetFocus;
  end else begin
      Edit1Exit(Edit1);
      Edit3.SetFocus;
  end;
end;

procedure TfPromociones.btnCancelarClick(Sender: TObject);
begin
  DesactivarPanel;
  Operacion:=' ';
end;

procedure TfPromociones.btnCrearClick(Sender: TObject);
begin
  Operacion:='A';
  FOldPromoArt := '';
  FOldPromoIni := '';
  FOldPromoFin := '';
  FOldPromoWasSegunda := False;
  LimpiaPanel();
  if chkSegundaUnd50<>nil then
    chkSegundaUnd50.Checked := False;
  PromoModeChanged(nil);
  ActivarPanel;
  Edit1.SetFocus;
end;

procedure TfPromociones.btnModificarClick(Sender: TObject);
begin
  if dbPromo.RecordCount=0 then exit;
  Operacion:='M';
  FOldPromoArt := dbPromo.FieldByName('P0').AsString;
  FOldPromoIni := PromoStrToDB(dbPromo.FieldByName('P5').AsString);
  FOldPromoFin := PromoStrToDB(dbPromo.FieldByName('P6').AsString);
  FOldPromoWasSegunda := HasSegundaUnidadRule(FOldPromoArt, FOldPromoIni, FOldPromoFin);
  Relleno();
  ActivarPanel;
  Edit1.SetFocus;
end;

procedure TfPromociones.Edit1Exit(Sender: TObject);
var
  CodReal: string;
begin
  if Edit1.Text='' then exit;
  if Edit3.Text<>Edit7.Text then exit;
  CodReal := ResolverCodigoArticulo(Edit1.Text);
  if CodReal <> '' then
    Edit1.Text := CodReal;

  if dbArti.Locate('A0', Edit1.Text, []) then begin
     Edit2.Text:=dbArti.FieldByName('A1').AsString;
     Edit3.Text:=FormatDateTime('DD/MM/YYYY',Date);
     Edit4.Text:=dbArti.FieldByName('A2').AsString;
     Edit5.Text:=dbArti.FieldByName('A24').AsString;
     Edit6.Text:=dbArti.FieldByName('A3').AsString;
     Edit7.Text:=FormatDateTime('DD/MM/YYYY',Date);
     Edit8.Text:=dbArti.FieldByName('A2').AsString;
     Edit9.Text:=dbArti.FieldByName('A24').AsString;
     Edit10.Text:=dbArti.FieldByName('A3').AsString;
     PromoModeChanged(nil);
     Edit3.SetFocus;
  end else begin
     ShowMessage('ARTICULO NO ENCONTRADO');
     Edit1.SetFocus;
  end;
end;

procedure TfPromociones.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then btnBuscarClick(Sender);
end;

procedure TfPromociones.LimpiaPanel();
begin
  Edit1.Text:='';   Edit2.Text:='';   Edit3.Text:='';
  Edit4.Text:='';   Edit5.Text:='';   Edit6.Text:='';
  Edit7.Text:='';   Edit8.Text:='';   Edit9.Text:='';
  Edit10.Text:='';
  if chkSegundaUnd50<>nil then
    chkSegundaUnd50.Checked := False;
  PromoModeChanged(nil);
end;

procedure TfPromociones.LlenaReg();
var
  D: TDateTime;
begin
  dbPromo.FieldByName('P0').AsString:=Edit1.Text;  //------ Codigo Articulo
  dbPromo.FieldByName('P1').AsString:=Edit2.Text;  //------ Descripcion
  dbPromo.FieldByName('P2').AsString:=Edit8.Text;  //------ PVP actual (para cuando acabe la oferta)
  dbPromo.FieldByName('P3').AsString:=Edit9.Text;  //------ PV Coste actual (para cuando se acabe la oferta)
  dbPromo.FieldByName('P4').AsString:=Edit10.Text; //------ IVA actual (para cuando se acabe la oferta)
  D := StrToDate(Edit3.Text);
  dbPromo.FieldByName('P5').AsDateTime:=Trunc(D);  //------ Fecha Inicio Oferta
  D := StrToDate(Edit7.Text);
  dbPromo.FieldByName('P6').AsDateTime:=Trunc(D);  //------ Fecha Fin Oferta
  // Aunque exista regla de 2ª unidad al 50%, mantenemos el PVP/coste/IVA
  // de oferta indicados por el usuario. Así se permite promoción doble:
  // precio rebajado + segunda unidad calculada sobre ese precio rebajado.
  dbPromo.FieldByName('P7').AsString:=Edit4.Text;  //------ PVP Oferta
  dbPromo.FieldByName('P8').AsString:=Edit5.Text;  //------ PV Coste Oferta
  dbPromo.FieldByName('P9').AsString:=Edit6.Text;  //------ IVA Oferta
  dbPromo.FieldByName('P10').AsString:='A';        //------ Inicialmente la Oferta está (A)ctiva

end;

procedure TfPromociones.Relleno();
var
  IniDB, FinDB: string;
begin
  if dbPromo.RecordCount=0 then exit;
  Edit1.Text:=dbPromo.FieldByName('P0').AsString;  //------ Codigo Articulo
  Edit2.Text:=dbPromo.FieldByName('P1').AsString;  //------ Descripcion
  Edit8.Text:=dbPromo.FieldByName('P2').AsString;  //------ PVP actual (para cuando acabe la oferta)
  Edit9.Text:=dbPromo.FieldByName('P3').AsString;  //------ PV Coste actual (para cuando se acabe la oferta)
  Edit10.Text:=dbPromo.FieldByName('P4').AsString; //------ IVA actual (para cuando se acabe la oferta)
  Edit3.Text:=PromoStrToUI(dbPromo.FieldByName('P5').AsString);  //------ Fecha Inicio Oferta
  Edit7.Text:=PromoStrToUI(dbPromo.FieldByName('P6').AsString);  //------ Fecha Fin Oferta
  Edit4.Text:=dbPromo.FieldByName('P7').AsString;  //------ PVP Oferta
  Edit5.Text:=dbPromo.FieldByName('P8').AsString;  //------ PV Coste Oferta
  Edit6.Text:=dbPromo.FieldByName('P9').AsString;  //------ IVA Oferta

  IniDB := PromoStrToDB(dbPromo.FieldByName('P5').AsString);
  FinDB := PromoStrToDB(dbPromo.FieldByName('P6').AsString);
  if chkSegundaUnd50<>nil then
    chkSegundaUnd50.Checked := HasSegundaUnidadRule(Edit1.Text, IniDB, FinDB);
  PromoModeChanged(nil);
end;

initialization
  {$I promociones.lrs}

end.
