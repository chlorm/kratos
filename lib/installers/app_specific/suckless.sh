# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_suckless_installed() {

  path_hasbin "st" > /dev/null || return 1

  return 0

}

app_suckless_cleanup() {

  return 0

}

app_suckless_configure() {

  app_suckless_installed || return 2
  app_nixpkgs || return 1

  pushd "$DOTFILES_DIR/dotfiles/nixpkgs/st/"
  if [ HIGH_DPI = true ] ; then
    symlink "config.highdpi.h" "config.mach.h"
  else
    symlink "config.other.h" "config.mach.h"
  fi
  popd

  echo "  ✓ suckless"

  return 0

}
