unit uFLXTemaVisual;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, ExtCtrls, StdCtrls, ComCtrls;

type
  TFLXTemaVisual = (
    tvNormal,
    tvContrasteReforzado,
    tvAltoContraste
  );

function FLXTemaVisualDesdeTexto(const ATexto: string): TFLXTemaVisual;
function FLXTemaVisualATexto(ATema: TFLXTemaVisual): string;
function FLXColorTema(const AColor: TColor; ATema: TFLXTemaVisual): TColor;
procedure FLXAplicarTemaVisual(ARaiz: TWinControl); overload;
procedure FLXAplicarTemaVisual(ARaiz: TWinControl;
  ATema: TFLXTemaVisual); overload;
procedure FLXAplicarTemaEnFormulariosAbiertos;

implementation

uses
  Global;

type
  TFLXColorSlot = (fcsColor, fcsBrush, fcsPen);

  { Las superficies claras no deben tratarse todas igual. Un panel emergente,
    una zona interior, una pestaña y una tarjeta necesitan intensidades
    distintas para que sus límites sean perceptibles en monitores con poco
    contraste. Los campos de edición y grids no pasan por estas categorías. }
  TFLXTipoSuperficie = (
    ftsGeneral,
    ftsPanelExterior,
    ftsPanelInterior,
    ftsPestana,
    ftsTarjeta,
    ftsBordeTarjeta
  );

  TFLXColoresOriginales = class
  public
    Componente: TComponent;
    TieneColor: Boolean;
    TieneBrush: Boolean;
    TienePen: Boolean;
    Color: TColor;
    BrushColor: TColor;
    PenColor: TColor;
  end;

  { Conserva los colores originales de cada control. Así, NORMAL recupera
    exactamente el diseño actual incluso después de probar otro contraste. }
  TFLXRegistroTema = class(TComponent)
  private
    FElementos: TList;
    function Buscar(AComponente: TComponent): TFLXColoresOriginales;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create;
    destructor Destroy; override;
    function ColorOriginal(AComponente: TComponent; ASlot: TFLXColorSlot;
      AColorActual: TColor): TColor;
  end;

var
  GRegistroTema: TFLXRegistroTema = nil;

constructor TFLXRegistroTema.Create;
begin
  inherited Create(nil);
  FElementos := TList.Create;
end;

destructor TFLXRegistroTema.Destroy;
var
  I: Integer;
  LElemento: TFLXColoresOriginales;
begin
  for I := FElementos.Count - 1 downto 0 do
  begin
    LElemento := TFLXColoresOriginales(FElementos[I]);
    if Assigned(LElemento.Componente) then
      LElemento.Componente.RemoveFreeNotification(Self);
    LElemento.Free;
  end;
  FElementos.Free;
  inherited Destroy;
end;

function TFLXRegistroTema.Buscar(
  AComponente: TComponent): TFLXColoresOriginales;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FElementos.Count - 1 do
    if TFLXColoresOriginales(FElementos[I]).Componente = AComponente then
      Exit(TFLXColoresOriginales(FElementos[I]));
end;

procedure TFLXRegistroTema.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  I: Integer;
begin
  inherited Notification(AComponent, Operation);
  if Operation <> opRemove then Exit;

  for I := FElementos.Count - 1 downto 0 do
    if TFLXColoresOriginales(FElementos[I]).Componente = AComponent then
    begin
      TFLXColoresOriginales(FElementos[I]).Free;
      FElementos.Delete(I);
    end;
end;

function TFLXRegistroTema.ColorOriginal(AComponente: TComponent;
  ASlot: TFLXColorSlot; AColorActual: TColor): TColor;
var
  LElemento: TFLXColoresOriginales;
begin
  LElemento := Buscar(AComponente);
  if not Assigned(LElemento) then
  begin
    LElemento := TFLXColoresOriginales.Create;
    LElemento.Componente := AComponente;
    FElementos.Add(LElemento);
    AComponente.FreeNotification(Self);
  end;

  case ASlot of
    fcsBrush:
      begin
        if not LElemento.TieneBrush then
        begin
          LElemento.BrushColor := AColorActual;
          LElemento.TieneBrush := True;
        end;
        Result := LElemento.BrushColor;
      end;
    fcsPen:
      begin
        if not LElemento.TienePen then
        begin
          LElemento.PenColor := AColorActual;
          LElemento.TienePen := True;
        end;
        Result := LElemento.PenColor;
      end;
  else
    begin
      if not LElemento.TieneColor then
      begin
        LElemento.Color := AColorActual;
        LElemento.TieneColor := True;
      end;
      Result := LElemento.Color;
    end;
  end;
end;

function RegistroTema: TFLXRegistroTema;
begin
  if not Assigned(GRegistroTema) then
    GRegistroTema := TFLXRegistroTema.Create;
  Result := GRegistroTema;
end;

function FLXTemaVisualDesdeTexto(const ATexto: string): TFLXTemaVisual;
var
  S: string;
begin
  S := UpperCase(Trim(ATexto));
  if (S = 'ALTO') or (S = 'ALTO CONTRASTE') or
     (S = 'ALTO_CONTRASTE') then
    Result := tvAltoContraste
  else if (S = 'REFORZADO') or (S = 'CONTRASTE REFORZADO') or
          (S = 'CONTRASTE_REFORZADO') then
    Result := tvContrasteReforzado
  else
    Result := tvNormal;
end;

function FLXTemaVisualATexto(ATema: TFLXTemaVisual): string;
begin
  case ATema of
    tvContrasteReforzado: Result := 'REFORZADO';
    tvAltoContraste:     Result := 'ALTO';
  else
    Result := 'NORMAL';
  end;
end;

function FLXColorTema(const AColor: TColor; ATema: TFLXTemaVisual): TColor;
var
  LColor: TColor;

  function Triple(ANormal, AReforzado, AAlto: TColor;
    out AResultado: TColor): Boolean;
  begin
    Result := LColor = ColorToRGB(ANormal);
    if not Result then Exit;

    case ATema of
      tvContrasteReforzado: AResultado := AReforzado;
      tvAltoContraste:      AResultado := AAlto;
    else
      AResultado := ANormal;
    end;
  end;

begin
  Result := AColor;
  if (AColor = clNone) or (AColor = clDefault) then Exit;

  LColor := ColorToRGB(AColor);

  { Fondos generales: cambian poco para que las tarjetas destaquen. }
  if Triple(RGBToColor(241, 245, 247), RGBToColor(234, 240, 243),
    RGBToColor(224, 233, 237), Result) then Exit;
  if Triple(RGBToColor(248, 250, 251), RGBToColor(242, 246, 248),
    RGBToColor(232, 239, 243), Result) then Exit;
  if Triple(RGBToColor(248, 250, 252), RGBToColor(242, 246, 249),
    RGBToColor(232, 239, 245), Result) then Exit;
  if Triple(RGBToColor(250, 251, 252), RGBToColor(245, 248, 250),
    RGBToColor(236, 242, 246), Result) then Exit;
  if Triple(RGBToColor(247, 249, 250), RGBToColor(239, 244, 247),
    RGBToColor(228, 236, 241), Result) then Exit;
  if Triple(RGBToColor(243, 248, 251), RGBToColor(232, 242, 247),
    RGBToColor(216, 232, 240), Result) then Exit;
  if Triple(RGBToColor(240, 248, 252), RGBToColor(222, 239, 247),
    RGBToColor(199, 226, 239), Result) then Exit;
  if Triple(RGBToColor(244, 254, 254), RGBToColor(225, 246, 246),
    RGBToColor(199, 234, 234), Result) then Exit;

  { Azules pastel estructurales. }
  if Triple(RGBToColor(226, 238, 242), RGBToColor(204, 224, 231),
    RGBToColor(178, 207, 217), Result) then Exit;
  if Triple(RGBToColor(225, 233, 236), RGBToColor(201, 218, 224),
    RGBToColor(174, 198, 207), Result) then Exit;
  if Triple(RGBToColor(219, 234, 239), RGBToColor(193, 218, 227),
    RGBToColor(164, 198, 211), Result) then Exit;
  if Triple(RGBToColor(205, 225, 234), RGBToColor(177, 207, 221),
    RGBToColor(144, 184, 203), Result) then Exit;
  if Triple(RGBToColor(219, 234, 254), RGBToColor(184, 215, 251),
    RGBToColor(144, 191, 246), Result) then Exit;
  if Triple(RGBToColor(228, 240, 252), RGBToColor(194, 220, 247),
    RGBToColor(157, 197, 239), Result) then Exit;
  if Triple(RGBToColor(239, 244, 249), RGBToColor(220, 232, 243),
    RGBToColor(193, 214, 233), Result) then Exit;
  if Triple(RGBToColor(232, 239, 246), RGBToColor(205, 219, 231),
    RGBToColor(174, 198, 219), Result) then Exit;

  { Verdes pastel estructurales. }
  if Triple(RGBToColor(231, 243, 234), RGBToColor(205, 231, 213),
    RGBToColor(174, 216, 188), Result) then Exit;
  if Triple(RGBToColor(232, 244, 236), RGBToColor(205, 232, 214),
    RGBToColor(173, 217, 189), Result) then Exit;
  if Triple(RGBToColor(236, 246, 237), RGBToColor(211, 234, 215),
    RGBToColor(181, 220, 188), Result) then Exit;
  if Triple(RGBToColor(220, 252, 231), RGBToColor(188, 239, 207),
    RGBToColor(145, 224, 177), Result) then Exit;
  if Triple(clMoneyGreen, RGBToColor(190, 225, 199),
    RGBToColor(151, 207, 169), Result) then Exit;

  { Morados y amarillos pastel estructurales. }
  if Triple(RGBToColor(239, 235, 247), RGBToColor(218, 207, 239),
    RGBToColor(190, 171, 226), Result) then Exit;
  if Triple(RGBToColor(242, 238, 226), RGBToColor(229, 216, 184),
    RGBToColor(211, 191, 139), Result) then Exit;
  if Triple(RGBToColor(255, 251, 235), RGBToColor(250, 236, 185),
    RGBToColor(244, 220, 128), Result) then Exit;
  if Triple(RGBToColor(255, 247, 204), RGBToColor(250, 224, 145),
    RGBToColor(240, 199, 80), Result) then Exit;
  if Triple(clCream, RGBToColor(245, 231, 175),
    RGBToColor(235, 207, 112), Result) then Exit;

  { Grises y colores clásicos usados como paneles. }
  if Triple(RGBToColor(239, 242, 244), RGBToColor(222, 228, 232),
    RGBToColor(198, 210, 218), Result) then Exit;
  if Triple(RGBToColor(244, 244, 244), RGBToColor(226, 229, 231),
    RGBToColor(201, 208, 213), Result) then Exit;
  if Triple(clSilver, RGBToColor(180, 188, 194),
    RGBToColor(150, 165, 175), Result) then Exit;
  if Triple(clSkyBlue, RGBToColor(104, 184, 218),
    RGBToColor(72, 154, 198), Result) then Exit;

  { Bordes de tarjetas TShape. }
  if Triple(RGBToColor(207, 218, 224), RGBToColor(147, 165, 176),
    RGBToColor(103, 129, 143), Result) then Exit;
  if Triple(RGBToColor(218, 226, 230), RGBToColor(161, 176, 184),
    RGBToColor(117, 139, 151), Result) then Exit;
  if Triple(RGBToColor(203, 213, 225), RGBToColor(142, 159, 180),
    RGBToColor(94, 119, 149), Result) then Exit;
end;

function FLXEsBlancoEstructural(const AColor: TColor): Boolean;
var
  C: TColor;
begin
  if (AColor = clNone) or (AColor = clDefault) then Exit(False);
  C := ColorToRGB(AColor);
  Result := (C = ColorToRGB(clWhite)) or
            (C = ColorToRGB(clWindow));
end;

function FLXEsFondoSistemaEstructural(const AColor: TColor): Boolean;
begin
  if (AColor = clNone) or (AColor = clDefault) then Exit(False);
  Result := ColorToRGB(AColor) = ColorToRGB(clBtnFace);
end;

function FLXColorSuperficie(const AColor: TColor; ATema: TFLXTemaVisual;
  ATipo: TFLXTipoSuperficie): TColor;
begin
  { Primero se aplican las equivalencias normales de la paleta existente. }
  Result := FLXColorTema(AColor, ATema);
  if ATema = tvNormal then Exit(AColor);

  { Los blancos de controles de entrada NO llegan a esta función. Solo se
    llama para contenedores estructurales y tarjetas. }
  if FLXEsBlancoEstructural(AColor) then
  begin
    case ATipo of
      ftsPanelExterior:
        case ATema of
          tvContrasteReforzado: Result := RGBToColor(212, 235, 245);
          tvAltoContraste:      Result := RGBToColor(180, 217, 233);
        end;
      ftsPanelInterior:
        case ATema of
          tvContrasteReforzado: Result := RGBToColor(239, 246, 249);
          tvAltoContraste:      Result := RGBToColor(220, 235, 242);
        end;
      ftsPestana:
        case ATema of
          tvContrasteReforzado: Result := RGBToColor(227, 240, 247);
          tvAltoContraste:      Result := RGBToColor(202, 225, 238);
        end;
      ftsTarjeta:
        case ATema of
          tvContrasteReforzado: Result := RGBToColor(245, 250, 252);
          tvAltoContraste:      Result := RGBToColor(231, 242, 247);
        end;
    else
      case ATema of
        tvContrasteReforzado: Result := RGBToColor(232, 243, 248);
        tvAltoContraste:      Result := RGBToColor(207, 228, 239);
      end;
    end;
    Exit;
  end;

  { Algunos paneles heredados usan clBtnFace. En contraste reforzado se
    convierten en una superficie neutra claramente distinta del formulario. }
  if FLXEsFondoSistemaEstructural(AColor) and
     (ATipo in [ftsPanelExterior, ftsPanelInterior, ftsPestana]) then
  begin
    if ATipo = ftsPanelInterior then
      case ATema of
        tvContrasteReforzado: Result := RGBToColor(232, 238, 242);
        tvAltoContraste:      Result := RGBToColor(207, 219, 227);
      end
    else
      case ATema of
        tvContrasteReforzado: Result := RGBToColor(218, 229, 236);
        tvAltoContraste:      Result := RGBToColor(188, 207, 220);
      end;
  end;

  { Borde exacto de las tarjetas modernas de Ventas (CBorde = 214,224,235).
    Se refuerza sin tocar bordes de campos ni colores funcionales. }
  if (ATipo = ftsBordeTarjeta) and
     (ColorToRGB(AColor) = ColorToRGB(RGBToColor(214, 224, 235))) then
    case ATema of
      tvContrasteReforzado: Result := RGBToColor(119, 151, 171);
      tvAltoContraste:      Result := RGBToColor(69, 108, 132);
    end;
end;

function FLXColorPerteneceSuperficie(AColorActual, AColorOriginal: TColor;
  ATipo: TFLXTipoSuperficie): Boolean;

  function Iguales(A, B: TColor): Boolean;
  begin
    if (A = clNone) or (A = clDefault) or
       (B = clNone) or (B = clDefault) then
      Result := A = B
    else
      Result := ColorToRGB(A) = ColorToRGB(B);
  end;

begin
  Result := Iguales(AColorActual,
      FLXColorSuperficie(AColorOriginal, tvNormal, ATipo)) or
    Iguales(AColorActual,
      FLXColorSuperficie(AColorOriginal, tvContrasteReforzado, ATipo)) or
    Iguales(AColorActual,
      FLXColorSuperficie(AColorOriginal, tvAltoContraste, ATipo));
end;

function FLXColorPerteneceAlTema(AColorActual, AColorOriginal: TColor): Boolean;

  function Iguales(A, B: TColor): Boolean;
  begin
    if (A = clNone) or (A = clDefault) or
       (B = clNone) or (B = clDefault) then
      Result := A = B
    else
      Result := ColorToRGB(A) = ColorToRGB(B);
  end;

begin
  Result := Iguales(AColorActual,
      FLXColorTema(AColorOriginal, tvNormal)) or
    Iguales(AColorActual,
      FLXColorTema(AColorOriginal, tvContrasteReforzado)) or
    Iguales(AColorActual,
      FLXColorTema(AColorOriginal, tvAltoContraste));
end;

procedure FLXAplicarTemaVisual(ARaiz: TWinControl;
  ATema: TFLXTemaVisual);

  procedure AplicarAControl(AControl: TControl);
  var
    I: Integer;
    LActual: TColor;
    LOriginal: TColor;
  begin
    if AControl is TForm then
    begin
      LActual := TForm(AControl).Color;
      LOriginal := RegistroTema.ColorOriginal(AControl, fcsColor, LActual);
      if FLXColorPerteneceAlTema(LActual, LOriginal) then
        TForm(AControl).Color := FLXColorTema(LOriginal, ATema);
    end
    else if AControl is TPanel then
    begin
      LActual := TPanel(AControl).Color;
      LOriginal := RegistroTema.ColorOriginal(AControl, fcsColor, LActual);
      if TPanel(AControl).Parent is TPanel then
      begin
        if FLXColorPerteneceSuperficie(LActual, LOriginal,
          ftsPanelInterior) then
          TPanel(AControl).Color := FLXColorSuperficie(LOriginal, ATema,
            ftsPanelInterior);
      end
      else
      begin
        if FLXColorPerteneceSuperficie(LActual, LOriginal,
          ftsPanelExterior) then
          TPanel(AControl).Color := FLXColorSuperficie(LOriginal, ATema,
            ftsPanelExterior);
      end;
    end
    else if AControl is TGroupBox then
    begin
      LActual := TGroupBox(AControl).Color;
      LOriginal := RegistroTema.ColorOriginal(AControl, fcsColor, LActual);
      if FLXColorPerteneceSuperficie(LActual, LOriginal,
        ftsPanelInterior) then
        TGroupBox(AControl).Color := FLXColorSuperficie(LOriginal, ATema,
          ftsPanelInterior);
    end
    else if AControl is TRadioGroup then
    begin
      LActual := TRadioGroup(AControl).Color;
      LOriginal := RegistroTema.ColorOriginal(AControl, fcsColor, LActual);
      if FLXColorPerteneceSuperficie(LActual, LOriginal,
        ftsPanelInterior) then
        TRadioGroup(AControl).Color := FLXColorSuperficie(LOriginal, ATema,
          ftsPanelInterior);
    end
    else if AControl is TCheckGroup then
    begin
      LActual := TCheckGroup(AControl).Color;
      LOriginal := RegistroTema.ColorOriginal(AControl, fcsColor, LActual);
      if FLXColorPerteneceSuperficie(LActual, LOriginal,
        ftsPanelInterior) then
        TCheckGroup(AControl).Color := FLXColorSuperficie(LOriginal, ATema,
          ftsPanelInterior);
    end
    else if AControl is TTabSheet then
    begin
      LActual := TTabSheet(AControl).Color;
      LOriginal := RegistroTema.ColorOriginal(AControl, fcsColor, LActual);
      if FLXColorPerteneceSuperficie(LActual, LOriginal, ftsPestana) then
        TTabSheet(AControl).Color := FLXColorSuperficie(LOriginal, ATema,
          ftsPestana);
    end
    else if AControl is TPageControl then
    begin
      LActual := TPageControl(AControl).Color;
      LOriginal := RegistroTema.ColorOriginal(AControl, fcsColor, LActual);
      if FLXColorPerteneceSuperficie(LActual, LOriginal, ftsPestana) then
        TPageControl(AControl).Color := FLXColorSuperficie(LOriginal, ATema,
          ftsPestana);
    end
    else if AControl is TScrollBox then
    begin
      LActual := TScrollBox(AControl).Color;
      LOriginal := RegistroTema.ColorOriginal(AControl, fcsColor, LActual);
      if FLXColorPerteneceSuperficie(LActual, LOriginal,
        ftsPanelInterior) then
        TScrollBox(AControl).Color := FLXColorSuperficie(LOriginal, ATema,
          ftsPanelInterior);
    end
    else if AControl is TStaticText then
    begin
      LActual := TStaticText(AControl).Color;
      LOriginal := RegistroTema.ColorOriginal(AControl, fcsColor, LActual);
      if FLXColorPerteneceAlTema(LActual, LOriginal) then
        TStaticText(AControl).Color := FLXColorTema(LOriginal, ATema);
    end
    else if AControl is TShape then
    begin
      LActual := TShape(AControl).Brush.Color;
      LOriginal := RegistroTema.ColorOriginal(AControl, fcsBrush, LActual);
      if FLXColorPerteneceSuperficie(LActual, LOriginal, ftsTarjeta) then
        TShape(AControl).Brush.Color := FLXColorSuperficie(LOriginal, ATema,
          ftsTarjeta);

      LActual := TShape(AControl).Pen.Color;
      LOriginal := RegistroTema.ColorOriginal(AControl, fcsPen, LActual);
      if FLXColorPerteneceSuperficie(LActual, LOriginal,
        ftsBordeTarjeta) then
        TShape(AControl).Pen.Color := FLXColorSuperficie(LOriginal, ATema,
          ftsBordeTarjeta);
    end;

    if AControl is TWinControl then
      for I := 0 to TWinControl(AControl).ControlCount - 1 do
        AplicarAControl(TWinControl(AControl).Controls[I]);
  end;

begin
  if not Assigned(ARaiz) then Exit;
  AplicarAControl(ARaiz);
  ARaiz.Invalidate;
end;

procedure FLXAplicarTemaVisual(ARaiz: TWinControl);
begin
  FLXAplicarTemaVisual(ARaiz,
    FLXTemaVisualDesdeTexto(ContrasteInterfaz));
end;

procedure FLXAplicarTemaEnFormulariosAbiertos;
var
  I: Integer;
begin
  for I := 0 to Screen.FormCount - 1 do
    if Assigned(Screen.Forms[I]) then
      FLXAplicarTemaVisual(Screen.Forms[I]);
end;

finalization
  FreeAndNil(GRegistroTema);

end.
