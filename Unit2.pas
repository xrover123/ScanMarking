unit Unit2;

interface

uses
  Classes {$IFDEF MSWINDOWS} , Windows {$ENDIF};

type TKIZ = record
  KIZ_status: byte;
  KIZ: String;
  KIZ_IndAttr: String;
  KIZ_NEW: boolean;
  end;
type TKIZArray = array of TKIZ;

type TKIZList = class
  private
  A: TKIZArray;
  CNT: integer;
  public
  function  getKIZ(ind: integer): TKIZ;
  procedure setKIZ(ind: integer; KIZ: TKIZ);
  constructor Create;
  property Count: integer read CNT;
  property KIZ[ind: integer]: TKIZ read getKIZ write setKIZ;
  function ADD(sKIZ:String; var nCNT_CHECK: integer): byte;
  procedure CHECK(ind: integer; sIndAttr: String);
  end;


type TMapData = record
  index: integer;
  KIZ: String;
  KIZ_IndAttr: String;
  end;
type TSelectedArr = array of TMapData;
type TSelected = record
  A: TSelectedArr;
  CNT: integer;
  end;

type
  TCheckMark = class(TThread)
  public
    RS: TSelected;
  private
    bContinue: boolean;
    procedure SetName;
  protected
    SL: TSelected;
    procedure GetData;
    procedure MapData;
    procedure SetData;
    procedure Execute; override;
  end;

var BusySign: boolean;
    KIZList: TKIZList;

implementation
uses Unit1, Messages, SysUtils, Dialogs;
{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TCheckMark.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{$IFDEF MSWINDOWS}
type
  TThreadNameInfo = record
    FType: LongWord;     // must be 0x1000
    FName: PChar;        // pointer to name (in user address space)
    FThreadID: LongWord; // thread ID (-1 indicates caller thread)
    FFlags: LongWord;    // reserved for future use, must be zero
  end;
{$ENDIF}

constructor TKIZList.Create;
begin
CNT:=0;
end;

function TKIZList.getKIZ(ind: integer): TKIZ;
begin
result:=A[ind];
end;
procedure TKIZList.setKIZ(ind: integer; KIZ: TKIZ);
begin
A[ind]:=KIZ;
end;

function TKIZList.ADD(sKIZ:String; var nCNT_CHECK: integer): byte;
var i: integer;
begin
for i:=0 to CNT-1 do
  with A[i] do
    if KIZ=sKIZ then
      begin
      result := KIZ_status;
      exit;
      end;
i:=CNT;
inc(CNT);
inc(nCNT_CHECK);
BusySign:=true;
SetLength(A, CNT);
with A[i] do
  begin
  KIZ := sKIZ;
  KIZ_status := 0;
  KIZ_IndAttr := '';
  KIZ_NEW:=True;
  end;
BusySign:=false;
result := 0;
end;

procedure TKIZList.CHECK(ind: integer; sIndAttr: String);
begin
A[ind].KIZ_IndAttr := sIndAttr;
if sIndAttr='' then
  A[ind].KIZ_status := 2
  else
  A[ind].KIZ_status := 1;
end;


{ TCheckMark }

procedure TCheckMark.GetData; //Копируем данные для обработки в отдельном потоке
var i:integer;
    TMP: TMapData;
begin
if BusySign then
  begin
  bContinue:=true;
  exit
  end;
if RS.CNT=0 then
  begin
  SetLength(SL.A, KIZList.Count);
  SL.CNT:=0;

  for i:=0 to KIZList.Count-1 do
    with KIZList.KIZ[i] do
      if KIZ_status=0 then
        begin
        TMP.index:=i;
        TMP.KIZ:=KIZ;
        TMP.KIZ_IndAttr:='';
        SL.A[SL.CNT]:=TMP;
        inc(SL.CNT);
        end;
  end;
end;

procedure TCheckMark.MapData; //Обрабатываем данные
var i: integer;
begin
for i:=0 to SL.CNT-1 do
  begin
  if length(SL.A)<SL.CNT then ShowMessage('Плохо!');
  SL.A[i].KIZ_IndAttr:='Падла';
  sleep(200)
  end;
end;


procedure TCheckMark.SetData;  //Возвращаем данные
var i: integer;
begin
if BusySign then
  begin
  bContinue:=true;
  exit
  end;
RS.CNT:=SL.CNT;
setLength(RS.A,RS.CNT);
for i:=0 to SL.CNT-1 do
  begin
  RS.A[i]:=SL.A[i];
  end;
SL.CNT:=0;
setLength(SL.A,SL.CNT);
end;

procedure TCheckMark.SetName;
{$IFDEF MSWINDOWS}
var
  ThreadNameInfo: TThreadNameInfo;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  ThreadNameInfo.FType := $1000;
  ThreadNameInfo.FName := 'CheckMark';
  ThreadNameInfo.FThreadID := $FFFFFFFF;
  ThreadNameInfo.FFlags := 0;

  try
    RaiseException( $406D1388, 0, sizeof(ThreadNameInfo) div sizeof(LongWord), @ThreadNameInfo );
  except
  end;
{$ENDIF}
end;

procedure TCheckMark.Execute;
begin
SetName;

SL.CNT:=0;
RS.CNT:=0;

  repeat
  Synchronize(GetData);//Получаем данные}
  MapData;               //Обрабатываем данные
  Synchronize(SetData);//Записываем данные в выходной буфер}
  until Terminated;//Пока не терминировали
  { Place thread code here }
end;

end.
