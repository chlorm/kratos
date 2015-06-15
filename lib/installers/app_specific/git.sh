app_git_installed() {

  path_hasbin "git" > /dev/null || return 1

  return 0

}

app_git_dotfiles() {

  exist -fx "$HOME/.gitconfig"

(cat <<GITCONFIG
[user]
    email = $GIT_EMAIL
    name = $GIT_NAME
[push]
    default = simple

GITCONFIG
) > "$HOME/.gitconfig" || return 1

  return 0

}

app_git_configure() {

  app_git_installed || return 2

  app_git_dotfiles || return 1

  return 0

}
