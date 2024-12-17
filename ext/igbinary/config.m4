dnl config.m4 for extension igbinary

dnl Comments in this file start with the string 'dnl'.
dnl Remove where necessary. This file will not work
dnl without editing.

dnl If your extension references something external, use with:

dnl PHP_ARG_WITH(igbinary, for igbinary support,
dnl Make sure that the comment is aligned:
dnl [  --with-igbinary             Include igbinary support])

dnl Otherwise use enable:

PHP_ARG_ENABLE(igbinary, whether to enable igbinary support,
  [  --enable-igbinary          Enable igbinary support])

if test "$PHP_IGBINARY" != "no"; then
  AC_CHECK_HEADERS([stdbool.h],, AC_MSG_ERROR([stdbool.h not exists]))
  AC_CHECK_HEADERS([stddef.h],, AC_MSG_ERROR([stddef.h not exists]))
  AC_CHECK_HEADERS([stdint.h],, AC_MSG_ERROR([stdint.h not exists]))

  AC_MSG_CHECKING(PHP version)

  PHP_IGBINARY_SRC_FILES="src/php7/igbinary.c src/php7/hash_si.c src/php7/hash_si_ptr.c"
  if test -n "$phpincludedir" -a -d "$phpincludedir"; then
    IGBINARY_PHPINCLUDEDIR=$phpincludedir
  else
    IGBINARY_PHPINCLUDEDIR=$abs_srcdir
  fi
  AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
  #include <$IGBINARY_PHPINCLUDEDIR/main/php_version.h>
  ]], [[
#if PHP_MAJOR_VERSION < 7
#error PHP < 7
#endif
  ]])],[
  AC_MSG_RESULT([PHP 7 or newer])
  ],[
  AC_MSG_ERROR([PHP 5 is not supported by igbinary 3. Use igbinary 2 instead for PHP5 support.])
  ])

  AC_MSG_CHECKING([for APCu includes])
  if test -f "$IGBINARY_PHPINCLUDEDIR/ext/apcu/apc_serializer.h"; then
    apc_inc_path="$IGBINARY_PHPINCLUDEDIR"
    AC_MSG_RESULT([APCu in $apc_inc_path])
    AC_DEFINE(HAVE_APCU_SUPPORT,1,[Whether to enable APCu support])
  else
    AC_MSG_RESULT([not found])
  fi

  AC_CHECK_SIZEOF([long])

  dnl GCC
  AC_MSG_CHECKING(compiler type)
  if test ! -z "`$CC --version | grep -i CLANG`"; then
    AC_MSG_RESULT(clang)
    if test -z "`echo $CFLAGS | grep -- -O0`"; then
      PHP_IGBINARY_CFLAGS="$CFLAGS -Wall -O2"
    fi
  elif test "$GCC" = yes; then
    AC_MSG_RESULT(gcc)
    if test -z "`echo $CFLAGS | grep -- '-O[0123]'`"; then
      PHP_IGBINARY_CFLAGS="$CFLAGS -O2 -Wall -Wpointer-arith -Wcast-align -Wwrite-strings -Wswitch"
    fi
  elif test "$ICC" = yes; then
    AC_MSG_RESULT(icc)
    if test -z "`echo $CFLAGS | grep -- -O0`"; then
      PHP_IGBINARY_CFLAGS="$CFLAGS -no-prec-div -O3 -x0 -unroll2"
    fi
  else
    AC_MSG_RESULT(other)
  fi

  PHP_ADD_MAKEFILE_FRAGMENT(Makefile.bench)
  PHP_INSTALL_HEADERS([ext/igbinary], [igbinary.h src/php7/igbinary.h php_igbinary.h src/php7/php_igbinary.h])
  PHP_NEW_EXTENSION(igbinary, $PHP_IGBINARY_SRC_FILES, $ext_shared,, $PHP_IGBINARY_CFLAGS)
  PHP_ADD_EXTENSION_DEP(igbinary, session, true)
  AC_DEFINE(HAVE_IGBINARY, 1, [Have igbinary support])
  PHP_ADD_BUILD_DIR($abs_builddir/src/php7, 1)
  PHP_SUBST(IGBINARY_SHARED_LIBADD)
fi
