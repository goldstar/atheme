dnl SPDX-License-Identifier: ISC
dnl SPDX-URL: https://spdx.org/licenses/ISC.html
dnl
dnl Copyright (C) 2005-2009 Atheme Project (http://atheme.org/)
dnl Copyright (C) 2018-2019 Aaron Jones <aaronmdjones@gmail.com>
dnl
dnl -*- Atheme IRC Services -*-
dnl Atheme Build System Component

AC_DEFUN([ATHEME_FEATURETEST_HEAP_ALLOCATOR], [

    HEAP_ALLOCATOR="Yes"

    AC_ARG_ENABLE([heap-allocator],
        [AS_HELP_STRING([--disable-heap-allocator], [Disable the heap allocator])],
        [], [enable_heap_allocator="yes"])

    case "x${enable_heap_allocator}" in
        xyes)
            HEAP_ALLOCATOR="Yes"
            AC_DEFINE([ATHEME_ENABLE_HEAP_ALLOCATOR], [1], [Define to 1 if --disable-heap-allocator was NOT given to ./configure])
            ;;
        xno)
            HEAP_ALLOCATOR="No"
            ;;
        *)
            AC_MSG_ERROR([invalid option for --enable-heap-allocator])
            ;;
    esac
])
