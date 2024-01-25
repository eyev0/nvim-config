require("rest-nvim").setup({
	-- Open request results in a horizontal split
	result_split_horizontal = false,
	-- Keep the http file buffer above|left when split horizontal|vertical
	result_split_in_place = true,
	-- Skip SSL verification, useful for unknown certificates
	skip_ssl_verification = false,
	-- Encode URL before making request
	encode_url = true,
	-- Highlight request on run
	highlight = {
		enabled = true,
		timeout = 200,
	},
	result = {
		-- toggle showing URL, HTTP info, headers at top the of result window
		show_url = true,
		show_http_info = true,
		show_headers = true,
		-- executables or functions for formatting response body [optional]
		-- set them to nil if you want to disable them
		formatters = {
			json = "jq",
			html = function(body)
				return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
			end,
		},
	},
	-- Jump to request line on run
	jump_to_request = false,
	env_file = "dev.env",
	custom_dynamic_variables = {
		["$date"] = function()
			local os_date = os.date("%Y-%m-%d")
			return os_date
		end,
	},
	yank_dry_run = true,
})

vim.cmd([[command! -nargs=0 RestNvimRun :lua require('rest-nvim').run()]])
vim.cmd([[command! -nargs=0 RestNvimPreview :lua require('rest-nvim').run(true)]])
vim.cmd([[command! -nargs=0 RestNvimRunLast :lua require('rest-nvim').last()]])

autocmd("BufWinEnter", {
	group = augroup("RestNvimSplitRight", {}),
	callback = function()
		if vim.bo.filetype == "httpResult" then
			vim.api.nvim_win_call(0, function()
				vim.cmd("wincmd L")
			end)
		end
	end,
})
