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
    procedure Test_IntegerQueue_PushHeadNewValueInto;
    procedure Test_IntegerQueue_PushTailNewValueInto;
    procedure Test_IntegerQueue_PeekHeadValue;
    procedure Test_IntegerQueue_PeekTailValue;

    procedure Test_StringQueue_CreateNewEmpty;
    procedure Test_StringQueue_PushHeadNewValueInto;
    procedure Test_StringQueue_PushTailNewValueInto;
    procedure Test_StringQueue_PeekHeadValue;
    procedure Test_StringQueue_PeekTailValue;
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

procedure TQueueTestCase.Test_IntegerQueue_PushHeadNewValueInto;
var
  queue : TIntegerQueue;
begin
  queue := TIntegerQueue.Create;

  AssertTrue('#Test_IntegerQueue_PushHeadNewValueInto -> ' +
    'Queue value 1 not append', queue.PushHead(4));
  AssertTrue('#Test_IntegerQueue_PushHeadNewValueInto -> ' +
    'Queue value 4 not append', queue.PushHead(3));
  AssertTrue('#Test_IntegerQueue_PushHeadNewValueInto -> ' +
    'Queue value 5 not append', queue.PushHead(8));

  AssertTrue('#Test_IntegerQueue_PushHeadNewValueInto -> ' +
    'Queue index 0 value is not correct', queue.PopHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 8);
  AssertTrue('#Test_IntegerQueue_PushHeadNewValueInto -> ' +
    'Queue index 1 value is not correct', queue.PopHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
  AssertTrue('#Test_IntegerQueue_PushHeadNewValueInto -> '+
    'Queue index 2 value is not correct', queue.PopHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4);

  AssertTrue('#Test_IntegerQueue_PushHeadNewValueInto -> ' +
    'Queue must be empty', queue.IsEmpty);

  FreeAndNil(queue);
end;

procedure TQueueTestCase.Test_IntegerQueue_PushTailNewValueInto;
var
  queue : TIntegerQueue;
begin
  queue := TIntegerQueue.Create;

  AssertTrue('#Test_IntegerQueue_PushTailNewValueInto -> ' +
    'Queue value 1 not append', queue.PushTail(4));
  AssertTrue('#Test_IntegerQueue_PushTailNewValueInto -> ' +
    'Queue value 4 not append', queue.PushTail(3));
  AssertTrue('#Test_IntegerQueue_PushTailNewValueInto -> ' +
    'Queue value 5 not append', queue.PushTail(8));

  AssertTrue('#Test_IntegerQueue_PushTailNewValueInto -> ' +
    'Queue index 0 value is not correct', queue.PopTail
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 8);
  AssertTrue('#Test_IntegerQueue_PushTailNewValueInto -> ' +
    'Queue index 1 value is not correct', queue.PopTail
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
  AssertTrue('#Test_IntegerQueue_PushTailNewValueInto -> '+
    'Queue index 2 value is not correct', queue.PopTail
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4);

  AssertTrue('#Test_IntegerQueue_PushTailNewValueInto -> ' +
    'Queue must be empty', queue.IsEmpty);

  FreeAndNil(queue);
end;

procedure TQueueTestCase.Test_IntegerQueue_PeekHeadValue;
var
  queue : TIntegerQueue;
begin
  queue := TIntegerQueue.Create;

  AssertTrue('#Test_IntegerQueue_PeekHeadValue -> ' +
    'Queue value 1 not append', queue.PushHead(4));
  AssertTrue('#Test_IntegerQueue_PeekHeadValue -> ' +
    'Queue value 4 not append', queue.PushHead(3));
  AssertTrue('#Test_IntegerQueue_PeekHeadValue -> ' +
    'Queue value 5 not append', queue.PushHead(8));

  AssertTrue('#Test_IntegerQueue_PeekHeadValue -> ' +
    'Queue index 0 value is not correct', queue.PeekHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 8);
  AssertTrue('#Test_IntegerQueue_PeekHeadValue -> ' +
    'Queue index 0 value is not correct', queue.PopHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 8);
  AssertTrue('#Test_IntegerQueue_PeekHeadValue -> ' +
    'Queue index 1 value is not correct', queue.PeekHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
  AssertTrue('#Test_IntegerQueue_PeekHeadValue -> ' +
    'Queue index 1 value is not correct', queue.PopHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
  AssertTrue('#Test_IntegerQueue_PeekHeadValue -> '+
    'Queue index 2 value is not correct', queue.PeekHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4);
  AssertTrue('#Test_IntegerQueue_PeekHeadValue -> '+
    'Queue index 2 value is not correct', queue.PopHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4);

  AssertTrue('#Test_IntegerQueue_PeekHeadValue -> ' +
    'Queue must be empty', queue.IsEmpty);

  FreeAndNil(queue);
end;

procedure TQueueTestCase.Test_IntegerQueue_PeekTailValue;
var
  queue : TIntegerQueue;
begin
  queue := TIntegerQueue.Create;

  AssertTrue('#Test_IntegerQueue_PeekTailValue -> ' +
    'Queue value 1 not append', queue.PushTail(4));
  AssertTrue('#Test_IntegerQueue_PeekTailValue -> ' +
    'Queue value 4 not append', queue.PushTail(3));
  AssertTrue('#Test_IntegerQueue_PeekTailValue -> ' +
    'Queue value 5 not append', queue.PushTail(8));

  AssertTrue('#Test_IntegerQueue_PeekTailValue -> ' +
    'Queue index 0 value is not correct', queue.PeekTail
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 8);
  AssertTrue('#Test_IntegerQueue_PeekTailValue -> ' +
    'Queue index 0 value is not correct', queue.PopTail
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 8);
  AssertTrue('#Test_IntegerQueue_PeekTailValue -> ' +
    'Queue index 1 value is not correct', queue.PeekTail
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
  AssertTrue('#Test_IntegerQueue_PeekTailValue -> ' +
    'Queue index 1 value is not correct', queue.PopTail
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
  AssertTrue('#Test_IntegerQueue_PeekTailValue -> '+
    'Queue index 2 value is not correct', queue.PeekTail
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4);
  AssertTrue('#Test_IntegerQueue_PeekTailValue -> '+
    'Queue index 2 value is not correct', queue.PopTail
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4);

  AssertTrue('#Test_IntegerQueue_PeekTailValue -> ' +
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

procedure TQueueTestCase.Test_StringQueue_PushHeadNewValueInto;
var
  queue : TStringQueue;
begin
  queue := TStringQueue.Create;

  AssertTrue('#Test_StringQueue_PushHeadNewValueInto -> ' +
    'Queue value 1 not append', queue.PushHead('apple'));
  AssertTrue('#Test_StringQueue_PushHeadNewValueInto -> ' +
    'Queue value 4 not append', queue.PushHead('orange'));
  AssertTrue('#Test_StringQueue_PushHeadNewValueInto -> ' +
    'Queue value 5 not append', queue.PushHead('banana'));

  AssertTrue('#Test_StringQueue_PushHeadNewValueInto -> ' +
    'Queue index 0 value is not correct', queue.PopHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'banana');
  AssertTrue('#Test_StringQueue_PushHeadNewValueInto -> ' +
    'Queue index 1 value is not correct', queue.PopHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'orange');
  AssertTrue('#Test_StringQueue_PushHeadNewValueInto -> '+
    'Queue index 2 value is not correct', queue.PopHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'apple');

  AssertTrue('#Test_StringQueue_PushHeadNewValueInto -> ' +
    'Queue must be empty', queue.IsEmpty);

  FreeAndNil(queue);
end;

procedure TQueueTestCase.Test_StringQueue_PushTailNewValueInto;
var
  queue : TStringQueue;
begin
  queue := TStringQueue.Create;

  AssertTrue('#Test_StringQueue_PushTailNewValueInto -> ' +
    'Queue value 1 not append', queue.PushTail('apple'));
  AssertTrue('#Test_StringQueue_PushTailNewValueInto -> ' +
    'Queue value 4 not append', queue.PushTail('orange'));
  AssertTrue('#Test_StringQueue_PushTailNewValueInto -> ' +
    'Queue value 5 not append', queue.PushTail('banana'));

  AssertTrue('#Test_StringQueue_PushTailNewValueInto -> ' +
    'Queue index 0 value is not correct', queue.PopTail
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'banana');
  AssertTrue('#Test_StringQueue_PushTailNewValueInto -> ' +
    'Queue index 1 value is not correct', queue.PopTail
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'orange');
  AssertTrue('#Test_StringQueue_PushTailNewValueInto -> '+
    'Queue index 2 value is not correct', queue.PopTail
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'apple');

  AssertTrue('#Test_StringQueue_PushTailNewValueInto -> ' +
    'Queue must be empty', queue.IsEmpty);

  FreeAndNil(queue);
end;

procedure TQueueTestCase.Test_StringQueue_PeekHeadValue;
var
  queue : TStringQueue;
begin
  queue := TStringQueue.Create;

  AssertTrue('#Test_StringQueue_PeekHeadValue -> ' +
    'Queue value 1 not append', queue.PushHead('apple'));
  AssertTrue('#Test_StringQueue_PeekHeadValue -> ' +
    'Queue value 4 not append', queue.PushHead('orange'));
  AssertTrue('#Test_StringQueue_PeekHeadValue -> ' +
    'Queue value 5 not append', queue.PushHead('banana'));

  AssertTrue('#Test_StringQueue_PeekHeadValue -> ' +
    'Queue index 0 value is not correct', queue.PeekHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'banana');
  AssertTrue('#Test_StringQueue_PeekHeadValue -> ' +
    'Queue index 0 value is not correct', queue.PopHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'banana');
  AssertTrue('#Test_StringQueue_PeekHeadValue -> ' +
    'Queue index 1 value is not correct', queue.PeekHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'orange');
  AssertTrue('#Test_StringQueue_PeekHeadValue -> ' +
    'Queue index 1 value is not correct', queue.PopHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'orange');
  AssertTrue('#Test_StringQueue_PeekHeadValue -> '+
    'Queue index 2 value is not correct', queue.PeekHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'apple');
  AssertTrue('#Test_StringQueue_PeekHeadValue -> '+
    'Queue index 2 value is not correct', queue.PopHead
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'apple');

  AssertTrue('#Test_StringQueue_PeekHeadValue -> ' +
    'Queue must be empty', queue.IsEmpty);

  FreeAndNil(queue);
end;

procedure TQueueTestCase.Test_StringQueue_PeekTailValue;
var
  queue : TStringQueue;
begin
  queue := TStringQueue.Create;

  AssertTrue('#Test_StringQueue_PeekTailValue -> ' +
    'Queue value 1 not append', queue.PushTail('apple'));
  AssertTrue('#Test_StringQueue_PeekTailValue -> ' +
    'Queue value 4 not append', queue.PushTail('orange'));
  AssertTrue('#Test_StringQueue_PeekTailValue -> ' +
    'Queue value 5 not append', queue.PushTail('banana'));

  AssertTrue('#Test_StringQueue_PeekTailValue -> ' +
    'Queue index 0 value is not correct', queue.PeekTail
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'banana');
  AssertTrue('#Test_StringQueue_PeekTailValue -> ' +
    'Queue index 0 value is not correct', queue.PopTail
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'banana');
  AssertTrue('#Test_StringQueue_PeekTailValue -> ' +
    'Queue index 1 value is not correct', queue.PeekTail
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'orange');
  AssertTrue('#Test_StringQueue_PeekTailValue -> ' +
    'Queue index 1 value is not correct', queue.PopTail
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'orange');
  AssertTrue('#Test_StringQueue_PeekTailValue -> '+
    'Queue index 2 value is not correct', queue.PeekTail
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'apple');
  AssertTrue('#Test_StringQueue_PeekTailValue -> '+
    'Queue index 2 value is not correct', queue.PopTail
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'apple');

  AssertTrue('#Test_StringQueue_PeekTailValue -> ' +
    'Queue must be empty', queue.IsEmpty);

  FreeAndNil(queue);
end;

initialization
  RegisterTest(TQueueTestCase{$IFNDEF FPC}.Suite{$ENDIF});
end.