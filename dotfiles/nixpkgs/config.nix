pkgs : {
  allowUnfree = true;
  cabal.libraryProfiling = true;
  firefox = {
    jre = false;
    enableAdobeFlash = true;
    enableGoogleTalkPlugin = true;
    icedtea = true;
  };
  chromium = {
    enablePepperFlash = true;
  #  enableWideVine = true;
    proprietaryCodecs = true;
  };
  # Suckless
  st.conf = (builtins.readFile ./st/config.mach.h)
    + (builtins.readFile ./st/config.inc.h);

  packageOverrides = self : rec {

    #chromium = self.chromium.override {
    #  enableNaCl = false;
    #  useOpenSSL = false;
    #  gnomeSupport = true;
    #  gnomeKeyringSupport = false;
    #  enablePepperFlash = true;
    #  enableWideVine = true;
    #  proprietaryCodecs = true;
    #  cupsSupport = true;
    #  pulseSupport = true;
    #  hiDPISupport = false;
    #};
    #emacs = self.emacs.override {
    #  withX = false;
    #};
    /*ffmpeg-full = self.ffmpeg-full.override {
      nonfreeLicensing = true;
      gnutls = null;
      opensslExtlib = true;
      #decklinkExtlib = true;
      fdkaacExtlib = true;
      openglExtlib = true;
    };*/
    rtorrent-git = self.rtorrent-git.override {
      colorSupport = true;
    };
    x265 = self.x265.override {
      highbitdepthSupport = true;
    };
    #desktop = self.haskellPackages.ghcWithPackages (self : with self; [
    #  haskell-ngPackages.xdgBasedir
     # xmonad
      #yi
    #]);

    # Import Environments
    user-env = self.buildEnv {
      name = "userEnv";
      paths = with self; [
        steamEnv
        # Default
          acpi
          atop
          bc
          dash
          dnstop
          emacs
          git
          gptfdisk
          hdparm
          htop
          iftop
          iotop
          iperf
          ipset
          iptables
          lm_sensors
          meslo-lg
          mtr
          neovim
          nftables
          nmap
          openssh
          openssl
          psmisc
          smartmontools
          sysstat
          tcpdump
          tmux
          vim
          wget
          zsh

        # Headless
          beets
          ffmpeg-full
          flac
          #gnupg1compat
          go
          #icedtea7_web
          imagemagick
          lame
          libpng
          libvpx
          mediainfo
          mkvtoolnix-cli
          mosh
          most
          mpd
          ncdc
          ncdu
          ncmpcpp
          networkmanager
          #nix-repl
          #nixops
          #notbit
          p7zip
          pcsclite
          pinentry
          psmisc
          pulseaudioFull
          rtorrent-git
          scrot
          speedtest_cli
          subversion
          unzip
          vobsub2srt
          x264
          x265
          #xlibs.xbacklight
          xz
          youtube-dl

        # Graphical
          chromium
          dmenu
          #eagle
          filezilla
          firefoxWrapper
          gimp
          guitarix
          #libreoffice
          makemkv
          mixxx
          mkvtoolnix-cli
          mpv
          mumble
          networkmanager
          networkmanagerapplet
          pavucontrol
          kde4.quasselClient
          sakura
          sublime3
          teamspeak_client
          texLive
          texstudio
          #virtmanager
          vlc
          xfe
      ];
    };

    steamEnv = self.buildEnv {
      name = "steam-env";
      ignoreCollisions = true;
      paths = with self; [
          steam
      ];
    };
  };
}
