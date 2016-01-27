# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Support for colored manpages and maybe setting the system pager

# TODO: make pager configurable (more/most/less)
export MANPAGER='less'
export PAGER='less'

# Less
export LESS='--RAW-CONTROL-CHARS'
export LESSCHARSET='utf-8'
#LESSANSIENDCHARS
#LESSANSIMIDCHARS
#LESSBINFMT
#LESSCHARDEF
#LESSCHARSET
#LESSCLOSE
#LESSECHO
#LESSEDIT
#LESSGLOBALTAGS
#LESSHISTFILE
#LESSKEY
#LESSKEY_SYSTEM
#LESSMETACHARS
#LESSMETAESCAPE
#LESSOPEN
#LESSSECURE
#LESSSEPARATOR
#LESSUTFBINFMT
export LESS_IS_MORE= # disabled

# Less colors
# TODO: use native kratos implementation, not tput
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)
