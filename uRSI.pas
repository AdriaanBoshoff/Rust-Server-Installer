unit uRSI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, DosCommand,
  ShellAPI, uOxideModInstaller, uSteamCMDinstaller;

type
  TForm1 = class(TForm)
    pnl1: TPanel;
    mmooutput: TMemo;
    btnclose: TButton;
    doscmdinstaller: TDosCommand;
    lbl3: TLabel;
    lblgithub: TLabel;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lblinstallserver: TLabel;
    lblinstallsteamcmd: TLabel;
    lblinstalloxidemod: TLabel;
    lblwebsite: TLabel;
    lbloxidemod: TLabel;
    procedure btncloseClick(Sender: TObject);
    procedure OpenURL(URL: string);
    procedure lblgithubClick(Sender: TObject);
    procedure lblwebsiteClick(Sender: TObject);
    procedure lbloxidemodClick(Sender: TObject);
    procedure lblinstallsteamcmdClick(Sender: TObject);
    procedure lblinstalloxidemodClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblinstallserverClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btncloseClick(Sender: TObject);
begin
  doscmdinstaller.Stop;
  Application.Terminate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.Title := 'Rust Server Installer';

  if not FileExists('libeay32.dll') or not FileExists('ssleay32.dll') then
  begin
    ShowMessage
      ('Some files seem to be missing. Please re-download Rust Server Installer.');
    OpenURL('https://github.com/Inforcer25/Rust-Server-Installer/releases');
    Application.Terminate;
  end;

end;

procedure TForm1.lblgithubClick(Sender: TObject);
begin
  OpenURL('https://github.com/Inforcer25/Rust-Server-Installer');
end;

procedure TForm1.lblinstalloxidemodClick(Sender: TObject);
begin
  frmoxidemodinstaller.ShowModal;
end;

procedure TForm1.lblinstallserverClick(Sender: TObject);
var
  command: TStringList;
begin
  if FileExists('.\steamcmd\steamcmd.exe') then
  begin
    doscmdinstaller.Stop;
    mmooutput.Clear;

    command := TStringList.Create;
    try
      command.Clear;
      command.Add('@echo off');
      command.Add('echo Starting Installation...');
      command.Add('.\steamcmd' +
        '\steamcmd.exe +login anonymous +force_install_dir "' + GetCurrentDir +
        '" +app_update 258550 +quit');
      command.Add('echo Done');
    finally
      command.SaveToFile('UpdateInstall.bat');
      command.Free
    end;

    doscmdinstaller.CommandLine := 'UpdateInstall.bat';
    doscmdinstaller.OutputLines := mmooutput.Lines;
    doscmdinstaller.Execute;
  end
  else
  begin
    ShowMessage('SteamCMD is not installed! Click the blue "Install SteamCMD"');
  end;
end;

procedure TForm1.lblinstallsteamcmdClick(Sender: TObject);
begin
  frmsteamcmdinstaller.ShowModal;
end;

procedure TForm1.lbloxidemodClick(Sender: TObject);
begin
  OpenURL('http://oxidemod.org/');
end;

procedure TForm1.lblwebsiteClick(Sender: TObject);
begin
  OpenURL('https://inforcer25.co.za/');
end;

procedure TForm1.OpenURL(URL: string);
begin
  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
end;

end.
