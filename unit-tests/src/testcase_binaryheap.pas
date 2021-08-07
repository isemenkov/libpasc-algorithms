unit testcase_binaryheap;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.binaryheap, utils.functor
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TIntegerMinBinaryHeap = {$IFDEF FPC}specialize{$ENDIF} TMinBinaryHeap<Integer,
    TCompareFunctorInteger>;
  TStringMinBinaryHeap = {$IFDEF FPC}specialize{$ENDIF} TMinBinaryHeap<String,
    TCompareFunctorString>;

  TIntegerMaxBinaryHeap = {$IFDEF FPC}specialize{$ENDIF} TMaxBinaryHeap<Integer,
    TCompareFunctorInteger>;
  TStringMaxBinaryHeap = {$IFDEF FPC}specialize{$ENDIF} TMaxBinaryHeap<String,
    TCompareFunctorString>;

  TBinaryHeapTestCase = class(TTestCase)
  public
    {$IFNDEF FPC}
    procedure AssertTrue (AMessage : String; ACondition : Boolean);
    {$ENDIF}
  published
    procedure Test_IntegerMinBinaryHeap_CreateNewEmpty;
    procedure Test_IntegerMinBinaryHeap_AppendNewValueInto;
    procedure Test_IntegerMinBinaryHeap_AppendNewValueAndReallocMemory;

    procedure Test_IntegerMaxBinaryHeap_CreateNewEmpty;
    procedure Test_IntegerMaxBinaryHeap_AppendNewValueInto;
    procedure Test_IntegerMaxBinaryHeap_AppendNewValueAndReallocMemory;

    procedure Test_StringMinBinaryHeap_CreateNewEmpty;
    procedure Test_StringMinBinaryHeap_AppendNewValueInto;
    procedure Test_StringMinBinaryHeap_AppendNewValueAndReallocMemory;

    procedure Test_StringMaxBinaryHeap_CreateNewEmpty;
    procedure Test_StringMaxBinaryHeap_AppendNewValueInto;
    procedure Test_StringMaxBinaryHeap_AppendNewValueAndReallocMemory;
  end;

implementation

{$IFNDEF FPC}
procedure TBinaryHeapTestCase.AssertTrue(AMessage : String; ACondition :
  Boolean);
begin
  CheckTrue(ACondition, AMessage);
end;
{$ENDIF}

procedure TBinaryHeapTestCase.Test_IntegerMinBinaryHeap_CreateNewEmpty;
var
  heap : TIntegerMinBinaryHeap;
begin
  heap := TIntegerMinBinaryHeap.Create;

  AssertTrue('#Test_IntegerMinBinaryHeap_CreateNewEmpty -> ' +
   'BinaryHeap must be empty', heap.NumEntries = 0);

  FreeAndNil(heap);
end;

procedure TBinaryHeapTestCase.Test_StringMinBinaryHeap_CreateNewEmpty;
var
  heap : TStringMinBinaryHeap;
begin
  heap := TStringMinBinaryHeap.Create;

  AssertTrue('#Test_StringMinBinaryHeap_CreateNewEmpty -> ' +
   'BinaryHeap must be empty', heap.NumEntries = 0);

  FreeAndNil(heap);
end;

procedure TBinaryHeapTestCase.Test_IntegerMaxBinaryHeap_CreateNewEmpty;
var
  heap : TIntegerMaxBinaryHeap;
begin
  heap := TIntegerMaxBinaryHeap.Create;

  AssertTrue('#Test_IntegerMaxBinaryHeap_CreateNewEmpty -> ' +
   'BinaryHeap must be empty', heap.NumEntries = 0);

  FreeAndNil(heap);
end;

procedure TBinaryHeapTestCase.Test_StringMaxBinaryHeap_CreateNewEmpty;
var
  heap : TStringMaxBinaryHeap;
begin
  heap := TStringMaxBinaryHeap.Create;

  AssertTrue('#Test_StringMaxBinaryHeap_CreateNewEmpty -> ' +
   'BinaryHeap must be empty', heap.NumEntries = 0);

  FreeAndNil(heap);
end;

procedure TBinaryHeapTestCase.Test_IntegerMinBinaryHeap_AppendNewValueInto;
var
  heap : TIntegerMinBinaryHeap;
begin
  heap := TIntegerMinBinaryHeap.Create;

  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap value 1 not append', heap.Append(4));
  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap value 4 not append', heap.Append(3));
  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap value 5 not append', heap.Append(8));

  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap length is not correct', heap.NumEntries = 3);

  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap index 0 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);
  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap index 1 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4);
  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueInto -> '+
    'MinBinaryHeap index 2 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 8);

  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap must be empty', heap.NumEntries = 0);

  FreeAndNil(heap);
end;

procedure TBinaryHeapTestCase.Test_StringMinBinaryHeap_AppendNewValueInto;
var
  heap : TStringMinBinaryHeap;
begin
  heap := TStringMinBinaryHeap.Create;

  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap value 1 not append', heap.Append('apple'));
  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap value 4 not append', heap.Append('orange'));
  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap value 5 not append', heap.Append('banana'));

  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap length is not correct', heap.NumEntries = 3);

  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap index 0 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'apple');
  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap index 1 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'banana');
  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueInto -> '+
    'MinBinaryHeap index 2 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'orange');

  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap must be empty', heap.NumEntries = 0);

  FreeAndNil(heap);
end;

procedure TBinaryHeapTestCase.Test_IntegerMaxBinaryHeap_AppendNewValueInto;
var
  heap : TIntegerMaxBinaryHeap;
begin
  heap := TIntegerMaxBinaryHeap.Create;

  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap value 1 not append', heap.Append(4));
  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap value 4 not append', heap.Append(3));
  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap value 5 not append', heap.Append(8));

  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap length is not correct', heap.NumEntries = 3);

  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap index 0 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 8);
  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap index 1 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 4);
  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueInto -> '+
    'MinBinaryHeap index 2 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 3);

  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap must be empty', heap.NumEntries = 0);

  FreeAndNil(heap);
end;

procedure TBinaryHeapTestCase.Test_StringMaxBinaryHeap_AppendNewValueInto;
var
  heap : TStringMaxBinaryHeap;
begin
  heap := TStringMaxBinaryHeap.Create;

  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap value 1 not append', heap.Append('apple'));
  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap value 4 not append', heap.Append('orange'));
  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap value 5 not append', heap.Append('banana'));

  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap length is not correct', heap.NumEntries = 3);

  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap index 0 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'orange');
  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap index 1 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'banana');
  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueInto -> '+
    'MinBinaryHeap index 2 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'apple');

  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueInto -> ' +
    'MinBinaryHeap must be empty', heap.NumEntries = 0);

  FreeAndNil(heap);
end;

procedure TBinaryHeapTestCase
  .Test_IntegerMinBinaryHeap_AppendNewValueAndReallocMemory;
var
  heap : TIntegerMinBinaryHeap;
begin
  heap := TIntegerMinBinaryHeap.Create(3);
  
  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value 12 not append', heap.Append(12));
  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value 432 not append', heap.Append(432));
  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value -34 not append', heap.Append(-34));
  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value 40 not append', heap.Append(40));
  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value 492 not append', heap.Append(492));
  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value 301 not append', heap.Append(301));
  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value -31 not append', heap.Append(-31));

  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap length is not correct', heap.NumEntries = 7);

  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 0 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -34);
  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 1 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -31);
  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 2 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12);
  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 3 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 40);
  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 4 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 301);
  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 5 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 432);
  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 6 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 492);
  
  AssertTrue('#Test_IntegerMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap must be empty', heap.NumEntries = 0);

  FreeAndNil(heap);
end;

procedure TBinaryHeapTestCase
  .Test_StringMinBinaryHeap_AppendNewValueAndReallocMemory;
var
  heap : TStringMinBinaryHeap;
begin
  heap := TStringMinBinaryHeap.Create(3);
  
  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value 12 not append', heap.Append('apple'));
  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value 432 not append', heap.Append('banana'));
  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value -34 not append', heap.Append('orange'));
  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value 40 not append', heap.Append('potato'));
  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value 492 not append', heap.Append('mango'));
  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value 301 not append', heap.Append('cherry'));
  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value -31 not append', heap.Append('tomato'));

  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap length is not correct', heap.NumEntries = 7);

  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 0 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'apple');
  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 1 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'banana');
  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 2 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'cherry');
  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 3 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'mango');
  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 4 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'orange');
  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 5 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'potato');
  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 6 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'tomato');
  
  AssertTrue('#Test_StringMinBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap must be empty', heap.NumEntries = 0);

  FreeAndNil(heap);
end;

procedure TBinaryHeapTestCase
  .Test_IntegerMaxBinaryHeap_AppendNewValueAndReallocMemory;
var
  heap : TIntegerMaxBinaryHeap;
begin
  heap := TIntegerMaxBinaryHeap.Create(3);
  
  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value 12 not append', heap.Append(12));
  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value 432 not append', heap.Append(432));
  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value -34 not append', heap.Append(-34));
  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value 40 not append', heap.Append(40));
  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value 492 not append', heap.Append(492));
  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value 301 not append', heap.Append(301));
  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value -31 not append', heap.Append(-31));

  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap length is not correct', heap.NumEntries = 7);

  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 0 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 492);
  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 1 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 432);
  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 2 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 301);
  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 3 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 40);
  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 4 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 12);
  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 5 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -31);
  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 6 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = -34);
  
  AssertTrue('#Test_IntegerMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap must be empty', heap.NumEntries = 0);

  FreeAndNil(heap);
end;

procedure TBinaryHeapTestCase
  .Test_StringMaxBinaryHeap_AppendNewValueAndReallocMemory;
var
  heap : TStringMaxBinaryHeap;
begin
  heap := TStringMaxBinaryHeap.Create(3);
  
  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value apple not append', heap.Append('apple'));
  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value banana not append', heap.Append('banana'));
  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value orange not append', heap.Append('orange'));
  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value potato not append', heap.Append('potato'));
  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value mango not append', heap.Append('mango'));
  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value cherry not append', heap.Append('cherry'));
  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap value tomato not append', heap.Append('tomato'));

  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap length is not correct', heap.NumEntries = 7);

  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 0 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'tomato');
  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 1 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'potato');
  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 2 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'orange');
  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 3 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'mango');
  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 4 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'cherry');
  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 5 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'banana');
  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap index 6 value is not correct', heap.Pop
    {$IFDEF USE_OPTIONAL}.Unwrap{$ENDIF} = 'apple');
  
  AssertTrue('#Test_StringMaxBinaryHeap_AppendNewValueAndReallocMemory -> ' +
    'MinBinaryHeap must be empty', heap.NumEntries = 0);

  FreeAndNil(heap);
end;

initialization
  RegisterTest(TBinaryHeapTestCase{$IFNDEF FPC}.Suite{$ENDIF});
end.
