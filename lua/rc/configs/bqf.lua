require("bqf").setup({
	auto_resize_height = false,
	preview = {
		auto_preview = false,
		win_height = 999,
		win_vheight = 22,
		border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
	},
	filter = {
		fzf = {
			extra_opts = { "--bind", "ctrl-o:toggle-all", "--exact" },
		},
	},
})

