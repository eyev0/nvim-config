require("oil").setup({
	skip_confirm_for_simple_edits = true,
  restore_win_options = false,
	keymaps = {
		["<C-s>"] = false,
		["<C-w>s"] = "actions.select_split",
		["<C-h>"] = false,
		["<C-w>v"] = "actions.select_vsplit",
		-- ["<C-p>"] = "actions.preview",
		["<C-p>"] = false,
		-- ["<C-c>"] = "actions.close",
		["<Esc>"] = "actions.close",
		["<C-c>"] = false,
		["<C-l>"] = false,
		["R"] = "actions.refresh",
    ["-"] = false,
    ["<BS>"] = "actions.parent",
	},
  view_options = {
    show_hidden = true,
  },
})
