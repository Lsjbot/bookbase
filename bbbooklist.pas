unit bbbooklist;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,bbmain;

type
  TFormList = class(TForm)
    ListBox1: TListBox;
    Newbookbutton: TButton;
    Shortbutton: TButton;
    Editbutton: TButton;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    ButtonIrma: TButton;
    ButtonSverker: TButton;
    ButtonDaniel: TButton;
    procedure Setup;
    procedure AddTitleList(aa:author_ptr);
    procedure Button1Click(Sender: TObject);
    procedure NewbookbuttonClick(Sender: TObject);
    procedure EditbuttonClick(Sender: TObject);
    procedure ShortbuttonClick(Sender: TObject);
    procedure ButtonIrmaClick(Sender: TObject);
    procedure ButtonSverkerClick(Sender: TObject);
    procedure ButtonDanielClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormList: TFormList;

implementation

uses bbnewbook, bbshortlist;

{$R *.DFM}

procedure TFormList.Setup;
var nbooks,i,j,k,li : integer;
    aa : author_ptr;
    bb : book_ptr;
    ss,s1,s2 : string;


begin

    Form1.Msg('Booklist setup start');
    Listbox1.Items.Clear;
    if ( bblist = nil ) then
      new(bblist);
    for i := 0 to MaxBooks do
      bblist^[i] := nil;
    aa := aaglob;
    if ( aaglob <> nil ) then
      begin
        Listbox1.Sorted := true;
        Form1.Msg('Booklist for '+aaglob^.name);
        Label1.Caption := aaglob^.name;
        bb := aaglob^.book;
        if ( bb <> nil ) then
          begin
            Form1.Msg('Entering main-authored books');
            while bb <> nil do
              begin
(**                writeln(bb^.title);**)
                s1 := bb^.title;
                if IsMusic then
                  begin
                    repeat
                      s1 := s1+' ';
                    until length(s1) > 50;
                    s1 := s1+' on '+bb^.where_bought;
                    if bb^.where_bought = 'Cassette' then
                      s1 := s1+' '+IntToStr(bb^.nread);
                  end;
                li := Listbox1.Items.Add(s1);
                Form1.Msg('li,book = '+inttostr(li)+' '+s1);
                bblist^[li] := bb;
                bb := bb^.next;
              end;
            Form1.Msg('Done with main-authored books');
          end;
        if ( aaglob^.cobook <> nil ) then
          begin
            Form1.Msg('Entering co-authored books');
            bb := aaglob^.cobook;
            while bb <> nil do
              begin
(**                writeln(bb^.title);**)
                s1 := bb^.title;
                if IsMusic then
                  begin
                    repeat
                      s1 := s1+' ';
                    until length(s1) > 50;
                    s1 := s1+' on '+bb^.where_bought;
                    if bb^.where_bought = 'Cassette' then
                      s1 := s1+' '+IntToStr(bb^.nread);
                  end;
                li := Listbox1.Items.Add(s1);
                Form1.Msg('li,book = '+inttostr(li)+' '+s1);
                bblist^[li] := bb;
                k := 0;
                for i := 1 to 5 do
                  if ( bb^.coauthor[i] = aaglob ) then
                    begin
                      k := i;
                    end;
                if ( k = 0 ) then
                  begin
                    Form1.Msg('Corrupt coauthor');
                    bb := nil;
                  end
                else
                  bb := bb^.conext[k];
              end;
            Form1.Msg('Done with coauthored');
          end;
        Form1.Msg('Round 2; indexing '+aaglob^.name);
        bb := aaglob^.book;
        if ( bb <> nil ) then
          begin
            Form1.Msg('Indexing main-authored books');
            while bb <> nil do
              begin
                s1 := bb^.title;
                if IsMusic then
                  begin
                    repeat
                      s1 := s1+' ';
                    until length(s1) > 50;
                    s1 := s1+' on '+bb^.where_bought;
                    if bb^.where_bought = 'Cassette' then
                      s1 := s1+' '+IntToStr(bb^.nread);
                  end;
                li := Listbox1.Items.Indexof(s1);
                if ( li >= 0 ) then
                  begin
                    Form1.Msg('li,book = '+inttostr(li)+' '+s1);
                    bblist^[li] := bb;
                  end
                else
                  Form1.Msg('ERROR! li,book = '+inttostr(li)+' '+bb^.title);
                bb := bb^.next;
              end;
            Form1.Msg('Done with indexing main-authored books');
          end
        else if ( aaglob^.cobook <> nil ) then
          begin
            Form1.Msg('Indexing co-authored books');
            bb := aaglob^.cobook;
            while bb <> nil do
              begin
(**                writeln(bb^.title);**)
                s1 := bb^.title;
                if IsMusic then
                  begin
                    repeat
                      s1 := s1+' ';
                    until length(s1) > 50;
                    s1 := s1+' on '+bb^.where_bought;
                    if bb^.where_bought = 'Cassette' then
                      s1 := s1+' '+IntToStr(bb^.nread);
                  end;
                li := Listbox1.Items.Indexof(s1);
                if ( li >= 0 ) then
                  bblist^[li] := bb
                else
                  Form1.Msg('ERROR! li,book = '+inttostr(li)+' '+s1);
                k := 0;
                for i := 1 to 5 do
                  if ( bb^.coauthor[i] = aaglob ) then
                    begin
                      k := i;
                    end;
                if ( k = 0 ) then
                  begin
                    Form1.Msg('Corrupt coauthor');
                    bb := nil;
                  end
                else
                  bb := bb^.conext[k];
              end;
            Form1.Msg('Done with indexing coauthored');
          end
        else
          li := Listbox1.Items.Add('no books');
      end
    else
      begin
        Form1.Msg('All books by everybody');
        Listbox1.Sorted := false;
        (** Solve bblist-problem before setting Sorted true here **)
        Label1.Caption := 'All books by everybody';
        AddTitleList(author_root^.prev);
        AddTitleList(author_root^.next);
      end;
    Form1.Msg('Booklist setup done');
end; (* Setup *)

procedure TFormList.AddTitleList(aa:author_ptr);

var bb : book_ptr;
    li : LongInt;

begin
  if ( aa <> nil ) then
    begin
      AddTitleList(aa^.prev);
      bb := aa^.book;
      if ( bb <> nil ) then
        begin
          while bb <> nil do
            begin
(**              writeln(bb^.title);**)
              li := Listbox1.Items.Add(bb^.title);
              if (( li mod 100 ) = 0 ) then
                Form1.Msg('li = '+Inttostr(li));
              if ( li > Maxbooks-10 ) then
                Form1.Msg('li TOO LARGE');
              bblist^[li] := bb;
              bb := bb^.next;
            end;
        end;
      AddTitleList(aa^.next);
    end;

end; (** AddTitleList **)

procedure TFormList.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TFormList.NewbookbuttonClick(Sender: TObject);
begin
  bbglob := nil;
  FormBook.Setup;
  FormBook.Show;
end;

procedure TFormList.EditbuttonClick(Sender: TObject);
begin
  bbglob := bblist^[Listbox1.ItemIndex];
  FormBook.Setup;
  FormBook.Show;

end;

procedure TFormList.ShortbuttonClick(Sender: TObject);
var aatemp : author_ptr;
begin
  aatemp := aaglob;
  aaglob := nil;
  bbglob := bblist^[Listbox1.ItemIndex];

  Formshortlist.Setup;
  Formshortlist.Show;

  aaglob := aatemp;
end;

procedure TFormList.ButtonIrmaClick(Sender: TObject);
begin
  if ( Listbox1.ItemIndex >= 0 ) then
    bblist^[Listbox1.ItemIndex].owner := 1
  else
    MessageDlg('No selection',mtWarning,[mbOK],0);

end;

procedure TFormList.ButtonSverkerClick(Sender: TObject);
begin
  if ( Listbox1.ItemIndex >= 0 ) then
    bblist^[Listbox1.ItemIndex].owner := 0
  else
    MessageDlg('No selection',mtWarning,[mbOK],0);
end;

procedure TFormList.ButtonDanielClick(Sender: TObject);
begin
  if ( Listbox1.ItemIndex >= 0 ) then
    bblist^[Listbox1.ItemIndex].owner := 2
  else
    MessageDlg('No selection',mtWarning,[mbOK],0);
end;

end.
