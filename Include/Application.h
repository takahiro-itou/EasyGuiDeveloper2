/*************************************************************************
**                                                                      **
**                  --  Easy GUI Developer Library  --                  **
**                                                                      **
**          Include/Application.h                                       **
**                                                                      **
**          Copyright (c), anonymous, 2001 - 2011.                      **
**          All rights reserved.                                        **
**                                                                      **
*************************************************************************/

/**
**      @file       Include/Application.h
**
**      An interface of Application class.
**/

/*************************************************************************
**                                                                      **
**    Application class controls an application instance. This class    **
**  provides functions for operating the application instance.          **
**    For more details, refer to documents.                             **
**                                                                      **
*************************************************************************/

#if !defined( EASY_GUI_DEVELOPER_INCLUDED_APPLICATION_H )
#   define    EASY_GUI_DEVELOPER_INCLUDED_APPLICATION_H

namespace EGD_NS {

//========================================================================
//
//    Application class.
//
/**
**    A class that controls an application instance. This class
**  provides functions for operating the application instance.
**/

class Application
{
//========================================================================
//
//    Constructor(s) and destructor.
//

public:

    //----------------------------------------------------------------
    /**   Constructor.
    **
    **/
    Application();

    //----------------------------------------------------------------
    /**   Destructor.
    **
    **/
    virtual ~Application();

//========================================================================
//
//    Pure-virtual functions. These functions must be
//  overridden to implement their action in sub-classes.
//

//========================================================================
//
//    Public member functions.
//
public:

    //----------------------------------------------------------------
    /**   Start up an application instance.
    **
    **  @retval BT_SUCCESS ; Success.
    **  @retval BT_FAILURE : Failure.
    **/
    virtual BtBool
    startupApplication();

    //----------------------------------------------------------------
    /**   Finalize the application instance.
    **
    **  @return   void.
    **/
    virtual void
    cleanupApplication();

    //----------------------------------------------------------------
    /**   Process an idle event. The library system calls this
    **  function when the application is idle. The 'idle'
    **  means the application is not busy, that is,  no signal
    **  from OS such as  keyboard/mouse input, paint/move/resize
    **  windows, menu operation, and so on.
    **
    **
    **  @param [in] count : The count of calling. This value
    **      is incremented when the system called this function.
    **      If the application want to use priority of each
    **      idle tasks, it can use this value in order to
    **      determine which task to execute.
    **        If the application becomes BUSY, that is, receives
    **      a signal from OS, the counter is reset to 0.
    **  @retval BT_BOOL_TRUE  : There are more idle tasks.
    **  @retval BT_BOOL_FALSE : No more idl tasks. If this
    **      function returns this value, the application
    **      sleeps until it becomes busy.
    **/
    virtual BtBool
    processIdleEvent(int count);

#if defined( EGD_USE_WIN32_API )

    //----------------------------------------------------------------
    /**   Pre process a message before it is processed.
    **
    **  @param [in,out] msg : A message from OS.
    **  @retval BT_BOOL_TRUE  : The message is pre processed,
    **      and it should NOT be processed.
    **  @retval BT_BOOL_FALSE : The message is NOT pre processed,
    **      and it will be processed by standard procedures.
    **/
    virtual BtBool
    preprocessMessage(MSG *msg);

#endif

    //----------------------------------------------------------------
    /**   Process an events.
    **
    **  @param [in] window : Awindow to process tje event.
    **  @retval -1 : It processed 'QUIT' event, and the
    **      application should end itself immediately.
    **  @retval  0 : There were no events to process.
    **  @retval  1 : It processed some event.
    **  @note   If this function returns negative value,
    **      quit the application immediately.
    **/
    virtual int
    processOneEvent(
            WndCHdl window  = (WndCHdl)INVALID_HANDLE);

    //----------------------------------------------------------------
    /**   Process some events.
    **
    **  @param [in] window : A window to process the events.
    **  @param [in] count  : The number of events to process.
    **  @retval -1 : It processed 'QUIT' event, and the
    **      application should end itself immediately.
    **  @retval  0 : There were no events to process.
    **  @retval  1 : It processed some events.
    **  @note   If this function returns negative value,
    **      quit the application immediately.
    **/
    virtual int
    processEvents(
            WndCHdl window  = (WndCHdl)INVALID_HANDLE,
            int     count   = 0);

    //----------------------------------------------------------------
    /**   Suspend the application for a while.
    **  Pause the specified intervals, in milliseconds).
    **
    **  @param [in] milliseconds : The time intervals to
    **      suspend, in milliseconds.
    **  @param [in] flags        : The flags of suspending.
    **  @return
    **/
    int
    pauseMilliseconds(
            int milliseconds,
            int flags   = PAUSE_FROM_NOW | PAUSE_HANDLE_EVENTS);

    //----------------------------------------------------------------
    /**   Suspend the application for a while.
    **  Wait for an event.
    **
    **  @param [in]  window : The window to wait event.
    **  @param [out] event  : The buffer to return the event.
    **  @return
    **/
    int
    waitForEvents(
            WndCHdl     window,
            WindowEvent *event);

    //----------------------------------------------------------------
    /**   Start the main loop of the application.
    **
    **  @return   void.
    **/
    void
    run();

//========================================================================
//
//    Member variables and accessors.
//
public:

#if defined( EGD_USE_WIN32_API )

    //----------------------------------------------------------------
    /**   Get the instance handle of the application.
    **
    **  @return   The application instance handle.
    **/
    HINSTANCE
    getInstance() const
    {
        return ( this->m_theInstance );
    }

#elif defined( EGD_USE_LINUX_XLIB )

    //----------------------------------------------------------------
    /**   Get the display (X-Server).
    **
    **  @return   The X-Server.
    **/
    Display *
    getDisplay() const
    {
        return ( this->m_theDisplay );
    }

    //----------------------------------------------------------------
    /**   Get the root window (Desktop window).
    **
    **  @return   The root window.
    **/
    Window
    getRootWindow() const
    {
        return ( this->m_rootWindow );
    }

    //----------------------------------------------------------------
    /**   Get the default screen.
    **
    **  @return   The default screen.
    **/
    int
    getDefaultScreen() const
    {
        return ( this->m_defScreen );
    }

    //----------------------------------------------------------------
    /**   Get the default visual.
    **
    **  @return   The default visual.
    **/
    Visual *
    getDefaultVisual() const
    {
        return ( this->m_defVisual );
    }

    //----------------------------------------------------------------
    /**   Get the default depth.
    **
    **  @return   The default depth.
    **/
    int
    getDefaultDepth() const
    {
        return ( this->m_defDepth );
    }

    //----------------------------------------------------------------
    /**   Get the default color map.
    **
    **  @return   The default color map.
    **/
    Colormap
    getDefaultColorMap() const
    {
        return ( this->m_defColorMap );
    }


    //----------------------------------------------------------------
    /**   Get the window deleting atom.
    **
    **  @return   The atom.
    **/
    Atom
    getDeleteWindowAtom() const
    {
        return ( this->m_delWndAtom );
    }

#endif

    //----------------------------------------------------------------
    /**   Register an event handler for idle event.
    **
    **  @param [in] fn : A function of idle event handler.
    **  @return   void.
    **/
    void
    registerIdleEventHandler(FnProcIdleEvent fn)
    {
        this->m_fnIdleEventHandler  = fn;
    }

    //----------------------------------------------------------------
    /**   Get the exit code of the application.
    **
    **  @return   The exit code.
    **/
    int
    getExitCode() const
    {
        return ( this->m_appExitCode );
    }

private:


#if defined( EGD_USE_WIN32_API )
    HINSTANCE       m_theInstance;
    int             m_argCmdShow;
    MSG             m_curMsg;
#else
    Display         m_theDisplay;
    Window          m_roowWindow;
    int             m_defScreen;
    Visual *        m_defVisual;
    int             m_defDepth;
    Colormap        m_defColorMap;
    unsigned long   m_black;
    unsigned long   m_white;
    XEvent          m_event;
    Atom            m_delWndAtom;
#endif

    int             m_appExitCode;
    int             m_endian;

    FnProcIdleEvent m_fnIdleEventHandler;

//========================================================================
//
//    For Internal Use Only.
//

#if defined( EGD_USE_WIN32_API )

    //----------------------------------------------------------------
    /**   Tell arguments of entry point to the application.
    **  The following is Win32 API version.
    **
    **  @param [in] hInstance : 1st argument of WinMain,
    **      the application instance handle.
    **  @param [in] cmdShow   : 4th argument of WinMain,
    **      the (initial showing) status of window.
    **  @return   void.
    **/
    void
    setEntryPointArguments(HINSTANCE hInstance, int cmdShow)
    {
        this->m_theInstance = hInstance;
        this->m_argCmdShow  = cmdShow;
    }

#elif defined( EGD_USE_LINUX_XLIB )

    //----------------------------------------------------------------
    /**   Tell arguments of entry point to the application.
    **  The following is Linux XLIB version.
    **
    **  @param [in] argc : 1st argument of main,
    **      the number of elements in argv.
    **  @param [in] argv : 2nd argument of main,
    **      an array of arguments.
    **  @return   void.
    **/
    void
    setEntryPointArguments(int argc, char * argv[])
    {
    }

#endif

#if defined( EGD_USE_WIN32_API )

    //----------------------------------------------------------------
    /**   Register a window class.
    **
    **  @param [in] className  : The name of the window class.
    **  @param [in] classStyle : The style of the class.
    **  @param [in] fnWndProc  : Address of the window procedure.
    **  @param [in] hIcon      : A handle to a window icon.
    **  @param [in] hCursor    : A handle to a window cursor.
    **  @param [in] hbrBack    : A handle to a background brush.
    **  @param [in] cbClsExtra : The size of class extra data.
    **  @param [in] cbWndExtra : The size of window extra data.
    **  @retval EGD_SUCCESS : Success.
    **  @retval EGD_FAILURE : Failure.
    **/
    int
    registerWndClass(
            BtCAString  className,
            UINT        classStyle,
            WNDPROC     fnWndProc   = (WNDPROC)NULL,
            HICON       hIcon       = (HICON)0,
            HCURSOR     hCursor     = (HCURSOR)0,
            HBRUSH      hbrBack     = (HBRUSH)(COLOR_WINDOW + 1),
            int         cbClsExtra  = 0,
            int         cbWndExtra  = 0);

    //----------------------------------------------------------------
    /**   Register a window class.
    **
    **  @param [in] className  : The name of the window class.
    **  @param [in] classStyle : The style of the class.
    **  @param [in] fnWndProc  : Address of the window procedure.
    **  @param [in] hIcon      : A handle to a window icon.
    **  @param [in] hCursor    : A handle to a window cursor.
    **  @param [in] hbrBack    : A handle to a background brush.
    **  @param [in] cbClsExtra : The size of class extra data.
    **  @param [in] cbWndExtra : The size of window extra data.
    **  @retval EGD_SUCCESS : Success.
    **  @retval EGD_FAILURE : Failure.
    **/
    int
    registerWndClass(
            BtCWString  className,
            UINT        classStyle,
            WNDPROC     fnWndProc   = (WNDPROC)NULL,
            HICON       hIcon       = (HICON)0,
            HCURSOR     hCursor     = (HCURSOR)0,
            HBRUSH      hbrBack     = (HBRUSH)(COLOR_WINDOW + 1),
            int         cbClsExtra  = 0,
            int         cbWndExtra  = 0);

    //----------------------------------------------------------------
    /**   Check if a message is for dialog or not.
    **
    **  @param [in] hwnd : A window handle of a dialog.
    **  @param [in] msg  : The message.
    **  @retval BT_BOOL_TRUE  : The message if a dialog message.
    **  @retval BT_BOOL_FALSE : The message is NOT for the dialog.
    **/
    int
    isDialogMessage(HWND hwnd, LPMSG msg);

#endif

};


}   //  End of namespace EGD_NS

#endif
