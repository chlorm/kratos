
shells_init() { # Initializes useful functions

  alias root="sudo_wrap su -"
  alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"
  alias nixpaste="curl -F 'text=<-' http://nixpaste.noip.me"
  #alias t='laptop_bat ; date'
  alias sha1="openssl sha1"
  alias sha256="openssl sha256"
  alias sha512="openssl sha512"
  alias youtube="youtube-dl --max-quality --no-check-certificate --prefer-insecure --console-title"
  alias music="ncmpcpp"
  alias tarxz="tar cjvf"
  alias emacs="emacs -nw"
  # Btrfs
  alias defragmentroot="sudo btrfs filesystem defragment -r -v /"
  alias defragmenthome="sudo btrfs filesystem defragment -r -v /home"
  # Gentoo
  if [ "$(os_linux)" = "gentoo" ] ; then
    alias inst="sudo emerge --ask"
    alias search="emerge --search"
    alias uses="equery uses"
    alias layup="sudo layman -S"
  fi

  # Environment Variables

  if [ "$PREFERED_EDITOR" = "emacs" ] ; then
    export EDITOR="emacs -nw"
  else
    export EDITOR="$PREFERED_EDITOR"
  fi
  export PAGER="less -r"
  export BLOCKSIZE="K"
  # Locale/UTF-8
  export LANG=en_US.UTF-8
  export LANGUAGE=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
  export LESSCHARSET=utf-8
  export PERL_UTF8_LOCALE=1
  export PERL_UNICODE=AS
  # Prevent GUI password dialog
  unset SSH_ASKPASS

}
