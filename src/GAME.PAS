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
  ballX, ballY: word;
  up, left, run: boolean;

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
  attach(1, 1, '┌', color, 100);
  for i := 2 to 79 do attach(i, 1, '─', color, 102);
  attach(80, 1, '┐', color, 100);
  for i := 2 to 23 do
  begin
    attach(1, i, '│', color, 101);
    attach(80, i, '│', color, 101);
  end;
  attach(1, 24, '└', color, 100);
  for i := 2 to 79 do attach(i, 24, '─', color, 103);
  attach(80, 24, '┘', color, 100);
end;

procedure renderBoard(position: word);
var i, size: word;
begin
  size := 10;
  for i := 0 to size do
    attach(position + i, 23, '▀', 6, 102);
end;

procedure setBoard(position: integer);
var size, newPosition: word;
begin
  size := 10;
  boardPosition := boardPosition + position;
  if boardPosition < 2 then boardPosition := 2;
  if boardPosition + size > 79 then boardPosition := 79 - size;

  if not run then
  begin
    ballX := boardPosition + (size div 2);
    ballY := 22;
  end;
end;

procedure setupBall;
begin
  ballX := 40;
  ballY := 22;
  up := true;
  left := true;
  run := false;
end;

procedure renderBall;
var x, y: word;
begin
  if not run then exit;

  if up then y := ballY - 1 else y := ballY + 1;
  if left then x := ballX - 1 else x := ballX + 1;
  if actions[x][y] <> 0 then 
  begin
    if (actions[x][y] = 103) then begin up := not up; run := false; end;
    if (actions[x][y] = 102) or (actions[x][y] = 100) then up := not up;
    if (actions[x][y] = 101) or (actions[x][y] = 100) then left := not left;
    if up then y := ballY - 1 else y := ballY + 1;
    if left then x := ballX - 1 else x := ballX + 1;
  end;

  ballX := x;
  ballY := y;
end;

procedure gameLoop;
var time: word;
begin
  clrScr;
  time := 0;
  boardPosition := 35;
  setupBall;
  PORT[$60] := 0;
  while PORT[$60] <> 1 do 
  begin
    time := time + 1;
    clear;
    renderGameArea;
    renderBoard(boardPosition);
    if time mod 2 = 0 then renderBall;
    point(ballX, ballY, '☺', 14);
    render;
    
    case PORT[$60] of
      27: {ESC} break;
      75: {LEFT} setBoard(-1);
      77: {RIGHT} setBoard(+1);
      57: {SPACE} run := true;
    end;
  end;
end;

procedure gameTest;
begin
  gameLoop;
end;

end.
