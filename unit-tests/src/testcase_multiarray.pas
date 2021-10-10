(******************************************************************************)
(*                             libPasC-Algorithms                             *)
(* delphi and object pascal library of  common data structures and algorithms *)
(*                 https://github.com/fragglet/c-algorithms                   *)
(*                                                                            *)
(* Copyright (c) 2021                                       Ivan Semenkov     *)
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

unit testcase_multiarray;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.multiarray, utils.functor
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TIntegerMultiArrayTestCase = class(TTestCase)
  public
    type
      TContainer = {$IFDEF FPC}specialize{$ENDIF} TMultiArray<Integer, 
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
    procedure Append_NewItem_ZeroLength_ReturnTrue;
    procedure Append_NewItem_IsEmpty_ReturnTrue;

    procedure Append_NewItem_Append_NewItem_ReturnTrue;
    procedure Append_NewItem_Prepend_NewItem_ReturnTrue;
    procedure Append_NewItem_Insert_NewItem_ReturnTrue;

    procedure Append_Items_CheckLength_ReturnTrue;
    procedure Append_Items_IsEmpty_ReturnFalse;
    procedure Append_Items_CheckValues_ReturnTrue;

    procedure Append_Items_Append_Items_CheckLength_ReturnTrue;
    procedure Append_Items_Append_Items_IsEmpty_ReturnFalse;
    procedure Append_Items_Prepend_Items_CheckLength_ReturnTrue;
    procedure Append_Items_Prepend_Items_IsEmpty_ReturnFalse;

    procedure Prepend_Items_Append_Items_CheckLength_ReturnTrue;
    procedure Prepend_Items_Append_Items_IsEmpty_ReturnFalse;
    procedure Prepend_Items_Prepend_Items_CheckLength_ReturnTrue;
    procedure Prepend_Items_Prepend_Items_IsEmpty_ReturnFalse;

    procedure Remove_Item_ReturnTrue;
    procedure Remove_Item_CheckLength_ReturnTrue;
    procedure Remove_Item_IsEmpty_ReturnTrue;

    procedure RemoveRange_Items_ReturnTrue;
    procedure RemoveRange_Items_CheckLength_ReturnTrue;
    procedure RemoveRange_Items_IsEmpty_ReturnTrue;

    procedure Insert_Items_ReturnTrue;
    procedure Insert_Items_CheckLength_ReturnTrue;
    procedure Insert_Items_IsEmpty_ReturnFalse;

    procedure Clear_IsEmpty_ReturnTrue;

    procedure Iterator_ForIn_CheckValue_ReturnTrue;
    procedure Iterator_ForwardIterator_CheckValue_ReturnTrue;
    procedure Iterator_BackwardIterator_CheckValue_ReturnTrue;
    procedure Iterator_Empty_Iteration_ReturnFalse;
  private
    AContainer : TContainer;
    AContainerIterator : TContainerIterator;
  end;

implementation

{$IFNDEF FPC}
procedure TIntegerMultiArrayTestCase.AssertTrue(ACondition: Boolean);
begin
  CheckTrue(ACondition);
end;

procedure TIntegerMultiArrayTestCase.AssertFalse(ACondition: Boolean);
begin
  CheckFalse(ACondition);
end;

procedure TIntegerMultiArrayTestCase.AssertEquals(Expected, Actual : Integer);
begin
  CheckEquals(Expected, Actual);
end;
{$ENDIF}

procedure TIntegerMultiArrayTestCase.MakeContainer;
begin
  AContainer := TContainer.Create;
end;

procedure TIntegerMultiArrayTestCase.TearDown;
begin
  FreeAndNil(AContainer);
end;

procedure TIntegerMultiArrayTestCase.ByDefault_ZeroLength_ReturnTrue;
begin
  MakeContainer;

  AssertEquals(AContainer.Length, 0);
end;

procedure TIntegerMultiArrayTestCase.ByDefault_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerMultiArrayTestCase.Append_NewItem_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.Append);
end;

procedure TIntegerMultiArrayTestCase.Append_NewItem_ZeroLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append;

  AssertEquals(AContainer.Value[0].Length, 0);
end;

procedure TIntegerMultiArrayTestCase.Append_NewItem_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append;

  AssertTrue(AContainer.Value[0].IsEmpty);
end;

procedure TIntegerMultiArrayTestCase.Append_NewItem_Append_NewItem_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append;
  AssertTrue(AContainer.Value[0].Append(1));
end;

procedure TIntegerMultiArrayTestCase.Append_NewItem_Prepend_NewItem_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append;
  AssertTrue(AContainer.Value[0].Prepend(1));
end;

procedure TIntegerMultiArrayTestCase.Append_NewItem_Insert_NewItem_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append;
  AssertTrue(AContainer.Value[0].Insert(0, 1));
end;

procedure TIntegerMultiArrayTestCase.Append_Items_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append;
  AssertEquals(AContainer.Length, 1);
end;

procedure TIntegerMultiArrayTestCase.Append_Items_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.Append;
  AssertFalse(AContainer.IsEmpty);
end;

procedure TIntegerMultiArrayTestCase
  .Append_Items_Append_Items_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append;
  AContainer.Value[0].Append(1);

  AssertEquals(AContainer.Value[0].Length, 1);
end;

procedure TIntegerMultiArrayTestCase
  .Append_Items_Append_Items_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.Append;
  AContainer.Value[0].Append(1);

  AssertFalse(AContainer.Value[0].IsEmpty);
end;

procedure TIntegerMultiArrayTestCase.Append_Items_CheckValues_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append;
  AContainer.Value[0].Append(1);
  AContainer.Value[0].Append(2);

  AssertEquals(AContainer.Value[0].Value[0], 1);
  AssertEquals(AContainer.Value[0].Value[1], 2);
end;

procedure TIntegerMultiArrayTestCase
  .Append_Items_Prepend_Items_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append;
  AContainer.Value[0].Prepend(1);

  AssertEquals(AContainer.Value[0].Length, 1);
end;

procedure TIntegerMultiArrayTestCase
  .Append_Items_Prepend_Items_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.Append;
  AContainer.Value[0].Prepend(1);

  AssertFalse(AContainer.Value[0].IsEmpty);
end;

procedure TIntegerMultiArrayTestCase
  .Prepend_Items_Append_Items_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Prepend;
  AContainer.Value[0].Append(1);

  AssertEquals(AContainer.Value[0].Length, 1);
end;

procedure TIntegerMultiArrayTestCase
  .Prepend_Items_Append_Items_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.Prepend;
  AContainer.Value[0].Append(1);

  AssertFalse(AContainer.Value[0].IsEmpty);
end;

procedure TIntegerMultiArrayTestCase
  .Prepend_Items_Prepend_Items_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Prepend;
  AContainer.Value[0].Prepend(1);

  AssertEquals(AContainer.Value[0].Length, 1);
end;

procedure TIntegerMultiArrayTestCase
  .Prepend_Items_Prepend_Items_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.Prepend;
  AContainer.Value[0].Prepend(1);

  AssertFalse(AContainer.Value[0].IsEmpty);
end;

procedure TIntegerMultiArrayTestCase.Remove_Item_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append;
  AssertTrue(AContainer.Remove(0));
end;

procedure TIntegerMultiArrayTestCase.Remove_Item_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append;
  AContainer.Append;
  AContainer.Remove(0);

  AssertEquals(AContainer.Length, 1);
end;

procedure TIntegerMultiArrayTestCase.Remove_Item_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append;
  AContainer.Remove(0);

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerMultiArrayTestCase.RemoveRange_Items_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append;
  AContainer.Append;
  AContainer.Append;

  AssertTrue(AContainer.RemoveRange(0, 3));
end;

procedure TIntegerMultiArrayTestCase.RemoveRange_Items_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append;
  AContainer.Append;
  AContainer.Append;
  AContainer.RemoveRange(1, 2);

  AssertEquals(AContainer.Length, 1);
end;

procedure TIntegerMultiArrayTestCase.RemoveRange_Items_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append;
  AContainer.Append;
  AContainer.Append;
  AContainer.RemoveRange(0, 3);

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerMultiArrayTestCase.Insert_Items_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.Insert(0));
end;

procedure TIntegerMultiArrayTestCase.Insert_Items_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(0);

  AssertEquals(AContainer.Length, 1);
end;

procedure TIntegerMultiArrayTestCase.Insert_Items_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.Insert(0);

  AssertFalse(AContainer.IsEmpty);
end;

procedure TIntegerMultiArrayTestCase.Clear_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append;
  AContainer.Clear;

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerMultiArrayTestCase.Iterator_ForIn_CheckValue_ReturnTrue;
var
  Index : Integer;
  Value : TContainer.TMultiValue;
begin
  MakeContainer;

  AContainer.Append;
  AContainer.Value[0].Append(1);
  AContainer.Value[0].Append(2);

  AContainer.Append;
  AContainer.Value[1].Append(3);
  AContainer.Value[1].Append(4);

  AContainer.Append;
  AContainer.Value[2].Append(5);
  AContainer.Value[2].Append(6);

  Index := 0;
  for Value in AContainer do
  begin
    case Index of
      0 : begin
        AssertEquals(Value.Value[0], 1);
        AssertEquals(Value.Value[1], 2);
        Inc(Index);
      end;
      1 : begin
        AssertEquals(Value.Value[0], 3);
        AssertEquals(Value.Value[1], 4);
        Inc(Index);
      end;
      2 : begin
        AssertEquals(Value.Value[0], 5);
        AssertEquals(Value.Value[1], 6);
        Inc(Index);
      end;
      else begin AssertTrue(False); Inc(Index); end;
    end;
  end;

  AssertEquals(Index, 3);
end;

procedure TIntegerMultiArrayTestCase
  .Iterator_ForwardIterator_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append;
  AContainer.Value[0].Append(1);
  AContainer.Value[0].Append(2);

  AContainer.Append;
  AContainer.Value[1].Append(3);
  AContainer.Value[1].Append(4);

  AContainer.Append;
  AContainer.Value[2].Append(5);
  AContainer.Value[2].Append(6);

  AContainerIterator := AContainer.FirstEntry;
  while AContainerIterator.HasValue do
  begin
    case AContainerIterator.Index of
      0 : begin
        AssertEquals(AContainerIterator.Value.Value[0], 1);
        AssertEquals(AContainerIterator.Value.Value[1], 2);
      end;
      1 : begin
        AssertEquals(AContainerIterator.Value.Value[0], 3);
        AssertEquals(AContainerIterator.Value.Value[1], 4);
      end;
      2 : begin
        AssertEquals(AContainerIterator.Value.Value[0], 5);
        AssertEquals(AContainerIterator.Value.Value[1], 6);
      end;
      else begin AssertTrue(False); end;
    end;

    AContainerIterator := AContainerIterator.Next;
  end;
end;

procedure TIntegerMultiArrayTestCase
  .Iterator_BackwardIterator_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Append;
  AContainer.Value[0].Append(1);
  AContainer.Value[0].Append(2);

  AContainer.Append;
  AContainer.Value[1].Append(3);
  AContainer.Value[1].Append(4);

  AContainer.Append;
  AContainer.Value[2].Append(5);
  AContainer.Value[2].Append(6);

  AContainerIterator := AContainer.LastEntry;
  while AContainerIterator.HasValue do
  begin
    case AContainerIterator.Index of
      2 : begin
        AssertEquals(AContainerIterator.Value.Value[0], 5);
        AssertEquals(AContainerIterator.Value.Value[1], 6);
      end;
      1 : begin
        AssertEquals(AContainerIterator.Value.Value[0], 3);
        AssertEquals(AContainerIterator.Value.Value[1], 4);
      end;
      0 : begin
        AssertEquals(AContainerIterator.Value.Value[0], 1);
        AssertEquals(AContainerIterator.Value.Value[1], 2);
      end;
      else begin AssertTrue(False); end;
    end;

    AContainerIterator := AContainerIterator.Prev;
  end;
end;

procedure TIntegerMultiArrayTestCase.Iterator_Empty_Iteration_ReturnFalse;
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
    'TMultiArray', 
    TIntegerMultiArrayTestCase{$IFNDEF FPC}.Suite{$ENDIF}
  );

end.
