program pRSI;

uses
  Vcl.Forms,
  uRSI in 'uRSI.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles,
  uOxideModInstaller in 'uOxideModInstaller.pas' {frmoxidemodinstaller},
  uSteamCMDinstaller in 'uSteamCMDinstaller.pas' {frmsteamcmdinstaller};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Ruby Graphite');
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(Tfrmoxidemodinstaller, frmoxidemodinstaller);
  Application.CreateForm(Tfrmsteamcmdinstaller, frmsteamcmdinstaller);
  Application.Run;
end.
