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


use github.com/chlorm/elvish-git/status
use github.com/chlorm/elvish-ssh/agent
use github.com/chlorm/elvish-stl/env
use github.com/chlorm/elvish-stl/io
use github.com/chlorm/elvish-stl/os
use github.com/chlorm/elvish-stl/path
use github.com/chlorm/elvish-stl/platform
use github.com/chlorm/elvish-stl/str
use github.com/chlorm/elvish-xdg/xdg-dirs


var KRATOS-DIR = (path:join (xdg-dirs:runtime-dir) 'kratos')
var LOCKFILENAME = 'session.lock'
var LOCKFILE = (path:join $KRATOS-DIR $LOCKFILENAME)
var INITIALIZED = (os:exists $LOCKFILE)

fn cache-new {|name contents~|
    var c = (path:join $KRATOS-DIR $name)
    if (not (os:exists $c)) {
        os:touch $c
        os:chmod 0600 $c
        try {
            print ($contents~) > $c
        } catch e { fail $e['reason'] }
    }
    put $c
}

fn cache-read {|cache|
    put (io:open $cache)
}

fn cache-remove {|cache|
    os:remove $cache
}

fn init-dirs {
    var initDirs = [ ]
    try {
        for i [ (str:split ':' (env:get 'KRATOS_INIT_DIRS')) ] {
            set initDirs = [ $@initDirs $i ]
        }
    } catch _ {
        return
    }

    for dir $initDirs {
        if (not (os:exists $dir)) {
            try {
                os:makedirs $dir
            } catch e {
                fail $e
            }
        }
    }
}


fn init-session {
    var startupLock = 'startup.lock'
    # FIXME: should sleep until initialized and then re-exec elvish.
    # Prevent race condition when multiple shells are started in parallel.
    if (os:exists (path:join $KRATOS-DIR $startupLock)) {
        return
    }

    if (not (os:exists $KRATOS-DIR)) {
        os:makedir $KRATOS-DIR
    }

    var startup = (cache-new $startupLock $nop~)

    use epm
    epm:upgrade

    use github.com/chlorm/elvish-xdg/xdg-dirs
    xdg-dirs:populate-env

    use github.com/chlorm/elvish-as-default-shell/default-shell
    default-shell:init-session

    use github.com/chlorm/elvish-tmpfs/automount

    try {
        var data = (xdg-dirs:data-home)
        if (os:is-dir (path:join $data 'nvim' 'site' 'pack' 'packer')) {
            e:nvim --headless '+PackerSync' '+qa'
        }
    } catch e { echo $e['reason'] >&2 }

    try {
        agent:init-session
    } catch e { echo $e['reason'] >&2 }

    init-dirs
    #init-dotfiles

    var _ = (cache-new $LOCKFILENAME $nop~)
    cache-remove $startup
}

fn init-instance {
    try {
        use github.com/chlorm/elvish-xdg/xdg-dirs
        xdg-dirs:populate-env
    } catch e { echo $e['reason'] >&2 }

    try {
        use github.com/chlorm/elvish-term/color-scheme
        # TODO: add an interface to allow user defined themes
        color-scheme:set (color-scheme:monokai)
    } catch e { echo $e['reason'] >&2 }

    try {
        use github.com/chlorm/elvish-auto-env/ls
        var lsCache = (cache-new 'ls' $ls:get~)
        try {
            ls:set &static=(cache-read $lsCache)
        } catch e { echo $e['reason'] >&2 }
    } catch e { echo $e['reason'] >&2 }

    use github.com/chlorm/elvish-auto-env/editor
    try {
        editor:set
    } catch e { echo $e['reason'] >&2 }

    try {
        use github.com/chlorm/elvish-auto-env/pager
        var pagerCache = (cache-new 'pager' $pager:get~)
        try {
            pager:set &static=(cache-read $pagerCache)
        } catch e { echo $e['reason'] >&2 }
    } catch e { echo $e['reason'] >&2 }

    try {
        agent:init-instance
    } catch e { echo 'Agent: '(to-string $e['reason']['content']) >&2 }

    set paths = [
        (env:get $xdg-dirs:XDG-BIN-HOME)
        (path:join (path:home) '.cargo' 'bin')
        (path:join (path:home) 'go' 'bin')
        $@paths
    ]

    set edit:prompt = {
        var user = $nil
        fn pill-begin {
            var p = "\ue0b6"
            # Fix ligatures in alacritty
            try {
                var _ = (env:get 'ALACRITTY_SOCKET')
                set p = $p' '
            } catch _ { }
            styled $p fg-black
        }
        fn pill-end {
            var p = "\ue0b4 "
            # Fix ligatures in Alacritty
            try {
                var _ = (env:get 'ALACRITTY_SOCKET')
                set p = "\ue0b4"
            } catch _ { }
            styled $p fg-black
        }
        try {
            set user = (env:get 'USER')
        } catch _ {
            set user = (env:get 'username')
        }
        pill-begin
        styled $user fg-green bg-black
        if (env:has 'SSH_CLIENT') {
            styled-segment &dim=$true &fg-color=white '@' &bg-color=black
            styled-segment (platform:hostname) &bold=$true &fg-color=red &bg-color=black
        #} else {
        #    styled-segment &bold=$true &fg-color=white (platform:hostname)
        }
        pill-end
        try {
            var g = (status:status)
            pill-begin
            styled ' '$g['branch']['head']' ' fg-white bg-black
            try {
                styled '+'(status:count-unstaged $g) fg-green bg-black
            } catch _ { }
            try {
                styled '~'(status:count-untracked $g) fg-yellow bg-black
            } catch _ { }
            try {
                styled '-'(status:count-deleted $g) fg-red bg-black
            } catch _ { }
            pill-end
        } catch _ { }
        pill-begin
        styled (tilde-abbr $pwd) fg-red bg-black
        pill-end
        styled-segment ' ' &fg-color=cyan
    }
    set edit:rprompt = { }
}
