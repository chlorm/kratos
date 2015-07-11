# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

# Add search, list, query, upgrade, info, history support

function pkg.usage {

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

function pkg.mgr {

  case "$(os.kernel)" in

    'cygwin')
      # ??? chloclatey
      err.error "not supported"
      ;;

    'darwin')
      # ??? homebrew
      err.error "not supported"
      ;;

    'freebsd') # Ports
      path.hasbin.err 'portmaster' || return 1
      path.hasbin.err 'portsnap' || return 1
      echo "ports"
      return 0
      ;;

    'linux')
      case "$(os.linux)" in

        'Debian'|'Ubuntu') # Apt
          path.hasbin.err 'apt-get' || return 1
          echo "apt"
          return 0
          ;;

        'nixos') # Nix
          path.hasbin.err 'nix-env' || return 1
          path.hasbin.err 'nixos-rebuild' || return 1
          path.hasbin.err 'nix-collect-garbage' || return 1
          path.hasbin.err 'nix-channel' || return 1
          echo "nix"
          return 0
          ;;

        'arch') # Pacman
          path.hasbin.err 'pacman' || return 1
          echo "pacman"
          return 0
          ;;

        'gentoo') # Portage
          path.hasbin.err 'emerge' || return 1
          echo "portage"
          return 0
          ;;

        'centos'|'fedora'|'red hat') # Red Hat
          path.hasbin.err 'yum' || return 1
          echo "rpm"
          return 0
          ;;

        'suse') # Yast, not sure about this cluster fuck
          path.hasbin.err 'zypper' || return 1
          echo "yast"
          return 0
          ;;

        *)
          err.error "not a suppoted linux distro"
          return 1
          ;;

      esac
      ;;

    *)
      err.error "not a supported base OS"
      return 1
      ;;

  esac

}

function pkg {
  case "$1" in
    '')
      err.error "no input provided"
      ;;
    'clean')
      case "$(pkg.mgr)" in
        'apt-get')
          err.error "unsupported action"
          ;;
        'nix')
          sudo_wrap nix-collect-garbage -d
          return $?
          ;;
        'pacman')
          [ -n "$(pacman -Qqdt)" ] && sudo_wrap pacman -Rns $(pacman -Qqdt)
          return $?
          ;;
        'portage')
          sudo_wrap emerge --depclean && sudo_wrap emerge @preserved-rebuild
          return $?
          ;;
        'rpm')
          err.error "unsupported action"
          ;;
        'yast')
          err.error "unsupported action"
          ;;
        *)
          return 1
          ;;
      esac
      ;;
    'install')
      case "$(pkg.mgr)" in
        'apt')
          shift
          sudo_wrap apt-get install $@
          return $?
          ;;
        'nix')
          shift
          nix-env -i $@
          return $?
          ;;
        'pacman')
          shift
          sudo_wrap pacman -S $@
          return $?
          ;;
        'portage')
          shift
          sudo_wrap emerge --with-bdeps=y $@
          return $?
          ;;
        'ports')
          shift
          sudo_wrap portmaster -yBd $@
          return $?
          ;;
        'rpm')
          shift
          sudo_wrap yum install $@
          return $?
          ;;
        'yast')
          shift
          sudo_wrap zypper
          return $?
          ;;
        *)
          return 1
          ;;
      esac
      ;;
    'uninstall')
      case "$(pkg.mgr)" in
        'ports')
          shift
          sudo_wrap portmaster -esdy $@
          return $?
          ;;
        'apt')
          shift
          sudo_wrap apt-get purge $@
          return $?
          ;;
        'nix')
          err.error "unsupported action"
          ;;
        'pacman')
          shift
          sudo_wrap pacman -Rsdc $@
          return $?
          ;;
        'portage')
          shift
          sudo_wrap emerge --unmerge $@
          return $?
          ;;
        'rpm')
          shift
          sudo_wrap yum install $@
          return $?
          ;;
        'yast')
          shift
          sudo_wrap zypper $@
          return $?
          ;;
        *)
          return 1
          ;;
      esac
      ;;
    'update')
      case "$(pkg.mgr)" in
        'ports')
            sudo_wrap portsnap fetch || return $?
            sudo_wrap portsnap update || return $?
            sudo_wrap portmaster -ayBd
            return $?
          ;;
        'apt')
          sudo_wrap apt-get update || return $?
          sudo_wrap apt-get dist-upgrade
          return $?
          ;;
        'nix')
          sudo_wrap nix-channel --update || return $?
          nixos-rebuild boot
          return $?
          ;;
        'pacman')
          sudo_wrap pacman -Syu
          return $?
          ;;
        'portage')
          sudo_wrap emerge --sync || return $?
          sudo_wrap emerge --keep-going --update --deep --with-bdeps=y --newuse @world
          return $?
          ;;
        'rpm')
          sudo_wrap yum update
          return $?
          ;;
        'yast')
          sudo_wrap zypper refresh || return $?
          sudo_wrap zypper update
          return $?
          ;;
        *)
          return 1
          ;;
      esac
      ;;
    '-h'|'--help'|'help')
      pkg.usage
      return 0
      ;;
    *)
      pkg.usage
      err.error "Invalid option: $1"
      return 1
      ;;
  esac
}
