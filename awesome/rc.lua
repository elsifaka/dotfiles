-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

require("scratch")

require("runonce")

run_once("xcompmgr")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical,
	title = "Oops, there were errors during startup!",
	text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.add_signal("debug::error", function (err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true

		naughty.notify({ preset = naughty.config.presets.critical,
		title = "Oops, an error happened!",
		text = err })
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/usr/share/awesome/themes/default/theme.lua")
theme.wallpaper_cmd = { "awsetbg /home/tosoa/Pictures/Backgrounds/tongotra_andraikiba.jpg" }

-- This is used later as the default terminal and editor to run.
-- urxvtc lives in /usr/local/bin/urxvtc
browser = "/usr/bin/firefox"
screenlock = "/usr/bin/slimlock"
terminal = "/usr/local/bin/urxvtc"
terminal_ = "/usr/local/bin/urxvtc -pe tabbed"
editor = "gvim" or os.getenv("EDITOR") or "nano"
editor_cmd = editor
mail = "urxvtc -e mutt"
-- editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
	awful.layout.suit.max,
	awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
	awful.layout.suit.spiral,
	awful.layout.suit.spiral.dwindle,
	awful.layout.suit.max.fullscreen,
	awful.layout.suit.magnifier
}
-- }}}

require "my_tags"
require "my_bar"
require "my_keys"
require "my_rules"
require "my_signals"

-- run_once("cbatticon")
run_once("volumeicon")
run_once("kupfer")
