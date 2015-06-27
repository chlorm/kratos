# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Application specific configuration

echo "Configurating applications"
for APP in `find $DOTFILES_DIR/lib/installers/app_specific/ -type f` ; do
  APP="$(basename $APP | sed -e 's/\.sh//')"
  if eval app_${APP}_configure ; then
    echo "  ☑ $APP"
  else
    case "$?" in
      '2')
        echo "  ☐ $APP"
        ;;
      '1')
        echo "  ☒ $APP"
        ;;
      *)
        echo "ERROR: invalid return code from app configure"
        exit 1
        ;;
    esac
    eval app_${APP}_cleanup
    continue
  fi
done

unset APP
