app_vim_installed() {

  path_hasbin "vim" > /dev/null || return 1

  return 0

}

app_vim_dotfiles() {

  dotfile_ln "vim" || return 1
  dotfile_ln "vimrc" || return 1

  return 0

}

app_vim_cleanup() {

  exist -dx "$HOME/.vim"
  exist -fx "$HOME/.vimrc"

}

app_vim_configure() {

  app_vim_installed || return 2

  exist -dx "$HOME/.viminfo" || return 1

  app_vim_dotfiles || return 1

  return 0

}
