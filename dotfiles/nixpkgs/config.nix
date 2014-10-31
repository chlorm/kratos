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
    enablePepperPDF = true;
  };
  # FFmpeg - enable fdk-aac
  ffmpeg.fdk = true;
  # Suckless
  st.conf = (builtins.readFile ./st/config.mach.h)
    + (builtins.readFile ./st/config.inc.h);

  packageOverrides = self : rec {
    rtorrent-git = self.rtorrent-git.override { colorSupport = true; };
    # Import Environments
    chlorm = self.buildEnv {
      name = "myChlorm";
      paths = with self; [
        # Required
        base
        # Optional
        audio
        communication
        desktop
        development
        download
        editors
        haskell
        headless
        image
        monitoring
        networking
        shells
        terminals
        video
        virtualization
        www
      ];
    };
    # Environments
    base = self.buildEnv {
      name = "myBase";
      paths = with self; [
        git
        htop
        openssh_hpn
        openssl
        tmux
        wget
      ];
    };
    audio = self.buildEnv {
      name = "myAudio";
      paths = with self; [
        pythonPackages.beets
        flac
        lame
        mpd
        ncmpcpp
        pavucontrol
        pulseaudio
      ];
    };
    communication = self.buildEnv {
      name = "myCommunication";
      paths = with self; [
        mumble
        pidgin
        #kde4.quasselClient
      ];
    };
    desktop = self.haskellPackages.ghcWithPackages (self : with self; [ xmonad ]);
    development = self.buildEnv {
      name = "myDevelopment";
      paths = with self; [
        #icedtea7_web
        #nix-repl
        #nixops
        subversion
        texLive
      ];
    };
    download = self.buildEnv {
      name = "myDownload";
      paths = with self; [
        filezilla
        ncdc
        qbittorrent
        rtorrent-git
        transmission
        youtubeDL
      ];
    };
    editors = self.buildEnv {
      name = "myEditors";
      paths = with self; [
        atom
        emacs
        #libreoffice
        sublime3
        texstudio
        vim
      ];
    };
    haskell = self.buildEnv {
      name = "myHaskell";
      paths = with self; [
        haskell.packages_ghc763
        haskellPackages.xdgBasedir
      ];
    };
    headless = self.buildEnv {
      name = "myHeadless";
      paths = with self; [
        acpi
        bc
        conky
        dmenu
        dzen2
        #gnupg1compat
        mosh
        most
        #notbit
        p7zip
        pcsclite
        pinentry
        psmisc
        scrot
        unzip
        #xlibs.xbacklight
        #zathura
      ];
    };
    image = self.buildEnv {
      name = "myImage";
      paths = with self; [
        gimp
        imagemagick
        libpng
      ];
    };
    monitoring = self.buildEnv {
      name = "myMonitoring";
      paths = with self; [
        ncdu
        speedtest_cli
      ];
    };
    networking = self.buildEnv {
      name = "myNetworking";
      paths = with self; [
        networkmanager
        networkmanagerapplet
      ];
    };
    shells = self.buildEnv {
      name = "myShells";
      paths = with self; [
        fish
        #zsh
      ];
    };
    terminals = self.buildEnv {
      name = "myTerminals";
      paths = with self; [
        sakura
      ];
    };
    video = self.buildEnv {
      name = "myVideo";
      paths = with self; [
        ffmpeg
        #mediainfo
        mkvtoolnix
        vlc
        vobsub2srt
        x264
      ];
    };
    virtualization = self.buildEnv {
      name = "myVirtualization";
      paths = with self; [
        virtmanager
      ];
    };
    www = self.buildEnv {
      name = "myWww";
      paths = with self; [
        chromium
        firefoxWrapper
      ];
    };
  };
}
