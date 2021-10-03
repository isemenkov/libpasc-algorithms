unit testcase_sortedarray;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.sortedarray, utils.functor
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TSortedArrayTestCase = class(TTestCase)
  public
    type
      TContainer = {$IFDEF FPC}specialize{$ENDIF} TSortedArray<Integer, 
        TCompareFunctorInteger>;
      TContainerIterator = TContainer.TIterator;
  public
    procedure MakeContainer;
    procedure TearDown; override;

    {$IFNDEF FPC}
    procedure AssertTrue (ACondition : Boolean);
    procedure AssertFalse (ACondition: Boolean);
    procedure AssertEquals (Expected, Actual : Integer);
    {$ENDIF}
  published
    procedure ByDefault_ZeroLength_ReturnTrue;
    procedure ByDefault_IsEmpty_ReturnTrue;

    procedure Append_NewItem_ReturnTrue;
    procedure Append_Items_CheckValues_ReturnTrue;
    procedure Append_Items_CheckLength_ReturnTrue;
    procedure Append_Items_IsEmpty_ReturnFalse;

    procedure Remove_Item_ReturnTrue;
    procedure Remove_Item_CheckValues_ReturnTrue;
    procedure Remove_Item_CheckLength_ReturnTrue;
    procedure Remove_Item_IsEmpty_ReturnTrue;

    procedure RemoveRange_Items_CheckValues_ReturnTrue;
    procedure RemoveRange_Items_CheckLength_ReturnTrue;
    procedure RemoveRange_Items_IsEmpty_ReturnTrue;

    procedure RemoveRange_Items_RemoveZeroCount_CheckValue_ReturnTrue;
    procedure RemoveRange_Items_RemoveZeroCount_CheckLength_ReturnTrue;
    procedure RemoveRange_Items_RemoveZeroCount_IsEmpty_ReturnFalse;

    procedure Clear_IsEmpty_ReturnTrue;

    procedure IndexOf_Exists_ReturnItemIndex;
    procedure IndexOf_NotExists_ReturnMinusOne;
    procedure IndexOf_Empty_ReturnMinusOne;

    procedure Iterator_ForIn_CheckValue_ReturnTrue;
    procedure Iterator_ForwardIteration_CheckValue_ReturnTrue;
    procedure Iterator_BackwardIteration_CheckValue_ReturnTrue;
    procedure Iterator_Empty_Iteration_ReturnFalse;
  private
    AContainer : TContainer;
    AContainerIterator : TContainerIterator;
  end;

implementation

{$IFNDEF FPC}
procedure TSortedArrayTestCase.AssertTrue(ACondition: Boolean);
begin
  CheckTrue(ACondition);
end;

procedure TSortedArrayTestCase.AssertFalse(ACondition: Boolean);
begin
  CheckFalse(ACondition);
end;

procedure TSortedArrayTestCase.AssertEquals(Expected, Actual : Integer);
begin
  CheckEquals(Expected, Actual);
end;
{$ENDIF}

procedure TSortedArrayTestCase.MakeContainer;
begin
  AContainer := TContainer.Create;
end;

procedure TSortedArrayTestCase.TearDown;
begin
  FreeAndNil(AContainer);
end;

procedure TSortedArrayTestCase.ByDefault_ZeroLength_ReturnTrue;
begin
  MakeContainer;

  AssertEquals(AContainer.Length, 0);
end;

procedure TSortedArrayTestCase.ByDefault_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.IsEmpty);
end;

procedure TSortedArrayTestCase.Append_NewItem_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.Append(0));
end;

procedure TSortedArrayTestCase.Append_Items_CheckValues_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(0);
  AContainer.Append(3);
  AContainer.Append(2);
  AContainer.Append(1);

  AssertEquals(AContainer.Value[0], 0);
  AssertEquals(AContainer.Value[1], 1);
  AssertEquals(AContainer.Value[2], 2);
  AssertEquals(AContainer.Value[3], 3);
end;

procedure TSortedArrayTestCase.Append_Items_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(0);

  AssertEquals(AContainer.Length, 1);
end;

procedure TSortedArrayTestCase.Append_Items_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.Append(0);

  AssertFalse(AContainer.IsEmpty);
end;

procedure TSortedArrayTestCase.Remove_Item_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(0);

  //AssertTrue(AContainer.Remove(0));
end;

procedure TSortedArrayTestCase.Remove_Item_CheckValues_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(0);

  AContainer.Remove(0);

  AssertEquals(AContainer.Value[0], 1);
  AssertEquals(AContainer.Value[1], 2);
end;

procedure TSortedArrayTestCase.Remove_Item_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(0);

  AContainer.Remove(0);

  AssertEquals(AContainer.Length, 2);
end;

procedure TSortedArrayTestCase.Remove_Item_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(0);

  AContainer.Remove(0);

  AssertTrue(AContainer.IsEmpty);
end;

procedure TSortedArrayTestCase.RemoveRange_Items_CheckValues_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(0);

  AContainer.RemoveRange(0, 2);

  AssertEquals(AContainer.Value[0], 2);
end;

procedure TSortedArrayTestCase.RemoveRange_Items_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(0);

  AContainer.RemoveRange(0, 2);

  AssertEquals(AContainer.Length, 1);
end;

procedure TSortedArrayTestCase.RemoveRange_Items_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(0);

  AContainer.RemoveRange(0, 3);

  AssertTrue(AContainer.IsEmpty);
end;

procedure TSortedArrayTestCase
  .RemoveRange_Items_RemoveZeroCount_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(0);

  AContainer.RemoveRange(0, 0);

  AssertEquals(AContainer.Value[0], 0);
  AssertEquals(AContainer.Value[1], 1);
  AssertEquals(AContainer.Value[2], 2);
end;

procedure TSortedArrayTestCase
  .RemoveRange_Items_RemoveZeroCount_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(0);

  AContainer.RemoveRange(0, 0);

  AssertEquals(AContainer.Length, 3);
end;

procedure TSortedArrayTestCase
  .RemoveRange_Items_RemoveZeroCount_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(0);

  AContainer.RemoveRange(0, 0);

  AssertFalse(AContainer.IsEmpty);
end;

procedure TSortedArrayTestCase.Clear_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(0);

  AContainer.Clear;

  AssertTrue(AContainer.IsEmpty);
end;

procedure TSortedArrayTestCase.IndexOf_Exists_ReturnItemIndex;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(0);

  AssertEquals(AContainer.IndexOf(2), 2);
end;

procedure TSortedArrayTestCase.IndexOf_NotExists_ReturnMinusOne;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(0);

  AssertEquals(AContainer.IndexOf(5), -1);
end;

procedure TSortedArrayTestCase.IndexOf_Empty_ReturnMinusOne;
begin
  MakeContainer;

  AssertEquals(AContainer.IndexOf(1), -1);
end;

procedure TSortedArrayTestCase.Iterator_ForIn_CheckValue_ReturnTrue;
var
  Index, Value : Integer;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(0);

  Index := 0;
  for Value in AContainer do
  begin
    case Index of
      0 : begin AssertEquals(Value, 0); Inc(Index); end;
      1 : begin AssertEquals(Value, 1); Inc(Index); end;
      2 : begin AssertEquals(Value, 2); Inc(Index); end;
      else begin AssertTrue(False); Inc(Index); end;
    end;
  end;

  AssertEquals(Index, 3);
end;

procedure TSortedArrayTestCase.Iterator_ForwardIteration_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(0);

  AContainerIterator := AContainer.FirstEntry;
  while AContainerIterator.HasValue do
  begin
    case AContainerIterator.Index of
      0 : AssertEquals(AContainerIterator.Value, 0);
      1 : AssertEquals(AContainerIterator.Value, 1);
      2 : AssertEquals(AContainerIterator.Value, 2);
      else AssertTrue(False);
    end;

    AContainerIterator := AContainerIterator.Next;
  end;
end;

procedure TSortedArrayTestCase.Iterator_BackwardIteration_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(0);

  AContainerIterator := AContainer.LastEntry;
  while AContainerIterator.HasValue do
  begin
    case AContainerIterator.Index of
      0 : AssertEquals(AContainerIterator.Value, 2);
      1 : AssertEquals(AContainerIterator.Value, 1);
      2 : AssertEquals(AContainerIterator.Value, 0);
      else AssertTrue(False);
    end;

    AContainerIterator := AContainerIterator.Prev;
  end;
end;

procedure TSortedArrayTestCase.Iterator_Empty_Iteration_ReturnFalse;
begin
  MakeContainer;

  AContainerIterator := AContainer.FirstEntry;
  while AContainerIterator.HasValue do
  begin
    AssertTrue(False);

    AContainerIterator := AContainerIterator.Next;
  end;
end;

initialization
  RegisterTest(
    'TSortedArray',
    TSortedArrayTestCase{$IFNDEF FPC}.Suite{$ENDIF}
  );
end.
