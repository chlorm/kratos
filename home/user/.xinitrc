exec gnome-session
systemd --user
dbus-launch nm-applet &
eval &(gnome-keyring-daemon --components=pkcs11,secrets,ssh,gpg)
export GNOME_KEYRING_PID
export GNOME_KEYRING_SOCKET
export SSH_AUTH_SOCK
export GPG_AGENT_INFO