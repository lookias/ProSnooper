{*

This Component was written by Lookias and is licensed under the rndware License,

which can be found in LICENSE.TXT

*}
unit uEditableComboBox;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Dialogs, Windows;

type
  EditableComboBox = class(TComboBox)
  private
      procedure slotOnExit(Sender: TObject);
      procedure slotOnKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation
constructor EditableComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  parent:=AOwner as TWinControl;
  Hint:='New names will be added to this List,'#10
        +'to delete one name select it and press escape.';
  ShowHint:=true;
  OnExit:=slotOnExit;
  OnKeyUp:=slotOnKeyUp;
end;
procedure EditableComboBox.slotOnExit(Sender: TObject);
var str:string;
begin
  str:=text;
  if str = '' then Exit;
  if -1 <> items.IndexOf(str) then Exit;
  AddItem(str,nil);
end;
procedure EditableComboBox.slotOnKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var str:string;
begin
  if Key <> VK_ESCAPE	then Exit;
  DeleteSelected;
end;
procedure Register;
begin
  RegisterComponents('Lookias', [EditableComboBox]);
end;

end.





