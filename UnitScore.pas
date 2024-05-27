unit UnitScore;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, StdCtrls, registry, ImgList;

type
  TFormScore = class(TForm)
    ImageGeneral: TImage;
    LabelTeam1: TLabel;
    LabelTeam2: TLabel;
    LabelScore1: TLabel;
    LabelScore2: TLabel;
    Label1: TLabel;
    ImageResp1: TImage;
    ImageResp2: TImage;
    IL1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure ImageGeneralMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure SaveProgPosition;
    procedure LoadProgPosition;
  public
    { Public declarations }
  end;

var
  FormScore: TFormScore;

implementation

uses UnitMain;

{$R *.dfm}

{ ------------------- Сохранение/Восстановление позиции begin ------------------ }
procedure TFormScore.SaveProgPosition;
var
  FIniFile: TRegIniFile;
begin
  FIniFile := TRegIniFile.Create('wottv_ru-score'); // Инициализирую реестр
  FIniFile.OpenKey('wottv_ru-score', true); // Открываю раздел
  FIniFile.OpenKey('wottv_ru-score-PositionScore', true);
  // Открываю ещё один раздел
  if WindowState = wsNormal then
  begin
    FIniFile.WriteInteger('Option', 'Left', Left);
    FIniFile.WriteInteger('Option', 'Top', Top);
  end;
  FIniFile.Free;
end;

procedure TFormScore.LoadProgPosition;
var
  FIniFile: TRegIniFile;
begin
  FIniFile := TRegIniFile.Create('wottv_ru-score');
  FIniFile.OpenKey('wottv_ru-score', true);
  FIniFile.OpenKey('wottv_ru-score-PositionScore', true);
  Left := FIniFile.ReadInteger('Option', 'Left', 100);
  Top := FIniFile.ReadInteger('Option', 'Top', 100);
  FIniFile.Free;
end;
{ ------------------- Сохранение/Восстановление позиции end-- ------------------ }

procedure TFormScore.FormClose(Sender: TObject; var Action: TCloseAction);
begin
SaveProgPosition;
end;

procedure TFormScore.FormCreate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_HWNDPARENT, GetDesktopWindow);
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TFormScore.FormHide(Sender: TObject);
begin
SaveProgPosition;
end;

procedure TFormScore.FormShow(Sender: TObject);
begin
LoadProgPosition;
end;

procedure TFormScore.ImageGeneralMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  sc_dragmove = $F012;
begin
  releasecapture;
  if FormMain.CBStay.Checked <> true then
  FormScore.Perform(wm_syscommand, sc_dragmove, 0);
end;

end.
