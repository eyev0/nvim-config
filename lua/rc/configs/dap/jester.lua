JEST_CONFIG = {
	cmd = "npx jest -t '$result' -- $file", -- run command
	terminal_cmd = ":tabnew | terminal",
}
-- Run nearest test(s) under the cursor
vim.cmd([[command! JesterRun lua require("jester").run(JEST_CONFIG)]])
-- Run current file
vim.cmd([[command! JesterRunFile lua require("jester").run_file(JEST_CONFIG)]])
-- Run last test(s)
vim.cmd([[command! JesterRunLast lua require("jester").run_last(JEST_CONFIG)]])
-- Debug nearest test(s) under the cursor
vim.cmd([[command! JesterDebug lua require("jester").debug(JEST_CONFIG)]])
-- Debug current file
vim.cmd([[command! JesterDebugFile lua require("jester").debug_file(JEST_CONFIG)]])
-- Debug last test(s)
vim.cmd([[command! JesterDebugLast lua require("jester").debug_last(JEST_CONFIG)]])

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- our picker function: colors
local function actions_picker(opts)
	opts = opts or {}
	return function()
		pickers.new(opts, {
			prompt_title = "Jester Actions",
			finder = finders.new_table({
				results = {
          "test file with coverage",
					"test file",
					"test all",
					"test all with coverage",
					"run",
					"debug",
					"run_file",
					"run_last",
					"debug_file",
					"debug_last",
				},
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					-- print(vim.inspect(map))
					-- print(vim.inspect(selection))
					-- vim.api.nvim_put({ selection[1] }, "", false, true)
					if selection[1] == "test file" then
						vim.cmd("split | terminal npx jest " .. vim.fn.expand("%:."))
					end
					if selection[1] == "test file with coverage" then
						vim.cmd(
							'split | terminal npx jest --coverage --collectCoverageFrom="" ' .. vim.fn.expand("%:.")
						)
					end
					if selection[1] == "test all" then
						vim.cmd("split | terminal npx jest")
					end
					if selection[1] == "test all with coverage" then
						vim.cmd("split | terminal npx jest --coverage")
					end
					if require("jester")[selection[1]] ~= nil then
						require("jester")[selection[1]](JEST_CONFIG)
					end
				end)
				return true
			end,
		}):find()
	end
end

-- to execute the function
-- colors()

vim.cmd([[command! JesterActions lua require("rc.configs.dap.jester").picker(require("telescope.themes").get_dropdown{})()]])

return { picker = actions_picker }
