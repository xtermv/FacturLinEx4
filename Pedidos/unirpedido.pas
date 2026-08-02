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
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit unirpedido;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Variants, db, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, DBGrids, Grids, Buttons, StdCtrls, ZConnection, ZDataset, LCLType,
  ComCtrls, ExtCtrls;

type

  { TFUniPedi }

  TFUniPedi = class(TForm)
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    dbConnect: TZConnection;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    dbPedic: TZQuery;
    dbPedic1: TZQuery;
    dbPedid1: TZQuery;
    dbPedid: TZQuery;
    dbBusca: TZQuery;
    Label1: TLabel;
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure DBGrid2TitleClick(Column: TColumn);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    function VerUltimaLinea: Integer;

  private
    FOrdenGrid1: String;
    FOrdenGrid2: String;
    FPanelCabecera: TPanel;
    FLabelTitulo: TLabel;
    FLabelSubtitulo: TLabel;
    FPanelAviso: TPanel;
    FLabelAviso: TLabel;
    procedure CrearCabeceraModerna;
    procedure AplicarEstiloModerno;
    procedure RecolocarControles;
    procedure ConfigurarGridModerno(AGrid: TDBGrid);
    procedure DibujarCeldaGrid(AGrid: TDBGrid; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure AplicarOrdenGrid(AGrid: TDBGrid; AQuery: TZQuery;
      Column: TColumn; var AOrden: String);
    procedure MarcarColumnaOrdenada(AGrid: TDBGrid; Column: TColumn;
      const AOrden: String);
    function DescribirPedido(AQuery: TZQuery): String;
  public
    { public declarations }
  end; 

  procedure ShowFormUniPedi();

var
  FUniPedi: TFUniPedi;

implementation

{ TFUniPedi }

uses
  Global, Funciones;

//===================== CREAR EL FORMULARIO =====================
procedure ShowFormUniPedi();
begin
  with TFUniPedi.Create(Application) do
    begin
       ShowModal;
    end;
end;
procedure TFUniPedi.FormCreate(Sender: TObject);
Var
  cont:Integer;
begin
  FOrdenGrid1:='ASC';
  FOrdenGrid2:='ASC';

  KeyPreview:=True;
  OnKeyDown:=@FormKeyDown;
  OnResize:=@FormResize;
  DBGrid1.OnTitleClick:=@DBGrid1TitleClick;
  DBGrid2.OnTitleClick:=@DBGrid2TitleClick;
  DBGrid1.OnDrawColumnCell:=@DBGrid1DrawColumnCell;
  DBGrid2.OnDrawColumnCell:=@DBGrid2DrawColumnCell;

  Constraints.MinWidth:=900;
  Constraints.MinHeight:=650;
  Position:=poScreenCenter;
  WindowState:=wsMaximized;

  //--------- Conectar con la bbdd
  Conectate(dbConnect);
  //--------- Pedido origen
  dbPedic.SQL.Text:='SELECT * FROM pedicc'+Tienda+
                    ' ORDER BY PC0 ASC, PC1 DESC, PC2 ASC, PC3 ASC, PC4 DESC';
  dbPedic.Active:=True;
  //--------- Pedido destino
  dbPedic1.SQL.Text:='SELECT * FROM pedicc'+Tienda+
                    ' ORDER BY PC0 ASC, PC1 DESC, PC2 ASC, PC3 ASC, PC4 DESC';
  dbPedic1.Active:=True;

  //----------------- Colores configurables heredados -------------------------
  if ColorFondo<>'' then Color:=StringToColor(ColorFondo);
  cont:=0;
  if ColorBotones<>'' then
    begin
     for cont:=0 to ComponentCount-1 do
       begin
        if (Components[cont] is TBitBtn) then
          TBitBtn(FindComponent(Components[cont].Name)).color:=StringToColor(ColorBotones);
       end;
    end;

  CrearCabeceraModerna;
  AplicarEstiloModerno;
  RecolocarControles;
end;

//=================== CERRAR FORMULARIO ============================
procedure TFUniPedi.BitBtn2Click(Sender: TObject);
begin
  Close();
end;
procedure TFUniPedi.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=CaFree;
end;

//======================= UNIR PEDIDOS ============================
procedure TFUniPedi.BitBtn3Click(Sender: TObject);
var
  Conta: Integer;
begin
  if dbPedic.RecordCount=0 then begin showmessage('NO TIENE PEDIDOS PARA UNIR'); exit; end;
  if dbPedic1.RecordCount=0 then begin showmessage('NO TIENE PEDIDOS PARA UNIR'); exit; end;
  //-------------- Chequear que los pedidos no sean los mismo (origen-destino)
  if (dbPedic.FieldByName('PC0').AsString=dbPedic1.FieldByName('PC0').AsString) and
     (dbPedic.FieldByName('PC1').AsString=dbPedic1.FieldByName('PC1').AsString) and
     (dbPedic.FieldByName('PC2').AsString=dbPedic1.FieldByName('PC2').AsString) and
     (dbPedic.FieldByName('PC3').AsString=dbPedic1.FieldByName('PC3').AsString) and
     (dbPedic.FieldByName('PC4').AsString=dbPedic1.FieldByName('PC4').AsString) then
     begin showmessage('NO PUEDE UNIR EL MISMO PEDIDO ORIGEN-DESTINO'); exit; end;
  //-------------------------------------------------------------------------------
  boxstyle := MB_ICONQUESTION + MB_YESNO;
  if Application.MessageBox(PChar(
       'Se copiarán todas las líneas del pedido ORIGEN al pedido DESTINO.'+#10+#10+
       'ORIGEN:  '+DescribirPedido(dbPedic)+#10+
       'DESTINO: '+DescribirPedido(dbPedic1)+#10+#10+
       'ATENCIÓN: al finalizar, el pedido origen se eliminará.'+#10+
       '¿Desea continuar?'),
       'FacturLinEx · Unión de pedidos', boxstyle) = IDNO Then
     Exit;
  //-------------- Pedido origen
  dbPedid.Active:=False;
  dbPedid.SQL.Text:='SELECT * FROM pedidd'+Tienda+' WHERE PD0='+dbPedic.FieldByName('PC0').AsString+
                     ' AND PD1="'+FormatDateTime('YYYY/MM/DD',dbPedic.FieldByName('PC1').AsDateTime)+'"'+
                     ' AND PD2='+dbPedic.FieldByName('PC2').AsString+
                     ' AND PD3="'+dbPedic.FieldByName('PC3').AsString+'"'+
                     ' AND PD4='+dbPedic.FieldByName('PC4').AsString;
  dbPedid.Active:=True;
  //-------------- Pedido destino
  dbPedid1.Active:=False;
  dbPedid1.SQL.Text:='SELECT * FROM pedidd'+Tienda+' WHERE PD0='+dbPedic1.FieldByName('PC0').AsString+
                     ' AND PD1="'+FormatDateTime('YYYY/MM/DD',dbPedic1.FieldByName('PC1').AsDateTime)+'"'+
                     ' AND PD2='+dbPedic1.FieldByName('PC2').AsString+
                     ' AND PD3="'+dbPedic1.FieldByName('PC3').AsString+'"'+
                     ' AND PD4='+dbPedic1.FieldByName('PC4').AsString;
  dbPedid1.Active:=True;
  //------------- Unir pedidos
  if dbPedid.RecordCount=0 then begin showmessage('EL PEDIDO ORIGEN NO TIENE LINEAS'); exit; end;
  ProgressBar1.Position:=0; ProgressBar1.Max:=dbPedid.RecordCount;
  Panel1.Visible:=True;
  Panel1.BringToFront;
  Application.ProcessMessages;
  dbPedid.First;
  while not dbPedid.EOF do
    begin
      dbPedid1.Append;

      dbPedid1.FieldByName('PD0').Value:=dbPedic1.FieldByName('PC0').Value;//----- N. Tienda
      dbPedid1.FieldByName('PD1').Value:=dbPedic1.FieldByName('PC1').Value;//----- Fecha
      dbPedid1.FieldByName('PD2').Value:=dbPedic1.FieldByName('PC2').Value;//----- Proveedor
      dbPedid1.FieldByName('PD3').Value:=dbPedic1.FieldByName('PC3').Value;//----- Serie
      dbPedid1.FieldByName('PD4').Value:=dbPedic1.FieldByName('PC4').Value;//----- N. Pedido
      dbPedid1.FieldByName('PD5').Value:=VerUltimaLinea;//------- N. Linea
      for Conta:=6 to 30 do
        dbPedid1.Fields[Conta].Value:=dbPedid.Fields[Conta].Value;
      dbPedid1.Post;
      ProgressBar1.Position:=ProgressBar1.Position+1;
      Application.ProcessMessages;
      dbPedid.Next;
    end;
  dbPedic1.Edit;
  dbPedic1.FieldByName('PC5').Value:=dbPedic1.FieldByName('PC5').AsInteger + dbPedic.FieldByName('PC5').AsInteger;
  dbPedic1.FieldByName('PC6').Value:=dbPedic1.FieldByName('PC6').AsInteger + dbPedic.FieldByName('PC6').AsInteger;
  dbPedic1.FieldByName('PC7').Value:=dbPedic1.FieldByName('PC7').AsFloat + dbPedic.FieldByName('PC7').AsFloat;
  dbPedic1.FieldByName('PC8').Value:=dbPedic1.FieldByName('PC8').AsFloat + dbPedic.FieldByName('PC8').AsFloat;
  dbPedic1.FieldByName('PC9').Value:=dbPedic1.FieldByName('PC9').AsFloat + dbPedic.FieldByName('PC9').AsFloat;
  dbPedic1.Post;
  //----------- Borrar pedido origen
  dbPedid.First;
  while not dbPedid.EOF do
    begin
      dbPedid.Delete;
      dbPedid.Next;
    end;
  dbPedic.Delete;
  Panel1.Visible:=False;
  showmessage('Los pedidos se han unido correctamente.');
end;


//=================== SACAR EL ULT N. DE LINEA =====================
function TFUniPedi.VerUltimaLinea: Integer;
begin
  VerUltimaLinea:=1;
  dbBusca.Active:=False;
  dbBusca.SQL.Text:='SELECT MAX(PD5) As ULTIMA FROM pedidd'+Tienda+' WHERE PD0='+dbPedic1.FieldByName('PC0').AsString+
                     ' AND PD1="'+FormatDateTime('YYYY/MM/DD',dbPedic1.FieldByName('PC1').AsDateTime)+'"'+
                     ' AND PD2='+dbPedic1.FieldByName('PC2').AsString+
                     ' AND PD3="'+dbPedic1.FieldByName('PC3').AsString+'"'+
                     ' AND PD4='+dbPedic1.FieldByName('PC4').AsString;
  dbBusca.Active:=True;
  if dbBusca.RecordCount=0 then exit;
  VerUltimaLinea:=dbBusca.FieldByName('ULTIMA').AsInteger+1;
end;


procedure TFUniPedi.CrearCabeceraModerna;
begin
  FPanelCabecera:=TPanel.Create(Self);
  FPanelCabecera.Name:='PanelCabeceraModerna';
  FPanelCabecera.Caption:='';
  FPanelCabecera.Parent:=Self;
  FPanelCabecera.BevelOuter:=bvNone;
  FPanelCabecera.Color:=RGBToColor(37, 73, 108);

  FLabelTitulo:=TLabel.Create(Self);
  FLabelTitulo.Name:='LabelTituloModerno';
  FLabelTitulo.Parent:=FPanelCabecera;
  FLabelTitulo.AutoSize:=False;
  FLabelTitulo.Caption:='UNIÓN DE PEDIDOS';
  FLabelTitulo.Transparent:=True;
  FLabelTitulo.Font.Name:='Sans';
  FLabelTitulo.Font.Height:=-23;
  FLabelTitulo.Font.Style:=[fsBold];
  FLabelTitulo.Font.Color:=clWhite;

  FLabelSubtitulo:=TLabel.Create(Self);
  FLabelSubtitulo.Name:='LabelSubtituloModerno';
  FLabelSubtitulo.Parent:=FPanelCabecera;
  FLabelSubtitulo.AutoSize:=False;
  FLabelSubtitulo.Caption:=
    'Seleccione el pedido que se trasladará y el pedido que recibirá sus líneas.';
  FLabelSubtitulo.Transparent:=True;
  FLabelSubtitulo.Font.Name:='Sans';
  FLabelSubtitulo.Font.Height:=-13;
  FLabelSubtitulo.Font.Color:=RGBToColor(222, 235, 247);

  FPanelAviso:=TPanel.Create(Self);
  FPanelAviso.Name:='PanelAvisoUnion';
  // Imprescindible: TPanel puede adoptar su Name como Caption y dibujarlo
  // centrado bajo el label, provocando la superposición observada en GTK.
  FPanelAviso.Caption:='';
  FPanelAviso.Parent:=Self;
  FPanelAviso.BevelOuter:=bvNone;
  FPanelAviso.Color:=RGBToColor(255, 244, 218);

  FLabelAviso:=TLabel.Create(Self);
  FLabelAviso.Name:='LabelAvisoUnion';
  FLabelAviso.Parent:=FPanelAviso;
  FLabelAviso.AutoSize:=False;
  FLabelAviso.Alignment:=taCenter;
  FLabelAviso.Layout:=tlCenter;
  // Mensaje único y breve: evitamos que GTK superponga líneas al ajustar el texto.
  FLabelAviso.WordWrap:=False;
  FLabelAviso.Caption:=
    'El pedido origen se copiará al destino y después se eliminará.';
  FPanelAviso.ShowHint:=True;
  FPanelAviso.Hint:=
    'Las líneas del pedido origen se añadirán al pedido destino y, al finalizar, '+
    'el pedido origen será eliminado.';
  FLabelAviso.Transparent:=True;
  FLabelAviso.Font.Name:='Sans';
  FLabelAviso.Font.Height:=-11;
  FLabelAviso.Font.Style:=[fsBold];
  FLabelAviso.Font.Color:=RGBToColor(110, 72, 20);
  FLabelAviso.BringToFront;
end;

procedure TFUniPedi.AplicarEstiloModerno;
begin
  Caption:='FacturLinEx · Unión de pedidos';
  Color:=RGBToColor(241, 246, 251);
  Font.Name:='Sans';
  Font.Color:=RGBToColor(35, 52, 70);

  StaticText1.ParentFont:=False;
  StaticText1.Font.Name:='Sans';
  StaticText1.Font.Height:=-14;
  StaticText1.Font.Style:=[fsBold];
  StaticText1.Font.Color:=clWhite;
  StaticText1.Color:=RGBToColor(42, 86, 132);
  StaticText1.Alignment:=taLeftJustify;
  StaticText1.BorderStyle:=sbsNone;
  StaticText1.Caption:='  1. PEDIDO ORIGEN · pedido que se copiará y eliminará';

  StaticText2.ParentFont:=False;
  StaticText2.Font.Name:='Sans';
  StaticText2.Font.Height:=-14;
  StaticText2.Font.Style:=[fsBold];
  StaticText2.Font.Color:=clWhite;
  StaticText2.Color:=RGBToColor(45, 112, 91);
  StaticText2.Alignment:=taLeftJustify;
  StaticText2.BorderStyle:=sbsNone;
  StaticText2.Caption:='  2. PEDIDO DESTINO · pedido que recibirá las líneas';

  BitBtn3.Caption:='Unir pedidos seleccionados';
  BitBtn3.Hint:=
    'Copia todas las líneas del pedido origen al destino y elimina el origen';
  BitBtn3.ShowHint:=True;
  BitBtn3.ParentFont:=False;
  BitBtn3.Font.Name:='Sans';
  BitBtn3.Font.Height:=-13;
  BitBtn3.Font.Style:=[fsBold];
  BitBtn3.Font.Color:=RGBToColor(26, 91, 62);
  BitBtn3.Color:=RGBToColor(217, 241, 228);
  BitBtn3.Layout:=blGlyphLeft;
  BitBtn3.Spacing:=10;

  BitBtn2.Caption:='Cerrar';
  BitBtn2.Hint:='Cerrar la unión de pedidos sin realizar cambios';
  BitBtn2.ShowHint:=True;
  BitBtn2.ParentFont:=False;
  BitBtn2.Font.Name:='Sans';
  BitBtn2.Font.Height:=-13;
  BitBtn2.Font.Style:=[fsBold];
  BitBtn2.Font.Color:=RGBToColor(52, 62, 72);
  BitBtn2.Color:=RGBToColor(232, 236, 240);
  BitBtn2.Layout:=blGlyphLeft;
  BitBtn2.Spacing:=10;

  Panel1.BevelOuter:=bvNone;
  Panel1.Color:=RGBToColor(239, 246, 252);
  Label1.ParentFont:=False;
  Label1.Font.Name:='Sans';
  Label1.Font.Height:=-14;
  Label1.Font.Style:=[fsBold];
  Label1.Font.Color:=RGBToColor(35, 68, 100);
  Label1.Caption:='Procesando líneas del pedido...';

  ConfigurarGridModerno(DBGrid1);
  ConfigurarGridModerno(DBGrid2);
end;

procedure TFUniPedi.ConfigurarGridModerno(AGrid: TDBGrid);
begin
  if not Assigned(AGrid) then Exit;
  AGrid.ParentFont:=False;
  AGrid.Font.Name:='Sans';
  AGrid.Font.Height:=-13;
  AGrid.Font.Color:=clWindowText;
  AGrid.Color:=clWindow;
  AGrid.FixedColor:=RGBToColor(225, 235, 245);
  AGrid.TitleFont.Name:='Sans';
  AGrid.TitleFont.Height:=-13;
  AGrid.TitleFont.Style:=[fsBold];
  AGrid.TitleFont.Color:=RGBToColor(30, 57, 82);
  AGrid.Options:=AGrid.Options+[dgTitles,dgIndicator,dgColumnResize,
    dgColumnMove,dgColLines,dgRowLines,dgRowSelect,dgAlwaysShowSelection];
  AGrid.ScrollBars:=ssAutoBoth;
end;

procedure TFUniPedi.RecolocarControles;
var
  Margen, CabeceraH, PieH, TituloH, Separacion, GridH, Disponible: Integer;
  TopGrid1, TopTitulo2, TopGrid2, TopPie: Integer;
begin
  if not Assigned(FPanelCabecera) then Exit;

  Margen:=18;
  CabeceraH:=76;
  PieH:=82;
  TituloH:=32;
  Separacion:=12;

  FPanelCabecera.SetBounds(0,0,ClientWidth,CabeceraH);
  FLabelTitulo.SetBounds(Margen,12,ClientWidth-(Margen*2),30);
  FLabelSubtitulo.SetBounds(Margen,44,ClientWidth-(Margen*2),22);

  Disponible:=ClientHeight-CabeceraH-PieH-(TituloH*2)-(Separacion*3)-Margen;
  GridH:=Disponible div 2;
  if GridH<150 then GridH:=150;

  StaticText1.SetBounds(Margen,CabeceraH+Separacion,ClientWidth-(Margen*2),TituloH);
  TopGrid1:=StaticText1.Top+TituloH+6;
  DBGrid1.SetBounds(Margen,TopGrid1,ClientWidth-(Margen*2),GridH);

  TopTitulo2:=DBGrid1.Top+DBGrid1.Height+Separacion;
  StaticText2.SetBounds(Margen,TopTitulo2,ClientWidth-(Margen*2),TituloH);
  TopGrid2:=StaticText2.Top+TituloH+6;
  DBGrid2.SetBounds(Margen,TopGrid2,ClientWidth-(Margen*2),GridH);

  TopPie:=ClientHeight-PieH+12;
  BitBtn3.SetBounds(Margen,TopPie,270,48);
  BitBtn2.SetBounds(ClientWidth-Margen-180,TopPie,180,48);

  FPanelAviso.SetBounds(BitBtn3.Left+BitBtn3.Width+14,TopPie,
    BitBtn2.Left-(BitBtn3.Left+BitBtn3.Width)-28,48);
  if FPanelAviso.Width<220 then FPanelAviso.Width:=220;
  FLabelAviso.SetBounds(12,0,FPanelAviso.ClientWidth-24,FPanelAviso.ClientHeight);

  Panel1.SetBounds((ClientWidth-420) div 2,(ClientHeight-100) div 2,420,100);
  Label1.SetBounds(20,16,Panel1.ClientWidth-40,24);
  ProgressBar1.SetBounds(20,56,Panel1.ClientWidth-40,22);
end;

procedure TFUniPedi.FormResize(Sender: TObject);
begin
  RecolocarControles;
end;

procedure TFUniPedi.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then
  begin
    // No interrumpimos una unión que ya está copiando líneas.
    if not Panel1.Visible then Close;
    Key:=0;
  end;
end;

procedure TFUniPedi.DibujarCeldaGrid(AGrid: TDBGrid; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  S: String;
  X, Y, AnchoTexto: Integer;
begin
  if gdSelected in State then
  begin
    AGrid.Canvas.Brush.Color:=RGBToColor(42,86,132);
    AGrid.Canvas.Font.Color:=clWhite;
    AGrid.Canvas.FillRect(Rect);

    if (Column<>nil) and (Column.Field<>nil) then
      S:=Column.Field.DisplayText
    else
      S:='';

    AnchoTexto:=AGrid.Canvas.TextWidth(S);
    X:=Rect.Left+4;
    if Column<>nil then
      case Column.Alignment of
        taCenter:
          X:=Rect.Left+((Rect.Right-Rect.Left-AnchoTexto) div 2);
        taRightJustify:
          X:=Rect.Right-AnchoTexto-4;
      end;
    Y:=Rect.Top+((Rect.Bottom-Rect.Top-AGrid.Canvas.TextHeight(S)) div 2);
    AGrid.Canvas.TextRect(Rect,X,Y,S);
    Exit;
  end;

  AGrid.Canvas.Brush.Color:=clWindow;
  AGrid.Canvas.Font.Color:=clWindowText;
  AGrid.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TFUniPedi.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  DibujarCeldaGrid(DBGrid1,Rect,DataCol,Column,State);
end;

procedure TFUniPedi.DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  DibujarCeldaGrid(DBGrid2,Rect,DataCol,Column,State);
end;

procedure TFUniPedi.MarcarColumnaOrdenada(AGrid: TDBGrid; Column: TColumn;
  const AOrden: String);
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
  if not Assigned(Column) then Exit;
  if SameText(AOrden,'ASC') then
    Column.Title.Caption:=Column.Title.Caption+' ▲'
  else
    Column.Title.Caption:=Column.Title.Caption+' ▼';
end;

procedure TFUniPedi.AplicarOrdenGrid(AGrid: TDBGrid; AQuery: TZQuery;
  Column: TColumn; var AOrden: String);
var
  SQLBase, SQLMayus, OrdenUsado: String;
  P: Integer;
  K0, K1, K2, K3, K4: Variant;
  TieneClave: Boolean;
begin
  if (not Assigned(AGrid)) or (not Assigned(AQuery)) or
     (not Assigned(Column)) or (Column.FieldName='') or
     (not AQuery.Active) then Exit;

  TieneClave:=AQuery.RecordCount>0;
  if TieneClave then
  begin
    K0:=AQuery.FieldByName('PC0').Value;
    K1:=AQuery.FieldByName('PC1').Value;
    K2:=AQuery.FieldByName('PC2').Value;
    K3:=AQuery.FieldByName('PC3').Value;
    K4:=AQuery.FieldByName('PC4').Value;
  end;

  AGrid.Enabled:=False;
  AQuery.DisableControls;
  try
    SQLBase:=Trim(AQuery.SQL.Text);
    SQLMayus:=UpperCase(SQLBase);
    P:=Pos(' ORDER BY ',SQLMayus);
    if P>0 then SQLBase:=Trim(Copy(SQLBase,1,P-1));

    OrdenUsado:=AOrden;
    AQuery.Close;
    AQuery.SQL.Text:=SQLBase+' ORDER BY '+Column.FieldName+' '+OrdenUsado;
    AQuery.Open;

    if TieneClave then
      AQuery.Locate('PC0,PC1,PC2,PC3,PC4',
        VarArrayOf([K0,K1,K2,K3,K4]),[]);

    MarcarColumnaOrdenada(AGrid,Column,OrdenUsado);
    if SameText(AOrden,'ASC') then AOrden:='DESC' else AOrden:='ASC';
  finally
    AQuery.EnableControls;
    AGrid.Enabled:=True;
    AGrid.Invalidate;
  end;
end;

procedure TFUniPedi.DBGrid1TitleClick(Column: TColumn);
begin
  AplicarOrdenGrid(DBGrid1,dbPedic,Column,FOrdenGrid1);
end;

procedure TFUniPedi.DBGrid2TitleClick(Column: TColumn);
begin
  AplicarOrdenGrid(DBGrid2,dbPedic1,Column,FOrdenGrid2);
end;

function TFUniPedi.DescribirPedido(AQuery: TZQuery): String;
begin
  Result:='';
  if (not Assigned(AQuery)) or (not AQuery.Active) or
     (AQuery.RecordCount=0) then Exit;
  Result:=Format('Tienda %s · %s · Proveedor %s · Serie %s · Pedido %s',[
    AQuery.FieldByName('PC0').AsString,
    FormatDateTime('dd/mm/yyyy',AQuery.FieldByName('PC1').AsDateTime),
    AQuery.FieldByName('PC2').AsString,
    AQuery.FieldByName('PC3').AsString,
    AQuery.FieldByName('PC4').AsString]);
end;


initialization
  {$I unirpedido.lrs}

end.

