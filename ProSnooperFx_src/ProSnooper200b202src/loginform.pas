(*

This program is licensed under the rndware License, which can be found in LICENSE.TXT

Copyright (c) Simon Hughes 2007-2008

*)

unit loginform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ImgList, ExtCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, inifiles, IdHTTP, Registry, XPMan, ShellAPI,
  Menus, Buttons, uEditableComboBox, Gradient;

type
  TfrmLogin = class(TForm)
    Button1: TButton;
    ImageList1: TImageList;
    ImageList2: TImageList;
    Image1: TImage;
    Button2: TButton;
    Bevel1: TBevel;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    cbflag: TComboBoxEx;
    cbrank: TComboBoxEx;
    Label4: TLabel;
    CheckBox2: TCheckBox;
    Timer1: TTimer;
    http: TIdHTTP;
    Bevel2: TBevel;
    XPManifest1: TXPManifest;
    Label5: TLabel;
    cbUser: EditableComboBox;
    cbChan: EditableComboBox;
    Button3: TBitBtn;
    ImageList3: TImageList;
    cbServer: EditableComboBox;
    Bevel3: TBevel;
    cbClan: EditableComboBox;
    Label6: TLabel;
    Gradient1: TGradient;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SetRegistryData(RootKey: HKEY; Key, Value: string; RegDataType: TRegDataType; Data: variant);
    function GetRegistryData(RootKey: HKEY; Key, Value: string): variant;
    procedure Timer1Timer(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    //procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;
  OptionsOn: Boolean;
  FirstTime: Boolean;

implementation

uses mainform, preferform;

{$R *.dfm}

procedure TfrmLogin.SetRegistryData(RootKey: HKEY; Key, Value: string;
  RegDataType: TRegDataType; Data: variant);
var
  Reg: TRegistry;
  s: string;
begin
  Reg := TRegistry.Create(KEY_WRITE);
  try
    Reg.RootKey := RootKey;
    if Reg.OpenKey(Key, True) then begin
      try
        if RegDataType = rdUnknown then
          RegDataType := Reg.GetDataType(Value);
        if RegDataType = rdString then
          Reg.WriteString(Value, Data)
        else if RegDataType = rdExpandString then
          Reg.WriteExpandString(Value, Data)
        else if RegDataType = rdInteger then
          Reg.WriteInteger(Value, Data)
        else if RegDataType = rdBinary then begin
          s := Data;
          Reg.WriteBinaryData(Value, PChar(s)^, Length(s));
        end else
          raise Exception.Create(SysErrorMessage(ERROR_CANTWRITE));
      except
        Reg.CloseKey;
        raise;
      end;
      Reg.CloseKey;
    end else
      raise Exception.Create(SysErrorMessage(GetLastError));
  finally
    Reg.Free;
  end;
end;

function TfrmLogin.GetRegistryData(RootKey: HKEY; Key, Value: string): variant;
var
  Reg: TRegistry;
  RegDataType: TRegDataType;
  DataSize, Len: integer;
  s: string;
label cantread;
begin
  Reg := nil;
  try
    Reg := TRegistry.Create(KEY_QUERY_VALUE);
    Reg.RootKey := RootKey;
    if Reg.OpenKeyReadOnly(Key) then begin
      try
        RegDataType := Reg.GetDataType(Value);
        if (RegDataType = rdString) or
           (RegDataType = rdExpandString) then
          Result := Reg.ReadString(Value)
        else if RegDataType = rdInteger then
          Result := Reg.ReadInteger(Value)
        else if RegDataType = rdBinary then begin
          DataSize := Reg.GetDataSize(Value);
          if DataSize = -1 then goto cantread;
          SetLength(s, DataSize);
          Len := Reg.ReadBinaryData(Value, PChar(s)^, DataSize);
          if Len <> DataSize then goto cantread;
          Result := s;
        end else
cantread:
        //raise Exception.Create(SysErrorMessage(ERROR_CANTREAD));
      except
        s := ''; // Deallocates memory if allocated
        Reg.CloseKey;
        raise;
      end;
      Reg.CloseKey;
    end else
      // raise Exception.Create(SysErrorMessage(GetLastError));
  except
    Reg.Free;
    raise;
  end;
  Reg.Free;
end;

procedure TfrmLogin.Button1Click(Sender: TObject);
var
IRCQuery: TStringList;
IRCServ, IRCJoin, IRCCountry: String;

begin
if (cbUser.Text = '') or (cbChan.Text = '') or (cbServer.Text = '') then
 Exit
else begin


    IRCQuery := TStringList.Create;
    try
     IRCQuery.Text := http.Get('http://'+cbServer.text+'/wormageddonweb/Login.asp?UserName=&Password=&IPAddress=');
    except
     ShowMessage('Error contacting server. This server or your network is down.');

     Exit;
    end;

    IRCServ := StringReplace(IRCQuery[0],'<CONNECT ','',[]);
    IRCServ := StringReplace(IRCServ,'>','',[]);

    if IRCQuery.Count >= 2 then begin // Server-controlled autojoin
     IRCJoin := StringReplace(IRCQuery[1],'<JOIN ','',[]);
     IRCJoin := StringReplace(IRCJoin,'>','',[]);
     cbChan.Text := IRCJoin;
    end;

    IRCQuery.Free;

     frmmain.irc.IrcOptions.MyNick := cbUser.Text;
     frmmain.irc.IrcOptions.ServerHost := IRCServ;
     frmmain.irc.IrcOptions.UserIdent := cbClan.Text;

     case cbflag.ItemIndex of
       51 : IRCCountry := 'CL';
       52 : IRCCountry := 'CS';
       53 : IRCCountry := 'SI';
       54 : IRCCountry := 'LB';
       55 : IRCCountry := 'MD';
       56 : IRCCountry := 'UA';
       57 : IRCCountry := 'LV';
       58 : IRCCountry := 'SK';
       59 : IRCCountry := 'CR';
       60 : IRCCountry := 'EE';
       61 : IRCCountry := 'CN';
     else
       IRCCountry := 'UK';
     end;


     frmmain.irc.IrcOptions.UserName := inttostr(cbflag.ItemIndex)+' '+inttostr(cbrank.ItemIndex)+' '+IRCCountry+' ProSnooperFx';
     frmmain.irc.IrcOptions.Password := 'ELSILRACLIHP';
     frmmain.irc.connect;
     frmmain.Caption := 'ProSnooperFx - '+cbchan.Text;

     frmMain.Show;

     try
       SetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','UsernameList',rdString,cbUser.Items.CommaText);
       SetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','Username',rdString,cbUser.Text);

       SetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','Channel',rdString,cbChan.Text);
       SetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','ChannelList',rdString,cbChan.Items.CommaText);

       SetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','Clan',rdString,cbClan.Text);
       SetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','ClanList',rdString,cbClan.Items.CommaText);

       SetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','Server',rdString,cbServer.Text);
       SetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','ServerList',rdString,cbServer.Items.CommaText);
       
       SetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','Flag',rdString,IntToStr(cbFlag.ItemIndex));
       SetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','Rank',rdString,IntToStr(cbRank.ItemIndex));
       SetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','AutoLogin',rdString,BoolToStr(CheckBox2.Checked));
     except
       ShowMessage('Cannot access registry.');
     end;
end;


end;

procedure TfrmLogin.FormShow(Sender: TObject);
  function GetWinDir: string;
  var
    dir: array [0..MAX_PATH] of Char;
  begin
    GetWindowsDirectory(dir, MAX_PATH);
    Result := StrPas(dir);
  end;
var
INI: TIniFile;
begin
if FirstTime = True then begin // load settings if this is applaunch (we should do this in onCreate instead)
 OptionsOn := False; //options toggle is off @ launch


  with TRegistry.Create do
    try
      RootKey := HKEY_CURRENT_USER;
      OpenKey('\Software\ProSnooperFx', False);

        if ValueExists('Username') = True then begin
          cbUser.items.CommaText      := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','UsernameList');
          cbUser.Text                 := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','Username');
          cbChan.Text                 := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','Channel');
          cbChan.Items.CommaText      := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','ChannelList');
          cbClan.Text                 := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','Clan');
          cbClan.Items.CommaText      := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','ClanList');
          cbFlag.ItemIndex            := StrToInt(GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','Flag'));
          cbRank.ItemIndex            := StrToInt(GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','Rank'));
          CheckBox2.Checked           := StrToBool(GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','AutoLogin'));
          frmMain.Autologin1.Checked  := StrToBool(frmLogin.GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','AutoLogin'));

          if CheckBox2.Checked then //autologin
           Timer1.Enabled := True;
        end else begin
          cbFlag.ItemIndex            := 0;
          cbRank.ItemIndex            := 0;
          cbChan.Items.CommaText:='#AnythingGoes,#RopersHeaven,#PartyTime,#Help';
          cbChan.Text:='#AnythingGoes';
        end;

        if ValueExists('colBackground') = True then begin //settings
          frmSettings.colBackground.Selected    := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','colBackground');
          frmSettings.colText1.Selected         := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','colText1');
          frmSettings.colText2.Selected         := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','colText2');
          frmSettings.colPrivate.Selected       := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','colPrivate');
          frmSettings.colActions.Selected       := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','colActions');
          frmSettings.colJoins.Selected         := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','colJoins');
          frmSettings.colParts.Selected         := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','colParts');
          frmSettings.colQuits.Selected         := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','colQuits');
          frmSettings.cbTimeStamps.Checked      := StrToBool(GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','EnableTimeStamps'));
          frmSettings.cbJoins.Checked           := StrToBool(GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','ShowJoins'));
          frmSettings.cbParts.Checked           := StrToBool(GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','ShowParts'));
          frmSettings.cbQuits.Checked           := StrToBool(GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','ShowQuits'));
          frmSettings.edTimeStamp.Text          := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooper\','TimeStampFormat');
          frmSettings.edsndBuddy.Text           := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','BuddySound');
          frmSettings.edsndHiLite.Text          := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','HiLiteSound');
          frmSettings.edsndMsg.Text             := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','MsgSound');
        end;

        if ValueExists('HostAwayText') = True then begin  //settings added in 104
          frmSettings.edHostGameAway.Text       := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','HostAwayText');
          frmSettings.edJoinGameAway.Text       := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','JoinAwayText');
          frmSettings.cbJoinGameAway.Checked    := StrToBool(GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','JoinGameAway'));
          frmSettings.cbHostGameAnn.Checked     := StrToBool(GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','HostGameAnn'));
          frmSettings.cbAwayAnnounce.Checked    := StrToBool(GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','AwayAnnounce'));
          frmSettings.cbHostGameAway.Checked    := StrToBool(GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','HostGameAway'));
          frmSettings.cbGetIP.Checked           := StrToBool(GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','GetIP'));
          frmSettings.cbResumeAnnounce.Checked  := StrToBool(GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','ResumeAnnounce'));
          frmSettings.cbSendAwayPriv.Checked    := StrToBool(GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','SendAwayPriv'));
          frmSettings.cbSendAwayHiLite.Checked  := StrToBool(GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx\','SendAwayHiLite'));
        end;

        if ValueExists('Pos1') = True then begin
          frmMain.Height   := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','Pos1');
          frmMain.Top      := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','Pos2');
          frmMain.Left     := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','Pos3');
          frmMain.Width    := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','Pos4');
        end;

        if ValueExists('Buddies') = True then begin
          frmSettings.lbBuddies.Items.CommaText := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','Buddies');
        end;

        if ValueExists('FntSize') = True then begin
          frmSettings.edFntSize.Text := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','FntSize');
        end;

        if ValueExists('ServerList') = True then begin
          cbServer.Items.CommaText := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','ServerList');
          cbServer.Text := GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','Server');
        end;

        if ValueExists('WindowState') = True then begin
         if GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','WindowState') = 'Maximized' then
          frmMain.WindowState := wsMaximized
         else if GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','WindowState') = 'Minimized' then
          frmMain.WindowState := wsMinimized
         else
          frmMain.WindowState := wsNormal;
        end;

        if ValueExists('Blink') = True then
         frmSettings.cbBlink.Checked := StrToBool(GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','Blink'));

        if ValueExists('Waexe') = True then
         frmSettings.edExe.Text := GetRegistryData(HKEY_CURRENT_USER, '\Software\ProSnooperFx','Waexe');

        if ValueExists('DisableScroll') = True then
         frmSettings.cbDisableScroll.Checked := StrToBool(GetRegistryData(HKEY_CURRENT_USER,'\Software\ProSnooperFx','DisableScroll'));
    finally
     Free;
    end;

   if cbUser.Text = '' then begin  // WA username
     ini := TIniFile.Create(GetWindir+'\win.ini');
     try
       cbUser.Text := ini.ReadString('NetSettings', 'PlayerName', '');
     finally
       ini.Free;
     end;
   end;

   if CheckBox2.Checked then
    Timer1.Enabled := True; // you cant open windowss onshow, so we use a timer instead

   FirstTime := False;
  end;
end;

procedure TfrmLogin.Button2Click(Sender: TObject);
begin
 Close;
end;

procedure TfrmLogin.Button3Click(Sender: TObject);
var bitmap:tBitmap;
begin
  bitmap:=tBitmap.Create;
  if ImageList3 = nil then caption:='dfdfgdf';
  if OptionsOn = False then begin
    Height := 471;
    Label3.Visible := True;
    Label4.Visible := True;
    cbFlag.Visible := True;
    cbRank.Visible := True;
    OptionsOn := True;
    ImageList3.GetBitmap(0,bitmap);
  end else begin
    Height := 323;
    Label3.Visible := False;
    Label4.Visible := False;
    cbFlag.Visible := False;
    cbRank.Visible := False;
    OptionsOn := False;
    ImageList3.GetBitmap(1,bitmap);
  end;
    Button3.Glyph := bitmap;
end;

procedure TfrmLogin.Timer1Timer(Sender: TObject);
begin
 Button1.OnClick(nil);
 Timer1.Enabled := False;
end;

procedure TfrmLogin.Image1Click(Sender: TObject);
begin
 ShellExecute(Handle,'Open','http://ProSnooperFx.rndware.info',nil,nil,SW_SHOWNORMAL);
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
 FirstTime := True;
end;

{procedure TfrmLogin.Button4Click(Sender: TObject);
begin

 try
  cbServer.Items.Text := http.Get('http://ProSnooperFx.rndware.info/serverlist.txt');
 except
  ShowMessage('Could not get serverlist.');
 end;

end;}

procedure TfrmLogin.Label5Click(Sender: TObject);
begin
Shellexecute(Handle,PChar('Open'),'http://worms.thecybershadow.net/wormnet/',nil,nil,SW_SHOW);
end;

end.
