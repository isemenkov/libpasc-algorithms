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

unit testcase_list;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.list, utils.functor
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TIntegerListTestCase = class(TTestCase)
  public
    type
      TContainer = {$IFDEF FPC}specialize{$ENDIF} TList<Integer,
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
    procedure ByDefault_Length_ReturnZero;
    procedure ByDefault_IsEmpty_ReturnTrue;

    procedure Append_NewItem_ReturnTrue;
    procedure Prepend_NewItem_ReturnTrue;

    procedure Append_Items_CheckValues_ReturnTrue;
    procedure Prepend_Items_CheckValues_ReturnTrue;

    procedure Append_Items_CheckLength_ReturnTrue;
    procedure Prepend_Items_CheckLength_ReturnTrue;

    procedure Append_Items_IsEmpty_ReturnFalse;
    procedure Prepend_Items_IsEmpty_ReturnFalse;

    procedure Remove_Items_Count_ReturnTrue;
    procedure Remove_Items_MultipleCount_ReturnTrue;
    procedure Remove_Items_CheckValue_ReturnTrue;
    procedure Remove_Items_CheckLength_ReturnTrue;
    procedure Remove_Items_IsEmpty_ReturnTrue;

    procedure Clear_IsEmpty_ReturnTrue;

    procedure Find_Exists_HasValue_ReturnTrue;
    procedure Find_Exists_CheckValue_ReturnTrue;
    procedure Find_NotExists_HasValue_ReturnFalse;
    procedure Find_NotExists_CheckValue_RaiseEValueNotExistsException_ReturnTrue;

    procedure NthEntry_Exists_HasValue_ReturnTrue;
    procedure NthEntry_Exists_CheckValue_ReturnTrue;
    procedure NthEntry_NotExists_HasValue_ReturnFalse;
    procedure NthEntry_NotExists_CheckValue_RaiseEValueNotExistsException_ReturnTrue;

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
procedure TIntegerListTestCase.AssertTrue(ACondition: Boolean);
begin
  CheckTrue(ACondition);
end;

procedure TIntegerListTestCase.AssertFalse(ACondition: Boolean);
begin
  CheckFalse(ACondition);
end;

procedure TIntegerListTestCase.AssertEquals(Expected, Actual : Integer);
begin
  CheckEquals(Expected, Actual);
end;
{$ENDIF}

procedure TIntegerListTestCase.MakeContainer;
begin
  AContainer := TContainer.Create;
end;

procedure TIntegerListTestCase.TearDown;
begin
  FreeAndNil(AContainer);
end;

procedure TIntegerListTestCase.ByDefault_Length_ReturnZero;
begin
  MakeContainer;

  AssertEquals(AContainer.Length, 0);
end;

procedure TIntegerListTestCase.ByDefault_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerListTestCase.Append_NewItem_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.Append(1));
end;

procedure TIntegerListTestCase.Prepend_NewItem_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.Prepend(1));
end;

procedure TIntegerListTestCase.Append_Items_CheckValues_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);

  AssertEquals(AContainer.FirstEntry.Value, 1);
end;

procedure TIntegerListTestCase.Prepend_Items_CheckValues_ReturnTrue;
begin
  MakeContainer;

  AContainer.Prepend(1);

  AssertEquals(AContainer.FirstEntry.Value, 1);
end;

procedure TIntegerListTestCase.Append_Items_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);

  AssertEquals(AContainer.Length, 1);
end;

procedure TIntegerListTestCase.Prepend_Items_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Prepend(1);

  AssertEquals(AContainer.Length, 1);
end;

procedure TIntegerListTestCase.Append_Items_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.Append(1);

  AssertFalse(AContainer.IsEmpty);
end;

procedure TIntegerListTestCase.Prepend_Items_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.Prepend(1);

  AssertFalse(AContainer.IsEmpty);
end;

procedure TIntegerListTestCase.Remove_Items_Count_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  AssertEquals(AContainer.Remove(2), 1);
end;

procedure TIntegerListTestCase.Remove_Items_MultipleCount_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(2);
  AContainer.Append(3);

  AssertEquals(AContainer.Remove(2), 2);
end;

procedure TIntegerListTestCase.Remove_Items_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);

  AContainer.Remove(1);

  AssertEquals(AContainer.FirstEntry.Value, 2);
end;

procedure TIntegerListTestCase.Remove_Items_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);

  AContainer.Remove(1);

  AssertEquals(AContainer.Length, 1);
end;

procedure TIntegerListTestCase.Remove_Items_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(1);

  AContainer.Remove(1);

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerListTestCase.Clear_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);

  AContainer.Clear;

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerListTestCase.Find_Exists_HasValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  AssertTrue(AContainer.FindEntry(3).HasValue);
end;

procedure TIntegerListTestCase.Find_Exists_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);

  AssertEquals(AContainer.FindEntry(2).Value, 2);
end;

procedure TIntegerListTestCase.Find_NotExists_HasValue_ReturnFalse;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  AssertFalse(AContainer.FindEntry(5).HasValue);
end;

procedure TIntegerListTestCase
  .Find_NotExists_CheckValue_RaiseEValueNotExistsException_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);

  try
    AContainer.FindEntry(2).Value;
  except on e: EValueNotExistsException do
    begin
      AssertTrue(True);
      Exit;
    end;
  end;

  AssertTrue(False);
end;

procedure TIntegerListTestCase.NthEntry_Exists_HasValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  AssertTrue(AContainer.NthEntry(0).HasValue);
end;

procedure TIntegerListTestCase.NthEntry_Exists_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);

  AssertEquals(AContainer.NthEntry(1).Value, 2);
end;

procedure TIntegerListTestCase.NthEntry_NotExists_HasValue_ReturnFalse;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  AssertFalse(AContainer.NthEntry(3).HasValue);
end;

procedure TIntegerListTestCase
  .NthEntry_NotExists_CheckValue_RaiseEValueNotExistsException_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(1);

  try
    AContainer.NthEntry(1).Value;
  except on e: EValueNotExistsException do
    begin
      AssertTrue(True);
      Exit;
    end;
  end;

  AssertTrue(False);
end;

procedure TIntegerListTestCase.Sort_CheckValues_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append(2);
  AContainer.Append(1);
  AContainer.Append(3);

  AContainer.Sort;

  AssertEquals(AContainer.NthEntry(0).Value, 1);
  AssertEquals(AContainer.NthEntry(1).Value, 2);
  AssertEquals(AContainer.NthEntry(2).Value, 3);
end;

procedure TIntegerListTestCase.Sort_Empty_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AContainer.Sort;

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerListTestCase.Iterator_ForIn_CheckValue_ReturnTrue;
var
  Index, Value: Integer;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  Index := 0;
  for Value in AContainer do
  begin
    case Index of
      0 : begin AssertEquals(Value, 1); Inc(Index); end;
      1 : begin AssertEquals(Value, 2); Inc(Index); end;
      2 : begin AssertEquals(Value, 3); Inc(Index); end;
      else begin AssertTrue(False); Inc(Index); end; 
    end;
  end;

  AssertEquals(Index, 3);
end;

procedure TIntegerListTestCase.Iterator_ForwardIteration_CheckValue_ReturnTrue;
var
  Index: Integer;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  Index := 0;
  AContainerIterator := AContainer.FirstEntry;
  while AContainerIterator.HasValue do
  begin
    case Index of
      0 : begin AssertEquals(AContainerIterator.Value, 1); Inc(Index); end;
      1 : begin AssertEquals(AContainerIterator.Value, 2); Inc(Index); end;
      2 : begin AssertEquals(AContainerIterator.Value, 3); Inc(Index); end;
      else begin AssertTrue(False); Inc(Index); end;
    end;

    AContainerIterator := AContainerIterator.Next;
  end;

  AssertEquals(Index, 3);
end;

procedure TIntegerListTestCase.Iterator_BackwardIteration_CheckValue_ReturnTrue;
var
  Index: Integer;
begin
  MakeContainer;

  AContainer.Append(1);
  AContainer.Append(2);
  AContainer.Append(3);

  Index := 0;
  AContainerIterator := AContainer.LastEntry;
  while AContainerIterator.HasValue do
  begin
    case Index of
      0 : begin AssertEquals(AContainerIterator.Value, 3); Inc(Index); end;
      1 : begin AssertEquals(AContainerIterator.Value, 2); Inc(Index); end;
      2 : begin AssertEquals(AContainerIterator.Value, 1); Inc(Index); end;
      else begin AssertTrue(False); Inc(Index); end;
    end;

    AContainerIterator := AContainerIterator.Prev;
  end;

  AssertEquals(Index, 3);
end;

procedure TIntegerListTestCase.Iterator_Empty_Iteration_ReturnFalse;
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
    'TList', 
    TIntegerListTestCase{$IFNDEF FPC}.Suite{$ENDIF}
  );
end.
