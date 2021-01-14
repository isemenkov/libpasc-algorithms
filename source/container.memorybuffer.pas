(******************************************************************************)
(*                             libPasC-Algorithms                             *)
(* delphi and object pascal library of  common data structures and algorithms *)
(*                                                                            *)
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

unit container.memorybuffer;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}
{$IFOPT D+}
  {$DEFINE DEBUG}
{$ENDIF}

interface

uses
  SysUtils;

type
  { A TMemoryBuffer is a useful data structure for storing arbitrary sized 
    blocks of memory. It is guarantees deletion of the memory block when the 
    object is destroyed.

    This class based on wxWidgets wxMemoryBuffer api interface 
    https://docs.wxwidgets.org/trunk/classwx_memory_buffer.html }
  PMemoryBuffer = ^TMemoryBuffer;
  TMemoryBuffer = class
  public
    constructor Create (ASize : Int64 = 1024);
    destructor Destroy; override;

    { Append a single byte to the buffer. }
    procedure AppendByte (AData : Byte);

    { Append a data block to the buffer. }
    procedure AppendData (const AData; ASize : Int64);

    { Clear the buffer contents. }
    procedure Clear;

    { Ensure that the buffer is big enough and return a pointer to the start of 
      the empty space in the buffer.
      This pointer can be used to directly write data into the buffer, this new 
      data will be appended to the existing data. }
    function GetAppendBuffer (ASizeNeeded : Int64) : Pointer;

    { Sets the length of the data stored in the buffer.
      Mainly useful for truncating existing data. }
    procedure SetBufferDataSize (ASizeUsed : Int64);

    { Ensure the buffer is big enough and return a pointer to the buffer which 
      can be used to directly write into the buffer up to sizeNeeded bytes. }
    function GetWriteBuffer (ASizeNeeded : Int64) : Pointer;

    { Ensures the buffer has at least size bytes available. }
    procedure SetBufferAllocSize (ASize : Int64);

    { Returns the size of the buffer. }
    function GetBufferAllocSize : Int64;

    { Returns the length of the valid data in the buffer. }
    function GetBufferDataSize : Int64;

    { Return a pointer to the data in the buffer. }
    function GetBufferData : Pointer;

    { Returns true if the buffer contains no data. }
    function IsEmpty : Boolean;
  protected
    { Reallocate the array to the new size }
    function Enlarge : Boolean;
  protected
    FData : array of Byte;
    FLength : Int64;
    FAlloced : Int64;
  end;

implementation

constructor TMemoryBuffer.Create (ASize : Int64);
begin
  if ASize = 0 then
  begin
    ASize := 1024;
  end;

  SetLength(FData, ASize);
  FAlloced := ASize;
  FLength := 0;
end;

destructor TMemoryBuffer.Destroy;
begin
  SetLength(FData, 0);
  inherited Destroy;
end;

function TMemoryBuffer.Enlarge : Boolean;
var
  NewSize : Int64;
begin
  { Double the allocated size }
  NewSize := FAlloced * 2;

  { Reallocate the array to the new size }
  SetLength(FData, NewSize);
  FAlloced := NewSize;
  
  Result := True;
end;

procedure TMemoryBuffer.AppendByte (AData : Byte);
begin
  if FLength + 1 > FAlloced then
  begin
    if not Enlarge then
    begin
      Exit;
    end;
  end;

  FData[FLength] := AData;
  Inc(FLength);
end;

procedure TMemoryBuffer.AppendData (const AData; ASize : Int64);
begin
  while FLength + ASize > FAlloced do
  begin
    if not Enlarge then
    begin
      Exit;
    end;
  end;

  Move(AData, FData[FLength], ASize);
  Inc(FLength, ASize);
end;

procedure TMemoryBuffer.Clear;
begin
  FLength := 0;
end;

function TMemoryBuffer.GetAppendBuffer (ASizeNeeded : Int64) : Pointer;
begin
  while FLength + ASizeNeeded > FAlloced do
  begin
    if not Enlarge then
    begin
      Exit(nil);
    end;
  end;

  Result := @FData[FLength];
end;

procedure TMemoryBuffer.SetBufferDataSize (ASizeUsed : Int64);
begin
  FLength := ASizeUsed;
end;

function TMemoryBuffer.GetWriteBuffer (ASizeNeeded : Int64) : Pointer;
begin
  while ASizeNeeded > FAlloced do
  begin
    if not Enlarge then
    begin
      Exit(nil);
    end;
  end;

  Result := @FData[0];
end;

procedure TMemoryBuffer.SetBufferAllocSize (ASize : Int64);
begin
  if ASize < FAlloced then
  begin
    SetLength(FData, ASize);
    FAlloced := ASize;
    FLength := ASize;
  end else
  begin
    while ASize < FAlloced do
    begin
      if not Enlarge then
      begin
        Exit;
      end;
    end;
  end;
end;

function TMemoryBuffer.GetBufferAllocSize : Int64;
begin
  Result := FAlloced;
end;

function TMemoryBuffer.GetBufferDataSize : Int64;
begin
  Result := FLength;
end;

function TMemoryBuffer.GetBufferData : Pointer;
begin
  Result := @FData[0];
end;

function TMemoryBuffer.IsEmpty : Boolean;
begin
  Result := (FLength = 0);
end;

end.
