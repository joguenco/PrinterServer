(*
  REST API Server
  Jorge Luis
  jorgeluis@resolvedor.dev
  https://resolvedor.dev
*)

unit ServerUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Interfaces, fphttpapp, HTTPDefs, httproute, PrinterUnit,
  fpjson, httpprotocol;

type

  { TServer }

  TServer = class
  public
    procedure Start;
  private
    procedure Ping(Request: TRequest; Response: TResponse);
    procedure CatchAll(Request: TRequest; Response: TResponse);
    procedure TextArray(Request: TRequest; Response: TResponse);
    function BearerTokenValidate(Request: TRequest; Response: TResponse): boolean;
  end;

var
  Server: TServer;

implementation

const
  BEARER_TOKEN = 'your_secret_token';

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
  WriteLn('[INFO] Request GET to /ping and response status: ' + IntToStr(Response.Code));
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
  authorization: boolean;
begin
  authorization := BearerTokenValidate(Request, Response);

  if not authorization then
    Exit;
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
  WriteLn('[INFO] Request POST to /print/v1/text/array and response status: ' +
    IntToStr(Response.Code));
end;

function TServer.BearerTokenValidate(Request: TRequest; Response: TResponse): boolean;
var
  AuthHeader: string;
begin
  AuthHeader := Request.GetHeader(THeader.hhAuthorization);
  if AuthHeader.StartsWith('Bearer ') and (AuthHeader.Substring(7) = BEARER_TOKEN) then
  begin
    Result := True;
  end
  else
  begin
    Response.Content := '{"message":"Unauthorized"}';
    Response.Code := 401;
    Response.ContentType := 'application/json';
    Response.ContentLength := Length(Response.Content);
    Response.SendContent;
    Result := False;
  end;
end;

end.
