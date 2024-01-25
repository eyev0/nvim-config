local yank_hl_timeout = 200
require("yanky").setup({
	highlight = {
		on_put = false,
		on_yank = false,
		timer = yank_hl_timeout,
	},
})

-- vim.api.nvim_set_hl(0, "YankyPut", { link = "Search" })

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "CurSearch", timeout = yank_hl_timeout })
	end,
})
-- au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}
