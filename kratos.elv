# Copyright (c) 2018, 2020, Cody Opel <cwopel@chlorm.net>
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


use str
use github.com/chlorm/elvish-stl/os
use github.com/chlorm/elvish-xdg/xdg

kratos-dir = (xdg:get-dir XDG_RUNTIME_DIR)'/kratos/'
lockfile = $kratos-dir'/initialized'
initialized = (os:exists $lockfile)

fn init-dirs {
  local:init-dirs = [ ]
  try {
    for local:i [ (str:split ':' (get-env KRATOS_INIT_DIRS)) ] {
      init-dirs = [ $@init-dirs $i ]
    }
  } except _ {
    return
  }

  for local:dir $init-dirs {
    if (not (os:is-dir $dir)) {
      try {
        os:makedirs $dir
      } except _ {
        fail 'Failed to create directory: '$dir
      }
    }
  }
}


fn init-session {
  use epm
  epm:upgrade

  use github.com/chlorm/elvish-xdg/xdg
  xdg:populate-env-vars

  use github.com/chlorm/elvish-as-default-shell/default-shell
  use github.com/chlorm/elvish-user-tmpfs/tmpfs-automount

  init-dirs

  if (not (os:is-dir $kratos-dir)) {
    # Don't create parent dirs, we want to catch failures here.
    os:makedir $kratos-dir
  }
  os:touch $lockfile
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
