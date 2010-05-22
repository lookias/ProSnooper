//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("MailRcv.res");
USEFORM("..\MailRcv1.cpp", POP3ExcercizerForm);
USEFORM("..\MailRcv2.cpp", MessageForm);
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
    try
    {
        Application->Initialize();
        Application->CreateForm(__classid(TPOP3ExcercizerForm), &POP3ExcercizerForm);
                 Application->CreateForm(__classid(TMessageForm), &MessageForm);
                 Application->Run();
    }
    catch (Exception &exception)
    {
        Application->ShowException(&exception);
    }
    return 0;
}
//---------------------------------------------------------------------------
