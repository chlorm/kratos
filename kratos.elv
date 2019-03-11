# Copyright (c) 2018, Cody Opel <codyopel@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

fn require [pkg]{
  use epm
  if (epm:is-installed $pkg) {
    epm:upgrade $pkg
  } else {
    epm:install &silent-if-installed=$true $pkg
  }
}

# TODO: add overrides and add interface for defining custom directories
fn init-dirs {
  local:xdg-dirs = [
    (get-env XDG_CACHE_HOME)
    (get-env XDG_CONFIG_HOME)
    (get-env XDG_DATA_HOME)
    (get-env XDG_DESKTOP_DIR)
    (get-env XDG_DOCUMENTS_DIR)
    (get-env XDG_DOWNLOAD_DIR)
    (get-env XDG_MUSIC_DIR)
    (get-env XDG_PICTURES_DIR)
    (get-env XDG_PREFIX_HOME)
    (get-env XDG_PUBLICSHARE_DIR)
    (get-env XDG_TEMPLATES_DIR)
    (get-env XDG_VIDEOS_DIR)
  ]

  local:trash-dirs = [
    (get-env XDG_DATA_HOME)'/trash/files'
    (get-env XDG_DATA_HOME)'/trash/info'
  ]

  local:custom-dirs = [
    (get-env HOME)'/Projects'
  ]

  local:kratos-dirs = [
    (get-env HOME)'/.local/share/kratos'
  ]

  local:create-dirs = [
    $@custom-dirs
    $@kratos-dirs
    $@xdg-dirs
    $@trash-dirs
  ]

  for local:dir $create-dirs {
    if (and (not ?(test -d $dir)) (!=s $dir '')) {
      try {
        mkdir -p $dir
      } except _ {
        fail 'Failed to create directory: '$dir
      }
    }
  }
}


# TODO: add an interface to allow user defined functions to be run.
# TODO: add an interface to allow user defined required packages to be checked.
fn init-session {
  # Session
  require github.com/chlorm/kratos
  require github.com/chlorm/elvish-xdg
  require github.com/chlorm/elvish-as-default-shell
  require github.com/chlorm/elvish-user-tmpfs
  require github.com/chlorm/elvish-term-color
  require github.com/chlorm/elvish-color-schemes

  use github.com/chlorm/elvish-xdg/xdg
  xdg:populate-env-vars

  use github.com/chlorm/elvish-as-default-shell/default-shell
  use github.com/chlorm/elvish-user-tmpfs/tmpfs-automount

  init-dirs

  if (not ?(test -d (get-env XDG_RUNTIME_DIR)'/kratos/')) {
    # Don't create parent dirs, we want to catch failures here.
    mkdir (get-env XDG_RUNTIME_DIR)'/kratos/'
  }
  touch (get-env XDG_RUNTIME_DIR)'/kratos/initialized'
}

fn init-instance {
  use github.com/chlorm/elvish-xdg/xdg
  xdg:populate-env-vars

  use github.com/chlorm/elvish-term-color/term-color
  use github.com/chlorm/elvish-color-schemes/color-scheme
  # TODO: add an interface to allow user defined themes
  term-color:set (color-scheme:monokai)

  paths = [
    (get-env XDG_PREFIX_HOME)'/bin'
    $@paths
  ]
}
