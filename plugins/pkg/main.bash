# This file is part of Kratos.
# Copyright (c) 2014-2016, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Add search, list, query, upgrade, info, history support

Pkg::Usage() {
cat <<EOF
Pkg is an abstraction layer for system package managers.

Usage: pkg UTILITY [OPTIONS]

    clean          - Remove orphanded dependencies
    install        - Install a package
    uninstall      - Uninstall a package
    update         - Install Updates
    -h|--help      - print this message

EOF
}

Pkg::Mgr() {
  case "$(OS::Kernel)" in
    'cygwin')
      # ??? chloclatey
      Debug::Message 'error' 'not supported'
      ;;
    'darwin')
      # ??? homebrew
      Debug::Message 'error' 'not supported'
      ;;
    'freebsd') # Ports
      Path::Check 'portmaster' || return 1
      Path::Check 'portsnap' || return 1
      echo 'ports'
      return 0
      ;;
    'linux')
      case "$(OS::Linux)" in
        'Debian'|'Ubuntu') # Apt
          Path::Check 'apt-get' || return 1
          echo 'apt'
          return 0
          ;;
        'triton') # Nix
          Path::Check 'nix-env' || return 1
          Path::Check 'nixos-rebuild' || return 1
          Path::Check 'nix-collect-garbage' || return 1
          Path::Check 'nix-channel' || return 1
          echo 'nix'
          return 0
          ;;
        'arch') # Pacman
          Path::Check 'pacman' || return 1
          echo 'pacman'
          return 0
          ;;
        'gentoo') # Portage
          Path::Check 'emerge' || return 1
          echo 'portage'
          return 0
          ;;
        'centos'|'fedora'|'red hat') # Red Hat
          Path::Check 'yum' || return 1
          echo 'rpm'
          return 0
          ;;
        'suse') # Yast, not sure about this cluster fuck
          Path::Check 'zypper' || return 1
          echo 'yast'
          return 0
          ;;
        *)
          Debug::Message 'error' 'not a suppoted linux distro'
          return 1
          ;;
      esac
      ;;
    *)
      Debug::Message 'error' 'not a supported base OS'
      return 1
      ;;
  esac
}

Pkg::Command() {
  case "${1}" in
    '')
      Debug::Message 'error' 'no input provided'
      ;;
    'clean')
      case "$(Pkg::Mgr)" in
        'apt-get')
          Debug::Message 'error' 'unsupported action'
          ;;
        'nix')
          KRATOS::Lib:sudo_wrap nix-collect-garbage -d
          return $?
          ;;
        'pacman')
          [[ -n "$(pacman -Qqdt)" ]] && sudo_wrap pacman -Rns $(pacman -Qqdt)
          return $?
          ;;
        'portage')
          KRATOS::Lib:sudo_wrap emerge --depclean && sudo_wrap emerge @preserved-rebuild
          return $?
          ;;
        'rpm')
          Debug::Message 'error' 'unsupported action'
          ;;
        'yast')
          Debug::Message 'error' 'unsupported action'
          ;;
        *)
          return 1
          ;;
      esac
      ;;
    'install')
      case "$(Pkg::Mgr)" in
        'apt')
          shift
          KRATOS::Lib:sudo_wrap apt-get install $@
          return $?
          ;;
        'nix')
          shift
          nix-env -i $@
          return $?
          ;;
        'pacman')
          shift
          KRATOS::Lib:sudo_wrap pacman -S $@
          return $?
          ;;
        'portage')
          shift
          KRATOS::Lib:sudo_wrap emerge --with-bdeps=y $@
          return $?
          ;;
        'ports')
          shift
          KRATOS::Lib:sudo_wrap portmaster -yBd $@
          return $?
          ;;
        'rpm')
          shift
          KRATOS::Lib:sudo_wrap yum install $@
          return $?
          ;;
        'yast')
          shift
          KRATOS::Lib:sudo_wrap zypper
          return $?
          ;;
        *)
          return 1
          ;;
      esac
      ;;
    'uninstall')
      case "$(Pkg::Mgr)" in
        'ports')
          shift
          KRATOS::Lib:sudo_wrap portmaster -esdy $@
          return $?
          ;;
        'apt')
          shift
          KRATOS::Lib:sudo_wrap apt-get purge $@
          return $?
          ;;
        'nix')
          Debug::Message 'error' 'unsupported action'
          ;;
        'pacman')
          shift
          KRATOS::Lib:sudo_wrap pacman -Rsdc $@
          return $?
          ;;
        'portage')
          shift
          KRATOS::Lib:sudo_wrap emerge --unmerge $@
          return $?
          ;;
        'rpm')
          shift
          KRATOS::Lib:sudo_wrap yum install $@
          return $?
          ;;
        'yast')
          shift
          KRATOS::Lib:sudo_wrap zypper $@
          return $?
          ;;
        *)
          return 1
          ;;
      esac
      ;;
    'update')
      case "$(Pkg::Mgr)" in
        'ports')
            KRATOS::Lib:sudo_wrap portsnap fetch || return $?
            KRATOS::Lib:sudo_wrap portsnap update || return $?
            KRATOS::Lib:sudo_wrap portmaster -ayBd
            return $?
          ;;
        'apt')
          KRATOS::Lib:sudo_wrap apt-get update || return $?
          KRATOS::Lib:sudo_wrap apt-get dist-upgrade
          return $?
          ;;
        'nix')
          KRATOS::Lib:sudo_wrap nix-channel --update || return $?
          KRATOS::Lib:sudo_wrap nixos-rebuild boot
          return $?
          ;;
        'pacman')
          KRATOS::Lib:sudo_wrap pacman -Syu
          return $?
          ;;
        'portage')
          KRATOS::Lib:sudo_wrap emerge --sync || return $?
          KRATOS::Lib:sudo_wrap emerge --keep-going --update --deep --with-bdeps=y --newuse @world
          return $?
          ;;
        'rpm')
          KRATOS::Lib:sudo_wrap yum update
          return $?
          ;;
        'yast')
          KRATOS::Lib:sudo_wrap zypper refresh || return $?
          KRATOS::Lib:sudo_wrap zypper update
          return $?
          ;;
        *)
          return 1
          ;;
      esac
      ;;
    '-h'|'--help'|'help')
      Pkg::Usage
      return 0
      ;;
    *)
      Pkg::Usage
      Debug::Message 'error' "Invalid option: $1"
      return 1
      ;;
  esac
}
