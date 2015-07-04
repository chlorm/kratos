Kratos
======

To install:
```
git clone "https://github.com/chlorm/kratos.git" "$HOME/.local/share" && \
cd $HOME/.local/share/kratos && ./install.sh
```

TODO:
-----

* Support for updating dotfiles & kratos repos
* Always exclude symlinking the ~/.bin dir.  symlink contents into dir
* Add support for config file in dotfiles
* Fix how environment variables and aliases are handled and split appropriately between dotfiles and kratos
* Move wrapper scripts back to kratos
* Add support for parsing for and replacing variables in config files
* Add support for a do before/after hook for dotfiles, needed for directory creation and such
* Add a way to find or set the dotfile dir at install time
* Investigate support for shells other than BASH, however unlikely, won't run natively though if things work
* Fix deskenv exec support
* remove shell fixes and use native implementations
* Add user agent support
* Work on PATH configuration
* Work on SSH configuration and handling of keys

Orginally this was all POSIX compliant shell, but dealing with a language that doesn't have support for real arrays isn't fun, and creating your own array implementation on top of it works up and to a point before it becomes a nightmare to maintain.  Hence is the reason why only BASH is supported for the backend.  Kratos can still spawn the users preferred shell, but Kratos' functions can only be called if your curent shell is BASH.  Only fish is supported beyond this because some of the functions have been rewritten to support fish.

Why not support ZSH, because ZSH performance is dogshit, and it is worse when you include functions in you prompt
