local M = {}

function M.tprint(tbl, max_depth, depth)
	if not max_depth then
		max_depth = 2
	end
	if not depth then
		depth = 0
	end
	for k, v in pairs(tbl) do
		local formatting = string.rep("  ", depth) .. k .. ": "
		if type(v) == "table" and depth < max_depth then
			print(formatting)
			M.tprint(v, max_depth, depth + 1)
		else
			print(formatting .. tostring(v))
		end
	end
end

function M.tbl_insert_all(target, ...)
	local tables = { ... }
	if type(target) == "table" then
		for _, t in pairs(tables) do
			if type(t) == "table" then
				for _, value in pairs(t) do
					table.insert(target, value)
				end
			end
		end
	end
	return target
end

-- clear junk from registers and marks
function M.clear_reg_marks()
	local regs = vim.fn.split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', "\zs")
	for _, reg in ipairs(regs) do
		vim.fn.setreg(reg, "")
	end
	vim.cmd("delm!")
	vim.cmd.delm("A-Z0-9")
end

vim.cmd([[
fun! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun
command! TrimWhitespace :call TrimWhitespace()<CR>
]])

return M
