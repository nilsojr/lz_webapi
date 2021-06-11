unit uMain;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF UNIX}cthreads, cmem, {$ENDIF}
  Classes, SysUtils,
  fphttpapp, httproute, HTTPDefs, fpjson, jsonparser,
  base64, StrUtils, uData;

implementation

procedure GenerateAndSendJSONResponse(var AResponse: TResponse; AData: String;
  AHttpCode: Integer);
begin
  AResponse.Content := AData;
  AResponse.Code := AHttpCode;
  AResponse.ContentType := 'application/json';
  AResponse.ContentLength := Length(AResponse.Content);
  AResponse.SendContent;
end;

procedure ValidateRequest(ARequest: TRequest);
var
  LHeaderValue,
  Lb64decoded,
  LUserName,
  LPassword: string;
begin
  LHeaderValue := ARequest.Authorization;

  if length(LHeaderValue) = 0 then
    raise Exception.Create('This endpoint requires authentication');

  if ExtractWord(1, LHeaderValue, [' ']) <> 'Basic' then
    raise Exception.Create('Only Basic Authentication is supported');

  Lb64decoded := DecodeStringBase64(ExtractWord(2, LHeaderValue, [' ']));
  LUserName := ExtractWord(1, Lb64decoded, [':']);
  LPassword := ExtractWord(2, Lb64decoded, [':']);

  if (DMData.ValidateUser(LUserName, LPassword) <> tuvOk) then
    raise Exception.Create('Invalid API credentials');
end;

procedure GreetingEndpoint(ARequest: TRequest; AResponse: TResponse);
var
  LJSONObject: TJSONObject;
  LHttpCode: Integer;
  LJSONData: TJSONData;
  LValue: string;
begin
  LJSONObject := TJSONObject.Create;
  try
    try
      ValidateRequest(ARequest);
      LJSONData := GetJSON(ARequest.Content);
      try
        LValue := LJSONData.FindPath('name').AsString;
        LJSONObject.Add('success', True);
        LJSONObject.Add('greeting', 'Hello, ' + LValue);
        LHttpCode := 200;
      finally
        LJSONData.Free;
      end;
    except
      on E: Exception do
      begin
        LJSONObject.Add('success', False);
        LJSONObject.Add('reason', E.Message);
        LHttpCode := 401;
      end;
    end;
    GenerateAndSendJSONResponse(AResponse, LJSONObject.AsJSON, LHttpCode);
  finally
    LJSONObject.Free;
  end;
end;

procedure TimeEndPoint(ARequest: TRequest; AResponse: TResponse);
var
  LJSONObject: TJSONObject;
  LHttpCode: Integer;
begin
  LJSONObject := TJSONObject.Create;
  try
    try
      ValidateRequest(ARequest);
      LJSONObject.Add('success', True);
      LJSONObject.Add('time', TimeToStr(Time));
      LHttpCode := 200;
    except
      on E: Exception do
      begin
        LJSONObject.Add('success', False);
        LJSONObject.Add('reason', E.Message);
        LHttpCode := 401;
      end;
    end;
    GenerateAndSendJSONResponse(AResponse, LJSONObject.AsJSON, LHttpCode);
  finally
    LJSONObject.Free;
  end;
end;

initialization
  HTTPRouter.RegisterRoute('/time', @TimeEndPoint, True);
  HTTPRouter.RegisterRoute('/greeting', @GreetingEndpoint);

end.

