dnl
dnl $Id$
dnl

dnl
dnl Configure options
dnl

PHP_ARG_WITH(gd, for GD support,
[  --with-gd[=DIR]           Include GD support.  DIR is the GD library base
                          install directory [BUNDLED]])
if test -z "$PHP_WEBP_DIR"; then
  PHP_ARG_WITH(webp-dir, for the location of libwebp,
  [  --with-webp-dir[=DIR]      GD: Set the path to libwebp install prefix], no, no)
fi

if test -z "$PHP_JPEG_DIR"; then
  PHP_ARG_WITH(jpeg-dir, for the location of libjpeg,
  [  --with-jpeg-dir[=DIR]     GD: Set the path to libjpeg install prefix], no, no)
fi

if test -z "$PHP_PNG_DIR"; then
  PHP_ARG_WITH(png-dir, for the location of libpng,
  [  --with-png-dir[=DIR]      GD: Set the path to libpng install prefix], no, no)
fi

if test -z "$PHP_ZLIB_DIR"; then
  PHP_ARG_WITH(zlib-dir, for the location of libz,
  [  --with-zlib-dir[=DIR]     GD: Set the path to libz install prefix], no, no)
fi

PHP_ARG_WITH(xpm-dir, for the location of libXpm,
[  --with-xpm-dir[=DIR]      GD: Set the path to libXpm install prefix], no, no)

PHP_ARG_WITH(freetype-dir, for FreeType 2,
[  --with-freetype-dir[=DIR] GD: Set the path to FreeType 2 install prefix], no, no)

PHP_ARG_ENABLE(gd-jis-conv, whether to enable JIS-mapped Japanese font support in GD,
[  --enable-gd-jis-conv    GD: Enable JIS-mapped Japanese font support], no, no)

dnl
dnl Checks for the configure options
dnl

AC_DEFUN([PHP_GD_ZLIB],[
	if test "$PHP_ZLIB_DIR" != "no" && test "$PHP_ZLIB_DIR" != "yes"; then
		if test -f "$PHP_ZLIB_DIR/include/zlib/zlib.h"; then
			PHP_ZLIB_DIR="$PHP_ZLIB_DIR"
			PHP_ZLIB_INCDIR="$PHP_ZLIB_DIR/include/zlib"
		elif test -f "$PHP_ZLIB_DIR/include/zlib.h"; then
			PHP_ZLIB_DIR="$PHP_ZLIB_DIR"
			PHP_ZLIB_INCDIR="$PHP_ZLIB_DIR/include"
		else
			AC_MSG_ERROR([Can't find zlib headers under "$PHP_ZLIB_DIR"])
		fi
	else
		for i in /usr/local /usr; do
			if test -f "$i/include/zlib/zlib.h"; then
				PHP_ZLIB_DIR="$i"
				PHP_ZLIB_INCDIR="$i/include/zlib"
			elif test -f "$i/include/zlib.h"; then
				PHP_ZLIB_DIR="$i"
				PHP_ZLIB_INCDIR="$i/include"
			fi
		done
	fi
])

AC_DEFUN([PHP_GD_WEBP],[
  if test "$PHP_WEBP_DIR" != "no"; then

    for i in $PHP_WEBP_DIR /usr/local /usr; do
      test -f $i/include/webp/decode.h && GD_WEBP_DIR=$i && break
    done

    if test -z "$GD_WEBP_DIR"; then
      AC_MSG_ERROR([webp/decode.h not found.])
    fi

    for i in $PHP_WEBP_DIR /usr/local /usr; do
      test -f $i/include/webp/encode.h && GD_WEBP_DIR=$i && break
    done

    if test -z "$GD_WEBP_DIR"; then
      AC_MSG_ERROR([webp/encode.h not found.])
    fi

    PHP_CHECK_LIBRARY(webp,WebPGetInfo,
    [
      PHP_ADD_INCLUDE($GD_WEBP_DIR/include)
      PHP_ADD_LIBRARY(pthread)
      PHP_ADD_LIBRARY_WITH_PATH(webp, $GD_WEBP_DIR/$PHP_LIBDIR, GD_SHARED_LIBADD)
    ],[
      AC_MSG_ERROR([Problem with libwebp.(a|so). Please check config.log for more information.])
    ],[
      -L$GD_WEBP_DIR/$PHP_LIBDIR
    ])
  else
    AC_MSG_RESULT([If configure fails try --with-webp-dir=<DIR>])
  fi
])

AC_DEFUN([PHP_GD_JPEG],[
  if test "$PHP_JPEG_DIR" != "no"; then

    for i in $PHP_JPEG_DIR /usr/local /usr; do
      test -f $i/include/jpeglib.h && GD_JPEG_DIR=$i && break
    done

    if test -z "$GD_JPEG_DIR"; then
      AC_MSG_ERROR([jpeglib.h not found.])
    fi

    PHP_CHECK_LIBRARY(jpeg,jpeg_read_header,
    [
      PHP_ADD_INCLUDE($GD_JPEG_DIR/include)
      PHP_ADD_LIBRARY_WITH_PATH(jpeg, $GD_JPEG_DIR/$PHP_LIBDIR, GD_SHARED_LIBADD)
    ],[
      AC_MSG_ERROR([Problem with libjpeg.(a|so). Please check config.log for more information.])
    ],[
      -L$GD_JPEG_DIR/$PHP_LIBDIR
    ])
  else
    AC_MSG_RESULT([If configure fails try --with-jpeg-dir=<DIR>])
  fi
])

AC_DEFUN([PHP_GD_PNG],[
  if test "$PHP_PNG_DIR" != "no"; then

    for i in $PHP_PNG_DIR /usr/local /usr; do
      test -f $i/include/png.h && GD_PNG_DIR=$i && break
    done

    if test -z "$GD_PNG_DIR"; then
      AC_MSG_ERROR([png.h not found.])
    fi

    if test "$PHP_ZLIB_DIR" = "no"; then
      AC_MSG_ERROR([PNG support requires ZLIB. Use --with-zlib-dir=<DIR>])
    fi

    PHP_CHECK_LIBRARY(png,png_write_image,
    [
      PHP_ADD_INCLUDE($GD_PNG_DIR/include)
      PHP_ADD_LIBRARY_WITH_PATH(z, $PHP_ZLIB_DIR/$PHP_LIBDIR, GD_SHARED_LIBADD)
      PHP_ADD_LIBRARY_WITH_PATH(png, $GD_PNG_DIR/$PHP_LIBDIR, GD_SHARED_LIBADD)
    ],[
      AC_MSG_ERROR([Problem with libpng.(a|so) or libz.(a|so). Please check config.log for more information.])
    ],[
      -L$PHP_ZLIB_DIR/$PHP_LIBDIR -lz -L$GD_PNG_DIR/$PHP_LIBDIR
    ])

  else
    AC_MSG_RESULT([If configure fails try --with-png-dir=<DIR> and --with-zlib-dir=<DIR>])
  fi
])

AC_DEFUN([PHP_GD_XPM],[
  if test "$PHP_XPM_DIR" != "no"; then

    for i in $PHP_XPM_DIR /usr/local /usr/X11R6 /usr; do
      test -f $i/include/xpm.h && GD_XPM_DIR=$i && GD_XPM_INC=$i && break
      test -f $i/include/X11/xpm.h && GD_XPM_DIR=$i && GD_XPM_INC=$i/X11 && break
    done

    if test -z "$GD_XPM_DIR"; then
      AC_MSG_ERROR([xpm.h not found.])
    fi

    PHP_CHECK_LIBRARY(Xpm,XpmFreeXpmImage,
    [
      PHP_ADD_INCLUDE($GD_XPM_INC)
      PHP_ADD_LIBRARY_WITH_PATH(Xpm, $GD_XPM_DIR/$PHP_LIBDIR, GD_SHARED_LIBADD)
      PHP_ADD_LIBRARY_WITH_PATH(X11, $GD_XPM_DIR/$PHP_LIBDIR, GD_SHARED_LIBADD)
    ],[
      AC_MSG_ERROR([Problem with libXpm.(a|so) or libX11.(a|so). Please check config.log for more information.])
    ],[
      -L$GD_XPM_DIR/$PHP_LIBDIR -lX11
    ])
  else
    AC_MSG_RESULT(If configure fails try --with-xpm-dir=<DIR>)
  fi
])

AC_DEFUN([PHP_GD_FREETYPE2],[
  if test "$PHP_FREETYPE_DIR" != "no"; then
      if test -z "$PKG_CONFIG"; then
        AC_PATH_PROG(PKG_CONFIG, pkg-config, no)
      fi
      if test -x "$PKG_CONFIG" && $PKG_CONFIG --exists freetype2 ; then
        FREETYPE2_CFLAGS=`$PKG_CONFIG --cflags freetype2`
        FREETYPE2_LIBS=`$PKG_CONFIG --libs freetype2`
      else
        for i in $PHP_FREETYPE_DIR /usr/local /usr; do
          if test -f "$i/bin/freetype-config"; then
            FREETYPE2_DIR=$i
            FREETYPE2_CONFIG="$i/bin/freetype-config"
            break
          fi
        done

        if test -z "$FREETYPE2_DIR"; then
          AC_MSG_ERROR([freetype-config not found.])
      fi

      FREETYPE2_CFLAGS=`$FREETYPE2_CONFIG --cflags`
      FREETYPE2_LIBS=`$FREETYPE2_CONFIG --libs`

    fi

    PHP_EVAL_INCLINE($FREETYPE2_CFLAGS)
    PHP_EVAL_LIBLINE($FREETYPE2_LIBS, GD_SHARED_LIBADD)
    AC_DEFINE(HAVE_LIBFREETYPE,1,[ ])
    AC_DEFINE(ENABLE_GD_TTF,1,[ ])
  else
    AC_MSG_RESULT([If configure fails try --with-freetype-dir=<DIR>])
  fi
])

AC_DEFUN([PHP_GD_JISX0208],[
  if test "$PHP_GD_JIS_CONV" = "yes"; then
    USE_GD_JIS_CONV=1
  fi
])

AC_DEFUN([PHP_GD_CHECK_VERSION],[
  PHP_CHECK_LIBRARY(gd, gdImageCreateFromPng,   [AC_DEFINE(HAVE_GD_PNG,              1, [ ])], [], [ $GD_SHARED_LIBADD ])
  PHP_CHECK_LIBRARY(gd, gdImageCreateFromWebp,  [AC_DEFINE(HAVE_GD_WEBP,             1, [ ])], [], [ $GD_SHARED_LIBADD ])
  PHP_CHECK_LIBRARY(gd, gdImageCreateFromJpeg,  [AC_DEFINE(HAVE_GD_JPG,              1, [ ])], [], [ $GD_SHARED_LIBADD ])
  PHP_CHECK_LIBRARY(gd, gdImageCreateFromXpm,   [AC_DEFINE(HAVE_GD_XPM,              1, [ ])], [], [ $GD_SHARED_LIBADD ])
  PHP_CHECK_LIBRARY(gd, gdImageCreateFromBmp,   [AC_DEFINE(HAVE_GD_BMP,              1, [ ])], [], [ $GD_SHARED_LIBADD ])
  PHP_CHECK_LIBRARY(gd, gdImageStringFT,        [AC_DEFINE(HAVE_GD_FREETYPE,         1, [ ])], [], [ $GD_SHARED_LIBADD ])
  PHP_CHECK_LIBRARY(gd, gdVersionString,        [AC_DEFINE(HAVE_GD_LIBVERSION,       1, [ ])], [], [ $GD_SHARED_LIBADD ])
])

dnl
dnl Main GD configure
dnl

dnl
dnl Common for both builtin and external GD
dnl
if test "$PHP_GD" != "no"; then

dnl PNG is required by GD library
  test "$PHP_PNG_DIR" = "no" && PHP_PNG_DIR=yes

dnl Various checks for GD features
  PHP_GD_ZLIB
  PHP_GD_WEBP
  PHP_GD_JPEG
  PHP_GD_PNG
  PHP_GD_XPM
  PHP_GD_FREETYPE2
  PHP_GD_JISX0208
fi

if test "$PHP_GD" = "yes"; then
  GD_MODULE_TYPE=builtin
  extra_sources="libgd/gd.c libgd/gd_gd.c libgd/gd_gd2.c libgd/gd_io.c libgd/gd_io_dp.c \
                 libgd/gd_io_file.c libgd/gd_ss.c libgd/gd_io_ss.c libgd/gd_webp.c \
                 libgd/gd_png.c libgd/gd_jpeg.c libgd/gdxpm.c libgd/gdfontt.c libgd/gdfonts.c \
                 libgd/gdfontmb.c libgd/gdfontl.c libgd/gdfontg.c libgd/gdtables.c libgd/gdft.c \
                 libgd/gdcache.c libgd/gdkanji.c libgd/wbmp.c libgd/gd_wbmp.c libgd/gdhelpers.c \
                 libgd/gd_topal.c libgd/gd_gif_in.c libgd/gd_xbm.c libgd/gd_gif_out.c libgd/gd_security.c \
                 libgd/gd_filter.c libgd/gd_pixelate.c libgd/gd_rotate.c libgd/gd_color_match.c \
                 libgd/gd_transform.c libgd/gd_crop.c libgd/gd_interpolation.c libgd/gd_matrix.c \
                 libgd/gd_bmp.c"

dnl check for fabsf and floorf which are available since C99
  AC_CHECK_FUNCS(fabsf floorf)

dnl These are always available with bundled library
  AC_DEFINE(HAVE_GD_BUNDLED,          1, [ ])
  AC_DEFINE(HAVE_GD_PNG,              1, [ ])
  AC_DEFINE(HAVE_GD_BMP,              1, [ ])
  AC_DEFINE(HAVE_GD_CACHE_CREATE,     1, [ ])

dnl Make sure the libgd/ is first in the include path
  GDLIB_CFLAGS="-DHAVE_LIBPNG"

dnl Depending which libraries were included to PHP configure,
dnl enable the support in bundled GD library

  if test -n "$GD_WEBP_DIR"; then
    AC_DEFINE(HAVE_GD_WEBP, 1, [ ])
    GDLIB_CFLAGS="$GDLIB_CFLAGS -DHAVE_LIBWEBP"
  fi

  if test -n "$GD_JPEG_DIR"; then
    AC_DEFINE(HAVE_GD_JPG, 1, [ ])
    GDLIB_CFLAGS="$GDLIB_CFLAGS -DHAVE_LIBJPEG"
  fi

  if test -n "$GD_XPM_DIR"; then
    AC_DEFINE(HAVE_GD_XPM, 1, [ ])
    GDLIB_CFLAGS="$GDLIB_CFLAGS -DHAVE_XPM"
  fi

  if test -n "$FREETYPE2_DIR"; then
    AC_DEFINE(HAVE_GD_FREETYPE,   1, [ ])
    AC_DEFINE(ENABLE_GD_TTF, 1, [ ])
    GDLIB_CFLAGS="$GDLIB_CFLAGS -DHAVE_LIBFREETYPE -DENABLE_GD_TTF"
  fi

  if test -n "$USE_GD_JIS_CONV"; then
    AC_DEFINE(USE_GD_JISX0208, 1, [ ])
    GDLIB_CFLAGS="$GDLIB_CFLAGS -DJISX0208"
  fi

else

 if test "$PHP_GD" != "no"; then
  GD_MODULE_TYPE=external
  extra_sources="gd_compat.c"

dnl Various checks for GD features
  PHP_GD_ZLIB
  PHP_GD_WEBP
  PHP_GD_JPEG
  PHP_GD_PNG
  PHP_GD_XPM
  PHP_GD_FREETYPE2

dnl Header path
  for i in include/gd include/gd2 include gd ""; do
    test -f "$PHP_GD/$i/gd.h" && GD_INCLUDE="$PHP_GD/$i"
  done

  if test -z "$GD_INCLUDE"; then
    AC_MSG_ERROR([Unable to find gd.h anywhere under $PHP_GD])
  fi

dnl Library path

  PHP_CHECK_LIBRARY(gd, gdSetErrorMethod,
  [
    PHP_ADD_LIBRARY_WITH_PATH(gd, $PHP_GD/$PHP_LIBDIR, GD_SHARED_LIBADD)
    AC_DEFINE(HAVE_LIBGD, 1, [ ])
  ],[
    AC_MSG_ERROR([Unable to find libgd.(a|so) >= 2.1.0 anywhere under $PHP_GD])
  ],[
    -L$PHP_GD/$PHP_LIBDIR
  ])
  PHP_GD_CHECK_VERSION

  PHP_EXPAND_PATH($GD_INCLUDE, GD_INCLUDE)
 fi
fi

dnl
dnl Common for both builtin and external GD
dnl
if test "$PHP_GD" != "no"; then
  PHP_NEW_EXTENSION(gd, gd.c $extra_sources, $ext_shared,, \\$(GDLIB_CFLAGS))

  if test "$GD_MODULE_TYPE" = "builtin"; then
    PHP_ADD_BUILD_DIR($ext_builddir/libgd)
    GDLIB_CFLAGS="-I$ext_srcdir/libgd $GDLIB_CFLAGS"
    GD_HEADER_DIRS="ext/gd/ ext/gd/libgd/"

    PHP_TEST_BUILD(foobar, [], [
      AC_MSG_ERROR([GD build test failed. Please check the config.log for details.])
    ], [ $GD_SHARED_LIBADD ], [char foobar () {}])
  else
    GD_HEADER_DIRS="ext/gd/"
    GDLIB_CFLAGS="-I$GD_INCLUDE $GDLIB_CFLAGS"
    PHP_ADD_INCLUDE($GD_INCLUDE)
    PHP_CHECK_LIBRARY(gd, gdImageCreate, [], [
      AC_MSG_ERROR([GD build test failed. Please check the config.log for details.])
    ], [ $GD_SHARED_LIBADD ])
  fi

  PHP_INSTALL_HEADERS([$GD_HEADER_DIRS])
  PHP_SUBST(GDLIB_CFLAGS)
  PHP_SUBST(GD_SHARED_LIBADD)
fi
