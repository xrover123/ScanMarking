unit Unit1;

interface

uses
  VCLFixes, VCLFixPack, VCLFlickerReduce, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, RxMemDS, Grids, DBGrids, Buttons,
  ComCtrls, Unit2;
type
  TPrc = procedure of object;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    KIZ: TEdit;
    DBGrid1: TDBGrid;
    MT: TRxMemoryData;
    DataSource1: TDataSource;
    MinusButton: TSpeedButton;
    OKButton: TButton;
    Panel2: TPanel;
    Splitter1: TSplitter;
    NOMEN_CODE: TEdit;
    NOMEN_NAME: TRichEdit;
    NOTE: TLabel;
    AddButton: TButton;
    Timer1: TTimer;
    PlusButton: TSpeedButton;
    procedure CheckAction;
    procedure RunAction(Act: byte);
    procedure FormResize(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure Panel2Resize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function GET_IND(sKIZ: String):integer;
  private
    ActPrc: TPrc;
    CheckMark: TCheckMark;
    CNT_CHECK: integer;

    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
{$R *.dfm}

function TForm1.GET_IND(sKIZ: String):integer;
var i:integer;
begin
MT.First;
i:=-1;
while not MT.Eof do
  begin
  inc(i);
  if MT.FieldByName('KIZ').AsString=sKIZ then
    begin
    result:=i;
    exit;
    end;
  MT.Next
  end;
result:=-1;
end;

procedure TForm1.CheckAction;
var i, j:integer;
    bLST, bERR: boolean;
begin
bLST:=false;
try
  BusySign:=True;
  with CheckMark do
    begin
    if RS.CNT>0 then
      begin
      for i:=0 to RS.CNT-1 do
        KIZList.CHECK(RS.A[i].index,RS.A[i].KIZ_IndAttr);
      dec(CNT_CHECK,RS.CNT);
      RS.CNT:=0;
      bLST:=true;
      end;
    end;
  except
    on E: Exception do
      ShowMessage('Ошибка CheckAction при простановке индустриального аттрибута.'+chr(10)+E.Message);
  end;
if CNT_CHECK=0 then
  begin
  NOTE.Font.Color:=clBlack;
  NOTE.Caption:='Проверено';
  Timer1.Enabled:=False;
  end
  else
  if Note.Visible then
    with NOTE.Font do
      if Color<>clRed then
        Color:=clRed
        else
        Color:=clBlue;
BusySign:=False;
bERR:=False;
try
 if bLST then
   for i:=0 to KIZList.Count-1 do
     with KIZList.KIZ[i] do
       if KIZ_NEW then
         if GET_IND(KIZ)>=0 then
           begin
           MT.Edit;
           if KIZ_status = 1 then
             MT.FieldByName('STATUS').AsString:='Удачно'
             else
             begin
             MT.FieldByName('STATUS').AsString:='Ошибка';
             bERR := True;
             end;
           MT.FieldByName('IndAttr').Value:=KIZ_IndAttr;
           MT.Post;
           end;
  except
    on E: Exception do
      ShowMessage('Ошибка CheckAction при простановке статуса строки.'+chr(10)+E.Message);
  end;
AddButton.Enabled:=not bERR;
end;
procedure TForm1.RunAction(Act: byte);
begin
case Act of
  1: if KIZList.ADD(KIZ.Text,CNT_CHECK)=0 then
      begin
      ActPrc:=CheckAction;
      Timer1.Enabled:=true;
      NOTE.Caption:='Проверка КИЗ';
     end;
  end;
end;
procedure TForm1.OKButtonClick(Sender: TObject);
var Q1, Q2: Integer;
    ind: integer;
    CH:boolean;
begin
RunAction(1);
Q2:=1;
ind:=GET_IND(KIZ.Text);
if ind<0 then
  begin
  MT.Append;
  MT.FieldByName('KIZ').Value:=KIZ.Text;
  Q1:=1;
  end
  else
  begin
  AddButton.Enabled:=False;
  MT.First;
  while not MT.Eof do
    begin
    if MT.FieldByName('KIZ').Value=KIZ.Text then break;
    MT.Next;
    end;
  if MT.Eof then
    begin
    ShowMessage('Ошибка!');
    exit;
    end;
  Q1:=MT.FieldByName('Q1').Value+1;
  MT.Edit;
  end;
MT.FieldByName('Q1').Value:=Q1;
MT.FieldByName('Q2').Value:=Q2;
MT.FieldByName('QUANT').Value:=IntToStr(Q1)+'/'+IntToStr(Q2);
MT.Post;
end;

procedure TForm1.Panel2Resize(Sender: TObject);
begin
if Panel2.Width<100 then Panel2.Width:=200;
NOMEN_CODE.Width:=Panel2.Width-17;
NOMEN_NAME.Width:=NOMEN_CODE.Width;
NOTE.Width:=NOMEN_CODE.Width;
NOMEN_NAME.Height:=Panel2.Height-115;
AddButton.Top:=NOMEN_NAME.Height+NOMEN_NAME.Top+10;
AddButton.Width:=NOMEN_CODE.Width
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
ActPrc ;
end;


procedure TForm1.FormResize(Sender: TObject);
begin
KIZ.Width:=Width-150;
PlusButton.Left:=KIZ.Width+6;
MinusButton.Left:=PlusButton.Left+PlusButton.Width;
OKButton.Left:=MinusButton.Left+MinusButton.Width+3;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
ActPrc:=nil;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
KIZList := TKIZList.Create;
BusySign:=True;

CheckMark:=TCheckMark.Create(false);
//CheckMark.FreeOnTerminate:=True;

//CheckMark.Suspend;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
CheckMark.Terminate;
end;

end.
 