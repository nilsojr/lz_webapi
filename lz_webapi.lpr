program lz_webapi;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uMain,
  { you can add units after this }
  fphttpapp,
  opensslsockets, uData, uUser, memdslaz;

{$R *.res}

begin
  //RequireDerivedFormResource := True;
  Application.Port := 9080;
  Application.UseSSL := True;
  Application.Threaded := True;
  Application.Initialize;
  Application.Run;
end.

