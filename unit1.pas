unit Unit1;                                     //Nova Aplikacia cenotvorba

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, LCLType;

type
  tovar=record
    ncena:integer; //nakupna cena
    pcena:integer; //predajna cena
    kod:integer; //kod tovaru
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Relod: TButton;
    Label2: TLabel;
    Label3: TLabel;
    ListBox2: TListBox;
    ListBox3: TListBox;
    Nacitaj: TButton;
    Label1: TLabel;
    ListBox1: TListBox;
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure NacitajClick(Sender: TObject);
    procedure RelodClick(Sender: TObject);
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
  nacena:integer;   //len na ukazku, neskor sa bude prerabat
  prcena:integer;   //globalna ktora sluzi len na demonstraciu
  i:integer;
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.NacitajClick(Sender: TObject);
var
  i,pom:integer;     //i=uroven zapisania, pom= nahravanie udajov, pom_s=string sa nahrava
  pom_s:string;
begin
AssignFile(subor,'tovar.txt');
 Reset(subor);
 Readln(subor,pom_s);
////////////////////
//Nacitanie
pocet_riad:=strtoint(pom_s);
 For i:=1 to pocet_riad do
     begin
       readln(subor,pom_s);
       pom:=Pos(';',pom_s);
       tovary[i].kod:=Strtoint(Copy(pom_s,1,pom-1));    //nacitanie kodu do pola
       Delete(pom_s,1,pom); //odreze kod z nacitaneho riadku

        pom:=Pos(';',pom_s);
        tovary[i].ncena:=strtoint(copy(pom_s,1,pom-1));
        Delete(pom_s,1,pom); //odreze nakupnu cena z nacitaneho riadku

         pom:=Length(pom_s);
         tovary[i].pcena:=Strtoint(Copy(pom_s,1,pom));
     end;
 CloseFile(subor);
 /////////////////////////
 //Vsuvka do Listbox
 For i:=1 to pocet_riad do
     begin
     ListBox1.Items.Add(inttostr(tovary[i].kod));
     Listbox2.Items.Add(inttostr(tovary[i].ncena));
     Listbox3.Items.Add(inttostr(tovary[i].pcena));
     end;
end;
// Začína Listbox sekcia, klikanie a úprava cien
//Listbox 2
procedure TForm1.ListBox2Click(Sender: TObject);  //na klik mi vyskoci okienko,kde zadavam novu ncena
var
  QueryResult: Boolean;
  UserString: string;
begin
 if InputQuery('Nova cena', 'Zadaj novu cenu', UserString) = True
 then tovary[i].ncena:=strtoint(UserString)
 else exit;

 Listbox2.Clear;
 Listbox2.Items.Add(inttostr(tovary[i].ncena));
  end;
//Listbox 3
procedure TForm1.ListBox3Click(Sender: TObject);     //na klik mi vyskoci okienko,kde zadavam novu pcena
var
  QueryResult: Boolean;
  UserString: string;
begin
 if InputQuery('Nova cena', 'Zadaj novu cenu', UserString) = True
  then tovary[i].pcena:=strtoint(UserString)
  else exit;

 Listbox3.Clear;
 Listbox3.Items.Add(inttostr(tovary[i].pcena));
   end;
end.

