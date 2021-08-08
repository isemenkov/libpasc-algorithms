(******************************************************************************)
(*                             libPasC-Algorithms                             *)
(* delphi and object pascal library of  common data structures and algorithms *)
(*                 https://github.com/fragglet/c-algorithms                   *)
(*                                                                            *)
(* Copyright (c) 2020 - 2021                                Ivan Semenkov     *)
(* https://github.com/isemenkov/libpasc-algorithms          ivan@semenkov.pro *)
(*                                                          Ukraine           *)
(******************************************************************************)
(*                                                                            *)
(* Permission is hereby  granted, free of  charge, to any  person obtaining a *)
(* copy of this software and associated documentation files (the "Software"), *)
(* to deal in the Software without  restriction, including without limitation *)
(* the rights  to use, copy,  modify, merge, publish, distribute, sublicense, *)
(* and/or  sell copies of  the Software,  and to permit  persons to  whom the *)
(* Software  is  furnished  to  do so, subject  to the following  conditions: *)
(*                                                                            *)
(* The above copyright notice and this permission notice shall be included in *)
(* all copies or substantial portions of the Software.                        *)
(*                                                                            *)
(* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR *)
(* IMPLIED, INCLUDING BUT NOT  LIMITED TO THE WARRANTIES  OF MERCHANTABILITY, *)
(* FITNESS FOR A  PARTICULAR PURPOSE AND  NONINFRINGEMENT. IN NO  EVENT SHALL *)
(* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER *)
(* LIABILITY,  WHETHER IN AN ACTION OF  CONTRACT, TORT OR  OTHERWISE, ARISING *)
(* FROM,  OUT OF OR  IN  CONNECTION WITH THE  SOFTWARE OR  THE  USE  OR OTHER *)
(* DEALINGS IN THE SOFTWARE.                                                  *)
(*                                                                            *)
(******************************************************************************)

unit testcase_arraylist;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.arraylist, utils.functor, utils.pair,
  utils.enumerate, utils.functional
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TIntegerArrayListTestCase = class(TTestCase)
  public
    type
      TContainer = {$IFDEF FPC}specialize{$ENDIF} TArrayList<Integer, 
        TCompareFunctorInteger>;
      TContainerIterator = TContainer.TIterator;
  public
    procedure MakeContainer;
    procedure TearDown; override;

    {$IFNDEF FPC}
    procedure AssertTrue (ACondition : Boolean);
    procedure AssertFalse (ACondition: Boolean);
    {$ENDIF} 
  published
    procedure ByDefault_ZeroLength_ReturnTrue;
    procedure ByDefault_IsEmpty_ReturnTrue;

    procedure Append_NewItem_ReturnTrue;
    procedure Prepend_NewItem_ReturnTrue;
    procedure Insert_NewItem_ReturnTrue;

    procedure Append_Items_CheckValues_ReturnTrue;
    procedure Prepend_Items_CheckValues_ReturnTrue;
    procedure Insert_Items_CheckValues_ReturnTrue;

    procedure Append_Items_CheckLength_ReturnTrue;
    procedure Prepend_Items_CheckLength_ReturnTrue;
    procedure Insert_Items_CheckLength_ReturnTrue;

    procedure Append_Items_IsEmpty_ReturnFalse;
    procedure Prepend_Items_IsEmpty_ReturnFalse;
    procedure Insert_Items_IsEmpty_ReturnFalse;

    procedure Insert_Items_AfterUpperBound_ReturnFalse;
    procedure Insert_Items_AfterUpperBound_CheckValue_RaiseEIndexOutOfRangeException_ReturnTrue;
    procedure Insert_Items_AfterUpperBound_CheckLength_ReturnFalse;
    procedure Insert_Items_AfterUpperBound_IsEmpty_ReturnTrue;

    procedure Insert_Items_BeforeLowerBound_ReturnFalse;
    procedure Insert_Items_BeforeLowerBound_CheckValue_RaiseEIndexOutOfRangeException_ReturnTrue;
    procedure Insert_Items_BeforeLowerBound_CheckLength_ReturnFalse;
    procedure Insert_Items_BeforeLowerBound_IsEmpty_ReturnTrue;

    procedure Remove_Item_ReturnTrue;
    procedure Remove_Item_CheckValues_ReturnTrue;
    procedure Remove_Item_CheckLength_ReturnTrue;
    procedure Remove_Item_IsEmpty_ReturnTrue;

    procedure Remove_Item_AfterUpperBound_ReturnFalse;
    procedure Remove_Item_AfterUpperBound_CheckValue_ReturnTrue;
    procedure Remove_Item_AfterUpperBound_CheckLength_ReturnTrue;
    procedure Remove_Item_AfterUpperBound_IsEmpty_ReturnFalse;

    procedure Remove_Item_BeforeLowerBound_ReturnFalse;
    procedure Remove_Item_BeforeLowerBound_CheckValue_ReturnTrue;
    procedure Remove_Item_BeforeLowerBound_CheckLength_ReturnTrue;
    procedure Remove_Item_BeforeLowerBound_IsEmpty_ReturnFalse;

    procedure RemoveRange_Items_ReturnTrue;
    procedure RemoveRange_Items_CheckValues_ReturnTrue;
    procedure RemoveRange_Items_CheckLength_ReturnTrue;
    procedure RemoveRange_Items_IsEmpty_ReturnTrue;

    procedure RemoveRange_Items_AfterUpperBoundIndex_ReturnFalse;
    procedure RemoveRange_Items_AfterUpperBoundIndex_CheckValue_ReturnTrue;
    procedure RemoveRange_Items_AfterUpperBoundIndex_CheckLength_ReturnTrue;
    procedure RemoveRange_Items_AgterUpperBoundIndex_IsEmpty_ReturnFalse;

    procedure RemoveRange_Items_BeforeLowerBoundIndex_ReturnFalse;
    procedure RemoveRange_Items_BeforeLowerBoundIndex_CheckValue_ReturnTrue;
    procedure RemoveRange_Items_BeforeLowerBoundIndex_CheckLength_ReturnTrue;
    procedure RemoveRange_Items_BeforeLowerBoundIndex_IsEmpty_ReturnFalse;

    procedure RemoveRange_Items_RemoveZeroCount_ReturnTrue;
    procedure RemoveRange_Items_RemoveZeroCount_CheckValue_ReturnTrue;
    procedure RemoveRange_Items_RemoveZeroCount_CheckLength_ReturnTrue;
    procedure RemoveRange_Items_RemoveZeroCount_IsEmpty_ReturnFalse;

    procedure Clear_IsEmpty_ReturnTrue;

    procedure IndexOf_ReturnTrue;
    procedure IndexOf_ReturnFalse;
    procedure IndexOf_CheckIndex_ReturnTrue;
    procedure IndexOf_CheckIndex_ReturnFalse;

    procedure Value_AfterUpperBoundIndex_RaiseEIndexOutOfRangeException_ReturnTrue;
    procedure Value_BeforeLowerBoundIndex_RaiseEIndexOutOfRangeException_ReturnTrue;

    procedure Sort_CheckValues_ReturnTrue;
    procedure Sort_Empty_IsEmpty_ReturnTrue;

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
procedure TIntegerArrayListTestCase.AssertTrue(ACondition: Boolean);
begin
  CheckTrue(ACondition);
end;

procedure TIntegerArrayListTestCase.AssertFalse(ACondition: Boolean);
begin
  CheckFalse(ACondition);
end;
{$ENDIF}


procedure TIntegerArrayListTestCase.MakeContainer;
begin
  AContainer := TContainer.Create;
end;

procedure TIntegerArrayListTestCase.TearDown;
begin
  FreeAndNil(AContainer);
end;

procedure TIntegerArrayListTestCase.ByDefault_ZeroLength_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.Length = 0);
end;

procedure TIntegerArrayListTestCase.ByDefault_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerArrayListTestCase.Append_NewItem_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.Append(0));
end;

procedure TIntegerArrayListTestCase.Prepend_NewItem_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.Prepend(0));
end;

procedure TIntegerArrayListTestCase.Insert_NewItem_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.Insert(0, 0));
end;

procedure TIntegerArrayListTestCase.Append_Items_CheckValues_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  AssertTrue(AContainer.Value[0] = 1);
  AssertTrue(AContainer.Value[1] = 2);
  AssertTrue(AContainer.Value[2] = 3);
end;

procedure TIntegerArrayListTestCase.Prepend_Items_CheckValues_ReturnTrue;
begin
  MakeContainer;

  AContainer.Prepend(1);
  AContainer.Prepend(2);
  AContainer.Prepend(3);

  AssertTrue(AContainer.Value[0] = 3);
  AssertTrue(AContainer.Value[1] = 2);
  AssertTrue(AContainer.Value[2] = 1);
end;

procedure TIntegerArrayListTestCase.Insert_Items_CheckValues_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(0, 1);
  AContainer.Insert(1, 2);
  AContainer.Insert(0, 3);

  AssertTrue(AContainer.Value[0] = 3);
  AssertTrue(AContainer.Value[1] = 1);
  AssertTrue(AContainer.Value[2] = 2);
end;

procedure TIntegerArrayListTestCase.Append_Items_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(0);

  AssertTrue(AContainer.Length = 1);
end;

procedure TIntegerArrayListTestCase.Prepend_Items_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Prepend(0);

  AssertTrue(AContainer.Length = 1);
end;

procedure TIntegerArrayListTestCase.Insert_Items_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(0, 0);

  AssertTrue(AContainer.Length = 1);
end;

procedure TIntegerArrayListTestCase.Append_Items_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.Append(1);

  AssertFalse(AContainer.IsEmpty);
end;

procedure TIntegerArrayListTestCase.Prepend_Items_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.Prepend(1);

  AssertFalse(AContainer.IsEmpty);
end;

procedure TIntegerArrayListTestCase.Insert_Items_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.Insert(0, 1);

  AssertFalse(AContainer.IsEmpty);
end;

procedure TIntegerArrayListTestCase
  .Insert_Items_AfterUpperBound_ReturnFalse;
begin
  MakeContainer;

  AssertFalse(AContainer.Insert(2, 0));
end;

procedure TIntegerArrayListTestCase
  .Insert_Items_AfterUpperBound_CheckValue_RaiseEIndexOutOfRangeException_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(2, 1);

  try 
    AContainer.Value[0];
  except on e: EIndexOutOfRangeException do
    begin
      AssertTrue(true);
      Exit;
    end;
  end;

  AssertTrue(false);
end;

procedure TIntegerArrayListTestCase
  .Insert_Items_AfterUpperBound_CheckLength_ReturnFalse;
begin
  MakeContainer;

  AContainer.Insert(2, 1);

  AssertFalse(AContainer.Length = 1);
end;

procedure TIntegerArrayListTestCase
  .Insert_Items_AfterUpperBound_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(2, 1);

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerArrayListTestCase
  .Insert_Items_BeforeLowerBound_ReturnFalse;
begin
  MakeContainer;

  AssertFalse(AContainer.Insert(-1, 1));
end;

procedure TIntegerArrayListTestCase
  .Insert_Items_BeforeLowerBound_CheckValue_RaiseEIndexOutOfRangeException_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(-1, 1);

  try
    AContainer.Value[0];
  except on e: EIndexOutOfRangeException do
    begin
      AssertTrue(true);
      Exit;
    end;
  end;

  AssertTrue(false);
end;

procedure TIntegerArrayListTestCase
  .Insert_Items_BeforeLowerBound_CheckLength_ReturnFalse;
begin
  MakeContainer;

  AContainer.Insert(-1, 1);

  AssertFalse(AContainer.Length = 1);
end;

procedure TIntegerArrayListTestCase
  .Insert_Items_BeforeLowerBound_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(-1, 1);

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerArrayListTestCase.Remove_Item_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);

  AssertTrue(AContainer.Remove(0));
end;

procedure TIntegerArrayListTestCase.Remove_Item_AfterUpperBound_ReturnFalse;
begin
  MakeContainer;

  AContainer.Append(1);

  AssertFalse(AContainer.Remove(5));
end;

procedure TIntegerArrayListTestCase.Remove_Item_BeforeLowerBound_ReturnFalse;
begin
  MakeContainer;

  AContainer.Append(1);

  AssertFalse(AContainer.Remove(-1));
end;

procedure TIntegerArrayListTestCase.Remove_Item_CheckValues_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  AContainer.Remove(0);

  AssertTrue(AContainer.Value[0] = 2);
  AssertTrue(AContainer.Value[1] = 3);
end;

procedure TIntegerArrayListTestCase.Remove_Item_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  AContainer.Remove(0);

  AssertTrue(AContainer.Length = 2);
end;

procedure TIntegerArrayListTestCase.Remove_Item_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);

  AContainer.Remove(0);

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerArrayListTestCase
  .Remove_Item_AfterUpperBound_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  
  AContainer.Remove(3);

  AssertTrue(AContainer.Value[0] = 1);
end;

procedure TIntegerArrayListTestCase
  .Remove_Item_AfterUpperBound_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);

  AContainer.Remove(2);

  AssertTrue(AContainer.Length = 1);
end;

procedure TIntegerArrayListTestCase
  .Remove_Item_AfterUpperBound_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.Append(1);

  AContainer.Remove(2);

  AssertFalse(AContainer.IsEmpty);
end;

procedure TIntegerArrayListTestCase
  .Remove_Item_BeforeLowerBound_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);

  AContainer.Remove(-1);

  AssertTrue(AContainer.Value[0] = 1);
end;

procedure TIntegerArrayListTestCase
  .Remove_Item_BeforeLowerBound_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);

  AContainer.Remove(-1);

  AssertTrue(AContainer.Length = 1);
end;

procedure TIntegerArrayListTestCase
  .Remove_Item_BeforeLowerBound_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.Append(1);

  AContainer.Remove(-1);

  AssertFalse(AContainer.IsEmpty);
end;

procedure TIntegerArrayListTestCase.RemoveRange_Items_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  AssertTrue(AContainer.RemoveRange(0, 2));
end;

procedure TIntegerArrayListTestCase.RemoveRange_Items_CheckValues_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  AContainer.RemoveRange(0, 2);

  AssertTrue(AContainer.Value[0] = 3);
end;

procedure TIntegerArrayListTestCase.RemoveRange_Items_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  AContainer.RemoveRange(0, 2);

  AssertTrue(AContainer.Length = 1);
end;

procedure TIntegerArrayListTestCase.RemoveRange_Items_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  AContainer.RemoveRange(0, 3);

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerArrayListTestCase
  .RemoveRange_Items_AfterUpperBoundIndex_ReturnFalse;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);

  AssertFalse(AContainer.RemoveRange(3, 1));
end;

procedure TIntegerArrayListTestCase
  .RemoveRange_Items_AfterUpperBoundIndex_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);

  AContainer.RemoveRange(3, 1);

  AssertTrue(AContainer.Value[0] = 1);
  AssertTrue(AContainer.Value[1] = 2);
end;

procedure TIntegerArrayListTestCase
  .RemoveRange_Items_AfterUpperBoundIndex_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);

  AContainer.RemoveRange(3, 1);

  AssertTrue(AContainer.Length = 2);
end;

procedure TIntegerArrayListTestCase
  .RemoveRange_Items_AgterUpperBoundIndex_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);

  AContainer.RemoveRange(3, 1);

  AssertFalse(AContainer.IsEmpty);
end;

procedure TIntegerArrayListTestCase
  .RemoveRange_Items_BeforeLowerBoundIndex_ReturnFalse;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);

  AssertFalse(AContainer.RemoveRange(-1, 2));
end;

procedure TIntegerArrayListTestCase
  .RemoveRange_Items_BeforeLowerBoundIndex_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);

  AContainer.RemoveRange(-1, 2);

  AssertTrue(AContainer.Value[0] = 1);
  AssertTrue(AContainer.Value[1] = 2);
end;

procedure TIntegerArrayListTestCase
  .RemoveRange_Items_BeforeLowerBoundIndex_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);

  AContainer.RemoveRange(-1, 2);

  AssertTrue(AContainer.Length = 2);
end;

procedure TIntegerArrayListTestCase
  .RemoveRange_Items_BeforeLowerBoundIndex_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);

  AContainer.RemoveRange(-1, 2);

  AssertFalse(AContainer.IsEmpty);
end;

procedure TIntegerArrayListTestCase
  .RemoveRange_Items_RemoveZeroCount_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);

  AssertTrue(AContainer.RemoveRange(0, 0));
end;

procedure TIntegerArrayListTestCase
  .RemoveRange_Items_RemoveZeroCount_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);

  AContainer.RemoveRange(0, 0);

  AssertTrue(AContainer.Value[0] = 1);
  AssertTrue(AContainer.Value[1] = 2);
end;

procedure TIntegerArrayListTestCase
  .RemoveRange_Items_RemoveZeroCount_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);

  AContainer.RemoveRange(0, 0);

  AssertTrue(AContainer.Length = 2);
end;

procedure TIntegerArrayListTestCase
  .RemoveRange_Items_RemoveZeroCount_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  
  AContainer.RemoveRange(0, 0);

  AssertFalse(AContainer.IsEmpty);
end;

procedure TIntegerArrayListTestCase.Clear_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  AContainer.Clear;

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerArrayListTestCase.IndexOf_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  AssertTrue(AContainer.IndexOf(2) <> -1);
end;

procedure TIntegerArrayListTestCase.IndexOf_ReturnFalse;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  AssertFalse(AContainer.IndexOf(0) <> -1);
end;

procedure TIntegerArrayListTestCase.IndexOf_CheckIndex_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  AssertTrue(AContainer.IndexOf(2) = 1);
end;

procedure TIntegerArrayListTestCase.IndexOf_CheckIndex_ReturnFalse;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  AssertFalse(AContainer.IndexOf(3) = 1);
end;

procedure TIntegerArrayListTestCase
  .Value_AfterUpperBoundIndex_RaiseEIndexOutOfRangeException_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  
  try
    AContainer.Value[3];
  except on e: EIndexOutOfRangeException do
    begin
      AssertTrue(true);
      Exit;
    end;
  end;

  AssertTrue(false);
end;

procedure TIntegerArrayListTestCase
  .Value_BeforeLowerBoundIndex_RaiseEIndexOutOfRangeException_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);

  try 
    AContainer.Value[-1];
  except on e: EIndexOutOfRangeException do
    begin
      AssertTrue(true);
      Exit;
    end;
  end;

  AssertTrue(false);
end;

procedure TIntegerArrayListTestCase.Sort_CheckValues_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(3);
  AContainer.Append(1);
  AContainer.Append(5);
  AContainer.Append(2);

  AContainer.Sort;

  AssertTrue(AContainer.Value[0] = 1);
  AssertTrue(AContainer.Value[1] = 2);
  AssertTrue(AContainer.Value[2] = 3);
  AssertTrue(AContainer.Value[3] = 5);
end;

procedure TIntegerArrayListTestCase.Sort_Empty_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AContainer.Sort;

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerArrayListTestCase.Iterator_ForIn_CheckValue_ReturnTrue;
var
  Index, Value : Integer;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  Index := 0;
  for Value in AContainer do
  begin
    case Index of
      0 : begin AssertTrue(Value = 1); Inc(Index); end;
      1 : begin AssertTrue(Value = 2); Inc(Index); end;
      2 : begin AssertTrue(Value = 3); Inc(Index); end;
      else begin AssertTrue(False); Inc(Index); end;
    end;
  end;

  AssertTrue(Index = 3);
end;

procedure TIntegerArrayListTestCase
  .Iterator_ForwardIteration_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  AContainerIterator := AContainer.FirstEntry;
  while AContainerIterator.HasValue do
  begin
    case AContainerIterator.Index of
      0 : AssertTrue(AContainerIterator.Value = 1);
      1 : AssertTrue(AContainerIterator.Value = 2);
      2 : AssertTrue(AContainerIterator.Value = 3);
      else AssertTrue(False);
    end;

    AContainerIterator := AContainerIterator.Next;
  end;
end;

procedure TIntegerArrayListTestCase
  .Iterator_BackwardIteration_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  AContainerIterator := AContainer.LastEntry;
  while AContainerIterator.HasValue do
  begin
    case AContainerIterator.Index of
      2 : AssertTrue(AContainerIterator.Value = 3);
      1 : AssertTrue(AContainerIterator.Value = 2);
      0 : AssertTrue(AContainerIterator.Value = 1);
      else AssertTrue(False);
    end;

    AContainerIterator := AContainerIterator.Prev;
  end;
end;

procedure TIntegerArrayListTestCase.Iterator_Empty_Iteration_ReturnFalse;
begin
  MakeContainer;

  AContainerIterator := AContainer.FirstEntry;
  while AContainerIterator.HasValue do
  begin
    AssertTrue(False);

    AContainerIterator := AContainerIterator.Next;
  end;

  AssertFalse(False);
end;

initialization
  RegisterTest(
    'TArrayList', 
    TIntegerArrayListTestCase{$IFNDEF FPC}.Suite{$ENDIF}
  );
end.
