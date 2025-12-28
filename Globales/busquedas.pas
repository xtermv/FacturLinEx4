{
  Gestion LinEx FacturLinEx

  Copyright (C) 2008-2009, Equipo de colaboradores.

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

unit Busquedas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  DBGrids, ZConnection, ZDataset, db, ExtCtrls, StdCtrls, Buttons, LCLType;

type

  { TFBusquedas }

  TFBusquedas = class(TForm)
    BtAplicar: TBitBtn;
    BtCancelar: TBitBtn;
    BtCerrar: TBitBtn;
    CBCampos: TComboBox;
    CBFiltros: TComboBox;
    Datasource1: TDatasource;
    dbBusquedas: TZQuery;
    GridBusquedas: TDBGrid;
    EdTexto: TEdit;
    GBCampo: TGroupBox;
    GBTexto: TGroupBox;
    GroupBox1: TGroupBox;

    procedure BtAplicarClick(Sender: TObject);
    procedure BtCancelarClick(Sender: TObject);
    procedure CBFiltrosChange(Sender: TObject);
    procedure DividirConsulta(TxtConsulta: string);
    procedure BtCerrarClick(Sender: TObject);
    procedure CBCamposChange(Sender: TObject);
    procedure EdTextoChange(Sender: TObject);
    procedure EdTextoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ActualizaGrid;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridBusquedasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridBusquedasTitleClick(Column: TColumn);
    procedure Reordena(nColumna: integer; var AntColund: String; var Orden: String);

    function IniciaBusquedas(TxtConsulta: string; const TituloCampos: Array of string; CampoBusqueda: string ):string;
    function CargaTitulos(var TitulosGrid: TDBGrid): variant;

  private
    { private declarations }
  public
    { public declarations }
  end; 

    procedure ShowFormBusquedas;

var
  AntColumna, Orden: String;
  FBusquedas: TFBusquedas;
  ConsultaOriginal, Consulta, ConsultaAnterior: string;
  InicioConsulta, FinalConsulta: string;
  CampoBuscar: string;
  modificador: string;
  Comodin: string;
  Resultado: variant;
  TxtCampos: array of string;
  RefCampos: array of string;

implementation

uses
 Funciones;

{ TFBusquedas }

procedure ShowFormBusquedas;
begin
  with TFBusquedas.Create(Application) do
    begin
      ShowModal;
    end;
end;


function TFBusquedas.IniciaBusquedas(TxtConsulta: string; const TituloCampos: Array of string; CampoBusqueda: string):string;
var
  contador: integer;
begin
   Resultado:='';
   AntColumna:='';
   Orden:= ' ASC';
   Consulta:= TxtConsulta;
   ConsultaOriginal:= Consulta;
   CampoBuscar:= CampoBusqueda;
   modificador:=' LIKE '; Comodin:='%';
   SetLength(TxtCampos, length(TituloCampos));
    for contador:=high(TituloCampos) downto low(TituloCampos)  do
       TxtCampos[contador]:= TituloCampos[contador];

   ShowFormBusquedas;
   Result:= Resultado;
end;

procedure TFBusquedas.BtAplicarClick(Sender: TObject);
begin
  if modificador='' then
     begin
        Showmessage('NO HAY SELECCIONADO UN FILTRO');
        Exit;
     end;
  if modificador = 'N0' then begin
                               CBFiltros.ItemIndex:= 0;
                               Consulta:= ConsultaAnterior ;
                               ActualizaGrid;
                               CBCampos.ItemIndex:= 1;
                               CBCamposChange(Self);
                               exit;
                             end;
  if modificador = 'N1' then begin
                               CBFiltros.ItemIndex:= 0;
                               Consulta:= ConsultaOriginal;
                               ActualizaGrid;
                               CBCampos.ItemIndex:= 1;
                               CBCamposChange(Self);
                               exit;
                             end;
  if  edTexto.Text='' then
     begin
        Showmessage('NO HAY VALOR PARA FILTRAR');
        Exit;
     end;
  ConsultaAnterior:= Consulta;
  DividirConsulta(Consulta);
end;

procedure TFBusquedas.BtCancelarClick(Sender: TObject);
begin
   Resultado:=-1;
   Close();
end;

procedure TFBusquedas.CBFiltrosChange(Sender: TObject);
begin
// Comodin:='';
 case CBFiltros.ItemIndex of
   0: modificador:='=';
   1: modificador:='<>';
   2: modificador:='<=';
   3: modificador:='>=';
   4: begin; modificador:=' LIKE '; Comodin:='%'; end;
   5: modificador:='N0';
   6: modificador:='N1';
 end;
end;

procedure TFBusquedas.BtCerrarClick(Sender: TObject);
begin
  if CampoBuscar='' then Resultado := Consulta
                    else Resultado:= dbBusquedas.FieldByName(CampoBuscar).Value;
  if (Resultado = null) then Resultado:=-1;
  Close();
end;

procedure TFBusquedas.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Closeaction:=CaFree;
end;

procedure TFBusquedas.DividirConsulta(TxtConsulta: string);
var
  comillas: string;
  enlazador: string;
  posWhere, posOtras: integer;
begin
  enlazador:= ' AND ';
  comillas:='"';
  InicioConsulta:= TxtConsulta;
  FinalConsulta := TxtConsulta;
  if pos('WHERE', TxtConsulta)=0 then posWhere:= pos('where', TxtConsulta)
                                 else posWhere:= pos('WHERE', TxtConsulta);
  if posWhere<>0 then  begin
                         Delete(InicioConsulta, posWhere , length(TxtConsulta));
                         Delete(FinalConsulta, 1, posWhere +5  );
                       end
                  else
                      begin
                        enlazador:='';
                        if pos('GROUP BY', TxtConsulta)=0 then posOtras:= pos('group by', TxtConsulta)
                                           else posOtras:= pos('GROUP BY', TxtConsulta);
                        if posOtras = 0 then
                                        begin
                                            if pos('ORDER BY', TxtConsulta)=0 then posOtras:= pos('order by', TxtConsulta)
                                                      else posOtras:= pos('ORDER BY', TxtConsulta);
                                        end;
                        posWhere:= posOtras;
                        if posWhere<>0 then
                                         begin
                                          Delete(InicioConsulta, posWhere , length(TxtConsulta));
                                          Delete(FinalConsulta, 1, posWhere-1 );
                                         end
                                       else
                                         begin
                                           FinalConsulta := '';
                                         end;
                     end;

//ftNonTextTypes = [ftBytes, ftVarBytes, ftBlob, ftMemo, ftGraphic, ftInteger]
 if dbBusquedas.Fields[CBCampos.ItemIndex].DataType in [ftBytes, ftVarBytes, ftBlob, ftMemo, ftGraphic, ftInteger]
   then comillas:='';
 Consulta := InicioConsulta + 'WHERE ' + RefCampos[CBCampos.ItemIndex] +
               modificador + comillas + Comodin + edTexto.Text+ comodin + comillas + enlazador + ' '+
               FinalConsulta;
 CBFiltros.ItemIndex:= 4;
 ActualizaGrid;
end;

procedure TFBusquedas.ActualizaGrid;
begin
   dbBusquedas.Active:=False;
   dbBusquedas.Sql.Text:=Consulta;
   dbBusquedas.Active:=True;

   Reordena(CBCampos.ItemIndex, AntColumna, Orden);
end;

procedure TFBusquedas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (key=VK_F8) then begin key:=0; btAplicarClick(self); Exit; End;
 if (key=VK_RETURN) then begin key:=0; btCerrarClick(Self); end;
 if (key=VK_ESCAPE) then begin key:=0; btCancelarClick(Self); end;
 if (key=VK_F12) and (GridBusquedas.Focused) then begin key:=0; EdTexto.SetFocus; Exit; End;
 if (key=VK_F12) and (EdTexto.Focused) then begin key:=0; GridBusquedas.SetFocus; Exit; End;

end;

procedure TFBusquedas.GridBusquedasKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=VK_RETURN) then begin key:=0; btCerrarClick(Self); end;
end;

procedure TFBusquedas.GridBusquedasTitleClick(Column: TColumn);
begin
    ConsultaAnterior:= Consulta;
    CBCampos.ItemIndex:= Column.Index;
    Reordena(Column.Index, AntColumna, Orden);
    Consulta:= dbBusquedas.SQL.Text;
end;

procedure TFBusquedas.CBCamposChange(Sender: TObject);
begin
    ConsultaAnterior:= Consulta;
    GridBusquedas.SelectedColumn.Index:=CBCampos.ItemIndex;
    Reordena(CBCampos.ItemIndex, AntColumna, Orden);
    Consulta:= dbBusquedas.SQL.Text;
end;

procedure TFBusquedas.EdTextoChange(Sender: TObject);
begin
  dbBusquedas.Locate(RefCampos[CBCampos.ItemIndex], EdTexto.Text, [loPartialkey, loCaseInsensitive] )
end;

procedure TFBusquedas.EdTextoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=VK_RETURN) then btCerrarClick(Self);  //BtAplicarClick(Self);
end;

procedure TFBusquedas.FormCreate(Sender: TObject);
var
   ncontador, columnasvisibles, ncolumnas: integer;
begin
  //Conectate(dbConect);     // Utilizamos datamodule1.dbConexión para toda la aplicación.
  self.BorderStyle:=bsSizeable;
  dbBusquedas.SQL.Text:=ConsultaOriginal;
  Datasource1.DataSet:=dbBusquedas;
  dbBusquedas.Active:= True;
  columnasvisibles:= GridBusquedas.Columns.VisibleCount;
  CBCampos.Clear;
  setlength(RefCampos, columnasvisibles);
  CBCampos.ItemIndex:=1;
  for ncolumnas:=0 to columnasvisibles-1 do
      begin
        RefCampos[ncolumnas]:=dbBusquedas.Fields.Fields[ncolumnas].FieldName;
        CBCampos.Items.Add(txtCampos[ncolumnas]);
        If CampoBuscar = RefCampos[ncolumnas] then CBCampos.ItemIndex:=ncolumnas;
      end;
  for ncontador:=0 to length(txtCampos)-1 do
      GridBusquedas.Columns.Items[ncontador].Title.Caption:= txtCampos[ncontador];
  CBCamposChange(Self);
end;

procedure TFBusquedas.Reordena(nColumna: integer; var AntColund: String; var Orden: String);
var
 TxtQuery,TxtQuery1: String;
 ncontador,x,j: integer;
begin
  TxtQuery:=dbBusquedas.Sql.Text;
  j:=length(TxtQuery);
  x:=pos('ORDER',TxtQuery);
  if x=0 then x:=pos('ORDER',TxtQuery);
  delete(TxtQuery,x,j-(x-1));
  BlancoGrid(GridBusquedas);
  if AntColund <> '' then
     begin
        If StrToInt(AntColund) = nColumna Then
          if Orden = ' ASC' then Orden:='DESC' else Orden:=' ASC';
     end;
  TxtQuery1:=' ORDER BY ' + RefCampos[nColumna] +' '+ Orden;
  Insert(TxtQuery1,TxtQuery,j);
  dbBusquedas.Active:=False;
  dbBusquedas.Sql.Text:=TxtQuery;
  dbBusquedas.Active:=True;
  AntColund:=IntTostr(nColumna);
  if Orden = 'DESC' then GridBusquedas.Columns.Items[nColumna].Color := $00DEDEF5 else
                         GridBusquedas.Columns.Items[nColumna].Color := clSkyBlue;
  for ncontador:=0 to length(txtCampos)-1 do
      GridBusquedas.Columns.Items[ncontador].Title.Caption:= txtCampos[ncontador];
  GridBusquedas.Columns.Items[nColumna].Title.Caption:=GridBusquedas.Columns.Items[nColumna].Title.Caption + ' ['+orden+']';
end;

function TFBusquedas.CargaTitulos(var TitulosGrid: TDBGrid): variant;
var
  ncontador: integer;
  Titulos: array of string;
begin
  setlength(Titulos, TitulosGrid.Columns.VisibleCount);
  for ncontador:=0 to length(TxtCampos)-1 do
      Titulos[ncontador]:=TitulosGrid.Columns.Items[ncontador].Title.Caption;
  Result:= Titulos;
end;

initialization
  {$I busquedas.lrs}

end.

