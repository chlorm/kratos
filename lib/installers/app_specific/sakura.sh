# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_sakura_installed() {

  path_hasbin "sakura" > /dev/null || return 1

  return 0

}

app_sakura_dirs() {

  exist -dc "$XDG_CONFIG_HOME/sakura" || return 1

  return 0

}

app_sakura_dotfiles() {
 
  dotfile_ln "config/sakura" || return 1

}

app_sakura_cleanup() {

  exist -dx "$XDG_CONFIG_HOME/sakura"

}

app_sakura_configure() {

  app_sakura_installed || return 2

  app_sakura_dirs || return 1

  app_sakura_dotfiles || return 1

  return 0

}
