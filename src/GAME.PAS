unit game;
interface

procedure gameTest;

implementation
uses crt;
var 
  screen: array[1..80, 1..25] of char;
  colors: array[1..80, 1..25] of word;

procedure point(x, y: word; value: char; color: word);
begin
  screen[x, y] := value;
  colors[x, y] := color;
end;

procedure clear;
var x, y: word;
begin
  for y:= 1 to 25 do
    for x:= 1 to 80 do
      point(x, y, ' ', 15);
end;

procedure render;
var x, y: word;
begin
  for y:= 1 to 25 do
    for x:= 1 to 80 do
    begin
      if ((y=25) and (x=80)) then continue;
      gotoXY(x, y);
      textColor(colors[x, y]);
      write(screen[x, y]);
    end;
end;

procedure initGameArea;
var m, n, color: word;
begin
  color := 2;
  point(1, 1, '┌', color);
  for m := 2 to 79 do point(m, 1, '─', color);
  point(80, 1, '┐', color);
  for m := 2 to 23 do
  begin
    point(1, m, '│', color);
    point(80, m, '│', color);
  end;
  point(1, 24, '└', color);
  for m := 2 to 79 do point(m, 24, '─', color);
  point(80, 24, '┘', color);
end;

procedure gameTest;
begin
  clrScr;
  clear;
  initGameArea;
  render;
  readKey;
end;

end.
