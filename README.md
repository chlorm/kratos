Kratos
======

A BASH/ZSH user environment configuration framework

### Prerequisites
* BASH >=3.1 or ZSH >=5
* GIT >=2 (optional support for updating)

##### Recommended:
* Linux (Support for other platforms is a bit more hit and miss at the moment)
* gpg-agent
* openssl
* rsync

### Installation
```
git clone "https://github.com/chlorm/kratos.git" "$HOME/.kratos" && \
cd $HOME/.kratos && ./bootstrap.sh
```

### Dotfiles
Kratos has builtin support for installing user's config files.

TODO:
* [x] Support for installing dotfiles
* [x] Install hooks (do before/after, override install)
* [ ] Support for specifing dotfiles directory
* [ ] Support for restoring changes
* [ ] Variable replacement for auto generating dotfiles

### Plugins
Currently Kratos only supports internal vendored plugins.
```bash
plugins=(battery golang haskell)
```
TODO:
* [ ] Support for adding plugins by url
* [ ] Support for adding plugins by paths

### Themes
Currently the themeing is hardcoded into Kratos.

TODO:
* [ ] Support for custom prompts
* [ ] Support for creating color schemes
* [ ] Map colors color codes to the terminals native codes
  + Kratos uses 256 color codes, but some terminals only support 4,8,16 & 88 colors
  + Helps to ensure consistency for color schemes

### Additional features
* [x] Standard library
* [ ] Shell alias auto configuration
* [ ] Autostart applications
* [ ] Set editor environment variables
  + [ ] Editor arguments
  + Auto detect installed editors and use first match to user's preferred editors
* [ ] Manage shell history
  + [ ] Forward/Back directory history functions
* [ ] Locale configuration
* [ ] Prompt customization
  + Allow L1,L2,R1,&R2 prompts (where applicable for given shells)
* [ ] Auto configure terminal color support
* [ ] Auto configure pager
  + [ ] Color support
* [x] TMP directory configuration
  + [ ] tmpfs fallback solution
* [ ] Autostarting preferred Desktop Environment(/Window Manager)
* [ ] Auto configure user agent (ssh-agent/gpg-agent)
* [ ] Support for updating, plugins, kratos, and dotfiles.
* [ ] Support for auto completion
  + Need to wrap the differences between BASH & ZSH as clean as possible

### Plugins
* [ ] battery
  + [ ] add visual battery meter
  + [x] functions for detecting batteries, capacity, and status
  + [ ] fallback for pre /sys
* [ ] golang
  + [ ] support for multiple GOPATH's
  + [x] Configure GOPATH and create directories
  + [x] Add Go /bin directory to PATH
* [x] haskell
  + [x] Add cabal /bin directory to PATH
* [x] pkg
* [ ] SSH
  + [x] Generate ssh keys
  + [ ] Support smart cards
  + [ ] Support for adding public keys in dotfiles to authorized_keys
  + [ ] Support for additional user specified keys
* [x] torrent
 + [x] generate torrent from a magnet link
* [ ] trash
* [ ] user-agent
* [ ] volume
  + [x] pulseaudio support
    - [ ] adjust multiple pulseaudio channels simultaneously
  + [ ] alsa
* [ ] wifi
  + [x] nmcli support
  + [ ] wpa_supplicant support

### Notes
* Look into auto-generating a plugin/module list via login shells to defer
   having to generate it with each interactive shell.
  + Use CRC32 to see if config was modified, else ignore changes to kratos config
* Defer additional checks to see if the TMP directory is configured
  + Once the TMP directory is create a file in the tmp directory and only
     configure if it doesn't exist
* Get rid of ShellInit, this should be split into respective modules/plugins
* Support for local config outside of dotfiles
* Decide on variable casing scheme(camel vs. snake, etc...) (local vs. global
   variables)
