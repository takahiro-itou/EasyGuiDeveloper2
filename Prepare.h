/*************************************************************************
**                                                                      **
**                  --  Easy GUI Developer Library  --                  **
**                                                                      **
**          Prepare.h                                                   **
**                                                                      **
**          Copyright (c), anonymous, 2001 - 2011.                      **
**          All rights reserved.                                        **
**                                                                      **
*************************************************************************/

/**
**      @file       Prepare.h
**
**      This header file prepares building library.
**/

/*************************************************************************
**                                                                      **
**    This header file prepares building library. All source            **
**  files must include this header file before any other                **
**  including or statements.                                            **
**    To distinguish building and using, the system uses                **
**  a directive EGD_BUILD_LIBRARY. All application which uses           **
**  this libary must NOT define it.                                     **
**    Moreover, there are some procedures for building library          **
**  and this header file completes all these procedures.                **
**  Hence, this file must be included at first of all source            **
**  files in the library.                                               **
**                                                                      **
*************************************************************************/

#if !defined( EASY_GUI_DEVELOPER_INCLUDED_PREPARE_H )
#   define    EASY_GUI_DEVELOPER_INCLUDED_PREPARE_H

//========================================================================
//
//    Settings to build library.
//

#if !defined( EASYGUIDEVELOPER_BUILD_LIBRARY )
#   define  EASYGUIDEVELOPER_BUILD_LIBRARY
#endif
#if defined( EASYGUIDEVELOPER_USE_LIBRARY )
#   undef   EASYGUIDEVELOPER_USE_LIBRARY
#endif

#if defined( EASYGUIDEVELOPER_VC6 )             \
        || defined( EASYGUIDEVELOPER_VC2003 )   \
        || defined( EASYGUIDEVELOPER_VC2005 )   \
        || defined( EASYGUIDEVELOPER_VC2008 )   \
        || defined( EASYGUIDEVELOPER_VC2010 )
#   if !defined( EASYGUIDEVELOPER_RELEASE_VERSION ) \
            && !defined( EASYGUIDEVELOPER_DEBUG_VERSION )
#       if defined( _DEBUG )
#           define  EASYGUIDEVELOPER_DEBUG_VERSION
#       else
#           define  EASYGUIDEVELOPER_RELEASE_VERSION
#       endif
#   endif
#   if !defined( EASYGUIDEVELOPER_WIN32_EDITION )
#       define  EASYGUIDEVELOPER_WIN32_EDITION
#   endif
#endif

#include    "EasyGuiDeveloper.h"

#endif
