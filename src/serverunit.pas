unit ServerUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Interfaces, fphttpapp, HTTPDefs, httproute, PrinterUnit,
  fpjson;

type

  { TServer }

  TServer = class
  public
    procedure Start;
  private
    procedure Ping(Request: TRequest; Response: TResponse);
    procedure CatchAll(Request: TRequest; Response: TResponse);
    procedure TextArray(Request: TRequest; Response: TResponse);
  end;

var
  Server: TServer;

implementation

procedure TServer.Start;
begin
  Application.Port := 9090;
  HTTPRouter.RegisterRoute('/ping', rmGet, @Ping);
  HTTPRouter.RegisterRoute('/catchall', rmAll, @CatchAll, True);
  HTTPRouter.RegisterRoute('/print/v1/text/array', rmPost, @TextArray);
  Application.Threaded := True;
  Application.Initialize;

  WriteLn('[INFO] Server is ready at localhost: ' + IntToStr(Application.Port));
  Application.Run;
end;

procedure TServer.Ping(Request: TRequest; Response: TResponse);
begin
  try
    PrinterPos.Ping;
    Response.Content := '{"message":"pong"}';
    Response.Code := 200;
  except
    on E: Exception do
    begin
      WriteLn('[ERROR] ' + E.Message);
      Response.Content := '{"message":"' + E.Message + '"}';
      Response.Code := 500;
    end;
  end;
  Response.ContentType := 'application/json';
  Response.ContentLength := Length(Response.Content);
  Response.SendContent;
end;

procedure TServer.CatchAll(Request: TRequest; Response: TResponse);
begin
  Response.Content := '{"message":"This endpoint is not available"}';
  Response.Code := 404;
  Response.ContentType := 'application/json';
  Response.ContentLength := Length(Response.Content);
  Response.SendContent;
end;

procedure TServer.TextArray(Request: TRequest; Response: TResponse);
var
  jObject: TJSONObject;
begin
  try
    jObject := GetJSON(Request.Content) as TJSONObject;
    PrinterPos.ArrayWriter(jObject);

    Response.Content := '{"message":"Array printed"}';
    Response.Code := 200;
  except
    on E: Exception do
    begin
      WriteLn('[ERROR] ' + E.Message);
      Response.Content := '{"message":"' + E.Message + '"}';
      Response.Code := 500;
    end;
  end;
  Response.ContentType := 'application/json';
  Response.ContentLength := Length(Response.Content);
  Response.SendContent;
end;

end.
