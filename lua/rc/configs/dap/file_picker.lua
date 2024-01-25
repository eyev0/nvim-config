local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- not doable for now at least
local function last_debug_runs_prompt(opts)
	opts = opts or {}
	return function()
		pickers.new(opts, {
			prompt_title = "Debugger runs",
			finder = finders.new_table({
				results = { "red", "green", "blue" },
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					-- print(vim.inspect(selection))
					-- vim.api.nvim_put({ selection[1] }, "", false, true)
					return selection[1]
				end)
				return true
			end,
		}):find()
	end
end

vim.cmd(
	[[command! DapLastRunsPicker lua require("rc.configs.dap.file_picker").last_debug_runs_prompt(require("telescope.themes").get_dropdown{})()]]
)

return { last_debug_runs_prompt = last_debug_runs_prompt }
