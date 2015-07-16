# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Add search, list, query, upgrade, info, history support

function PkgUsage {

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

function PkgMgr {

  case "$(OsKernel)" in

    'cygwin')
      # ??? chloclatey
      ErrError 'not supported'
      ;;

    'darwin')
      # ??? homebrew
      ErrError 'not supported'
      ;;

    'freebsd') # Ports
      PathHasBinErr 'portmaster' || return 1
      PathHasBinErr 'portsnap' || return 1
      echo 'ports'
      return 0
      ;;

    'linux')
      case "$(OsLinux)" in

        'Debian'|'Ubuntu') # Apt
          PathHasBinErr 'apt-get' || return 1
          echo 'apt'
          return 0
          ;;

        'nixos') # Nix
          PathHasBinErr 'nix-env' || return 1
          PathHasBinErr 'nixos-rebuild' || return 1
          PathHasBinErr 'nix-collect-garbage' || return 1
          PathHasBinErr 'nix-channel' || return 1
          echo 'nix'
          return 0
          ;;

        'arch') # Pacman
          PathHasBinErr 'pacman' || return 1
          echo 'pacman'
          return 0
          ;;

        'gentoo') # Portage
          PathHasBinErr 'emerge' || return 1
          echo 'portage'
          return 0
          ;;

        'centos'|'fedora'|'red hat') # Red Hat
          PathHasBinErr 'yum' || return 1
          echo 'rpm'
          return 0
          ;;

        'suse') # Yast, not sure about this cluster fuck
          PathHasBinErr 'zypper' || return 1
          echo 'yast'
          return 0
          ;;

        *)
          ErrError 'not a suppoted linux distro'
          return 1
          ;;

      esac
      ;;

    *)
      ErrError 'not a supported base OS'
      return 1
      ;;

  esac

}

function pkg {
  case "${1}" in
    '')
      ErrError 'no input provided'
      ;;
    'clean')
      case "$(PkgMgr)" in
        'apt-get')
          ErrError 'unsupported action'
          ;;
        'nix')
          SudoWrap nix-collect-garbage -d
          return $?
          ;;
        'pacman')
          [ -n "$(pacman -Qqdt)" ] && SudoWrap pacman -Rns $(pacman -Qqdt)
          return $?
          ;;
        'portage')
          SudoWrap emerge --depclean && SudoWrap emerge @preserved-rebuild
          return $?
          ;;
        'rpm')
          ErrError 'unsupported action'
          ;;
        'yast')
          ErrError 'unsupported action'
          ;;
        *)
          return 1
          ;;
      esac
      ;;
    'install')
      case "$(PkgMgr)" in
        'apt')
          shift
          SudoWrap apt-get install $@
          return $?
          ;;
        'nix')
          shift
          nix-env -i $@
          return $?
          ;;
        'pacman')
          shift
          SudoWrap pacman -S $@
          return $?
          ;;
        'portage')
          shift
          SudoWrap emerge --with-bdeps=y $@
          return $?
          ;;
        'ports')
          shift
          SudoWrap portmaster -yBd $@
          return $?
          ;;
        'rpm')
          shift
          SudoWrap yum install $@
          return $?
          ;;
        'yast')
          shift
          SudoWrap zypper
          return $?
          ;;
        *)
          return 1
          ;;
      esac
      ;;
    'uninstall')
      case "$(PkgMgr)" in
        'ports')
          shift
          SudoWrap portmaster -esdy $@
          return $?
          ;;
        'apt')
          shift
          SudoWrap apt-get purge $@
          return $?
          ;;
        'nix')
          ErrError 'unsupported action'
          ;;
        'pacman')
          shift
          SudoWrap pacman -Rsdc $@
          return $?
          ;;
        'portage')
          shift
          SudoWrap emerge --unmerge $@
          return $?
          ;;
        'rpm')
          shift
          SudoWrap yum install $@
          return $?
          ;;
        'yast')
          shift
          SudoWrap zypper $@
          return $?
          ;;
        *)
          return 1
          ;;
      esac
      ;;
    'update')
      case "$(PkgMgr)" in
        'ports')
            SudoWrap portsnap fetch || return $?
            SudoWrap portsnap update || return $?
            SudoWrap portmaster -ayBd
            return $?
          ;;
        'apt')
          SudoWrap apt-get update || return $?
          SudoWrap apt-get dist-upgrade
          return $?
          ;;
        'nix')
          SudoWrap nix-channel --update || return $?
          SudoWrap nixos-rebuild boot
          return $?
          ;;
        'pacman')
          SudoWrap pacman -Syu
          return $?
          ;;
        'portage')
          SudoWrap emerge --sync || return $?
          SudoWrap emerge --keep-going --update --deep --with-bdeps=y --newuse @world
          return $?
          ;;
        'rpm')
          SudoWrap yum update
          return $?
          ;;
        'yast')
          SudoWrap zypper refresh || return $?
          SudoWrap zypper update
          return $?
          ;;
        *)
          return 1
          ;;
      esac
      ;;
    '-h'|'--help'|'help')
      PkgUsage
      return 0
      ;;
    *)
      PkgUsage
      ErrError "Invalid option: $1"
      return 1
      ;;
  esac
}
