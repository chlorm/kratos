# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# WARNING: enabling the auto updater with destroy any local changes in both your
# dotfiles and kratos repo, this is not recommended.
KRATOS_AUTO_UPDATER=false

# Add user specified directories to this array in your local config
KRATOS_CREATE_CUSTOM_DIRECTOIES=()

# ~/Projects
KRATOS_CREATE_PROJECT_DIRECTORIES=true

# ~/.local/share/trash/files
# ~/.local/share/trash/info
KRATOS_CREATE_TRASH_DIRECTORIES=true

# ~/.cache"       # XDG_CACHE_HOME
# ~/.config"      # XDG_CONFIG_HOME
# ~/.local/share" # XDG_DATA_HOME
# ~/Desktop"      # XDG_DESKTOP_DIR
# ~/Documents"    # XDG_DOCUMENTS_DIR
# ~/Downloads"    # XDG_DOWNLOAD_DIR
# ~/Music"        # XDG_MUSIC_DIR
# ~/Pictures"     # XDG_PICTURES_DIR
# ~/Share"        # XDG_PUBLICSHARE_DIR
# ~/Templates"    # XDG_TEMPLATES_DIR
# ~/Videos"       # XDG_VIDEOS_DIR
KRATOS_CREATE_XDG_DIRECTORIES=true
