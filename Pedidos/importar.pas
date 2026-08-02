{
  Gestion LinEx FacturLinEx

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  buFt WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit importar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math, db, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, Buttons, StdCtrls, Grids, ComCtrls, DBGrids, ZConnection,
  ZDataset, SynEdit, LCLType, LCLIntf, Gestionar
  {$IFDEF LCLGTK2}
  , gtk2, gdk2
  {$ENDIF}
  ;

type
     RLineaPedido = record
   //cada línea tendrá 3 integer indicarán la concordancia
   //de cada campo significativo entre el txt y la bd: CoinCod, CoinEan, CoinDes
                        //0 ausente en el txt,
                        //1 está en artitien
                        //2 está en eans
                        //3 dato del txt inexistente en la BD
     Codigo: string;     CoinCod: integer;
     CodigoEAN: string;  CoinEan: integer;
     Descripcion: string;CoinDes: integer;
     Unidades: string;
     Costo: string;
     IVA: string;
     PVP: string;
     Pos: integer; //Posición en el Array de líneas de Pedido
     //Familia: string;
     //Existecias: string;
   end;

  { TfImportar }

  TfImportar = class(TForm)
    BitBtn6: TBitBtn;
    BitBtnAceptarDatosBD: TBitBtn;
    BitBtnDAltaCod: TBitBtn;
    BitBtnAltaEan: TBitBtn;
    btnGenerar: TBitBtn;
    btnAPedido: TBitBtn;
    btnSeleccionar: TBitBtn;
    btnSalir: TBitBtn;
    cbCodtxtAEan: TCheckBox;
    dbPedidAux: TZQuery;
    dbPedicAux: TZQuery;
    dbTrabajo: TZQuery;
    dbArtiAux: TZQuery;
    dbEans: TZQuery;
    EditPenCodigo: TEdit;
    EditBDUnid: TEdit;
    EditPenEan: TEdit;
    EditPenNombre: TEdit;
    EditBDEan: TEdit;
    EditBDCodigo: TEdit;
    EditBDNombre: TEdit;
    eOCosto: TEdit;
    eODecCosto: TEdit;
    eODecPVP: TEdit;
    eODesCosto: TEdit;
    eODesPVP: TEdit;
    Label23: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    PanelEdicion: TPanel;
    sgDatos: TStringGrid;
    dbgProcesados: TStringGrid;
    dbgPendientes: TStringGrid;
    dsProcesados: TDatasource;
    dsPendientes: TDatasource;
    dbArti: TZQuery;
    eCodigoDesde: TEdit;
    eDelimitador: TEdit;
    eEANDesde: TEdit;
    eEANHasta: TEdit;
    eCodigoHasta: TEdit;
    eCostoDesde: TEdit;
    eCostoHasta: TEdit;
    eDecCostoDesde: TEdit;
    eDecCostoHasta: TEdit;
    eDecPVPDesde: TEdit;
    eDecPVPHasta: TEdit;
    eIVADesde: TEdit;
    eIVAHasta: TEdit;
    eNombreDesde: TEdit;
    eNombreHasta: TEdit;
    eOCodigo: TEdit;
    eOEAN: TEdit;
    eOIVA: TEdit;
    eONombre: TEdit;
    eOPVP: TEdit;
    eOUnidades: TEdit;
    ePos: TEdit;
    ePVPDesde: TEdit;
    ePVPHasta: TEdit;
    eUnidDesde: TEdit;
    eUnidHasta: TEdit;
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
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label3: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    LoadDialog: TOpenDialog;
    Panel3: TPanel;
    Panel4: TPanel;
    pc: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    SaveDialog: TSaveDialog;
    sbLimpiar2: TSpeedButton;
    sbLoad1: TSpeedButton;
    sbSave1: TSpeedButton;
    sbLimpiar1: TSpeedButton;
    SpeedButton1: TSpeedButton;
    sbSave2: TSpeedButton;
    sbLoad2: TSpeedButton;
    SynEdit1: TSynEdit;
    tsProcesados: TTabSheet;
    tsPendientes: TTabSheet;
    tsSeleccion: TTabSheet;
    tsDelimitado: TTabSheet;

    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtnAceptarDatosBDClick(Sender: TObject);
    procedure BitBtnDAltaCodClick(Sender: TObject);
    procedure BitBtnAltaEanClick(Sender: TObject);
    procedure btnAPedidoClick(Sender: TObject);
    procedure btnGenerarClick(Sender: TObject);
    procedure btnSalirClick(Sender: TObject);
    procedure btnSeleccionarClick(Sender: TObject);
    procedure dbgPendientesDblClick(Sender: TObject);
    procedure dbgProcesadosDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure eCodigoDesdeExit(Sender: TObject);
    procedure eCostoDesdeExit(Sender: TObject);
    procedure eCostoHastaExit(Sender: TObject);
    procedure eDecCostoDesdeExit(Sender: TObject);
    procedure eDecCostoHastaExit(Sender: TObject);
    procedure eDecPVPDesdeExit(Sender: TObject);
    procedure eDecPVPHastaExit(Sender: TObject);
    procedure eEANDesdeExit(Sender: TObject);
    procedure eIVADesdeExit(Sender: TObject);
    procedure eIVAHastaExit(Sender: TObject);
    procedure eNombreDesdeExit(Sender: TObject);
    procedure eOCostoExit(Sender: TObject);
    procedure eODesCostoExit(Sender: TObject);
    procedure eODesPVPExit(Sender: TObject);
    procedure eOIVAExit(Sender: TObject);
    procedure eOPVPExit(Sender: TObject);
    procedure eOUnidadesExit(Sender: TObject);
    procedure ePVPDesdeExit(Sender: TObject);
    procedure ePVPHastaExit(Sender: TObject);
    procedure eUnidDesdeExit(Sender: TObject);
    procedure eUnidHastaExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    //procedure FormCreate(Sender: TObject;FPedido: TFPedido);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridHeaderMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label72Click(Sender: TObject);
    procedure MostrarPosicion(Sender: TObject);
    procedure PanelEdicionClick(Sender: TObject);
    procedure sbLimpiar1Click(Sender: TObject);
    procedure sbLimpiar2Click(Sender: TObject);
    procedure sbLoad1Click(Sender: TObject);
    procedure sbLoad2Click(Sender: TObject);
    procedure sbSave2Click(Sender: TObject);
    procedure sgDatosDblClick(Sender: TObject);
    procedure sgDatosDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sbSave1Click(Sender: TObject);
    procedure eCodigoExit(Sender: TObject);
    procedure eEANExit(Sender: TObject);
    procedure eNombreExit(Sender: TObject);
    procedure eOCodigoExit(Sender: TObject);
    procedure eOEANExit(Sender: TObject);
    procedure eONombreExit(Sender: TObject);
    procedure SynEdit1Click(Sender: TObject);
    procedure TodoEnblanco1();
    procedure TodoEnblanco2();
    procedure Formatear();
    procedure FormatearExcel(const AFichero: string);
    procedure DistribuirLineasPedido(var ArrayDeLineasPedidoAux: array of RLineaPedido);
    procedure BuscarCoincidencias(var Linea: RLineaPedido);
    procedure CompletaLineaPedidoConBD(var Linea: RLineaPedido);
    procedure WriteLinea(const Linea: RLineaPedido);
    procedure tsPendientesEnter(Sender: TObject);
    procedure tsProcesadosEnter(Sender: TObject);
    procedure IniciaImportar(var dbPedid: TzQuery; dbPedic: TzQuery);
    procedure InsertarLinea(Linea: RLineaPedido; VerUltimaLinea: integer );
    procedure SumaPendientes(CodiPen, UniPen: String);
    function SeleccionarArticuloExistentePorDescripcion(const TextoBusqueda: string; out ACodigo, ANombre: string): Boolean;
    function SeleccionarArticuloSimilarOAltaNueva(const TextoBusqueda: string; out ACodigo, ANombre: string; out ACrearNuevo: Boolean): Boolean;
    function IntentarVincularArticuloSimilarAntesAlta(var Linea: RLineaPedido; const CodigoNuevo, NombreNuevo, EanNuevo: string): Boolean;
    function PrepararArticuloExistenteParaEan(var Linea: RLineaPedido): Boolean;
    procedure NuevoEan(const nuevoEan: string; var linea: RLineaPedido);

  private
    { Estado visual de la modernización. Los campos se declaran antes que los
      métodos para mantener compatibilidad con FPC 3.2.2. }
    FCabeceraPrincipal: TPanel;
    FTituloPrincipal: TLabel;
    FSubtituloPrincipal: TLabel;
    FSortColDatos: Integer;
    FSortColProcesados: Integer;
    FSortColPendientes: Integer;
    FSortAscDatos: Boolean;
    FSortAscProcesados: Boolean;
    FSortAscPendientes: Boolean;
    FMoviendoPanelEdicion: Boolean;
    FPanelEdicionMovidoPorUsuario: Boolean;
    FPanelEdicionDragOffset: TPoint;
    FPanelPasoSeleccionar: TPanel;
    FPanelPasoAnalizar: TPanel;
    FPanelPasoPedido: TPanel;
    FPanelPasoSalir: TPanel;
    FDescPasoSeleccionar: TLabel;
    FDescPasoAnalizar: TLabel;
    FDescPasoPedido: TLabel;
    FDescPasoSalir: TLabel;
    FLabelAyudaPosicion: TLabel;

    procedure CrearCabeceraPrincipal;
    procedure CrearPanelesAccionPrincipal;
    procedure CrearAyudaPosicion;
    procedure ConfigurarBotonesPlantilla;
    procedure AplicarEstiloModerno;
    procedure RecolocarControles;
    procedure ConfigurarStringGrid(AGrid: TStringGrid);
    procedure EstiloTitulo(ALabel: TLabel);
    procedure OrdenarStringGrid(AGrid: TStringGrid; ACol: Integer;
      var AColOrdenada: Integer; var AAscendente: Boolean);
    procedure MarcarColumnaOrdenada(AGrid: TStringGrid; ACol: Integer;
      AAscendente: Boolean);
    function CompararValoresGrid(const A, B: String): Integer;
    procedure DibujarCeldaGridLegible(AGrid: TStringGrid; ACol, ARow: Integer;
      ARect: TRect; AState: TGridDrawState);
    procedure AplicarContrasteSeleccion(AControl: TWinControl);
    procedure AplicarContrasteSeleccionControles(AParent: TWinControl);
    procedure PanelEdicionDragMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PanelEdicionDragMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure PanelEdicionDragMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LimitarPanelEdicionAlAreaVisible;
  public
    { public declarations }
    procedure LlenarLineaGrid(
      var gridDatos: TStringGrid;
      cont: integer;
      const Linea: RLineaPedido;
      var AnchuraColumnaCod: integer;
      var AnchuraColumnaEan: integer;
      var AnchuraColumnaDes: integer);
  end;

  procedure ShowFormImportar(dbPedid: TzQuery; dbPedic: TzQuery);

var
  fImportar: TfImportar;
  //dbPedidAux: TZQuery;
  ColorLineas: TColor;
  ArrayDeLineasPedido: array of RLineaPedido;
  ArrayDeLineasPedidoPen: array of RLineaPedido;
  ArrayDeLineasPedidoPro: array of RLineaPedido;
  AnchuraColumnaCod: integer;
  AnchuraColumnaEan: integer;
  AnchuraColumnaDes: integer;
  LineaSeleccionada: integer;
implementation

{ TfImportar }

uses
   Global, Funciones, Articulos, StrUtils, Zipper, DOM, XMLRead;


type
  TXLSXRow = array of string;
  TXLSXTable = array of TXLSXRow;
  TXLSXSharedStrings = array of string;

var
  // Se usa sólo como ayuda visual al preguntar IVA para artículos nuevos
  // cuando el fichero no trae IVA válido. No cambia la lógica de artículos existentes.
  FLX_UltimoIvaAltaNuevo: Double = 21.0;

function FLX_EsFicheroExcel(const AFichero: string): Boolean;
var
  Ext: string;
begin
  Ext := LowerCase(ExtractFileExt(AFichero));
  Result := (Ext = '.xls') or (Ext = '.xlsx');
end;

function FLX_EsFicheroXLSX(const AFichero: string): Boolean;
begin
  Result := LowerCase(ExtractFileExt(AFichero)) = '.xlsx';
end;

function FLX_NormalizaRutaXLSX(const S: string): string;
begin
  Result := StringReplace(S, '\\', '/', [rfReplaceAll]);
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
  Result := StringReplace(Result, ' ', '', [rfReplaceAll]);
end;

function FLX_NormalizaDescripcionImportada(const S: string): string;
var
  I: Integer;
  T: string;
begin
  Result := Trim(S);

  // Espacios raros/tabuladores a espacio normal.
  Result := StringReplace(Result, #9, ' ', [rfReplaceAll]);
  Result := StringReplace(Result, #160, ' ', [rfReplaceAll]);

  // Quitamos acentos y diéresis para evitar problemas en búsquedas/SQL/impresión.
  Result := StringReplace(Result, 'Á', 'A', [rfReplaceAll]);
  Result := StringReplace(Result, 'É', 'E', [rfReplaceAll]);
  Result := StringReplace(Result, 'Í', 'I', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ó', 'O', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ú', 'U', [rfReplaceAll]);
  Result := StringReplace(Result, 'À', 'A', [rfReplaceAll]);
  Result := StringReplace(Result, 'È', 'E', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ì', 'I', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ò', 'O', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ù', 'U', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ä', 'A', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ë', 'E', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ï', 'I', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ö', 'O', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ü', 'U', [rfReplaceAll]);

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
  Result := StringReplace(Result, 'ä', 'a', [rfReplaceAll]);
  Result := StringReplace(Result, 'ë', 'e', [rfReplaceAll]);
  Result := StringReplace(Result, 'ï', 'i', [rfReplaceAll]);
  Result := StringReplace(Result, 'ö', 'o', [rfReplaceAll]);
  Result := StringReplace(Result, 'ü', 'u', [rfReplaceAll]);

  // Ñ/ñ a N/n.
  Result := StringReplace(Result, 'Ñ', 'N', [rfReplaceAll]);
  Result := StringReplace(Result, 'ñ', 'n', [rfReplaceAll]);

  // Comillas simples/dobles rectas y tipográficas: se eliminan.
  Result := StringReplace(Result, '''', '', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '', [rfReplaceAll]);
  Result := StringReplace(Result, '´', '', [rfReplaceAll]);
  Result := StringReplace(Result, '`', '', [rfReplaceAll]);
  Result := StringReplace(Result, '’', '', [rfReplaceAll]);
  Result := StringReplace(Result, '‘', '', [rfReplaceAll]);
  Result := StringReplace(Result, '“', '', [rfReplaceAll]);
  Result := StringReplace(Result, '”', '', [rfReplaceAll]);

  // Por si algún proveedor/fichero llega con UTF-8 mal interpretado.
  Result := StringReplace(Result, 'ÃÁ', 'A', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ã‰', 'E', [rfReplaceAll]);
  Result := StringReplace(Result, 'ÃÍ', 'I', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ã“', 'O', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ãš', 'U', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ã¡', 'a', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ã©', 'e', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ã­', 'i', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ã³', 'o', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ãº', 'u', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ã¼', 'u', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ãœ', 'U', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ã‘', 'N', [rfReplaceAll]);
  Result := StringReplace(Result, 'Ã±', 'n', [rfReplaceAll]);

  // Bytes sueltos de TXT antiguos en codificación DOS/OEM CP437/CP850.
  // El caso visto en producción es ¥ = Ñ, que MySQL rechaza en utf8mb4.
  Result := StringReplace(Result, Chr(165), 'N', [rfReplaceAll]); // Ñ OEM / CP850
  Result := StringReplace(Result, Chr(164), 'n', [rfReplaceAll]); // ñ OEM / CP850
  Result := StringReplace(Result, Chr(181), 'A', [rfReplaceAll]); // Á OEM / CP850
  Result := StringReplace(Result, Chr(144), 'E', [rfReplaceAll]); // É OEM / CP850
  Result := StringReplace(Result, Chr(214), 'I', [rfReplaceAll]); // Í OEM / CP850
  Result := StringReplace(Result, Chr(224), 'O', [rfReplaceAll]); // Ó OEM / CP850
  Result := StringReplace(Result, Chr(233), 'U', [rfReplaceAll]); // Ú OEM / CP850
  Result := StringReplace(Result, Chr(130), 'e', [rfReplaceAll]); // é OEM / CP850
  Result := StringReplace(Result, Chr(161), 'i', [rfReplaceAll]); // í OEM / CP850
  Result := StringReplace(Result, Chr(162), 'o', [rfReplaceAll]); // ó OEM / CP850
  Result := StringReplace(Result, Chr(163), 'u', [rfReplaceAll]); // ú OEM / CP850
  Result := StringReplace(Result, Chr(129), 'u', [rfReplaceAll]); // ü OEM / CP850
  Result := StringReplace(Result, Chr(154), 'U', [rfReplaceAll]); // Ü OEM / CP850
  Result := StringReplace(Result, Chr(128), 'C', [rfReplaceAll]); // Ç OEM / CP850
  Result := StringReplace(Result, Chr(135), 'c', [rfReplaceAll]); // ç OEM / CP850

  // Limpieza final de seguridad para que ninguna descripción importada guarde
  // bytes no ASCII en artitien/eans. Evita errores tipo Incorrect string value.
  T := '';
  for I := 1 to Length(Result) do
  begin
    if (Ord(Result[I]) >= 32) and (Ord(Result[I]) <= 126) then
      T := T + Result[I]
    else if (Result[I] = #9) or (Result[I] = #10) or (Result[I] = #13) then
      T := T + ' ';
  end;
  Result := Trim(T);

  while Pos('  ', Result) > 0 do
    Result := StringReplace(Result, '  ', ' ', [rfReplaceAll]);
end;

function FLX_NormalizaTextoExcel(const S: string): string;
begin
  Result := FLX_NormalizaDescripcionImportada(S);
end;

function FLX_NormalizaDescripcionTXTImportada(const S: string): string;
begin
  Result := Trim(S);

  // Algunos TXT/CSV de proveedor llegan en ANSI/ISO-8859-1/Windows-1252.
  // Si ReadLn los carga como bytes sin convertir a UTF-8, los literales UTF-8
  // de FLX_NormalizaDescripcionImportada no siempre los alcanzan.
  // Por eso limpiamos también por código de byte antes de la normalización común.
  Result := StringReplace(Result, Chr(193), 'A', [rfReplaceAll]); // Á ANSI
  Result := StringReplace(Result, Chr(201), 'E', [rfReplaceAll]); // É ANSI
  Result := StringReplace(Result, Chr(205), 'I', [rfReplaceAll]); // Í ANSI
  Result := StringReplace(Result, Chr(211), 'O', [rfReplaceAll]); // Ó ANSI
  Result := StringReplace(Result, Chr(218), 'U', [rfReplaceAll]); // Ú ANSI
  Result := StringReplace(Result, Chr(192), 'A', [rfReplaceAll]); // À ANSI
  Result := StringReplace(Result, Chr(200), 'E', [rfReplaceAll]); // È ANSI
  Result := StringReplace(Result, Chr(204), 'I', [rfReplaceAll]); // Ì ANSI
  Result := StringReplace(Result, Chr(210), 'O', [rfReplaceAll]); // Ò ANSI
  Result := StringReplace(Result, Chr(217), 'U', [rfReplaceAll]); // Ù ANSI
  Result := StringReplace(Result, Chr(196), 'A', [rfReplaceAll]); // Ä ANSI
  Result := StringReplace(Result, Chr(203), 'E', [rfReplaceAll]); // Ë ANSI
  Result := StringReplace(Result, Chr(207), 'I', [rfReplaceAll]); // Ï ANSI
  Result := StringReplace(Result, Chr(214), 'O', [rfReplaceAll]); // Ö ANSI
  Result := StringReplace(Result, Chr(220), 'U', [rfReplaceAll]); // Ü ANSI

  Result := StringReplace(Result, Chr(225), 'a', [rfReplaceAll]); // á ANSI
  Result := StringReplace(Result, Chr(233), 'e', [rfReplaceAll]); // é ANSI
  Result := StringReplace(Result, Chr(237), 'i', [rfReplaceAll]); // í ANSI
  Result := StringReplace(Result, Chr(243), 'o', [rfReplaceAll]); // ó ANSI
  Result := StringReplace(Result, Chr(250), 'u', [rfReplaceAll]); // ú ANSI
  Result := StringReplace(Result, Chr(224), 'a', [rfReplaceAll]); // à ANSI
  Result := StringReplace(Result, Chr(232), 'e', [rfReplaceAll]); // è ANSI
  Result := StringReplace(Result, Chr(236), 'i', [rfReplaceAll]); // ì ANSI
  Result := StringReplace(Result, Chr(242), 'o', [rfReplaceAll]); // ò ANSI
  Result := StringReplace(Result, Chr(249), 'u', [rfReplaceAll]); // ù ANSI
  Result := StringReplace(Result, Chr(228), 'a', [rfReplaceAll]); // ä ANSI
  Result := StringReplace(Result, Chr(235), 'e', [rfReplaceAll]); // ë ANSI
  Result := StringReplace(Result, Chr(239), 'i', [rfReplaceAll]); // ï ANSI
  Result := StringReplace(Result, Chr(246), 'o', [rfReplaceAll]); // ö ANSI
  Result := StringReplace(Result, Chr(252), 'u', [rfReplaceAll]); // ü ANSI

  Result := StringReplace(Result, Chr(209), 'N', [rfReplaceAll]); // Ñ ANSI
  Result := StringReplace(Result, Chr(241), 'n', [rfReplaceAll]); // ñ ANSI

  // TXT en codificación DOS/OEM CP437/CP850: muy habitual en ficheros antiguos.
  // En esa codificación Ñ = #165 y ñ = #164, justo el ¥ que ha fallado.
  Result := StringReplace(Result, Chr(165), 'N', [rfReplaceAll]); // Ñ OEM / CP850
  Result := StringReplace(Result, Chr(164), 'n', [rfReplaceAll]); // ñ OEM / CP850
  Result := StringReplace(Result, Chr(181), 'A', [rfReplaceAll]); // Á OEM / CP850
  Result := StringReplace(Result, Chr(144), 'E', [rfReplaceAll]); // É OEM / CP850
  Result := StringReplace(Result, Chr(214), 'I', [rfReplaceAll]); // Í OEM / CP850
  Result := StringReplace(Result, Chr(224), 'O', [rfReplaceAll]); // Ó OEM / CP850
  Result := StringReplace(Result, Chr(233), 'U', [rfReplaceAll]); // Ú OEM / CP850
  Result := StringReplace(Result, Chr(160), 'a', [rfReplaceAll]); // á OEM / CP850
  Result := StringReplace(Result, Chr(130), 'e', [rfReplaceAll]); // é OEM / CP850
  Result := StringReplace(Result, Chr(161), 'i', [rfReplaceAll]); // í OEM / CP850
  Result := StringReplace(Result, Chr(162), 'o', [rfReplaceAll]); // ó OEM / CP850
  Result := StringReplace(Result, Chr(163), 'u', [rfReplaceAll]); // ú OEM / CP850
  Result := StringReplace(Result, Chr(129), 'u', [rfReplaceAll]); // ü OEM / CP850
  Result := StringReplace(Result, Chr(154), 'U', [rfReplaceAll]); // Ü OEM / CP850

  Result := StringReplace(Result, Chr(199), 'C', [rfReplaceAll]); // Ç ANSI
  Result := StringReplace(Result, Chr(231), 'c', [rfReplaceAll]); // ç ANSI

  // Comillas ANSI/Windows-1252 que suelen romper SQL o comparaciones.
  Result := StringReplace(Result, Chr(34), '', [rfReplaceAll]);  // "
  Result := StringReplace(Result, Chr(39), '', [rfReplaceAll]);  // '
  Result := StringReplace(Result, Chr(96), '', [rfReplaceAll]);  // `
  Result := StringReplace(Result, Chr(180), '', [rfReplaceAll]); // ´
  Result := StringReplace(Result, Chr(145), '', [rfReplaceAll]); // ‘ CP1252
  Result := StringReplace(Result, Chr(146), '', [rfReplaceAll]); // ’ CP1252
  Result := StringReplace(Result, Chr(147), '', [rfReplaceAll]); // “ CP1252
  Result := StringReplace(Result, Chr(148), '', [rfReplaceAll]); // ” CP1252

  Result := FLX_NormalizaDescripcionImportada(Result);
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


function FLX_SoloDigitos(const S: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(S) do
    if S[I] in ['0'..'9'] then
      Result := Result + S[I];
end;

function FLX_NormalizaEANImportado(const S, ACodigo, ADescripcion: string): string;
var
  Aux: string;
  R: Integer;
begin
  Result := Trim(S);
  Result := StringReplace(Result, ' ', '', [rfReplaceAll]);
  Result := StringReplace(Result, #160, '', [rfReplaceAll]);
  if Result = '' then Exit;

  // El EAN debe trabajarse como cadena de dígitos. Algunos Excel/TXT pueden traer
  // espacios, separadores o el valor con formato raro; dejamos sólo números.
  Aux := FLX_SoloDigitos(Result);
  if Aux = '' then
  begin
    Result := '';
    Exit;
  end;

  // Caso detectado en proveedor: EAN de 14 dígitos que realmente es 1 + EAN13.
  // Si tras el primer dígito viene 84, eliminamos automáticamente el primer dígito.
  while Length(Aux) > 13 do
  begin
    if Copy(Aux, 2, 2) = '84' then
    begin
      Delete(Aux, 1, 1);
      Continue;
    end;

    R := MessageDlg(
      'El fichero trae un EAN con más de 13 dígitos:' + LineEnding + LineEnding +
      'EAN leído: ' + Aux + LineEnding +
      'Código: ' + ACodigo + LineEnding +
      'Descripción: ' + ADescripcion + LineEnding + LineEnding +
      'FacturLinEx trabaja con EAN13.' + LineEnding + LineEnding +
      'Pulse SÍ para eliminar el PRIMER dígito.' + LineEnding +
      'Pulse NO para eliminar el ÚLTIMO dígito.' + LineEnding +
      'Pulse CANCELAR para dejar este EAN vacío y revisarlo manualmente.',
      mtConfirmation, [mbYes, mbNo, mbCancel], 0);

    if R = mrYes then
      Delete(Aux, 1, 1)
    else if R = mrNo then
      Delete(Aux, Length(Aux), 1)
    else
    begin
      Result := '';
      Exit;
    end;
  end;

  Result := Aux;
end;

function FLX_NormalizaNumeroExcel(const S: string): string;
var
  Sep: Char;
  PComa, PPunto: Integer;
begin
  Result := Trim(S);
  Result := StringReplace(Result, ' ', '', [rfReplaceAll]);
  Result := StringReplace(Result, #160, '', [rfReplaceAll]);
  if Result = '' then Exit;

  Sep := DefaultFormatSettings.DecimalSeparator;
  PComa := LastDelimiter(',', Result);
  PPunto := LastDelimiter('.', Result);

  if (PComa > 0) and (PPunto > 0) then
  begin
    // Si vienen ambos, consideramos decimal el separador de más a la derecha.
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

function FLX_StrToFloatDefSeguro(const S: string; const Defecto: Double): Double;
var
  Aux: string;
begin
  Aux := FLX_NormalizaNumeroExcel(S);
  if Aux = '' then
  begin
    Result := Defecto;
    Exit;
  end;

  if not TryStrToFloat(Aux, Result) then
    Result := Defecto;
end;


function FLX_CosteImportadoGestionable(const SCosto: string): Boolean;
begin
  // Si el proveedor envía coste vacío, nulo o 0, lo tratamos como obsequio.
  // No debe mostrarse en el importador, ni pasar a pendientes/procesados,
  // ni intentar darse de alta como artículo nuevo.
  Result := FLX_StrToFloatDefSeguro(SCosto, 0) > 0;
end;

function FLX_DescripcionEsCajaMixta(const S: string): Boolean;
var
  T, TCompacto: string;
begin
  T := UpperCase(FLX_NormalizaDescripcionImportada(S));
  T := StringReplace(T, '.', ' ', [rfReplaceAll]);
  T := StringReplace(T, ',', ' ', [rfReplaceAll]);
  T := StringReplace(T, '/', ' ', [rfReplaceAll]);
  T := StringReplace(T, '\', ' ', [rfReplaceAll]);
  T := StringReplace(T, '-', ' ', [rfReplaceAll]);
  T := StringReplace(T, '_', ' ', [rfReplaceAll]);
  while Pos('  ', T) > 0 do
    T := StringReplace(T, '  ', ' ', [rfReplaceAll]);
  T := Trim(T);

  TCompacto := StringReplace(T, ' ', '', [rfReplaceAll]);

  // C.MIXTA / C MIXTA / CMIXTA, CAJA MIXTA, LOTE MIXTO, PACK MIXTO, SURTIDO MIXTO...
  // Estas líneas no representan un artículo único, sino varios artículos independientes.
  Result :=
    (Pos('CMIXT', TCompacto) > 0) or
    ((Pos('MIXT', T) > 0) and
     ((Pos('CAJA', T) > 0) or
      (Pos('LOTE', T) > 0) or
      (Pos('PACK', T) > 0) or
      (Pos('SURTID', T) > 0)));
end;

procedure FLX_AnadirLineaMixta(ALista: TStringList; const AOrigen: string;
  const ANumLinea: Integer; const Linea: RLineaPedido);
begin
  if ALista = nil then Exit;

  ALista.Add(
    'Origen: ' + AOrigen +
    ' | Línea: ' + IntToStr(ANumLinea) +
    ' | Código: ' + Trim(Linea.Codigo) +
    ' | EAN: ' + Trim(Linea.CodigoEAN) +
    ' | Uds: ' + Trim(Linea.Unidades) +
    ' | Coste: ' + Trim(Linea.Costo) +
    ' | Descripción: ' + Trim(Linea.Descripcion)
  );
end;

function FLX_GuardarListadoLineasMixtas(const AFicheroOrigen: string;
  ALineas: TStringList): string;
var
  Ruta, Nombre: string;
begin
  Result := '';
  if (ALineas = nil) or (ALineas.Count = 0) then Exit;

  Nombre := 'lineas_mixtas_importacion_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.txt';
  Ruta := IncludeTrailingPathDelimiter(ExtractFilePath(AFicheroOrigen)) + Nombre;
  try
    ALineas.SaveToFile(Ruta);
    Result := Ruta;
  except
    Ruta := IncludeTrailingPathDelimiter(GetTempDir(False)) + Nombre;
    try
      ALineas.SaveToFile(Ruta);
      Result := Ruta;
    except
      Result := '';
    end;
  end;
end;

procedure FLX_AvisarLineasOmitidas(const ATitulo, AFicheroOrigen: string;
  const AOmitidasCosteCero, AOmitidasMixtas: Integer; ALineasMixtas: TStringList);
var
  Msg, RutaListado: string;
begin
  if (AOmitidasCosteCero <= 0) and (AOmitidasMixtas <= 0) then Exit;

  Msg := ATitulo + LineEnding + LineEnding;

  if AOmitidasCosteCero > 0 then
    Msg := Msg + 'Líneas omitidas por coste 0/vacío, tratadas como obsequio: ' +
           IntToStr(AOmitidasCosteCero) + LineEnding;

  if AOmitidasMixtas > 0 then
  begin
    RutaListado := FLX_GuardarListadoLineasMixtas(AFicheroOrigen, ALineasMixtas);
    Msg := Msg + 'Líneas omitidas por CAJA/LOTE/PACK MIXTO: ' +
           IntToStr(AOmitidasMixtas) + LineEnding;
    Msg := Msg + 'No se darán de alta ni se añadirán al pedido porque no representan un artículo único.' +
           LineEnding;

    if RutaListado <> '' then
      Msg := Msg + 'Se ha creado un listado para introducir su contenido a mano:' +
             LineEnding + RutaListado + LineEnding
    else
      Msg := Msg + 'No se ha podido crear el listado de líneas mixtas.' + LineEnding;
  end;

  ShowMessage(Msg);
end;

function FLX_SQLTexto(const S: string): string;
begin
  Result := Trim(S);
  Result := StringReplace(Result, '\', '\\', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '\"', [rfReplaceAll]);
end;

function FLX_TextoValidoEAN(const S: string): Boolean;
var
  Aux: string;
begin
  Aux := Trim(S);
  Result := (Aux <> '') and (Aux <> '0000000000000');
end;

function FLX_NormalizaParaSimilitud(const S: string): string;
var
  I: Integer;
  C: Char;
  T: string;
begin
  T:=UpperCase(FLX_NormalizaDescripcionImportada(S));
  Result:='';

  for I:=1 to Length(T) do
  begin
    C:=T[I];
    if (((C>='A') and (C<='Z')) or ((C>='0') and (C<='9'))) then
      Result:=Result+C
    else
      Result:=Result+' ';
  end;

  while Pos('  ', Result)>0 do
    Result:=StringReplace(Result, '  ', ' ', [rfReplaceAll]);
  Result:=Trim(Result);
end;

function FLX_PalabraUtilParaSimilitud(const S: string): Boolean;
var
  P: string;
begin
  P:=UpperCase(Trim(S));
  Result:=Length(P)>=3;
  if not Result then Exit;

  // Palabras muy comunes que no ayudan a distinguir artículos.
  if (P='CON') or (P='SIN') or (P='DEL') or (P='LOS') or
     (P='LAS') or (P='UNA') or (P='UNO') or (P='PAR') or
     (P='UND') or (P='UDS') or (P='UNID') or (P='PACK') then
    Result:=False;
end;

procedure FLX_ExtraerPalabrasSimilares(const S: string; Palabras: TStringList);
var
  I: Integer;
  T, P: string;
begin
  if Palabras=nil then Exit;
  Palabras.Clear;
  T:=FLX_NormalizaParaSimilitud(S);
  P:='';

  for I:=1 to Length(T) do
  begin
    if T[I]<>' ' then
      P:=P+T[I]
    else
    begin
      if FLX_PalabraUtilParaSimilitud(P) and (Palabras.IndexOf(P)<0) then
        Palabras.Add(P);
      P:='';
    end;
  end;

  if FLX_PalabraUtilParaSimilitud(P) and (Palabras.IndexOf(P)<0) then
    Palabras.Add(P);
end;

function FLX_ScoreDescripcionSimilar(const DescImportada, DescBD: string): Integer;
var
  Palabras: TStringList;
  I: Integer;
  P, TImp, TBD: string;
begin
  Result:=0;
  TImp:=FLX_NormalizaParaSimilitud(DescImportada);
  TBD:=FLX_NormalizaParaSimilitud(DescBD);

  if (TImp='') or (TBD='') then Exit;

  if TImp=TBD then
    Inc(Result, 500)
  else
  begin
    if Pos(TImp, TBD)>0 then Inc(Result, 180);
    if Pos(TBD, TImp)>0 then Inc(Result, 120);
  end;

  Palabras:=TStringList.Create;
  try
    FLX_ExtraerPalabrasSimilares(TImp, Palabras);
    for I:=0 to Palabras.Count-1 do
    begin
      P:=Palabras[I];
      if Pos(' '+P+' ', ' '+TBD+' ')>0 then
        Inc(Result, 30+(Length(P)*2))
      else if Pos(P, TBD)>0 then
        Inc(Result, 15+Length(P));

      if Copy(TBD, 1, Length(P))=P then
        Inc(Result, 10);
    end;
  finally
    Palabras.Free;
  end;
end;

procedure FLX_InsertarCandidatoSimilar(Codigos, Nombres, Lineas: TStringList;
  const Codigo, Nombre: string; const Score: Integer);
var
  I: Integer;
begin
  if (Codigos=nil) or (Nombres=nil) or (Lineas=nil) then Exit;
  if (Trim(Codigo)='') or (Trim(Nombre)='') then Exit;
  if Score<=0 then Exit;
  if Codigos.IndexOf(Codigo)>=0 then Exit;

  I:=0;
  while (I<Lineas.Count) and (StrToIntDef(Copy(Lineas[I],1,4),0)>=Score) do
    Inc(I);

  Codigos.Insert(I, Codigo);
  Nombres.Insert(I, Nombre);
  Lineas.Insert(I, Format('%.4d  %s  -  %s', [Score, Codigo, Nombre]));

  while Lineas.Count>25 do
  begin
    Lineas.Delete(Lineas.Count-1);
    Codigos.Delete(Codigos.Count-1);
    Nombres.Delete(Nombres.Count-1);
  end;
end;

function FLX_PedirIVAArticuloNuevo(const ACodigo, ANombre: string; var AIva: Double): Boolean;
var
  S: string;
  Prompt: string;
begin
  Result := False;
  AIva := 0;
  S := FloatToStr(FLX_UltimoIvaAltaNuevo);

  Prompt :=
    'El fichero no trae IVA válido para este artículo nuevo:' + LineEnding + LineEnding +
    'Código: ' + ACodigo + LineEnding +
    'Descripción: ' + ANombre + LineEnding + LineEnding +
    'Indique el IVA para esta línea (21, 10, 4, etc.):';

  repeat
    if not InputQuery('IVA artículo nuevo', Prompt, S) then
    begin
      ShowMessage('Alta de artículo cancelada. No se ha indicado IVA para esta línea.');
      Exit;
    end;

    AIva := FLX_StrToFloatDefSeguro(S, -1);
    if AIva > 0 then
    begin
      FLX_UltimoIvaAltaNuevo := AIva;
      Result := True;
      Exit;
    end;

    ShowMessage('IVA no válido. Indique un valor como 21, 10 o 4.');
    S := FloatToStr(FLX_UltimoIvaAltaNuevo);
  until False;
end;


function FLX_PedirCostoArticuloNuevo(const ACodigo, ANombre: string; var ACosto: Double): Boolean;
var
  S: string;
  Prompt: string;
begin
  Result := False;
  if ACosto > 0 then
    S := FloatToStr(ACosto)
  else
    S := '';

  Prompt :=
    'El fichero no trae coste válido para este artículo nuevo:' + LineEnding + LineEnding +
    'Código: ' + ACodigo + LineEnding +
    'Descripción: ' + ANombre + LineEnding + LineEnding +
    'Indique el coste sin IVA para esta línea:';

  repeat
    if not InputQuery('Coste artículo nuevo', Prompt, S) then Exit;

    ACosto := FLX_StrToFloatDefSeguro(S, -1);
    if ACosto > 0 then
    begin
      Result := True;
      Exit;
    end;

    ShowMessage('Coste no válido. Indique un importe mayor que 0.');
    S := '';
  until False;
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

function FLX_FilaDesdeReferenciaCelda(const Ref: string): Integer;
var
  I: Integer;
  Num: string;
begin
  Num := '';
  for I := 1 to Length(Ref) do
    if Ref[I] in ['0'..'9'] then
      Num := Num + Ref[I];

  if Num = '' then
    Result := -1
  else
    Result := StrToIntDef(Num, 0) - 1;
end;

function FLX_DirTemporalXLSX: string;
var
  Base: string;
begin
  Base := GetEnvironmentVariable('TMPDIR');
  if Base = '' then Base := '/tmp';
  Result := IncludeTrailingPathDelimiter(Base) +
            'flx_xlsx_' + FormatDateTime('yyyymmddhhnnsszzz', Now) + '_' + IntToStr(Random(1000000));
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

  // Números, fórmulas con valor cacheado, texto simple y booleanos.
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
  ColCod, ColDes, ColUni: Integer;
begin
  Result := -1;
  MaxFila := Length(ATabla) - 1;
  if MaxFila > 20 then MaxFila := 20;

  for R := 0 to MaxFila do
  begin
    ColCod := FLX_BuscarColumnaExcelEnFila(ATabla[R], ['Artículo', 'Articulo', 'Código', 'Codigo', 'Referencia']);
    ColDes := FLX_BuscarColumnaExcelEnFila(ATabla[R], ['Descripción', 'Descripcion', 'Nombre', 'Artículo descripción', 'Articulo descripcion']);
    ColUni := FLX_BuscarColumnaExcelEnFila(ATabla[R], ['Uds', 'Unidades', 'Cantidad', 'Cant']);

    if (ColCod >= 0) and (ColDes >= 0) and (ColUni >= 0) then
    begin
      Result := R;
      Exit;
    end;
  end;
end;

procedure TfImportar.WriteLinea(const Linea: RLineaPedido);
begin
    Write('Cod->');Write(linea.Codigo);
    Write(', EAN->');Write(linea.CodigoEAN);
    Write(', Nombre->');Write(linea.Descripcion);
    Write(', Vector->(');Write(linea.CoinCod);Write(',');Write(linea.CoinEan);Write(',');Write(linea.CoinDes);WriteLn(')');
end;
//==== COMPLETAR LAS LINEAS DE PEDIDO CON DATOS DE LA BD =====
// Una vez identificada la línea y sus coincidencias, si se decide procesarla,
// sus datos se completan o rectifican para que coincidan con los de la BD
procedure TfImportar.CompletaLineaPedidoConBD(var Linea: RLineaPedido);
begin
  if (Linea.CoinCod=2) then  // Cod.txt en Eans
     begin
      dbArtiAux.Active:=False;
      dbArtiAux.SQL.Text:='SELECT * FROM eans WHERE EAN0="'+Linea.Codigo+'"';
      dbArtiAux.Active:=True;
      //writelinea(linea);
      if dbArtiAux.RecordCount<>0 then
      begin
        //ShowMessage(dbArtiAux.SQL.Text);
        Linea.Codigo:=dbArtiAux.FieldByName('EAN1').AsString;
        Linea.CodigoEAN:=dbArtiAux.FieldByName('EAN0').AsString;
        Linea.CoinCod:=1; Linea.CoinEan:=2;
        //writelinea(linea);
        //ShowMessage('-----------'+dbArtiAux.SQL.Text);
      end;
      //Al cambiar el CoinCod a 1 el nombre se completará también
     end;
     if (Linea.CoinCod=1) then //Cod.txt en Artitien, me aseguro que el nombre sea el mismo
     begin
      dbArtiAux.Active:=False;
      dbArtiAux.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Linea.Codigo+'"';
      dbArtiAux.Active:=True;
      if dbArtiAux.RecordCount<>0 then
      begin
        //writelinea(linea);
        //ShowMessage('coincod=1 '+dbArtiAux.SQL.Text);
        Linea.Descripcion:=dbArtiAux.FieldByName('A1').AsString;
        Linea.CoinDes:=1;
      end;
     end;
end;

//=============== BUSCAR COINCIDENCIAS ===============
// Busca en la BD el código, el EAN y el nombre del artículo de
// de la línea de pedido, el resultado se almacena en el propio registro
procedure TfImportar.BuscarCoincidencias(var Linea: RLineaPedido);
var
  CodDesdeEan: string;
begin
  // Vector de coincidencias:
  // 0 = ausente en fichero
  // 1 = existe en artitien
  // 2 = existe en eans
  // 3 = viene en fichero pero no existe en BD
  // 4 = EAN 0000000000000
  // 5 = conflicto real entre código/EAN
  //
  // IMPORTANTE:
  // Antes se modificaba Linea.Codigo cuando el código interno existía pero el EAN
  // del proveedor era desconocido. Si el EAN no estaba en eans, CodDesdeEan quedaba
  // vacío y la línea acababa pareciendo "artículo nuevo", aunque el código ya existía.
  // Ahora BuscarCoincidencias solo clasifica; no machaca el código importado salvo
  // cuando el propio dato del código está localizado como auxiliar en eans.
  Linea.CoinCod:=0;
  Linea.CoinDes:=0;
  Linea.CoinEan:=0;
  CodDesdeEan:='';

  // --- EAN importado ---
  if Trim(Linea.CodigoEAN)<>'' then
  begin
    if Trim(Linea.CodigoEAN)='0000000000000' then
      Linea.CoinEan:=4
    else
    begin
      Linea.CoinEan:=3;

      dbEans.Active:=False;
      dbEans.SQL.Text:='SELECT * FROM eans WHERE EAN0="'+FLX_SQLTexto(Linea.CodigoEAN)+'" LIMIT 1';
      dbEans.Active:=True;
      if dbEans.RecordCount<>0 then
      begin
        Linea.CoinEan:=2;
        CodDesdeEan:=dbEans.FieldByName('EAN1').AsString;
      end
      else
      begin
        dbArti.Active:=False;
        dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+
                         ' WHERE A0="'+FLX_SQLTexto(Linea.CodigoEAN)+'" LIMIT 1';
        dbArti.Active:=True;
        if dbArti.RecordCount<>0 then
          Linea.CoinEan:=1;
      end;
    end;
  end;

  // --- Código importado ---
  if Trim(Linea.Codigo)<>'' then
  begin
    Linea.CoinCod:=3;

    dbArti.Active:=False;
    dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+
                     ' WHERE A0="'+FLX_SQLTexto(Linea.Codigo)+'" LIMIT 1';
    dbArti.Active:=True;
    if dbArti.RecordCount<>0 then
    begin
      Linea.CoinCod:=1;

      // Si el EAN ya existe pero apunta a otro código interno, marcamos conflicto real.
      // No sustituimos Linea.Codigo por un valor vacío ni por el otro código, porque eso
      // impide luego añadir el EAN al artículo correcto o aceptar la ficha manualmente.
      // Si el EAN apunta a otro código, no marcamos el código como nuevo.
      // Conservamos CoinCod=1 para que la pantalla lo trate como artículo existente
      // y el usuario pueda revisar/decidir sin que aparezca como alta nueva.
      // La existencia del EAN se conserva en CoinEan=2.
    end
    else
    begin
      dbEans.Active:=False;
      dbEans.SQL.Text:='SELECT * FROM eans WHERE EAN0="'+FLX_SQLTexto(Linea.Codigo)+'" LIMIT 1';
      dbEans.Active:=True;
      if dbEans.RecordCount<>0 then
        Linea.CoinCod:=2;
    end;
  end;

  // --- Descripción importada ---
  if Trim(Linea.Descripcion)<>'' then
  begin
    Linea.CoinDes:=3;

    dbArti.Active:=False;
    dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+
                     ' WHERE TRIM(A1)="'+FLX_SQLTexto(Linea.Descripcion)+'" LIMIT 1';
    dbArti.Active:=True;
    if dbArti.RecordCount<>0 then
      Linea.CoinDes:=1
    else
    begin
      dbEans.Active:=False;
      dbEans.SQL.Text:='SELECT * FROM eans WHERE TRIM(EAN2)="'+FLX_SQLTexto(Linea.Descripcion)+'" LIMIT 1';
      dbEans.Active:=True;
      if dbEans.RecordCount<>0 then
        Linea.CoinDes:=2;
    end;
  end;
end;

procedure TfImportar.tsPendientesEnter(Sender: TObject);
begin
  dbgPendientes.Repaint;
end;

procedure TfImportar.tsProcesadosEnter(Sender: TObject);
begin
  dbgProcesados.Repaint;
end;

//=============== LLENAR LINEA DE GRID ===============
//Una vez comprobada la línea de pedido en la DB la pasamos al Grid

procedure TfImportar.LlenarLineaGrid(
  var gridDatos: TStringGrid;
  cont: integer;
  const Linea: RLineaPedido;
  var AnchuraColumnaCod: integer;
  var AnchuraColumnaEan: integer;
  var AnchuraColumnaDes: integer);
begin
  //Write('Conta=');Write(conta);WriteLn(linea.Pos);
  gridDatos.RowCount:= cont + 1; //Añade una fila, la primera es la cabecera
  //Guarda en el grid la posicion que ocupa la linea en el arraydelineaspedido
  gridDatos.Cells[7, cont]:=intTostr(linea.Pos);
  if (linea.Codigo<>'') then begin
       if (AnchuraColumnaCod<length(linea.Codigo)) then AnchuraColumnaCod:=length(
         linea.Codigo);
{ //-- Comprobación de Cambio de colorido
         case linea.CoinCod of
            0: ColorLineas:=clRed;
            1: ColorLineas:=clBlack;
            2: ColorLineas:=clRed;
            3: ColorLineas:=clRed;
            4: ColorLineas:=clGreen;
            5: ColorLineas:=clYellow;
       end;
}
       //--gridDatos.Canvas.Brush.Color:= ColorLineas;
//-- Pruebas       if Linea.CoinCod=5 then ColorLineas:=clYellow else ColorLineas:=clBlack;
//-- Pruebas       gridDatos.Canvas.Font.Color := ColorLineas;

       //for Font.Color
{
       Canvas.Font.Color := clYellow;
       Canvas.TextRect( Rect, Rect.Left+2, Rect.Top+2, Cells[acol, arow]);
}
       //Explicación de INTERNET


       //Write('En LlenarLineaGrid '+linea.Codigo+'CoincidenciaCodigo-->'); Write(linea.CoinCod); Write('---');
       gridDatos.ColWidths[1]:=AnchuraColumnaCod*9;
       gridDatos.Cells[1, cont]:=linea.Codigo;
    end;
    if (linea.CodigoEAN<>'') then begin
        if (AnchuraColumnaEan<length(linea.CodigoEan)) then AnchuraColumnaEan:=length(
          linea.CodigoEan);
{
        case linea.CoinEan of
             0: ColorLineas:=clRed;
             1: ColorLineas:=clBlack;
             2: ColorLineas:=clRed;
             3: ColorLineas:=clRed;
             4: ColorLineas:=clGreen;
             5: ColorLineas:=clYellow;
        end;
        gridDatos.Canvas.Font.Color:= ColorLineas;
}
        //Write(linea.CodigoEan+'CoincidenciaEAN-->'); Write(linea.CoinEan); Write('---');
        gridDatos.ColWidths[0]:=AnchuraColumnaEan*9;
        gridDatos.Cells[0, cont]:=linea.CodigoEan;
    end;
    if (linea.Descripcion <> '') then begin
         if (AnchuraColumnaDes<length(linea.Descripcion)) then AnchuraColumnaDes:=
           length(linea.Descripcion);
{
         case linea.CoinDes of
              0: ColorLineas:=clRed;
              1: ColorLineas:=clBlack;
              2: ColorLineas:=clRed;
              3: ColorLineas:=clRed;
              4: ColorLineas:=clGreen;
              5: ColorLineas:=clYellow;
         end;
         gridDatos.Canvas.Font.Color:= ColorLineas;
}
         //Write(linea.Descripcion+'CoincidenciaDescripcion-->'); WriteLn(linea.CoinDes);
         gridDatos.ColWidths[2]:=AnchuraColumnaDes*9;
         gridDatos.Cells[2, cont]:=linea.Descripcion;
    end;
    if (linea.Unidades <> '') then gridDatos.Cells[3, cont]:=linea.Unidades;
    if (linea.Costo <> '') then gridDatos.Cells[4, cont]:=linea.Costo;
    if (linea.IVA <> '') then gridDatos.Cells[5, cont]:=linea.IVA;
    if (linea.PVP <> '') then gridDatos.Cells[6, cont]:=linea.PVP;

end;


//=============== FORMATEAR EXCEL / XLSX ======================
//Lee directamente ficheros XLSX del proveedor y rellena el mismo
//ArrayDeLineasPedido que usa el importador de TXT/CSV.
//IMPORTANTE: Linea.PVP se deja vacío a propósito para mantener la lógica actual:
//el PVP se tomará de la ficha del artículo en InsertarLinea().
procedure TfImportar.FormatearExcel(const AFichero: string);
var
  TempDir, HojaRelativa: string;
  Shared: TXLSXSharedStrings;
  Tabla: TXLSXTable;
  FilaCabecera, R: Integer;
  ColCodigo, ColEAN, ColDescripcion, ColUnidades, ColCosto, ColIVA: Integer;
  Cont, OmitidasCosteCero, OmitidasMixtas: Integer;
  Linea: RLineaPedido;
  LineasMixtas: TStringList;
begin
  SetLength(ArrayDeLineasPedido, 0);
  SetLength(ArrayDeLineasPedidoPen, 0);
  SetLength(ArrayDeLineasPedidoPro, 0);

  sgDatos.RowCount := 1;
  dbgPendientes.RowCount := 1;
  dbgProcesados.RowCount := 1;

  if not FLX_EsFicheroXLSX(AFichero) then
  begin
    ShowMessage('Sin instalar librerías externas, esta versión sólo puede leer ficheros .XLSX.' + #13 +
                'El formato .XLS antiguo es binario y necesita conversión o librería específica.');
    Exit;
  end;

  if not FileExists(AFichero) then
  begin
    ShowMessage('No existe el fichero Excel seleccionado.');
    Exit;
  end;

  LineasMixtas := TStringList.Create;

  TempDir := '';
  Randomize;
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
        ShowMessage('No se ha podido leer el fichero XLSX:' + #13 + AFichero + #13 + #13 + E.Message);
        Exit;
      end;
    end;

    FilaCabecera := FLX_BuscarFilaCabeceraExcel(Tabla);
    if FilaCabecera < 0 then
    begin
      ShowMessage('No se han encontrado las cabeceras esperadas en el XLSX.' + #13 +
                  'Se necesitan, como mínimo: Artículo, Descripción y Uds.');
      Exit;
    end;

    ColCodigo      := FLX_BuscarColumnaExcelEnFila(Tabla[FilaCabecera], ['Artículo', 'Articulo', 'Código', 'Codigo', 'Referencia']);
    ColDescripcion := FLX_BuscarColumnaExcelEnFila(Tabla[FilaCabecera], ['Descripción', 'Descripcion', 'Nombre', 'Artículo descripción', 'Articulo descripcion']);
    ColUnidades    := FLX_BuscarColumnaExcelEnFila(Tabla[FilaCabecera], ['Uds', 'Unidades', 'Cantidad', 'Cant']);
    ColCosto       := FLX_BuscarColumnaExcelEnFila(Tabla[FilaCabecera], ['Precio Neto', 'Precio neto', 'Coste', 'Costo', 'Precio coste', 'Precio costo']);
    ColEAN         := FLX_BuscarColumnaExcelEnFila(Tabla[FilaCabecera], ['Ean', 'EAN', 'Código EAN', 'Codigo EAN', 'Código de barras', 'Codigo de barras']);
    ColIVA         := FLX_BuscarColumnaExcelEnFila(Tabla[FilaCabecera], ['Iva', 'IVA', '% IVA', 'Tipo IVA']);

    if (ColCodigo < 0) or (ColDescripcion < 0) or (ColUnidades < 0) then
    begin
      ShowMessage('Faltan columnas obligatorias en el XLSX.' + #13 +
                  'Columnas obligatorias: Artículo, Descripción y Uds.');
      Exit;
    end;

    Cont := 1;
    OmitidasCosteCero := 0;
    OmitidasMixtas := 0;
    AnchuraColumnaEan := 0;
    AnchuraColumnaDes := 0;
    AnchuraColumnaCod := 0;

    for R := FilaCabecera + 1 to Length(Tabla) - 1 do
    begin
      Linea.CoinCod := 0;
      Linea.CoinEan := 0;
      Linea.CoinDes := 0;
      Linea.Codigo := '';
      Linea.CodigoEAN := '';
      Linea.Descripcion := '';
      Linea.Unidades := '';
      Linea.Costo := '';
      Linea.IVA := '';
      Linea.PVP := '';

      if ColCodigo >= 0 then
        Linea.Codigo := FLX_NormalizaCodigoExcel(FLX_CeldaTabla(Tabla, R, ColCodigo), True);

      if ColEAN >= 0 then
        Linea.CodigoEAN := FLX_NormalizaCodigoExcel(FLX_CeldaTabla(Tabla, R, ColEAN), False);

      if ColDescripcion >= 0 then
        Linea.Descripcion := FLX_NormalizaTextoExcel(FLX_CeldaTabla(Tabla, R, ColDescripcion));

      if Linea.CodigoEAN <> '' then
        Linea.CodigoEAN := FLX_NormalizaEANImportado(Linea.CodigoEAN, Linea.Codigo, Linea.Descripcion);

      if ColUnidades >= 0 then
        Linea.Unidades := FLX_NormalizaNumeroExcel(FLX_CeldaTabla(Tabla, R, ColUnidades));

      if ColCosto >= 0 then
        Linea.Costo := FLX_NormalizaNumeroExcel(FLX_CeldaTabla(Tabla, R, ColCosto));

      if ColIVA >= 0 then
        Linea.IVA := FLX_NormalizaNumeroExcel(FLX_CeldaTabla(Tabla, R, ColIVA));

      // NO cargamos Precio con Iva del proveedor en Linea.PVP.
      // Linea.PVP debe quedar vacío para que InsertarLinea use A2 de artitien.
      Linea.PVP := '';

      if (Linea.Codigo = '') and (Linea.CodigoEAN = '') and (Linea.Descripcion = '') then
        Continue;

      if FLX_DescripcionEsCajaMixta(Linea.Descripcion) then
      begin
        Inc(OmitidasMixtas);
        FLX_AnadirLineaMixta(LineasMixtas, 'XLSX', R + 1, Linea);
        Continue;
      end;

      if not FLX_CosteImportadoGestionable(Linea.Costo) then
      begin
        Inc(OmitidasCosteCero);
        Continue;
      end;

      Linea.Pos := Cont;
      BuscarCoincidencias(Linea);
      SetLength(ArrayDeLineasPedido, Cont);
      ArrayDeLineasPedido[Cont - 1] := Linea;
      LlenarLineaGrid(sgDatos, Cont, Linea, AnchuraColumnaCod, AnchuraColumnaEan, AnchuraColumnaDes);
      Inc(Cont);
    end;

    if Cont = 1 then
      ShowMessage('No se ha importado ninguna línea gestionable del XLSX.')
    else
      ShowMessage('XLSX leído correctamente. Líneas importadas: ' + IntToStr(Cont - 1));

    FLX_AvisarLineasOmitidas('Resumen de líneas omitidas del XLSX', AFichero,
      OmitidasCosteCero, OmitidasMixtas, LineasMixtas);
  finally
    LineasMixtas.Free;
    SetLength(Shared, 0);
    SetLength(Tabla, 0);
    if (TempDir <> '') and DirectoryExists(TempDir) then
    begin
      try
        DeleteDirectory(TempDir, False);
      except
        // Si no se pudiera borrar la carpeta temporal, no interrumpimos la importación.
      end;
    end;
  end;
end;

//=============== FORMATEAR ==========================
//Según el fichero importado esté delimitado por caracteres (,) o por
//dimensiones fijas, obtiene el valor de los campos y los mete en variables dentro
// del registro línea de pedido
procedure TfImportar.Formatear();
var
  Linea: RLineaPedido;

  PosFin: integer;
  PosIni: integer;
  contdel: integer;
  cont: integer;
  NumLineaFichero: integer;
  OmitidasCosteCero: integer;
  OmitidasMixtas: integer;
  LineasMixtas: TStringList;
  F: TextFile;
  TxtTEMP: String;
  Txt: String;
  FicheroTXT: String;
begin
    FicheroTXT:=OpenDialog1.FileName;

    if FLX_EsFicheroExcel(FicheroTXT) then
    begin
      FormatearExcel(FicheroTXT);
      btnGenerar.Enabled:=True;
      Exit;
    end;

    if Memo1.Lines.Count=0 then begin
       ShowMessage('DEBE SELECCIONAR EL FICHERO DE TEXTO A IMPORTAR');
       btnGenerar.Enabled:=False;
       abort;
    end;
    btnGenerar.Enabled:=True;
    LineasMixtas := TStringList.Create;
    AssignFile(F,FicheroTXT);
    Reset(F);

    try

    if pc.ActivePage=tsSeleccion then begin   // Activada la pestaña de Selección de Posiciones
       cont:=1;
       NumLineaFichero:=0;
       OmitidasCosteCero:=0;
       OmitidasMixtas:=0;
       AnchuraColumnaEan:=0; AnchuraColumnaDes:=0; AnchuraColumnaCod:=0;

       while not EOF(F) do begin
             Readln(F,Txt);
             Inc(NumLineaFichero);
             if length(txt)=0 then Continue; //Si la línea está en blanco, salta. La de EOF está en blanco.
             //sgDatos.RowCount:= cont + 1; //Añade una fila, la primera es la cabecera
             linea.CoinCod:=0; linea.CoinEan:=0; linea.CoinDes:=0;
             // Se inicializa a 0 => No encontrado, cualquier otro valor se obtendrá en el flujo
             linea.Codigo:='';linea.CodigoEAN:='';linea.Descripcion:='';linea.Unidades:='';linea.Costo:='';linea.IVA:='';linea.PVP:='';
             //Todos los valores vacios

             // Extraemos los datos requeridos de la linea cargada
             // Comprobamos que los campos no están en blanco para evitar errores

             if length(txt)=0 then Continue; //Si la línea está en blanco, salta. La de EOF está en blanco.
             // Extraemos los datos requeridos de la linea cargada
             // Comprobamos que los campos no están en blanco para evitar errores

             if ((eCodigoDesde.Text<>'') and (eCodigoHasta.Text<>'')) then
               begin
                linea.Codigo:=copy(Txt,StrToInt(eCodigoDesde.Text),StrToInt(eCodigoHasta.Text)-StrToInt(eCodigoDesde.Text)+1);
                //--- INTENTO ELIMINAR EL 0 A LA IZQUIERDA DEL CÓDIGO PRINCIPAL
                while linea.Codigo[1]='0' do delete(linea.Codigo, 1, 1);
               end;

             if ((eEANDesde.Text<>'') and (eEANHasta.Text<>'')) then
                linea.CodigoEAN:= copy(Txt,StrToInt(eEANDesde.Text),StrToInt(eEANHasta.Text)-StrToInt(eEANDesde.Text)+1);

             if ((eNombreDesde.Text<>'') and (eNombreHasta.Text<>'')) then
                linea.Descripcion:=FLX_NormalizaDescripcionTXTImportada(copy(Txt,StrToInt(eNombreDesde.Text),StrToInt(eNombreHasta.Text)-StrToInt(eNombreDesde.Text)+1));

             if ((eUnidDesde.Text<>'') and (eUnidHasta.Text<>'')) then
                linea.Unidades:=copy(Txt,StrToInt(eUnidDesde.Text),StrToInt(eUnidHasta.Text)-StrToInt(eUnidDesde.Text)+1);

             if ((eCostoDesde.Text<>'') and (eCostoHasta.Text<>'') and (eDecCostoDesde.Text<>'') and (eDecCostoHasta.Text<>'')) then
                linea.Costo:=copy(Txt,StrToInt(eCostoDesde.Text),StrToInt(eCostoHasta.Text)-StrToInt(eCostoDesde.Text)+1)+'.'+
                copy(Txt,StrToInt(eDecCostoDesde.Text),StrToInt(eDecCostoHasta.Text)-StrToInt(eDecCostoDesde.Text)+1);

             if ((eIVADesde.Text<>'') and (eIVAHasta.Text<>'')) then
                linea.IVA:=copy(Txt,StrToInt(eIVADesde.Text),StrToInt(eIVAHasta.Text)-StrToInt(eIVADesde.Text)+1);

             if ((ePVPDesde.Text<>'') and (ePVPHasta.Text<>'') and (eDecPVPDesde.Text<>'') and (eDecPVPHasta.Text<>'')) then
                linea.PVP:=copy(Txt,StrToInt(ePVPDesde.Text),StrToInt(ePVPHasta.Text)-StrToInt(ePVPDesde.Text)+1)+'.'+
                copy(Txt,StrToInt(eDecPVPDesde.Text),StrToInt(eDecPVPHasta.Text)-StrToInt(eDecPVPDesde.Text)+1);

             linea.Descripcion:=FLX_NormalizaDescripcionTXTImportada(linea.Descripcion);

             if linea.CodigoEAN <> '' then
                linea.CodigoEAN:=FLX_NormalizaEANImportado(linea.CodigoEAN, linea.Codigo, linea.Descripcion);

             if FLX_DescripcionEsCajaMixta(linea.Descripcion) then
             begin
                Inc(OmitidasMixtas);
                FLX_AnadirLineaMixta(LineasMixtas, 'TXT/CSV', NumLineaFichero, linea);
                Continue;
             end;

             if not FLX_CosteImportadoGestionable(linea.Costo) then
             begin
                Inc(OmitidasCosteCero);
                Continue;
             end;

             linea.Pos:=cont;// Guarda la posicion del array en el registro
             BuscarCoincidencias(Linea);
             SetLength(ArrayDeLineasPedido, cont); // Redimensiona el vector al tamaño del contador(líneas contadas)
             ArrayDeLineasPedido[cont-1]:=linea;//Empieza a contar desde 0 y cont se inicializa en 1
             LlenarLineaGrid(sgDatos, cont, Linea, AnchuraColumnaCod, AnchuraColumnaEan, AnchuraColumnaDes);
             cont:=cont+1;
       end;
       CloseFile(F);
    end
    else begin    // Activada la pestaña de Delimitado por Comas
    //if pc.ActivePage=tsDelimitado then begin   // Activada la pestaña de Delimitado por caracteres

       if eDelimitador.Text='' then begin
          ShowMessage('DEBE INDICAR EL CARACTER DELIMITADOR');
          abort;
       end;
       cont:=1;
       NumLineaFichero:=0;
       OmitidasCosteCero:=0;
       OmitidasMixtas:=0;
       AnchuraColumnaEan:=0; AnchuraColumnaDes:=0; AnchuraColumnaCod:=0;

       while not EOF(F) do begin
             Readln(F,Txt);
             Inc(NumLineaFichero);
             if length(txt)=0 then Continue; //Si la línea está en blanco, salta. La de EOF está en blanco.
             //sgDatos.RowCount:= cont + 1; //Añade una fila, la primera es la cabecera
             linea.CoinCod:=0; linea.CoinEan:=0; linea.CoinDes:=0;
             // Se inicializa a 0 => No encontrado, cualquier otro valor se obtendrá en el flujo
             linea.Codigo:='';linea.CodigoEAN:='';linea.Descripcion:='';linea.Unidades:='';linea.Costo:='';linea.IVA:='';linea.PVP:='';
             //Todos los valores vacios

             // Extraemos los datos requeridos de la linea cargada
             // Comprobamos que los campos no están en blanco para evitar errores

             TxtTemp:=Txt;   // Necesitamos una variable temporal porque hay que recargarla para cada valor
             if (eOCodigo.Text<>'') then begin
                if eOCodigo.Text='1' then begin
                   PosIni:=1
                end else begin
                   for contdel:=1 to (StrToInt(eOCodigo.Text)-1) do begin
                       PosIni:=Pos(eDelimitador.Text,TxtTemp);
                       Delete(TxtTemp,1,PosIni);
                   end;
                end;
                PosFin:=Pos(eDelimitador.Text,TxtTemp);
                linea.Codigo:=copy(TxtTemp,1,PosFin-1);
                //--- INTENTO ELIMINAR EL 0 A LA IZQUIERDA DEL CÓDIGO PRINCIPAL
                while linea.Codigo[1]='0' do delete(linea.Codigo, 1, 1);

             end;

             TxtTemp:=Txt;
             if (eOEAN.Text<>'') then begin
                if eOEAN.Text='1' then begin
                   PosIni:=1
                end else begin
                   for contdel:=1 to (StrToInt(eOEAN.Text)-1) do begin
                       PosIni:=Pos(eDelimitador.Text,TxtTemp);
                       Delete(TxtTemp,1,PosIni);     // Borramos todo el texto anterior que ya hemos revisado
                   end;
                end;
                PosFin:=Pos(eDelimitador.Text,TxtTemp);
                linea.CodigoEAN:=copy(TxtTemp,1,PosFin-1);
             end;
             TxtTemp:=Txt;
             if (eONombre.Text<>'') then begin
                if eONombre.Text='1' then begin
                   PosIni:=1
                end else begin
                   for contdel:=1 to (StrToInt(eONombre.Text)-1) do begin
                       PosIni:=Pos(eDelimitador.Text,TxtTemp);
                       Delete(TxtTemp,1,PosIni);
                   end;
                end;
                PosFin:=Pos(eDelimitador.Text,TxtTemp);
                linea.Descripcion:=FLX_NormalizaDescripcionTXTImportada(copy(TxtTemp,1,PosFin-1));
             end;
             TxtTemp:=Txt;
             if (eOUnidades.Text<>'') then begin
                if eOUnidades.Text='1' then begin
                   PosIni:=1
                end else begin
                   for contdel:=1 to (StrToInt(eOUnidades.Text)-1) do begin
                       PosIni:=Pos(eDelimitador.Text,TxtTemp);
                       Delete(TxtTemp,1,PosIni);
                   end;
                end;
                PosFin:=Pos(eDelimitador.Text,TxtTemp);
                linea.Unidades:=copy(TxtTemp,1,PosFin-1);
             end;
             TxtTemp:=Txt;
             if ((eOCosto.Text<>'')and(eODecCosto.Text<>'')) then begin
                if eOCosto.Text='1' then begin
                   PosIni:=1
                end else begin
                   for contdel:=1 to (StrToInt(eOCosto.Text)-1) do begin
                       PosIni:=Pos(eDelimitador.Text,TxtTemp);
                       Delete(TxtTemp,1,PosIni);
                   end;
                end;
                PosFin:=Pos(eDelimitador.Text,TxtTemp);
                linea.Costo:=copy(TxtTemp,1,PosFin-1);
             end;
             TxtTemp:=Txt;
             if ((eOCosto.Text<>'')and(eODecCosto.Text<>'')) then begin
                if eODecCosto.Text='1' then begin
                   PosIni:=1
                end else begin
                   for contdel:=1 to (StrToInt(eODecCosto.Text)-1) do begin
                       PosIni:=Pos(eDelimitador.Text,TxtTemp);
                       Delete(TxtTemp,1,PosIni);
                   end;
                end;
                PosFin:=Pos(eDelimitador.Text,TxtTemp);
                linea.Costo:=linea.Costo+','+copy(TxtTemp,1,PosFin-1);
             end;
             TxtTemp:=Txt;
             if (eOIVA.Text<>'') then begin
                if eOIVA.Text='1' then begin
                   PosIni:=1
                end else begin
                   for contdel:=1 to (StrToInt(eOIVA.Text)-1) do begin
                       PosIni:=Pos(eDelimitador.Text,TxtTemp);
                       Delete(TxtTemp,1,PosIni);
                   end;
                end;
                PosFin:=Pos(eDelimitador.Text,TxtTemp);
                linea.IVA:=copy(TxtTemp,1,PosFin-1);
             end;
             TxtTemp:=Txt;
             if ((eOPVP.Text<>'')and(eODecPVP.Text<>'')) then begin
                if eOPVP.Text='1' then begin
                   PosIni:=1
                end else begin
                   for contdel:=1 to (StrToInt(eOPVP.Text)-1) do begin
                       PosIni:=Pos(eDelimitador.Text,TxtTemp);
                       Delete(TxtTemp,1,PosIni);
                   end;
                end;
                PosFin:=Pos(eDelimitador.Text,TxtTemp);
                linea.PVP:=copy(TxtTemp,1,PosFin-1);
             end;
             TxtTemp:=Txt;
             if ((eOPVP.Text<>'')and(eODecPVP.Text<>'')) then begin
                if eODecPVP.Text='1' then begin
                   PosIni:=1
                end else begin
                   for contdel:=1 to (StrToInt(eODecPVP.Text)-1) do begin
                       PosIni:=Pos(eDelimitador.Text,TxtTemp);
                       Delete(TxtTemp,1,PosIni);
                   end;
                end;
                PosFin:=Pos(eDelimitador.Text,TxtTemp);
                linea.PVP:=linea.PVP+'.'+copy(TxtTemp,1,PosFin-1);
             end;
             linea.Descripcion:=FLX_NormalizaDescripcionTXTImportada(linea.Descripcion);

             if linea.CodigoEAN <> '' then
                linea.CodigoEAN:=FLX_NormalizaEANImportado(linea.CodigoEAN, linea.Codigo, linea.Descripcion);

             if FLX_DescripcionEsCajaMixta(linea.Descripcion) then
             begin
                Inc(OmitidasMixtas);
                FLX_AnadirLineaMixta(LineasMixtas, 'TXT/CSV', NumLineaFichero, linea);
                Continue;
             end;

             if not FLX_CosteImportadoGestionable(linea.Costo) then
             begin
                Inc(OmitidasCosteCero);
                Continue;
             end;

             linea.Pos:=cont;// Guarda la posicion del array en el registro
             BuscarCoincidencias(Linea);
             SetLength(ArrayDeLineasPedido, cont); // Redimensiona el vector al tamaño del contador(líneas contadas)
             ArrayDeLineasPedido[cont-1]:=linea;//Empieza a contar desde 0 y cont se inicializa en 1
             LlenarLineaGrid(sgDatos, cont, Linea, AnchuraColumnaCod, AnchuraColumnaEan, AnchuraColumnaDes);
             //Write(cont);WriteLn('Llenando array EAN->'+linea.CodigoEAN);
             cont:=cont+1;
       end;
       CloseFile(F);
    end;

    FLX_AvisarLineasOmitidas('Resumen de líneas omitidas del TXT/CSV', FicheroTXT,
      OmitidasCosteCero, OmitidasMixtas, LineasMixtas);

    finally
      LineasMixtas.Free;
    end;
end;

//=============== DISTRIBUIR LINEAS DEL PEDIDO ==========================
//Una vez identificadas las líneas del Pedido, se clasifican según se hayan
// identificado los artículos implicados, esto lo hacemos trabajando con las
// coincidencias obtenidad en BuscarCoincidencias
procedure TfImportar.DistribuirLineasPedido(var ArrayDeLineasPedidoAux: array of RLineaPedido);
var
  cont: integer;
  dimPen: integer; dimPro: integer;
begin
  //Vaciamos las grid
  dbgProcesados.RowCount:=1;
  dbgPendientes.RowCount:=1;
  //Ponemos los arrays de destino en dimensión 0
  SetLength(ArrayDeLineasPedidoPen, 0);
  SetLength(ArrayDeLineasPedidoPro, 0);
  //writeln(Length(ArrayDeLineasPedidoAux)-1);
  for cont:=0 to Length(ArrayDeLineasPedidoAux)-1 do
  begin
  //WriteLn('Dentro de distribuir:');
  //WriteLinea(ArrayDeLineasPedidoAux[cont]);

    ////Los if han sido obtenidos analizando los casos de uso en tablas aparte
    //// Directamente a la tabla de procesados si tienen Nombre conocido y Ean conocido,
    //// o NO tiene ean pero SI Código conocido (Si tiene ean desconocido queda pendiente)
    //if (
    //((ArrayDeLineasPedidoAux[cont].CoinDes=1) OR (ArrayDeLineasPedidoAux[cont].CoinDes=2)) AND
    //   ((ArrayDeLineasPedidoAux[cont].CoinEan=2) OR
    //   ((ArrayDeLineasPedidoAux[cont].CoinEan=0) AND (ArrayDeLineasPedidoAux[cont].CoinCod=1)))) then

    // Si tienen algún 3, no van a procesados, hay al menos un dato desconocido que hay que mirar,
    // del resto, los que tengan al menos dos coincidencias (1/2) iran a la tabla de procesados como
    // articulos conocidos. Si le falta Nombre o Codigo se autocompletará
    if (
         ( not
               (
                 (ArrayDeLineasPedidoAux[cont].CoinCod=3) OR
                 (ArrayDeLineasPedidoAux[cont].CoinCod=5) OR
                 //-- (ArrayDeLineasPedidoAux[cont].CoinDes=3) OR
                 (ArrayDeLineasPedidoAux[cont].CoinEan=3)
               )
         ) AND
         (
           ((ArrayDeLineasPedidoAux[cont].CoinCod<>0) AND (ArrayDeLineasPedidoAux[cont].CoinEan<>0)) OR
           ((ArrayDeLineasPedidoAux[cont].CoinCod<>0) AND (ArrayDeLineasPedidoAux[cont].CoinDes<>0)) OR
           ((ArrayDeLineasPedidoAux[cont].CoinEan<>0) AND (ArrayDeLineasPedidoAux[cont].CoinDes<>0))
         )
       ) then
      begin
       //ShowMessage(inttostr(cont)+'en procesados');
      //Antes de guardarla nos aseguramos que todos los datos son completos y correctos
       //writelinea(ArrayDeLineasPedidoAux[cont]);
      CompletaLineaPedidoConBD(ArrayDeLineasPedidoAux[cont]);
      //writelinea(ArrayDeLineasPedidoAux[cont]);
      dimPro:= Length(ArrayDeLineasPedidoPro);
      SetLength(ArrayDeLineasPedidoPro, dimPro+1);
      ArrayDeLineasPedidoPro[dimPro]:=ArrayDeLineasPedidoAux[cont];
      LlenarLineaGrid(dbgProcesados, dimPro+1, ArrayDeLineasPedidoAux[cont], AnchuraColumnaCod, AnchuraColumnaEan, AnchuraColumnaDes);
    end
    //todo lo demás está pendiente
    else
    begin
    //ShowMessage(inttostr(cont)+'en pendientes');
      dimPen:= Length(ArrayDeLineasPedidoPen);
      SetLength(ArrayDeLineasPedidoPen, dimPen+1);
      ArrayDeLineasPedidoPen[dimPen]:=ArrayDeLineasPedidoAux[cont];
      LlenarLineaGrid(dbgPendientes, dimPen+1, ArrayDeLineasPedidoAux[cont], AnchuraColumnaCod, AnchuraColumnaEan, AnchuraColumnaDes);
      //-- Falta colorear las lineas según me interese


    end;
  end;
end;
//================== TODO EN BLANCO ===========================
procedure TfImportar.TodoEnblanco1();
begin
  eEANDesde.Text:='';  eEANHasta.Text:='';
  eCodigoDesde.Text:='';  eCodigoHasta.Text:='';
  eNombreDesde.Text:='';  eNombreHasta.Text:='';
  eUnidDesde.Text:='';  eUnidHasta.Text:='';
  eCostoDesde.Text:='';  eCostoHasta.Text:='';
  eDecCostoDesde.Text:='';  eDecCostoHasta.Text:='';
  eIVADesde.Text:='';  eIVAHasta.Text:='';
  ePVPDesde.Text:='';  ePVPHasta.Text:='';
  eDecPVPDesde.Text:='';  eDecPVPHasta.Text:='';
  SynEdit1.Text:='';
  Memo1.Clear;
  btnGenerar.Enabled:=False;
  Panel2.Enabled:=false;
  Panel4.Enabled:=false;
  tsProcesados.Enabled:=false;
  tsPendientes.Enabled:=false;
  sgDatos.Clear;
end;
procedure TfImportar.TodoEnBlanco2();
begin
  eDelimitador.Text:=',';
  eOEAN.Text:='';
  eOCodigo.Text:='';
  eONombre.Text:='';
  eOUnidades.Text:='';
  eOIVA.Text:='';
  eOCosto.Text:='';
  eOPVP.Text:='';
  SynEdit1.Text:='';
  Memo1.Clear;
  btnGenerar.Enabled:=False;
  Panel2.Enabled:=false;
  Panel4.Enabled:=false;
  tsProcesados.Enabled:=false;
  tsPendientes.Enabled:=false;
  sgDatos.Clear;
end;

procedure TfImportar.PanelEdicionClick(Sender: TObject);
begin

end;

procedure TfImportar.sbLimpiar1Click(Sender: TObject);
begin
 TodoEnblanco1();
end;

procedure TfImportar.sbLimpiar2Click(Sender: TObject);
begin
 TodoEnblanco2();
end;

procedure TfImportar.sbLoad1Click(Sender: TObject);
var
  F: TextFile;
  Txt: String;
begin
  LoadDialog.DefaultExt:='.selp';   // selp = Fichero de Selección de Posiciones
  LoadDialog.Filter:='Selección de Posiciones (*.selp)|*.selp';
  LoadDialog.InitialDir:=RutaSql+'selecciones';
  if LoadDialog.Execute then begin
     AssignFile(F,LoadDialog.FileName);
     Reset(F);
                      // Usamos IntToStr(StrToInt( )) para eliminar los CEROS. Lo ideal sería una función en *f_cadenas.pas* para eliminar un carácter de una cadena. *** PARA HACER ***.
     ReadLn(F,Txt);
     eEANDesde.Text:=IntToStr(StrToInt(Copy(Txt,12,5)));  eEANHasta.Text:=IntToStr(StrToInt(Copy(Txt,18,5)));
     if ((eEANDesde.Text='0') OR (eEANHasta.Text='0')) then begin eEANDesde.Text:=''; eEANHasta.Text:=''; end;
     ReadLn(F,Txt);
     eCodigoDesde.Text:=IntToStr(StrToInt(Copy(Txt,12,5)));  eCodigoHasta.Text:=IntToStr(StrToInt(Copy(Txt,18,5)));
     if ((eCodigoDesde.Text='0') OR (eCodigoHasta.Text='0')) then begin eCodigoDesde.Text:=''; eCodigoHasta.Text:=''; end;
     ReadLn(F,Txt);
     eNombreDesde.Text:=IntToStr(StrToInt(Copy(Txt,12,5)));  eNombreHasta.Text:=IntToStr(StrToInt(Copy(Txt,18,5)));
     if ((eNombreDesde.Text='0') OR (eNombreHasta.Text='0')) then begin eNombreDesde.Text:=''; eNombreHasta.Text:=''; end;
     ReadLn(F,Txt);
     eUnidDesde.Text:=IntToStr(StrToInt(Copy(Txt,12,5)));  eUnidHasta.Text:=IntToStr(StrToInt(Copy(Txt,18,5)));
     if ((eUnidDesde.Text='0') OR (eUnidHasta.Text='0')) then begin eUnidDesde.Text:=''; eUnidHasta.Text:=''; end;
     ReadLn(F,Txt);
     eCostoDesde.Text:=IntToStr(StrToInt(Copy(Txt,12,5)));  eCostoHasta.Text:=IntToStr(StrToInt(Copy(Txt,18,5)));
     if ((eCostoDesde.Text='0') OR (eCostoHasta.Text='0')) then begin eCostoDesde.Text:=''; eCostoHasta.Text:=''; end;
     ReadLn(F,Txt);
     eDecCostoDesde.Text:=IntToStr(StrToInt(Copy(Txt,12,5)));  eDecCostoHasta.Text:=IntToStr(StrToInt(Copy(Txt,18,5)));
     if ((eDecCostoDesde.Text='0') OR (eDecCostoHasta.Text='0')) then begin eDecCostoDesde.Text:=''; eDecCostoHasta.Text:=''; end;
     ReadLn(F,Txt);
     eIVADesde.Text:=IntToStr(StrToInt(Copy(Txt,12,5)));  eIVAHasta.Text:=IntToStr(StrToInt(Copy(Txt,18,5)));
     if ((eIVADesde.Text='0') OR (eIVAHasta.Text='0')) then begin eIVADesde.Text:=''; eIVAHasta.Text:=''; end;
     ReadLn(F,Txt);
     ePVPDesde.Text:=IntToStr(StrToInt(Copy(Txt,12,5)));  ePVPHasta.Text:=IntToStr(StrToInt(Copy(Txt,18,5)));
     if ((ePVPDesde.Text='0') OR (ePVPHasta.Text='0')) then begin ePVPDesde.Text:=''; ePVPHasta.Text:=''; end;
     ReadLn(F,Txt);
     eDecPVPDesde.Text:=IntToStr(StrToInt(Copy(Txt,12,5)));  eDecPVPHasta.Text:=IntToStr(StrToInt(Copy(Txt,18,5)));
     if ((eDecPVPDesde.Text='0') OR (eDecPVPHasta.Text='0')) then begin eDecPVPDesde.Text:=''; eDecPVPHasta.Text:=''; end;
     CloseFile(F);
  end;
  Formatear();
end;

procedure TfImportar.sbLoad2Click(Sender: TObject);
var
  F: TextFile;
  Txt: String;
begin
  LoadDialog.DefaultExt:='.seld';   // selp = Fichero de Selección Delimitado por Comas
  LoadDialog.Filter:='Selección Delimitado por Comas (*.seld)|*.seld';
  LoadDialog.InitialDir:=RutaSql+'selecciones';
  if LoadDialog.Execute then begin
     AssignFile(F,LoadDialog.FileName);
     Reset(F);
                      // Usamos IntToStr(StrToInt( )) para eliminar los CEROS. Lo ideal sería una función en *f_cadenas.pas* para eliminar un carácter de una cadena. *** PARA HACER ***.
     ReadLn(F,Txt); eDelimitador.Text:=Copy(Txt,13,1);
     ReadLn(F,Txt); eOEAN.Text:=IntToStr(StrToInt(Copy(Txt,13,2)));
     ReadLn(F,Txt); eOCodigo.Text:=IntToStr(StrToInt(Copy(Txt,13,2)));
     ReadLn(F,Txt); eONombre.Text:=IntToStr(StrToInt(Copy(Txt,13,2)));
     ReadLn(F,Txt); eOUnidades.Text:=IntToStr(StrToInt(Copy(Txt,13,2)));
     ReadLn(F,Txt); eOIVA.Text:=IntToStr(StrToInt(Copy(Txt,13,2)));
     ReadLn(F,Txt); eOCosto.Text:=IntToStr(StrToInt(Copy(Txt,13,2)));
     ReadLn(F,Txt); eOPVP.Text:=IntToStr(StrToInt(Copy(Txt,13,2)));
     CloseFile(F);
  end;
  Formatear();
end;

procedure TfImportar.sbSave2Click(Sender: TObject);
var
  F: TFileStream;
  s: String;
begin
  SaveDialog.DefaultExt:='.seld';   // seld = Fichero de Selección Delimitado por Comas
  SaveDialog.Filter:='Selección Delimitado por Comas (*.seld)|*.seld';
  SaveDialog.InitialDir:=RutaSql+'selecciones';
  if SaveDialog.Execute then begin
     if FileExists(SaveDialog.FileName) then
        begin
          if Application.MessageBox('¡EL FICHERO DE SELECCION YA EXISTE!' +
            #13 + '¿DESEA REEMPLAZARLO?', 'FacturLinEx',
            MB_ICONQUESTION + MB_YESNO) = idYes then
            DeleteFile(SaveDialog.FileName)
          else
            abort;
        end;
     F := TFileStream.Create(SaveDialog.FileName, fmCreate);
     s := 'DELIMITADOR=' + eDelimitador.Text + #13 + #10;  F.Write(s[1],Length(s));
     s := 'EAN        =' + DataModule1.lFill(eOEAN.Text,2,'0') + #13 + #10;  F.Write(s[1],Length(s));
     s := 'CODIGO     =' + DataModule1.lFill(eoCodigo.Text,2,'0') + #13 + #10;  F.Write(s[1],Length(s));
     s := 'NOMBRE     =' + DataModule1.lFill(eONombre.Text,2,'0') + #13 + #10;  F.Write(s[1],Length(s));
     s := 'UNIDADES   =' + DataModule1.lFill(eOUnidades.Text,2,'0') + #13 + #10;  F.Write(s[1],Length(s));
     s := 'IVA        =' + DataModule1.lFill(eOIVA.Text,2,'0') + #13 + #10;  F.Write(s[1],Length(s));
     s := 'COSTO      =' + DataModule1.lFill(eOCosto.Text,2,'0') + #13 + #10;  F.Write(s[1],Length(s));
     s := 'PRECIO PVP =' + DataModule1.lFill(eOPVP.Text,2,'0') + #13 + #10;  F.Write(s[1],Length(s));
     F.Free;
  end;
end;

procedure TfImportar.sgDatosDblClick(Sender: TObject);
begin
  ShowFormArticulos();
end;

procedure TfImportar.sgDatosDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
  DibujarCeldaGridLegible(sgDatos,aCol,aRow,aRect,aState);
end;

procedure TfImportar.sbSave1Click(Sender: TObject);
var
  F: TFileStream;
  s: String;
begin
  SaveDialog.DefaultExt:='.selp';   // selp = Fichero de Selección de Posiciones
  SaveDialog.Filter:='Selección de Posiciones (*.selp)|*.selp';
  SaveDialog.InitialDir:=RutaSql+'selecciones';
  if SaveDialog.Execute then begin
     if FileExists(SaveDialog.FileName) then
        begin
          if Application.MessageBox('¡EL FICHERO DE SELECCION YA EXISTE!' +
            #13 + '¿DESEA REEMPLAZARLO?', 'FacturLinEx',
            MB_ICONQUESTION + MB_YESNO) = idYes then
            DeleteFile(SaveDialog.FileName)
          else
            abort;
        end;
     //F := TFileStream.Create(SaveDialog.FileName, fmCreate);
     //s := 'EAN       =' + DataModule1.lFill(eEANDesde.Text,5,'0') + ' ' + DataModule1.lFill(eEANHasta.Text,5,'0') + #13 + #10;  F.Write(s[1],Length(s));
     //s := 'CODIGO    =' + DataModule1.lFill(eCodigoDesde.Text,5,'0') + ' ' + DataModule1.lFill(eCodigoHasta.Text,5,'0') + #13 + #10;  F.Write(s[1],Length(s));
     //s := 'NOMBRE    =' + DataModule1.lFill(eNombreDesde.Text,5,'0') + ' ' + DataModule1.lFill(eNombreHasta.Text,5,'0') + #13 + #10;  F.Write(s[1],Length(s));
     //s := 'UNIDADES  =' + DataModule1.lFill(eUnidDesde.Text,5,'0') + ' ' + DataModule1.lFill(eUnidHasta.Text,5,'0') + #13 + #10;  F.Write(s[1],Length(s));
     //s := 'COSTO     =' + DataModule1.lFill(eCostoDesde.Text,5,'0') + ' ' + DataModule1.lFill(eCostoHasta.Text,5,'0') + #13 + #10;  F.Write(s[1],Length(s));
     //s := 'DEC. COSTO=' + DataModule1.lFill(eDecCostoDesde.Text,5,'0') + ' ' + DataModule1.lFill(eDecCostoHasta.Text,5,'0') + #13 + #10;  F.Write(s[1],Length(s));
     //s := 'IVA       =' + DataModule1.lFill(eIVADesde.Text,5,'0') + ' ' + DataModule1.lFill(eIVAHasta.Text,5,'0') + #13 + #10;  F.Write(s[1],Length(s));
     //s := 'PRECIO PVP=' + DataModule1.lFill(ePVPDesde.Text,5,'0') + ' ' + DataModule1.lFill(ePVPHasta.Text,5,'0') + #13 + #10;  F.Write(s[1],Length(s));
     //s := 'DEC. PVP  =' + DataModule1.lFill(eDecPVPDesde.Text,5,'0') + ' ' + DataModule1.lFill(eDecPVPHasta.Text,5,'0') + #13 + #10;  F.Write(s[1],Length(s));
     F := TFileStream.Create(SaveDialog.FileName, fmCreate);
     s := 'EAN       =' + DataModule1.lFill(eEANDesde.Text,5,'0') + ' ' + DataModule1.lFill(eEANHasta.Text,5,'0') + #13 + #10;  F.Write(s[1],Length(s));
     s := 'CODIGO    =' + DataModule1.lFill(eCodigoDesde.Text,5,'0') + ' ' + DataModule1.lFill(eCodigoHasta.Text,5,'0') + #13 + #10;  F.Write(s[1],Length(s));
     s := 'NOMBRE    =' + DataModule1.lFill(eNombreDesde.Text,5,'0') + ' ' + DataModule1.lFill(eNombreHasta.Text,5,'0') + #13 + #10;  F.Write(s[1],Length(s));
     s := 'UNIDADES  =' + DataModule1.lFill(eUnidDesde.Text,5,'0') + ' ' + DataModule1.lFill(eUnidHasta.Text,5,'0') + #13 + #10;  F.Write(s[1],Length(s));
     s := 'COSTO     =' + DataModule1.lFill(eCostoDesde.Text,5,'0') + ' ' + DataModule1.lFill(eCostoHasta.Text,5,'0') + #13 + #10;  F.Write(s[1],Length(s));
     s := 'DEC. COSTO=' + DataModule1.lFill(eDecCostoDesde.Text,5,'0') + ' ' + DataModule1.lFill(eDecCostoHasta.Text,5,'0') + #13 + #10;  F.Write(s[1],Length(s));
     s := 'IVA       =' + DataModule1.lFill(eIVADesde.Text,5,'0') + ' ' + DataModule1.lFill(eIVAHasta.Text,5,'0') + #13 + #10;  F.Write(s[1],Length(s));
     s := 'PRECIO PVP=' + DataModule1.lFill(ePVPDesde.Text,5,'0') + ' ' + DataModule1.lFill(ePVPHasta.Text,5,'0') + #13 + #10;  F.Write(s[1],Length(s));
     s := 'DEC. PVP  =' + DataModule1.lFill(eDecPVPDesde.Text,5,'0') + ' ' + DataModule1.lFill(eDecPVPHasta.Text,5,'0') + #13 + #10;  F.Write(s[1],Length(s));
     F.Free;
  end;
end;

function TfImportar.SeleccionarArticuloExistentePorDescripcion(const TextoBusqueda: string; out ACodigo, ANombre: string): Boolean;
var
  Busqueda: string;
  FormSel: TForm;
  Lista: TListBox;
  BtnOK, BtnCancel: TButton;
  Codigos, Nombres: TStringList;
  Num: Integer;
begin
  Result:=False;
  ACodigo:='';
  ANombre:='';
  Busqueda:=Trim(TextoBusqueda);

  repeat
    if Busqueda='' then
      Busqueda:=Trim(EditPenNombre.Text);

    if not InputQuery(
      'Buscar artículo existente',
      'Indique parte de la descripción o código del artículo existente:' + LineEnding + LineEnding +
      'Línea importada: ' + Trim(EditPenNombre.Text),
      Busqueda) then Exit;

    Busqueda:=Trim(Busqueda);
    if Busqueda='' then
    begin
      ShowMessage('Debe indicar un texto para buscar.');
      Continue;
    end;

    dbArti.Active:=False;
    dbArti.SQL.Text:=
      'SELECT A0,A1 FROM artitien'+Tienda+
      ' WHERE A1 LIKE "%'+FLX_SQLTexto(Busqueda)+'%"'+
      ' OR A0 LIKE "%'+FLX_SQLTexto(Busqueda)+'%"'+
      ' ORDER BY A1 LIMIT 50';
    dbArti.Active:=True;

    if dbArti.RecordCount=0 then
    begin
      if MessageDlg(
           'No se ha encontrado ningún artículo con:' + LineEnding + LineEnding +
           Busqueda + LineEnding + LineEnding +
           '¿Desea realizar otra búsqueda?',
           mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
      Continue;
    end;

    if dbArti.RecordCount=1 then
    begin
      ACodigo:=dbArti.FieldByName('A0').AsString;
      ANombre:=dbArti.FieldByName('A1').AsString;
      if MessageDlg(
           'Se ha encontrado este artículo:' + LineEnding + LineEnding +
           ACodigo + ' - ' + ANombre + LineEnding + LineEnding +
           '¿Usarlo para añadir el código auxiliar?',
           mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        Result:=True;
        Exit;
      end;
      Continue;
    end;

    Codigos:=TStringList.Create;
    Nombres:=TStringList.Create;
    FormSel:=TForm.Create(Self);
    try
      FormSel.Caption:='Seleccione artículo existente';
      FormSel.Position:=poScreenCenter;
      FormSel.BorderStyle:=bsDialog;
      FormSel.Width:=760;
      FormSel.Height:=420;

      Lista:=TListBox.Create(FormSel);
      Lista.Parent:=FormSel;
      Lista.Left:=8;
      Lista.Top:=8;
      Lista.Width:=FormSel.ClientWidth-16;
      Lista.Height:=FormSel.ClientHeight-56;
      Lista.Anchors:=[akLeft, akTop, akRight, akBottom];

      BtnOK:=TButton.Create(FormSel);
      BtnOK.Parent:=FormSel;
      BtnOK.Caption:='Aceptar';
      BtnOK.ModalResult:=mrOk;
      BtnOK.Left:=FormSel.ClientWidth-180;
      BtnOK.Top:=FormSel.ClientHeight-40;
      BtnOK.Width:=80;
      BtnOK.Anchors:=[akRight, akBottom];

      BtnCancel:=TButton.Create(FormSel);
      BtnCancel.Parent:=FormSel;
      BtnCancel.Caption:='Cancelar';
      BtnCancel.ModalResult:=mrCancel;
      BtnCancel.Left:=FormSel.ClientWidth-92;
      BtnCancel.Top:=FormSel.ClientHeight-40;
      BtnCancel.Width:=84;
      BtnCancel.Anchors:=[akRight, akBottom];

      dbArti.First;
      while not dbArti.EOF do
      begin
        Codigos.Add(dbArti.FieldByName('A0').AsString);
        Nombres.Add(dbArti.FieldByName('A1').AsString);
        Lista.Items.Add(dbArti.FieldByName('A0').AsString + '  -  ' + dbArti.FieldByName('A1').AsString);
        dbArti.Next;
      end;
      if Lista.Items.Count>0 then Lista.ItemIndex:=0;

      if FormSel.ShowModal=mrOk then
      begin
        Num:=Lista.ItemIndex;
        if (Num>=0) and (Num<Codigos.Count) then
        begin
          ACodigo:=Codigos[Num];
          ANombre:=Nombres[Num];
          Result:=True;
          Exit;
        end;
      end
      else
        Exit;
    finally
      FormSel.Free;
      Codigos.Free;
      Nombres.Free;
    end;
  until False;
end;

function TfImportar.SeleccionarArticuloSimilarOAltaNueva(const TextoBusqueda: string; out ACodigo, ANombre: string; out ACrearNuevo: Boolean): Boolean;
var
  FormSel: TForm;
  Lista: TListBox;
  LInfo: TLabel;
  BtnUsar, BtnNuevo, BtnCancel: TButton;
  Codigos, Nombres, Lineas, Palabras: TStringList;
  Condicion, Busqueda: string;
  I, Modal: Integer;
  Score: Integer;
begin
  Result:=False;
  ACodigo:='';
  ANombre:='';
  ACrearNuevo:=False;
  Busqueda:=Trim(TextoBusqueda);

  if Busqueda='' then
  begin
    ACrearNuevo:=True;
    Result:=True;
    Exit;
  end;

  Codigos:=TStringList.Create;
  Nombres:=TStringList.Create;
  Lineas:=TStringList.Create;
  Palabras:=TStringList.Create;
  try
    FLX_ExtraerPalabrasSimilares(Busqueda, Palabras);

    Condicion:='';
    for I:=0 to Palabras.Count-1 do
    begin
      if I>=6 then Break; // No saturar la consulta en bases grandes.
      if Condicion<>'' then Condicion:=Condicion+' OR ';
      Condicion:=Condicion+'A1 LIKE "%'+FLX_SQLTexto(Palabras[I])+'%"';
    end;

    if Condicion='' then
      Condicion:='A1 LIKE "%'+FLX_SQLTexto(FLX_NormalizaParaSimilitud(Busqueda))+'%"';

    dbArti.Active:=False;
    dbArti.SQL.Text:=
      'SELECT A0,A1 FROM artitien'+Tienda+
      ' WHERE '+Condicion+
      ' ORDER BY A1 LIMIT 200';
    dbArti.Active:=True;

    dbArti.First;
    while not dbArti.EOF do
    begin
      Score:=FLX_ScoreDescripcionSimilar(Busqueda, dbArti.FieldByName('A1').AsString);
      FLX_InsertarCandidatoSimilar(
        Codigos, Nombres, Lineas,
        dbArti.FieldByName('A0').AsString,
        dbArti.FieldByName('A1').AsString,
        Score);
      dbArti.Next;
    end;

    // Si no hay candidatos razonables, no molestamos: se continúa con el alta nueva.
    if Lineas.Count=0 then
    begin
      ACrearNuevo:=True;
      Result:=True;
      Exit;
    end;

    FormSel:=TForm.Create(Self);
    try
      FormSel.Caption:='Artículos similares encontrados';
      FormSel.Position:=poScreenCenter;
      FormSel.BorderStyle:=bsSizeable;
      FormSel.Width:=850;
      FormSel.Height:=480;

      LInfo:=TLabel.Create(FormSel);
      LInfo.Parent:=FormSel;
      LInfo.Left:=8;
      LInfo.Top:=8;
      LInfo.Width:=FormSel.ClientWidth-16;
      LInfo.Height:=48;
      LInfo.Anchors:=[akLeft, akTop, akRight];
      LInfo.Caption:=
        'Antes de crear un artículo nuevo, se han encontrado posibles coincidencias.' + LineEnding +
        'Línea importada: ' + Busqueda + LineEnding +
        'Puede usar uno de estos artículos o continuar con el alta nueva.';

      Lista:=TListBox.Create(FormSel);
      Lista.Parent:=FormSel;
      Lista.Left:=8;
      Lista.Top:=64;
      Lista.Width:=FormSel.ClientWidth-16;
      Lista.Height:=FormSel.ClientHeight-112;
      Lista.Anchors:=[akLeft, akTop, akRight, akBottom];
      Lista.Items.Assign(Lineas);
      if Lista.Items.Count>0 then Lista.ItemIndex:=0;

      BtnUsar:=TButton.Create(FormSel);
      BtnUsar.Parent:=FormSel;
      BtnUsar.Caption:='Usar seleccionado';
      BtnUsar.ModalResult:=mrOk;
      BtnUsar.Left:=FormSel.ClientWidth-370;
      BtnUsar.Top:=FormSel.ClientHeight-40;
      BtnUsar.Width:=130;
      BtnUsar.Anchors:=[akRight, akBottom];

      BtnNuevo:=TButton.Create(FormSel);
      BtnNuevo.Parent:=FormSel;
      BtnNuevo.Caption:='Alta nueva';
      BtnNuevo.ModalResult:=mrYes;
      BtnNuevo.Left:=FormSel.ClientWidth-232;
      BtnNuevo.Top:=FormSel.ClientHeight-40;
      BtnNuevo.Width:=100;
      BtnNuevo.Anchors:=[akRight, akBottom];

      BtnCancel:=TButton.Create(FormSel);
      BtnCancel.Parent:=FormSel;
      BtnCancel.Caption:='Cancelar';
      BtnCancel.ModalResult:=mrCancel;
      BtnCancel.Left:=FormSel.ClientWidth-124;
      BtnCancel.Top:=FormSel.ClientHeight-40;
      BtnCancel.Width:=116;
      BtnCancel.Anchors:=[akRight, akBottom];

      Modal:=FormSel.ShowModal;
      if Modal=mrOk then
      begin
        I:=Lista.ItemIndex;
        if (I>=0) and (I<Codigos.Count) then
        begin
          ACodigo:=Codigos[I];
          ANombre:=Nombres[I];
          ACrearNuevo:=False;
          Result:=True;
        end;
      end
      else if Modal=mrYes then
      begin
        ACrearNuevo:=True;
        Result:=True;
      end;
    finally
      FormSel.Free;
    end;
  finally
    Codigos.Free;
    Nombres.Free;
    Lineas.Free;
    Palabras.Free;
  end;
end;

function TfImportar.IntentarVincularArticuloSimilarAntesAlta(var Linea: RLineaPedido; const CodigoNuevo, NombreNuevo, EanNuevo: string): Boolean;
var
  CodBD, NomBD, Aux: string;
  CrearNuevo, InsertoAux: Boolean;
begin
  // Devuelve True si la acción ya queda resuelta o cancelada.
  // Devuelve False si el usuario decide continuar con el alta nueva normal.
  Result:=False;

  if not SeleccionarArticuloSimilarOAltaNueva(NombreNuevo, CodBD, NomBD, CrearNuevo) then
  begin
    Result:=True; // Cancelado por el usuario.
    Exit;
  end;

  if CrearNuevo then
    Exit; // Continúa el alta nueva existente.

  EditBDCodigo.Text:=CodBD;
  EditBDNombre.Text:=NomBD;
  EditBDEan.Text:='';

  Linea.Codigo:=CodBD;
  Linea.Descripcion:=NomBD;
  Linea.CoinCod:=1;
  Linea.CoinDes:=1;
  InsertoAux:=False;

  // Si el proveedor trae EAN válido, lo añadimos como auxiliar del artículo seleccionado.
  if FLX_TextoValidoEAN(EanNuevo) then
  begin
    Aux:=FLX_NormalizaEANImportado(EanNuevo, CodigoNuevo, NombreNuevo);
    EditPenEan.Text:=Aux;
    NuevoEan(Aux, Linea);
    InsertoAux:=True;
  end
  else if (Trim(CodigoNuevo)<>'') and (Trim(CodigoNuevo)<>Trim(CodBD)) then
  begin
    // Si no hay EAN, se ofrece guardar el código del proveedor como auxiliar.
    if MessageDlg(
         'Ha elegido usar un artículo existente:' + LineEnding + LineEnding +
         CodBD + ' - ' + NomBD + LineEnding + LineEnding +
         'La línea no trae un EAN válido.' + LineEnding +
         '¿Desea añadir el código del proveedor como código auxiliar?' + LineEnding + LineEnding +
         'Código proveedor: ' + CodigoNuevo,
         mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      NuevoEan(CodigoNuevo, Linea);
      InsertoAux:=True;
    end;
  end;

  if not InsertoAux then
  begin
    Linea.Codigo:=CodBD;
    Linea.Descripcion:=NomBD;
    Linea.CodigoEAN:='';
    Linea.CoinCod:=1;
    Linea.CoinDes:=1;
    Linea.CoinEan:=0;
  end;

  BuscarCoincidencias(Linea);
  ArrayDeLineasPedido[Linea.Pos-1]:=Linea;
  DistribuirLineasPedido(ArrayDeLineasPedido);

  BitBtnDAltaCod.Enabled:=False;
  BitBtnAltaEan.Enabled:=False;
  BitBtnAceptarDatosBD.Enabled:=False;
  PanelEdicion.Visible:=False;

  Result:=True;
end;

function TfImportar.PrepararArticuloExistenteParaEan(var Linea: RLineaPedido): Boolean;
var
  CodBD, NomBD: string;
begin
  Result:=False;

  if not SeleccionarArticuloExistentePorDescripcion(Trim(EditPenNombre.Text), CodBD, NomBD) then Exit;

  EditBDCodigo.Text:=CodBD;
  EditBDNombre.Text:=NomBD;
  EditBDEan.Text:='';

  // Marcamos la línea como vinculada a un artículo existente para que el flujo
  // posterior use la ficha correcta y pueda insertar el EAN/código auxiliar.
  Linea.Codigo:=CodBD;
  Linea.Descripcion:=NomBD;
  Linea.CoinCod:=1;
  Linea.CoinDes:=1;

  if FLX_TextoValidoEAN(EditPenEan.Text) then
    Linea.CoinEan:=3
  else
    Linea.CoinEan:=0;

  Result:=True;
end;

procedure TfImportar.NuevoEan(const nuevoEan: string; var linea: RLineaPedido);
begin
  // Comprobamos de nuevo que no exista otro ean igual.
  // Si ya existe, NO intentamos duplicarlo: vinculamos la línea al auxiliar ya existente
  // para que no quede como "artículo nuevo" cuando en realidad ya está en la tabla eans.
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM eans WHERE EAN0="'+FLX_SQLTexto(nuevoEan)+'" LIMIT 1';
  dbArti.Active:=True;

  if dbArti.RecordCount=0 then
  begin
    dbArti.Append;
    dbArti.FieldByName('EAN0').AsString:=nuevoEan;                 // EAN / auxiliar
    dbArti.FieldByName('EAN1').AsString:=EditBDCodigo.Text;        // Código interno
    if EditPenNombre.Text <> '' then
      dbArti.FieldByName('EAN2').AsString:=FLX_NormalizaDescripcionImportada(EditPenNombre.Text)      // Descripción del fichero
    else
      dbArti.FieldByName('EAN2').AsString:=FLX_NormalizaDescripcionImportada(EditBDNombre.Text);      // Descripción BD

    dbArti.FieldByName('EAN3').AsString:='1';                      // Unidades
    dbArti.FieldByName('EAN4').AsString:='0';                      // Precio auxiliar
    dbArti.FieldByName('EAN5').AsString:='1';                      // Unidades a descontar
    dbArti.Post;

    ShowMessage(
      'Añadido código auxiliar:' + LineEnding + LineEnding +
      'Código:      ' + dbArti.FieldByName('EAN1').AsString + LineEnding +
      'EAN/Aux.:    ' + dbArti.FieldByName('EAN0').AsString + LineEnding +
      'Descripción: ' + dbArti.FieldByName('EAN2').AsString
    );

    // Dejamos la línea vinculada al artículo al que acabamos de añadir el auxiliar.
    linea.Codigo:=EditBDCodigo.Text;
    linea.CodigoEAN:=nuevoEan;
    if EditBDNombre.Text<>'' then
      linea.Descripcion:=EditBDNombre.Text;
  end
  else
  begin
    ShowMessage(
      'Ese código auxiliar ya existía en la base de datos.' + LineEnding + LineEnding +
      'Se usará el artículo al que ya pertenece:' + LineEnding + LineEnding +
      'Código:      ' + dbArti.FieldByName('EAN1').AsString + LineEnding +
      'EAN/Aux.:    ' + dbArti.FieldByName('EAN0').AsString + LineEnding +
      'Descripción: ' + dbArti.FieldByName('EAN2').AsString
    );

    // Si ya existe, no es un artículo nuevo: adoptamos la ficha real del auxiliar.
    linea.Codigo:=dbArti.FieldByName('EAN1').AsString;
    linea.CodigoEAN:=dbArti.FieldByName('EAN0').AsString;
    linea.Descripcion:=dbArti.FieldByName('EAN2').AsString;
  end;
end;

procedure ShowFormImportar(dbPedid: TzQuery; dbPedic: TzQuery);
begin
  with TfImportar.Create(Application) do
    begin
       dbPedidAux:= dbPedid;
       dbPedicAux:= dbPedic;

       ShowModal;
    end;
end;

//=============== CREAR EL FORMULARIO ================
//procedure TfImportar.IniciaImportar(var palabra: string);
procedure TfImportar.IniciaImportar(var dbPedid: TzQuery; dbPedic: TzQuery);
begin
   ShowFormImportar(dbPedid, dbPedic);
   //dbPedidAux:=dbPedid;
   //dbPedicAux:=dbPedic;
end;

procedure TfImportar.btnAPedidoClick(Sender: TObject);
var cont:integer;
begin
  for cont:=0 to Length(ArrayDeLineasPedidoPro)-1 do
  begin
    // En pedidos enpiezan a insertar en la línea 1, hay que sumar 1 al nº de líneas
    InsertarLinea(ArrayDeLineasPedidoPro[cont], (dbPedidAux.RecordCount+1));
    Label28.Caption:='Registros a procesar . . .  '+('cont= '+IntToStr(cont)+'recor= '+IntToStr(dbPedidAux.RecordCount));
  end;
  SetLength(ArrayDeLineasPedidoPro, 0);
  dbgProcesados.RowCount:=0;
  showmessage('Registros Procesados ... '+'cont= '+IntToStr(cont)+'recor= '+IntToStr(dbPedidAux.RecordCount));
end;
//----------------- Aceptar Lineas ----------------
//procedure TfImportar.InsertarLinea(var dbPedidI: TzQuery; dbPedicAux: TzQuery; Linea: RLineaPedido; VerUltimaLinea: integer );
procedure TfImportar.InsertarLinea(Linea: RLineaPedido; VerUltimaLinea: integer );
var
  valtemp : Double;
  UnidadesPedido: Double;
  CostoSinIVA: Double;
  IvaPedido: Double;
  RecargoPedido: Double;
  CostoConIVA: Double;
  PvpConIVA: Double;
  PvpSinIVA: Double;
  MargenPedido: Double;
  MargenSobrePvpPedido: Double;
begin
  valtemp:=0;

  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Linea.Codigo+'"';
  dbArti.Active:=True;

  if dbArti.RecordCount = 0 then
  begin
    ShowMessage(
      'No se puede insertar la línea en el pedido porque no se encuentra la ficha del artículo.' + LineEnding + LineEnding +
      'Código: ' + Linea.Codigo + LineEnding +
      'Descripción: ' + Linea.Descripcion
    );
    Exit;
  end;

  // Normalizamos importes antes de insertar. Esto evita que una línea recién creada
  // con coste/PVP vacío o a 0 acabe provocando divisiones por cero en los márgenes.
  UnidadesPedido:=FLX_StrToFloatDefSeguro(Linea.Unidades, 0);
  CostoSinIVA:=FLX_StrToFloatDefSeguro(Linea.Costo, 0);
  if CostoSinIVA <= 0 then
    CostoSinIVA:=dbArti.FieldByName('A24').AsFloat;
  if CostoSinIVA < 0 then
    CostoSinIVA:=0;

  RecargoPedido:=dbArti.FieldByName('A36').AsFloat;
  if RecargoPedido < 0 then
    RecargoPedido:=0;

  IvaPedido:=FLX_StrToFloatDefSeguro(Linea.IVA, 0);
  if IvaPedido <= 0 then
    IvaPedido:=dbArti.FieldByName('A3').AsFloat;
  if IvaPedido <= 0 then
    IvaPedido:=21;

  if Trim(Linea.PVP) <> '' then
    PvpConIVA:=FLX_StrToFloatDefSeguro(Linea.PVP, 0)
  else
    PvpConIVA:=dbArti.FieldByName('A2').AsFloat;

  // Para artículos nuevos el alta los marca con PVP 999,00. Si por cualquier motivo
  // la ficha todavía devuelve 0, usamos 999,00 en la línea para no paralizar el pedido.
  if PvpConIVA <= 0 then
    PvpConIVA:=999.00;

  CostoConIVA:=CostoSinIVA*(1+(IvaPedido/100));
  PvpSinIVA:=0;
  if (1+(IvaPedido/100)) <> 0 then
    PvpSinIVA:=PvpConIVA/(1+(IvaPedido/100));

  MargenPedido:=0;
  if CostoConIVA <> 0 then
    MargenPedido:=(((PvpConIVA-CostoConIVA)*100)/CostoConIVA);

  MargenSobrePvpPedido:=0;
  if PvpConIVA <> 0 then
    MargenSobrePvpPedido:=(((CostoConIVA/PvpConIVA)-1)*(-100));

  dbPedidAux.Append;
  try
    // Los datos que tengo en la linea de pedido son estos:
    // Codigo: string; CodigoEAN: string; Descripcion: string;
    // Unidades: string; Costo: string; IVA: string; PVP: string;
    // el resto de campos implicados en este proceso los dejo en blanco o 0
    dbPedidAux.FieldByName('PD0').Value:=dbPedicAux.FieldByName('PC0').Value;//----- N. Tienda
    dbPedidAux.FieldByName('PD1').Value:=dbPedicAux.FieldByName('PC1').Value;//----- Fecha
    dbPedidAux.FieldByName('PD2').Value:=dbPedicAux.FieldByName('PC2').Value;//----- Proveedor
    dbPedidAux.FieldByName('PD3').Value:=dbPedicAux.FieldByName('PC3').Value;//----- Serie
    dbPedidAux.FieldByName('PD4').Value:=dbPedicAux.FieldByName('PC4').Value;//----- N. Pedido

    dbPedidAux.FieldByName('PD5').Value:=VerUltimaLinea;//------- N. Linea
    dbPedidAux.FieldByName('PD6').AsString:=Linea.Codigo;//------ Codigo articulo
    dbPedidAux.FieldByName('PD7').AsString:=Linea.Descripcion;//- Descripcion
    dbPedidAux.FieldByName('PD8').AsFloat:=UnidadesPedido;//----- Unidades
    dbPedidAux.FieldByName('PD9').AsString:='0';//--------------- Bonificaciones
    dbPedidAux.FieldByName('PD10').AsFloat:=CostoSinIVA;//------- Precio de costo sin IVA y sin recargo

    dbPedidAux.FieldByName('PD13').AsFloat:=RecargoPedido;//----- Recargo de equivalencia
    dbPedidAux.FieldByName('PD14').AsFloat:=IvaPedido;//--------- Tipo de IVA
    dbPedidAux.FieldByName('PD15').AsFloat:=CostoConIVA;//------- Precio costo con IVA
    dbPedidAux.FieldByName('PD16').AsFloat:=PvpConIVA;//--------- Precio venta con IVA
    dbPedidAux.FieldByName('PD17').AsFloat:=CostoConIVA*UnidadesPedido;// Importe total coste con IVA

    valtemp:=PvpConIVA*UnidadesPedido;
    dbPedidAux.FieldByName('PD18').AsFloat:=valtemp;//----------- Importe total PVP con IVA
    dbPedidAux.FieldByName('PD19').Value:=dbArti.FieldByName('A14').Value;// Familia

    dbPedidAux.FieldByName('PD12').AsFloat:=PvpSinIVA;//--------- Precio venta sin IVA
    dbPedidAux.FieldByName('PD11').AsFloat:=MargenPedido;//------ Margen
    dbPedidAux.FieldByName('PD20').Value:=dbArti.FieldByName('A4').Value;// Stock actual

    dbPedidAux.FieldByName('PD21').AsString:='0';//-------------- Unidades vendidas año actual
    dbPedidAux.FieldByName('PD22').AsString:='0';//-------------- Unidades vendidas año anterior

    dbPedidAux.FieldByName('PD23').AsString:='S';//-------------- Recibido S/N
    dbPedidAux.FieldByName('PD24').AsString:='';//--------------- Serie de colores
    dbPedidAux.FieldByName('PD25').AsString:='';//--------------- Serie de tallas
    dbPedidAux.FieldByName('PD26').Value:=dbArti.FieldByName('A28').Value;// Precio tarifa
    dbPedidAux.FieldByName('PD27').AsFloat:=dbArti.FieldByName('A29').AsFloat;// Dto Importe
    dbPedidAux.FieldByName('PD28').AsFloat:=dbArti.FieldByName('A30').AsFloat;// Dto % 1
    dbPedidAux.FieldByName('PD29').AsFloat:=dbArti.FieldByName('A31').AsFloat;// Dto % 2
    dbPedidAux.FieldByName('PD30').AsFloat:=MargenSobrePvpPedido;// Margen sobre PVP

    dbPedidAux.Post;
    SumaPendientes(Linea.Codigo, Linea.Unidades);//----- Sumar unidades pendientes
  except
    on E: Exception do
    begin
      if dbPedidAux.State in [dsInsert, dsEdit] then
        dbPedidAux.Cancel;
      ShowMessage(
        'No se ha podido insertar la línea del pedido.' + LineEnding + LineEnding +
        'Código: ' + Linea.Codigo + LineEnding +
        'Descripción: ' + Linea.Descripcion + LineEnding + LineEnding +
        'Error: ' + E.Message
      );
    end;
  end;
end;
//================== UNIDADES PENDIENTES EN PEDIDOS ================
procedure TFImportar.SumaPendientes(CodiPen, UniPen: String);
begin
  dbTrabajo.SQL.Text:='UPDATE artitien'+Tienda+' SET A11=A11+'+UniPen+
                      ' WHERE A0="'+CodiPen+'"';
  dbTrabajo.ExecSQL;
end;

procedure TfImportar.btnSalirClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfImportar.btnSeleccionarClick(Sender: TObject);
var
  FicheroTXT, Txt: String;
  F: TextFile;
begin
  Memo1.Clear;
  SynEdit1.Clear;
  Panel3.Enabled:=false;
  btnGenerar.Enabled:=False;
  btnAPedido.Enabled:=False;
  TodoEnblanco1();
  TodoEnBlanco2();

  OpenDialog1.InitialDir:=ExtractFilePath(ParamStr(0));
  OpenDialog1.Filter:='Pedidos de proveedor (*.txt;*.csv;*.xlsx;*.xls)|*.txt;*.csv;*.xlsx;*.xls|Texto (*.txt;*.csv)|*.txt;*.csv|Excel XLSX (*.xlsx)|*.xlsx|Excel antiguo XLS (*.xls)|*.xls|Todos los ficheros (*.*)|*.*';

  if OpenDialog1.Execute then begin
     FicheroTXT:=OpenDialog1.FileName;

     if FLX_EsFicheroExcel(FicheroTXT) then
     begin
       if not FLX_EsFicheroXLSX(FicheroTXT) then
       begin
         SynEdit1.Lines.Add('Fichero XLS antiguo seleccionado: ' + ExtractFileName(FicheroTXT));
         Memo1.Lines.Add('El formato .XLS antiguo no se puede leer con esta versión sin librerías externas.');
         Memo1.Lines.Add('Seleccione el fichero .XLSX del proveedor.');
         ShowMessage('Sin instalar librerías externas, sólo podemos leer .XLSX.' + #13 +
                     'El .XLS antiguo es binario. Seleccione/solicite el fichero en formato .XLSX.');
         Panel2.Enabled:=false;
         Panel4.Enabled:=false;
         Panel3.Enabled:=true;
         btnGenerar.Enabled:=False;
         Exit;
       end;

       SynEdit1.Lines.Add('Fichero XLSX seleccionado: ' + ExtractFileName(FicheroTXT));
       Memo1.Lines.Add('Fichero XLSX seleccionado: ' + ExtractFileName(FicheroTXT));
       Memo1.Lines.Add('Pulse GENERAR para leer el Excel y comprobar las líneas.');

       // Para XLSX no hacen falta las pestañas de posiciones/delimitadores.
       Panel2.Enabled:=false;
       Panel4.Enabled:=false;
       Panel3.Enabled:=true;
       btnGenerar.Enabled:=True;
       Exit;
     end;

     // Seleccionamos sólo la primera linea para contar posiciones
     AssignFile(F,FicheroTXT);
     Reset(F);
     Readln(F,Txt);
     SynEdit1.Lines.Add(Txt);
     CloseFile(F);

     // Cargamos todo el contenido del fichero
     AssignFile(F,FicheroTXT);
     Reset(F);
     while not EOF(F) do begin
           Readln(F,Txt);
           Memo1.Lines.Add(Txt);
     end;
     CloseFile(F);
     Panel2.Enabled:=true;
     Panel4.Enabled:=true;
     Panel3.Enabled:=true;
     btnGenerar.Enabled:=True;
  end else
     FicheroTXT:='';
end;

//Doble click sobre una fila obtentrá los datos de la BD de ese artículo si existe, si no nuevo.
procedure TfImportar.dbgPendientesDblClick(Sender: TObject);
var
fila:integer;
linea: RLineaPedido;
TxtQuery: String;
Conocido: Boolean;
begin
TxtQuery:=''; Conocido:=False;
  BitBtnAltaEan.Enabled:=False;
  BitBtnAceptarDatosBD.Enabled:=False;
  BitBtnDAltaCod.Enabled:=False;

EditBDCodigo.Text:='';
EditBDNombre.Text:='';
EditBDEan.Text:='';

fila:=dbgPendientes.Row;
Val(dbgPendientes.Cells[7,fila],lineaSeleccionada);//Posicion de la linea en el arraylineaPedido

linea:=ArrayDeLineasPedido[lineaSeleccionada-1];
EditPenCodigo.Text:=dbgPendientes.Cells[1,fila];
EditPenNombre.Text:=FLX_NormalizaDescripcionImportada(dbgPendientes.Cells[2,fila]);
EditPenEan.Text:=dbgPendientes.Cells[0,fila];
//EditPenIVA.Text:=dbgPendientes.Cells[5,fila];
//EditPenPVP.Text:=dbgPendientes.Cells[6,fila];
//EditPenCosto.Text:=dbgPendientes.Cells[4,fila];
//EditPenUnid.Text:=dbgPendientes.Cells[3,fila];

  //CONOCIDOS: son lineas de pedido que tienen cierta similitud en la BD
  //Opciones: 1. Aceptar la linea con los datos de la BD
  //Conocidos por el código, nombre o ean aparecen en la tabla de eans
  IF ((linea.CoinCod=2) or (linea.CoinEan=2) or (linea.CoinDes=2)) then
  begin
    BitBtnAceptarDatosBD.Enabled:=True;
    Conocido:=True;

    TxtQuery:='SELECT * FROM eans WHERE EAN2="'+Linea.Descripcion+'"';
    if linea.CoinCod=2 then TxtQuery:='SELECT * FROM eans WHERE EAN0="'+Linea.Codigo+'"';
    if linea.CoinEan=2 then TxtQuery:='SELECT * FROM eans WHERE EAN0="'+Linea.CodigoEAN+'"';
    //WriteLn('TxtQuery de '+Txtquery);
    dbArti.Active:=False;
    dbArti.Sql.Text:=TxtQuery;
    dbArti.Active:=True;

    EditBDCodigo.Text:=dbArti.FieldByName('EAN1').AsString;
    EditBDNombre.Text:=dbArti.FieldByName('EAN2').AsString;
    EditBDEan.Text:=dbArti.FieldByName('EAN0').AsString;
  end
  //Conocidos que no están en la tabla de eans y que si lo estan en la de artitien
  else if ((linea.CoinCod=1) or (linea.CoinDes=1)) then
  begin
    BitBtnAceptarDatosBD.Enabled:=True;
    Conocido:=True;

    TxtQuery:='SELECT * FROM artitien'+Tienda+' WHERE A1="'+Linea.Descripcion+'"';
    if linea.CoinCod=1 then TxtQuery:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Linea.Codigo+'"';
    //WriteLn('TxtQuery de '+Txtquery);
    dbArti.Active:=False;
    dbArti.Sql.Text:=TxtQuery;
    dbArti.Active:=True;

    EditBDCodigo.Text:=dbArti.FieldByName('A0').AsString;
    EditBDNombre.Text:=dbArti.FieldByName('A1').AsString;
    EditBDEan.Text:='';
  end;
  //NUEVOS EANS: Artículos que están en la BD, pero que por algún cambio
  //pudiera ser conveniente darles un nuevo Ean. Estan todos: los de ean y los de cod desconocidos
  //Si el codigo, el ean o el nombre existe en eans pero tiene ean.txt o cod.txt desconocido
  IF (((linea.CoinCod=2) or (linea.CoinEan=2) or (linea.CoinDes=2)) AND ((linea.CoinEan=3) OR (linea.CoinCod=3))) then
  begin
    BitBtnAltaEan.Enabled:=True;
    Conocido:=True;

    TxtQuery:='SELECT * FROM eans WHERE EAN2="'+Linea.Descripcion+'"';
    if linea.CoinCod=2 then TxtQuery:='SELECT * FROM eans WHERE EAN0="'+Linea.Codigo+'"';
    if linea.CoinEan=2 then TxtQuery:='SELECT * FROM eans WHERE EAN0="'+Linea.CodigoEAN+'"';
    //prevalecen los datos de eans si existen
    //WriteLn('TxtQuery de '+Txtquery);
    dbArti.Active:=False;
    dbArti.Sql.Text:=TxtQuery;
    dbArti.Active:=True;

    EditBDCodigo.Text:=dbArti.FieldByName('EAN1').AsString;
    EditBDNombre.Text:=dbArti.FieldByName('EAN2').AsString;
    EditBDEan.Text:=dbArti.FieldByName('EAN0').AsString;

  end;
  //Si el codigo o el nombre existe en artitien pero tiene ean.txt o cod.txt desconocido
  // si había un 2 pero ahora encuentra un 1. Tiene prioridad el 1
  IF (((linea.CoinCod=1) or (linea.CoinDes=1)) AND ((linea.CoinEan=3) OR (linea.CoinCod=3))) then
  begin
    BitBtnAltaEan.Enabled:=True;
    Conocido:=True;

    TxtQuery:='SELECT * FROM artitien'+Tienda+' WHERE A1="'+Linea.Descripcion+'"';
    if linea.CoinCod=1 then TxtQuery:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Linea.Codigo+'"';
    //WriteLn('TxtQuery de '+Txtquery);
    dbArti.Active:=False;
    dbArti.Sql.Text:=TxtQuery;
    dbArti.Active:=True;

    EditBDCodigo.Text:=dbArti.FieldByName('A0').AsString;
    EditBDNombre.Text:=dbArti.FieldByName('A1').AsString;
    EditBDEan.Text:='';
  end;

  //Si el nombre existe pero tiene otro código o no tiene
  IF ((linea.CoinDes=1) AND (((linea.coinEan=3) and (linea.CoinCod=0)) OR
                             ((linea.coinEan=0) and (linea.CoinCod=3)) OR
                             ((linea.coinEan=3) and (linea.CoinCod=3)))) then
  begin
    BitBtnAltaEan.Enabled:=True;
    Conocido:=True;

    TxtQuery:='SELECT * FROM artitien'+Tienda+' WHERE A1="'+Linea.Descripcion+'"';
    //WriteLn('TxtQuery de '+Txtquery);
    dbArti.Active:=False;
    dbArti.Sql.Text:=TxtQuery;
    dbArti.Active:=True;

    EditBDCodigo.Text:=dbArti.FieldByName('A0').AsString;
    EditBDNombre.Text:=dbArti.FieldByName('A1').AsString;
    EditBDEan.Text:='';
  end;
  //Si el nombre existe pero en eans (tiene ean.bd) y tiene otro código o ean o no tiene
  // O si el cod esta en eans pero no coinciden ni ean ni nombre
  IF (((linea.CoinDes=2) AND (((linea.coinEan=3) and (linea.CoinCod=0)) OR
                             ((linea.coinEan=0) and (linea.CoinCod=3)) OR
                             ((linea.coinEan=3) and (linea.CoinCod=3)))) OR
       ((linea.CoinCod=2) AND (linea.CoinEan=3) AND (linea.CoinDes=3)))then
  begin
    BitBtnAltaEan.Enabled:=True;
    Conocido:=True;

    TxtQuery:='SELECT * FROM eans WHERE EAN2="'+Linea.Descripcion+'"';
    if (linea.CoinCod=2) then  TxtQuery:='SELECT * FROM eans WHERE EAN0="'+Linea.Codigo+'"';
    //WriteLn('TxtQuery de '+Txtquery);
    dbArti.Active:=False;
    dbArti.Sql.Text:=TxtQuery;
    dbArti.Active:=True;

    EditBDCodigo.Text:=dbArti.FieldByName('EAN1').AsString;
    EditBDNombre.Text:=dbArti.FieldByName('EAN2').AsString;
    EditBDEan.Text:=dbArti.FieldByName('EAN0').AsString;
  end;
  // RESCATE PARA TXT/FICHEROS DE ANCHO FIJO
  // En algunos proveedores el nombre llega con espacios de relleno o pequeñas diferencias
  // de formato. Antes de considerarlo artículo nuevo, buscamos por nombre recortado.
  // Si existe en artitien/eans, se habilita de nuevo el alta de EAN auxiliar.
  if (not Conocido) and (Trim(EditPenNombre.Text) <> '') then
  begin
    TxtQuery:='SELECT * FROM artitien'+Tienda+' WHERE TRIM(A1)="'+FLX_SQLTexto(EditPenNombre.Text)+'" LIMIT 1';
    dbArti.Active:=False;
    dbArti.Sql.Text:=TxtQuery;
    dbArti.Active:=True;

    if dbArti.RecordCount<>0 then
    begin
      BitBtnAceptarDatosBD.Enabled:=True;
      if FLX_TextoValidoEAN(EditPenEan.Text) or (Trim(EditPenCodigo.Text) <> '') then
        BitBtnAltaEan.Enabled:=True;
      Conocido:=True;

      EditBDCodigo.Text:=dbArti.FieldByName('A0').AsString;
      EditBDNombre.Text:=dbArti.FieldByName('A1').AsString;
      EditBDEan.Text:='';

      linea.CoinDes:=1;
      if FLX_TextoValidoEAN(EditPenEan.Text) then
        linea.CoinEan:=3;
      if Trim(EditPenCodigo.Text)=Trim(EditBDCodigo.Text) then
        linea.CoinCod:=1
      else if Trim(EditPenCodigo.Text)<>'' then
        linea.CoinCod:=3;

      ArrayDeLineasPedido[linea.Pos-1]:=linea;
    end
    else
    begin
      TxtQuery:='SELECT * FROM eans WHERE TRIM(EAN2)="'+FLX_SQLTexto(EditPenNombre.Text)+'" LIMIT 1';
      dbArti.Active:=False;
      dbArti.Sql.Text:=TxtQuery;
      dbArti.Active:=True;

      if dbArti.RecordCount<>0 then
      begin
        BitBtnAceptarDatosBD.Enabled:=True;
        if FLX_TextoValidoEAN(EditPenEan.Text) or (Trim(EditPenCodigo.Text) <> '') then
          BitBtnAltaEan.Enabled:=True;
        Conocido:=True;

        EditBDCodigo.Text:=dbArti.FieldByName('EAN1').AsString;
        EditBDNombre.Text:=dbArti.FieldByName('EAN2').AsString;
        EditBDEan.Text:=dbArti.FieldByName('EAN0').AsString;

        linea.CoinDes:=2;
        if FLX_TextoValidoEAN(EditPenEan.Text) then
          linea.CoinEan:=3;
        if Trim(EditPenCodigo.Text)<>'' then
          linea.CoinCod:=3;

        ArrayDeLineasPedido[linea.Pos-1]:=linea;
      end;
    end;
  end;

  // ARTICULO NUEVO
  ////Nombre de artículo desconocido sin otros datos conocidos
  //IF ((linea.CoinDes=3) AND (((linea.coinEan=0) and (linea.CoinCod=0)) OR
  //                           ((linea.coinEan=3) and (linea.CoinCod=0)) OR
  //                           ((linea.coinEan=0) and (linea.CoinCod=3)) OR
  //                           ((linea.coinEan=3) and (linea.CoinCod=3)))) then

  // El Botón Artículo Nuevo se mostrará para todas las líneas que no hayan sido reconocidas
  // en los casos anteriores. Será en el código del propio botón donde se comprobará
  // si tiene los datos mínimos e imprescindibles para dar de alta un nuevo artículo
  if not Conocido then
  begin
    BitBtnDAltaCod.Enabled:=True;

    // Aunque la línea se muestre como artículo nuevo, puede corresponderse
    // con un artículo ya existente que no se ha reconocido automáticamente.
    // Permitimos buscarlo por descripción y añadirle el EAN/código auxiliar
    // sin tener que crear una ficha nueva.
    BitBtnAltaEan.Enabled:=FLX_TextoValidoEAN(EditPenEan.Text) or (Trim(EditPenCodigo.Text) <> '');

    EditBDCodigo.Text:='';
    EditBDNombre.Text:='';
    EditBDEan.Text:='';
  end;

//Desconocidos
//EditPenIVA.Text:=dbgPendientes.Cells[5,fila];
//EditPenPVP.Text:=dbgPendientes.Cells[6,fila];
//EditPenCosto.Text:=dbgPendientes.Cells[4,fila];
//EditPenUnid.Text:=dbgPendientes.Cells[3,fila];

  PanelEdicion.Visible:=True;
  PanelEdicion.BringToFront;
  AplicarContrasteSeleccionControles(PanelEdicion);
  if EditPenCodigo.CanFocus then EditPenCodigo.SetFocus;
end;

procedure TfImportar.dbgProcesadosDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin
  if Sender is TStringGrid then
    DibujarCeldaGridLegible(TStringGrid(Sender),aCol,aRow,aRect,aState);
end;

//Dar de alta ean con el codigo.txt
// si hay cod.txt este será el nuevo ean
procedure TfImportar.BitBtnAltaEanClick(Sender: TObject);
var
  linea: RLineaPedido;
  nEan: string;
  InsertoAlgo: Boolean;
begin
  linea:=ArrayDeLineasPedido[lineaSeleccionada-1];
  InsertoAlgo:=False;

  // Si la línea se estaba mostrando como artículo nuevo, todavía damos la
  // posibilidad de vincularla a un artículo ya existente buscándolo por
  // descripción. Así se puede añadir el EAN/código auxiliar sin crear ficha.
  if ((Trim(EditBDCodigo.Text) = '') and (Trim(EditBDNombre.Text) = '')) then
  begin
    if not PrepararArticuloExistenteParaEan(linea) then Exit;
    ArrayDeLineasPedido[linea.Pos-1]:=linea;
  end;

  // Caso de Nuevo Ean por ean.txt desconocido
  if (linea.CoinEan = 3) and FLX_TextoValidoEAN(EditPenEan.Text) then
  begin
    if ((EditBDCodigo.Text = '') and (EditBDNombre.Text ='')) then begin
      ShowMessage('Datos insuficientes');exit;
    end;
    nEan:=FLX_NormalizaEANImportado(EditPenEan.Text, EditPenCodigo.Text, EditPenNombre.Text);
    if not FLX_TextoValidoEAN(nEan) then
    begin
      ShowMessage('No se ha podido normalizar un EAN válido para esta línea.');
      Exit;
    end;
    EditPenEan.Text:=nEan;
    NuevoEan(nEan, linea);
    InsertoAlgo:=True;
  end;

  // Casos en los que esté marcado el añadir cod.txt como ean
  if cbCodtxtAEan.Checked then begin
    if EditPenCodigo.Text = '' then begin EditPenCodigo.SetFocus; exit; end;
    if ((EditBDCodigo.Text = '') and (EditBDNombre.Text ='')) then begin
      ShowMessage('Datos insuficientes');exit;
    end;
    nEan:=EditPenCodigo.Text;
    NuevoEan(nEan, linea);
    InsertoAlgo:=True;
  end
  else if (not InsertoAlgo) and (not FLX_TextoValidoEAN(EditPenEan.Text)) and
          (Trim(EditPenCodigo.Text) <> '') then
  begin
    // Si no hay EAN válido en el fichero, ofrecemos usar el código del
    // proveedor como código auxiliar. Esto mantiene el comportamiento manual
    // y evita crear un artículo duplicado cuando realmente ya existe.
    if MessageDlg(
         'La línea no trae un EAN válido.' + LineEnding + LineEnding +
         '¿Desea insertar el código del proveedor como código auxiliar del artículo seleccionado?' + LineEnding + LineEnding +
         'Código proveedor: ' + EditPenCodigo.Text + LineEnding +
         'Artículo BD: ' + EditBDCodigo.Text + ' - ' + EditBDNombre.Text,
         mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      nEan:=EditPenCodigo.Text;
      NuevoEan(nEan, linea);
      InsertoAlgo:=True;
    end;
  end;

  if not InsertoAlgo then
  begin
    ShowMessage(
      'No se ha insertado ningún código auxiliar.' + LineEnding + LineEnding +
      'Revise que la línea tenga EAN válido o marque la opción de usar el código del proveedor como auxiliar.'
    );
    Exit;
  end;

  BuscarCoincidencias(Linea);

  //Las modificaciones pasan al vector de lineas de pedido
  ArrayDeLineasPedido[linea.Pos-1]:=linea;

  DistribuirLineasPedido(ArrayDeLineasPedido);
  BitBtnAltaEan.Enabled:=False;
  PanelEdicion.Visible:=False;
end;

procedure TfImportar.BitBtnAceptarDatosBDClick(Sender: TObject);
var
  linea: RLineaPedido;
  TxtQuery: String;
  datosDe: String;
begin
  datosDe:='';
  linea:=ArrayDeLineasPedido[lineaSeleccionada-1];

  // Prioridad de búsqueda:
  // 1) EAN exacto en eans.
  // 2) Código del proveedor que realmente es un EAN auxiliar en eans.
  // 3) Descripción encontrada en eans.
  // 4) Código interno real en artitien.
  // 5) Descripción encontrada en artitien.
  //
  // OJO: antes había dos errores aquí:
  // - CoinCod=2 consultaba EAN1, pero BuscarCoincidencias lo había localizado por EAN0.
  // - El else if repetía CoinCod=2 en lugar de CoinCod=1, por lo que un artículo
  //   existente por código interno podía quedar como "no encontrado".

  if linea.CoinEan=2 then
  begin
    TxtQuery:='SELECT * FROM eans WHERE EAN0="'+FLX_SQLTexto(EditPenEan.Text)+'" LIMIT 1';
    datosDe:='eans';
  end
  else if linea.CoinCod=2 then
  begin
    TxtQuery:='SELECT * FROM eans WHERE EAN0="'+FLX_SQLTexto(EditPenCodigo.Text)+'" LIMIT 1';
    datosDe:='eans';
  end
  else if linea.CoinDes=2 then
  begin
    TxtQuery:='SELECT * FROM eans WHERE TRIM(EAN2)="'+FLX_SQLTexto(EditPenNombre.Text)+'" LIMIT 1';
    datosDe:='eans';
  end
  else if linea.CoinCod=1 then
  begin
    TxtQuery:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+FLX_SQLTexto(EditPenCodigo.Text)+'" LIMIT 1';
    datosDe:='artitien';
  end
  else if linea.CoinDes=1 then
  begin
    TxtQuery:='SELECT * FROM artitien'+Tienda+' WHERE TRIM(A1)="'+FLX_SQLTexto(EditPenNombre.Text)+'" LIMIT 1';
    datosDe:='artitien';
  end;

  if datosDe <> '' then
  begin
    dbArti.Active:=False;
    dbArti.SQL.Text:=TxtQuery;
    dbArti.Active:=True;

    if dbArti.RecordCount<>0 then
    begin
      if datosDe = 'eans' then
      begin
        // Tomamos la ficha real desde el auxiliar encontrado.
        Linea.CodigoEAN:=dbArti.FieldByName('EAN0').AsString;
        Linea.Codigo:=dbArti.FieldByName('EAN1').AsString;
        Linea.Descripcion:=dbArti.FieldByName('EAN2').AsString;
      end
      else
      begin
        // Tomamos la ficha real desde artitien.
        Linea.Codigo:=dbArti.FieldByName('A0').AsString;
        Linea.Descripcion:=dbArti.FieldByName('A1').AsString;
        // Dejamos el EAN vacío para no forzar un auxiliar incorrecto.
        // Si el EAN del fichero no existía, se añadirá con BitBtnAltaEan.
        if linea.CoinEan<>2 then
          Linea.CodigoEan:='';
      end;
    end
    else
    begin
      ShowMessage(
        'No se ha podido localizar en la base de datos el registro que indicaba la coincidencia.' + LineEnding + LineEnding +
        'Código importado: ' + EditPenCodigo.Text + LineEnding +
        'EAN importado: ' + EditPenEan.Text + LineEnding +
        'Descripción importada: ' + EditPenNombre.Text + LineEnding + LineEnding +
        'La línea seguirá en pendientes para revisarla manualmente.'
      );
      Exit;
    end;
  end;

  BuscarCoincidencias(Linea);
  ArrayDeLineasPedido[linea.Pos-1]:=linea;

  DistribuirLineasPedido(ArrayDeLineasPedido);
  BitBtnAceptarDatosBD.Enabled:=False;
  PanelEdicion.Visible:=False;
end;

procedure TfImportar.BitBtnDAltaCodClick(Sender: TObject);
var

  Conta: Integer;
  ANO: String;
  linea: RLineaPedido;
  CodigoNuevo, NombreNuevo, EanNuevo: String;
  IvaAlta, PvpAlta, PvpSinIvaAlta: Double;
  CostoAlta, RecargoAlta, CostoConImpuestosAlta: Double;
  MargenAlta, MargenSobrePvpAlta: Double;
  IvaPorDefecto: Boolean;
begin
  CodigoNuevo:=Trim(EditPenCodigo.Text);
  NombreNuevo:=FLX_NormalizaDescripcionImportada(EditPenNombre.Text);
  EanNuevo:=Trim(EditPenEan.Text);
  if EanNuevo <> '' then
  begin
    EanNuevo:=FLX_NormalizaEANImportado(EanNuevo, CodigoNuevo, NombreNuevo);
    EditPenEan.Text:=EanNuevo;
  end;

  //los dos campos tienen que estar completos
  if NombreNuevo = '' then begin EditPenNombre.SetFocus; exit; end;
  if CodigoNuevo = '' then begin EditPenCodigo.SetFocus; exit; end;

  linea:=ArrayDeLineasPedido[lineaSeleccionada-1];

  // Normalizamos la línea antes del alta. En XLSX Linea.PVP viene vacío a propósito
  // para que en pedidos se use el PVP de la ficha. En artículos nuevos usamos una
  // marca visible de 999,00 euros para poder revisarlos después.
  linea.Codigo:=CodigoNuevo;
  linea.Descripcion:=NombreNuevo;
  linea.CodigoEAN:=EanNuevo;

  // Antes de crear una ficha nueva, ofrecemos posibles artículos similares.
  // Si el usuario elige uno, la línea queda vinculada al existente y no se crea duplicado.
  if IntentarVincularArticuloSimilarAntesAlta(linea, CodigoNuevo, NombreNuevo, EanNuevo) then
    Exit;

  ShowMessage(
    'UN ARTÍCULO PUEDE TENER OTRAS MUCHAS CARACTERISTICAS QUE NO ESTÁN RECOGIDAS EN ESTA CREACIÓN' + LineEnding +
    'SE RECOMIENDA VISITAR LA FICHA DEL ARTÍCULO' + LineEnding + LineEnding +
    'Se creará con PVP provisional 999,00 para localizarlo fácilmente.'
  );

  IvaAlta:=FLX_StrToFloatDefSeguro(linea.IVA, -1);
  IvaPorDefecto:=(IvaAlta <= 0);
  if IvaPorDefecto then
  begin
    if not FLX_PedirIVAArticuloNuevo(CodigoNuevo, NombreNuevo, IvaAlta) then Exit;
    linea.IVA:=FloatToStr(IvaAlta);
  end;

  PvpAlta:=999.00;       // PVP con IVA provisional para localizar artículos nuevos
  RecargoAlta:=0;
  CostoAlta:=FLX_StrToFloatDefSeguro(linea.Costo, 0);
  if CostoAlta <= 0 then
  begin
    ShowMessage(
      'No se dará de alta este artículo porque el coste importado es 0 o está vacío.' + LineEnding + LineEnding +
      'Código: ' + CodigoNuevo + LineEnding +
      'Descripción: ' + NombreNuevo + LineEnding + LineEnding +
      'Se considera un obsequio del proveedor y no se gestiona desde el importador.'
    );
    Exit;
  end;

  // En los artículos recién creados dejamos también la línea con importes válidos,
  // para que al pasarla al pedido no dependa de un refresco posterior de la ficha.
  linea.Costo:=FloatToStr(CostoAlta);
  linea.PVP:=FloatToStr(PvpAlta);

  PvpSinIvaAlta:=0;
  if (1 + (IvaAlta / 100)) <> 0 then
    PvpSinIvaAlta:=PvpAlta / (1 + (IvaAlta / 100));

  CostoConImpuestosAlta:=CostoAlta * (1 + ((IvaAlta + RecargoAlta) / 100));
  MargenAlta:=0;
  MargenSobrePvpAlta:=0;
  if (CostoConImpuestosAlta <> 0) and (PvpAlta <> 0) then
  begin
    MargenAlta:=((PvpAlta - CostoConImpuestosAlta) * 100) / CostoConImpuestosAlta;
    MargenSobrePvpAlta:=((CostoConImpuestosAlta / PvpAlta) - 1) * (-100);
  end;

  // Protección: si por cualquier motivo esta línea se mostró como nueva,
  // pero ya existe por código/nombre en artitien, NO creamos otro.
  // En ese caso preparamos la pantalla para añadir el EAN/código auxiliar al existente.
  dbArti.Active:=False;
  dbArti.Sql.Text:='SELECT * FROM artitien'+Tienda+
                   ' WHERE A0="'+FLX_SQLTexto(CodigoNuevo)+'"'+
                   ' OR TRIM(A1)="'+FLX_SQLTexto(NombreNuevo)+'" LIMIT 1';
  dbArti.Active:=True;
  if dbArti.RecordCount<>0 then
  begin
    EditBDCodigo.Text:=dbArti.FieldByName('A0').AsString;
    EditBDNombre.Text:=dbArti.FieldByName('A1').AsString;
    EditBDEan.Text:='';

    linea.Codigo:=EditBDCodigo.Text;
    linea.Descripcion:=EditBDNombre.Text;
    linea.CoinDes:=1;
    if Trim(CodigoNuevo)=Trim(EditBDCodigo.Text) then
      linea.CoinCod:=1
    else
      linea.CoinCod:=3;
    if FLX_TextoValidoEAN(EanNuevo) then
      linea.CoinEan:=3;
    ArrayDeLineasPedido[linea.Pos-1]:=linea;

    BitBtnAltaEan.Enabled:=FLX_TextoValidoEAN(EanNuevo) or (Trim(CodigoNuevo) <> '');
    BitBtnDAltaCod.Enabled:=False;

    ShowMessage(
      'El artículo ya existe en la ficha de artículos.' + LineEnding + LineEnding +
      'Código BD: ' + EditBDCodigo.Text + LineEnding +
      'Nombre BD: ' + EditBDNombre.Text + LineEnding + LineEnding +
      'No se crea un artículo nuevo. Use el botón de añadir EAN/código auxiliar.'
    );
    Exit;
  end;

  // Segunda protección: puede que no exista como artículo principal, pero sí como
  // auxiliar en eans. Esto explica el caso "me lo muestra como nuevo, pero al
  // introducir algún campo dice que ya existe".
  if FLX_TextoValidoEAN(EanNuevo) then
  begin
    dbArti.Active:=False;
    dbArti.Sql.Text:='SELECT * FROM eans WHERE EAN0="'+FLX_SQLTexto(EanNuevo)+'" LIMIT 1';
    dbArti.Active:=True;
    if dbArti.RecordCount<>0 then
    begin
      EditBDCodigo.Text:=dbArti.FieldByName('EAN1').AsString;
      EditBDNombre.Text:=dbArti.FieldByName('EAN2').AsString;
      EditBDEan.Text:=dbArti.FieldByName('EAN0').AsString;

      linea.Codigo:=EditBDCodigo.Text;
      linea.CodigoEAN:=EditBDEan.Text;
      linea.Descripcion:=EditBDNombre.Text;
      linea.CoinEan:=2;
      linea.CoinCod:=2;
      linea.CoinDes:=2;
      ArrayDeLineasPedido[linea.Pos-1]:=linea;

      BitBtnAceptarDatosBD.Enabled:=True;
      BitBtnAltaEan.Enabled:=False;
      BitBtnDAltaCod.Enabled:=False;

      ShowMessage(
        'El EAN/código auxiliar ya existe en la base de datos.' + LineEnding + LineEnding +
        'Código BD: ' + EditBDCodigo.Text + LineEnding +
        'EAN/Aux.: ' + EditBDEan.Text + LineEnding +
        'Nombre BD: ' + EditBDNombre.Text + LineEnding + LineEnding +
        'No se crea artículo nuevo. Acepte los datos de BD para usar la ficha existente.'
      );
      Exit;
    end;
  end;

  if Trim(CodigoNuevo)<>'' then
  begin
    dbArti.Active:=False;
    dbArti.Sql.Text:='SELECT * FROM eans WHERE EAN0="'+FLX_SQLTexto(CodigoNuevo)+'" LIMIT 1';
    dbArti.Active:=True;
    if dbArti.RecordCount<>0 then
    begin
      EditBDCodigo.Text:=dbArti.FieldByName('EAN1').AsString;
      EditBDNombre.Text:=dbArti.FieldByName('EAN2').AsString;
      EditBDEan.Text:=dbArti.FieldByName('EAN0').AsString;

      linea.Codigo:=EditBDCodigo.Text;
      linea.CodigoEAN:=EditBDEan.Text;
      linea.Descripcion:=EditBDNombre.Text;
      linea.CoinCod:=2;
      linea.CoinEan:=2;
      linea.CoinDes:=2;
      ArrayDeLineasPedido[linea.Pos-1]:=linea;

      BitBtnAceptarDatosBD.Enabled:=True;
      BitBtnAltaEan.Enabled:=False;
      BitBtnDAltaCod.Enabled:=False;

      ShowMessage(
        'El código del proveedor ya existe como código auxiliar.' + LineEnding + LineEnding +
        'Código BD: ' + EditBDCodigo.Text + LineEnding +
        'Auxiliar: ' + EditBDEan.Text + LineEnding +
        'Nombre BD: ' + EditBDNombre.Text + LineEnding + LineEnding +
        'No se crea artículo nuevo. Acepte los datos de BD para usar la ficha existente.'
      );
      Exit;
    end;
  end;

  if Trim(NombreNuevo)<>'' then
  begin
    dbArti.Active:=False;
    dbArti.Sql.Text:='SELECT * FROM eans WHERE TRIM(EAN2)="'+FLX_SQLTexto(NombreNuevo)+'" LIMIT 1';
    dbArti.Active:=True;
    if dbArti.RecordCount<>0 then
    begin
      EditBDCodigo.Text:=dbArti.FieldByName('EAN1').AsString;
      EditBDNombre.Text:=dbArti.FieldByName('EAN2').AsString;
      EditBDEan.Text:=dbArti.FieldByName('EAN0').AsString;

      linea.Codigo:=EditBDCodigo.Text;
      linea.CodigoEAN:=EditBDEan.Text;
      linea.Descripcion:=EditBDNombre.Text;
      linea.CoinDes:=2;
      if FLX_TextoValidoEAN(EanNuevo) then
        linea.CoinEan:=3
      else
        linea.CoinEan:=2;
      linea.CoinCod:=2;
      ArrayDeLineasPedido[linea.Pos-1]:=linea;

      BitBtnAltaEan.Enabled:=FLX_TextoValidoEAN(EanNuevo) or (Trim(CodigoNuevo) <> '');
      BitBtnDAltaCod.Enabled:=False;

      ShowMessage(
        'La descripción ya existe en códigos auxiliares.' + LineEnding + LineEnding +
        'Código BD: ' + EditBDCodigo.Text + LineEnding +
        'Auxiliar: ' + EditBDEan.Text + LineEnding +
        'Nombre BD: ' + EditBDNombre.Text + LineEnding + LineEnding +
        'No se crea artículo nuevo. Puede aceptar la ficha BD o añadir el nuevo auxiliar si corresponde.'
      );
      Exit;
    end;
  end;

  // MUY IMPORTANTE: en las comprobaciones anteriores hemos reutilizado dbArti
  // tanto contra artitien como contra eans. Si la última consulta fue contra eans,
  // dbArti no tiene campos A0/A1/A2... y al hacer Append daría:
  // "A0 field not found".
  // Por eso reabrimos explícitamente dbArti contra artitien antes del Append.
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+
                   ' WHERE A0="'+FLX_SQLTexto(CodigoNuevo)+'" LIMIT 1';
  dbArti.Active:=True;

  if dbArti.RecordCount<>0 then
  begin
    ShowMessage(
      'No se puede crear el artículo porque ahora ya aparece en la ficha de artículos.' + LineEnding +
      'Código: ' + CodigoNuevo + LineEnding +
      'Descripción: ' + NombreNuevo + LineEnding + LineEnding +
      'Se cancela el alta para evitar duplicados.'
    );
    Exit;
  end;

  dbArti.Append;
  dbArti.FieldByName('A0').AsString:=CodigoNuevo;//-------------- Código
  dbArti.FieldByName('A1').AsString:=NombreNuevo;//-------------- Nombre

  // Alta mínima coherente: PVP provisional 999,00 con IVA, precio sin IVA,
  // coste del fichero, coste medio y márgenes calculados igual que en pedidos.
  dbArti.FieldByName('A21').AsFloat:=PvpSinIvaAlta;//------------ Precio venta sin IVA
  dbArti.FieldByName('A3').AsFloat:=IvaAlta;//------------------- IVA
  dbArti.FieldByName('A36').AsFloat:=RecargoAlta;//-------------- Recargo
  dbArti.FieldByName('A2').AsFloat:=PvpAlta;//------------------- P.V.P. con IVA provisional
  dbArti.FieldByName('A14').AsString:='0';//--------------------- Familia provisional
  dbArti.FieldByName('A24').AsFloat:=CostoAlta;//---------------- Costo sin IVA
  dbArti.FieldByName('A25').AsFloat:=CostoAlta;//---------------- Costo medio
  dbArti.FieldByName('A26').AsFloat:=MargenAlta;//--------------- Margen normal
  dbArti.FieldByName('A37').AsFloat:=MargenSobrePvpAlta;//------- Margen sobre PVP
  dbArti.FieldByName('A28').AsFloat:=CostoAlta;//---------------- Precio tarifa compra provisional
  dbArti.FieldByName('A29').AsFloat:=0;//------------------------ Descuento en importe
  dbArti.FieldByName('A30').AsFloat:=0;//------------------------ % Descuento 1
  dbArti.FieldByName('A31').AsFloat:=0;//------------------------ % Descuento 2
  dbArti.Post;

  //--------- Estadistica
  ANO:=FormatDateTime('YYYY',Date);
  for conta:=1 to 12 do
    begin
    //WriteLn('INSERT IGNORE INTO estaarti'+Tienda+' (TA0,TA1,TA2,TA3,TA4,TA5,TA6,TA7) '+'VALUES ("'+CodigoNuevo+'",'+ANO+','+IntToStr(Conta)+',0,0,0,0,0)');
     dbTrabajo.SQL.Text:='INSERT IGNORE INTO estaarti'+Tienda+' (TA0,TA1,TA2,TA3,TA4,TA5,TA6,TA7) '+
                         'VALUES ("'+CodigoNuevo+'",'+ANO+','+IntToStr(Conta)+',0,0,0,0,0)';
     dbTrabajo.ExecSQL;
  end;


  // Si el fichero traía EAN, al crear el artículo nuevo lo insertamos también
  // como código auxiliar en la tabla EANS, asociado al código recién creado.
  if (EanNuevo<>'') and (EanNuevo<>'0000000000000') then
  begin
    EditBDCodigo.Text:=CodigoNuevo;
    EditBDNombre.Text:=NombreNuevo;
    EditBDEan.Text:='';
    NuevoEan(EanNuevo, linea);
  end;

  BuscarCoincidencias(Linea);

  //Las modificaciones pasan al vector de lineas de pedido
  ArrayDeLineasPedido[linea.Pos-1]:=linea;
  //writeLinea(ArrayDeLineasPedido[linea.Pos-1]);

  DistribuirLineasPedido(ArrayDeLineasPedido);
  BitBtnAceptarDatosBD.Enabled:=False;
  BitBtnAltaEan.Enabled:=False;
  BitBtnDAltaCod.Enabled:=False;
  PanelEdicion.Visible:=False;
end;

//end;
//=============== EVENTOS EXIT DE LOS EDIT ==============
//Comprobar que los contenidos sean números y mostrar resultados

procedure TfImportar.eCodigoExit(Sender: TObject);
begin
  if (NOT(EsNumero(eCodigoHasta.Text)) OR NOT((eCodigoDesde.Text<>'') AND (StrToInt(eCodigoDesde.Text) < StrToInt(eCodigoHasta.Text)))) then
    begin eCodigoHasta.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportar.eCodigoDesdeExit(Sender: TObject);
begin
  if not (EsNumero(eCodigoDesde.Text)) then begin eCodigoDesde.Text:=''; exit; end;
end;

procedure TfImportar.eEANExit(Sender: TObject);
begin
  if (NOT (EsNumero(eEANHasta.Text)) OR NOT((eEANDesde.Text<>'') AND (StrToInt(eEANDesde.Text) < StrToInt(eEANHasta.Text)))) then
    begin eEANHasta.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportar.eEANDesdeExit(Sender: TObject);
begin
  if not (EsNumero(eEANDesde.Text)) then begin eEANDesde.Text:=''; exit; end;
end;

procedure TfImportar.eNombreExit(Sender: TObject);
begin
  if (NOT (EsNumero(eNombreHasta.Text)) OR NOT((eNombreDesde.Text<>'') AND (StrToInt(eNombreDesde.Text) < StrToInt(eNombreHasta.Text)))) then
    begin eNombreHasta.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportar.eNombreDesdeExit(Sender: TObject);
begin
  if not (EsNumero(eNombreDesde.Text)) then begin eNombreDesde.Text:=''; exit; end;
end;

procedure TfImportar.eCostoHastaExit(Sender: TObject);
begin
  if (NOT (EsNumero(eCostoHasta.Text)) OR NOT((eCostoDesde.Text<>'') AND (StrToInt(eCostoDesde.Text) < StrToInt(eCostoHasta.Text)))) then
    begin eCostoHasta.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportar.eCostoDesdeExit(Sender: TObject);
begin
  if not (EsNumero(eCostoDesde.Text)) then begin eCostoDesde.Text:=''; exit; end;
end;

procedure TfImportar.eDecCostoHastaExit(Sender: TObject);
begin
  if (NOT (EsNumero(eDecCostoHasta.Text)) OR NOT((eDecCostoDesde.Text<>'') AND (StrToInt(eDecCostoDesde.Text) < StrToInt(eDecCostoHasta.Text)))) then
    begin eDecCostoHasta.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportar.eDecCostoDesdeExit(Sender: TObject);
begin
  if not (EsNumero(eDecCostoDesde.Text)) then begin eDecCostoDesde.Text:=''; exit; end;
end;

procedure TfImportar.eDecPVPHastaExit(Sender: TObject);
begin
  if (NOT (EsNumero(eDecPVPHasta.Text)) OR NOT((eDecPVPDesde.Text<>'') AND (StrToInt(eDecPVPDesde.Text) < StrToInt(eDecPVPHasta.Text)))) then
    begin eDecPVPHasta.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportar.eDecPVPDesdeExit(Sender: TObject);
begin
  if not (EsNumero(eDecPVPDesde.Text)) then begin eDecPVPDesde.Text:=''; exit; end;
end;

procedure TfImportar.eIVAHastaExit(Sender: TObject);
begin
  if (NOT (EsNumero(eIVAHasta.Text)) OR NOT ((eIVADesde.Text<>'') AND (StrToInt(eIVADesde.Text) < StrToInt(eIVAHasta.Text)))) then
    begin eIVAHasta.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportar.eIVADesdeExit(Sender: TObject);
begin
  if not (EsNumero(eIVADesde.Text)) then begin eIVADesde.Text:=''; exit; end;
end;

procedure TfImportar.ePVPHastaExit(Sender: TObject);
begin
  if (NOT (EsNumero(ePVPHasta.Text)) OR NOT ((ePVPDesde.Text<>'') AND (StrToInt(ePVPDesde.Text) < StrToInt(ePVPHasta.Text)))) then
    begin ePVPHasta.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportar.ePVPDesdeExit(Sender: TObject);
begin
  if not (EsNumero(ePVPDesde.Text)) then begin ePVPDesde.Text:=''; exit; end;
end;

procedure TfImportar.eUnidHastaExit(Sender: TObject);
begin
  if (not (EsNumero(eUnidHasta.Text)) OR NOT ((eUnidDesde.Text<>'') AND (StrToInt(eUnidDesde.Text) < StrToInt(eUnidHasta.Text)))) then
    begin eUnidHasta.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportar.eUnidDesdeExit(Sender: TObject);
begin
  if not (EsNumero(eUnidDesde.Text)) then begin eUnidDesde.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportar.eOCostoExit(Sender: TObject);
begin
  if not (EsNumero(eOCosto.Text)) then begin eOCosto.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportar.eODesCostoExit(Sender: TObject);
begin
  if not (EsNumero(eODecCosto.Text)) then begin eODecCosto.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportar.eODesPVPExit(Sender: TObject);
begin
  if not (EsNumero(eODecPVP.Text)) then begin eOPVP.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportar.eOIVAExit(Sender: TObject);
begin
  if not (EsNumero(eOIVA.Text)) then begin eOIVA.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportar.eOPVPExit(Sender: TObject);
begin
  if not (EsNumero(eOPVP.Text)) then begin eOPVP.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportar.eOUnidadesExit(Sender: TObject);
begin
  if not (EsNumero(eOUnidades.Text)) then begin eOUnidades.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportar.eOCodigoExit(Sender: TObject);
begin
  if not (EsNumero(eOCodigo.Text)) then begin eOUnidades.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportar.eOEANExit(Sender: TObject);
begin
  if not (EsNumero(eOEAN.Text)) then begin eOUnidades.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportar.eONombreExit(Sender: TObject);
begin
  if not (EsNumero(eONombre.Text)) then begin eOUnidades.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportar.SynEdit1Click(Sender: TObject);
begin
  ePos.Text:=IntToStr(SynEdit1.CaretX);
end;

procedure TfImportar.btnGenerarClick(Sender: TObject);
begin
  if FLX_EsFicheroExcel(OpenDialog1.FileName) then
  begin
    Formatear();
    if Length(ArrayDeLineasPedido)=0 then Exit;
  end;

  tsProcesados.Enabled:=true;
  tsPendientes.Enabled:=true;
  pc.ActivePage:=tsPendientes;
  btnAPedido.Visible:=True;
  btnAPedido.Enabled:=True;
  //Formatear();



  //  MIRAR ESTO, DE MOMENTO EL IF NO HACE NADA



  if ((pc.ActivePage=tsProcesados) OR (pc.ActivePage=tsPendientes)) then
     //DistribuirLineasPedido(ArrayDeLineasPedidoPen)   // Activada la pestaña de Pendientes o Procesados
     DistribuirLineasPedido(ArrayDeLineasPedido)
  else DistribuirLineasPedido(ArrayDeLineasPedido);   // Activadas las pestañas de Formateo
end;

procedure TfImportar.BitBtn6Click(Sender: TObject);
begin
  PanelEdicion.Visible:=False;
end;

//procedure TfImportar.BitBtn6Click(Sender: TObject);
//var
//i:integer;
//begin
//Write('longidud del vector ');writeLn(Length(ArrayDeLineasPedido)-1);
//showmessage('Pinto todas las lineas');
//    for i:=0 to Length(ArrayDeLineasPedido)-1 do
//  writeLinea(ArrayDeLineasPedido[i]);
//end;

procedure TfImportar.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;
//procedure TfImportar.FormCreate(Sender: TObject;FPedido: TFPedido);
procedure TfImportar.FormCreate(Sender: TObject);
begin
  FCabeceraPrincipal:=nil;
  FTituloPrincipal:=nil;
  FSubtituloPrincipal:=nil;
  FSortColDatos:=-1;
  FSortColProcesados:=-1;
  FSortColPendientes:=-1;
  FSortAscDatos:=True;
  FSortAscProcesados:=True;
  FSortAscPendientes:=True;
  FMoviendoPanelEdicion:=False;
  FPanelEdicionMovidoPorUsuario:=False;
  FPanelPasoSeleccionar:=nil;
  FPanelPasoAnalizar:=nil;
  FPanelPasoPedido:=nil;
  FPanelPasoSalir:=nil;
  FDescPasoSeleccionar:=nil;
  FDescPasoAnalizar:=nil;
  FDescPasoPedido:=nil;
  FDescPasoSalir:=nil;
  FLabelAyudaPosicion:=nil;

  KeyPreview:=True;
  OnResize:=@FormResize;
  OnKeyDown:=@FormKeyDown;
  sgDatos.OnMouseDown:=@GridHeaderMouseDown;
  dbgProcesados.OnMouseDown:=@GridHeaderMouseDown;
  dbgPendientes.OnMouseDown:=@GridHeaderMouseDown;
  dbgPendientes.OnDrawCell:=@dbgProcesadosDrawCell;

  CrearCabeceraPrincipal;
  CrearPanelesAccionPrincipal;
  CrearAyudaPosicion;
  AplicarEstiloModerno;
  RecolocarControles;

  //--------- Conectar con la bbdd
  //Conectate(dbConnect);       // Utilizamos datamodule1.dbConexión para toda la aplicación.
  pc.ActivePage:=tsSeleccion;
end;

procedure TfImportar.FormShow(Sender: TObject);
begin
  btnGenerar.Enabled:=False;
  tsProcesados.Enabled:=False;
  tsPendientes.Enabled:=False;
  PanelEdicion.Visible:=False;
  // El tercer paso permanece visible para que el flujo sea comprensible,
  // pero sólo se activa después de analizar correctamente el fichero.
  btnAPedido.Visible:=True;
  btnAPedido.Enabled:=False;
  if not DirectoryExists(RutaSql+'selecciones') then
    CreateDir(RutaSql+'selecciones');

  // En OnShow los controles GTK ya disponen de widget nativo.
  AplicarContrasteSeleccionControles(Self);
  RecolocarControles;
  if btnSeleccionar.CanFocus then btnSeleccionar.SetFocus;
end;

procedure TfImportar.FormResize(Sender: TObject);
begin
  RecolocarControles;
end;

procedure TfImportar.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key<>VK_ESCAPE then Exit;

  // Primero se cierra el panel auxiliar. Sólo desde la pantalla principal
  // se ejecuta la misma acción que el botón Salir.
  if PanelEdicion.Visible then
  begin
    Key:=0;
    BitBtn6Click(Self);
    Exit;
  end;

  Key:=0;
  btnSalirClick(Self);
end;

procedure TfImportar.GridHeaderMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  if (Button<>mbLeft) or not (Sender is TStringGrid) then Exit;
  TStringGrid(Sender).MouseToCell(X,Y,ACol,ARow);
  if (ARow<>0) or (ACol<0) or (ACol>=TStringGrid(Sender).ColCount-1) then Exit;

  if Sender=sgDatos then
    OrdenarStringGrid(sgDatos,ACol,FSortColDatos,FSortAscDatos)
  else if Sender=dbgProcesados then
    OrdenarStringGrid(dbgProcesados,ACol,FSortColProcesados,FSortAscProcesados)
  else if Sender=dbgPendientes then
    OrdenarStringGrid(dbgPendientes,ACol,FSortColPendientes,FSortAscPendientes);
end;

procedure TfImportar.CrearCabeceraPrincipal;
begin
  if Assigned(FCabeceraPrincipal) then Exit;

  FCabeceraPrincipal:=TPanel.Create(Self);
  FCabeceraPrincipal.Parent:=Self;
  FCabeceraPrincipal.BevelOuter:=bvNone;
  FCabeceraPrincipal.Color:=RGBToColor(31,78,121);
  FCabeceraPrincipal.SetBounds(0,0,ClientWidth,72);

  FTituloPrincipal:=TLabel.Create(Self);
  FTituloPrincipal.Parent:=FCabeceraPrincipal;
  FTituloPrincipal.AutoSize:=False;
  FTituloPrincipal.SetBounds(22,12,520,28);
  FTituloPrincipal.Caption:='IMPORTACIÓN DE PEDIDOS';
  FTituloPrincipal.ParentFont:=False;
  FTituloPrincipal.Font.Name:='Sans';
  FTituloPrincipal.Font.Height:=-22;
  FTituloPrincipal.Font.Style:=[fsBold];
  FTituloPrincipal.Font.Color:=clWhite;
  FTituloPrincipal.Transparent:=True;

  FSubtituloPrincipal:=TLabel.Create(Self);
  FSubtituloPrincipal.Parent:=FCabeceraPrincipal;
  FSubtituloPrincipal.AutoSize:=False;
  FSubtituloPrincipal.SetBounds(24,42,720,20);
  FSubtituloPrincipal.Caption:='Seleccione el fichero, revise la estructura y resuelva las líneas pendientes antes de crear el pedido';
  FSubtituloPrincipal.ParentFont:=False;
  FSubtituloPrincipal.Font.Name:='Sans';
  FSubtituloPrincipal.Font.Height:=-12;
  FSubtituloPrincipal.Font.Color:=RGBToColor(220,235,248);
  FSubtituloPrincipal.Transparent:=True;
end;

procedure TfImportar.CrearPanelesAccionPrincipal;

  procedure PrepararPaso(var APanel: TPanel; var ADescripcion: TLabel;
    AButton: TBitBtn; const AColor: TColor; const ATexto: String);
  begin
    APanel:=TPanel.Create(Self);
    APanel.Parent:=Panel1;
    APanel.BevelOuter:=bvNone;
    APanel.Color:=AColor;

    AButton.Parent:=APanel;

    ADescripcion:=TLabel.Create(Self);
    ADescripcion.Parent:=APanel;
    ADescripcion.AutoSize:=False;
    ADescripcion.Alignment:=taCenter;
    ADescripcion.Layout:=tlCenter;
    ADescripcion.WordWrap:=True;
    ADescripcion.Transparent:=True;
    ADescripcion.ParentFont:=False;
    ADescripcion.Font.Name:='Sans';
    ADescripcion.Font.Height:=-11;
    ADescripcion.Font.Color:=RGBToColor(48,64,80);
    ADescripcion.Caption:=ATexto;
  end;

begin
  if Assigned(FPanelPasoSeleccionar) then Exit;

  PrepararPaso(FPanelPasoSeleccionar,FDescPasoSeleccionar,btnSeleccionar,
    RGBToColor(224,239,252),'TXT, CSV o XLSX. Muestra una vista previa del contenido.');
  PrepararPaso(FPanelPasoAnalizar,FDescPasoAnalizar,btnGenerar,
    RGBToColor(255,244,213),'Lee las columnas, identifica artículos y separa las incidencias.');
  PrepararPaso(FPanelPasoPedido,FDescPasoPedido,btnAPedido,
    RGBToColor(226,244,232),'Añade al pedido las líneas ya revisadas y preparadas.');
  PrepararPaso(FPanelPasoSalir,FDescPasoSalir,btnSalir,
    RGBToColor(239,242,245),'Cierra esta pantalla sin continuar con la importación.');
end;

procedure TfImportar.CrearAyudaPosicion;
begin
  if Assigned(FLabelAyudaPosicion) then Exit;

  FLabelAyudaPosicion:=TLabel.Create(Self);
  FLabelAyudaPosicion.Parent:=tsSeleccion;
  FLabelAyudaPosicion.AutoSize:=False;
  FLabelAyudaPosicion.Transparent:=True;
  FLabelAyudaPosicion.ParentFont:=False;
  FLabelAyudaPosicion.Font.Name:='Sans';
  FLabelAyudaPosicion.Font.Height:=-11;
  FLabelAyudaPosicion.Font.Color:=RGBToColor(74,89,104);
  FLabelAyudaPosicion.Caption:=
    'Haga clic en la vista previa: esta columna sirve de referencia para completar DESDE y HASTA.';
end;

procedure TfImportar.ConfigurarBotonesPlantilla;

  procedure Preparar(ABoton: TSpeedButton; const ACaption, AHint: String);
  begin
    ABoton.AutoSize:=False;
    ABoton.Flat:=False;
    ABoton.Layout:=blGlyphLeft;
    ABoton.Spacing:=6;
    ABoton.Caption:=ACaption;
    ABoton.Hint:=AHint;
    ABoton.ShowHint:=True;
  end;

begin
  Preparar(sbLimpiar1,'Limpiar campos',
    'Borra todas las posiciones DESDE/HASTA de esta plantilla.');
  Preparar(sbSave1,'Guardar plantilla',
    'Guarda las posiciones actuales para reutilizarlas con este proveedor.');
  Preparar(sbLoad1,'Cargar plantilla',
    'Recupera una plantilla de posiciones guardada anteriormente.');

  Preparar(sbLimpiar2,'Limpiar campos',
    'Borra el delimitador y el orden de las columnas configuradas.');
  Preparar(sbSave2,'Guardar plantilla',
    'Guarda el delimitador y el orden actual de las columnas.');
  Preparar(sbLoad2,'Cargar plantilla',
    'Recupera una plantilla delimitada guardada anteriormente.');
end;

procedure TfImportar.EstiloTitulo(ALabel: TLabel);
begin
  if not Assigned(ALabel) then Exit;
  ALabel.ParentFont:=False;
  ALabel.Font.Name:='Sans';
  ALabel.Font.Height:=-15;
  ALabel.Font.Style:=[fsBold];
  ALabel.Font.Color:=clWhite;
  ALabel.Color:=RGBToColor(47,99,145);
  ALabel.Transparent:=False;
  ALabel.Alignment:=taCenter;
  ALabel.Layout:=tlCenter;
end;

procedure TfImportar.ConfigurarStringGrid(AGrid: TStringGrid);
begin
  if not Assigned(AGrid) then Exit;
  AGrid.ParentFont:=False;
  AGrid.Font.Name:='Sans';
  AGrid.Font.Height:=-13;
  AGrid.Font.Color:=RGBToColor(30,43,56);
  AGrid.Color:=clWhite;
  AGrid.FixedColor:=RGBToColor(218,231,244);
  AGrid.DefaultRowHeight:=27;
  AGrid.GridLineWidth:=1;
  AGrid.ScrollBars:=ssAutoBoth;
  AGrid.ShowHint:=True;
  AGrid.Hint:='Pulse una cabecera para ordenar por esa columna';
  if AGrid.ColCount>7 then AGrid.ColWidths[7]:=0;
  AGrid.Options:=AGrid.Options+
    [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goRangeSelect,
     goColSizing,goSmoothScroll];
end;

procedure TfImportar.AplicarEstiloModerno;
var
  I: Integer;
  C: TComponent;
  B: TBitBtn;
begin
  Caption:='Importar pedidos - FacturLinEx';
  Color:=RGBToColor(241,246,251);
  Font.Name:='Sans';
  Font.Color:=RGBToColor(35,52,70);
  Constraints.MinWidth:=980;
  Constraints.MinHeight:=700;
  WindowState:=wsMaximized;

  SpeedButton1.Visible:=False;
  Panel1.Align:=alNone;
  Panel1.BevelOuter:=bvNone;
  Panel1.Color:=RGBToColor(226,238,248);
  Panel2.BevelOuter:=bvNone;
  Panel2.Color:=RGBToColor(248,250,253);
  Panel3.BevelOuter:=bvNone;
  Panel3.Color:=RGBToColor(248,250,253);
  Panel4.BevelOuter:=bvNone;
  Panel4.Color:=RGBToColor(248,250,253);
  PanelEdicion.BevelOuter:=bvNone;
  PanelEdicion.Color:=RGBToColor(248,250,253);

  pc.ParentFont:=False;
  pc.Font.Name:='Sans';
  pc.Font.Height:=-13;
  pc.Font.Style:=[fsBold];
  pc.Font.Color:=RGBToColor(28,55,82);

  Memo1.ParentFont:=False;
  Memo1.Font.Name:='Monospace';
  Memo1.Font.Height:=-13;
  Memo1.Font.Color:=RGBToColor(28,42,56);
  Memo1.Color:=RGBToColor(255,252,232);

  SynEdit1.Color:=clWhite;
  SynEdit1.Font.Name:='Monospace';
  SynEdit1.Font.Height:=-13;

  for I:=0 to ComponentCount-1 do
  begin
    C:=Components[I];
    if C is TLabel then
    begin
      TLabel(C).ParentFont:=False;
      TLabel(C).Font.Name:='Sans';
      TLabel(C).Font.Height:=-13;
      TLabel(C).Font.Color:=RGBToColor(35,52,70);
      TLabel(C).Transparent:=True;
    end
    else if C is TCustomEdit then
    begin
      // TCustomEdit no publica ParentFont en Lazarus 4.x.
      TCustomEdit(C).Font.Name:='Sans';
      TCustomEdit(C).Font.Height:=-13;
      TCustomEdit(C).Font.Color:=clWindowText;
      TCustomEdit(C).Color:=clWindow;
      AplicarContrasteSeleccion(TWinControl(C));
    end
    else if C is TCheckBox then
    begin
      TCheckBox(C).ParentFont:=False;
      TCheckBox(C).Font.Name:='Sans';
      TCheckBox(C).Font.Height:=-13;
      TCheckBox(C).Font.Style:=[fsBold];
      TCheckBox(C).Font.Color:=RGBToColor(25,55,80);
      TCheckBox(C).Color:=PanelEdicion.Color;
    end
    else if C is TBitBtn then
    begin
      B:=TBitBtn(C);
      B.ParentFont:=False;
      B.Font.Name:='Sans';
      B.Font.Height:=-13;
      B.Font.Style:=[fsBold];
      B.Font.Color:=RGBToColor(24,48,72);
    end
    else if C is TSpeedButton then
    begin
      TSpeedButton(C).ParentFont:=False;
      TSpeedButton(C).Font.Name:='Sans';
      TSpeedButton(C).Font.Height:=-12;
      TSpeedButton(C).Font.Style:=[fsBold];
      TSpeedButton(C).Flat:=False;
    end;
  end;

  // Colores semánticos y títulos que deben conservar contraste propio.
  // Restaurar los colores de la cabecera, ya que sus labels dinámicos
  // también forman parte de Components[] y han pasado por el bucle general.
  if Assigned(FTituloPrincipal) then
  begin
    FTituloPrincipal.Font.Name:='Sans';
    FTituloPrincipal.Font.Height:=-22;
    FTituloPrincipal.Font.Style:=[fsBold];
    FTituloPrincipal.Font.Color:=clWhite;
    FTituloPrincipal.Transparent:=True;
  end;
  if Assigned(FSubtituloPrincipal) then
  begin
    FSubtituloPrincipal.Font.Name:='Sans';
    FSubtituloPrincipal.Font.Height:=-12;
    FSubtituloPrincipal.Font.Style:=[];
    FSubtituloPrincipal.Font.Color:=RGBToColor(220,235,248);
    FSubtituloPrincipal.Transparent:=True;
  end;

  if Assigned(FDescPasoSeleccionar) then
  begin
    FDescPasoSeleccionar.Font.Height:=-11;
    FDescPasoSeleccionar.Font.Color:=RGBToColor(48,64,80);
    FDescPasoAnalizar.Font.Height:=-11;
    FDescPasoAnalizar.Font.Color:=RGBToColor(48,64,80);
    FDescPasoPedido.Font.Height:=-11;
    FDescPasoPedido.Font.Color:=RGBToColor(48,64,80);
    FDescPasoSalir.Font.Height:=-11;
    FDescPasoSalir.Font.Color:=RGBToColor(48,64,80);
  end;
  if Assigned(FLabelAyudaPosicion) then
  begin
    FLabelAyudaPosicion.Font.Height:=-11;
    FLabelAyudaPosicion.Font.Style:=[];
    FLabelAyudaPosicion.Font.Color:=RGBToColor(74,89,104);
  end;

  Label29.Font.Color:=RGBToColor(25,105,70);
  Label29.Font.Style:=[fsBold];
  Label30.Font.Color:=RGBToColor(145,91,0);
  Label30.Font.Style:=[fsBold];
  Label31.Font.Color:=RGBToColor(180,40,40);
  Label31.Font.Style:=[fsBold];
  EstiloTitulo(Label72);

  // Campos informativos de base de datos diferenciados de los editables.
  EditBDCodigo.Color:=RGBToColor(235,241,246);
  EditBDNombre.Color:=RGBToColor(235,241,246);
  EditBDEan.Color:=RGBToColor(235,241,246);
  EditBDCodigo.Font.Color:=RGBToColor(40,58,75);
  EditBDNombre.Font.Color:=RGBToColor(40,58,75);
  EditBDEan.Font.Color:=RGBToColor(40,58,75);

  // Flujo principal expresado como pasos y acciones inequívocas.
  btnSeleccionar.Caption:='1. ELEGIR ARCHIVO';
  btnSeleccionar.Hint:='Seleccione el fichero TXT, CSV o XLSX recibido del proveedor.';
  btnGenerar.Caption:='2. ANALIZAR DATOS';
  btnGenerar.Hint:='Lee el fichero con la plantilla elegida y clasifica las líneas.';
  btnAPedido.Caption:='3. CREAR PEDIDO';
  btnAPedido.Hint:='Incorpora al pedido las líneas procesadas y revisadas.';
  btnSalir.Caption:='CERRAR';
  btnSalir.Hint:='Cierra la importación sin añadir nuevas líneas al pedido.';

  btnSeleccionar.Layout:=blGlyphLeft;
  btnGenerar.Layout:=blGlyphLeft;
  btnAPedido.Layout:=blGlyphLeft;
  btnSalir.Layout:=blGlyphLeft;
  btnSeleccionar.Spacing:=8;
  btnGenerar.Spacing:=8;
  btnAPedido.Spacing:=8;
  btnSalir.Spacing:=8;
  btnSeleccionar.ShowHint:=True;
  btnGenerar.ShowHint:=True;
  btnAPedido.ShowHint:=True;
  btnSalir.ShowHint:=True;

  // Acciones del panel de resolución de incidencias.
  BitBtnDAltaCod.Caption:='Crear artículo nuevo';
  BitBtnDAltaCod.Hint:='Da de alta un artículo nuevo con los datos de la línea pendiente.';
  BitBtnAltaEan.Caption:='Crear EAN / auxiliar';
  BitBtnAltaEan.Hint:='Asocia el EAN o código auxiliar de la línea al artículo seleccionado.';
  BitBtnAceptarDatosBD.Caption:='Usar artículo existente';
  BitBtnAceptarDatosBD.Hint:='Resuelve la línea utilizando el código y descripción existentes en la base de datos.';
  BitBtn6.Caption:='Cerrar edición';
  BitBtn6.Hint:='Cierra este panel sin aceptar otra acción.';
  BitBtnDAltaCod.ShowHint:=True;
  BitBtnAltaEan.ShowHint:=True;
  BitBtnAceptarDatosBD.ShowHint:=True;
  BitBtn6.ShowHint:=True;

  Label13.Caption:='Columna actual del cursor:';
  Label13.Hint:='Número de carácter donde está situado el cursor en la vista previa.';
  Label13.ShowHint:=True;
  ePos.ReadOnly:=True;
  ePos.TabStop:=False;
  ePos.Alignment:=taCenter;
  ePos.Color:=RGBToColor(235,241,246);
  ePos.Font.Style:=[fsBold];
  ePos.Hint:='Use este número para completar las columnas DESDE y HASTA del campo correspondiente.';
  ePos.ShowHint:=True;

  ConfigurarBotonesPlantilla;
  ConfigurarStringGrid(sgDatos);
  ConfigurarStringGrid(dbgProcesados);
  ConfigurarStringGrid(dbgPendientes);

  Label72.Cursor:=crSizeAll;
  Label72.Hint:='Arrastre esta cabecera para mover el panel';
  Label72.ShowHint:=True;
  Label72.OnMouseDown:=@PanelEdicionDragMouseDown;
  Label72.OnMouseMove:=@PanelEdicionDragMouseMove;
  Label72.OnMouseUp:=@PanelEdicionDragMouseUp;
  PanelEdicion.OnMouseMove:=@PanelEdicionDragMouseMove;
  PanelEdicion.OnMouseUp:=@PanelEdicionDragMouseUp;
end;

procedure TfImportar.RecolocarControles;
var
  Ancho, AltoDisponible, AltoPC: Integer;
  Margen, Separacion, AnchoSalir, AnchoPaso, X: Integer;
begin
  if ClientWidth<1 then Exit;
  Ancho:=ClientWidth;

  if Assigned(FCabeceraPrincipal) then
  begin
    FCabeceraPrincipal.SetBounds(0,0,Ancho,72);
    FCabeceraPrincipal.BringToFront;
  end;

  Panel1.SetBounds(0,72,Ancho,118);

  // Tarjetas de proceso: el usuario ve siempre qué hace cada paso y en qué orden.
  Margen:=18;
  Separacion:=12;
  AnchoSalir:=140;
  AnchoPaso:=(Ancho-(Margen*2)-AnchoSalir-(Separacion*3)) div 3;
  if AnchoPaso<210 then AnchoPaso:=210;
  X:=Margen;
  FPanelPasoSeleccionar.SetBounds(X,8,AnchoPaso,102);
  Inc(X,AnchoPaso+Separacion);
  FPanelPasoAnalizar.SetBounds(X,8,AnchoPaso,102);
  Inc(X,AnchoPaso+Separacion);
  FPanelPasoPedido.SetBounds(X,8,AnchoPaso,102);
  Inc(X,AnchoPaso+Separacion);
  FPanelPasoSalir.SetBounds(X,8,Ancho-Margen-X,102);
  if FPanelPasoSalir.Width<AnchoSalir then FPanelPasoSalir.Width:=AnchoSalir;

  btnSeleccionar.SetBounds(8,7,FPanelPasoSeleccionar.Width-16,50);
  btnGenerar.SetBounds(8,7,FPanelPasoAnalizar.Width-16,50);
  btnAPedido.SetBounds(8,7,FPanelPasoPedido.Width-16,50);
  btnSalir.SetBounds(8,7,FPanelPasoSalir.Width-16,50);
  FDescPasoSeleccionar.SetBounds(10,60,FPanelPasoSeleccionar.Width-20,36);
  FDescPasoAnalizar.SetBounds(10,60,FPanelPasoAnalizar.Width-20,36);
  FDescPasoPedido.SetBounds(10,60,FPanelPasoPedido.Width-20,36);
  FDescPasoSalir.SetBounds(10,60,FPanelPasoSalir.Width-20,36);

  Memo1.SetBounds(16,202,Ancho-32,82);
  pc.Left:=16;
  pc.Top:=296;
  pc.Width:=Ancho-32;

  AltoDisponible:=ClientHeight-pc.Top-28;
  AltoPC:=AltoDisponible div 2;
  if AltoPC<230 then AltoPC:=230;
  if AltoPC>300 then AltoPC:=300;
  pc.Height:=AltoPC;

  Panel3.SetBounds(16,pc.Top+pc.Height+12,Ancho-32,
    ClientHeight-(pc.Top+pc.Height+28));
  if Panel3.Height<155 then Panel3.Height:=155;

  // Selección por posiciones. Las acciones de plantilla quedan identificadas
  // con texto y la columna del cursor se explica junto a la vista previa.
  Panel2.SetBounds(16,14,Max(650,Min(780,tsSeleccion.ClientWidth-190)),132);
  sbLimpiar1.SetBounds(tsSeleccion.ClientWidth-168,14,152,36);
  sbSave1.SetBounds(tsSeleccion.ClientWidth-168,56,152,36);
  sbLoad1.SetBounds(tsSeleccion.ClientWidth-168,98,152,36);
  if Assigned(FLabelAyudaPosicion) then
    FLabelAyudaPosicion.SetBounds(16,138,tsSeleccion.ClientWidth-206,18);
  SynEdit1.SetBounds(16,158,tsSeleccion.ClientWidth-206,
    tsSeleccion.ClientHeight-170);
  Label13.SetBounds(tsSeleccion.ClientWidth-174,142,158,20);
  ePos.SetBounds(tsSeleccion.ClientWidth-168,164,152,28);
  if SynEdit1.Height<36 then SynEdit1.Height:=36;

  // Campos de posiciones más amplios y alineados.
  eEANDesde.SetBounds(78,28,72,27); eEANHasta.SetBounds(158,28,72,27);
  eCodigoDesde.SetBounds(78,61,72,27); eCodigoHasta.SetBounds(158,61,72,27);
  eNombreDesde.SetBounds(78,94,72,27); eNombreHasta.SetBounds(158,94,72,27);
  eUnidDesde.SetBounds(330,28,72,27); eUnidHasta.SetBounds(410,28,72,27);
  eCostoDesde.SetBounds(330,61,72,27); eCostoHasta.SetBounds(410,61,72,27);
  eDecCostoDesde.SetBounds(330,94,72,27); eDecCostoHasta.SetBounds(410,94,72,27);
  eIVADesde.SetBounds(600,28,72,27); eIVAHasta.SetBounds(680,28,72,27);
  ePVPDesde.SetBounds(600,61,72,27); ePVPHasta.SetBounds(680,61,72,27);
  eDecPVPDesde.SetBounds(600,94,72,27); eDecPVPHasta.SetBounds(680,94,72,27);

  Label22.SetBounds(16,33,58,20); Label1.SetBounds(16,66,58,20);
  Label4.SetBounds(16,99,58,20);
  Label2.SetBounds(88,7,62,20); Label3.SetBounds(168,7,62,20);
  Label5.SetBounds(244,33,82,20); Label6.SetBounds(244,66,82,20);
  Label9.SetBounds(244,99,82,20);
  Label7.SetBounds(340,7,62,20); Label8.SetBounds(420,7,62,20);
  Label10.SetBounds(506,33,88,20); Label11.SetBounds(506,66,88,20);
  Label12.SetBounds(506,99,88,20);
  Label14.SetBounds(610,7,62,20); Label15.SetBounds(690,7,62,20);

  // Selección delimitada.
  Label27.SetBounds(22,18,210,24);
  eDelimitador.SetBounds(238,14,56,30);
  Panel4.SetBounds(22,52,Max(620,Min(700,tsDelimitado.ClientWidth-194)),140);
  sbLimpiar2.SetBounds(tsDelimitado.ClientWidth-168,52,152,38);
  sbSave2.SetBounds(tsDelimitado.ClientWidth-168,98,152,38);
  sbLoad2.SetBounds(tsDelimitado.ClientWidth-168,144,152,38);
  eOEAN.SetBounds(104,34,72,28); eOCodigo.SetBounds(104,72,72,28);
  eONombre.SetBounds(104,110,72,28);
  eOUnidades.SetBounds(326,34,72,28); eOCosto.SetBounds(326,72,72,28);
  eODesCosto.SetBounds(326,110,72,28);
  eOIVA.SetBounds(588,34,72,28); eOPVP.SetBounds(588,72,72,28);
  eODesPVP.SetBounds(588,110,72,28);
  Label24.SetBounds(22,39,78,20); Label16.SetBounds(22,77,78,20);
  Label20.SetBounds(22,115,78,20); Label17.SetBounds(110,8,70,20);
  Label21.SetBounds(220,39,102,20); Label23.SetBounds(220,77,102,20);
  Label32.SetBounds(220,115,102,20); Label18.SetBounds(332,8,70,20);
  Label25.SetBounds(500,39,84,20); Label26.SetBounds(482,77,102,20);
  Label33.SetBounds(482,115,102,20); Label19.SetBounds(592,8,70,20);

  // Los grids ocupan toda la pestaña o panel disponible.
  dbgProcesados.SetBounds(8,8,tsProcesados.ClientWidth-16,tsProcesados.ClientHeight-16);
  dbgPendientes.SetBounds(8,8,tsPendientes.ClientWidth-16,tsPendientes.ClientHeight-16);
  Label28.SetBounds(12,8,240,22);
  sgDatos.SetBounds(8,34,Panel3.ClientWidth-16,Panel3.ClientHeight-70);
  Label29.SetBounds(18,Panel3.ClientHeight-28,145,20);
  Label31.SetBounds(180,Panel3.ClientHeight-28,130,20);
  Label30.SetBounds(330,Panel3.ClientHeight-28,Panel3.ClientWidth-345,20);

  // Panel auxiliar de edición amplio, ordenado y móvil.
  PanelEdicion.Width:=Min(900,ClientWidth-48);
  PanelEdicion.Height:=430;
  Label72.SetBounds(0,0,PanelEdicion.Width,42);
  Label34.SetBounds(150,56,180,22);
  Label73.SetBounds(560,56,180,22);
  Label44.SetBounds(28,86,110,24); EditBDCodigo.SetBounds(150,84,300,28);
  Label45.SetBounds(28,120,110,24); EditPenCodigo.SetBounds(150,118,300,28);
  EditBDEan.SetBounds(560,84,PanelEdicion.Width-590,28);
  EditPenEan.SetBounds(560,118,PanelEdicion.Width-590,28);
  Label35.SetBounds(150,160,180,22);
  Label38.SetBounds(28,190,110,24); EditBDNombre.SetBounds(150,188,PanelEdicion.Width-180,29);
  Label39.SetBounds(28,226,110,24); EditPenNombre.SetBounds(150,224,PanelEdicion.Width-180,29);
  BitBtnDAltaCod.SetBounds(28,278,160,38);
  BitBtnAltaEan.SetBounds(204,278,160,38);
  BitBtnAceptarDatosBD.SetBounds(380,278,PanelEdicion.Width-408,38);
  cbCodtxtAEan.SetBounds(30,334,PanelEdicion.Width-60,24);
  BitBtn6.SetBounds((PanelEdicion.Width-120) div 2,378,120,38);

  if not FPanelEdicionMovidoPorUsuario then
  begin
    PanelEdicion.Left:=(ClientWidth-PanelEdicion.Width) div 2;
    PanelEdicion.Top:=(ClientHeight-PanelEdicion.Height) div 2;
  end
  else
    LimitarPanelEdicionAlAreaVisible;

  if PanelEdicion.Visible then PanelEdicion.BringToFront;
end;

function TfImportar.CompararValoresGrid(const A, B: String): Integer;
var
  SA, SB: String;
  NA, NB: Double;
  DA, DB: TDateTime;
  FS: TFormatSettings;
begin
  SA:=Trim(A); SB:=Trim(B);
  FS:=DefaultFormatSettings;
  FS.DecimalSeparator:='.';
  FS.ThousandSeparator:=#0;

  SA:=StringReplace(SA,' ','',[rfReplaceAll]);
  SB:=StringReplace(SB,' ','',[rfReplaceAll]);
  if (Pos(',',SA)>0) and (Pos('.',SA)>0) then SA:=StringReplace(SA,'.','',[rfReplaceAll]);
  if (Pos(',',SB)>0) and (Pos('.',SB)>0) then SB:=StringReplace(SB,'.','',[rfReplaceAll]);
  SA:=StringReplace(SA,',','.',[rfReplaceAll]);
  SB:=StringReplace(SB,',','.',[rfReplaceAll]);

  if TryStrToFloat(SA,NA,FS) and TryStrToFloat(SB,NB,FS) then
  begin
    if NA<NB then Exit(-1);
    if NA>NB then Exit(1);
    Exit(0);
  end;

  if TryStrToDate(A,DA) and TryStrToDate(B,DB) then
  begin
    if DA<DB then Exit(-1);
    if DA>DB then Exit(1);
    Exit(0);
  end;

  Result:=CompareText(Trim(A),Trim(B));
end;

procedure TfImportar.MarcarColumnaOrdenada(AGrid: TStringGrid; ACol: Integer;
  AAscendente: Boolean);
var
  I: Integer;
  S: String;
begin
  if not Assigned(AGrid) then Exit;
  for I:=0 to AGrid.Columns.Count-1 do
  begin
    S:=AGrid.Columns[I].Title.Caption;
    S:=StringReplace(S,' ▲','',[rfReplaceAll]);
    S:=StringReplace(S,' ▼','',[rfReplaceAll]);
    AGrid.Columns[I].Title.Caption:=S;
  end;
  if (ACol<0) or (ACol>=AGrid.Columns.Count) then Exit;
  if AAscendente then
    AGrid.Columns[ACol].Title.Caption:=AGrid.Columns[ACol].Title.Caption+' ▲'
  else
    AGrid.Columns[ACol].Title.Caption:=AGrid.Columns[ACol].Title.Caption+' ▼';
end;

procedure TfImportar.OrdenarStringGrid(AGrid: TStringGrid; ACol: Integer;
  var AColOrdenada: Integer; var AAscendente: Boolean);
var
  DireccionAsc: Boolean;
  procedure IntercambiarFilas(R1, R2: Integer);
  var C: Integer; T: String;
  begin
    if R1=R2 then Exit;
    for C:=0 to AGrid.ColCount-1 do
    begin
      T:=AGrid.Cells[C,R1];
      AGrid.Cells[C,R1]:=AGrid.Cells[C,R2];
      AGrid.Cells[C,R2]:=T;
    end;
  end;
  procedure QuickSort(L, R: Integer);
  var I, J: Integer; P: String;
  begin
    I:=L; J:=R; P:=AGrid.Cells[ACol,(L+R) div 2];
    repeat
      if DireccionAsc then
      begin
        while CompararValoresGrid(AGrid.Cells[ACol,I],P)<0 do Inc(I);
        while CompararValoresGrid(AGrid.Cells[ACol,J],P)>0 do Dec(J);
      end
      else
      begin
        while CompararValoresGrid(AGrid.Cells[ACol,I],P)>0 do Inc(I);
        while CompararValoresGrid(AGrid.Cells[ACol,J],P)<0 do Dec(J);
      end;
      if I<=J then
      begin
        IntercambiarFilas(I,J);
        Inc(I); Dec(J);
      end;
    until I>J;
    if L<J then QuickSort(L,J);
    if I<R then QuickSort(I,R);
  end;
begin
  if (not Assigned(AGrid)) or (AGrid.RowCount<=AGrid.FixedRows+1) or
     (ACol<0) or (ACol>=AGrid.ColCount-1) then Exit;

  if AColOrdenada=ACol then
    AAscendente:=not AAscendente
  else
  begin
    AColOrdenada:=ACol;
    AAscendente:=True;
  end;
  DireccionAsc:=AAscendente;

  AGrid.Enabled:=False;
  try
    QuickSort(AGrid.FixedRows,AGrid.RowCount-1);
    MarcarColumnaOrdenada(AGrid,ACol,DireccionAsc);
    AGrid.Row:=AGrid.FixedRows;
  finally
    AGrid.Enabled:=True;
    AGrid.Invalidate;
  end;
end;

procedure TfImportar.DibujarCeldaGridLegible(AGrid: TStringGrid;
  ACol, ARow: Integer; ARect: TRect; AState: TGridDrawState);
var
  Texto: String;
  XTexto, YTexto: Integer;
begin
  if not Assigned(AGrid) then Exit;
  if gdFixed in AState then
  begin
    AGrid.Canvas.Brush.Color:=RGBToColor(218,231,244);
    AGrid.Canvas.Font.Color:=RGBToColor(28,55,82);
    AGrid.Canvas.Font.Style:=[fsBold];
  end
  else if gdSelected in AState then
  begin
    // Dibujo manual para impedir que el tema GTK vuelva a imponer
    // texto negro sobre el fondo azul de la selección.
    AGrid.Canvas.Brush.Color:=RGBToColor(42,86,132);
    AGrid.Canvas.Font.Color:=clWhite;
    AGrid.Canvas.Font.Style:=[];
  end
  else
  begin
    if Odd(ARow) then
      AGrid.Canvas.Brush.Color:=RGBToColor(247,250,253)
    else
      AGrid.Canvas.Brush.Color:=clWhite;
    AGrid.Canvas.Font.Color:=RGBToColor(30,43,56);
    AGrid.Canvas.Font.Style:=[];
  end;

  AGrid.Canvas.FillRect(ARect);
  Texto:=AGrid.Cells[ACol,ARow];
  if gdFixed in AState then
    XTexto:=ARect.Left+Max(5,((ARect.Right-ARect.Left)-AGrid.Canvas.TextWidth(Texto)) div 2)
  else
    XTexto:=ARect.Left+6;
  YTexto:=ARect.Top+Max(2,((ARect.Bottom-ARect.Top)-AGrid.Canvas.TextHeight(Texto)) div 2);
  AGrid.Canvas.TextRect(ARect,XTexto,YTexto,Texto);
end;

procedure TfImportar.AplicarContrasteSeleccion(AControl: TWinControl);
{$IFDEF LCLGTK2}
var
  FondoNormal, TextoNormal, FondoSeleccion, TextoSeleccion: TGdkColor;
  Widget: PGtkWidget;
{$ENDIF}
begin
  if not Assigned(AControl) then Exit;
  AControl.HandleNeeded;
  {$IFDEF LCLGTK2}
  Widget:=PGtkWidget(AControl.Handle);
  if Assigned(Widget) then
  begin
    gdk_color_parse(PChar('#FFFFFF'),@FondoNormal);
    gdk_color_parse(PChar('#101820'),@TextoNormal);
    gtk_widget_modify_base(Widget,GTK_STATE_NORMAL,@FondoNormal);
    gtk_widget_modify_text(Widget,GTK_STATE_NORMAL,@TextoNormal);
    gdk_color_parse(PChar('#2A5684'),@FondoSeleccion);
    gdk_color_parse(PChar('#FFFFFF'),@TextoSeleccion);
    gtk_widget_modify_base(Widget,GTK_STATE_SELECTED,@FondoSeleccion);
    gtk_widget_modify_text(Widget,GTK_STATE_SELECTED,@TextoSeleccion);
  end;
  {$ENDIF}
end;

procedure TfImportar.AplicarContrasteSeleccionControles(AParent: TWinControl);
var
  I: Integer;
  C: TControl;
begin
  if not Assigned(AParent) then Exit;
  for I:=0 to AParent.ControlCount-1 do
  begin
    C:=AParent.Controls[I];
    if C is TCustomEdit then
      AplicarContrasteSeleccion(TWinControl(C));
    if C is TWinControl then
      AplicarContrasteSeleccionControles(TWinControl(C));
  end;
end;

procedure TfImportar.LimitarPanelEdicionAlAreaVisible;
var
  MaxLeft, MaxTop: Integer;
begin
  MaxLeft:=ClientWidth-PanelEdicion.Width;
  MaxTop:=ClientHeight-PanelEdicion.Height;
  if MaxLeft<0 then MaxLeft:=0;
  if MaxTop<0 then MaxTop:=0;
  if PanelEdicion.Left<0 then PanelEdicion.Left:=0;
  if PanelEdicion.Top<0 then PanelEdicion.Top:=0;
  if PanelEdicion.Left>MaxLeft then PanelEdicion.Left:=MaxLeft;
  if PanelEdicion.Top>MaxTop then PanelEdicion.Top:=MaxTop;
end;

procedure TfImportar.PanelEdicionDragMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  P, OrigenPanel: TPoint;
begin
  if (Button<>mbLeft) or not (Sender is TControl) then Exit;
  P:=TControl(Sender).ClientToScreen(Point(X,Y));
  OrigenPanel:=PanelEdicion.ClientToScreen(Point(0,0));
  FPanelEdicionDragOffset:=Point(P.X-OrigenPanel.X,P.Y-OrigenPanel.Y);
  FMoviendoPanelEdicion:=True;
  FPanelEdicionMovidoPorUsuario:=True;
  SetCapture(PanelEdicion.Handle);
end;

procedure TfImportar.PanelEdicionDragMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  P, OrigenPadre: TPoint;
begin
  if (not FMoviendoPanelEdicion) or not (Sender is TControl) then Exit;
  P:=TControl(Sender).ClientToScreen(Point(X,Y));
  OrigenPadre:=ClientToScreen(Point(0,0));
  PanelEdicion.Left:=P.X-FPanelEdicionDragOffset.X-OrigenPadre.X;
  PanelEdicion.Top:=P.Y-FPanelEdicionDragOffset.Y-OrigenPadre.Y;
  LimitarPanelEdicionAlAreaVisible;
end;

procedure TfImportar.PanelEdicionDragMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button<>mbLeft then Exit;
  FMoviendoPanelEdicion:=False;
  ReleaseCapture;
  LimitarPanelEdicionAlAreaVisible;
end;

procedure TfImportar.Label72Click(Sender: TObject);
begin

end;

procedure TfImportar.MostrarPosicion(Sender: TObject);
begin

end;



//procedure TfImportar.MostrarPosicion(Sender: TObject);
//begin
//  ePos.Text:=IntToStr(SynEdit1.CaretX);
//end;

initialization
  {$I importar.lrs}

end.

