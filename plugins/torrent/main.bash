# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

#
# Algorithm borrowed from http://wiki.rtorrent.org/MagnetUri and adapted to work with zsh.
#

Torrent::Magnet2Torrent() {
  local InfoHash
  local Filename

  Var::Type.string "${@}"

  if [[ "${1}" =~ xt=urn:btih:([^\&/]+) ]] ; then
    InfoHash="${match[1]}"
  else
    Debug::Message 'error' 'no info hash found'
    return 1
  fi

  if [[ "${1}" =~ dn=([^\&/]+) ]] ; then
    Filename="${match[1]}"
  else
    Filename="${InfoHash}"
  fi

  echo "d10:magnet-uri${#1}:${1}e" > "${Filename}.torrent"
}
