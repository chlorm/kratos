app_sh_installed() {

  path_hasbin "sh" || {
  	path_hasbin "dash" || return 1
  } || return 1

  return 0

}

app_sh_dotfiles() {

  exist -fx "$HOME/.profile"

  dotfile_ln "profile"

  return 0

}

app_sh_cleanup() {

  exist -fx "$HOME/.profile"

}

app_sh_configure() {

  app_sh_installed || return 1

  app_sh_dotfiles || return 1

  return 0

}
