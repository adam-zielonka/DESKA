unit time;
interface

procedure timeinit;
function timediffer: longint;

implementation
var
  last: integer;
  count, sum: longint;

function getTime(var time: integer): integer; assembler;
asm
  MOV	AH,2CH
  INT	21H
  MOV	AL,DL
  LES	DI,time
  STOSW
end;

function timediffer: longint;
var 
  now: integer;
  tmp: longint;
begin
  if count > 10 then timediffer := sum div 10 else
  begin
    getTime(now);

    if now < last then tmp := 100 - last + now
    else tmp := now - last;


    if tmp <> 0 then
    begin
      count := count + 1;
      sum := sum + tmp;
    end;
    last := now;
    timediffer := tmp;
  end;
end;

procedure timeinit;
begin
  getTime(last);
  sum := 0;
  count := 0;
end;

begin
  timeinit;
end.
