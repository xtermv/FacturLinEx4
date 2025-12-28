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

Unit actualizapedi;

{$mode Objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset, DBGrids,
  StdCtrls, db, LR_Class, EditBtn;

Type

  { TFActualizaPedi }

  TFActualizaPedi = Class(Tform)
    BitBtnActualiza: TBitBtn;
    BitBtnCerrar: TBitBtn;
    Datasource1: TDatasource;
    dbSeries: TZQuery;
    dbCodPedi2: TZQuery;
    dbAux: TZQuery;

    dbQuery: TZQuery;
    dbPedicc: TZQuery;
    dbRPedi: TZQuery;
    dbConectR: TZConnection;
    dbCodPedi: TZQuery;
    dbTraAct: TZQuery;
    Label1: TLabel;
    LabelPRegNuev: TLabel;
    LabelRegNuev: TLabel;
    PanelRegNuev: TPanel;


    procedure NumeroPedido();
    procedure BitBtnActualizaClick(Sender: TObject);
    procedure BitBtnCerrarClick(Sender: TObject);
    //procedure dbConectAfterConnect(Sender: TObject);
    //procedure FormCreate(Sender: TObject);






    //procedure DBGrid2TitleClick(Column: TColumn);


    //procedure Colorea(Column: TColumn;Grid: TDBGrid;dbColor: TZQuery);
    //procedure RellenaListBoxAnos(TxtQuery: String);
    //procedure BlancoGrid(Grid: TDBGrid);


    //procedure EscogeNombreComboCambiable(TxtCampo: String; ComboCambiableNombre: TComboBox;  dbRArtiTien: TZQuery; EditCambiableNombre: TEdit; StaticTextCambiableNombre: TStaticText);
  Private
    { Private Declarations }
  Public
    { Public Declarations }
  End;

  procedure ShowFormactualizaPedi;

Var
  FActualizaPedi: TFActualizaPedi;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;
  NPEDIDO: Integer;

Implementation

uses
  Global, Funciones;

//=============== Crea el formulario ================
procedure ShowFormactualizaPedi;
begin
  with TFActualizaPedi.Create(Application) do
    begin
       ShowModal;
    end;
end;








//==================== CERRAR ======================
procedure TFActualizaPedi.BitBtnCerrarClick(Sender: TObject);
begin
  // Al terminar Borramos la tabla temporal
{  dbTraAct.Active:=False;
  dbTraAct.SQL.Text:='DROP TABLE IF EXISTS trabajoact';
  dbTraAct.ExecSQL;

  dbQuery.Active:=False;
  dbConect.Connected:=False;
  dbConectR.Connected:=False;
}
  dbCodPedi2.Active:=False;
  dbCodPedi.Active:=False;
  dbAux.Active:=False;
  dbPedicc.Active:=False;
  dbRPedi.Active:=False;
  dbTraAct.Active:=False;
  dbQuery.Active:=False;
  dbConectR.Connected:=False;
  Close();
end;

//================= N. DE PEDIDO ===========================
procedure TFActualizaPedi.NumeroPedido();
begin
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='UPDATE seriesfactu SET SF7=SF7+1 WHERE SF0="A"';
  dbSeries.ExecSql;
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF0="A"';
  dbSeries.Active:=True;
  if dbSeries.Recordcount=0 then exit;
//  SPEDIDO:=dbSeries.Fields[0].AsString;
  NPEDIDO:=dbSeries.Fields[7].Value;
  dbSeries.Active:=False;
end;


//==================== ACTUALIZA ===================
procedure TFActualizaPedi.BitBtnActualizaClick(Sender: TObject);
 var
   Conta, CodPed, Conta2, Cambia: Integer;
   TiendaR, NombreCli,maxCod,ContaArti, fech, NombreTiendaR: String; //TiendaR es el código de la tienda Remota con 4 dígitos
   TxtQuery: String;
begin
   //Comunicación con la tienda Remota    (dbConectR)
   // Los parametros de la conexión se extraen de la tabla Tiendas
   TiendaR:='tienda_vmart';
   try
   //Screen.Cursor := crHourGlass;
   dbConectR.Connected:=False;
   dbConectR.HostName:='localhost';
   dbConectR.Database:=TiendaR;
   dbConectR.User:=TiendaR;
   dbConectR.Password:='broza';
   dbConectR.Port:=3306;
   dbConectR.Protocol:='mysql-5';
   //WriteLn('dbConectR.HostName'+dbConectR.HostName);
   try
    dbConectR.Connected:=True;
  except
    ShowMessage('NO SE PUDO REALIZAR LA CONEXIÓN');
    Exit;
  end;

   dbRPedi.Active:=False;   //dbRPedi depende de dbConectR
   TxtQuery:= 'SELECT * FROM jos_vm_orders ORDER BY order_id';
   dbRPedi.Sql.Text:= TxtQuery;
   dbRPedi.Active := True; //Contiene todos los datos de los pedidos de la tienda Remota


   //Screen.Cursor := crDefault;
   if dbRPedi.RecordCount=0 then
      begin
         ShowMessage('EL FICHERO DE PEDIDOS DE LA TIENDA VIRTUAL ESTA VACIO');
         Exit;
      end;
  except
   ShowMessage('NO SE HA PODIDO ESTABLECER LA COMUNICACION');
   exit;
  end;

   Conta:=0;
  if Application.MessageBox('CONFIRME LA ACTUALIZACION DE PEDIDOS','FacturLinEx', boxstyle) = IDNO Then Exit;
  //Screen.Cursor := crHourGlass;
  dbRPedi.First;
  while not dbRPedi.Eof do
    begin
     try
      begin
       //Comprobacion de que el pedido no este ya en facturlinex
       CodPed:= dbRPedi.Fields[0].AsInteger;

       dbCodPedi.Active:=False;
       dbCodPedi.SQL.Text:= 'select PC32 from pedicc0000 where PC32='+dbRPedi.Fields[0].AsString;
       dbCodPedi.Active:=True;
       dbCodPedi2.Active:=False;
       dbCodPedi2.SQL.Text:= 'select HPC45 from hipedicc0000 where HPC45='+dbRPedi.Fields[0].AsString;
       dbCodPedi2.Active:=True;


       if (dbCodPedi.RecordCount=0) and (dbCodPedi2.RecordCount=0) then
        begin //Insercion del pedido en facturlinex
         {
         dbTraAct.Active:=False;
         dbTraAct.SQL.Text:='select max(PC4) from pedicc0000';
         dbTraAct.ExecSQL;
         dbTraAct.Active:=True;
         maxCod:= dbTraAct.Fields[0].AsString;
         maxCod:= IntToStr(StrToInt(maxCod)+1);
         }
         NumeroPedido();


         TxtQuery:='select UPPER(name) from jos_users where id="'+dbRPedi.Fields[1].AsString+'"';
         dbAux.Active:= False;
         dbAux.SQL.Text:=TxtQuery;
         dbAux.ExecSQL;
         dbAux.Active:= True;
         NombreCli:= dbAux.Fields[0].AsString;

         TxtQuery:='select convert(from_unixtime(cdate),date) from jos_vm_orders where order_id="'+dbRPedi.Fields[0].AsString+'"';
         dbAux.Active:= False;
         dbAux.SQL.Text:=TxtQuery;
         dbAux.ExecSQL;
         dbAux.Active:= True;
         fech:= '"'+FormatDateTime('yyyy/mm/dd',dbAux.Fields[0].Value)+'"';

         TxtQuery:='INSERT INTO pedicc0000 (PC0,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,'+
         'PC9,PC10,PC11,PC13,PC14,PC15,PC17,PC18,PC19,PC21,PC23,PC25,'+
         'PC27,PC28,PC32) VALUES (';
         TxtQuery:=TxtQuery + '1,';
         TxtQuery:=TxtQuery + fech +',';
         TxtQuery:=TxtQuery + '1,';
         TxtQuery:=TxtQuery + '"A",';
         TxtQuery:=TxtQuery + IntToStr(NPEDIDO) +',';
         TxtQuery:=TxtQuery + '0,';
         TxtQuery:=TxtQuery + '0,';
         TxtQuery:=TxtQuery + '0.00,';
         TxtQuery:=TxtQuery + '0.00,';
         TxtQuery:=TxtQuery + '0.00,';
         TxtQuery:=TxtQuery + '"N",';
         TxtQuery:=TxtQuery + '"T",';
         TxtQuery:=TxtQuery + '"TIENDA VIRT",';
         TxtQuery:=TxtQuery + dbRPedi.Fields[1].AsString + ',';
         TxtQuery:=TxtQuery + '"' + NombreCli + '",';
         TxtQuery:=TxtQuery + dbRPedi.Fields[5].AsString + ',';
         TxtQuery:=TxtQuery + '0.00,';
         TxtQuery:=TxtQuery + dbRPedi.Fields[5].AsString + ',';
         TxtQuery:=TxtQuery + '0.00,';
         TxtQuery:=TxtQuery + '0.00,';
         TxtQuery:=TxtQuery + '0.00,';
         TxtQuery:=TxtQuery + '0.00,';
         TxtQuery:=TxtQuery + '"P",';
         TxtQuery:=TxtQuery + dbRPedi.Fields[0].AsString + ')';

         dbPedicc.Active:= False;
         dbPedicc.SQL.Text:= TxtQuery;
         dbPedicc.ExecSQL;
         Conta:= Conta+1;
         LabelPRegNuev.Caption:=FormatFloat('0',Conta); LabelPRegNuev.Repaint;

         //Detalles
         TxtQuery:='select * from jos_vm_order_item where order_id="'+dbRPedi.Fields[0].AsString+'" ORDER BY order_item_id';
         dbAux.Active:= False;
         dbAux.SQL.Text:=TxtQuery;
         dbAux.Active:= True;
         dbAux.First;
         Conta2:=1;
         ContaArti:=IntToStr(0);

         while not dbAux.Eof do
           begin
               TxtQuery:='INSERT INTO pedidd0000 (PD0,PD1,PD2,PD3,PD4,PD5,PD6,PD7,PD8,'+
               'PD9,PD10,PD11,PD12,PD13,PD14,PD15,PD16,PD17,PD18,PD19,PD20,PD21,PD22,'+
               'PD23,PD26,PD27,PD28,PD29,PD30) VALUES (';

               TxtQuery:=TxtQuery + '1,';
               TxtQuery:=TxtQuery + fech +',';
               TxtQuery:=TxtQuery + '1,';
               TxtQuery:=TxtQuery + '"A",';
               TxtQuery:=TxtQuery + IntToStr(NPEDIDO) +',';
               TxtQuery:=TxtQuery + IntToStr(Conta2) +',';
               TxtQuery:=TxtQuery + dbAux.Fields[4].AsString + ',';
               TxtQuery:=TxtQuery + '"'+ UpperCase(dbAux.Fields[6].AsString) +'",';
               TxtQuery:=TxtQuery + dbAux.Fields[7].AsString + ',';
               TxtQuery:=TxtQuery + '0,';
               TxtQuery:=TxtQuery + '0.000,';
               TxtQuery:=TxtQuery + '0.000,';
               TxtQuery:=TxtQuery + dbAux.Fields[8].AsString + ',';
               TxtQuery:=TxtQuery + '0.00,';
               TxtQuery:=TxtQuery + '18.00,';
               TxtQuery:=TxtQuery + '0.000,';
               TxtQuery:=TxtQuery + dbAux.Fields[9].AsString + ',';
               TxtQuery:=TxtQuery + '0.00,';
               TxtQuery:=TxtQuery + '0.00,';
               TxtQuery:=TxtQuery + '0,';
               TxtQuery:=TxtQuery + '0.00,';
               TxtQuery:=TxtQuery + '0.00,';
               TxtQuery:=TxtQuery + '0.00,';
               TxtQuery:=TxtQuery + '"S",';
               TxtQuery:=TxtQuery + '0.000,';
               TxtQuery:=TxtQuery + '0.00,';
               TxtQuery:=TxtQuery + '0.00,';
               TxtQuery:=TxtQuery + '0.00,';
               TxtQuery:=TxtQuery + '0.00)';

               dbCodPedi.Active:= False;
               dbCodPedi.SQL.Text:=TxtQuery;
               dbCodPedi.ExecSQL;
               Conta2:= Conta2+1;
               ContaArti:= IntToStr(dbAux.Fields[7].AsInteger + StrToInt(ContaArti));
               dbAux.Next;
           end;
           Conta2:=Conta2-1;
           dbCodPedi.SQL.Text:='update pedicc0000 set PC5='+IntToStr(Conta2)+', PC6='+ContaArti+' where PC4="'+IntToStr(NPEDIDO)+'"';
           dbCodPedi.ExecSQL;
        end

      end
     except
      ShowMessage('NO SE HA PODIDO ACTUALIZAR');
     end;
      dbRPedi.Next;
     end;

       //Screen.Cursor := crDefault;
    if Conta=0 then
       begin
          ShowMessage('NO HAY NUEVOS PEDIDOS');
       end
    else
       begin
          ShowMessage('ACTUALIZACION REALIZADA.');
       end
 end;













        {
  procedure TFActualizaPedi.DBGrid2TitleClick(Column: TColumn);
  begin
    Colorea(Column,DBGrid2,dbQuery, AntColun, Orden, TituloColumn, Ordenado);
  end;
}

// dbTraAct es un registro temporal donde guardamos todas las operaciones realizadas
// durante la actualización se utiliza para mostrar los datos en el grid y el Report


Initialization
  {$I actualizapedi.lrs}

End.
