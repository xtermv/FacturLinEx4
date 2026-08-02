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
  { add your units here }, Menu, uVFQueueMonitor, uVeriFactuHTTPSender,
  uVFServer, uVeriHash, uVF_HashChain, uVF_Integration, uVeriChain,
  uVeriChainCheck, uVF_QueueResult, fn_mysql, fn_cadenas, copiaseg,
  copiasegauto, uBackupUnpackHelper, uFLXRestoreRemote, listaclientes, Factura,
  puestos, zcomponent, listatiendas, lazreport, TAChartLazarusPkg, Series,
  Envases, config, uFLX_CryptoIni, Global, Familias, Departamentos, FormaPago,
  Rutas, Fabricantes, listausuarios, Usuarios, historicoop, gestionar,
  uFLXTemaVisual,
  actualizaeans, ivaEmi, ivaReci, listaproveedores, Proveedores, Funciones,
  acaja, pagos, listafamilias, listapuestos, calculadora, teclado, Imprimir,
  entrada, CambiPrecio, importar, facturaped, Tiendas, listadepartamentos,
  creditos, facturar, lineales, EtiEans, histopedi, actualizapedi,
  listaarticulos, articulos, promociones, ActAutArt, uPromoEngine, enviopedidos,
  about, roles, Produccion, Presupuestos, Albaran, histoAlba, histofaprov,
  Ventas, uVeriFactu, Clientes, FAStock, etilineales, envioarti, envioclientes,
  actualizaarti, calculos, Mensajes, uFLX_Log, uFacturaE_Signer, Modelo347,
  uVeriSIFForm, uFLXPermisos, uFLXManualViewer;

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

