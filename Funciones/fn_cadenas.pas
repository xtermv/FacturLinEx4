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

unit fn_cadenas;

{$mode objfpc}

interface

uses
  Classes, SysUtils; 

  function limpiar_cadena(sCadena: ansistring; cCaracter: Char): ansistring;
  function convertir_a_hex(sCadena: ansistring): ansistring;
  function Val2Hex(ilPassedValue : LongInt) : String;
  function Char2Hex(cPassedChar : Char) : String;


implementation

// ----------------- ELIMINAR DE UNA CADENA UN CARACTER DETERMINADO ------------
// Sintaxis:
//    limpiar_cadena(sCadena, cCaracter);
//    Devuelve la cadena inicial sin el carácter indicado
// Ejemplo:
//    cadena:=limpiar_cadena(cadena, 'A');
//    Elimina todas las letras A de cadena
// -----------------------------------------------------------------------------
function limpiar_cadena(sCadena: ansistring; cCaracter: Char): ansistring;
var
  cont: integer;
begin
   cont := 1;
   while cont <= length(sCadena) do begin
       if sCadena[cont]=cCaracter then delete(sCadena,cont,1);
       cont := cont + 1;
   end;
   Result := sCadena;
end;

// --------------- CONVERTIR UNA CADENA A SU VALOR HEXADECIMAL -----------------
// Sintaxis:
//    convertir_a_hex(sCadena);
//    Devuelve la cadena convertida a hexadecimal
// Ejemplo:
//    cadenahex:=convertir_a_hex(cadena);
// -----------------------------------------------------------------------------
function convertir_a_hex(sCadena: ansistring): ansistring;
var
  sRetStr : String;
  cont : integer;
  car : char;
begin
  if length(sCadena) > 0 then begin
     sRetStr:='0x';
     for cont := 1 to length(sCadena) do begin
         car := sCadena[cont];
         sRetStr := sRetStr + Char2Hex(car);
     end;
  end;
   convertir_a_hex:=sRetStr;
end;

//=============== Char2Hex -> Char a Hexadecimal ================
 Function Char2Hex(cPassedChar : Char) : String;
 var
   sRetStr  : String;
 begin
    sRetStr  := '';
    sRetStr := Val2Hex(Ord(cPassedChar));
    While length(sRetStr) < 2 do
          sRetStr := '0' + sRetStr;
    Char2hex := sRetStr;

 end;

//=============== Val2Hex -> LongInt a Hexadecimal ================
 Function Val2Hex(ilPassedValue : LongInt) : String;
 var
   sRetStr  : String;
   sTempStr : String;
   iRest    : Integer;
   ilFigure : LongInt;
 begin
    sRetStr  := '';
    sTempStr := '';
    iRest    := 0;
    ilFigure := 0;
    ilFigure := ilPassedValue;
    Repeat
       iRest := ilFigure MOD 16;
       Case iRest of
          0 : sTempStr := '0';
          1 : sTempStr := '1';
          2 : sTempStr := '2';
          3 : sTempStr := '3';
          4 : sTempStr := '4';
          5 : sTempStr := '5';
          6 : sTempStr := '6';
          7 : sTempStr := '7';
          8 : sTempStr := '8';
          9 : sTempStr := '9';
         10 : sTempStr := 'A';
         11 : sTempStr := 'B';
         12 : sTempStr := 'C';
         13 : sTempStr := 'D';
         14 : sTempStr := 'E';
         15 : sTempStr := 'F';
       End;
       sRetStr := sTempStr + sRetStr;
       ilFigure := ilFigure - iRest;
       ilFigure := ilFigure DIV 16;
    Until ilFigure = 0;
    Val2Hex := sRetStr;
 end;

end.

