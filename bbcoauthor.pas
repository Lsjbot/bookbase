unit bbcoauthor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,bbmain;

type
  TFormCo = class(TForm)
    ListBox1: TListBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    AnotherButton: TButton;
    DoneButton: TButton;
    CancelButton: TButton;
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
    Label3: TLabel;
    procedure Setup;
    procedure FillCoAutListBox(aa:author_ptr);
    procedure abutClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure AnotherButtonClick(Sender: TObject);
    procedure DoneButtonClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCo: TFormCo;

implementation

{$R *.DFM}

procedure TFormCo.FillCoAutListBox(aa:author_ptr);

var li : LongInt;

begin
  if ( aa <> nil ) then
    begin
      if ( aa^.prev <> nil ) then
        FillCoAutListBox(aa^.prev);
      Listbox1.Items.Add(aa^.name);
      if ( aa^.next <> nil ) then
        FillCoAutListBox(aa^.next);
    end;
end; (** FillCOAutListBox **)

procedure TFormCo.Setup;
begin
  Listbox1.Items.Clear;
  FillCoAutListBox(author_root^.prev);
  FillCoAutListBox(author_root^.next);
  Edit1.Text := '';
  Label3.Caption := '';
  if aaglob <> nil then
    Label2.Caption := aaglob^.name
  else
    Label2.Caption := '';
end;

procedure TFormCo.abutClick(Sender: TObject);
var c:char;
    i,j,k : integer;
begin
  c := (Sender as TButton).Caption[1];
  for i := Listbox1.Items.Count-1 downto 0 do
    if ( c = Listbox1.Items[i][1] ) then
      k := i;
  Listbox1.Topindex := k;
end;

procedure TFormCo.CancelButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TFormCo.AnotherButtonClick(Sender: TObject);
var p:PChar;
    aa:author_ptr;
    i,j,k:integer;
begin
            p := StrNew(GName);
            StrPCopy(p,Edit1.Text);
            (**writeln('Selected author from text: ',StrPas(p));**)
            if ( StrLen(p) > 0 ) then
              begin
                Form1.FindAuthor(author_root,p,aa,true);
                if ( aa = nil ) then
(**                  writeln('Author not found!')**)
                else
                  begin
                    k := 1;
                    while coaglob[k] <> nil do
                      k := k+1;
                    if k > 5 then
                      MessageDlg('Too many coauthors! (max 5)',mtError,[mbOK],0)
                    else
                      begin
                        coaglob[k] := aa;
                        if Label3.Caption <> '' then
                          Label3.Caption := Label3.Caption+' & ';
                        Label3.Caption := Label3.Caption+aa^.name;
                      end;
(**                    writeln('Coaglob[',k:1,'] pointing');**)
(**                    writeln('at ',StrPas(coaglob[k]^.name));**)
                  end;
              end;
            Edit1.Text := '';

end;

procedure TFormCo.DoneButtonClick(Sender: TObject);
begin
  AnotherButtonClick(Sender);
  Close;
end;

procedure TFormCo.ListBox1Click(Sender: TObject);
begin
  Edit1.Text := Listbox1.Items[Listbox1.Itemindex];
end;

end.
