{$g+}
unit keyb;
interface

TYPE TKeyboard_Event   = PROCEDURE;

VAR  key             : array[1..127] of boolean; { to store the key-presses }
     AnyPressed      : Boolean;
     KeyDelay        : Word;
     KEYBOARD_EVENT  : TKeyboard_Event;

Const 
      VK_ESC = 1;      { these are just some constants... }
      VK_Down   = 80;     { the most important keys in games }
      VK_Up     = 72;     { are the arrow keys, and the }
      VK_Left   = 75;     { control+alt keys... }
      VK_Right  = 77;
      VK_CTRL   = 29;
      VK_ALT    = 56;
      VK_RETURN = 28;
      VK_SPACE  = 57;
      VK_SHIFT  = 42;

PROCEDURE Keyb_Init;
PROCEDURE Keyb_End;
PROCEDURE Keyb_Clear;
Function  Keyb_KeyRetrace:Boolean;

implementation
uses dos;

VAR OldInt09        : pointer;        { old keyboard interupt             }

Const KeyWait:Integer=0;

PROCEDURE Keyb_End ;
BEGIN
 SetIntVec( $09, OldInt09 ) ;
END;

{$f+}
PROCEDURE Keyb_NewInt09; INTERRUPT;
Begin
  IF Assigned(KEYBOARD_EVENT) THEN
     Keyboard_Event;

ASM
 STI

 xor ch,ch             { set CH to 0, we're using bytes here! }

 mov dx,$60            { set DX to port $60 (keyboard port) }
 in al,dx              { get byte from keyboard }
 mov cl,al             { put it in CL for usage }
 and cl,$7f            { and CL with 127 (MOD 128) }

 mov bx,offset key     { get offset of the KEY array of booleans }
 dec bx
 add bx,cx             { add keyfound to BX }
 mov si,bx             { put calculated offset in DS:[SI] }

 shr al,7              { divide AL with 128 }
 xor al,1
 mov [si],al           { put TRUE or FALSE in array position of keyfound }
 mov anypressed,al     { set ANYPRESSED to TRUE or FALSE }
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
END;
End;
{$f-}

PROCEDURE Keyb_Init;
VAR n : byte;
BEGIN
 AnyPressed:=False;
 ExitProc := addr( Keyb_End) ;
 GetIntVec( $09, OldInt09 ) ;
 SetIntVec( $09, addr( Keyb_NewInt09 ) ) ;
 For N := 1 to 127 do Key[ N ] := False ;
END;

PROCEDURE Keyb_Clear;Assembler;
ASM
 mov ax, 0c00h
 int 21h
END;

Function Keyb_KeyRetrace:Boolean;
begin
Keyb_KeyRetrace:=False;
if keywait>0 then begin dec(keydelay);exit; End;
keywait:=KeyDelay;
Keyb_KeyRetrace:=True;
end;

begin
KeyDelay:=1;FillChar(key,sizeof(key),0);
KEYBOARD_EVENT:=NIL;
end.
