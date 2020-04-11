program deska;
uses crt;
var 
  z:char;
  k,l,m,n,s,p,x,y,q,t,u,c,f,v,w,d,e,o:word;
  imie,nik:string;
  wynik:word;

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
  clrscr;
  textcolor(1);
  writeln;
  writeln('  ██████████        █████████       ████████      ██   ██          ███');
  writeln('  ██       ██       ██             ██             ██  ██          ██ ██');
  writeln('  ██        ██      ██              ██            ██ ██          ██   ██');
  writeln('  ██         ██     ███████          ██████       ████          ██     ██');
  writeln('  ██        ██      ██                    ██      ██ ██        ███████████');
  writeln('  ██       ██       ██                   ██       ██  ██      ██         ██');
  writeln('  ██████████        █████████      ███████        ██   ██    ██           ██');
end;

procedure readBestResult;
var fileText:text;
begin
  Assign(fileText, 'WYNIKI.TXT');
  Reset(fileText);
  ReadLn(fileText, imie);
  ReadLn(fileText, wynik);
  Close(fileText);
end;

procedure writeBestResult(name: string; result: word);
var fileText:text;
begin
  Assign(fileText, 'WYNIKI.TXT');
  Rewrite(fileText);
  WriteLn(fileText, name);
  WriteLn(fileText, result);
  Close(fileText);
end;

procedure printMenu;
begin
  readBestResult;
  printTitle;
  textcolor(15);
  gotoxy(33, 10); write('Start');
  gotoxy(33, 11); write('Instrukcja');
  gotoxy(33, 12); write('Wyjście');
  gotoxy(24, 14); write('╔════════════════════════════════╗');
  gotoxy(24, 15); write('║                                ║');
  gotoxy(24, 16); write('╚════════════════════════════════╝');
  gotoxy(25, 15); write(imie);
  gotoxy(34, 15); write(wynik:23);
  gotoxy(30, 10); write('►');
end;

procedure printHelp;
begin
  printTitle;
  textcolor(15);
  gotoxy(23, 10); write('╔════════════════════════════════╗');
  gotoxy(23, 11); write('║ Esc    - wyjście               ║');
  gotoxy(23, 12); write('║ ',#27,'      - lewo                  ║');
  gotoxy(23, 13); write('║ ',#26,'      - prawo                 ║');
  gotoxy(23, 14); write('║ Spacja - wybicie piłki         ║');
  gotoxy(23, 15); write('║ P      - pauza                 ║');
  gotoxy(23, 16); write('╚════════════════════════════════╝');
  gotoxy(23, 17); write('     Cokolwiek aby powrócić');
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
      #27: k:=1;
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
          gotoxy(30, menu); write(' ');
          menu := menu - 1;
          if menu = 9 then menu := 12;
          gotoxy(30, menu); write('►');
        end;
      #80: 
        begin
          gotoxy(30, menu); write(' ');
          menu := menu + 1;
          if menu = 13 then menu := 10;
          gotoxy(30, menu); write('►');
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

procedure move(x, y, color: word);
begin
  gotoXY(x, y);
  textColor(color);
end;

procedure moveLeft;
begin
  if l <> 2 then
    begin
      l := l - 1;
      gotoxy(l + 10, 23); write(' ');
      print(l, 23, 6, '▀');
    end;
end;

procedure moveRight;
begin
  if l <> 70 then
    begin
      l := l + 1;
      gotoxy(l - 1, 23); write(' ');
      print(l + 9, 23, 6, '▀');
    end;
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
      move(1, 25, 4); write(' ♥ x ', e);
      move(40, 25, 15); write(w:40);
    end;
   if p=1 then
    begin
     if keypressed then z:=ReadKey else z:='?';
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
      #32:
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
     if keypressed then z:=ReadKey else z:='?';
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
     if t=50 then
      begin
       t:=0;
       gotoxy(x,y);
       write(' ');
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
       if d=2 then begin w:=w+10; gotoxy(40,25); write(w:40); d:=1; end;
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
       gotoxy(x,y);
       textcolor(14);
       write('☺');
       textcolor(15);
      end;
   end;
   if p=3 then
    begin
      e:=e-1;
      if e=0 then p:=4 else p:=1;
      move(1, 25, 4); write(' ♥ x ', e);
      move(37, 10, 4); write(' ♥ x ', e);
      textcolor(15);
      if p<>4 then 
        begin
          readkey;
          gotoxy(37,10);
          write('      ');
          gotoxy(x,y);
          write(' ');
          gotoxy(l+5,22);
          textcolor(14);
          write('☺');
          textcolor(15);
        end;
    end;
   if p=4 then
    begin
     if w>wynik then
      begin
        gotoxy(23, 11); write(' Jesteś najlepszy podaj swoje imię: ');
        gotoxy(30, 12); write('(Enter aby zatwierdzić)');
        gotoxy(24, 14); write('╔════════════════════════════════╗');   
        gotoxy(24, 15); write('║'); 
        gotoxy(57, 15); write('║');
        gotoxy(24, 16); write('╚════════════════════════════════╝');
        gotoxy(25, 15); read(nik);
        writeBestResult(nik, w);
        readBestResult;
      end;
      gotoxy(23, 11); write(' Jeszcze raz? [Spacja] Nie? [Esc]   ');
      gotoxy(24, 14); write('╔════════════════════════════════╗');
      gotoxy(24, 15); write('║                                ║'); 
      gotoxy(24, 16); write('╚════════════════════════════════╝');
      gotoxy(34, 15); write(wynik:23);
      gotoxy(25, 15); write(imie);
      z:=readKey;
      case z of
        #27: begin o:=2; p:=999; end;
        #32: p:=0;
      end;
      z:='?'
    end;
    delay(1);
  until(k=1);
end.
