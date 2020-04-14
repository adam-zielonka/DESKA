unit game;
interface

procedure gameTest;

implementation
uses crt;
var 
  screen: array[1..80, 1..25] of char;
  colors: array[1..80, 1..25] of word;
  rScreen: array[1..80, 1..25] of char;
  rColors: array[1..80, 1..25] of word;
  actions: array[1..80, 1..25] of word;
  boardPosition: word; 

procedure attach(x, y: word; value: char; color, action: word);
begin
  screen[x, y] := value;
  colors[x, y] := color;
  actions[x, y] := action;
end;

procedure point(x, y: word; value: char; color: word);
begin
  attach(x, y, value, color, 0);
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
      if ((rScreen[x, y] <> screen[x, y]) or (rColors[x, y] <> colors[x, y])) then
      begin
        gotoXY(x, y);
        textColor(colors[x, y]);
        write(screen[x, y]);
        rScreen[x, y] := screen[x, y];
        rColors[x, y] := colors[x, y];
      end;
    end;
end;

procedure renderGameArea;
var i, color: word;
begin
  color := 15;
  attach(1, 1, '┌', color, 1);
  for i := 2 to 79 do attach(i, 1, '─', color, 1);
  attach(80, 1, '┐', color, 1);
  for i := 2 to 23 do
  begin
    attach(1, i, '│', color, 1);
    attach(80, i, '│', color, 1);
  end;
  attach(1, 24, '└', color, 1);
  for i := 2 to 79 do attach(i, 24, '─', color, 1);
  attach(80, 24, '┘', color, 1);
end;

procedure renderBoard(position: word);
var i, size: word;
begin
  size := 11;
  for i := 0 to size do
    attach(position + i, 23, '▀', 6, 2);
end;

procedure setBoard(position: integer);
var size, newPosition: word;
begin
  size := 11;
  boardPosition := boardPosition + position;
  if boardPosition < 2 then boardPosition := 2;
  if boardPosition + size > 79 then boardPosition := 79 - size;
end;

procedure gameLoop;
var key: char;
begin
  clrScr;
  boardPosition := 35;
  while true do 
  begin
    clear;
    renderGameArea;
    renderBoard(boardPosition);
    render;
    
    key := readKey;
    case key of
      #27: {ESC} break;
      #75: {LEFT} setBoard(-1);
      #77: {RIGHT} setBoard(+1);
      else key:='?';
    end;
  end;
end;

procedure gameTest;
begin
  gameLoop;
end;

end.
