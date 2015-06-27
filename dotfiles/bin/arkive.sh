#!/usr/bin/env bash
##       ________   ___       ___
##      /  _____/  /  /      /  /
##     /  /       /  /      /  /
##    /  /       /  /____  /  / _______  _______  ____  ____
##   /  /       /  ___  / /  / /  __  / /  ____/ /    \/    \
##  /  /_____  /  /  / / /  / /  /_/ / /  /     /  /\    /\  \
## /________/ /__/  /_/ /__/ /______/ /__/     /__/  \__/  \__\ TM
##
## Title: ARKhive
## Author: Cody Opel
## E-mail: codyopel(at)gmail.com
## Copyright (c) 2014 All Rights Reserved, http://www.chlorm.net
## License: The MIT License - http://opensource.org/licenses/MIT
## Comments:
##    Dependencies:
##      bash
##      coreutils (cp, basename, dirname, pwd, rm, tail)
##      fdkaac
##  ??? findutils
##      ffmpeg (libfdkaac, libopus, libvorbis, threads) >=2.3.x
##      gawk
##      grep
##      mkvtoolnix (mkvextract, mkvmerge)
##      libopus
##      libvorbis
##      VobSub2SRT
##      x265 >=1.5.x

# VIDEO: h.265 (High Efficiency Video Coding)
# AUDIO: AC-3 (Audio Codec 3)
# Subtitles: ASS (Advanced SubStation Alpha)
# Chapters: ??? xml ???
# Container: mkv (Matroska)

VERSION="3"

# Terminal Colors
clR="\033[1;31m"  # Red
clG="\033[1;32m"  # Green
clW="\033[1;37m"  # White
clP="\033[1;35m"  # Purple
clGa="\033[0;30m" # Gray
clC="\033[0;36m"  # Cyan (light blue)
clY="\033[0;33m"  # Yellow
clU="\033[0;4m"   # Underline
clD="\033[0;0m"   # default

arkhive_usage() {

cat <<ARKIVEUSAGE
${clC}ARKhive version:${clG} ${VERSION}
${clC}Automated video encoding according to Chlorm's ARK specifications.

Usage: ${clD}arkhive [${clU}${clP}OPTIONS$clD] ${clU}${clP}FILE$clD [${clU}${clP}OPTIONS$clD]$clD
    $clG-i|--input  ${clU}${clP}FILE\$clD          $clY*$clD - set input file$clD
    $clG-o|--output ${clU}${clP}DIRECTORY$clD       - set output directory$clD
    $clG-t|--temp   ${clU}${clP}DIRECTORY$clD       - set temp directory$clD
    $clG-h|--help\$clD                   - print this message
    $clG-v|--version\$clD                - print version
ARKIVEUSAGE

}

# Tests to see if a binary exists in the path
path_hasbin() {

  [ "$#" -ne "1" ] && return 2
  type $1 > /dev/null 2>&1

}

# Check for ffmpeg compile flag
ffmpeg_compile_option() {

  hasFFmpegLib=$(ffmpeg 2>&1 | grep -o "enable-${1}")

  [ -z "$hasFFmpegLib" ] && {
    echo "ERROR: FFmpeg not compiled with: '${1}'"
    return 1
  }

}

# Dependencies
path_hasbin vobsub2srt || { echo "ERROR: 'vobsub2srt' is not installed" ; exit 1 ; }
path_hasbin awk || { echo "ERROR: 'awk' is not installed" ; exit 1 ; }
path_hasbin dirname || { echo "ERROR: 'dirname' is not installed" ; exit 1 ; }
path_hasbin grep || { echo "ERROR: 'grep' is not installed" ; exit 1 ; }
path_hasbin pwd || { echo "ERROR: 'pwd' is not installed" ; exit 1 ; }
path_hasbin rm || { echo "ERROR: 'rm' is not installed" ; exit 1 ; }
path_hasbin tail || { echo "ERROR: 'tail' is not installed" ; exit 1 ; }
path_hasbin x265 || { echo "ERROR: 'x265' is not installed" ; exit 1 ; }
path_hasbin ffmpeg || { echo "ERROR: 'ffmpeg' is not installed" ; exit 1 ; }

#ffmpeg_compile_option libass # substation alpha subtitles
#ffmpeg_compile_option libzvbi # Enable support for decoding DVB Teletext Subtitles

# Check for input
if [ -z "$1" ] ; then
  echo -e "${clR}ERROR: No arguments provided"
  exit 1
else
  # Parse Arguments
  while [ "$1" ] ; do

    case "$1" in

      '-i'|'--input')
        if [ -z "$2" ] ; then
          echo -e "${clR}ERROR: No input provided"
          exit 1
        elif [ -d "$2" ] ; then
          userInput="$2"
          shift
        elif [ -f "$2" ] ; then
          inputFileExt=${2##*.}

          case "$inputFileExt" in

            'avi'|'f4v'|'flv'|'m4v'|'mkv'|'mp4'|'mpeg'|'mpg'|'mov'|'ts'|'wmv')
              userInput="$2"
              shift
              ;;

            'm2ts')
              m2tsAudioStreamArray=($(\
                ffprobe -i ${inputFile} 2>&1 | \
                grep "Audio:" | \
                awk '/Stream\ #0:/ { print $2 }' | \
                grep -o -P '(?<=\#0\:)[0-9](?=\([a-z]+\)|\[[0-9]+x[0-9]+\]|\:)'))

              # Find total number of audio streams in the container
              m2tsAudioStreamCount=$(${#m2tsAudioStreamArray[@]})

              m2tsSubtitleStreamArray=($(\
                ffprobe -i ${inputFile} 2>&1 | \
                grep "Subtitle:" | \
                awk '/Stream\ #0:/ { print $2 }' | \
                grep -o -P '(?<=\#0\:)[0-9](?=\([a-z]+\)|\[[0-9]+x[0-9]+\]|\:)'))

              # Find total number of subtitle streams in the container
              m2tsSubtitleStreamCount=$(${#m2tsSubtitleStreamArray[@]})

              if [ ${m2tsAudioStreamCount} == "1" ] && [ ${m2tsSubtitleStreamCount} -le "1" ] ; then
                userInput=$2
                shift
              else
                echo -e "${clR}ERROR: unsupported format"
                echo "ARKhive cannot handle 'm2ts' files with multiple audio or"
                echo "subtitle streams, they do not contain stream language codes"
                echo "Please remux the 'm2ts' to mkv or another supported format"
                exit 1
              fi
              ;;

            *)
              printf "${clR}ERROR: Selected file is not a supported format!\n"
              printf "${clY}Supported: avi,f4v,flv,m2ts,m4v,mkv,mp4,mpeg,mpg,mov,ts,wmv\n"
              exit 1
              ;;

          esac
        else
          printf "${clR}ERROR: Input file does not exist\n"
          exit 1
        fi
        ;;

      '-o'|'--output')
        if [ -z "$2" ] ; then
          echo -e "${clR}ERROR: No output directory provided"
          exit 1
        elif [ ! -d "$2" ] ; then
          echo -e "${clR}ERROR: Output is not a directory"
          exit 1
        else
          userOutput=$2
          shift
        fi
        ;;

      '-t'|'--temp')
        if [ -z "$2" ] ; then
          echo -e "${clR}ERROR: No temp directory provided"
          exit 1
        elif [ ! -d "$2" ] ; then
          echo -e "${clR}ERROR: Temp is not a directory"
          exit 1
        else
          userTemp="$2"
          shift
        fi
        ;;

      '-h'|'--help')
        eval "printf \"${HELP}\""
        exit 1
        ;;

      '-v'|'--version')
        printf "ARKhive version: ${VERSION}\n\n"
        exit 1
        ;;

      -*)
        eval "printf \"${HELP}\""
        printf "\n${clR}ERROR: Unknown option $1\n"
        exit 1
        ;;

      *)
        if [ -n "${1}" ] ; then
          eval "printf \"${HELP}\""
          printf "\n${clR}ERROR: Unknown option $1\n"
          exit 1
        elif [ ! -r "${1}" ] ; then
          printf "${clR}ERROR: Unable to read $1\n"
          exit 1
        else
          INPATH="$1"
        fi
        ;;

    esac
    shift

  done
fi

# Confirm user has provided input
[ -z "$userInput" ] && {
  eval "printf \"${HELP}\""
  echo -e "${clR}ERROR: no input provided"
  exit 1
}

# Find number of cpu's (physical, not logical cores)
export cpuCores=$(awk '/^cpu\ cores/ { print $4 ; exit }' /proc/cpuinfo | grep -o '[0-9]*')
[ -z "$cpuCores" ] && { cpuCores="1" ; }

input_directory() {

  cd $(dirname ${inputFile})
  pwd

}

output_directory() {

  if [ -z "${userOutput}" ] ; then
    input_directory
  else
    cd ${userOutput}
    pwd
  fi

}

temp_directory() {

  if [ -z "${userTemp}" ] ; then
    input_directory
  else
    cd ${userTemp}
    pwd
  fi

}

filename_orginal() {

  # Input filename w/ ext
  basename "$inputFile"

}

filename_base() {

  # Input filename w/o ext
  filename_orginal | sed -r 's/\.[[:alnum:]]+$//'

}

filename_handler() {

  # TODO: eventually this should handle more parsing, but for now, fuck it, ship it

  # Add tag
  arkMark="-ARK"
  echo "$(filename_base)$arkMark"

}

chapter_stream_extractor() {

  ## TODO: convert to use ffmpeg instead of mkvextract

    mkvextract \
      chapters \
      --simple ${inputFile} \
      --redirect-output $(temp_directory)/$(filename).xml || \
      { echo "WARNING: Failed to extract chapter stream" ; return 1 ; }

}

#############
# SUBTITLES #
#############

## TODO: case for subtitle without language set
## TODO: use for loop to find all english subs in file
##      after finding subs look for plain text subs
## TODO: parse vobsub2srt output and remove ERROR:... lines
## TODO: add support for PGS subtitles
##      if pgs use bdsup2sub to covert to sub/idx and then vobsub2srt

subtitle_stream_selector() {

  # Look for seperate subtitle file(s)
  if [ -f "$(input_directory)/$(filename_base).ass" ] ; then

    cp "$(input_directory)/$(filename_base).ass" "$(temp_directory)/$(filename).ass"

  elif [ -f "$(input_directory)/$(filename_base).srt" ] ; then

    ffmpeg -i $(input_directory)/$(filename_base).srt -an -vn -c:s:0 ass $(temp_directory)/$(filename_handler).ass

  elif [ -n "$hasSubtitles" ] ; then

    # Finds first english subtitle stream]
    subtitleStream=$(\
      ffmpeg -i ${userInput} -f null - 2>&1 | \
      grep -m 1 -o -P '(?<=Stream).*(?=\(eng\):\ Subtitle)' | \
      awk -F ":" '{print $2}' | tail -1)

    if [ -z "${subtitleStream}" ] ; then
      echo "No english subtitles found"
    fi

  else

    echo "No subtitle stream found"

  fi

}

subtitle_stream_extractor() {

  # Extract subtitles to ASS or VOBSub format

  # https://github.com/FFmpeg/FFmpeg/blob/master/libavcodec/codec_desc.c

  subtitleFormat=$(ffprobe ${inputFile} | grep "subtitle format")

  case $subtitleFormat in

    '')
      echo "WARNING: could not detect subtitle format, not including subtitles"
      return 1
      ;;

##### More than likely none of this works, but it is here as an outline

    # Name, File Extension, Type, Line Break, Text Styling Support, Metadata Support, Timing Method, Timing Precision
    'ass') # Advanced SubStation Alpla, .ass/.ssa, Text, y, y, Elapsed Time, 10 milliseconds
      echo "ffmpeg -i ${inputFile} -an -vn -c:s:$(subtitle_stream_selector) copy $(temp_directory)/$(filename).ass"
      ;;

    'dvb_subtitle') # DVB Subtitles, (in DVB stream), bitmap, n, n, n, elapsed time, ???
      echo "ffmpeg -i ${inputFile} -an -vn -c:s:$(subtitle_stream_selector) dvd_subtitle $(temp_directory)/$(filename).sub/.idx ???"
      ;;

    'dvb_teletext') #???
      echo "ffmpeg -i ${inputFile} -an -vn -c:s:$(subtitle_stream_selector) copy $(temp_directory)/$(filename).ass"
      ;;

    'dvd_subtitle') # VOBSub, .sub+.idx, bitmap, n, n, n, elapsed time, 1 millisecond
      echo "ffmpeg(extract) -> vobsub2srt -> ass"
      ;;

    'hdmv_pgs_subtitle') # Blu-Ray, (pgs), bitmap, n, n, n, elapsed time, ???
      echo "ffmpeg(extract) -> bdsup2sub -> vobsub2srt -> ass"
      ;;

    'jacosub') # JACOSub, .jss, Text w/markup, y, n, elapsed time, frame
      echo "ffmpeg -i ${inputFile} -an -vn -c:s:$(subtitle_stream_selector) ass $(temp_directory)/$(filename).ass"
      ;;

    'microdvd') # MicroDVD, .sub, Text, n, n, frame, frame
      echo "ffmpeg -i ${inputFile} -an -vn -c:s:$(subtitle_stream_selector) ass $(temp_directory)/$(filename).ass"
      ;;

    'mov_text') #MPEG-4 Timed Text, Text, ???
      echo "ffmpeg -i ${inputFile} -an -vn -c:s:$(subtitle_stream_selector) ass $(temp_directory)/$(filename).ass"
      ;;

    'mpl2') # MPL2, ???, Text ???, ???, ???, ???, ???
      echo "ffmpeg -i ${inputFile} -an -vn -c:s:$(subtitle_stream_selector) ass $(temp_directory)/$(filename).ass"
      ;;

    'pjs') # Phoenix Subtitle, .pjs, Text, n, n, frame, frame
      echo "ffmpeg -i ${inputFile} -an -vn -c:s:$(subtitle_stream_selector) ass $(temp_directory)/$(filename).ass"
      ;;

    'realtext') # RealText, .rt, HTML, y, n, elapsed time, 10 Milliseconds
      echo "ffmpeg -i ${inputFile} -an -vn -c:s:$(subtitle_stream_selector) ass $(temp_directory)/$(filename).ass"
      ;;

    'sami') # SAMI, .smi, HTML, y, y, frame, frame
      echo "ffmpeg -i ${inputFile} -an -vn -c:s:$(subtitle_stream_selector) ass $(temp_directory)/$(filename).ass"
      ;;

    'ssa') # SubStation Alpla, .ass/.ssa, Text, y, y, Elapsed Time, 10 milliseconds
      echo "ffmpeg -i ${inputFile} -an -vn -c:s:0 ass -map ??? $(temp_directory)/$(filename).ass"
      ;;

    'stl') # Spruce Subtitle Format, .stl, Text, y, y, Sequential Time+Frames, Sequential Time+Frames
      echo "ffmpeg -i ${inputFile} -an -vn -c:s:$(subtitle_stream_selector) ass $(temp_directory)/$(filename).ass"
      ;;

    'subrip'|'srt') # SubRip, .srt, Text, y, n, elapsed time, 1 Millisecond
      echo "ffmpeg -i ${inputFile} -an -vn -c:s:$(subtitle_stream_selector) ass $(temp_directory)/$(filename).ass"
      ;;

    'subviewer') # SubViewer v2, .sub, Text, n, y, elapsed time, 10 Milliseconds
      echo "ffmpeg -i ${inputFile} -an -vn -c:s:$(subtitle_stream_selector) ass $(temp_directory)/$(filename).ass"
      ;;

    'subviewer1') # SubViewer v1, .sub, Text, n, y, elapsed time, 10 Milliseconds
      echo "ffmpeg -i ${inputFile} -an -vn -c:s:$(subtitle_stream_selector) ass $(temp_directory)/$(filename).ass"
      ;;

    'text') # Raw UTF-8 Text
      echo "ffmpeg -i ${inputFile} -an -vn -c:s:$(subtitle_stream_selector) ass $(temp_directory)/$(filename).ass"
      ;;

    'vplayer') # VPlayer , .txt, Text, y, n, n, frame/time, 10 milliseconds
      echo "ffmpeg -i ${inputFile} -an -vn -c:s:$(subtitle_stream_selector) ass $(temp_directory)/$(filename).ass"
      ;;

    'webvtt') # WebVTT ???, ???, Text ???, ... ???
      echo "ffmpeg -i ${inputFile} -an -vn -c:s:$(subtitle_stream_selector) ass $(temp_directory)/$(filename).ass"
      ;;

    'xsub') # DivX XSUB, n/a (embedded in divx container), image, n, n, elapsed time, 1 Millisecond
      echo "ffmpeg -i ${inputFile} -an -vn -c:s:$(subtitle_stream_selector) ass $(temp_directory)/$(filename).ass"
      ;;

    *|'eia_608')
      echo "WARNING: unsupported subtitle format, not including subtitles"
      return 1
      ;;

  esac

}

subtitle_ass_parser() {

  # Parses the ASS file and adds/fixes formatting
  echo "does nothing"

}

subtitle_format() {

  ffprobe "${inputFile}" | \
    grep -m 1 "Stream #0:$(subtitle_stream_selector)" | \
    grep -o "\(ass\|dvb_subtitle\|dvb_teletext\|hdmv_pgs_subtitle\|jacosub\|microdvd\|mov_text\|mpl2\|pjs\|\
               realtext\|sami\|srt\|ssa\|stl\|subrip\|subviewer\|subviewer1\|text\|vplayer\|webvtt\)"

}

subtitle_type() {

  echo "not implemented"
  return 0 # Exit, the following does nothing

  # Determines if subtitles are in a text or bitmap based format

  case $(subtitle_format) in

    '')
      echo "WARNING: could not detect subtitle format, not including subtitles"
      return 1
      ;;

    'ass'|'ssa'|'jacosub'|'microdvd'|'mov_text'|'mpl2'|'pjs'|'realtext'|'sami'|'srt'|'stl'|'subrip'|'subviewer'|'subviewer1'|'text'|'vplayer'|'webvtt')
      echo "text"
      ;;

    'dvb_subtitle'|'dvd_subtitle'|'hdmv_pgs_subtitle'|'xsub')
      echo "bitmap"
      ;;

    'dvb_teletext') #???
      echo "unknown"
      ;;

    *)
      echo "WARNING: unsupported subtitle format, not including subtitles"
      return 1
      ;;

  esac

}

subtitle_srt_converter() {

  # Check for VobSub and convert to SRT
  [ -f "$(temp_directory)/$(filename).idx" ] && [ -f "$(temp_directory)/$(filename).sub" ] && {
    echo "         Converting VobSub to SRT"
    vobsub2srt $(temp_directory)/$(filename) &> /dev/null || {
      echo "WARNING: failed to convert vobsub to srt"
      return 1
    }
  }

}

audio_stream_selector() {

# CONTAINERS WITH NO LANGUAGE CODES: avi,m2ts,ts

  # Add all streams with audio into an array
  # <There is a lot or trickery required to get the stream
  #  number that is container specific, so 'or' statements
  #  were added to grep to work around this>
  # RETESTED: mkv,mp4,m2ts
  audioStreamArray=($(\
    ffprobe -i ${inputFile} 2>&1 | \
    grep -o -P '(?<=Stream\ #0:)[0-9]+(?=\([a-z]+\):\ Audio:|\[[0-9]x[0-9]+\]:\ Audio:|:\ Audio:)'))

  # Find total number of audio streams in the container
  audioStreamCount="${#audioStreamArray[@]}"

  if [ -z "$audioStreamCount" ] ; then
    echo "ERROR: No audio streams found"
    return 1
  elif [ "$audioStreamCount" = "1" ] ; then
    # Set stream number to the only one found
    echo "${audioStreamArray[0]}"
  elif [ "$audioStreamCount" -gt "1" ] ; then

  # Find language of audio stream
  ffprobe -i ${inputFile} 2>&1 | \
    # Gets line of streams
    grep "Stream #0:1" | \
    # Pulls first part of line containing language
    awk '/Stream\ #0:1/ { print $2 }' | \
    # Pulls the three digit language code
    # ISO 639-2/B
    grep -m 1 -o -P '(?<=\#0\:1\().*(?=\):)'
  # 3 
    #  if only one audio stream take it
    #  if not, see if any audio streams contain english
    #    if so, see if there are multiples
    #      select best option 
    #  if not, see if there is anything other than "und"
    #  if not, see if there are multiple und
    #    if so, pick best option
  else
    echo "ERROR: Video has no audio"
    return 2
  fi

  # 4 Fuck Bitches

}
        
audio_input_sample_rate() {

  ffprobe -i ${userInput} 2>&1 | \
    grep -m 1 "Stream #0:${primaryAudioStream}" | \
    awk -F ", " '/Hz/ { print $2 }'

}

audio_sample_rate() {

  [ "$(audio_num_channels)" == "2" ] && {
    echo "44100"
    return 0
  }

  [ "$(audio_num_channels)" == "6" ] && {
    echo "48000"
    return 0
  }

  return 1

}

audio_bitrate() {

  [ "$(audio_num_channels)" == "2" ] && {
    echo "256"
    return 0
  }

  [ "$(audio_num_channels)" == "6" ] && {
    echo "640"
    return 0
  }

  return 1

}

audio_source_channel_layout() {

  ffprobe -i ${inputFile} 2>&1 | \
    grep -m 1 "Stream #0:$(audio_stream_selector)" | \
    grep -o -P "(?<=$(audio_input_sample_rate) Hz, ).+(?=, [a-z]+)"

}

audio_num_channels() {

  case "$(audio_source_channel_layout)" in

    '')
      echo "ERROR: could not detect input file's number of audio channels"
      exit 1
      ;;

    'mono') # 1 -> 2
      echo "2"
      ;;

    'stereo') # 2 -> 2
      echo "2"
      ;;

    '2.1') # 3 -> 2
      echo "2"
      ;;

    '3.0') # 3 -> 2
      echo "2"
      ;;

    '3.0(back)') # 3 -> 2
      echo "2"
      ;;

    '4.0') # 4 -> 2
      echo "2"
      ;;

    'quad') # 4 -> 6
      echo "6"
      ;;

    'quad(side)') # 4 -> 6
      echo "6"
      ;;

    '3.1') # 4 -> 2
      echo "2"
      ;;

    '4.1') # 5 -> 2
      echo "2"
      ;;

    '5.0') # 5 -> 6
      echo "6"
      ;;

    '5.0(side)') # 5 -> 6
      echo "6"
      ;;

    '5.1') # 6 -> 6
      echo "6"
      ;;

    '5.1(side)') # 6 -> 6
      echo "6"
      ;;

    '6.0') # 6 -> 6
      echo "6"
      ;;

    '6.0(front)') # 6 -> 6
      echo "6"
      ;;

    'hexagonal') # 6 -> 6
      echo "6"
      ;;

    '6.1') # 7 -> 6
      echo "6"
      ;;

    '6.1(back)') # 7 -> 6
      echo "6"
      ;;

    '6.1(front)') # 7 -> 6
      echo "6"
      ;;

    '7.0') # 7 -> 6
      echo "6"
      ;;

    '7.0(front)') # 7 -> 6
      echo "6"
      ;;

    '7.1') # 8 -> 6
      echo "6"
      ;;

    '7.1(wide)') # 8 -> 6
      echo "6"
      ;;

    '7.1(wide-side)') # 8 -> 6
      echo "6"
      ;;

    'octagonal') # 8 -> 6
      echo "6"
      ;;

    'downmix') # 2 -> 2
      echo "2"
      ;;

    *)
      echo "ERROR: Unsupported channel layout"
      exit 1
      ;;

  esac

}

audio_channel_mapper() {

  # https://github.com/FFmpeg/FFmpeg/blob/master/libavutil/channel_layout.c
  # https://github.com/FFmpeg/FFmpeg/blob/master/doc/utils.texi

  # 0 = FL - Front Left
  # 1 = FR - Front Right
  # 2 = FC - Front Center
  # 3 = LFE - Low Frequency
  # 4 = BL - Back Left
  # 5 = BR - Back Fight
  # 6 = FLC - Front Left-of-Center <- Da Fuck is this shit (going to map them to FC for now)
  # 7 = FRC - Front Right-of-Center <- Da Fuck is this shit
  # 8 = BC - Back Center
  # 9 = SL - Side Left
  # 10 = SR - Side Right
  # 11 = TC - Top Center
  # 12 = TFL - Top Front Left
  # 13 = TFC - Top Front Center
  # 14 = TFR - Top Front Right
  # 15 = TBL - Top Back Left
  # 16 = TBC - Top Back Center
  # 17 = TBR - Top Back Right
  # 29 = DL - Downmix Left
  # 30 = DR - Downmix Right
  # 31 = WL - Wide Left
  # 32 = WR - Wide Right
  # 33 = SDL - Surround Direct Right
  # 34 = SDR - Surround Direct Left
  # 35 = LFE2 - Low Frequency 2

  # AC3 channel ordering

  # 0. FL
  # 1. FR
  # 2. FC
  # 3. LFE
  # 4. BL
  # 5. BR

  case "$(audio_source_channel_layout)" in

    '')
      echo "ERROR: could not detect input file's audio channel layout"
      return 1
      ;;
    'mono') # FC -> FL+FR
      echo "pan=stereo| FL < 0.5*FC | FR < 0.5*FC"
      ;;
    'stereo') # FL+FR -> FL+FR
      echo "pan=stereo| FL < FL | FR < FR"
      ;;
    '2.1') # FL+FR+LFE -> FL+FR
      echo "pan=stereo| FL < FL + LFE | FR < FR + LFE"
      ;;
    '3.0') # FL+FR+FC -> FL+FR
      echo "pan=stereo| FL < FL + 0.5*FC | FR < FR + 0.5*FC"
      ;;
    '3.0(back)') # FL+FR+BC -> FL+FR
      echo "pan=stereo| FL < FL + 0.5*BC | FR < FR + 0.5*BC"
      ;;
    '4.0') # FL+FR+FC+BC -> FL+FR
      echo "pan=stereo| FL < FL + 0.5*FC + BC | FR < FR + 0.5*FC + BC"
      ;;
    'quad') # FL+FR+BL+BR -> FL+FR+FC+LFE+BL+BR
      echo "pan=5.1| FL < FL | FR < FR | FC < FL + FR | LFE < FL + FR + BL + BR | BL < BL | BR < BR"
      ;;
    'quad(side)') # FL+FR+SL+SR -> FL+FR+FC+LFE+BL+BR
      echo "pan=5.1|FL < FL | FR < FR | FC < FL + FR | LFE < FL + FR + SL + SR | BL < SL | BR < SR"
      ;;
    '3.1') # FL+FR+FC+LFE -> FL+FR
      echo "pan=stereo| FL < FL + 0.5*FC + LFE | FR < FR + 0.5*FC + LFE"
      ;;
    '4.1') # FL+FR+FC+LFE+BC -> FL+FR
      echo "pan=stereo|FL < FL + 0.5*FC + BC + LFE | FR < FR + 0.5*FC + BC + LFE"
      ;;
    '5.0') # FL+FR+FC+BL+BR -> FL+FR+FC+LFE+BL+BR
      echo "pan=5.1|FL<FL|FR<FR|FC<FC|LFE<FL+FR+FC+BL+BR|BL<BL|BR<BR"
      ;;
    '5.0(side)') # FL+FR+FC+SL+SR -> FL+FR+FC+LFE+BL+BR
      echo "pan=5.1|FL<FL|FR<FR|FC<FC|LFE<FL+FR+FC+SL+SR|BL<SL|BR<SR"
      ;;
    '5.1') # FL+FR+FC+LFE+BL+BR -> FL+FR+FC+LFE+BL+BR
      echo "pan=5.1|FL<FL|FR<FR|FC<FC|LFE<LFE|BL<BL|BR<BR"
      ;;
    '5.1(side)') # FL+FR+FC+LFE+SL+SR -> FL+FR+FC+LFE+BL+BR
      echo "pan=5.1|FL<FL|FR<FR|FC<FC|LFE<LFE|BL<SL|BR<SR"
      ;;
    '6.0') # FL+FR+FC+BC+SL+SR -> FL+FR+FC+LFE+BL+BR
      echo "pan=5.1|FL<FL|FR<FR|FC<FC|LFE<FL+FR+FC+BC+SL+SR|BL<SL+BC|BR<SR+BC"
      ;;
    '6.0(front)') # FL+FR+FLC+FRC+SL+SR -> FL+FR+FC+LFE+BL+BR
      echo "pan=5.1|FL<FL+FLC|FR<FR+FRC|FC<FC+FLC+FRC|LFE<FL+FR+FLC+FRC+SL+SR|BL<SL|BR<SR"
      ;;
    'hexagonal') # FL+FR+FC+BL+BR+BC -> FL+FR+FC+LFE+BL+BR
      echo "pan=5.1|FL<FL|FR<FR|FC<FC|LFE<FL+FR+FC+BL+BR+BC|BL<BL+BC|BR<BL+BC"
      ;;
    '6.1') # FL+FR+FC+LFE+BC+SL+SR -> FL+FR+FC+LFE+BL+BR
      echo "pan=5.1|FL<FL|FR<FR|FC<FC|LFE<LFE|BL<SL+BC|BR<SR+BC"
      ;;
#    '6.1(back)') # FL+FR+FC+LFE+BL+BR+BC -> FL+FR+FC+LFE+BL+BR
#      echo "pan=5.1|FL<FL|FR<FR|FC<FC|LFE<LFE|BL<BL+BC|BR<BR+BC"
#      ;;
    '6.1(front)') # FL+FR+LFE+FLC+FRC+SL+SR -> FL+FR+FC+LFE+BL+BR
      echo "pan=5.1|FL<FL+FLC|FR<FR+FRC|FC<FLC+FRC+FL+FR|LFE<FL+FR+LFE+FLC+FRC+SL+SR|BL<SL|BR<SR"
      ;;
    '7.0') # FL+FR+FC+BL+BR+SL+SR -> FL+FR+FC+LFE+BL+BR
      echo "pan=5.1|FL<FL|FR<FR|FC<FC|LFE<FL+FR+FC+BL+BR+SL+SR|BL<BL+SL|BR<BR+SR"
      ;;
    '7.0(front)') # FL+FR+FC+FLC+FRC+SL+SR -> FL+FR+FC+LFE+BL+BR
      echo "pan=5.1|FL<FL+FLC|FR<FR+FRC|FC<FC+FLC+FRC|LFE<FL+FR+FC+FLC+FRC+SL+SR|BL<SL|BR<SR"
      ;;
    '7.1') # FL+FR+FC+LFE+BL+BR+SL+SR -> FL+FR+FC+LFE+BL+BR
      echo "pan=5.1| FL < FL | FR < FR | FC < FC | LFE < LFE | BL < BL + SL | BR < BR + SR"
      ;;
    '7.1(wide)') # FL+FR+FC+LFE+BL+BR+FLC+FRC -> FL+FR+FC+LFE+BL+BR
      echo "pan=5.1| FL < FL + FLC | FR < FR + FRC | FC < FC + FLC + FRC | LFE < LFE | BL < BL | BR < BR"
      ;;
    '7.1(wide-side)') # FL+FR+FC+LFE+FLC+FRC+SL+SR -> FL+FR+FC+LFE+BL+BR
      echo "pan=5.1|FL<FL+FLC|FR<FR+FRC|FC<FLC+FRC|LFE<LFE|BL<SL|BR<SR"
      ;;
    'octagonal') # FL+FR+FC+BL+BR+BC+SL+SR -> FL+FR+FC+LFE+BL+BR
      echo "pan=5.1|FL<FL|FR<FR|FC<FC|LFE<FL+FR+FC+BL+BR+BC+SL+SR|BL<BL+BC+SL|BR<BR+BC+SR"
      ;;
    'downmix') # DL+DR -> FL+FR
      echo "pan=stereo | FL < DL | FR < DR"
      ;;
    *)
      echo "ERROR: Unsupported channel layout"
      exit 1
      ;;

  esac

}

audio_encode() {

  # Encode Audio
  ffmpeg \
  -i "${inputFile}" \
  -c:a ac3 \
  -map 0:"$(audio_stream_selector)" \
  -ac "$(audio_num_channels)" \
  -b:a "$(audio_bitrate)k" \
  -af "$(audio_channel_mapper)" \
  -ar $(audio_sample_rate) \
  -y $(temp_directory)/$(filename_handler).ac3 || \
  { echo -e "${clR}ERROR: Failed to encode audio" ; return 1 ; }

}

black_bar_crop_detection() {

  ## [several checks to accurately crop black-bars]
  crop="1"
  totalLoops="10"
  ## [gather crop values]
  A=0
  while [ "$A" -lt "$totalLoops" ] ; do

    A="$(( $A + 1 ))"
    skipSecs="$(( 120 * $A ))"
    crop[$A]=$(\
      ffmpeg -threads "${cpuCores}" -i $inputFile -ss $skipSecs \
      -t 1 -vf cropdetect -f null - 2>&1 | \
      awk -F "=" '/crop/ { print $NF }' | tail -1)
    echo -ne "\r       ${clC}crop detect ${clP}$A ${clC}of ${clP}10 ${clC}complete"

  done

  B=0
  while [ "$B" -lt "$totalLoops" ] ; do

    B="$(( $B + 1 ))"
    C=0
    while [ "$C" -lt "$totalLoops" ] ; do

      C="$(( $C + 1 ))"
      if [ "${crop[$B]}" == "${crop[$C]}" ] ; then
        countCrop[$B]="$(( ${countCrop[$B]} + 1 ))"
      fi

    done

  done

  ## [find greatest crop]
  highestCount=0
  D=0
  while [ "$D" -lt "$totalLoops" ] ; do

    D="$(( $D + 1 ))"
    if [ "${countCrop[$D]}" -gt "$highestCount" ] ; then
      highestCount="${countCrop[$D]}"
      greatest="$D"
    fi

  done
  ## [final crop value]
  crop="${crop[$greatest]}"
  ## [frame width from final crop value]
  cropWidth=$(echo $crop | awk -F ":" '{print $1}')
  echo -e "\n             Crop: ${clP}$crop"

}

video_interlace_detection() {

  echo "Not implemented yet"

}

video_frame_counter() {

  # Frames Per Second
  FPS="23.976023976"
  # Get Duration
  totalLength=$(ffprobe "$inputFile" 2>&1 | sed -n "s/.* Duration: \([^,]*\), .*/\1/p")
  HRS=$(echo $totalLength | cut -d":" -f1)
  MIN=$(echo $totalLength | cut -d":" -f2)
  SEC=$(echo $totalLength | cut -d":" -f3)
  # Get total number of frames
  totalFrames=$(echo "($HRS*3600+$MIN*60+$SEC)*$FPS" | bc | cut -d"." -f1)
  echo "Estimated total frames: $totalFrames"

}

video_encode() {

  videoEncodingPasses=2

  # Initial pass number, DO NOT CHANGE VALUE
  videoEncodingPass=1

  while [ "$videoEncodingPass" -le "$videoEncodingPasses" ] ; do

    echo -e "${clC}Encoding Pass: ${clP}$videoEncodingPass ${clC}of ${clP}$videoEncodingPasses${clD}"

    ## [ffmpeg piped to x265]
    ## TODO: determine if crop height or width are odd numbers and if so
    ##        enable ffmpeg scaling otherwise disable
    ## TODO: make ffmpeg output to $fileName.ffmpeg
    ffmpeg \
      -threads "${cpuCores}" \
      -i "$inputFile" \
      -vf "crop=$crop,scale=$cropWidth:trunc(ow/a/2)*2" \
      -r 24000/1001 \
      -pix_fmt yuv420p \
      -f yuv4mpegpipe - 2> nul | \
    x265 \
      --y4m \
      --stats=$(temp_directory)/$(filename_handler).stats \
      --threads="${cpuCores}" \
      --frame-threads="${cpuCores}" \
      --wpp \
      --ctu=64 \
      --no-cutree \
      --tu-intra-depth=4 \
      --tu-inter-depth=4 \
      --me=2 \
      --cbqpoffs=3 \
      --crqpoffs=3 \
      --psy-rd=0.15 \
      --subme=7 \
      --merange=60 \
      --ref=4 \
      --bframes=3 \
      --b-pyramid \
      --b-adapt=2 \
      --bframe-bias=0 \
      --b-intra \
      --weightb \
      --weightp \
      --bitrate=500 \
      --vbv-init=0.9 \
      --vbv-bufsize=31250 \
      --vbv-maxrate=31250 \
      --no-slow-firstpass \
      --pass=$videoEncodingPass \
      --keyint=250 \
      --min-keyint=23 \
      --rc-lookahead=60 \
      --no-constrained-intra \
      --aq-mode=0 \
      --lft \
      --cbqpoffs=-3 \
      --crqpoffs=-3 \
      --rect \
      --amp \
      --max-merge=5 \
      --no-early-skip \
      --no-tskip \
      --hash=2 \
      -f 0 \
      -o "$(temp_directory)/$(filename_handler).hvc" - || \
      { echo "ERROR: video encoding failed" ; return 1 ; }

    # Finished encoding
    if [ "$videoEncodingPass" == "$videoEncodingPasses" ] ; then
      echo
      echo "Encoding complete"
    # Not finised encoding
    else 
      echo
    fi

    # Increment pass count
    videoEncodingPass="$(( $videoEncodingPass + 1 ))"

  done

}

mux_streams() {

  # mkvmerge
  # -o "$rar_variable-s.mkv"
  # "--default-track" "0:yes"
  # "--forced-track" "0:no"
  # "--language" "1:eng"
  # "--track-name"
  # "1:English"
  # "--default-track"
  # "1:yes"
  # "--forced-track"
  # "1:no"
  # "--language" "2:eng"
  # "--default-track" "2:yes" "--forced-track"
  # "2:no" "-a" "1" "-d" "0" "-s" "2" "-T" "--no-global-tags"
  # "--no-chapters" "(" "$rlsname_variable.mkv" ")"
  # "--track-order" "0:0,0:1,0:2" "--split" "parts:00:01:30-00:02:30"

  ## [check for chapter file]
  if [ -f "$(temp_directory)/$(filename_handler).xml" ] ; then
    muxChapters=""
  else
    muxChapters=
  fi

  ## [check for subtitle file]
  if [ -f "$(temp_directory)/$(filename_handler).srt" ] ; then
    muxSubtitles="-i $(temp_directory)/$(filename_handler).ass -c:s copy"
  else
    muxSubtitles=
  fi

  ## TODO: find audio language and set videolanguage to audiolanguage
#  mkvmerge \
#    -o $(output_directory)/$(filename_handler).mkv \
#    --title $(filename_handler) \
#    -A $(temp_directory)/$(filename_handler).hvc \
#    ${muxChapters} \
#    ${muxSubtitles} \
#    $(temp_directory)/$(filename_handler).${audioCodec}

  ffmpeg \
    -threads "${cpuCores}" \
    -i "$(temp_directory)/$(filename_handler).hvc" \
    -i "$(temp_directory)/$(filename_handler).ac3" \
    -acodec copy -vcodec copy \
    -y "$(temp_directory)/$(filename_handler).mkv"


}

cleanup_temp_file() {

  [ -f "$(temp_directory)/${1}" ] && {
    rm -f $(temp_directory)/${1} || {
      echo "WARNING: failed to remove temp file: ${1}"
      return 1
    }
    echo "Removed temp file: ${1}"
  }

}

cleanup_temp() {

  # CLEANUP TEMP FILES
    ## ffmpeg redirected output [nul]
    ## pgs subtitles
  cleanup_temp_file $(filename_handler).hvc
  cleanup_temp_file $(filename_handler).stats
  cleanup_temp_file $(filename_handler).ac3
  cleanup_temp_file $(filename_handler).sub
  cleanup_temp_file $(filename_handler).idx
  cleanup_temp_file $(filename_handler).srt
  cleanup_temp_file $(filename_handler).xml

}

run_arkhive() {

  # Find full path to the directory containing the input file
  input_directory "${inputFile}"

  # Determine if input has subtitles
  hasSubtitles=$(ffprobe $userInput 2>&1 | awk '/Subtitle/ { print $2 }')

  [ -n "$hasSubtitles" ] && {
    subtitle_stream_selector
    subtitle_stream_extractor
    subtitle_format_detection
  }
  #
  # TODO: test here for non-srt subtitles
  #
  [ "subtitlesNotSrt" == "true" ] && {
    subtitle_srt_converter
  }

  # Determine if a chapter stream exists
  hasChapters=$(ffprobe -i $userInput 2>&1 | awk '/Chapter/ { print $2 }')
  [ -n "$hasChapters" ] && { $(chapter_stream_extractor) ; }

  audio_stream_selector || { return 1 ; }

  audio_channel_mapper || { return 1 ; }

  audio_encode || { return 1 ; }

  black_bar_crop_detection || { return 1 ; }

  video_interlace_detection || { return 1 ; }

  video_encode || { return 1 ; }

  mux_streams || { return 1 ; }
}

if [ -d "$userInput" ] ; then
#  find $(input_directory) -type f \( \
#    -name "*.avi" \
#    -o -name "*.f4v" \
#    -o -name "*.flv" \
#    -o -name "*.m2ts" \
#    -o -name "*.m4v" \
#    -o -name "*.mkv" \
#    -o -name "*.mov" \
#    -o -name "*.mp4" \
#    -o -name "*.mpeg" \
#    -o -name "*.mpg" \
#    -o -name "*.ts" \
#    -o -name "*.webm" \
#    -o -name "*.wmv" \
#  \) -print0 | \
#  while read -d $'\0' inputFile; do \
#    run_arkhive \
#  done
echo "dirs not supported yet"
elif [ -f "$userInput" ] ; then
  inputFile="$userInput"
  echo "str: $(audio_stream_selector)"
  echo "sam: $(audio_input_sample_rate)"
  echo "chn: $(audio_source_channel_layout)"
  run_arkhive || { cleanup_temp ; }
fi
