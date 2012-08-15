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

-- This is used later as the default terminal and editor to run.
-- urxvtc lives in /usr/local/bin/urxvtc
browser = "/usr/bin/firefox"
screenlock = "/usr/bin/gnome-screensaver-command -l"
terminal = "/usr/local/bin/urxvtc"
terminal_ = "/usr/local/bin/urxvtc -pe tabbed -n scratchpad"
editor = "gvim" or os.getenv("EDITOR") or "nano"
editor_cmd = editor
mail = "/usr/local/bin/urxvtc -e mutt"
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

-- {{{ Tags
-- Define a tag table which hold all screen tags.
--tags = {}
--for s = 1, screen.count() do
    ---- Each screen has its own tag table.
    --tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
--end
-- }}}
require "shifty"

-- Define if we want to use titlebar on all applications.
use_titlebar = false

-- Shifty configured tags.
shifty.config.tags = {
	main = {
		layout    = awful.layout.suit.max,
		mwfact    = 0.60,
		exclusive = false,
		position  = 1,
		init      = true,
		slave     = true,
		persist 	= true,
	},
	dev = {
		layout      = awful.layout.suit.tile.max,
		mwfact      = 0.65,
		position    = 2,
		exclusive 	= true,
		max_clients = 1
	},
	im = {
		layout      = awful.layout.suit.tile.right,
		mwfact      = 0.65,
		position    = 3,
		spawn 			= "pidgin",
		exclusive   = true
	},
	web = {
		layout      = awful.layout.suit.tile.bottom,
		mwfact      = 0.65,
		exclusive   = true,
		max_clients = 1,
		position    = 4,
		spawn       = browser,
	},
	mail = {
		layout    = awful.layout.suit.tile,
		mwfact    = 0.55,
		exclusive = false,
		position  = 5,
		spawn     = mail,
		slave     = true
	},
	media = {
		layout    = awful.layout.suit.float,
		exclusive = false,
		position  = 8,
	},
	office = {
		layout   = awful.layout.suit.tile,
		position = 9,
	},
}

-- SHIFTY: application matching rules
-- order here matters, early rules will be applied first
shifty.config.apps = {
	{
		match = {
			"Navigator",
			"Vimperator",
			"Pentadactyl",
			"Gran Paradiso",
			"luakit",
		},
		tag = "web",
	},
	{
		match = {
			"Shredder.*",
			"Thunderbird",
			"mutt",
		},
		tag = "mail",
	},
	{
		match = {
			"kupfer.py",
			"synapse"
		},
		slave = true,
		intrusive = true
	},
	{
		match = {
			"pcmanfm",
			"nautilus"
		},
		slave = true,
		intrusive = true,
	},
	{
		match = {
			"OpenOffice.*",
			"Abiword",
			"Gnumeric",
			"lyx",
		},
		tag = "office",
	},
	{
		match = {
			"Mplayer.*",
			"Mirage",
			"gimp",
			"gtkpod",
			"Ufraw",
			"easytag",
		},
		tag = "media",
		nopopup = true,
	},
	{
		match = {
			"MPlayer",
			"Gnuplot",
			"galculator",
		},
		float = true,
	},
	{
		match = {
			terminal,
		},
		honorsizehints = false,
		slave = true,
	},
	{
		match = {
			"Pidgin"
		},
		tag = "im"
	},
	{
		match = {
			"gvim",
			"emacs"
		},
		tag = "dev"
	},
	{
		match = {
			"guayadeque",
			"quodlibet",
			"ario",
			"gmpc"
		},
		tag = "music",
		slave = true
	},
	{
		match = {""},
		buttons = awful.util.table.join(
		awful.button({}, 1, function (c) client.focus = c; c:raise() end),
		awful.button({modkey}, 1, function(c)
			client.focus = c
			c:raise()
			awful.mouse.client.move(c)
		end),
		awful.button({modkey}, 3, awful.mouse.client.resize)
		),
		keys = awful.util.table.join(
		awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
		awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
		awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
		awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
		awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
		awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
		awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
		awful.key({ modkey,           }, "n",
		function (c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end),
		awful.key({ modkey,           }, "m",
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c.maximized_vertical   = not c.maximized_vertical
		end)
		)
	},
}

-- SHIFTY: default tag creation rules
-- parameter description
--  * floatBars : if floating clients should always have a titlebar
--  * guess_name : should shifty try and guess tag names when creating
--                 new (unconfigured) tags?
--  * guess_position: as above, but for position parameter
--  * run : function to exec when shifty creates a new tag
--  * all other parameters (e.g. layout, mwfact) follow awesome's tag API
shifty.config.defaults = {
	layout = awful.layout.suit.tile.bottom,
	ncol = 1,
	mwfact = 0.60,
	floatBars = true,
	guess_name = true,
	guess_position = true,
}

-- {{{ Menu
require "awesome-freedesktop.freedesktop.utils"
freedesktop.utils.terminal = terminal  -- default: "xterm"
freedesktop.utils.icon_theme = 'gnome' -- look inside /usr/share/icons/, default: nil (don't use icon theme)
require('awesome-freedesktop.freedesktop.menu')

-- Create a laucher widget and a main menu
menu_items = freedesktop.menu.new()
myawesomemenu = {
	{ "Manual", terminal .. " -e man awesome", freedesktop.utils.lookup_icon({ icon = 'help' }) },
	{ "Edit Config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua", freedesktop.utils.lookup_icon({ icon = 'package_settings' }) },
	{ "Restart", awesome.restart, freedesktop.utils.lookup_icon({ icon = 'gtk-refresh' }) },
	{ "Quit", awesome.quit, freedesktop.utils.lookup_icon({ icon = 'gtk-quit' }) }
}
table.insert(menu_items, { "Awesome", myawesomemenu, beautiful.awesome_icon })
table.insert(menu_items, { "Open Terminal", terminal, freedesktop.utils.lookup_icon({icon = 'terminal'}) })
-- table.insert(menu_items, { "Debian", debian.menu.Debian_menu.Debian, freedesktop.utils.lookup_icon({ icon = 'debian-logo' }) })

mymainmenu = awful.menu.new({ items = menu_items, width = 150 })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
awful.button({ }, 1, awful.tag.viewonly),
awful.button({ modkey }, 1, awful.client.movetotag),
awful.button({ }, 3, awful.tag.viewtoggle),
awful.button({ modkey }, 3, awful.client.toggletag),
awful.button({ }, 4, awful.tag.viewnext),
awful.button({ }, 5, awful.tag.viewprev)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
awful.button({ }, 1, function (c)
	if c == client.focus then
		c.minimized = true
	else
		if not c:isvisible() then
			awful.tag.viewonly(c:tags()[1])
		end
		-- This will also un-minimize
		-- the client, if needed
		client.focus = c
		c:raise()
	end
end),
awful.button({ }, 3, function ()
	if instance then
		instance:hide()
		instance = nil
	else
		instance = awful.menu.clients({ width=250 })
	end
end),
awful.button({ }, 4, function ()
	awful.client.focus.byidx(1)
	if client.focus then client.focus:raise() end
end),
awful.button({ }, 5, function ()
	awful.client.focus.byidx(-1)
	if client.focus then client.focus:raise() end
end))

for s = 1, screen.count() do
	-- Create a promptbox for each screen
	mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	mylayoutbox[s] = awful.widget.layoutbox(s)
	mylayoutbox[s]:buttons(awful.util.table.join(
	awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
	awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
	awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
	awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
	-- Create a taglist widget
	mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

	-- Create a tasklist widget
	mytasklist[s] = awful.widget.tasklist(function(c)
		return awful.widget.tasklist.label.currenttags(c, s)
	end, mytasklist.buttons)

	-- Create the wibox
	mywibox[s] = awful.wibox({ position = "top", screen = s })
	-- Add widgets to the wibox - order matters
	mywibox[s].widgets = {
		{
			mylauncher,
			mytaglist[s],
			mypromptbox[s],
			layout = awful.widget.layout.horizontal.leftright
		},
		mylayoutbox[s],
		mytextclock,
		s == 1 and mysystray or nil,
		mytasklist[s],
		layout = awful.widget.layout.horizontal.rightleft
	}
end
-- }}}

-- SHIFTY: initialize shifty
-- the assignment of shifty.taglist must always be after its actually
-- initialized with awful.widget.taglist.new()
shifty.taglist = mytaglist
shifty.init()

-- KEYS: {{{

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
awful.button({ }, 3, function () mymainmenu:toggle() end),
awful.button({ }, 4, awful.tag.viewnext),
awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

awful.key({ modkey,           }, "j",
function ()
	awful.client.focus.byidx( 1)
	if client.focus then client.focus:raise() end
end),
awful.key({ modkey,           }, "k",
function ()
	awful.client.focus.byidx(-1)
	if client.focus then client.focus:raise() end
end),
awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

-- Layout manipulation
awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
awful.key({ modkey,           }, "Tab",
function ()
	awful.client.focus.history.previous()
	if client.focus then
		client.focus:raise()
	end
end),

-- Standard program
awful.key({ modkey, "Control", "Shift" }, "l", function () awful.util.spawn(screenlock) end),
awful.key({ modkey,           }, "b", function () awful.util.spawn(browser) end),
-- awful.key({ modkey, "Shift"   }, "b", function () awful.util.spawn("/usr/bin/showbatt") end),
awful.key({ modkey, "Shift"   }, "m", function () awful.util.spawn(mail) end),
awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
awful.key({ modkey, "Shift"   }, "Return", function () scratch.drop(terminal_, "bottom", "center", .60, .30, true) end),
awful.key({ modkey, "Control" }, "r", awesome.restart),
awful.key({ modkey, "Shift"   }, "q", awesome.quit),

awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

awful.key({ modkey, "Control" }, "n", awful.client.restore),

-- Prompt
awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

awful.key({ modkey }, "x",
function ()
	awful.prompt.run({ prompt = "Run Lua code: " },
	mypromptbox[mouse.screen].widget,
	awful.util.eval, nil,
	awful.util.getdir("cache") .. "/history_eval")
end)
)


-- Compute the maximum number of digit we need, limited to 9
keynumber = 9
--for s = 1, screen.count() do
--keynumber = math.min(9, math.max(#tags[s], keynumber));
--end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, (shifty.config.maxtags or 9) do
	globalkeys = awful.util.table.join(globalkeys,
	awful.key({modkey}, "#" .. i + 9, function()
		local t =  awful.tag.viewonly(shifty.getpos(i))
	end),
	awful.key({modkey, "Control"}, "#" .. i + 9, function()
		local t = shifty.getpos(i)
		t.selected = not t.selected
	end),
	awful.key({modkey, "Control", "Shift"}, "#" .. i + 9, function()
		if client.focus then
			awful.client.toggletag(shifty.getpos(i))
		end
	end),
	-- move clients to other tags
	awful.key({modkey, "Shift"}, "#" .. i + 9, function()
		if client.focus then
			t = shifty.getpos(i)
			awful.client.movetotag(t)
			awful.tag.viewonly(t)
		end
	end))
end

clientbuttons = awful.util.table.join(
awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
awful.button({ modkey }, 1, awful.mouse.client.move),
awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- }}}
-- RULES {{{

awful.rules.rules = {
    -- All clients will match this rule.
		{
			rule = { },
			properties = {
				border_width = beautiful.border_width,
				border_color = beautiful.border_normal,
				size_hints_honor = false,
				focus = true,
			}
		},
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "pcmanfm" },
      properties = { opacity = 0.8, intrusive = true } },
    { rule = { class = "kupfer.py" },
      properties = { opacity = 0.8, floating = true, intrusive = true, border_width = 0 } },
    { rule = { class = "urxvt" },
      properties = { opacity = 0.8 } },
    { rule = { class = "Gvim" },
      properties = { opacity = 0.8 } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- SIGNALS {{{
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
	-- Add a titlebar
	-- awful.titlebar.add(c, { modkey = modkey })

	-- Enable sloppy focus
	c:add_signal("mouse::enter", function(c)
		if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
			and awful.client.focus.filter(c) then
			client.focus = c
		end
	end)

	if not startup then
		-- Set the windows at the slave,
		-- i.e. put it at the end of others instead of setting it master.
		-- awful.client.setslave(c)

		-- Put windows in a smart way, only if they does not set an initial position.
		if not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_overlap(c)
			awful.placement.no_offscreen(c)
		end
	end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- run_once("cbatticon")
run_once("volumeicon")
run_once("kupfer")
run_once("nautilus -n")
run_once("nm-applet")
