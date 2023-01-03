
######################################################################
##                                                                  ##
##  The makefile for building static/shared libraries.              ##
##                                                                  ##
######################################################################

######################################################################
##                                                                  ##
##  Usage.                                                          ##
##                                                                  ##
##  make           :   Build libraries.                             ##
##  make all       :                                                ##
##  make build     :                                                ##
##                                                                  ##
##  make cleanobjs :   Remove object files.                         ##
##  make clean     :   Remove all output files (object files and    ##
##                   output library files).                         ##
##  make rebuild   :   First remove all output files, then build.   ##
##                   This equals to `make clean; make build'.       ##
##  make depend    : Update the dependency file.                    ##
##                                                                  ##
##  Build environment and target version.                           ##
##                                                                  ##
##  BUILD_ENV=Mingw  :   The build environment is Mingw.            ##
##  BUILD_ENV=Cygwin :   The build environment is Cygwin.           ##
##  BUILD_ENV=Linux  :   The build environment is Linux.            ##
##  otherwise        :   The build environment is default, Linux.   ##
##                                                                  ##
##  TARGET_VERSION=Release :   The target is release edition.       ##
##  TARGET_VERSION=Debug   :   The target is debug edition.         ##
##  otherwise              :   The target is debug edition.         ##
##                                                                  ##
######################################################################

######################################################################
##
##  Extensions.
##
##    This makefile automatically read the file named `Projects.mak'
##  if the file exists. Overwrite the following variables
##  to change the output directory, output name, compiler options.
##  COMMON_....      :   For all build enviroments.
##  MINGW_....       :   BUILD_ENV=Mingw.
##  CYGWIN_....      :   BUILD_ENV=Cygwin.
##  LINUX_....       :   BUILD_ENV=Linux.
##  .._RELEASE_..    :   TARGET_VERSION=Release.
##  .._DEBUG_..      :   TARGET_VERSION=Debug.
##  ...._OUTPUT_DIR  :   The binary output directory name.
##  ...._OUTPUT_NAME :   The name of output binary.
##  ...._C_FLAGS     :   The C compiler options.
##  ...._CPP_FLAGS   :   The C++ compiler options.
##  ...._LINK_FLAGS  :   The linker options.
##  ...._LIBS_DIR    :   The -L options, library directories.
##  ...._LIBS        :   The -l options, libraries.
##
##
##    The following variables hold a default, proper values.
##  Overwrite the settings to change the make action.
##  C_COMPILER   : The name of C compiler.
##  CPP_COMPILER : The name of C++ compiler.
##  LINK_COMMAND : The name of linker.
##  GDB_COMMAND  : The name of debugger.
##  CD_COMMAND   : The command which changes directory (eg. cd).
##  PWD_COMMAND  : The command which gets current directory (eg. pwd).
##  LS_COMMAND   : The command which gets file list (eg. ls)
##  RM_COMMAND   : The command which removes file (eg. rm -f)
##  PROJECT_HOME : The root directory of the project.
##  SOURCE_DIR   : The directory that holds source files.
##  INCLUDE_DIRS : The directories that hold header files.
##  OBJECTS_DIR  : The directory that saves object files.
##  OUTPUT_DIR   : The directory that saves output binary file. 
##  PROGRAM_NAME : The name of output binary (without directory name).
##  OBJECT_FILES : The list of object files (with directory name).
##
##    Overwrite the following variables, to silent make action.
##  SILENT_COMPILE = @ :   If right hand side is @,
##  SILENT_LINK    = @ : make displays only few messages.
##  SILENT_MAKE    = @
##
######################################################################

##################################################################
##
##  The build enviroments.
##

ifeq ($(strip $(BUILD_ENV)),)
  BUILD_ENV             := Linux
endif

ifeq ($(strip $(TARGET_VERSION)),)
  TARGET_VERSION        := Debug
endif

ifeq ($(strip $(BUILD_ENV)),Mingw)
      UC_BUILD_ENV      := MINGW
      LC_BUILD_ENV      := mingw
      TARGET_PLATFORM   := WIN32
      LD_PATHS_SEP      := ;
else
  ifeq ($(strip $(BUILD_ENV)),Cygwin)
      UC_BUILD_ENV      := CYGWIN
      LC_BUILD_ENV      := cygwin
      TARGET_PLATFORM   := CYGWIN
      LD_PATHS_SEP      := :
  else
    ifeq ($(strip $(BUILD_ENV)),Linux)
      UC_BUILD_ENV      := LINUX
      LC_BUILD_ENV      := linux
      TARGET_PLATFORM   := LINUX
      LD_PATHS_SEP      := :
    else
      BUILD_ENV         := Linux
      UC_BUILD_ENV      := LINUX
      LC_BUILD_ENV      := linux
      TARGET_PLATFORM   := LINUX
      LD_PATHS_SEP      := :
    endif
  endif
endif

ifeq ($(strip $(TARGET_VERSION)),Debug)
    UC_TARGET_NAME  := DEBUG
    LC_TARGET_NAME  := debug
else
  ifeq ($(strip $(TARGET_VERSION)),Release)
    UC_TARGET_NAME  := RELEASE
    LC_TARGET_NAME  := release
  else
    TARGET_VERSION  := Debug
    UC_TARGET_NAME  := DEBUG
    LC_TARGET_NAME  := debug
  endif
endif

S_EDITION_OBJDIR    := $(BUILD_ENV)Slib$(TARGET_VERSION)
D_EDITION_OBJDIR    := $(BUILD_ENV)Dll$(TARGET_VERSION)
EDITION_PREFIX      := $(UC_BUILD_ENV)_$(UC_TARGET_NAME)
CONFIG_NAME         := $(strip $(BUILD_ENV))$(strip $(TARGET_VERSION))

##################################################################
##
##  The default settings.
##

SILENT_COMPILE      := @
SILENT_LINK         := @
SILENT_MAKE         := @
MAKE_SILENT_FLAG    := -s

THE_MAKEFILE        := makefile

ifeq ($(strip $(BUILD_ENV)),Mingw)
  MFLU_CHG_DIR_SEP  := 1
  C_COMPILER        := gcc
  CPP_COMPILER      := g++
  AR_COMMAND        := ar rcs
  LINK_COMMAND      := gcc
  GDB_COMMAND       := gdb
  CD_COMMAND        := cd
  PWD_COMMAND       := cd
  LS_COMMAND        := dir
  RM_COMMAND        := del
endif

ifeq ($(strip $(BUILD_ENV)),Cygwin)
  MFLU_CHG_DIR_SEP  := 0
  C_COMPILER        := gcc
  CPP_COMPILER      := g++
  AR_COMMAND        := ar rcs
  LINK_COMMAND      := gcc
  GDB_COMMAND       := gdb
  CD_COMMAND        := cd
  PWD_COMMAND       := pwd
  LS_COMMAND        := ls
  RM_COMMAND        := rm -f
endif

ifeq ($(strip $(BUILD_ENV)),Linux)
  MFLU_CHG_DIR_SEP  := 0
  C_COMPILER        := gcc
  CPP_COMPILER      := g++
  AR_COMMAND        := ar rcs
  LINK_COMMAND      := gcc
  GDB_COMMAND       := gdb
  CD_COMMAND        := cd
  PWD_COMMAND       := pwd
  LS_COMMAND        := ls
  RM_COMMAND        := rm -f
endif

CURRENT_DIR         := $(shell $(PWD_COMMAND))
PROJECT_HOME        := ./
PROGRAM_NAME        := $(notdir $(CURRENT_DIR))
LIBRARY_TITLE       := lib$(PROGRAM_NAME)
MINGW_DLL_TITLE     := $(PROGRAM_NAME)
DIRECTIVE_PREFIX    := $(shell echo $(PROGRAM_NAME) | tr \[a-z\] \[A-Z\])
DIRECTIVE_PREFIX    := $(strip $(DIRECTIVE_PREFIX))
PROJECT_DEPEND_FILE := Projects.depend
DEPEND_TEMP_FILE    := .Projects.depend

PLATFORM_DIRECTIVE  := -D$(DIRECTIVE_PREFIX)_$(TARGET_PLATFORM)_EDITION
VERSION_DIRECTIVE   := -D$(DIRECTIVE_PREFIX)_$(UC_TARGET_NAME)_VERSION
EDITION_DIRECTIVES  := $(PLATFORM_DIRECTIVE) $(VERSION_DIRECTIVE)

SOURCE_DIR          := $(PROJECT_HOME)Source/
S_OBJECTS_DIR       := $(PROJECT_HOME)Objects/$(S_EDITION_OBJDIR)/
D_OBJECTS_DIR       := $(PROJECT_HOME)Objects/$(D_EDITION_OBJDIR)/

HOME_C_FILES        := $(wildcard $(PROJECT_HOME)*.c)
HOME_CPP_FILES      := $(wildcard $(PROJECT_HOME)*.cpp)
SOURCE_C_FILES      := $(wildcard $(SOURCE_DIR)*.c)
SOURCE_CPP_FILES    := $(wildcard $(SOURCE_DIR)*.cpp)
RESOURCE_SCRIPTS    := $(wildcard $(PROJECT_HOME)*.rc)

S_OBJECT_FILES      := \
    $(HOME_C_FILES:$(PROJECT_HOME)%.c=$(S_OBJECTS_DIR)%.o)          \
    $(HOME_CPP_FILES:$(PROJECT_HOME)%.cpp=$(S_OBJECTS_DIR)%.obj)    \
    $(SOURCE_C_FILES:$(SOURCE_DIR)%.c=$(S_OBJECTS_DIR)%.o)          \
    $(SOURCE_CPP_FILES:$(SOURCE_DIR)%.cpp=$(S_OBJECTS_DIR)%.obj)    \
	$(RESOURCE_SCRIPTS:$(PROJECT_HOME)%.rc=$(S_OBJECTS_DIR)%.coff)
D_OBJECT_FILES      := \
    $(HOME_C_FILES:$(PROJECT_HOME)%.c=$(D_OBJECTS_DIR)%.o)          \
    $(HOME_CPP_FILES:$(PROJECT_HOME)%.cpp=$(D_OBJECTS_DIR)%.obj)    \
    $(SOURCE_C_FILES:$(SOURCE_DIR)%.c=$(D_OBJECTS_DIR)%.o)          \
    $(SOURCE_CPP_FILES:$(SOURCE_DIR)%.cpp=$(D_OBJECTS_DIR)%.obj)    \
	$(RESOURCE_SCRIPTS:$(PROJECT_HOME)%.rc=$(D_OBJECTS_DIR)%.coff)

S_COMMON_RELEASE_C_FLAGS        := -Wall -O2 -DMEMORY_CONTROL_FAST
S_COMMON_RELEASE_CPP_FLAGS      := -Wall -O2 -DMEMORY_CONTROL_FAST
S_COMMON_RELEASE_RC_FLAGS       :=
S_COMMON_RELEASE_LINK_FLAGS     := -Wall
S_COMMON_RELEASE_INC_DIRS       := $(PROJECT_HOME) $(PROJECT_HOME)Include/
S_COMMON_RELEASE_SLIB_DIRS      :=
S_COMMON_RELEASE_DLIB_DIRS      :=
S_COMMON_RELEASE_LIBS           :=
S_COMMON_DEBUG_C_FLAGS          := -Wall -g -DMEMORY_CONTROL_STRICT
S_COMMON_DEBUG_CPP_FLAGS        := -Wall -g -DMEMORY_CONTROL_STRICT
S_COMMON_DEBUG_RC_FLAGS         :=
S_COMMON_DEBUG_LINK_FLAGS       := -Wall
S_COMMON_DEBUG_INC_DIRS         := $(PROJECT_HOME) $(PROJECT_HOME)Include/
S_COMMON_DEBUG_SLIB_DIRS        :=
S_COMMON_DEBUG_DLIB_DIRS        :=
S_COMMON_DEBUG_LIBS             :=
D_COMMON_RELEASE_C_FLAGS        := -Wall -O2 -DMEMORY_CONTROL_FAST
D_COMMON_RELEASE_CPP_FLAGS      := -Wall -O2 -DMEMORY_CONTROL_FAST
D_COMMON_RELEASE_RC_FLAGS       :=
D_COMMON_RELEASE_LINK_FLAGS     := -Wall
D_COMMON_RELEASE_INC_DIRS       := $(PROJECT_HOME) $(PROJECT_HOME)Include/
D_COMMON_RELEASE_SLIB_DIRS      :=
D_COMMON_RELEASE_DLIB_DIRS      :=
D_COMMON_RELEASE_LIBS           :=
D_COMMON_DEBUG_C_FLAGS          := -Wall -g -DMEMORY_CONTROL_STRICT
D_COMMON_DEBUG_CPP_FLAGS        := -Wall -g -DMEMORY_CONTROL_STRICT
D_COMMON_DEBUG_RC_FLAGS         :=
D_COMMON_DEBUG_LINK_FLAGS       := -Wall
D_COMMON_DEBUG_INC_DIRS         := $(PROJECT_HOME) $(PROJECT_HOME)Include/
D_COMMON_DEBUG_SLIB_DIRS        :=
D_COMMON_DEBUG_DLIB_DIRS        :=
D_COMMON_DEBUG_LIBS             :=

S_MINGW_RELEASE_OUTPUT_DIR      := $(PROJECT_HOME)Lib/
S_MINGW_RELEASE_LIBRARY_NAME    := $(LIBRARY_TITLE)$(CONFIG_NAME).a
S_MINGW_RELEASE_C_FLAGS         :=
S_MINGW_RELEASE_CPP_FLAGS       :=
S_MINGW_RELEASE_RC_FLAGS        :=
S_MINGW_RELEASE_LINK_FLAGS      :=
S_MINGW_RELEASE_INC_DIRS        :=
S_MINGW_RELEASE_SLIB_DIRS       :=
S_MINGW_RELEASE_DLIB_DIRS       :=
S_MINGW_RELEASE_LIBS            :=
S_MINGW_DEBUG_OUTPUT_DIR        := $(PROJECT_HOME)Lib/
S_MINGW_DEBUG_LIBRARY_NAME      := $(LIBRARY_TITLE)$(CONFIG_NAME).a
S_MINGW_DEBUG_C_FLAGS           :=
S_MINGW_DEBUG_CPP_FLAGS         :=
S_MINGW_DEBUG_RC_FLAGS          :=
S_MINGW_DEBUG_LINK_FLAGS        :=
S_MINGW_DEBUG_INC_DIRS          :=
S_MINGW_DEBUG_SLIB_DIRS         :=
S_MINGW_DEBUG_DLIB_DIRS         :=
S_MINGW_DEBUG_LIBS              :=
D_MINGW_RELEASE_OUTPUT_DIR      := $(PROJECT_HOME)Bin/
D_MINGW_RELEASE_LIBRARY_NAME    := $(LIBRARY_TITLE)$(CONFIG_NAME).a
D_MINGW_RELEASE_SO_NAME         := $(MINGW_DLL_TITLE)$(CONFIG_NAME).dll
D_MINGW_RELEASE_SHORT_NAME      :=
D_MINGW_RELEASE_C_FLAGS         :=
D_MINGW_RELEASE_CPP_FLAGS       :=
D_MINGW_RELEASE_RC_FLAGS        :=
D_MINGW_RELEASE_LINK_FLAGS      :=
D_MINGW_RELEASE_INC_DIRS        :=
D_MINGW_RELEASE_SLIB_DIRS       :=
D_MINGW_RELEASE_DLIB_DIRS       :=
D_MINGW_RELEASE_LIBS            :=
D_MINGW_DEBUG_OUTPUT_DIR        := $(PROJECT_HOME)Bin/
D_MINGW_DEBUG_LIBRARY_NAME      := $(LIBRARY_TITLE)$(CONFIG_NAME).a
D_MINGW_DEBUG_SO_NAME           := $(MINGW_DLL_TITLE)$(CONFIG_NAME).dll
D_MINGW_DEBUG_SHORT_NAME        :=
D_MINGW_DEBUG_C_FLAGS           :=
D_MINGW_DEBUG_CPP_FLAGS         :=
D_MINGW_DEBUG_RC_FLAGS          :=
D_MINGW_DEBUG_LINK_FLAGS        :=
D_MINGW_DEBUG_INC_DIRS          :=
D_MINGW_DEBUG_SLIB_DIRS         :=
D_MINGW_DEBUG_DLIB_DIRS         :=
D_MINGW_DEBUG_LIBS              :=

S_CYGWIN_RELEASE_OUTPUT_DIR     := $(PROJECT_HOME)Lib/
S_CYGWIN_RELEASE_LIBRARY_NAME   := $(LIBRARY_TITLE)$(CONFIG_NAME).a
S_CYGWIN_RELEASE_C_FLAGS        :=
S_CYGWIN_RELEASE_CPP_FLAGS      :=
S_CYGWIN_RELEASE_RC_FLAGS       :=
S_CYGWIN_RELEASE_LINK_FLAGS     :=
S_CYGWIN_RELEASE_INC_DIRS       :=
S_CYGWIN_RELEASE_SLIB_DIRS      :=
S_CYGWIN_RELEASE_DLIB_DIRS      :=
S_CYGWIN_RELEASE_LIBS           :=
S_CYGWIN_DEBUG_OUTPUT_DIR       := $(PROJECT_HOME)Lib/
S_CYGWIN_DEBUG_LIBRARY_NAME     := $(LIBRARY_TITLE)$(CONFIG_NAME).a
S_CYGWIN_DEBUG_C_FLAGS          :=
S_CYGWIN_DEBUG_CPP_FLAGS        :=
S_CYGWIN_DEBUG_RC_FLAGS         :=
S_CYGWIN_DEBUG_LINK_FLAGS       :=
S_CYGWIN_DEBUG_INC_DIRS         :=
S_CYGWIN_DEBUG_SLIB_DIRS        :=
S_CYGWIN_DEBUG_DLIB_DIRS        :=
S_CYGWIN_DEBUG_LIBS             :=
D_CYGWIN_RELEASE_OUTPUT_DIR     :=
D_CYGWIN_RELEASE_LIBRARY_NAME   :=
D_CYGWIN_RELEASE_SO_NAME        :=
D_CYGWIN_RELEASE_SHORT_NAME     :=
D_CYGWIN_RELEASE_C_FLAGS        :=
D_CYGWIN_RELEASE_CPP_FLAGS      :=
D_CYGWIN_RELEASE_RC_FLAGS       :=
D_CYGWIN_RELEASE_LINK_FLAGS     :=
D_CYGWIN_RELEASE_INC_DIRS       :=
D_CYGWIN_RELEASE_SLIB_DIRS      :=
D_CYGWIN_RELEASE_DLIB_DIRS      :=
D_CYGWIN_RELEASE_LIBS           :=
D_CYGWIN_DEBUG_OUTPUT_DIR       :=
D_CYGWIN_DEBUG_LIBRARY_NAME     :=
D_CYGWIN_DEBUG_SO_NAME          :=
D_CYGWIN_DEBUG_SHORT_NAME       :=
D_CYGWIN_DEBUG_C_FLAGS          :=
D_CYGWIN_DEBUG_CPP_FLAGS        :=
D_CYGWIN_DEBUG_RC_FLAGS         :=
D_CYGWIN_DEBUG_LINK_FLAGS       :=
D_CYGWIN_DEBUG_INC_DIRS         :=
D_CYGWIN_DEBUG_SLIB_DIRS        :=
D_CYGWIN_DEBUG_DLIB_DIRS        :=
D_CYGWIN_DEBUG_LIBS             :=

S_LINUX_RELEASE_OUTPUT_DIR      := $(PROJECT_HOME)Lib/
S_LINUX_RELEASE_LIBRARY_NAME    := $(LIBRARY_TITLE)$(CONFIG_NAME).a
S_LINUX_RELEASE_C_FLAGS         :=
S_LINUX_RELEASE_CPP_FLAGS       :=
S_LINUX_RELEASE_RC_FLAGS        :=
S_LINUX_RELEASE_LINK_FLAGS      :=
S_LINUX_RELEASE_INC_DIRS        :=
S_LINUX_RELEASE_SLIB_DIRS       :=
S_LINUX_RELEASE_DLIB_DIRS       :=
S_LINUX_RELEASE_LIBS            :=
S_LINUX_DEBUG_OUTPUT_DIR        := $(PROJECT_HOME)Lib/
S_LINUX_DEBUG_LIBRARY_NAME      := $(LIBRARY_TITLE)$(CONFIG_NAME).a
S_LINUX_DEBUG_C_FLAGS           :=
S_LINUX_DEBUG_CPP_FLAGS         :=
S_LINUX_DEBUG_RC_FLAGS          :=
S_LINUX_DEBUG_LINK_FLAGS        :=
S_LINUX_DEBUG_INC_DIRS          :=
S_LINUX_DEBUG_SLIB_DIRS         :=
S_LINUX_DEBUG_DLIB_DIRS         :=
S_LINUX_DEBUG_LIBS              :=
D_LINUX_RELEASE_OUTPUT_DIR      := $(PROJECT_HOME)Bin/
D_LINUX_RELEASE_LIBRARY_NAME    := $(LIBRARY_TITLE)$(CONFIG_NAME).so.0.0
D_LINUX_RELEASE_SO_NAME         := $(LIBRARY_TITLE)$(CONFIG_NAME).so.0
D_LINUX_RELEASE_SHORT_NAME      := $(LIBRARY_TITLE)$(CONFIG_NAME).so
D_LINUX_RELEASE_C_FLAGS         := -fPIC
D_LINUX_RELEASE_CPP_FLAGS       := -fPIC
D_LINUX_RELEASE_RC_FLAGS        :=
D_LINUX_RELEASE_LINK_FLAGS      :=
D_LINUX_RELEASE_INC_DIRS        :=
D_LINUX_RELEASE_SLIB_DIRS       :=
D_LINUX_RELEASE_DLIB_DIRS       :=
D_LINUX_RELEASE_LIBS            :=
D_LINUX_DEBUG_OUTPUT_DIR        := $(PROJECT_HOME)Bin/
D_LINUX_DEBUG_LIBRARY_NAME      := $(LIBRARY_TITLE)$(CONFIG_NAME).so.0.0
D_LINUX_DEBUG_SO_NAME           := $(LIBRARY_TITLE)$(CONFIG_NAME).so.0
D_LINUX_DEBUG_SHORT_NAME        := $(LIBRARY_TITLE)$(CONFIG_NAME).so
D_LINUX_DEBUG_C_FLAGS           := -fPIC
D_LINUX_DEBUG_CPP_FLAGS         := -fPIC
D_LINUX_DEBUG_RC_FLAGS          :=
D_LINUX_DEBUG_LINK_FLAGS        :=
D_LINUX_DEBUG_INC_DIRS          :=
D_LINUX_DEBUG_SLIB_DIRS         :=
D_LINUX_DEBUG_DLIB_DIRS         :=
D_LINUX_DEBUG_LIBS              :=

##################################################################
##
##  Read the project local settings from `Projects.mak'
##

-include Projects.mak

S_OUTPUT_DIR        := $(S_$(EDITION_PREFIX)_OUTPUT_DIR)
S_LIBRARY_NAME      := $(S_$(EDITION_PREFIX)_LIBRARY_NAME)
D_OUTPUT_DIR        := $(D_$(EDITION_PREFIX)_OUTPUT_DIR)
D_LIBRARY_NAME      := $(D_$(EDITION_PREFIX)_LIBRARY_NAME)
D_SO_NAME           := $(D_$(EDITION_PREFIX)_SO_NAME)
D_SHORT_NAME        := $(D_$(EDITION_PREFIX)_SHORT_NAME)

S_C_COMPILE_FLAGS   := $(S_COMMON_$(UC_TARGET_NAME)_C_FLAGS)        \
    $(S_$(EDITION_PREFIX)_C_FLAGS) $(EDITION_DIRECTIVES)
S_CPP_COMPILE_FLAGS := $(S_COMMON_$(UC_TARGET_NAME)_CPP_FLAGS)    \
    $(S_$(EDITION_PREFIX)_CPP_FLAGS) $(EDITION_DIRECTIVES)
S_RES_COMPILE_FLAGS := $(S_COMMON_$(UC_TARGET_NAME)_RC_FLAGS)     \
    $(S_$(EDITION_PREFIX)_RC_FLAGS)
S_LINK_FLAGS        := $(S_COMMON_$(UC_TARGET_NAME)_LINK_FLAGS)   \
    $(S_$(EDITION_PREFIX)_LINK_FLAGS)
S_INCLUDE_DIRS      := $(S_$(EDITION_PREFIX)_INC_DIRS)            \
    $(S_COMMON_$(UC_TARGET_NAME)_INC_DIRS)
S_STATIC_LIB_DIRS   := $(S_$(EDITION_PREFIX)_SLIB_DIRS)           \
    $(S_COMMON_$(UC_TARGET_NAME)_SLIB_DIRS)
S_SHARED_LIB_DIRS   := $(S_$(EDITION_PREFIX)_DLIB_DIRS)           \
    $(S_COMMON_$(UC_TARGET_NAME)_DLIB_DIRS)
S_LIB_DIRS          := $(S_STATIC_LIB_DIRS) $(S_SHARED_LIB_DIRS)
S_LIBRARIES         := $(S_$(EDITION_PREFIX)_LIBS)                \
    $(S_COMMON_$(UC_TARGET_NAME)_LIBS)
D_C_COMPILE_FLAGS   := $(D_COMMON_$(UC_TARGET_NAME)_C_FLAGS)        \
    $(D_$(EDITION_PREFIX)_C_FLAGS) $(EDITION_DIRECTIVES)
D_CPP_COMPILE_FLAGS := $(D_COMMON_$(UC_TARGET_NAME)_CPP_FLAGS)    \
    $(D_$(EDITION_PREFIX)_CPP_FLAGS) $(EDITION_DIRECTIVES)
D_RES_COMPILE_FLAGS := $(D_COMMON_$(UC_TARGET_NAME)_RC_FLAGS)     \
    $(D_$(EDITION_PREFIX)_RC_FLAGS)
D_LINK_FLAGS        := $(D_COMMON_$(UC_TARGET_NAME)_LINK_FLAGS)   \
    $(D_$(EDITION_PREFIX)_LINK_FLAGS)
D_INCLUDE_DIRS      := $(D_$(EDITION_PREFIX)_INC_DIRS)            \
    $(D_COMMON_$(UC_TARGET_NAME)_INC_DIRS)
D_STATIC_LIB_DIRS   := $(D_$(EDITION_PREFIX)_SLIB_DIRS)           \
    $(D_COMMON_$(UC_TARGET_NAME)_SLIB_DIRS)
D_SHARED_LIB_DIRS   := $(D_$(EDITION_PREFIX)_DLIB_DIRS)           \
    $(D_COMMON_$(UC_TARGET_NAME)_DLIB_DIRS)
D_LIB_DIRS          := $(D_STATIC_LIB_DIRS) $(D_SHARED_LIB_DIRS)
D_LIBRARIES         := $(D_$(EDITION_PREFIX)_LIBS)                \
    $(D_COMMON_$(UC_TARGET_NAME)_LIBS)

##
##  The internal use variables.
##

MFLU_PROJECT_HOME_RE    := $(subst /,\/,$(PROJECT_HOME))
MFLU_PROJECT_HOME_RE    := $(subst .,\.,$(MFLU_PROJECT_HOME_RE))
MFLU_PROJECT_HOME_RE    := $(strip $(MFLU_PROJECT_HOME_RE))

S_MFLU_CFLAGS_INC_DIRS  := $(patsubst %,-I%,$(S_INCLUDE_DIRS))
S_MFLU_LFLAGS_LIB_DIRS  := $(patsubst %,-L%,$(S_LIB_DIRS))
S_MFLU_LFLAGS_LIBS      := $(patsubst %,-l%,$(S_LIBRARIES))
S_MFLU_LINK_FLAGS       := $(S_LINK_FLAGS)
S_MFLU_LINK_LIBRARIES   := $(S_MFLU_LFLAGS_LIB_DIRS) $(S_MFLU_LFLAGS_LIBS)
S_MFLU_LD_LIB_PATHS     :=  \
    $(patsubst %,%$(LD_PATHS_SEP),$(S_SHARED_LIB_DIRS))
D_MFLU_CFLAGS_INC_DIRS  := $(patsubst %,-I%,$(D_INCLUDE_DIRS))
D_MFLU_LFLAGS_LIB_DIRS  := $(patsubst %,-L%,$(D_LIB_DIRS))
D_MFLU_LFLAGS_LIBS      := $(patsubst %,-l%,$(D_LIBRARIES))
D_MFLU_LINK_FLAGS       := $(D_LINK_FLAGS)
D_MFLU_LINK_LIBRARIES   := $(D_MFLU_LFLAGS_LIB_DIRS) $(D_MFLU_LFLAGS_LIBS)
D_MFLU_LD_LIB_PATHS     :=  \
    $(patsubst %,%$(LD_PATHS_SEP),$(D_SHARED_LIB_DIRS))

S_C_COMPILE_FLAGS       += -D$(DIRECTIVE_PREFIX)_BUILD_LIBRARY  \
    -D$(DIRECTIVE_PREFIX)_STATIC_LIB_VERSION
S_CPP_COMPILE_FLAGS     += -D$(DIRECTIVE_PREFIX)_BUILD_LIBRARY  \
    -D$(DIRECTIVE_PREFIX)_STATIC_LIB_VERSION
D_C_COMPILE_FLAGS       += -D$(DIRECTIVE_PREFIX)_BUILD_LIBRARY  \
    -D$(DIRECTIVE_PREFIX)_DYNAMIC_LIB_VERSION
D_CPP_COMPILE_FLAGS     += -D$(DIRECTIVE_PREFIX)_BUILD_LIBRARY  \
    -D$(DIRECTIVE_PREFIX)_DYNAMIC_LIB_VERSION

S_C_COMPILE_FLAGS       += $(S_MFLU_CFLAGS_INC_DIRS)
S_CPP_COMPILE_FLAGS     += $(S_MFLU_CFLAGS_INC_DIRS)
D_C_COMPILE_FLAGS       += $(D_MFLU_CFLAGS_INC_DIRS)
D_CPP_COMPILE_FLAGS     += $(D_MFLU_CFLAGS_INC_DIRS)


ifeq ($(strip $(MFLU_CHG_DIR_SEP)),1)
  S_MFCDS_OBJECTS_DIR  := $(subst /,\,$(S_OBJECTS_DIR))
  S_MFCDS_OUTPUT_DIR   := $(subst /,\,$(S_OUTPUT_DIR))
  D_MFCDS_OBJECTS_DIR  := $(subst /,\,$(D_OBJECTS_DIR))
  D_MFCDS_OUTPUT_DIR   := $(subst /,\,$(D_OUTPUT_DIR))
else
  S_MFCDS_OBJECTS_DIR  := $(S_OBJECTS_DIR)
  S_MFCDS_OUTPUT_DIR   := $(S_OUTPUT_DIR)
  D_MFCDS_OBJECTS_DIR  := $(D_OBJECTS_DIR)
  D_MFCDS_OUTPUT_DIR   := $(D_OUTPUT_DIR)
endif

ifeq ($(strip $(S_LIBRARY_NAME)),)
  S_MFCDS_LIBRARY_NAME      :=
else
  S_MFCDS_LIBRARY_NAME      := $(S_MFCDS_OUTPUT_DIR)$(S_LIBRARY_NAME)
endif
ifeq ($(strip $(D_LIBRARY_NAME)),)
  D_MFCDS_LIBRARY_NAME      :=
  D_MFCDS_SO_NAME           :=
else
  D_MFCDS_LIBRARY_NAME      := $(D_MFCDS_OUTPUT_DIR)$(D_LIBRARY_NAME)
  D_MFCDS_SO_NAME           := $(D_MFCDS_OUTPUT_DIR)$(D_SO_NAME)
endif
ifeq ($(strip $(D_SHORT_NAME)),)
  D_MFCDS_SHORT_NAME        :=
else
  D_MFCDS_SHORT_NAME        := $(D_MFCDS_OUTPUT_DIR)$(D_SHORT_NAME)
endif

##################################################################
##
##  The commands.
##

.PHONY : all build rebuild clean cleanobjs
.PHONY : depend updatedependency params

all: build

build: $(S_MFCDS_LIBRARY_NAME) $(D_MFCDS_LIBRARY_NAME)

rebuild:
	$(SILENT_MAKE)$(MAKE) clean
	$(SILENT_MAKE)$(MAKE) build

clean:
ifneq ($(strip $(S_MFCDS_LIBRARY_NAME)),)
	-$(RM_COMMAND) $(S_MFCDS_LIBRARY_NAME)
endif
ifneq ($(strip $(D_MFCDS_LIBRARY_NAME)),)
	-$(RM_COMMAND) $(D_MFCDS_LIBRARY_NAME) \
		$(D_MFCDS_SO_NAME)  $(D_MFCDS_SHORT_NAME)
endif
	-$(RM_COMMAND) $(S_MFCDS_OBJECTS_DIR)*.o
	-$(RM_COMMAND) $(S_MFCDS_OBJECTS_DIR)*.obj
	-$(RM_COMMAND) $(S_MFCDS_OBJECTS_DIR)*.coff
	-$(RM_COMMAND) $(D_MFCDS_OBJECTS_DIR)*.o
	-$(RM_COMMAND) $(D_MFCDS_OBJECTS_DIR)*.obj
	-$(RM_COMMAND) $(D_MFCDS_OBJECTS_DIR)*.coff

cleanobjs:
	-$(RM_COMMAND) $(S_MFCDS_OBJECTS_DIR)*.o
	-$(RM_COMMAND) $(S_MFCDS_OBJECTS_DIR)*.obj
	-$(RM_COMMAND) $(S_MFCDS_OBJECTS_DIR)*.coff
	-$(RM_COMMAND) $(D_MFCDS_OBJECTS_DIR)*.o
	-$(RM_COMMAND) $(D_MFCDS_OBJECTS_DIR)*.obj
	-$(RM_COMMAND) $(D_MFCDS_OBJECTS_DIR)*.coff

depend: $(THE_MAKEFILE) updatedependency
	@cat $(PROJECT_DEPEND_FILE)

params:
	@echo The parameters:
	@echo "BUILD_ENV           = $(BUILD_ENV)"
	@echo "TARGET_VERSION      = $(TARGET_VERSION)"
	@echo "CONFIG_NAME         = $(CONFIG_NAME)"
	@echo "THE_MAKEFILE        = $(THE_MAKEFILE)"
	@echo "PROJECT_HOME        = $(PROJECT_HOME)"
	@echo "PROGRAM_NAME        = $(PROGRAM_NAME)"
	@echo "LIBRARY_TITLE       = $(LIBRARY_TITLE)"
	@echo "MINGW_DLL_TITLE     = $(MINGW_DLL_TITLE)"
	@echo "DIRECTIVE_PREFIX    = $(DIRECTIVE_PREFIX)"
	@echo "PROJECT_DEPEND_FILE = $(PROJECT_DEPEND_FILE)"
	@echo "SOURCE_DIR          = $(SOURCE_DIR)"
	@echo "S_INCLUDE_DIRS      = $(S_INCLUDE_DIRS)"
	@echo "S_OBJECTS_DIR       = $(S_OBJECTS_DIR)"
	@echo "D_INCLUDE_DIRS      = $(D_INCLUDE_DIRS)"
	@echo "D_OBJECTS_DIR       = $(D_OBJECTS_DIR)"
	@echo "S_OUTPUT_DIR        = $(S_OUTPUT_DIR)"
	@echo "S_LIBRARY_NAME      = $(S_MFCDS_LIBRARY_NAME)"
	@echo "D_OUTPUT_DIR        = $(D_OUTPUT_DIR)"
	@echo "D_LIBRARY_NAME      = $(D_MFCDS_LIBRARY_NAME)"
	@echo "HOME_C_FILES        = $(HOME_C_FILES)"
	@echo "HOME_CPP_FILES      = $(HOME_CPP_FILES)"
	@echo "SOURCE_C_FILES      = $(SOURCE_C_FILES)"
	@echo "SOURCE_CPP_FILES    = $(SOURCE_CPP_FILES)"
	@echo "RESOURCE_SCRIPTS    = $(RESOURCE_SCRIPTS)"
	@echo "S_OBJECT_FILES      = $(S_OBJECT_FILES)"
	@echo "D_OBJECT_FILES      = $(D_OBJECT_FILES)"
	@echo "S_C_COMPILE_FLAGS   = $(S_C_COMPILE_FLAGS)"
	@echo "S_CPP_COMPILE_FLAGS = $(S_CPP_COMPILE_FLAGS)"
	@echo "S_RES_COMPILE_FLAGS = $(S_RES_COMPILE_FLAGS)"
	@echo "S_LINK_FLAGS        = $(S_MFLU_LINK_FLAGS)"
	@echo "S_LINK_LIBRARIES    = $(S_MFLU_LINK_LIBRARIES)"
	@echo "D_C_COMPILE_FLAGS   = $(D_C_COMPILE_FLAGS)"
	@echo "D_CPP_COMPILE_FLAGS = $(D_CPP_COMPILE_FLAGS)"
	@echo "D_RES_COMPILE_FLAGS = $(D_RES_COMPILE_FLAGS)"
	@echo "D_LINK_FLAGS        = $(D_MFLU_LINK_FLAGS)"
	@echo "D_LINK_LIBRARIES    = $(D_MFLU_LINK_LIBRARIES)"
	@echo The internal use parameters:
	@echo "LD_PATHS_SEP        = $(LD_PATHS_SEP)"
	@echo "S_CFLAGS_INC_DIRS   = $(S_MFLU_CFLAGS_INC_DIRS)"
	@echo "D_CFLAGS_INC_DIRS   = $(D_MFLU_CFLAGS_INC_DIRS)"

##################################################################
##
##  The generation rules.
##

##
##  Link object files.
##

$(S_MFCDS_LIBRARY_NAME) : $(THE_MAKEFILE) $(S_OBJECT_FILES)
	@echo Linking object files and creating static library ...
	$(SILENT_LINK)$(AR_COMMAND) $(S_MFCDS_LIBRARY_NAME) $(S_OBJECT_FILES)

$(D_MFCDS_LIBRARY_NAME) : $(THE_MAKEFILE) $(D_OBJECT_FILES)
	@echo Linking object files and creating shared library ...
ifeq ($(strip $(BUILD_ENV)),Mingw)
	$(SILENT_LINK)$(LINK_COMMAND) $(D_MFLU_LINK_FLAGS)      \
		-shared -Wl,--out-implib,$(D_MFCDS_LIBRARY_NAME)    \
		-o $(D_MFCDS_SO_NAME) $(D_OBJECT_FILES)             \
		$(D_MFLU_LINK_LIBRARIES)
else
	$(SILENT_LINK)$(LINK_COMMAND) $(D_MFLU_LINK_FLAGS)      \
		-shared -Wl,-soname,$(D_MFCDS_SO_NAME)              \
		-o $(D_MFCDS_LIBRARY_NAME) $(D_OBJECT_FILES)        \
		$(D_MFLU_LINK_LIBRARIES)
	@echo Creating symbolic links ...
	-/sbin/ldconfig -n $(D_MFCDS_OUTPUT_DIR)
	ln -sf $(D_SO_NAME) $(D_MFCDS_OUTPUT_DIR)$(D_SHORT_NAME)
endif

##
##  Compile source files.
##

$(S_OBJECTS_DIR)%.o : $(THE_MAKEFILE) $(SOURCE_DIR)%.c
	@echo Compile [$*.c] ...
	$(SILENT_COMPILE)$(C_COMPILER) $(S_C_COMPILE_FLAGS)       \
		-c -o $(S_OBJECTS_DIR)$*.o $(SOURCE_DIR)$*.c

$(S_OBJECTS_DIR)%.obj : $(THE_MAKEFILE) $(SOURCE_DIR)%.cpp
	@echo Compile [$*.cpp] ...
	$(SILENT_COMPILE)$(CPP_COMPILER) $(S_CPP_COMPILE_FLAGS)   \
		-c -o $(S_OBJECTS_DIR)$*.obj $(SOURCE_DIR)$*.cpp

$(S_OBJECTS_DIR)%.o : $(THE_MAKEFILE) $(PROJECT_HOME)%.c
	@echo Compile [$*.c] ...
	$(SILENT_COMPILE)$(C_COMPILER) $(S_C_COMPILE_FLAGS)       \
		-c -o $(S_OBJECTS_DIR)$*.o $(PROJECT_HOME)$*.c

$(S_OBJECTS_DIR)%.obj : $(THE_MAKEFILE) $(PROJECT_HOME)%.cpp
	@echo Compile [$*.cpp] ...
	$(SILENT_COMPILE)$(CPP_COMPILER) $(S_CPP_COMPILE_FLAGS)   \
		-c -o $(S_OBJECTS_DIR)$*.obj $(PROJECT_HOME)$*.cpp

$(S_OBJECTS_DIR)%.coff : $(THE_MAKEFILE) $(PROJECT_HOME)%.rc
	@echo "Compile resource [$*.rc] ..."
	$(SILENT_COMPILE)$(RES_COMPILER) $(S_RES_COMPILE_FLAGS)   \
		-o $(S_OBJECTS_DIR)$*.coff $(PROJECT_HOME)$*.rc


$(D_OBJECTS_DIR)%.o : $(THE_MAKEFILE) $(SOURCE_DIR)%.c
	@echo Compile [$*.c] ...
	$(SILENT_COMPILE)$(C_COMPILER) $(D_C_COMPILE_FLAGS)       \
		-c -o $(D_OBJECTS_DIR)$*.o $(SOURCE_DIR)$*.c

$(D_OBJECTS_DIR)%.obj : $(THE_MAKEFILE) $(SOURCE_DIR)%.cpp
	@echo Compile [$*.cpp] ...
	$(SILENT_COMPILE)$(CPP_COMPILER) $(D_CPP_COMPILE_FLAGS)   \
		-c -o $(D_OBJECTS_DIR)$*.obj $(SOURCE_DIR)$*.cpp

$(D_OBJECTS_DIR)%.o : $(THE_MAKEFILE) $(PROJECT_HOME)%.c
	@echo Compile [$*.c] ...
	$(SILENT_COMPILE)$(C_COMPILER) $(D_C_COMPILE_FLAGS)       \
		-c -o $(D_OBJECTS_DIR)$*.o $(PROJECT_HOME)$*.c

$(D_OBJECTS_DIR)%.obj : $(THE_MAKEFILE) $(PROJECT_HOME)%.cpp
	@echo Compile [$*.cpp] ...
	$(SILENT_COMPILE)$(CPP_COMPILER) $(D_CPP_COMPILE_FLAGS)   \
		-c -o $(D_OBJECTS_DIR)$*.obj $(PROJECT_HOME)$*.cpp

$(D_OBJECTS_DIR)%.coff : $(THE_MAKEFILE) $(PROJECT_HOME)%.rc
	@echo "Compile resource [$*.rc] ..."
	$(SILENT_COMPILE)$(RES_COMPILER) $(D_RES_COMPILE_FLAGS)   \
		-o $(D_OBJECTS_DIR)$*.coff $(PROJECT_HOME)$*.rc

##################################################################
##
##  The dependency file.
##

##
##  Generate dependency file.
##

updatedependency:
	@echo "Generating dependency file [$(PROJECT_DEPEND_FILE)]"
	@echo "Getting dependency ..."

	@echo "" > $(DEPEND_TEMP_FILE)
	@echo "##" >> $(DEPEND_TEMP_FILE)
	@echo "## The dependency" >> $(DEPEND_TEMP_FILE)
	@echo "##" >> $(DEPEND_TEMP_FILE)
	@echo "" >> $(DEPEND_TEMP_FILE)
ifneq ($(strip $(HOME_C_FILES) $(SOURCE_C_FILES)),)
	-@$(C_COMPILER) -MM $(S_C_COMPILE_FLAGS)       \
		$(HOME_C_FILES) $(SOURCE_C_FILES) >> $(DEPEND_TEMP_FILE)
endif
ifneq ($(strip $(HOME_CPP_FILES) $(SOURCE_CPP_FILES)),)
	-@$(CPP_COMPILER) -MM $(S_CPP_COMPILE_FLAGS)   \
		$(HOME_CPP_FILES) $(SOURCE_CPP_FILES) >> $(DEPEND_TEMP_FILE)
endif
	@echo "" >> $(DEPEND_TEMP_FILE)
	@sed -e 's/^\(.*\)\.o:\(.*\1\.c \)/$$(S_OBJECTS_DIR)\1.o:\2/g'      \
		-e 's/^\(.*\)\.o:\(.*\1\.c$$\)/$$(S_OBJECTS_DIR)\1.o:\2/g'      \
		-e 's/^\(.*\)\.o:\(.*\1\.cpp\)/$$(S_OBJECTS_DIR)\1.obj:\2/g'    \
		$(DEPEND_TEMP_FILE)                                             \
	| sed -e '/^\#\#/!s/\([^ ]\)\(  *\)\([^ ]\)/\1 \\\n  \3/g'          \
	| sed -e '/^\#\#/!s/\([^\\]\)$$/\1\n/g'                             \
	| sed -e '/\(^[^ ]\|^  $(MFLU_PROJECT_HOME_RE)\)\|^$$/!d'           \
	| sed -e '/\\$$/{' -e N -e 's/\\\n$$/\n/g' -e '}' -e P -e D         \
		> $(PROJECT_DEPEND_FILE)

	@echo "" > $(DEPEND_TEMP_FILE)
	@echo "##" >> $(DEPEND_TEMP_FILE)
	@echo "## The dependency" >> $(DEPEND_TEMP_FILE)
	@echo "##" >> $(DEPEND_TEMP_FILE)
	@echo "" >> $(DEPEND_TEMP_FILE)
ifneq ($(strip $(HOME_C_FILES) $(SOURCE_C_FILES)),)
	-@$(C_COMPILER) -MM $(D_C_COMPILE_FLAGS)       \
		$(HOME_C_FILES) $(SOURCE_C_FILES) >> $(DEPEND_TEMP_FILE)
endif
ifneq ($(strip $(HOME_CPP_FILES) $(SOURCE_CPP_FILES)),)
	-@$(CPP_COMPILER) -MM $(D_CPP_COMPILE_FLAGS)   \
		$(HOME_CPP_FILES) $(SOURCE_CPP_FILES) >> $(DEPEND_TEMP_FILE)
endif
	@echo "" >> $(DEPEND_TEMP_FILE)
	@sed -e 's/^\(.*\)\.o:\(.*\1\.c \)/$$(D_OBJECTS_DIR)\1.o:\2/g'      \
		-e 's/^\(.*\)\.o:\(.*\1\.c$$\)/$$(D_OBJECTS_DIR)\1.o:\2/g'      \
		-e 's/^\(.*\)\.o:\(.*\1\.cpp\)/$$(D_OBJECTS_DIR)\1.obj:\2/g'    \
		$(DEPEND_TEMP_FILE)                                             \
	| sed -e '/^\#\#/!s/\([^ ]\)\(  *\)\([^ ]\)/\1 \\\n  \3/g'          \
	| sed -e '/^\#\#/!s/\([^\\]\)$$/\1\n/g'                             \
	| sed -e '/\(^[^ ]\|^  $(MFLU_PROJECT_HOME_RE)\)\|^$$/!d'           \
	| sed -e '/\\$$/{' -e N -e 's/\\\n$$/\n/g' -e '}' -e P -e D         \
		>> $(PROJECT_DEPEND_FILE)

	@$(RM_COMMAND) $(DEPEND_TEMP_FILE)

##
##  Include the dependency file.
##

-include $(PROJECT_DEPEND_FILE)

