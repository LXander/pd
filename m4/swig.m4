##### http://autoconf-archive.cryp.to/ac_pkg_swig.html
#
# SYNOPSIS
#
#   AC_PROG_SWIG_MOD([major.minor.micro])
#
# DESCRIPTION
#
#   This macro searches for a SWIG installation on your system. If
#   found you should call SWIG via $(SWIG). You can use the optional
#   first argument to check if the version of the available SWIG is
#   greater than or equal to the value of the argument. It should have
#   the format: N[.N[.N]] (N is a number between 0 and 999. Only the
#   first N is mandatory.)
#
#   If the version argument is given (e.g. 1.3.17), AC_PROG_SWIG_MOD checks
#   that the swig package is this version number or higher.
#
#   In configure.in, use as:
#
#     AC_PROG_SWIG_MOD(1.3.17)
#     SWIG_ENABLE_CXX
#     SWIG_MULTI_MODULE_SUPPORT
#     SWIG_PYTHON_MOD
#
# LAST MODIFICATION
#
#   2006-10-22
#
# COPYLEFT
#
#   Copyright (c) 2006 Sebastian Huber <sebastian-huber@web.de>
#   Copyright (c) 2006 Alan W. Irwin <irwin@beluga.phys.uvic.ca>
#   Copyright (c) 2006 Rafael Laboissiere <rafael@laboissiere.net>
#   Copyright (c) 2006 Andrew Collier <colliera@ukzn.ac.za>
#
#   This program is free software; you can redistribute it and/or
#   modify it under the terms of the GNU General Public License as
#   published by the Free Software Foundation; either version 2 of the
#   License, or (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful, but
#   WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#   General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
#   02111-1307, USA.
#
#   As a special exception, the respective Autoconf Macro's copyright
#   owner gives unlimited permission to copy, distribute and modify the
#   configure scripts that are the output of Autoconf when processing
#   the Macro. You need not follow the terms of the GNU General Public
#   License when using or distributing such scripts, even though
#   portions of the text of the Macro appear in them. The GNU General
#   Public License (GPL) does govern all other use of the material that
#   constitutes the Autoconf Macro.
#
#   This special exception to the GPL applies to versions of the
#   Autoconf Macro released by the Autoconf Macro Archive. When you
#   make and distribute a modified version of the Autoconf Macro, you
#   may extend this special exception to the GPL to apply to your
#   modified version as well.


#   Modified by Mike Tyka 23/07/07 to modify the behaviour when swig is missing.
#   a) print an error message to indicate that SWIG is not absolute required, but
#      without it one cannot modify the C++ code and get these changes appear in Python.
#      Using a 'static' pd_wrap.cxx will have undefined behaviour. 
#   b) This option is not avalable if this is a SVN checkout - only packaged ones
#      have a pregenerated pd.py and pd_wrap.cxx (the same goes for all the satelite modules)
#   c) set a variable indicating the state of this

AC_DEFUN([AC_PROG_SWIG_MOD],[
        GENERATE_WRAPPERS="yes"								
        AC_PATH_PROG([SWIG],[swig])
        if test -z "$SWIG" ; then
                AC_MSG_WARN([cannot find 'swig' program. You should look at http://www.swig.org])
                SWIG='echo "Error: SWIG is not installed. You should look at http://www.swig.org" ; false'
                GENERATE_WRAPPERS="no"								
        elif test -n "$1" ; then
                AC_MSG_CHECKING([for SWIG version])
                [swig_version=`$SWIG -version 2>&1 | grep 'SWIG Version' | sed 's/.*\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\).*/\1/g'`]
                AC_MSG_RESULT([$swig_version])
                if test -n "$swig_version" ; then
                        # Calculate the required version number components
                        [required=$1]
                        [required_major=`echo $required | sed 's/[^0-9].*//'`]
                        if test -z "$required_major" ; then
                                [required_major=0]
                        fi
                        [required=`echo $required | sed 's/[0-9]*[^0-9]//'`]
                        [required_minor=`echo $required | sed 's/[^0-9].*//'`]
                        if test -z "$required_minor" ; then
                                [required_minor=0]
                        fi
                        [required=`echo $required | sed 's/[0-9]*[^0-9]//'`]
                        [required_patch=`echo $required | sed 's/[^0-9].*//'`]
                        if test -z "$required_patch" ; then
                                [required_patch=0]
                        fi
                        # Calculate the available version number components
                        [available=$swig_version]
                        [available_major=`echo $available | sed 's/[^0-9].*//'`]
                        if test -z "$available_major" ; then
                                [available_major=0]
                        fi
                        [available=`echo $available | sed 's/[0-9]*[^0-9]//'`]
                        [available_minor=`echo $available | sed 's/[^0-9].*//'`]
                        if test -z "$available_minor" ; then
                                [available_minor=0]
                        fi
                        [available=`echo $available | sed 's/[0-9]*[^0-9]//'`]
                        [available_patch=`echo $available | sed 's/[^0-9].*//'`]
                        if test -z "$available_patch" ; then
                                [available_patch=0]
                        fi
                        if test $available_major -ne $required_major \
                                -o $available_minor -ne $required_minor \
                                -o $available_patch -lt $required_patch ; then
                                AC_MSG_WARN([SWIG version >= $1 is required.  You have $swig_version.  You should look at http://www.swig.org])
                                SWIG='echo "Error: SWIG version >= $1 is required.  You have '"$swig_version"'.  You should look at http://www.swig.org" ; false'
                                GENERATE_WRAPPERS="no"								
                        else
                                AC_MSG_NOTICE([SWIG executable is '$SWIG'])
                                SWIG_LIB=`$SWIG -swiglib`
                                AC_MSG_NOTICE([SWIG library directory is '$SWIG_LIB'])
                        fi
                else
                        AC_MSG_WARN([cannot determine SWIG version])
                        SWIG='echo "Error: Cannot determine SWIG version.  You should look at http://www.swig.org" ; false'
                        GENERATE_WRAPPERS="no"								
                fi
        fi
        AC_SUBST([SWIG_LIB])


				if test "x$GENERATE_WRAPPERS" != "xyes"; then
					AC_MSG_NOTICE([******************************** ERROR ************************************])
					AC_MSG_NOTICE([The program SWIG version >= $1 is required for the generation of the ])
					AC_MSG_NOTICE([Python interface of the PD library and its modules. SWIG is available ])
					AC_MSG_NOTICE([free of charge from http://www.swig.org ])
					AC_MSG_NOTICE([  ])
					AC_MSG_NOTICE([You can still compile PD and the modules using the supplied, pregenerated])
					AC_MSG_NOTICE([Python interface (available **only** in the Release packages, not from])
					AC_MSG_NOTICE([current SVN) by calling configure with the command line option ])
					AC_MSG_NOTICE(["--without-swig":])
					AC_MSG_NOTICE([])
					AC_MSG_NOTICE([  ./configure  --without-swig ])
					AC_MSG_NOTICE([])
					AC_MSG_NOTICE([***************************************************************************])
					AC_MSG_ERROR([SWIG $1 or newer required. See above notice.])
				fi
])

# SWIG_ENABLE_CXX()
#
# Enable SWIG C++ support.  This effects all invocations of $(SWIG).
AC_DEFUN([SWIG_ENABLE_CXX_MOD],[
	AC_REQUIRE([AC_PROG_SWIG_MOD])
	AC_REQUIRE([AC_PROG_CXX])
	SWIG="$SWIG -c++"
])

# SWIG_PYTHON_MOD([use-shadow-classes = {no, yes}])
#
# Checks for Python and provides the $(SWIG_PYTHON_CPPFLAGS),
# $(SWIG_PYTHON_LIBS) and $(SWIG_PYTHON_OPT) output variables.
# $(SWIG_PYTHON_OPT) contains all necessary SWIG options to generate
# code for Python.  Shadow classes are enabled unless the value of the
# optional first argument is exactly 'no'.  If you need multi module
# support (provided by the SWIG_MULTI_MODULE_SUPPORT() macro) use
# $(SWIG_PYTHON_LIBS) to link against the appropriate library.  It
# contains the SWIG Python runtime library that is needed by the type
# check system for example.
AC_DEFUN([SWIG_PYTHON_MOD],[
	AC_REQUIRE([AC_PROG_SWIG_MOD])
	AC_REQUIRE([PYTHON_DEVEL_MOD])
	test "x$1" != "xno" || swig_shadow=" -noproxy"
	AC_SUBST([SWIG_PYTHON_OPT],[-python$swig_shadow])
	AC_SUBST([SWIG_PYTHON_CPPFLAGS],[$PYTHON_CPPFLAGS])
	AC_SUBST([SWIG_PYTHON_LIBS],["$SWIG_RUNTIME_LIBS_DIR -lswigpy"])
])

# PYTHON_DEVEL_MOD()
#
# Checks for Python and tries to get the include path to 'Python.h'.
# It provides the $(PYTHON_CPPFLAGS) and $(PYTHON_LDFLAGS) output variable.
AC_DEFUN([PYTHON_DEVEL_MOD],[
	AC_REQUIRE([AM_PATH_PYTHON])

	# Check for Python include path
	AC_MSG_CHECKING([for Python include path])
	python_path=${PYTHON%/bin*}
	for i in "$python_path/include/python$PYTHON_VERSION/" "$python_path/include/python/" "$python_path/" ; do
		python_path=`find $i -type f -name Python.h -print`
		if test -n "$python_path" ; then
			break
		fi
	done
	for i in $python_path ; do
		python_path=${python_path%/Python.h}
		break
	done
	AC_MSG_RESULT([$python_path])
	if test -z "$python_path" ; then
		AC_MSG_ERROR([cannot find Python include path])
	fi
	AC_SUBST([PYTHON_CPPFLAGS],[-I$python_path])


## disabled - we dont need those
##	# Check for Python library path
##	AC_MSG_CHECKING([for Python library path])
##	python_path=${PYTHON%/bin*}
##	for i in "$python_path/lib/python$PYTHON_VERSION/config/" "$python_path/lib/python$PYTHON_VERSION/" "$python_path/lib/python/config/" "$python_path/lib/python/" "$python_path/" ; do
##		python_path=`find $i -type f -name libpython$PYTHON_VERSION.* -print`
##		if test -n "$python_path" ; then
##			break
##		fi
##	done
##	for i in $python_path ; do
##		python_path=${python_path%/libpython*}
##		break
##	done
##	AC_MSG_RESULT([$python_path])
##	if test -z "$python_path" ; then
##		AC_MSG_ERROR([cannot find Python library path])
##	fi
##	AC_SUBST([PYTHON_LDFLAGS],["-L$python_path -lpython$PYTHON_VERSION"])
])
