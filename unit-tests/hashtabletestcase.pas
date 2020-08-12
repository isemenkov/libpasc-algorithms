unit hashtabletestcase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, container.hashtable, utils.functor;

type
  TIntIntHashTable = specialize THashTable<Integer, Integer,
    TCompareFunctorInteger>;
  TStringIntHashTable = specialize THashTable<String, Integer,
    TCompareFunctorString>;

  THashTableTestCase = class(TTestCase)
  published
    procedure TestHashIntIntCreate;
    procedure TestHashStringIntCreate;
    procedure TestHashIntIntInsert;
    procedure TestHashStringIntInsert;
    procedure TestHashIntIntRemove;
    procedure TestHashStringIntRemove;
    procedure TestHashIntIntStoreOneMillionItems;
  end;

implementation

procedure THashTableTestCase.TestHashIntIntCreate;
var
  hash : TIntIntHashTable;
begin
  hash := TIntIntHashTable.Create(@HashInteger);

  AssertTrue('HashTable must be empty', hash.NumEntries = 0);

  FreeAndNil(hash);
end;

procedure THashTableTestCase.TestHashStringIntCreate;
var
  hash : TStringIntHashTable;
begin
  hash := TStringIntHashTable.Create(@HashString);

  AssertTrue('HashTable must be empty', hash.NumEntries = 0);

  FreeAndNil(hash);
end;

procedure THashTableTestCase.TestHashIntIntInsert;
var
  hash : TIntIntHashTable;
begin
  hash := TIntIntHashTable.Create(@HashInteger);

  AssertTrue('HashTable value 1 not insert', hash.Insert(1, 100));
  AssertTrue('HashTable value 5 not insert', hash.Insert(5, 100));
  AssertTrue('HashTable value 121 not insert', hash.Insert(121, 12100));

  AssertTrue('Hash table value 1 is not correct', hash.Search(1) = 100);
  AssertTrue('Hash table value 5 is not correct', hash.Search(5) = 100);
  AssertTrue('Hash table value 121 is not correct', hash.Search(121) = 12100);

  FreeAndNil(hash);
end;

procedure THashTableTestCase.TestHashStringIntInsert;
var
  hash : TStringIntHashTable;
begin
  hash := TStringIntHashTable.Create(@HashString);

  AssertTrue('HashTable value test1 not insert', hash.Insert('test1', 100));
  AssertTrue('HashTable value test5 not insert', hash.Insert('test5', 100));
  AssertTrue('HashTable value test121 not insert', hash.Insert('test121',
    12100));

  AssertTrue('Hash table value test1 is not correct', hash.Search('test1') =
    100);
  AssertTrue('Hash table value test5 is not correct', hash.Search('test5') =
    100);
  AssertTrue('Hash table value test121 is not correct', hash.Search('test121') =
    12100);

  FreeAndNil(hash);
end;

procedure THashTableTestCase.TestHashIntIntRemove;
var
  hash : TIntIntHashTable;
begin
  hash := TIntIntHashTable.Create(@HashInteger);

  AssertTrue('HashTable value 1 not insert', hash.Insert(1, 100));
  AssertTrue('HashTable value 5 not insert', hash.Insert(5, 100));
  AssertTrue('HashTable value 121 not insert', hash.Insert(121, 12100));

  AssertTrue('Hash table value 1 is not correct', hash.Search(1) = 100);
  AssertTrue('Hash table value 5 is not correct', hash.Search(5) = 100);
  AssertTrue('Hash table value 121 is not correct', hash.Search(121) = 12100);

  AssertTrue('Hash table value 1 is not removed', hash.Remove(1));
  AssertTrue('Hash table value 5 is not removed', hash.Remove(5));
  AssertTrue('Hash table value 121 is not removed', hash.Remove(121));

  AssertTrue('HashTable must be empty', hash.NumEntries = 0);

  FreeAndNil(hash);
end;

procedure THashTableTestCase.TestHashStringIntRemove;
var
  hash : TStringIntHashTable;
begin
  hash := TStringIntHashTable.Create(@HashString);

  AssertTrue('HashTable value test1 not insert', hash.Insert('test1', 100));
  AssertTrue('HashTable value test5 not insert', hash.Insert('test5', 100));
  AssertTrue('HashTable value test121 not insert', hash.Insert('test121',
    12100));

  AssertTrue('Hash table value test1 is not correct', hash.Search('test1') =
    100);
  AssertTrue('Hash table value test5 is not correct', hash.Search('test5') =
    100);
  AssertTrue('Hash table value test121 is not correct', hash.Search('test121') =
    12100);

  AssertTrue('Hash table value test1 is not removed', hash.Remove('test1'));
  AssertTrue('Hash table value test5 is not removed', hash.Remove('test5'));
  AssertTrue('Hash table value test121 is not removed', hash.Remove('test121'));

  AssertTrue('HashTable must be empty', hash.NumEntries = 0);

  FreeAndNil(hash);
end;

procedure THashTableTestCase.TestHashIntIntStoreOneMillionItems;
var
  hash : TIntIntHashTable;
  index : Integer;
begin
  hash := TIntIntHashTable.Create(@HashInteger);

  for index := 0 to 1000000 do
  begin
    AssertTrue('1: HashTable index ' + IntToStr(index) + ' value not insert',
      hash.Insert(index, index * 10 + 4));
  end;

  for index := 0 to 1000000 do
  begin
    AssertTrue('2: Hash table value index ' + IntToStr(index) +
     ' is not correct', hash.Search(index) = index * 10 + 4);
  end;

  FreeAndNil(hash);
end;

initialization
  RegisterTest(THashTableTestCase);

end.

