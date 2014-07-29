program WinCacheGrind;

uses
  Forms,
  uCacheGrind in 'uCacheGrind.pas',
  uConfig in 'uConfig.pas',
  uDoc in 'uDoc.pas' {fDoc},
  uEditor in 'uEditor.pas' {fEditor},
  uMain in 'uMain.pas' {fMain},
  uOptions in 'uOptions.pas' {fOptions},
  uWait in 'uWait.pas' {fWait},
  RegExpr in 'RegExpr\RegExpr.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'WinCacheGrind';
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TfOptions, fOptions);
  Application.CreateForm(TfWait, fWait);
  Application.Run;
end.
