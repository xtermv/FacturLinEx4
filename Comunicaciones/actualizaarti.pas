{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2008,

  Nicolas Lopez de Lerma Aymerich
  PuntoDev GNU S.L. <info@puntodev.com>
  
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

Unit actualizaarti;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset, DBGrids,
  StdCtrls, db, LR_Class, ExtDlgs, EditBtn, LR_DBSet;

Type

  { TFActualizaArti }

  TFActualizaArti = Class(Tform)
    BitBtnCambiable1: TBitBtn;
    ComboCambiableNombre1: TComboBox;
    dbCambiable: TZQuery;
    dbRArtiTien: TZQuery;
    dbConectR: TZConnection;
    dbTiendas: TZQuery;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    dbArtiTien: TZQuery;
    dbTraAct: TZQuery;
    EditCambiableCodigo1: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    Label1: TLabel;
    LabelTiendaActiva: TLabel;
    LabelCambiable1: TLabel;
    LabelRegNuev: TLabel;
    LabelPModif: TLabel;
    LabelModif: TLabel;

    LabelPRegNuev: TLabel;
    LabelTituloDBGrid1: TLabel;
    PanelCambiable1: TPanel;
    PanelModif: TPanel;
    PanelInferior: TPanel;
    BitBtnInforme: TBitBtn;
    BitBtnImprimir: TBitBtn;
    BitBtnActualiza: TBitBtn;
    BitBtnCerrar: TBitBtn;
    Datasource1: TDatasource;
    dbQuery: TZQuery;
    PanelRegNuev: TPanel;
    StaticTextCambiableNombre1: TStaticText;
    procedure BitBtnCambiable1Click(Sender: TObject);
    procedure BitBtnInformeClick(Sender: TObject);
    procedure BitBtnImprimirClick(Sender: TObject);
    procedure BitBtnActualizaClick(Sender: TObject);
    procedure BitBtnCerrarClick(Sender: TObject);
    procedure ComboCambiableNombre1Click(Sender: TObject);
    procedure ComboCambiableNombre1KeyPress(Sender: TObject; var Key: char);

    procedure DBGrid1TitleClick(Column: TColumn);
    procedure EditCambiableCodigo1Enter(Sender: TObject);
    procedure EditCambiableCodigo1Exit(Sender: TObject);
    //procedure DBGrid2TitleClick(Column: TColumn);

    Procedure Formcreate(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
    //procedure Colorea(Column: TColumn;Grid: TDBGrid;dbColor: TZQuery);
    //procedure RellenaListBoxAnos(TxtQuery: String);
    //procedure BlancoGrid(Grid: TDBGrid);

    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);

    procedure OcultarBDGrid();
    procedure DimensionarColocarBDGrid();

    procedure CopiaTrabajoAct(Valor:String);

    //procedure EscogeNombreComboCambiable(TxtCampo: String; ComboCambiableNombre: TComboBox;  dbRArtiTien: TZQuery; EditCambiableNombre: TEdit; StaticTextCambiableNombre: TStaticText);
  Private
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormactualizaArti;
  
Var
  FActualizaArti: TFActualizaArti;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;

Implementation

uses
  Global, Funciones;

//=============== Crea el formulario ================
procedure ShowFormactualizaArti;
begin
  with TFActualizaArti.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFActualizaArti.Formcreate(Sender: Tobject);
var
   TxtQuery: String;
begin
   // Creo la Tabla temporal trabajoact
   dbTraAct.Active:=False;
   dbTraAct.SQL.Text:='DROP TABLE IF EXISTS trabajoact';
   dbTraAct.ExecSQL;
   TxtQuery :='CREATE TEMPORARY TABLE trabajoact ('+
       'TRA0 char(5) NOT NULL,'+
       'TRA1 int(6) NOT NULL,'+
       'TRA2 char(30) default NULL,'+
       'TRA3 double(10,2) default NULL,'+
       'PRIMARY KEY  (TRA0,TRA1),'+
       'UNIQUE KEY TRA0 (TRA0,TRA1),'+
       'KEY ktra (TRA0,TRA1)'+
     ') ENGINE=MyISAM DEFAULT CHARSET=latin1';
   //WriteLn(TxtQuery);
   dbTraAct.Sql.Text:= TxtQuery;
   dbTraAct.ExecSql;

   //---------------------Paneles visibles por defecto, los de RadioButton1Change

   BitBtnImprimir.Enabled:=False; BitBtnActualiza.Enabled:=True;
   BitBtnInforme.Enabled:=False;

   //Tienda es el valor de la variable global, se obtiene de los ficheros de configuración
   // al iniciar la aplicación. Tiene 4 digitos y su valor en entero es NTienda
   LabelCambiable1.Caption:='Tienda';
   LabelTiendaActiva.Caption:='La tienda activa es la nº: '+NTienda;

   //Ocultamos todos los DBGrid
   DimensionarColocarBDGrid();
   OcultarBDGrid();
  
End;

//==================== CERRAR ======================
procedure TFActualizaArti.BitBtnCerrarClick(Sender: TObject);
begin
  // Al terminar Borramos la tabla temporal
  dbTraAct.Active:=False;
  dbTraAct.SQL.Text:='DROP TABLE IF EXISTS trabajoact';
  dbTraAct.ExecSQL;

  dbQuery.Active:=False;
  dbConectR.Connected:=False;
  Close();
end;

Procedure TFActualizaArti.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//==================== ACTUALIZA ===================
procedure TFActualizaArti.BitBtnActualizaClick(Sender: TObject);
 var
   Conta1, Conta2, Cambia: Integer;
   TiendaR, NombreTiendaR: String; //TiendaR es el código de la tienda Remota con 4 dígitos
   TxtQuery: String;
 begin
   OcultarBDGrid();
   dbTraAct.Active:=False;
   dbTraAct.SQL.Text:='DELETE FROM trabajoact';
   dbTraAct.ExecSQL;
   BitBtnImprimir.Enabled:=False;
   BitBtnInforme.Enabled:=False;
   LabelPModif.Caption:='0'; LabelPRegNuev.Caption:='0'; Conta1:=0; Conta2:=0;
   if BitBtnActualiza.Caption='Nueva' then begin BitBtnActualiza.Caption:='Actualizar';Exit;end;
   Ordenado:=False;

   dbTiendas.Active:=False;
   if EditCambiableCodigo1.Text <> '' then
     TxtQuery:='SELECT * FROM tiendas WHERE T0='+EditCambiableCodigo1.Text
   else
     begin  // Dejo la tienda 0000 por defecto
       TxtQuery:='SELECT * FROM tiendas WHERE T0=0';
       EditCambiableCodigo1.Text:='0';
       EditCambiableCodigo1Exit(EditCambiableCodigo1);
     end;
   TiendaR:=DataModule1.LFill(EditCambiableCodigo1.Text,4,'0');
     //WriteLn('TiendaR es'+ TiendaR+'y Tienda es'+Tienda);
   if TiendaR=Tienda then
     begin
        ShowMessage('DEBE ACTUALIZAR DESDE UNA TIENDA DISTINTA A LA TIENDA ACTIVA');
        Exit;
     end;
   //WriteLn('TxtQuery de la Tienda seleccionada '+TxtQuery);
   dbTiendas.SQL.Text:=TxtQuery;
   dbTiendas.Active:=True;  //dbTiendas contiene todos los datos de la tienda Remota
   if dbTiendas.RecordCount=0 then
     begin
        ShowMessage('NO EXISTE ESA TIENDA EN EL FICHERO DE TIENDAS');
        Exit;
     end;
   if (dbTiendas.Fields[12].AsString='') or (dbTiendas.Fields[13].AsString='') or
      (dbTiendas.Fields[14].AsString='') or (dbTiendas.Fields[17].AsString='') then
     begin
        ShowMessage('LA DATOS DE '+NombreTiendaR+' SON INCOMPLETOS PARA LA CONEXIÓN');
        Exit;
     end;

   //Comunicación con la tienda Remota    (dbConectR)
   // Los parametros de la conexión se extraen de la tabla Tiendas
   try
   //Screen.Cursor := crHourGlass;
   dbConectR.Connected:=False;
   dbConectR.HostName:=dbTiendas.Fields[13].AsString;
   dbConectR.Database:=dbTiendas.Fields[12].AsString;
   dbConectR.User:=dbTiendas.Fields[15].AsString;
   dbConectR.Password:=dbTiendas.Fields[16].AsString;
   dbConectR.Port:=dbTiendas.Fields[14].AsInteger;
   dbConectR.Protocol:=dbTiendas.Fields[17].AsString;
   //WriteLn('dbConectR.HostName'+dbConectR.HostName);
   try
    dbConectR.Connected:=True;
  except
    ShowMessage('NO SE PUDO REALIZAR LA CONEXIÓN');
    Exit;
  end;

   dbRArtiTien.Active:=False;   //dbRArtitien depende de dbConectR
   dbRArtiTien.Sql.Text:='SELECT * FROM artitien'+TiendaR+' ORDER BY A0';
   //WriteLn('TxtQuery de seleccion Remota '+ 'SELECT * FROM artitien'+TiendaR+' ORDER BY A0');
   dbRArtiTien.Active := True; //Contiene todos los datos de los artículos de la tienda Remota
   //Screen.Cursor := crDefault;
   if dbRArtiTien.RecordCount=0 then
      begin
         ShowMessage('EL FICHERO DE ARTICULOS DE LA '+NombreTiendaR+' ESTA VACIO');
         Exit;
      end;
  except
   ShowMessage('NO SE HA PODIDO ESTABLECER LA COMUNICACION');
   exit;
  end;

  if Application.MessageBox('CONFIRME LA ACTUALIZACION DE ARTICULOS','FacturLinEx', boxstyle) = IDNO Then Exit;
  //Screen.Cursor := crHourGlass;
  dbRArtitien.First;
  while not dbRArtitien.Eof do
    begin
     try
      // Selecciona de MI tienda los articulos que vienen de la tienda Remota
      dbArtiTien.Active:=False;
      dbArtiTien.Sql.Text:='SELECT * FROM artitien'+ Tienda +' WHERE A0="'+dbRArtiTien.Fields[0].AsString+'"';
      //WriteLn('TxtQuery de seleccion de mi tienda '+ 'SELECT * FROM artitien'+ Tienda +' WHERE A0="'+dbRArtiTien.Fields[0].AsString+'"');
      dbArtiTien.Active := True;
      if dbArtiTien.RecordCount=0 then
        //Si el articulo no esta en mi tienda lo inserto
        begin
        //el número de campos con respecto a al 1.6 ha variado
         TxtQuery:='INSERT INTO artitien'+Tienda+' (A0,A1,A2,A3,A4,A5,A6,A7,A8,'+
         'A9,A10,A11,A12,A13,A14,A15,A16,A17,A18,A19,A20,A21,A22,A23,A24,A25,'+
         'A26,A27,A28,A29,A30,A31,A32,A33,A34) VALUES (';
         TxtQuery:=TxtQuery + '"' + dbRArtiTien.Fields[0].AsString + '",';
         TxtQuery:=TxtQuery + '"' + dbRArtiTien.Fields[1].AsString + '",';
         TxtQuery:=TxtQuery + dbRArtiTien.Fields[2].AsString + ',';
         TxtQuery:=TxtQuery + dbRArtiTien.Fields[3].AsString + ',';
         TxtQuery:=TxtQuery + '0,';
         TxtQuery:=TxtQuery + '0,';
         TxtQuery:=TxtQuery + '0,';
         TxtQuery:=TxtQuery + '0,';
         TxtQuery:=TxtQuery + '0,';
         TxtQuery:=TxtQuery + '0,';
         TxtQuery:=TxtQuery + dbRArtiTien.Fields[10].AsString + ',';
         TxtQuery:=TxtQuery + '0,';
         TxtQuery:=TxtQuery + '"",';
         TxtQuery:=TxtQuery + '"",';
         TxtQuery:=TxtQuery + dbRArtiTien.Fields[14].AsString + ',';
         TxtQuery:=TxtQuery + '"' + dbRArtiTien.Fields[15].AsString + '",';
         TxtQuery:=TxtQuery + '"' + dbRArtiTien.Fields[16].AsString + '",';
         TxtQuery:=TxtQuery + '"' + dbRArtiTien.Fields[17].AsString + '",';
         TxtQuery:=TxtQuery + '"' + dbRArtiTien.Fields[18].AsString + '",';
         TxtQuery:=TxtQuery + '"' + dbRArtiTien.Fields[19].AsString + '",';
         TxtQuery:=TxtQuery + dbRArtiTien.Fields[20].AsString + ',';
         TxtQuery:=TxtQuery + dbRArtiTien.Fields[21].AsString + ',';
         TxtQuery:=TxtQuery + '"' + dbRArtiTien.Fields[22].AsString + '",';
         TxtQuery:=TxtQuery + '"' + dbRArtiTien.Fields[23].AsString + '",';
         TxtQuery:=TxtQuery + dbRArtiTien.Fields[24].AsString + ',';
         TxtQuery:=TxtQuery + dbRArtiTien.Fields[25].AsString + ',';
         TxtQuery:=TxtQuery + dbRArtiTien.Fields[26].AsString + ',';
         TxtQuery:=TxtQuery + dbRArtiTien.Fields[27].AsString + ',';
         TxtQuery:=TxtQuery + dbRArtiTien.Fields[28].AsString + ',';
         TxtQuery:=TxtQuery + dbRArtiTien.Fields[29].AsString + ',';
         TxtQuery:=TxtQuery + dbRArtiTien.Fields[30].AsString + ',';
         TxtQuery:=TxtQuery + dbRArtiTien.Fields[31].AsString + ',';
         TxtQuery:=TxtQuery + dbRArtiTien.Fields[32].AsString + ',';
         TxtQuery:=TxtQuery + dbRArtiTien.Fields[33].AsString + ',';
         TxtQuery:=TxtQuery + '"' + dbRArtiTien.Fields[34].AsString + '")';
         //WriteLn('TxtQuery de insercion en mi tienda '+Txtquery);
         dbArtiTien.Active:=False;
         dbArtiTien.Sql.Text:=TxtQuery;
         dbArtiTien.ExecSQL; //Cada vez que pasa por aquí, inserta un articulo nuevo en nuestra BD
         Conta2:=Conta2+1;
         LabelPRegNuev.Caption:=FormatFloat('0',Conta2); LabelPRegNuev.Repaint;
         CopiaTrabajoAct('NUEVO');   //Mantiene un registro de las operaciones realizadas y le pone la etiquete de articulio nuevo
         end
      else
        // Si está, actualizo sus datos
        begin
         Cambia:=0;
         if dbArtiTien.Fields[1].AsString<>dbRArtiTien.Fields[1].AsString then Cambia:=1;
         if dbArtiTien.Fields[2].AsString<>dbRArtiTien.Fields[2].AsString then Cambia:=1;
         if dbArtiTien.Fields[3].AsString<>dbRArtiTien.Fields[3].AsString then Cambia:=1;
         if dbArtiTien.Fields[10].AsString<>dbRArtiTien.Fields[10].AsString then Cambia:=1;
         if dbArtiTien.Fields[14].AsString<>dbRArtiTien.Fields[14].AsString then Cambia:=1;
         if dbArtiTien.Fields[15].AsString<>dbRArtiTien.Fields[15].AsString then Cambia:=1;
         if dbArtiTien.Fields[16].AsString<>dbRArtiTien.Fields[16].AsString then Cambia:=1;
         if dbArtiTien.Fields[17].AsString<>dbRArtiTien.Fields[17].AsString then Cambia:=1;
         if dbArtiTien.Fields[18].AsString<>dbRArtiTien.Fields[18].AsString then Cambia:=1;
         if dbArtiTien.Fields[19].AsString<>dbRArtiTien.Fields[19].AsString then Cambia:=1;
         if dbArtiTien.Fields[20].AsString<>dbRArtiTien.Fields[20].AsString then Cambia:=1;
         if dbArtiTien.Fields[21].AsString<>dbRArtiTien.Fields[21].AsString then Cambia:=1;
         if dbArtiTien.Fields[22].AsString<>dbRArtiTien.Fields[22].AsString then Cambia:=1;
         if dbArtiTien.Fields[23].AsString<>dbRArtiTien.Fields[23].AsString then Cambia:=1;
         if dbArtiTien.Fields[24].AsString<>dbRArtiTien.Fields[24].AsString then Cambia:=1;
         if dbArtiTien.Fields[25].AsString<>dbRArtiTien.Fields[25].AsString then Cambia:=1;
         if dbArtiTien.Fields[26].AsString<>dbRArtiTien.Fields[26].AsString then Cambia:=1;
         if dbArtiTien.Fields[27].AsString<>dbRArtiTien.Fields[27].AsString then Cambia:=1;
         if dbArtiTien.Fields[28].AsString<>dbRArtiTien.Fields[28].AsString then Cambia:=1;
         if dbArtiTien.Fields[29].AsString<>dbRArtiTien.Fields[29].AsString then Cambia:=1;
         if dbArtiTien.Fields[30].AsString<>dbRArtiTien.Fields[30].AsString then Cambia:=1;
         if dbArtiTien.Fields[31].AsString<>dbRArtiTien.Fields[31].AsString then Cambia:=1;
         if dbArtiTien.Fields[32].AsString<>dbRArtiTien.Fields[32].AsString then Cambia:=1;
         if dbArtiTien.Fields[33].AsString<>dbRArtiTien.Fields[33].AsString then Cambia:=1;
         if dbArtiTien.Fields[34].AsString<>dbRArtiTien.Fields[34].AsString then Cambia:=1;
         if Cambia=1 then  //primero comprueba si hay diferencias entre el artículoActual y el ArticuloRemoto
           begin           // y si la hay, lo actualiza
            TxtQuery:='UPDATE artitien'+Tienda+' SET A1="'+ dbRArtiTien.Fields[1].AsString + '",';
            TxtQuery:=TxtQuery + 'A2='+ dbRArtiTien.Fields[2].AsString + ',';
            TxtQuery:=TxtQuery + 'A3='+ dbRArtiTien.Fields[3].AsString + ',';
            TxtQuery:=TxtQuery + 'A10='+ dbRArtiTien.Fields[10].AsString + ',';
            TxtQuery:=TxtQuery + 'A14='+ dbRArtiTien.Fields[14].AsString + ',';
            TxtQuery:=TxtQuery + 'A15="'+ dbRArtiTien.Fields[15].AsString + '",';
            TxtQuery:=TxtQuery + 'A16="'+ dbRArtiTien.Fields[16].AsString + '",';
            TxtQuery:=TxtQuery + 'A17="'+ dbRArtiTien.Fields[17].AsString + '",';
            TxtQuery:=TxtQuery + 'A18="'+ dbRArtiTien.Fields[18].AsString + '",';
            TxtQuery:=TxtQuery + 'A19="'+ dbRArtiTien.Fields[19].AsString + '",';
            TxtQuery:=TxtQuery + 'A20='+ dbRArtiTien.Fields[20].AsString + ',';
            TxtQuery:=TxtQuery + 'A21='+ dbRArtiTien.Fields[21].AsString + ',';
            TxtQuery:=TxtQuery + 'A22="'+ dbRArtiTien.Fields[22].AsString + '",';
            TxtQuery:=TxtQuery + 'A23="'+ dbRArtiTien.Fields[23].AsString + '",';
            TxtQuery:=TxtQuery + 'A24='+ dbRArtiTien.Fields[24].AsString + ',';
            TxtQuery:=TxtQuery + 'A25='+ dbRArtiTien.Fields[25].AsString + ',';
            TxtQuery:=TxtQuery + 'A26='+ dbRArtiTien.Fields[26].AsString + ',';
            TxtQuery:=TxtQuery + 'A27='+ dbRArtiTien.Fields[27].AsString + ',';
            TxtQuery:=TxtQuery + 'A28='+ dbRArtiTien.Fields[28].AsString + ',';
            TxtQuery:=TxtQuery + 'A29='+ dbRArtiTien.Fields[29].AsString + ',';
            TxtQuery:=TxtQuery + 'A30='+ dbRArtiTien.Fields[30].AsString + ',';
            TxtQuery:=TxtQuery + 'A31='+ dbRArtiTien.Fields[31].AsString + ',';
            TxtQuery:=TxtQuery + 'A32='+ dbRArtiTien.Fields[32].AsString + ',';
            TxtQuery:=TxtQuery + 'A33='+ dbRArtiTien.Fields[33].AsString + ',';
            TxtQuery:=TxtQuery + 'A34="'+ dbRArtiTien.Fields[34].AsString + '"';
            TxtQuery:=TxtQuery + ' WHERE A0="' + dbRArtiTien.Fields[0].AsString + '"';
            //WriteLn('TxtQuery de update en mi tienda '+Txtquery);
            dbArtiTien.Active:=False;
            dbArtiTien.Sql.Text:=TxtQuery;
            dbArtiTien.ExecSQL;   //Cada vez que pasa por aquí actualiza un artículo
            Conta1:=Conta1+1; LabelPModif.Caption:=FormatFloat('0',Conta1); LabelPModif.Refresh;
            CopiaTrabajoAct('MODIF');   //en el registro de cambios lo guarda como artículo modificado
            end;
        end;
     except
      ShowMessage('NO SE HA PODIDO ACTUALIZAR EL ARTICULO ' + dbRArtiTien.Fields[1].AsString);
     end;
      dbRArtiTien.Next;
    end;
     //TODO : Pendiente de la creación del módulo de tallas
{
      if Modulo1='S' then
       begin
         dbRMocota.Active:=False;
         dbRMocota.Sql.Text:='SELECT * FROM mocota0000 ORDER BY AU1';
         dbRMocota.Active := True;
         if dbRMocota.RecordCount=0 then
          begin
            ShowMessage('EL FICHERO DE TALLAS Y COLORES DEL ALMACEN ESTA VACIO');
            Exit;
          end;
         LabelPModif.Caption:='0'; LabelPRegNuev.Caption:='0'; Conta1:=0; Conta2:=0;
         dbRMocota.First;
         while not dbRMocota.Eof do
          begin
            try
              dbMocota.Active:=False;
              dbMocota.Sql.Text:='SELECT * FROM mocota'+ Tienda +' WHERE AU0="'+dbRMocota.Fields[0].AsString+'"';
              dbMocota.Active := True;
              if dbMocota.RecordCount=0 then
                begin
                 TxtQuery:='INSERT INTO mocota'+Tienda+' (AU0,AU1,AU2,AU3,AU4,AU5,AU6,AU7,AU8,AU9) VALUES (';
                 TxtQuery:=TxtQuery + '"' + dbRMocota.Fields[0].AsString + '",';
                 TxtQuery:=TxtQuery + '"' + dbRMocota.Fields[1].AsString + '",';
                 TxtQuery:=TxtQuery + '"' + dbRMocota.Fields[2].AsString + '",';
                 TxtQuery:=TxtQuery + '"' + dbRMocota.Fields[3].AsString + '",';
                 TxtQuery:=TxtQuery + '0,';
                 TxtQuery:=TxtQuery + dbRMocota.Fields[5].AsString +',';
                 TxtQuery:=TxtQuery + dbRMocota.Fields[6].AsString +',';
                 TxtQuery:=TxtQuery + dbRMocota.Fields[7].AsString +',';
                 TxtQuery:=TxtQuery + '"' + dbRMocota.Fields[8].AsString + '",';
                 TxtQuery:=TxtQuery + '"' + dbRMocota.Fields[9].AsString + '")';
                 dbMocota.Active:=False;
                 dbMocota.Sql.Text:=TxtQuery;
                 dbMocota.ExecSQL;
                 Conta2:=Conta2+1; LabelPRegNuev.Caption:=FormatFloat('0',Conta2); LabelPRegNuev.Refresh;
                end
              else
                begin
                 TxtQuery:='UPDATE mocota'+Tienda+' SET ';
                 TxtQuery:=TxtQuery + 'AU2="'+dbRMocota.Fields[2].AsString + '",';
                 TxtQuery:=TxtQuery + 'AU3="'+dbRMocota.Fields[3].AsString + '",';
                 TxtQuery:=TxtQuery + 'AU5='+dbRMocota.Fields[5].AsString +',';
                 TxtQuery:=TxtQuery + 'AU6='+dbRMocota.Fields[6].AsString +',';
                 TxtQuery:=TxtQuery + 'AU7='+dbRMocota.Fields[7].AsString +',';
                 TxtQuery:=TxtQuery + 'AU8="' + dbRMocota.Fields[8].AsString + '",';
                 TxtQuery:=TxtQuery + 'AU9="' + dbRMocota.Fields[9].AsString + '"';
                 TxtQuery:=TxtQuery + ' WHERE AU0="' + dbRMocota.Fields[0].AsString + '"';
                 dbMocota.Active:=False;
                 dbMocota.Sql.Text:=TxtQuery;
                 dbMocota.ExecSQL;
                 Conta1:=Conta1+1; LabelPModif.Caption:=FormatFloat('0',Conta1); LabelPModif.Refresh;
                end;
            except
            end;
            dbRMocota.Next;
          end;
       end;
    }

    //Screen.Cursor := crDefault;
    ShowMessage('ACTUALIZACION REALIZADA.');
    BitBtnInforme.Enabled:=True;
    BitBtnActualiza.Enabled:=False;

 end;

//==================== INFORME ===================
procedure TFActualizaArti.BitBtnInformeClick(Sender: TObject);
var
  TxtQuery:String;
begin
  AntColun:='0';Ordenado:=False; Orden:='DESC';
  TituloGrid:='INFORME DE OPERACIONES DE ACTUALIZACIÓN';
  //FMensaje.Show;
  //FMensaje.Refresh;
  TxtQuery:='select * from trabajoact';
  dbTraAct.Active:=False;
  dbTraAct.Sql.Text:=TxtQuery;
  dbTraAct.Active:=True;
  DBGrid1.Visible:=True;
  DBGrid1.BringToFront;
  //FMensaje.Close;
  BitBtnImprimir.Enabled:=True;
  BitBtnInforme.Enabled:=False;
  BitBtnActualiza.Enabled:=True;BitBtnActualiza.Caption:='Nueva';

  //LabelTituloDBGrid.Caption:=TituloGrid;
  //WriteLn('TxtQuery del informe '+Txtquery);
end;

//==================== IMPRIMIR ===================
procedure TFActualizaArti.BitBtnImprimirClick(Sender: TObject);
begin
     frDBDataSet1.DataSet:=dbTraAct;
     frReport1.LoadFromFile(RutaReports+'ComuniActuArti.lrf');
     frReport1.ShowReport;
end;
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFActualizaArti.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
  if ParName ='EMPRESA' then ParValue := Empresa;
  if ParName='DIRECCION' then ParValue := Direccion;
  if ParName='LOCALIDAD' then ParValue := Localidad;
  if ParName='PROVINCIA' then ParValue := Provincia;
  if ParName='NIF' then ParValue := Nif;
  if ParName='TELEFONO' then ParValue := Telefono;
  if ParName='FAX' then ParValue := Fax;
  if ParName='EMAIL' then ParValue := EMail;
  if ParName='CP' then ParValue := CP;
  if ParName='TITULO' then ParValue := TituloGrid;
end;
//======================= LOGOTIPO DEL FORMULARIO ========================
procedure TFActualizaArti.frReport1EnterRect(Memo: TStringList; View: TfrView);
var
  vImage: TImage;
begin
  frReport1.Title:=TituloGrid;
  if assigned( View ) and
     (View.Name = 'Picture1') and
     (View is TfrPictureView)
  then
    try
      vImage := TImage.Create( nil );
      try
         TfrPictureView(View).Picture.Clear;
         TfrPictureView(View).Picture.LoadFromFile(LogoEmpresa);
      finally
        FreeAndNil(vImage);
      end;
    except
      TfrPictureView(View).Picture.Clear;
    end;
end;


//======================= OCULTA TODOS LOS DBGird y su Titulo
procedure TFActualizaArti.OcultarBDGrid();
  begin
    DBGrid1.Visible:=False;
    //DBGrid2.Visible:=False;

    //LabelTituloDBGrid.Caption:='';
    DimensionarColocarBDGrid();
  end;
//======================= DIMENSIONA LOS DBGrid
// Los DBGrid estan "minimizados" (50x50) para poder trabajar en el resto del
// formulario, con esta funcion los adapto al PanelModif donde se encuentran
procedure TFActualizaArti.DimensionarColocarBDGrid();
  begin
    DBGrid1.Height:=420;
    DBGrid1.Width:=740;
    DBGrid1.Left:=110;
    DBGrid1.Top:=160;
    //DBGrid1.Align:=alClient;
    //DBGrid2.Align:=alClient;

  end;

//-------- Al pulsar en el titulo de la columna ordenar por ella
procedure TFActualizaArti.DBGrid1TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid1,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;

// ------- Selección de la tienda desde la que se desea actualizar
procedure TFActualizaArti.EditCambiableCodigo1Enter(Sender: TObject);
begin
   StaticTextCambiableNombre1.Caption:='';
end;
procedure TFActualizaArti.ComboCambiableNombre1Click(Sender: TObject);
begin
  EscogeNombreComboCambiable( 'T1', ComboCambiableNombre1, dbCambiable, EditCambiableCodigo1, StaticTextCambiableNombre1)
end;
procedure TFActualizaArti.ComboCambiableNombre1KeyPress(Sender: TObject;
  var Key: char);
begin
  if key=#13 then ComboCambiableNombre1Click(ComboCambiableNombre1);
end;
procedure TFActualizaArti.EditCambiableCodigo1Exit(Sender: TObject);
var
 TxtQuery: String;
begin
  TxtQuery:='SELECT T1 FROM tiendas WHERE T0="'+EditCambiableCodigo1.Text+'"';
  if EditCambiableCodigo1.Text<>'' then
    begin
     RellenaPanelCambiableN(TxtQuery,dbCambiable, StaticTextCambiableNombre1);
     if dbCambiable.RecordCount=0 then
       begin
         Showmessage('NO HAY '+LabelCambiable1.Caption+' CON ESE CODIGO');
         EditCambiableCodigo1.Text:='';
         exit;
       end;
    end;
end;
procedure TFActualizaArti.BitBtnCambiable1Click(Sender: TObject);
var
 TxtQuery: String;
begin
 TxtQuery:='SELECT T0, T1 FROM tiendas ORDER BY T1';
 CargaValoresEnComboCambiable(TxtQuery, ComboCambiableNombre1, dbCambiable, LabelCambiable1);
end;

{
  procedure TFActualizaArti.DBGrid2TitleClick(Column: TColumn);
  begin
    Colorea(Column,DBGrid2,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  end;
}

// dbTraAct es un registro temporal donde guardamos todas las operaciones realizadas
// durante la actualización se utiliza para mostrar los datos en el grid y el Report
procedure TFActualizaArti.CopiaTrabajoAct(Valor:String);
var
  TxtQuery:String;
begin
   TxtQuery:='INSERT INTO trabajoact (TRA0,TRA1,TRA2,TRA3) VALUES (';
   TxtQuery:=TxtQuery +'"' + Valor + '",';
   TxtQuery:=TxtQuery + '"' + dbRArtiTien.Fields[0].AsString + '",';
   TxtQuery:=TxtQuery + '"' + dbRArtiTien.Fields[1].AsString + '",';
   TxtQuery:=TxtQuery + dbRArtiTien.Fields[2].AsString + ')';
   //WriteLn('TxtQuery dentro de CopiaTrabajoAct  '+Txtquery);
   dbTraAct.Active:=False;
   dbTraAct.Sql.Text:=TxtQuery;
   dbTraAct.ExecSql;
end;

Initialization
  {$I actualizaarti.lrs}

End.

