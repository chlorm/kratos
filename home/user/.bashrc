# /etc/skel/.bashrc

# Test for an interactive shell.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# Bash Prompt »
PS1="\[\e[1;32m\]\u\[\e[30m\]@\[\e[37m\]\h\[\e[30m\] [\[\e[1;35m\]\w\[\e[30m\]]\[\e[1;37m\]:\[\e[0m\] \[\e[1;36m\]"

# ls Command Custom Highlighting
LS_COLORS='no=00:fi=00:di=01;35:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.7z=01;34:*.iso=01;34:*.tar=01;34:*.tgz=01;34:*.zip=01;34:*.gz=01;34:*.bz2=01;34:*.deb=01;34:*.rpm=01;34:*.jar=01;34:*.xz=01;34:*.jpg=01;33:*.jpeg=01;33:*.gif=01;33:*.bmp=01;33:*.tga=01;33:*.xbm=01;33:*.tif=01;35:*.tiff=01;33:*.png=01;33:*.avc=01;32:*.h264=01;32:*.h265=01;32:*.hevc=01;32:*.hvc=01;32:*.mkv=01;32:*.mov=01;32:*.mpg=01;32:*.mpeg=01;32:*.avi=01;32:*.flv=01;32:*.mp4=01;32:*.ape=01;31:*.flac=01;31:*.mp3=01;31:*.mpc=01;31:*.ogg=01;31:*.wav=01;31:';
export LS_COLORS

# Aliases
alias sha1="openssl sha1"
alias sha256="openssl sha256"
alias sha512="openssl sha512"

# Gentoo Specific Aliases
alias inst="sudo emerge --ask"
alias search="emerge --search"
alias uses="equery uses"
alias untargz="tar xzvf"
alias untarxz="tar xjvf"
alias tarxz="tar cjvf"
update() {
	sudo emerge --sync
	sudo emerge --ask --update --deep --with-bdeps=y --newuse --keep-going @world
}
# List all packages from overlays with corresponding name
fromover() {
	for i in /var/db/pkg/*/*
	do if ! grep gentoo $i/repository >/dev/null
	then echo -e "`basename $i`\t`cat $i/repository`"
	fi
	done
}
