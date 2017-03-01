unit bbauthor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,bbmain;

type
  TFormAuthor = class(TForm)
    ListBox1: TListBox;
    Booklistbutton: TButton;
    Shortlistbutton: TButton;
    Newbookbutton: TButton;
    Newauthorbutton: TButton;
    Button5: TButton;
    abut: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Button23: TButton;
    Button24: TButton;
    Button25: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    RenameButton: TButton;
    procedure Setup;
    procedure Button5Click(Sender: TObject);
    procedure abutClick(Sender: TObject);
    procedure FillAutListBox(aa:author_ptr);
    procedure ListBox1Click(Sender: TObject);
    procedure FindAuthor(aroot:author_ptr; p1:PChar; var aa:author_ptr;make:boolean);
    procedure BooklistbuttonClick(Sender: TObject);
    procedure NewAuthor(pname:PChar; var aa:author_ptr);
    procedure NewbookbuttonClick(Sender: TObject);
    procedure NewauthorbuttonClick(Sender: TObject);
    procedure ShortlistbuttonClick(Sender: TObject);
    procedure Stripnumbers(pp:PChar);
    procedure RenameButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAuthor: TFormAuthor;

implementation

uses bbbooklist, bbnewbook, bbshortlist;

{$R *.DFM}

procedure TFormAuthor.FillAutListBox(aa:author_ptr);
var sss:string;
    bb : book_ptr;
    ss : short_ptr;
    nbooks, nshorts,likedsum,i,j,k : integer;
begin
  if ( aa <> nil ) then
    begin
      if ( aa^.prev <> nil ) then
        FillAutListBox(aa^.prev);

                    nbooks := 0;
                    likedsum := 0;
                    bb := aa^.book;
                    while bb <> nil do
                      begin
                        nbooks := nbooks+1;
                        bb := bb^.next;
                      end;
                    nshorts := 0;
                    ss := aa^.short;
                    while ss <> nil do
                      begin
                        nshorts := nshorts+1;
                        ss := ss^.nexta;
                      end;
                    ss := aa^.coshort;
                    while ss <> nil do
                      begin
                        nshorts := nshorts+1;
                        k := 0;
                        for i := 1 to 5 do
                          if ( ss^.coauthor[i] = aa ) then
                            k := i;
                        if ( k = 0 ) then
                          begin
                            writeln('Corrupt coauthor');
                            ss := nil;
                          end
                        else
                          ss := ss^.conext[k];
                      end;
      sss := aa^.name+'  ';
      repeat
        sss := sss+' ';
      until length(sss) > 35;
      if nbooks > 0 then
        sss := sss + Inttostr(nbooks);
      repeat
        sss := sss+' ';
      until length(sss) > 40;
      if nshorts > 0 then
        sss := sss+Inttostr(nshorts);
      Listbox1.Items.Add(sss);
      if ( aa^.next <> nil ) then
        FillAutListBox(aa^.next);
    end;
end;

procedure TFormAuthor.Setup;
begin
  Listbox1.Items.Clear;
  FillAutListBox(author_root^.prev);
  FillAutListBox(author_root^.next);

  if IsMusic then
    begin
      Label1.Caption := '# records';
      Label3.Caption := '# songs';
      Booklistbutton.Caption := 'List records';
      Shortlistbutton.Caption := 'List songs';
      Newbookbutton.Caption := 'New record';
      Newauthorbutton.Caption := 'New artist';
    end;
end;

procedure TFormAuthor.Button5Click(Sender: TObject);
begin
  Close;
end;

procedure TFormAuthor.abutClick(Sender: TObject);
var c:char;
    i,j,k : integer;
begin
  c := (Sender as TButton).Caption[1];
  for i := Listbox1.Items.Count-1 downto 0 do
    if ( c = Listbox1.Items[i][1] ) then
      k := i;
  Listbox1.Topindex := k;
end;

procedure TFormAuthor.NewAuthor(pname:PChar; var aa:author_ptr);

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
end; (** newauthor **)


procedure TFormAuthor.FindAuthor(aroot:author_ptr; p1:PChar; var aa:author_ptr;make:boolean);

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
end; (* Findauthor *)


procedure TFormAuthor.ListBox1Click(Sender: TObject);
var nbooks,i,j,k,likedsum,nshorts : integer;
    aa : author_ptr;
    bb : book_ptr;
    ss : short_ptr;
    pp : PChar;

begin
  pp := StrAlloc(80);
  StrPCopy(pp,Listbox1.Items[Listbox1.Itemindex]);
  StripNumbers(pp);
  Label4.Caption := pp+'|';
                FindAuthor(author_root,pp,aa,false);
                if ( aa = nil ) then
                  begin
                    Form1.Msg('Author not found!');
                    Edit1.Text := pp;
                    Edit2.Text := 'not found';
                    Edit3.Text := '';
                  end
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
                    (*writeln('nbooks,likedsum,i = ',nbooks,' ',likedsum,' ',i);*)
                    Edit1.Text := IntToStr(nbooks);
                    (**if ( nbooks > 0 ) then**)
                    Edit2.Text := IntToStr(i);
                    nshorts := 0;
                    ss := aa^.short;
                    while ss <> nil do
                      begin
                        nshorts := nshorts+1;
                        ss := ss^.nexta;
                      end;
                    ss := aa^.coshort;
                    while ss <> nil do
                      begin
                        nshorts := nshorts+1;
                        k := 0;
                        for i := 1 to 5 do
                          if ( ss^.coauthor[i] = aa ) then
                            k := i;
                        if ( k = 0 ) then
                          begin
                            writeln('Corrupt coauthor');
                            ss := nil;
                          end
                        else
                          ss := ss^.conext[k];
                      end;
                    Edit3.Text := IntToStr(nshorts);
                  end;
  StrDispose(pp);
end;

procedure TFormAuthor.BooklistbuttonClick(Sender: TObject);
var nbooks,i : integer;
    aa : author_ptr;
    bb : book_ptr;
    pp : PChar;

begin
            if ( Listbox1.ItemIndex >= 0 ) then
              begin
                pp := StrAlloc(80);
                StrPCopy(pp,Listbox1.Items[Listbox1.Itemindex]);
                StripNumbers(pp);
                FindAuthor(author_root,pp,aa,false);
                StrDispose(pp);
                if ( aa = nil ) then
                  Form1.Msg('Author not found!')
                else
                  begin
                    aaglob := aa;
                    FormList.Setup;
                    FormList.Show;
                  end;
              end;

end;

procedure TFormAuthor.NewbookbuttonClick(Sender: TObject);
var aa : author_ptr;
    bb : book_ptr;
    pp : PChar;
begin
            if ( Listbox1.ItemIndex >= 0 ) then
              begin
                pp := StrAlloc(80);
                StrPCopy(pp,Listbox1.Items[Listbox1.Itemindex]);
                StripNumbers(pp);
                FindAuthor(author_root,pp,aa,false);
                StrDispose(pp);
                if ( aa = nil ) then
                  Form1.Msg('Author not found!')
                else
                  begin
                    aaglob := aa;
                    bbglob := nil;
                    FormBook.Setup;
                    FormBook.Show;
                  end;
              end;

end;

procedure TFormAuthor.NewauthorbuttonClick(Sender: TObject);
begin
  aaglob := nil;
  bbglob := nil;
  FormBook.Setup;
  FormBook.Show;
end;

procedure TFormAuthor.ShortlistbuttonClick(Sender: TObject);
var pp:PChar;
begin
            if ( Listbox1.ItemIndex >= 0 ) then
              begin
                pp := StrAlloc(80);
                StrPCopy(pp,Listbox1.Items[Listbox1.Itemindex]);
                StripNumbers(pp);
                FindAuthor(author_root,pp,aa,false);
                StrDispose(pp);
                if ( aa = nil ) then
                  Form1.Msg('Author not found!')
                else
                  begin
                    aaglob := aa;
                    bbglob := nil;
                    Formshortlist.Setup;
                    Formshortlist.Show;
                  end;
              end
            else
              begin
                aaglob := nil;
                bbglob := nil;
                Formshortlist.Setup;
                Formshortlist.Show;
              end;
end;

procedure TFormAuthor.Stripnumbers(pp:PChar);
var i,j : integer;
    pb : PChar;
begin
  pb := StrPos(pp,'   ');
  i := pb-pp;
  pp := StrLCopy(pp,pp,i);
end;


procedure TFormAuthor.RenameButtonClick(Sender: TObject);
var s:string;
    pp:PChar;
begin
            if ( Listbox1.ItemIndex >= 0 ) then
              begin
                pp := StrAlloc(80);
                StrPCopy(pp,Listbox1.Items[Listbox1.Itemindex]);
                StripNumbers(pp);
                FindAuthor(author_root,pp,aa,false);
                StrDispose(pp);
                if ( aa = nil ) then
                  Form1.Msg('Author not found!')
                else
                  begin
                    S:=aa^.name;
                    if InputQuery('Rename Author','Change author name to:',s) then
                      begin
                        StrDispose(aa^.name);
                        aa^.name := StrAlloc(length(s));
                        StrPCopy(aa^.name,s);
                      end;
                  end;
              end;
end;

end.
