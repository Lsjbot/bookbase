unit bbmain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus;

const
  MaxBooks = 20000;
  GLine : array[0..256] of char =
  ('1','2','3','4','5','6','7','8','9','0','1','2','3','4','5','6','7','8','9','0',
   '1','2','3','4','5','6','7','8','9','0','1','2','3','4','5','6','7','8','9','0',
   '1','2','3','4','5','6','7','8','9','0','1','2','3','4','5','6','7','8','9','0',
   '1','2','3','4','5','6','7','8','9','0','1','2','3','4','5','6','7','8','9','0',
   '1','2','3','4','5','6','7','8','9','0','1','2','3','4','5','6','7','8','9','0',
   '1','2','3','4','5','6','7','8','9','0','1','2','3','4','5','6','7','8','9','0',
   '1','2','3','4','5','6','7','8','9','0','1','2','3','4','5','6','7','8','9','0',
   '1','2','3','4','5','6','7','8','9','0','1','2','3','4','5','6','7','8','9','0',
   '1','2','3','4','5','6','7','8','9','0','1','2','3','4','5','6','7','8','9','0',
   '1','2','3','4','5','6','7','8','9','0','1','2','3','4','5','6','7','8','9','0',
   '1','2','3','4','5','6','7','8','9','0','1','2','3','4','5','6','7','8','9','0',
   '1','2','3','4','5','6','7','8','9','0','1','2','3','4','5','6','7','8','9','0',
   '1','2','3','4','5','6','7','8','9','0',chr(0),chr(0),chr(0),chr(0),chr(0),chr(0),chr(0));

  GName : array[0..70] of char = '0123456789012345678901234567890123456789012345678901234567890123456789';

  Groot : array[0..10] of char = 'Mmmmmmmmm';


type


     author_ptr = ^author_type;
     book_ptr = ^book_type;
     short_ptr = ^short_type;
     coarray = array[1..5] of author_ptr;
     author_type = record
                     name : PChar;
                     next,prev,back : author_ptr;
                     book : book_ptr;
                     cobook : book_ptr;
                     short : short_ptr;
                     coshort : short_ptr;
                     nbooks : integer;
                     nshorts : integer;
                   end;
     book_type = record
                   title : PChar;
                   author : author_ptr;
                   coauthor : coarray;
                   conext : array[1..5] of book_ptr;
                   next,prev : book_ptr;
                   publisher : pchar;
                   year_first, year_this : integer;
                   date_bought : PChar;
                   where_bought : PChar;
                   price : integer;
                   nread : integer;
                   liked_it : integer;
                   genre : integer;
                   short : short_ptr;
                   owner : integer;
                 end;

     short_type = record
                   title : PChar;
                   author : author_ptr;
                   coauthor : coarray;
                   conext : array[1..5] of short_ptr;
                   nexta,preva : short_ptr;
                   nextb,prevb : short_ptr;
                   collection : book_ptr;
                  end;

     bblist_type = array[0..MaxBooks] of book_ptr;
     sslist_type = array[0..MaxBooks] of short_ptr;

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    Saveas1: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    Report1: TMenuItem;
    Statistics1: TMenuItem;
    HTML1: TMenuItem;
    Authorlist1: TMenuItem;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Memo1: TMemo;
    Label2: TLabel;
    booklist: TMenuItem;
    Shortlist: TMenuItem;
    Options: TMenuItem;
    DebugPrint: TMenuItem;
    Booklist1: TMenuItem;
    N1: TMenuItem;
    OpenBOOKSBKB1: TMenuItem;
    procedure Open1Click(Sender: TObject);
    procedure Msg(s:string);
    procedure Init;
    procedure Loadfile;
    procedure Savefile;
    procedure SaveBook(bb:book_ptr);
    procedure SaveAuthor(aa:author_ptr);
    procedure Minustrailing(p:pchar);
    procedure NewAuthor(pname:PChar; var aa:author_ptr);
    procedure FindAutTit(var bbtit:book_ptr; aa:author_ptr; tit : PChar);
    procedure FindTitle(var bbtit:book_ptr; tit : PChar);
    procedure FindAuthor(aroot:author_ptr; p1:PChar; var aa:author_ptr;make:boolean);
    procedure FindPartial(aroot:author_ptr; p1:PChar; var aa:author_ptr;var nfound:integer);
    procedure AddBook(aa:author_ptr;coa : coarray; bname,pub :PChar; yf,yt:integer;db:PChar;wb:PChar;
                                pr,li,nr,gn,ow : integer; var bbret:book_ptr);
    procedure FindShortInBook(stitle : PChar; bb:book_ptr; var ssret : short_ptr);
    procedure FindShortByAuthor(stitle : PChar; aa:author_ptr; var ssret : short_ptr);
    procedure AddShort(aa:author_ptr;coa:coarray; bb: book_ptr; ptitle: PChar; ssret:short_ptr);
    procedure NextWord(pline:PChar;var tabpos:integer; var p:PChar);
    procedure SplitCoauthors(var p1:PChar; var aa: author_ptr; var coa: coarray);
    procedure Save1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Authorlist1Click(Sender: TObject);
    procedure HTML1Click(Sender: TObject);
    procedure Statistics1Click(Sender: TObject);
    procedure AuthorReport(aa:author_ptr; tree:boolean);
    procedure CollectStatistics(aa:author_ptr);
    procedure booklistClick(Sender: TObject);
    procedure ShortlistClick(Sender: TObject);
    procedure DebugPrintClick(Sender: TObject);
    procedure MusicInit;
    procedure Memo1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Booklist1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure OpenBOOKSBKB1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }

  end;
var
  Form1: TForm1;
bookfile,titfile,shfile,authfile : text;
author_root,aaglob : author_ptr;
book_root,bbglob : book_ptr;
short_root,ssglob : short_ptr;
coaglob : coarray;
genre_tab,gmusic_tab : array[0..30] of PChar;
bblist : ^bblist_type;
sslist : ^sslist_type;
IsMusic,numbered : boolean;
nbooks,nshorts,nauthors,iline : integer;
lihist : array[0..9] of integer;
cathist : array[0..30] of integer;
TotalPrice : LongInt;
OK_to_quit : boolean;
dbp : boolean;
firstchar : char;
iauth : integer;
ss,Gfilename : string;
owner_tab : array[0..5] of string;

implementation

uses bbauthor, bbbooklist, bbshortlist, bbnewbook, bbbookrep;

{$R *.DFM}

procedure TForm1.Open1Click(Sender: TObject);
begin
  if Memo1.Lines.Indexof('Form1.Init') >= 0 then
    begin
      MessageDlg('You cannot load a second file!',mtError,mbOKCancel,0);
      Exit;
    end;
  Init;
  if OpenDialog1.Execute then
              begin
                (** First load the file... **)
                Ss := OpenDialog1.FileName;
                Assignfile(bookfile,ss);
                Gfilename := ss;
                Reset(bookfile);
                Msg('Load starting of file '+Gfilename);
                LoadFile;
                closefile(bookfile);
                Msg('File successfully loaded');
                (** ... and then immediately save it under a random name. **)
                ss := 'backaaaa.bkb';
                randomize;
                ss[5] := chr(random(25)+97);
                ss[6] := chr(random(25)+97);
                ss[7] := chr(random(25)+97);
                ss[8] := chr(random(25)+97);
                Msg('backup file: '+ss);
                assignfile(bookfile,ss);
                rewrite(bookfile);
                SaveFile;
                closefile(bookfile);
                Msg('File successfully backed up');
                OK_to_Quit := false;
              end;

end;


procedure TForm1.MinusTrailing(p:PChar);

var p1,p2 : PChar;

begin
  p1 := StrRScan(p,' ');
  p2 := StrEnd(p);
  if ( p1 <> nil ) then
    if ( p2-p1 = 1  ) then
      begin
        p1^ := chr(0);
        MinusTrailing(p);
      end;
end; (** MinusTrailing **)

procedure TForm1.NewAuthor(pname:PChar; var aa:author_ptr);

begin
  new(aa);
  with aa^ do
    begin
      name := StrNew(pname);
      Label2.Caption := name;
      next := nil;
      prev := nil;
      back := nil;
      book := nil;
      cobook := nil;
      short := nil;
      coshort := nil;
      nbooks := 0;
      nshorts := 0;
    end;
end;

procedure TForm1.FindAutTit(var bbtit:book_ptr; aa:author_ptr; tit : PChar);

var bb : book_ptr;

begin
  if ( aa <> nil ) and ( bbtit = nil ) then
    begin
(**      writeln('FindAutTit(',aa^.name);**)
      bb := aa^.book;
      while bb <> nil do
        begin
          if ( StrComp(bb^.title,tit) = 0 ) then
            begin
              bbtit := bb;
              bb := nil;
            end
          else
            bb := bb^.next;
        end;
      if ( bbtit = nil ) then
        FindAutTit(bbtit,aa^.prev,tit);
      if ( bbtit = nil ) then
        FindAutTit(bbtit,aa^.next,tit);
    end;
end; (** FindAutTit **)

procedure TForm1.FindTitle(var bbtit:book_ptr; tit : PChar);

var aa : author_ptr;

begin
(**  writeln('In FindTitle');**)
  aa := author_root;
  bbtit := nil;
  FindAutTit(bbtit,author_root^.prev,tit);
  if ( bbtit = nil ) then
    FindAutTit(bbtit,author_root^.next,tit);
end; (** FindTitle **)


procedure TForm1.FindAuthor(aroot:author_ptr; p1:PChar; var aa:author_ptr;make:boolean);

var i : integer;
    pu1,pu2 : PChar;
begin
  pu1 := StrNew(p1);
  pu2 := StrNew(aroot^.name);
  i := StrComp(StrUpper(pu1),StrUpper(pu2));
  StrDispose(pu1);
  StrDispose(pu2);
  if ( i < 0 ) then
    begin
      if ( aroot^.prev = nil ) then
        begin
          if make then
            begin
              NewAuthor(p1,aroot^.prev);
              aroot^.prev^.back := aroot;
              aa := aroot^.prev;
            end
          else
            aa := nil;
        end
      else
        FindAuthor(aroot^.prev,p1,aa,make);
    end
  else if ( i = 0 ) then
    aa := aroot
  else
    begin
      if ( aroot^.next = nil ) then
        begin
          if make then
            begin
              NewAuthor(p1,aroot^.next);
              aroot^.next^.back := aroot;
              aa := aroot^.next;
            end
          else
            aa := nil;
        end
      else
        FindAuthor(aroot^.next,p1,aa,make);
    end;
end;

procedure TForm1.FindPartial(aroot:author_ptr; p1:PChar; var aa:author_ptr;var nfound:integer);

var i : integer;
    pu1,pu2 : PChar;
begin
  pu1 := StrNew(p1);
  pu2 := StrNew(aroot^.name);
  i := StrLComp(StrUpper(pu1),StrUpper(pu2),StrLen(pu1));
  StrDispose(pu1);
  StrDispose(pu2);
  if ( i = 0 ) then
    begin
      nfound := nfound+1;
      aa := aroot;
      if ( aroot^.prev <> nil ) then
        FindPartial(aroot^.prev,p1,aa,nfound);
      if ( aroot^.next <> nil ) then
        FindPartial(aroot^.next,p1,aa,nfound);
    end
  else if ( i < 0 ) then
    begin
      if ( aroot^.prev <> nil ) then
        FindPartial(aroot^.prev,p1,aa,nfound);
    end
  else
    begin
      if ( aroot^.next <> nil ) then
        FindPartial(aroot^.next,p1,aa,nfound);
    end
end;


procedure TForm1.AddBook(aa:author_ptr;coa : coarray; bname,pub :PChar; yf,yt:integer;db:PChar;wb:PChar;
                                pr,li,nr,gn,ow : integer; var bbret:book_ptr);

var bb,bbb,bbc : book_ptr;
    aaa : author_ptr;
    i,j,k : integer;

begin
  if dbp then
    begin
      Msg('author,bname = '+aa^.name+', '+bname);
    end;
  if ( aa^.book = nil ) then
    begin
      if dbp then
        Msg('first book');
      new(aa^.book);
      bb := aa^.book;
      if ( bb = nil ) then
        Msg('bb nil !!!');
      if dbp then
        Msg('bb ok');
      bb^.prev := nil;
    end
  else
    begin
      if dbp then
        Msg('not first book');
      bb := aa^.book;
      while bb^.next <> nil do
        bb := bb^.next;
      new(bb^.next);
      bb^.next^.prev := bb;
      bb := bb^.next;
    end;
  bbret := bb;
  with bb^ do
    begin
      title := StrNew(bname);
      author := aa;
      next := nil;
      short := nil;
      coauthor := coa;
      if dbp then
        Msg('Outer coauthorloop');
      for i := 1 to 5 do
        conext[i] := nil;
      for i := 1 to 5 do
        if ( coauthor[i] <> nil ) then
          begin
            (**
            writeln('coauthor = ',longint(coauthor[i]));
            writeln('Coauthor[',i,'] pointing');
            writeln('at ',StrPas(coauthor[i]^.name));
            **)
            bbb := coauthor[i]^.cobook;
            if ( bbb = nil ) then
              coauthor[i]^.cobook := bb
            else
              begin
                (**
                writeln('Starting bbbloop');
                writeln('bbb pointing at ',bbb^.title);
                **)
                while bbb <> nil do
                  begin
                    bbc := nil;
                    (**writeln('Inner coauthorloop');**)
                    for j := 1 to 5 do
                      if ( bbb^.coauthor[j] = coauthor[i] ) then
                        begin
                          (**writeln('Found! j=',j);       **)
                          (**writeln('conext = ',longint(conext[j]));**)
                          bbc := bbb;
                          k := j;
                        end;
                    (**writeln('After j-loop');**)
                    if ( bbc = nil ) then
                      Msg('Corrupt coauthors!')
                    else
                      bbb := bbb^.conext[k];
                  end;
                (**writeln('bbc at ',bbc^.title);**)
                bbc^.conext[k] := bb;
              end;
          end;
      if dbp then
        Msg('After coauthoring');
      publisher := StrNew(pub);
      year_first := yf;
      year_this := yt;
      date_bought := StrNew(db);
      where_bought := StrNew(wb);
      price := pr;
      liked_it := li;
      nread := nr;
      genre := gn;
      owner := ow;
    end;
end;  (** AddBook **)

procedure TForm1.FindShortInBook(stitle : PChar; bb:book_ptr; var ssret : short_ptr);

var ss : short_ptr;

begin
  ssret := nil;
  ss := bb^.short;
  while ( ss <> nil ) do
    begin
      if ( StrComp(stitle,ss^.title) = 0 ) then
        ssret := ss;
      ss := ss^.nextb;
    end;
end; (** FindShortInBook **)

procedure TForm1.FindShortByAuthor(stitle : PChar; aa:author_ptr; var ssret : short_ptr);

var ss : short_ptr;

begin
  ssret := nil;
  ss := aa^.short;
  while ( ss <> nil ) do
    begin
      if ( StrComp(stitle,ss^.title) = 0 ) then
        ssret := ss;
      ss := ss^.nexta;
    end;
end; (** FindShortByAuthor **)

procedure TForm1.AddShort(aa:author_ptr;coa:coarray; bb: book_ptr; ptitle: PChar; ssret:short_ptr);

var
    ss,sss,ssc : short_ptr;
    i,j,k : integer;

begin
  (**writeln('Coll:',bb^.title);**)
  if ( aa^.short = nil ) then
    begin
      new(aa^.short);
      ss := aa^.short;
      ss^.preva := nil;
    end
  else
    begin
      ss := aa^.short;
      while ( ss^.nexta <> nil ) do
        ss := ss^.nexta;
      new(ss^.nexta);
      ss^.nexta^.preva := ss;
      ss := ss^.nexta;
    end;
  ss^.nexta := nil;
  ss^.nextb := nil;
  if ( bb^.short = nil ) then
    begin
      bb^.short := ss;
      ss^.prevb := nil;
    end
  else
    begin
      sss := bb^.short;
      while ( sss^.nextb <> nil ) do
        sss := sss^.nextb;
      sss^.nextb := ss;
      ss^.prevb := sss;
    end;
  ssret := ss;
  with ss^ do
    begin
      title := StrNew(ptitle);
      author := aa;
      collection := bb;
      coauthor := coa;
(**      writeln('Outer coauthorloop');**)
      for i := 1 to 5 do
        conext[i] := nil;
      for i := 1 to 5 do
        if ( coauthor[i] <> nil ) then
          begin
            (**
            writeln('coauthor = ',longint(coauthor[i]));
            writeln('Coauthor[',i,'] pointing');
            writeln('at ',StrPas(coauthor[i]^.name));
            **)
            sss := coauthor[i]^.coshort;
            if ( sss = nil ) then
              coauthor[i]^.coshort := ss
            else
              begin
                (**
                writeln('Starting bbbloop');
                writeln('bbb pointing at ',bbb^.title);
                **)
                while sss <> nil do
                  begin
                    ssc := nil;
                    (**writeln('Inner coauthorloop');**)
                    for j := 1 to 5 do
                      if ( sss^.coauthor[j] = coauthor[i] ) then
                        begin
                          (**writeln('Found! j=',j);       **)
                          (**writeln('conext = ',longint(conext[j]));**)
                          ssc := sss;
                          k := j;
                        end;
                    (**writeln('After j-loop');**)
                    if ( ssc = nil ) then
                      Msg('Corrupt coauthors!')
                    else
                      sss := sss^.conext[k];
                  end;
                (**writeln('bbc at ',bbc^.title);**)
                ssc^.conext[k] := ss;
              end;
          end;
(**      writeln('After coauthoring');**)
    end;

end; (** AddShort **)

procedure TForm1.NextWord(pline:PChar;var tabpos:integer; var p:PChar);

var i,j : integer;

begin
  i := 0;
  j := 0;
  while(pline[tabpos+i+1] > chr(9)) do
    begin
      if ( j > 0 ) or ( pline[tabpos+i+1] <> ' ' ) then
        begin
          if ( j < 255 ) then
            begin
              p[j] := pline[tabpos+i+1];
              j := j+1;
            end;
        end;
      i := i+1;
    end;
  if ( pline[tabpos+i+1] <> chr(0) ) then
    tabpos := tabpos+i+1
  else
    tabpos := tabpos+i;
  p[j] := chr(0);
  i := j-1;
  while (i >= 0) and ( p[i] = ' ' ) do
    begin
      p[i] := chr(0);
      i := i-1;
    end;
end;  (** NextWord **)

procedure TForm1.SplitCoauthors(var p1:PChar; var aa: author_ptr; var coa: coarray);

var i,j,k : integer;
    p2,p3 : PChar;
    pco : array[1..5] of PChar;

begin
  (*p2 := StrNew(GName);*)
  for i := 1 to 5 do
    pco[i] := StrNew(GName);
  for i := 1 to 5 do
    coa[i] := nil;
  p2 := StrScan(p1,'&');
  if ( p2 <> nil ) then
    begin
      j := 0;
      for i := 0 to StrLen(p2)+1 do
        begin
          if ( p2[i+1] <> ' ' ) or ( j <> 0 ) then
            begin
              pco[1][j] := p2[i+1];
              j := j+1;
            end;
        end;

      p2^:= chr(0);
      i := 1;
      while ( p1[i] <> chr(0) ) do
        begin
          if ( p1[i] <> ' ' ) then
            k := i;
          i := i+1;
        end;
      i := k;
      while ( p1[i] <> chr(0) ) do
        begin
          if ( p1[i] = ' ' ) then
            p1[i] := chr(0);
          i := i+1;
        end;

      k := 1;
      (**writeln('Coauthor 1 = ',StrPas(pco[1]));**)
      while ( StrScan(pco[k],'&') <> nil ) do
        begin
          p2 := StrScan(pco[k],'&');
          j := 0;
          for i := 0 to StrLen(p2)+1 do
            if ( p2[i+1] <> ' ' ) or ( j <> 0 ) then
              begin
                pco[k+1][j] := p2[i+1];
                j := j+1;
              end;
            pco[k+1][i] := p2[i+1];
          p2^:= chr(0);
          k := k+1;
          (**writeln('Coauthor ',k,' = ',StrPas(pco[k]));**)
        end;
      (**writeln('Calling FindAuthor');**)
      for i := 1 to k do
        begin
          p3 := StrScan(pco[i],'(');
          if ( p3 <> nil ) then
            if ( StrLComp(p3,'(ed)',4) = 0 ) then
              p3^:= chr(0);
          MinusTrailing(pco[i]);
          FindAuthor(author_root,pco[i],coa[i],true);
        end;
    end;
  p3 := StrScan(p1,'(');
  if ( p3 <> nil ) then
    if ( StrLComp(p3,'(ed)',4) = 0 ) then
      p3^:= chr(0);
  MinusTrailing(p1);
  FindAuthor(author_root,p1,aa,true);

  for i := 1 to 5 do
    StrDispose(pco[i]);

end; (** SplitCoauthors **)

procedure TForm1.LoadFile;

var
aa : author_ptr;
bb : book_ptr;
ssret : short_ptr;
i,j,k,yf,yt,li,nr,gn,pr,ow : integer;
pline,ptitle,ppub,pwhere,pwhen,p1,p2 : PChar;
coa : coarray;
existed,flag : boolean;
tabpos,nbook : integer;
line,s : string[255];
IsShort : boolean;
s1:string;

begin
  pline := StrNew(GLine);
  ptitle := StrNew(GLine);
  ppub := StrNew(GLine);
  pwhere := StrNew(GLine);
  pwhen := StrNew(GLine);
  p1 := StrNew(GLine);
  p2 := StrNew(GLine);
  readln(bookfile, line);
  s := Copy(line,1,7);
  Msg(s);
  if ( s[1] = '0' ) then
    begin
      numbered := true;
      Delete(s,1,2);
    end
  else
    begin
      numbered := false;
      Delete(s,6,2);
    end;
  if ( s = 'MUSIC' ) then
    MusicInit
  else
    IsMusic := false;
  Msg(s);
  nbook := 0;
  while not Eof(bookfile) do
    begin
      readln(bookfile,line);
      if dbp then
        Msg(line);
      StrPCopy(pline,line);
      p2 := StrScan(pline,chr(9));
      if ( p2 <> nil ) then
        begin
          tabpos := -1;
          NextWord(pline,tabpos,p1);
          if numbered then
            NextWord(pline,tabpos,p1);
          if ( StrScan(p1,'#') <> nil ) then
            begin
              IsShort := true;
              NextWord(pline,tabpos,p1);
            end
          else
            IsShort := false;
          if dbp then
            Msg('Author = '+p1);
          (*if ( StrPos(p1,'Quevedo') <> nil ) then*)
          (*  dbp := true;*)
          SplitCoauthors(p1,aa,coa);
          if dbp then
            Msg('after coa');
          nbook := nbook+1;
          if (( nbook mod 20 ) = 0 ) then
            begin
              aaglob := aa;
            end;
          NextWord(pline,tabpos,ptitle);
          if not IsShort then
            begin
              NextWord(pline,tabpos,ppub);
              NextWord(pline,tabpos,pwhen);
              NextWord(pline,tabpos,p1);
              val(StrPas(p1),yf,j);
              if ( j <> 0 ) then
                yf := -1;
              NextWord(pline,tabpos,p1);
              val(StrPas(p1),yt,j);
              if ( j <> 0 ) then
                yt := -1;
              NextWord(pline,tabpos,pwhere);
              NextWord(pline,tabpos,p1);
              val(StrPas(p1),pr,j);
              if ( j <> 0 ) then
                pr := -1;
              NextWord(pline,tabpos,p1);
              val(StrPas(p1),nr,j);
              if ( j <> 0 ) then
                nr := -1;
              NextWord(pline,tabpos,p1);
              val(StrPas(p1),li,j);
              if ( j <> 0 ) then
                li := -1;
              NextWord(pline,tabpos,p1);
              gn := 0;
              for i := 0 to 30 do
                if ( StrComp(p1,genre_tab[i]) = 0 ) then
                  gn := i;
              if gn = 0 then
                for i := 0 to 30 do
                  if ( StrComp(p1,gmusic_tab[i]) = 0 ) then
                    gn := i;
              if dbp then
                Msg('Title = '+ptitle);
              NextWord(pline,tabpos,p1);
              s1 := StrPas(p1);
              ow := 0;
              for i := 0 to 5 do
                if s1 = owner_tab[i] then
                  ow := i;
              AddBook(aa,coa,ptitle,ppub,yf,yt,pwhen,pwhere,pr,li,nr,gn,ow,bb);
            end
          else
            if ( StrLen(ptitle) > 0 ) then
              AddShort(aa,coa,bb,ptitle,ssret);
        end
      else
        Msg('Invalid line');
    end;
end; (** LoadFile **)

procedure TForm1.SaveBook(bb:book_ptr);

var i,j,k : integer;
    ss : short_ptr;

begin
  with bb^do
    begin
      write(bookfile,iline:5,chr(9));
      iline := iline+1;
      write(bookfile,author^.name);
      for i := 1 to 5 do
        if ( coauthor[i] <> nil ) then
          write(bookfile,'&',coauthor[i]^.name);
      write(bookfile,chr(9),title);
      write(bookfile,chr(9),publisher);
      write(bookfile,chr(9),date_bought);
      write(bookfile,chr(9),year_first);
      write(bookfile,chr(9),year_this);
      write(bookfile,chr(9),where_bought);
      write(bookfile,chr(9),price);
      write(bookfile,chr(9),nread);
      write(bookfile,chr(9),liked_it);
      if IsMusic then
        write(bookfile,chr(9),gmusic_tab[genre])
      else
        write(bookfile,chr(9),genre_tab[genre]);
      write(bookfile,chr(9),owner_tab[owner]);
      writeln(bookfile);
      if ( short <> nil ) then
        begin
          ss := short;
          while ( ss <> nil ) do
            begin
              write(bookfile,iline:5,chr(9));
              iline := iline+1;
              write(bookfile,'#',chr(9),ss^.author^.name);
              for i := 1 to 5 do
                if ( ss^.coauthor[i] <> nil ) then
                  write(bookfile,'&',ss^.coauthor[i]^.name);
              writeln(bookfile,chr(9),ss^.title);
              ss := ss^.nextb;
            end;
        end;
    end;
end; (** SaveBook **)


procedure TForm1.SaveAuthor(aa : author_ptr);

var
    bb : book_ptr;
    i,j,k : integer;

begin
  if ( aa = nil ) then
    Exit;
  SaveAuthor(aa^.prev);
  aaglob := aa;
  bb := aa^.book;
  while bb <> nil do
    begin
      SaveBook(bb);
      bb := bb^.next;
    end;
  SaveAuthor(aa^.next);
end; (** SaveAuthor **)

procedure TForm1.SaveFile;

var aa : author_ptr;
    bb : book_ptr;
    i,j,k : integer;

begin
  Cursor := crHourglass;
  if IsMusic then
    writeln(bookfile,'0'+chr(9)+'MUSIC')
  else
    writeln(bookfile,'0'+chr(9)+'BOOKS');
  iline := 1;
  SaveAuthor(author_root^.prev);
  SaveAuthor(author_root^.next);
  Cursor := crDefault;

end;  (** SaveFile **)

procedure TForm1.init;

var i:integer;
begin
  NewAuthor(Groot,author_root);
  Msg('Form1.Init');
  OK_to_Quit := true;
  for i := 0 to 30 do
    genre_tab[i] := StrNew(Groot);
  for i := 0 to 30 do
    gmusic_tab[i] := StrNew(Groot);
  StrPCopy(genre_tab[0],'other');
  StrPCopy(genre_tab[1],'sf');
  StrPCopy(genre_tab[2],'fict');
  StrPCopy(genre_tab[3],'phys');
  StrPCopy(genre_tab[4],'chem');
  StrPCopy(genre_tab[5],'bio');
  StrPCopy(genre_tab[6],'econ');
  StrPCopy(genre_tab[7],'phil');
  StrPCopy(genre_tab[8],'rel');
  StrPCopy(genre_tab[9],'pol');
  StrPCopy(genre_tab[10],'geo');
  StrPCopy(genre_tab[11],'hist');
  StrPCopy(genre_tab[12],'nf');
  StrPCopy(genre_tab[13],'baby');
  StrPCopy(genre_tab[14],'game');
  StrPCopy(genre_tab[15],'sex');
  StrPCopy(genre_tab[16],'humor');
  StrPCopy(genre_tab[17],'biog');
  StrPCopy(genre_tab[18],'ling');
  StrPCopy(genre_tab[19],'lang');
  StrPCopy(genre_tab[20],'comp');
  StrPCopy(genre_tab[21],'other');
  StrPCopy(genre_tab[22],'other');
  StrPCopy(genre_tab[23],'other');
  StrPCopy(genre_tab[24],'other');
  StrPCopy(genre_tab[25],'other');
  StrPCopy(genre_tab[26],'other');
  StrPCopy(genre_tab[27],'other');
  StrPCopy(genre_tab[28],'other');
  StrPCopy(genre_tab[29],'other');
  StrPCopy(genre_tab[30],'other');

  StrPCopy(gmusic_tab[0],'other');
  StrPCopy(gmusic_tab[1],'pop');
  StrPCopy(gmusic_tab[2],'rock');
  StrPCopy(gmusic_tab[3],'metal');
  StrPCopy(gmusic_tab[4],'electr');
  StrPCopy(gmusic_tab[5],'class');
  StrPCopy(gmusic_tab[6],'regg');
  StrPCopy(gmusic_tab[7],'jazz');
  for i := 8 to 30 do
    StrPCopy(gmusic_tab[7],'other');

  for i := 0 to 5 do
    owner_tab[i] := 'none';
  owner_tab[0] := 'Sverker';
  owner_tab[1] := 'Irma';
  owner_tab[2] := 'Daniel';

  bblist := nil;
  sslist := nil;
  aaglob := nil;
  bbglob := nil;
  ssglob := nil;

  dbp := false;

end; (** Init **)

procedure TForm1.Msg(s:string);
begin
  Memo1.Lines.Add(s);
end;

procedure TForm1.Save1Click(Sender: TObject);
begin
            ss := GFilename;
            Assignfile(bookfile,ss);
            Rewrite(bookfile);
            Msg('Save started of '+ss);
            SaveFile;
            closefile(bookfile);
            Msg('File successfully saved');
            OK_to_quit := true;

end;

procedure TForm1.Saveas1Click(Sender: TObject);
begin
  SaveDialog1.Filename := GFilename;
  if SaveDialog1.Execute then
    begin
      GFilename := SaveDialog1.FileName;
      Save1Click(Sender);
    end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  if not OK_to_quit then
    if ( MessageDlg('Quit without saving changes?',mtError,mbOKCancel,0) = mrOK ) then
      OK_to_Quit := true;
  if OK_to_Quit then
    Close;
end;

procedure TForm1.Authorlist1Click(Sender: TObject);
begin
  Msg('Before Formauthor.setup');
  FormAuthor.Setup;
  Msg('After Formauthor.setup, before show');
  FormAuthor.Show;
  Msg('After show');
end;

procedure TForm1.AuthorReport(aa:author_ptr; tree:boolean);

var bb : book_ptr;
    ss : short_ptr;
    fname : string[127];
    i,j,k : integer;
    p : PChar;
    folder : string;

begin
  if (aa <> nil) then
    begin
      if tree then
        AuthorReport(aa^.prev,tree);
      writeln(bookfile);
      if IsMusic then
        folder := 'music\'
      else
        folder := 'books\';
      fname := folder+'auth0000.htm';
      for i := 1 to 4 do
        begin
          if ( aa^.name[i-1] in ['a'..'z'] ) then
            fname[i+6] := aa^.name[i-1]
          else if ( aa^.name[i-1] in ['A'..'Z'] ) then
            fname[i+6] := aa^.name[i-1]
          else
            fname[i+6] := 'x';
        end;
      if ( aa^.name[0] <> firstchar ) then
        begin
          firstchar := aa^.name[0];
          Msg(firstchar);
        end;
      iauth := iauth+1;
      i := iauth;
      k := 14;
      while ( i > 0 ) do
        begin
          j := i - 10*(i div 10);
          fname[k] := chr(j+ord('0'));
          k := k-1;
          i := i div 10;
        end;
      if ( iauth < 20 ) then
        Msg(fname);
      writeln(bookfile,'<li> <a href="',fname,'"> ',aa^.name,'</A>');
      (*writeln(fname);*)
      assignfile(authfile,fname);
      rewrite(authfile);
      writeln(authfile,'<HTML>');
      writeln(authfile,'<HEAD>');
      writeln(authfile,'<TITLE>By ',aa^.name,' in Sverker Johansson''s collection</TITLE>');
      writeln(authfile,'</HEAD>');
      writeln(authfile,'<BODY>');
      writeln(bookfile);
      writeln(authfile,'<h1>',aa^.name,'</h1>');
      bb := aa^.book;
      if ( aa^.short <> nil ) or ( aa^.coshort <> nil ) then
        if ( aa^.book <> nil ) or ( aa^.cobook <> nil ) then
          if IsMusic then
            writeln(authfile,'<p> Records: <p>')
          else
            writeln(authfile,'<p> Books: <p>');
      if ( bb <> nil ) then
        begin
          writeln(authfile,'<ul>');

(**            writeln('Entering main-authored books');**)
          while bb <> nil do
            begin
              writeln(authfile,'<li>',bb^.title);
              bb := bb^.next;
            end;
          writeln(authfile,'</ul>');
        end;
      if ( aa^.cobook <> nil ) then
        begin
(**            writeln('Entering co-authored books');**)
          bb := aa^.cobook;
          writeln(authfile,'<ul>');
          while bb <> nil do
            begin
              writeln(authfile,'<li> ',bb^.title);
              k := 0;
              for i := 1 to 5 do
                if ( bb^.coauthor[i] = aa ) then
                  begin
                    k := i;
                  end;
              if ( k = 0 ) then
                begin
                  writeln(authfile,'Corrupt coauthor');
                  bb := nil;
                end
              else
                bb := bb^.conext[k];
            end;
          writeln(authfile,'</ul>');
(**            writeln('Done with coauthored');**)
        end;
      if ( aa^.short <> nil ) or ( aa^.coshort <> nil ) then
        if ( aa^.book <> nil ) or ( aa^.cobook <> nil ) then
          if IsMusic then
            writeln(authfile,'<p> Songs: <p>')
          else
            writeln(authfile,'<p> Short stories: <p>');
      p := StrNew(GLine);
      ss := aa^.short;
      if ( ss <> nil ) then
        begin
          writeln(authfile,'<ul>');
          while ss <> nil do
            begin
              StrCopy(p,ss^.title);
              repeat
                p := StrCat(p,' ');
              until ( StrLen(p) > 40 );
              p := StrCat(p,'  in: ');
              p := StrCat(p,ss^.collection^.title);
              writeln(authfile,'<li>     ',p);
              ss := ss^.nexta;
            end;
          writeln(authfile,'</ul>');
        end;
      if ( aa^.coshort <> nil ) then
        begin
          ss := aa^.coshort;
          writeln(authfile,'<ul>');
          while ss <> nil do
            begin
              StrCopy(p,ss^.title);
              repeat
                p := StrCat(p,' ');
              until ( StrLen(p) > 40 );
              p := StrCat(p,'  in: ');
              p := StrCat(p,ss^.collection^.title);
              writeln(authfile,'<li>     ',p);
              k := 0;
              for i := 1 to 5 do
                if ( ss^.coauthor[i] = aa ) then
                  begin
                    k := i;
                  end;
              if ( k = 0 ) then
                begin
                  Msg('Corrupt coauthor');
                  ss := nil;
                end
              else
                ss := ss^.conext[k];
            end;
          writeln(authfile,'</ul>');
(**            writeln('Done with coauthored');**)
        end;
      StrDispose(p);
      writeln(authfile,'</BODY>');
      writeln(authfile,'</HTML>');
      closefile(authfile);

      if tree then
        AuthorReport(aa^.next,tree);

    end;
end; (*AuthorReport *)

procedure TForm1.HTML1Click(Sender: TObject);
var ss:string;
begin
            Cursor := crHourglass;
            Msg('Making html');
            firstchar := 'A';
            Msg(firstchar);
            if IsMusic then
              ss := 'musiclist.htm'
            else
              ss := 'authlist.htm';
            assignfile(bookfile,ss);
            rewrite(bookfile);
            writeln(bookfile,'<HTML>');
            writeln(bookfile,'<HEAD>');
            if IsMusic then
              writeln(bookfile,'<TITLE>Music collection of Sverker Johansson</TITLE>')
            else
              writeln(bookfile,'<TITLE>Book collection of Sverker Johansson</TITLE>');
            writeln(bookfile,'</HEAD>');
            writeln(bookfile,'<BODY>');
            if IsMusic then
              begin
                writeln(bookfile,'<h1>Music collection of Sverker Johansson</h1>');
                writeln(bookfile,'<h2>Alphabetical by Artist</h2>');
              end
            else
              begin
                writeln(bookfile,'<h1>Book collection of Sverker Johansson</h1>');
                writeln(bookfile,'<h2>Alphabetical by Author</h2>');
              end;
            iauth := 0;
            writeln(bookfile,'<ul>');
            AuthorReport(author_root^.prev,true);
            AuthorReport(author_root^.next,true);
            writeln(bookfile,'</ul>');
            writeln(bookfile,'</body>');
            writeln(bookfile,'</html>');
            closefile(bookfile);
            Cursor := crDefault;
            Msg('Done!');

end;


procedure TForm1.CollectStatistics(aa:author_ptr);

var bb:book_ptr;
    sh : short_ptr;

begin
  if ( aa^.prev <> nil ) then
    CollectStatistics(aa^.prev);
  (*writeln('CollectStatistis(',aa^.name,')');*)
  nauthors := nauthors+1;
  bb := aa^.book;
  while bb <> nil do
    begin
      nbooks := nbooks+1;
      (**
      lihist[bb^.liked_it] := lihist[bb^.liked_it] + 1;
      cathist[bb^.genre] := cathist[bb^.genre] + 1;
      **)
      TotalPrice := TotalPrice + bb^.price;
      sh := bb^.short;
      while sh <> nil do
        begin
          nshorts := nshorts+1;
          sh := sh^.nextb;
        end;
      bb := bb^.next;
    end;
  if ( aa^.next <> nil ) then
    CollectStatistics(aa^.next);
end; (** CollectStatistics **)

procedure TForm1.Statistics1Click(Sender: TObject);
var i,j,k:integer;
begin
            Msg('idStatistics');
            Cursor := crHourglass;
            nbooks := 0;
            nshorts := 0;
            nauthors := 0;
            TotalPrice := 0;
            for i := 0 to 9 do
              lihist[i] := 0;
            for i := 0 to 30 do
              cathist[i] := 0;
            CollectStatistics(author_root^.prev);
            CollectStatistics(author_root^.next);
            Msg('After CollectStatistics');
            Msg('# authors      : '+inttostr(nauthors));
            Msg('# books        : '+inttostr(nbooks));
            Msg('# short stories: '+inttostr(nshorts));
            Cursor := crDefault;
end;

procedure TForm1.booklistClick(Sender: TObject);
begin
  aaglob := nil;
  Formlist.Setup;
  Formlist.Show;
end;

procedure TForm1.ShortlistClick(Sender: TObject);
begin
  aaglob := nil;
  bbglob := nil;
  Formshortlist.Setup;
  Formshortlist.Show;
end;

procedure TForm1.DebugPrintClick(Sender: TObject);
begin
  DebugPrint.Checked := true;
  dbp := true;
end;

procedure TForm1.MusicInit;
begin
  Formbook.Label1.Caption := 'Artist';
  FormBook.ButtonAddshort.Caption := 'Add song';
  FormBook.ButtonListshort.Caption := 'List songs';
  Authorlist1.Caption := 'Artist list';
  Booklist.Caption := 'Record list';
  Booklist1.Caption := 'Record list';
  Shortlist.Caption := 'Song list';
  IsMusic := true;

end;


procedure TForm1.Memo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Label2.Caption := InttoStr(ord(Key));
end;

procedure TForm1.Booklist1Click(Sender: TObject);
begin
  aaglob := nil;
  bbglob := nil;
  Formbookreport.Setup;
  Formbookreport.Show;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
  if Memo1.Lines.Indexof('Form1.Init') >= 0 then
    begin
      MessageDlg('You cannot load a second file!',mtError,mbOKCancel,0);
      Exit;
    end;
  Init;
                (** First load the file... **)
                Ss := 'C:\Bookbase\music.bkb';
                Assignfile(bookfile,ss);
                Gfilename := ss;
                Reset(bookfile);
                Msg('Load starting of file '+Gfilename);
                LoadFile;
                closefile(bookfile);
                Msg('File successfully loaded');
                (** ... and then immediately save it under a random name. **)
                ss := 'mbakaaaa.bkb';
                randomize;
                ss[5] := chr(random(25)+97);
                ss[6] := chr(random(25)+97);
                ss[7] := chr(random(25)+97);
                ss[8] := chr(random(25)+97);
                Msg('backup file: '+ss);
                assignfile(bookfile,ss);
                rewrite(bookfile);
                SaveFile;
                closefile(bookfile);
                Msg('File successfully backed up');
                OK_to_Quit := false;

end;

procedure TForm1.OpenBOOKSBKB1Click(Sender: TObject);
begin
  if Memo1.Lines.Indexof('Form1.Init') >= 0 then
    begin
      MessageDlg('You cannot load a second file!',mtError,mbOKCancel,0);
      Exit;
    end;
  Init;
                (** First load the file... **)
                Ss := 'C:\Bookbase\books.bkb';
                Assignfile(bookfile,ss);
                Gfilename := ss;
                Reset(bookfile);
                Msg('Load starting of file '+Gfilename);
                LoadFile;
                closefile(bookfile);
                Msg('File successfully loaded');
                (** ... and then immediately save it under a random name. **)
                ss := 'bbakaaaa.bkb';
                randomize;
                ss[5] := chr(random(25)+97);
                ss[6] := chr(random(25)+97);
                ss[7] := chr(random(25)+97);
                ss[8] := chr(random(25)+97);
                Msg('backup file: '+ss);
                assignfile(bookfile,ss);
                rewrite(bookfile);
                SaveFile;
                closefile(bookfile);
                Msg('File successfully backed up');
                OK_to_Quit := false;

end;

end.
