/*************************************************************************
**                                                                      **
**                  --  Easy GUI Developer Library  --                  **
**                                                                      **
**          Include/EasyGuiDeveloper.h                                  **
**                                                                      **
**          Copyright (c), anonymous, 2001 - 2011.                      **
**          All rights reserved.                                        **
**                                                                      **
*************************************************************************/

/**
**      @file       Include/EasyGuiDeveloper.h
**
**      An interface of the library.
**/

/*************************************************************************
**                                                                      **
**    This header file prepares building or using library. All          **
**  source files of this library must include this header file          **
**  via #include "Prepare.h" at the first.                              **
**    Each application which uses this library, all source files        **
**  must include this header file before including any other            **
**  header files of this library. Do NOT define a directive             **
**  EGD_BUILD_LIBRARY.                                                  **
**                                                                      **
*************************************************************************/

#if !defined( EASY_GUI_DEVELOPER_INCLUDED_EASY_GUI_DEVELOPER_H )
#   define    EASY_GUI_DEVELOPER_INCLUDED_EASY_GUI_DEVELOPER_H

//========================================================================
//
//    Check a platform: Win32, Cygwin, Linux.
//

#if defined( EASYGUIDEVELOPER_WIN32_EDITION )
#   define  EGD_WIN32
#   define  EGD_USE_WIN32_API
#elif defined( EASYGUIDEVELOPER_CYGWIN_EDITION )
#   define  EGD_CYGWIN
#   define  EGD_USE_LINUX_XLIB
#elif defined( EASYGUIDEVELOPER_LINUX_EDITION )
#   define  EGD_LINUX
#   define  EGD_USE_LINUX_XLIB
#   if defined( EASYGUIDEVELOPER_LINUX_ENABLE_GTK )
#       define  EGD_USE_LINUX_GTK
#   endif
#else
#   warning No Platform Specified
#   define  EGD_LINUX
#   define  EGD_USE_LINUX_XLIB
#endif

//========================================================================
//
//    Check a version: Debug or Release.
//

#if defined( EASYGUIDEVELOPER_DEBUG_VERSION )
#   define  EGD_DEBUG_VERSION
#elif defined( EASYGUIDEVELOPER_RELEASE_VERSION )
#   define  EGD_RELEASE_VERSION
#else
#   define  EGD_RELEASE_VERSION
#endif

//========================================================================
//
//    Check an environment.
//

#if defined( EASYGUIDEVELOPER_VC2003 )          \
        || defined( EASYGUIDEVELOPER_VC2005 )   \
        || defined( EASYGUIDEVELOPER_VC2008 )   \
        || defined( EASYGUIDEVELOPER_VC2010 )
#   if !defined( EGD_VCNET )
#       define  EGD_VCNET
#   endif
#endif

#if defined( EASYGUIDEVELOPER_VC2005 )          \
        || defined( EASYGUIDEVELOPER_VC2008 )   \
        || defined( EASYGUIDEVELOPER_VC2010 )
#   if !defined( EGD_VC_SECURE_CRT )
#       define  EGD_VC_SECURE_CRT
#   endif
#else
#   if defined( EGD_VC_SECURE_CRT )
#       undef   EGD_VC_SECURE_CRT
#   endif
#endif

#if defined( EASYGUIDEVELOPER_VC6 ) || defined( EGD_VCNET )
#   if defined( EGD_ENABLE_VA_ARGS_MACRO )
#       undef   EGD_ENABLE_VA_ARGS_MACRO
#   endif
#else
#   if !defined( EGD_ENABLE_VA_ARGS_MACRO )
#       define  EGD_ENABLE_VA_ARGS_MACRO
#   endif
#endif

//========================================================================
//
//    Interfaces.
//

#if defined( EASYGUIDEVELOPER_DYNAMIC_LIB_VERSION )
#   define  EGD_DYNAMIC_LIB_VERSION
#elif defined( EASYGUIDEVELOPER_STATIC_LIB_VERSION )
#   define  EGD_STATIC_LIB_VERSION
#else
#   define  EGD_STATIC_LIB_VERSION
#endif

#if defined( EASYGUIDEVELOPER_BUILD_LIBRARY )
#   define  EGD_BUILD_LIBRARY
#else
#   define  EGD_USE_LIBRARY
#endif

#if defined( EGD_DYNAMIC_LIB_VERSION )
#   if defined( EGD_BUILD_LIBRARY )
#       define  EGD_CLASS_INTERFACE     __declspec(dllexport)
#       define  EGD_LIBRARY_EXPORT      __declspec(dllexport)
#       define  EGD_APP_DEFINED         __declspec(dllimport)
#   else
#       define  EGD_CLASS_INTERFACE     __declspec(dllimport)
#       define  EGD_LIBRARY_EXPORT      __declspec(dllimport)
#       define  EGD_APP_DEFINED         __declspec(dllexport)
#   endif
#else   /* if defined(EGD_STATIC_LIB_VERSION) */
#   define  EGD_CLASS_INTERFACE
#   define  EGD_LIBRARY_EXPORT
#   define  EGD_APP_DEFINED
#endif


#if defined( EASYGUIDEVELOPER_VC6 ) || defined( EASYGUIDEVELOPER_VCNET )
#   define      EGD_INLINE      __inline
#else
#   define      EGD_INLINE      inline
#endif

/**
**    入力引数. 関数の引数が入力引数であることを明示する.
**  すなわち, 関数内で, その引数の内容を変更しない.
**/
#define     IN_ARG      const

/**
**    出力引数. 関数の引数が出力引数であることを明示する.
**  すなわち, 関数内でその引数の内容を変更する.
**
**    ただし, 入出力引数である場合にも使用する.
**  すなわち, 内容の読み取りと, 変更の両方を行う,
**/
#define     OUTARG


/**
**    メソッド (クラスのメンバ関数) が const  メンバ関数で
**  あることを明示する. この属性が付与されたメソッドは,
**  その内部でインスタンスの状態を変更しない.
**/
#define     CONSTMF     const


//========================================================================

#include    <stdio.h>

//========================================================================
//
//    Define a name space.
//

#define     EGD_NS  easy_gui_developper_namespace

namespace EGD_NS {

//========================================================================
//
//    Basic type definitions.
//

/**
**    Basic type definitions. All basic types has prefix Bt,
**  for example: BtBool is an Basic Type represents Bool.
**    The constant values of basic types has also prefix BT_,
**  for example: BT_BOOL_TRUE is a constant value of a basic type
**  BtBool type, and it represents TRUE value.
**/

//----------------------------------------------------------------

/**   A size type. This type represents the size of an array. */
typedef     const   size_t      BtSize;

/**   An index type. This type represents the subscript of an array. */
typedef     const   size_t      BtIndex;


//----------------------------------------------------------------
//
//    A character and a string (an array of characters).
//

//  Check the UNICODE.

#if !defined( EGD_UNICODE ) && !defined( EGD_NO_UNICODE )
#   if defined( _UNICODE )
#       define  EGD_UNICODE
#   else
#       define  EGD_NO_UNICODE
#   endif
#endif

/**   An ANSI character type. */
typedef     char        BtAChr;

/**
**    An ANSI string type, that is,
**  an array of (ANSI) characters.
**/
typedef     BtAChr *        BtAString;

/**
**    A const ANSI string type, that is an array of (ANSI)
**  characters, but the string is constant.
**/
typedef     const BtAChr *  BtCAString;

/**   A wide (Unicode) character type. */
typedef     wchar_t         BtWChr;

/**
**    A wide (Unicode) string type, that is,
**  an array of wide (Unicode) characters.
**/
typedef     BtWChr *        BtWString;

/**
**    A const wide (Unicode) string type, that is an array
**  of wide (Unicode) characters, but the string is constant.
**/
typedef     const BtWChr *  BtCWString;



/**
**    A character type. This type is one of BtAChr (ANSI) or
**  BtWChr (UNICODE). The macro EGD_UNICODE and EGD_NO_UNICODE
**/
typedef     char            BtTChr;

/**   A string type, that is an array of characters. */
typedef     BtTChr *        BtTStr;

/**
**    A constant string type, that is an array of characters,
**  but the string is constant.
**/
typedef     const BtTChr *  BtTCStr;

/**
**    A length type, which is equivalent to BtSize.
**  This type represents the length of a text.
**/
typedef     BtSize          BtTLen;

//----------------------------------------------------------------
/**   A boolean type, it represents true or false. */
typedef     int             BtBool;

/**   A boolean constant, TRUE. */
const       BtBool  BT_BOOL_TRUE    = 1;

/**   A boolean constant, FALSE. */
const       BtBool  BT_BOOL_FALSE   = 0;

/**
**    A boolean constant, which is a return value of funcitions,
**  SUCCESS. This value is equivalent to TRUE.
**/
const       BtBool  BT_SUCCESS  = BT_BOOL_TRUE;

/**
**    A boolean constant, which is a return value of functions,
**  FAILURE. This value is equivalent to FALSE.
**/
const       BtBool  BT_FAILURE  = BT_BOOL_FALSE;

}   //  End of namespace EGD_NS

//========================================================================
//
//    Exceptions and Assert.
//

#include    "Exceptions.h"

//========================================================================
//
//    Solve Platform Dependency.
//

#include    "Platform.h"


namespace EGD_NS {

//========================================================================
//
//    Handle (Pointer to class instance).
//

#define     EGD_INVALID_HANDLE      0

typedef     class Application *             HdlApp;
typedef     const class Application *       CnstHdlApp;

typedef     class WindowBase *              HdlWnd;
typedef     const class WindowBase *        CnstHdlWnd;

typedef     class DialogWindow *            HdlDlg;
typedef     const class DialogWindow *      CnstHdlDlg;

typedef     class CommSystem *              HdlComm;
typedef     const class CommSystem *        CnstHdlComm;



//========================================================================
//
//    Type Informations.
//

typedef     class ObjectBase *          HdlObj;
typedef     const class ObjectBase *    CnstHdlObj;

typedef     HdlObj  (* FnCreateObject)();

typedef     struct egdtagTypeInfo       EgdTagTypeInfo;
typedef     const EgdTagTypeInfo *      EgdTypeInfo;

/**
**    型情報の管理のための構造体.
**/
struct  egdtagTypeInfo {
    BtCAString      typeName;
    const   BtSize  cbSize;
    const   BtSize  reserved0;
    FnCreateObject  objectCreator;
    EgdTypeInfo     baseType;
};

/**
**
**/
const   EgdTypeInfo     EGD_INVALID_TYPEINFO    = ((EgdTypeInfo)0);

EGD_INLINE
HdlObj
createObject(EgdTypeInfo typeInfo)
{
    FnCreateObject  fn;

    if ( typeInfo == EGD_INVALID_TYPEINFO ) {
        EGD_THROW("Null Pointer Exception");
    }
    fn  = (typeInfo->objectCreator);
    if ( fn == static_cast<FnCreateObject>(NULL) ) {
        EGD_THROW("Null Pointer Exception");
    }
    return ( (* fn)() );
}

#define     EGD_TYPEINFO(classname)                             \
    &(classname::s_egd_tag_ ## classname)

#define     EGD_DECLARE_TYPEINFO(classname)                     \
    public:                                                     \
    virtual EgdTypeInfo         getTypeInfo() const;            \
    static const EgdTagTypeINfo s_egd_tag_ ## classname

#define     EGD_DECLARE_DYNAMIC_CREATION(classname)             \
    EGD_DECLARE_TYPEINFO(classname);                            \
    static  HdlObj              createObject()

#define     EGDTAG_IMPLEMENT_TYPEINFO(cls, base, fn)            \
    EgdTypeInfo     cls::getTypeInfo() const {                  \
        return ( EGD_TYPEINFO(cls) );                           \
    }                                                           \
    const EgdTagTypeInfo    cls::s_egd_tag_ ## cls = {          \
        # cls, sizeof(cls), -1, fn, EGD_TYPEINFO(base)          \
    }

#define     EGD_IMPLEMENT_TYPEINFO(cls, base)                   \
    EGDTAG_IMPLEMENT_TYPEINFO(cls, base, NULL)

#define     EGD_IMPLEMENT_DYNAMIC_CREATION(cls, base)           \
    HdlObj  cls::createObject() {                               \
        return ( new cls );                                     \
    }                                                           \
    EGDTAG_IMPLEMENT_TYPEINFO(cls, base, cls::createObject)

/**
**    型情報を持つクラスの基底クラス.
**/
class ObjectBase
{
public:
    ObjectBase()
    { }

    virtual ~ObjectBase() = 0;

public:
    virtual EgdTypeInfo
    getTypeInfo() const = 0;

    static
    const   EgdTagTypeInfo  s_egd_tag_ObjectBase;

};


//----------------------------------------------------------------
/**   二個の型情報を比較して, それらが同じか判定する.
**
**  @param [in] lhs   比較する一個目の型情報.
**  @param [in] rhs   比較する二個目の型情報.
**  @retval BT_BOOL_FALSE   二個の型情報は一致しない.
**  @retval Otherwise       二個の型情報は一致している.
**/

EGD_INLINE  BtBool
isTypeEqual(
        IN_ARG  EgdTypeInfo lhs,
        IN_ARG  EgdTypeInfo rhs)
{
    return ( (lhs == rhs) ? BT_BOOL_TRUE : BT_BOOL_FALSE );
}

//----------------------------------------------------------------
/**   二個の型情報を比較して, 一個目の型が, 二個目の
**  型の派生型 (Sub-Type) であるか判定する.
**
**  @param [in] downStream    一個目の型情報.
**  @param [in] upStream      二個目の型情報.
**  @return   もし, \a downStream が, \a upStream の
**      派生型 (Sub-Type) であれば, 正の整数を返す.
**      そうでなければ 0を返す.
**/

EGD_INLINE  int
isSubType(
        IN_ARG  EgdTypeInfo downStream,
        IN_ARG  EgdTypeInfo upStream)
{
    int cnt = 0;
    for ( EgdTypeInfo ti = downStream; ti; ti = ti->baseType ) {
        if ( ti == upStream ) { return ( cnt ); }
        ++ cnt;
    }
    return ( 0 );
}


//----------------------------------------------------------------
/**   オブジェクトが, 指定した型情報が示す型の
**  インスタンスであるかどうかを確認する.
**
**  @param [in] object      型を検査するオブジェクトのハンドル.
**  @param [in] typeInfo    型情報.
**  @return BT_BOOL_FALSE   オブジェクトは指定した型では無い.
**  @return Otherwise       オブジェクト \a object  は,
**      指定した型情報 \a typeInfo  が示す型のインスタンス.
**/

EGD_INLINE  BtBool
isTypeOf(
        IN_ARG  CnstHdlObj  object,
        IN_ARG  EgdTypeInfo typeInfo)
{
    return ( isTypeEqual(object->getTypeInfo(), typeInfo) );
}

//----------------------------------------------------------------
/**   オブジェクトが, 指定した型情報が示す型の
**  派生型のインスタンスであるかどうかを確認する.
**
**  @param [in] object      型を検査するオブジェクトのハンドル.
**  @param [in] baseType    型情報.
**  @return     もし, \a object が, \a baseType またはその
**      派生型 (Sub-Type) のインスタンスであれば, 正の整数を
**      返す. そうでなければ 0を返す.
**/

EGD_INLINE  int
isSubTypeObject(
        IN_ARG  CnstHdlObj  object,
        IN_ARG  EgdTypeInfo baseType)
{
    return ( isSubType(object->getTypeInfo(), baseType) );
}

}   //  End of namespace EGD_NS

#endif
