# This file is part of Kratos.
# Copyright (c) 2014-2015, Cody Opel <codyopel@gmail.com>.
#
# Use of this source code is governed by the terms of the
# BSD-3 license.  A copy of the license can be found in
# the `LICENSE' file in the top level source directory.

app_xmonad_installed() {

  path_hasbin "xmonad" > /dev/null || return 1

  return 0

}

app_xmonad_dirs() {

  exist -dc "$HOME/.xmonad" || return 1

  return 0

}

app_xmonad_dotfiles() {

  exist -fx "$HOME/.xmonad/xmonad.hs"

(
cat <<XMONAD
import XMonad
import Data.Monoid
--[gets xdg-home directory]
import System.Directory
-- getHomeDirectory
import System.Exit
--import XMonad.Util.Run (spawnPipe)

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- Default terminal
myTerminal = "sakura"

-- Focus follows mouse pointer
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Click on a window to focus and also pass the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Window border width (in pixels)
myBorderWidth = 2

-- Super/Mod key
myModMask = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

-- Focused border color
myFocusedBorderColor = "#990000"
-- Unfocused border color
myNormalBorderColor = "#555555"

-- Key bindings
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
  -- launch a terminal
  [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
  -- launch emacs
  , ((modm .|. shiftMask,   xK_i     ), spawn "run emacs")
  -- lock screen
  , ((modm,               xK_a     ), spawn "run comp_lock")
  -- sleep machine 
  , ((modm,               xK_s     ), spawn "run comp_sleep")
  -- launch dmenu
  , ((modm,               xK_p     ), spawn "dmenu_run")
  -- launch gmrun
  , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")
  -- close focused window
  , ((modm .|. shiftMask, xK_c     ), kill)
   -- Rotate through the available layout algorithms
  , ((modm,               xK_space ), sendMessage NextLayout)
  --  Reset the layouts on the current workspace to default
  , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
  -- Resize viewed windows to the correct size
  , ((modm,               xK_n     ), refresh)
  -- Move focus to the next window
  , ((modm,               xK_Tab   ), windows W.focusDown)
  -- Move focus to the next window
  , ((modm,               xK_j     ), windows W.focusDown)
  -- Move focus to the previous window
  , ((modm,               xK_k     ), windows W.focusUp  )
  -- Move focus to the master window
  , ((modm,               xK_m     ), windows W.focusMaster  )
  -- Swap the focused window and the master window
  , ((modm,               xK_Return), windows W.swapMaster)
  -- Swap the focused window with the next window
  , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
  -- Swap the focused window with the previous window
  , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
  -- Shrink the master area
  , ((modm,               xK_h     ), sendMessage Shrink)
  -- Expand the master area
  , ((modm,               xK_l     ), sendMessage Expand)
  -- Push window back into tiling
  , ((modm,               xK_t     ), withFocused $ windows . W.sink)
  -- Increment the number of windows in the master area
  , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
  -- Deincrement the number of windows in the master area
  , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
  -- Printscreen
  , ((0                 , xK_Print), spawn "scrot")
  -- Toggle the status bar gap
  -- Use this binding with avoidStruts from Hooks.ManageDocks.
  -- See also the statusBar function from Hooks.DynamicLog.
  --
  -- , ((modm              , xK_b     ), sendMessage ToggleStruts)
  -- Quit xmonad
  , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
  -- Restart xmonad
  , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
  -- Run xmessage with a summary of the default keybindings (useful for beginners)
  -- , ((modMask .|. shiftMask, xK_slash ), spawn ("echo \\"" ++ help ++ "\\" | xmessage -file -"))
  ]
  ++
  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modm, k), windows $ f i)
    | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
  ++
  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

-- Mouse bindings
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
  -- mod-button1, Set the window to floating mode and move by dragging
  [ ((modm, button1), (\\w -> focus w >> mouseMoveWindow w
                                     >> windows W.shiftMaster))
  -- mod-button2, Raise the window to the top of the stack
  , ((modm, button2), (\\w -> focus w >> windows W.shiftMaster))
  -- mod-button3, Set the window to floating mode and resize by dragging
  , ((modm, button3), (\\w -> focus w >> mouseResizeWindow w
                                     >> windows W.shiftMaster))
  -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]

-- Layout
myLayout = tiled ||| Mirror tiled ||| Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio
    -- The default number of windows in the master pane
    nmaster = 1
    -- Default proportion of screen occupied by master pane
    ratio   = 1/2
    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

-- Application/Window rules
myManageHook = composeAll
  [ className =? "MPlayer"        --> doFloat
  , className =? "Gimp"           --> doFloat
  , resource  =? "desktop_window" --> doIgnore
  , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling
-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
myEventHook = mempty

--[statusbars and logging]
myLogHook = return ()

--[startup hook]
myStartupHook = return ()

--[topbar]
--myXmonadBar = "dzen2 -x '0' -y '0' -h '14' -w '500' -ta 'l' -fg '"++foreground++"' -bg '"++background++"' -fn "++myFont
--myStatusBar = "/home/jackal/.xmonad/status_bar '"++foreground++"' '"++background++"' "++myFont

--[run xmonad]
main = do
--  dzenLeftBar     <- spawnPipe myXmonadBar
--  dzenRightBar    <- spawnPipe myStatusBar
  xmonad defaults

defaults = defaultConfig {
  --[simple stuff]
    terminal           = myTerminal,
    focusFollowsMouse  = myFocusFollowsMouse,
    clickJustFocuses   = myClickJustFocuses,
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    workspaces         = myWorkspaces,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,

  --[key bindings]
    keys               = myKeys,
    mouseBindings      = myMouseBindings,

  --[hooks, layouts]
    layoutHook         = myLayout,
    manageHook         = myManageHook,
    handleEventHook    = myEventHook,
    logHook            = myLogHook,
    startupHook        = myStartupHook
}

-- Fonts
myFont = "-*-nu-*-*-*-*-*-*-*-*-*-*-*-*"

-- Colors
background = "#181512"
foreground = "#D6C3B6"
color0     = "#332d29"
color1     = "#8c644c"
color2     = "#746C48"
color3     = "#bfba92"
color4     = "#646a6d"
color5     = "#766782"
color6     = "#4B5C5E"
color7     = "#504339"
color8     = "#817267"
color9     = "#9f7155"
color10    = "#9f7155"
color11    = "#E0DAAC"
color12    = "#777E82"
color13    = "#897796"
color14    = "#556D70"
color15    = "#9a875f"

XMONAD
) > "$HOME/.xmonad/xmonad.hs" || return 1

  return 0

}

app_xmonad_cleanup() {

  exist -dx "$HOME/.xmonad"

}

app_xmonad_configure() {

  app_xmonad_installed || return 2

  app_xmonad_dirs || return 1

  app_xmonad_dotfiles || return 1

  return 0

}