//---------------------------------------------------------------------------
#ifndef Cli7H
#define Cli7H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "WSocket.hpp"
#include <ExtCtrls.hpp>
//---------------------------------------------------------------------------
class TCli7Form : public TForm
{
__published:	// IDE-managed Components
    TPanel *Panel1;
    TLabel *Label6;
    TLabel *Label1;
    TEdit *PortEdit;
    TEdit *HostNameEdit;
    TButton *ConnectButton;
    TButton *LineOnButton;
    TButton *LineOffButton;
    TButton *DisconnectButton;
    TButton *ReadLineButton;
    TMemo *DisplayMemo;
    TWSocket *WSocket1;
    void __fastcall FormShow(TObject *Sender);
    void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
    void __fastcall LineOnButtonClick(TObject *Sender);
    void __fastcall LineOffButtonClick(TObject *Sender);
    void __fastcall ConnectButtonClick(TObject *Sender);
    void __fastcall DisconnectButtonClick(TObject *Sender);
    void __fastcall WSocket1SessionConnected(TObject *Sender, WORD Error);
    void __fastcall WSocket1SessionClosed(TObject *Sender, WORD Error);
    void __fastcall WSocket1DataAvailable(TObject *Sender, WORD Error);
    void __fastcall ReadLineButtonClick(TObject *Sender);
private:	// User declarations
    AnsiString FIniFileName;
    BOOL       FInitialized;
    __fastcall void Display(AnsiString Msg);
public:		// User declarations
    __fastcall TCli7Form(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TCli7Form *Cli7Form;
//---------------------------------------------------------------------------
#endif
