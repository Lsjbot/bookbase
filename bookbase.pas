
program Bookbase;

{$S-}
{$R bookbase.RES}

uses WinTypes, WinProcs, WinDos, Strings, FileDlgs, WinCrt;

const
  AppName = 'BookBase';
  MaxBooks = 4000;

const

  id_OK     = 1;
  id_Cancel = 999;
  id_New    = 100;
  id_Open   = 101;
  id_Save   = 102;
  id_SaveAs = 103;
  id_OpenShort = 104;
  id_Exit   = 199;
  id_About  = 401;

  id_Author = 201;
  id_BookList   = 202;
  id_NewBook  = 203;
  id_ShortList = 204;

  id_RepDef = 301;
  id_RepList = 302;
  id_Statistics = 303;

  ida_ListBox   = 101;
  ida_ListBooks = 102;
  ida_ListShorts= 103;
  ida_NewBook   = 104;
  ida_NBooks    = 107;
  ida_AutText   = 106;
  ida_LikedThem = 108;
  ida_NewAuthor = 105;


  idb_Author    = 101;
  idb_Title     = 102;
  idb_Publisher = 103;
  idb_YearFirst = 104;
  idb_YearThis  = 105;
  idb_BoughtWhere = 106;
  idb_BoughtWhen  = 107;
  idb_LikedIt     = 111;
  idb_Coauthor    = 110;
  idb_Colist      = 109;
  idb_Price       = 108;
  idb_ListShorts  = 113;
  idb_Shorts      = 114;

  idb_Cat1 =   112;
  idb_CatMax = 126;

  idbl_Edit = 102;
  idbl_NewBook = 103;
  idbl_ListShorts = 104;

  idc_ListBox = 104;
  idc_Title   = 102;
  idc_Another = 103;
  idc_Author  = 105;

  ids_Author = 101;
  ids_Title  = 102;
  ids_Another= 103;
  ids_Done   = 104;

  idst_Books = 101;
  idst_Shorts = 102;
  idst_Authors = 103;
  idst_Price = 104;


const
  GFileName: array[0..fsPathName] of Char = '';
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


type author_ptr = ^author_type;
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

var bookfile,titfile,shfile,authfile : text;
author_root,aaglob : author_ptr;
book_root,bbglob : book_ptr;
short_root,ssglob : short_ptr;
coaglob : coarray;
genre_tab : array[0..30] of PChar;
bblist : ^bblist_type;
sslist : ^sslist_type;
nbooks,nshorts,nauthors : integer;
lihist : array[0..9] of integer;
cathist : array[0..30] of integer;
TotalPrice : LongInt;
OK_to_quit : boolean;
dbp : boolean;
iauth : integer;



function About(Dialog: HWnd; Message, WParam: Word;
  LParam: Longint): Bool; export;
begin
  About := True;
  case Message of
    wm_InitDialog:
      Exit;
    wm_Command:
      if (WParam = id_Ok) or (WParam = id_Cancel) then
      begin
        EndDialog(Dialog, 1);
        Exit;
      end;
  end;
  About := False;
end; (** About **)

procedure MinusTrailing(p:PChar);

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

procedure NewAuthor(pname:PChar; var aa:author_ptr);

begin
  new(aa);
  with aa^ do
    begin
      name := StrNew(pname);
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

procedure FindAutTit(var bbtit:book_ptr; aa:author_ptr; tit : PChar);

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

procedure FindTitle(var bbtit:book_ptr; tit : PChar);

var aa : author_ptr;

begin
(**  writeln('In FindTitle');**)
  aa := author_root;
  bbtit := nil;
  FindAutTit(bbtit,author_root^.prev,tit);
  if ( bbtit = nil ) then
    FindAutTit(bbtit,author_root^.next,tit);
end; (** FindTitle **)


procedure FindAuthor(aroot:author_ptr; p1:PChar; var aa:author_ptr;make:boolean);

var i : integer;
begin
  i := StrComp(p1,aroot^.name);
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

procedure AddBook(aa:author_ptr;coa : coarray; bname,pub :PChar; yf,yt:integer;db:PChar;wb:PChar;
                                pr,li,nr,gn : integer; var bbret:book_ptr);

var bb,bbb,bbc : book_ptr;
    aaa : author_ptr;
    i,j,k : integer;

begin
  if dbp then
    begin
      writeln('author,bname = ',aa^.name,bname);
      writeln('In add_book; yf,yt,price = ',yf:4,yt:4,pr:4);
    end;
  if ( aa^.book = nil ) then
    begin
      if dbp then
        writeln('first book');
      new(aa^.book);
      bb := aa^.book;
      if ( bb = nil ) then
        writeln('bb nil !!!');
      if dbp then
        writeln('bb ok');
      bb^.prev := nil;
    end
  else
    begin
      if dbp then
        writeln('not first book');
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
        writeln('Outer coauthorloop');
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
                      writeln('Corrupt coauthors!')
                    else
                      bbb := bbb^.conext[k];
                  end;
                (**writeln('bbc at ',bbc^.title);**)
                bbc^.conext[k] := bb;
              end;
          end;
      if dbp then
        writeln('After coauthoring');
      publisher := StrNew(pub);
      year_first := yf;
      year_this := yt;
      date_bought := StrNew(db);
      where_bought := StrNew(wb);
      price := pr;
      liked_it := li;
      nread := nr;
      genre := gn;
    end;
end;  (** AddBook **)

procedure FindShortInBook(stitle : PChar; bb:book_ptr; var ssret : short_ptr);

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

procedure FindShortByAuthor(stitle : PChar; aa:author_ptr; var ssret : short_ptr);

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

procedure AddShort(aa:author_ptr;coa:coarray; bb: book_ptr; ptitle: PChar; ssret:short_ptr);

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
                      writeln('Corrupt coauthors!')
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

procedure NextWord(pline:PChar;var tabpos:integer; var p:PChar);

var i,j : integer;

begin
  i := 0;
  j := 0;
  while(pline[tabpos+i+1] > chr(9)) do
    begin
      if ( j > 0 ) or ( pline[tabpos+i+1] <> ' ' ) then
        begin
          p[j] := pline[tabpos+i+1];
          j := j+1;
        end;
      i := i+1;
    end;
  tabpos := tabpos+i+1;
  p[j] := chr(0);
  i := j-1;
  while (i >= 0) and ( p[i] = ' ' ) do
    begin
      p[i] := chr(0);
      i := i-1;
    end;
end;  (** NextWord **)

procedure SplitCoauthors(var p1:PChar; var aa: author_ptr; var coa: coarray);

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

procedure LoadShorts;

var pline,ptitle,p1,p2,pcoll : PChar;
    coa,coed : coarray;
    tabpos : integer;
    aa,ed : author_ptr;
    bb : book_ptr;
    line : String;
    ssret : short_ptr;

begin
  pline := StrNew(GLine);
  ptitle := StrNew(GName);
  p1 := StrNew(GName);
  p2 := StrNew(GName);
  pcoll := StrNew(GName);

  while not eof(bookfile) do
    begin
      writeln(MemAvail, 'free memory');
      readln(bookfile,line);
      writeln(line);
      StrPCopy(pline,line);
      p2 := StrScan(pline,chr(9));
      if ( p2 <> nil ) then
        begin
          tabpos := -1;
          NextWord(pline,tabpos,p1);
          (**writeln('Calling coauthors');**)
          SplitCoauthors(p1,aa,coa);
          (**writeln('Back from coauthors');**)
          NextWord(pline,tabpos,ptitle);
          NextWord(pline,tabpos,p2);
          SplitCoauthors(p2,ed,coed);
          NextWord(pline,tabpos,pcoll);
          bb := nil;
          FindAutTit(bb,ed,pcoll);
          if ( bb = nil ) then
            FindTitle(bb,pcoll);
          if ( bb = nil ) then
            begin
(**              writeln('Collection not found for short');**)
(**              writeln('story ',ptitle);**)
(**              writeln('by ',p1);**)
(**              writeln('Before AddBook ',pcoll);**)
              StrPCopy(p2,'???');
              AddBook(ed,coed,pcoll,p2,0,0,p2,p2,0,0,1,0,bb);
(**              writeln('After  AddBook ',bb^.title);**)
            end;
(**          writeln('Calling AddShort');**)
          AddShort(aa,coa,bb,ptitle,ssret);
          FindShortInBook(ptitle,bb,ssret);
          if ( ssret = nil ) then
            begin
              writeln('ERROR! ',ptitle,' not found');
              writeln('in coll ',bb^.title);
              readln;
            end;
          FindShortByAuthor(ptitle,aa,ssret);
          if ( ssret = nil ) then
            begin
              writeln('ERROR! ',ptitle,' not found');
              writeln('in author ',aa^.name);
              readln;
            end;
        end;
    end;
end; (** LoadShorts **)
  
procedure LoadFile(Window:HWnd);

var
aa : author_ptr;
bb : book_ptr;
ssret : short_ptr;
i,j,k,yf,yt,li,nr,gn,pr : integer;
pline,ptitle,ppub,pwhere,pwhen,p1,p2 : PChar;
coa : coarray;
existed,flag : boolean;
tabpos,nbook : integer;
line,s : string[255];
IsShort : boolean;

begin
  pline := StrNew(GLine);
  ptitle := StrNew(GName);
  ppub := StrNew(GName);
  pwhere := StrNew(GName);
  pwhen := StrNew(GName);
  p1 := StrNew(GName);
  p2 := StrNew(GName);
  nbook := 0;
  while not Eof(bookfile) do
    begin
      readln(bookfile,line);
      if dbp then
        writeln(line);
      StrPCopy(pline,line);
      p2 := StrScan(pline,chr(9));
      if ( p2 <> nil ) then
        begin
          tabpos := -1;
          NextWord(pline,tabpos,p1);
          if ( StrScan(p1,'#') <> nil ) then
            begin
              IsShort := true;
              NextWord(pline,tabpos,p1);
            end
          else
            IsShort := false;
          if dbp then
            writeln('Author = ',p1);
          (*if ( StrPos(p1,'Quevedo') <> nil ) then*)
          (*  dbp := true;*)
          SplitCoauthors(p1,aa,coa);
          if dbp then
            writeln('after coa');
          nbook := nbook+1;
          if (( nbook mod 20 ) = 0 ) then
            begin
              aaglob := aa;
              InvalidateRect(Window,nil,false);
              UpdateWindow(Window);
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
              if dbp then
                writeln('Title = ',ptitle);
              AddBook(aa,coa,ptitle,ppub,yf,yt,pwhen,pwhere,pr,li,nr,gn,bb);
            end
          else
            AddShort(aa,coa,bb,ptitle,ssret);
        end
      else
        writeln('Invalid line');
    end;
end; (** LoadFile **)

procedure SaveBook(bb:book_ptr);

var i,j,k : integer;
    ss : short_ptr;

begin
  with bb^do
    begin
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
      writeln(bookfile,chr(9),genre_tab[genre]);
      if ( short <> nil ) then
        begin
          ss := short;
          while ( ss <> nil ) do
            begin
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


procedure SaveAuthor(aa : author_ptr; Window:HWnd);

var
    bb : book_ptr;
    i,j,k : integer;

begin
  if ( aa = nil ) then
    Exit;
  SaveAuthor(aa^.prev,Window);
  aaglob := aa;
  InvalidateRect(Window,nil,false);
  UpdateWindow(Window);
  bb := aa^.book;
  while bb <> nil do
    begin
      SaveBook(bb);
      bb := bb^.next;
    end;
  SaveAuthor(aa^.next,Window);
end; (** SaveAuthor **)



procedure SaveFile(Window: HWnd);

var aa : author_ptr;
    bb : book_ptr;
    i,j,k : integer;

begin
  SaveAuthor(author_root^.prev,Window);
  SaveAuthor(author_root^.next,Window);
end;



procedure FillCoAutListBox(Dialog:HWnd; aa:author_ptr);

var li : LongInt;

begin
  if ( aa <> nil ) then
    begin
      if ( aa^.prev <> nil ) then
        FillCoAutListBox(Dialog,aa^.prev);
      li := SendDlgItemMessage(Dialog,idc_ListBox,lb_AddString,word(0),LongInt(aa^.name));
      if ( aa^.next <> nil ) then
        FillCoAutListBox(Dialog,aa^.next);
    end;
end; (** FillCOAutListBox **)

function CoAuthorBox(Dialog: HWnd; Message, WParam: Word;
  LParam: Longint): Bool; export;

var s : string;
    p : PChar;
    i,j,k : integer;
    li,lj : LongInt;
    aa : author_ptr;
    bb : book_ptr;
begin
  CoAuthorBox := True;
  p := StrNew(GLine);
  case Message of
    wm_InitDialog:   
      begin
        FillCoAutListBox(Dialog,author_root^.prev);
        FillCoAutListBox(Dialog,author_root^.next);
        Exit;
      end;
    wm_Command:
      (***
      if ( WParam > 200 ) then
        begin
          s := ' ';
          s[1] := chr(ord('A')+WParam-201);
          StrPCopy(p,s);
          li := SendDlgItemMessage(Dialog,ida_ListBox,lb_SelectString,word(-1),LongInt(p));
          if ( li >= 0 ) then
            begin
              lj := SendDlgItemMessage(Dialog,ida_ListBox,lb_GetText,word(li),longint(p));
              SetDlgItemText(Dialog,ida_AutText,p);
            end;
        end
      else
      ***)
       case WParam of
        idc_ListBox:
          begin
            li := SendDlgItemMessage(Dialog,idc_ListBox,lb_GetCurSel,word(0),LongInt(0));
            if ( li >= 0 ) then
              begin
                lj := SendDlgItemMessage(Dialog,idc_ListBox,lb_GetText,word(li),longint(p));
                SetDlgItemText(Dialog,idc_Author,p);
              end
            else
              begin
(**                writeln('idcListBox but no selection');**) 
              end;
          end;
        id_OK,idc_Another:
          begin
            GetDlgItemText(Dialog,idc_Author,p,240);
            (**writeln('Selected author from text: ',StrPas(p));**)
            if ( StrLen(p) > 0 ) then
              begin
                FindAuthor(author_root,p,aa,true);
                if ( aa = nil ) then
(**                  writeln('Author not found!')**)
                else
                  begin
                    k := 1;
                    while coaglob[k] <> nil do
                      k := k+1;
                    coaglob[k] := aa;
(**                    writeln('Coaglob[',k:1,'] pointing');**)
(**                    writeln('at ',StrPas(coaglob[k]^.name));**)
                  end;
              end;
            if ( WParam = id_OK ) then
              EndDialog(Dialog, 1);
            Exit;
          end;
        id_Cancel:
          begin
            EndDialog(Dialog, 1);
            Exit;
          end;
      end;
  end;
  CoAuthorBox := False;
  StrDispose(p);
end; (** CoAuthorBox **)


function ShortBox(Dialog: HWnd; Message, WParam: Word;
  LParam: Longint): Bool; export;

var s : string;
    pa,pt : PChar;
    i,j,k : integer;
    li,lj : LongInt;
    aa : author_ptr;
    bb : book_ptr;
    ss : Short_ptr;
    coa : coarray;
begin
  ShortBox := True;
  case Message of
    wm_InitDialog:   
      begin
        SetDlgItemText(Dialog,ids_Author,aaglob^.name);
        Exit;
      end;
    wm_Command:
       case WParam of
        ids_Done,ids_Another:
          begin
            pa := StrNew(GLine);
            pt := StrNew(GLine);
            i := GetDlgItemText(Dialog,ids_Author,pa,240);
            j := GetDlgItemText(Dialog,ids_Title,pt,240);
            if ( i > 0 ) and ( j > 0 ) then
              begin
                SplitCoauthors(pa,aa,coa);
                AddShort(aa,coa,bbglob,pt,ss);
              end;
            if ( WParam = ids_Done ) then
              EndDialog(Dialog, 1)
            else
              SetDlgItemText(Dialog,ids_Title,'');
            StrDispose(pa);
            StrDispose(pt);
            Exit;
          end;
      end;
  end;
  ShortBox := False;
end; (** ShortBox **)


function NewBook(Dialog: HWnd; Message, WParam: Word;
  LParam: Longint): Bool; export;

var s : string;
    p : PChar;
    MinP,MaxP,pos : integer;
    li,lj : LongInt;
    i,j,k,lk,nr,gn : integer;
    yf,yt,pr : word;
    pline,ptitle,ppub,pwhere,pwhen,p1,p2,pauthor : PChar;
    aa : author_ptr;
    bb : book_ptr;
    flag : PBool;
    CoAuthorProc, ShortProc : TFarProc;
begin
  NewBook := True;
  (***
  writeln('In NewBook; Message,Wparam = ',Message,' ',Wparam);
  writeln('wminit = ',wm_initdialog);
  writeln('wmcommand = ',wm_command);
  ***)

  case Message of
    wm_InitDialog:
      begin
        if ( aaglob <> nil ) then
          SetDlgItemText(Dialog,idb_Author,aaglob^.name);
        if ( bbglob <> nil ) then
          begin
            SetDlgItemText(Dialog,idb_Author,bbglob^.author^.name);
            SetDlgItemText(Dialog,idb_Title,bbglob^.title);
            SetDlgItemText(Dialog,idb_Publisher,bbglob^.publisher);
            SetDlgItemText(Dialog,idb_BoughtWhere,bbglob^.where_bought);
            SetDlgItemInt(Dialog,idb_YearFirst,bbglob^.year_first,true);
            SetDlgItemInt(Dialog,idb_YearThis,bbglob^.year_this,true);
            SetDlgItemText(Dialog,idb_BoughtWhen,bbglob^.date_bought);
            SetDlgItemInt(Dialog,idb_Price,bbglob^.price,true);
            SetDlgItemInt(Dialog,idb_YearFirst,bbglob^.year_first,true);
            for i := 1 to 5 do
              if ( bbglob^.coauthor[i] <> nil ) then
                li := SendDlgItemMessage(Dialog,idb_Colist,lb_AddString,word(0),LongInt(bbglob^.coauthor[i]^.name));
          end;
      
        p := StrNew(GLine);
        StrPCopy(p,'Unread');
        li := SendDlgItemMessage(Dialog,idb_LikedIt,lb_AddString,word(0),LongInt(p));
        for i := 1 to 9 do
          begin
            StrPCopy(p,chr(ord('0')+i));
            li := SendDlgItemMessage(Dialog,idb_LikedIt,lb_AddString,word(0),LongInt(p));
          end;
        StrPCopy(p,'Science fiction');
        li := SendDlgItemMessage(Dialog,idb_Cat1,lb_AddString,word(0),LongInt(p));
        StrPCopy(p,'General fiction');
        li := SendDlgItemMessage(Dialog,idb_Cat1,lb_AddString,word(0),LongInt(p));
        StrPCopy(p,'Physics');
        li := SendDlgItemMessage(Dialog,idb_Cat1,lb_AddString,word(0),LongInt(p));
        StrPCopy(p,'Chemistry');
        li := SendDlgItemMessage(Dialog,idb_Cat1,lb_AddString,word(0),LongInt(p));
        StrPCopy(p,'Biology');
        li := SendDlgItemMessage(Dialog,idb_Cat1,lb_AddString,word(0),LongInt(p));
        StrPCopy(p,'Economics');
        li := SendDlgItemMessage(Dialog,idb_Cat1,lb_AddString,word(0),LongInt(p));
        StrPCopy(p,'Philosophy');
        li := SendDlgItemMessage(Dialog,idb_Cat1,lb_AddString,word(0),LongInt(p));
        StrPCopy(p,'Religion');
        li := SendDlgItemMessage(Dialog,idb_Cat1,lb_AddString,word(0),LongInt(p));
        StrPCopy(p,'Politics');
        li := SendDlgItemMessage(Dialog,idb_Cat1,lb_AddString,word(0),LongInt(p));
        StrPCopy(p,'Geography');
        li := SendDlgItemMessage(Dialog,idb_Cat1,lb_AddString,word(0),LongInt(p));
        StrPCopy(p,'History');
        li := SendDlgItemMessage(Dialog,idb_Cat1,lb_AddString,word(0),LongInt(p));
        StrPCopy(p,'Other nonfiction');
        li := SendDlgItemMessage(Dialog,idb_Cat1,lb_AddString,word(0),LongInt(p));
        StrPCopy(p,'Baby care');
        li := SendDlgItemMessage(Dialog,idb_Cat1,lb_AddString,word(0),LongInt(p));
        StrPCopy(p,'Games');
        li := SendDlgItemMessage(Dialog,idb_Cat1,lb_AddString,word(0),LongInt(p));
        StrPCopy(p,'Sex');
        li := SendDlgItemMessage(Dialog,idb_Cat1,lb_AddString,word(0),LongInt(p));
        StrPCopy(p,'Humor');
        li := SendDlgItemMessage(Dialog,idb_Cat1,lb_AddString,word(0),LongInt(p));
        StrPCopy(p,'Biographies');
        li := SendDlgItemMessage(Dialog,idb_Cat1,lb_AddString,word(0),LongInt(p));
        StrPCopy(p,'Linguistics');
        li := SendDlgItemMessage(Dialog,idb_Cat1,lb_AddString,word(0),LongInt(p));
        StrPCopy(p,'Languages');
        li := SendDlgItemMessage(Dialog,idb_Cat1,lb_AddString,word(0),LongInt(p));
        StrPCopy(p,'Computers');
        li := SendDlgItemMessage(Dialog,idb_Cat1,lb_AddString,word(0),LongInt(p));
        if ( bbglob = nil ) then
          begin
            li := SendDlgItemMessage(Dialog,idb_LikedIt,lb_SetCurSel,word(0),LongInt(0));
            li := SendDlgItemMessage(Dialog,idb_Cat1,lb_SetCurSel,word(0),LongInt(0));
            for i := 1 to 5 do
              coaglob[i] := nil;
          end
        else
          begin
            li := SendDlgItemMessage(Dialog,idb_LikedIt,lb_SetCurSel,word(bbglob^.liked_it),LongInt(0));
            li := SendDlgItemMessage(Dialog,idb_Cat1,lb_SetCurSel,word(bbglob^.genre-1),LongInt(0));
            coaglob := bbglob^.coauthor;
          end;
        for i := 1 to 5 do
          begin
(**           writeln('coaglob = ',longint(coaglob[i]));**)
(**
            if ( coaglob[i] <> nil ) then
              begin
                writeln('Coa[',i,'] pointing');
                writeln('at ',StrPas(coaglob[i]^.name));
              end;
              **)
          end;

        StrDispose(p);
        Exit;
      end;
    wm_Command:
      case WParam of
        idb_Coauthor :
          begin
            (**
            for i := 1 to 5 do
              begin
                writeln('coa = ',longint(coaglob[i]));
                if ( coaglob[i] <> nil ) then
                  begin
                    writeln('Coa[',i,'] pointing');
                    writeln('at ',StrPas(coaglob[i]^.name));
                  end;
              end;
          **)
            CoAuthorProc := MakeProcInstance(@CoAuthorBox, HInstance);
            DialogBox(HInstance, 'CoAuthor', Dialog, CoAuthorProc);
            FreeProcInstance(CoAuthorProc);
(**            writeln('Back from cobox');**)
            (****
            for i := 1 to 5 do
              begin
                writeln('coa = ',longint(coaglob[i]));
                if ( coaglob[i] <> nil ) then
                  begin
                    writeln('Coaglob[',i,'] pointing');
                    writeln('at ',StrPas(coaglob[i]^.name));
                  end;
              end;
            **)
            li := SendDlgItemMessage(Dialog,idb_Colist,lb_ResetContent,word(0),longint(0));
            for i := 1 to 5 do
              if ( coaglob[i] <> nil ) then
                li := SendDlgItemMessage(Dialog,idb_Colist,lb_AddString,word(0),LongInt(coaglob[i]^.name));

(**            writeln('Colist fixed');**)
            
            Exit;
          end;
        id_OK,idb_Shorts:
          begin
            writeln('Before getting..');
            if ( bbglob = nil ) then
              begin
                ptitle := StrNew(GName);
                ppub := StrNew(GName);
                pwhere := StrNew(GName);
                pwhen := StrNew(GRoot);
                (**p1 := StrNew(GLine);**)
                i := GetDlgItemText(Dialog,idb_Title,ptitle,50);
                writeln('i,title = ',i,ptitle);
                i := GetDlgItemText(Dialog,idb_Publisher,ppub,50);
                writeln('i,publisher = ',i,ppub);
                i := GetDlgItemText(Dialog,idb_BoughtWhere,pwhere,50);
                writeln('i,where = ',i,pwhere);
                i := GetDlgItemText(Dialog,idb_BoughtWhen,pwhen,10);
                writeln('i,when = ',i,pwhen);

                new(flag);
                yf := GetDlgItemInt(Dialog,idb_YearFirst,flag,true);
                if not flag^ then
                  writeln('Error from getting yf');
                yt := GetDlgItemInt(Dialog,idb_YearThis,flag,true);
                if not flag^ then
                  writeln('Error from getting yt');
                pr := GetDlgItemInt(Dialog,idb_Price,flag,true);
                if not flag^ then
                  writeln('Error from getting pr');
              end;
            li := SendDlgItemMessage(Dialog,idb_LikedIt,lb_getcursel,word(0),LongInt(0));
            lk := li;
            li := SendDlgItemMessage(Dialog,idb_Cat1,lb_getcursel,word(0),LongInt(0));
            gn := li+1;
            nr := 1;
            writeln('After getting; yf,yt,pr,lk,gn = ');
            writeln(yf,' ',yt,' ',pr,' ',lk,' ',gn);
            if ( bbglob = nil ) then
              begin
                if ( aaglob = nil ) then
                  begin
                    pauthor := StrNew(GName);
                    i := GetDlgItemText(Dialog,idb_Author,pauthor,50);
                    FindAuthor(author_root,pauthor,aaglob,true);
                  end;
                AddBook(aaglob,coaglob,ptitle,ppub,yf,yt,pwhen,pwhere,pr,lk,nr,gn,bbglob);
              end
            else with bbglob^ do
              begin
                writeln('Modifying ',title);
                (***
                StrDispose(title);
                title := StrNew(ptitle);
                StrDispose(publisher);
                publisher := StrNew(ppub);
                StrDispose(date_bought);
                date_bought := StrNew(pwhen);
                StrDispose(where_bought);
                where_bought := StrNew(pwhere);
                year_first := yf;
                year_this := yt;
                price := pr;
                **)
                liked_it := lk;
                genre := gn;
              end;
            writeln('Done!');
            if ( WParam = id_OK ) then
              EndDialog(Dialog, 1)
            else (** idb_Shorts **)
              begin
                if ( aaglob = nil ) then
                  aaglob := bbglob^.author;
                ShortProc := MakeProcInstance(@ShortBox, HInstance);
                DialogBox(HInstance, 'AddShort', Dialog, ShortProc);
                FreeProcInstance(ShortProc);
              end;
            Exit;
          end;
        id_Cancel:
          begin
            
            EndDialog(Dialog, 1);
            Exit;
          end;
      end;
  end;
  NewBook := false;
end;  (** NewBook **)

procedure AddTitleList(aa:author_ptr; Dialog:HWnd; idlb : integer);

var bb : book_ptr;
    li : LongInt;

begin
  if ( aa <> nil ) then
    begin
      AddTitleList(aa^.prev,Dialog,idlb);
      bb := aa^.book;
      if ( bb <> nil ) then
        begin
          while bb <> nil do
            begin
(**              writeln(bb^.title);**)
              li := SendDlgItemMessage(Dialog,idlb,lb_AddString,word(0),LongInt(bb^.title));
              if (( li mod 100 ) = 0 ) then 
                writeln('li = ',li);
              if ( li > 2990 ) then
                writeln('li TOO LARGE  = ',li);
              bblist^[li] := bb;
              bb := bb^.next;
            end;
        end;
      AddTitleList(aa^.next,Dialog,idlb);
    end;

end; (** AddTitleList **)

function ShortList(Dialog: HWnd; Message, WParam: Word;
  LParam: Longint): Bool; export;

var s : string;
    p : PChar;
    i,j,k : integer;
    li,lj : LongInt;
    aa : author_ptr;
    ss : short_ptr;
    NewBookProc : TFarProc;
begin
  ShortList := True;
  if ( sslist = nil ) then
    new(sslist);
  (**writeln('Booklist; Message,Wparam= ',message,' ',wparam);**)
case Message of
   wm_InitDialog:
     begin
      p := StrNew(GLine);
      if ( aaglob <> nil ) then
       begin
        ss := aaglob^.short;
        if ( ss <> nil ) then
          begin
            while ss <> nil do
              begin
                StrCopy(p,ss^.title);
                repeat
                  p := StrCat(p,' ');
                until ( StrLen(p) > 50 );
                p := StrCat(p,'  in: ');
                p := StrCat(p,ss^.collection^.title);
                li := SendDlgItemMessage(Dialog,ida_ListBox,lb_AddString,word(0),LongInt(p));
                sslist^[li] := ss;
                ss := ss^.nexta;
              end;
          end;
        if ( aaglob^.coshort <> nil ) then
          begin
            ss := aaglob^.coshort;
            while ss <> nil do
              begin
                StrCopy(p,ss^.title);
                repeat
                  p := StrCat(p,' ');
                until ( StrLen(p) > 50 );
                p := StrCat(p,'  in: ');
                p := StrCat(p,ss^.collection^.title);
                li := SendDlgItemMessage(Dialog,ida_ListBox,lb_AddString,word(0),LongInt(p));
                sslist^[li] := ss;
                k := 0;
                for i := 1 to 5 do
                  if ( ss^.coauthor[i] = aaglob ) then
                    begin
                      k := i;
                    end;
                if ( k = 0 ) then
                  begin
                    writeln('Corrupt coauthor');
                    ss := nil;
                  end
                else
                  ss := ss^.conext[k]; 
              end;
(**            writeln('Done with coauthored');**)
          end;
        if ( aaglob^.short = nil ) and ( aaglob^.coshort = nil ) then
          li := SendDlgItemMessage(Dialog,ida_ListBox,lb_AddString,word(0),LongInt(StrNew('(no shorts)')));
        Exit;
       end
     else if ( bbglob <> nil ) then
       begin
        ss := bbglob^.short;
        if ( ss <> nil ) then
          begin
            while ss <> nil do
              begin
                StrCopy(p,ss^.title);
                repeat
                  p := StrCat(p,' ');
                until ( StrLen(p) > 50 );
                p := StrCat(p,'  by: ');
                p := StrCat(p,ss^.author^.name);
                li := SendDlgItemMessage(Dialog,ida_ListBox,lb_AddString,word(0),LongInt(p));
                sslist^[li] := ss;
                ss := ss^.nextb;
              end;
          end
        else
          li := SendDlgItemMessage(Dialog,ida_ListBox,lb_AddString,word(0),LongInt(StrNew('(no shorts)')));
      end
     else
      begin
        (**
        AddTitleList(author_root^.prev,Dialog,ida_ListBox);
        AddTitleList(author_root^.next,Dialog,ida_ListBox);
        **)
      end;
     StrDispose(p);
     Exit;
    end;
  wm_Command:
      case WParam of
        id_OK:
          begin
            dispose(sslist);
            sslist := nil;
            EndDialog(Dialog, 1);
            Exit;
          end;
        (**
        idbl_Edit:
          begin
            p := StrNew(GLine);
            li := SendDlgItemMessage(Dialog,ida_ListBox,lb_GetCurSel,word(0),LongInt(0));
            if ( li >= 0 ) then
              begin
                bbglob := bblist^[li];
                NewBookProc := MakeProcInstance(@NewBook, HInstance);
                DialogBox(HInstance, 'NewBook', Dialog, NewBookProc);
                FreeProcInstance(NewBookProc);
              end;
            StrDispose(p);
            exit;
          end;
        idbl_NewBook:
          begin
            bbglob := nil;
            NewBookProc := MakeProcInstance(@NewBook, HInstance);
            DialogBox(HInstance, 'NewBook', Dialog, NewBookProc);
            FreeProcInstance(NewBookProc);
          end;
        **)
      end;
  end;
  ShortList := false;
end; (** ShortList **)


function BookList(Dialog: HWnd; Message, WParam: Word;
  LParam: Longint): Bool; export;

var s : string;
    p : PChar;
    i,j,k : integer;
    li,lj : LongInt;
    aa,aatemp : author_ptr;
    bb : book_ptr;
    NewBookProc,ShortListProc : TFarProc;
begin
  BookList := True;
  if ( bblist = nil ) then
    new(bblist);
  (**writeln('Booklist; Message,Wparam= ',message,' ',wparam);**)
case Message of
   wm_InitDialog:
    if ( aaglob <> nil ) then
      begin
        bb := aaglob^.book;
        if ( bb <> nil ) then
          begin
(**            writeln('Entering main-authored books');**)
            while bb <> nil do
              begin
(**                writeln(bb^.title);**)
                li := SendDlgItemMessage(Dialog,ida_ListBox,lb_AddString,word(0),LongInt(bb^.title));
                bblist^[li] := bb;
                bb := bb^.next;
              end;
          end
        else if ( aaglob^.cobook <> nil ) then
          begin
(**            writeln('Entering co-authored books');**)
            bb := aaglob^.cobook;
            while bb <> nil do
              begin
(**                writeln(bb^.title);**)
                li := SendDlgItemMessage(Dialog,ida_ListBox,lb_AddString,word(0),LongInt(bb^.title));
                bblist^[li] := bb;
                k := 0;
                for i := 1 to 5 do
                  if ( bb^.coauthor[i] = aaglob ) then
                    begin
                      k := i;
                    end;
                if ( k = 0 ) then
                  begin
                    writeln('Corrupt coauthor');
                    bb := nil;
                  end
                else
                  bb := bb^.conext[k]; 
              end;
(**            writeln('Done with coauthored');**)
          end
        else
          li := SendDlgItemMessage(Dialog,ida_ListBox,lb_AddString,word(0),LongInt(StrNew('(no books)')));
        Exit;
      end
    else
      begin
        AddTitleList(author_root^.prev,Dialog,ida_ListBox);
        AddTitleList(author_root^.next,Dialog,ida_ListBox);
      end;
  wm_Command:
      case WParam of
        id_OK:
          begin
            dispose(bblist);
            bblist := nil;
            EndDialog(Dialog, 1);
            Exit;
          end;
        
        idbl_Edit:
          begin
            p := StrNew(GLine);
            li := SendDlgItemMessage(Dialog,ida_ListBox,lb_GetCurSel,word(0),LongInt(0));
            if ( li >= 0 ) then
              begin
                bbglob := bblist^[li];
                NewBookProc := MakeProcInstance(@NewBook, HInstance);
                DialogBox(HInstance, 'NewBook', Dialog, NewBookProc);
                FreeProcInstance(NewBookProc);
              end
            else
              begin
                (**writeln('id_Edit but no selection');**) 
              end;
            StrDispose(p);
            exit;
          end;
        idbl_NewBook:
          begin
            bbglob := nil;
            NewBookProc := MakeProcInstance(@NewBook, HInstance);
            DialogBox(HInstance, 'NewBook', Dialog, NewBookProc);
            FreeProcInstance(NewBookProc);
          end;
        idbl_ListShorts:
          begin
            p := StrNew(GLine);
            li := SendDlgItemMessage(Dialog,ida_ListBox,lb_GetCurSel,word(0),LongInt(0));
            if ( li >= 0 ) then
              begin
                aatemp := aaglob;
                aaglob := nil;
                bbglob := bblist^[li];
                ShortListProc := MakeProcInstance(@ShortList, HInstance);
                DialogBox(HInstance, 'ShortList', Dialog, ShortListProc);
                FreeProcInstance(ShortListProc);
                aaglob := aatemp;
              end;
          end;
      end;
  end;
  BookList := false;
end; (** BookList **)

procedure AuthorReport(aa:author_ptr; tree:boolean);

var bb : book_ptr;
    ss : short_ptr;
    fname : string[127];
    i,j,k : integer;
    p : PChar;

begin
  if (aa <> nil) then
    begin
      if tree then
        AuthorReport(aa^.prev,tree);
      writeln(bookfile);
      fname := 'html\auth0000.htm';
      for i := 1 to 4 do
        begin
          if ( aa^.name[i-1] in ['a'..'z'] ) then
            fname[i+5] := aa^.name[i-1]
          else if ( aa^.name[i-1] in ['A'..'Z'] ) then
            fname[i+5] := aa^.name[i-1]
          else
            fname[i+5] := 'x';
        end;
      iauth := iauth+1;
      i := iauth;
      k := 8;
      while ( i > 0 ) do
        begin
          j := i - 10*(i div 10);
          fname[k] := chr(j+ord('0'));
          k := k-1;
          i := i div 10;
        end;
      writeln(bookfile,'<li> <a href="',fname,'"> ',aa^.name,'</A>');
      writeln(fname);
      assign(authfile,fname);
      rewrite(authfile);
      writeln(authfile,'<HTML>');
      writeln(authfile,'<HEAD>');
      writeln(authfile,'<TITLE>',aa^.name,'</TITLE>');
      writeln(authfile,'</HEAD>');
      writeln(authfile,'<BODY>');
      writeln(authfile,'<h1>',aa^.name,'</h1>');
      bb := aa^.book;
      if ( aa^.short <> nil ) or ( aa^.coshort <> nil ) then
        if ( aa^.book <> nil ) or ( aa^.cobook <> nil ) then
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
                  writeln('Corrupt coauthor');
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
      close(authfile);

      if tree then
        AuthorReport(aa^.next,tree);

    end;
end; (*AuthorReport *)



procedure FillAutListBox(Dialog:HWnd; aa:author_ptr);

var li : LongInt;

begin
  if ( aa <> nil ) then
    begin
      if ( aa^.prev <> nil ) then
        FillAutListBox(Dialog,aa^.prev);
      li := SendDlgItemMessage(Dialog,ida_ListBox,lb_AddString,word(0),LongInt(aa^.name));
      if ( aa^.next <> nil ) then
        FillAutListBox(Dialog,aa^.next);
    end;
end;

function AuthorBox(Dialog: HWnd; Message, WParam: Word;
  LParam: Longint): Bool; export;

var s : string;
    p : PChar;
    i : integer;
    li,lj : LongInt;
    aa : author_ptr;
    bb : book_ptr;
    BookListProc,NewBookProc,ShortListProc : TFarProc;
    nbooks,likedsum : integer;
begin
  AuthorBox := True;
  p := StrNew(GLine);
  case Message of
    wm_InitDialog:   
      begin
        FillAutListBox(Dialog,author_root^.prev);
        FillAutListBox(Dialog,author_root^.next);
        Exit;
      end;
    wm_Command:
      if ( WParam > 200 ) then
        begin
          s := ' ';
          s[1] := chr(ord('A')+WParam-201);
          (**writeln('Authors starting with ',s);**)
          StrPCopy(p,s);
          li := SendDlgItemMessage(Dialog,ida_ListBox,lb_SelectString,word(-1),LongInt(p));
          if ( li >= 0 ) then
            begin
              lj := SendDlgItemMessage(Dialog,ida_ListBox,lb_GetText,word(li),longint(p));
              SetDlgItemText(Dialog,ida_AutText,p);
            end;
        end
      else
       case WParam of
        id_OK:
          begin
            EndDialog(Dialog, 1);
            Exit;
          end;
        id_Cancel:
          begin
            EndDialog(Dialog, 1);
            Exit;
          end;
        ida_ListBox:
          begin
            li := SendDlgItemMessage(Dialog,ida_ListBox,lb_GetCurSel,word(0),LongInt(0));
            if ( li >= 0 ) then
              begin
                lj := SendDlgItemMessage(Dialog,ida_ListBox,lb_GetText,word(li),longint(p));
                SetDlgItemText(Dialog,ida_AutText,p);
                FindAuthor(author_root,p,aa,false);
                if ( aa = nil ) then
                  writeln('Author not found!')
                else
                  begin
                    nbooks := 0;
                    likedsum := 0;
                    bb := aa^.book;
                    while bb <> nil do
                      begin
                        nbooks := nbooks+1;
                        likedsum := likedsum + bb^.liked_it;
                        bb := bb^.next;
                      end;
                    if ( nbooks > 0 ) then
                      i := likedsum div nbooks
                    else
                      i := 0;
                    writeln('nbooks,likedsum,i = ',nbooks,' ',likedsum,' ',i);
                    SetDlgItemInt(Dialog,ida_NBooks,nbooks,false);
                    (**if ( nbooks > 0 ) then**)
                      SetDlgItemInt(Dialog,ida_LikedThem,i,false);
                  end;
              end
            else
              begin
(**                writeln('idaListBox but no selection');**) 
              end;
          end;
        ida_ListBooks:
          begin
            GetDlgItemText(Dialog,ida_AutText,p,240);
            (**writeln('Selected author from text: ',StrPas(p));**)
            if ( StrLen(p) > 0 ) then
              begin
                FindAuthor(author_root,p,aa,false);
                if ( aa = nil ) then
                  writeln('Author not found!')
                else
                  begin
                    aaglob := aa;
                    BooklistProc := MakeProcInstance(@BookList, HInstance);
                    DialogBox(HInstance, 'BookList', Dialog, BookListProc);
                    FreeProcInstance(BookListProc);
                    Exit;
                  end;
              end;
            exit;
          end;
        ida_ListShorts:
          begin
            GetDlgItemText(Dialog,ida_AutText,p,240);
            (**writeln('Selected author from text: ',StrPas(p));**)
            if ( StrLen(p) > 0 ) then
              begin
                FindAuthor(author_root,p,aa,false);
                if ( aa = nil ) then
                  writeln('Author not found!')
                else
                  begin
                    aaglob := aa;
                    ShortlistProc := MakeProcInstance(@ShortList, HInstance);
                    DialogBox(HInstance, 'ShortList', Dialog, ShortListProc);
                    FreeProcInstance(ShortListProc);
                    Exit;
                  end;
              end;
            exit;
          end;
        ida_NewBook:
          begin
            GetDlgItemText(Dialog,ida_AutText,p,240);
            (**writeln('Selected author from text: ',StrPas(p));**)
            if ( StrLen(p) > 0 ) then
              begin
                FindAuthor(author_root,p,aa,true);
                aaglob := aa;
                bbglob := nil;
                (**writeln('ida_NewBook');**)
                NewBookProc := MakeProcInstance(@NewBook, HInstance);
                DialogBox(HInstance, 'NewBook', Dialog, NewBookProc);
                FreeProcInstance(NewBookProc);
                Exit;
              end;
            exit;

          end;
        ida_NewAuthor:
          begin
            aaglob := nil;
            bbglob := nil;
            NewBookProc := MakeProcInstance(@NewBook, HInstance);
            DialogBox(HInstance, 'NewBook', Dialog, NewBookProc);
            FreeProcInstance(NewBookProc);
            Exit;
          end;

      end;
  end;
  AuthorBox := False;
  StrDispose(p);
end; (** AuthorBox **)


function StatBox(Dialog: HWnd; Message, WParam: Word;
  LParam: Longint): Bool; export;

var s : string;
    p : PChar;
    i : integer;
begin
  StatBox := True;
  case Message of
    wm_InitDialog:   
      begin
        SetDlgItemInt(Dialog,idst_Books,nbooks,false);
        SetDlgItemInt(Dialog,idst_Shorts,nshorts,false);
        SetDlgItemInt(Dialog,idst_Authors,nauthors,false);
        SetDlgItemInt(Dialog,idst_Price,TotalPrice,false);
        Exit;
      end;
    wm_Command:
      case WParam of
        id_OK:
          begin
            EndDialog(Dialog, 1);
            Exit;
          end;
        id_Cancel:
          begin
            EndDialog(Dialog, 1);
            Exit;
          end;
      end;
  end;
  StatBox := False;
end; (** AuthorBox **)

procedure CollectStatistics(aa:author_ptr);

var bb:book_ptr;
    sh : short_ptr;

begin
  if ( aa^.prev <> nil ) then
    CollectStatistics(aa^.prev);
  writeln('CollectStatistis(',aa^.name,')');
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

function MainWndProc(Window: HWnd; Message, WParam: Word;
  LParam: Longint): Longint; export;
var
  AboutProc,AuthorProc,BookProc,StatProc: TFarProc;
  DC: HDC;
  PS: TPaintStruct;
  P: PChar;
  S: array[0..127] of Char;
  ss : string[127];
  flag : boolean;
  i,j,k : integer;
  aa : author_ptr;
  bb : book_ptr;
  sh : short_ptr;


begin
  MainWndProc := 0;
  case Message of
    wm_Command:
      case WParam of
        id_Open:
          begin
            flag := DoFileOpen(Window, StrCopy(GFileName, '*.bkb'));
            if flag then
              begin
                (** First load the file... **)
                Ss := StrPas(GFileName);
                Assign(bookfile,ss);
                Reset(bookfile);
                LoadFile(Window);
                close(bookfile);
                (** ... and then immediately save it under a random name. **) 
                ss := 'backaaaa.bkb';
                randomize;
                ss[5] := chr(random(25)+97);
                ss[6] := chr(random(25)+97);
                ss[7] := chr(random(25)+97);
                ss[8] := chr(random(25)+97);
                writeln('backup file: ',ss);
                assign(bookfile,ss);
                rewrite(bookfile);
                SaveFile(Window);
                close(bookfile);
                InvalidateRect(Window, nil, True);
              end;
            Exit;
          end;
        id_OpenShort: 
          begin
            DoFileOpen(Window, StrCopy(GFileName, '*.bkb'));
            Ss := StrPas(GFileName);
            Assign(bookfile,ss);
            Reset(bookfile);
            LoadShorts;
            close(bookfile);
            InvalidateRect(Window, nil, True);
            Exit;
          end;
        id_Save, id_SaveAs:
          begin
            if ( WParam = id_SaveAs ) then
              begin
                flag := DoFileSave(Window, GFileName);
                if not flag then
                  Exit;
              end;
            Ss := StrPas(GFileName);
(**            writeln('Returned filename is ',ss);**)
            Assign(bookfile,ss);
            Rewrite(bookfile);
(**            writeln('Save started');**)
            SaveFile(Window);
            close(bookfile);
(**            writeln('File successfully saved');**)
            OK_to_quit := true;
            InvalidateRect(Window, nil, True);
            Exit;
          end;
        id_Exit:
          begin
            if OK_to_quit then
              SendMessage(Window, wm_Close, 0, 0);
            Exit;
          end;
        id_About:
          begin
            AboutProc := MakeProcInstance(@About, HInstance);
            DialogBox(HInstance, 'AboutBox', Window, AboutProc);
            FreeProcInstance(AboutProc);
            Exit;
          end;
        id_Author:
          begin
            OK_to_quit := false;
            AuthorProc := MakeProcInstance(@AuthorBox, HInstance);
            DialogBox(HInstance, 'Author', Window, AuthorProc);
            FreeProcInstance(AuthorProc);
            Exit;
          end;
        id_BookList:
          begin
            OK_to_quit := false;
            aaglob := nil;
            BookProc := MakeProcInstance(@BookList, HInstance);
            DialogBox(HInstance, 'BookList', Window, BookProc);
            FreeProcInstance(BookProc);
            Exit;
          end;
        id_NewBook:
          begin
            OK_to_quit := false;
            aaglob := nil;
            bbglob := nil;
            BookProc := MakeProcInstance(@NewBook, HInstance);
            DialogBox(HInstance, 'NewBook', Window, BookProc);
            FreeProcInstance(BookProc);
            Exit;
          end;
        id_RepList:
          begin
            ss := 'authlist.htm';
            assign(bookfile,ss);
            rewrite(bookfile);
            writeln(bookfile,'<HTML>');
            writeln(bookfile,'<HEAD>');
            writeln(bookfile,'<TITLE> Author List</TITLE>');
            writeln(bookfile,'</HEAD>');
            writeln(bookfile,'<BODY>');
            writeln(bookfile,'<h1>Alphabetical by Author</h1>');
            iauth := 0;
            writeln(bookfile,'<ul>');
            AuthorReport(author_root^.prev,true);
            AuthorReport(author_root^.next,true);
            writeln(bookfile,'</ul>');
            writeln(bookfile,'</body>');
            writeln(bookfile,'</html>');
            close(bookfile);
          end;
        id_Statistics:
          begin
            writeln('idStatistics');
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
            writeln('After CollectStatistics');
            StatProc := MakeProcInstance(@StatBox, HInstance);
            DialogBox(HInstance, 'StatBox', Window, StatProc);
            FreeProcInstance(StatProc);
            Exit;
          end;
      end;

    wm_Paint:
      begin
        DC := BeginPaint(Window, PS);
        P := @GFileName;
        TextOut(DC, 10, 10, S, WVSPrintF(S, 'File name:  %s', P));
        if ( aaglob <> nil ) then
          TextOut(DC, 10, 30, S, WVSPrintF(S, 'Author:  %s',aaglob^.name));
        EndPaint(Window, PS);
      end;
    wm_Destroy:
      begin
        DoneWinCrt;
        PostQuitMessage(0);
        Exit;
      end;
  end;
  MainWndProc := DefWindowProc(Window, Message, WParam, LParam);
end;

procedure InitApplication;
const
  WindowClass: TWndClass = (
    style: 0;
    lpfnWndProc: @MainWndProc;
    cbClsExtra: 0;
    cbWndExtra: 0;
    hInstance: 0;
    hIcon: 0;
    hCursor: 0;
    hbrBackground: 0;
    lpszMenuName: AppName;
    lpszClassName: AppName);
begin
  WindowClass.hInstance := HInstance;
  WindowClass.hIcon := LoadIcon(0, idi_Application);
  WindowClass.hCursor := LoadCursor(0, idc_Arrow);
  WindowClass.hbrBackground := GetStockObject(white_Brush);
  if not RegisterClass(WindowClass) then Halt(1);
end;

procedure InitInstance;
var
  Window: HWnd;
begin
  Window := CreateWindow(
    AppName,
    'BookBase',
    ws_OverlappedWindow or ws_hscroll or ws_vscroll,
    260,
    20,
    cw_UseDefault,
    cw_UseDefault,
    0,
    0,
    HInstance,
    nil);
  if Window = 0 then Halt(1);
  ShowWindow(Window, CmdShow);
  UpdateWindow(Window);
end;

procedure WinMain;
var
  Message: TMsg;
begin
  if HPrevInst = 0 then InitApplication;
  InitInstance;
  while GetMessage(Message, 0, 0, 0) do
  begin
    TranslateMessage(Message);
    DispatchMessage(Message);
  end;
  Halt(Message.wParam);
end; (** WinMain ***)

procedure init;

var i:integer;
begin
  WindowOrg.x := 0;
  WindowOrg.Y := 20;
  WindowSize.X := 250;
  WindowSize.Y := 580;

  InitWinCrt;
  NewAuthor(Groot,author_root);
  for i := 0 to 30 do
    genre_tab[i] := StrNew(Groot);
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
  StrPCopy(genre_tab[17],'bio');
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

  bblist := nil;
  sslist := nil;
  aaglob := nil;
  bbglob := nil;
  ssglob := nil;

  dbp := false;
end; (** Init **)

begin
  init;
  WinMain;
end.
