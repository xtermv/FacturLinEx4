unit Modelo347;

{$mode objfpc}

interface

uses
  Classes, SysUtils, db, FileUtil, LR_Class, LR_DBSet, LResources, Forms,
  Controls, Graphics, Dialogs, DBGrids, ExtCtrls, StdCtrls, Buttons, MaskEdit,
  ComCtrls, ZDataset, Grids, LR_DSet;

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
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
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


end;

//================== Cerrar formulario ===============
procedure TFModelo347.BitBtn4Click(Sender: TObject);
begin
   Close();
end;

procedure TFModelo347.btSeleccionClick(Sender: TObject);
begin
   Cargaclientes3000();
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
begin

 with Sender as TDBGrid do begin
     if (datacol=6) then Canvas.Font.Color:=clMaroon
                    else defaultdrawing:= true;
                end;
 DBGrid1.DefaultDrawColumnCell(rect,datacol,column,state);
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
begin
  Ano:= StrToInt(MEAno.Text);
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



initialization
  {$I modelo347.lrs}

end.

