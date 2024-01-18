program martisor;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Windows, Interfaces, // this includes the LCL widgetset
  Forms, uMain
  { you can add units after this };

{$R *.res}

Var Ex: Integer;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;

  Ex:= Windows.GetWindowLong(Windows.FindWindow(Nil, PChar(Application.Title)), GWL_EXSTYLE);
  SetWindowLong(FindWindow(Nil, PChar(Application.Title)), GWL_EXSTYLE, Ex Or WS_EX_TOOLWINDOW And Not WS_EX_APPWINDOW);
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.

