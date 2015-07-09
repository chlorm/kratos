Kratos
======

To install:
```
git clone "https://github.com/chlorm/kratos.git" "$HOME/.kratos" && \
cd $HOME/.kratos/tools && ./install.sh
```

### Prerequisites
* A shell with support for BASH style arrays (i.e. BASH, KSH, PDKSH, ZSH)
* git v2
* systemd (Might be able to also partially support OSX, however supporting
   sysvinit systemd would require root access)
* Assumes /usr/bin/env exists and is configured correctly

### Design Goals
* Never require root access for ANYTHING, if it needs root it can't be a part of
   Kratos
* Handle autostarting applications
* Configure environment variables
* Launch prefered deskenv if one isn't running
* Setup ssh keys
* Configure and launch user-agent (ssh-agent/gpg-agent)
* Support for creating themes
* Support for managing dotfiles
* Variable replacement for dotfiles (way to work around applications requiring
   explicit paths and possibly other use cases)
   + FILENAME: `<dotfile>.gen`
* Do-before and Do-after functions for dotfiles to allow for directory creation
   and additional setup. Maybe other hooks could be added.
   + CHANGE: Use `<dotfile>.install`, `<dotfile>.install-pre` &
      `<dotfile>.install-post`
* Dotfiles init hooks for auto starting applications

TODO:
-----

* Migrate the BASHisms (in the if statements) in dotfiles.sh to be compatible
   with BASH, ZSH, & KSH (and any other shell that supports BASH like arrays).
	 This will allow supporting additional shells.
	+ migrate if statements
	+ use sh for shebangs
	+ add init check to see if executing shell is supported, if not try to find
	   and spawn a compatible shell, else fail
* Support for updating dotfiles & kratos repos
* Always exclude symlinking the ~/.bin dir.  symlink contents into dir
* Add support for config file in dotfiles
* Fix how environment variables and aliases are handled and split appropriately
   between dotfiles and kratos
* Move wrapper scripts back to kratos
* Add support for parsing for and replacing variables in config files
* Add support for a do before/after hook for dotfiles, needed for directory
   creation and such
* Add a way to find or set the dotfile dir at install time
* Fix deskenv exec support
* Remove shell fixes for arrays and only support shells that support BASH style
   arrays (i.e. bash, zsh, ksh)
* Add user agent support
* Work on PATH configuration
* Work on SSH configuration and handling of keys
* Split shell loader functions out of lib/core.sh (e.g. prompt)
* Allow user defined color scheme
* Add color mapping between terminals color levels (e.g. 1/4/8/16/88/256)
	+ Should generate a file with the colors at each level that is sourced by the
	   loader at shell init
* Avoid any instances of loops iterating through arrays at runtime
* Add editor args variable (e.g. for setting -nw for emacs), used in EDITOR
   environment variable.
* Add a way to introduce module execution priority (maybe using `wait` to wait
	 for other modules to finish)
* Add error logging to kratos std lib
