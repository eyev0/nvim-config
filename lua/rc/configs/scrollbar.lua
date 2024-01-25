-- local colors = require("colorscheme").colors

require("scrollbar").setup({
	show_in_active_only = false,
	hide_if_all_visible = true,
	autocmd = {
		render = {
			"BufWinEnter",
			"TabEnter",
			"TermEnter",
			"WinEnter",
			"CmdwinLeave",
			"TextChanged",
			"VimResized",
			"WinScrolled",
		},
		clear = {
			"BufWinLeave",
			"TabLeave",
			"TermLeave",
			"WinLeave",
		},
	},
	handlers = {
		cursor = false,
		diagnostic = true,
		gitsigns = true,
		handle = true,
		search = false,
		ale = false,
	},
	handle = {
		highlight = "CursorLine", -- CursorLine, TermCursor
	},
})

require("scrollbar.handlers.gitsigns").setup()
