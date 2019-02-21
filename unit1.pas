unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls, ExtCtrls;

type
  tovar=record
    nazov:string;
    ncena,pcena:real;
    kod:integer;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Edit1: TEdit;
    Memo2: TMemo;
    Ulozit: TButton;
    Image1: TImage;
    Memo1: TMemo;
    Cena: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure CenaClick(Sender: TObject);
    procedure Reload;
    procedure UlozitClick(Sender: TObject);
    procedure Zapis;
    function privelkaNC(iTovaru, novaNC:integer):boolean;
    function nizkaPC(iTovaru, novaPC:integer):boolean;
    procedure zmenaNC;
    procedure zmenaPC;
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
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var i, pom:integer;
  pom_s:string;
begin
image1.picture.LoadFromFile('logo.png');
  AssignFile(subor,'tovar4.txt');
  Reset(subor);
  Readln(subor,pom_s);
 //////////////////////
 //Nacitanie
 pocet_riad:=strtoint(pom_s);
 Memo1.Append(inttostr(pocet_riad));
   For i:=1 to pocet_riad do
       begin
         readln(subor,pom_s);
         pom:=Pos(';',pom_s);
         tovary[i].kod:=StrToInt(Copy(pom_s,1,pom-1));
         Delete(pom_s,1,pom); //odreze kod z nacitaneho riadku

         pom:=Pos(';',pom_s);
         tovary[i].nazov:=copy(pom_s,1,pom-1);
         Delete(pom_s,1,pom); //odreze nazov

         pom:=Pos(';',pom_s);
         tovary[i].ncena:=StrToFloat(copy(pom_s,1,pom-1));
         Delete(pom_s,1,pom); //odreze nakupnu cenu s ;

         //pom:=Pos(';',pom_s);
         //tovary[i].pcena:=StrToFloat(Copy(pom_s,1,length(pom_s)));
         tovary[i].pcena:= StrToFloat(pom_s);
       end;
 CloseFile(subor);
 /////////////////////////
 //Vsuva do tabulky
 Reload;
end;

procedure TForm1.CenaClick(Sender: TObject);
var  S1,S2:integer;
  P1,P2:string;
begin
 P1:=inttostr(Cena.Col);    //zisti mi poziciu vertik
 P2:=inttostr(Cena.Row);    //zisti mi poziciu horizontalne
 S1:=strtoint(P1);
 Memo1.Append(P1+'___'+P2);                            //pouzit If,

 IF 3 = S1 then
    begin
     ZmenaNC;
     exit;
    end;
 IF 4 = S1 then
    Begin
     ZmenaPC;
     exit;
    end;
end;

procedure TForm1.Reload;
var i,j:integer;
  c1,c2:real;
begin
  For i:=1 to pocet_riad do
      begin
        c1:=(tovary[i].ncena) /100;
        c2:=(tovary[i].pcena) /100;
        Cena.Cells[0,i]:=Inttostr(i);
        Cena.Cells[1,i]:=inttostr(tovary[i].kod);
        Cena.Cells[2,i]:=tovary[i].nazov;
        Cena.Cells[3,i]:=FormatFloat('0.## €',(c1));
        Cena.Cells[4,i]:=FormatFloat('0.## €',(c2));
        Memo2.Append(floattostr((c1)));
      end;

end;

procedure TForm1.UlozitClick(Sender: TObject);
begin
  Zapis;
end;

procedure TForm1.Zapis;
var i:integer;
    t1,t2,t3,t4:string;
begin
 AssignFile(subor,'cennik2.txt');
 Rewrite(subor);
 Writeln(subor,pocet_riad);
 For i:=1 to pocet_riad do
     begin
         t1:=inttostr(tovary[i].kod);
         t2:=tovary[i].nazov;
         t3:=floattostr(tovary[i].ncena);
         t4:=FloatToStr(tovary[i].pcena);
         writeln(subor, t1+';'+t3+';'+t4);
     end;

end;
function TForm1.privelkaNC(iTovaru, novaNC:integer):boolean;
begin
 IF novaNC > tovary[iTovaru].pcena
    then begin
      Showmessage('Zadaj nizsiu cenu');
      exit(true);
      end else begin
          exit(false);
    end;
end;
function TForm1.nizkaPC(iTovaru, novaPC:integer):boolean;
begin
 IF novaPC > tovary[iTovaru].ncena
    then begin
      Showmessage('Zadaj nizsiu cenu');
      exit(true);
      end else begin
          exit(false);
    end;
end;
procedure TForm1.zmenaNC;
var
   QueryResult,success:Boolean;
  UserString,P2:string;
  number,i:integer;
  jePrivelkaNC:boolean;
begin
 jePrivelkaNC:=false;
///////////////////////////////
 P2:=inttostr(Cena.Row);   //do pozicie P1 som si nahral hor cisla,
 i:=strtoint(P2);            //do i vkladam udaje z pozicky 1, neskor i pouzivam pri tovare aby som vedel kde som to zmenil
//Memo1.Append(inttostr(i));
///////////////////////////////
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
/////////////////////////////////////
jePrivelkaNC:=privelkaNC(i, number);
if jePrivelkaNC then begin
 exit;
 end;
//////////////////////////////////
if number > 0
    then
     tovary[i].ncena:=number
     else
       ShowMessage('Zadaj vyssiu cenu');
/////////////////////////////////
 Reload;
 Zapis;
end;
procedure TForm1.ZmenaPC;
var
   QueryResult,success:Boolean;
  UserString,P2:string;
  number,i:integer;
  jeNizkaPC:boolean;
begin
 jeNizkaPC:=false;
///////////////////////////////
 P2:=inttostr(Cena.Row);   //do pozicie P1 som si nahral hor cisla,
 i:=strtoint(P2);            //do i vkladam udaje z pozicky 1, neskor i pouzivam pri tovare aby som vedel kde som to zmenil
//Memo1.Append(inttostr(i));
///////////////////////////////
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
/////////////////////////////////////
jeNizkaPC:=nizkaPC(i, number);
if jeNizkaPC then begin
 exit;
 end;
//////////////////////////////////
if number > 0
    then
     tovary[i].ncena:=number
     else
       ShowMessage('Zadaj vyssiu cenu');
/////////////////////////////////
 Reload;
 Zapis;
end;
end.

