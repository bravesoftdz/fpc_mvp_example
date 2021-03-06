unit ConverterModel;

{$mode objfpc}{$H+}

interface

uses
  Classes, Sysutils,
  ModelInterface;

type

  { TConverter }

  TConverter = class(TInterfacedObject, ICalculatorModel)
  protected
    FISODate           : string;
    FUnixDate          : integer;
    FOnISODateChanged  : TNotifyEvent;
    FOnUnixDateChanged : TNotifyEvent;
    class function IsISODateString    ( Date : string)  : boolean;
    class function ISOStringToDateTime( Date : string ) : TDateTime;
  public
    procedure SetISODate ( Date : string);
    procedure SetUnixDate( Date : integer );
    procedure SetOnISODateChanged(  Func : TNotifyEvent );
    procedure SetOnUnixDateChanged( Func : TNotifyEvent );

    function  GetISODate  : string;
    function  GetUnixDate : integer;
    function  GetOnISODateChanged  : TNotifyEvent;
    function  GetOnUnixDateChanged : TNotifyEvent;

    property  ISODate  : string  read GetISODate  write SetIsoDate;
    property  UnixDate : integer read GetUnixDate write SetUnixDate;
    property  OnISODateChanged  : TNotifyEvent read GetOnISODateChanged  write SetOnISODateChanged;
    property  OnUnixDateChanged : TNotifyEvent read GetOnUnixDateChanged write SetOnUnixDateChanged;
  end;

implementation

uses
  regexpr, dateutils;

{ TConverter }

class function TConverter.IsISODateString(Date : String) : Boolean;
var
  Pattern : TRegExpr;
begin
  Pattern := TRegExpr.Create;
  Pattern.Expression := '[0-9]{4}-[0-9]{2}-[0-9]{2}';
  if not Pattern.Exec(Date) then
    Result := false
  else
    Result := true;
end;

class function TConverter.ISOStringToDateTime(Date : String) : TDatetime;
begin
  if not IsISODateString(Date) then
    raise Exception.Create('datestring is not in format YYYY-mm-dd');
  try
    Result := StrToDate(Date, 'YYYY-MM-DD', '-');
  except
    on e : Exception do
      raise e;
  end;
end;

procedure TConverter.SetISODate(Date : String);
var
  NativeDate  : TDateTime;
  NewUnixDate : integer;
begin
  if Date = FISODate then
    Exit;
  try
    WriteLn('TConverter.SetISODate ', Date);
    NativeDate  := ISOStringToDateTime(Date);
    FISODate    := Date;
    NewUnixDate := DateTimeToUnix(NativeDate);

    if Assigned(FOnISODateChanged) then
      FOnISODateChanged(self)
    else
      WriteLn('FOnISODateChanged is not assigned.');

    SetUnixDate(NewUnixDate);
  except
    Writeln('Error');
  end;
end;

function TConverter.GetISODate : String;
begin
  Result := FISODate;
end;

procedure TConverter.SetUnixDate(Date : Integer);
var
  NativeDate : TDateTime;
  NewISODate : string;
begin
  if Date = FUnixDate then
    Exit;
  try
    WriteLn('TConverter.SetUnixDate ', Date);
    NativeDate := UnixToDateTime(Date);
    FUnixDate  := Date;
    NewISODate := FormatDateTime('YYYY-MM-DD', NativeDate);

    if Assigned(FOnUnixDateChanged) then
      FOnUnixDateChanged(self)
    else
      WriteLn('FOnUnixDateChanged is not assigned.');

    SetISODate(NewISODate);
  except
    Writeln('Error');
  end;
end;

function TConverter.GetUnixDate : Integer;
begin
  Result := FUnixDate;
end;

procedure TConverter.SetOnISODateChanged(Func : TNotifyEvent);
begin
  FOnISODateChanged := Func;
end;

procedure TConverter.SetOnUnixDateChanged(Func : TNotifyEvent);
begin
  FOnUnixDateChanged := Func;
end;

function TConverter.GetOnISODateChanged : TNotifyEvent;
begin
  Result := FOnISODateChanged;
end;

function TConverter.GetOnUnixDateChanged : TNotifyEvent;
begin
  Result := FOnUnixDateChanged;
end;

end.

