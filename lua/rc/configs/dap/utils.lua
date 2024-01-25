local M = {}

M.last_debugged_files = {}

M.file_prompt_or_last = function(filetype)
	return function()
		local value
		local last = M.last_debugged_files[filetype]
		if last == nil then
			value = vim.fn.input("File[empty = current]: ")
			if value ~= "" then
				if value == "!" then
					value = last
				end
			else
				-- current buffer
				value = vim.fn.expand("%:p")
			end
		else
			value = vim.fn.input("File[empty = current, l = " .. last .. "]: ")
			if value ~= "" then
				if value == "l" then
					-- current buffer
					value = last
				end
			else
				value = vim.fn.expand("%:p")
			end
		end
		M.last_debugged_files[filetype] = value
		return value
	end
end

return M
