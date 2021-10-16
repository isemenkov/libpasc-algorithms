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

unit testcase_orderedset;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.orderedset, utils.functor
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TIntegerOrderedSetTestCase = class(TTestCase)
  public
    type
      TContainer = {$IFDEF FPC}specialize{$ENDIF} TOrderedSet<Integer, 
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
    procedure ByDefault_NumEntries_ReturnZero;
    procedure ByDefault_IsEmpty_ReturnTrue;

    procedure Insert_NewItem_ReturnTrue;

    procedure Insert_Items_CheckNumEntries_ReturnTrue;
    procedure Insert_Items_IsEmpty_ReturnFalse;
    procedure Insert_Items_CheckValues_ReturnTrue;

    procedure Remove_Items_CheckNumEntries_ReturnTrue;
    procedure Remove_Items_IsEmpty_ReturnTrue;
    procedure Remove_Items_CheckValues_ReturnTrue;

    procedure Union_Items_CheckNumEntries_ReturnTrue;
    procedure Union_Items_CheckValues_ReturnTrue;

    procedure Intersection_Items_CheckNumEntries_RetrunTrue;
    procedure Intersection_Items_CheckValues_ReturnTrue;

    procedure Iterator_ForIn_CheckValue_ReturnTrue;
    procedure Iterator_ForwardIterator_CheckValue_ReturnTrue;
    procedure Iterator_Empty_Iteration_ReturnFalse;
  private
    AContainer : TContainer;
    AContainerIterator : TContainerIterator;
  end;

implementation

{$IFNDEF FPC}
procedure TIntegerOrderedSetTestCase.AssertTrue(ACondition: Boolean);
begin
  CheckTrue(ACondition);
end;

procedure TIntegerOrderedSetTestCase.AssertFalse(ACondition: Boolean);
begin
  CheckFalse(ACondition);
end;

procedure TIntegerOrderedSetTestCase.AssertEquals(Expected, Actual : Integer);
begin
  CheckEquals(Expected, Actual);
end;
{$ENDIF}

procedure TIntegerOrderedSetTestCase.MakeContainer;
begin
  AContainer := TContainer.Create(@HashInteger);
end;

procedure TIntegerOrderedSetTestCase.TearDown;
begin
  FreeAndNil(AContainer);
end;

procedure TIntegerOrderedSetTestCase.ByDefault_NumEntries_ReturnZero;
begin
  MakeContainer;

  AssertEquals(AContainer.NumEntries, 0);
end;

procedure TIntegerOrderedSetTestCase.ByDefault_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerOrderedSetTestCase.Insert_NewItem_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.Insert(1));
end;

procedure TIntegerOrderedSetTestCase.Insert_Items_CheckNumEntries_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1);

  AssertEquals(AContainer.NumEntries, 1);
end;

procedure TIntegerOrderedSetTestCase.Insert_Items_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.Insert(1);

  AssertFalse(AContainer.IsEmpty);
end;

procedure TIntegerOrderedSetTestCase.Insert_Items_CheckValues_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1);

  AssertTrue(AContainer.HasValue(1));
end;

procedure TIntegerOrderedSetTestCase.Remove_Items_CheckNumEntries_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1);
  AContainer.Insert(2);
  AContainer.Insert(0);

  AContainer.Remove(2);

  AssertEquals(AContainer.NumEntries, 2);
end;

procedure TIntegerOrderedSetTestCase.Remove_Items_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1);

  AContainer.Remove(1);

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerOrderedSetTestCase.Remove_Items_CheckValues_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1);
  AContainer.Insert(2);
  AContainer.Insert(0);

  AContainer.Remove(2);

  AssertTrue(AContainer.HasValue(1));
  AssertFalse(AContainer.HasValue(2));
  AssertTrue(AContainer.HasValue(0));
end;

procedure TIntegerOrderedSetTestCase.Union_Items_CheckNumEntries_ReturnTrue;
var
  Container2 : TContainer;
begin
  MakeContainer;
  Container2 := TContainer.Create(@HashInteger);

  Container2.Insert(1);
  Container2.Insert(4);
  Container2.Insert(5);

  AContainer.Insert(1);
  AContainer.Insert(2);
  AContainer.Insert(0);

  AContainer := AContainer.Union(Container2);

  AssertEquals(AContainer.NumEntries, 5);

  FreeAndNil(Container2);
end;

procedure TIntegerOrderedSetTestCase.Union_Items_CheckValues_ReturnTrue;
var
  Container2 : TContainer;
begin
  MakeContainer;
  Container2 := TContainer.Create(@HashInteger);

  Container2.Insert(1);
  Container2.Insert(4);
  Container2.Insert(5);

  AContainer.Insert(1);
  AContainer.Insert(2);
  AContainer.Insert(0);

  AContainer := AContainer.Union(Container2);

  AssertTrue(AContainer.HasValue(0));
  AssertTrue(AContainer.HasValue(1));
  AssertTrue(AContainer.HasValue(2));
  AssertTrue(AContainer.HasValue(4));
  AssertTrue(AContainer.HasValue(5));

  FreeAndNil(Container2);
end;

procedure TIntegerOrderedSetTestCase
  .Intersection_Items_CheckNumEntries_RetrunTrue;
var
  Container2 : TContainer;
begin
  MakeContainer;
  Container2 := TContainer.Create(@HashInteger);

  Container2.Insert(1);
  Container2.Insert(4);
  Container2.Insert(5);

  AContainer.Insert(1);
  AContainer.Insert(2);
  AContainer.Insert(0);

  AContainer := AContainer.Intersection(Container2);

  AssertEquals(AContainer.NumEntries, 1);

  FreeAndNil(Container2);
end;

procedure TIntegerOrderedSetTestCase.Intersection_Items_CheckValues_ReturnTrue;
var
  Container2 : TContainer;
begin
  MakeContainer;
  Container2 := TContainer.Create(@HashInteger);

  Container2.Insert(1);
  Container2.Insert(4);
  Container2.Insert(5);

  AContainer.Insert(1);
  AContainer.Insert(2);
  AContainer.Insert(0);

  AContainer := AContainer.Intersection(Container2);

  AssertTrue(AContainer.HasValue(1));

  FreeAndNil(Container2);
end;

procedure TIntegerOrderedSetTestCase.Iterator_ForIn_CheckValue_ReturnTrue;
var
  Index, Value : Integer;
begin
  MakeContainer;

  AContainer.Insert(1);
  AContainer.Insert(2);
  AContainer.Insert(0);

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

procedure TIntegerOrderedSetTestCase
  .Iterator_ForwardIterator_CheckValue_ReturnTrue;
var
  Index : Integer;
begin
  MakeContainer;

  AContainer.Insert(1);
  AContainer.Insert(2);
  AContainer.Insert(0);

  Index := 0;
  AContainerIterator := AContainer.FirstEntry;
  while AContainerIterator.HasValue do
  begin
    case Index of
      0 : begin AssertEquals(AContainerIterator.Value, 0); Inc(Index); end;
      1 : begin AssertEquals(AContainerIterator.Value, 1); Inc(Index); end;
      2 : begin AssertEquals(AContainerIterator.Value, 2); Inc(Index); end;
      else begin AssertTrue(False); Inc(Index); end;
    end;

    AContainerIterator := AContainerIterator.Next;
  end;

  AssertEquals(Index, 3);
end;

procedure TIntegerOrderedSetTestCase.Iterator_Empty_Iteration_ReturnFalse;
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
    'TOrderedSet',
    TIntegerOrderedSetTestCase{$IFNDEF FPC}.Suite{$ENDIF}
  );

end.

