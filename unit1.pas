unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type
  cena=record
    ncena:integer; //nakupna cena
    pcena:integer; //predajna cena
    kod:integer; //kod tovaru
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;
 Const N=10;

var
  p:array[1..N]of cena;
  subor:textfile;
  i,j:integer;
  nc:integer; //nakupnacena
  pc:integer; //predajnacena
  nazov:string;  //berie sa nazov zoznamu z edit.1
  pom:integer;
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
 Memo1.Clear;
 nazov:=edit1.text;
 AssignFile(subor,nazov+'.txt');
 Reset(subor);
 i:=0;
 While not eof(subor) do
  begin
  inc(i);
  readln(subor,p[i].kod);
  Memo1.Append(inttostr(p[i].kod));
  end;
 CloseFile(subor);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  p[nc].ncena:=inttostr(edit2.text); //nakupna cena
  p[pc].pcena:=inttostr(edit3.text); //predajna cena
  pom:=inttostr(edit4.text);       //pomocna pri vyhladavani ci sa tam taky kod vobec nachadza
  AssignFile(subor,nazov+'.txt');
  Append(subor);

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
end;

end.

