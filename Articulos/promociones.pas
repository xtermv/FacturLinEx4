{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2010,  Nicolas Lopez de Lerma Aymerich

  PuntoDev GNU S.L. <info@puntodev.com>

  Collaborators:
                 F.Javier Pérez Vidal
                 Jaime Alvarez Ares.

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
unit promociones;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, DBGrids, Buttons, ZConnection, ZDataset,
  LCLType;

type

  { TfPromociones }

  TfPromociones = class(TForm)
    btnActualizar: TBitBtn;
    btnBuscar: TBitBtn;
    btnCancelar: TBitBtn;
    btnAceptar: TBitBtn;
    btnCrear: TBitBtn;
    btnBorrar: TBitBtn;
    btnModificar: TBitBtn;
    btnCerrar: TBitBtn;
    dsPromo: TDatasource;
    dbgDatos: TDBGrid;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    rgFiltro: TRadioGroup;
    dbPromo: TZQuery;
    dbArti: TZQuery;
    dbTrabajo: TZQuery;
    procedure ActualizarPromociones;
    procedure btnActualizarClick(Sender: TObject);
    procedure btnAceptarClick(Sender: TObject);
    procedure btnBorrarClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnCerrarClick(Sender: TObject);
    procedure btnCrearClick(Sender: TObject);
    procedure btnModificarClick(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure rgFiltroClick(Sender: TObject);
    procedure ActivarPanel;
    procedure DesactivarPanel;
    procedure LimpiaPanel();
    procedure LlenaReg();
    procedure Relleno();
  private
    { private declarations }
    Operacion: char;        //   A = Alta / M = Modificación
  public
    { public declarations }
  end; 

  procedure ShowFormPromociones;

var
  fPromociones: TfPromociones;

implementation

uses
  global, funciones, busquedas;

//=============== Crea el formulario ================
procedure ShowFormPromociones;
begin
  with TFPromociones.Create(Application) do
    begin
       ShowModal;
    end;
end;

//======== Procesa las Promociones para actualizar Artículos ======
procedure TfPromociones.ActualizarPromociones;
var
   PrecioSin: Double;
begin
  // Procesamos las promociones en vigor
  if dbPromo.Active=True then dbPromo.Active:=False;
  dbPromo.SQL.Clear;
  dbPromo.SQL.Text:='SELECT * FROM promo'+Tienda+' WHERE P10="A" ORDER BY P0';
  dbPromo.Active := True;

  if dbPromo.RecordCount=0 then exit;

  dbPromo.First;

  while not dbPromo.EOF do begin
    // Si es una promoción nueva y estamos en la fecha de inicio.
    if ((dbPromo.FieldByName('P5').AsString <= FormatDateTime('DD-MM-YYYY',Date)) and (dbPromo.FieldByName('P6').AsString>= FormatDateTime('DD-MM-YYYY',Date)))  then
      begin
        dbArti.Active:=False;
        dbArti.SQL.Text:=' SELECT A0, A2, A3, A21, A24 FROM artitien'+Tienda+' WHERE A0='+dbPromo.FieldByName('P0').AsString;
        dbArti.Active:=True;
       if dbArti.RecordCount<>0 then
        begin
         // Pasamos datos de promoción a la ficha del artículo.
         dbArti.Edit;
         dbArti.FieldByName('A2').AsString:= dbPromo.FieldByName('P7').AsString;
         dbArti.FieldByName('A24').AsString:= dbPromo.FieldByName('P8').AsString;
         dbArti.FieldByName('A3').AsString:= dbPromo.FieldByName('P9').AsString;
         PrecioSin := (100 * dbPromo.FieldByName('P7').AsFloat) / (100 + dbPromo.FieldByName('P9').AsFloat);
         dbArti.FieldByName('A21').AsString:=FormatFloat('0.000',PrecioSin);
         dbArti.Post;
        end;
      end;

    // Si es una promoción Activada y es la fecha de finalización.
    if (dbPromo.FieldByName('P6').AsString< FormatDateTime('DD/MM/YYYY',Date))  then
      begin
        dbArti.Active:=False;
        dbArti.SQL.Text:=' SELECT A0, A2, A3, A21, A24 FROM artitien'+Tienda+' WHERE A0='+dbPromo.FieldByName('P0').AsString;
        dbArti.Active:=True;
       if dbArti.RecordCount<>0 then
        begin
         // Restauramos los valores anteriores a la promoción y damos por finalizada la misma.
         dbArti.Edit;
         dbArti.FieldByName('A2').AsString:= dbPromo.FieldByName('P2').AsString;
         dbArti.FieldByName('A24').AsString:= dbPromo.FieldByName('P3').AsString;
         dbArti.FieldByName('A3').AsString:= dbPromo.FieldByName('P4').AsString;
         PrecioSin := (100 * dbPromo.FieldByName('P2').AsFloat) / (100 + dbPromo.FieldByName('P4').AsFloat);
         dbArti.FieldByName('A21').AsString:=FormatFloat('0.000',PrecioSin);
         dbPromo.Edit;
         dbPromo.FieldByName('P10').AsString:='F';
         dbPromo.Post; dbArti.Post;
        end;
      end;

    dbPromo.Next;
  end;

end;

procedure TfPromociones.btnActualizarClick(Sender: TObject);
begin
  ActualizarPromociones;
  rgFiltroClick(Self);
end;

{ TfPromociones }

// Procedimientos para Activación y Desactivación del Panel
procedure TfPromociones.ActivarPanel;
begin
  rgFiltro.Enabled:=False;
  dbgDatos.Enabled:=False;
  btnCrear.Enabled:=False;
  btnBorrar.Enabled:=False;
  btnModificar.Enabled:=False;
  btnCerrar.Enabled:=False;
  btnActualizar.Enabled:=False;
  Panel1.Visible:=True;
end;
procedure TfPromociones.DesactivarPanel;
begin
  Panel1.Visible:=False;
  rgFiltro.Enabled:=True;
  dbgDatos.Enabled:=True;
  btnCrear.Enabled:=True;
  btnBorrar.Enabled:=True;
  btnModificar.Enabled:=True;
  btnCerrar.Enabled:=True;
  btnActualizar.Enabled:=True;
end;

procedure TfPromociones.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  Closeaction:=CaFree;
end;

procedure TfPromociones.FormCreate(Sender: TObject);
begin
  //----------------- CONEXION -----------------
  //Conectate(dbConect);   // Utilizamos datamodule1.dbConexión para toda la aplicación.
  //------------------- Tablas ------------------
  dbPromo.SQL.Text:='SELECT * FROM promo'+Tienda+' WHERE P10="A" ORDER BY P0';
  dbPromo.Active := True;
  dbArti.Sql.Text:='SELECT * FROM artitien'+Tienda+' ORDER BY A0';
  dbArti.Active := True;
end;

procedure TfPromociones.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key=VK_ESCAPE) and (Panel1.Visible=False)) then begin; key:=0; btnCerrarClick(Sender); exit; end;
  if ((Key=VK_ESCAPE) and (Panel1.Visible=True)) then begin; key:=0; btnCancelarClick(Sender); exit ; end;
  if (key=VK_F8) and ( Panel1.Visible=True) then begin; key:=0; btnAceptarClick(self); exit; end;
  if (key=VK_F3) and ( Panel1.Visible=False) then begin; key:=0; btnBorrarClick(self); exit; end;
  if (key=VK_F2) and ( Panel1.Visible=False) then begin; key:=0; btnCrearClick(self); exit; end;
end;

procedure TfPromociones.rgFiltroClick(Sender: TObject);
begin
  dbPromo.Active:=False;
  dbPromo.SQL.Clear;
  case rgFiltro.ItemIndex of
       0: dbPromo.SQL.Add('SELECT * FROM promo'+Tienda+' WHERE P10="A" ORDER BY P0');
       1: dbPromo.SQL.Add('SELECT * FROM promo'+Tienda+' WHERE P10="F" ORDER BY P0');
       2: dbPromo.SQL.Add('SELECT * FROM promo'+Tienda+' ORDER BY P0');
  end;
  dbPromo.Active:=True;
end;

procedure TfPromociones.btnCerrarClick(Sender: TObject);
begin
  dbPromo.Active:=False;
  dbArti.Active:=False;
  Self.Close;
end;

procedure TfPromociones.btnAceptarClick(Sender: TObject);
begin
   //  Comprobamos que no exista otra promoción con los mismos datos
  dbTrabajo.Active:=False;
  dbTrabajo.SQL.Text:='SELECT * FROM promo'+Tienda+' WHERE '+
                      'P0="'+Edit1.Text+'" and '+
                      'P1="'+Edit2.Text+'" and '+
                      'P5="'+FormatDateTime('YYYY-MM-DD',StrToDate(Edit3.text))+'" and '+
                      'P6="'+FormatDateTime('YYYY-MM-DD',StrToDate(Edit7.text))+'"';

{dbTrabajo.SQL.Text:='SELECT * FROM promo'+Tienda+' WHERE '+
                      'P0="'+Edit1.Text+'" and P10=''A'' '; }
  dbTrabajo.Active:=True;

  if dbTrabajo.RecordCount<>0 then
   begin
    showmessage(' Ya existe esa promoción, REACTIVANDO ... ' );
    dbTrabajo.Edit;
    dbTrabajo.FieldByName('P10').AsString:='A';
    dbTrabajo.Post;
    Exit
   end;
  if Operacion='A' then
     dbPromo.Append
  else
     dbPromo.Edit;
  LlenaReg();
  dbPromo.Post;
  dbgDatos.Refresh;
  Operacion:='A';
  LimpiaPanel();
  Edit1.SetFocus;
end;

procedure TfPromociones.btnBorrarClick(Sender: TObject);
begin
  if dbPromo.RecordCount=0 then exit;
  if Application.MessageBox('¿DESEA BORRAR LA PROMOCION SELECCIONADA?',
     'FacturLinEx',
     MB_ICONQUESTION + MB_YESNO) = idYes then dbPromo.Delete;
end;

procedure TfPromociones.btnBuscarClick(Sender: TObject);
begin
  Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT A0, A1 FROM artitien'+Tienda+
                  ' WHERE A1 LIKE "%'+Edit2.Text+'%"', ['Código','Referencia'],'A0');
  if Edit1.Text='-1' then begin
     Edit1.Text:='';
     LimpiaPanel();
     Edit1.SetFocus;
  end else begin
      Edit1Exit(Edit1);
      Edit3.SetFocus;
  end;
end;

procedure TfPromociones.btnCancelarClick(Sender: TObject);
begin
  DesactivarPanel;
  Operacion:=' ';
end;

procedure TfPromociones.btnCrearClick(Sender: TObject);
begin
  Operacion:='A';
  LimpiaPanel();
  ActivarPanel;
  Edit1.SetFocus;
end;

procedure TfPromociones.btnModificarClick(Sender: TObject);
begin
  if dbPromo.RecordCount=0 then exit;
  Operacion:='M';
  Relleno();
  ActivarPanel;
  Edit1.SetFocus;
end;

procedure TfPromociones.Edit1Exit(Sender: TObject);
begin
  if Edit1.Text='' then exit;
  if Edit3.Text<>Edit7.Text then exit;
//-- Si se activa esta función, da problemas con las altas al no recuperar los datos  if dbPromo.RecordCount<>0 then exit;
  if dbArti.Locate('A0', Edit1.Text, []) then begin
     Edit2.Text:=dbArti.FieldByName('A1').AsString;
     Edit3.Text:=FormatDateTime('DD/MM/YYYY',Date);
     Edit4.Text:=dbArti.FieldByName('A2').AsString;
     Edit5.Text:=dbArti.FieldByName('A24').AsString;
     Edit6.Text:=dbArti.FieldByName('A3').AsString;
     Edit7.Text:=FormatDateTime('DD/MM/YYYY',Date);
     Edit8.Text:=dbArti.FieldByName('A2').AsString;
     Edit9.Text:=dbArti.FieldByName('A24').AsString;
     Edit10.Text:=dbArti.FieldByName('A3').AsString;
     Edit3.SetFocus;
  end else begin
     ShowMessage('ARTICULO NO ENCONTRADO');
     Edit1.SetFocus;
  end;
end;

procedure TfPromociones.Edit2KeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then btnBuscarClick(Sender);
end;

procedure TfPromociones.LimpiaPanel();
begin
  Edit1.Text:='';   Edit2.Text:='';   Edit3.Text:='';
  Edit4.Text:='';   Edit5.Text:='';   Edit6.Text:='';
  Edit7.Text:='';   Edit8.Text:='';   Edit9.Text:='';
  Edit10.Text:='';
end;

procedure TfPromociones.LlenaReg();
begin
  dbPromo.FieldByName('P0').AsString:=Edit1.Text;  //------ Codigo Articulo
  dbPromo.FieldByName('P1').AsString:=Edit2.Text;  //------ Descripcion
  dbPromo.FieldByName('P2').AsString:=Edit8.Text;  //------ PVP actual (para cuando acabe la oferta)
  dbPromo.FieldByName('P3').AsString:=Edit9.Text;  //------ PV Coste actual (para cuando se acabe la oferta)
  dbPromo.FieldByName('P4').AsString:=Edit10.Text; //------ IVA actual (para cuando se acabe la oferta)
  dbPromo.FieldByName('P5').AsString:=Edit3.Text;  //------ Fecha Inicio Oferta
  dbPromo.FieldByName('P6').AsString:=Edit7.Text;  //------ Fecha Fin Oferta
  dbPromo.FieldByName('P7').AsString:=Edit4.Text;  //------ PVP Oferta
  dbPromo.FieldByName('P8').AsString:=Edit5.Text;  //------ PV Coste Oferta
  dbPromo.FieldByName('P9').AsString:=Edit6.Text;  //------ IVA Oferta
  dbPromo.FieldByName('P10').AsString:='A'         //------ Inicialmente la Oferta está (A)ctiva

end;

procedure TfPromociones.Relleno();
begin
  if dbPromo.RecordCount=0 then exit;
  Edit1.Text:=dbPromo.FieldByName('P0').AsString;  //------ Codigo Articulo
  Edit2.Text:=dbPromo.FieldByName('P1').AsString;  //------ Descripcion
  Edit8.Text:=dbPromo.FieldByName('P2').AsString;  //------ PVP actual (para cuando acabe la oferta)
  Edit9.Text:=dbPromo.FieldByName('P3').AsString;  //------ PV Coste actual (para cuando se acabe la oferta)
  Edit10.Text:=dbPromo.FieldByName('P4').AsString; //------ IVA actual (para cuando se acabe la oferta)
  Edit3.Text:=dbPromo.FieldByName('P5').AsString;  //------ Fecha Inicio Oferta
  Edit7.Text:=dbPromo.FieldByName('P6').AsString;  //------ Fecha Fin Oferta
  Edit4.Text:=dbPromo.FieldByName('P7').AsString;  //------ PVP Oferta
  Edit5.Text:=dbPromo.FieldByName('P8').AsString;  //------ PV Coste Oferta
  Edit6.Text:=dbPromo.FieldByName('P9').AsString;  //------ IVA Oferta
end;

initialization
  {$I promociones.lrs}

end.

