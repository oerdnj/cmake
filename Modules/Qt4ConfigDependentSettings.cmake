# This file is included by FindQt4.cmake, don't include it directly.

#=============================================================================
# Copyright 2005-2009 Kitware, Inc.
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distributed this file outside of CMake, substitute the full
#  License text for the above reference.)


###############################################
#
#       configuration/system dependent settings  
#
###############################################

# find dependencies for some Qt modules
# when doing builds against a static Qt, they are required
# when doing builds against a shared Qt, they are not required
# if a user needs the dependencies, and they couldn't be found, they can set
# the variables themselves.

SET(QT_QTGUI_LIB_DEPENDENCIES "")
SET(QT_QTCORE_LIB_DEPENDENCIES "")
SET(QT_QTNETWORK_LIB_DEPENDENCIES "")
SET(QT_QTOPENGL_LIB_DEPENDENCIES "")
SET(QT_QTDBUS_LIB_DEPENDENCIES "")
SET(QT_QTHELP_LIB_DEPENDENCIES ${QT_QTCLUCENE_LIBRARY})


IF(WIN32)
  # On Windows, qconfig.pri has "static" for static library builds
  IF(QT_CONFIG MATCHES "static")
    SET(QT_IS_STATIC 1)
  ENDIF(QT_CONFIG MATCHES "static")
ELSE(WIN32)
  # On other platforms, check file extension to know if its static
  IF(QT_QTCORE_LIBRARY_RELEASE)
    GET_FILENAME_COMPONENT(qtcore_lib_ext "${QT_QTCORE_LIBRARY_RELEASE}" EXT)
    IF("${qtcore_lib_ext}" STREQUAL "${CMAKE_STATIC_LIBRARY_SUFFIX}")
      SET(QT_IS_STATIC 1)
    ENDIF("${qtcore_lib_ext}" STREQUAL "${CMAKE_STATIC_LIBRARY_SUFFIX}")
  ENDIF(QT_QTCORE_LIBRARY_RELEASE)
  IF(QT_QTCORE_LIBRARY_DEBUG)
    GET_FILENAME_COMPONENT(qtcore_lib_ext "${QT_QTCORE_LIBRARY_DEBUG}" EXT)
    IF(${qtcore_lib_ext} STREQUAL ${CMAKE_STATIC_LIBRARY_SUFFIX})
      SET(QT_IS_STATIC 1)
    ENDIF(${qtcore_lib_ext} STREQUAL ${CMAKE_STATIC_LIBRARY_SUFFIX})
  ENDIF(QT_QTCORE_LIBRARY_DEBUG)
ENDIF(WIN32)

# build using shared Qt needs -DQT_DLL on Windows
IF(WIN32  AND  NOT QT_IS_STATIC)
  SET(QT_DEFINITIONS ${QT_DEFINITIONS} -DQT_DLL)
ENDIF(WIN32  AND  NOT QT_IS_STATIC)

IF(NOT QT_IS_STATIC)
  RETURN()
ENDIF(NOT QT_IS_STATIC)

# QtOpenGL dependencies
find_package(OpenGL)
SET (QT_QTOPENGL_LIB_DEPENDENCIES ${OPENGL_glu_LIBRARY} ${OPENGL_gl_LIBRARY})


## system png
IF(QT_QCONFIG MATCHES "system-png")
  FIND_LIBRARY(QT_PNG_LIBRARY NAMES png)
  MARK_AS_ADVANCED(QT_PNG_LIBRARY)
  IF(QT_PNG_LIBRARY)
    SET(QT_QTGUI_LIB_DEPENDENCIES ${QT_QTGUI_LIB_DEPENDENCIES} ${QT_PNG_LIBRARY})
  ENDIF(QT_PNG_LIBRARY)
ENDIF(QT_QCONFIG MATCHES "system-png")


# for X11, get X11 library directory
IF(Q_WS_X11)
  FIND_PACKAGE(X11)
ENDIF(Q_WS_X11)


## X11 SM
IF(QT_QCONFIG MATCHES "x11sm")
  IF(X11_SM_LIB AND X11_ICE_LIB)
    SET(QT_QTGUI_LIB_DEPENDENCIES ${QT_QTGUI_LIB_DEPENDENCIES} ${X11_SM_LIB} ${X11_ICE_LIB})
  ENDIF(X11_SM_LIB AND X11_ICE_LIB)
ENDIF(QT_QCONFIG MATCHES "x11sm")


## Xi
IF(QT_QCONFIG MATCHES "tablet")
  IF(X11_Xi_LIB)
    SET(QT_QTGUI_LIB_DEPENDENCIES ${QT_QTGUI_LIB_DEPENDENCIES} ${X11_Xi_LIB})
  ENDIF(X11_Xi_LIB)
ENDIF(QT_QCONFIG MATCHES "tablet")


## Xrender
IF(QT_QCONFIG MATCHES "xrender")
  IF(X11_Xrender_LIB)
    SET(QT_QTGUI_LIB_DEPENDENCIES ${QT_QTGUI_LIB_DEPENDENCIES} ${X11_Xrender_LIB})
  ENDIF(X11_Xrender_LIB)
ENDIF(QT_QCONFIG MATCHES "xrender")


## Xrandr
IF(QT_QCONFIG MATCHES "xrandr")
  IF(X11_Xrandr_LIB)
    SET(QT_QTGUI_LIB_DEPENDENCIES ${QT_QTGUI_LIB_DEPENDENCIES} ${X11_Xrandr_LIB})
  ENDIF(X11_Xrandr_LIB)
ENDIF(QT_QCONFIG MATCHES "xrandr")


## Xcursor
IF(QT_QCONFIG MATCHES "xcursor")
  IF(X11_Xcursor_LIB)
    SET(QT_QTGUI_LIB_DEPENDENCIES ${QT_QTGUI_LIB_DEPENDENCIES} ${X11_Xcursor_LIB})
  ENDIF(X11_Xcursor_LIB)
ENDIF(QT_QCONFIG MATCHES "xcursor")


## Xinerama
IF(QT_QCONFIG MATCHES "xinerama")
  IF(X11_Xinerama_LIB)
    SET(QT_QTGUI_LIB_DEPENDENCIES ${QT_QTGUI_LIB_DEPENDENCIES} ${X11_Xinerama_LIB})
  ENDIF(X11_Xinerama_LIB)
ENDIF(QT_QCONFIG MATCHES "xinerama")


## Xfixes
IF(QT_QCONFIG MATCHES "xfixes")
  IF(X11_Xfixes_LIB)
    SET(QT_QTGUI_LIB_DEPENDENCIES ${QT_QTGUI_LIB_DEPENDENCIES} ${X11_Xfixes_LIB})
  ENDIF(X11_Xfixes_LIB)
ENDIF(QT_QCONFIG MATCHES "xfixes")


## system-freetype
IF(QT_QCONFIG MATCHES "system-freetype")
  FIND_LIBRARY(QT_FREETYPE_LIBRARY NAMES freetype)
  MARK_AS_ADVANCED(QT_FREETYPE_LIBRARY)
  IF(QT_FREETYPE_LIBRARY)
    SET(QT_QTGUI_LIB_DEPENDENCIES ${QT_QTGUI_LIB_DEPENDENCIES} ${QT_FREETYPE_LIBRARY})
  ENDIF(QT_FREETYPE_LIBRARY)
ENDIF(QT_QCONFIG MATCHES "system-freetype")


## fontconfig
IF(QT_QCONFIG MATCHES "fontconfig")
  FIND_LIBRARY(QT_FONTCONFIG_LIBRARY NAMES fontconfig)
  MARK_AS_ADVANCED(QT_FONTCONFIG_LIBRARY)
  IF(QT_FONTCONFIG_LIBRARY)
    SET(QT_QTGUI_LIB_DEPENDENCIES ${QT_QTGUI_LIB_DEPENDENCIES} ${QT_FONTCONFIG_LIBRARY})
  ENDIF(QT_FONTCONFIG_LIBRARY)
ENDIF(QT_QCONFIG MATCHES "fontconfig")


## system-zlib
IF(QT_QCONFIG MATCHES "system-zlib")
  FIND_LIBRARY(QT_ZLIB_LIBRARY NAMES z)
  MARK_AS_ADVANCED(QT_ZLIB_LIBRARY)
  IF(QT_ZLIB_LIBRARY)
    SET(QT_QTCORE_LIB_DEPENDENCIES ${QT_QTCORE_LIB_DEPENDENCIES} ${QT_ZLIB_LIBRARY})
  ENDIF(QT_ZLIB_LIBRARY)
ENDIF(QT_QCONFIG MATCHES "system-zlib")


## openssl
IF(NOT Q_WS_WIN)
  SET(_QT_NEED_OPENSSL 0)
  IF(QT_VERSION_MINOR LESS 4 AND QT_QCONFIG MATCHES "openssl")
    SET(_QT_NEED_OPENSSL 1)
  ENDIF(QT_VERSION_MINOR LESS 4 AND QT_QCONFIG MATCHES "openssl")
  IF(QT_VERSION_MINOR GREATER 3 AND QT_QCONFIG MATCHES "openssl-linked")
    SET(_QT_NEED_OPENSSL 1)
  ENDIF(QT_VERSION_MINOR GREATER 3 AND QT_QCONFIG MATCHES "openssl-linked")
  IF(_QT_NEED_OPENSSL)
    FIND_PACKAGE(OpenSSL)
    IF(OPENSSL_LIBRARIES)
      SET(QT_QTNETWORK_LIB_DEPENDENCIES ${QT_QTNETWORK_LIB_DEPENDENCIES} ${OPENSSL_LIBRARIES})
    ENDIF(OPENSSL_LIBRARIES)
  ENDIF(_QT_NEED_OPENSSL)
ENDIF(NOT Q_WS_WIN)


## dbus
IF(QT_QCONFIG MATCHES "dbus")

  # if the dbus library isn't found, we'll assume its not required to build
  # shared Qt on Linux doesn't require it
  IF(NOT QT_DBUS_LIBRARY)
    EXECUTE_PROCESS(COMMAND pkg-config --libs-only-L dbus-1
      OUTPUT_VARIABLE _dbus_query_output
      RESULT_VARIABLE _dbus_result
      ERROR_VARIABLE _dbus_query_output )

    IF(_dbus_result MATCHES 0)
      STRING(REPLACE "-L" "" _dbus_query_output "${_dbus_query_output}")
      SEPARATE_ARGUMENTS(_dbus_query_output)
    ELSE(_dbus_result MATCHES 0)
      SET(_dbus_query_output)
    ENDIF(_dbus_result MATCHES 0)

    FIND_LIBRARY(QT_DBUS_LIBRARY NAMES dbus-1 PATHS ${_dbus_query_output} )

    IF(QT_DBUS_LIBRARY)
      SET(QT_QTDBUS_LIB_DEPENDENCIES ${QT_QTDBUS_LIB_DEPENDENCIES} ${QT_DBUS_LIBRARY})
    ENDIF(QT_DBUS_LIBRARY)

    MARK_AS_ADVANCED(QT_DBUS_LIBRARY)
  ENDIF(NOT QT_DBUS_LIBRARY)

ENDIF(QT_QCONFIG MATCHES "dbus")


## glib
IF(QT_QCONFIG MATCHES "glib")

  # if the glib libraries aren't found, we'll assume its not required to build
  # shared Qt on Linux doesn't require it

  # Qt 4.2.0+ uses glib-2.0
  IF(NOT QT_GLIB_LIBRARY OR NOT QT_GTHREAD_LIBRARY)
    EXECUTE_PROCESS(COMMAND pkg-config --libs-only-L glib-2.0 gthread-2.0
      OUTPUT_VARIABLE _glib_query_output
      RESULT_VARIABLE _glib_result
      ERROR_VARIABLE _glib_query_output )

    IF(_glib_result MATCHES 0)
      STRING(REPLACE "-L" "" _glib_query_output "${_glib_query_output}")
      SEPARATE_ARGUMENTS(_glib_query_output)
    ELSE(_glib_result MATCHES 0)
      SET(_glib_query_output)
    ENDIF(_glib_result MATCHES 0)

    FIND_LIBRARY(QT_GLIB_LIBRARY NAMES glib-2.0 PATHS ${_glib_query_output} )
    FIND_LIBRARY(QT_GTHREAD_LIBRARY NAMES gthread-2.0 PATHS ${_glib_query_output} )

    MARK_AS_ADVANCED(QT_GLIB_LIBRARY)
    MARK_AS_ADVANCED(QT_GTHREAD_LIBRARY)
  ENDIF(NOT QT_GLIB_LIBRARY OR NOT QT_GTHREAD_LIBRARY)

  IF(QT_GLIB_LIBRARY AND QT_GTHREAD_LIBRARY)
    SET(QT_QTCORE_LIB_DEPENDENCIES ${QT_QTCORE_LIB_DEPENDENCIES}
        ${QT_GTHREAD_LIBRARY} ${QT_GLIB_LIBRARY})
  ENDIF(QT_GLIB_LIBRARY AND QT_GTHREAD_LIBRARY)


  # Qt 4.5+ also links to gobject-2.0
  IF(QT_VERSION_MINOR GREATER 4)
     IF(NOT QT_GOBJECT_LIBRARY)
       EXECUTE_PROCESS(COMMAND pkg-config --libs-only-L gobject-2.0
         OUTPUT_VARIABLE _glib_query_output
         RESULT_VARIABLE _glib_result
         ERROR_VARIABLE _glib_query_output )

       IF(_glib_result MATCHES 0)
         STRING(REPLACE "-L" "" _glib_query_output "${_glib_query_output}")
         SEPARATE_ARGUMENTS(_glib_query_output)
       ELSE(_glib_result MATCHES 0)
         SET(_glib_query_output)
       ENDIF(_glib_result MATCHES 0)

       FIND_LIBRARY(QT_GOBJECT_LIBRARY NAMES gobject-2.0 PATHS ${_glib_query_output} )

       MARK_AS_ADVANCED(QT_GOBJECT_LIBRARY)
     ENDIF(NOT QT_GOBJECT_LIBRARY)

     IF(QT_GOBJECT_LIBRARY)
       SET(QT_QTCORE_LIB_DEPENDENCIES ${QT_QTCORE_LIB_DEPENDENCIES}
           ${QT_GOBJECT_LIBRARY})
     ENDIF(QT_GOBJECT_LIBRARY)
  ENDIF(QT_VERSION_MINOR GREATER 4)

ENDIF(QT_QCONFIG MATCHES "glib")


## clock-monotonic, just see if we need to link with rt
IF(QT_QCONFIG MATCHES "clock-monotonic")
  SET(CMAKE_REQUIRED_LIBRARIES_SAVE ${CMAKE_REQUIRED_LIBRARIES})
  SET(CMAKE_REQUIRED_LIBRARIES rt)
  CHECK_SYMBOL_EXISTS(_POSIX_TIMERS "unistd.h;time.h" QT_POSIX_TIMERS)
  SET(CMAKE_REQUIRED_LIBRARIES ${CMAKE_REQUIRED_LIBRARIES_SAVE})
  IF(QT_POSIX_TIMERS)
    FIND_LIBRARY(QT_RT_LIBRARY NAMES rt)
    MARK_AS_ADVANCED(QT_RT_LIBRARY)
    IF(QT_RT_LIBRARY)
      SET(QT_QTCORE_LIB_DEPENDENCIES ${QT_QTCORE_LIB_DEPENDENCIES} ${QT_RT_LIBRARY})
    ENDIF(QT_RT_LIBRARY)
  ENDIF(QT_POSIX_TIMERS)
ENDIF(QT_QCONFIG MATCHES "clock-monotonic")


IF(Q_WS_X11)
  # X11 libraries Qt always depends on
  SET(QT_QTGUI_LIB_DEPENDENCIES ${QT_QTGUI_LIB_DEPENDENCIES} ${X11_Xext_LIB} ${X11_X11_LIB})

  set(CMAKE_THREAD_PREFER_PTHREADS 1)
  find_package(Threads)
  if(CMAKE_USE_PTHREADS_INIT)
    SET(QT_QTCORE_LIB_DEPENDENCIES ${QT_QTCORE_LIB_DEPENDENCIES} ${CMAKE_THREAD_LIBS_INIT})
  endif(CMAKE_USE_PTHREADS_INIT)

  SET (QT_QTCORE_LIB_DEPENDENCIES ${QT_QTCORE_LIB_DEPENDENCIES} ${CMAKE_DL_LIBS})

ENDIF(Q_WS_X11)


IF(Q_WS_WIN)
  SET(QT_QTGUI_LIB_DEPENDENCIES ${QT_QTGUI_LIB_DEPENDENCIES} imm32 winmm)
  SET(QT_QTCORE_LIB_DEPENDENCIES ${QT_QTCORE_LIB_DEPENDENCIES} ws2_32)
ENDIF(Q_WS_WIN)


IF(Q_WS_MAC)
  SET(QT_QTGUI_LIB_DEPENDENCIES ${QT_QTGUI_LIB_DEPENDENCIES} "-framework Carbon")

  # Qt 4.0, 4.1, 4.2 use QuickTime
  IF(QT_VERSION_MINOR LESS 3)
    SET(QT_QTGUI_LIB_DEPENDENCIES ${QT_QTGUI_LIB_DEPENDENCIES} "-framework QuickTime")
  ENDIF(QT_VERSION_MINOR LESS 3)

  # Qt 4.2+ use AppKit
  IF(QT_VERSION_MINOR GREATER 1)
    SET(QT_QTGUI_LIB_DEPENDENCIES ${QT_QTGUI_LIB_DEPENDENCIES} "-framework AppKit")
  ENDIF(QT_VERSION_MINOR GREATER 1)

  SET(QT_QTCORE_LIB_DEPENDENCIES ${QT_QTCORE_LIB_DEPENDENCIES} "-framework ApplicationServices")
ENDIF(Q_WS_MAC)

