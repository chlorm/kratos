# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_xorg_installed() {

  path_hasbin "Xorg" > /dev/null || return 1

  return 0

}

app_xorg_dotfiles() {

  exist -fx "$HOME/.xinitrc" "$HOME/.xprofile" "$HOME/.xsession" "$HOME/.Xresources"

(
cat <<XINITRC
#!/usr/bin/env sh

# Run local commands first
[ -f "$HOME/.xinitrc.local" ] && . "$HOME/.xinitrc.local"

. "$DOTFILES_DIR/lib/loader"

[ -f "$HOME/.xprofile" ] && . "$HOME/.xprofile"

path_add "$HOME/.bin"
#agent_auto
deskenvs_auto

# Gnome 3.xx
#exec gnome-session
#systemd --user
#dbus-launch nm-applet &
#eval &(gnome-keyring-daemon --components=pkcs11,secrets,ssh,gpg)
#export GNOME_KEYRING_PID
#export GNOME_KEYRING_SOCKET
#export SSH_AUTH_SOCK
#export GPG_AGENT_INFO

XINITRC
) > "$HOME/.xinitrc" || return 1

(
cat <<XPROFILE
#!/usr/bin/env sh

# Run local commands first
[ -f "$HOME/.xprofile.local" ] && . "$HOME/.xprofile.local"

. "$DOTFILES_DIR/lib/loader"

XPROFILE
) > "$HOME/.xprofile" || return 1

  symlink "$HOME/.xinitrc" "$HOME/.xsession" || return 1

  return 0

}

app_xorg_cleanup() {

  exist -fx "$HOME/.xinitrc" "$HOME/.xprofile" "$HOME/.xsession" "$HOME/.Xresources"

}

app_xorg_configure() {

  app_xorg_installed || return 2

  app_xorg_dotfiles || return 1

  return 0

}
