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
  ffmpeg.fdk = true;
  st.conf = (builtins.readFile ./st/config.mach.h)
    + (builtins.readFile ./st/config.inc.h);
  packageOverrides = self : rec {
    hsEnv = self.haskellPackages.ghcWithPackages (self : with self; [
      xmonad
      #yi
    ]);
    graphical = self.buildEnv {
      name = "myGraphical";
      paths = with self; [
        # Envs
        #cs225
        #dev
        #orpheum
        #shell
        #profile
        #mumc

        # Pkgs
        bc
        pythonPackages.beets
        chromium
        conky
        dmenu
        dzen2
        emacs
        ffmpeg
        firefoxWrapper
        filezilla
        flac
        gimp
        #gnupg1compat
        hsEnv
        #icedtea7_web
        lame
        #libreoffice
        ##mediainfo
        mkvtoolnix
        mpd
        mumble
        ncdc
        ncdu
        ncmpcpp
        networkmanager
        networkmanagerapplet
        #nix-repl
        #nixops
        #notbit
        p7zip
        pavucontrol
        pcsclite
        pidgin
        pinentry
        pulseaudio
        kde4.quasselClient
        qbittorrent
        #rtorrent-git
        sakura
        scrot
        #sl
        speedtest_cli
        #st
        sublime3
        #sup
        texLive
        texstudio
        transmission
        #virtmanager
        vlc
        vobsub2srt
        haskellPackages.xdgBasedir
        x264
        #xlibs.xbacklight
        youtubeDL
        #zathura
      ];
    };
    profile = self.myEnvFun {
      name = "profile";
      buildInputs = with self; [
        (self.haskellPackages.ghcWithPackages (self : with self; [
          hakyll
        ]))
      ];
    };
    nongraphical = self.buildEnv {
      name = "myNonGraphical";
      paths = with self; [
        #dev
        shell
      ];
    };
    dev = self.buildEnv {
      name = "myDev";
      paths = with self; [
        cdrkit
        #python3Packages.ipython
        subversion
      ];
    };
    shell = self.buildEnv {
      name = "myShell";
      paths = with self; [
        acpi
        fish
        git
        htop
        mosh
        openssh_hpn
        openssl
        psmisc
        tmux
        unzip
        vim
        wget
      ];
    };
    mumc = self.myEnvFun {
      name = "mumble-connect";
      buildInputs = with self; [
        stdenv
        autoconf
        automake
        libtool
        pkgconfig
        valgrind
      ];
    };
    cs225 = self.myEnvFun {
      name = "cs225";
      buildInputs = with self; [
        gdb
        imagemagick
        libpng
        stdenv
        valgrind
      ];
    };
    orpheum = self.myEnvFun {
      name = "orpheum";
      buildInputs = (with self; [ python27
      #rubyLibs.sass_3_3_4
      ])
        ++ (with self.python27Packages; [
          django_1_5 google_api_python_client paypalrestsdk pil sorl_thumbnail six sqlite3
        ]);
    };
  };
}
