Kratos
======

To install:
```
git clone "https://github.com/chlorm/kratos.git" "$HOME/.kratos" && \
cd $HOME/.kratos/tools && ./install.sh
```

### Prerequisites
* A shell with support for BASH style arrays (i.e. BASH, KSH, PDKSH, ZSH)
  + Portions currently only work with BASH
* git v2
* systemd
* Assumes /usr/bin/env exists and is configured correctly

### Design Goals/TODO
- [x] Never require root access for ANYTHING, if it needs root it can't be a part of
   Kratos
- [ ] Handle autostarting applications (via systemd)
- [ ] Configure environment variables (EDITOR,PAGER,etc...)
- [ ] Launch prefered deskenv if one isn't running (Handled via .xinitrc)
- [ ] Configure and launch user-agent (ssh-agent/gpg-agent)
- [ ] Support for themeing
- [x] Support for managing dotfiles
- [ ] Variable replacement for dotfiles (way to work around applications requiring
   explicit paths and possibly other use cases)
   + FILENAME: `<dotfile>.gen`
- [x] Do-before and Do-after functions for dotfiles to allow for directory creation
   and additional setup. Maybe other hooks could be added.
   + CHANGE: Use `<dotfile>.install`, `<dotfile>.install-pre` &
      `<dotfile>.install-post`
- [ ] Dotfiles init hooks for auto starting applications
- [ ] Support for updating dotfiles & kratos repos
- [x] Add support for config file in dotfiles
- [ ] Fix how environment variables and aliases are handled and split appropriately
   between dotfiles and kratos
- [x] Move wrapper scripts back to kratos
- [ ] Add a way to find or set the dotfile dir at install time
* [ ] Work on PATH configuration
* [ ] Work on SSH configuration and handling of keys
* [ ] Add color mapping between terminals color levels (e.g. 1/4/8/16/88/256)
	+ Should generate a file with the colors at each level that is sourced by the
	   loader at shell init
* [ ] Avoid any instances of loops iterating through arrays at runtime
* [ ] Add editor args variable (e.g. for setting -nw for emacs), used in EDITOR
   environment variable.
* [ ] Add error logging to kratos std lib
* [ ] Findout if KSH/PDKSH have an alternative to BASH's FUNCNAME[@] array for
   accessing the call stack history.
