program deska;
uses menu, game;

procedure hideCursor; assembler;
asm 
  mov cx,2000h; 
  mov ah,1; 
  int 10h; 
end;

begin
  hideCursor;
  while true do case menuLoop of
    MENU_EXIT: break;
    MENU_GAME: gameLoop;
  end;
end.
