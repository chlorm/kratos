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


use platform
use str
use github.com/chlorm/elvish-stl/io
use github.com/chlorm/elvish-stl/os
use github.com/chlorm/elvish-stl/path
use github.com/chlorm/elvish-xdg/xdg


var KRATOS-DIR = (path:join (xdg:get-dir 'XDG_RUNTIME_DIR') 'kratos')
var LOCKFILE = (path:join $KRATOS-DIR 'initialized')
var INITIALIZED = (os:exists $LOCKFILE)

fn cache-new [name contents~]{
    var c = (path:join $KRATOS-DIR $name)
    if (not (os:exists $c)) {
        os:touch $c
        os:chmod 0600 $c
        try {
            print ($contents~) > $c
        } except e { fail $e['reason'] }
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
    var initDirs = [ ]
    try {
        for i [ (str:split ':' (get-env 'KRATOS_INIT_DIRS')) ] {
            set initDirs = [ $@initDirs $i ]
        }
    } except _ {
        return
    }

    for dir $initDirs {
        if (not (os:exists $dir)) {
            try {
                os:makedirs $dir
            } except e {
                fail $e
            }
        }
    }
}


fn init-session {
    # FIXME: should sleep until initialized and then re-exec elvish.
    # Prevent race condition when multiple shells are started in parallel.
    if (os:exists (path:join $KRATOS-DIR 'startup')) {
        return
    }

    if (not (os:exists $KRATOS-DIR)) {
        os:makedir $KRATOS-DIR
    }

    var startup = (cache-new 'startup' $nop~)

    use epm
    epm:upgrade

    use github.com/chlorm/elvish-xdg/xdg
    xdg:populate-env-vars
    
    use github.com/chlorm/elvish-as-default-shell/default-shell
    use github.com/chlorm/elvish-user-tmpfs/tmpfs-automount

    init-dirs
    #init-dotfiles

    var _ = (cache-new 'initialized' $nop~)
    cache-remove $startup
}

fn init-instance {
    try {
        use github.com/chlorm/elvish-xdg/xdg
        xdg:populate-env-vars
    } except e { echo $e['reason'] >&2 }

    try {
        use github.com/chlorm/elvish-term-color/term-color
        use github.com/chlorm/elvish-color-schemes/color-scheme
        # TODO: add an interface to allow user defined themes
        term-color:set (color-scheme:monokai)
    } except e { echo $e['reason'] >&2 }

    try {
        use github.com/chlorm/elvish-auto-env/ls
        var lsCache = (cache-new 'ls' $ls:get~)
        try {
            ls:set &static=(cache-read $lsCache)
        } except e { echo $e['reason'] >&2 }
    } except e { echo $e['reason'] >&2 }

    use github.com/chlorm/elvish-auto-env/editor
    try {
        editor:set
    } except e { echo $e['reason'] >&2 }

    try {
        use github.com/chlorm/elvish-auto-env/pager
        var pagerCache = (cache-new 'pager' $pager:get~)
        try {
            pager:set &static=(cache-read $pagerCache)
        } except e { echo $e['reason'] >&2 }
    } except e { echo $e['reason'] >&2 }

    set paths = [
        (path:join (get-env XDG_PREFIX_HOME) 'bin')
        $@paths
    ]
}
