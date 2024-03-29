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

unit container.queue;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils{$IFDEF USE_OPTIONAL}, utils.optional{$ENDIF};

type
  {$IFNDEF USE_OPTIONAL}
  { List item value not exists. }
  EValueNotExistsException = class(Exception);
  {$ENDIF}

  { A double ended queue stores a list of values in order. New values can be 
    added and removed from either end of the queue. }
  {$IFDEF FPC}generic{$ENDIF} TQueue<T> = class
  protected
    type
      { A double-ended queue. }
      PQueueEntry = ^TQueueEntry;
      TQueueEntry = record
        Value : T;
        Prev : PQueueEntry;
        Next : PQueueEntry;
      end;
  public
    type
      {$IFDEF USE_OPTIONAL}
      TOptionalValue = {$IFDEF FPC}specialize{$ENDIF} TOptional<T>;
      {$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;

    { Add a value to the head of a queue. }
    function PushHead (AData : T) : Boolean;

    { Remove a value from the head of a queue. }
    function PopHead : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue{$ENDIF};

    { Read value from the head of a queue, without removing it from the queue. }
    function PeekHead : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue{$ENDIF};
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Add a value to the tail of a queue. }
    function PushTail (AData : T) : Boolean;

    { Remove a value from the tail of a queue. }
    function PopTail : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue{$ENDIF};

    { Read a value from the tail of a queue, without removing it from the 
      queue. }
    function PeekTail : {$IFNDEF USE_OPTIONAL}T{$ELSE}TOptionalValue{$ENDIF};
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Retrieve the number of entries in the queue. }
    function NumEntries : Cardinal;
      {$IFNDEF DEBUG}inline;{$ENDIF}

    { Returns true if the queue contains no data. }
    function IsEmpty : Boolean;
      {$IFNDEF DEBUG}inline;{$ENDIF}
  protected
    FHead : PQueueEntry;
    FTail : PQueueEntry;
    FLength : Cardinal;
  end;

implementation

{ TQueue }

constructor TQueue{$IFNDEF FPC}<T>{$ENDIF}.Create;
begin
  FHead := nil;
  FTail := nil;
  FLength := 0;
end;

destructor TQueue{$IFNDEF FPC}<T>{$ENDIF}.Destroy;
begin
  { Empty the queue. }
  while not IsEmpty do
    PopHead;

  inherited Destroy;
end;

function TQueue{$IFNDEF FPC}<T>{$ENDIF}.PushHead (AData : T) : Boolean;
var
  NewEntry : PQueueEntry;
begin
  { Create the new entry and fill in the fields in the structure. }
  New(NewEntry);
  NewEntry^.Value := AData;
  NewEntry^.Prev := nil;
  NewEntry^.Next := FHead;

  { Insert into the queue. }
  if FHead = nil then
  begin
    { If the queue was previously empty, both the head and tail must be pointed 
      at the new entry. }
    FHead := NewEntry;
    FTail := NewEntry;
  end else
  begin
    { First entry in the list must have prev pointed back to this new entry. }
    FHead^.Prev := NewEntry;

    { Only the head must be pointed at the new entry. }
    FHead := NewEntry;
  end;

  Inc(FLength);
  Result := True;
end;

function TQueue{$IFNDEF FPC}<T>{$ENDIF}.PopHead : {$IFNDEF USE_OPTIONAL}T{$ELSE}
  TOptionalValue{$ENDIF};
var
  Entry : PQueueEntry;
begin
  { Check the queue is not empty. }
  if IsEmpty then
  begin
    {$IFNDEF USE_OPTIONAL}
    raise EValueNotExistsException.Create('Queue is empty.');
    {$ELSE}
    Exit(TOptionalValue.Create);
    {$ENDIF}
  end;

  { Unlink the first entry from the head of the queue. }
  Entry := FHead;
  FHead := Entry^.Next;
  Result := {$IFNDEF USE_OPTIONAL}Entry^.Value{$ELSE}
    TOptionalValue.Create(Entry^.Value){$ENDIF};
  
  if FHead = nil then
  begin
    { If doing this has unlinked the last entry in the queue, set tail to NULL 
      as well. }
    FTail := nil;
  end else
  begin
    { The new first in the queue has no previous entry. }
    FHead^.Prev := nil;
  end;

  Dec(FLength);

  { Free back the queue entry structure. }
  Dispose(Entry);
end;

function TQueue{$IFNDEF FPC}<T>{$ENDIF}.PeekHead : {$IFNDEF USE_OPTIONAL}T
  {$ELSE}TOptionalValue{$ENDIF};
begin
  if IsEmpty then
  begin
    {$IFNDEF USE_OPTIONAL}
    raise EValueNotExistsException.Create('Queue is empty.');
    {$ELSE}
    Exit(TOptionalValue.Create);
    {$ENDIF}
  end;

  Result := {$IFNDEF USE_OPTIONAL}FHead^.Value{$ELSE}
    TOptionalValue.Create(FHead^.Value){$ENDIF};
end;

function TQueue{$IFNDEF FPC}<T>{$ENDIF}.PushTail (AData : T) : Boolean;
var
  NewEntry : PQueueEntry;
begin
  { Create the new entry and fill in the fields in the structure. }
  New(NewEntry);
  NewEntry^.Value := AData;
  NewEntry^.Prev := FTail;
  NewEntry^.Next := nil;

  { Insert into the queue. }
  if FTail = nil then
  begin
    { If the queue was previously empty, both the head and tail must be pointed 
      at the new entry. }
    FHead := NewEntry;
    FTail := NewEntry;
  end else
  begin
    { First entry in the list must have prev pointed back to this new entry. }
    FTail^.Next := NewEntry;

    { Only the head must be pointed at the new entry. }
    FTail := NewEntry;
  end;

  Inc(FLength);
  Result := True;
end;

function TQueue{$IFNDEF FPC}<T>{$ENDIF}.PopTail : {$IFNDEF USE_OPTIONAL}T{$ELSE}
  TOptionalValue{$ENDIF};
var
  Entry : PQueueEntry;
begin
  { Check the queue is not empty. }
  if IsEmpty then
  begin
    {$IFNDEF USE_OPTIONAL}
    raise EValueNotExistsException.Create('Queue is empty.');
    {$ELSE}
    Exit(TOptionalValue.Create);
    {$ENDIF}
  end;

  { Unlink the first entry from the head of the queue. }
  Entry := FTail;
  FTail := Entry^.Prev;
  Result := {$IFNDEF USE_OPTIONAL}Entry^.Value{$ELSE}
    TOptionalValue.Create(Entry^.Value){$ENDIF};
  
  if FTail = nil then
  begin
    { If doing this has unlinked the last entry in the queue, set tail to NULL 
      as well. }
    FHead := nil;
  end else
  begin
    { The new first in the queue has no previous entry. }
    FTail^.Next := nil;
  end;

  Dec(FLength);

  { Free back the queue entry structure. }
  Dispose(Entry);
end;

function TQueue{$IFNDEF FPC}<T>{$ENDIF}.PeekTail : {$IFNDEF USE_OPTIONAL}T
  {$ELSE}TOptionalValue{$ENDIF};
begin
  if IsEmpty then
  begin
    {$IFNDEF USE_OPTIONAL}
    raise EValueNotExistsException.Create('Queue is empty.');
    {$ELSE}
    Exit(TOptionalValue.Create);
    {$ENDIF}
  end;

  Result := {$IFNDEF USE_OPTIONAL}FTail^.Value{$ELSE}
    TOptionalValue.Create(FTail^.Value){$ENDIF};
end;

function TQueue{$IFNDEF FPC}<T>{$ENDIF}.NumEntries : Cardinal;
begin
  Result := FLength;
end;

function TQueue{$IFNDEF FPC}<T>{$ENDIF}.IsEmpty : Boolean;
begin
  Result := FHead = nil;
end;

end.
