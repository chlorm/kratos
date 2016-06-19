Kratos
======

A user environment configuration framework

# Installation

### Prerequisites
* bash >=4.2+
* Linux, FreeBSD (will work on other platforms, however it is untested)

### Recommended:
* git >=2 (optional support for updating)

### Install
```bash
git clone 'https://github.com/chlorm/kratos.git' "${HOME}/.kratos"
cd "${HOME}/.kratos"
bash ./bootstrap.bash
```

# Configuration
### Config file
`~/.config/kratos/config`

### Dotfiles
Kratos can also manage and install your configuration files.
```
documentation incomplete
```

### Plugins
+ Vendored
```zsh
plugins=(battery golang haskell)
```
+ Local
```
Not implemented yet
```
+ Remote
```
Not implemented yet
```

### Themes
+ Vendored
```bash
KRATOS_COLOR_SCHEME='monokai'
KRATOS_PROMPT='kratos'
```
+ Local / Dotfiles
```
Not implemented yet
```

### Updating
```
Not implemented yet, use git pull
```

### Uninstall
```
Not implemented yet
```