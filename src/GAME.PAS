unit game;
interface

procedure gameLoop;

implementation
uses crt, keys, results;
var 
  screen: array[1..80, 1..25] of char;
  colors: array[1..80, 1..25] of word;
  rScreen: array[1..80, 1..25] of char;
  rColors: array[1..80, 1..25] of word;
  actions: array[1..80, 1..25] of word;
  boardPosition: word; 
  ballX, ballY: word;
  up, left, run: boolean;
  boxes: array[1..26, 1..15] of word;
  points: LongInt;
  lives: word;

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

procedure clearR;
var x, y: word;
begin
  for y:= 1 to 25 do
    for x:= 1 to 80 do
    begin
        rScreen[x, y] := ' ';
        rColors[x, y] := 0;
    end;
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
  color := 8;
  attach(1, 1, '▄', color, 100);
  for i := 2 to 79 do attach(i, 1, '▄', color, 102);
  attach(80, 1, '▄', color, 100);
  for i := 2 to 23 do
  begin
    attach(1, i, '█', color, 101);
    attach(80, i, '█', color, 101);
  end;
  attach(1, 24, '▀', color, 100);
  for i := 2 to 79 do attach(i, 24, '▀', color, 103);
  attach(80, 24, '▀', color, 100);
end;

procedure renderBox(x, y, color: word);
begin
  attach(x + 0, y, '▓', color, 300);
  attach(x + 1, y, '▓', color, 300);
  attach(x + 2, y, '▓', color, 300);
end;

procedure renderBoxB(x, y, color: word);
begin
  attach(x + 0, y, '▒', color, 300);
  attach(x + 1, y, '▒', color, 300);
  attach(x + 2, y, '▒', color, 300);
end;

procedure renderBoard(position: word);
var i, size: word;
begin
  size := 10;
  for i := 0 to size do
    attach(position + i, 23, '▀', 6, 102);
  actions[position + size + 1, 23] := 102;
  actions[position - 1, 23] := 102;
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

procedure touchBox(x, y: word);
begin
  points := points + 10;
  boxes[(x + 1) div 3, y - 1] := 0;
end;

procedure calcBall;
var x, y: word;
begin
  if not run then exit;

  if up then y := ballY - 1 else y := ballY + 1;
  if left then x := ballX - 1 else x := ballX + 1;

  if (actions[x - 1][y] <> 0) or (actions[x + 1][y] <> 0) then left := not left;
  if (actions[x][y - 1] <> 0) or (actions[x][y + 1] <> 0) then up := not up; 

  if (actions[x - 1][y] = 300) then touchBox(x - 1, y);
  if (actions[x + 1][y] = 300) then touchBox(x + 1, y);
  if (actions[x][y - 1] = 300) then touchBox(x, y - 1);
  if (actions[x][y + 1] = 300) then touchBox(x, y + 1);
  if (actions[x][y + 1] = 103) then 
    begin 
      run := false;
      lives := lives - 1;
    end;
  if (actions[x][y + 1] = 102) then points := points + 1;

  ballX := x;
  ballY := y;
  if not run then setBoard(0);
end;

procedure renderBall;
begin
  point(ballX, ballY, '☺', 14);
end;

procedure setupBall;
begin
  ballX := 40;
  ballY := 22;
  up := true;
  left := true;
  run := false;
end;

procedure setupBoxes;
var x, y: word;
begin
  for y:= 1 to 15 do
    for x:= 1 to 26 do
      if x mod 1 = 0 then boxes[x, y] := 1 + ((y - 1) div 3) + ((x - 1) div 3) else boxes[x, y] := 0;
end;

procedure renderBoxes;
var x, y: word;
begin
  for y:= 1 to 15 do
    for x:= 1 to 26 do
      if boxes[x, y] <> 0 then
        if (x + y) mod 2 = 0 then renderBox(-1 + (x * 3), 1 + y, boxes[x, y])
        else renderBoxB(-1 + (x * 3), 1 + y, boxes[x, y]);
end;

procedure setup;
begin
  clearR;
  points := 0;
  lives := 3;
  boardPosition := 35;
  setupBall;
  setupBoxes;
end;

procedure nextSetup;
begin
  clearR;
  points := 0;
  lives := 3;
end;

procedure newBest(result: LongInt);
var newName: string;
begin
  textColor(15);
  gotoXY(23, 11); write(' Jesteś najlepszy podaj swoje imię: ');
  gotoXY(30, 12); write('(Enter aby zatwierdzić)');
  gotoXY(24, 14); write('╔════════════════════════════════╗');   
  gotoXY(24, 15); write('║'); 
  gotoXY(57, 15); write('║');
  gotoXY(24, 16); write('╚════════════════════════════════╝');
  gotoXY(25, 15); read(newName);
  writeBestResult(newName, result);
end;

function gameOver: boolean;
begin
  readBestResult;
  if result < points then newBest(points);
  textColor(15);
  gotoXY(23, 11); write('  Kontynuuj? [Spacja] Nie? [Esc]  ');
  gotoXY(24, 14); write('╔════════════════════════════════╗');
  gotoXY(24, 15); write('║                                ║'); 
  gotoXY(24, 16); write('╚════════════════════════════════╝');
  gotoXY(34, 15); write(result:23);
  gotoXY(25, 15); write(name);
  keysInit;
  while true do 
  begin    
    keysClear;
    if key[KEY_ESC] then begin gameOver := true; break end;
    if key[KEY_SPACE] then begin gameOver := false; break end;
  end;
  keysEnd;
end;

procedure mainLoop;
var time, i: word;
begin
  clrScr;
  time := 0;
  keysInit;
  while not key[KEY_ESC] do 
  begin
    keysClear;
    time := time + 1;
    if time mod 2 = 0 then calcBall;
    if lives = 0 then break;

    clear;
    renderGameArea;
    renderBoxes;
    renderBoard(boardPosition);
    renderBall;
    render;
    gotoXY(40, 25); textColor(15); write(points:40); 
    gotoXY(1, 25); textColor(4); write(' ♥ x ', lives); 
    
    if key[KEY_ESC] then break;
    if key[KEY_LEFT] then setBoard(-1);
    if key[KEY_RIGHT] then setBoard(+1);
    if key[KEY_SPACE] then run := true;
  end;
  keysClear;
  keysEnd;
end;

procedure gameLoop;
begin
  setup;
  while true do
  begin
    mainLoop;
    if gameOver then break else nextSetup;
  end;
end;

end.
