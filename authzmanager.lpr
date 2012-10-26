program authzmanager;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, buildauthz, acercade;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmBuildAuthz, frmBuildAuthz);
  Application.CreateForm(TfrmAcercade, frmAcercade);
  Application.Run;
end.

