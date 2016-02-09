
function path_has_installed {

  echo "PathHasBin$(
      to_upper "${1}" |
      sed -e 's/-/_/'
    )=$(
      if path_has_bin "${1}" ; then
        echo 'true'
      else
        echo 'false'
      fi
    )" >> "${HOME}/.local/share/kratos/is-installed"

  return 0

}

ensure_file_destroy "${HOME}/.local/share/kratos/is-installed"
ensure_file_exists "${HOME}/.local/share/kratos/is-installed"

# Checks for installed applications
path_has_installed '7z'
path_has_installed 'acpi'
path_has_installed 'apt'
path_has_installed 'apt-get'
path_has_installed 'bunzip2'
path_has_installed 'bzr'
path_has_installed 'cvs'
path_has_installed 'darcs'
path_has_installed 'emacs'
path_has_installed 'fossil'
path_has_installed 'ghc'
path_has_installed 'git'
path_has_installed 'go'
path_has_installed 'gpg-agent'
path_has_installed 'gunzp'
path_has_installed 'hg'
path_has_installed 'less'
path_has_installed 'nix-env'
path_has_installed 'nmcli'
path_has_installed 'nvim'
path_has_installed 'openssl'
path_has_installed 'pacmd'
path_has_installed 'pactl'
path_has_installed 'perl'
path_has_installed 'python'
path_has_installed 'python3'
path_has_installed 'ssh-add'
path_has_installed 'ssh-agent'
path_has_installed 'ssh-keygen'
path_has_installed 'svn'
path_has_installed 'systemctl'
path_has_installed 'tar'
path_has_installed 'uncompress'
path_has_installed 'unrar'
path_has_installed 'unzip'
path_has_installed 'vim'
path_has_installed 'yum'
