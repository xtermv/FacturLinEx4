{
  Gestion LinEx FacturLinEx

  Copyright (C) 2000-2010, Nicolas Lopez de Lerma Aymerich
  PuntoDev GNU S.L. <info@puntodev.com>

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 3 of the License, or
  (at your option) any later version.
}

unit Envases;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, LResources, Forms, Controls, Graphics, Dialogs,
  LCLType, DBGrids, Grids, db, ZConnection, ZDataset, Buttons, ExtCtrls,
  StdCtrls
  {$IFDEF LCLGTK2}
  , gtk2, gdk2
  {$ENDIF}
  ;

type

  { TFEnvases }

  TFEnvases = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    Datasource1: TDatasource;
    dbProve: TZQuery;
    DBGrid1: TDBGrid;
    dbRoles: TZQuery;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
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
    Label14: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    dbEnvases: TZQuery;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure Edit14Enter(Sender: TObject);
    procedure Edit14Exit(Sender: TObject);
    procedure Edit16Exit(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure Edit4Exit(Sender: TObject);
    procedure Edit5Exit(Sender: TObject);
    procedure Edit6Exit(Sender: TObject);
    procedure Edit7Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CabeceraEdicionMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CabeceraEdicionMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure CabeceraEdicionMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PintaDatos();
    procedure LimpiaDatos();
    procedure Relleno();
  private
    FHeaderPanel: TPanel;
    FHeaderTitle: TLabel;
    FHeaderSubtitle: TLabel;
    FStatusLabel: TLabel;
    FEditHeader: TPanel;
    FEditTitle: TLabel;
    FSortField: string;
    FSortAsc: Boolean;
    FMoviendoPanel: Boolean;
    FPanelMovidoPorUsuario: Boolean;
    FPanelDragOffset: TPoint;
    procedure AplicarEstiloModerno;
    procedure AplicarContrasteSeleccion(AControl: TWinControl);
    procedure AplicarContrasteSeleccionControles(AParent: TWinControl);
    procedure ActualizarEstado;
    procedure ConfigurarBoton(ABoton: TBitBtn; const ACaption, AHint: string;
      AColor: TColor);
    procedure LimitarPanelAlAreaVisible;
    procedure MarcarColumnaOrdenada(Column: TColumn);
    procedure MostrarPanelEdicion;
    procedure RecolocarControles;
  public
  end;

procedure ShowFormEnvases;

var
  FEnvases: TFEnvases;

implementation

uses
  Global, funciones;

{ TFEnvases }

procedure ShowFormEnvases;
begin
  with TFEnvases.Create(Application) do
    ShowModal;
end;

procedure TFEnvases.ConfigurarBoton(ABoton: TBitBtn;
  const ACaption, AHint: string; AColor: TColor);
begin
  if not Assigned(ABoton) then Exit;
  ABoton.Caption := ACaption;
  ABoton.Hint := AHint;
  ABoton.ShowHint := True;
  ABoton.Color := AColor;
  ABoton.Font.Name := 'Sans';
  ABoton.Font.Height := -14;
  ABoton.Font.Color := RGBToColor(24, 36, 48);
  ABoton.Font.Style := [fsBold];
  ABoton.Visible := True;
  ABoton.BringToFront;
end;

procedure TFEnvases.AplicarContrasteSeleccion(AControl: TWinControl);
{$IFDEF LCLGTK2}
var
  FondoNormal, TextoNormal, FondoSeleccion, TextoSeleccion: TGdkColor;
  Widget: PGtkWidget;
{$ENDIF}
begin
  if not Assigned(AControl) then Exit;
  AControl.HandleNeeded;
  {$IFDEF LCLGTK2}
  Widget := PGtkWidget(AControl.Handle);
  if Assigned(Widget) then
  begin
    gdk_color_parse(PChar('#FFFFFF'), @FondoNormal);
    gdk_color_parse(PChar('#101820'), @TextoNormal);
    gtk_widget_modify_base(Widget, GTK_STATE_NORMAL, @FondoNormal);
    gtk_widget_modify_text(Widget, GTK_STATE_NORMAL, @TextoNormal);
    gdk_color_parse(PChar('#2A5684'), @FondoSeleccion);
    gdk_color_parse(PChar('#FFFFFF'), @TextoSeleccion);
    gtk_widget_modify_base(Widget, GTK_STATE_SELECTED, @FondoSeleccion);
    gtk_widget_modify_text(Widget, GTK_STATE_SELECTED, @TextoSeleccion);
  end;
  {$ENDIF}
end;

procedure TFEnvases.AplicarContrasteSeleccionControles(AParent: TWinControl);
var
  I: Integer;
  C: TControl;
begin
  if not Assigned(AParent) then Exit;
  for I := 0 to AParent.ControlCount - 1 do
  begin
    C := AParent.Controls[I];
    if C is TCustomEdit then
      AplicarContrasteSeleccion(TWinControl(C));
    if C is TWinControl then
      AplicarContrasteSeleccionControles(TWinControl(C));
  end;
end;

procedure TFEnvases.AplicarEstiloModerno;
var
  I: Integer;
  C: TControl;
begin
  Caption := 'Envases y embalajes';
  Color := RGBToColor(244, 248, 251);
  Font.Name := 'Sans';
  Font.Height := -14;
  KeyPreview := True;

  if not Assigned(FHeaderPanel) then
  begin
    FHeaderPanel := TPanel.Create(Self);
    FHeaderPanel.Parent := Self;
    FHeaderPanel.Align := alTop;
    FHeaderPanel.Height := 88;
    FHeaderPanel.Caption := '';
    FHeaderPanel.BevelOuter := bvNone;
    FHeaderPanel.Color := RGBToColor(38, 84, 124);

    FHeaderTitle := TLabel.Create(Self);
    FHeaderTitle.Parent := FHeaderPanel;
    FHeaderTitle.Left := 24;
    FHeaderTitle.Top := 15;
    FHeaderTitle.Caption := 'ENVASES Y EMBALAJES';
    FHeaderTitle.Font.Name := 'Sans';
    FHeaderTitle.Font.Height := -24;
    FHeaderTitle.Font.Style := [fsBold];
    FHeaderTitle.Font.Color := clWhite;
    FHeaderTitle.ParentColor := True;

    FHeaderSubtitle := TLabel.Create(Self);
    FHeaderSubtitle.Parent := FHeaderPanel;
    FHeaderSubtitle.Left := 26;
    FHeaderSubtitle.Top := 52;
    FHeaderSubtitle.Caption :=
      'Gestión de costes, precios, existencias y proveedor habitual de cada envase.';
    FHeaderSubtitle.Font.Name := 'Sans';
    FHeaderSubtitle.Font.Height := -13;
    FHeaderSubtitle.Font.Color := RGBToColor(222, 236, 248);
    FHeaderSubtitle.ParentColor := True;
  end;

  Panel2.Caption := '';
  Panel2.BevelOuter := bvNone;
  Panel2.Color := RGBToColor(232, 240, 246);

  ConfigurarBoton(BitBtn2, 'Nuevo envase',
    'Crear un nuevo envase o embalaje (F2)', RGBToColor(190, 231, 202));
  ConfigurarBoton(BitBtn4, 'Modificar',
    'Modificar el envase seleccionado', RGBToColor(196, 220, 242));
  ConfigurarBoton(BitBtn3, 'Eliminar',
    'Eliminar el envase seleccionado (F3)', RGBToColor(246, 207, 207));
  ConfigurarBoton(BitBtn1, 'Cerrar',
    'Cerrar el formulario (ESC)', RGBToColor(224, 229, 234));

  if not Assigned(FStatusLabel) then
  begin
    FStatusLabel := TLabel.Create(Self);
    FStatusLabel.Parent := Panel2;
    FStatusLabel.AutoSize := False;
    FStatusLabel.Alignment := taCenter;
    FStatusLabel.Layout := tlCenter;
    FStatusLabel.Font.Name := 'Sans';
    FStatusLabel.Font.Height := -13;
    FStatusLabel.Font.Color := RGBToColor(47, 68, 86);
    FStatusLabel.ParentColor := True;
  end;

  DBGrid1.Color := clWhite;
  DBGrid1.Font.Name := 'Sans';
  DBGrid1.Font.Height := -14;
  DBGrid1.Font.Color := RGBToColor(20, 30, 40);
  DBGrid1.TitleFont.Name := 'Sans';
  DBGrid1.TitleFont.Height := -13;
  DBGrid1.TitleFont.Style := [fsBold];
  DBGrid1.TitleFont.Color := RGBToColor(28, 48, 65);
  DBGrid1.FixedColor := RGBToColor(217, 230, 240);
  DBGrid1.Options := DBGrid1.Options + [dgTitles, dgColumnResize, dgColumnMove,
    dgRowSelect, dgAlwaysShowSelection];

  Panel1.Caption := '';
  Panel1.BevelOuter := bvNone;
  Panel1.Color := RGBToColor(246, 249, 252);

  if not Assigned(FEditHeader) then
  begin
    FEditHeader := TPanel.Create(Self);
    FEditHeader.Parent := Panel1;
    FEditHeader.Align := alTop;
    FEditHeader.Height := 58;
    FEditHeader.Caption := '';
    FEditHeader.BevelOuter := bvNone;
    FEditHeader.Color := RGBToColor(55, 104, 145);
    FEditHeader.Cursor := crSizeAll;
    FEditHeader.OnMouseDown := @CabeceraEdicionMouseDown;
    FEditHeader.OnMouseMove := @CabeceraEdicionMouseMove;
    FEditHeader.OnMouseUp := @CabeceraEdicionMouseUp;

    FEditTitle := TLabel.Create(Self);
    FEditTitle.Parent := FEditHeader;
    FEditTitle.Left := 22;
    FEditTitle.Top := 17;
    FEditTitle.Caption := 'DATOS DEL ENVASE';
    FEditTitle.Font.Name := 'Sans';
    FEditTitle.Font.Height := -18;
    FEditTitle.Font.Style := [fsBold];
    FEditTitle.Font.Color := clWhite;
    FEditTitle.ParentColor := True;
    FEditTitle.Cursor := crSizeAll;
    FEditTitle.OnMouseDown := @CabeceraEdicionMouseDown;
    FEditTitle.OnMouseMove := @CabeceraEdicionMouseMove;
    FEditTitle.OnMouseUp := @CabeceraEdicionMouseUp;
  end;

  Label1.Caption := 'Código';
  Label2.Caption := 'Descripción';
  Label3.Caption := 'Coste';
  Label4.Caption := 'Margen %';
  Label5.Caption := 'Precio sin IVA';
  Label6.Caption := 'IVA %';
  Label15.Caption := 'Recargo %';
  Label7.Caption := 'P.V.P.';
  Label8.Caption := 'Stock actual';
  Label9.Caption := 'Stock mínimo';
  Label10.Caption := 'Stock máximo';
  Label11.Caption := 'Unidades por artículo';
  Label12.Caption := 'Fecha última compra';
  Label13.Caption := 'Fecha última venta';
  Label14.Caption := 'Proveedor habitual';

  for I := 0 to Panel1.ControlCount - 1 do
  begin
    C := Panel1.Controls[I];
    if C is TLabel then
    begin
      TLabel(C).ParentColor := True;
      TLabel(C).Font.Name := 'Sans';
      TLabel(C).Font.Height := -13;
      TLabel(C).Font.Color := RGBToColor(35, 55, 72);
    end
    else if C is TEdit then
    begin
      TEdit(C).Color := clWhite;
      TEdit(C).Font.Name := 'Sans';
      TEdit(C).Font.Height := -14;
      TEdit(C).Font.Color := RGBToColor(16, 24, 32);
    end;
  end;

  Edit15.Color := RGBToColor(237, 242, 246);

  ConfigurarBoton(BitBtn5, 'Guardar cambios',
    'Guardar el alta o la modificación (F8)', RGBToColor(190, 231, 202));
  ConfigurarBoton(BitBtn6, 'Cancelar',
    'Cancelar la edición y volver al listado (ESC)', RGBToColor(224, 229, 234));

  RecolocarControles;
end;

procedure TFEnvases.RecolocarControles;
var
  EspacioEstado: Integer;
begin
  if Assigned(BitBtn1) then
    BitBtn1.Left := Panel2.ClientWidth - BitBtn1.Width - 20;

  if Assigned(FStatusLabel) then
  begin
    FStatusLabel.Left := BitBtn3.Left + BitBtn3.Width + 18;
    EspacioEstado := BitBtn1.Left - FStatusLabel.Left - 18;
    if EspacioEstado < 120 then EspacioEstado := 120;
    FStatusLabel.Width := EspacioEstado;
    FStatusLabel.Top := 16;
    FStatusLabel.Height := 40;
  end;

  if Panel1.Visible then
  begin
    if not FPanelMovidoPorUsuario then
    begin
      Panel1.Left := (ClientWidth - Panel1.Width) div 2;
      Panel1.Top := FHeaderPanel.Height +
        ((ClientHeight - FHeaderPanel.Height - Panel2.Height - Panel1.Height) div 2);
    end;
    LimitarPanelAlAreaVisible;
    Panel1.BringToFront;
  end;
end;

procedure TFEnvases.LimitarPanelAlAreaVisible;
var
  MaxLeft, MaxTop, MinTop: Integer;
begin
  if not Assigned(Panel1) then Exit;
  MinTop := 88;
  MaxLeft := ClientWidth - Panel1.Width;
  MaxTop := ClientHeight - Panel2.Height - Panel1.Height;
  if MaxLeft < 0 then MaxLeft := 0;
  if MaxTop < MinTop then MaxTop := MinTop;
  if Panel1.Left < 0 then Panel1.Left := 0;
  if Panel1.Left > MaxLeft then Panel1.Left := MaxLeft;
  if Panel1.Top < MinTop then Panel1.Top := MinTop;
  if Panel1.Top > MaxTop then Panel1.Top := MaxTop;
end;

procedure TFEnvases.MostrarPanelEdicion;
begin
  FPanelMovidoPorUsuario := False;
  Panel1.Visible := True;
  RecolocarControles;
  Panel1.BringToFront;
end;

procedure TFEnvases.ActualizarEstado;
begin
  if not Assigned(FStatusLabel) then Exit;
  if dbEnvases.Active then
    FStatusLabel.Caption := Format(
      '%d envases. Pulse una cabecera para ordenar; doble clic para modificar.',
      [dbEnvases.RecordCount])
  else
    FStatusLabel.Caption := 'Listado de envases';
end;

procedure TFEnvases.MarcarColumnaOrdenada(Column: TColumn);
var
  I: Integer;
  S: string;
begin
  for I := 0 to DBGrid1.Columns.Count - 1 do
  begin
    S := DBGrid1.Columns[I].Title.Caption;
    S := StringReplace(S, ' ▲', '', [rfReplaceAll]);
    S := StringReplace(S, ' ▼', '', [rfReplaceAll]);
    DBGrid1.Columns[I].Title.Caption := S;
  end;
  if Assigned(Column) then
  begin
    if FSortAsc then
      Column.Title.Caption := Column.Title.Caption + ' ▲'
    else
      Column.Title.Caption := Column.Title.Caption + ' ▼';
  end;
end;

procedure TFEnvases.FormCreate(Sender: TObject);
begin
  dbEnvases.SQL.Text := 'SELECT * FROM envas ORDER BY EN0';
  dbEnvases.Active := True;

  BitBtn4.Enabled := CheckRoles(dbRoles, CgRol, 'Envases', 2);
  BitBtn3.Enabled := CheckRoles(dbRoles, CgRol, 'Envases', 3);

  FSortField := 'EN0';
  FSortAsc := True;
  FMoviendoPanel := False;
  FPanelMovidoPorUsuario := False;

  AplicarEstiloModerno;
  if DBGrid1.Columns.Count > 0 then
    MarcarColumnaOrdenada(DBGrid1.Columns[0]);
  ActualizarEstado;
end;

procedure TFEnvases.FormShow(Sender: TObject);
begin
  AplicarContrasteSeleccionControles(Self);
  RecolocarControles;
  DBGrid1.SetFocus;
end;

procedure TFEnvases.FormResize(Sender: TObject);
begin
  RecolocarControles;
end;

procedure TFEnvases.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    if Panel1.Visible then
      BitBtn6Click(Sender)
    else
      BitBtn1Click(Sender);
    Exit;
  end;
  if (Key = VK_F2) and (not Panel1.Visible) then
  begin
    Key := 0;
    BitBtn2Click(Sender);
  end
  else if (Key = VK_F3) and (not Panel1.Visible) then
  begin
    Key := 0;
    BitBtn3Click(Sender);
  end
  else if (Key = VK_F8) and Panel1.Visible then
  begin
    Key := 0;
    BitBtn5Click(Sender);
  end;
end;

procedure TFEnvases.CabeceraEdicionMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  P, Origen: TPoint;
begin
  if Button <> mbLeft then Exit;
  if not (Sender is TControl) then Exit;
  P := TControl(Sender).ClientToScreen(Point(X, Y));
  Origen := Panel1.ClientToScreen(Point(0, 0));
  FPanelDragOffset := Point(P.X - Origen.X, P.Y - Origen.Y);
  FMoviendoPanel := True;
  FPanelMovidoPorUsuario := True;
end;

procedure TFEnvases.CabeceraEdicionMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  P, OrigenPadre: TPoint;
begin
  if not FMoviendoPanel then Exit;
  if not (ssLeft in Shift) then
  begin
    FMoviendoPanel := False;
    Exit;
  end;
  if not (Sender is TControl) then Exit;
  P := TControl(Sender).ClientToScreen(Point(X, Y));
  OrigenPadre := ClientToScreen(Point(0, 0));
  Panel1.Left := P.X - FPanelDragOffset.X - OrigenPadre.X;
  Panel1.Top := P.Y - FPanelDragOffset.Y - OrigenPadre.Y;
  LimitarPanelAlAreaVisible;
end;

procedure TFEnvases.CabeceraEdicionMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then Exit;
  FMoviendoPanel := False;
  LimitarPanelAlAreaVisible;
end;

procedure TFEnvases.DBGrid1TitleClick(Column: TColumn);
var
  Direccion: string;
begin
  if (not Assigned(Column)) or (Column.FieldName = '') then Exit;

  if SameText(FSortField, Column.FieldName) then
    FSortAsc := not FSortAsc
  else
  begin
    FSortField := Column.FieldName;
    FSortAsc := True;
  end;

  if FSortAsc then Direccion := ' ASC' else Direccion := ' DESC';

  dbEnvases.DisableControls;
  try
    dbEnvases.Close;
    dbEnvases.SQL.Text := 'SELECT * FROM envas ORDER BY ' +
      FSortField + Direccion;
    dbEnvases.Open;
  finally
    dbEnvases.EnableControls;
  end;
  MarcarColumnaOrdenada(Column);
  ActualizarEstado;
end;

procedure TFEnvases.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if gdSelected in State then
  begin
    DBGrid1.Canvas.Brush.Color := RGBToColor(42, 86, 132);
    DBGrid1.Canvas.Font.Color := clWhite;
  end
  else
  begin
    DBGrid1.Canvas.Brush.Color := clWhite;
    DBGrid1.Canvas.Font.Color := RGBToColor(20, 30, 40);
  end;
  DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TFEnvases.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TFEnvases.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

procedure TFEnvases.BitBtn2Click(Sender: TObject);
begin
  DBGrid1.Enabled := False;
  Panel2.Enabled := False;
  Edit1.Text := '';
  LimpiaDatos;
  Edit1.Enabled := True;
  MostrarPanelEdicion;
  Edit1.SetFocus;
end;

procedure TFEnvases.BitBtn3Click(Sender: TObject);
begin
  if (dbEnvases.RecordCount = 0) or dbEnvases.EOF then
  begin
    ShowMessage('ESE ENVASE NO EXISTE, NO PUEDE BORRARLO');
    Exit;
  end;

  boxstyle := MB_ICONQUESTION + MB_YESNO;
  if Application.MessageBox(
    'Confirme el borrado del envase seleccionado.',
    'FacturLinEx', boxstyle) = IDNO then
    Exit;

  dbEnvases.Delete;
  ActualizarEstado;
end;

procedure TFEnvases.DBGrid1DblClick(Sender: TObject);
begin
  if (dbEnvases.RecordCount = 0) or dbEnvases.EOF then Exit;
  DBGrid1.Enabled := False;
  Panel2.Enabled := False;
  LimpiaDatos;
  PintaDatos;
  Edit1.Enabled := False;
  MostrarPanelEdicion;
  Edit2.SetFocus;
end;

procedure TFEnvases.Edit1Exit(Sender: TObject);
begin
  if Edit1.Text = '' then
  begin
    Edit1.SetFocus;
    Exit;
  end;
  if dbEnvases.Locate('EN0', Edit1.Text, []) then
  begin
    PintaDatos;
    ShowMessage('ESE ENVASE YA EXISTE');
    LimpiaDatos;
    Edit1.Text := '';
    Edit1.SetFocus;
  end;
end;

procedure TFEnvases.BitBtn5Click(Sender: TObject);
begin
  if Edit1.Enabled then
  begin
    if (Edit1.Text = '') or (Edit2.Text = '') then
    begin
      ShowMessage('NO PUEDE CREAR REGISTROS EN BLANCO');
      Exit;
    end;
    if dbEnvases.Locate('EN0', Edit1.Text, []) then
    begin
      ShowMessage('ESE REGISTRO YA EXISTE');
      Exit;
    end;
    dbEnvases.Append;
  end
  else
  begin
    if (Edit1.Text = '') or (Edit2.Text = '') then
    begin
      ShowMessage('NO PUEDE CREAR REGISTROS EN BLANCO');
      Exit;
    end;
    if not dbEnvases.Locate('EN0', Edit1.Text, []) then
    begin
      ShowMessage('ESE REGISTRO NO EXISTE, NO PUEDE MODIFICARLO');
      Exit;
    end;
    dbEnvases.Edit;
  end;

  Relleno;
  dbEnvases.Post;
  BitBtn6Click(BitBtn6);
  ActualizarEstado;
end;

procedure TFEnvases.BitBtn6Click(Sender: TObject);
begin
  Panel1.Visible := False;
  Edit1.Enabled := True;
  DBGrid1.Enabled := True;
  Panel2.Enabled := True;
  FMoviendoPanel := False;
  DBGrid1.SetFocus;
end;

procedure TFEnvases.PintaDatos;
begin
  Edit1.Text := dbEnvases.FieldByName('EN0').AsString;
  Edit2.Text := dbEnvases.FieldByName('EN1').AsString;
  Edit3.Text := dbEnvases.FieldByName('EN2').AsString;
  Edit4.Text := dbEnvases.FieldByName('EN3').AsString;
  Edit5.Text := dbEnvases.FieldByName('EN4').AsString;
  Edit6.Text := dbEnvases.FieldByName('EN5').AsString;
  Edit7.Text := dbEnvases.FieldByName('EN6').AsString;
  Edit8.Text := dbEnvases.FieldByName('EN7').AsString;
  Edit9.Text := dbEnvases.FieldByName('EN8').AsString;
  Edit10.Text := dbEnvases.FieldByName('EN9').AsString;
  Edit11.Text := dbEnvases.FieldByName('EN10').AsString;
  Edit12.Text := dbEnvases.FieldByName('EN11').AsString;
  Edit13.Text := dbEnvases.FieldByName('EN12').AsString;
  Edit14.Text := dbEnvases.FieldByName('EN13').AsString;
  Edit14Exit(Edit14);
end;

procedure TFEnvases.Relleno;
begin
  dbEnvases.FieldByName('EN0').AsString := Edit1.Text;
  dbEnvases.FieldByName('EN1').AsString := Edit2.Text;
  dbEnvases.FieldByName('EN2').AsString := Edit3.Text;
  dbEnvases.FieldByName('EN3').AsString := Edit4.Text;
  dbEnvases.FieldByName('EN4').AsString := Edit5.Text;
  dbEnvases.FieldByName('EN5').AsString := Edit6.Text;
  dbEnvases.FieldByName('EN6').AsString := Edit7.Text;
  dbEnvases.FieldByName('EN7').AsString := Edit8.Text;
  dbEnvases.FieldByName('EN8').AsString := Edit9.Text;
  dbEnvases.FieldByName('EN9').AsString := Edit10.Text;
  dbEnvases.FieldByName('EN10').AsString := Edit11.Text;

  if Edit12.Text = '' then
    dbEnvases.FieldByName('EN11').Value := Null
  else
    dbEnvases.FieldByName('EN11').AsString := Edit12.Text;

  if Edit13.Text = '' then
    dbEnvases.FieldByName('EN12').Value := Null
  else
    dbEnvases.FieldByName('EN12').AsString := Edit13.Text;

  dbEnvases.FieldByName('EN13').AsString := Edit14.Text;
end;

procedure TFEnvases.LimpiaDatos;
begin
  Edit2.Text := '';
  Edit3.Text := '0';
  Edit4.Text := '0';
  Edit5.Text := '0';
  Edit6.Text := '0';
  Edit7.Text := '0';
  Edit8.Text := '0';
  Edit9.Text := '0';
  Edit10.Text := '0';
  Edit11.Text := '0';
  Edit12.Text := '';
  Edit13.Text := '';
  Edit14.Text := '';
  Edit15.Text := '';
  Edit16.Text := '0';
end;

procedure TFEnvases.Edit3Exit(Sender: TObject);
var
  Precio: Double;
begin
  if (Edit3.Text = '0') or (Edit3.Text = '') then Exit;
  if (Edit4.Text = '0') or (Edit4.Text = '') then Exit;
  Precio := (StrToFloat(Edit3.Text) * StrToFloat(Edit4.Text) / 100) +
    StrToFloat(Edit3.Text);
  Edit5.Text := FormatFloat('0.000', Precio);
end;

procedure TFEnvases.Edit4Exit(Sender: TObject);
var
  Precio: Double;
begin
  if (Edit3.Text = '0') or (Edit3.Text = '') then Exit;
  if (Edit4.Text = '0') or (Edit4.Text = '') then Exit;
  Precio := (StrToFloat(Edit3.Text) * StrToFloat(Edit4.Text) / 100) +
    StrToFloat(Edit3.Text);
  Edit5.Text := FormatFloat('0.000', Precio);
end;

procedure TFEnvases.Edit5Exit(Sender: TObject);
var
  PvpSinIva, Margen, CostoCero, PrecioCon, Recargo: Double;
begin
  if (Edit5.Text = '') or (Edit5.Text = '0') then Exit;
  if (Edit3.Text <> '') and (Edit3.Text <> '0') then
  begin
    PvpSinIva := StrToFloat(Edit5.Text);
    Margen := (PvpSinIva - StrToFloat(Edit3.Text)) * 100 /
      StrToFloat(Edit3.Text);
    Edit4.Text := FormatFloat('0.000', Margen);
  end
  else if (Edit4.Text <> '') and (Edit4.Text <> '0') then
  begin
    CostoCero := (100 * StrToFloat(Edit5.Text)) /
      (100 + StrToFloat(Edit4.Text));
    Edit3.Text := FormatFloat('0.000', CostoCero);
    Edit3Exit(Edit3);
  end;

  if (Edit6.Text <> '0') and (Edit6.Text <> '') then
  begin
    Recargo := 0;
    PrecioCon := (StrToFloat(Edit5.Text) * StrToFloat(Edit4.Text) / 100) +
      StrToFloat(Edit5.Text);
    if Edit16.Text <> '0' then
      Recargo := PrecioCon * StrToFloat(Edit16.Text) / 100;
    Edit7.Text := FormatFloat('0.00',
      ((PrecioCon * StrToFloat(Edit6.Text) / 100) + PrecioCon) + Recargo);
  end;
end;

procedure TFEnvases.Edit6Exit(Sender: TObject);
var
  PrecioCon, Recargo: Double;
begin
  if VersiNumero(Edit6.Text) = False then Edit6.Text := '0';
  if (Edit3.Text = '') or (Edit3.Text = '0') then
  begin
    Edit3.Text := '0';
    Exit;
  end;
  if (Edit6.Text = '') or (Edit6.Text = '0') then
  begin
    Edit6.Text := '0';
    Exit;
  end;
  if (Edit16.Text = '') or (Edit16.Text = '0') then Edit16.Text := '0';

  Recargo := 0;
  PrecioCon := (StrToFloat(Edit3.Text) * StrToFloat(Edit4.Text) / 100) +
    StrToFloat(Edit3.Text);
  if Edit16.Text <> '0' then
    Recargo := PrecioCon * StrToFloat(Edit16.Text) / 100;
  Edit7.Text := FormatFloat('0.00',
    ((PrecioCon * StrToFloat(Edit6.Text) / 100) + PrecioCon) + Recargo);
end;

procedure TFEnvases.Edit16Exit(Sender: TObject);
var
  PrecioCon, Recargo: Double;
begin
  if VersiNumero(Edit16.Text) = False then Edit16.Text := '0';
  if (Edit3.Text = '') or (Edit3.Text = '0') then
  begin
    Edit3.Text := '0';
    Exit;
  end;
  if (Edit6.Text = '') or (Edit6.Text = '0') then
  begin
    Edit6.Text := '0';
    Exit;
  end;
  if (Edit16.Text = '') or (Edit16.Text = '0') then Edit16.Text := '0';

  Recargo := 0;
  PrecioCon := (StrToFloat(Edit3.Text) * StrToFloat(Edit4.Text) / 100) +
    StrToFloat(Edit3.Text);
  if Edit16.Text <> '0' then
    Recargo := PrecioCon * StrToFloat(Edit16.Text) / 100;
  Edit7.Text := FormatFloat('0.00',
    ((PrecioCon * StrToFloat(Edit6.Text) / 100) + PrecioCon) + Recargo);
end;

procedure TFEnvases.Edit7Exit(Sender: TObject);
var
  PrecioSin: Double;
begin
  if (Edit7.Text = '') or (Edit7.Text = '0') then Exit;
  if (Edit6.Text = '') or (Edit6.Text = '0') then Exit;
  PrecioSin := (100 * StrToFloat(Edit7.Text)) /
    (100 + StrToFloat(Edit6.Text));
  Edit5.Text := FormatFloat('0.000', PrecioSin);
  Edit5Exit(Edit5);
end;

procedure TFEnvases.Edit14Enter(Sender: TObject);
begin
  Edit15.Text := '';
end;

procedure TFEnvases.Edit14Exit(Sender: TObject);
begin
  if Edit14.Text = '' then Exit;
  dbProve.Active := False;
  dbProve.SQL.Text := 'SELECT P0,P1 FROM proveedores WHERE P0=' + Edit14.Text;
  dbProve.Active := True;
  if dbProve.RecordCount = 0 then Exit;
  Edit15.Text := dbProve.FieldByName('P1').AsString;
end;

initialization
  {$I Envases.lrs}

end.
