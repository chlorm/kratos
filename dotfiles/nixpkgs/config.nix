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
  ffmpeg = {
    fdk = true;
  };
  # Suckless
  st.conf = (builtins.readFile ./st/config.mach.h)
    + (builtins.readFile ./st/config.inc.h);

  packageOverrides = self : rec {
    rtorrent-git = self.rtorrent-git.override { colorSupport = true; };
    desktop-chlorm = self.haskellPackages.ghcWithPackages (self : with self; [
      xmonad
      #yi
    ]);
    # Import Environments
    chlorm = self.buildEnv {
      name = "myChlorm";
      paths = with self; [
        # Required
        base-chlorm
        # Optional
        audio-chlorm
        communication-chlorm
        desktop-chlorm
        development-chlorm
        download-chlorm
        editors-chlorm
        haskell-chlorm
        headless-chlorm
        image-chlorm
        monitoring-chlorm
        networking-chlorm
        shells-chlorm
        terminals-chlorm
        video-chlorm
        virtualization-chlorm
        www-chlorm
	# Unsorted
	xfe
      ];
    };
    # Environments
    base-chlorm = self.buildEnv {
      name = "myBase";
      paths = with self; [
        git
        htop
        #openssh_hpn
	openssh
        openssl
        slock
        tmux
        wget
      ];
    };
    audio-chlorm = self.buildEnv {
      name = "myAudio";
      paths = with self; [
        beets
        flac
        lame
        mpd
        ncmpcpp
        pavucontrol
        pulseaudio
      ];
    };
    communication-chlorm = self.buildEnv {
      name = "myCommunication";
      paths = with self; [
        mumble
        pidgin
        kde4.quasselClient
      ];
    };
    development-chlorm = self.buildEnv {
      name = "myDevelopment";
      paths = with self; [
        go
        #icedtea7_web
        #nix-repl
        #nixops
        subversion
        texLive
      ];
    };
    download-chlorm = self.buildEnv {
      name = "myDownload";
      paths = with self; [
        filezilla
        ncdc
        #qbittorrent
        rtorrent-git
        #transmission
        youtubeDL
      ];
    };
    editors-chlorm = self.buildEnv {
      name = "myEditors";
      paths = with self; [
        atom
        emacs
        libreoffice
        sublime3
        texstudio
        vim
      ];
    };
    haskell-chlorm = self.buildEnv {
      name = "myHaskell";
      paths = with self; [
        haskellPackages.xdgBasedir
      ];
    };
    headless-chlorm = self.buildEnv {
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
	xz
        #zathura
      ];
    };
    image-chlorm = self.buildEnv {
      name = "myImage";
      paths = with self; [
        geeqie
        gimp
        imagemagick
        libpng
      ];
    };
    monitoring-chlorm = self.buildEnv {
      name = "myMonitoring";
      paths = with self; [
        ncdu
        speedtest_cli
      ];
    };
    networking-chlorm = self.buildEnv {
      name = "myNetworking";
      paths = with self; [
        networkmanager
        networkmanagerapplet
      ];
    };
    shells-chlorm = self.buildEnv {
      name = "myShells";
      paths = with self; [
        fish
        #zsh
      ];
    };
    terminals-chlorm = self.buildEnv {
      name = "myTerminals";
      paths = with self; [
        sakura
      ];
    };
    video-chlorm = self.buildEnv {
      name = "myVideo";
      paths = with self; [
        ffmpeg
        mediainfo
        mkvtoolnix
        vlc
        vobsub2srt
        x264
        x265
        #x265-hg
      ];
    };
    virtualization-chlorm = self.buildEnv {
      name = "myVirtualization";
      paths = with self; [
        virtmanager
      ];
    };
    www-chlorm = self.buildEnv {
      name = "myWww";
      paths = with self; [
        chromium
        firefoxWrapper
      ];
    };
  };
}
