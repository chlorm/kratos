app_gnome3_installed() {

  path_hasbin "gnome-session" > /dev/null || return 1

  return 0

}

app_gnome3_cleanup() {

  return 0

}

app_gnome3_configure() {

  app_gnome3_installed || return 1

  return 0

}
