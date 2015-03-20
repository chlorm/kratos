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

  # Suckless
  st.conf = (builtins.readFile ./st/config.mach.h)
    + (builtins.readFile ./st/config.inc.h);

  packageOverrides = self : rec {

    emacs = self.emacs.override {
      withX = false;
    };

    ffmpeg = self.ffmpeg.override {

      nonfreeLicensing = true;

      gnutls = null;
      opensslExtlib = true;

      #decklinkExtlib = true;
      fdk-aacExtlib = true;
      openglExtlib = true;
      sambaExtlib = true;

    };

    rtorrent-git = self.rtorrent-git.override {
      colorSupport = true;
    };

    x265-hg = self.x265-hg.override {
      highBitDepth = true;
    };

    desktop-chlorm = self.haskellPackages.ghcWithPackages (self : with self; [
      haskellPackages.xdgBasedir
      xmonad
      #yi
    ]);

    # Import Environments
    chlorm = self.buildEnv {
      name = "myChlorm";
      paths = with self; [
        base-chlorm
        headless-chlorm
        graphical-chlorm
        beets
        mpd
        ncmpcpp
      ];
    };
    # Environments
    base-chlorm = self.buildEnv {
      name = "myBase";
      paths = with self; [
        bc
        emacs
        git
        htop
        openssh #_hpn
        openssl
        slock
        tmux
        vim
        wget
        zsh
      ];
    };
    graphical-chlorm = self.buildEnv {
      name = "myGraphical";
      paths = with self; [
        chromium
        conky
        dmenu
        dzen2
        filezilla
        firefoxWrapper
        geeqie
        gimp
        #libreoffice
        mumble
        networkmanagerapplet
        pavucontrol
        pidgin
        #qbittorrent
        kde4.quasselClient
        sakura
        sublime3
        texLive
        texstudio
        #transmission
        virtmanager
        vlc
        xfe
      ];
    };
    headless-chlorm = self.buildEnv {
      name = "myHeadless";
      paths = with self; [
        acpi
        ffmpeg_2_6
        fish
        flac
        #gnupg1compat
        go
        #icedtea7_web
        imagemagick
        lame
        libpng
        libvpx-git
        mediainfo
        mkvtoolnix
        mosh
        most
        ncdc
        ncdu
        networkmanager
        #nix-repl
        #nixops
        #notbit
        p7zip
        pcsclite
        pinentry
        psmisc
        pulseaudio
        rtorrent-git
        scrot
        speedtest_cli
        subversion
        unzip
        vobsub2srt
        x264
        x265-hg
        #xlibs.xbacklight
        xz
        youtubeDL
        #zathura
        zsh
      ];
    };
  };
}