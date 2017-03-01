unit bbbookrep;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,bbmain;

type
  TFormbookreport = class(TForm)
    Button1: TButton;
    Button2: TButton;
    SaveDialog1: TSaveDialog;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    ListBox4: TListBox;
    Button3: TButton;
    procedure Setup;
    procedure FillAutReport(aa:author_ptr);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Formbookreport: TFormbookreport;
  aadash : author_ptr;
  selgenre,selowner : integer;

implementation

{$R *.DFM}

procedure TFormbookreport.FillAutreport(aa:author_ptr);
var i,j,k,idone:integer;
    bb:book_ptr;
    ss:short_ptr;
    donebooks:array[1..400] of book_ptr;
    done,match: boolean;
    s,s1:string;
begin

  if ( aa^.prev <> nil ) and ( aa <> aadash ) then
    FillAutreport(aa^.prev);

  if (  aa^.name = '-' ) and ( aadash = nil ) then
      begin
        aadash := aa;
        if ( aa^.next <> nil ) then
          FillAutreport(aa^.next);
        Exit;
      end;

  for i := 1 to 400 do
    donebooks[i] := nil;
  idone := 0;

  match := false;

  Listbox4.Items.Clear;
  Listbox4.Items.Add(aa^.name);


        bb := aa^.book;
        if ( bb <> nil ) then
          begin
            (*Form1.Msg('Entering main-authored books');*)
            while bb <> nil do
              begin
                if ( selgenre < 0 ) or ( bb^.genre = selgenre ) then
                  if ( selowner < 0 ) or ( bb^.owner = selowner ) then
                    begin
                      match := true;
                      s1 := '   ;'+bb^.title;
                      if IsMusic then
                        begin
                          s1 := s1+' ; on '+bb^.where_bought;
                          if bb^.where_bought = 'Cassette' then
                            s1 := s1+' '+IntToStr(bb^.nread);
                        end;
                      (*Form1.Msg(s1);*)
                      Listbox4.Items.Add(s1);
                      idone := idone+1;
                      donebooks[idone] := bb;
                    end;
                bb := bb^.next;
              end;
            (*Form1.Msg('Done with main-authored books');*)
          end;
        if ( aa^.cobook <> nil ) then
          begin
            (*Form1.Msg('Entering co-authored books');*)
            bb := aa^.cobook;
            while bb <> nil do
              begin
                if ( selgenre < 0 ) or ( bb^.genre = selgenre ) then
                  if ( selowner < 0 ) or ( bb^.owner = selowner ) then
                    begin
                      match := true;
                      s1 := '   ;'+bb^.title;
                      if IsMusic then
                        begin
                          s1 := s1+' ; on '+bb^.where_bought;
                          if bb^.where_bought = 'Cassette' then
                            s1 := s1+' '+IntToStr(bb^.nread);
                        end;
                      Listbox4.Items.Add(s1);
                      idone := idone+1;
                      donebooks[idone] := bb;
                    end;
                k := 0;
                for i := 1 to 5 do
                  if ( bb^.coauthor[i] = aa ) then
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
            (*Form1.Msg('Done with coauthored');*)
          end;

        ss := aa^.short;
        if ( ss <> nil ) then
          begin
            while ss <> nil do
              begin
                bb := ss^.collection;
                done := false;
                for i := 1 to idone do
                  if ( donebooks[i] = bb ) then
                    done := true;
                if not done then
                  if ( selgenre < 0 ) or ( bb^.genre = selgenre ) then
                    if ( selowner < 0 ) or ( bb^.owner = selowner ) then
                      begin
                        match := true;
                        s1 := '   ;[ '+bb^.title+' ]';
                        if IsMusic then
                          begin
                            s1 := s1+' ; in '+bb^.where_bought;
                            if bb^.where_bought = 'Cassette' then
                              s1 := s1+' '+IntToStr(bb^.nread);
                          end;
                        Listbox4.Items.Add(s1);
                        idone := idone+1;
                        donebooks[idone] := bb;
                      end;
                ss := ss^.nexta;
              end;
          end;
        if ( aa^.coshort <> nil ) then
          begin
            ss := aa^.coshort;
            while ss <> nil do
              begin
                bb := ss^.collection;
                done := false;
                for i := 1 to idone do
                  if ( donebooks[i] = bb ) then
                    done := true;
                if not done then
                  if ( selgenre < 0 ) or ( bb^.genre = selgenre ) then
                    if ( selowner < 0 ) or ( bb^.owner = selowner ) then
                      begin
                        match := true;
                        s1 := '   ;[ '+bb^.title+' ]';
                        if IsMusic then
                          begin
                            s1 := s1+' ; in '+bb^.where_bought;
                            if bb^.where_bought = 'Cassette' then
                              s1 := s1+' '+IntToStr(bb^.nread);
                          end;
                        Listbox4.Items.Add(s1);
                        idone := idone+1;
                        donebooks[idone] := bb;
                      end;
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

  if match then
    for i := 0 to Listbox4.Items.Count-1 do
      Listbox1.Items.Add(Listbox4.Items[i]);

  if ( aa^.next <> nil )  and ( aa <> aadash ) then
    FillAutreport(aa^.next);
end;

procedure TFormbookreport.Setup;
var aa:author_ptr;
    bb:book_ptr;
    i,j:integer;
begin
  Listbox1.Items.Clear;
  Listbox2.Items.Clear;
  Listbox3.Items.Clear;

    Listbox3.Items.Add('All');
    for i := 0 to 5 do
      Listbox3.Items.Add(owner_tab[i]);

    Listbox2.Items.Add('All');
    if IsMusic then
      begin
        Listbox2.Items.Add('Pop');
        Listbox2.Items.Add('Rock');
        Listbox2.Items.Add('Metal');
        Listbox2.Items.Add('Electronic');
        Listbox2.Items.Add('Classical');
        Listbox2.Items.Add('Reggae');
        Listbox2.Items.Add('Jazz');
        Listbox2.Items.Add('Other');
      end
    else
      begin
        Listbox2.Items.Add('Science fiction');
        Listbox2.Items.Add('General fiction');
        Listbox2.Items.Add('Physics');
        Listbox2.Items.Add('Chemistry');
        Listbox2.Items.Add('Biology');
        Listbox2.Items.Add('Economics');
        Listbox2.Items.Add('Philosophy');
        Listbox2.Items.Add('Religion');
        Listbox2.Items.Add('Politics');
        Listbox2.Items.Add('Geography');
        Listbox2.Items.Add('History');
        Listbox2.Items.Add('Other nonfiction');
        Listbox2.Items.Add('Baby care');
        Listbox2.Items.Add('Games');
        Listbox2.Items.Add('Sex');
        Listbox2.Items.Add('Humor');
        Listbox2.Items.Add('Biographies');
        Listbox2.Items.Add('Linguistics');
        Listbox2.Items.Add('Languages');
        Listbox2.Items.Add('Computers');
      end;

end;

procedure TFormbookreport.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TFormbookreport.Button1Click(Sender: TObject);
var s:string;
    i,j,k:integer;
begin
  if Savedialog1.Execute then
    begin
      s := Savedialog1.Filename;
      Form1.Msg('Saving record list to '+s);
      assignfile(titfile,s);
      rewrite(titfile);
      for i := 0 to Listbox1.Items.Count-1 do
        writeln(titfile,Listbox1.Items[i]);
      closefile(titfile);
      Close;
    end
  else
    Form1.Msg('Savedialog cancelled');
end;

procedure TFormbookreport.Button3Click(Sender: TObject);
begin

  if Listbox2.Itemindex = 0 then
    selgenre := -1
  else
    selgenre := Listbox2.Itemindex;

  if Listbox3.Itemindex = 0 then
    selowner := -1
  else
    selowner := Listbox3.Itemindex-1;

  aadash := nil;

  FillAutReport(author_root^.prev);
  FillAutReport(author_root^.next);

  if ( aadash <> nil ) then
    FillAutReport(aadash);
end;

end.
