
function PathHasInstalled {

  if PathHasBin "${1}" ; then
    echo "PathHasBin$(
        ToUpper "${1}" |
        sed -e 's/-/_/'
      )=true" >> "${HOME}/.local/share/kratos/is-installed"
  else
    echo "PathHasBin$(
        ToUpper "${1}" |
        sed -e 's/-/_/'
      )=false" >> "${HOME}/.local/share/kratos/is-installed"
  fi

  return 0

}

EnsureFileDestroy "${HOME}/.local/share/kratos/is-installed"
EnsureFileExists "${HOME}/.local/share/kratos/is-installed"

# Checks for installed applications
PathHasInstalled '7z'
PathHasInstalled 'acpi'
PathHasInstalled 'apt'
PathHasInstalled 'apt-get'
PathHasInstalled 'atom'
PathHasInstalled 'bunzip2'
PathHasInstalled 'bzr'
PathHasInstalled 'cvs'
PathHasInstalled 'darcs'
PathHasInstalled 'emacs'
PathHasInstalled 'fossil'
PathHasInstalled 'ghc'
PathHasInstalled 'git'
PathHasInstalled 'go'
PathHasInstalled 'gpg-agent'
PathHasInstalled 'gunzp'
PathHasInstalled 'hg'
PathHasInstalled 'less'
PathHasInstalled 'nix-env'
PathHasInstalled 'nmcli'
PathHasInstalled 'nvim'
PathHasInstalled 'openssl'
PathHasInstalled 'pacmd'
PathHasInstalled 'pactl'
PathHasInstalled 'perl'
PathHasInstalled 'python'
PathHasInstalled 'python3'
PathHasInstalled 'ssh-add'
PathHasInstalled 'ssh-agent'
PathHasInstalled 'ssh-keygen'
PathHasInstalled 'svn'
PathHasInstalled 'systemctl'
PathHasInstalled 'tar'
PathHasInstalled 'uncompress'
PathHasInstalled 'unrar'
PathHasInstalled 'unzip'
PathHasInstalled 'vim'
PathHasInstalled 'yum'
