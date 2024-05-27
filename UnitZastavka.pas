unit UnitZastavka;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, registry;

type
  TFormZastavka = class(TForm)
    ImageGeneral: TImage;
    procedure ImageGeneralMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
    procedure SaveProgPosition;
    procedure LoadProgPosition;
  public
    { Public declarations }
  end;

var
  FormZastavka: TFormZastavka;

implementation

uses UnitMain, UnitScore;

{$R *.dfm}

{ ------------------- Сохранение/Восстановление позиции begin ------------------ }
procedure TFormZastavka.SaveProgPosition;
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

procedure TFormZastavka.LoadProgPosition;
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

procedure TFormZastavka.FormClose(Sender: TObject; var Action: TCloseAction);
begin
SaveProgPosition;
end;

procedure TFormZastavka.FormCreate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_HWNDPARENT, GetDesktopWindow);
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TFormZastavka.FormHide(Sender: TObject);
begin
SaveProgPosition;
end;

procedure TFormZastavka.FormShow(Sender: TObject);
begin
LoadProgPosition;
end;

procedure TFormZastavka.ImageGeneralMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
const
  sc_dragmove = $F012;
begin
  releasecapture;
  if FormMain.CBStay.Checked <> true then
  FormZastavka.Perform(wm_syscommand, sc_dragmove, 0);
end;

end.
