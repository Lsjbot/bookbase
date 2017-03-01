unit bbnewbook;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,bbmain;

type
  TFormbook = class(TForm)
    Label1: TLabel;
    Eaut: TEdit;
    Label2: TLabel;
    Etit: TEdit;
    ScrollBar1: TScrollBar;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Elike: TEdit;
    ListBox1: TListBox;
    Label6: TLabel;
    Label7: TLabel;
    Epub: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Eyf: TEdit;
    Eyt: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Ewhere: TEdit;
    Ewhen: TEdit;
    Eprice: TEdit;
    OKButton: TButton;
    CancelButton: TButton;
    ListBoxCo: TListBox;
    Label15: TLabel;
    Cobutton: TButton;
    Buttonlistshort: TButton;
    ButtonAddshort: TButton;
    Memo1: TMemo;
    ListBox2: TListBox;
    Label16: TLabel;
    CNEdit: TEdit;
    ListBox3: TListBox;
    Label17: TLabel;
    procedure Setup;
    procedure CancelButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure ButtonAddshortClick(Sender: TObject);
    procedure CobuttonClick(Sender: TObject);
    procedure SaveInfo;
    procedure ButtonlistshortClick(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure Msg(ss:string);
    procedure EautChange(Sender: TObject);
    procedure EyfChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Formbook: TFormbook;
    s : string;
    p : PChar;
    MinP,MaxP,pos : integer;
    li,lj : LongInt;
    i,j,k,lk,nr,gn,ow : integer;
    yf,yt,pr : word;
    pline,ptitle,ppub,pwhere,pwhen,p1,p2,pauthor : PChar;
    sline,stitle,spub,swhere,swhen,s1,s2,sauthor : string;
    aa : author_ptr;
    bb : book_ptr;
    flag : PBool;

implementation

uses bbcoauthor, bbaddshort, bbshortlist;

{$R *.DFM}

procedure TFormBook.Msg(ss:string);
begin
  Memo1.Lines.Add(ss);
end;

procedure TFormbook.Setup;

begin
  Msg('Formbook.Setup.start');
        if ( aaglob <> nil ) then
          begin
            Eaut.Text := aaglob^.name;
            Etit.Taborder := 0;
            Msg('aaglob <> nil');
          end
        else
          begin
            Eaut.Text := '';
            Eaut.taborder := 0;
            Msg('aaglob = nil');
          end;
        if ( bbglob <> nil ) then
          begin
            Msg('bbglob <> nil');
            Eaut.Text := bbglob^.author^.name;
            Etit.Text := bbglob^.title;
            Epub.Text := bbglob^.publisher;
            Ewhere.Text := bbglob^.where_bought;
            Eyf.Text := Inttostr(bbglob^.year_first);
            Eyt.Text := Inttostr(bbglob^.year_this);
            Ewhen.Text := bbglob^.date_bought;
            Eprice.Text := Inttostr(bbglob^.price);
            Listboxco.Items.Clear;
            for i := 1 to 5 do
              if ( bbglob^.coauthor[i] <> nil ) then
                Listboxco.Items.Add(bbglob^.coauthor[i]^.name);
            Scrollbar1.Position := bbglob^.liked_it;
            Elike.Text := Inttostr(bbglob^.liked_it);
            CNEdit.Text := Inttostr(bbglob^.nread);
          end
        else
          begin
            Msg('bbglob = nil');
            Etit.Text := '';
            Epub.Text := '';
            Ewhere.Text := '';
            Eyf.Text := '00';
            Eyt.Text := '00';
            Ewhen.Text := '0';
            Eprice.Text := '0';
            Listboxco.Items.Clear;
            Scrollbar1.Position := 0;
            Elike.Text := '0';
          end;


        Listbox1.Items.Clear;
        Listbox2.Items.Clear;
        Listbox3.Items.Clear;

        for i := 0 to 5 do
          Listbox3.Items.Add(owner_tab[i]);

    if IsMusic then
      begin
        Listbox1.Items.Add('Pop');
        Listbox1.Items.Add('Rock');
        Listbox1.Items.Add('Metal');
        Listbox1.Items.Add('Electronic');
        Listbox1.Items.Add('Classical');
        Listbox1.Items.Add('Reggae');
        Listbox1.Items.Add('Jazz');
        Listbox1.Items.Add('Other');
        Listbox2.Enabled := true;
        Listbox2.Visible := true;
        Listbox2.Items.Add('CD');
        Listbox2.Items.Add('LP');
        Listbox2.Items.Add('Cassette');
        Listbox2.Items.Add('DVD');
        Listbox2.Itemindex := 0;
        CNEdit.Enabled := true;
        CNEdit.Visible := true;
      end
    else
      begin
        Listbox2.Enabled := false;
        Listbox2.Visible := false;
        Listbox1.Items.Add('Science fiction');
        Listbox1.Items.Add('General fiction');
        Listbox1.Items.Add('Physics');
        Listbox1.Items.Add('Chemistry');
        Listbox1.Items.Add('Biology');
        Listbox1.Items.Add('Economics');
        Listbox1.Items.Add('Philosophy');
        Listbox1.Items.Add('Religion');
        Listbox1.Items.Add('Politics');
        Listbox1.Items.Add('Geography');
        Listbox1.Items.Add('History');
        Listbox1.Items.Add('Other nonfiction');
        Listbox1.Items.Add('Baby care');
        Listbox1.Items.Add('Games');
        Listbox1.Items.Add('Sex');
        Listbox1.Items.Add('Humor');
        Listbox1.Items.Add('Biographies');
        Listbox1.Items.Add('Linguistics');
        Listbox1.Items.Add('Languages');
        Listbox1.Items.Add('Computers');
      end;

        if ( bbglob = nil ) then
          begin
            Scrollbar1.Position := 0;
            Listbox1.Itemindex := 0;
            Listbox3.Itemindex := 0;
            for i := 1 to 5 do
              coaglob[i] := nil;
          end
        else
          begin
            Listbox1.Itemindex := bbglob^.genre-1;
            Listbox3.Itemindex := bbglob^.owner;
            coaglob := bbglob^.coauthor;
            if IsMusic then
              for i := 0 to Listbox2.Items.Count-1 do
                if Listbox2.Items[i] = Ewhere.Text then
                  Listbox2.Itemindex := i;
          end;
(*        for i := 1 to 5 do
          begin
           writeln('coaglob = ',longint(coaglob[i]));

            if ( coaglob[i] <> nil ) then
              begin
                writeln('Coa[',i,'] pointing');
                writeln('at ',StrPas(coaglob[i]^.name));
              end;
          end;*)

  Msg('End of setup');
end;

procedure TFormbook.CancelButtonClick(Sender: TObject);
begin
  Close;
end;


procedure TFormBook.Saveinfo;
begin
            Form1.Msg('Saveinfo..');
            if ( bbglob = nil ) then
              begin
                ptitle := StrNew(GName);
                ppub := StrNew(GName);
                pwhere := StrNew(GName);
                pwhen := StrNew(GRoot);
                (**p1 := StrNew(GLine);**)
                StrPCopy(ptitle,Etit.Text);
                StrPCopy(ppub,Epub.text);
                if IsMusic then
                  begin
                    if ( Listbox2.ItemIndex >= 0 ) then
                      StrPcopy(pwhere,Listbox2.Items[Listbox2.ItemIndex])
                    else
                      StrPCopy(pwhere,Listbox2.Items[0]);
                  end
                else
                  StrPCopy(pwhere,Ewhere.Text);
                StrPCopy(pwhen,Ewhen.Text);

                yf := Strtoint(Eyf.Text);
                yt := Strtoint(Eyt.Text);
                pr := Strtoint(Eprice.Text);
              end;
            lk := Scrollbar1.Position;
            gn := Listbox1.Itemindex + 1;
            ow := Listbox3.Itemindex;
            if ( IsMusic ) then
              begin
                nr := Strtoint(CNEdit.Text);
              end
            else
              nr := 1;
            (*writeln('After getting; yf,yt,pr,lk,gn = ');
            writeln(yf,' ',yt,' ',pr,' ',lk,' ',gn);*)
            if ( bbglob = nil ) then
              begin
                if ( aaglob = nil ) then
                  begin
                    pauthor := StrNew(GName);
                    StrPCopy(pauthor,Eaut.Text);
                    Form1.FindAuthor(author_root,pauthor,aaglob,true);
                  end;
                Form1.AddBook(aaglob,coaglob,ptitle,ppub,yf,yt,pwhen,pwhere,pr,lk,nr,gn,ow,bbglob);
              end
            else with bbglob^ do
              begin
                Form1.Msg('Modifying '+title);
                if IsMusic then
                  begin
                    if ( Listbox2.ItemIndex >= 0 ) then
                      StrPcopy(where_bought,Listbox2.Items[Listbox2.ItemIndex])
                    else
                      StrPCopy(where_bought,Listbox2.Items[0]);
                  end;
                if ( IsMusic ) then
                  nread := Strtoint(CNEdit.Text);
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
                owner := ow;
              end;
            Form1.Msg('Done!');

end; (** Saveinfo **)

procedure TFormbook.OKButtonClick(Sender: TObject);
begin
  Saveinfo;
  Close;
end;

procedure TFormbook.ButtonAddshortClick(Sender: TObject);
begin
  Saveinfo;
  FormAddshort.Setup;
  FormAddshort.Show;
end;

procedure TFormbook.CobuttonClick(Sender: TObject);
var ss : string;
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
            FormCo.Setup;
            FormCo.ShowModal;
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
            Form1.Msg('Rewriting coauthor listbox');
            ListboxCo.Items.Clear;
            for i := 1 to 5 do
              if ( coaglob[i] <> nil ) then
                begin
                  ss := coaglob[i]^.name;
                  Listboxco.Items.Add(ss);
                end;

(**            writeln('Colist fixed');**)


end;

procedure TFormbook.ButtonlistshortClick(Sender: TObject);
var aatemp:author_ptr;
begin
  SaveInfo;
  aatemp := aaglob;
  aaglob := nil;

  Formshortlist.Setup;
  Formshortlist.Show;

  aaglob := aatemp;
end;

procedure TFormbook.ScrollBar1Change(Sender: TObject);
begin
  Elike.text := Inttostr(Scrollbar1.Position);
end;


procedure TFormbook.EautChange(Sender: TObject);
var nfound:integer;
    aa : author_ptr;
begin
  (*
  pa := StrNew(GLine);
  StrPCopy(pa,Eaut.Text);
  nfound := 0;
  Form1.FindPartial(author_root,pa,aa,nfound);
  if ( nfound = 1 ) then
    Eaut.Text := aa^.name;
  Eaut.SelStart := StrLen(pa);
  Eaut.SelLength := 1;
  Label3.Caption := IntToStr(nfound);
  StrDispose(pa);
  *)
end;

procedure TFormbook.EyfChange(Sender: TObject);
begin
  Eyt.Text := Eyf.Text;
end;

end.
