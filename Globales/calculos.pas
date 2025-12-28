unit calculos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, Forms, StdCtrls;

var
 TotalLinea, CantidadLinea, PrecioConIva, PrecioSinIva,
 IvaLinea, DescuentoLinea, TotalSinIvaLinea : Double;

 procedure SalirCantidad(sender: TObject);
 procedure SalirPrecio(sender: TObject);
 procedure SalirPrecioSinIva(sender: TObject);
 procedure SalirDescuento(sender: TObject);
 procedure SalirIva(sender: TObject);

implementation

uses
  Funciones;


//===================== SALIR DE LA CANTIDAD ======================
procedure SalirCantidad(Sender: TObject);
begin

  TotalLinea:= CantidadLinea * PrecioConIva;

  //------- Calcular importe con descuento
  if DescuentoLinea<>0 then TotalLinea:= TotalLinea - (TotalLinea * DescuentoLinea)/100 ;
  TotalSinIvaLinea:= TotalLinea;

  //------- Calcular Total sin iva
  if IvaLinea<>0 then TotalSinIvaLinea:=TotalLinea/(1+(IvaLinea/100));

end;


//======================= SALIR DEL PRECIO ==================

procedure SalirPrecio(Sender: TObject);
begin

//---------- Calcular precios
  PrecioSinIva := PrecioConIva / (1+ IvaLinea/100);

  //-----
  TotalLinea:= CantidadLinea*PrecioConIva;//--- Importe Total

  //------- Calcular importe con descuento
  if DescuentoLinea<>0 then TotalLinea:=TotalLinea - (TotalLinea*DescuentoLinea)/100;//---- Importe total con DTO

  TotalSinIvaLinea:=TotalLinea;//---- importe

  //------- Calcular Total sin iva
  if IvaLinea<>0 then TotalSinIvaLinea:=TotalLinea/(1+(IvaLinea/100));

end;

//======================= SALIR DEL PRECIO ========================
procedure SalirPrecioSinIva(Sender: TObject);
begin

  //---- P.V.P.
  PrecioConIva:=PrecioSinIva*(1+(IvaLinea/100));//---- + IVA
  //----
  TotalLinea:=CantidadLinea*PrecioConIva;//--- Importe Total
  TotalSinIvaLinea:=CantidadLinea*PrecioSinIva;//--- Importe

   //------- Calcular importe con descuento
  if DescuentoLinea<>0 then TotalLinea:=TotalLinea - (TotalLinea * DescuentoLinea/100);//---- Importe total con DTO

  TotalSinIvaLinea:=TotalLinea;//---- importe

  //------- Calcular Total sin iva
  if Ivalinea<>0 then TotalSinIvaLinea:=TotalLinea/(1+IvaLinea/100);

end;

//======================= SALIR DEL DTO =============================
procedure SalirDescuento(Sender: TObject);
begin

  TotalLinea:=CantidadLinea*PrecioConIva;//--- Importe Total

  //------- Calcular importe con descuento
  if DescuentoLinea<>0 then TotalLinea:=TotalLinea -(TotalLinea*DescuentoLinea/100);//---- Importe total con DTO

  TotalSinIvaLinea:=TotalLinea;//---- Total sin iva

  //------- Calcular Total sin iva
  if IvaLinea<>0 then
    begin
      TotalSinIvaLinea:=TotalLinea/(1+IvaLinea/100);
    end;

end;

//======================= SALIR DEL IVA ==============================
procedure SalirIva(Sender: TObject);
begin

  //---- P.V.P.
  PrecioConIva:=PrecioSinIva*(1+IvaLinea/100);//---- + IVA
  //-----
  TotalLinea:=CantidadLinea*PrecioConIva;//---- Total

   //------- Calcular importe con descuento
  if DescuentoLinea<>0 then TotalLinea:= TotalLinea-(TotalLinea*DescuentoLinea)/100;//---- Importe total con DTO

  TotalSinIvaLinea:=TotalLinea;//---- Total sin iva


  //------- Calcular Total sin iva
  if IvaLinea<>0 then TotalSinIvaLinea:=TotalLinea /(1+ IvaLinea/100);

end;

end.



