(******************************************************************************)
(*                             libPasC-Algorithms                             *)
(*       object pascal library of common data structures and algorithms       *)
(*                 https://github.com/fragglet/c-algorithms                   *)
(*                                                                            *)
(* Copyright (c) 2020                                       Ivan Semenkov     *)
(* https://github.com/isemenkov/libpasc-algorithms          ivan@semenkov.pro *)
(*                                                          Ukraine           *)
(******************************************************************************)
(*                                                                            *)
(* This source  is free software;  you can redistribute  it and/or modify  it *)
(* under the terms of the GNU General Public License as published by the Free *)
(* Software Foundation; either version 3 of the License.                      *)
(*                                                                            *)
(* This code is distributed in the  hope that it will  be useful, but WITHOUT *)
(* ANY  WARRANTY;  without even  the implied  warranty of MERCHANTABILITY  or *)
(* FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License for *)
(* more details.                                                              *)
(*                                                                            *)
(* A copy  of the  GNU General Public License is available  on the World Wide *)
(* Web at <http://www.gnu.org/copyleft/gpl.html>. You  can also obtain  it by *)
(* writing to the Free Software Foundation, Inc., 51  Franklin Street - Fifth *)
(* Floor, Boston, MA 02110-1335, USA.                                         *)
(*                                                                            *)
(******************************************************************************)

unit arraylist;

{$mode objfpc}{$H+}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils;

type
  { ArrayList index is not exists. }
  EIndexOutOfRangeException = class(Exception);

  { Automatically resizing array. 
    ArrayLists are arrays of pointers which automatically increase in size. }
  generic TArrayLists<T> = class
  public
    constructor Create (ALength : Cardinal = 0);
    destructor Destroy; override;

    { Append a value to the end of an ArrayList. 
      Return true if the request was successful, false if it was not possible to 
      allocate more memory for the new entry. }
    function Append (AValue : T) : Boolean;

    { Prepend a value to the beginning of an ArrayList. 
      Return true if the request was successful, false if it was not possible to 
      allocate more memory for the new entry. }
    function Prepend (AValue : T) : Boolean;

    { Remove the entry at the specified location in an ArrayList. }
    procedure Remove (AIndex: Cardinal);

    { Remove a range of entries at the specified location in an ArrayList. }
    procedure RemoveRange (AIndex : Cardinal; ALength : Cardinal);

    { Insert a value at the specified index in an ArrayList.
      The index where the new value can be inserted is limited by the size of 
      the ArrayList.
      Returns false if unsuccessful, else true if successful (due to an invalid 
      index or if it was impossible to allocate more memory). }
    function Insert (AIndex : Cardinal; AData : T) : Boolean;

    { Find the index of a particular value in an ArrayList. 
      Return the index of the value if found, or -1 if not found. }
    function IndexOf (AData : T) : Integer;

    { Remove all entries from an ArrayList. }
    procedure Clear;

    { Sort the values in an ArrayList. }
    procedure Sort;
  protected
    { Reallocate the array to the new size }
    function Enlarge : Boolean;

    { Get value by index. }
    function GetValue (AIndex : Cardinal) : T;

    { Set new value by index. }
    procedure SetValue (AIndex : Cardinal; AData : T);
  protected
    var
      FData : array of T;
      FLength : Cardinal;
      FAlloced : Cardinal;
  protected
    { Read/Write value in an ArrayList. If index not exists raise
      EIndexOutOfRangeException. }
    property Value [AIndex : Cardinal] : T read GetValue write SetValue;

    { Get ArrayList length. }
    property Length : Cardinal read FLength;
  end;

implementation

constructor TArrayLists.Create(ALength : Cardinal);
begin
  if ALength = 0 then
  begin
    ALength := 16;
  end;

  SetLength(FData, ALength);
  FAlloced := ALength;
  FLength := 0;
end;

destructor TArrayLists.Destroy;
begin
  SetLength(FData, 0);
  inherited Destroy;
end;

function TArrayLists.GetValue (AIndex : Cardinal) : T;
begin
  if AIndex > FLength then
  begin
    raise EIndexOutOfRangeException.Create('Index out of range.');
  end;

  Result := FData[AIndex];
end;

procedure TArrayLists.SetValue (AIndex : Cardinal; AData : T);
begin
  if AIndex > FLength then
  begin
    raise EIndexOutOfRangeException.Create('Index out of range.');
  end;  

  FData[AIndex] := AData;
end;

function TArrayLists.Enlarge : Boolean;
var
  NewSize : Cardinal;
begin
  { Double the allocated size }
  NewSize := FAlloced * 2;

  { Reallocate the array to the new size }
  SetLength(FData, NewSize);
  FAlloced := NewSize;
  
  Result := True;  
end;

function TArrayLists.Insert (AIndex : Cardinal; AData : T) : Boolean;
begin
  { Sanity check the index }
  if AIndex > FLength then
  begin
    Result := False;
    Exit;
  end;
 
  { Increase the size if necessary }
  if FLength + 1 > FAlloced then
  begin
    if not Enlarge then
    begin
      Result := False;
      Exit;
    end;
  end;

  { Move the contents of the array forward from the index onwards }
  Move(FData[AIndex], FData[AIndex + 1], (FLength - AIndex) * SizeOf(T));

  { Insert the new entry at the index }
  FData[AIndex] := AData;
  Inc(FLength);

  Result := True;
end;

function TArrayLists.Append (AValue : T) : Boolean;
begin
  Result := Insert(FLength, AValue);
end;

function TArrayLists.Prepend (AValue : T) : Boolean;
begin
  Result := Insert(0, AValue);
end;

procedure TArrayLists.RemoveRange (AIndex : Cardinal; ALength : Cardinal);
begin
  { Check this is a valid range }
  if (AIndex > FLength) or (AIndex + ALength > FLength) then
  begin
    Exit;
  end;

  { Move back the entries following the range to be removed }
  Move(FData[AIndex + ALength], FData[AIndex],
    (FLength - (AIndex + ALength)) * SizeOf(T));
  Dec(FLength, ALength);
end;

procedure TArrayLists.Remove (AIndex : Cardinal);
begin
  RemoveRange(AIndex, 1);
end;

function TArrayLists.IndexOf (AData : T) : Integer;
var
  i : Cardinal;
begin
  for i := 0 to FLength - 1 do
  begin
    if FData[i] = AData then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := -1;
end;

procedure TArrayLists.Clear;
begin
  FLength := 0;
end;

procedure TArrayLists.Sort;
begin
  
end;

end.
