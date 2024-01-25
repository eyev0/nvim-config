---@class Terms
---@field count number
---@field bufnrs table<number, true>
---@field terms table<string, Terminal>
local M = { count = 0, bufnrs = {}, terms = {} }

local Terminal = require("toggleterm.terminal").Terminal
M.terms.lazygit = Terminal:new({
	cmd = "lazygit",
	direction = "float",
	float_opts = {
		border = "double",
	},
  on_create = function(term)
		vim.keymap.set("n", "q", "<cmd>close<CR>", { noremap = true, silent = true, buffer = term.bufnr })
  end,
	on_open = function()
		vim.cmd("startinsert!")
	end,
})

require("toggleterm").setup({
	on_create = function(term)
		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("ToggleTermBufEnter", {}),
			buffer = term.bufnr,
			callback = function()
				vim.cmd("startinsert!")
			end,
		})
		vim.cmd("startinsert!")
	end,
	on_exit = function()
		vim.cmd("startinsert!")
	end,
})

return M
