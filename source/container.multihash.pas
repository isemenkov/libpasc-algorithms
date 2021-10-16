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

unit container.multihash;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils, container.hashtable, container.list
  {$IFNDEF FPC}, utils.functor{$ENDIF}
  {$IFDEF USE_OPTIONAL}, utils.optional{$ENDIF};

type
  {$IFDEF FPC}generic{$ENDIF} TMultiHash<K, V; KeyBinaryCompareFunctor
    {$IFNDEF FPC}: constructor, utils.functor.TBinaryFunctor<K,
    Integer> {$ENDIF}; ValueBinaryCompareFunctor{$IFNDEF FPC}: constructor,
    utils.functor.TBinaryFunctor<V, Integer> {$ENDIF}> = class
  public
    type
      TMultiValue = {$IFDEF FPC}specialize{$ENDIF} TList<V, 
        ValueBinaryCompareFunctor>;
      {$IFDEF USE_OPTIONAL}
      TOptionalMultiValue = {$IFDEF FPC}specialize{$ENDIF} 
        TOptional<TMultiValue>;
      {$ENDIF}
  protected
    type
      TContainer = {$IFDEF FPC}specialize{$ENDIF} THashTable<K, TMultiValue,
        KeyBinaryCompareFunctor>;
  public
    type
      { TMultiHash iterator. }
      TIterator = TContainer.TIterator;
      TKeyMultiValuePair = TContainer.TKeyValuePair;
  public
    constructor Create (HashFunc : TContainer.THashTableHashFunc);
    destructor Destroy; override;

    { Insert a value into a multi hash. }
    function Insert (Key : K; Value : V) : Boolean;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Look up a value in a multi hash by key. }
    function Search (Key : K) : {$IFNDEF USE_OPTIONAL}TMultiValue{$ELSE}
      TOptionalMultiValue{$ENDIF};
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Look up a value in a hash table by key. Return default value if Key not 
      exists. }
    function SearchDefault (Key : K; ADefault : V) : TMultiValue;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Remove a value from multi hash. }
    function Remove (Key : K) : Boolean;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Return true if container is empty. }
    function IsEmpty : Boolean;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Retrieve the number of entries in a multi hash. }
    function NumEntries : Cardinal;
      {$IFNDEF DEBUG}inline;{$ENDIF} 

    { Retrive the first entry in multi hash. }    
    function FirstEntry : TIterator; 
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Return enumerator for in operator. }
    function GetEnumerator : TIterator;
      {$IFNDEF DEBUG}inline;{$ENDIF}
  protected
    var
      FContainer : TContainer;
  end;

implementation

{ TMultiHash }

constructor TMultiHash{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor, 
  ValueBinaryCompareFunctor>{$ENDIF}.Create (HashFunc : 
  TContainer.THashTableHashFunc);
begin
  FContainer := TContainer.Create(HashFunc);
end;

destructor TMultiHash{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor,
  ValueBinaryCompareFunctor>{$ENDIF}.Destroy;
begin
  FreeAndNil(FContainer);
end;

function TMultiHash{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor, 
  ValueBinaryCompareFunctor>{$ENDIF}.Insert (Key : K; Value : V) : Boolean;
var
  MultiValue : TMultiValue;
begin
  try
    FContainer.Search(Key).Append(Value);
  except on e : EKeyNotExistsException do
    begin
      MultiValue := TMultiValue.Create;
      MultiValue.Append(Value);
      FContainer.Insert(Key, MultiValue);
    end;
  end;
end;

function TMultiHash{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor, 
  ValueBinaryCompareFunctor>{$ENDIF}.Search (Key : K) : 
  {$IFNDEF USE_OPTIONAL}TMultiValue{$ELSE}TOptionalMultiValue{$ENDIF};
begin
  Result := FContainer.Search(Key);
end;

function TMultiHash{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor, 
  ValueBinaryCompareFunctor>{$ENDIF}.SearchDefault (Key : K; ADefault : V) : 
  TMultiValue;
var
  MultiValue : TMultiValue;
begin
  try
    Result := FContainer.Search(Key);
  except on e: EKeyNotExistsException do
    begin
      MultiValue := TMultiValue.Create;
      MultiValue.Append(ADefault);
      Result := MultiValue;
    end;
  end;
end;

function TMultiHash{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor, 
  ValueBinaryCompareFunctor>{$ENDIF}.Remove (Key : K) : Boolean;
begin
  Result := FContainer.Remove(Key);
end;

function TMultiHash{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor, 
  ValueBinaryCompareFunctor>{$ENDIF}.IsEmpty : Boolean;
begin
  Result := FContainer.IsEmpty;
end;

function TMultiHash{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor, 
  ValueBinaryCompareFunctor>{$ENDIF}.NumEntries : Cardinal;
begin
  Result := FContainer.NumEntries;
end;

function TMultiHash{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor, 
  ValueBinaryCompareFunctor>{$ENDIF}.FirstEntry : TIterator;
begin
  Result := FContainer.FirstEntry;
end;

function TMultiHash{$IFNDEF FPC}<K, V, KeyBinaryCompareFunctor, 
  ValueBinaryCompareFunctor>{$ENDIF}.GetEnumerator : TIterator;
begin
  Result := FContainer.GetEnumerator;
end;

end.
