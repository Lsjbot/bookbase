program bookbase;

uses
  Forms,
  bbmain in 'bbmain.pas' {Form1},
  bbauthor in 'bbauthor.pas' {FormAuthor},
  bbbooklist in 'bbbooklist.pas' {FormList},
  bbnewbook in 'bbnewbook.pas' {Formbook},
  bbcoauthor in 'bbcoauthor.pas' {FormCo},
  bbaddshort in 'bbaddshort.pas' {FormAddshort},
  bbshortlist in 'bbshortlist.pas' {Formshortlist},
  bbbookrep in 'bbbookrep.pas' {Formbookreport};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormAuthor, FormAuthor);
  Application.CreateForm(TFormList, FormList);
  Application.CreateForm(TFormbook, Formbook);
  Application.CreateForm(TFormCo, FormCo);
  Application.CreateForm(TFormAddshort, FormAddshort);
  Application.CreateForm(TFormshortlist, Formshortlist);
  Application.CreateForm(TFormbookreport, Formbookreport);
  Application.Run;
end.
