program readbase;

uses Wincrt;

var i,j,k: integer;
    infile: file of char;
    outfile: text;
    c : char;
    c1,c2,c3 : char;

begin
writeln('starting');
 Assign(outfile,'c:\windows\bookbase\shorts.asc');
 writeln('After assign');
(* {$I-}  *)
 Rewrite(outfile);
 IF IOResult <> 0 then
 Begin
  WriteLn('File error  during rewrite.');
  halt(0);
 end;
{$I+}
 writeln('Before second assign');
 Assign(infile,'c:\windows\bookbase\shorts.one');
 Reset(infile);
 k := 0;
 j := 0;
 writeln('Starting loop');
 while (not EOF(infile)) and ( k < 9999 ) do
   begin
     read(infile,c);
     if ( c = chr(0) ) then
      begin
       if ( j = 0 ) then
         begin
           j := 1;
           read(infile,c1);
           if ( c1 = chr(0) ) then
             begin
              read(infile,c2);
              write(outfile,' ; ');
             end
         end
       else
        begin
         read(infile,c1);
         if ( c1 = chr($f2) ) then
           begin
             for i := 1 to 7 do
               read(infile,c);
             writeln(outfile);
             j := 0;
             k := k+1;
             writeln(k);
           end
         else 
           write(outfile,' ; ',c1);
        end
      end
     else if ( c = chr($f2) ) then
       begin
         for i := 1 to 7 do
           read(infile,c);
         writeln(outfile);
         k := k+1;
         writeln(k);
         j := 0;
       end
     else
       write(outfile,c);
   end;
 close(outfile);
end.