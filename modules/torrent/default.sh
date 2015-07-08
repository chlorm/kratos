# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

#
# Algorithm borrowed from http://wiki.rtorrent.org/MagnetUri and adapted to work with zsh.
#

function magnet_to_torrent {

  [[ "$1" =~ xt=urn:btih:([^\&/]+) ]] || return 1

  hashh=${match[1]}

  if [[ "$1" =~ dn=([^\&/]+) ]];then
    filename=${match[1]}
  else
    filename=$hashh
  fi

  echo "d10:magnet-uri${#1}:${1}e" > "$filename.torrent"

}
