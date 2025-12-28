{
  Gestion LinEx FacturLinEx

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

unit fn_mysql;

{$mode objfpc}

interface

uses
  Classes, SysUtils, ZConnection;

  function mysql_conectar(dbConector: TZConnection; sServidor, sBaseDatos, sUsuario, sClave, sProtocolo: String; iPuerto: Integer): Boolean;
  procedure mysql_desconectar(dbConector: TZConnection);


implementation

// ------------------- CONEXION CON EL SERVIDOR MySQL --------------------------
// Sintaxis:
//    mysql_conectar(dbConector, sServidor, sBaseDatos, sUsuario, sClave, sProtocol, iPuerto);
// Ejemplo:
//    mysql_conectar(dbConector, 'localhost', 'facturlinex2', 'usuario','clave','mysql-5',3306);
// -----------------------------------------------------------------------------
function mysql_conectar(dbConector: TZConnection; sServidor, sBaseDatos, sUsuario, sClave, sProtocolo: String; iPuerto: Integer): Boolean;
begin
  dbConector.HostName:=sServidor;
  dbConector.Database:=sBaseDatos;
  dbConector.User:=sUsuario;
  dbConector.Password:=sClave;
  dbConector.Protocol:=sProtocolo;
  dbConector.Port:=iPuerto;

  try
    dbConector.Connected:=True
  except
     result:=False;
  end;
end;

// ---------------- CONEXION CON EL SERVIDOR MySQL ---------------------
// Sintaxis:
//    mysql_desconectar(dbConector);
// Ejemplo:
//    mysql_desconectar(dbConector);
// -----------------------------------------------------------------------------
procedure mysql_desconectar(dbConector: TZConnection);
begin
  dbConector.Connected:= False;
end;

end.

