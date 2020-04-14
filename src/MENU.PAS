unit menu;
interface

function menuLoop: word;

implementation
uses crt, results;

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

function menuLoop: word;
var 
  item:word;
  key:char;
begin
  item := 10;
  printMenu;
  while true do
  begin
    key := readKey;
    case key of
      #27: begin menuLoop := 0; break; end;
      #13, #32: 
        begin 
          case item of
            10: {PLAY} menuLoop := 1;
            11: {HELP} begin printHelp; readKey; end;
            12: {EXIT} menuLoop := 0;
          end;
          break;
        end;
      #72: 
        begin
          gotoXY(30, item); write(' ');
          item := item - 1;
          if item = 9 then item := 12;
          gotoXY(30, item); write('►');
        end;
      #80: 
        begin
          gotoXY(30, item); write(' ');
          item := item + 1;
          if item = 13 then item := 10;
          gotoXY(30, item); write('►');
        end;
      else key:='?';
    end;
  end;
end;

end.
