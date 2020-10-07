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
use github.com/chlorm/elvish-stl/io
use github.com/chlorm/elvish-stl/os
use github.com/chlorm/elvish-stl/path
use github.com/chlorm/elvish-xdg/xdg


kratos-dir = (path:join (xdg:get-dir XDG_RUNTIME_DIR) 'kratos')
lockfile = (path:join $kratos-dir 'initialized')
initialized = (os:exists $lockfile)

fn cache-new [name contents~]{
    local:c = (path:join $kratos-dir $name)
    if (not (os:exists $c)) {
        os:touch $c
        os:chmod 0600 $c
        try {
            print ($contents~) > $c
        } except e { fail $e[reason] }
    }
    put $c
}

fn cache-read [cache]{
    put (io:open $cache)
}

fn cache-remove [cache]{
    os:remove $cache
}

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
    # FIXME: should sleep until initialized and then re-exec elvish.
    # Prevent race condition when multiple shells are started in parallel.
    if (os:exists (path:join $kratos-dir 'startup')) {
        return
    }

    if (not (os:exists $kratos-dir)) {
        os:makedir $kratos-dir
    }

    local:startup = (cache-new 'startup' $echo~)

    use epm
    epm:upgrade

    use github.com/chlorm/elvish-xdg/xdg
    xdg:populate-env-vars

    use github.com/chlorm/elvish-as-default-shell/default-shell
    use github.com/chlorm/elvish-user-tmpfs/tmpfs-automount

    init-dirs

    local:initialized = (cache-new 'initialized' $echo~)
    cache-remove $startup
}

fn init-instance {
    try {
        use github.com/chlorm/elvish-xdg/xdg
        xdg:populate-env-vars
    } except e { echo $e[reason] >&2 }

    try {
        use github.com/chlorm/elvish-term-color/term-color
        use github.com/chlorm/elvish-color-schemes/color-scheme
        # TODO: add an interface to allow user defined themes
        term-color:set (color-scheme:monokai)
    } except e { echo $e[reason] >&2 }

    try {
        use github.com/chlorm/elvish-auto-env/ls
        local:ls-cache = (cache-new 'ls' $ls:get~)
        try {
            ls:set &static=(cache-read $ls-cache)
        } except e { echo $e[reason] >&2 }
    } except e { echo $e[reason] >&2 }

    try {
        use github.com/chlorm/elvish-auto-env/editor
        local:editor-cache = (cache-new 'editor' $editor:get~)
        try {
            editor:set &static=(cache-read $editor-cache)
        } except e { echo $e[reason] >&2 }
    } except e { echo $e[reason] >&2 }

    try {
        use github.com/chlorm/elvish-auto-env/pager
        local:pager-cache = (cache-new 'pager' $pager:get~)
        try {
            pager:set &static=(cache-read $pager-cache)
        } except e { echo $e[reason] >&2 }
    } except e { echo $e[reason] >&2 }

    paths = [
        (path:join (get-env XDG_PREFIX_HOME) 'bin')
        $@paths
    ]
}
