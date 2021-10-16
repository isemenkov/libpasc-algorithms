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

unit testcase_arraylist_performance;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.arraylist, utils.functor
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TIntegerArrayListPerformanceTestCase = class(TTestCase)
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
    procedure AssertEquals (Expected, Actual : Integer);
    {$ENDIF} 
  published
    procedure Append_OneMillionItems_ReturnTrue;
  private
    AContainer : TContainer;
end;

implementation

{$IFNDEF FPC}
procedure TIntegerArrayListPerformanceTestCase.AssertTrue(ACondition: Boolean);
begin
  CheckTrue(ACondition);
end;

procedure TIntegerArrayListPerformanceTestCase.AssertFalse(ACondition: Boolean);
begin
  CheckFalse(ACondition);
end;

procedure TIntegerArrayListPerformanceTestCase.AssertEquals(Expected, 
  Actual : Integer);
begin
  CheckEquals(Expected, Actual);
end;
{$ENDIF}

procedure TIntegerArrayListPerformanceTestCase.MakeContainer;
begin
  AContainer := TContainer.Create;
end;

procedure TIntegerArrayListPerformanceTestCase.TearDown;
begin
  FreeAndNil(AContainer);
end;

procedure TIntegerArrayListPerformanceTestCase
  .Append_OneMillionItems_ReturnTrue;
var
  i : Integer;
begin
  MakeContainer;

  for i := 0 to 999999 do
  begin
    AssertTrue(AContainer.Append(i));
  end;

  AssertEquals(AContainer.Length, 1000000);
end;

initialization
  RegisterTest(
    'TArrayList', 
    TIntegerArrayListPerformanceTestCase{$IFNDEF FPC}.Suite{$ENDIF}
  );
end.
