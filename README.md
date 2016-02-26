Kratos
======

A ZSH user environment configuration framework

### Prerequisites
* zsh >=5 (untested on <5)

### Recommended:
* git >=2 (optional support for updating)
* gpg-agent
* openssl
* rsync

### Installation
```zsh
git clone 'https://github.com/chlorm/kratos.git' "${HOME}/.kratos"
cd "${HOME}/.kratos"
zsh ./bootstrap.zsh
```

### Plugins
Currently Kratos only supports internal vendored plugins.
```zsh
plugins=(battery golang haskell)
```
