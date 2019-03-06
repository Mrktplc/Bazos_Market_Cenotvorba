unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls, ExtCtrls;

type
  tovar=record
    nazov:string;
    ncena,pcena,oldNCena,oldPCena:real;
    kod:integer;
    kodis:integer;
    jeaktivna:boolean;
    verzia:integer;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Timer1: TTimer;
    Vymaz: TButton;
    Edit1: TEdit;
    Image2: TImage;
    Memo2: TMemo;
    Ulozit: TButton;
    Image1: TImage;
    Cena: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure CenaClick(Sender: TObject);
    procedure Reload;
    procedure Reload2;
    procedure Timer1Timer(Sender: TObject);
    //procedure VerziaTimer(Sender: TObject);
    //procedure Timer1Timer(Sender: TObject);
    //procedure Timer1Timer(Sender: TObject);
    procedure UlozitClick(Sender: TObject);
    procedure VymazClick(Sender: TObject);
    procedure Zapis;
    function privelkaNC(iTovaru, novaNC:integer):boolean;
    function nizkaPC(iTovaru, novaPC:integer):boolean;
    procedure zmenaNC;
    procedure zmenaPC;
    procedure NacitanieTovaru;
    procedure Nacitaniecennika;
    procedure VerziaC;
    procedure LockT;
    procedure LockC;
    procedure DeleteLock;
  private
    { private declarations }
  public
    { public declarations }
  end;
Const N=100;
      Path='Z:\\INFProjekt2019\TimA\';
      //path='';
var
  tovary:array[1..N]of tovar;
  subor:textfile;
  pocet_riad,p1,p2,p3,p4:integer;
  AktualC,AktualT:integer;  //aktualne subory
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
AssignFile(subor,path + 'CENNIK_VERZIA.txt');
Reset(subor);
Readln(subor,p1);
CloseFile(subor);
                 AssignFile(subor,path + 'TOVAR_VERZIA.txt');
                 Reset(subor);
                 Readln(subor,p3); //dostanem tam cislo ktore pak porovnavam s aktualnou verziou
                 CloseFile(subor);
image1.picture.LoadFromFile('logo.png');
LockT;
LockC;
NacitanieTovaru;
 //////////////////////////////////////////////////
Nacitaniecennika;
 //Vsuva do tabulky
 Reload;
 DeleteLock;
end;
procedure TForm1.DeleteLock;
begin
     DeleteFile(path + 'TOVAR_LOCK.txt');
     DeleteFile(path + 'CENNIK_LOCK.txt');
end;

procedure TForm1.NacitanieTovaru;
var tovarStrList: TStringList;
  P1,pozB,i,pom,j,h:integer;
  pom_r,pom_s:string;
begin
  tovarStrList:= TStringList.Create;
 tovarStrList.LOadFromFile(path + 'TOVAR.txt');
 //Nacitanie riadkov
 pocet_riad:=strtoint(tovarStrList[0]);
   For i:=1 to pocet_riad do
       begin
         pom_r:=(tovarStrList[i]);
         pom:=Pos(';',pom_r);
         tovary[i].kod:=strtoint(copy(pom_r,1,pom-1));
         Delete(pom_r,1,pom);

         tovary[i].nazov:=pom_r;
         end;
end;
procedure TForm1.Nacitaniecennika;    //ak kod nema cenu: In Construction!!!
var                                   //hodit currency,
  pom_r:string;
  cenaStrList: TStringList;
  pom,i,r:integer;
begin
   cenaStrList:=TStringList.Create;
            cenaStrList.LoadFromFile(path +'CENNIK.txt');
            r:=strtoint(cenaStrList[0]);          //pocet riadkov
            For i:=1 to r do
                begin
                  pom_r:=cenaStrList[i];
                  if (length(pom_r)=3) then begin
                                            tovary[i].jeaktivna:=false;
                                            Cena.Cells[3,i]:=Cena.Cells[3,i]+'*';
                                            Cena.Cells[4,i]:=Cena.Cells[4,i]+'*';
                                            end else begin
                  tovary[i].jeaktivna:=true;
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

end;

procedure TForm1.CenaClick(Sender: TObject);
var  S1,S2:integer;
  P1,P2:integer;
begin
 P1:=Cena.Col;    //zisti mi poziciu vertik
 P2:= Cena.Row;    //zisti mi poziciu horizontalne
 //Memo1.Append(intToStr(P1)+'___'+intToStr(P2));                            //pouzit If,

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
procedure TForm1.Reload2;
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

procedure TForm1.Timer1Timer(Sender: TObject);

begin
  //VerziaC;
  //AssignFile(subor,path + 'TOVAR_VERZIA.txt');
  //Reset(subor);
  //Readln(subor,p4);
 NacitanieCennika;
 NacitanieTovaru
end;



procedure TForm1.LockT;  //lock Tovaru
var LT:boolean;    //lock tovaru
begin
 LT:=false;
 While Not LT do
     begin
     if not fileexists(path + 'TOVAR_LOCK.txt') then begin
      AssignFile(subor, path + 'TOVAR_LOCK.txt');
      rewrite(subor);
      CloseFile(subor);
      LT:=true;
     end;
end;
end;
procedure TForm1.LockC; //lock Cennika
var LC:boolean; //lock Cennika
begin
  LC:=false;
 While Not LC do
     begin
     if not fileexists(path + 'CENNIK_LOCK.txt') then begin
      AssignFile(subor,path + 'CENNIK_LOCK.txt');
      rewrite(subor);
      CloseFile(subor);
       LC:=true;
     end;
end;
end;

procedure TForm1.VerziaC;
begin
 AssignFile(subor,path + 'CENNIK_VERZIA.txt');
 Reset(Subor);
 ReadLn(subor,p2);
 CloseFile(subor);
end;



procedure TForm1.VymazClick(Sender: TObject);
var i:integer;
begin
//vece vyrobit vymazanie suboru
end;

procedure TForm1.Zapis;
var v,i,iHlRiadku, iTovaru:integer;
    nazov,P2,t1,t2,t3,t4,oldRiadok,newRiadok,COldRiadok,CNewRiadok:string;
    tovarStrlist,cenaStrList: TStringList;
     jeaktivna:boolean;
begin
  {tovarStrList:= TStringList.Create;
      tovarStrList.LoadFromFile('TOVAR.txt');
 oldRiadok:= intToStr(tovary[iHlRiadku].kod) +';' +(tovary[iHlRiadku].nazov);
 newRiadok:= inttostr(tovary[iHlRiadku].kod)+';'+ (tovary[iHlRiadku].nazov);
 tovarStrList.Text:= StringReplace(tovarStrList.Text, oldRiadok, newRiadok, [rfIgnoreCase]);
   tovarStrList.SaveToFile('Cennik3.txt');
      tovarStrList.Free; }
 {cenaStrList:= TStringList.Create;
      cenaStrList.LoadFromFile('Cennik9.txt');
      pocet_riad:=strtoint(cenastrlist[0]);
      jeaktivna:=false;
      For iTovaru:= 1 to pocet_riad do
      begin
          For iHlRiadku:=1 to pocet_riad do
              begin
               if (copy(cenastrlist[iHlRiadku],1,3)=inttostr(tovary[iTovaru].kod)) then
                  if tovary[iHlRiadku].jeaktivna then begin                      //napise len kod
                                                       tovary[iHlRiadku].kod
                                                       end else begin

                  cenaStrList[iHlRiadku]:=inttostr(tovary[iHlRiadku].kod)+';'+floattostr(tovary[iHlRiadku].ncena)+';'+floattostr(tovary[iHlRiadku].pcena);
                  break; //v oboch pripadoch (uz sme nasli, mozme zapisat dalsi kod)
                   end;
              end;
      end;
 oldRiadok:= intToStr(tovary[iHlRiadku].kod) + floattostr(tovary[iHlRiadku].oldNCena) + ';' + floattostr(tovary[iHlRiadku].oldPCena);
 newRiadok:= intToStr(tovary[iHlRiadku].kod) + floattostr(tovary[iHlRiadku].ncena)+ ';' + floattostr(tovary[iHlRiadku].pcena);
 cenaStrList.Text:= StringReplace(cenaStrList.Text, oldRiadok, newRiadok, [rfIgnoreCase]);
   cenaStrList.SaveToFile('CENNIK5.txt');
      cenaStrList.Free; }


 {AssignFile(subor,'CENNIK.txt');
 Rewrite(subor);
 Writeln(subor,pocet_riad);
 For iHlRiadku:=1 to pocet_riad do
     begin
     //Memo2.Append(inttostr(pocet_riad));
         t1:=inttostr(tovary[iHlRiadku].kod);
         t2:=tovary[iHlRiadku].nazov;
         t3:=floattostr(tovary[iHlRiadku].oldNCena);
         t4:=FloatToStr(tovary[iHlRiadku].oldPCena);
         writeln(subor, t1+';'+t3+';'+t4);
     end; }

 LockC;
 DeleteLock;


 AssignFile(subor,path + 'CENNIK.txt');
 Rewrite(subor);
 Writeln(subor,pocet_riad);
 For i:=1 to pocet_riad do
     begin
     t1:=inttostr(tovary[i].kod);
     t3:=floattostr(tovary[i].ncena);
     t4:=floattostr(tovary[i].pcena);
     writeln(subor, t1+';'+t3+';'+t4);
     Memo2.Append(t1+';'+t3+';'+t4);
     end;
   CloseFile(subor);
 ////////////////////////////////////////
   AssignFile(subor,path + 'CENNIK_VERZIA.txt');
  Reset(subor);
  Readln(subor,v);

    Rewrite(subor);
    Writeln(subor,v+1);
    CloseFile(subor);

end;

function TForm1.privelkaNC(iTovaru, novaNC:integer):boolean;
var chcezmenit:integer;
begin
 IF novaNC > tovary[iTovaru].pcena
    then begin
        chcezmenit:= MessageDlg('Chcete nastavit vyssiu nakupnu cenu ako ' +
                     'predajnu?', MtCustom, MBOkCancel, 0);
        if chcezmenit = MrOk then begin
            exit(false);
        end else begin
            exit(true);
        end;
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
//Memo1.Append(P1+'__'+P2);
 i:=Cena.Row;            //do i vkladam udaje z pozicky 1, neskor i pouzivam pri tovare aby som vedel kde som to zmenil
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
if number >=0
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
// P2:=inttostr(Cena.Row);   //do pozicie P1 som si nahral hor cisla,
 i:=Cena.Row;            //do i vkladam udaje z pozicky 1, neskor i pouzivam pri tovare aby som vedel kde som to zmenil
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
if number >= 0
    then
     tovary[i].pcena:=number
     else
       ShowMessage('Zadaj vyssiu cenu');
/////////////////////////////////
 Reload;
 Zapis;
end;
procedure TForm1.UlozitClick(Sender: TObject);
begin
image2.picture.LoadFromFile('204.jpg');
DeleteFile(path + 'TOVAR_LOCK.txt');
DeleteFile(path + 'CENNIK_LOCK.txt');
  //Zapis;
end;
end.

