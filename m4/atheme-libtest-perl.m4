dnl SPDX-License-Identifier: ISC
dnl SPDX-URL: https://spdx.org/licenses/ISC.html
dnl
dnl Copyright (C) 2005-2009 Atheme Project (http://atheme.org/)
dnl Copyright (C) 2018-2019 Atheme Development Group (https://atheme.github.io/)
dnl
dnl -*- Atheme IRC Services -*-
dnl Atheme Build System Component

AC_DEFUN([ATHEME_LIBTEST_PERL], [

    LIBPERL="No"
    LIBPERL_CFLAGS=""
    LIBPERL_LIBS=""

    AC_ARG_WITH([perl],
            [AS_HELP_STRING([--with-perl], [Enable Perl (for modules/scripting/perl)])],
            [], [with_perl="no"])

    case "x${with_perl}" in
        xno | xyes | xauto)
            ;;
        *)
            AC_MSG_ERROR([invalid option for --with-perl])
            ;;
    esac

    AS_IF([test "${with_perl}" != "no"], [

        AC_PATH_PROG([perlpath], [perl])

        if test -n "${perlpath}"
        then
            LIBPERL="Yes"
            LIBPERL_CFLAGS="$(perl -MExtUtils::Embed -e ccopts)"
            LIBPERL_LIBS="$(perl -MExtUtils::Embed -e ldopts)"

            dnl if Perl is built with threading support, we need to link atheme against libpthread
            AS_IF([echo "${LIBPERL_LIBS}" | grep -q pthread], [
                LIBS="-lpthread ${LIBS}"
            ])

            AS_IF([test "${with_perl}${LIBPERL_CFLAGS}" = "yes"], [
                AC_MSG_ERROR([--with-perl was given but Perl could not be found])
            ])

            ATHEME_COND_PERL_ENABLE
        else
            LIBPERL="No"
            AS_IF([test "${with_perl}" = "yes"], [
                AC_MSG_ERROR([--with-perl was given but Perl could not be found])
            ])
        fi
    ], [
        LIBPERL="No"
    ])

    AC_SUBST([LIBPERL_CFLAGS])
    AC_SUBST([LIBPERL_LIBS])
])
