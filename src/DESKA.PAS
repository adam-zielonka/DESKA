program deska;
uses crt;
var 
  z: char;
  k,l,m,n,s,p,x,y,q,t,u,c,f,v,w,d,e,o: word;
  name: string;
  result: word;

procedure init;
begin
  asm mov cx,2000h; mov ah,1; int 10h; end;
  p:=999;
  l:=35;
  w:=0;
  o:=2;
end;

procedure printTitle;
begin
  clrScr;
  textColor(1);
  writeLn;
  writeLn('  ██████████        █████████       ████████      ██   ██          ███');
  writeLn('  ██       ██       ██             ██             ██  ██          ██ ██');
  writeLn('  ██        ██      ██              ██            ██ ██          ██   ██');
  writeLn('  ██         ██     ███████          ██████       ████          ██     ██');
  writeLn('  ██        ██      ██                    ██      ██ ██        ███████████');
  writeLn('  ██       ██       ██                   ██       ██  ██      ██         ██');
  writeLn('  ██████████        █████████      ███████        ██   ██    ██           ██');
end;

procedure readBestResult;
var fileText:text;
begin
  Assign(fileText, 'WYNIKI.TXT');
  Reset(fileText);
  ReadLn(fileText, name);
  ReadLn(fileText, result);
  Close(fileText);
end;

procedure writeBestResult(_name: string; _result: word);
var fileText:text;
begin
  Assign(fileText, 'WYNIKI.TXT');
  Rewrite(fileText);
  WriteLn(fileText, _name);
  WriteLn(fileText, _result);
  Close(fileText);
end;

procedure printMenu;
begin
  readBestResult;
  printTitle;
  textColor(15);
  gotoXY(33, 10); write('Start');
  gotoXY(33, 11); write('Instrukcja');
  gotoXY(33, 12); write('Wyjście');
  gotoXY(24, 14); write('╔════════════════════════════════╗');
  gotoXY(24, 15); write('║                                ║');
  gotoXY(24, 16); write('╚════════════════════════════════╝');
  gotoXY(25, 15); write(name);
  gotoXY(34, 15); write(result:23);
  gotoXY(30, 10); write('►');
end;

procedure printHelp;
begin
  printTitle;
  textColor(15);
  gotoXY(23, 10); write('╔════════════════════════════════╗');
  gotoXY(23, 11); write('║ Esc    - wyjście               ║');
  gotoXY(23, 12); write('║ ',#27,'      - lewo                  ║');
  gotoXY(23, 13); write('║ ',#26,'      - prawo                 ║');
  gotoXY(23, 14); write('║ Spacja - wybicie piłki         ║');
  gotoXY(23, 15); write('║ P      - pauza                 ║');
  gotoXY(23, 16); write('╚════════════════════════════════╝');
  gotoXY(23, 17); write('     Cokolwiek aby powrócić');
end;

procedure menuLoop;
var 
  menu:word;
  key:char;
begin
  menu := 10;
  printMenu;
  while true do
  begin
    key := readKey;
    case key of
      #27: begin k:=1; break; end;
      #13, #32: 
        begin 
          case menu of
            10: {PLAY} begin o:=1; p:=0; end;
            11: {HELP} begin printHelp; readKey; end;
            12: {EXIT} k:=1;
          end;
          break;
        end;
      #72: 
        begin
          gotoXY(30, menu); write(' ');
          menu := menu - 1;
          if menu = 9 then menu := 12;
          gotoXY(30, menu); write('►');
        end;
      #80: 
        begin
          gotoXY(30, menu); write(' ');
          menu := menu + 1;
          if menu = 13 then menu := 10;
          gotoXY(30, menu); write('►');
        end;
      else key:='?';
    end;
  end;
end;

procedure printGameArea;
begin
  ClrScr;
  textColor(15);
  write('┌');
  for m := 2 to 79 do write('─');
  write('┐');
  for m := 2 to 23 do
  begin
    write('│');
    for n := 2 to 79 do write(' ');
    write('│');
  end;
  write('└');
  for m := 2 to 79 do write('─');
  write('┘');
end;

procedure print(x, y, color: word; text: string);
begin
  gotoXY(x, y);
  textColor(color);
  write(text);
end;

procedure gotoXYC(x, y, color: word);
begin
  gotoXY(x, y);
  textColor(color);
end;

procedure moveLeft;
begin
  if l <> 2 then
    begin
      l := l - 1;
      gotoXY(l + 10, 23); write(' ');
      print(l, 23, 6, '▀');
    end;
end;

procedure moveRight;
begin
  if l <> 70 then
    begin
      l := l + 1;
      gotoXY(l - 1, 23); write(' ');
      print(l + 9, 23, 6, '▀');
    end;
end;

procedure newBest(result: word);
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
  readBestResult;
end;

procedure gameOver;
begin
  textColor(15);
  gotoXY(23, 11); write(' Jeszcze raz? [Spacja] Nie? [Esc]   ');
  gotoXY(24, 14); write('╔════════════════════════════════╗');
  gotoXY(24, 15); write('║                                ║'); 
  gotoXY(24, 16); write('╚════════════════════════════════╝');
  gotoXY(34, 15); write(result:23);
  gotoXY(25, 15); write(name);
end;

begin
  init;
  repeat
   if p=999 then
      repeat menuLoop; until((o = 1) or (k = 1));
   if p=0 then
    begin
      s:=0;
      p:=1;
      w:=0;
      e:=3;
      printGameArea;
      print(l, 23, 6, '▀▀▀▀▀▀▀▀▀▀');
      print(l + 5, 22, 14, '☺');
      gotoXYC(1, 25, 4); write(' ♥ x ', e);
      gotoXYC(40, 25, 15); write(w:40);
    end;
   if p=1 then
    begin
     if keyPressed then z:=ReadKey else z:='?';
     case z of
      #27: begin o:=2; p:=999; end;
      #75: 
        begin
          moveLeft;
          print(l + 6, 22, 14, ' ');
          print(l + 5, 22, 14, '☺');
        end;
      #77: 
        begin
          moveRight;
          print(l + 4, 22, 14, ' ');
          print(l + 5, 22, 14, '☺');
        end;
      #32, #13:
        begin
          p:=2;
          x:=l+5;
          y:=22;
          q:=1;
          d:=0;
          if ((x mod 2)=0) then v:=1 else v:=2;
        end;
      #80, #112: 
        begin
          print(37, 10, 15, 'Pauza!');
          readKey;
          print(37, 10, 15, '      ');
        end;
     end;
    end;
   if p=2 then
    begin
     if keyPressed then z:=ReadKey else z:='?';
     case z of
      #27: begin o:=2; p:=999; end;
      #75: moveLeft;
      #77: moveRight;
      #80, #112: 
        begin
          print(37, 10, 15, 'Pauza!');
          readKey;
          print(37, 10, 15, '      ');
        end;
     end;
     t:=t+1;
     if t=75 then
      begin
       t:=0;
       gotoXY(x, y); write(' ');
       if y=22 then
        begin
         q:=1;
         f:=0;
         c:=l-2;
         u:=0;
         repeat
          f:=f+1;
          c:=c+1;
          if x=c then u:=1;
         until((f=12) or (u=1));
          if u<>1 then p:=3;
          if p<>3 then d:=d+1;
        end;
       if d=2 then begin w:=w+10; gotoXYC(40, 25, 15); write(w:40); d:=1; end;
       if y=2 then q:=2;
       case q of
        1: begin
            if p<>3 then y:=y-1
                    else y:=y+1;
           end;
        2: y:=y+1;
       end;
       if x=2 then v:=2;
       if x=79 then v:=1;
       case v of
        1: x:=x-1;
        2: x:=x+1;
       end;
       print(x, y, 14, '☺');
      end;
   end;
   if p=3 then
    begin
      e:=e-1;
      if e=0 then p:=4 else p:=1;
      gotoXYC(1, 25, 4); write(' ♥ x ', e);
      gotoXYC(37, 10, 4); write(' ♥ x ', e);
      textColor(15);
      if p<>4 then 
        begin
          readKey;
          gotoXY(37, 10); write('      ');
          print(x, y, 14, ' ');
          print(l + 5, 22, 14, '☺');
        end;
    end;
    if p=4 then
      begin
        if w>result then newBest(w);
        gameOver;
        z:=readKey;
        case z of
          #27: begin o:=2; p:=999; end;
          #32, #13: p:=0;
        end;
        z:='?'
      end;
    delay(1);
  until(k=1);
end.
