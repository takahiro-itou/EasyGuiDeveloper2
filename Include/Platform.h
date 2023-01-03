/*************************************************************************
**                                                                      **
**                  --  Easy GUI Deceloper Library  --                  **
**                                                                      **
**          Include/Platform.h                                          **
**                                                                      **
**          Copyright (c), anonymous, 2001 - 2011.                      **
**          All rights reserved.                                        **
**                                                                      **
*************************************************************************/

/**
**      @file       Include/Platform.h
**
**      Platform dependences.
**/

/*************************************************************************
**                                                                      **
**    このヘッダファイルは, プラットフォーム依存の内容を含む.           **
**  プラットフォーム依存を吸収するためのインターフェイスを提供する.     **
**                                                                      **
*************************************************************************/

#if !defined( EASY_GUI_DEVELOPER_INCLUDED_PLATFORM_H )
#   define    EASY_GUI_DEVELOPER_INCLUDED_PLATFORM_H

//========================================================================
//
//    Use HelpTools Library.
//

#if defined( EGD_USE_HELPTOOLS )

#   if defined( EASYGUIDEVELOPER_VC6 )
#       define  HELPTOOLS_VC6
#   elif defined( EASYGUIDEVELOPER_VC2003 )
#       define  HELPTOOLS_VC2003
#   elif defined( EASYGUIDEVELOPER_VC2005 )
#       define  HELPTOOLS_VC2005
#   elif defined( EASYGUIDEVELOPER_VC2008 )
#       define  HELPTOOLS_VC2008
#   elif defined( EASYGUIDEVELOPER_VC2010 )
#       define  HELPTOOLS_VC2010
#   endif

#   if defined( EGD_DYNAMIC_LIB_VERSION )
#       define  HELPTOOLS_DYNAMIC_LIB_VERSION
#   else
#       define  HELPTOOLS_STATIC_LIB_VERSION
#   endif

#   if defined( EGD_WIN32 )
#       define  HELPTOOLS_WIN32_EDITION
#   elif defined( EGD_CYGWIN )
#       define  HELPTOOLS_CYGWIN_EDITION
#   else
#       define  HELPTOOLS_LINUX_EDITION
#   endif

#   if defined( EGD_DEBUG_VERSION )
#       define  HELPTOOLS_DEBUG_VERSION
#       if !defined(MEMORY_CONTROL_STRICT) && !defined(MEMORY_CONTROL_FAST)
#           define  MEMORY_CONTROL_STRICT
#       endif
#   else
#       define  HELPTOOLS_RELEASE_VERSION
#       if !defined(MEMORY_CONTROL_STRICT) && !defined(~~MEMORY_CONTROL_FAST)
#           define  MEMORY_CONTROL_FAST
#       endif
#   endif

#   if !defined( HELPTOOLS_USE_LIBRARY )
#       define  HELPTOOLS_USE_LIBRARY
#   endif
#   if defined( HELPTOOLS_BUILD_LIBRARY )
#       undef   HELPTOOLS_BUILD_LIBRARY
#   endif

#   include     "HelpTools.h"

#endif  /* defined(EGD_USE_HELPTOOLS) */


//========================================================================
//
//    Include Header Files.
//

#if defined( EGD_USE_WIN32_API )

#   define      STRICT
#   define      WIN32_LEAN_AND_MEAN
#   include     <windows.h>
#   include     <process.h>
#   include     <winsock.h>
#   include     <windowsx.h>
#   include     <commdlg.h>

#   if defined( EASYGUIDEVELOPER_VC6 )          \
        || defined( EASYGUIDEVELOPER_VC2003 )   \
        || defined( EASYGUIDEVELOPER_VC2005 )

#       include     <zmouse.h>
#   endif
#   if !defined( GET_WHEEL_DELTA_WPARAM )
#       define  GET_WHEEL_DELTA_WPARAM(wparam)  ((short)HIWORD(wparam))
#   endif

#elif defined( EGD_USE_LINUX_XLIB )

#   include     <X11/Xlib.h>
#   include     <unistd.h>

#endif

//========================================================================
//
//    Namespace.
//

namespace   EGD_NS {

//========================================================================
//
//    Coordinates and Measurements.
//

/**
**    座標 (位置) を示す型.
**/
typedef     int     BtCoord;

/**
**    幅と高さを示す型.
**/
typedef     int     BtMeas;


//========================================================================
//
//    Graphics.
//

#if defined( EGD_USE_WIN32_API )

typedef     HDC     Graphic;

#   define      GRAPHIC_TO_HDC(g)   (g)

#elif defined( EGD_USE_LINUX_XLIB )

typedef struct {
    Display     * display;
    Window      window;
    GC          gc;
    Visual      * visual;
    int         depth;
} GraphicDevice;

typedef     GraphicDevice *     Graphic;

#endif  /* defined(EGD_USE_LINUX_XLIB) */

//========================================================================
//
//    Window Descriptor.
//

#if defined( EGD_USE_WIN32_API )

typedef     HWND    EgdWindowID;

typedef     int     ComponentIndex;

typedef     int     ComponentID;

#define     WNDID_TO_HWND(wid)      (wid)

#elif defined( EGD_USE_LINUX_XLIB )

typedef     Window  EgdWindowID;

typedef     int     ComponentIndex;

typedef     int     ComponentID;

#define     WNDID_TO_WINDOW(wid)    (wid)

#endif  /* defined(EGD_USE_LINUX_XLIB) */

}   //  End of namespace EGD_NS

#endif
