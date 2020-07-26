unit hashtabletestcase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, hash_table;

type
  TIntIntHashTable = specialize THashTable<Integer, Integer>;

  THashTableTestCase = class(TTestCase)
  published

  end;

implementation


initialization
  RegisterTest(THashTableTestCase);

end.

