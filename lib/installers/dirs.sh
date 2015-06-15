# XDG freedesktop directories

# XDG_CACHE_HOME
exist -dc "$HOME/.cache"
# XDG_CONFIG_HOME
exist -dc "$HOME/.config"
# XDG_DATA_HOME
exist -dc "$HOME/.local/share"
# XDG_DESKTOP_DIR
exist -dc "$HOME/Desktop"
# XDG_DOCUMENTS_DIR
exist -dc "$HOME/Documents"
# XDG_DOWNLOAD_DIR
exist -dc "$HOME/Downloads"
# XDG_MUSIC_DIR
exist -dc "$HOME/Music"
# XDG_PICTURES_DIR
exist -dc "$HOME/Pictures"
# XDG_PUBLICSHARE_DIR
exist -dc "$HOME/Share"
# XDG_TEMPLATES_DIR
exist -dc "$HOME/Templates"
# XDG_VIDEOS_DIR
exist -dc "$HOME/Videos"


# Freedesktop trash directories

# DIR_TRASH_INFO
exist -dc "$HOME/"
# DIR_TRASH_FILES
exist -dc "$HOME/"


# Custom directories

exist -dc "$HOME/dev"