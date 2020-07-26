unit hashtabletestcase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, hash_table;

type
  TIntIntHashTable = specialize THashTable<Integer, Integer>;

  THashTableTestCase = class(TTestCase)
  published
    procedure TestHashCreate;
    procedure TestHashInsert;
  end;

implementation

procedure THashTableTestCase.TestHashCreate;
var
  hash : TIntIntHashTable;
begin
  hash := TIntIntHashTable.Create(@HashInteger);

  AssertTrue('HashTable must be empty', hash.NumEntries = 0);

  FreeAndNil(hash);
end;

procedure THashTableTestCase.TestHashInsert;
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

initialization
  RegisterTest(THashTableTestCase);

end.

