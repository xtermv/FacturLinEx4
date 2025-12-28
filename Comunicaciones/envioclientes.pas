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

unit envioclientes;

{$mode objfpc}{$H+}

interface

uses
  Classes, Sysutils, Lresources, Forms, Controls, Graphics, Dialogs,
  LCLType, ExtCtrls, Process, Buttons, ZConnection, ZDataset,
  StdCtrls, db, LR_Class, EditBtn, md5;

type

  { TFEnvioClientes }

  TFEnvioClientes = class(TForm)
    BitBtnActualiza: TBitBtn;
    BitBtnCerrar: TBitBtn;
    Datasource1: TDatasource;
    dbAux1: TZQuery;
    dbCli: TZQuery;
    dbAux: TZQuery;
    dbConectR: TZConnection;
    dbRCli: TZQuery;
    Label1: TLabel;
    procedure BitBtnActualizaClick(Sender: TObject);
    procedure BitBtnCerrarClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 
procedure ShowFormenvioClientes;
var
  FEnvioClientes: TFEnvioClientes;

implementation
uses
  Global, Funciones;

//=============== Crea el formulario ================
procedure ShowFormenvioClientes;
begin
  with TFEnvioClientes.Create(Application) do
    begin
       ShowModal;
    end;
end;
//==================== CERRAR ======================
procedure TFEnvioClientes.BitBtnCerrarClick(Sender: TObject);
begin
  dbConectR.Connected:=False;
  Close();
end;

//==================== ENVIO CLIENTES A TIENDA VIRTUAL ===================
{ TFEnvioArti }

procedure TFEnvioClientes.BitBtnActualizaClick(Sender: TObject);
 var
   Conta, CodPed, Conta2, Cambia, Cambia2: Integer;
   TiendaR, NombreCli, maxCod2, ContaArti, fech, NombreTiendaR,
   Maxid, Auxid, Salt, Pass, Pass2: String;
   //TiendaR es el código de la tienda Remota con 4 dígitos
   TxtQuery: String;
   cad: PChar;
   UnProceso: TProcess;
 begin

   // Comunicación con la tienda Remota    (dbConectR)
   // Los parametros de la conexión se extraen de la tabla Tiendas
   TiendaR:='tienda_vmart';
   try
    dbConectR.Connected:=False;
    dbConectR.HostName:='localhost';
    dbConectR.Database:=TiendaR;
    dbConectR.User:=TiendaR;
    dbConectR.Password:='broza';
    dbConectR.Port:=3306;
    dbConectR.Protocol:='mysql-5';
    try
    dbConectR.Connected:=True;
    except
    ShowMessage('NO SE PUDO REALIZAR LA CONEXIÓN');
    Exit;
    end;

   dbRCli.Active:=False;   //dbRArti depende de dbConectR
   TxtQuery:= 'SELECT * FROM jos_users ORDER BY id';
   dbRCli.Sql.Text:= TxtQuery;
   dbRCli.Active := True; //Contiene todos los datos de los artículos de la tienda Remota

   except
   ShowMessage('NO SE HA PODIDO ESTABLECER LA COMUNICACION');
   exit;
   end;


   dbCli.Active:=False;
   TxtQuery:= 'SELECT * FROM clientes ORDER BY C0';
   dbCli.Sql.Text:= TxtQuery;
   dbCli.Active := True;

   if Application.MessageBox('CONFIRME LA ACTUALIZACION DE CLIENTES','FacturLinEx', boxstyle) = IDNO Then Exit;
   dbCli.First;
   Conta:=0;
   Conta2:=0;

   while not dbCli.Eof do
    begin
     try
      begin

       dbAux.Active:= False;
       dbAux.SQL.Text:= 'select id from jos_users where id ="'+dbCli.Fields[0].AsString+'"';
       dbAux.Active:= True;
       //Comprobación de que el cliente no este ya en Virtue Mart
       if (dbAux.RecordCount=0) and (dbCli.Fields[0].AsString<>'62') then
        begin
         Salt:='vIU8pYHJ8ogbV2k2vblQcQzLJmtco99T';
         Pass:=MD5Print(MD5String(dbCli.Fields[53].AsString+'vIU8pYHJ8ogbV2k2vblQcQzLJmtco99T'));
         //Inserta el cliente en jos_users
         TxtQuery:='insert into jos_users (id,name,username,email,password,usertype,'+
         'block,gid) VALUES (';
         TxtQuery:=TxtQuery + dbCli.Fields[0].AsString + ',';
         TxtQuery:=TxtQuery + '"' + dbCli.Fields[1].AsString + '",';   //Nombre
         TxtQuery:=TxtQuery + '"' + dbCli.Fields[52].AsString + '",';  //Nombre usuario
         TxtQuery:=TxtQuery + '"' + dbCli.Fields[40].AsString + '",';  //Email
         TxtQuery:=TxtQuery + '"'+Pass+':'+Salt+'",';  //Pass
         TxtQuery:=TxtQuery + '"Registered",';
         TxtQuery:=TxtQuery + dbCli.Fields[54].AsString + ',';
         TxtQuery:=TxtQuery + '18)';

         dbAux.Active:=False;
         dbAux.Sql.Text:=TxtQuery;
         dbAux.ExecSQL;

         //Inserta el cliente en jos_core_acl_aro
         TxtQuery:='select max(id) from jos_core_acl_aro';
         dbAux1.Active:=False;
         dbAux1.Sql.Text:=TxtQuery;
         dbAux1.ExecSQL;
         dbAux1.Active:=True;


         TxtQuery:='insert into jos_core_acl_aro (id,section_value,value,order_value,'+
         'name,hidden) VALUES (';
         TxtQuery:=TxtQuery + IntToStr(dbAux1.Fields[0].AsInteger + 1) + ',';

         TxtQuery:=TxtQuery + '"users",';
         TxtQuery:=TxtQuery + dbCli.Fields[0].AsString + ',';
         TxtQuery:=TxtQuery + '0,';
         TxtQuery:=TxtQuery + '"' + dbCli.Fields[1].AsString + '",';  //Nombre
         TxtQuery:=TxtQuery + '0)';


         dbAux.Active:=False;
         dbAux.Sql.Text:=TxtQuery;
         dbAux.ExecSql;

         //Inserta el cliente en jos_core_acl_groups_aro_map
         Maxid:=IntToStr(dbAux1.Fields[0].AsInteger+1);
         TxtQuery:='insert into jos_core_acl_groups_aro_map (group_id,aro_id) values (18,'+Maxid+')';
         dbAux.Active:=False;
         dbAux.Sql.Text:=TxtQuery;
         dbAux.ExecSql;

         //Inserta el cliente en jos_vm_user_info
         TxtQuery:='insert into jos_vm_user_info (user_info_id,user_id,address_type,first_name,phone_1,'+
         'address_1,city,state,country,user_email) VALUES (';
         TxtQuery:=TxtQuery + dbCli.Fields[0].AsString + ',';       //ID
         TxtQuery:=TxtQuery + dbCli.Fields[0].AsString + ',';       //ID
         TxtQuery:=TxtQuery + '"BT",';
         TxtQuery:=TxtQuery + '"' + dbCli.Fields[1].AsString + '",';//Nombre
         TxtQuery:=TxtQuery + '"' + dbCli.Fields[6].AsString + '",';//Telefono
         TxtQuery:=TxtQuery + '"' + dbCli.Fields[3].AsString + '",';//Domicilio
         TxtQuery:=TxtQuery + '"' + dbCli.Fields[4].AsString + '",';
         TxtQuery:=TxtQuery + '18,';
         TxtQuery:=TxtQuery + '"ESP",';
         TxtQuery:=TxtQuery + '"' + dbCli.Fields[40].AsString + '")';//email

         dbAux.Active:=False;
         dbAux.Sql.Text:=TxtQuery;
         dbAux.ExecSql;


        end;
       end;

     except
      ShowMessage('NO SE HA PODIDO ACTUALIZAR');
     end;
     dbCli.Next;


    end;

    //Actualización Clientes en Tienda Virtual
    dbRCli.Active:=False;
    TxtQuery:= 'SELECT * FROM jos_vm_user_info ORDER BY user_id';
    dbRCli.Sql.Text:= TxtQuery;
    dbRCli.Active := True;
    dbRCli.First;

    while not dbRCli.Eof do
     begin
      try
       begin
        //Comprobación por si el cliente ha sido borrado en FacturLinex y sigue en Tienda Virtual
        TxTQuery:= 'SELECT C0 FROM clientes where C0='+ dbRCli.Fields[1].AsString +'';
        dbCli.Active:=False;
        dbCli.Sql.Text:=TxtQuery;
        dbCli.Active := True;

        if dbCli.RecordCount=0 then
         begin
          //Borra cliente en la tabla jos_users
          TxtQuery:='DELETE FROM jos_users WHERE id= '+ dbRCli.Fields[1].AsString +'';
          dbAux.Active := False;
          dbAux.Sql.Text:=TxtQuery;
          dbAux.ExecSql;

          //Borra cliente en la tabla jos_core_acl_groups_aro_map, jos_core_acl_aro y  jos_vm_user_info
          TxtQuery:='SELECT id FROM jos_core_acl_aro WHERE value='+ dbRCli.Fields[1].AsString +'';
          dbAux.Active := False;
          dbAux.Sql.Text:=TxtQuery;
          dbAux.ExecSql;
          dbAux.Active:= True;

          TxtQuery:='DELETE FROM jos_core_acl_groups_aro_map where aro_id='+ dbAux.Fields[0].AsString +'';
          dbAux1.Active:=False;
          dbAux1.Sql.Text:=TxtQuery;
          dbAux1.ExecSQL;

          TxtQuery:='DELETE FROM jos_core_acl_aro WHERE value='+ dbRCli.Fields[1].AsString +'';
          dbAux.Active:=False;
          dbAux.Sql.Text:=TxtQuery;
          dbAux.ExecSQL;
          TxtQuery:='DELETE FROM jos_vm_user_info WHERE user_id= '+ dbRCli.Fields[1].AsString +'';
          dbAux.Active:=False;
          dbAux.Sql.Text:=TxtQuery;
          dbAux.ExecSQL;
        end
        else
         begin
          dbCli.Active:=False;
          dbCli.SQL.Text:= 'select * from clientes where C0 = "'+dbRCli.Fields[1].AsString+'"';
          dbCli.ExecSQL;
          dbCli.Active:=True;
          Cambia:=0;
          // Actualizacion jos_vm_user_info
          if dbCli.FieldByName('C1').AsString<>dbRCli.FieldByName('first_name').AsString then Cambia:=1;
          if dbCli.FieldByName('C3').AsString<>dbRCli.FieldByName('address_1').AsString then Cambia:=1;
          if dbCli.FieldByName('C4').AsString<>dbRCli.FieldByName('city').AsString then Cambia:=1;
          if dbCli.FieldByName('C6').AsString<>dbRCli.FieldByName('phone_1').AsString then Cambia:=1;
          if dbCli.FieldByName('C40').AsString<>dbRCli.FieldByName('user_email').AsString then Cambia:=1;

          If Cambia=1 then
           begin
            TxtQuery:='UPDATE jos_vm_user_info SET first_name="'+ dbCli.Fields[1].AsString + '",';
            TxtQuery:=TxtQuery + 'address_1="'+ dbCli.Fields[3].AsString + '",';
            TxtQuery:=TxtQuery + 'city="'+ dbCli.Fields[4].AsString + '",';
            TxtQuery:=TxtQuery + 'phone_1="'+ dbCli.Fields[6].AsString + '",';
            TxtQuery:=TxtQuery + 'user_email="'+ dbCli.Fields[40].AsString + '"';
            TxtQuery:=TxtQuery + ' WHERE user_id="' + dbCli.Fields[0].AsString + '"';

            dbAux.Active:=False;
            dbAux.Sql.Text:=TxtQuery;
            dbAux.ExecSQL;
           end;
          Cambia:=0;
          // Actualizacion jos_users
          dbAux.Active:=False;
          TxtQuery:= 'SELECT * FROM jos_users WHERE id="'+dbRCli.Fields[1].AsString+'" ORDER BY id';
          dbAux.Sql.Text:= TxtQuery;
          dbAux.Active := True;
          dbAux.First;
          Salt:='vIU8pYHJ8ogbV2k2vblQcQzLJmtco99T';
          Pass:=MD5Print(MD5String(dbCli.Fields[53].AsString+'vIU8pYHJ8ogbV2k2vblQcQzLJmtco99T'));
          Pass2:=MD5Print(MD5String(dbAux.FieldByName('password').AsString+'vIU8pYHJ8ogbV2k2vblQcQzLJmtco99T'));
          if dbCli.FieldByName('C1').AsString<>dbAux.FieldByName('name').AsString then Cambia:=1;
          if dbCli.FieldByName('C40').AsString<>dbAux.FieldByName('email').AsString then Cambia:=1;
          if dbCli.FieldByName('C52').AsString<>dbAux.FieldByName('username').AsString then Cambia:=1;
          if Pass<>Pass2 then Cambia:=1;
          if dbCli.FieldByName('C54').AsString<>dbAux.FieldByName('block').AsString then Cambia:=1;

          If Cambia=1 then
           begin
            TxtQuery:='UPDATE jos_users SET name="'+ dbCli.Fields[1].AsString + '",';
            TxtQuery:=TxtQuery + 'email="'+ dbCli.Fields[40].AsString + '",';
            TxtQuery:=TxtQuery + 'username="'+ dbCli.Fields[52].AsString + '",';
            TxtQuery:=TxtQuery + 'password="'+Pass+':'+Salt+'",';
            TxtQuery:=TxtQuery + 'block="'+ dbCli.Fields[54].AsString + '"';
            TxtQuery:=TxtQuery + ' WHERE id="' + dbCli.Fields[0].AsString + '"';

            dbAux.Active:=False;
            dbAux.Sql.Text:=TxtQuery;
            dbAux.ExecSQL;
           end;
          Cambia:=0;
          // Actualizacion jos_core_acl_aro
          dbAux.Active:=False;
          TxtQuery:= 'SELECT * FROM jos_core_acl_aro WHERE value="'+dbRCli.Fields[1].AsString+'" ORDER BY value';
          dbAux.Sql.Text:= TxtQuery;
          dbAux.Active := True;
          dbAux.First;
          if dbCli.FieldByName('C1').AsString<>dbAux.FieldByName('name').AsString then Cambia:=1;
          If Cambia=1 then
           begin
            TxtQuery:='UPDATE jos_core_acl_aro SET name="'+ dbCli.Fields[1].AsString + '"';
            TxtQuery:=TxtQuery + ' WHERE value="' + dbCli.Fields[0].AsString + '"';

            dbAux.Active:=False;
            dbAux.Sql.Text:=TxtQuery;
            dbAux.ExecSQL;
           end;

         end;
       end;

       except
        ShowMessage('NO SE HA PODIDO ACTUALIZAR');
       end;
       dbRCli.Next;

     end;

    end;


initialization
  {$I envioclientes.lrs}

end.

