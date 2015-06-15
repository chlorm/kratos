# Initalize shell configuration
unset DOTFILES_DIR
. "$HOME/.local/share/dotfiles/dir"
. "$HOME/.local/share/dotfiles/preferences"

. "$DOTFILES_DIR/lib/core.sh"
load_all "lib/modules"

if [ "$INITALIZED" != true ] ; then
  shells_tmp
  shells_theme
  shells_init
  export INITALIZED=true
fi

if [ "$PREFERED_SHELL" != "$(shell_nov)" ] ; then
  exec "$PREFERED_SHELL"
  exit $?
fi

prompt_configure
