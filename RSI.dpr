program RSI;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  uSSL in 'uSSL.pas' {frmssldownloader},
  uBranchSelector in 'uBranchSelector.pas' {frmbranchselector},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Material Black Pearl');
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(Tfrmssldownloader, frmssldownloader);
  Application.CreateForm(Tfrmbranchselector, frmbranchselector);
  Application.Run;
end.
