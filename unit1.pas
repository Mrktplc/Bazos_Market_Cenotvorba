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
    kodis:integer;
    jeaktivna:boolean;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Edit1: TEdit;
    Memo2: TMemo;
    Ulozit: TButton;
    Image1: TImage;
    Memo1: TMemo;
    Cena: TStringGrid;
    Verzia: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure CenaClick(Sender: TObject);
    procedure Reload;
    //procedure Timer1Timer(Sender: TObject);
    //procedure Timer1Timer(Sender: TObject);
    procedure UlozitClick(Sender: TObject);
    procedure VerziaTimer(Sender: TObject);
    procedure Zapis;
    function privelkaNC(iTovaru, novaNC:integer):boolean;
    function nizkaPC(iTovaru, novaPC:integer):boolean;
    procedure zmenaNC;
    procedure zmenaPC;
    procedure Nacitaniecennika;
    procedure Verzie;
    procedure Lock;
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
var tovarStrList, cenaStrList: TStringList;
  P1,pozB,i,pom,j,h:integer;
  pom_r,pom_s:string;
begin
image1.picture.LoadFromFile('logo.png');
Lock;
 tovarStrList:= TStringList.Create;
 tovarStrList.LOadFromFile('TOVAR.txt');
 //////////////////////
 //Nacitanie
 pocet_riad:=strtoint(tovarStrList[0]);
 //Memo1.Append(inttostr(pocet_riad));
   For i:=1 to pocet_riad do
       begin
         pom_r:=(tovarStrList[i]);
         pom:=Pos(';',pom_r);
         tovary[i].kod:=strtoint(copy(pom_r,1,pom-1));
         Delete(pom_r,1,pom);

         //pom_r:=(tovarStrList[i]);
         //Memo1.Append(pom_r);
         tovary[i].nazov:=(copy(pom_r,1,length(pom_r)));

         end;
//////////////////////////////////////////////////
Nacitaniecennika;
{P1:=Cena.Col;
P1:=P1+1;
      cenaStrList:=TStringList.Create;
            cenaStrList.LoadFromFile('cennik9.txt');
            j:=strtoint(cenaStrList[0]);          //pocet riadkov
             Memo2.Append(inttostr(j));
            For i:=1 to pocet_riad do
                begin
                  pom_s:=cenaStrList[i];     //if length pom_t > 3 then nech pokracuje program, ak nie tak nech stopne alebo to hodi inam
                  if (length(pom_s)>=3) then begin
                   Tovary[i].jeAktivna:=false;
                   Cena.Cells[0, P1]:=Cena.Cells[0, P1]+ '*';
                   Cena.Cells[2, P1]:='';
                  end else begin
                  Memo2.Append(pom_s);
                  pozB:=Pos(';',pom_s);

                 // tovary[i].kodis:=strtoint(copy(pom_s,1,pozB-1));
                  Delete(pom_s,1,3);

                  pozB:=Pos(';',pom_s);
                  tovary[i].ncena:=strtofloat(copy(pom_s,1,pozB-1));
                  Delete(pom_s,1,pozB);

                  tovary[i].pcena:=strtofloat(pom_s);
                  end;
                end;  }
////////////////////////////////////////////////////
         {pom:=Pos(';',pom_s);
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
         tovary[i].pcena:= StrToFloat(pom_s);}
 /////////////////////////
 //Vsuva do tabulky
 Reload;
end;
procedure TForm1.Nacitaniecennika;
var
  pom_r:string;
  cenaStrList: TStringList;
  pom,i,r:integer;
begin
   cenaStrList:=TStringList.Create;
            cenaStrList.LoadFromFile('CENNIK9.txt');
            r:=strtoint(cenaStrList[0]);          //pocet riadkov
            For i:=1 to r do
                begin
                  pom_r:=cenaStrList[i];
                  pom:=Pos(';',pom_r);
                  tovary[i].kodis:=strtoint(copy(pom_r,1,pom-1));
                  Delete(pom_r,1,pom);
                  //Memo2.Append(inttostr(pom)+'___'+pom_r);

                  pom:=Pos(';',pom_r);
                  tovary[i].ncena:=strtofloat(copy(pom_r,1,pom-1));
                  Delete(pom_r,1,pom);
                 // Memo2.Append(inttostr(pom)+'___'+pom_r);

                  tovary[i].pcena:=strtofloat(pom_r);
                end;
end;

procedure TForm1.CenaClick(Sender: TObject);
var  S1,S2:integer;
  P1,P2:integer;
begin
 P1:=Cena.Col;    //zisti mi poziciu vertik
 P2:= Cena.Row;    //zisti mi poziciu horizontalne
 Memo1.Append(intToStr(P1)+'___'+intToStr(P2));                            //pouzit If,

 IF (3 = P1) then
    begin
     ZmenaNC;
     exit;
    end;
 IF (4 = P1) then
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
        //Memo2.Append(floattostr((c1)));
      end;

end;
procedure TForm1.Lock;
begin
 While Not Fileexists('TOVAR_LOCK.txt') do
     begin
   Filecreate('TOVAR_LOCK.txt');
     end;
end;

procedure TForm1.UlozitClick(Sender: TObject);
begin
  Zapis;
end;
procedure TForm1.Verzie;
begin

end;

procedure TForm1.VerziaTimer(Sender: TObject);
begin

end;

procedure TForm1.Zapis;
var i:integer;
    t1,t2,t3,t4,oldRiadok,newRiadok,COldRiadok,CNewRiadok:string;
    tovarStrlist,cenaStrList: TStringList;
begin
  tovarStrList:= TStringList.Create;
      tovarStrList.LoadFromFile('TOVAR.txt');
 oldRiadok:= intToStr(tovary[i].kod);// +(tovary[i].nazov);
 newRiadok:= inttostr(tovary[i].kod); //+ (tovary[i].nazov);
 tovarStrList.Text:= StringReplace(tovarStrList.Text, oldRiadok, newRiadok, [rfIgnoreCase]);
   tovarStrList.SaveToFile('Cennik3.txt');
      tovarStrList.Free;

 cenaStrList:= TStringList.Create;
      cenaStrList.LoadFromFile('Cennik9.txt');
 oldRiadok:= floattostr(tovary[i].ncena) + ';' + floattostr(tovary[i].pcena);
 newRiadok:= floattostr(tovary[i].ncena)+ ';' + floattostr(tovary[i].pcena);
 tovarStrList.Text:= StringReplace(cenaStrList.Text, oldRiadok, newRiadok, [rfIgnoreCase]);
   tovarStrList.SaveToFile('Cennik3.txt');
      tovarStrList.Free;


 {AssignFile(subor,'cennik3.txt');
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

end;}

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
var chcezmenit:integer;
begin
 IF novaPC < tovary[iTovaru].ncena
    then begin
        chcezmenit:= MessageDlg('Chcete nastavit nizsiu predajnu  cenu ako ' +
                     'nakupnu?', MtCustom, MBOkCancel, 0);
        if chcezmenit = MrOk then begin
            exit(false);
        end else begin
            exit(true);
        end;
    end else begin
        exit(false);
    end;
end;
procedure TForm1.zmenaNC;
var
   QueryResult,success:Boolean;
  UserString,P2,P1:string;
  number,i:integer;
  jePrivelkaNC:boolean;
begin
 jePrivelkaNC:=false;
///////////////////////////////
P1:=inttostr(Cena.Col);
P2:=inttostr(Cena.Row);   //do pozicie P1 som si nahral hor cisla,
Memo1.Append(P1+'__'+P2);
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

