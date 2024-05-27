program WOTTVru_Score;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitScore in 'UnitScore.pas' {FormScore},
  ThreadCheckNewVersion in 'ThreadCheckNewVersion.pas',
  UnitZastavka in 'UnitZastavka.pas' {FormZastavka},
  UnitLogo in 'UnitLogo.pas' {FormLogo};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormScore, FormScore);
  Application.CreateForm(TFormZastavka, FormZastavka);
  Application.CreateForm(TFormLogo, FormLogo);
  Application.Run;
end.
