{
  Gestion LinEx FacturLinEx 2.0

  Copyright (C) 2000-2009,  Nicolas Lopez de Lerma Aymerich

  PuntoDev GNU S.L. <info@puntodev.com>

  Collaborators:
                 José Belenguer
                 Xaime Alvarez Ares
                 Elmo Calatayud Chumbes
                 Javier Perez

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

unit EtiEans;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, Buttons, StdCtrls, EditBtn, DBGrids, LR_Class, LR_DBSet, LR_BarC,
  ZConnection, ZDataset, LCLType, Process;

type

  { TEtiBarras }

  TEtiBarras = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    CheckBox1: TCheckBox;  // Para Controlar herramienta Externa Glabels
    DateEdit1: TDateEdit;  // Desde Fecha de Ultima Compra
    DateEdit2: TDateEdit;  // hasta Fecha de Ultima Compra
    DBGrid1: TDBGrid;
    Edit1: TEdit; // Desde Codigo
    Edit2: TEdit; // Hasta Codigo
    Edit3: TEdit; // Familia
    Edit4: TEdit;
    Edit5: TEdit; // Proveedor
    Edit6: TEdit;
    Edit7: TEdit; // Numero de Copias
    frBarCodeObject1: TfrBarCodeObject;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioGroup1: TRadioGroup;
    SaveDialog1: TSaveDialog;
    dbArtiTien: TZQuery;
    dbEans: TZQuery;
    dbDirec: TZQuery;
    dbProve: TZQuery;
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure Edit7Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton3Change(Sender: TObject);
  private
    procedure AplicarEstiloModerno;
    { private declarations }
  public
    { public declarations }
  end; 
  procedure ShowFormEtiEans;

var
  EtiBarras: TEtiBarras;
  txtSql: String;
implementation
Uses
Busquedas, Global, Funciones;

procedure ShowFormEtiEans;
begin
  with TEtiBarras.Create(Application) do
    begin
       ShowModal;
    end;
end;

{ TEtiBarras }

procedure TEtiBarras.FormCreate(Sender: TObject);
begin
  // Conectate(dbConect);              // Utilizamos datamodule1.dbConexión para toda la aplicación.
  Edit1.Text := '';
  Edit2.Text := 'ZZZZZZZZZZZZZZZZZZZZZZZ';
  Edit3.Text := '';
  Edit4.Text := '';
  Edit5.Text := '';
  Edit6.Text := '';
  Label8.Visible := False;
  Edit7.Visible := False;
  {$IFDEF LINUX}
     CheckBox1.Checked := True;
  {$ELSE}
     CheckBox1.Checked := False;
     CheckBox1.Enabled := False;
     CheckBox1.Visible := False;
  {$ENDIF}
  // Verificando datos em las Tablas
  // ---------------- Tablas Productos -------------------
  txtSql := 'SELECT A0, A1 FROM artitien'+Tienda+' LIMIT 0, 10';
  dbArtitien.Active := False;
  dbArtitien.Sql.Text:=txtSql;
  dbArtitien.Active:=True;
  if dbArtitien.RecordCount=0 then Showmessage('La Tabla de Productos esta vacia, Primero debe Ingrear los Productos');
  // ---------------- Tablas Eans -------------------
  txtSql := 'SELECT EAN1 AS A0,EAN2 AS A1 FROM eans LIMIT 0, 10';
  dbEans.Active := False;
  dbEans.Sql.Text:=txtSql;
  dbEans.Active:=True;
  if dbEans.RecordCount=0 then
     begin
        Showmessage('La Tabla de Eans esta Vacia .. Desactivando Check Eans');
        RadioGroup1.Visible := False;
        dbEans.Active := False;
     end;
  // ---------------- Tablas de Clientes -------------------
  txtSql := 'SELECT C0, C1 FROM clientes LIMIT 0, 10';
  dbDirec.Active := False;
  dbDirec.Sql.Text:=txtSql;
  dbDirec.Active:=True;
  if dbDirec.RecordCount=0 then
     begin
        Showmessage('La Tabla de Clientes esta Vacia .. Desactivando Clientes');
        BitBtn2.Enabled := False;
        dbDirec.Active := False;
     end;
  // ---------------- Tablas de Proveedores -------------------
  txtSql := 'SELECT P0, P1 FROM proveedores LIMIT 0, 10';
  dbProve.Active := False;
  dbProve.Sql.Text:=txtSql;
  dbProve.Active:=True;
  if dbProve.RecordCount=0 then
     begin
        Showmessage('La Tabla de Proveedores esta Vacia .. Desactivando Proveedores');
        BitBtn3.Enabled := False;
        Edit5.Enabled := False;
        Edit6.Enabled := False;
        BitBtn10.Enabled := False;
        dbProve.Active := False;
     end;
   Panel2.BringToFront;
   AplicarEstiloModerno();
end;


procedure TEtiBarras.AplicarEstiloModerno;
var
  PnlCabecera: TPanel;
  LTitulo, LSubtitulo: TLabel;
  GBFiltros, GBOpciones: TGroupBox;
  X: Integer;
begin
  Caption := 'Etiquetas y códigos de barras';
  Position := poScreenCenter;
  WindowState := wsMaximized;
  Color := $00F4F6F8;
  Constraints.MinWidth := 1020;
  Constraints.MinHeight := 680;

  Panel1.Caption := '';
  Panel2.Caption := '';
  Panel3.Caption := '';
  Panel4.Caption := '';

  Panel1.Align := alBottom;
  Panel1.Height := 78;
  Panel1.BevelOuter := bvNone;
  Panel1.Color := clWhite;

  Panel2.Align := alClient;
  Panel2.BevelOuter := bvNone;
  Panel2.Color := $00F4F6F8;

  PnlCabecera := TPanel.Create(Self);
  PnlCabecera.Parent := Panel2;
  PnlCabecera.Align := alTop;
  PnlCabecera.Height := 82;
  PnlCabecera.BevelOuter := bvNone;
  PnlCabecera.Color := clNavy;

  LTitulo := TLabel.Create(Self);
  LTitulo.Parent := PnlCabecera;
  LTitulo.SetBounds(24, 13, 620, 30);
  LTitulo.Caption := 'ETIQUETAS Y CÓDIGOS DE BARRAS';
  LTitulo.ParentFont := False;
  LTitulo.Font.Name := 'Sans';
  LTitulo.Font.Height := -20;
  LTitulo.Font.Style := [fsBold];
  LTitulo.Font.Color := clWhite;

  LSubtitulo := TLabel.Create(Self);
  LSubtitulo.Parent := PnlCabecera;
  LSubtitulo.SetBounds(25, 47, 720, 22);
  LSubtitulo.Caption := 'Seleccione artículos, clientes o proveedores y controle el número de copias antes de generar.';
  LSubtitulo.ParentFont := False;
  LSubtitulo.Font.Name := 'Sans';
  LSubtitulo.Font.Height := -12;
  LSubtitulo.Font.Color := clSilver;

  GBFiltros := TGroupBox.Create(Self);
  GBFiltros.Parent := Panel2;
  GBFiltros.SetBounds(20, 98, 720, 352);
  GBFiltros.Caption := ' FILTROS DE SELECCIÓN ';
  GBFiltros.ParentFont := False;
  GBFiltros.Font.Name := 'Sans';
  GBFiltros.Font.Height := -13;
  GBFiltros.Font.Style := [fsBold];
  GBFiltros.Color := clWhite;

  Label1.Parent := GBFiltros; Edit1.Parent := GBFiltros; BitBtn7.Parent := GBFiltros;
  Label2.Parent := GBFiltros; Edit2.Parent := GBFiltros; BitBtn8.Parent := GBFiltros;
  Label3.Parent := GBFiltros; Edit3.Parent := GBFiltros; Edit4.Parent := GBFiltros; BitBtn9.Parent := GBFiltros;
  Label4.Parent := GBFiltros; Edit5.Parent := GBFiltros; Edit6.Parent := GBFiltros; BitBtn10.Parent := GBFiltros;
  Label5.Parent := GBFiltros; DateEdit1.Parent := GBFiltros;
  Label6.Parent := GBFiltros; DateEdit2.Parent := GBFiltros;

  Label1.SetBounds(18, 42, 120, 22); Edit1.SetBounds(145, 36, 170, 31); BitBtn7.SetBounds(322, 36, 32, 31);
  Label2.SetBounds(370, 42, 120, 22); Edit2.SetBounds(492, 36, 170, 31); BitBtn8.SetBounds(668, 36, 32, 31);
  Label3.SetBounds(18, 102, 120, 22); Edit3.SetBounds(145, 96, 82, 31); BitBtn9.SetBounds(233, 96, 32, 31); Edit4.SetBounds(272, 96, 428, 31);
  Label4.SetBounds(18, 162, 120, 22); Edit5.SetBounds(145, 156, 82, 31); BitBtn10.SetBounds(233, 156, 32, 31); Edit6.SetBounds(272, 156, 428, 31);
  Label5.SetBounds(18, 222, 122, 22); DateEdit1.SetBounds(145, 216, 136, 31);
  Label6.SetBounds(356, 222, 122, 22); DateEdit2.SetBounds(484, 216, 136, 31);

  GBOpciones := TGroupBox.Create(Self);
  GBOpciones.Parent := Panel2;
  GBOpciones.SetBounds(Panel2.ClientWidth - 270, 98, 250, 352);
  GBOpciones.Anchors := [akTop, akRight];
  GBOpciones.Caption := ' OPCIONES DE GENERACIÓN ';
  GBOpciones.ParentFont := False;
  GBOpciones.Font.Name := 'Sans';
  GBOpciones.Font.Height := -13;
  GBOpciones.Font.Style := [fsBold];
  GBOpciones.Color := clWhite;

  RadioGroup1.Parent := GBOpciones;
  RadioGroup1.SetBounds(14, 28, 220, 78);
  RadioGroup1.ParentFont := False;
  RadioGroup1.Font.Style := [];
  RadioGroup1.Color := clWhite;

  Panel4.Parent := GBOpciones;
  Panel4.SetBounds(14, 116, 220, 174);
  Panel4.BevelOuter := bvLowered;
  Panel4.Color := clWhite;
  Label7.Left := 30;
  Label7.Top := 10;
  RadioButton1.SetBounds(10, 40, 198, 24);
  RadioButton2.SetBounds(10, 68, 200, 24);
  RadioButton3.SetBounds(10, 96, 150, 24);
  Label8.SetBounds(28, 132, 88, 22);
  Edit7.SetBounds(126, 127, 54, 29);

  CheckBox1.Parent := GBOpciones;
  CheckBox1.SetBounds(18, 306, 216, 24);
  CheckBox1.ParentFont := False;
  CheckBox1.Font.Style := [];

  { Acciones principales }
  X := 16;
  BitBtn1.SetBounds(X, 11, 134, 56); BitBtn1.Layout := blGlyphLeft;
  BitBtn2.SetBounds(X + 144, 11, 134, 56); BitBtn2.Layout := blGlyphLeft;
  BitBtn3.SetBounds(X + 288, 11, 134, 56); BitBtn3.Caption := 'Proveedores'; BitBtn3.Layout := blGlyphLeft;
  BitBtn4.SetBounds(X + 432, 11, 134, 56); BitBtn4.Caption := 'Generadas'; BitBtn4.Layout := blGlyphLeft;
  BitBtn5.SetBounds(X + 576, 11, 134, 56); BitBtn5.Layout := blGlyphLeft;
  BitBtn6.SetBounds(Panel1.ClientWidth - 150, 11, 134, 56);
  BitBtn6.Anchors := [akTop, akRight];
  BitBtn6.Layout := blGlyphLeft;

  { Grid conservado y preparado para cuando sea utilizado }
  Panel3.Align := alClient;
  Panel3.BevelOuter := bvNone;
  DBGrid1.Align := alClient;
  DBGrid1.BorderSpacing.Around := 12;
  DBGrid1.Color := clWhite;
  DBGrid1.ParentFont := False;
  DBGrid1.Font.Name := 'Sans';
  DBGrid1.Font.Height := -13;
  Panel2.BringToFront;
end;

procedure TEtiBarras.RadioButton1Change(Sender: TObject);
begin
  if RadioButton1.Checked=True then
    begin
      Label8.Visible:=False; Edit7.Visible:=False;
    end;
end;

procedure TEtiBarras.RadioButton2Change(Sender: TObject);
begin
  if RadioButton2.Checked=True then
    begin
      Label8.Visible:=False; Edit7.Visible:=False;
    end;
end;

procedure TEtiBarras.RadioButton3Change(Sender: TObject);
begin
  if RadioButton3.Checked=True then
    begin
      Label8.Visible:=True; Edit7.Visible:=True;
      Edit7.SetFocus;
    end;
end;

procedure TEtiBarras.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

     dbArtitien.Active := False;
     dbEans.Active := False;
     dbDirec.Active := False;
     dbProve.Active := False;
     CloseAction := CaFree;
end;

procedure TEtiBarras.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key <> VK_ESCAPE then
    Exit;

  { Esta unidad no tiene pantallas interiores navegables: en la pantalla
    principal, ESC ejecuta exactamente la misma acción que el botón Cerrar. }
  Key := 0;
  BitBtn6Click(BitBtn6);
end;

procedure TEtiBarras.BitBtn1Click(Sender: TObject);
Var
  TxtQuery: String;
  F: TextFile;
  Conta: Integer;
begin
  if RadioGroup1.ItemIndex = 0 Then
     begin
        TxtQuery:='SELECT A0,A1,A2,A4 FROM artitien'+Tienda+' WHERE A0>="'+Edit1.Text+'" AND A0<="'+Edit2.Text+'" ';
        if Trim(Edit3.Text)<>'' then TxtQuery:=TxtQuery+'AND A14='+Edit3.Text+' ';
        if Trim(Edit5.Text)<>'' then TxtQuery:=TxtQuery+'AND A35='+Edit5.Text+' ';
        if trim(DateEdit1.Text)<>'' then TxtQuery:=TxtQuery+'AND A13>="'+FormatDateTime('yy/mm/dd',StrToDate(DateEdit1.Text))+'"';
        if trim(DateEdit2.Text)<>'' then TxtQuery:=TxtQuery+' AND A13<="'+FormatDateTime('yy/mm/dd',StrToDate(DateEdit2.Text))+'"';
     end
  else
     Begin
        TxtQuery:='SELECT a.EAN0 AS A0,a.EAN2 AS A1, b.A2, a.EAN3 AS A4 FROM eans a, artitien'+Tienda+' b WHERE a.EAN1=b.A0 AND a.EAN1>="'+Edit1.Text+'" AND a.EAN1<="'+Edit2.Text+'" ';
     end;

  dbArtitien.Active:=False;
  dbArtitien.Sql.Text:=TxtQuery;
  dbArtitien.Active:=True;
  if dbArtitien.RecordCount=0 then begin Showmessage('CON ESTA SELECCION NO ENCUENTRO ARTICULOS.'); exit; end;
  if Application.MessageBox(PChar('SE VAN A GENERAR '+IntToStr(dbArtitien.RecordCount)+' ARTICULOS, CONTINUAMOS?'),'FacturLinEx2',  MB_OKCANCEL+MB_ICONQUESTION ) = ID_CANCEL   Then Exit;
  dbArtitien.First;
  Screen.Cursor := crHourGlass;
  If CheckBox1.Checked Then
  Begin
  SaveDialog1.FileName:=RutaReports + 'etieans.txt';
  AssignFile(F, SaveDialog1.FileName);
  Rewrite(F);
  while not dbArtitien.Eof do
    begin
     if RadioButton1.Checked=True then
        Writeln(F, dbArtitien.Fields[0].AsString+':'+dbArtitien.Fields[1].AsString+':'+dbArtitien.Fields[2].AsString);
     if RadioButton2.Checked=True then
       begin
         for Conta:=1 to dbArtitien.fields[4].AsInteger do
           Writeln(F, dbArtitien.Fields[0].AsString+':'+dbArtitien.Fields[1].AsString+':'+dbArtitien.Fields[2].AsString);
       end;
     if RadioButton3.Checked=True then
       begin
          for Conta:=1 to StrToInt(Edit7.Text) do
            Writeln(F, dbArtitien.Fields[0].AsString+':'+dbArtitien.Fields[1].AsString+':'+dbArtitien.Fields[2].AsString);
       end;
     dbArtitien.Next;
    end;
  CloseFile(F);
  Screen.Cursor := crDefault;
  Showmessage('LA GENERACION HA TERMINADO CORRECTAMENTE');
  {$IFDEF LINUX}
   AProcess := TProcess.Create(nil);
   AStringList := TStringList.Create;
   AProcess.CommandLine := 'glabels /usr/share/facturlinex2/plantillas_glabels/etibarras.glabels';
   // AProcess.Options := AProcess.Options + [poWaitOnExit, poUsePipes];
   AProcess.Options := AProcess.Options;
   AProcess.Execute;
   AProcess.Free; AStringList.Free;
  {$ENDIF}
  end
  Else
    Begin
     frDBDataSet1.DataSet:=dbArtitien;
     frReport1.LoadFromFile(RutaReports+'EtiEans.lrf');
     frReport1.ShowReport;
    End;
end;

procedure TEtiBarras.BitBtn10Click(Sender: TObject);
begin
  if Edit5.Text='' then begin ShowMessage('DEBE INGRESAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit5.Text:='0'; end;
  try
  Edit5.Text := FBusquedas.IniciaBusquedas('SELECT P0, P1 FROM proveedores WHERE P0>='+Edit5.Text+' ORDER BY P1',
                                           ['Proveedor', 'Nombre' ], 'P0' );
  except
        Edit5.Text := '';
        ShowMessage('No selecciono ningún Dato!');
  end;

end;

procedure TEtiBarras.BitBtn2Click(Sender: TObject);
var
  SqlText: String;
  F: TextFile;
begin
  if Edit1.Text='' then Edit1.Text:='0';
  if Edit2.Text='ZZZZZZZZZZZZZZZZZZZZZZZ' then Edit2.Text:='99999999';
  dbDirec.Active:=False;
//  SqlText:= 'SELECT C0,C1,C3,C4,C37,C38 FROM clientes';
  SqlText:= 'SELECT C0,C1,C3,C4 FROM clientes';
  SqlText:= SqlText + ' WHERE  C0>='+Edit1.Text+' AND C0<='+Edit2.Text+' ORDER BY C0 ';
  dbDirec.SQL.Text:=SqlText;
  dbDirec.Active:=True;
  dbDirec.First;
  Screen.Cursor := crHourGlass;
  If CheckBox1.Checked Then
     Begin
     SaveDialog1.FileName:=RutaReports + 'etidirec.txt';
     AssignFile(F, SaveDialog1.FileName);
     Rewrite(F);
     while not dbDirec.Eof do
      begin
       Writeln(F, dbDirec.Fields[0].AsString+':'+dbDirec.Fields[1].AsString+':'+dbDirec.Fields[2].AsString+':'+dbDirec.Fields[3].AsString);
        // +':'+dbDirec.Fields[4].AsString+':'+dbDirec.Fields[5].AsString);
       dbDirec.Next;
      end;
      CloseFile(F);
     Screen.Cursor := crDefault;
     Showmessage('LA GENERACION HA TERMINADO CORRECTAMENTE');
     {$IFDEF LINUX}
        AProcess := TProcess.Create(nil);
        AStringList := TStringList.Create;
        AProcess.CommandLine := 'glabels /usr/share/facturlinex2/plantillas_glabels/etidirec.glabels';
        AProcess.Options := AProcess.Options;
        AProcess.Execute;
        AProcess.Free; AStringList.Free;
     {$ENDIF}
     end
   Else
     Begin
     frDBDataSet1.DataSet:=dbDirec;
     frReport1.LoadFromFile(RutaReports+'EtiDirec.lrf');
     frReport1.ShowReport;
     End;

     Edit1.Text := '';
     Edit2.Text := 'ZZZZZZZZZZZZZZZZZZZZZZZ';

end;

procedure TEtiBarras.BitBtn3Click(Sender: TObject);
var
  SqlText: String;
  F: TextFile;
begin
  if Edit1.Text='' then Edit1.Text:='0';
  if Edit2.Text='ZZZZZZZZZZZZZZZZZZZZZZZ' then Edit2.Text:='99999999';
  dbDirec.Active:=False;
  SqlText:= 'SELECT P0 as C0,P1 as C1,P2 as C2,P3 as C3, P4 as C4  FROM proveedores';
  SqlText:= SqlText + ' WHERE  P0>='+Edit1.Text+' AND P0<='+Edit2.Text+' ORDER BY P0 ';
  dbDirec.SQL.Text:=SqlText;
  dbDirec.Active:=True;
  dbDirec.First;
  Screen.Cursor := crHourGlass;
  If CheckBox1.Checked Then
     Begin
     SaveDialog1.FileName:=RutaIni + 'etidirec.txt';
     AssignFile(F, SaveDialog1.FileName);
     Rewrite(F);
     while not dbDirec.Eof do
      begin
       Writeln(F, dbDirec.Fields[0].AsString+':'+dbDirec.Fields[1].AsString+':'+dbDirec.Fields[2].AsString+':'+dbDirec.Fields[3].AsString);
       //+':'+dbDirec.Fields[4].AsString+':'+dbDirec.Fields[5].AsString);
       dbDirec.Next;
      end;
      CloseFile(F);
     Screen.Cursor := crDefault;
     Showmessage('LA GENERACION HA TERMINADO CORRECTAMENTE');
     {$IFDEF LINUX}
        AProcess := TProcess.Create(nil);
        AStringList := TStringList.Create;
        AProcess.CommandLine := 'glabels /usr/share/facturlinex2/plantillas_glabels/etidirec.glabels';
        AProcess.Options := AProcess.Options;
        AProcess.Execute;
        AProcess.Free; AStringList.Free;
     {$ENDIF}
     end
   Else
     Begin
     frDBDataSet1.DataSet:=dbDirec;
     frReport1.LoadFromFile(RutaReports+'EtiDirec.lrf');
     frReport1.ShowReport;
     End;

     Edit1.Text := '';
     Edit2.Text := 'ZZZZZZZZZZZZZZZZZZZZZZZ';

end;

procedure TEtiBarras.BitBtn4Click(Sender: TObject);
Var
  TxtQuery: String;
begin
  If CheckBox1.Checked Then
   Begin
  {$IFDEF LINUX}
   AProcess := TProcess.Create(nil);
   AStringList := TStringList.Create;
   AProcess.CommandLine := 'glabels /usr/share/facturlinex2/plantillas_glabels/etibarras.glabels';
   AProcess.Options := AProcess.Options;
   AProcess.Execute;
   AProcess.Free; AStringList.Free;
  {$ENDIF}
  end
  Else
    Begin
  if RadioGroup1.ItemIndex = 0 Then
     begin
        TxtQuery:='SELECT A0,A1,A2,A4 FROM artitien'+Tienda+' WHERE A0>="'+Edit1.Text+'" AND A0<="'+Edit2.Text+'" ';
        if Trim(Edit3.Text)<>'' then TxtQuery:=TxtQuery+'AND A14='+Edit3.Text+' ';
        if Trim(Edit5.Text)<>'' then TxtQuery:=TxtQuery+'AND A35='+Edit5.Text+' ';
        if trim(DateEdit1.Text)<>'' then TxtQuery:=TxtQuery+'AND A13>="'+FormatDateTime('yy/mm/dd',StrToDate(DateEdit1.Text))+'"';
        if trim(DateEdit2.Text)<>'' then TxtQuery:=TxtQuery+' AND A13<="'+FormatDateTime('yy/mm/dd',StrToDate(DateEdit2.Text))+'"';
     end
  else
     Begin
        TxtQuery:='SELECT a.EAN0 AS A0,a.EAN2 AS A1, b.A2, a.EAN3 AS A4 FROM eans a, artitien'+Tienda+' b WHERE a.EAN1=b.A0 AND a.EAN1>="'+Edit1.Text+'" AND a.EAN1<="'+Edit2.Text+'" ';
        // TxtQuery:='SELECT EAN1 AS A0,EAN2 AS A1,EAN4 AS A2, EAN3 AS A4 FROM eans WHERE EAN1>="'+Edit1.Text+'" AND EAN1<="'+Edit2.Text+'" ';
     end;

  dbArtitien.Active:=False;
  dbArtitien.Sql.Text:=TxtQuery;
  dbArtitien.Active:=True;

     if dbArtitien.RecordCount=0 then exit;
     frDBDataSet1.DataSet:=dbArtitien;
     frReport1.LoadFromFile(RutaReports+'EtiEans.lrf');
     frReport1.ShowReport;
    End;
end;

procedure TEtiBarras.BitBtn5Click(Sender: TObject);
var
  F: TextFile;
begin
  If CheckBox1.Checked Then
  Begin
  {$IFDEF LINUX}
  if Application.MessageBox('CONFIRME EL BORRADO DE LAS ETIQUETAS ACTUALES','FacturLinEx2', MB_OKCANCEL+MB_ICONINFORMATION ) = ID_CANCEL Then Exit;
  SaveDialog1.FileName:=RutaReports + 'etieans.txt';
  AssignFile(F, SaveDialog1.FileName);
  Rewrite(F);
  CloseFile(F);
  {$ENDIF}
  end;
end;

procedure TEtiBarras.BitBtn6Click(Sender: TObject);
begin
   Close();
end;

procedure TEtiBarras.BitBtn7Click(Sender: TObject);
begin
  if Edit1.Text='' then begin ShowMessage('DEBE INGRESAR EL COMIENZO DEL TEXTO A BUSCAR'); end;
  try
  if Edit1.Text='' then begin
    Edit1.Text := FBusquedas.IniciaBusquedas('SELECT A0, A1 FROM artitien'+Tienda+' ORDER BY A1',
                                           ['Codigo', 'Descripcion' ], 'A0' );
    end
    Else
    Edit1.Text := FBusquedas.IniciaBusquedas('SELECT A0, A1 FROM artitien'+Tienda+' WHERE A0 >="'+Edit1.Text+'" ORDER BY A1',
                                           ['Codigo', 'Descripcion' ], 'A0' );
  except
        Edit1.Text := '';
        ShowMessage('No selecciono ningún Dato!');
  end;

end;

procedure TEtiBarras.BitBtn8Click(Sender: TObject);
begin
  if Edit2.Text='' then begin ShowMessage('DEBE INGRESAR EL COMIENZO DEL TEXTO A BUSCAR'); end;
  try
  if Edit2.Text='' then begin
    Edit2.Text := FBusquedas.IniciaBusquedas('SELECT A0, A1 FROM artitien'+Tienda+' ORDER BY A1',
                                           ['Codigo', 'Descripcion' ], 'A0' );
    end
    Else
    Edit2.Text := FBusquedas.IniciaBusquedas('SELECT A0, A1 FROM artitien'+Tienda+' WHERE A0 >="'+Edit1.Text+'" ORDER BY A1',
                                           ['Codigo', 'Descripcion' ], 'A0' );
  except
        Edit3.Text := '';
        ShowMessage('No selecciono ningún Dato!');
  end;
end;

procedure TEtiBarras.BitBtn9Click(Sender: TObject);
begin
  if Edit3.Text='' then begin ShowMessage('DEBE INGRESAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit3.Text:='0'; end;
  try
  if Edit4.Text='' then begin
     Edit3.Text := FBusquedas.IniciaBusquedas('SELECT F0, F1 FROM familias'+Tienda+
                                           ' WHERE F0 >="'+Edit3.Text+'" ORDER BY F1',
                                           ['Familia', 'Descripcion' ], 'F0' );
    end
    Else
     Edit3.Text := FBusquedas.IniciaBusquedas('SELECT F0, F1 FROM familias'+Tienda+
                                           ' WHERE F1 >="'+Edit4.Text+'" ORDER BY F1',
                                           ['Familia', 'Descripcion' ], 'F0' );
  except
        Edit3.Text := '';
        ShowMessage('No selecciono ningún Dato!');
  end;
end;

procedure TEtiBarras.Edit7Exit(Sender: TObject);
begin
    if (Edit7.Text='') or (Edit7.Text='0') then Edit1.Text:='1';
end;

initialization
  {$I etieans.lrs}

end.

