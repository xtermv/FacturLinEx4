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
  Classes, SysUtils, db, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, Buttons, StdCtrls, Grids, ComCtrls, DBGrids, ZConnection,
  ZDataset, SynEdit, LCLType, Gestionar;

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

  { TfImportarPed }

  TfImportarPed = class(TForm)
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
    dbConnect: TZConnection;
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
    procedure DistribuirLineasPedido(var ArrayDeLineasPedidoAux: array of RLineaPedido);
    procedure BuscarCoincidencias(var Linea: RLineaPedido);
    procedure CompletaLineaPedidoConBD(var Linea: RLineaPedido);
    procedure WriteLinea(const Linea: RLineaPedido);
    procedure tsPendientesEnter(Sender: TObject);
    procedure tsProcesadosEnter(Sender: TObject);
    procedure IniciaImportar(var dbPedid: TzQuery; dbPedic: TzQuery);
    procedure InsertarLinea(Linea: RLineaPedido; VerUltimaLinea: integer );
    procedure SumaPendientes(CodiPen, UniPen: String);
    procedure NuevoEan(const nuevoEan: string; var linea: RLineaPedido);

  private
    { private declarations }
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
  fImportarPed: TfImportarPed;
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

{ TfImportarPed }

uses
   Global, Funciones, Articulos;
procedure TfImportarPed.WriteLinea(const Linea: RLineaPedido);
begin
    Write('Cod->');Write(linea.Codigo);
    Write(', EAN->');Write(linea.CodigoEAN);
    Write(', Nombre->');Write(linea.Descripcion);
    Write(', Vector->(');Write(linea.CoinCod);Write(',');Write(linea.CoinEan);Write(',');Write(linea.CoinDes);WriteLn(')');
end;
//==== COMPLETAR LAS LINEAS DE PEDIDO CON DATOS DE LA BD =====
// Una vez identificada la línea y sus coincidencias, si se decide procesarla,
// sus datos se completan o rectifican para que coincidan con los de la BD
procedure TfImportarPed.CompletaLineaPedidoConBD(var Linea: RLineaPedido);
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
procedure TfImportarPed.BuscarCoincidencias(var Linea: RLineaPedido);
begin
  //ColorLineas:=clRed;
  Linea.CoinCod:=0;Linea.CoinDes:=0;Linea.CoinEan:=0;

  if (Linea.Codigo<>'') then
     begin
      // Si no lo encuentra en ninguna de las dos tablas el valor del vector es 3
      Linea.CoinCod:=3;
      dbArti.Active:=False;
      dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Linea.Codigo+'"';
      dbArti.Active:=True;
      if dbArti.RecordCount<>0 then
        begin
         //ColorLineas:= clBlack;
         Linea.CoinCod:=1;
        end
      else
          begin
          dbEans.Active:=False;
          dbEans.SQL.Text:='SELECT * FROM eans WHERE EAN0="'+Linea.Codigo+'"';
          dbEans.Active:=True;
          if dbEans.RecordCount<>0 then
             begin
             //ColorLineas:= clBlack;
             Linea.CoinCod:=2;
             //WriteLn('Codigo encontrado en EANS con la consulta:');
             end;
           end;
      //if (dbArti.RecordCount<>0) then WriteLn('codigo encontrado en artitien con la consulta:');
      //WriteLn(dbArti.SQL.Text);
  end;

   if (Linea.CodigoEAN<>'') then begin
      // Si no lo encuentra en ninguna de las dos tablas el valor del vector es 3
      linea.CoinEan:=3;
       dbEans.Active:=False;
       dbEans.SQL.Text:='SELECT * FROM eans WHERE EAN0="'+Linea.CodigoEAN+'"';
       dbEans.Active:=True;
       if dbEans.RecordCount<>0 then begin
          //ColorLineas:= clBlack;
          linea.CoinEan:=2;
          //WriteLn('EAN encontrado en EANS con la consulta:');

       end
       else begin
            dbArti.Active:=False;
            dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+linea.CodigoEAN+'"';
            dbArti.Active:=True;
            if dbArti.RecordCount<>0 then begin
              //ColorLineas:= clBlack;
              linea.CoinEan:=1;
            end;
       end;
      //WriteLn(dbEans.SQL.Text);
   end;

  if (Linea.Descripcion <> '') then begin
      // Si no lo encuentra en ninguna de las dos tablas el valor del vector es 3
      Linea.CoinDes:=3;
      dbArti.Active:=False;
      dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A1="'+Linea.Descripcion+'"';
      dbArti.Active:=True;
      if (dbArti.RecordCount<>0) then
        begin
         //ColorLineas:=clGreen;
         Linea.CoinDes:=1;//nombre encontrado en artitien
         //WriteLn('Nombre encontrado en artitien con la consulta:');
        end
      else begin
        dbEans.Active:=False;
        dbEans.SQL.Text:='SELECT * FROM eans WHERE EAN2="'+Linea.Descripcion+'"';
        dbEans.Active:=True;
        if (dbEans.RecordCount<>0) then begin
           //ColorLineas:=clYellow;
           Linea.CoinDes:=2;//nombre encontrado en eans
           //WriteLn('Nombre encontrado en EANs con la consulta:');
        end;
      end;
  end;
end;

procedure TfImportarPed.tsPendientesEnter(Sender: TObject);
begin
  dbgPendientes.Repaint;
end;

procedure TfImportarPed.tsProcesadosEnter(Sender: TObject);
begin
  dbgProcesados.Repaint;
end;

//=============== LLENAR LINEA DE GRID ===============
//Una vez comprobada la línea de pedido en la DB la pasamos al Grid

procedure TfImportarPed.LlenarLineaGrid(
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
       case linea.CoinCod of
            0: ColorLineas:=clRed;
            1: ColorLineas:=clBlack;
            2: ColorLineas:=clRed;
            3: ColorLineas:=clRed;
            4: ColorLineas:=clGreen;
            5: ColorLineas:=clYellow;
       end;
       gridDatos.Canvas.Brush.Color:= ColorLineas;
       //Write('En LlenarLineaGrid '+linea.Codigo+'CoincidenciaCodigo-->'); Write(linea.CoinCod); Write('---');
       gridDatos.ColWidths[1]:=AnchuraColumnaCod*9;
       gridDatos.Cells[1, cont]:=linea.Codigo;
    end;
    if (linea.CodigoEAN<>'') then begin
        if (AnchuraColumnaEan<length(linea.CodigoEan)) then AnchuraColumnaEan:=length(
          linea.CodigoEan);
        case linea.CoinEan of
             0: ColorLineas:=clRed;
             1: ColorLineas:=clBlack;
             2: ColorLineas:=clRed;
             3: ColorLineas:=clRed;
             4: ColorLineas:=clGreen;
             5: ColorLineas:=clYellow;
        end;
        gridDatos.Canvas.Font.Color:= ColorLineas;
        //Write(linea.CodigoEan+'CoincidenciaEAN-->'); Write(linea.CoinEan); Write('---');
        gridDatos.ColWidths[0]:=AnchuraColumnaEan*9;
        gridDatos.Cells[0, cont]:=linea.CodigoEan;
    end;
    if (linea.Descripcion <> '') then begin
         if (AnchuraColumnaDes<length(linea.Descripcion)) then AnchuraColumnaDes:=
           length(linea.Descripcion);
         case linea.CoinDes of
              0: ColorLineas:=clRed;
              1: ColorLineas:=clBlack;
              2: ColorLineas:=clRed;
              3: ColorLineas:=clRed;
              4: ColorLineas:=clGreen;
              5: ColorLineas:=clYellow;
         end;
         gridDatos.Canvas.Font.Color:= ColorLineas;
         //Write(linea.Descripcion+'CoincidenciaDescripcion-->'); WriteLn(linea.CoinDes);
         gridDatos.ColWidths[2]:=AnchuraColumnaDes*9;
         gridDatos.Cells[2, cont]:=linea.Descripcion;
    end;
    if (linea.Unidades <> '') then gridDatos.Cells[3, cont]:=linea.Unidades;
    if (linea.Costo <> '') then gridDatos.Cells[4, cont]:=linea.Costo;
    if (linea.IVA <> '') then gridDatos.Cells[5, cont]:=linea.IVA;
    if (linea.PVP <> '') then gridDatos.Cells[6, cont]:=linea.PVP;

end;

//=============== FORMATEAR ==========================
//Según el fichero importado esté delimitado por caracteres (,) o por
//dimensiones fijas, obtiene el valor de los campos y los mete en variables dentro
// del registro línea de pedido
procedure TfImportarPed.Formatear();
var
  Linea: RLineaPedido;

  PosFin: integer;
  PosIni: integer;
  contdel: integer;
  cont: integer;
  F: TextFile;
  TxtTEMP: String;
  Txt: String;
  FicheroTXT: String;
begin
    if Memo1.Lines.Count=0 then begin
       ShowMessage('DEBE SELECCIONAR EL FICHERO DE TEXTO A IMPORTAR');
       btnGenerar.Enabled:=False;
       abort;
    end;
    btnGenerar.Enabled:=True;
    FicheroTXT:=OpenDialog1.FileName;
    AssignFile(F,FicheroTXT);
    Reset(F);

    if pc.ActivePage=tsSeleccion then begin   // Activada la pestaña de Selección de Posiciones
       cont:=1;
       AnchuraColumnaEan:=0; AnchuraColumnaDes:=0; AnchuraColumnaCod:=0;

       while not EOF(F) do begin
             Readln(F,Txt);
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
                linea.Codigo:=copy(Txt,StrToInt(eCodigoDesde.Text),StrToInt(eCodigoHasta.Text)-StrToInt(eCodigoDesde.Text)+1);

             if ((eEANDesde.Text<>'') and (eEANHasta.Text<>'')) then
                linea.CodigoEAN:= copy(Txt,StrToInt(eEANDesde.Text),StrToInt(eEANHasta.Text)-StrToInt(eEANDesde.Text)+1);

             if ((eNombreDesde.Text<>'') and (eNombreHasta.Text<>'')) then
                linea.Descripcion:=copy(Txt,StrToInt(eNombreDesde.Text),StrToInt(eNombreHasta.Text)-StrToInt(eNombreDesde.Text)+1);

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
       AnchuraColumnaEan:=0; AnchuraColumnaDes:=0; AnchuraColumnaCod:=0;

       while not EOF(F) do begin
             Readln(F,Txt);
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
                linea.Descripcion:=copy(TxtTemp,1,PosFin-1);
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
end;

//=============== DISTRIBUIR LINEAS DEL PEDIDO ==========================
//Una vez identificadas las líneas del Pedido, se clasifican según se hayan
// identificado los artículos implicados, esto lo hacemos trabajando con las
// coincidencias obtenidad en BuscarCoincidencias
procedure TfImportarPed.DistribuirLineasPedido(var ArrayDeLineasPedidoAux: array of RLineaPedido);
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
                 (ArrayDeLineasPedidoAux[cont].CoinDes=3) OR
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

    end;
  end;
end;
//================== TODO EN BLANCO ===========================
procedure TfImportarPed.TodoEnblanco1();
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
procedure TfImportarPed.TodoEnBlanco2();
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

procedure TfImportarPed.PanelEdicionClick(Sender: TObject);
begin

end;

procedure TfImportarPed.sbLimpiar1Click(Sender: TObject);
begin
 TodoEnblanco1();
end;

procedure TfImportarPed.sbLimpiar2Click(Sender: TObject);
begin
 TodoEnblanco2();
end;

procedure TfImportarPed.sbLoad1Click(Sender: TObject);
var
  F: TextFile;
  Txt: String;
begin
  LoadDialog.DefaultExt:='.selp';   // selp = Fichero de Selección de Posiciones
  LoadDialog.Filter:='Selección de Posiciones (*.selp)|*.selp';
  LoadDialog.InitialDir:=Lee+'selecciones';
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

procedure TfImportarPed.sbLoad2Click(Sender: TObject);
var
  F: TextFile;
  Txt: String;
begin
  LoadDialog.DefaultExt:='.seld';   // selp = Fichero de Selección Delimitado por Comas
  LoadDialog.Filter:='Selección Delimitado por Comas (*.seld)|*.seld';
  LoadDialog.InitialDir:=Lee+'selecciones';
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

procedure TfImportarPed.sbSave2Click(Sender: TObject);
var
  F: TFileStream;
  s: String;
begin
  SaveDialog.DefaultExt:='.seld';   // seld = Fichero de Selección Delimitado por Comas
  SaveDialog.Filter:='Selección Delimitado por Comas (*.seld)|*.seld';
  SaveDialog.InitialDir:=Lee+'selecciones';
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

procedure TfImportarPed.sgDatosDblClick(Sender: TObject);
begin
  ShowFormArticulos();
end;

procedure TfImportarPed.sgDatosDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
   sgDatos.Canvas.Font.Color:= ColorLineas;
   sgDatos.DefaultDrawCell(aCol, aRow, aRect, aState);
end;

procedure TfImportarPed.sbSave1Click(Sender: TObject);
var
  F: TFileStream;
  s: String;
begin
  SaveDialog.DefaultExt:='.selp';   // selp = Fichero de Selección de Posiciones
  SaveDialog.Filter:='Selección de Posiciones (*.selp)|*.selp';
  SaveDialog.InitialDir:=Lee+'selecciones';
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

procedure TfImportarPed.NuevoEan(const nuevoEan: string; var linea: RLineaPedido);
begin
        // Comprobamos de nuevo que no exista otro ean igual
        dbArti.Active:=False;
        dbArti.SQL.Text:='SELECT * FROM eans WHERE EAN0="'+nuevoEan+'"';
        dbArti.Active:=True;
              //ShowMessage('  Dato a tratar :' + #13 + #13 +
              //           ' Código :      ' + dbArti.FieldByName('ean1').AsString + #13 +
              //           ' Descripción : ' + dbArti.FieldByName('ean2').AsString );
        if dbArti.RecordCount=0 then
          begin
            dbArti.Append;
            dbArti.FieldByName('EAN0').AsString:=nuevoEan;//-------- Ean
            dbArti.FieldByName('EAN1').AsString:=EditBDCodigo.Text;//----------Código
            if EditPenNombre.Text <> '' then
               dbArti.FieldByName('EAN2').AsString:=EditPenNombre.Text//----------descripción del txt
            else dbArti.FieldByName('EAN2').AsString:=EditBDNombre.Text;//----------descripción de la BD

  // CAMPOS QUE YO NO SÉ MANEJAR

            dbArti.FieldByName('EAN3').AsString:='1';//-----------------Unidades
            if linea.PVP <> '' then
                dbArti.FieldByName('EAN4').AsString:=linea.PVP //Esto no se si es correcto, creo que NO
                                   else
                dbArti.FieldByName('EAN4').AsString:='0';//---------Precio
            dbArti.FieldByName('EAN5').AsString:='1';//-----------------Unidades a descontar
            dbArti.Post;

            ShowMessage('   Añadido :' + #13 + #13 +
                         ' Código :      ' + dbArti.FieldByName('ean1').AsString + #13 +
                         ' EAN :         ' + dbArti.FieldByName('ean0').AsString + #13 +
                         ' Descripción : ' + dbArti.FieldByName('ean2').AsString + #13 + #13);
          end else
            ShowMessage('   Ya existe ese valor :' + #13 + #13 +
                         ' Código :      ' + dbArti.FieldByName('ean1').AsString + #13 +
                         ' Descripción : ' + dbArti.FieldByName('ean2').AsString + #13 + #13 +
                         'No se crea ningún registro nuevo en la tabla de EAN');
end;

procedure ShowFormImportar(dbPedid: TzQuery; dbPedic: TzQuery);
begin
  with TfImportarPed.Create(Application) do
    begin
       dbPedidAux:= dbPedid;
       dbPedicAux:= dbPedic;

       ShowModal;
    end;
end;

//=============== CREAR EL FORMULARIO ================
//procedure TfImportarPed.IniciaImportar(var palabra: string);
procedure TfImportarPed.IniciaImportar(var dbPedid: TzQuery; dbPedic: TzQuery);
begin
   ShowFormImportar(dbPedid, dbPedic);
   //dbPedidAux:=dbPedid;
   //dbPedicAux:=dbPedic;
end;

procedure TfImportarPed.btnAPedidoClick(Sender: TObject);
var cont:integer;
begin
  for cont:=0 to Length(ArrayDeLineasPedidoPro)-1 do
  begin
    // En pedidos enpiezan a insertar en la línea 1, hay que sumar 1 al nº de líneas
    InsertarLinea(ArrayDeLineasPedidoPro[cont], (dbPedidAux.RecordCount+1));
    showmessage('cont= '+IntToStr(cont)+'recor= '+IntToStr(dbPedidAux.RecordCount));
  end;
  SetLength(ArrayDeLineasPedidoPro, 0);
  dbgProcesados.RowCount:=0;
end;
//----------------- Aceptar Lineas ----------------
//procedure TfImportarPed.InsertarLinea(var dbPedidI: TzQuery; dbPedicAux: TzQuery; Linea: RLineaPedido; VerUltimaLinea: integer );
procedure TfImportarPed.InsertarLinea(Linea: RLineaPedido; VerUltimaLinea: integer );
begin
    dbPedidAux.Append;
    begin
// Los datos que tengo en la linea de pedido son estos:
     //Codigo: string;     CoinCod: integer;
     //CodigoEAN: string;  CoinEan: integer;
     //Descripcion: string;CoinDes: integer;
     //Unidades: string;
     //Costo: string;
     //IVA: string;
     //PVP: string;
     //Pos: integer; //Posición en el Array de líneas de Pedido
// el resto de campos implicados en este proceso los dejo en blanco o 0
 dbPedidAux.FieldByName('PD0').Value:=dbPedicAux.FieldByName('PC0').Value;//----- N. Tienda
 dbPedidAux.FieldByName('PD1').Value:=dbPedicAux.FieldByName('PC1').Value;//----- Fecha
 dbPedidAux.FieldByName('PD2').Value:=dbPedicAux.FieldByName('PC2').Value;//----- Proveedor
 dbPedidAux.FieldByName('PD3').Value:=dbPedicAux.FieldByName('PC3').Value;//----- Serie
 dbPedidAux.FieldByName('PD4').Value:=dbPedicAux.FieldByName('PC4').Value;//----- N. Pedido

  dbPedidAux.FieldByName('PD5').Value:=VerUltimaLinea;//------- N. Linea    Quizas se pueda utilizar linea.pos
  dbPedidAux.FieldByName('PD6').AsString:=linea.codigo;//-------- Codigo articulo
  dbPedidAux.FieldByName('PD7').AsString:=linea.descripcion;//----------- Descripcion
  dbPedidAux.FieldByName('PD8').AsString:=Linea.unidades;//----------- Unidades
  dbPedidAux.FieldByName('PD9').AsString:='0';//------------------ Bonificaciones
  dbPedidAux.FieldByName('PD10').AsString:=Linea.costo;//---------- Precio de costo (Sin Iva y sin Recargo)
  dbPedidAux.FieldByName('PD11').AsString:='0';//--------- Margen
  dbPedidAux.FieldByName('PD12').AsString:='0';//--------- Precio venta(Sin Iva)

  dbPedidAux.FieldByName('PD13').AsString:='0';//--------- Recargo de equivalencia

  //dbPedidAux.FieldByName('PD14').Value:='';//------------- Tipo de iva
  dbPedidAux.FieldByName('PD15').AsString:='0';//--------- Precio de costo (Con Iva)
  dbPedidAux.FieldByName('PD16').AsString:=Linea.PVP;//--------- Precio venta(Con Iva)
  dbPedidAux.FieldByName('PD17').AsString:='0';//----------Importe total de costo (Con Iva)
  dbPedidAux.FieldByName('PD18').AsFloat:=StrToFloat(Linea.Unidades);//*StrToFloat(Linea.PVP);//---- Importe total PVP (Con Iva)
  //dbPedidAux.FieldByName('PD19').Value:=dbArti.FieldByName('A14').Value;//-- Familia

      //dbPedidAux.FieldByName('PD20').Value:=dbArti.FieldByName('A4').Value;//----- Stock actual en el momento de pedir

      dbPedidAux.FieldByName('PD21').AsString:='0';//---------- Unidades vendidas de X a X año actual
      dbPedidAux.FieldByName('PD22').AsString:='0';//---------- Unidades vendidas de X a X año anterior

  dbPedidAux.FieldByName('PD23').AsString:='S';//-------------- Recibido S/N (Por defecto siempre si)
  dbPedidAux.FieldByName('PD24').AsString:='';//--------------- Serie de colores
  dbPedidAux.FieldByName('PD25').AsString:='';//--------------- Serie de tallas
  dbPedidAux.FieldByName('PD26').Value:='0';//--------- Precio Tarifa
  dbPedidAux.FieldByName('PD27').AsString:='0';//------ Dto Importe
  dbPedidAux.FieldByName('PD28').AsString:='0';//------ Dto % 1
  dbPedidAux.FieldByName('PD29').AsString:='0';//------ Dto % 2
  dbPedidAux.FieldByName('PD30').AsString:='0';//------ Margen sobre PVP
end;
    dbPedidAux.Post;
    SumaPendientes(linea.Codigo,linea.Unidades);//----- Sumar unidades pendientes

  //PintarTotalGeneral();

  //      Deberemos limpiar la linea de grid y arrays
end;
//================== UNIDADES PENDIENTES EN PEDIDOS ================
procedure TfImportarPed.SumaPendientes(CodiPen, UniPen: String);
begin
  dbTrabajo.SQL.Text:='UPDATE artitien'+Tienda+' SET A11=A11+'+UniPen+
                      ' WHERE A0="'+CodiPen+'"';
  dbTrabajo.ExecSQL;
end;

procedure TfImportarPed.btnSalirClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfImportarPed.btnSeleccionarClick(Sender: TObject);
var
  FicheroTXT, Txt: String;
  F: TextFile;
begin
  Memo1.Clear;
  Panel3.Enabled:=false;
  btnGenerar.Enabled:=False;
  TodoEnblanco1();
  TodoEnBlanco2();

  OpenDialog1.InitialDir:=ExtractFilePath(ParamStr(0));

  if OpenDialog1.Execute then begin
     FicheroTXT:=OpenDialog1.FileName;
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
procedure TfImportarPed.dbgPendientesDblClick(Sender: TObject);
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
EditPenNombre.Text:=dbgPendientes.Cells[2,fila];
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
end;

//Dar de alta ean con el codigo.txt
// si hay cod.txt este será el nuevo ean
procedure TfImportarPed.BitBtnAltaEanClick(Sender: TObject);
var
  linea: RLineaPedido;
  nEan: string;
begin
  linea:=ArrayDeLineasPedido[lineaSeleccionada-1];
  //Caso de Nuevo Ean por ean.txt desconocido
  if linea.CoinEan = 3 then
  begin
    if EditPenEan.Text = '' then begin EditPenEan.SetFocus; exit; end;
    if ((EditBDCodigo.Text = '') and (EditBDNombre.Text ='')) then begin
      ShowMessage('Datos insuficientes');exit;
    end;
    nEan:=EditPenEan.Text;
    //Inserta nuevo ean
    NuevoEan(nEan, linea);
  end;
  // Casos en los que esté marcado el añadir cod.txt como ean
  if cbCodtxtAEan.Checked then begin
    if EditPenCodigo.Text = '' then begin EditPenCodigo.SetFocus; exit; end;
    if ((EditBDEan.Text = '') and (EditBDNombre.Text ='')) then begin
      ShowMessage('Datos insuficientes');exit;
    end;
    nEan:=EditPenCodigo.Text;
    //Inserta nuevo ean
    NuevoEan(nEan, linea);
  end;

  BuscarCoincidencias(Linea);

  //Las modificaciones pasan al vector de lineas de pedido
  ArrayDeLineasPedido[linea.Pos-1]:=linea;

  DistribuirLineasPedido(ArrayDeLineasPedido);
  BitBtnAltaEan.Enabled:=False;
  PanelEdicion.Visible:=False;
end;

procedure TfImportarPed.BitBtnAceptarDatosBDClick(Sender: TObject);
var
  linea: RLineaPedido;
  TxtQuery: String;
  datosDe: String;
begin
  datosDe:='';
//los tres campos tienen que estar completos, el codigo es el de la BD y no se puede variar
  //if EditPenNombre.Text = '' then begin EditPenNombre.SetFocus; exit; end;
  //if EditPenCodigo.Text = '' then begin EditPenCodigo.SetFocus; exit; end;
  //if EditPenEan.Text = '' then begin EditPenEan.SetFocus; exit; end;
  linea:=ArrayDeLineasPedido[lineaSeleccionada-1];

  if linea.CoinDes=2 then begin TxtQuery:='SELECT * FROM eans WHERE EAN2="'+EditPenNombre.Text+'"';datosDe:='eans';end
  else if linea.CoinDes=1 then begin TxtQuery:='SELECT * FROM artitien'+Tienda+' WHERE A1="'+EditPenNombre.Text+'"';datosDe:='artitien';end;
  if linea.CoinEan=2 then begin TxtQuery:='SELECT * FROM eans WHERE EAN0="'+EditPenEan.Text+'"';datosDe:='eans';end;
  if linea.CoinCod=2 then begin TxtQuery:='SELECT * FROM eans WHERE EAN1="'+EditPenCodigo.Text+'"';datosDe:='eans';end
  else if linea.CoinCod=2 then begin TxtQuery:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+EditPenCodigo.Text+'"';datosDe:='artitien';end;

  if datosDe <> '' then begin
    dbArti.Active:=False;
    dbArti.SQL.Text:=TxtQuery;
    dbArti.Active:=True;

//        ShowMessage('  Dato a tratar :' + #13 + #13 +
//                   ' Código :      ' + dbArti.FieldByName('ean1').AsString + #13 +
//                   ' Descripción : ' + dbArti.FieldByName('ean2').AsString );
    if dbArti.RecordCount<>0 then begin
      if datosDe = 'eans' then begin
        if linea.CoinCod=2 then begin
          //El cod.txt lo pasamos a ean.txt y ponemos el codigo de la BD
          Linea.CodigoEAN:=Linea.Codigo;
          Linea.Codigo:=dbArti.FieldByName('EAN1').AsString;
          Linea.Descripcion:=dbArti.FieldByName('EAN2').AsString;
        end
        else if linea.CoinEan=2 then begin
          Linea.Codigo:=dbArti.FieldByName('EAN1').AsString;
          Linea.Descripcion:=dbArti.FieldByName('EAN2').AsString;
        end
        else if linea.CoinDes=2 then begin
          Linea.CodigoEAN:=dbArti.FieldByName('EAN0').AsString;
          Linea.Codigo:=dbArti.FieldByName('EAN1').AsString;
        end;
      end
      else begin
        Linea.Codigo:=dbArti.FieldByName('A0').AsString;
        Linea.Descripcion:=dbArti.FieldByName('A1').AsString;
        Linea.CodigoEan:='';
      end;
    end;
  end;

  BuscarCoincidencias(Linea);
  //Las modificaciones pasan al vector de lineas de pedido
  ArrayDeLineasPedido[linea.Pos-1]:=linea;
  //writeLinea(ArrayDeLineasPedido[linea.Pos-1]);

  DistribuirLineasPedido(ArrayDeLineasPedido);
  BitBtnAceptarDatosBD.Enabled:=False;
  PanelEdicion.Visible:=False;
end;

procedure TfImportarPed.BitBtnDAltaCodClick(Sender: TObject);
var

  Conta: Integer;
  ANO: String;
  linea: RLineaPedido;
begin
  ShowMessage('UN ARTÍCULO PUEDE TENER OTRAS MUCHAS CARACTERISTICAS QUE NO ESTÁN RECOGIDAS EN ESTA CREACIÓN' +#13
              +'SE RECOMIENDA VISITAR LA FICHA DEL ARTÍCULO'    );
  //los dos campos tienen que estar completos
  if EditPenNombre.Text = '' then begin EditPenNombre.SetFocus; exit; end;
  if EditPenCodigo.Text = '' then begin EditPenCodigo.SetFocus; exit; end;
  linea:=ArrayDeLineasPedido[lineaSeleccionada-1];

  dbArti.Active:=False;
  dbArti.Sql.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+EditPenCodigo.Text+'"';
  dbArti.Active:=True;
  If dbArti.RecordCount = 0 then
  begin
  dbArti.Append;
  dbArti.FieldByName('A0').AsString:=EditPenCodigo.Text;//-------------- Código
  dbArti.FieldByName('A1').AsString:=EditPenNombre.Text;//-------------- Nombre

// ESTOS DATOS NO LOS SÉ TRATAR

  dbArti.FieldByName('A21').AsString:='0';//------------ Precio       SEGURO QUE ESTA MAL
  dbArti.FieldByName('A3').AsString:=linea.IVA;//-------------- Iva
  //dbArti.FieldByName('A36').AsString:='0';//-------------- Recargo
  dbArti.FieldByName('A2').AsString:=linea.PVP;//------------- P.V.P.
  //dbArti.FieldByName('A14').AsString:='';//------------ Familia
  //dbArti.FieldByName('A24').AsString:='0';//------- Costo
  //dbArti.FieldByName('A25').AsString:='0';//------- Costo Medio
  //dbArti.FieldByName('A26').AsString:=Edit11.Text;//------- Margen
  //dbArti.FieldByName('A37').AsString:=Edit37.Text;//------- Margen sobre Venta
  //dbArti.FieldByName('A28').AsString:=Edit19.Text;//------- Precio tarifa
  //dbArti.FieldByName('A29').AsString:=Edit22.Text;//------- Descuento en importe
  //dbArti.FieldByName('A30').AsString:=Edit27.Text;//------- % Descuento 1
  //dbArti.FieldByName('A31').AsString:=Edit29.Text;//------- % Descuento 2
  //dbArti.FieldByName('A32').AsString:=dbProve.FieldByName('P0').AsString;//--- Ultimo proveedor
  dbArti.Post;

  //--------- Estadistica
  ANO:=FormatDateTime('YYYY',Date);
  for conta:=1 to 12 do
    begin
    //WriteLn('INSERT IGNORE INTO estaarti'+Tienda+' (TA0,TA1,TA2,TA3,TA4,TA5,TA6,TA7) '+'VALUES ("'+EditPenCodigo.Text+'",'+ANO+','+IntToStr(Conta)+',0,0,0,0,0)');
     dbTrabajo.SQL.Text:='INSERT IGNORE INTO estaarti'+Tienda+' (TA0,TA1,TA2,TA3,TA4,TA5,TA6,TA7) '+
                         'VALUES ("'+EditPenCodigo.Text+'",'+ANO+','+IntToStr(Conta)+',0,0,0,0,0)';
     dbTrabajo.ExecSQL;
  end;

  end;

  BuscarCoincidencias(Linea);

  //Las modificaciones pasan al vector de lineas de pedido
  ArrayDeLineasPedido[linea.Pos-1]:=linea;
  //writeLinea(ArrayDeLineasPedido[linea.Pos-1]);

  DistribuirLineasPedido(ArrayDeLineasPedido);
  BitBtnAceptarDatosBD.Enabled:=False;
  PanelEdicion.Visible:=False;
end;

//end;
//=============== EVENTOS EXIT DE LOS EDIT ==============
//Comprobar que los contenidos sean números y mostrar resultados

procedure TfImportarPed.eCodigoExit(Sender: TObject);
begin
  if (NOT(EsNumero(eCodigoHasta.Text)) OR NOT((eCodigoDesde.Text<>'') AND (StrToInt(eCodigoDesde.Text) < StrToInt(eCodigoHasta.Text)))) then
    begin eCodigoHasta.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportarPed.eCodigoDesdeExit(Sender: TObject);
begin
  if not (EsNumero(eCodigoDesde.Text)) then begin eCodigoDesde.Text:=''; exit; end;
end;

procedure TfImportarPed.eEANExit(Sender: TObject);
begin
  if (NOT (EsNumero(eEANHasta.Text)) OR NOT((eEANDesde.Text<>'') AND (StrToInt(eEANDesde.Text) < StrToInt(eEANHasta.Text)))) then
    begin eEANHasta.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportarPed.eEANDesdeExit(Sender: TObject);
begin
  if not (EsNumero(eEANDesde.Text)) then begin eEANDesde.Text:=''; exit; end;
end;

procedure TfImportarPed.eNombreExit(Sender: TObject);
begin
  if (NOT (EsNumero(eNombreHasta.Text)) OR NOT((eNombreDesde.Text<>'') AND (StrToInt(eNombreDesde.Text) < StrToInt(eNombreHasta.Text)))) then
    begin eNombreHasta.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportarPed.eNombreDesdeExit(Sender: TObject);
begin
  if not (EsNumero(eNombreDesde.Text)) then begin eNombreDesde.Text:=''; exit; end;
end;

procedure TfImportarPed.eCostoHastaExit(Sender: TObject);
begin
  if (NOT (EsNumero(eCostoHasta.Text)) OR NOT((eCostoDesde.Text<>'') AND (StrToInt(eCostoDesde.Text) < StrToInt(eCostoHasta.Text)))) then
    begin eCostoHasta.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportarPed.eCostoDesdeExit(Sender: TObject);
begin
  if not (EsNumero(eCostoDesde.Text)) then begin eCostoDesde.Text:=''; exit; end;
end;

procedure TfImportarPed.eDecCostoHastaExit(Sender: TObject);
begin
  if (NOT (EsNumero(eDecCostoHasta.Text)) OR NOT((eDecCostoDesde.Text<>'') AND (StrToInt(eDecCostoDesde.Text) < StrToInt(eDecCostoHasta.Text)))) then
    begin eDecCostoHasta.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportarPed.eDecCostoDesdeExit(Sender: TObject);
begin
  if not (EsNumero(eDecCostoDesde.Text)) then begin eDecCostoDesde.Text:=''; exit; end;
end;

procedure TfImportarPed.eDecPVPHastaExit(Sender: TObject);
begin
  if (NOT (EsNumero(eDecPVPHasta.Text)) OR NOT((eDecPVPDesde.Text<>'') AND (StrToInt(eDecPVPDesde.Text) < StrToInt(eDecPVPHasta.Text)))) then
    begin eDecPVPHasta.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportarPed.eDecPVPDesdeExit(Sender: TObject);
begin
  if not (EsNumero(eDecPVPDesde.Text)) then begin eDecPVPDesde.Text:=''; exit; end;
end;

procedure TfImportarPed.eIVAHastaExit(Sender: TObject);
begin
  if (NOT (EsNumero(eIVAHasta.Text)) OR NOT ((eIVADesde.Text<>'') AND (StrToInt(eIVADesde.Text) < StrToInt(eIVAHasta.Text)))) then
    begin eIVAHasta.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportarPed.eIVADesdeExit(Sender: TObject);
begin
  if not (EsNumero(eIVADesde.Text)) then begin eIVADesde.Text:=''; exit; end;
end;

procedure TfImportarPed.ePVPHastaExit(Sender: TObject);
begin
  if (NOT (EsNumero(ePVPHasta.Text)) OR NOT ((ePVPDesde.Text<>'') AND (StrToInt(ePVPDesde.Text) < StrToInt(ePVPHasta.Text)))) then
    begin ePVPHasta.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportarPed.ePVPDesdeExit(Sender: TObject);
begin
  if not (EsNumero(ePVPDesde.Text)) then begin ePVPDesde.Text:=''; exit; end;
end;

procedure TfImportarPed.eUnidHastaExit(Sender: TObject);
begin
  if (not (EsNumero(eUnidHasta.Text)) OR NOT ((eUnidDesde.Text<>'') AND (StrToInt(eUnidDesde.Text) < StrToInt(eUnidHasta.Text)))) then
    begin eUnidHasta.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportarPed.eUnidDesdeExit(Sender: TObject);
begin
  if not (EsNumero(eUnidDesde.Text)) then begin eUnidDesde.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportarPed.eOCostoExit(Sender: TObject);
begin
  if not (EsNumero(eOCosto.Text)) then begin eOCosto.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportarPed.eODesCostoExit(Sender: TObject);
begin
  if not (EsNumero(eODecCosto.Text)) then begin eODecCosto.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportarPed.eODesPVPExit(Sender: TObject);
begin
  if not (EsNumero(eODecPVP.Text)) then begin eOPVP.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportarPed.eOIVAExit(Sender: TObject);
begin
  if not (EsNumero(eOIVA.Text)) then begin eOIVA.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportarPed.eOPVPExit(Sender: TObject);
begin
  if not (EsNumero(eOPVP.Text)) then begin eOPVP.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportarPed.eOUnidadesExit(Sender: TObject);
begin
  if not (EsNumero(eOUnidades.Text)) then begin eOUnidades.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportarPed.eOCodigoExit(Sender: TObject);
begin
  if not (EsNumero(eOCodigo.Text)) then begin eOUnidades.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportarPed.eOEANExit(Sender: TObject);
begin
  if not (EsNumero(eOEAN.Text)) then begin eOUnidades.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportarPed.eONombreExit(Sender: TObject);
begin
  if not (EsNumero(eONombre.Text)) then begin eOUnidades.Text:=''; exit; end;
  Formatear();
end;

procedure TfImportarPed.SynEdit1Click(Sender: TObject);
begin
  ePos.Text:=IntToStr(SynEdit1.CaretX);
end;

procedure TfImportarPed.btnGenerarClick(Sender: TObject);
begin
  tsProcesados.Enabled:=true;
  tsPendientes.Enabled:=true;
  pc.ActivePage:=tsPendientes;
  btnAPedido.Visible:=True;
  //Formatear();



  //  MIRAR ESTO, DE MOMENTO EL IF NO HACE NADA



  if ((pc.ActivePage=tsProcesados) OR (pc.ActivePage=tsPendientes)) then
     //DistribuirLineasPedido(ArrayDeLineasPedidoPen)   // Activada la pestaña de Pendientes o Procesados
     DistribuirLineasPedido(ArrayDeLineasPedido)
  else DistribuirLineasPedido(ArrayDeLineasPedido);   // Activadas las pestañas de Formateo
end;

procedure TfImportarPed.BitBtn6Click(Sender: TObject);
begin
  PanelEdicion.Visible:=False;
end;

//procedure TfImportarPed.BitBtn6Click(Sender: TObject);
//var
//i:integer;
//begin
//Write('longidud del vector ');writeLn(Length(ArrayDeLineasPedido)-1);
//showmessage('Pinto todas las lineas');
//    for i:=0 to Length(ArrayDeLineasPedido)-1 do
//  writeLinea(ArrayDeLineasPedido[i]);
//end;

procedure TfImportarPed.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;
//procedure TfImportarPed.FormCreate(Sender: TObject;FPedido: TFPedido);
procedure TfImportarPed.FormCreate(Sender: TObject);
begin
 //--------- Conectar con la bbdd
  Conectate(dbConnect);

  //dbPedidAux:=dbPedid;
  //dbPedicAux:=dbPedic;

  pc.ActivePage:=tsSeleccion;
end;

procedure TfImportarPed.FormShow(Sender: TObject);
begin
 btnGenerar.Enabled:=False;
 tsProcesados.Enabled:=false;
 tsPendientes.Enabled:=false;
 PanelEdicion.Visible:=False;
 btnAPedido.Visible:=False;
 if not (DirectoryExists(Lee+'selecciones')) then CreateDir(Lee+'selecciones')
end;

procedure TfImportarPed.Label72Click(Sender: TObject);
begin

end;

procedure TfImportarPed.MostrarPosicion(Sender: TObject);
begin

end;



//procedure TfImportarPed.MostrarPosicion(Sender: TObject);
//begin
//  ePos.Text:=IntToStr(SynEdit1.CaretX);
//end;

initialization
  {$I importar.lrs}

end.

