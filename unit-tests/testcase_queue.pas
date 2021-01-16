unit testcase_queue;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.queue
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TIntegerQueue = {$IFDEF FPC}specialize{$ENDIF} TQueue<Integer>;
  TStringQueue = {$IFDEF FPC}specialize{$ENDIF} TQueue<String>;

  TQueueTestCase = class(TTestCase)
  public
    {$IFNDEF FPC}
    procedure AssertTrue (AMessage : String; ACondition : Boolean);
    {$ENDIF}
  published
    procedure Test_IntegerQueue_CreateNewEmpty;
    procedure Test_IntegerQueue_AppendNewValueInto;

    procedure Test_StringQueue_CreateNewEmpty;
    procedure Test_StringQueue_AppendNewValueInto;
  end;

implementation

{$IFNDEF FPC}
procedure TQueueTestCase.AssertTrue(AMessage : String; ACondition :
  Boolean);
begin
  CheckTrue(ACondition, AMessage);
end;
{$ENDIF}

procedure TQueueTestCase.Test_IntegerQueue_CreateNewEmpty;
var
  queue : TIntegerQueue;
begin
  queue := TIntegerQueue.Create;

  AssertTrue('#Test_IntegerQueue_CreateNewEmpty -> ' +
   'Queue must be empty', queue.IsEmpty);

  FreeAndNil(queue);
end;

procedure TQueueTestCase.Test_IntegerQueue_AppendNewValueInto;
var
  queue : TIntegerQueue;
begin
  queue := TIntegerQueue.Create;

  AssertTrue('#Test_IntegerQueue_AppendNewValueInto -> ' +
    'Queue value 1 not append', queue.PushHead(4));
  AssertTrue('#Test_IntegerQueue_AppendNewValueInto -> ' +
    'Queue value 4 not append', queue.PushHead(3));
  AssertTrue('#Test_IntegerQueue_AppendNewValueInto -> ' +
    'Queue value 5 not append', queue.PushHead(8));

  AssertTrue('#Test_IntegerQueue_AppendNewValueInto -> ' +
    'Queue index 0 value is not correct', queue.PopHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 8);
  AssertTrue('#Test_IntegerQueue_AppendNewValueInto -> ' +
    'Queue index 1 value is not correct', queue.PopHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
  AssertTrue('#Test_IntegerQueue_AppendNewValueInto -> '+
    'Queue index 2 value is not correct', queue.PopHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4);

  AssertTrue('#Test_IntegerQueue_AppendNewValueInto -> ' +
    'Queue must be empty', queue.IsEmpty);

  FreeAndNil(queue);
end;

procedure TQueueTestCase.Test_StringQueue_CreateNewEmpty;
var
  queue : TStringQueue;
begin
  queue := TStringQueue.Create;

  AssertTrue('#Test_StringQueue_CreateNewEmpty -> ' +
   'Queue must be empty', queue.IsEmpty);

  FreeAndNil(queue);
end;

procedure TQueueTestCase.Test_StringQueue_AppendNewValueInto;
var
  queue : TStringQueue;
begin
  queue := TStringQueue.Create;

  AssertTrue('#Test_StringQueue_AppendNewValueInto -> ' +
    'Queue value 1 not append', queue.PushHead('apple'));
  AssertTrue('#Test_StringQueue_AppendNewValueInto -> ' +
    'Queue value 4 not append', queue.PushHead('orange'));
  AssertTrue('#Test_StringQueue_AppendNewValueInto -> ' +
    'Queue value 5 not append', queue.PushHead('banana'));

  AssertTrue('#Test_StringQueue_AppendNewValueInto -> ' +
    'Queue index 0 value is not correct', queue.PopHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'banana');
  AssertTrue('#Test_StringQueue_AppendNewValueInto -> ' +
    'Queue index 1 value is not correct', queue.PopHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'orange');
  AssertTrue('#Test_StringQueue_AppendNewValueInto -> '+
    'Queue index 2 value is not correct', queue.PopHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'apple');

  AssertTrue('#Test_StringQueue_AppendNewValueInto -> ' +
    'Queue must be empty', queue.IsEmpty);

  FreeAndNil(queue);
end;

initialization
  RegisterTest(TQueueTestCase{$IFNDEF FPC}.Suite{$ENDIF});
end.