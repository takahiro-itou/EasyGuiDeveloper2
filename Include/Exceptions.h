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
**      @file       Include/Exceptions.
**
**      An interface of Exception classes.
**/

/*************************************************************************
**                                                                      **
**    このヘッダファイルは, 例外クラスを宣言する. 例外クラスは,         **
**  以下のように分類される.                                             **
**  - RuntimeError  クラス. 実行時エラークラス. ユーザーの入力や操作に  **
**      起因するエラーが発生した場合にスローされる.                     **
**  - LogicError  クラス. プログラム, またはライブラリ内部の誤りに      **
**      よる, 所謂, 内部ロジックに問題がある場合にスローされる.         **
**      - AssertFailure クラス. 特にアサートに失敗した場合である.       **
**                                                                      **
**    また, このヘッダファイルは, 例外をスローしたり, コンパイル        **
**  モード (Debug/Release)  によって, アサートの有効, 無効を切り替える  **
**  為のマクロも提供する.                                               **
**                                                                      **
*************************************************************************/

#if !defined( EASY_GUI_DEVELOPER_INCLUDED_EXCEPTIONS_H )
#   define    EASY_GUI_DEVELOPER_INCLUDED_EXCEPTIONS_H

#include    <stdexcept>

namespace EGD_NS {

/**
**    実行時エラー例外.
**/
class RuntimeError : public std::runtime_error
{
public:
    RuntimeError(
            IN_ARG  BtCAString  msg)
        : std::runtime_error(msg)
    { }
};

/**
**    内部ロジックエラー例外.
**/
class LogicError : public std::logic_error
{
public:
    LogicError(
            IN_ARG  BtCAString  msg)
        : std::logic_error(msg)
    { }
};

/**
**    アサート失敗を示す例外クラス.
**/
class AssertFailure : public LogicError
{
public:
    AssertFailure(
            IN_ARG  BtCAString  msg)
        : LogicError(msg)
    { }
};

/**
**
**  @tparam E   スローする例外の型.
**  @param [in] msg   エラーメッセージ.
**/

template <typename E>
EGD_INLINE  void
throwException(
        BtCAString  msg)
{
    throw E(msg);
}

/**
**    ファイル名と行番号を得るマクロ.
**  このマクロが置かれた位置の, ソースファイルの名前と,
**  行番号を, リテラル文字列化する.
**/
#define     EGD_FILE_LINE           __FILE__ ":" EGD_LINE_NUM

/**
**    行番号を得る.
**/
#define     EGD_LINE_NUM            EGD_LINE_TO_STR(__LINE__)

/**
**    行番号を, リテラル文字列に変換する.
**  @param [in] l   文字列化する行番号.
**/
#define     EGD_LINE_TO_STR(l)      EGD_NUM_TO_STR(l)

/**
**    数値をリテラル文字列に変換する.
**  @param [in] val   文字列化する数値.
**/
#define     EGD_NUM_TO_STR(val)     # val



#define     EGD_THROW(t)            \
    throwException<LogicError>(EGD_FILE_LINE ":" t)

#define     EGD_RUNTIME_ERROR(t)    \
    throwException<RuntimeError>(EGD_FILE_LINE ":" t)

}   //  End of namespace EGD_NS

#endif
