Kratos
=========

Orginally this was all POSIX compliant shell, but dealing with a language that doesn't have support for real arrays isn't fun, and creating your own array implementation on top of it works up and to a point before it becomes a nightmare to maintain.  Hence is the reason why only BASH is supported for the backend.  Kratos can still spawn the users preferred shell, but Kratos' functions can only be called if your curent shell is BASH.  Only fish is supported beyond this because some of the functions have been rewritten to support fish.

Why not support ZSH, because ZSH performance is dogshit, and it is worse when you include functions in you prompt

To install:
```
git clone "https://github.com/chlorm/kratos.git" "$HOME/.local/share" && \
cd $HOME/.local/share/kratos && ./install.sh
```
