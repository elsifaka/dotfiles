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
		screen    = 1,
		slave     = true,
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
