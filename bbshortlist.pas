unit bbshortlist;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,bbmain;

type
  TFormshortlist = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ListBox1: TListBox;
    Button1: TButton;
    RenameButton: TButton;
    procedure Setup;
    procedure Addauthor(aa:author_ptr;tree:boolean);
    procedure Button1Click(Sender: TObject);
    procedure RenameButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Formshortlist: TFormshortlist;
    s : string;
    p : PChar;
    i,j,k : integer;
    li,lj : LongInt;
    aa : author_ptr;
    ss : short_ptr;

implementation

{$R *.DFM}

procedure TFormshortlist.AddAuthor(aa:author_ptr;tree:boolean);
begin
        if tree then
          if (aa^.prev <> nil ) then
            AddAuthor(aa^.prev,tree);

        ss := aa^.short;
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
                li := Listbox1.Items.Add(p);
                sslist^[li] := ss;
                ss := ss^.nexta;
              end;
          end;
        if ( aa^.coshort <> nil ) then
          begin
            ss := aa^.coshort;
            while ss <> nil do
              begin
                StrCopy(p,ss^.title);
                repeat
                  p := StrCat(p,' ');
                until ( StrLen(p) > 50 );
                p := StrCat(p,'  in: ');
                p := StrCat(p,ss^.collection^.title);
                li := Listbox1.Items.Add(p);
                sslist^[li] := ss;
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
(**            writeln('Done with coauthored');**)
          end;
        if ( aa^.short = nil ) and ( aa^.coshort = nil ) and not tree then
          Listbox1.Items.Add('(no short stories)');

        if tree then
          if (aa^.next <> nil ) then
            AddAuthor(aa^.next,tree);

end; (* AddAuthor *)

procedure TFormshortlist.Setup;

begin
  Listbox1.Items.Clear;
  if ( sslist = nil ) then
    new(sslist);
  (**writeln('Booklist; Message,Wparam= ',message,' ',wparam);**)
  p := StrNew(GLine);
  if ( aaglob <> nil ) then
    begin
      Label2.Caption := 'by';
      Label3.Caption := aaglob^.name;
      AddAuthor(aaglob,false);
    end
  else if ( bbglob <> nil ) then
    begin
        ss := bbglob^.short;
        Label2.Caption := 'in';
        Label3.Caption := bbglob^.title;
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
                li := Listbox1.Items.Add(p);
                sslist^[li] := ss;
                ss := ss^.nextb;
              end;
          end
        else
          Listbox1.Items.Add('(no short stories)');
      end
    else
      begin
        Label2.Caption := '';
        Label3.Caption := '';
        AddAuthor(author_root^.prev,true);
        AddAuthor(author_root^.next,true);
      end;
     StrDispose(p);

end;

procedure TFormshortlist.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TFormshortlist.RenameButtonClick(Sender: TObject);
var s:string;
    pp:PChar;
begin
            if ( Listbox1.ItemIndex >= 0 ) then
              begin
                (*
                pp := StrAlloc(80);
                StrPCopy(pp,Listbox1.Items[Listbox1.Itemindex]);
                StripNumbers(pp);
                FindAuthor(author_root,pp,aa,false);
                StrDispose(pp);
                if ( aa = nil ) then
                  Form1.Msg('Author not found!')
                else
                *)
                  begin
                    S:=sslist^[Listbox1.ItemIndex]^.title;
                    if InputQuery('Rename Song','Change song name to:',s) then
                      begin
                        StrDispose(sslist^[Listbox1.ItemIndex]^.title);
                        sslist^[Listbox1.ItemIndex]^.title := StrAlloc(length(s));
                        StrPCopy(sslist^[Listbox1.ItemIndex]^.title,s);
                      end;
                  end;
              end;
end;

end.
