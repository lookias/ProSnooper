(*

This program is licensed under the rndware License, which can be found in LICENSE.TXT

Copyright (c) Simon Hughes 2007-2008

*)
unit messagesform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmMessages = class(TForm)
    Memo1: TMemo;
    Bevel1: TBevel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMessages: TfrmMessages;

implementation

{$R *.dfm}

procedure TfrmMessages.Button1Click(Sender: TObject);
begin
 Close;
end;

end.
