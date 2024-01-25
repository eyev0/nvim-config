local get_mode = require("lualine.components.mode")
local ok, navic = pcall(require, "nvim-navic")

-- Remove Symbols Nerd Font from your font configuration files, eg.
-- `rm /etc/fonts/conf.d/10-nerd-font-symbols.conf`.

local function is_lsp_attached()
	return next(vim.lsp.get_active_clients()) ~= nil
end

local function get_diagnostics_count(severity)
	if not is_lsp_attached() then
		return nil
	end

	local count = 0

	for _ in pairs(vim.diagnostic.get(0, { severity = severity })) do
		count = count + 1
	end

	return count
end

local function lsp_attached()
	local count = 0
	for _, _ in pairs(vim.lsp.get_active_clients()) do
		count = count + 1
	end
	return count > 0 and "  " .. count or ""
end

local function diagnostic_errors()
	local count = get_diagnostics_count(vim.diagnostic.severity.ERROR)
	return count ~= nil and "  " .. count or ""
end

local function diagnostic_warnings()
	local count = get_diagnostics_count(vim.diagnostic.severity.WARN)
	return count ~= nil and "  " .. count or ""
end

local function diagnostic_hints()
	local count = get_diagnostics_count(vim.diagnostic.severity.HINT)
	return count ~= nil and "  " .. count or ""
end

local function diagnostic_info()
	local count = get_diagnostics_count(vim.diagnostic.severity.INFO)
	return count ~= nil and "  " .. count or ""
end

local function position()
	return string.format("%d/%d:%d", vim.fn.line("."), vim.fn.line("$"), vim.fn.col("."))
end

--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param [ellipsis] boolean whether to disable adding '...' at end after truncation
--- @return function function that can format the component accordingly
---@diagnostic disable-next-line: unused-function
local function trunc(trunc_width, trunc_len, hide_width, ellipsis)
	return function(str)
		local win_width = vim.fn.winwidth(0)
		if hide_width and win_width < hide_width then
			return ""
		elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
			return str:sub(1, trunc_len) .. (ellipsis and "..." or "")
		end
		return str
	end
end

---@diagnostic disable-next-line: unused-function, unused-local
local function hide(hide_width)
	return trunc(1000, 1000, hide_width)
end

require("lualine").setup({
	options = {
		theme = O.colorscheme,
		extensions = { "nvim-tree", "fugitive", "quickfix", "aerial", "man", "nvim-dap-ui" },
		disabled_filetypes = {},
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		-- component_separators = { left = "\\uE0B5", right = "\\uE0B7" },
  --   section_separators = { left = [[\uE0B4]], right = [[\uE0B6]] },
	},
	sections = {
		lualine_a = {
			{
				function()
					if vim.bo.modifiable then
						return get_mode()
					else
						return ""
					end
				end,
				-- fmt = trunc(90, 4, 30),
			},
		},
		lualine_b = {
			{
				"branch", --[[fmt = hide(75)]]
			},
			{
				-- show @recording messages
				require("noice").api.status.mode.get,
				cond = require("noice").api.status.mode.has,
				color = { fg = "#ff9e64" },
				-- fmt = trunc(100, 4, 30),
			},
		},
		lualine_c = {
			{ --[["filename"]]
				function()
					return " " .. vim.fn.expand("%:p"):gsub("/home/yev", "~")
				end,
			},
			{ navic.get_location, cond = navic.is_available },
		},
		lualine_x = {
			{
				function()
					return diagnostic_errors()
						.. diagnostic_warnings()
						.. diagnostic_hints()
						.. diagnostic_info()
						.. lsp_attached()
				end,
				-- fmt = hide(65),
			},
		},
		lualine_y = {
			{
				"filetype", --[[fmt = trunc(100, 1, 40)]]
			},
			{
				"fileformat", --[[fmt = hide(80)]]
			},
			{
				"encoding", --[[fmt = hide(85)]]
			},
		},
		lualine_z = {
			{
				position, --[[fmt = hide(25)]]
			},
		},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
})
