unit Modelo347;

{$mode objfpc}

interface

uses
  Classes, SysUtils, db, FileUtil, LR_Class, LR_DBSet, LResources, Forms,
  Controls, Graphics, Dialogs, DBGrids, ExtCtrls, StdCtrls, Buttons, MaskEdit,
  ComCtrls, ZDataset, Grids, LR_DSet, LCLType
  {$IFDEF LCLGTK2}
  , gtk2, gdk2
  {$ENDIF}
  ;

type

  { TFModelo347 }

  TFModelo347 = class(TForm)
    BitBtn4: TBitBtn;
    btSeleccion: TBitBtn;
    btImprimir: TBitBtn;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    DataSource1: TDataSource;
    dbConsulta: TZQuery;
    db347: TZQuery;
    DBGrid1: TDBGrid;
    dbFacturas: TZQuery;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    LabelCabeceraSubtitulo: TLabel;
    LabelAyudaResultado: TLabel;
    MEAno: TMaskEdit;
    MELimite: TMaskEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    dbhistoricos: TZQuery;
    dbClientes: TZQuery;
    dbSeries: TZQuery;
    RadioGroup1: TRadioGroup;


    procedure BitBtn4Click(Sender: TObject);
    procedure btImprimirClick(Sender: TObject);
    procedure btSeleccionClick(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CargaSeries();
    procedure CargaClientes();
    procedure FormCreate(Sender: TObject);
    procedure BuscaCliente(Sender: TObject);
    procedure Cargaclientes3000();
    function CargaRazonSocial(Cif: string): String;
    function CargaTrimestre(trimestre: string): double;
    procedure MEAnoChange(Sender: TObject);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);

  private
    FOrdenCampo: String;
    FOrdenAscendente: Boolean;
    procedure AplicarEstiloModerno;
    procedure AjustarDistribucion;
    procedure AplicarContrasteSeleccion(AControl: TWinControl);
    procedure AplicarContrasteSeleccionControles(AParent: TWinControl);
    procedure OrdenarResultados(const ACampo: String; AAscendente: Boolean);
    procedure ActualizarFlechasOrden;
    function QuitarFlechaOrden(const ATexto: String): String;

  public

  end;

  procedure ShowFormModelo347;

var
  FModelo347: TFModelo347;
  CondicionClientes, CondicionSeries, TituloGrid: string;
  Ano: Integer;


implementation

{ TFModelo347 }

Uses
  Global, busquedas, Funciones;

//=============== Crea el formulario ================
procedure ShowFormModelo347;
begin
  with TFModelo347.Create(Application) do
    begin
       ShowModal;
    end;

end;

procedure TFModelo347.FormCreate(Sender: TObject);
begin

 CargaSeries();//----- Cargar Series de facturacion

 CargaClientes();//----- Cargar Clientes

 MELimite.Text:='3000';
 MEAno.Text:= IntToStr(StrToInt(FormatDateTime('yyyy', date))-1);
 Ano:= StrToInt(MEAno.Text);

 CondicionClientes:=''; CondicionSeries:='';

 FOrdenCampo:='';
 FOrdenAscendente:=True;
 AplicarEstiloModerno;
 AjustarDistribucion;

end;

//================== Cerrar formulario ===============
procedure TFModelo347.BitBtn4Click(Sender: TObject);
begin
   Close();
end;

procedure TFModelo347.btSeleccionClick(Sender: TObject);
begin
   Cargaclientes3000();

   if db347.Active and (db347.RecordCount > 0) then
     LabelAyudaResultado.Caption:=
       Format('%d cliente(s) superan el límite indicado. Puede ordenar por columnas o imprimir el informe.',
         [db347.RecordCount])
   else
     LabelAyudaResultado.Caption:=
       'No se han encontrado operaciones que superen el límite con los filtros seleccionados.';
end;


procedure TFModelo347.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Closeaction:=CaFree;
end;


//======================= CARGAR SERIES DE FACTURACION ========================
procedure TFModelo347.CargaSeries();
begin
  dbSeries.Active:=False;
  dbSeries.SQL.Text:='SELECT * FROM seriesfactu WHERE SF5<>"E" ORDER BY SF0';
  dbSeries.Active:=True;
  if dbSeries.RecordCount=0 then begin showmessage('NO EXISTEN SERIES A LISTAR'); exit; end;
  dbSeries.First;
  ComboBox1.Items.Clear; ComboBox1.Items.Add('TODAS LAS SERIES');
  while not dbSeries.EOF do
    begin
     ComboBox1.Items.Add(Space(3-length(dbSeries.FieldByName('SF0').AsString))+ dbSeries.FieldByName('SF0').AsString+' - '+
                        dbSeries.FieldByName('SF1').AsString);
     dbSeries.Next;
    end;

  ComboBox1.ItemIndex:=0;
end;


//======================= CARGAR CLIENTES por CIF ========================
procedure TFModelo347.CargaClientes();
begin
  dbClientes.Active:=False;
  dbClientes.SQL.Text:='SELECT * FROM clientes where C5<>"" ORDER BY C1';
  dbClientes.Active:=True;
  if dbClientes.RecordCount=0 then begin showmessage('NO HAY CLIENTES'); exit; end;
  dbClientes.First;
  ComboBox2.Items.Clear; ComboBox2.Items.Add('TODOS LOS CLIENTES');
  while not dbClientes.EOF do
    begin
     ComboBox2.Items.Add(Space(15-length(dbClientes.FieldByName('C5').AsString))+ dbClientes.FieldByName('C5').AsString+' - ('+
                         Space(11-length(dbClientes.FieldByName('C0').AsString))+ dbClientes.FieldByName('C0').AsString+') '+
                         dbClientes.FieldByName('C1').AsString);
     dbClientes.Next;
    end;

  ComboBox2.ItemIndex:=0;
end;

procedure TFModelo347.ComboBox2Change(Sender: TObject);
var
  Valor: string;
begin

  Valor:= trim(copy(ComboBox2.Text,1,18));

  if Valor='TODOS LOS CLIENTES' then
      begin

        Edit1.Text:='';
        Edit2.Text:='';
        Edit3.Text:='';

        Edit1.SetFocus;


      end else

       begin
        Edit1.Text:= Valor;

        edit1Exit(self);

       end;

end;

procedure TFModelo347.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Grid: TDBGrid;
begin
  Grid:=TDBGrid(Sender);

  if gdSelected in State then
  begin
    Grid.Canvas.Brush.Color:=RGBToColor(42,86,132);
    Grid.Canvas.Font.Color:=clWhite;
  end
  else
  begin
    Grid.Canvas.Brush.Color:=clWhite;
    if DataCol=6 then
      Grid.Canvas.Font.Color:=clMaroon
    else
      Grid.Canvas.Font.Color:=RGBToColor(24,36,48);
  end;

  Grid.Canvas.FillRect(Rect);
  Grid.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;


//=================== CIF CLIENTE =======================
procedure TFModelo347.Edit1Enter(Sender: TObject);
begin
   Edit2.Text:=''; Edit3.Text:='';
end;

procedure TFModelo347.Edit1Exit(Sender: TObject);
var
  I: integer;
begin
   if Edit1.Text='' then Exit;
   dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C5="'+Edit1.Text+'"';
   dbClientes.Active:=True;
   If dbClientes.RecordCount=0 then
                               Begin
                                 BuscaCliente(self);
                                 Edit2.SetFocus; Exit;
                               End;
   Edit2.Text:=dbClientes.FieldByName('C1').AsString;

   Edit3.Text:=dbClientes.FieldByName('C0').AsString;


  for I := 0 to ComboBox2.Items.Count -1 do
     begin
     ComboBox2.ItemIndex:=I;
     if trim(copy(ComboBox2.Text,1,15)) = Edit1.Text then
       exit;
     end;


end;

//--------------- Busca Cliente -----------------------
procedure TFModelo347.BuscaCliente(Sender: TObject);
begin
   Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT C0,C1,C5 FROM clientes',['Código','Cliente','N.I.F.'],'C5');
   Edit2.SetFocus;
   Edit1Exit(self);
end;


//--------------- Buscar por nombre -----------------
procedure TFModelo347.Edit2Exit(Sender: TObject);
begin
  if Edit2.Text='' then begin ShowMessage('DEBE TECLEAR EL COMIENZO DEL TEXTO A BUSCAR'); Edit2.SetFocus; Exit; end;
  dbClientes.SQL.Text:='SELECT C0,C1,C5 FROM clientes WHERE C1="'+Edit2.Text+'"'; dbClientes.Active:=True;
  if dbClientes.RecordCount=0 then
                             begin
                               Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT C0,C1,C5 FROM clientes WHERE C1 LIKE "'+Edit2.Text+'%"',
                                                         ['Código', 'Cliente', 'N.I.F.'],'C5');
                               Edit1Exit(self);
                               Exit;
                              end;
  Edit1.Text:=dbClientes.FieldByName('C5').AsString;
  Edit1Exit(self);
end;

//---------------- Buscar por código ------------------
procedure TFModelo347.Edit3Exit(Sender: TObject);
begin
   if Edit3.Text='' then Exit;
   dbClientes.SQL.Text:='SELECT * FROM clientes WHERE C0="'+Edit3.Text+'"';
   dbClientes.Active:=True;
   If dbClientes.RecordCount=0 then
                             begin
                               Edit1.Text:=FBusquedas.IniciaBusquedas('SELECT C0,C1,C5 FROM clientes WHERE C0 LIKE "'+Edit3.Text+'%"',
                                                         ['Código', 'Cliente', 'N.I.F.'],'C5');
                               Edit1Exit(self);
                               Exit;

                             end;

   Edit2.Text:=dbClientes.FieldByName('C1').AsString;

   Edit1.Text:=dbClientes.FieldByName('C5').AsString;
   Edit1Exit(self);

end;

// ---------------------- Carga clientes a listar ------------------
procedure TFModelo347.Cargaclientes3000();
var
  CampoCIF, CampoSeries: string;
begin

  db347.Active:=False;
  db347.SQL.Text:='DELETE FROM Mod347';                       // Borra todos los registros del temporal.
  db347.ExecSQL;
  db347.SQL.Text:='SELECT * FROM Mod347';
  db347.Active:=True;
  FOrdenCampo:='';
  FOrdenAscendente:=True;
  ActualizarFlechasOrden;

  if RadioGroup1.ItemIndex=0 then
                            begin
                              CampoCIF:='FC24'; CampoSeries:='FC2';
                            end else
                            begin
                              CampoCIF:='HO19'; CampoSeries:='HO4';
                            end;


  CondicionClientes:='';
  if Edit1.Text<>'' then CondicionClientes:=CampoCIF+'="'+Edit1.Text+'" AND ';

  CondicionSeries:='';
  if ComboBox1.Text<>'TODAS LAS SERIES' then CondicionSeries:=CampoSeries+'="'+Copy(ComboBox1.Text, 1,3)+'" AND ';

  dbHistoricos.Active:=False;
  if RadioGroup1.ItemIndex=0 then
    dbHistoricos.SQL.Text:='SELECT sum(FC9), FC0, FC1, FC24 FROM factuc'+Tienda+' WHERE '+CondicionClientes+CondicionSeries+
                           '(FC1>"'+IntToStr(Ano-1)+'-12-31" and FC1<"'+IntToStr(Ano+1)+'-01-01") GROUP BY FC24 HAVING sum(FC9)>'+MELimite.Text

  else
    dbHistoricos.SQL.Text:='SELECT sum(HO11), HO0, HO8, HO5, HO19 FROM hisopcc'+Tienda+' WHERE '+CondicionClientes+ CondicionSeries+' HO5 in ("FA","NS","NT")'+
                           'and (HO0>"'+IntToStr(Ano-1)+'-12-31" and HO0<"'+IntToStr(Ano+1)+'-01-01") GROUP BY HO19 HAVING sum(HO11)>'+MELimite.Text;

  dbHistoricos.Active:=True;

 if dbHistoricos.RecordCount=0 then
                              begin
                                Showmessage(' No hay clientes de más de '+MELimite.Text+' € ');
                                Exit;
                              end;

 dbHistoricos.First;

 while not dbHistoricos.eof do
       begin

         if dbHistoricos.FieldByName(CampoCIF).AsString<>'' then
           begin
             db347.Append;

             db347.FieldByName('CIF').AsString:= dbHistoricos.FieldByName(CampoCIF).AsString; //  Ponemos CIF del cliente

             db347.FieldByName('RSocial').AsString:=CargaRazonSocial(dbHistoricos.FieldByName(CampoCIF).AsString); // Ponemos Razón Social

             db347.FieldByName('Trimestre1').AsFloat:= StrToFloat(FormatFloat('0.00', CargaTrimestre('Primero')));
             db347.FieldByName('Trimestre2').AsFloat:= StrToFloat(FormatFloat('0.00', CargaTrimestre('Segundo')));
             db347.FieldByName('Trimestre3').AsFloat:= StrToFloat(FormatFloat('0.00', CargaTrimestre('Tercero')));
             db347.FieldByName('Trimestre4').AsFloat:= StrToFloat(FormatFloat('0.00', CargaTrimestre('Cuarto')));

             db347.FieldByName('Total').AsFloat:=StrToFloat(FormatFloat('0.00',db347.FieldByName('Trimestre1').AsFloat+
                                                 db347.FieldByName('Trimestre2').AsFloat+
                                                 db347.FieldByName('Trimestre3').AsFloat+
                                                 db347.FieldByName('Trimestre4').AsFloat));
             db347.post;

           end;

        dbHistoricos.Next;

      end;


end;

//----------------- Carga datos de cada trimestre ------------------
//----------------- entrada : trimestre a buscar
//----------------- salida  : Importe del trimestre
//------------------------------------------------------------------
function TFModelo347.CargaTrimestre(trimestre: string): double;
var
   tmpTrimestre: string;
   tmpCampoFactHist: string;
begin

 if RadioGroup1.ItemIndex=0 then tmpCampoFactHist:='FC1' else tmpCampoFactHist:='HO0';

 case trimestre of
    'Primero':tmpTrimestre:='('+tmpCampoFactHist+'>"'+IntToStr(Ano-1)+'-12-31" and '+tmpCampoFactHist+'<"'+IntToStr(Ano)+'-04-01")';
    'Segundo':tmpTrimestre:='('+tmpCampoFactHist+'>"'+IntToStr(Ano)+'-03-31" and '+tmpCampoFactHist+'<"'+IntToStr(Ano)+'-07-01")';
    'Tercero':tmpTrimestre:='('+tmpCampoFactHist+'>"'+IntToStr(Ano)+'-06-30" and '+tmpCampoFactHist+'<"'+IntToStr(Ano)+'-10-01")';
    'Cuarto':tmpTrimestre:= '('+tmpCampoFactHist+'>"'+IntToStr(Ano)+'-09-30" and '+tmpCampoFactHist+'<"'+IntToStr(Ano+1)+'-01-01")';
 end;


 dbConsulta.Active:=False;

 if RadioGroup1.ItemIndex=0 then
   dbConsulta.SQL.Text:='SELECT sum(FC9) as subtotal,FC2, FC1, FC24 FROM factuc'+Tienda+' WHERE '+CondicionSeries+' FC24="'+dbHistoricos.FieldByName('FC24').AsString+'"'
                           +' AND '+tmpTrimestre+' GROUP BY FC24 '

 else
   dbConsulta.SQL.Text:='SELECT sum(HO11)as subtotal, HO19, HO4, HO5, HO0 FROM hisopcc'+Tienda+' WHERE '+CondicionSeries+' HO19="'+dbHistoricos.FieldByName('HO19').AsString+'"'
                       +' AND HO5 in ("FA","NS","NT") and '+tmpTrimestre + ' GROUP BY HO19';

 dbConsulta.Active:=True;


 Result:=dbConsulta.FieldByName('subtotal').AsFloat;

end;



//----------------- Carga Razon Social Cliente ------------------
//------------------------------------------------------------------
function TFModelo347.CargaRazonSocial(Cif: string): String;
begin

 dbClientes.SQL.Text:='SELECT C1, C5 FROM clientes WHERE C5="'+Cif+'"';
 dbClientes.Active:=True;

 if dbClientes.RecordCount=0 then Exit;

 Result:=dbclientes.FieldByName('C1').AsString;

 if dbClientes.RecordCount>1 then Result := '(Varios) '+dbclientes.FieldByName('C1').AsString +', ...';

end;

procedure TFModelo347.MEAnoChange(Sender: TObject);
var
  NuevoAno: Integer;
begin
  if TryStrToInt(Trim(MEAno.Text), NuevoAno) then
    Ano:=NuevoAno;
end;

//========================================================================
//==================     impresión =======================================
//========================================================================

procedure TFModelo347.btImprimirClick(Sender: TObject);
begin
     frDBDataSet1.DataSet:=db347;
     frReport1.LoadFromFile(RutaReports+'Modelo347.lrf');
//--     frReport1.PrepareReport;
     frReport1.ShowReport;
end;


//================= PASAR PARAMETROS AL REPORT ===============
procedure TFModelo347.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin

// showmessage(ParName);
  if ParName ='EMPRESA' then ParValue := Empresa;
  if ParName='DIRECCION' then ParValue := Direccion;
  if ParName='LOCALIDAD' then ParValue := Localidad;
  if ParName='PROVINCIA' then ParValue := Provincia;
  if ParName='NIF' then ParValue := Nif;
  if ParName='TELEFONO' then ParValue := Telefono;
  if ParName='FAX' then ParValue := Fax;
  if ParName='EMAIL' then ParValue := EMail;
  if ParName='CP' then ParValue := CP;
  if ParName='TITULO' then ParValue := 'Modelo 347';
  if ParName='EJERCICIO' then ParValue := MeAno.Text;
end;


//======================= LOGOTIPO DEL FORMULARIO ========================
procedure TFModelo347.frReport1EnterRect(Memo: TStringList; View: TfrView);
var
  vImage: TImage;
begin
  frReport1.Title:=' Modelo 347 ';
  if assigned( View ) and
     (View.Name = 'Picture1') and
     (View is TfrPictureView)
  then
    try
      vImage := TImage.Create( nil );
      try
         TfrPictureView(View).Picture.Clear;
         TfrPictureView(View).Picture.LoadFromFile(LogoEmpresa);
      finally
        FreeAndNil(vImage);
      end;
    except
      TfrPictureView(View).Picture.Clear;
    end;
end;



//================= MODERNIZACIÓN VISUAL =================
procedure TFModelo347.AplicarEstiloModerno;
const
  COLOR_TEXTO = TColor($00302418);
begin
  Color:=RGBToColor(245,248,251);
  KeyPreview:=True;
  ShowHint:=True;

  Panel1.Caption:='';
  Panel2.Caption:='';
  Panel3.Caption:='';
  Panel1.Color:=RGBToColor(38,78,118);
  Panel2.Color:=RGBToColor(245,248,251);
  Panel3.Color:=RGBToColor(232,239,245);

  Label1.Color:=Panel1.Color;
  Label1.Font.Color:=clWhite;
  LabelCabeceraSubtitulo.Color:=Panel1.Color;
  LabelCabeceraSubtitulo.Font.Color:=clWhite;

  GroupBox1.Color:=RGBToColor(236,246,252);
  GroupBox2.Color:=RGBToColor(247,249,251);
  GroupBox3.Color:=RGBToColor(247,249,251);
  GroupBox1.Font.Color:=COLOR_TEXTO;
  GroupBox2.Font.Color:=COLOR_TEXTO;
  GroupBox3.Font.Color:=COLOR_TEXTO;

  Label2.ParentColor:=True;
  Label3.ParentColor:=True;
  Label4.ParentColor:=True;
  Label5.ParentColor:=True;
  Label6.ParentColor:=True;
  Label2.Font.Color:=COLOR_TEXTO;
  Label3.Font.Color:=COLOR_TEXTO;
  Label4.Font.Color:=COLOR_TEXTO;
  Label5.Font.Color:=COLOR_TEXTO;
  Label6.Font.Color:=COLOR_TEXTO;

  RadioGroup1.Color:=GroupBox1.Color;
  RadioGroup1.Font.Color:=COLOR_TEXTO;

  Edit1.Color:=clWhite;
  Edit2.Color:=clWhite;
  Edit3.Color:=clWhite;
  MEAno.Color:=clWhite;
  MELimite.Color:=clWhite;
  ComboBox1.Color:=clWhite;
  ComboBox2.Color:=clWhite;

  btSeleccion.Caption:='Consultar operaciones';
  btSeleccion.Hint:='Calcular y mostrar los importes del Modelo 347';
  btSeleccion.Color:=RGBToColor(207,232,246);
  btSeleccion.Font.Color:=COLOR_TEXTO;
  btSeleccion.Font.Style:=[fsBold];

  btImprimir.Caption:='Imprimir informe';
  btImprimir.Hint:='Previsualizar e imprimir el informe Modelo 347';
  btImprimir.Color:=RGBToColor(214,238,220);
  btImprimir.Font.Color:=COLOR_TEXTO;
  btImprimir.Font.Style:=[fsBold];

  BitBtn4.Caption:='Cerrar';
  BitBtn4.Hint:='Cerrar el formulario';
  BitBtn4.Color:=RGBToColor(239,226,226);
  BitBtn4.Font.Color:=COLOR_TEXTO;
  BitBtn4.Font.Style:=[fsBold];

  btSeleccion.Visible:=True;
  btImprimir.Visible:=True;
  BitBtn4.Visible:=True;
  btSeleccion.BringToFront;
  btImprimir.BringToFront;
  BitBtn4.BringToFront;
  LabelAyudaResultado.BringToFront;

  DBGrid1.Color:=clWhite;
  DBGrid1.FixedColor:=RGBToColor(220,230,238);
  DBGrid1.Font.Color:=COLOR_TEXTO;
  DBGrid1.TitleFont.Color:=COLOR_TEXTO;
  DBGrid1.TitleFont.Style:=[fsBold];
  DBGrid1.DefaultRowHeight:=28;
  DBGrid1.Options:=DBGrid1.Options+
    [dgTitles,dgIndicator,dgColumnResize,dgColumnMove,dgColLines,
     dgRowLines,dgRowSelect,dgAlwaysShowSelection];

  OnKeyDown:=@FormKeyDown;
  OnResize:=@FormResize;
  OnShow:=@FormShow;
  DBGrid1.OnTitleClick:=@DBGrid1TitleClick;
end;

procedure TFModelo347.AjustarDistribucion;
var
  AnchoDisponible: Integer;
begin
  if not Assigned(Panel2) then Exit;

  GroupBox1.Left:=16;
  GroupBox1.Top:=12;

  GroupBox3.Left:=Panel2.ClientWidth-GroupBox3.Width-16;
  if GroupBox3.Left < GroupBox1.Left+GroupBox1.Width+250 then
    GroupBox3.Left:=GroupBox1.Left+GroupBox1.Width+250;

  GroupBox2.Left:=GroupBox1.Left+GroupBox1.Width+16;
  GroupBox2.Top:=12;
  AnchoDisponible:=GroupBox3.Left-16-GroupBox2.Left;
  if AnchoDisponible<360 then AnchoDisponible:=360;
  GroupBox2.Width:=AnchoDisponible;

  Edit2.Width:=GroupBox2.ClientWidth-Edit2.Left-16;
  if Edit2.Width<160 then Edit2.Width:=160;
  ComboBox2.Width:=GroupBox2.ClientWidth-32;
  if ComboBox2.Width<300 then ComboBox2.Width:=300;

  Label1.Width:=Panel1.ClientWidth-48;
  LabelCabeceraSubtitulo.Width:=Panel1.ClientWidth-52;

  LabelAyudaResultado.Left:=690;
  LabelAyudaResultado.Width:=Panel3.ClientWidth-LabelAyudaResultado.Left-24;
  if LabelAyudaResultado.Width<260 then
  begin
    LabelAyudaResultado.Left:=Panel3.ClientWidth-284;
    LabelAyudaResultado.Width:=260;
  end;
end;

procedure TFModelo347.FormResize(Sender: TObject);
begin
  AjustarDistribucion;
end;

procedure TFModelo347.FormShow(Sender: TObject);
begin
  AjustarDistribucion;
  AplicarContrasteSeleccionControles(Self);
end;

procedure TFModelo347.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then
  begin
    Key:=0;
    Close;
  end;
end;

procedure TFModelo347.AplicarContrasteSeleccion(AControl: TWinControl);
{$IFDEF LCLGTK2}
var
  FondoNormal, TextoNormal, FondoSeleccion, TextoSeleccion: TGdkColor;
  Widget: PGtkWidget;
{$ENDIF}
begin
  if not Assigned(AControl) then Exit;
  AControl.HandleNeeded;

  {$IFDEF LCLGTK2}
  Widget:=PGtkWidget(AControl.Handle);
  if Assigned(Widget) then
  begin
    gdk_color_parse(PChar('#FFFFFF'),@FondoNormal);
    gdk_color_parse(PChar('#182430'),@TextoNormal);
    gtk_widget_modify_base(Widget,GTK_STATE_NORMAL,@FondoNormal);
    gtk_widget_modify_text(Widget,GTK_STATE_NORMAL,@TextoNormal);

    gdk_color_parse(PChar('#2A5684'),@FondoSeleccion);
    gdk_color_parse(PChar('#FFFFFF'),@TextoSeleccion);
    gtk_widget_modify_base(Widget,GTK_STATE_SELECTED,@FondoSeleccion);
    gtk_widget_modify_text(Widget,GTK_STATE_SELECTED,@TextoSeleccion);
  end;
  {$ENDIF}
end;

procedure TFModelo347.AplicarContrasteSeleccionControles(AParent: TWinControl);
var
  I: Integer;
  C: TControl;
begin
  if not Assigned(AParent) then Exit;

  for I:=0 to AParent.ControlCount-1 do
  begin
    C:=AParent.Controls[I];

    if (C is TCustomEdit) or (C is TComboBox) then
      AplicarContrasteSeleccion(TWinControl(C));

    if C is TWinControl then
      AplicarContrasteSeleccionControles(TWinControl(C));
  end;
end;

function TFModelo347.QuitarFlechaOrden(const ATexto: String): String;
var
  P: SizeInt;
begin
  Result:=ATexto;
  P:=Pos(' ▲',Result);
  if P>0 then Delete(Result,P,Length(Result)-P+1);
  P:=Pos(' ▼',Result);
  if P>0 then Delete(Result,P,Length(Result)-P+1);
end;

procedure TFModelo347.ActualizarFlechasOrden;
var
  I: Integer;
  TextoBase: String;
begin
  for I:=0 to DBGrid1.Columns.Count-1 do
  begin
    TextoBase:=QuitarFlechaOrden(DBGrid1.Columns[I].Title.Caption);
    if SameText(DBGrid1.Columns[I].FieldName,FOrdenCampo) then
    begin
      if FOrdenAscendente then
        DBGrid1.Columns[I].Title.Caption:=TextoBase+' ▲'
      else
        DBGrid1.Columns[I].Title.Caption:=TextoBase+' ▼';
    end
    else
      DBGrid1.Columns[I].Title.Caption:=TextoBase;
  end;
end;

procedure TFModelo347.OrdenarResultados(const ACampo: String;
  AAscendente: Boolean);
var
  Direccion: String;
begin
  if (ACampo='') or (not db347.Active) then Exit;

  if AAscendente then
    Direccion:=' ASC'
  else
    Direccion:=' DESC';

  db347.DisableControls;
  try
    db347.Close;
    db347.SQL.Text:='SELECT * FROM Mod347 ORDER BY '+ACampo+Direccion;
    db347.Open;
  finally
    db347.EnableControls;
  end;
end;

procedure TFModelo347.DBGrid1TitleClick(Column: TColumn);
begin
  if (Column=nil) or (Column.FieldName='') or (not db347.Active) then Exit;

  if SameText(FOrdenCampo,Column.FieldName) then
    FOrdenAscendente:=not FOrdenAscendente
  else
  begin
    FOrdenCampo:=Column.FieldName;
    FOrdenAscendente:=True;
  end;

  OrdenarResultados(FOrdenCampo,FOrdenAscendente);
  ActualizarFlechasOrden;
end;


initialization
  {$I modelo347.lrs}

end.

