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

unit ActAutArt;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, Buttons, StdCtrls, DbCtrls, Grids, ZConnection,
  ZDataset, LCLType;

type

  { TfActAutArt }

  TfActAutArt = class(TForm)
    bbFiltrar: TBitBtn;
    bbFijo: TBitBtn;
    bbPorcentaje: TBitBtn;
    bbAplicar: TBitBtn;
    BitBtnCerrar: TBitBtn;
    cbAutor: TComboBox;
    cbFamilia: TComboBox;
    cbProveedor: TComboBox;
    cgActTarifas: TCheckGroup;
    dsProveedores: TDatasource;
    dsFamilias: TDatasource;
    dsAutoFabri: TDatasource;
    dsArticulos: TDatasource;
    eCodigoD: TEdit;
    eDescrD: TEdit;
    eDescrH: TEdit;
    eCodigoH: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel1: TPanel;
    dbArticulos: TZQuery;
    dbAutoFabri: TZQuery;
    dbFamilias: TZQuery;
    rgPorcentaje: TRadioGroup;
    rgFijo: TRadioGroup;
    sgDatos: TStringGrid;
    Query: TZQuery;
    dbProveedores: TZQuery;
    procedure bbAplicarClick(Sender: TObject);
    procedure bbFijoClick(Sender: TObject);
    procedure bbFiltrarClick(Sender: TObject);
    procedure bbPorcentajeClick(Sender: TObject);
    procedure BitBtnCerrarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure sgDatosKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  end; 
  procedure ShowFormActAutArt;
  function SumaPorcen(base, porciento: double): double;
  function RestaPorcen(total, porciento: double): double;

var
  fActAutArt: TfActAutArt;

implementation

{ TfActAutArt }

Uses funciones, global;

//=============== Crea el formulario ================
procedure ShowFormActAutArt;
begin
  with TFActAutArt.Create(Application) do
    begin
       ShowModal;
    end;
end;

//=========Funciones para sumar y restar un porcentaje========
function SumaPorcen(Base, PorCiento: double): double;
begin
  result := Base+((Base*PorCiento)/100);
end;

function RestaPorcen(Total, PorCiento: double): double;
begin
  result := (100 * Total) / (100 + PorCiento);
end;

procedure TfActAutArt.BitBtnCerrarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfActAutArt.bbFiltrarClick(Sender: TObject);
var
  clausula: string;
begin
  clausula:='WHERE ';
  if dbArticulos.Active then dbArticulos.Close;
  dbArticulos.SQL.Clear;
  dbArticulos.SQL.Add('SELECT * FROM artitien'+Tienda+' ');
  if eCodigoD.Text<>'' then begin
     dbArticulos.SQL.Add(clausula+'A0 >= '''+eCodigoD.Text+'''');
     clausula:=' and ';
  end;
  if eCodigoH.Text<>'' then begin
     dbArticulos.SQL.Add(clausula+'A0 <= '''+eCodigoH.Text+'''');
     clausula:=' and ';
  end;
  if eDescrD.Text<>'' then begin
     dbArticulos.SQL.Add(clausula+'A1 >= '''+eDescrD.Text+'''');
     clausula:=' and ';
  end;
  if eDescrH.Text<>'' then begin
     dbArticulos.SQL.Add(clausula+'A1 <= '''+eDescrH.Text+'''');
     clausula:=' and ';
  end;
  if cbAutor.Text<>'' then begin
     // Buscamos el código de Autor/Fabricante y lo insertamos en el query
     dbAutoFabri.Open;
     dbAutoFabri.Locate('AUT1', cbAutor.Text, []);
     dbArticulos.SQL.Add(clausula+'A20 = '''+dbAutoFabri.FieldByName('AUT0').AsString +'''');
     clausula:=' and ';
     dbAutoFabri.Close;
  end;
  if cbFamilia.Text<>'' then begin
     // Buscamos el código de la Familia y lo insertamos en el query
     dbFamilias.Open;
     dbFamilias.Locate('F1', cbFamilia.Text, []);
     dbArticulos.SQL.Add(clausula+'A14 = '''+dbFamilias.FieldByName('F0').AsString +'''');
     clausula:=' and ';
     dbFamilias.Close;
  end;
  if cbProveedor.Text<>'' then begin
     // Buscamos el código del Proveedor y lo insertamos en el query
     dbProveedores.Open;
     dbProveedores.Locate('P1', cbProveedor.Text, []);
     dbArticulos.SQL.Add(clausula+'A32 = '''+dbProveedores.FieldByName('P0').AsString +'''');
     clausula:=' and ';
     dbProveedores.Close;
  end;
  dbArticulos.Open;
  sgDatos.RowCount:=dbArticulos.RecordCount+1;
  while not dbArticulos.EOF do begin
        sgDatos.Cells[0,dbArticulos.RecNo]:=dbArticulos.FieldByName('A0').AsString;
        sgDatos.Cells[1,dbArticulos.RecNo]:=dbArticulos.FieldByName('A1').AsString;
        sgDatos.Cells[2,dbArticulos.RecNo]:=FormatFloat('0.000',dbArticulos.FieldByName('A21').AsFloat);
        sgDatos.Cells[4,dbArticulos.RecNo]:=FormatFloat('0.000',dbArticulos.FieldByName('A3').AsFloat);
        sgDatos.Cells[5,dbArticulos.RecNo]:=FormatFloat('0.000',dbArticulos.FieldByName('A2').AsFloat);
        dbArticulos.Next;
  end;
  dbArticulos.Close;
  rgFijo.Enabled:=True;  bbFijo.Enabled:=True;
  rgPorcentaje.Enabled:=True;  bbPorcentaje.Enabled:=True;
  sgDatos.Row:=0; sgDatos.Col:=3; sgDatos.SetFocus;
end;

procedure TfActAutArt.bbPorcentajeClick(Sender: TObject);
var
  imp_porcen: string;
  cont: integer;
begin
  imp_porcen := InputBox('FacturLinEx 2','Introducir PORCENTAJE','');
  if rgPorcentaje.ItemIndex=0 then begin    // PVP S/IVA
     for cont:=1 to SgDatos.RowCount-1 do begin
         if sgDatos.Cells[3,cont]='' then begin     // No hay datos, se calcula sobre el dato original
            sgDatos.Cells[3,cont]:=FormatFloat('0.000',SumaPorcen(StrToFloat(sgDatos.Cells[2,Cont]),StrToFloat(imp_porcen)));
         end else begin    // Hay datos, se calcula sobre el dato modificado
            sgDatos.Cells[3,cont]:=FormatFloat('0.000',SumaPorcen(StrToFloat(sgDatos.Cells[3,Cont]),StrToFloat(imp_porcen)));
         end;
         sgDatos.Cells[6,Cont]:=FormatFloat('0.000',SumaPorcen(StrToFloat(sgDatos.Cells[3,Cont]),
                                                               StrToFloat(sgDatos.Cells[4,Cont])));
     end;
  end else begin    // PVP C/IVA
     for cont:=1 to SgDatos.RowCount-1 do begin
         if sgDatos.Cells[6,cont]='' then begin     // No hay datos, se calcula sobre el dato original
            sgDatos.Cells[6,cont]:=FormatFloat('0.000',SumaPorcen(StrToFloat(sgDatos.Cells[5,Cont]),StrToFloat(imp_porcen)));
         end else begin    // Hay datos, se calcula sobre el dato modificado
            sgDatos.Cells[6,cont]:=FormatFloat('0.000',SumaPorcen(StrToFloat(sgDatos.Cells[6,Cont]),StrToFloat(imp_porcen)));
         end;
         sgDatos.Cells[3,Cont]:=FormatFloat('0.000',RestaPorcen(StrToFloat(sgDatos.Cells[6,Cont]),
                                                                StrToFloat(sgDatos.Cells[4,Cont])));
     end;
  end;
end;

procedure TfActAutArt.bbFijoClick(Sender: TObject);
var
  importe: string;
  cont: integer;
begin
  importe := InputBox('FacturLinEx 2','Introducir IMPORTE','');
  if rgFijo.ItemIndex=0 then begin    // PVP S/IVA
     for cont:=1 to SgDatos.RowCount-1 do begin
         if sgDatos.Cells[3,cont]='' then begin     // No hay datos, se calcula sobre el dato original
            sgDatos.Cells[3,cont]:=FormatFloat('0.000',StrToFloat(sgDatos.Cells[2,Cont])+StrToFloat(importe));
         end else begin    // Hay datos, se calcula sobre el dato modificado
            sgDatos.Cells[3,cont]:=FormatFloat('0.000',StrToFloat(sgDatos.Cells[3,Cont])+StrToFloat(importe));
         end;
         sgDatos.Cells[6,Cont]:=FormatFloat('0.000',SumaPorcen(StrToFloat(sgDatos.Cells[3,Cont]),
                                                               StrToFloat(sgDatos.Cells[4,Cont])));
     end;
  end else begin    // PVP C/IVA
     for cont:=1 to SgDatos.RowCount-1 do begin
         if sgDatos.Cells[6,cont]='' then begin     // No hay datos, se calcula sobre el dato original
            sgDatos.Cells[6,cont]:=FormatFloat('0.000',StrToFloat(sgDatos.Cells[5,Cont])+StrToFloat(importe));
         end else begin    // Hay datos, se calcula sobre el dato modificado
            sgDatos.Cells[6,cont]:=FormatFloat('0.000',StrToFloat(sgDatos.Cells[6,Cont])+StrToFloat(importe));
         end;
         sgDatos.Cells[3,Cont]:=FormatFloat('0.000',RestaPorcen(StrToFloat(sgDatos.Cells[6,Cont]),
                                                                StrToFloat(sgDatos.Cells[4,Cont])));
     end;
  end;
end;

procedure TfActAutArt.bbAplicarClick(Sender: TObject);
var
  cont: integer;
begin
  if not cgActTarifas.Checked[0] and
     not cgActTarifas.Checked[1] and
     not cgActTarifas.Checked[2] and
     not cgActTarifas.Checked[3] then begin
         ShowMessage('DEBE SELECCIONAR AL MENOS UNA TARIFA');
         Abort;
     end;
  if Application.MessageBox('SE VA A PROCEDER A ACTUALIZAR LOS DATOS' +
     #13 + '¿DESEA CONTINUAR?', 'FacturLinEx',
     MB_ICONQUESTION + MB_YESNO) = idNo then abort;

  if cgActTarifas.Checked[0] then begin     // Actualizacion de Tarifa General
     for cont:=1 to SgDatos.RowCount-1 do begin
         if sgDatos.Cells[3,cont]<>'' then begin
            if Query.Active then Query.Close;
            Query.SQL.Clear;
            Query.SQL.Add('UPDATE artitien'+global.Tienda+' ');
            Query.SQL.Add('SET A21='''+sgDatos.Cells[3,cont]+''',');
            Query.SQL.Add('    A2 ='''+sgDatos.Cells[6,cont]+''' ');
            Query.SQL.Add('WHERE A0='''+sgDatos.Cells[0,cont]+'''');
            Query.ExecSQL;
         end;
     end;
  end;

  if cgActTarifas.Checked[1] then begin     // Actualizacion de Tarifa 1
     for cont:=1 to SgDatos.RowCount-1 do begin
         if sgDatos.Cells[3,cont]<>'' then begin
            if Query.Active then Query.Close;
            Query.SQL.Clear;
            Query.SQL.Add('UPDATE tarifas');
            Query.SQL.Add('SET TAR2='''+sgDatos.Cells[3,cont]+''',');
            Query.SQL.Add('    TAR7='''+sgDatos.Cells[6,cont]+''' ');
            Query.SQL.Add('WHERE TAR0='''+sgDatos.Cells[0,cont]+'''');
            Query.ExecSQL;
         end;
     end;
  end;

  if cgActTarifas.Checked[2] then begin     // Actualizacion de Tarifa 2
     for cont:=1 to SgDatos.RowCount-1 do begin
         if sgDatos.Cells[3,cont]<>'' then begin
            if Query.Active then Query.Close;
            Query.SQL.Clear;
            Query.SQL.Add('UPDATE tarifas');
            Query.SQL.Add('SET TAR4='''+sgDatos.Cells[3,cont]+''',');
            Query.SQL.Add('    TAR8='''+sgDatos.Cells[6,cont]+''' ');
            Query.SQL.Add('WHERE TAR0='''+sgDatos.Cells[0,cont]+'''');
            Query.ExecSQL;
         end;
     end;
  end;

  if cgActTarifas.Checked[3] then begin     // Actualizacion de Tarifa 3
     for cont:=1 to SgDatos.RowCount-1 do begin
         if sgDatos.Cells[3,cont]<>'' then begin
            if Query.Active then Query.Close;
            Query.SQL.Clear;
            Query.SQL.Add('UPDATE tarifas');
            Query.SQL.Add('SET TAR6='''+sgDatos.Cells[3,cont]+''',');
            Query.SQL.Add('    TAR9='''+sgDatos.Cells[6,cont]+''' ');
            Query.SQL.Add('WHERE TAR0='''+sgDatos.Cells[0,cont]+'''');
            Query.ExecSQL;
         end;
     end;
  end;

  ShowMessage('¡¡ PROCESO REALIZADO SATISFACTORIAMENTE !!');
  sgDatos.Clear;
end;

procedure TfActAutArt.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  cont: integer;
  modif: boolean;
begin
  // Si se han modificado precios, se pide confirmación para salir
  if (sgDatos.RowCount<>0) then
  begin
    modif:=false;
    for cont:=0 to SgDatos.RowCount-1 do
    begin
        if (sgDatos.Cells[3,cont]<>'') then modif:=true;
    end;
    if (modif=true) then
       if Application.MessageBox('¡ HAY PRECIOS MODIFICADOS !' +
         #13 + '¿DESEA REALMENTE SALIR?', 'FacturLinEx',
         MB_ICONQUESTION + MB_YESNO) = idNo then abort;
  end;

  if dbArticulos.Active then dbArticulos.Close;
  CloseAction:=caFree;
end;

procedure TfActAutArt.FormCreate(Sender: TObject);
begin
  //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.
  // Carga de los datos en el POPUP de Autores / Fabricantes
  dbAutoFabri.SQL.Add('SELECT * FROM autofabri ORDER BY AUT1');
  dbAutoFabri.Open;
  dbAutoFabri.First;
  while not dbAutoFabri.EOF do begin
        cbAutor.Items.Add(dbAutoFabri.FieldByName('AUT1').Text);
        dbAutoFabri.Next;
  end;
  // Carga de los datos en el POPUP de Familias
  dbFamilias.SQL.Add('SELECT * FROM familias'+Tienda+' ORDER BY F1');
  dbFamilias.Open;
  dbFamilias.First;
  while not dbFamilias.EOF do begin
        cbFamilia.Items.Add(dbFamilias.FieldByName('F1').Text);
        dbFamilias.Next;
  end;
  // Carga de los datos en el POPUP de Proveedores
  dbProveedores.SQL.Add('SELECT * FROM proveedores ORDER BY P1');
  dbProveedores.Open;
  dbProveedores.First;
  while not dbProveedores.EOF do begin
        cbProveedor.Items.Add(dbproveedores.FieldByName('P1').Text);
        dbproveedores.Next;
  end;
  dbAutoFabri.Close;
  dbFamilias.Close;
  dbProveedores.Close;
end;

procedure TfActAutArt.sgDatosKeyPress(Sender: TObject; var Key: char);
var
  precio: string;
begin
  if (key=#13) and ((sgDatos.Col=3) or (sgDatos.Col=6)) then
  begin
     precio:=InputBox('FacturLinEx 2','Introducir precio','');
     if not (EsFloat(precio)) then        // Salimos si no hay datos buenos.
     begin
         key:=#0;
         exit;
     end;

     if sgDatos.Col=3 then begin   // INTRO en el cambio de Precio Sin IVA
        sgDatos.Cells[3,sgDatos.Row]:=FormatFloat('0.000',StrToFloat(precio));
        sgDatos.Cells[6,sgDatos.Row]:=FormatFloat('0.000',SumaPorcen(StrToFloat(sgDatos.Cells[3,sgDatos.Row]),
                                                                     StrToFloat(sgDatos.Cells[4,sgDatos.Row])));
     end;
     if sgDatos.Col=6 then begin   // INTRO en el cambio de Precio Con IVA incluido
        sgDatos.Cells[6,sgDatos.Row]:=FormatFloat('0.000',StrToFloat(precio));
        sgDatos.Cells[3,sgDatos.Row]:=FormatFloat('0.000',RestaPorcen(StrToFloat(sgDatos.Cells[6,sgDatos.Row]),
                                                                      StrToFloat(sgDatos.Cells[4,sgDatos.Row])));
     end;
     sgDatos.Row:= sgDatos.Row+1;
     key:=#0;
  end;
end;

initialization
  {$I actautart.lrs}

end.

