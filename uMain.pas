unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uSSL,
  uBranchSelector, DosCommand, Tlhelp32;

type
  TfrmMain = class(TForm)
    mmoOutPut: TMemo;
    btnInstallUpdate: TButton;
    btnInstallOxidemod: TButton;
    dosCommandsteamcmd: TDosCommand;
    lbl1: TLabel;
    procedure DownloadSSL(Link, Path: string; Extract: Boolean; ExtractPath: string);
    procedure btnInstallOxidemodClick(Sender: TObject);
    procedure btnInstallUpdateClick(Sender: TObject);
    procedure InstallSteamcmd;
    function KillTask(ExeFileName: string): Integer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

const
  steamcmdpath = '.\steamcmd\steamcmd.exe';

implementation

{$R *.dfm}

{ TForm1 }

procedure TfrmMain.btnInstallOxidemodClick(Sender: TObject);
begin
  DownloadSSL('https://www.github.com/OxideMod/Oxide/releases/download/latest/Oxide-Rust.zip', 'oixde.zip', True, '.\');
end;

procedure TfrmMain.btnInstallUpdateClick(Sender: TObject);
var
  branch: Integer;
  installcommand: string;
  command: TStringList;
begin
  if not FileExists(steamcmdpath) then
  begin
    if MessageDlg('ERROR: steamcmd.exe could not be found. Do you want RSM to install it for you?', mtError, [mbYes, mbNo], 0) = mrYes then
    begin
      InstallSteamcmd;
      btnInstallUpdate.Click;
    end;
  end
  else
  begin

    frmbranchselector.showmodal;
    if frmbranchselector.install = True then
    begin
      branch := frmbranchselector.branch;
      case branch of
        -1:
          begin
            ShowMessage('You have to select a branch!');
            Exit
          end;
        0:
          installcommand := '"' + steamcmdpath + '"' + ' +login anonymous +force_install_dir "' + GetCurrentDir + '" +app_update 258550 +quit';
        1:
          installcommand := '"' + steamcmdpath + '"' + ' +login anonymous +force_install_dir "' + GetCurrentDir + '" +app_update 258550 -beta staging +quit';
        2:
          installcommand := '"' + steamcmdpath + '"' + ' +login anonymous +force_install_dir "' + GetCurrentDir + '" +app_update 258550 -beta prerelease +quit';
        3:
          installcommand := '"' + steamcmdpath + '"' + ' +login anonymous +force_install_dir "' + GetCurrentDir + '" +app_update 258550 -beta july2016 +quit';
        4:
          installcommand := '"' + steamcmdpath + '"' + ' +login anonymous +force_install_dir "' + GetCurrentDir + '" +app_update 258550 -beta october2016 +quit';
      end;

      command := TStringList.Create;
      try
        command.Add('@echo off');
        command.Add('echo Starting Server Installation..');
        command.Add(installcommand);
        command.Add('echo Done.');
      finally
        command.SaveToFile('.\install.bat');
        command.Free;
      end;
      dosCommandsteamcmd.CommandLine := '.\install.bat';
      dosCommandsteamcmd.OutputLines := mmoOutPut.Lines;
      dosCommandsteamcmd.Execute;
    end;
  end;
end;

procedure TfrmMain.DownloadSSL(Link, Path: string; Extract: Boolean; ExtractPath: string);
begin
  frmssldownloader.Link := Link;
  frmssldownloader.Path := Path;
  frmssldownloader.Extract := Extract;
  frmssldownloader.ExtractPath := ExtractPath;
  frmssldownloader.showmodal;
  if frmssldownloader.error = True then
    ShowMessage('Error downloading or extracting.');
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  KillTask('steamcmd.exe');
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  if not FileExists('libeay32.dll') or not FileExists('ssleay32.dll') then
    mmoOutPut.Lines.Add('Some files seem to be missing' + sLineBreak + 'Please dowload this program again from: https://oxidemod.org/resources/rust-server-installer.2640/');
end;

procedure TfrmMain.InstallSteamcmd;
begin
  if not DirectoryExists('.\steamcmd') then
    MkDir('.\steamcmd');
  DownloadSSL('https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip', '.\steamcmd\steamcmd.zip', True, '.\steamcmd');
end;

function Tfrmmain.KillTask(ExeFileName: string): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName))) then
      Result := Integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0), FProcessEntry32.th32ProcessID), 0));
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

end.

