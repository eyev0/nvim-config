local ignore_modes = require("rc.utils.keymap").vis_modes
table.insert(ignore_modes, "i")

require("illuminate").configure({
	delay = 90,
	large_file_cutoff = 2000,
  modes_denylist = ignore_modes,
	min_count_to_highlight = 2,
	under_cursor = true,
})

vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("illuminateSetHl", {}),
	callback = function()
		vim.api.nvim_set_hl(0, "IlluminatedWordText", {
      underline = true,
		})
		vim.api.nvim_set_hl(0, "IlluminatedWordRead", {
      underline = true,
		})
		vim.api.nvim_set_hl(0, "IlluminatedWordWrite", {
      bold = true,
      -- italic = true,
      underline = true,
		})
	end,
})
