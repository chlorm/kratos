# This file is part of Kratos.
# Copyright (c) 2015-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

Path::IsInstalled() {
  echo "PathHasBin$(
      String::UpperCase "${1}" | sed -e 's/-/_/'
    )=$(
      if Path::Check "${1}" ; then
        echo 'true'
      else
        echo 'false'
      fi
    )" >> "${HOME}/.local/share/kratos/is-installed"
}

File::Remove "${HOME}/.local/share/kratos/is-installed"
File::Create "${HOME}/.local/share/kratos/is-installed"

# Checks for installed applications
Path::IsInstalled '7z'
Path::IsInstalled 'acpi'
Path::IsInstalled 'apt'
Path::IsInstalled 'apt-get'
Path::IsInstalled 'bunzip2'
Path::IsInstalled 'bzr'
Path::IsInstalled 'cvs'
Path::IsInstalled 'darcs'
Path::IsInstalled 'emacs'
Path::IsInstalled 'fossil'
Path::IsInstalled 'ghc'
Path::IsInstalled 'git'
Path::IsInstalled 'go'
Path::IsInstalled 'gpg-agent'
Path::IsInstalled 'gunzp'
Path::IsInstalled 'hg'
Path::IsInstalled 'less'
Path::IsInstalled 'nix-env'
Path::IsInstalled 'nmcli'
Path::IsInstalled 'nvim'
Path::IsInstalled 'openssl'
Path::IsInstalled 'pacmd'
Path::IsInstalled 'pactl'
Path::IsInstalled 'perl'
Path::IsInstalled 'python'
Path::IsInstalled 'python3'
Path::IsInstalled 'ssh-add'
Path::IsInstalled 'ssh-agent'
Path::IsInstalled 'ssh-keygen'
Path::IsInstalled 'svn'
Path::IsInstalled 'systemctl'
Path::IsInstalled 'tar'
Path::IsInstalled 'uncompress'
Path::IsInstalled 'unrar'
Path::IsInstalled 'unzip'
Path::IsInstalled 'vim'
Path::IsInstalled 'yum'
