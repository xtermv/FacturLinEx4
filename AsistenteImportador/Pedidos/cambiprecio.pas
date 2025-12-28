{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2009, Nicolas Lopez de Lerma Aymerich

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

unit CambiPrecio;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, ZConnection, ZDataset, Buttons;

type

  { TFCambiPrecio }

  TFCambiPrecio = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    BitBtn30: TBitBtn;
    BitBtn31: TBitBtn;
    cbFCosto: TCheckBox;
    cbPIva: TCheckBox;
    cbPPrecio: TCheckBox;
    cbPMargen: TCheckBox;
    cbPCosto: TCheckBox;
    cbPDescripcion: TCheckBox;
    cbFMargen: TCheckBox;
    cbFPrecio: TCheckBox;
    cbFIva: TCheckBox;
    cbFRec: TCheckBox;
    cbFPvp: TCheckBox;
    cbFDescripcion: TCheckBox;
    cbPPvp: TCheckBox;
    cbPRec: TCheckBox;
    cbTodas: TCheckBox;
    cbAuto: TCheckBox;
    dbCambios: TZQuery;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    PanelAvisoAutomatizacion: TPanel;
    StaticText1: TStaticText;
    StaticText12: TStaticText;
    StaticText13: TStaticText;
    StaticText14: TStaticText;
    StaticText15: TStaticText;
    StaticText16: TStaticText;
    StaticText17: TStaticText;
    dbConnect: TZConnection;
    dbPedid: TZQuery;
    dbArti: TZQuery;
    Timer1: TTimer;
    procedure BitBtn30Click(Sender: TObject);
    procedure BitBtn31Click(Sender: TObject);
    procedure cbAutoClick(Sender: TObject);
    procedure cbFCostoClick(Sender: TObject);
    procedure CambiaSeleccion(cbCambia: TCheckBox; cbpareja: TCheckBox);
    procedure cbTodasClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SeleccionaFicha();
    procedure SeleccionInversa();
    procedure cbFDescripcionClick(Sender: TObject);
    procedure cbFIvaClick(Sender: TObject);
    procedure cbFMargenClick(Sender: TObject);
    procedure cbFPrecioClick(Sender: TObject);
    procedure cbFPvpClick(Sender: TObject);
    procedure cbFRecClick(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure Edit4Exit(Sender: TObject);
    procedure Edit5Exit(Sender: TObject);
    procedure Edit6Exit(Sender: TObject);
    procedure Edit7Exit(Sender: TObject);
    procedure Edit8Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure PintaArticulo();
    procedure Timer1StartTimer(Sender: TObject);
    procedure Timer1StopTimer(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end;

  procedure ShowCambioPrecio(CpTienda,Proveedor,Numero,Linea: Integer; Fecha: TdateTime; Codigo,Serie: string);

var
  FCambiPrecio: TFCambiPrecio;
  PasaCodigo,PasaSerie: String;
  PasaTienda,PasaProveedor,PasaNumero,PasaLinea: Integer;
  PasaFecha: TdateTime;

  segundos: Integer;

implementation

{ TFCambiPrecio }

uses
  Global, Funciones, entrada;

//===================== CREAR EL FORMULARIO =====================
procedure ShowCambioPrecio(CpTienda,Proveedor,Numero,Linea: Integer; Fecha: TdateTime; Codigo,Serie: string);
begin
  PasaCodigo:=Codigo; PasaSerie:=Serie; PasaTienda:=CpTienda;
  PasaProveedor:=Proveedor; PasaNumero:=Numero; PasaLinea:=Linea;
  PasaFecha:=Fecha;
  with TFCambiPrecio.Create(Application) do
    begin
       ShowModal;
    end;
end;
procedure TFCambiPrecio.FormCreate(Sender: TObject);
begin
  //--------- Conectar con la bbdd
  Conectate(dbConnect);
  //--------- Pedido
  dbPedid.SQL.Text:='SELECT * FROM pedidd'+Tienda+' WHERE PD0='+IntToStr(PasaTienda)+' AND '+
                    'PD1="'+FormatDateTime('YYYY/MM/DD',PasaFecha)+'" AND '+
                    'PD2='+IntToStr(PasaProveedor)+' AND PD3="'+PasaSerie+'" AND '+
                    'PD4='+IntToStr(PasaNumero)+' AND PD5='+IntToStr(PasaLinea);
  dbPedid.Active:=True;
  //---------- Activamos checkbox por defecto para la actualizacion
  SeleccionaFicha();

  //--------- Articulo
  Edit1.Text:=PasaCodigo;//-------- Codigo que se pasa desde la entrada
  dbArti.Active:=False;
  dbArti.SQL.Text:='SELECT * FROM artitien'+Tienda+' WHERE A0="'+Edit1.Text+'"';
  dbArti.Active:=True;
  if dbArti.RecordCount=0 then begin showmessage('SE HA BORRADO EL ARTICULO'); Exit; end;
  PintaArticulo();//--- Pintar datos articulos

end;

procedure TFCambiPrecio.FormShow(Sender: TObject);
begin
  if SeleccionAutomatica = true then BitBtn30Click(self);
end;


//======================== CERRAR EL FORMULARIO ====================
procedure TFCambiPrecio.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
    cbDescripcionP:= cbPDescripcion.Checked;
    cbCostoP:= cbPCosto.Checked;
    cbMargenP:= cbPMargen.Checked;
    cbPrecioP:= cbPPrecio.Checked;
    cbIvaP:= cbPIva.Checked;
    cbRecP:= cbPRec.Checked;
    cbPvpP:= cbPPvp.Checked;
    cbDescripcionF:= cbFDescripcion.Checked;
    cbCostoF:= cbFCosto.Checked;
    cbMargenF:= cbFMargen.Checked;
    cbPrecioF:= cbFPrecio.Checked;
    cbIvaF:= cbFIva.Checked;
    cbRecF:= cbFRec.Checked;
    cbPvpF:= cbFPvp.Checked;

    CloseAction:=caFree;
end;

//=============== ACEPTAR DATOS NUEVOS ===================
procedure TFCambiPrecio.BitBtn30Click(Sender: TObject);
begin
  dbArti.Edit;
  if cbPDescripcion.Checked then dbArti.FieldByName('A1').AsString:=Edit2.Text;//----- Descripción.
  if (cbPCosto.Checked) and (StrToFloat(Edit3.Text)<>0) then dbArti.FieldByName('A24').AsString:=Edit3.Text;//---- Costo Pedido
  if cbPMargen.Checked then dbArti.FieldByName('A26').AsString:=Edit4.Text;//---- Margen Pedido
  if cbPPrecio.Checked then dbArti.FieldByName('A21').AsString:=Edit5.Text;//---- Precio Pedido
  if cbPIva.Checked then dbArti.FieldByName('A3').AsString:=Edit6.Text;//---- % Iva Pedido
  if cbPRec.Checked then dbArti.FieldByName('A36').AsString:=Edit7.Text;//---- % Recargo Pedido

  if cbPPvp.Checked then dbArti.FieldByName('A2').AsString:=Edit8.Text;//---- P.V.P. Pedido
  dbArti.Post;
  //------------------- Etiquetas lineales si cambia el precio
  dbCambios.Active:=False;
  dbCambios.SQL.Text:='SELECT * FROM cambios WHERE CA0="'+dbArti.FieldByName('A0').AsString+'"';
  dbCambios.Active:=True;
  if dbCambios.RecordCount=0 then dbCambios.Append else dbCambios.Edit;
  dbCambios.FieldByName('CA0').AsString:=dbArti.FieldByName('A0').AsString;
  dbCambios.FieldByName('CA1').AsString:=dbArti.FieldByName('A1').AsString;
  dbCambios.FieldByName('CA2').AsString:=dbArti.FieldByName('A2').AsString;
  dbCambios.Post;
  Close();
end;

//=============== QUEDAR DATOS DE LA FICHA ===================
procedure TFCambiPrecio.BitBtn31Click(Sender: TObject);
begin
  SeleccionInversa();
end;

//=============   SELECCIONES DE LOS CHECKBOX PARA LA ACTUALIZACION
procedure TFCambiPrecio.cbFDescripcionClicK(Sender: TObject);
begin
 if cbFDescripcion.Focused=True then CambiaSeleccion( cbFDescripcion, cbPDescripcion )
                                else CambiaSeleccion( cbPDescripcion, cbFDescripcion );

end;

procedure TFCambiPrecio.cbFCostoClick(Sender: TObject);
begin
 if cbFCosto.Focused=True then CambiaSeleccion( cbFCosto, cbPCosto)
                                else CambiaSeleccion( cbPCosto, cbFCosto);

end;

procedure TFCambiPrecio.cbFIvaClick(Sender: TObject);
begin
 if cbFIva.Focused=True then CambiaSeleccion( cbFIva, cbPIva)
                                else CambiaSeleccion( cbPIva, cbFIva );

end;

procedure TFCambiPrecio.cbFMargenClick(Sender: TObject);
begin
 if cbFMargen.Focused=True then CambiaSeleccion( cbFMargen, cbPMargen)
                                else CambiaSeleccion( cbPMargen, cbFMargen );
end;

procedure TFCambiPrecio.cbFPrecioClick(Sender: TObject);
begin
 if cbFPrecio.Focused=True then CambiaSeleccion( cbFPrecio, cbPPrecio)
                                else CambiaSeleccion( cbPPrecio, cbFPrecio );
end;

procedure TFCambiPrecio.cbFPvpClick(Sender: TObject);
begin
 if cbFPvp.Focused=True then CambiaSeleccion( cbFPvp, cbPPvp)
                                else CambiaSeleccion( cbPPvp, cbFPvp );
end;

procedure TFCambiPrecio.cbFRecClick(Sender: TObject);
begin
 if cbFRec.Focused=True then CambiaSeleccion( cbFRec, cbPRec)
                                else CambiaSeleccion( cbPRec, cbFRec );
end;

procedure TFCambiPrecio.CambiaSeleccion(cbCambia: TCheckBox; cbPareja: TCheckBox);
begin
  if cbCambia.Checked then cbPareja.Checked:=False else cbPareja.Checked:=True;
end;

procedure TFCambiPrecio.cbTodasClick(Sender: TObject);
begin
  MantenerSeleccion:= cbTodas.Checked;
end;

procedure TFCambiPrecio.cbAutoClick(Sender: TObject);
begin
  SeleccionAutomatica:= cbAuto.Checked;
  if SeleccionAutomatica = True  then
     begin
        segundos:=0;
        Timer1.Enabled:= True;
        PanelAvisoAutomatizacion.Visible:= True;
     end;
end;

procedure TFCambiPrecio.SeleccionaFicha();
begin
  if MantenerSeleccion=True then
  begin
    cbPDescripcion.Checked:= cbDescripcionP;
    cbPCosto.Checked:= cbCostoP;
    cbPMargen.Checked:= cbMargenP;
    cbPPrecio.Checked:= cbPrecioP;
    cbPIva.Checked:= cbIvaP;
    cbPRec.Checked:= cbRecP;
    cbPPvp.Checked:= cbPvpP;
    cbFDescripcion.Checked:= cbDescripcionF;
    cbFCosto.Checked:= cbCostoF;
    cbFMargen.Checked:= cbMargenF;
    cbFPrecio.Checked:= cbPrecioF;
    cbFIva.Checked:= cbIvaF;
    cbFRec.Checked:= cbRecF;
    cbFPvp.Checked:= cbPvpF;
  end else
  begin
    cbPDescripcion.Checked:= True;
    cbPCosto.Checked:= True;
    cbPMargen.Checked:= True;
    cbPPrecio.Checked:= True;
    cbPIva.Checked:= True;
    cbPRec.Checked:= True;
    cbPPvp.Checked:= True;
    cbFDescripcion.Checked:= False;
    cbFCosto.Checked:= False;
    cbFMargen.Checked:= False;
    cbFPrecio.Checked:= False;
    cbFIva.Checked:= False;
    cbFRec.Checked:= False;
    cbFPvp.Checked:= False;
   end;

   cbTodas.Checked:= MantenerSeleccion;
   cbAuto.Checked:= SeleccionAutomatica;

end;

procedure TFCambiPrecio.SeleccionInversa();
begin
if cbPDescripcion.Checked=True then cbPDescripcion.checked:=False else cbPDescripcion.checked:=True;
if cbFDescripcion.Checked=True then cbFDescripcion.checked:=False else cbFDescripcion.checked:=True;
if cbPCosto.Checked=True then cbPCosto.Checked:=False else cbPCosto.Checked:=True;
if cbFCosto.Checked=True then cbFCosto.Checked:=False else cbFCosto.Checked:=True;
if cbPMargen.Checked=True then cbPMargen.Checked:=False else cbPMargen.Checked:=True;
if cbFMargen.Checked=True then cbFMargen.Checked:=False else cbFMargen.Checked:=True;
if cbPPrecio.Checked=True then cbPPrecio.Checked:=False else cbPPrecio.Checked:=True;
if cbFPrecio.Checked=True then cbFPrecio.Checked:=False else cbFPrecio.Checked:=True;
if cbPIva.Checked=True then cbPIva.Checked:=False else cbPIva.Checked:=True;
if cbFIva.Checked=True then cbFIva.Checked:=False else cbFIva.Checked:=True;
if cbPRec.Checked=True then cbPRec.Checked:=False else cbPRec.Checked:=True;
if cbFRec.Checked=True then cbFRec.Checked:=False else cbFRec.Checked:=True;
if cbPPvp.Checked=True then cbPPvp.Checked:=False else cbPPvp.Checked:=True;
if cbFPvp.Checked=True then cbFPvp.Checked:=False else cbFPvp.Checked:=True;

end;

//===================== SALIR DEL COSTO ======================
procedure TFCambiPrecio.Edit3Exit(Sender: TObject);
var
  PrecioCon, Recargo, RecargoCosto: Double;
begin
  if (Edit3.Text='') or (StrToFloat(Edit3.Text)=0) then begin Edit3.Text:='0'; Exit; end;//------ Costo
  if (Edit7.Text='') or (StrToInt(Edit7.Text)=0) then Edit7.Text:='0';
  //---- P.V.P.
  Recargo:=0; RecargoCosto:=0;
  PrecioCon:=(StrToFloat(Edit3.Text)*StrToFloat(Edit4.text)/100)+StrToFloat(Edit3.Text);//-- + Margen
  if StrToInt(Edit7.Text)<>0 then Recargo:=(PrecioCon*StrToInt(Edit7.Text) / 100);//---- + Recargo
  Edit8.Text:=FormatFloat('0.00',((PrecioCon*StrToFloat(Edit6.Text) / 100)+PrecioCon)+Recargo);//---- + IVA
  if StrToInt(Edit7.Text)<>0 then RecargoCosto:=(StrToFloat(Edit3.Text)*StrToInt(Edit7.Text) / 100);//- Recargo
end;

//===================== SALIR DEL MARGEN ======================
procedure TFCambiPrecio.Edit4Exit(Sender: TObject);
var
  PrecioCon, Recargo: Double;
begin
  if (Edit3.Text='') or (StrToFloat(Edit3.Text)=0) then begin Edit3.Text:='0'; Exit; end;//------- Costo
  if (Edit6.Text='') or (StrToFloat(Edit6.Text)=0) then Edit6.Text:='0';//------------------------ IVA
  if (Edit4.Text='') or (StrToFloat(Edit4.Text)=0) then begin Edit4.Text:='0'; Exit; end;//---- Margen
  if (Edit7.Text='') or (StrToInt(Edit7.Text)=0) then Edit7.Text:='0';
  //---- P.V.P.
  Recargo:=0; PrecioCon:=0;
  PrecioCon:=(StrToFloat(Edit3.Text)*StrToFloat(Edit4.Text)/100)+StrToFloat(Edit3.Text);//-- + Margen
  Edit5.Text:=FormatFloat('0.0000',PrecioCon);//-------- Precio sin iva
  if (StrToInt(Edit7.Text)<>0) then Recargo:=(PrecioCon*StrToInt(Edit7.Text) / 100);//---- + Recargo
  if (StrToFloat(Edit6.Text)<>0) Then Edit8.Text:=FormatFloat('0.00',((PrecioCon*StrToFloat(Edit6.Text) / 100)+PrecioCon)+Recargo);//---- + IVA
end;

//=========== SALIR DEL PRECIO SIN IVA (COSTO+MARGEN) ==========
procedure TFCambiPrecio.Edit5Exit(Sender: TObject);
var
  PvpSinIva, Margen, CostoCero, PrecioCon: double;
begin
  if (Edit5.Text='') or (StrToFloat(Edit5.Text)=0) then exit;
  //---------- Calcular margen sobre el pvp
  if (Edit3.Text <> '') and (StrToFloat(Edit3.Text)<>0) then
    begin
      PvpSinIva := StrToFloat(Edit5.text);
      Margen := (PvpSinIva - StrToFloat(Edit3.Text)) * 100 / StrToFloat(Edit3.Text);
      Edit4.Text := FormatFloat('0.000',Margen);
    end
  else
    begin
      //------- Calcular costo cuando es 0
      if (Edit4.Text<>'') and (StrToFloat(Edit4.Text)<>0) then
       begin
        CostoCero := (100 * StrToFloat(Edit5.text)) / (100 + StrToFloat(Edit4.Text));
        Edit3.Text:=FormatFloat('0.000',CostoCero); Edit3Exit(Edit3);
       end;
    end;
   //------ Calcular precio con iva si hay iva ---------
   if (StrToFloat(Edit6.Text)<>0) and (Edit6.Text<>'') then
     begin
       PrecioCon:=(StrToFloat(Edit5.Text) * StrToFloat(Edit6.Text) / 100) +
                   StrToFloat(Edit5.Text); //--- Sumar el IVA
       Edit8.Text:=FormatFloat('0.00',PrecioCon);
     end;
end;

//===================== SALIR DEL IVA ======================
procedure TFCambiPrecio.Edit6Exit(Sender: TObject);
var
  PrecioCon, Recargo, RecargoCosto: Double;
begin
  if (Edit3.Text='') or (StrToFloat(Edit3.Text)=0) then begin Edit3.Text:='0'; Exit; end;//------ Costo
  if (Edit6.Text='') or (StrToFloat(Edit6.Text)=0) then begin Edit6.Text:='0'; Exit; end;//------ IVA
  if (Edit7.Text='') or (StrToInt(Edit7.Text)=0) then Edit7.Text:='0';
  //---- P.V.P.
  Recargo:=0; RecargoCosto:=0;
  PrecioCon:=(StrToFloat(Edit3.Text)*StrToFloat(Edit4.Text)/100)+StrToFloat(Edit3.Text);//-- + Margen
  if (StrToInt(Edit7.Text)<>0) then Recargo:=(PrecioCon*StrToInt(Edit7.Text) / 100);//---- + Recargo
  Edit8.Text:=FormatFloat('0.00',((PrecioCon*StrToFloat(Edit6.Text) / 100)+PrecioCon)+Recargo);//---- + IVA
  if (StrToInt(Edit7.Text)<>0) then RecargoCosto:=(StrToFloat(Edit3.Text)*StrToInt(Edit7.Text) / 100);//- Recargo
end;

//===================== SALIR DEL RECARGO ======================
procedure TFCambiPrecio.Edit7Exit(Sender: TObject);
var
  PrecioCon, Recargo, RecargoCosto: Double;
begin
  if (Edit3.Text='') or (StrToFloat(Edit3.Text)=0) then begin Edit3.Text:='0'; Exit; end;//------ Costo
  if (Edit7.Text='') or (StrToInt(Edit7.Text)=0) then Edit7.Text:='0';
  //---- P.V.P.
  Recargo:=0; RecargoCosto:=0;
  PrecioCon:=(StrToFloat(Edit3.Text)*StrToFloat(Edit4.Text)/100)+StrToFloat(Edit3.Text);//-- + Margen
  if (StrToInt(Edit7.Text)<>0) then Recargo:=(PrecioCon*StrToInt(Edit7.Text) / 100);//---- + Recargo
  Edit8.Text:=FormatFloat('0.00',((PrecioCon*StrToFloat(Edit6.Text) / 100)+PrecioCon)+Recargo);//---- + IVA + Recargo
  if (StrToInt(Edit7.Text)<>0) then RecargoCosto:=(StrToFloat(Edit3.Text)*StrToInt(Edit7.Text) / 100);//- Recargo
end;

//===================== SALIR DEL PVP ======================
procedure TFCambiPrecio.Edit8Exit(Sender: TObject);
var
  PvpSinIVA, Margen : Double;
begin
  //---------- Calcular precio sin iva
  PvpSinIva := (100 * StrToFloat(Edit8.text)) / (100 + StrToFloat(Edit6.Text)+ StrToInt(Edit7.Text));
  //---------- Calcular margen sobre el pvp
  if (Edit3.Text <> '') and (StrToFloat(Edit3.Text)<>0) then
    begin
      Margen := (PvpSinIva - StrToFloat(Edit3.Text)) * 100 / StrToFloat(Edit3.Text);
      Edit4.Text := FormatFloat('0.000',Margen);
      Edit4Exit(Edit4);
    end
end;

//==================== PINTAR DATOS PASADOS =================
procedure TFCambiPrecio.PintaArticulo();
begin
  Edit2.Text:=dbPedid.FieldByName('PD7').AsString;//------ Descripcion
  StaticText1.Caption:=dbArti.FieldByName('A1').AsString;
  if Edit2.Text<>StaticText1.Caption then StaticText1.Color:=$00C5C5F7;

  Edit3.Text:=FormatFloat('0.00',dbPedid.FieldByName('PD10').AsFloat);//---- Costo Pedido
  StaticText12.Caption:=FormatFloat('0.00',dbArti.FieldByName('A24').AsFloat);//----- Costo Articulo
  if Edit3.Text<>StaticText12.Caption then StaticText12.Color:=$00C5C5F7;

  Edit4.Text:=FormatFloat('0.00',dbPedid.FieldByName('PD11').AsFloat);//---- Margen Pedido
  StaticText13.Caption:=FormatFloat('0.00',dbArti.FieldByName('A26').AsFloat);//----- Margen Articulo
  if Edit4.Text<>StaticText13.Caption then StaticText13.Color:=$00C5C5F7;

  Edit5.Text:=FormatFloat('0.00',dbPedid.FieldByName('PD12').AsFloat);//---- Precio Pedido
  StaticText14.Caption:=FormatFloat('0.00',dbArti.FieldByName('A21').AsFloat);//----- Precio Articulo
  if Edit5.Text<>StaticText14.Caption then StaticText14.Color:=$00C5C5F7;

  Edit6.Text:=IntToStr(dbPedid.FieldByName('PD14').AsInteger);//---- % Iva Pedido
  StaticText15.Caption:=IntToStr(dbArti.FieldByName('A3').AsInteger);//------ % Iva Articulo
  if Edit6.Text<>StaticText15.Caption then StaticText15.Color:=$00C5C5F7;

  Edit7.Text:=IntToStr(dbPedid.FieldByName('PD13').AsInteger);//---- % Rec Pedido
  StaticText16.Caption:=IntToStr(dbArti.FieldByName('A36').AsInteger);//------- % Rec Articulo
  if Edit7.Text<>StaticText16.Caption then StaticText16.Color:=$00C5C5F7;

  Edit8.Text:=FormatFloat('0.00',dbPedid.FieldByName('PD16').AsFloat);//---- P.V.P. Pedido
  StaticText17.Caption:=FormatFloat('0.00',dbArti.FieldByName('A2').AsFloat);//------- P.V.P. Articulo
  if Edit8.Text<>StaticText17.Caption then StaticText17.Color:=$00C5C5F7;

end;

procedure TFCambiPrecio.Timer1StartTimer(Sender: TObject);
begin
  segundos := segundos + 1;
  if segundos = 3 then Timer1.Enabled:= False;
end;

procedure TFCambiPrecio.Timer1StopTimer(Sender: TObject);
begin
  Timer1.Enabled:= False;
  PanelAvisoAutomatizacion.Visible:= False;
end;

initialization
  {$I cambiprecio.lrs}

end.

