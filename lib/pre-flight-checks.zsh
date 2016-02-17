
KRATOS::Lib:path.has_installed() {
  echo "PathHasBin$(
      KRATOS::Lib:to_upper "${1}" |
      sed -e 's/-/_/'
    )=$(
      if KRATOS::Lib:path.has_bin "${1}" ; then
        echo 'true'
      else
        echo 'false'
      fi
    )" >> "${HOME}/.local/share/kratos/is-installed"

  return 0
}

KRATOS::Lib:ensure.file_destroy "${HOME}/.local/share/kratos/is-installed"
KRATOS::Lib:ensure.file_exists "${HOME}/.local/share/kratos/is-installed"

# Checks for installed applications
KRATOS::Lib:path.has_installed '7z'
KRATOS::Lib:path.has_installed 'acpi'
KRATOS::Lib:path.has_installed 'apt'
KRATOS::Lib:path.has_installed 'apt-get'
KRATOS::Lib:path.has_installed 'bunzip2'
KRATOS::Lib:path.has_installed 'bzr'
KRATOS::Lib:path.has_installed 'cvs'
KRATOS::Lib:path.has_installed 'darcs'
KRATOS::Lib:path.has_installed 'emacs'
KRATOS::Lib:path.has_installed 'fossil'
KRATOS::Lib:path.has_installed 'ghc'
KRATOS::Lib:path.has_installed 'git'
KRATOS::Lib:path.has_installed 'go'
KRATOS::Lib:path.has_installed 'gpg-agent'
KRATOS::Lib:path.has_installed 'gunzp'
KRATOS::Lib:path.has_installed 'hg'
KRATOS::Lib:path.has_installed 'less'
KRATOS::Lib:path.has_installed 'nix-env'
KRATOS::Lib:path.has_installed 'nmcli'
KRATOS::Lib:path.has_installed 'nvim'
KRATOS::Lib:path.has_installed 'openssl'
KRATOS::Lib:path.has_installed 'pacmd'
KRATOS::Lib:path.has_installed 'pactl'
KRATOS::Lib:path.has_installed 'perl'
KRATOS::Lib:path.has_installed 'python'
KRATOS::Lib:path.has_installed 'python3'
KRATOS::Lib:path.has_installed 'ssh-add'
KRATOS::Lib:path.has_installed 'ssh-agent'
KRATOS::Lib:path.has_installed 'ssh-keygen'
KRATOS::Lib:path.has_installed 'svn'
KRATOS::Lib:path.has_installed 'systemctl'
KRATOS::Lib:path.has_installed 'tar'
KRATOS::Lib:path.has_installed 'uncompress'
KRATOS::Lib:path.has_installed 'unrar'
KRATOS::Lib:path.has_installed 'unzip'
KRATOS::Lib:path.has_installed 'vim'
KRATOS::Lib:path.has_installed 'yum'
