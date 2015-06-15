app_htop_installed() {

  path_hasbin "htop" > /dev/null || return 1

  return 0

}

app_htop_dirs() {

  exist -dc "$XDG_CONFIG_HOME/htop" || return 1

  return 0

}

app_htop_dotfiles() {

  exist -fx "$XDG_CONFIG_HOME/htop/htoprc"

  dotfile_ln "config/htop/htoprc" || return 1

  return 0

}

app_htop_cleanup() {

  exist -dx "$XDG_CONFIG_HOME/htop"

}

app_htop_configure() {

  app_htop_installed  || return 2

  app_htop_dirs || return 1

  app_htop_dotfiles || return 1

  return 0

}
