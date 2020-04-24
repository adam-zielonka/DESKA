{Code base on http://pascal.kurs-programowania.pl/turbo_pascal,obs%C5%82uga_klawiatury_w_turbo_pascalu.html}
{$g+}
unit keys;
interface
var
  key: array[1..127] of boolean;
  isAnyPressed: boolean;
const
  KEY_ESC = 1;
  KEY_UP = 72;
  KEY_LEFT = 75;
  KEY_RIGHT = 77;
  KEY_DOWN = 80;
  KEY_SPACE = 57;
  KEY_ENTER = 28;
  KEY_CTRL = 29;
  KEY_ALT = 56;
  KEY_SHIFT = 42;
  KEY_P = 25;

procedure keysInit;
procedure keysEnd;
procedure keysClear;
procedure waitFor(keyCode: byte);

implementation
uses dos;

var 
  oldInterrupt09: pointer;
  keyboardEvent: procedure;

procedure keysEnd;
begin
  setIntVec($09, oldInterrupt09);
end;

{$f+}
procedure newInterrupt09; interrupt;
begin
  if assigned(keyboardEvent) then keyboardEvent;
  asm
    STI

    xor ch,ch             { set CH to 0, we're using bytes here! }

    mov dx,$60            { set DX to port $60 (keyboard port) }
    in al,dx              { get byte from keyboard }
    mov cl,al             { put it in CL for usage }
    and cl,$7f            { and CL with 127 (MOD 128) }

    mov bx,offset key     { get offset of the KEY array of booleans }
    dec bx
    add bx,cx             { add keyFound to BX }
    mov si,bx             { put calculated offset in DS:[SI] }

    shr al,7              { divide AL with 128 }
    xor al,1
    mov [si],al           { put TRUE or FALSE in array position of keyFound }
    mov isAnyPressed,al   { set isAnyPressed to TRUE or FALSE }
    mov dx,$61
    in al,dx              { get byte from the port }
    mov cl,al
    or al,$80
    out dx,al
    mov al,cl
    out dx,al
    cli

    mov ax,$20
    mov dx,$20
    out dx,ax
  end;
end;
{$f-}

procedure keysInit;
var n: byte;
begin
  isAnyPressed:= false;
  exitProc := addr(keysEnd);
  getIntVec($09, oldInterrupt09);
  setIntVec($09, addr(newInterrupt09));
  for n := 1 to 127 do key[n] := false;
end;

procedure keysClear; assembler;
asm
  mov ax, 0c00h
  int 21h
end;

procedure waitFor(keyCode: byte);
begin
  while key[keyCode] do begin end;
  while not key[keyCode] do begin end;
  key[keyCode] := false;
end;

begin
  fillChar(key, sizeof(key), 0);
  keyboardEvent := nil;
end.
