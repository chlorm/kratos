# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

function gitignore { Download::Http "https://www.gitignore.io/api/$1" ; }

#_gitignoreio_get_command_list() {
#  download "https://www.gitignore.io/api/list" | tr "," "\n"
#}

#_gitignoreio () {
#  compset -P '*,'
#  compadd -S '' `_gitignoreio_get_command_list`
#}

#compdef _gitignoreio gi
