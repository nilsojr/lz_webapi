unit uData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, SQLDB, DB, BufDataset;

type

  { TDMData }

  TUserValidation = (tuvUserNotFound, tuvIncorrectPassword, tuvOk);

  TDMData = class(TDataModule)
    DataSetConn: TBufDataset;
    DBTestConn: TIBConnection;
    QueryConn: TSQLQuery;
    SQLTransactionConn: TSQLTransaction;
  private

  public
    function ValidateUser(AUsername, APassword: string): TUserValidation;
    function GetStringFieldValue(ATable, AField, AWhere: string; AParam,
      AParamValue: string): string;
  end;

var
  DMData: TDMData;

implementation

{$R *.lfm}

{ TDMData }

function TDMData.ValidateUser(AUsername, APassword: string): TUserValidation;
var
  LPassword: string;
begin
  Result := tuvOk;
  LPassword := GetStringFieldValue('USERS', 'PASSWORD', 'USERNAME = :USERNAME', 'USERNAME', AUsername.ToUpper);
  if (LPassword.IsEmpty) then
    Result := tuvUserNotFound
  else if (LPassword <> APassword) then
    Result := tuvIncorrectPassword;
end;

function TDMData.GetStringFieldValue(ATable, AField, AWhere: string;
  AParam, AParamValue: string): string;
const
  _SQL = 'SELECT %s from %s where %s';
begin
  QueryConn.Close;
  QueryConn.SQL.Text := Format(_SQL, [AField, ATable, AWhere]);
  QueryConn.ParamByName(AParam).AsString := AParamValue;
  QueryConn.Open;

  Result := QueryConn.Fields[0].AsString;
end;

initialization
  DMData := TDMData.Create(nil);

finalization
  DMData.Free;

end.

