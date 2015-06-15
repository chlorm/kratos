app_suckless_installed() {

  path_hasbin "st" > /dev/null || return 1

  return 0

}

app_suckless_cleanup() {

  return 0

}

app_suckless_configure() {

  app_suckless_installed || return 2
  app_nixpkgs || return 1

  pushd "$DOTFILES_DIR/dotfiles/nixpkgs/st/"
  if [ HIGH_DPI = true ] ; then
    symlink "config.highdpi.h" "config.mach.h"
  else
    symlink "config.other.h" "config.mach.h"
  fi
  popd

  echo "  ✓ suckless"

  return 0

}
