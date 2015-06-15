app_sublime_installed() {

  path_hasbin "sublime" > /dev/null || return 1

  return 0

}

app_sublimetext_cleanup() {

  return 0

}

app_sublimetext_configure() {

  app_sublime_installed || return 2

  dotfile_ln "config/sublime-text-3" || return 1

  return 0

}
