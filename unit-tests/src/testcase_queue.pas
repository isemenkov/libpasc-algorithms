unit testcase_queue;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.queue
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TQueueTestCase = class(TTestCase)
  public
    type
      TContainer = {$IFDEF FPC}specialize{$ENDIF} TQueue<Integer>;
  public
    procedure MakeContainer;
    procedure TearDown; override;

    {$IFNDEF FPC}
    procedure AssertTrue (ACondition : Boolean);
    procedure AssertFalse (ACondition: Boolean);
    procedure AssertEquals (Expected, Actual : Integer);
    {$ENDIF}
  published
    procedure ByDefault_NumEntries_ReturnZero;
    procedure ByDefault_IsEmpty_ReturnTrue;

    procedure PushHead_NewItem_ReturnTrue;
    procedure PushTail_NewItem_ReturnTrue;

    procedure PushHead_Items_CheckNumEntries_ReturnTrue;
    procedure PushTail_Items_CheckNulEntries_ReturnTrue;

    procedure PushHead_Items_IsEmpty_ReturnFalse;
    procedure PushTail_Items_IsEmpty_ReturnFalse;

    procedure PopHead_ReturnTrue;
    procedure PopHead_NotExists_RaiseEValueNotExistsException_ReturnTrue;
    procedure PopTail_ReturnTrue;
    procedure PopTail_NotExists_RaiseEValueNotExistsException_ReturnTrue;

    procedure PeekHead_ReturnTrue;
    procedure PeekHead_NotExists_RaiseEValueNotExistsException_ReturnTrue;
    procedure PeekTail_ReturnTrue;
    procedure PeekTail_NotExists_RaiseEValueNotExistsException_ReturnTrue;
  private
    AContainer : TContainer;
  end;

implementation

{$IFNDEF FPC}
procedure TQueueTestCase.AssertTrue(ACondition: Boolean);
begin
  CheckTrue(ACondition);
end;

procedure TQueueTestCase.AssertFalse(ACondition: Boolean);
begin
  CheckFalse(ACondition);
end;

procedure TQueueTestCase.AssertEquals(Expected, Actual: Integer);
begin
  CheckEquals(Expected, Actual);
end;
{$ENDIF}

procedure TQueueTestCase.MakeContainer;
begin
  AContainer := TContainer.Create;
end;

procedure TQueueTestCase.TearDown;
begin
  FreeAndNil(AContainer);
end;

procedure TQueueTestCase.ByDefault_NumEntries_ReturnZero;
begin
  MakeContainer;

  AssertEquals(AContainer.NumEntries, 0);
end;

procedure TQueueTestCase.ByDefault_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.IsEmpty);
end;

procedure TQueueTestCase.PushHead_NewItem_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.PushHead(1));
end;

procedure TQueueTestCase.PushTail_NewItem_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.PushTail(1));
end;

procedure TQueueTestCase.PushHead_Items_CheckNumEntries_ReturnTrue;
begin
  MakeContainer;

  AContainer.PushHead(1);

  AssertEquals(AContainer.NumEntries, 1);
end;

procedure TQueueTestCase.PushTail_Items_CheckNulEntries_ReturnTrue;
begin
  MakeContainer;

  AContainer.PushTail(1);

  AssertEquals(AContainer.NumEntries, 1);
end;

procedure TQueueTestCase.PushHead_Items_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.PushHead(1);

  AssertFalse(AContainer.IsEmpty);
end;

procedure TQueueTestCase.PushTail_Items_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.PushTail(1);

  AssertFalse(AContainer.IsEmpty);
end;

procedure TQueueTestCase.PopHead_ReturnTrue;
begin
  MakeContainer;

  AContainer.PushHead(1);

  AssertEquals(AContainer.PopHead, 1);
end;

procedure TQueueTestCase
  .PopHead_NotExists_RaiseEValueNotExistsException_ReturnTrue;
begin
  MakeContainer;

  try
    AContainer.PopHead;
  except on e: EValueNotExistsException do
    begin
      AssertTrue(True);
      Exit;
    end;
  end;

  AssertTrue(False);
end;

procedure TQueueTestCase.PopTail_ReturnTrue;
begin
  MakeContainer;

  AContainer.PushTail(1);

  AssertEquals(AContainer.PopTail, 1);
end;

procedure TQueueTestCase
  .PopTail_NotExists_RaiseEValueNotExistsException_ReturnTrue;
begin
  MakeContainer;

  try
    AContainer.PopTail;
  except on e: EValueNotExistsException do
    begin
      AssertTrue(True);
      Exit;
    end;
  end;

  AssertTrue(False);
end;

procedure TQueueTestCase.PeekHead_ReturnTrue;
begin
  MakeContainer;

  AContainer.PushHead(1);

  AssertEquals(AContainer.PeekHead, 1);
end;

procedure TQueueTestCase
  .PeekHead_NotExists_RaiseEValueNotExistsException_ReturnTrue;
begin
  MakeContainer;

  try
    AContainer.PeekHead;
  except on e: EValueNotExistsException do
    begin
      AssertTrue(True);
      Exit;
    end;
  end;

  AssertTrue(False);
end;

procedure TQueueTestCase.PeekTail_ReturnTrue;
begin
  MakeContainer;

  AContainer.PushTail(1);

  AssertEquals(AContainer.PeekTail, 1);
end;

procedure TQueueTestCase
  .PeekTail_NotExists_RaiseEValueNotExistsException_ReturnTrue;
begin
  MakeContainer;

  try
    AContainer.PeekTail;
  except on e: EValueNotExistsException do
    begin
      AssertTrue(True);
      Exit;
    end;
  end;

  AssertTrue(False);
end;

initialization
  RegisterTest(TQueueTestCase{$IFNDEF FPC}.Suite{$ENDIF});
end.
