unit game;
interface

procedure gameLoop;

implementation
uses crt, keys, results;
type
  CellType = record
    value, lastValue: char;
    color, lastColor: word;
    action: word;
  end;
var 
  screen: array[1..80, 1..25] of CellType;
  boardPosition: word; 
  ballX, ballY: word;
  up, left, run: boolean;
  boxes: array[1..26, 1..15] of word;
  points: LongInt;
  lives: word;

procedure attach(x, y: word; _value: char; _color, _action: word);
begin
  with screen[x, y] do
  begin
    value := _value;
    color := _color;
    action := _action;
  end;
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
      with screen[x, y] do
      begin
        lastValue := ' ';
        lastColor := 0;
      end;
end;

function isRenderNeed(x, y: word): boolean;
begin
  with screen[x, y] do if (value <> lastValue) or (color <> lastColor) 
  then isRenderNeed := true
  else isRenderNeed := false
end;

procedure render;
var x, y: word;
begin
  for y:= 1 to 25 do
    for x:= 1 to 80 do
    begin
      if ((y=25) and (x=80)) then continue;
      if isRenderNeed(x, y) then with screen[x, y] do
      begin
        gotoXY(x, y);
        textColor(color);
        write(value);
        lastValue := value;
        lastColor := color;
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
  screen[position + size + 1, 23].action := 102;
  screen[position - 1, 23].action := 102;
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

  if (screen[x - 1][y].action <> 0) or (screen[x + 1][y].action <> 0) then left := not left;
  if (screen[x][y - 1].action <> 0) or (screen[x][y + 1].action <> 0) then up := not up; 

  if (screen[x - 1][y].action = 300) then touchBox(x - 1, y);
  if (screen[x + 1][y].action = 300) then touchBox(x + 1, y);
  if (screen[x][y - 1].action = 300) then touchBox(x, y - 1);
  if (screen[x][y + 1].action = 300) then touchBox(x, y + 1);
  if (screen[x][y + 1].action = 103) then 
    begin 
      run := false;
      lives := lives - 1;
    end;
  if (screen[x][y + 1].action = 102) then points := points + 1;

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
  clrScr;
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

procedure writeLives;
begin
  gotoXY(1, 25); textColor(4); write(' ♥ x ', lives); 
end;

procedure writePoints;
begin
  gotoXY(40, 25); textColor(15); write(points:40); 
end;

procedure newBest(result: LongInt);
var newName: string;
begin
  textColor(15);
  gotoXY(23, 11); write(' Jesteś najlepszy, podaj swoje imię: ');
  gotoXY(23, 12); write('       (Enter aby zatwierdzić)       ');
  gotoXY(24, 14); write('╔════════════════════════════════╗');
  gotoXY(24, 15); write('║                                ║');
  gotoXY(24, 16); write('╚════════════════════════════════╝');
  gotoXY(25, 15); readLn(newName);
  writeBestResult(newName, result);
end;

function gameOver: boolean;
begin
  writeLives;
  readBestResult;
  if result < points then newBest(points);
  textColor(15);
  gotoXY(23, 11); write('   Kontynuuj? [Spacja]  Nie? [Esc]   ');
  gotoXY(23, 12); write('                                     ');
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
    if key[KEY_SPACE] or key[KEY_ENTER] then begin gameOver := false; break end;
  end;
  keysEnd;
end;

procedure mainLoop;
var time, i: word;
begin
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
    writeLives;
    writePoints;
    
    if key[KEY_ESC] then break;
    if key[KEY_LEFT] then setBoard(-1);
    if key[KEY_RIGHT] then setBoard(+1);
    if key[KEY_SPACE] or key[KEY_ENTER] then run := true;
    if key[KEY_P] then
    begin
      gotoXY(37, 25); textColor(15); write('Pauza!'); 
      waitFor(KEY_P);
      gotoXY(37, 25); textColor(15); write('      '); 
    end;
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
