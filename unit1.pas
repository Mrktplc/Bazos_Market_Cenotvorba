unit Unit1;                                     //Nova Aplikacia cenotvorba

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  LCLType, ExtCtrls;

type
  tovar=record
    nazov:string; //nazov produktu
    ncena:real; //nakupna cena
    pcena:real; //predajna cena
    kod:integer; //kod tovaru
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListBox2: TListBox;
    ListBox3: TListBox;
    Label1: TLabel;
    ListBox1: TListBox;
    ListBox4: TListBox;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure Reload;
    function privelkaNC(iTovaru, novaNC:Integer):boolean;
    function nizkaPC(iTovaru, novaPC:integer):boolean;
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
  nacena:integer;   //len na ukazku, neskor sa bude prerabat
  prcena:integer;   //globalna ktora sluzi len na demonstraciu
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var i, pom:integer;
  pom_s,pom_t:string;
begin
 image1.picture.LoadFromFile('logo.bmp');
 AssignFile(subor,'tovar3.txt');
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
       tovary[i].nazov:=copy(pom_s,1,pom-1);
       delete(pom_s,1,pom);


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
  t1,t2:string;
  c1,c2,c3,c4:real;
begin
 Listbox1.Clear;
 Listbox2.Clear;
 Listbox3.Clear;            //dorobit cenu
 Listbox4.Clear;
 For i:=1 to pocet_riad do
     begin
     {
     c1:=(tovary[i].ncena) / 100;
     c2:=(tovary[i].pcena) / 100;
     c3:=StrtoFloat(FormatFloat('0.##',(c1)));
     c4:=StrtoFloat(FormatFloat('0.##',(c2)));
     ListBox1.Items.Add(inttostr(tovary[i].kod));
     Listbox2.Items.Add(FloattoStr(c3));
     Listbox3.Items.Add(FloattoStr(c4));
     Listbox4.Items.Add(tovary[i].nazov);
     }
     c1:=(tovary[i].ncena) / 100;
     c2:=(tovary[i].pcena) / 100;
     ListBox1.Items.Add(inttostr(tovary[i].kod));
     Listbox2.Items.Add(FormatFloat('0.## €',(c1)));
     Listbox3.Items.Add(FormatFloat('0.## €',(c2)));
     Listbox4.Items.Add(tovary[i].nazov);
     end;
 end;
function TForm1.privelkaNC(iTovaru, novaNC:Integer):boolean;
begin
 If novaNC > tovary[iTovaru].pcena
     then begin
      if MessageDlg('Zmena nakupnej ceny', 'Chcete nastavit nakupnu cenu vyssiy  ako predajnu cenu?', mtConfirmation,
   [mbYes, mbNo],0) = mrYes then
      exit(false);
     end else begin
     exit(true);
     end;

    end;
function TForm1.nizkaPC(iTovaru, novaPC:integer):boolean;
begin
  IF novaPC < tovary[iTovaru].ncena
      then begin
      if MessageDlg('Zmena predajnej ceny', 'Chcete nastavit predajnu cenu nizsiu ako nakupnu cenu?', mtConfirmation,
   [mbYes, mbNo],0) = mrYes then
       exit(false);
      end else begin
           exit(true);
      end;
end;

procedure TForm1.Zapis;
var i:integer;
  t1,t2,t3,t4:string;
begin
 Assignfile(subor,'cennik5.txt');
 Rewrite(subor);
 writeln(subor,pocet_riad);
 For i:=1 to pocet_riad do
     begin
     t1:=inttostr(tovary[i].kod);
     t2:=floattostr(tovary[i].ncena);
     t3:=floattostr(tovary[i].pcena);
     t4:=(tovary[i].nazov);
     writeln(subor,t1+';'+t4+';'+t2+';'+t3);
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
    if number>=0     //kontrola ceny aby nebola zaporna
     then
   tovary[i].ncena:=number
        else
        ShowMessage('Zadaj vyssiu cenu');

//////////////////////////////////
Zapis;
Reload;
  end;

//Listbox 3
procedure TForm1.ListBox3Click(Sender: TObject);     //na klik mi vyskoci okienko,kde zadavam novu pcena
var
  QueryResult,success: Boolean;
  UserString: string;
  number,i:integer;
  jeNizkaPC:boolean;
begin
     jeNizkaPC:=false;
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

 ///////////////////////////////// porovnanie pceny a nceny, pcene nemoze byt mensia ako ncena
  jeNizkaPC:=nizkaPC(i, number);
  IF jeNizkaPC THEN begin
   exit;
   end;
////////////////////////////////// kontroluje aby cena nebola zaporna
 if number>=0
     then
   tovary[i].pcena:=number
        else
        ShowMessage('Zadaj nenulovu cenu');
/////////////////////////////////
 Zapis;
 Reload;

   end;
end.

