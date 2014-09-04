##       ________   ___       ___
##      /  _____/  /  /      /  /
##     /  /       /  /      /  /
##    /  /       /  /____  /  / _______  _______  ____  ____
##   /  /       /  ___  / /  / /  __  / /  ____/ /    \/    \
##  /  /_____  /  /  / / /  / /  /_/ / /  /     /  /\    /\  \
## /________/ /__/  /_/ /__/ /______/ /__/     /__/  \__/  \__\ TM
##
## Title: Local BashRC Configuration File
## Author: Cody Opel
## E-mail: codyopel(at)gmail.com
## Copyright (c) 2014 All Rights Reserved, http://www.chlorm.net
## License: The MIT License - http://opensource.org/licenses/MIT
## Comments:
##    Assumed Directory & File Structure:
##      ~/.bashrc
##    Legend:
##      () - option
##      [] - description
##      ## - comments [not to be uncommented]
##      # -- commented variables

## [http://en.wikipedia.org/wiki/Unicode_symbols]

export XDG_DATA_HOME="/home/$USER/.local/share"
export XDG_CONFIG_HOME="/home/$USER/.config"
export XDG_CACHE_HOME="/home/$USER/.cache"
export XDG_DOWNLOAD_DIR="/home/$USER/Downloads"

## Test for an interactive shell.
if [[ $- != *i* ]] ; then
	## Shell is non-interactive.  Be done now!
	return
fi

export LANGUAGE="en_US:en"

# [git branch details for bash prompt]
function parse_git_dirty {
    [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "*"
}
function parse_git_branch {
    git branch --no-color 2> /dev/null | \
    sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

## [bash prompt »]
PS1="\[\e[1;32m\]\u\[\e[30m\]@\[\e[37m\]\h\[\e[30m\][\[\e[1;35m\]\w\[\e[30m\]]\[\e[1;37m\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \"\[\e[1;32m\]git\[\e[1;30m\]∫\")\[\e[1;37m\]\$(parse_git_branch)\[\e[0m\]\[\e[36m\]〉"

## [ls colors]
#LS_COLORS='no=00:fi=00:di=01;35:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.7z=01;34:*.iso=01;34:*.tar=01;34:*.tgz=01;34:*.zip=01;34:*.gz=01;34:*.bz2=01;34:*.deb=01;34:*.rpm=01;34:*.jar=01;34:*.xz=01;34:*.jpg=01;33:*.jpeg=01;33:*.gif=01;33:*.bmp=01;33:*.tga=01;33:*.xbm=01;33:*.tif=01;35:*.tiff=01;33:*.png=01;33:*.avc=01;32:*.h264=01;32:*.h265=01;32:*.hevc=01;32:*.hvc=01;32:*.mkv=01;32:*.mov=01;32:*.mpg=01;32:*.mpeg=01;32:*.avi=01;32:*.flv=01;32:*.mp4=01;32:*.ape=01;31:*.flac=01;31:*.mp3=01;31:*.mpc=01;31:*.ogg=01;31:*.wav=01;31:';
#export LS_COLORS

## TODO: Create global color scheme and export variables

## [aliases]
alias sha1="openssl sha1"
alias sha256="openssl sha256"
alias sha512="openssl sha512"
alias youtube="youtube-dl --max-quality --no-check-certificate --prefer-insecure --console-title"
alias music="ncmpcpp"
alias tarxz="tar cjvf"

## [gentoo specific]
alias inst="sudo emerge --ask"
alias search="emerge --search"
alias uses="equery uses"
alias layup="sudo layman -S"
function update {
    sudo emerge --sync
    sudo emerge --ask --update --deep --with-bdeps=y --newuse --keep-going @world
    ## TODO: add all 9999 and recompile on update [in order of dependencies]
    ## x265,libvpx,ffmpeg,vlc,rtorrent
}
## [list all packages from overlays with corresponding overlay name]
function fromover {
    for i in /var/db/pkg/*/*; do
        if ! grep gentoo $i/repository >/dev/null; then
            echo -e "`basename $i`\t`cat $i/repository`"
        fi
    done
}

#[btrfs]
alias defragmentroot="sudo btrfs filesystem defragment -r -v -czlib /"
alias defragmenthome="sudo btrfs filesystem defragment -r -v /home"

function extract {
    if [ -f $1 ]; then
        case $1 in
            *.tar) tar xf $1 ;;
            *.tar.bz2) tar xjf $1 ;;
            *.tbz2) tar xjf $1 ;;
            *.bz2) bunzip2 $1 ;;
            *.tar.gz) tar xzf $1 ;;
            *.tgz) tar xzf $1 ;;
            *.gz) gunzip $1 ;;
            *.tar.xz) tar xJf $1 ;;
            *.txz) tar xJf $1 ;;
            *.rar) unrar e $1 ;;
            *.zip) unzip $1 ;;
            *.Z) uncompress $1 ;;
            *.7z) 7z x $1 ;;
            *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# [color man pages]
## TODO: update color scheme to match global
function man {
    env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

## [for generating icons]
## TODO: modify to be a single function that takes an argument for the icon size
icongen16 () {
    for i in $( ls *.png)
    do convert -resize 16x16^ -gravity center -extent 16x16 -background none $i 16_$i
    done
}
icongen22 () {
    for i in $( ls *.png)
    do convert -resize 22x22^ -gravity center -extent 22x22 -background none $i 22_$i
    done
}
icongen24 () {
    for i in $( ls *.png)
    do convert -resize 24x24^ -gravity center -extent 24x24 -background none $i 24_$i
    done
}
icongen32 () {
    for i in $( ls *.png)
    do convert -resize 32x32^ -gravity center -extent 32x32 -background none $i 32_$i
    done
}
icongen48 () {
    for i in $( ls *.png)
    do convert -resize 48x48^ -gravity center -extent 48x48 -background none $i 48_$i
    done
}
icongen64 () {
    for i in $( ls *.png)
    do convert -resize 64x64^ -gravity center -extent 64x64 -background none $i 64_$i
    done
}
icongen96 () {
    for i in $( ls *.png)
    do convert -resize 96x96^ -gravity center -extent 96x96 -background none $i 96_$i
    done
}
icogen96 () {
    for i in $( ls *.ico)
    do convert -resize 96x96^ -gravity center -extent 96x96 -background none $i 96_$i.png
    done
}