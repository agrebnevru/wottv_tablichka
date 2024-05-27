unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Shellapi, ExtCtrls, Menus, registry,
  ThreadCheckNewVersion, Buttons;

type
  TFormMain = class(TForm)
    EditTeam1: TEdit;
    EditTeam2: TEdit;
    MemoScore2: TMemo;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    CBShowHide: TCheckBox;
    MemoScore1: TMemo;
    TI: TTrayIcon;
    PMTray: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    CBStay: TCheckBox;
    PanelBottom: TPanel;
    LabelCopy: TLabel;
    LabelVer: TLabel;
    LabelCopyLink: TLabel;
    LabelIssetNewVirsion: TLabel;
    TimerUpdate: TTimer;
    CBZastavka: TCheckBox;
    BitBtn1: TBitBtn;
    CBLogo: TCheckBox;
    function GetVerProg: string;
    procedure LabelCopyLinkClick(Sender: TObject);
    procedure CBShowHideClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure EditTeam1Change(Sender: TObject);
    procedure EditTeam2Change(Sender: TObject);
    procedure LabelIssetNewVirsionClick(Sender: TObject);
    procedure TimerUpdateTimer(Sender: TObject);
    procedure CBZastavkaClick(Sender: TObject);
    procedure TIDblClick(Sender: TObject);
    procedure UpDown2Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure BitBtn1Click(Sender: TObject);
    procedure CBLogoClick(Sender: TObject);
  private
    Thread1: CheckNewVersion;
    { Private declarations }
    procedure SaveProgPosition;
    procedure LoadProgPosition;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;
  KeyClose: Boolean;

implementation

uses UnitScore, UnitZastavka, UnitLogo;
{$R *.dfm}

{ ------------------- Сохранение/Восстановление позиции begin ------------------ }
procedure TFormMain.SaveProgPosition;
var
  FIniFile: TRegIniFile;
begin
  FIniFile := TRegIniFile.Create('wottv_ru-score'); // Инициализирую реестр
  FIniFile.OpenKey('wottv_ru-score', true); // Открываю раздел
  FIniFile.OpenKey('wottv_ru-score-PositionMain', true);
  // Открываю ещё один раздел
  if WindowState = wsNormal then
  begin
    FIniFile.WriteInteger('Option', 'Left', Left);
    FIniFile.WriteInteger('Option', 'Top', Top);
  end;
  FIniFile.Free;
end;

procedure TFormMain.LoadProgPosition;
var
  FIniFile: TRegIniFile;
begin
  FIniFile := TRegIniFile.Create('wottv_ru-score');
  FIniFile.OpenKey('wottv_ru-score', true);
  FIniFile.OpenKey('wottv_ru-score-PositionMain', true);
  Left := FIniFile.ReadInteger('Option', 'Left', 100);
  Top := FIniFile.ReadInteger('Option', 'Top', 100);
  FIniFile.Free;
end;
{ ------------------- Сохранение/Восстановление позиции end-- ------------------ }

procedure TFormMain.TIDblClick(Sender: TObject);
begin
  if Showing then
    Hide
  else
    Show;
end;

procedure TFormMain.TimerUpdateTimer(Sender: TObject);
begin
  TimerUpdate.Enabled := false;
  Thread1 := CheckNewVersion.Create(true);
  Thread1.FreeOnTerminate := true;
  Thread1.Priority := tplower;
  Thread1.Resume;
end;

procedure TFormMain.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
  FormScore.LabelScore2.Caption := MemoScore2.Lines.Text;
end;

procedure TFormMain.UpDown2Click(Sender: TObject; Button: TUDBtnType);
begin
  FormScore.LabelScore1.Caption := MemoScore1.Lines.Text;
end;

function TFormMain.GetVerProg: string;
type
  TVerInfo = packed record
    Nevazhno: array [0 .. 47] of byte; // ненужные нам 48 байт
    Minor, Major, Build, Release: word; // а тут версия
  end;
var
  s: TResourceStream;
  v: TVerInfo;
begin
  result := '';
  try
    s := TResourceStream.Create(HInstance, '#1', RT_VERSION); // достаём ресурс
    if s.Size > 0 then
    begin
      s.Read(v, SizeOf(v)); // читаем нужные нам байты
      result := IntToStr(v.Major) + '.' + IntToStr(v.Minor) + '.' +
      // вот и версия...
        IntToStr(v.Release) + '.' + IntToStr(v.Build);
    end;
    s.Free;
  except
    ;
  end;
end;

procedure TFormMain.BitBtn1Click(Sender: TObject);
begin
  if FormScore.ImageResp1.Left = 435 then
  begin
    FormScore.ImageResp1.Left := 538;
    FormScore.ImageResp2.Left := 435;
  end
  else
  begin
    FormScore.ImageResp1.Left := 435;
    FormScore.ImageResp2.Left := 538;
  end;
end;

procedure TFormMain.CBLogoClick(Sender: TObject);
begin
  if FormLogo.Showing then
    FormLogo.Hide
  else
    FormLogo.Show;
end;

procedure TFormMain.CBShowHideClick(Sender: TObject);
begin
  if FormScore.Showing then
    FormScore.Hide
  else
    FormScore.Show;
end;

procedure TFormMain.CBZastavkaClick(Sender: TObject);
begin
  if FormZastavka.Showing then
    FormZastavka.Hide
  else
    FormZastavka.Show;
end;

procedure TFormMain.EditTeam1Change(Sender: TObject);
begin
  FormScore.LabelTeam1.Caption := EditTeam1.Text;
end;

procedure TFormMain.EditTeam2Change(Sender: TObject);
begin
  FormScore.LabelTeam2.Caption := EditTeam2.Text;
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if KeyClose = true then
  begin
    SaveProgPosition;
  end
  else
    Hide;
  CanClose := KeyClose;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  LoadProgPosition;
  KeyClose := false;
  LabelVer.Caption := GetVerProg;
  TimerUpdate.Enabled := true;
end;

procedure TFormMain.LabelCopyLinkClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar('http://wottv.ru/'), nil, nil, SW_SHOW);
end;

procedure TFormMain.LabelIssetNewVirsionClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar('http://wottv.ru/'), nil, nil, SW_SHOW);
end;

procedure TFormMain.N1Click(Sender: TObject);
begin
  if FormScore.Showing then
    FormScore.Hide
  else
    FormScore.Show;
end;

procedure TFormMain.N2Click(Sender: TObject);
begin
  if Showing then
    Hide
  else
    Show;
end;

procedure TFormMain.N4Click(Sender: TObject);
begin
  KeyClose := true;
  Close;
end;

end.
