unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  System.Win.TaskbarCore, Taskbar, ComCtrls,  SyncObjs;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Timer1: TTimer;
    ProgressBar1: TProgressBar;
    Button4: TButton;
    Button5: TButton;
    ProgressBar2: TProgressBar;
    Timer2: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TSecondThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute;  override;

  end;

  TThirdThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute;  override;

  end;

   TMainThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute;  override;

  end;

var
  Form1: TForm1;
  f : System.Text;
  a, b, c: double;
  MainThread:TMainThread;
  SecondThread:TSecondThread;
  ThirdThread:TThirdThread;
  CS: TCriticalSection;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
    MainThread:=TMainThread.Create(False);
   MainThread.Priority:=tpNormal;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin

  Form1.timer1.Enabled:=true;
  Form1.timer1.Interval:=1000;
  Form1.ProgressBar1.BarColor := clGreen;

  SecondThread:=TSecondThread.Create(False);
  SecondThread.Priority:=tpNormal;


end;

procedure TForm1.Button3Click(Sender: TObject);
begin

  if SecondThread <> nil then
begin
  SecondThread.Terminate;
  SecondThread := nil
end;

  timer1.Enabled:=false;
  ProgressBar1.BarColor := clRed;

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
   Form1.timer2.Enabled:=true;
  Form1.timer2.Interval:=1000;
  Form1.ProgressBar2.BarColor := clGreen;

  ThirdThread:=TThirdThread.Create(False);
  ThirdThread.Priority:=tpNormal;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
   if ThirdThread <> nil then
begin
  ThirdThread.Terminate;
  ThirdThread := nil
end;

  timer2.Enabled:=false;
  ProgressBar2.BarColor := clRed;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
ProgressBar1.Position := 100;
ProgressBar1.BarColor := clRed;
ProgressBar2.Position := 100;
ProgressBar2.BarColor := clRed;

AssignFile(f, 'LogFile.txt');
rewrite(f);
CloseFile(f);

CS:= TCRiticalSection.Create;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  //AssignFile(f, 'D:\LogFile.txt');
  //Rewrite(f);
  //Append(f);
  //Writeln(f, '????? ?2 ????????. ?????: '+ TimeToStr(Now));
  //CloseFile(f);
end;






procedure TForm1.Timer2Timer(Sender: TObject);
begin
     //AssignFile(f, 'D:\LogFile.txt');
  //Rewrite(f);
  //Append(f);
  //Writeln(f, '????? ?3 ????????. ?????: '+ TimeToStr(Now));
  //CloseFile(f);
end;

{
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure MainThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end;

    or

    Synchronize(
      procedure
      begin
        Form1.Caption := 'Updated in thread via an anonymous method'
      end
      )
    );

  where an anonymous method is passed.

  Similarly, the developer can call the Queue method with similar parameters as
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.

}

{ MainThread }

procedure TMainThread.Execute;
begin
while not Terminated do begin
    cs.Enter;
    try
      AssignFile(f, 'LogFile.txt');
      //Rewrite(f);
      Append(f);

      a:= StrToFloat(Form1.Edit1.Text);
      b:= StrToFloat(Form1.Edit2.Text);
      c:=a+b;

      Writeln(f, '????????? ???????? ? ???????? ??????. ?????????: ' + FloatToStr(a) + ' + ' + FloatToStr(b) + ' = ' + FloatToStr(c));
      CloseFile(f);
       finally
      cs.Leave;
    end;
    if MainThread <> nil then
    begin
      MainThread.Terminate;
      MainThread := nil
    end;
end;
//Synchronize(TSecondThread.Execute);
end;

procedure TSecondThread.Execute;
begin



while not Terminated do begin
    cs.Enter;
    try
      AssignFile(f, 'LogFile.txt');
      //Rewrite(f);
      Append(f);
      sleep(1000);
      Writeln(f, '????? ?2 ????????. ?????: '+ TimeToStr(Now));
      CloseFile(f);
       finally
      cs.Leave;
    end;

end;
end;

procedure TThirdThread.Execute;
begin



while not Terminated do begin
    cs.Enter;
    try
      AssignFile(f, 'LogFile.txt');
      //Rewrite(f);
      Append(f);
      sleep(1000);
      Writeln(f, '????? ?3 ????????. ?????: '+ TimeToStr(Now));
      CloseFile(f);
       finally
      cs.Leave;
    end;

end;
end;


end.
