unit keys;
interface
const 
  KEY_ESC = 1;
  KEY_UP = 72;
  KEY_LEFT = 75;
  KEY_RIGHT = 77;
  KEY_DOWN = 80;
  KEY_SPACE = 57;
  KEY_ENTER = 28;

function key: byte;
procedure resetKey;

implementation

procedure clear; assembler;
asm
  mov ax, 0c00h
  int 21h
end;

procedure resetKey;
begin
  clear;
  PORT[$60] := 0;
end;

function key: byte;
begin
  clear;
  key := PORT[$60];
end;

end.
