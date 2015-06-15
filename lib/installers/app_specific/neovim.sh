app_neovim_installed() {

  path_hasbin "nvim" > /dev/null || return 1

  return 0

}

app_neovim_dotfiles() {

  dotfile_ln "nvim" || return 1
  dotfile_ln "nvimrc" || return 1

  return 0

}

app_neovim_cleanup() {

  exist -dx "$HOME/.nvim"
  exist -fx "$HOME/.nvimrc"

}

app_neovim_configure() {

  app_neovim_installed || return 2

  exist -dx "$HOME/.nviminfo" || return 1

  app_neovim_dotfiles || return 1

  return 0

}
