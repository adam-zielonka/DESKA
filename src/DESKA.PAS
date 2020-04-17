program deska;
uses crt, menu, results, game, keys;

procedure init;
begin
  asm mov cx,2000h; mov ah,1; int 10h; end;
end;

begin
  init;
  {while true do writeLn(key);}
  while true do case menuLoop of
    0: begin break end;
    1: begin gameLoop end;
  end;
end.
