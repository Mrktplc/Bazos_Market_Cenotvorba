unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Menus;

type
  tovar=record
    ncena:integer; //nakupna tovar
    pcena:integer; //predajna tovar
    kod:integer; //kod tovaru
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    zmenaNceny: TButton;
    zmenaPCeny: TButton;
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
    procedure zmenaNcenyClick(Sender: TObject);
    procedure zmenaPCenyClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;
 Const N=100;

var
  tovary:array[1..N]of tovar;
  subor:textfile;
  pocet_riad:integer;
  nc:integer; //nakupnacena
  pc:integer; //predajnacena
  nazov:string;  //berie sa nazov zoznamu z edit.1, neskor zmenim na Radiobutton alebo checkbox
  i:integer;
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
Var
pom,j:integer;
pom_s:string;
begin
 AssignFile(subor,'cennik.txt');       //moze sa zmenit na nazov+
 Reset(subor);
 Readln(subor,pom_s);
 pocet_riad:=strtoint(pom_s);
 for i:=1 to  pocet_riad do
  begin
  readln(subor,pom_s);
  pom:=Pos(';',pom_s);    //Opravene. malo to byť naopak ^^
  tovary[i].kod:=Strtoint(Copy(pom_s,1,pom-1)); //nacitanie kod do pola

  Delete(pom_s,1,pom); //odreze kod zo nacitaneho riadku

  pom:=Pos(';',pom_s);
  tovary[i].ncena:=Strtoint(Copy(pom_s,1,pom-1)); //naciatnie nakupnej ceny

  Delete(pom_s,1,pom); //odreze nakupna tovar zo nacitaneho riadku

  pom:=Length(pom_s);
  tovary[i].pcena:=Strtoint(Copy(pom_s,1,pom));

  end;
 CloseFile(subor); //END of naćitanie
end;

procedure TForm1.Button2Click(Sender: TObject);
var
pom1:integer;
pom2:integer;
pom3:integer;
iTovaru: integer;
begin
 {Memo1.Clear;
  pom1:=strtoint(edit2.text);          //zmena nakupnej ceny
  pom2:=strtoint(edit3.text);          //zmena predajnej ceny
  pom3:=strtoint(edit4.text);          //kod na pororvnanie
  tovary[i].ncena:=pom1;
  tovary[i].pcena:=pom2;
    AssignFile(subor,'cennik.txt');
    Append(subor);


    iTovaru:= 1;
    while(pom3 <> tovary[iTovaru].kod) do inc(iTovaru); }



end;

procedure TForm1.Button3Click(Sender: TObject);
var i:integer;
begin
  memo1.append('Kod___Nakupna cena___Predajna cena');
  for i:=1 to pocet_riad do
   begin
   memo1.append(InttoStr(tovary[i].kod)+'____'+InttoStr(tovary[i].ncena)+'____'+InttoStr(tovary[i].pcena));
   end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
end;

procedure TForm1.zmenaNcenyClick(Sender: TObject);
var
   chcemString, inputRiadok: string;
   chcemInteger:integer;
   pom3,hlKod,iTovaru:integer;
begin
  //pom3:=strtoint(edit4.text);
  //chcemString:=inputbox('Zmena Predajnej Ceny','Zadaj novu cenu', inputRiadok);
  chcemInteger:=strtoint(inputbox('Zmena Predajnej ceny','Zadaj novu cenu',inputRiadok));

  iTovaru:= 1;
   // while(pom3 <> tovary[iTovaru].kod) do inc(iTovaru);
end;

procedure TForm1.zmenaPCenyClick(Sender: TObject);
var
   chcemString, inputRiadok: string;
   chcemInteger: integer;
   pom3,hlKod,iTovaru:integer;
begin
  //pom3:=strtoint(edit4.text);
     //chcemString:= inputbox('Zadaj novu cenu','toto mi daj', inputRiadok);
     chcemInteger:= strToInt(inputbox('Predajna cena', 'Zadaj novu predajnu cenu', inputRiadok));
     Memo1.Append(chcemString +' '+ intToStr(chcemInteger));

     iTovaru:= 1;
    //while(pom3 <> tovary[iTovaru].kod) do inc(iTovaru);

end;

end.

