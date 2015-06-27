# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_mpd_installed() {

  path_hasbin "mpd" > /dev/null || return 1

  return 0

}

app_mpd_dirs() {

  exist -dc "$HOME/.config/mpd/playlists" || return 1

  return 0

}

app_mpd_dotfiles() {

  exist -fx "$HOME/.config/mpd/mpd.conf"

(
cat <<MPDDOTFILE
# This file was auto generated by config, do not edit locally

##       ________   ___       ___
##      /  _____/  /  /      /  /
##     /  /       /  /      /  /
##    /  /       /  /____  /  / _______  _______  ____  ____
##   /  /       /  ___  / /  / /  __  / /  ____/ /    \\/    \\
##  /  /_____  /  /  / / /  / /  /_/ / /  /     /  /\\    /\  \\
## /________/ /__/  /_/ /__/ /______/ /__/     /__/  \\__/  \__\\ TM
##
## Title: MPD Configuration File
## Author: Cody Opel
## E-mail: codyopel(at)gmail.com
## Copyright (c) 2014 All Rights Reserved, http://www.chlorm.net
## License: The MIT License - http://opensource.org/licenses/MIT
## Assumed Directory & File Structure:
##   $XDG_CONFIG_HOME/mpd/ ----------- MPD directory
##   $XDG_CONFIG_HOME/mpd/playlists/ - MPD playlists directory
##   $XDG_CONFIG_HOME/mpd/mpd.conf --- MPD config file
##   $XDG_CONFIG_HOME/mpd/database --- MPD database file
##   $XDG_CONFIG_HOME/mpd/log -------- MPD log file
##   $XDG_CONFIG_HOME/mpd/state ------ MPD state file
##   $HOME/.tmp/mpd.pid ----------- MPD pid file
##   $HOME/.tmp/mpd.fifo ---------- MPD FIFO output file

# Directories and files
filesystem_charset "UTF-8"
music_directory    "$XDG_MUSIC_DIR"
playlist_directory "$XDG_CONFIG_HOME/mpd/playlists"
db_file            "$XDG_CONFIG_HOME/mpd/database"
log_file           "$XDG_CONFIG_HOME/mpd/log"
pid_file           "$HOME/.tmp/mpd.pid"
state_file         "$XDG_CONFIG_HOME/mpd/state"

# Network
#bind_to_address "localhost"
#port "6600"
#zeroconf_enabled "yes"
#zeroconf_name "MPD Music Player"

restore_paused "yes"
#metadata_to_use "artist,album,title,track,name,genre,date,composer,performer,disc"
#auto_update_depth "yes"
#auto_update_depth "3"

input {
    plugin "curl"
}

# Audio Outputs
audio_output {
    type           "alsa"
    name           "MPD ALSA Output"
    device         "hw:0,0"
    format         "44100:16:2"
    mixer_type     "hardware"
    mixer_device   "default"
    mixer_control  "PCM"
    mixer_index    "0"
}
audio_output {
    type           "fifo"
    name           "MPD FIFO Output"
    path           "$HOME/.tmp/mpd.fifo"
    format         "192000:24:2"
}
audio_output {
    type           "pulse"
    name           "MPD Pulse Output"
}

MPDDOTFILE
) > "$HOME/.config/mpd/mpd.conf" || return 1

  return 0

}

app_mpd_files() {

  exist -fc "$HOME/.config/mpd/database" "$HOME/.config/mpd/state" \
            "$HOME/.config/mpd/sticker.sql" "$HOME/.config/mpd/log" || return 1

  return 0

}

app_mpd_cleanup() {

  exist -dx "$HOME/.config/mpd"

}

app_mpd_configure() {

  app_mpd_installed || return 2

  app_mpd_dirs || return 1

  app_mpd_files || return 1

  app_mpd_dotfiles || return 1

  return 0

}
