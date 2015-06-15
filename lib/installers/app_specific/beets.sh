app_beets_installed() {

  path_hasbin "beet" > /dev/null || return 1

  return 0

}

app_beets_dirs() {

  exist -dc "$HOME/.config/beets" || return 1

  return 0

}

app_beets_dotfiles () {

  exist -fx "$HOME/.config/beets/config.yaml"

  dotfile_ln "config/beets/config.yaml" || return 1

  return 0

}

app_beets_cleanup() {

  exist -dx "$HOME/.config/beets"

}

app_beets_configure() {

  app_beets_installed || return 2

  app_beets_dirs || return 1

  app_beets_dotfiles || return 1

  return 0

}
