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

unit envioarti;

{$mode objfpc}{$H+}

interface

uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, {Process,} Buttons, ZConnection, ZDataset,
  StdCtrls, db, LR_Class, EditBtn;

Type

  { TFEnvioArti }

  TFEnvioArti = class(TForm)
    BitBtnActualiza: TBitBtn;
    BitBtnCerrar: TBitBtn;
    Datasource1: TDatasource;
    dbAux: TZQuery;
    dbConectR: TZConnection;
    dbArti: TZQuery;
    dbQuery: TZQuery;
    dbRArti: TZQuery;
    Label1: TLabel;
    LabelModif: TLabel;
    LabelPModif: TLabel;
    LabelPRegNuev: TLabel;
    LabelRegNuev: TLabel;
    PanelModif: TPanel;
    PanelRegNuev: TPanel;


    procedure BitBtnActualizaClick(Sender: TObject);
    procedure BitBtnCerrarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

procedure ShowFormenvioArti;
var
  FEnvioArti: TFEnvioArti;
  AntColun, Titulocolumn, Orden, TituloGrid: String;
  Ordenado: Boolean;



implementation

uses
  Global, Funciones;

//=============== Crea el formulario ================
procedure ShowFormenvioArti;
begin
  with TFEnvioArti.Create(Application) do
    begin
       ShowModal;
    end;
end;

//==================== CERRAR ======================
procedure TFEnvioArti.BitBtnCerrarClick(Sender: TObject);
begin
  dbQuery.Active:=False;
  dbConectR.Connected:=False;
  Close();
end;

procedure TFEnvioArti.FormCreate(Sender: TObject);
begin

end;


//==================== ENVIO ARTICULOS A TIENDA VIRTUAL ===================
{ TFEnvioArti }

procedure TFEnvioArti.BitBtnActualizaClick(Sender: TObject);
 var
   Conta, CodPed, Conta2, Cambia, Cambia2: Integer;
   TiendaR, NombreCli, maxCod2, ContaArti, fech, NombreTiendaR: String; //TiendaR es el código de la tienda Remota con 4 dígitos
   TxtQuery: String;

   cad: PChar;

   {UnProceso: TProcess;
begin
   // Ahora creamos UnProceso.
   UnProceso := TProcess.Create(nil);

   // Asignamos a UnProceso la orden que debe ejecutar.
   // Vamos a lanzar el compilador de FreePascal
   UnProceso.CommandLine := '/home/juanma/Escritorio/lftpclient';

   // Definimos una opción de comportamiento de 'TProccess'
   // La opción poWaitOnExit hará que nuestro programa
   // se detenga hasta que termine el programa lanzado
   UnProceso.Options := UnProceso.Options + [poWaitOnExit];

   // Lanzamos la ejecución de 'ppc386 -h'.
   UnProceso.Execute;

   // Nuestro programa se detiene hasta que 'ppc386' finaliza.
   UnProceso.Free;
   }

begin
   //Comunicación con la tienda Remota    (dbConectR)
   // Los parametros de la conexión se extraen de la tabla Tiendas

   TiendaR:='tienda_vmart';
   try
    dbConectR.Connected:=False;
    dbConectR.HostName:='localhost';
    dbConectR.Database:=TiendaR;
    dbConectR.User:=TiendaR;
    dbConectR.Password:='4330';
    dbConectR.Port:=3306;
    dbConectR.Protocol:='mysql-5';
    try
    dbConectR.Connected:=True;
    except
    ShowMessage('NO SE PUDO REALIZAR LA CONEXIÓN');
    Exit;
    end;

   dbRArti.Active:=False;   //dbRArti depende de dbConectR
   TxtQuery:= 'SELECT * FROM jos_vm_product ORDER BY product_id';
   dbRArti.Sql.Text:= TxtQuery;
   dbRArti.Active := True; //Contiene todos los datos de los artículos de la tienda Remota

   except
   ShowMessage('NO SE HA PODIDO ESTABLECER LA COMUNICACION');
   exit;
   end;

   dbArti.Active:=False;
   TxtQuery:= 'SELECT * FROM artitien0000 ORDER BY A0';
   dbArti.Sql.Text:= TxtQuery;
   dbArti.Active := True;

   if Application.MessageBox('CONFIRME LA ACTUALIZACION DE ARTICULOS','FacturLinEx', boxstyle) = IDNO Then Exit;
   dbArti.First;
   Conta:=0;
   Conta2:=0;

   while not dbArti.Eof do
    begin
     try
      begin

       dbAux.Active:= False;
       dbAux.SQL.Text:= 'select product_id from jos_vm_product where product_id ="'+dbArti.Fields[0].AsString+'"';
       dbAux.Active:= True;

       //Comprobación de que el artículo no este ya en Virtue Mart
       if dbAux.RecordCount=0 then
        begin
         if dbArti.Fields[38].AsString='Y' then
         begin
         //Inserta el articulo
         TxtQuery:='insert into jos_vm_product (product_id,vendor_id,product_parent_id,'+
         'product_sku,product_s_desc,product_desc,product_thumb_image,product_full_image,'+
         'product_publish,product_in_stock,product_availability,'+
         'product_name,product_sales,custom_attribute,product_tax_id) VALUES (';
         TxtQuery:=TxtQuery + dbArti.Fields[0].AsString + ',';
         TxtQuery:=TxtQuery + '1,';
         TxtQuery:=TxtQuery + '0,';
         TxtQuery:=TxtQuery + '"FL",';
         TxtQuery:=TxtQuery + '"' + dbArti.Fields[1].AsString + '",';  //Descripcion corta
         TxtQuery:=TxtQuery + '"' + dbArti.Fields[17].AsString + '",';  //Descripcion larga
         TxtQuery:=TxtQuery + '"' + ExtractFileName(dbArti.Fields[16].AsString) +'",';
         TxtQuery:=TxtQuery + '"' + ExtractFileName(dbArti.Fields[16].AsString) +'",';
         TxtQuery:=TxtQuery + '"' + dbArti.Fields[38].AsString + '",';   //publicar
         TxtQuery:=TxtQuery + '5,';                                    //stock
         TxtQuery:=TxtQuery + '" ",';
         TxtQuery:=TxtQuery + '"' + dbArti.Fields[1].AsString + '",';   //Descripción
         TxtQuery:=TxtQuery + '0,';
         TxtQuery:=TxtQuery + '" ",';
         TxtQuery:=TxtQuery + '0)';

         dbAux.Active:=False;
         dbAux.Sql.Text:=TxtQuery;
         dbAux.ExecSQL;

         //Inserta el precio
         dbAux.SQL.Text:= 'select max(product_price_id) from jos_vm_product_price';
         dbAux.ExecSQL;
         dbAux.Active:= True;
         maxCod2:= dbAux.Fields[0].AsString;
         maxCod2:= IntToStr(StrToInt(maxCod2)+1);

         TxtQuery:='insert into jos_vm_product_price (product_price_id,product_id,'+
         'product_price,product_currency,shopper_group_id,price_quantity_start,price_quantity_end) VALUES (';
         TxtQuery:=TxtQuery + maxCod2 +',';
         TxtQuery:=TxtQuery + dbArti.Fields[0].AsString + ',';
         TxtQuery:=TxtQuery + dbArti.Fields[2].AsString + ',';
         TxtQuery:=TxtQuery + '"EUR",';
         TxtQuery:=TxtQuery + '5,';
         TxtQuery:=TxtQuery + '0,';
         TxtQuery:=TxtQuery + '0)';

         dbAux.Active:=False;
         dbAux.Sql.Text:=TxtQuery;
         dbAux.ExecSQL;
         Conta:=Conta+1;


         end;
       end
       else
        begin
         dbAux.Active:=False;
         dbAux.SQL.Text:= 'select * from jos_vm_product where product_id ="'+dbArti.Fields[0].AsString+'"';
         dbAux.ExecSQL;
         dbAux.Active:=True;
         Cambia:=0;
         if dbAux.FieldByName('product_s_desc').AsString<>dbArti.Fields[1].AsString then Cambia:=1;
         if dbAux.FieldByName('product_desc').AsString<>dbArti.Fields[17].AsString then Cambia:=1;
         if dbAux.FieldByName('product_publish').AsString<>dbArti.Fields[38].AsString then Cambia:=1;
         if dbAux.FieldByName('product_name').AsString<>dbArti.Fields[1].AsString then Cambia:=1;

         if Cambia=1 then
           begin
            TxtQuery:='UPDATE jos_vm_product SET product_s_desc="'+ dbArti.Fields[1].AsString + '",';
            TxtQuery:=TxtQuery + 'product_desc="'+ dbArti.Fields[17].AsString + '",';
            TxtQuery:=TxtQuery + 'product_publish="'+ dbArti.Fields[38].AsString + '",';
            TxtQuery:=TxtQuery + 'product_name="'+ dbArti.Fields[1].AsString + '"';
            TxtQuery:=TxtQuery + ' WHERE product_id="' + dbArti.Fields[0].AsString + '"';

            dbAux.Active:=False;
            dbAux.Sql.Text:=TxtQuery;
            dbAux.ExecSQL;
           end;
         dbAux.Active:=False;
         dbAux.SQL.Text:= 'select * from jos_vm_product_price where product_id ="'+dbArti.Fields[0].AsString+'"';
         dbAux.ExecSQL;
         dbAux.Active:=True;
         Cambia2:=0;
         if dbAux.FieldByName('product_price').AsString<>dbArti.Fields[2].AsString then Cambia2:=1;
         if Cambia2=1 then
           begin
             TxtQuery:='UPDATE jos_vm_product_price SET product_price ='+dbArti.Fields[2].AsString+'';
             TxtQuery:=TxtQuery + ' WHERE product_id=' + dbArti.Fields[0].AsString + '';
             dbAux.Active:=False;
             dbAux.Sql.Text:=TxtQuery;
             dbAux.ExecSQL;
           end;
         if (Cambia=1) or (Cambia2=1) then
          begin
          Conta2:=Conta2+1;
          end;
        end;
       end;
     except
      ShowMessage('NO SE HA PODIDO ACTUALIZAR');
     end;
     dbArti.Next;

     end;
     LabelPRegNuev.Caption:=FormatFloat('0',Conta); LabelPRegNuev.Repaint;
     LabelPModif.Caption:=FormatFloat('0',Conta2); LabelPModif.Repaint;
     ShowMessage('ACTUALIZACION REALIZADA.');
     end;




initialization
  {$I envioarti.lrs}

end.

