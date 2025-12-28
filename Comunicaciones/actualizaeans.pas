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

Unit actualizaeans;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset, DBGrids,
  StdCtrls, db, LR_Class, ExtDlgs, EditBtn, LR_DBSet;

Type

  { TFActualizaEans }

  TFActualizaEans = Class(Tform)
    BitBtnCambiable1: TBitBtn;
    ComboCambiableNombre1: TComboBox;
    dbCambiable: TZQuery;
    dbRArtiTien: TZQuery;
    dbConectR: TZConnection;
    dbTiendas: TZQuery;
    DBGrid1: TDBGrid;
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

    Procedure Formcreate(Sender: Tobject);
    Procedure Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);

    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);

    procedure OcultarBDGrid();
    procedure DimensionarColocarBDGrid();

    procedure CopiaTrabajoAct(Valor:String);

  Private
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormActualizaEans;
  
Var
  FActualizaEans: TFActualizaEans;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;

Implementation

uses
  Global, Funciones;

//=============== Crea el formulario ================
procedure ShowFormActualizaEans;
begin
  with TFActualizaEans.Create(Application) do
    begin
       ShowModal;
    end;
end;

Procedure TFActualizaEans.Formcreate(Sender: Tobject);
var
   TxtQuery: String;
begin
   // Creo la Tabla temporal trabajoact
   dbTraAct.Active:=False;
   dbTraAct.SQL.Text:='DROP TABLE IF EXISTS trabajoact';
   dbTraAct.ExecSQL;
   TxtQuery :='CREATE TEMPORARY TABLE trabajoact ('+
       'TRA0 char(10) NOT NULL,'+
       'TRA1 char(13) NOT NULL,'+
       'TRA2 char(13) NOT NULL,'+
       'TRA3 char(50) default NULL,'+
       'TRA4 double(10,2) default NULL,'+
       'TRA5 double(10,2) default NULL,'+
       'TRA6 double(10,5) default NULL,'+
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
procedure TFActualizaEans.BitBtnCerrarClick(Sender: TObject);
begin
  // Al terminar Borramos la tabla temporal
  dbTraAct.Active:=False;
  dbTraAct.SQL.Text:='DROP TABLE IF EXISTS trabajoact';
  dbTraAct.ExecSQL;

  dbQuery.Active:=False;
  dbConectR.Connected:=False;
  Close();
end;

Procedure TFActualizaEans.Formclose(Sender: Tobject; Var Closeaction: Tcloseaction);
Begin
  Closeaction:=CaFree;
End;

//==================== ACTUALIZA ===================
procedure TFActualizaEans.BitBtnActualizaClick(Sender: TObject);
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
     WriteLn('TiendaR es'+ TiendaR+'y Tienda es'+Tienda);
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
   dbRArtiTien.Sql.Text:='SELECT * FROM eans ORDER BY EAN0';
   //WriteLn('TxtQuery de seleccion Remota '+ 'SELECT * FROM eans ORDER BY EAN0');
   dbRArtiTien.Active := True; //Contiene todos los datos de los eans de la tienda Remota
   //Screen.Cursor := crDefault;
   if dbRArtiTien.RecordCount=0 then
      begin
         ShowMessage('EL FICHERO DE EANS DE LA '+NombreTiendaR+' ESTA VACIO');
         Exit;
      end;
  except
   ShowMessage('NO SE HA PODIDO ESTABLECER LA COMUNICACION');
   exit;
  end;

  if Application.MessageBox('CONFIRME LA ACTUALIZACION DE EANS','FacturLinEx', boxstyle) = IDNO Then Exit;
  //Screen.Cursor := crHourGlass;
  dbRArtitien.First;
  while not dbRArtitien.Eof do
    begin
     try
      // Selecciona de MI tienda los eans que vienen de la tienda Remota
      dbArtiTien.Active:=False;
      dbArtiTien.Sql.Text:='SELECT * FROM eans WHERE EAN0="'+dbRArtiTien.Fields[0].AsString+'" AND EAN1="'+dbRArtiTien.Fields[1].AsString+'"';
      WriteLn('TxtQuery de seleccion de mi tienda '+ 'SELECT * FROM eans WHERE EAN0="'+dbRArtiTien.Fields[0].AsString+'" AND EAN1="'+dbRArtiTien.Fields[1].AsString+'"');
      dbArtiTien.Active := True;
      if dbArtiTien.RecordCount=0 then
        //Si el articulo no esta en mi tienda lo inserto
        begin
        //el número de campos con respecto a al 1.6 ha variado
         TxtQuery:='INSERT INTO eans (EAN0,EAN1,EAN2,EAN3,EAN4,EAN5) VALUES (';
                TxtQuery:=TxtQuery + '"' + dbRArtiTien.Fields[0].AsString + '",';
                TxtQuery:=TxtQuery + '"' + dbRArtiTien.Fields[1].AsString + '",';
                TxtQuery:=TxtQuery + '"' + dbRArtiTien.Fields[2].AsString + '",';
                TxtQuery:=TxtQuery + dbRArtiTien.Fields[3].AsString + ',';
                TxtQuery:=TxtQuery + dbRArtiTien.Fields[4].AsString + ',';
                TxtQuery:=TxtQuery + dbRArtiTien.Fields[5].AsString + ')';
         //WriteLn('TxtQuery de insercion en mi tienda '+Txtquery);
         dbArtiTien.Active:=False;
         dbArtiTien.Sql.Text:=TxtQuery;
         dbArtiTien.ExecSQL; //Cada vez que pasa por aquí, inserta un ean nuevo en nuestra BD
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
         if dbArtiTien.Fields[4].AsString<>dbRArtiTien.Fields[4].AsString then Cambia:=1;
         if dbArtiTien.Fields[5].AsString<>dbRArtiTien.Fields[5].AsString then Cambia:=1;
         if Cambia=1 then  //primero comprueba si hay diferencias entre el eansActual y el eansRemoto
           begin           // y si la hay, lo actualiza
            TxtQuery:='UPDATE eans SET EAN1="' + dbRArtiTien.Fields[1].AsString + '",';
                  TxtQuery:=TxtQuery + 'EAN2="' + dbRArtiTien.Fields[2].AsString + '",';
                  TxtQuery:=TxtQuery + 'EAN3=' + dbRArtiTien.Fields[3].AsString + ',';
                  TxtQuery:=TxtQuery + 'EAN4=' + dbRArtiTien.Fields[4].AsString + ',';
                  TxtQuery:=TxtQuery + 'EAN5=' + dbRArtiTien.Fields[5].AsString;
                  TxtQuery:=TxtQuery + ' WHERE EAN0="'+dbRArtiTien.Fields[0].AsString+'" AND EAN1="'+dbRArtiTien.Fields[1].AsString+'"';
                  //WriteLn('TxtQuery de update en mi tienda '+Txtquery);
            dbArtiTien.Active:=False;
            dbArtiTien.Sql.Text:=TxtQuery;
            dbArtiTien.ExecSQL;   //Cada vez que pasa por aquí actualiza un eans
            Conta1:=Conta1+1; LabelPModif.Caption:=FormatFloat('0',Conta1); LabelPModif.Refresh;
            CopiaTrabajoAct('MODIF');   //en el registro de cambios lo guarda como eans modificado
            end;
        end;
     except
      ShowMessage('NO SE HA PODIDO ACTUALIZAR EL EAN ' + dbRArtiTien.Fields[1].AsString);
     end;
      dbRArtiTien.Next;
    end;
    //Screen.Cursor := crDefault;
    ShowMessage('ACTUALIZACION REALIZADA.');
    BitBtnInforme.Enabled:=True;
    BitBtnActualiza.Enabled:=False;

 end;

//==================== INFORME ===================
procedure TFActualizaEans.BitBtnInformeClick(Sender: TObject);
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
  //WriteLn('TxtQuery del informe '+Txtquery);
end;

//==================== IMPRIMIR ===================
procedure TFActualizaEans.BitBtnImprimirClick(Sender: TObject);
begin
     frDBDataSet1.DataSet:=dbTraAct;
     frReport1.LoadFromFile(RutaReports+'ComuniActuEans.lrf');
     frReport1.ShowReport;

end;
//================= PASAR PARAMETROS AL REPORT ===============
procedure TFActualizaEans.frReport1GetValue(const ParName: String;
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
procedure TFActualizaEans.frReport1EnterRect(Memo: TStringList; View: TfrView);
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
procedure TFActualizaEans.OcultarBDGrid();
  begin
    DBGrid1.Visible:=False;
    DimensionarColocarBDGrid();
  end;
//======================= DIMENSIONA LOS DBGrid
// Los DBGrid estan "minimizados" (50x50) para poder trabajar en el resto del
// formulario, con esta funcion los adapto al PanelModif donde se encuentran
procedure TFActualizaEans.DimensionarColocarBDGrid();
  begin
    DBGrid1.Height:=420;
    DBGrid1.Width:=880;
    DBGrid1.Left:=80;
    DBGrid1.Top:=160;

  end;

//-------- Al pulsar en el titulo de la columna ordenar por ella
procedure TFActualizaEans.DBGrid1TitleClick(Column: TColumn);
begin
  Colorea(Column,DBGrid1,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
end;

// ------- Selección de la tienda desde la que se desea actualizar
procedure TFActualizaEans.EditCambiableCodigo1Enter(Sender: TObject);
begin
   StaticTextCambiableNombre1.Caption:='';
end;
procedure TFActualizaEans.ComboCambiableNombre1Click(Sender: TObject);
begin
  EscogeNombreComboCambiable( 'T1', ComboCambiableNombre1, dbCambiable, EditCambiableCodigo1, StaticTextCambiableNombre1)
end;
procedure TFActualizaEans.ComboCambiableNombre1KeyPress(Sender: TObject;
  var Key: char);
begin
  if key=#13 then ComboCambiableNombre1Click(ComboCambiableNombre1);
end;
procedure TFActualizaEans.EditCambiableCodigo1Exit(Sender: TObject);
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
procedure TFActualizaEans.BitBtnCambiable1Click(Sender: TObject);
var
 TxtQuery: String;
begin
 TxtQuery:='SELECT T0, T1 FROM tiendas ORDER BY T1';
 CargaValoresEnComboCambiable(TxtQuery, ComboCambiableNombre1, dbCambiable, LabelCambiable1);
end;

// dbTraAct es un registro temporal donde guardamos todas las operaciones realizadas
// durante la actualización se utiliza para mostrar los datos en el grid y el Report
procedure TFActualizaEans.CopiaTrabajoAct(Valor:String);
var
  TxtQuery:String;
begin
   TxtQuery:='INSERT INTO trabajoact (TRA0,TRA1,TRA2,TRA3,TRA4,TRA5,TRA6) VALUES (';
   TxtQuery:=TxtQuery +'"' + Valor + '",';
   TxtQuery:=TxtQuery + '"' + dbRArtiTien.Fields[0].AsString + '",';
   TxtQuery:=TxtQuery + '"' + dbRArtiTien.Fields[1].AsString + '",';
   TxtQuery:=TxtQuery + '"' + dbRArtiTien.Fields[2].AsString + '",';
   TxtQuery:=TxtQuery + '"' + dbRArtiTien.Fields[3].AsString + '",';
   TxtQuery:=TxtQuery + '"' + dbRArtiTien.Fields[4].AsString + '",';
   TxtQuery:=TxtQuery + dbRArtiTien.Fields[5].AsString + ')';
   //WriteLn('TxtQuery dentro de CopiaTrabajoAct  '+Txtquery);
   dbTraAct.Active:=False;
   dbTraAct.Sql.Text:=TxtQuery;
   dbTraAct.ExecSql;
end;

Initialization
  {$I actualizaeans.lrs}

End.

