unit UnitLogo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, registry;

type
  TFormLogo = class(TForm)
    Image1: TImage;
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
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
  FormLogo: TFormLogo;

implementation

uses UnitMain;

{$R *.dfm}

{ ------------------- Сохранение/Восстановление позиции begin ------------------ }
procedure TFormLogo.SaveProgPosition;
var
  FIniFile: TRegIniFile;
begin
  FIniFile := TRegIniFile.Create('wottv_ru-score'); // Инициализирую реестр
  FIniFile.OpenKey('wottv_ru-score', true); // Открываю раздел
  FIniFile.OpenKey('wottv_ru-score-PositionZastavka', true);
  // Открываю ещё один раздел
  if WindowState = wsNormal then
  begin
    FIniFile.WriteInteger('Option', 'Left', Left);
    FIniFile.WriteInteger('Option', 'Top', Top);
  end;
  FIniFile.Free;
end;

procedure TFormLogo.LoadProgPosition;
var
  FIniFile: TRegIniFile;
begin
  FIniFile := TRegIniFile.Create('wottv_ru-score');
  FIniFile.OpenKey('wottv_ru-score', true);
  FIniFile.OpenKey('wottv_ru-score-PositionZastavka', true);
  Left := FIniFile.ReadInteger('Option', 'Left', 100);
  Top := FIniFile.ReadInteger('Option', 'Top', 100);
  FIniFile.Free;
end;
{ ------------------- Сохранение/Восстановление позиции end-- ------------------ }

procedure TFormLogo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
SaveProgPosition;
end;

procedure TFormLogo.FormCreate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_HWNDPARENT, GetDesktopWindow);
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TFormLogo.FormHide(Sender: TObject);
begin
SaveProgPosition;
end;

procedure TFormLogo.FormShow(Sender: TObject);
begin
LoadProgPosition;
end;

procedure TFormLogo.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
const
  sc_dragmove = $F012;
begin
  releasecapture;
  if FormMain.CBStay.Checked <> true then
  FormLogo.Perform(wm_syscommand, sc_dragmove, 0);
end;

end.
