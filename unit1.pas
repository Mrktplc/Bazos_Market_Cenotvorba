unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Menus;

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
    Button3: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;
 Const N=100;

var
  pole:array[1..N]of cena;
  subor:textfile;
  pocet_riad:integer;
  nc:integer; //nakupnacena
  pc:integer; //predajnacena
  nazov:string;  //berie sa nazov zoznamu z edit.1
  i:integer;
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
Var
pom,j:integer;
pom_s,pom_pom_pom:string;
begin
 AssignFile(subor,'cennik.txt');       //moze sa zmenit na nazov+
 Reset(subor);
 Readln(subor,pom_s);
 pocet_riad:=strtoint(pom_s);
 for i:=1 to  pocet_riad do
  begin
  readln(subor,pom_s);
  pom:=Pos(';',pom_s);    //Opravene. malo to byť naopak ^^
  pole[i].kod:=Strtoint(Copy(pom_s,1,pom-1)); //nacitanie kod do pola

  Delete(pom_s,1,pom); //odreze kod zo nacitaneho riadku

  pom:=Pos(';',pom_s);
  pole[i].ncena:=Strtoint(Copy(pom_s,1,pom-1)); //naciatnie nakupnej ceny

  Delete(pom_s,1,pom); //odreze nakupna cena zo nacitaneho riadku

  pom:=Length(pom_s);
  pole[i].pcena:=Strtoint(Copy(pom_s,1,pom));

  end;
 CloseFile(subor); //END of naćitanie
end;

procedure TForm1.Button2Click(Sender: TObject);
var
pom1:integer;
pom2:integer;
pom3:integer;
begin
 Memo1.Clear;
  pom1:=strtoint(edit2.text);
  pom2:=strtoint(edit3.text);
  pom3:=strtoint(edit4.text);
  pole[i].ncena:=pom1;
  pole[i].pcena:=pom2;
    AssignFile(subor,'cennik.txt');
    Append(subor);

    If pom3=pole[i].kod then
                            begin



 //Memo1.Append(inttostr(pom1));
 //Memo1.Append(inttostr(pom2));
 //Memo1.Append(inttostr(pole[i].ncena));
end;

procedure TForm1.Button3Click(Sender: TObject);
var i:integer;
begin
  memo1.append('Kod___Nakupna cena___Predajna cena');
  for i:=1 to pocet_riad do
   begin
   memo1.append(InttoStr(pole[i].kod)+'____'+InttoStr(pole[i].ncena)+'____'+InttoStr(pole[i].pcena));
   end;
  For i:=1 to pocet_riad do
   begin
   memo1.append(inttostr(pole[i].ncena));
   //memo1.Append(inttostr(pole[i].pcena));
   end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
end;

end.

