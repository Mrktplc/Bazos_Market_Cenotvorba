unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls;

type
  tovar=record
    nazov:string;
    ncena,pcena:real;
    kod:integer;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Ponuka: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure Reload;
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
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var i, pom:integer;
  pom_s:string;
begin
//image1.picture.LoadFromFile('logo.bmp');
  AssignFile(subor,'tovar3.txt');
  Reset(subor);
  Readln(subor,pom_s);
 //////////////////////
 //Nacitanie
 pocet_riad:=strtoint(pom_s);
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
procedure TForm1.Reload;
var i,j:integer;
  c1,c2:real;
begin
     For i:=1 to pocet_riad do   //zapis do riadkov
     begin
         //tahanie z pola podla postupu
         c1:=(tovary[i].ncena) / 100;
         c2:=(tovary[i].pcena) / 100;
         Ponuka.Cells[0,i]:= IntToStr(i);
         Ponuka.Cells[1,i]:=IntToStr(tovary[i].kod);
         Ponuka.Cells[2,i]:=tovary[i].nazov;
         Ponuka.Cells[3,i]:=FormatFloat('0.## €',(c1));
         Ponuka.Cells[4,i]:=FormatFloat('0.## €',(c2));
     end;
end;
procedure TForm1.Zapis;
var i:integer;
    t1,t2,t3,t4:string;
begin
 AssignFile(subor,'cennik.txt');
 Rewrite(subor);
 Writeln(subor,pocet_riad);
 For i:=1 to pocet_riad do
     begin
         t1:=inttostr(tovary[i].kod);
         t2:=tovary[i].nazov;
         t3:=floattostr(tovary[i].ncena);
         t4:=FloatToStr(tovary[i].pcena);
         writeln(subor, t1+';'+t2+';'+t3+';'+t4);
     end;

end;

end.

