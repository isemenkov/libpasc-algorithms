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

unit testcase_multihash;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.hashtable, container.multihash, utils.functor
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TIntegerMultiHashTestCase = class(TTestCase)
  public
    type
      TContainer = {$IFDEF FPC}specialize{$ENDIF} TMultiHash<Integer, Integer, 
        TCompareFunctorInteger, TCompareFunctorInteger>;
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
    procedure ByDefault_ZeroNumEntries_ReturnTrue;
    procedure ByDefault_IsEmpty_ReturnTrue;

    procedure Insert_NewItem_ReturnTrue;

    procedure Insert_Items_CheckValues_ReturnTrue;
    procedure Insert_Items_CheckLength_ReturnTrue;
    procedure Insert_Items_IsEmpty_ReturnFalse;

    procedure Insert_MultipleItems_CheckValues_ReturnTrue;
    procedure Insert_MultipleItems_CheckLength_ReturnTrue;

    procedure Remove_Items_CheckValue_ReturnTrue;
    procedure Remove_Items_CheckNumEntries_ReturnTrue;
    procedure Remove_Items_IsEmpty_ReturnTrue;
    procedure Remove_Items_NotExistsValue_ReturnFalse;

    procedure Search_Exists_CheckValue_ReturnTrue;
    procedure Search_NotExists_CheckValue_RaiseEKeyNotExistsException_ReturnTrue;

    procedure SearchDefault_Exists_CheckValue_ReturnTrue;
    procedure SearchDefault_NotExists_CheckValue_ReturnTrue;

    procedure Iterator_ForIn_CheckValue_ReturnTrue;
    procedure Iterator_ForwardIterator_CheckValue_ReturnTrue;
    procedure Iterator_Empty_Iteration_ReturnFalse;
  private
    AContainer : TContainer;
    AContainerIterator : TContainerIterator;
  end;

implementation

{$IFNDEF FPC}
procedure TIntegerMultiHashTestCase.AssertTrue(ACondition: Boolean);
begin
  CheckTrue(ACondition);
end;

procedure TIntegerMultiHashTestCase.AssertFalse(ACondition: Boolean);
begin
  CheckFalse(ACondition);
end;

procedure TIntegerMultiHashTestCase.AssertEquals(Expected, Actual : Integer);
begin
  CheckEquals(Expected, Actual);
end;
{$ENDIF}

procedure TIntegerMultiHashTestCase.MakeContainer;
begin
  AContainer := TContainer.Create(@HashInteger);
end;

procedure TIntegerMultiHashTestCase.TearDown;
begin
  FreeAndNil(AContainer);
end;

procedure TIntegerMultiHashTestCase.ByDefault_ZeroNumEntries_ReturnTrue;
begin
  MakeContainer;

  AssertEquals(AContainer.NumEntries, 0);
end;

procedure TIntegerMultiHashTestCase.ByDefault_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerMultiHashTestCase.Insert_NewItem_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.Insert(1, 1));
end;

procedure TIntegerMultiHashTestCase.Insert_Items_CheckValues_ReturnTrue;
var
  MultiValue : TContainer.TMultiValue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);
  MultiValue := AContainer.Search(1);

  AssertEquals(MultiValue.NthEntry(0).Value, 1);
end;

procedure TIntegerMultiHashTestCase.Insert_MultipleItems_CheckValues_ReturnTrue;
var
  Value : TContainer.TMultiValue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);
  AContainer.Insert(1, 2);

  Value := AContainer.Search(1);

  AssertEquals(Value.NthEntry(0).Value, 1);
  AssertEquals(Value.NthEntry(1).Value, 2);
end;

procedure TIntegerMultiHashTestCase.Insert_MultipleItems_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);
  AContainer.Insert(1, 2);

  AssertEquals(AContainer.Search(1).Length, 2);
end;

procedure TIntegerMultiHashTestCase.Insert_Items_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  AssertEquals(AContainer.NumEntries, 1);
end;

procedure TIntegerMultiHashTestCase.Insert_Items_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  AssertFalse(AContainer.IsEmpty);
end;

procedure TIntegerMultiHashTestCase.Remove_Items_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  AssertTrue(AContainer.Remove(1));
end;

procedure TIntegerMultiHashTestCase.Remove_Items_NotExistsValue_ReturnFalse;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  AssertFalse(AContainer.Remove(2));
end;

procedure TIntegerMultiHashTestCase.Remove_Items_CheckNumEntries_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);
  AContainer.Insert(2, 2);
  AContainer.Remove(1);

  AssertEquals(AContainer.NumEntries, 1);
end;

procedure TIntegerMultiHashTestCase.Remove_Items_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);
  AContainer.Remove(1);

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerMultiHashTestCase.Search_Exists_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  AssertEquals(AContainer.Search(1).NthEntry(0).Value, 1);
end;

procedure TIntegerMultiHashTestCase
  .Search_NotExists_CheckValue_RaiseEKeyNotExistsException_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  try
    AContainer.Search(2);
  except
    on e: EKeyNotExistsException do
    begin
      AssertTrue(True);
      Exit;
    end;
  end;

  AssertTrue(False);
end;

procedure TIntegerMultiHashTestCase.SearchDefault_Exists_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  AssertEquals(AContainer.SearchDefault(1, 4).NthEntry(0).Value, 1);
end;

procedure TIntegerMultiHashTestCase
  .SearchDefault_NotExists_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  AssertEquals(AContainer.SearchDefault(2, 4).NthEntry(0).Value, 4);
end;

procedure TIntegerMultiHashTestCase.Iterator_ForIn_CheckValue_ReturnTrue;
var
  ContainsValue: array [0 .. 3] of Boolean;
  Index: Integer;
  Value: TContainer.TKeyMultiValuePair;
begin
  MakeContainer;

  AContainer.Insert(1, 1);
  AContainer.Insert(2, 4);
  AContainer.Insert(3, 9);
  AContainer.Insert(4, 16);

  ContainsValue[0] := False;
  ContainsValue[1] := False;
  ContainsValue[2] := False;
  ContainsValue[3] := False;

  Index := 0;
  for Value in AContainer do
  begin
    case Value.First of
      1 : begin ContainsValue[0] := True; Inc(Index); end;
      2 : begin ContainsValue[1] := True; Inc(Index); end;
      3 : begin ContainsValue[2] := True; Inc(Index); end;
      4 : begin ContainsValue[3] := True; Inc(Index); end;
      else begin AssertTrue(False); Inc(Index); end;
    end;
  end;

  AssertTrue(ContainsValue[0]);
  AssertTrue(ContainsValue[1]);
  AssertTrue(ContainsValue[2]);
  AssertTrue(ContainsValue[3]);
  AssertEquals(Index, 4);
end;

procedure TIntegerMultiHashTestCase
  .Iterator_ForwardIterator_CheckValue_ReturnTrue;
var
  ContainsValue: array [0 .. 3] of Boolean;
  Index: Integer;
begin
  MakeContainer;

  AContainer.Insert(1, 1);
  AContainer.Insert(2, 4);
  AContainer.Insert(3, 9);
  AContainer.Insert(4, 16);

  ContainsValue[0] := False;
  ContainsValue[1] := False;
  ContainsValue[2] := False;
  ContainsValue[3] := False;

  Index := 0;
  AContainerIterator := AContainer.FirstEntry;
  while AContainerIterator.HasValue do
  begin
    case AContainerIterator.Key of
      1 : begin ContainsValue[0] := True; Inc(Index); end;
      2 : begin ContainsValue[1] := True; Inc(Index); end;
      3 : begin ContainsValue[2] := True; Inc(Index); end;
      4 : begin ContainsValue[3] := True; Inc(Index); end;
      else begin AssertTrue(False); Inc(Index); end;
    end;

    AContainerIterator := AContainerIterator.Next;
  end;

  AssertTrue(ContainsValue[0]);
  AssertTrue(ContainsValue[1]);
  AssertTrue(ContainsValue[2]);
  AssertTrue(ContainsValue[3]);
  AssertEquals(Index, 4);
end;

procedure TIntegerMultiHashTestCase.Iterator_Empty_Iteration_ReturnFalse;
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
    'TMultiHash',
    TIntegerMultiHashTestCase{$IFNDEF FPC}.Suite{$ENDIF}
  );
end.

