unit game;
interface

procedure gameTest;

implementation
uses crt;
var 
  screen: array[1..80, 1..25] of char;
  colors: array[1..80, 1..25] of word;
  actions: array[1..80, 1..25] of word;
  board_position: word; 

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
      gotoXY(x, y);
      textColor(colors[x, y]);
      write(screen[x, y]);
    end;
end;

procedure initGameArea;
var i, color: word;
begin
  color := 2;
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

procedure setBoard(position: word);
var i: word;
begin
  for i := 0 to 9 do
    attach(position + i, 23, '▀', 6, 2);
end;

procedure gameLoop;
var key: char;
begin
  clrScr;
  board_position := 35;
  while true do 
  begin
    clear;
    initGameArea;
    setBoard(board_position);
    render;
    
    key := readKey;
    case key of
      #27: {ESC} break;
      #75: {LEFT} board_position := board_position - 1;
      #77: {RIGHT} board_position := board_position + 1;
      else key:='?';
    end;
  end;
end;

procedure gameTest;
begin
  gameLoop;
end;

end.
