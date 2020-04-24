unit menu;
interface
const
  MENU_EXIT = 0;
  MENU_GAME = 1;

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

function nextPosition(position: word; direction: boolean): word;
var newPosition: word;
const 
  MAX = 12;
  MIN = 10;
begin
  if direction then newPosition := position - 1 else newPosition := position + 1;
  if newPosition = MIN - 1 then newPosition := MAX;
  if newPosition = MAX + 1 then newPosition := MIN;

  gotoXY(30, position); write(' ');
  gotoXY(30, newPosition); write('►');

  nextPosition := newPosition;
end;

function menuLoop: word;
var 
  position: word;
const
  POSITION_PLAY = 10;
  POSITION_HELP = 11;
  POSITION_EXIT = 12;
begin
  position := POSITION_PLAY;
  printMenu;
  while true do case readKey of
    #27: {ESC} begin menuLoop := MENU_EXIT; break; end;
    #13, #32: {ENTER, SPACE}
      begin 
        case position of
          POSITION_PLAY: menuLoop := MENU_GAME;
          POSITION_HELP: printHelp;
          POSITION_EXIT: menuLoop := MENU_EXIT;
        end;
        break;
      end;
    #72: {UP} position := nextPosition(position, true);
    #80: {DOWN} position := nextPosition(position, false);
  end;
end;

end.
