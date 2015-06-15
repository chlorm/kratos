app_bash_installed() {

  path_hasbin "bash" || return 1

  return 0

}

app_bash_dotfiles() {

  exist -fx "$HOME/.bashrc" "$HOME/.bash_logout" "$HOME/.bash_profile"

  dotfile_ln "bashrc"

  return 0

}

app_bash_cleanup() {

  exist -fx "$HOME/.bashrc" "$HOME/.bash_logout" "$HOME/.bash_profile"

}

app_bash_configure() {

  app_bash_installed || return 1

  app_bash_dotfiles || return 1

  return 0

}
