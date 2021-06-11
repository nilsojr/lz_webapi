unit uUser;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TUser }

  TUser = class
  private
    FId: Integer;
    FPassword: string;
    FUsername: string;
    procedure SetId(AValue: Integer);
    procedure SetPassword(AValue: string);
    procedure SetUsername(AValue: string);
  public
    property Id: Integer read FId write SetId;
    property Username: string read FUsername write SetUsername;
    property Password: string read FPassword write SetPassword;
  end;

implementation

{ TUser }

procedure TUser.SetId(AValue: Integer);
begin
  if FId=AValue then Exit;
  FId:=AValue;
end;

procedure TUser.SetPassword(AValue: string);
begin
  if FPassword=AValue then Exit;
  FPassword:=AValue;
end;

procedure TUser.SetUsername(AValue: string);
begin
  if FUsername=AValue then Exit;
  FUsername:=AValue;
end;

end.

