(*

This program is licensed under the rndware License, which can be found in LICENSE.TXT

Copyright (c) Simon Hughes 2007-2008

*)
unit aboutform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellAPI, ExtCtrls, jpeg, Gradient;

type
  TfrmAbout = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Label3: TLabel;
    Bevel2: TBevel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Label11: TLabel;
    Label12: TLabel;
    Label8: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Image2: TImage;
    Gradient1: TGradient;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label10Click(Sender: TObject);
    procedure Label11Click(Sender: TObject);
    procedure Label12Click(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure Label13Click(Sender: TObject);
    procedure Label14Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

procedure TfrmAbout.Button1Click(Sender: TObject);
begin
 Close;
end;

procedure TfrmAbout.FormShow(Sender: TObject);
   function  GetAppVersion:string;
   var
    Size, Size2: DWord;
    Pt, Pt2: Pointer;
   begin
     Size := GetFileVersionInfoSize(PChar (ParamStr (0)), Size2);
     if Size > 0 then
     begin
       GetMem (Pt, Size);
       try
          GetFileVersionInfo (PChar (ParamStr (0)), 0, Size, Pt);
          VerQueryValue (Pt, '\', Pt2, Size2);
          with TVSFixedFileInfo (Pt2^) do
          begin
            Result:= IntToStr (HiWord (dwFileVersionMS)) + '.' +
                     IntToStr (LoWord (dwFileVersionMS)) + '.' +
                     IntToStr (HiWord (dwFileVersionLS)) + ' build ' +
                     IntToStr (LoWord (dwFileVersionLS));
         end;
       finally
         FreeMem (Pt);
       end;
     end;
   end;

 begin
   Label3.Caption:='Version '+GetAppVersion;
end;

procedure TfrmAbout.Label5Click(Sender: TObject);
begin
  Shellexecute(Handle,PChar('Open'),'http://lookias.inventforum.com/',nil,nil,SW_SHOW);
end;

procedure TfrmAbout.Label10Click(Sender: TObject);
begin
  Shellexecute(Handle,PChar('Open'),'http://lookias.inventforum.com/viewtopic.php?t=18',nil,nil,SW_SHOW);
end;

procedure TfrmAbout.Label11Click(Sender: TObject);
begin
  Shellexecute(Handle,PChar('Open'),'http://worms2d.info/The_Wheat_Snooper',nil,nil,SW_SHOW);
end;

procedure TfrmAbout.Label12Click(Sender: TObject);
begin
  Shellexecute(Handle,PChar('Open'),'http://worms2d.info/Play_Worms_Armageddon_on_Linux',nil,nil,SW_SHOW);
end;

procedure TfrmAbout.Label8Click(Sender: TObject);
begin
  Shellexecute(Handle,PChar('Open'),'http://lookias.lo.funpic.de/page/',nil,nil,SW_SHOW);
end;

procedure TfrmAbout.Label13Click(Sender: TObject);
begin
  Shellexecute(Handle,PChar('Open'),'http://lookias.inventforum.com/viewforum.php?f=1',nil,nil,SW_SHOW);
end;

procedure TfrmAbout.Label14Click(Sender: TObject);
begin
  Shellexecute(Handle,PChar('Open'),'http://lookias.inventforum.com/viewforum.php?f=4',nil,nil,SW_SHOW);
end;

end.
