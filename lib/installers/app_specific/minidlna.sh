# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_minidlna_installed() {
	
  path_hasbin "minidlna" > /dev/null || return 1

  return 0

}

app_minidlna_dirs() {

  exist -dc "$HOME/.minidlna" "$XDG_DATA_HOME/minidlna" || return 1

  return 0

}

app_minidlna_dotfiles() {

  exist -fx "$HOME/.minidlna/minidlna.conf"

(
cat <<MINIDLNA
# $DOTFILES_AUTOGEN_WARN

friendly_name=Chlorm DLNA Server
port=8200
user=$(whoami)

# use different container as root of the tree
# possible values:
#   + "." - use standard container (this is the default)
#   + "B" - "Browse Directory"
#   + "M" - "Music"
#   + "V" - "Video"
#   + "P" - "Pictures"
# if you specify "B" and client device is audio-only then "Music/Folders" will be used as root

media_dir=V,$XDG_VIDEOS_DIR/Movies
media_dir=V,$XDG_VIDEOS_DIR/Television

db_dir=$XDG_DATA_HOME/minidlna/db
log_dir=$XDG_DATA_HOME/minidlna/log

# List of file names to check for when searching for album art
album_art_names=Cover.jpg/cover.jpg/AlbumArtSmall.jpg/albumartsmall.jpg/AlbumArt.jpg/albumart.jpg/Album.jpg/album.jpg/Folder.jpg/folder.jpg/Thumb.jpg/thumb.jpg

inotify=yes
enable_tivo=no
strict_dlna=no
notify_interval=895
serial=12345678
model_number=1

MINIDLNA
) > "$HOME/.minidlna/minidlna.conf" || return 1

  return 0

}

app_minidlna_cleanup() {

  exist -dx "$HOME/.minidlna" "$XDG_DATA_HOME/minidlna"

}

app_minidlna_configure() {

  app_minidlna_installed || return 2

  app_minidlna_dirs || return 1

  app_minidlna_dotfiles || return 1

  return 0

}
