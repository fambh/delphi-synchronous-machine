unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls,  StdCtrls, jpeg, Math, Buttons;

type
  TForm1 = class(TForm)
    pnlCorrentes: TPanel;
    imgBkCorrentes: TImage;
    tbPosicao: TTrackBar;
    lblPosicao: TLabel;
    imgFasores: TImage;
    tmrAuto: TTimer;
    chkAuto: TCheckBox;
    Image1: TImage;
    shpPos: TShape;
    chkFaseA: TCheckBox;
    chkFaseB: TCheckBox;
    chkFaseC: TCheckBox;
    chkResultante: TCheckBox;
    Bevel1: TBevel;
    lblF1: TLabel;
    lblF2: TLabel;
    lblF3: TLabel;
    lblR: TLabel;
    procedure tbPosicaoChange(Sender: TObject);
    procedure chkAutoClick(Sender: TObject);
    procedure tmrAutoTimer(Sender: TObject);
  private
    procedure DesenhaFasores;
    procedure DesenhaFlecha(Rect: TRect; Color: TColor);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

const
  _WF = 100;
  _SetaSize = 10;

implementation

{$R *.dfm}

procedure TForm1.tbPosicaoChange(Sender: TObject);
begin
  lblPosicao.Caption := 'Posição: ' + IntToStr(tbPosicao.Position) + '°';

  shpPos.Left := 385 + Round((396/360)*tbPosicao.Position);

  DesenhaFasores;
end;

// L 158 T 160

procedure TForm1.DesenhaFasores;
var
  iFasorA, iFasorB, iFasorC: Integer;
  pCenter, pTamA, pTamB, pTamC, pTamR: TPoint;
begin
  imgFasores.Canvas.Brush.Color := clWhite;
  imgFasores.Canvas.FillRect(Rect(1,1,320,320));

  pCenter := Point(158, 160);

  iFasorA := Round(_WF * Sin(DegToRad(tbPosicao.Position)));
  pTamA := Point(iFasorA, 0);

  iFasorB := Round(_WF * Sin(DegToRad(tbPosicao.Position - 120)));
  pTamB := Point(Round(Cos(-2*Pi/3)*iFasorB), Round(Sin(-2*Pi/3)*iFasorB));

  iFasorC := Round(_WF * Sin(DegToRad(tbPosicao.Position + 120)));
  pTamC := Point(Round(Cos(2*Pi/3)*iFasorC), Round(Sin(2*Pi/3)*iFasorC));

{  iFasorA := Round(_WF * Sin(DegToRad(tbPosicao.Position)));
  pTamA := Point(iFasorA, 0);

  iFasorB := Round(_WF * Sin(DegToRad(tbPosicao.Position - 120)));
  pTamB := Point(Round(Sin(1*Pi/6)*iFasorB), Round(Cos(1*Pi/6)*iFasorB));  // 120 - 90 = 30

  iFasorC := Round(_WF * Sin(DegToRad(tbPosicao.Position + 120)));
  pTamC := Point(Round(Sin(-4*Pi/3)*iFasorC), Round(Cos(2*Pi/3)*iFasorC));}


  if chkFaseA.Checked then
  begin
    imgFasores.Canvas.Pen.Width := 3;
    imgFasores.Canvas.Pen.Color := clBlue;

    imgFasores.Canvas.MoveTo(pCenter.X, pCenter.Y);
    imgFasores.Canvas.LineTo(pCenter.X + pTamA.X, pCenter.Y + pTamA.Y);

    if Abs(iFasorA) > _SetaSize then
      DesenhaFlecha(Rect(pCenter.X, pCenter.Y, pCenter.X + pTamA.X, pCenter.Y + pTamA.Y), clBlue);

    lblF1.Caption := FormatFloat('#0.00', iFasorA/_WF);
    lblF2.Caption := FormatFloat('#0.00', iFasorB/_WF);
    lblF3.Caption := FormatFloat('#0.00', iFasorC/_WF);
  end;

  if chkFaseB.Checked then
  begin
    imgFasores.Canvas.Pen.Width := 3;
    imgFasores.Canvas.Pen.Color := clRed;

    imgFasores.Canvas.MoveTo(pCenter.X, pCenter.Y);
    imgFasores.Canvas.LineTo(pCenter.X + pTamB.X, pCenter.Y + pTamB.Y);

    if Abs(iFasorB) > _SetaSize then
      DesenhaFlecha(Rect(pCenter.X, pCenter.Y, pCenter.X + pTamB.X, pCenter.Y + pTamB.Y), clRed);
  end;

  if chkFaseC.Checked then
  begin

    imgFasores.Canvas.Pen.Width := 3;
    imgFasores.Canvas.Pen.Color := clBlack;

    imgFasores.Canvas.MoveTo(pCenter.X, pCenter.Y);
    imgFasores.Canvas.LineTo(pCenter.X + pTamC.X, pCenter.Y + pTamC.Y);

    if Abs(iFasorC) > _SetaSize then
      DesenhaFlecha(Rect(pCenter.X, pCenter.Y, pCenter.X + pTamC.X, pCenter.Y + pTamC.Y), clBlack);
  end;

  if chkResultante.Checked then
  begin
    imgFasores.Canvas.Pen.Width := 1;

    if not chkFaseA.Checked then
    begin
      imgFasores.Canvas.Pen.Color := clBlue;
      imgFasores.Canvas.MoveTo(pCenter.X, pCenter.Y);
      imgFasores.Canvas.LineTo(pCenter.X + pTamA.X, pCenter.Y + pTamA.Y);
    end;

    imgFasores.Canvas.Pen.Color := clRed;
    imgFasores.Canvas.MoveTo(pCenter.X + pTamA.X, pCenter.Y + pTamA.Y);
    imgFasores.Canvas.LineTo(pCenter.X + pTamA.X + pTamB.X, pCenter.Y + pTamA.Y + pTamB.Y);

    imgFasores.Canvas.Pen.Color := clBlack;
    imgFasores.Canvas.LineTo(pCenter.X + pTamA.X + pTamB.X + pTamC.X, pCenter.Y + pTamA.Y + pTamB.Y + pTamC.Y);

    imgFasores.Canvas.Pen.Width := 3;
    imgFasores.Canvas.Pen.Color := clPurple;
    imgFasores.Canvas.Pen.Style := psSolid;

    imgFasores.Canvas.MoveTo(pCenter.X, pCenter.Y);

    pTamR.X := pTamA.X + pTamB.X + pTamC.X;
    pTamR.Y := pTamA.Y + pTamB.Y + pTamC.Y;

    if Abs(pTamR.X) < 2 then
      pTamR.X := 0;

    if Abs(pTamR.Y) < 2 then
      pTamR.Y := 0;

    imgFasores.Canvas.LineTo(pCenter.X + pTamR.X, pCenter.Y + pTamR.Y);

    DesenhaFlecha(Rect(pCenter.X, pCenter.Y, pCenter.X + pTamR.X, pCenter.Y + pTamR.Y), clPurple);
  end;
end;


procedure TForm1.DesenhaFlecha(Rect: TRect; Color: TColor);
var
  a0, a1, a2: Extended; // Ângulos para desenho das setas
  pArrow: array[1..3] of TPoint;
begin
  { Ponta da Seta }

  imgFasores.Canvas.Pen.Width := 1;
  imgFasores.Canvas.Pen.Color := Color;
  imgFasores.Canvas.Brush.Color := Color;


  pArrow[1] := Rect.BottomRight;


  if Rect.BottomRight.X = Rect.TopLeft.X then
    a0 := pi/2
  else
    a0 := ArcTan( -1*(Rect.BottomRight.Y - Rect.TopLeft.Y) / (Rect.BottomRight.X - Rect.TopLeft.X) );

  a1 := DegToRad(30) - a0;
  a2 := DegToRad(60) - a0;

  if (Rect.BottomRight.X > Rect.TopLeft.X) or ((Rect.BottomRight.X = Rect.TopLeft.X) and (Rect.BottomRight.Y < Rect.TopLeft.Y)) then
  begin

    pArrow[2].X := Rect.BottomRight.X - Round(_SetaSize*cos(a1));
    pArrow[2].Y := Rect.BottomRight.Y - Round(_SetaSize*sin(a1));

    pArrow[3].X := Rect.BottomRight.X - Round(_SetaSize*sin(a2));
    pArrow[3].Y := Rect.BottomRight.Y + Round(_SetaSize*cos(a2));

  end
  else
  begin

    pArrow[2].X := Rect.BottomRight.X + Round(_SetaSize*cos(a1));
    pArrow[2].Y := Rect.BottomRight.Y + Round(_SetaSize*sin(a1));

    pArrow[3].X := Rect.BottomRight.X + Round(_SetaSize*sin(a2));
    pArrow[3].Y := Rect.BottomRight.Y - Round(_SetaSize*cos(a2));

  end;

  imgFasores.Canvas.Brush.Style := bsSolid;
  imgFasores.Canvas.Brush.Color := Color;
  imgFasores.Canvas.Polygon(pArrow);
end;



procedure TForm1.chkAutoClick(Sender: TObject);
begin
//  if not tmrAuto.Enabled then
//    tbPosicao.Position := 0;
  tmrAuto.Enabled := chkAuto.Checked;
end;

procedure TForm1.tmrAutoTimer(Sender: TObject);
begin
  if tbPosicao.Position = 360 then
    tbPosicao.Position := 5;

  tbPosicao.Position := tbPosicao.Position + 5;
end;

end.
