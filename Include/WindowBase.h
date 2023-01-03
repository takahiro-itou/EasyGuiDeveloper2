/*************************************************************************
**                                                                      **
**                  --  Easy GUI Deceloper Library  --                  **
**                                                                      **
**          Include/WindowBase.h                                        **
**                                                                      **
**          Copyright (c), anonymous, 2001 - 2011.                      **
**          All rights reserved.                                        **
**                                                                      **
*************************************************************************/

/**
**      @file       Include/WindowBase.h
**
**      An interface of WindowBase class.
**/

/*************************************************************************
**                                                                      **
**    WindowBase  クラスは, ウィンドウを一つ管理する. このクラスは      **
**  ウィンドウ操作のための基本的なメソッドを提供する.                   **
**    For more details, refer to documents.                             **
**                                                                      **
*************************************************************************/

#if !defined( EASY_GUI_DEVELOPER_INCLUDED_WINDOW_BASE_H )
#   define    EASY_GUI_DEVELOPER_INCLUDED_WINDOW_BASE_H

//#include    "BitmapImage.h"
//#include    "WindowEvents.h"

namespace EGD_NS {

//========================================================================
//
//    Window structures.
//

class WindowBase;

#if defined( EGD_USE_WIN32_API )

typedef     CREATESTRUCTA   CWINFOA;
typedef     CREATESTRUCTW   CWINFOW;

#if defined( EGD_UNICODE )
typedef     CWINFOA         CWINFO;
#else
typedef     CWINFOW         CWINFO;
#endif

#elif defined( EGD_USE_LINUX_XLIB )

typedef struct {
    AppHandle       appHandle;
    WindowHandle    parentWindow;
    int             x, y;
    int             width, height;
} CreatingWindowInfo;

#endif  /* defined(EGD_USE_LINUX_XLIB) */

//========================================================================
//
//    WindowBase class.
//
/**
**    ウィンドウを管理するクラス.
**/

class WindowBase
{
//========================================================================
//
//    Type Information.
//

    EGD_DECLARE_TYPEINFO(WindowBase);

//========================================================================
//
//    Constructor(s) and destructor.
//
public:

    //----------------------------------------------------------------
    /**   ウィンドウは作成せず, インスタンスの初期化のみ行う.
    **   (デフォルトコンストラクタ).
    **  ウィンドウの作成は, 別途 createWindow  メソッドで行う.
    **/
    WindowBase();

    //----------------------------------------------------------------
    /**   ウィンドウを作成する (コンストラクタ).
    **
    **  @param [in] w       作成するウィンドウの幅.
    **  @param [in] h       作成するウィンドウの高さ.
    **  @param [in] title   ウィンドウのテキスト.
    **/
    WindowBase(
            IN_ARG  BtMeas      w,
            IN_ARG  BtMeas      h,
            IN_ARG  HtlCAString title)
};


}   //  End of namespace EGD_NS

#endif
