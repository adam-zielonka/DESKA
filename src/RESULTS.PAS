unit results;
interface
var   
  name: string;
  result: word;

procedure readBestResult;
procedure writeBestResult(_name: string; _result: word);

implementation

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
  readBestResult;
end;

end.
