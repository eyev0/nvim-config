local dap = require("dap")
local dap_util = require("rc.configs.dap.utils")

dap.adapters.node2 = function(callback, config)
	if config.preLaunchTask then
		-- vim.cmd([[FloatermToggle <bar> Floaterm send ]] .. config.preLaunchTask .. "<CR>")
		-- vim.fn.system(config.preLaunchTask)
		vim.cmd("!" .. config.preLaunchTask)
	end
	local adapter = {
		type = "executable",
		command = "node",
		args = { os.getenv("HOME") .. "/dev/nvim/dap/vscode-node-debug2/out/src/nodeDebug.js" },
	}
	callback(adapter)
end

table.insert(DEBUG_CONFIGS, {
	javascript = {
		{
			name = "Launch javascript file",
			program = dap_util.file_prompt_or_last("javascript"),
		},
	},
})

table.insert(DEBUG_CONFIGS, {
	typescript = {
		{
			name = "Launch typescript file",
			program = dap_util.file_prompt_or_last("typescript"),
			preLaunchTask = "tsc",
		},
	},
})
