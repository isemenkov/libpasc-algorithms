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

unit testcase_hashtable_performance;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.hashtable, utils.functor
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TIntegerHashTablePerformanceTestCase = class(TTestCase)
  public
    type
      TContainer = {$IFDEF FPC}specialize{$ENDIF} THashTable<Integer, Integer,
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
    procedure Append_OneMillionItems_ReturnTrue;
  private
    AContainer : TContainer;
end;

implementation

{$IFNDEF FPC}
procedure TIntegerHashTablePerformanceTestCase.AssertTrue(ACondition: Boolean);
begin
  CheckTrue(ACondition);
end;

procedure TIntegerHashTablePerformanceTestCase.AssertFalse(ACondition: Boolean);
begin
  CheckFalse(ACondition);
end;

procedure TIntegerHashTablePerformanceTestCase.AssertEquals(Expected, 
  Actual : Integer);
begin
  CheckEquals(Expected, Actual);
end;
{$ENDIF}

procedure TIntegerHashTablePerformanceTestCase.MakeContainer;
begin
  AContainer := TContainer.Create(@HashInteger);
end;

procedure TIntegerHashTablePerformanceTestCase.TearDown;
begin
  FreeAndNil(AContainer);
end;

procedure TIntegerHashTablePerformanceTestCase
  .Append_OneMillionItems_ReturnTrue;
var
  i : Integer;
begin
  MakeContainer;

  for i := 0 to 999999 do
  begin
    AContainer.Insert(i, i);
  end;

  AssertEquals(AContainer.NumEntries, 1000000);
end;

initialization
  RegisterTest(
    'THashTable', 
    TIntegerHashTablePerformanceTestCase{$IFNDEF FPC}.Suite{$ENDIF}
  );
end.
