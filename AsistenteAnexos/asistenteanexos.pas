unit AsistenteAnexos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DBGrids, ZDataset, ZConnection,
  Inifiles, Process, LCLType;

type

  { TFormAsistenteAnexos }

  TFormAsistenteAnexos = class(TForm)
    bitBtnConfiguracion: TBitBtn;
    bitBtnScaner: TBitBtn;
    BitBtnApSc: TBitBtn;
    BitBtnBorrar: TBitBtn;
    BitBtnCerrar: TBitBtn;
    BitBtnGuardarConf: TBitBtn;
    BitBtnModificar: TBitBtn;
    BitBtnNuevo: TBitBtn;
    BitBtnRuImSc: TBitBtn;
    BitBtnSalir: TBitBtn;
    BitBtnSalirConf: TBitBtn;
    BitBtnSeleccionar: TBitBtn;
    DatasourceAnexos: TDatasource;
    DatasourceSeleccion: TDatasource;
    dbAnexos: TZQuery;
    dbConect: TZConnection;
    DBGridAnexados: TDBGrid;
    DBGridNodoAlbaran: TDBGrid;
    DBGridNodoArticulo: TDBGrid;
    DBGridNodoFactura: TDBGrid;
    DBGridNodoRuta: TDBGrid;
    dbSeleccion: TZQuery;
    dbTrabajo: TZQuery;
    EditApliScaner: TEdit;
    EditRutaImagenesScaner: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabelRev: TLabel;
    Label6: TLabel;
    LabelAnexados: TLabel;
    LabelApSc: TLabel;
    LabelNodo: TLabel;
    LabelRuImSc: TLabel;
    OpenDialogApliSc: TOpenDialog;
    OpenDialogSeleccion: TOpenDialog;
    Panel1: TPanel;
    PanelAnexos: TPanel;
    PanelConfiguracion: TPanel;
    PanelDBNodos: TPanel;
    PanelSeleccionNodo: TPanel;
    PanelTipoNodo: TPanel;
    RadioButtonAlbaranes: TRadioButton;
    RadioButtonArticulos: TRadioButton;
    RadioButtonFacturas: TRadioButton;
    RadioButtonRutas: TRadioButton;
    rgTipoNodo: TRadioGroup;
    SelectDirectoryDialogRuImSc: TSelectDirectoryDialog;

    procedure bitBtnConfiguracionClick(Sender: TObject);
    procedure BitBtnApScClick(Sender: TObject);
    procedure BitBtnBorrarClick(Sender: TObject);
    procedure BitBtnGuardarConfClick(Sender: TObject);
    procedure BitBtnModificarClick(Sender: TObject);
    procedure BitBtnNuevoClick(Sender: TObject);
    procedure BitBtnRuImScClick(Sender: TObject);
    procedure BitBtnSalirClick(Sender: TObject);
    procedure BitBtnSalirConfClick(Sender: TObject);
    procedure bitBtnScanerClick(Sender: TObject);
    procedure BitBtnSeleccionarClick(Sender: TObject);
    procedure DBGridAnexadosDblClick(Sender: TObject);
    procedure DBGridNodoDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Inicia();
    procedure CargaQuerys();
    procedure CargaGridNodo();
    procedure CargaGridAnexo();
    procedure AccionNodo();
    procedure CargarDatosNodo();
    function NumeroDocAnexo(): integer;
    function GeneraKeyDelNodo():string;
    procedure GuardarIni();
    procedure RadioButtonChange(Sender: TObject);
    procedure OcultarBDGrid();
    procedure DimensionarColocarBDGrid();
    procedure BitBtnCerrarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FormAsistenteAnexos: TFormAsistenteAnexos;
  IniReader : TIniFile;
  Sections : TStringList;
  Contents : TStringList;
  RutaImagenesScaner: String;
  ApliScaner: String;
  RutaDocumento: String;
  TxtQueryNodos: string;
  TxtQueryTrabajo: string;
  FileTemporal: String;
  ExisteConfig: Boolean;
  tipo: String;
  camposKey: integer;
  tablaNodo: String;

  accion: string;

implementation

{ TFormAsistenteAnexos }

uses
   funciones, global;

//=========================== CREAR FORMULARIO ======================
procedure TFormAsistenteAnexos.FormCreate(Sender: TObject);
begin
  bitBtnScaner.Enabled:=False;
  Inicia();
  LabelRev.Caption := 'Rev. 3';
  PanelSeleccionNodo.Visible:=False;
  PanelConfiguracion.Visible:=False;
 //  PanelTipoNodo.Visible:=True;
  DimensionarColocarBDGrid();
  OcultarBDGrid();
end;

procedure TFormAsistenteAnexos.BitBtnNuevoClick(Sender: TObject);
begin
  accion:='anadir';
  AccionNodo();
end;

procedure TFormAsistenteAnexos.BitBtnRuImScClick(Sender: TObject);
begin
  if SelectDirectoryDialogRuimSc.Execute then
   begin
     SelectDirectoryDialogRuimSc.Title:='Seleccione la carpeta para las imágenes del scaner';
     EditRutaImagenesScaner.Text:=SelectDirectoryDialogRuimSc.FileName;
   end;
end;

procedure TFormAsistenteAnexos.BitBtnSalirClick(Sender: TObject);
begin
  PanelSeleccionNodo.Visible:=False;
end;

procedure TFormAsistenteAnexos.BitBtnSalirConfClick(Sender: TObject);
begin
  PanelConfiguracion.Visible:=False;
end;

procedure TFormAsistenteAnexos.bitBtnScanerClick(Sender: TObject);
begin
    if ApliScaner = '' then
    begin
      Showmessage('NO HAY NINGUNA APLICACIÓN DEFINIDA PARA LA UTILIZACIÓN DEL SCANER');
      PanelConfiguracion.Visible:=True;
      exit;
    end
  else
    begin
      showmessage('La ruta definida para guardar las imagenes del Scaner es '+RutaImagenesScaner);
      AProcess := TProcess.Create(nil);
      AProcess.CommandLine:= ApliScaner;
    end;
  AProcess.Execute;
  AProcess.Free;
end;

procedure TFormAsistenteAnexos.BitBtnSeleccionarClick(Sender: TObject);
begin
  If dbSeleccion.RecordCount=0 then Begin Showmessage('NO HAY NADA QUE SELECCIONAR'); Exit; End;
  CargarDatosNodo();
end;

procedure TFormAsistenteAnexos.DBGridAnexadosDblClick(Sender: TObject);
begin
  accion:='modificar';
  AccionNodo();
end;

procedure TFormAsistenteAnexos.DBGridNodoDblClick(Sender: TObject);
begin
  If dbSeleccion.RecordCount=0 then Begin Showmessage('NO HAY NADA QUE SELECCIONAR'); Exit; End;
  CargarDatosNodo();
end;

procedure TFormAsistenteAnexos.BitBtnModificarClick(Sender: TObject);
begin
  accion:='modificar';
  AccionNodo();
end;

procedure TFormAsistenteAnexos.BitBtnBorrarClick(Sender: TObject);
begin
  accion:='borrar';
  AccionNodo();
end;

procedure TFormAsistenteAnexos.BitBtnGuardarConfClick(Sender: TObject);
begin
  GuardarIni();
end;

procedure TFormAsistenteAnexos.bitBtnConfiguracionClick(Sender: TObject);
begin
    PanelConfiguracion.Visible:=True;
end;

procedure TFormAsistenteAnexos.BitBtnApScClick(Sender: TObject);
begin
 if OpenDialogApliSc.Execute then
   begin
     EditApliScaner.Text:=OpenDialogApliSc.FileName;
   end;
end;

procedure TFormAsistenteAnexos.Inicia();
var
  TxtQuery: String;
begin
 // Los parametros son los de Globales
 // ATENCIÓN: Ahora mismo se crea el DataModule al inicio de la aplicación y la
 // variable Lee coge el valor de donde está ÉSTE ejecutable, que es distinto de
 // del de facturlinex.
 // Cuando la aplicación se lanza desde facturlinex esto habrá que revisarlo

 if FileExists(Lee+'FacturConf.ini') then
   begin
    IniReader := TIniFile.Create(Lee+'FacturConf.ini');
    Sections := TStringList.Create;
    Contents := TStringList.Create;
    IniReader.ReadSections( Sections );

    if IniReader.ReadString('Modulos','AsistenteAnexos','')<>'S' then
     begin
      if Application.MessageBox('CONFIRME LA INSTALACIÓN DEL MÓDULO AISTENTE PARA ANEXOS','FacturLinEx', boxstyle) = IDNO Then
        begin
          Close();
          exit;
        end;
      IniReader.WriteString('Modulos','AsistenteAnexos','S');
     end;
    if not (DirectoryExists(Lee+'ImagenesScaner')) then CreateDir(Lee+'ImagenesScaner');
    RutaImagenesScaner:=Lee+'ImagenesScaner';
    if IniReader.ReadString('ProExt','CarpetaImagenesScaner','')<>'' then
     begin
      RutaImagenesScaner:=IniReader.ReadString('ProExt','CarpetaImagenesScaner','');
     end;
    if IniReader.ReadString('ProExt','ApliScaner','')<>'' then
     begin
      ApliScaner:=IniReader.ReadString('ProExt','ApliScaner','');
      bitBtnScaner.Enabled:=True;
     end;
    EditRutaImagenesScaner.Text:=RutaImagenesScaner;
    EditApliScaner.Text:=ApliScaner;
    Conectate(dbConect);
    // Hay que comprobar si existe la Tabla docuanexos y si no está insertarla
    TxtQuery:='CREATE TABLE IF NOT EXISTS docuanexos'+//Tienda+
                    '('+
                      ' claveNodo char(40) NOT NULL,'+
                      ' numDoc int(10) unsigned NOT NULL,'+
                      ' rutaDoc char(50) NOT NULL,'+
                      ' tablaNodo char(15) NOT NULL,'+
                    ' PRIMARY KEY (claveNodo,numDoc,rutaDoc),'+
                    ' UNIQUE INDEX nod (claveNodo,numDoc,rutaDoc))'+
                    ' ENGINE=InnoDB DEFAULT CHARSET=utf8;';
    dbTrabajo.SQL.Text:=TxtQuery;
    dbTrabajo.ExecSQL;
  end
  else
    begin
      showmessage('No se encuentra el fichero de configuración FacturConf.ini');
      // No consigo que se cierre el proceso ¿?
      //Close();
      bitBtnCerrarClick(self);
    end;
end;

//====================== Cambia las TxtQuerys según el Check activado
procedure TFormAsistenteAnexos.CargaQuerys();
begin
  if RadioButtonFacturas.Checked=True then begin
  tipo:='FACTURA';camposKey:=4;tablaNodo:='factuc'+Tienda;
  TxtQueryNodos:='SELECT * FROM docuanexos WHERE tablaNodo = "'+tablaNodo+'" ORDER BY numDoc ASC';
  TxtQueryTrabajo:='SELECT *,C1 FROM factuc'+Tienda+', clientes WHERE FC0=C0 ORDER BY FC2 ASC, FC1 DESC, FC3 DESC';
  Labelnodo.Caption:='SELECCIONE FACTURA';
  DBGridNodoFactura.Visible:=True;
  end;
  if RadioButtonAlbaranes.Checked=True then begin
  tipo:='ALBARAN';camposKey:=4;tablaNodo:='albac'+Tienda;
  TxtQueryNodos:='SELECT * FROM docuanexos WHERE tablaNodo = "'+tablaNodo+'" ORDER BY numDoc ASC';
  TxtQueryTrabajo:='SELECT *,C1 FROM albac'+Tienda+', clientes WHERE AC0=C0 ORDER BY AC2 ASC, AC1 DESC, AC3 DESC';
  Labelnodo.Caption:='SELECCIONE ALBARÁN';
  DBGridNodoAlbaran.Visible:=True;
  end;
  if RadioButtonArticulos.Checked=True then begin
  tipo:='ARTICULO';camposKey:=1;tablaNodo:='artitien'+Tienda;
  TxtQueryNodos:='SELECT * FROM docuanexos WHERE tablaNodo = "'+tablaNodo+'" ORDER BY numDoc ASC';
  TxtQueryTrabajo:='SELECT * FROM artitien'+Tienda+' ORDER BY A1 ASC';
  Labelnodo.Caption:='SELECCIONE ARTÍCULO';
  DBGridNodoArticulo.Visible:=True;
  end;
  if RadioButtonRutas.Checked=True then begin
  tipo:='RUTA';camposKey:=1;tablaNodo:='rutas'+Tienda;
  TxtQueryNodos:='SELECT * FROM docuanexos WHERE tablaNodo = "'+tablaNodo+'" ORDER BY numDoc ASC';
  TxtQueryTrabajo:='SELECT * FROM rutas'+Tienda+' ORDER BY RUT1 ASC';
  Labelnodo.Caption:='SELECCIONE RUTA';
  DBGridNodoRuta.Visible:=True;
  end;
  Labelnodo.Caption:='SELECCIONE '+tipo;
  //showmessage(TablaNodo);
  //showmessage(TxtQueryNodos);
  //showmessage(TxtQueryTrabajo);
end;

//======================= Lanzamos las Querys
procedure TFormAsistenteAnexos.CargaGridNodo();
begin
  //CargaQuerys();
    dbSeleccion.Active:=False;
    dbSeleccion.SQL.Text:=TxtQueryTrabajo;
    dbSeleccion.Active := True;
end;
procedure TFormAsistenteAnexos.CargaGridAnexo();
begin
    dbAnexos.Active:=False;
    dbAnexos.SQL.Text:=TxtQueryNodos;
    dbAnexos.Active:=True;
end;
// ====================== Acciones sobre los Nodos Anexos
procedure TFormAsistenteAnexos.AccionNodo();
begin
  if (dbAnexos.Active=False) then
    begin
      Showmessage('DEBE ESCOGER EL TIPO DE NODO');
      Exit;
    end;
  if accion='modificar' then
    begin   // MODIFICAR
      if (dbAnexos.RecordCount=0) then
        begin
          Showmessage('NO HAY NINGUNA LÍNEA SELECCIONADA');
          exit;
        end;
      OpenDialogSeleccion.FileName:=dbAnexos.FieldByName('rutaDoc').Text;
      OpenDialogSeleccion.Execute;
      dbAnexos.Edit; // Abrimos para editar la línea seleccionada
    end
  else if accion='anadir' then      // AÑADIR
    begin
      OpenDialogSeleccion.InitialDir:=RutaImagenesScaner;
      OpenDialogSeleccion.Execute;
      dbAnexos.Append; // Abrimos para añadir
    end
  else if accion='borrar' then       // BORRAR
    begin
      if (dbAnexos.RecordCount=0) then
        begin
          Showmessage('NO HAY NINGUNA LÍNEA SELECCIONADA');
          exit;
        end;
      if Application.MessageBox('CONFIRME EL BORRADO DE LA LINEA','FacturLinEx', boxstyle) = IDNO Then Exit;
      dbAnexos.Delete;
      Exit;
    end;
  if OpenDialogSeleccion.FileName <> '' then begin
    rutaDocumento:=OpenDialogSeleccion.FileName;
  end
  else exit;
  //CargaGridNodo();
  // Abrimos el panel de Selección de Nodo y dejamos que sea CargarDatosNodo()
  // quien termine de cargar los datos (dbAnexos.Post)
  PanelSeleccionNodo.Visible:=True;
end;

procedure TFormAsistenteAnexos.CargarDatosNodo();
begin
  dbAnexos.FieldByName('claveNodo').AsString:=GeneraKeyDelNodo();
  dbAnexos.FieldByName('numDoc').Value:=NumeroDocAnexo()+1;
  dbAnexos.FieldByName('rutaDoc').Value:=rutaDocumento;
  dbAnexos.FieldByName('tablaNodo').AsString:=tablaNodo;
// Podria mirar si existe este anexo
  dbAnexos.Post;
  PanelSeleccionNodo.Visible:=False;
end;


//================= N. DE DOCUMENTO ANEXO ===========================
// Busca el mayor nº de documento añexo
function TFormAsistenteAnexos.NumeroDocAnexo(): integer;
var
  numDoc: integer;
  txtquery:string;
begin
  numDoc:=0;
  dbTrabajo.Active:=False;
  txtquery:='SELECT * FROM docuanexos'+//Tienda+
           ' WHERE claveNodo="'+GeneraKeyDelNodo() +
           '" ORDER BY NumDoc DESC';

  dbTrabajo.SQL.Text:=txtquery;
  dbTrabajo.Active:=True;
  if dbTrabajo.Recordcount=0 then numDoc:=0
  else numDoc:=dbTrabajo.FieldByName('NumDoc').Value;
  showmessage('num doc '+inttostr(numdoc));
  dbTrabajo.Active:=False;
  Result:= numDoc;
end;
function TFormAsistenteAnexos.GeneraKeyDelNodo():string;
var
  cadena: string;
  cont: integer;
begin
  cadena:='';
  cont:=0;
  while cont < camposKey-1 do
    begin
      cadena:=cadena+dbSeleccion.Fields[cont].AsString+'|-|';
      cont:=cont+1;
    end;
  cadena:=cadena+dbSeleccion.Fields[cont].AsString;
  //showmessage(cadena);
  Result:=cadena;
end;
procedure TFormAsistenteAnexos.GuardarIni();
begin
  RutaImagenesScaner:=EditRutaImagenesScaner.Text;
  ApliScaner:=EditApliScaner.Text;
  If (RutaImagenesScaner='') OR (ApliScaner='') then
    begin
      Showmessage('Debe elegir una aplicación para escanear y una carpeta de destino');
      EditApliScaner.SetFocus;
      exit;
    end;
  //-------------- Aplicaciones Extras -------------------
  IniReader.WriteString('ProExt','CarpetaImagenesScaner',RutaImagenesScaner);
  IniReader.WriteString('ProExt','ApliScaner',ApliScaner);
  //---- Guardar IniFile
  IniReader.UpdateFile;
  bitBtnScaner.Enabled:=True;
  PanelConfiguracion.Visible:=False;
end;
//======================= Al picar sobre los Check recarga dotos
procedure TFormAsistenteAnexos.RadioButtonChange(Sender: TObject);
begin
  OcultarBDGrid();
  CargaQuerys();
  CargaGridAnexo();
  CargaGridNodo();
  PanelAnexos.Visible:=True;
end;
//======================= OCULTA TODOS LOS DBGird
procedure TFormAsistenteAnexos.OcultarBDGrid();
  begin
    LabelNodo.Caption:='';
    DBGridNodoFactura.Visible:=False;
    DBGridNodoArticulo.Visible:=False;
    DBGridNodoAlbaran.Visible:=False;
    DBGridNodoRuta.Visible:=False;
  end;
// ====================== Redimensiona y Coloca Todos los DBGrid
procedure TFormAsistenteAnexos.DimensionarColocarBDGrid();
begin
  DBGridNodoFactura.Align:=alClient;
  DBGridNodoArticulo.Align:=alClient;
  DBGridNodoAlbaran.Align:=alClient;
  DBGridNodoRuta.Align:=alClient;
end;

procedure TFormAsistenteAnexos.BitBtnCerrarClick(Sender: TObject);
begin
  Close();
end;
procedure TFormAsistenteAnexos.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

initialization
  {$I asistenteanexos.lrs}

end.

