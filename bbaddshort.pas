unit bbaddshort;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,bbmain;

type
  TFormAddshort = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Eaut: TEdit;
    Etit: TEdit;
    AnotherButton: TButton;
    DoneButton: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    procedure Setup;
    procedure Saveinfo;
    procedure AnotherButtonClick(Sender: TObject);
    procedure DoneButtonClick(Sender: TObject);
    procedure EautChange(Sender: TObject);
    procedure EautKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAddshort: TFormAddshort;
    s,partname,fullname : string;
    pa,pt : PChar;
    i,j,k : integer;
    li,lj : LongInt;
    aa : author_ptr;
    bb : book_ptr;
    ss : Short_ptr;
    coa : coarray;


implementation

uses bbcoauthor;

{$R *.DFM}

procedure TFormaddshort.Setup;
begin
  Eaut.text := aaglob^.name;
  Etit.text := '';
  Label3.Caption := '';
  Label4.Caption := '';
  partname := '';
  fullname := '';
end;

procedure TFormaddshort.SaveInfo;
var sss : short_ptr;
    i,j:integer;
begin
            pa := StrNew(GLine);
            pt := StrNew(GLine);
            StrPCopy(pa,Eaut.Text);
            StrPCopy(pt,Etit.Text);
            if (pa <> '') and (pt <> '') then
              begin
                Form1.SplitCoauthors(pa,aa,coa);
                Form1.AddShort(aa,coa,bbglob,pt,ss);
                Button4.Caption := pa;
                Button5.Caption := pt;
              end;
            StrDispose(pa);
            StrDispose(pt);
      i := 0;
      if bbglob^.short <> nil then
        begin
          i := 1;
          sss := bbglob^.short;
          while ( sss^.nextb <> nil ) do
            begin
              i := i+1;
              sss := sss^.nextb;
            end;
        end;
      Label3.Caption := Inttostr(i);
end;

procedure TFormAddshort.AnotherButtonClick(Sender: TObject);
begin
  if ( Eaut.Text <> '' ) and ( Etit.Text <> '' ) then
    Saveinfo;
  Etit.Text := '';
end;

procedure TFormAddshort.DoneButtonClick(Sender: TObject);
begin
  if ( Eaut.Text <> '' ) and ( Etit.Text <> '' ) then
    SaveInfo;
  Close;
end;

procedure TFormAddshort.EautChange(Sender: TObject);
type TPoint = record
       x,y : longint;
     end;

var nfound,i:integer;
    aa : author_ptr;
    xx:boolean;
    x,y : longint;
    pa : PChar;
begin
  (*xx:= GetCaretPos(pp);*)
 if ( Length(Eaut.Text) > 0 ) then
  if ( Eaut.Text[Length(Eaut.Text)] <> '§' ) then
    begin
      pa := StrNew(GLine);
      StrPCopy(pa,Eaut.Text);
      nfound := 0;
      Form1.FindPartial(author_root,pa,aa,nfound);
      if ( nfound = 1 ) then
        begin
          partname := Eaut.Text;
          Button6.Caption := aa^.name;
          fullname := Button6.Caption;
          (*
          Eaut.SelStart := StrLen(pa);
          Eaut.SelLength := 0;
          *)
        end
      else
        Button6.Caption := IntToStr(nfound);
      Label4.Caption := IntToStr(nfound);
      StrDispose(pa);
    end
  else
    Eaut.Text := Button6.Caption
end;

procedure TFormAddshort.EautKeyPress(Sender: TObject; var Key: Char);
var nfound,i :integer;
    aa : author_ptr;
    pa : PChar;
    xx:boolean;
begin
  if key = '§' then
    Eaut.Text := Button6.Caption
  else
    begin
    end;
  (*
  if ( length(fullname) > length(partname) ) then
    begin
      if ( fullname[length(partname)+1] = Key ) then
        begin
          partname := partname + Key;
          s := Eaut.Text;
          Delete(s,length(partname)+1,1);
          Eaut.Text := s;
          Eaut.SelStart := Length(partname);
          Eaut.SelLength := 0;
        end
      else
        begin
          Eaut.Text := partname + Key;
          fullname := '';
          partname := '';
          Eaut.SelStart := Length(Eaut.Text)+1;
          Eaut.SelLength := 0;
        end;
    end;
  *)
end;

procedure TFormAddshort.Button1Click(Sender: TObject);
var coadum : coarray;
begin
            coadum := coaglob;
            for i:= 1 to 5 do
              coaglob[i] := nil;
            Eaut.Text := '';
            FormCo.Setup;
            FormCo.ShowModal;
            for i := 1 to 5 do
              if coaglob[i] <> nil then
                begin
                  if ( Eaut.Text <> '' ) then
                    Eaut.Text := Eaut.Text + '&';
                  Eaut.Text := Eaut.Text + coaglob[i]^.name;
                end;
            coaglob := coadum;

end;

procedure TFormAddshort.Button2Click(Sender: TObject);
begin
  if ( aaglob <> nil ) then
    Eaut.Text := aaglob^.name;
end;

procedure TFormAddshort.Button3Click(Sender: TObject);
begin
  if ( bbglob <> nil ) then
    Etit.Text := bbglob^.title;

end;

procedure TFormAddshort.Button4Click(Sender: TObject);
begin
  Eaut.Text := Button4.Caption;
end;

procedure TFormAddshort.Button5Click(Sender: TObject);
begin
  Etit.Text := Button5.Caption;

end;

procedure TFormAddshort.Button6Click(Sender: TObject);
begin
  Eaut.Text := Button6.Caption
end;

end.
