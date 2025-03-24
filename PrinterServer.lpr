program PrinterServer;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes,
  SysUtils,
  CustApp,
  ServerUnit;

type

  { TPrinterServer }

  TPrinterServer = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

  { TPrinterServer }

  procedure TPrinterServer.DoRun;
  var
    ErrorMsg: string;
  begin
    // quick check parameters
    ErrorMsg := CheckOptions('h', 'help');
    if ErrorMsg <> '' then
    begin
      ShowException(Exception.Create(ErrorMsg));
      Terminate;
      Exit;
    end;

    // parse parameters
    if HasOption('h', 'help') then
    begin
      WriteHelp;
      Terminate;
      Exit;
    end;

    Server.Start;

    // stop program loop
    Terminate;
  end;

  constructor TPrinterServer.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    StopOnException := True;
  end;

  destructor TPrinterServer.Destroy;
  begin
    inherited Destroy;
  end;

  procedure TPrinterServer.WriteHelp;
  begin
    { add your help code here }
    writeln('Usage: ', ExeName, ' -h');
  end;

var
  Application: TPrinterServer;
begin
  Application := TPrinterServer.Create(nil);
  Application.Title := 'POS Printer Server';
  Application.Run;
  Application.Free;
end.
