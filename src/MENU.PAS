unit menu;
interface

function menuLoop: word;

implementation
uses crt, results, keys;

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
end;

function nextItem(item: word; up: boolean): word;
var tempItem: word;
begin
  if up then tempItem := item - 1 else tempItem := item + 1;
  if tempItem = 9 then tempItem := 12;
  if tempItem = 13 then tempItem := 10;

  gotoXY(30, item); write(' ');
  gotoXY(30, tempItem); write('►');

  nextItem := tempItem;
end;

function menuLoop: word;
var 
  item: word;
begin
  item := 10;
  printMenu;
  resetKey;
  while true do
  begin
    case key of
      KEY_ESC: begin menuLoop := 0; break; end;
      KEY_ENTER, KEY_SPACE: {ENTER, SPACE}
        begin 
          case item of
            10: {PLAY} menuLoop := 1;
            11: {HELP} begin printHelp; resetKey; readKey; end;
            12: {EXIT} menuLoop := 0;
          end;
          break;
        end;
      KEY_UP: {UP} item := nextItem(item, true);
      KEY_DOWN: {DOWN} item := nextItem(item, false);
    end;
    delay(100);
  end;
end;

end.
