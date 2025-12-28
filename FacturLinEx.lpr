program FacturLinEx;

{$mode objfpc}{$H+}

{$IFDEF UNIX}
  {$DEFINE UseCThreads}
{$ENDIF}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, LResources
  { add your units here }, Menu, uVeriFactuHTTPSender, uVFServer, uVeriHash,
  uVF_HashChain, uVF_Sender, uVF_Integration, uVeriChain, uVeriChainCheck,
  uVF_QueueResult, fn_mysql, fn_cadenas, copiaseg, copiasegauto, listaclientes,
  Factura, puestos, zcomponent, listatiendas, lazreport, TAChartLazarusPkg,
  Series, Envases, config, Global, Familias, Departamentos, FormaPago, Rutas,
  Fabricantes, listausuarios, Usuarios, historicoop, gestionar, actualizaeans,
  ivaEmi, ivaReci, listaproveedores, Proveedores, Funciones, acaja, pagos,
  listafamilias, listapuestos, calculadora, teclado, Imprimir, entrada,
  CambiPrecio, importar, facturaped, Tiendas, listadepartamentos, creditos,
  facturar, lineales, EtiEans, histopedi, actualizapedi, listaarticulos,
  articulos, promociones, ActAutArt, enviopedidos, about, roles, Produccion,
  Presupuestos, Albaran, histoAlba, histofaprov, Ventas, uVeriFactu, Clientes,
  FAStock, etilineales, envioarti, envioclientes, actualizaarti, calculos,
  Mensajes, uFLX_Log, uFacturaE_Signer, Modelo347, uVeriSIFForm;

{$R *.res}


begin
  {$I FacturLinEx.lrs}
  RequireDerivedFormResource := True;
  Application.Scaled:=True;
  Application.Title:='FacturLinEx 2';
  Application.Initialize;
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TFmenu, Fmenu);
  Application.Run;
end.

