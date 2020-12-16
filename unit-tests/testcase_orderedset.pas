unit testcase_orderedset;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.orderedset, utils.functor
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TIntOrderedSet = {$IFDEF FPC}specialize{$ENDIF} TOrderedSet<Integer, 
    TCompareFunctorInteger>;
  TStringOrderedSet = {$IFDEF FPC}specialize{$ENDIF} TOrderedSet<String, 
    TCompareFunctorString>;

  TOrderedSetTestCase = class(TTestCase)
  public
    {$IFNDEF FPC}
    procedure AssertTrue (AMessage : String; ACondition : Boolean);
    {$ENDIF}
  published
    procedure Test_IntOrderedSet_CreateNewEmpty;
    procedure Test_IntOrderedSet_InsertNewValueInto;
    procedure Test_IntOrderedSet_RemoveValueFrom;
    procedure Test_IntOrderedSet_IterateValues;
    procedure Test_IntOrderedSet_IterateRange;
    procedure Test_IntOrderedSet_InsertOneMillionValuesInto;

    procedure Test_StringOrderedSet_CreateNewEmpty;
    procedure Test_StringOrderedSet_InsertNewValueInto;
    procedure Test_StringOrderedSet_RemoveValueFrom;
    procedure Test_StringOrderedSet_IterateValues;
    procedure Test_StringOrderedSet_IterateRange;
    procedure Test_StringOrderedSet_InsertOneMillionValuesInto;
  end;

implementation

{$IFNDEF FPC}
procedure TOrderedSetTestCase.AssertTrue(AMessage : String; ACondition :
  Boolean);
begin
  CheckTrue(ACondition, AMessage);
end;
{$ENDIF}

procedure TOrderedSetTestCase.Test_IntOrderedSet_CreateNewEmpty;
var
  orderedset : TIntOrderedSet;
begin
  orderedset := TIntOrderedSet.Create(@HashInteger);

  AssertTrue('#Test_IntOrderedSet_CreateNewEmpty -> ' +
    'OrderedSet must be empty', orderedset.NumEntries = 0);

  FreeAndNil(orderedset);
end;

procedure TOrderedSetTestCase.Test_StringOrderedSet_CreateNewEmpty;
var
  orderedset : TStringOrderedSet;
begin
  orderedset := TStringOrderedSet.Create(@HashString);

  AssertTrue('#Test_StringOrderedSet_CreateNewEmpty -> ' +
    'OrderedSet must be empty', orderedset.NumEntries = 0);

  FreeAndNil(orderedset);
end;

procedure TOrderedSetTestCase.Test_IntOrderedSet_InsertNewValueInto;
var
  orderedset : TIntOrderedSet;
begin
  orderedset := TIntOrderedSet.Create(@HashInteger);

  AssertTrue('#Test_IntOrderedSet_InsertNewValueInto -> ' +
    'OrderedSet value 1 not insert', orderedset.Insert(1));
  AssertTrue('#Test_IntOrderedSet_InsertNewValueInto -> ' +
    'OrderedSet value 5 not insert', orderedset.Insert(5));
  AssertTrue('#Test_IntOrderedSet_InsertNewValueInto -> ' +
    'OrderedSet value 121 not insert', orderedset.Insert(121));

  AssertTrue('#Test_IntOrderedSet_InsertNewValueInto -> ' +
    'OrderedSet hasn''t value 1', orderedset.HasValue(1));
  AssertTrue('#Test_IntOrderedSet_InsertNewValueInto -> ' +
    'OrderedSet hasn''t value 5', orderedset.HasValue(5));
  AssertTrue('#Test_IntOrderedSet_InsertNewValueInto -> ' +
    'OrderedSet hasn''t value 121', orderedset.HasValue(121));

  FreeAndNil(orderedset);
end;

procedure TOrderedSetTestCase.Test_StringOrderedSet_InsertNewValueInto;
var
  orderedset : TStringOrderedSet;
begin
  orderedset := TStringOrderedSet.Create(@HashString);

  AssertTrue('#Test_StringOrderedSet_InsertNewValueInto -> ' +
    'OrderedSet value test1 not insert', orderedset.Insert('test1'));
  AssertTrue('#Test_StringOrderedSet_InsertNewValueInto -> ' +
    'OrderedSet value test5 not insert', orderedset.Insert('test5'));
  AssertTrue('#Test_StringOrderedSet_InsertNewValueInto -> ' +
    'OrderedSet value test121 not insert', orderedset.Insert('test121'));

  AssertTrue('#Test_StringOrderedSet_InsertNewValueInto -> ' +
    'OrderedSet hasn''t value test1', orderedset.HasValue('test1'));
  AssertTrue('#Test_StringOrderedSet_InsertNewValueInto -> ' +
    'OrderedSet hasn''t value test5', orderedset.HasValue('test5'));
  AssertTrue('#Test_StringOrderedSet_InsertNewValueInto -> ' +
    'OrderedSet hasn''t value test121', orderedset.HasValue('test121'));

  FreeAndNil(orderedset);
end;

procedure TOrderedSetTestCase.Test_IntOrderedSet_RemoveValueFrom;
var
  orderedset : TIntOrderedSet;
begin
  orderedset := TIntOrderedSet.Create(@HashInteger);

  AssertTrue('#Test_IntOrderedSet_RemoveValueFrom -> ' +
    'OrderedSet value 1 not insert', orderedset.Insert(1));
  AssertTrue('#Test_IntOrderedSet_RemoveValueFrom -> ' +
    'OrderedSet value 5 not insert', orderedset.Insert(5));
  AssertTrue('#Test_IntOrderedSet_RemoveValueFrom -> ' +
    'OrderedSet value 121 not insert', orderedset.Insert(121));

  AssertTrue('#Test_IntOrderedSet_RemoveValueFrom -> ' +
    'OrderedSet hasn''t value 1', orderedset.HasValue(1));
  AssertTrue('#Test_IntOrderedSet_RemoveValueFrom -> ' +
    'OrderedSet hasn''t value 5', orderedset.HasValue(5));
  AssertTrue('#Test_IntOrderedSet_RemoveValueFrom -> ' +
    'OrderedSet hasn''t value 121', orderedset.HasValue(121));

  AssertTrue('#Test_IntOrderedSet_RemoveValueFrom -> ' +
    'OrderedSet value 1 not removed', orderedset.Remove(1));
  AssertTrue('#Test_IntOrderedSet_RemoveValueFrom -> ' +
    'OrderedSet value 5 not removed', orderedset.Remove(5));
  AssertTrue('#Test_IntOrderedSet_RemoveValueFrom -> ' +
    'OrderedSet value 121 not removed', orderedset.Remove(121));

  AssertTrue('#Test_IntOrderedSet_RemoveValueFrom -> ' +
    'OrderedSet must be empty', orderedset.NumEntries = 0);

  FreeAndNil(orderedset);
end;

procedure TOrderedSetTestCase.Test_StringOrderedSet_RemoveValueFrom;
var
  orderedset : TStringOrderedSet;
begin
  orderedset := TStringOrderedSet.Create(@HashString);

  AssertTrue('#Test_StringOrderedSet_RemoveValueFrom -> ' +
    'OrderedSet value test1 not insert', orderedset.Insert('test1'));
  AssertTrue('#Test_StringOrderedSet_RemoveValueFrom -> ' +
    'OrderedSet value test5 not insert', orderedset.Insert('test5'));
  AssertTrue('#Test_StringOrderedSet_RemoveValueFrom -> ' +
    'OrderedSet value test121 not insert', orderedset.Insert('test121'));

  AssertTrue('#Test_StringOrderedSet_RemoveValueFrom -> ' +
    'OrderedSet hasn''t value test1', orderedset.HasValue('test1'));
  AssertTrue('#Test_StringOrderedSet_RemoveValueFrom -> ' +
    'OrderedSet hasn''t value test5', orderedset.HasValue('test5'));
  AssertTrue('#Test_StringOrderedSet_RemoveValueFrom -> ' +
    'OrderedSet hasn''t value test121', orderedset.HasValue('test121'));

  AssertTrue('#Test_StringOrderedSet_RemoveValueFrom -> ' +
    'OrderedSet value test1 not removed', orderedset.Remove('test1'));
  AssertTrue('#Test_StringOrderedSet_RemoveValueFrom -> ' +
    'OrderedSet value test5 not removed', orderedset.Remove('test5'));
  AssertTrue('#Test_StringOrderedSet_RemoveValueFrom -> ' +
    'OrderedSet value test121 not removed', orderedset.Remove('test121'));

  AssertTrue('#Test_StringOrderedSet_RemoveValueFrom -> ' +
    'OrderedSet must be empty', orderedset.NumEntries = 0);

  FreeAndNil(orderedset);
end;

procedure TOrderedSetTestCase.Test_IntOrderedSet_IterateValues;
var
  orderedset : TIntOrderedSet;
  iterator : TIntOrderedSet.TIterator;
begin
  orderedset := TIntOrderedSet.Create(@HashInteger);

  AssertTrue('#Test_IntOrderedSet_IterateValues -> ' +
    'OrderedSet value 1 not insert', orderedset.Insert(1));
  AssertTrue('#Test_IntOrderedSet_IterateValues -> ' +
    'OrderedSet value 5 not insert', orderedset.Insert(5));
  AssertTrue('#Test_IntOrderedSet_IterateValues -> ' +
    'OrderedSet value 121 not insert', orderedset.Insert(121));

  iterator := orderedset.FirstEntry;
  AssertTrue('#Test_IntOrderedSet_IterateValues -> ' +
    'OrderedSet iterator hasn''t value', iterator.HasValue);
  AssertTrue('#Test_IntOrderedSet_IterateValues -> ' +
    'OrderedSet hasn''t value ' + IntToStr(iterator.Value),
    orderedset.HasValue(iterator.Value));

  iterator := iterator.Next;
  AssertTrue('#Test_IntOrderedSet_IterateValues -> ' +
    'OrderedSet iterator hasn''t value', iterator.HasValue);
  AssertTrue('#Test_IntOrderedSet_IterateValues -> ' +
    'OrderedSet hasn''t value ' + IntToStr(iterator.Value),
    orderedset.HasValue(iterator.Value));

  iterator := iterator.Next;
  AssertTrue('#Test_IntOrderedSet_IterateValues -> ' +
    'OrderedSet iterator hasn''t value', iterator.HasValue);
  AssertTrue('#Test_IntOrderedSet_IterateValues -> ' +
    'OrderedSet hasn''t value ' + IntToStr(iterator.Value),
    orderedset.HasValue(iterator.Value));

  iterator := iterator.Next;
  AssertTrue('#Test_IntOrderedSet_IterateValues -> ' +
    'OrderedSet iterator not correct', not iterator.HasValue);

  FreeAndNil(orderedset);
end;

procedure TOrderedSetTestCase.Test_StringOrderedSet_IterateValues;
var
  orderedset : TStringOrderedSet;
  iterator : TStringOrderedSet.TIterator;
begin
  orderedset := TStringOrderedSet.Create(@HashString);

  AssertTrue('#Test_StringOrderedSet_IterateValues -> ' +
    'OrderedSet value test1 not insert', orderedset.Insert('test1'));
  AssertTrue('#Test_StringOrderedSet_IterateValues -> ' +
    'OrderedSet value test5 not insert', orderedset.Insert('test5'));
  AssertTrue('#Test_StringOrderedSet_IterateValues -> ' +
    'OrderedSet value test121 not insert', orderedset.Insert('test121'));

  iterator := orderedset.FirstEntry;
  AssertTrue('#Test_StringOrderedSet_IterateValues -> ' +
    'OrderedSet iterator hasn''t value', iterator.HasValue);
  AssertTrue('#Test_StringOrderedSet_IterateValues -> ' +
    'OrderedSet hasn''t value ' + iterator.Value,
    orderedset.HasValue(iterator.Value));

  iterator := iterator.Next;
  AssertTrue('#Test_StringOrderedSet_IterateValues -> ' +
    'OrderedSet iterator hasn''t value', iterator.HasValue);
  AssertTrue('#Test_StringOrderedSet_IterateValues -> ' +
    'OrderedSet hasn''t value ' + iterator.Value,
    orderedset.HasValue(iterator.Value));

  iterator := iterator.Next;
  AssertTrue('#Test_StringOrderedSet_IterateValues -> ' +
    'OrderedSet iterator hasn''t value', iterator.HasValue);
  AssertTrue('#Test_StringOrderedSet_IterateValues -> ' +
    'OrderedSet hasn''t value ' + iterator.Value,
    orderedset.HasValue(iterator.Value));

  iterator := iterator.Next;
  AssertTrue('#Test_StringOrderedSet_IterateValues -> ' +
    'OrderedSet iterator not correct', not iterator.HasValue);

  FreeAndNil(orderedset);
end;

procedure TOrderedSetTestCase.Test_IntOrderedSet_IterateRange;
var
  orderedset : TIntOrderedSet;
  value : Integer;
  counter : Cardinal;
begin
  orderedset := TIntOrderedSet.Create(@hashInteger);

  AssertTrue('#Test_IntOrderedSet_IterateRange -> ' +
    'OrderedSet value 1 not insert', orderedset.Insert(1));
  AssertTrue('#Test_IntOrderedSet_IterateRange -> ' +
    'OrderedSet value 5 not insert', orderedset.Insert(5));
  AssertTrue('#Test_IntOrderedSet_IterateRange -> ' +
    'OrderedSet value 121 not insert', orderedset.Insert(121));

  counter := 0;
  for value in orderedset do
  begin
    AssertTrue('#Test_IntOrderedSet_IterateRange -> ' +
      'OrderedSet hasn''t value ' + IntToStr(Value),
      orderedset.HasValue(Value));
    Inc(counter);
  end;
  AssertTrue('#Test_IntOrderedSet_IterateRange -> ' +
    'OrderedSet iterate through not all elements', counter = 3);

  FreeAndNil(orderedset);
end;

procedure TOrderedSetTestCase.Test_StringOrderedSet_IterateRange;
var
  orderedset : TStringOrderedSet;
  value : String;
  counter : Cardinal;
begin
  orderedset := TStringOrderedSet.Create(@hashString);

  AssertTrue('#Test_StringOrderedSet_IterateRange -> ' +
    'OrderedSet value test1 not insert', orderedset.Insert('test1'));
  AssertTrue('#Test_StringOrderedSet_IterateRange -> ' +
    'OrderedSet value test5 not insert', orderedset.Insert('test5'));
  AssertTrue('#Test_StringOrderedSet_IterateRange -> ' +
    'OrderedSet value test121 not insert', orderedset.Insert('test121'));

  counter := 0;
  for value in orderedset do
  begin
    AssertTrue('#Test_StringOrderedSet_IterateRange -> ' +
      'OrderedSet hasn''t value ' + Value, orderedset.HasValue(Value));
    Inc(counter);
  end;
  AssertTrue('#Test_StringOrderedSet_IterateRange -> ' +
    'OrderedSet iterate through not all elements', counter = 3);

  FreeAndNil(orderedset);
end;

procedure TOrderedSetTestCase.Test_IntOrderedSet_InsertOneMillionValuesInto;
var
  orderedset : TIntOrderedSet;
  index : Integer;
begin
  orderedset := TIntOrderedSet.Create(@HashInteger);

  for index := 0 to 1000000 do
  begin
    AssertTrue('#Test_IntOrderedSet_InsertOneMillionValuesInto -> ' +
      'OrderedSet value ' + IntToStr(index) + ' not insert',
      orderedset.Insert(index * 10 + 4));
  end;

  for index := 0 to 1000000 do
  begin
    AssertTrue('#Test_IntOrderedSet_InsertOneMillionValuesInto -> ' +
      'OrderedSet hasn''t value '+ IntToStr(index),
      orderedset.HasValue(index * 10 + 4));
  end;

  FreeAndNil(orderedset);
end;

procedure TOrderedSetTestCase.Test_StringOrderedSet_InsertOneMillionValuesInto;
var
  orderedset : TStringOrderedSet;
  index : Integer;
begin
  orderedset := TStringOrderedSet.Create(@HashString);

  for index := 0 to 1000000 do
  begin
    AssertTrue('#Test_StringOrderedSet_InsertOneMillionValuesInto -> ' +
      'OrderedSet value test' + IntToStr(index) + ' not insert',
      orderedset.Insert('test' + IntToStr(index * 10 + 4)));
  end;

  for index := 0 to 1000000 do
  begin
    AssertTrue('#Test_StringOrderedSet_InsertOneMillionValuesInto -> ' +
      'OrderedSet hasn''t value test' + IntToStr(index),
      orderedset.HasValue('test' + IntToStr(index * 10 + 4)));
  end;

  FreeAndNil(orderedset);
end;

initialization
  RegisterTest(TOrderedSetTestCase{$IFNDEF FPC}.Suite{$ENDIF});

end.

