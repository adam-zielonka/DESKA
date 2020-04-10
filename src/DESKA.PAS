program deska;
uses crt;
var z:char;
    k,l,m,n,s,p,x,y,q,t,u,c,f,v,r,w,d,e,o,g:word;
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

begin
  init;
  Repeat
   if p=999 then
    repeat
     if o=2 then
      begin
       printTitle;
       textcolor(15);
       gotoxy(33,10);
       write('Start');
       gotoxy(33,11);
       write('Instrukcja');
       gotoxy(33,12);
       write('Wyjście');
       readBestResult;
       gotoxy(24,14);
       write('╔════════════════════════════════╗');   
       gotoxy(34,15);
       write(wynik:23,'║');
       gotoxy(24,15);
       write('║',imie);
       gotoxy(24,16);
       write('╚════════════════════════════════╝');
       o:=3;
       gotoxy(30,10);
       write('►');
       g:=10;
      end;
     if o=3 then
      begin
        z:=readkey;
        case z of
         #27: k:=1;
         #32: begin 
               case g of
                10: begin o:=1; p:=0; end;
                11: o:=4;
                12: k:=1;
               end;
                       end;
         #72: begin
               gotoxy(30,g);
               write(' ');
               g:=g-1;
               if g=9 then g:=12;
               gotoxy(30,g);
               write('►');
              end;
         #80: begin
               gotoxy(30,g);
               write(' ');
               g:=g+1;
               if g=13 then g:=10;
               gotoxy(30,g);
               write('►');
              end;
         else z:='?';
        end;
     end;
     if o=4 then
      begin
       printTitle;
       textcolor(15);
       gotoxy(23,10);
       write('╔════════════════════════════════╗');
       gotoxy(23,11);
       write('║ Esc    - wyjście               ║');
       gotoxy(23,12);
       write('║ ',#27,'      - lewo                  ║');
       gotoxy(23,13);
       write('║ ',#26,'      - prawo                 ║');
       gotoxy(23,14);
       write('║ Spacja - wybicie piłki         ║');
       gotoxy(23,15);
       write('║ P      - pauza                 ║');
       gotoxy(23,16);
       write('╚════════════════════════════════╝');
       gotoxy(23,17);
       write('     Cokolwiek aby powrócić');
       z:=readkey;
       case z of
        #27: o:=2;
        else o:=2;
        z:='?';
     end;
         end;
    until((o=1) or (k=1));
    {if runda=1 then
     begin
      if element=1 then
      begin
      gotoxy(36,3);
      write('┌────┐')  ;
      gotoxy(36,4) ;
      write('└────┘');
      end;
     end;
    }
   if p=0 then
    begin
     ClrScr;
     s:=0;
     p:=1;
     write('┌');
     for m:=2 to 79 do write('─');
     write('┐');
     for m:=2 to 23 do
      begin
       write('│');
       for n:=2 to 79 do write(' ');
       write('│');
      end;
     write('└');
     for m:=2 to 79 do write('─');
     write('┘');
     gotoxy(l,23);
     textcolor(6);
     write('▀▀▀▀▀▀▀▀▀▀');
     textcolor(15);
     gotoxy(l+5,22);
     textcolor(14);
     write('☺');
     textcolor(15);
     w:=0;
     gotoxy(1,25);
     e:=3;
     textcolor(4);
     write(' ♥ x ',e);
     textcolor(15);
     gotoxy(40,25);
     write(w:40);
    end;
   if p=1 then
    begin
     if keypressed then z:=ReadKey else z:='?';
     case z of
      #27: begin o:=2; p:=999; end;
      #75: begin
            gotoxy(2,23);
            for m:=2 to 79 do write(' ');
            if l<>2 then l:=l-1 else l:=2;
            gotoxy(l,23);
            textcolor(6);
            write('▀▀▀▀▀▀▀▀▀▀');
            textcolor(15);
            gotoxy(2,22);
            for m:=2 to 79 do write(' ');
            gotoxy(l+5,22);
            textcolor(14);
            write('☺');
            textcolor(15);
            r:=1;
           end;
      #77: begin
            gotoxy(2,23);
            for m:=2 to 79 do write(' ');
            if l<>70 then l:=l+1 else l:=70;
            gotoxy(l,23);
            textcolor(6);
            write('▀▀▀▀▀▀▀▀▀▀');
            textcolor(15);
            gotoxy(2,22);
            for m:=2 to 79 do write(' ');
            gotoxy(l+5,22);
            textcolor(14);
            write('☺');
            textcolor(15);
            r:=1;
           end;
      #32: begin
            p:=2;
            x:=l+5;
            y:=22;
            q:=1;
            d:=0;
            if ((x mod 2)=0) then v:=1 else v:=2;
           end;
      #80: begin
           gotoxy(37,10);
           write('Pauza!');
           readkey;
           gotoxy(37,10);
           write('      ');
           end;
      #112:begin
           gotoxy(37,10);
           write('Pauza!');
           readkey;
           gotoxy(37,10);
           write('      ');
           end;
     end;
    end;
   if p=2 then
    begin
     if keypressed then z:=ReadKey else z:='?';
     case z of
      #27: begin o:=2; p:=999; end;
      #75: begin
            gotoxy(2,23);
            for m:=2 to 79 do write(' ');
            if l<>2 then l:=l-1 else l:=2;
            gotoxy(l,23);
            textcolor(6);
            write('▀▀▀▀▀▀▀▀▀▀');
            textcolor(15);
            r:=1;
           end;
      #77: begin
            gotoxy(2,23);
            for m:=2 to 79 do write(' ');
            if l<>70 then l:=l+1 else l:=70;
            gotoxy(l,23);
            textcolor(6);
            write('▀▀▀▀▀▀▀▀▀▀');
            textcolor(15);
            r:=1;
           end;
      #80: begin
           gotoxy(37,10);
           write('Pauza!');
           readkey;
           gotoxy(37,10);
           write('      ');
           end;
      #112:begin
           gotoxy(37,10);
           write('Pauza!');
           readkey;
           gotoxy(37,10);
           write('      ');
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
    gotoxy(1,25);
    textcolor(4);
    write(' ♥ x ',e);	
    gotoxy(37,10);
    write(' ♥ x ',e);
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
       gotoxy(23,11);
     write(' Jesteś najlepszy podaj swoje imię: ');
            gotoxy(30,12);
     write('(Enter aby zatwierdzić)');
       gotoxy(24,14);
       write('╔════════════════════════════════╗');   
       gotoxy(24,15);
       write('║');
       gotoxy(57,15);
       write('║');
       gotoxy(24,16);
       write('╚════════════════════════════════╝');
            gotoxy(25,15);
     read(nik);
     writeBestResult(nik, w);
     readBestResult;
  end;
     gotoxy(23,11);
     write(' Jeszcze raz? [Spacja] Nie? [Esc]   ');
                        gotoxy(30,12);
     write('                       ');
       gotoxy(24,14);
       write('╔════════════════════════════════╗');   
       gotoxy(34,15);
       write(wynik:23,'║');
       gotoxy(24,15);
       write('║',imie);
       gotoxy(24,16);
       write('╚════════════════════════════════╝');
     if keypressed then z:=ReadKey
                   else z:='?';
     case z of
      #27: begin o:=2; p:=999; end;
      #32: p:=0;
     end;
    end;
   if r=1 then
   begin
    gotoxy(1,1);
    write('┌');
    for m:=2 to 79 do write('─');
    write('┐');
    for m:=2 to 23 do
    begin
     gotoxy(1,m);
     write('│');
     gotoxy(80,m);
     write('│');
    end;
    write('└');
    for m:=2 to 79 do write('─');
    write('┘');
    r:=0;
    gotoxy(1,25);
    textcolor(4);
    write(' ♥ x ',e);
    textcolor(15);
   end;
   delay(1);
  until(k=1);
end.
