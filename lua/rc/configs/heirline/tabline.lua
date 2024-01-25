local utils = require("heirline.utils")
local api = vim.api
local fn = vim.fn

local TabLineOffset = {
	condition = function(self)
		local win = api.nvim_tabpage_list_wins(0)[1]
		local bufnr = api.nvim_win_get_buf(win)
		self.winid = win

		if vim.bo[bufnr].filetype == "NvimTree" then
			self.title = "NvimTree"
			return true
			-- elseif vim.bo[bufnr].filetype == "TagBar" then
			--     ...
		end
	end,
	provider = function(self)
		local title = self.title
		local width = api.nvim_win_get_width(self.winid)
		local pad = math.ceil((width - #title) / 2)
		return string.rep(" ", pad) .. title .. string.rep(" ", pad)
	end,
	hl = function(self)
		if api.nvim_get_current_win() == self.winid then
			return "TablineSel"
		else
			return "Tabline"
		end
	end,
}

local Tabpage = {
	fallthrough = false,
	-- tabpage for terminal
	{
		condition = function(self)
			for _, tabnr in ipairs(api.nvim_list_tabpages()) do
				local nr = api.nvim_tabpage_get_number(tabnr)
				if nr == self.tabnr then
					local win = api.nvim_tabpage_list_wins(tabnr)[1]
					local bufnr = api.nvim_win_get_buf(win)
					return vim.bo[bufnr].buftype == "terminal"
				end
			end
			return false
		end,
		provider = " term ",
	},
	{
		-- regular tabpage displaying number
		{
			provider = function(self)
				return "%" .. self.tabnr .. "T " .. self.tabnr .. " %T"
			end,
		},
		-- dir path
		{
			provider = function(self)
				-- if fn.haslocaldir(-1, self.tabnr) == 1 then
				local tab_cwd = fn.getcwd(-1, self.tabnr)
				local parent_dir_path = fn.fnamemodify(fn.pathshorten(fn.fnamemodify(tab_cwd, ":~")), ":h")
				local dir_name = fn.fnamemodify(tab_cwd, ":t")
				return "(" .. parent_dir_path .. "/" .. dir_name .. ") "
				-- end
			end,
		},
	},
	hl = function(self)
		if not self.is_active then
			return "TabLine"
		else
			return "TabLineSel"
		end
	end,
}

Tabpage = utils.surround({ "", "" }, function(self)
	if self.is_active then
		return utils.get_highlight("TabLineSel").bg
	else
		return utils.get_highlight("TabLine").bg
	end
end, { Tabpage })

local TabpageClose = {
	provider = "%999X  %X",
	hl = "TabLine",
}

local TabPages = {
	-- only show this component if there's 2 or more tabpages
	condition = function()
		return #api.nvim_list_tabpages() >= 2
	end,
	utils.make_tablist(Tabpage),
	{ provider = "%=" },
	TabpageClose,
}

local TabLine = {
	TabLineOffset,
	--[[BufferLine,]]
	TabPages,
}

return TabLine
