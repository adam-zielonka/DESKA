unit keys;
interface
const 
  KEY_ESC = 1;
  KEY_LEFT = 75;
  KEY_RIGHT = 77;
  KEY_SPACE = 57;
  KEY_ENTER = 28;

function key: byte;
procedure resetKey;

implementation

function key: byte;
begin
  key := PORT[$60];
end;

procedure resetKey;
begin
  PORT[$60] := 0;
end;

end.
