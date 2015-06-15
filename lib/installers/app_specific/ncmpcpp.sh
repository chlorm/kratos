app_ncmpcpp_installed() {

  path_hasbin "ncmpcpp" > /dev/null || return 1

  return 0

}

app_ncmpcpp_dirs() {

  exist -dc "$HOME/.ncmpcpp" || return 1

  return 0

}

app_ncmpcpp_dotfiles() {

  exist -fx "$HOME/.ncmpcpp/config"

(
cat <<NCMPCPP
##       ________   ___       ___
##      /  _____/  /  /      /  /
##     /  /       /  /      /  /
##    /  /       /  /____  /  / _______  _______  ____  ____
##   /  /       /  ___  / /  / /  __  / /  ____/ /    \\/    \\
##  /  /_____  /  /  / / /  / /  /_/ / /  /     /  /\\    /\\  \\
## /________/ /__/  /_/ /__/ /______/ /__/     /__/  \\__/  \\__\\ TM
##
## Title: Ncmpcpp Configuration File
## Author: Cody Opel
## E-mail: codyopel(at)gmail.com
## Copyright (c) 2014 All Rights Reserved, http://www.chlorm.net
## License: The MIT License - http://opensource.org/licenses/MIT
## Comments:
##    Assumed Directory & File Structure:
##      $HOME/.ncmpcpp/ ------------ ncmpcpp directory
##      $HOME/.ncmpcpp/config ------ ncmpcpp configuration file
##      $XDG_CONFIG_HOME/mpd/ --------- mpd directory
##      $XDG_CONFIG_HOME/mpd/lyrics --- mpd lyrics directory
##      $HOME/.tmp/mpd.fifo -------- mpd fifo ouput file

# MPD
mpd_host = localhost
mpd_port = 6600
mpd_music_dir = $XDG_MUSIC_DIR
mpd_connection_timeout = 5
mpd_crossfade_time = 5
#mpd_communication_mode = "notifications" (polling/notifications)
###################
# Global settings #
###################
ncmpcpp_directory = $HOME/.ncmpcpp
startup_screen = playlist
search_engine_default_search_mode = 1
allow_for_physical_item_deletion = no
#
# Colors
colors_enabled = yes
empty_tag_color = yellow
state_line_color = white
state_flags_color = white
main_window_color = cyan
main_window_highlight_color = white
alternative_ui_separator_color = green
active_column_color = magenta
#
# Formatting
titles_visibility = yes
jump_to_now_playing_song_at_start = yes
ignore_leading_the = yes
centered_cursor = yes
lines_scrolled = 5
autocenter_mode = yes
browser_display_mode = columns
search_engine_display_mode = classic
discard_colors_if_item_is_selected = yes
#
# Mouse Support
mouse_support = yes
mouse_list_scroll_whole_page = yes
#
# Lyrics
## supported lyrics databases:
## - 1 - lyricsplugin.com
#lyrics_database = 1
lyrics_directory = $XDG_CONFIG_HOME/mpd/lyrics
follow_now_playing_lyrics = no
store_lyrics_in_song_dir = no
external_editor = nano
use_console_editor = yes
lastfm_preferred_language = en
#
# Delays
playlist_disable_highlight_delay = 5
message_delay_time = 3
#
# Search
default_place_to_search_in = database
#
# Window Title
enable_window_title = yes
song_window_title_format = {%a - }{%t}|{%f}
#
# Header
user_interface = alternative
alternative_header_first_line_format = \$0{%a}\$9 \$3•\$9 \$6{%y - %b}\$9
alternative_header_second_line_format ={\$7%t\$8}
header_window_color = white
volume_color = yellow
clock_display_seconds = yes
display_volume_level = yes
display_bitrate = yes
display_remaining_time = no
header_visibility = yes
#display_screens_numbers_on_start = no
header_text_scrolling = yes
cyclic_scrolling = no
#
# Progress Bar
progressbar_look = ─░─
progressbar_color = green
#
# Status Bar
statusbar_visibility = yes
song_status_format = {\$8%a} \$3• \$b{\$6%b}\$1\$/b
# Status bar warning messages
statusbar_color = yellow
################
# Tab Settings #
################
#
# Playlist tab
playlist_display_mode = columns
song_list_format = {$8%a\$9}\$3•\$9{\$6%y - %b\$9}\$3•\$9{\$7%t\$9}|{\$7%f\$9}\$7\$R{\$3(\$b%l\$/b)\$9}
song_columns_list_format = (6)[green]{l:Length} (20)[white]{a:Artist} (5)[magenta]{y:Year} (30)[magenta]{b:Album} (50)[cyan]{t|f:Track}
now_playing_prefix = \$9
now_playing_suffix =  \$4♫\$9
ask_before_clearing_playlists = yes
playlist_show_remaining_time = yes
playlist_shorten_total_times = yes
#
# Browser Tab
browser_sort_mode = format
browser_sort_format = {\$8%a - }{\$7%t}|{\$7%f} {(\$3%l)}
#
# Media Library Tab
media_library_primary_tag = artist
#
# Tag Editor Tab
default_tag_editor_pattern = %n - %t
tag_editor_album_format = {\$8%a} - {\$7%b}
empty_tag_marker = <empty>
#tags_separator =  | 
#tag_editor_extended_numeration = no
#
# Visualizer Tab
visualizer_fifo_path = $HOME/.tmp/mpd.fifo
visualizer_in_stereo = no
visualizer_sync_interval = 30
visualizer_type = spectrum
# (▉▉/●│/●▉/◆│)
visualizer_look = ▉▉
visualizer_color = white
#
## TODO: move the following to proper categories
#
song_library_format = {\$7%n - }{\$7%t}|{\$7%f}
#
seek_time = 1
## (wrapped/normal)
default_find_mode = wrapped
## (add/select)
#default_space_mode = "add"
## [enabled - add/remove, disabled - always add]
#ncmpc_like_songs_adding = "no"
#
#locked_screen_width_part = "50"
#
#ask_for_locked_screen_width_part = "yes"
## (basic/extended)
#regular_expressions = "basic"
#
#block_search_constraints_change_if_items_found = "yes"

NCMPCPP
) > "$HOME/.ncmpcpp/config" || return 1

  return 0

}

app_ncmpcpp_cleanup() {

  exist -dx "$HOME/.ncmpcpp"

}

app_ncmpcpp_configure() {

  app_ncmpcpp_installed || return 2
  app_mpd_installed || return 1

  app_ncmpcpp_dirs || return 1

  app_ncmpcpp_dotfiles || return 1

  return 0

}
