# This file is part of Kratos.
# Copyright (c) 2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# When completing from the middle of a word,
# move the cursor to the end of the word.
setopt always_to_end
# show completion menu on successive tab press.
# needs unsetop menu_complete to work
setopt auto_menu
# any parameter that is set to the absolute name of a
# directory immediately becomes a name for that directory
setopt auto_name_dirs
# Allow completion from within a word/phrase
setopt complete_in_word
# do not autoselect the first completion entry
unsetopt menu_complete

autoload -U compinit
compinit

# Only show menu if 2 or more results exist.
zstyle ':completion:*' menu select=2
# Reload all completions incase there are changes
zstyle ':completion:*' rehash true
