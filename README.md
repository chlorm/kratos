Kratos
======

To install:
```
git clone "https://github.com/chlorm/kratos.git" "$HOME/.local/share/kratos" && \
cd $HOME/.local/share/kratos && ./install.sh
```

### Prerequisites
A shell with support for BASH style arrays (i.e. BASH, KSH, ZSH)
git v2
Assumes /usr/bin/env exists and is configured correctly


Eventually this will end up as a hybrid of oh-my-zsh/prezto and a dotfile manager

TODO:
-----

* Migrate the BASHisms (in the if statements) in dotfiles.sh to be compatible with BASH, ZSH, & KSH (and any other shell that supports BASH like arrays).  This will allow supporting additional shells.
	+ migrate if statements
	+ use sh for shebangs
	+ add init check to see if executing shell is supported, if not try to find and spawn a compatible shell, else fail
* Support for updating dotfiles & kratos repos
* Always exclude symlinking the ~/.bin dir.  symlink contents into dir
* Add support for config file in dotfiles
* Fix how environment variables and aliases are handled and split appropriately between dotfiles and kratos
* Move wrapper scripts back to kratos
* Add support for parsing for and replacing variables in config files
* Add support for a do before/after hook for dotfiles, needed for directory creation and such
* Add a way to find or set the dotfile dir at install time
* Fix deskenv exec support
* Remove shell fixes for arrays and only support shells that support BASH style arrays (i.e. bash, zsh, ksh)
* Add user agent support
* Work on PATH configuration
* Work on SSH configuration and handling of keys
* Split shell loader functions out of lib/core.sh (e.g. prompt)
* Allow user defined color scheme
* Add color mapping between terminals color levels (e.g. 1/4/8/16/88/256)
	+ Should generate a file with the colors at each level that is sourced by the loader at shell init
* Avoid any instances of loops iterating through arrays at runtime
