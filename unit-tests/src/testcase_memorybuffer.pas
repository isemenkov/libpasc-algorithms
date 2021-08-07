unit testcase_memorybuffer;

{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, container.memorybuffer
  {$IFDEF FPC}, fpcunit, testregistry{$ELSE}, TestFramework{$ENDIF};

type
  TMemoryBufferTestCase = class(TTestCase)
  public
    {$IFNDEF FPC}
    procedure AssertTrue (AMessage : String; ACondition : Boolean);
    {$ENDIF}
  published
    procedure Test_MemoryBuffer_CreateNewEmpty;
    procedure Test_MemoryBuffer_AppendByteValueInto;
    procedure Test_MemoryBuffer_AppendByteAndReallocMemory;
    procedure Test_MemoryBuffer_AppendDataValueInto;
    procedure Test_MemoryBuffer_Clear;
    procedure Test_MemoryBuffer_AppendBufferWriteValue;
    procedure Test_MemoryBuffer_BufferRawWriteValue;
  end;

implementation

{$IFNDEF FPC}
procedure TMemoryBufferTestCase.AssertTrue(AMessage : String; ACondition :
  Boolean);
begin
  CheckTrue(ACondition, AMessage);
end;
{$ENDIF}

procedure TMemoryBufferTestCase.Test_MemoryBuffer_CreateNewEmpty;
var
  buffer : TMemoryBuffer;
begin
  buffer := TMemoryBuffer.Create;

  AssertTrue('#Test_MemoryBuffer_CreateNewEmpty -> ' +
   'MemoryBuffer must be empty', buffer.IsEmpty);

  FreeAndNil(buffer);
end;

procedure TMemoryBufferTestCase.Test_MemoryBuffer_AppendByteValueInto;
var
  buffer : TMemoryBuffer;
begin
  buffer := TMemoryBuffer.Create;

  buffer.AppendByte(1);
  buffer.AppendByte(254);

  AssertTrue('#Test_MemoryBuffer_AppendByteValueInto -> ' +
    'MemoryBuffer must not be empty', not buffer.IsEmpty);
  AssertTrue('#Test_MemoryBuffer_AppendByteValueInto -> ' +
    'MemoryBuffer length is not correct', buffer.GetBufferDataSize = 2);
  AssertTrue('#Test_MemoryBuffer_AppendByteValueInto -> ' +
    'MemoryBuffer value is not correct', PByte(buffer.GetBufferData)^ = 1);
  AssertTrue('#Test_MemoryBuffer_AppendByteValueInto -> ' +
    'MemoryBuffer value is not correct', PByte(PAnsiChar(buffer.GetBufferData) +
    Sizeof(Byte))^ = 254);

  FreeAndNil(buffer);
end;

procedure TMemoryBufferTestCase.Test_MemoryBuffer_AppendByteAndReallocMemory;
var
  buffer : TMemoryBuffer;
begin
  buffer := TMemoryBuffer.Create(1);

  buffer.AppendByte(43);
  buffer.AppendByte(12);
  buffer.AppendByte(255);
  buffer.AppendByte(3);

  AssertTrue('#Test_MemoryBuffer_AppendByteAndReallocMemory -> ' +
    'MemoryBuffer must not be empty', not buffer.IsEmpty);
  AssertTrue('#Test_MemoryBuffer_AppendByteAndReallocMemory -> ' +
    'MemoryBuffer length is not correct', buffer.GetBufferDataSize = 4);

  AssertTrue('#Test_MemoryBuffer_AppendByteAndReallocMemory -> ' +
    'MemoryBuffer value is not correct', PByte(buffer.GetBufferData)^ = 43);
  AssertTrue('#Test_MemoryBuffer_AppendByteAndReallocMemory -> ' +
    'MemoryBuffer value is not correct', PByte(PAnsiChar(buffer.GetBufferData) +
    Sizeof(Byte) * 1)^ = 12);
  AssertTrue('#Test_MemoryBuffer_AppendByteAndReallocMemory -> ' +
    'MemoryBuffer value is not correct', PByte(PAnsiChar(buffer.GetBufferData) +
    Sizeof(Byte) * 2)^ = 255);
  AssertTrue('#Test_MemoryBuffer_AppendByteAndReallocMemory -> ' +
    'MemoryBuffer value is not correct', PByte(PAnsiChar(buffer.GetBufferData) +
    Sizeof(Byte) * 3)^ = 3);

  FreeAndNil(buffer);
end;

procedure TMemoryBufferTestCase.Test_MemoryBuffer_AppendDataValueInto;
var
  buffer : TMemoryBuffer;
  data : Int64;
begin
  buffer := TMemoryBuffer.Create;

  data := 12545888;
  buffer.AppendData(data, Sizeof(Int64));
  data := 85416362;
  buffer.AppendData(data, Sizeof(Int64));
  data := 54962185984545;
  buffer.AppendData(data, Sizeof(Int64));

  AssertTrue('#Test_MemoryBuffer_AppendDataValueInto -> ' +
    'MemoryBuffer must not be empty', not buffer.IsEmpty);
  AssertTrue('#Test_MemoryBuffer_AppendDataValueInto -> ' +
    'MemoryBuffer length is not correct', buffer.GetBufferDataSize =
    Sizeof(Int64) * 3);

  AssertTrue('#Test_MemoryBuffer_AppendDataValueInto -> ' +
    'MemoryBuffer value is not correct', PInt64(buffer.GetBufferData)^ =
    12545888);
  AssertTrue('#Test_MemoryBuffer_AppendDataValueInto -> ' +
    'MemoryBuffer value is not correct', PInt64(PAnsiChar(buffer.GetBufferData)
    + Sizeof(Int64) * 1)^ = 85416362);
  AssertTrue('#Test_MemoryBuffer_AppendDataValueInto -> ' +
    'MemoryBuffer value is not correct', PInt64(PAnsiChar(buffer.GetBufferData)
    + Sizeof(Int64) * 2)^ = 54962185984545);

  FreeAndNil(buffer);
end;

procedure TMemoryBufferTestCase.Test_MemoryBuffer_Clear;
var
  buffer : TMemoryBuffer;
begin
  buffer := TMemoryBuffer.Create(1);

  buffer.AppendByte(43);
  buffer.AppendByte(12);
  buffer.AppendByte(255);
  buffer.AppendByte(3);

  AssertTrue('#Test_MemoryBuffer_Clear -> ' +
    'MemoryBuffer must not be empty', not buffer.IsEmpty);
  AssertTrue('#Test_MemoryBuffer_Clear -> ' +
    'MemoryBuffer length is not correct', buffer.GetBufferDataSize = 4);

  AssertTrue('#Test_MemoryBuffer_Clear -> ' +
    'MemoryBuffer value is not correct', PByte(buffer.GetBufferData)^ = 43);
  AssertTrue('#Test_MemoryBuffer_Clear -> ' +
    'MemoryBuffer value is not correct', PByte(PAnsiChar(buffer.GetBufferData) +
    Sizeof(Byte) * 1)^ = 12);
  AssertTrue('#Test_MemoryBuffer_Clear -> ' +
    'MemoryBuffer value is not correct', PByte(PAnsiChar(buffer.GetBufferData) +
    Sizeof(Byte) * 2)^ = 255);
  AssertTrue('#Test_MemoryBuffer_Clear -> ' +
    'MemoryBuffer value is not correct', PByte(PAnsiChar(buffer.GetBufferData) +
    Sizeof(Byte) * 3)^ = 3);

  buffer.Clear;
  AssertTrue('#Test_MemoryBuffer_Clear -> ' +
    'MemoryBuffer must be empty', buffer.IsEmpty);

  FreeAndNil(buffer);
end;

procedure TMemoryBufferTestCase.Test_MemoryBuffer_AppendBufferWriteValue;
var
  buffer : TMemoryBuffer;
  ptr : Pointer;
  data : Int64;
begin
  buffer := TMemoryBuffer.Create;

  buffer.AppendByte(21);
  ptr := buffer.GetAppendBuffer(Sizeof(Int64) * 2);

  data := 1245665;
  Move(data, (ptr)^, Sizeof(Int64));
  data := 56554147;
  Move(data, (PAnsiChar(ptr) + Sizeof(Int64) * 1)^, Sizeof(Int64));
  buffer.SetBufferDataSize(Sizeof(Byte) + Sizeof(Int64) * 2);

  AssertTrue('#Test_MemoryBuffer_AppendBufferWriteValue -> ' +
    'MemoryBuffer must not be empty', not buffer.IsEmpty);
  AssertTrue('#Test_MemoryBuffer_AppendBufferWriteValue -> ' +
    'MemoryBuffer length is not correct', buffer.GetBufferDataSize =
    Sizeof(Byte) + Sizeof(Int64) * 2);
  AssertTrue('#Test_MemoryBuffer_AppendBufferWriteValue -> ' +
    'MemoryBuffer value is not correct', PByte(buffer.GetBufferData)^ = 21);
  AssertTrue('#Test_MemoryBuffer_AppendBufferWriteValue -> ' +
    'MemoryBuffer value is not correct', PInt64(PAnsiChar(buffer.GetBufferData)
    + Sizeof(Byte))^ = 1245665);
  AssertTrue('#Test_MemoryBuffer_AppendBufferWriteValue -> ' +
    'MemoryBuffer value is not correct', PInt64(PAnsiChar(buffer.GetBufferData)
    + Sizeof(Byte) + Sizeof(Int64) * 1)^ = 56554147);

  FreeAndNil(buffer);
end;

procedure TMemoryBufferTestCase.Test_MemoryBuffer_BufferRawWriteValue;
var
  buffer : TMemoryBuffer;
  ptr : Pointer;
  data : Int64;
begin
  buffer := TMemoryBuffer.Create;

  buffer.AppendByte(21);
  ptr := buffer.GetWriteBuffer(Sizeof(Int64) * 2);

  data := 1245665;
  Move(data, (ptr)^, Sizeof(Int64));
  data := 56554147;
  Move(data, (PAnsiChar(ptr) + Sizeof(Int64) * 1)^, Sizeof(Int64));
  buffer.SetBufferDataSize(Sizeof(Int64) * 2);

  AssertTrue('#Test_MemoryBuffer_BufferRawWriteValue -> ' +
    'MemoryBuffer must not be empty', not buffer.IsEmpty);
  AssertTrue('#Test_MemoryBuffer_BufferRawWriteValue -> ' +
    'MemoryBuffer length is not correct', buffer.GetBufferDataSize =
    Sizeof(Int64) * 2);
  AssertTrue('#Test_MemoryBuffer_BufferRawWriteValue -> ' +
    'MemoryBuffer value is not correct', PInt64(buffer.GetBufferData)^
    = 1245665);
  AssertTrue('#Test_MemoryBuffer_BufferRawWriteValue -> ' +
    'MemoryBuffer value is not correct', PInt64(PAnsiChar(buffer.GetBufferData)
    + Sizeof(Int64) * 1)^ = 56554147);

  FreeAndNil(buffer);
end;

initialization
  RegisterTest(TMemoryBufferTestCase{$IFNDEF FPC}.Suite{$ENDIF});
end.

