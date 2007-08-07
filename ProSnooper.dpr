program ProSnooper;

uses
  Forms,
  loginform in 'loginform.pas' {frmLogin},
  mainform in 'mainform.pas' {frmMain},
  aboutform in 'aboutform.pas' {frmAbout},
  nickdock in 'nickdock.pas' {frmdkNickList},
  gamedock in 'gamedock.pas' {frmdkGmList},
  preferform in 'preferform.pas' {frmSettings},
  joinform in 'joinform.pas' {frmJoinGame},
  buddyform in 'buddyform.pas' {frmBuddies},
  hostform in 'hostform.pas' {frmHost},
  chanlistform in 'chanlistform.pas' {frmChanList},
  messagesform in 'messagesform.pas' {frmMessages};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'ProSnooper';

  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TfrmdkNickList, frmdkNickList);
  Application.CreateForm(TfrmdkGmList, frmdkGmList);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.CreateForm(TfrmJoinGame, frmJoinGame);
  Application.CreateForm(TfrmBuddies, frmBuddies);
  Application.CreateForm(TfrmHost, frmHost);
  Application.CreateForm(TfrmChanList, frmChanList);
  Application.CreateForm(TfrmMessages, frmMessages);
  Application.Run;

  end.