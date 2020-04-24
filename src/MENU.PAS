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
  gotoXY(34, 15); write(result:23);
  gotoXY(25, 15); write(name);
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
  readKey;
end;

function nextItem(item: word; up: boolean): word;
var tempItem: word;
const 
  MAX = 12;
  MIN = 10;
begin
  if up then tempItem := item - 1 else tempItem := item + 1;
  if tempItem = MIN - 1 then tempItem := MAX;
  if tempItem = MAX + 1 then tempItem := MIN;

  gotoXY(30, item); write(' ');
  gotoXY(30, tempItem); write('►');

  nextItem := tempItem;
end;

function menuLoop: word;
var 
  item: word;
  key: char;
begin
  item := 10;
  printMenu;
  while true do
  begin
    key := readKey;
    case key of
      #27: {ESC} begin menuLoop := 0; break; end;
      #13, #32: {ENTER, SPACE}
        begin 
          case item of
            10: {PLAY} menuLoop := 1;
            11: {HELP} printHelp;
            12: {EXIT} menuLoop := 0;
          end;
          break;
        end;
      #72: {UP} item := nextItem(item, true);
      #80: {DOWN} item := nextItem(item, false);
      else key:='?';
    end;
  end;
end;

end.
