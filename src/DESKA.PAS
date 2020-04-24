program deska;
uses menu, game;

procedure init;
begin
  asm mov cx,2000h; mov ah,1; int 10h; end;
end;

begin
  init;
  while true do case menuLoop of
    MENU_EXIT: begin break end;
    MENU_GAME: begin gameLoop end;
  end;
end.
