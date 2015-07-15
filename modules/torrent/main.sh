# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

#
# Algorithm borrowed from http://wiki.rtorrent.org/MagnetUri and adapted to work with zsh.
#

function magnet2torrent {

  local URI
  local filename

  function MatchArray {

    if [[ "$(shell)" == 'bash' ]] ; then
      echo "${BASH_REMATCH[1]}"
    elif [[ "$(shell)" == 'zsh' ]] ; then
      echo "${match[1]}"
    fi

  }

  [[ -n $@ ]] || {
    ErrError 'no input'
    return 1
  }

  # TODO: fix zsh parse error near &
  if [[ "${1}" =~ xt=urn:btih:([^\&/]+) ]] ; then
    URI="$(MatchArray)"
  else
    ErrError 'no URI found'
    return 1
  fi

  # TODO: Fix the filename regex
  if [[ "${1}" =~ dn=([^\&/]+) ]] ; then
    filename="$(MatchArray)"
  else
    filename="${URI}"
  fi

  echo "d10:magnet-uri${#1}:${1}e" > "${filename}.torrent"

}
