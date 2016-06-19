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

KRATOS::Plugins:pkg.mgr() {
  case "$(KRATOS::Lib:os.kernel)" in
    'cygwin')
      # ??? chloclatey
      KRATOS::Lib:err.error 'not supported'
      ;;
    'darwin')
      # ??? homebrew
      KRATOS::Lib:err.error 'not supported'
      ;;
    'freebsd') # Ports
      KRATOS::Lib:path.has_bin 'portmaster' || return 1
      KRATOS::Lib:path.has_bin 'portsnap' || return 1
      echo 'ports'
      return 0
      ;;
    'linux')
      case "$(KRATOS::Lib:os.linux)" in
        'Debian'|'Ubuntu') # Apt
          KRATOS::Lib:path.has_bin 'apt-get' || return 1
          echo 'apt'
          return 0
          ;;
        'triton') # Nix
          KRATOS::Lib:path.has_bin 'nix-env' || return 1
          KRATOS::Lib:path.has_bin 'nixos-rebuild' || return 1
          KRATOS::Lib:path.has_bin 'nix-collect-garbage' || return 1
          KRATOS::Lib:path.has_bin 'nix-channel' || return 1
          echo 'nix'
          return 0
          ;;
        'arch') # Pacman
          KRATOS::Lib:path.has_bin 'pacman' || return 1
          echo 'pacman'
          return 0
          ;;
        'gentoo') # Portage
          KRATOS::Lib:path.has_bin 'emerge' || return 1
          echo 'portage'
          return 0
          ;;
        'centos'|'fedora'|'red hat') # Red Hat
          KRATOS::Lib:path.has_bin 'yum' || return 1
          echo 'rpm'
          return 0
          ;;
        'suse') # Yast, not sure about this cluster fuck
          KRATOS::Lib:path.has_bin 'zypper' || return 1
          echo 'yast'
          return 0
          ;;
        *)
          KRATOS::Lib:err.error 'not a suppoted linux distro'
          return 1
          ;;
      esac
      ;;
    *)
      KRATOS::Lib:err.error 'not a supported base OS'
      return 1
      ;;
  esac
}

KRATOS::Plugins:pkg.command() {
  case "${1}" in
    '')
      KRATOS::Lib:err.error 'no input provided'
      ;;
    'clean')
      case "$(KRATOS::Plugins:pkg.mgr)" in
        'apt-get')
          KRATOS::Lib:err.error 'unsupported action'
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
          KRATOS::Lib:err.error 'unsupported action'
          ;;
        'yast')
          KRATOS::Lib:err.error 'unsupported action'
          ;;
        *)
          return 1
          ;;
      esac
      ;;
    'install')
      case "$(KRATOS::Plugins:pkg.mgr)" in
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
      case "$(KRATOS::Plugins:pkg.mgr)" in
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
          KRATOS::Lib:err.error 'unsupported action'
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
      case "$(KRATOS::Plugins:pkg.mgr)" in
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
      KRATOS::Plugins:pkg.usage
      return 0
      ;;
    *)
      KRATOS::Plugins:pkg.usage
      KRATOS::Lib:err.error "Invalid option: $1"
      return 1
      ;;
  esac
}
