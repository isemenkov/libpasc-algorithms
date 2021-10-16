unit testcase_avltree;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.avltree, utils.functor
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TIntegerAvlTreeTestCase = class(TTestCase)
  public
    type
      TContainer = {$IFDEF FPC}specialize{$ENDIF} TAvlTree<Integer, Integer, 
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
    procedure ByDefault_NumEntries_ReturnZero;
    procedure ByDefault_IsEmpty_ReturnTrue;

    procedure Insert_Items_CheckValues_ReturnTrue;

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
procedure TIntegerAvlTreeTestCase.AssertTrue(ACondition: Boolean);
begin
  CheckTrue(ACondition);
end;

procedure TIntegerAvlTreeTestCase.AssertFalse(ACondition: Boolean);
begin
  CheckFalse(ACondition);
end;

procedure TIntegerAvlTreeTestCase.AssertEquals(Expected, Actual : Integer);
begin
  CheckEquals(Expected, Actual);
end;
{$ENDIF}

procedure TIntegerAvlTreeTestCase.MakeContainer;
begin
  AContainer := TContainer.Create;
end;

procedure TIntegerAvlTreeTestCase.TearDown;
begin
  FreeAndNil(AContainer);
end;

procedure TIntegerAvlTreeTestCase.ByDefault_NumEntries_ReturnZero;
begin
  MakeContainer;

  AssertEquals(AContainer.NumEntries, 0);
end;

procedure TIntegerAvlTreeTestCase.ByDefault_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerAvlTreeTestCase.Insert_Items_CheckValues_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  AssertEquals(AContainer.Search(1), 1);
end;

procedure TIntegerAvlTreeTestCase.Remove_Items_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);
  
  AssertTrue(AContainer.Remove(1));
end;

procedure TIntegerAvlTreeTestCase.Remove_Items_CheckNumEntries_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);
  AContainer.Insert(2, 4);

  AContainer.Remove(2);

  AssertEquals(AContainer.NumEntries, 1);
end;

procedure TIntegerAvlTreeTestCase.Remove_Items_IsEmpty_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);
  AContainer.Remove(1);

  AssertTrue(AContainer.IsEmpty);
end;

procedure TIntegerAvlTreeTestCase.Remove_Items_NotExistsValue_ReturnFalse;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  AssertFalse(AContainer.Remove(2));
end;

procedure TIntegerAvlTreeTestCase.Search_Exists_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  AssertEquals(AContainer.Search(1), 1);
end;

procedure TIntegerAvlTreeTestCase
  .Search_NotExists_CheckValue_RaiseEKeyNotExistsException_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  try 
    AContainer.Search(2);
  except on e: EKeyNotExistsException do
    begin
      AssertTrue(True);
      Exit;
    end;
  end;

  AssertTrue(False);
end;

procedure TIntegerAvlTreeTestCase.SearchDefault_Exists_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  AssertEquals(AContainer.SearchDefault(1, 4), 1);
end;

procedure TIntegerAvlTreeTestCase.SearchDefault_NotExists_CheckValue_ReturnTrue;
begin
  MakeContainer;

  AContainer.Insert(1, 1);

  AssertEquals(AContainer.SearchDefault(2, 4), 4);
end;

procedure TIntegerAvlTreeTestCase.Iterator_ForIn_CheckValue_ReturnTrue;
var
  ContainsValue: array [0 .. 3] of Boolean;
  Index: Integer;
  Value: TContainer.TAvlKeyValuePair;
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

procedure TIntegerAvlTreeTestCase
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

procedure TIntegerAvlTreeTestCase.Iterator_Empty_Iteration_ReturnFalse;
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
    'TAvlTree',
    TIntegerAvlTreeTestCase{$IFNDEF FPC}.Suite{$ENDIF}
  );
end.

