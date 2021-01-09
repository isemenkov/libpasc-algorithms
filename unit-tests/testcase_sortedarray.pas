unit testcase_sortedarray;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.sortedarray, utils.functor, utils.pair,
  utils.enumerate, utils.functional
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TIntegerSortedArray = {$IFDEF FPC}specialize{$ENDIF} TSortedArray<Integer,
    TCompareFunctorInteger>;

  TSortedArrayTestCase = class(TTestCase)
  public
    {$IFNDEF FPC}
    procedure AssertTrue (AMessage : String; ACondition : Boolean);
    {$ENDIF}
  published
    procedure Test_IntegerSortedArray_CreateNewEmpty;
    procedure Test_IntegerSortedArray_AppendNewValueInto;

  end;

implementation

{$IFNDEF FPC}
procedure TSortedArrayTestCase.AssertTrue(AMessage : String; ACondition :
  Boolean);
begin
  CheckTrue(ACondition, AMessage);
end;
{$ENDIF}

procedure TSortedArrayTestCase.Test_IntegerSortedArray_CreateNewEmpty;
var
  arr : TIntegerSortedArray;
begin
  arr := TIntegerSortedArray.Create(0);

  AssertTrue('#Test_IntegerSortedArray_CreateNewEmpty -> ' +
   'ArrayList must be empty', arr.Length = 0);

  FreeAndNil(arr);
end;

procedure TSortedArrayTestCase.Test_IntegerSortedArray_AppendNewValueInto;
var
  arr : TIntegerSortedArray;
begin
  arr := TIntegerSortedArray.Create(3);

  AssertTrue('#Test_IntegerSortedArray_AppendNewValueInto -> ' +
    'ArrayList value 1 not append', arr.Append(4));
  AssertTrue('#Test_IntegerSortedArray_AppendNewValueInto -> ' +
    'ArrayList value 4 not append', arr.Append(3));
  AssertTrue('#Test_IntegerSortedArray_AppendNewValueInto -> ' +
    'ArrayList value 5 not append', arr.Append(8));

  AssertTrue('#Test_IntegerSortedArray_AppendNewValueInto -> ' +
    'ArrayLists length is not correct', arr.Length = 3);

  AssertTrue('#Test_IntegerSortedArray_AppendNewValueInto -> ' +
    'ArrayLists index 0 value is not correct', arr.Value[0]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
  AssertTrue('#Test_IntegerSortedArray_AppendNewValueInto -> ' +
    'ArrayLists index 1 value is not correct', arr.Value[1]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4);
  AssertTrue('#Test_IntegerSortedArray_AppendNewValueInto -> '+
    'ArrayLists index 2 value is not correct', arr.Value[2]
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 8);

  FreeAndNil(arr);
end;

initialization
  RegisterTest(TSortedArrayTestCase{$IFNDEF FPC}.Suite{$ENDIF});
end.
