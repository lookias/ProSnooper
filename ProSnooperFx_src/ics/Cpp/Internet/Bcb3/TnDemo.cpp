//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("TnDemo.res");
USEFORM("..\tndemo1.cpp", TnDemoForm);
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
    try
    {
        Application->Initialize();
        Application->CreateForm(__classid(TTnDemoForm), &TnDemoForm);
        Application->Run();
    }
    catch (Exception &exception)
    {
        Application->ShowException(&exception);
    }
    return 0;
}
//---------------------------------------------------------------------------