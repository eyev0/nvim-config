vim.cmd([[command! SessionDeleteCurrent lua require("persistence").delete_current()]])
vim.cmd([[command! SessionLoadLast lua require("persistence").load({ last = true })]])
vim.cmd([[command! SessionStop lua require("persistence").stop()]])

require("persistence").setup({
	dir = vim.fn.expand(vim.fn.stdpath("cache") .. "/sessions/"), -- directory where session files are saved
	options = { "tabpages", "winsize", "winpos", "help" }, -- sessionoptions used for saving
})
