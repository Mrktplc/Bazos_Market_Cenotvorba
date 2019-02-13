unit Unit1;                                     //Nova Aplikacia cenotvorba

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, LCLType;

type
  tovar=record
    ncena:currency; //nakupna cena
    pcena:Currency; //predajna cena
    kod:integer; //kod tovaru
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Label2: TLabel;
    Label3: TLabel;
    ListBox2: TListBox;
    ListBox3: TListBox;
    Label1: TLabel;
    ListBox1: TListBox;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure Reload;
    function privelkaNC(iTovaru, novaNC:Integer):boolean;
    procedure Zapis;
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
  nacena:currency;   //len na ukazku, neskor sa bude prerabat
  prcena:currency;   //globalna ktora sluzi len na demonstraciu
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var i, pom:integer;
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
  Reload;
end;

procedure TForm1.Button1Click(Sender: TObject);
var i:integer;
begin
Memo1.Append(currtostr(tovary[i].ncena));
end;

procedure TForm1.Reload;
var i:integer;
begin
 Listbox1.Clear;
 Listbox2.Clear;
 Listbox3.Clear;                               //dorobit cenu
 For i:=1 to pocet_riad do
     begin
     ListBox1.Items.Add(inttostr(tovary[i].kod));
     Listbox2.Items.Add(currtostr(tovary[i].ncena)+'€');
     Listbox3.Items.Add(currtostr(tovary[i].pcena)+'€');
     end;
 end;
function TForm1.privelkaNC(iTovaru, novaNC:Integer):boolean;
begin
 If novaNC > tovary[iTovaru].pcena
     then begin
      Showmessage('Zadaj nizsiu cenu');
      exit(true);
     end else begin
     exit(false);
     end;

    end;
procedure TForm1.Zapis;
var i:integer;
begin
 Assignfile(subor,'cennik4.txt');
 Rewrite(subor);
 writeln(subor,pocet_riad);
 For i:=1 to 3 do
     begin
     writeln(subor,tovary[i].kod);
     writeln(subor,tovary[i].ncena);
     writeln(subor,tovary[i].pcena);
     end;
 CloseFile(subor);
end;


// Začína Listbox sekcia, klikanie a úprava cien
//Listbox 2
procedure TForm1.ListBox2Click(Sender: TObject);  //na klik mi vyskoci okienko,kde zadavam novu ncena
var
  QueryResult,success: Boolean;
  UserString: string;
  number,i:integer;
  jePrivelkaNC:boolean;
begin
 jePrivelkaNC:=false;
//////////////////////////////////////////////////// zistuje na ktorej pozicii sa nachadzame
   if ListBox2.ItemIndex > 0 then
    ListBox3.ItemIndex;

   i:=Listbox2.ItemIndex;
     i:=i+1;
////////////////////////////////////////////////////  nepusti ked clovek zada string
     if InputQuery('Nova cena', 'Zadaj novu cenu', UserString) = True
      then
       begin
         success:=TryStrtoInt(UserString, number);                                     //odobrit nech zostane predtym zadana cena
         if not success then begin
          ShowMessage('Zadaj cenu, nie abecedu!');
          exit;
         end;
       end
     else begin
          exit;
     end;
/////////////////////////////////// porovnavanie nceny a pceny
  jePrivelkaNC:=privelkaNC(i,number);
  if jePrivelkaNC then begin
   exit;
   end;
////////////////////////////////// nepusti ked cena je mensia ako nula
    if number>0     //kontrola ceny aby nebola zaporna
     then
   tovary[i].ncena:=number
        else
        ShowMessage('Zadaj vyssiu cenu');

//////////////////////////////////
Reload;
  end;

//Listbox 3
procedure TForm1.ListBox3Click(Sender: TObject);     //na klik mi vyskoci okienko,kde zadavam novu pcena
var
  QueryResult,success: Boolean;
  UserString: string;
  number,i:integer;
begin
 ///////////////////////////////// zistuje miesto v poli
   if ListBox3.ItemIndex > 0 then    //Delete only when a string in the listbox is selected
    ListBox3.Items.Delete(ListBox1.ItemIndex);

   i:=Listbox3.ItemIndex;
     i:=i+1;
///////////////////////////////// nepusti zadavanie slov ale iba ceny
 if InputQuery('Nova cena', 'Zadaj novu cenu', UserString) = True  //zadavanie novej ceny+ robit overovanie
  then
    begin
         success:=TryStrtoInt(UserString, number);
         if not success then begin
          ShowMessage('Zadaj cenu, nie abecedu!');  //vyskoci okno aby
          exit;
          end;
       end
     else begin
          exit;
       end;

////////////////////////////////// kontroluje aby cena nebola zaporna


 if number>0
     then
   tovary[i].pcena:=number
        else
        ShowMessage('Zadaj nenulovu cenu');
/////////////////////////////////
 Reload;

   end;
end.

