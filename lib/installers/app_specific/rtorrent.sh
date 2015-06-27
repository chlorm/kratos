# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_rtorrent_installed() {

  path_hasbin "rtorrent" > /dev/null || return 1

  return 0

}

app_rtorrent_dirs() {

  exist -dc "$HOME/Torrents/Complete" "$HOME/Torrents/Incomplete" \
            "$HOME/Torrents/Watch" "$HOME/.local/share/rtorrent" || return 1

  return 0

}

app_rtorrent_dotfiles() {

  exist -fx "$HOME/.rtorrent.rc"

(
cat <<RTORRENTRC
# $DOTFILES_AUTOGEN_WARN

## rTorrent Configuration File
## Assumed Directory & File Structure:
##   $HOME/Torrents/Complete/ ----- Torrents are moved here when complete
##   $HOME/Torrents/Incomplete/ --- Temporaray location for torrents while downloading
##   $HOME/Torrents/Watch/ -------- The 'autoload' directory for rtorrent to use
##   $HOME/.local/share/rtorrent/ - For storing rtorrent session information

#
# Directories
#
directory.default.set = $HOME/Torrents/Incomplete/
method.set_key = event.download.finished,move_complete,"d.directory.set=$HOME/Torrents/Complete;execute2=mv,-u,\$d.base_path=,$HOME/Torrents/Complete"
session.path.set = $HOME/.local/share/rtorrent
schedule2 = watch.directory.added,5,5,load.start=$HOME/Torrents/Watch/*.torrent
#
# Re-hash complete torrents
#
pieces.hash.on_completion.set = yes
#
# Throttle
#
throttle.min_peers.normal.set = 40
throttle.max_peers.normal.set = 100
throttle.min_peers.seed.set = -1
throttle.max_peers.seed.set = -1
throttle.max_uploads.set = 50
throttle.global_down.max_rate.set_kb = 0
throttle.global_up.max_rate.set_kb = 0
#
# Network
#
#network.local_address.set = 127.0.0.1
#network.local_address.set = example.com
#network.bind_address.set = 127.0.0.1
#network.bind_address.set = rakshasa.no
network.port_range.set = 6890-6999
port_random = yes
#
# XML-RPC
#
scgi_port = 127.0.0.1:5000
#
# Trackers
#
trackers.use_udp.set = no
#
# Encryption
#
protocol.encryption.set = require,require_RC4,allow_incoming,try_outgoing,enable_retry
#
# DHT
#
#dht.mode.set = enable
#dht.port.set = 6881
#
# Peer exchange
#
#protocol.pex.set = yes
#
# Custom Colors
#
color_bg_active = 8
color_fg_active = 10
color_bg_complete = 8
color_fg_complete = 14
color_bg_inactive = 8
color_fg_inactive = 9
color_bg_dead = 8
color_fg_dead = 11

RTORRENTRC
) > "$HOME/.rtorrent.rc" || return 1

  return 0

}

app_rtorrent_cleanup() {

  # add test for contents on Torrents/ before removing

  exist -dx "$XDG_DATA_HOME/rtorrent"

}

app_rtorrent_configure() {

  app_rtorrent_installed || return 2

  app_rtorrent_dirs || return 1

  app_rtorrent_dotfiles || return 1

  return 0

}
