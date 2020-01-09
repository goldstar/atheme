dnl SPDX-License-Identifier: ISC
dnl SPDX-URL: https://spdx.org/licenses/ISC.html
dnl
dnl Copyright (C) 2005-2009 Atheme Project (http://atheme.org/)
dnl Copyright (C) 2018-2019 Atheme Development Group (https://atheme.github.io/)
dnl
dnl -*- Atheme IRC Services -*-
dnl Atheme Build System Component

AC_DEFUN([ATHEME_FEATURETEST_DEBUGGING], [

    DEBUGGING="No"

    AC_ARG_ENABLE([debugging],
        [AS_HELP_STRING([--enable-debugging], [Enable extensive debugging support])],
        [], [enable_debugging="no"])

    case "x${enable_debugging}" in
        xyes)
            ATHEME_CC_TEST_CFLAGS([-O0 -g])
            AS_IF([test "${ATHEME_CC_TEST_CFLAGS_RESULT}" = "no"], [
                AC_MSG_ERROR([--enable-debugging requires compiler support for -O0 -g])
            ])
            DEBUGGING="Yes"
            AC_DEFINE([ATHEME_ENABLE_DEBUGGING], [1], [Define to 1 if --enable-debugging was given to ./configure])
            ;;
        xno)
            AS_IF([test "${CFLAGS_WAS_SET}" = "no"], [
                ATHEME_CC_TEST_CFLAGS([-O2])
                ATHEME_CC_TEST_CFLAGS([-g])
            ])
            DEBUGGING="No"
            ;;
        *)
            AC_MSG_ERROR([invalid option for --enable-debugging])
            ;;
    esac
])
