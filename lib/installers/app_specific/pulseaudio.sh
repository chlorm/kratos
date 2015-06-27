# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_pulseaudio_installed() {

  path_hasbin "pacmd" > /dev/null || return 1

  return 0

}

app_pulseaudio_dirs() {

  exist -dc "$XDG_CONFIG_HOME/pulse" || return 1

  return 0

}

app_pulseaudio_dotfiles() {

  exist -fx "$XDG_CONFIG_HOME/pulse/daemon.conf"

  dotfile_ln "config/pulse/daemon.conf" || return 1

  return 0

}

app_pulseaudio_cleanup() {

  exist -dx "$XDG_CONFIG_HOME/pulse"

}

app_pulseaudio_configure() {

  app_pulseaudio_installed || return 2

  app_pulseaudio_dirs || return 1

  app_pulseaudio_dotfiles || return 1

  return 0

}
