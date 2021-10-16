unit testcase_hashtable;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.hashtable, utils.functor
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TIntegerHashTableTestCase = class(TTestCase)
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
    procedure ByDefault_ZeroNumEntries_ReturnTrue;
    procedure ByDefault_IsEmpty_ReturnTrue;

    procedure Insert_NewItem_ReturnTrue;

    procedure Insert_Items_CheckValues_ReturnTrue;
    procedure Insert_Items_CheckLength_ReturnTrue;
    procedure Insert_Items_IsEmpty_ReturnFalse;

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
procedure TIntegerHashTableTestCase.AssertTrue(ACondition: Boolean);
begin
  CheckTrue(ACondition);
end;

procedure TIntegerHashTableTestCase.AssertFalse(ACondition: Boolean);
begin
  CheckFalse(ACondition);
end;

procedure TIntegerHashTableTestCase.AssertEquals(Expected, Actual : Integer);
begin
  CheckEquals(Expected, Actual);
end;
{$ENDIF}

procedure TIntegerHashTableTestCase.MakeContainer;
begin
  AContainer := TContainer.Create(@HashInteger);
end;

procedure TIntegerHashTableTestCase.TearDown;
begin
  FreeAndNil(AContainer);
end;

procedure TIntegerHashTableTestCase.ByDefault_ZeroNumEntries_ReturnTrue;
begin
  MakeContainer;

  AssertEquals(AContainer.NumEntries, 0);
end;

procedure TIntegerHashTableTestCase.ByDefault_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerHashTableTestCase.Insert_NewItem_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.Insert(1, 1));
end;

procedure TIntegerHashTableTestCase.Insert_Items_CheckValues_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  AssertEquals(AContainer.Search(1), 1);
end;

procedure TIntegerHashTableTestCase.Insert_Items_CheckLength_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  AssertEquals(AContainer.NumEntries, 1);
end;

procedure TIntegerHashTableTestCase.Insert_Items_IsEmpty_ReturnFalse;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  AssertFalse(AContainer.IsEmpty);
end;

procedure TIntegerHashTableTestCase.Remove_Items_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  AssertTrue(AContainer.Remove(1));
end;

procedure TIntegerHashTableTestCase.Remove_Items_NotExistsValue_ReturnFalse;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  AssertFalse(AContainer.Remove(2));
end;

procedure TIntegerHashTableTestCase.Remove_Items_CheckNumEntries_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);
  AContainer.Insert(2, 2);
  AContainer.Remove(1);

  AssertEquals(AContainer.NumEntries, 1);
end;

procedure TIntegerHashTableTestCase.Remove_Items_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);
  AContainer.Remove(1);

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerHashTableTestCase.Search_Exists_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  AssertEquals(AContainer.Search(1), 1);
end;

procedure TIntegerHashTableTestCase
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

procedure TIntegerHashTableTestCase.SearchDefault_Exists_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  AssertEquals(AContainer.SearchDefault(1, 4), 1);
end;

procedure TIntegerHashTableTestCase
  .SearchDefault_NotExists_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  AssertEquals(AContainer.SearchDefault(2, 4), 4);
end;

procedure TIntegerHashTableTestCase.Iterator_ForIn_CheckValue_ReturnTrue;
var
  ContainsValue: array [0 .. 3] of Boolean;
  Index: Integer;
  Value: TContainer.TKeyValuePair;
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

procedure TIntegerHashTableTestCase
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

procedure TIntegerHashTableTestCase.Iterator_Empty_Iteration_ReturnFalse;
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
    'THashTable',
    TIntegerHashTableTestCase{$IFNDEF FPC}.Suite{$ENDIF}
  );
end.

