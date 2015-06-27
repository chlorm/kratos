# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.


# XDG freedesktop directories

# XDG_CACHE_HOME
exist -dc "$HOME/.cache"
# XDG_CONFIG_HOME
exist -dc "$HOME/.config"
# XDG_DATA_HOME
exist -dc "$HOME/.local/share"
# XDG_DESKTOP_DIR
exist -dc "$HOME/Desktop"
# XDG_DOCUMENTS_DIR
exist -dc "$HOME/Documents"
# XDG_DOWNLOAD_DIR
exist -dc "$HOME/Downloads"
# XDG_MUSIC_DIR
exist -dc "$HOME/Music"
# XDG_PICTURES_DIR
exist -dc "$HOME/Pictures"
# XDG_PUBLICSHARE_DIR
exist -dc "$HOME/Share"
# XDG_TEMPLATES_DIR
exist -dc "$HOME/Templates"
# XDG_VIDEOS_DIR
exist -dc "$HOME/Videos"


# Freedesktop trash directories

# DIR_TRASH_INFO
exist -dc "$HOME/.local/share/trash/info"
# DIR_TRASH_FILES
exist -dc "$HOME/.local/share/trash/files"


# Custom directories

exist -dc "$HOME/dev"
