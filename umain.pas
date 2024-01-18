unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, StdCtrls;

type

  { TfMain }

  TfMain = class(TForm)
    IdleTimer1: TIdleTimer;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    miQuit: TMenuItem;
    PopupMenu1: TPopupMenu;
    TrayIcon1: TTrayIcon;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure IdleTimer1Timer(Sender: TObject);
    procedure miQuitClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fMain: TfMain;

{Function SetLayeredWindowAttributes Lib "user32" (ByVal hWnd As Long, ByVal Color As Long, ByVal X As Byte, ByVal alpha As Long) As Boolean }
function SetLayeredWindowAttributes(hWnd: longint; Color: longint;
  X: byte; Alpha: longint): boolean; stdcall; external 'USER32';

{not sure how to alias these functions here ????   alias setwindowlonga!!}
{Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long }
function SetWindowLongA(hWnd: longint; nIndex: longint; dwNewLong: longint): longint;
  stdcall; external 'USER32';

{Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As Long) As Long }
function GetWindowLongA(hWnd: longint; nIndex: longint): longint;
  stdcall; external 'user32';

implementation

{$R *.lfm}

const
  WS_EX_LAYERED = $80000;
  GWL_EXSTYLE = -20;

var
  OldX, OldY: integer;
  MoveOn: boolean;

procedure SetTranslucent(ThehWnd: longint; Color: longint; nTrans: integer);
var
  Attrib: longint;
begin
  { SetWindowLong and SetLayeredWindowAttributes are API functions, see MSDN for details }
  Attrib := GetWindowLongA(ThehWnd, GWL_EXSTYLE);
  SetWindowLongA(ThehWnd, GWL_EXSTYLE, attrib or WS_EX_LAYERED);
  { anything with color value color will completely disappear if flag = 1 or flag = 3  }
  SetLayeredWindowAttributes(ThehWnd, Color, nTrans, 1);
end;

{ TfMain }

procedure TfMain.FormCreate(Sender: TObject);
var
  c: TColor;
begin
  fMain.BorderStyle := bsNone;
  fMain.BorderIcons := [];
  Image3.Picture := Image2.Picture;
  fMain.Width := Image3.Width;
  fMain.Height := Image3.Height;
  c := clWhite;
  fMain.Color := c;
  SetTranslucent(fMain.Handle, c, 0);

  fMain.Left := Screen.Width - fMain.Width - 20;
  fMain.Top := Screen.Height - fMain.Height - 50; // Taskbar Height = 30
end;

procedure TfMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  MoveOn := True;
  OldX := X;
  OldY := Y;
end;

procedure TfMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
begin
  if MoveOn then
  begin
    Left := (Left - OldX) + X;
    Top := (Top - OldY) + Y;
  end;
end;

procedure TfMain.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  MoveOn := False;
end;

procedure TfMain.IdleTimer1Timer(Sender: TObject);
var
  mpt: TPoint;
begin
  IdleTimer1.Enabled := False;
  mpt := Image3.ScreenToClient(Mouse.CursorPos);
  if (mpt.x > 0) and (mpt.x < Image3.Width) and (mpt.y > 0) and
    (mpt.y < Image3.Height) then
    Image3.Picture := Image1.Picture
  else
    Image3.Picture := Image2.Picture;
  IdleTimer1.Enabled := True;
end;

procedure TfMain.miQuitClick(Sender: TObject);
begin
  Close;
end;

end.
