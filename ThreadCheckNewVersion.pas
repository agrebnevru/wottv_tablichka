unit ThreadCheckNewVersion;

interface

uses
  Classes, idhttp, SysUtils;

type
  CheckNewVersion = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

implementation

uses UnitMain;

{ CheckNewVersion }

function Check: boolean;
var
  HTTP: TIdHTTP;
  verkaOnServer: string;
begin
  result := false;
  try
    HTTP := TIdHTTP.Create();
    verkaOnServer := HTTP.Get(
      'http://wottv.ru/application/wottv_ru_score/lastver.txt');
  finally
    HTTP.Free;
  end;
  if Trim(verkaOnServer) <> FormMain.GetVerProg then
    result := true;
end;

procedure CheckNewVersion.Execute;
begin
  { Place thread code here }
  if Check then
    FormMain.LabelIssetNewVirsion.Visible := true;
end;

end.
