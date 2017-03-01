unit readOne;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
    infile: file of char;
    outfile: text;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var i,j,k: integer;
    c : char;
    c1,c2,c3 : char;

begin
 memo1.lines.add('starting');
 Assignfile(outfile,'c:\bookbase\music.asc');
 memo1.lines.add('After assign');
(* {$I-}  *)
 Rewrite(outfile);
 IF IOResult <> 0 then
 Begin
  memo1.lines.add('File error  during rewrite.');
  halt(0);
 end;
{$I+}
 memo1.lines.add('Before second assign');
 Assignfile(infile,'c:\bookbase\music.one');
 Reset(infile);
 k := 0;
 j := 0;
 memo1.lines.add('Starting loop');
 while (not EOF(infile)) and ( k < 9999 ) do
   begin
     read(infile,c);
     if ( c = chr(0) ) then
       begin
         read(infile,c1);
         if ( c1 = chr(0) ) then
           begin
             write(outfile,' ; ');
             read(infile,c1);
           end;
         if ( c1 = chr($f2) ) then
           begin
             for i := 1 to 7 do
               read(infile,c);
             writeln(outfile);
             j := 0;
             k := k+1;
             memo1.lines.add(inttostr(k));
           end
         else if ( c1 > chr($19) ) then
           write(outfile,' ; ',c1);
       end
     else if ( c = chr($f2) ) then
       begin
         for i := 1 to 7 do
           read(infile,c);
         writeln(outfile);
         k := k+1;
         memo1.lines.add(inttostr(k));
         j := 0;
       end
     else
       write(outfile,c);
   end;
 closefile(outfile);

 Close;

end;

end.
