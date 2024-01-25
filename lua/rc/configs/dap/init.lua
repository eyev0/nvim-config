-- source all global configs
require("rc.configs.dap.node2")
require("rc.configs.dap.java")
require("rc.configs.dap.nlua")
-- require("rc.configs.dap.go")
require("rc.configs.dap.python")

local dap = require("dap")

-- dap.defaults.fallback.terminal_win_cmd = "tabnew DapConsole"
-- dap.defaults.fallback.terminal_win_cmd = function()
-- 	local term = require("toggleterm.terminal").Terminal:new({
--     direction = "tab",
--     on_create = function()
--       vim.cmd("startinsert!")
--     end,
--     on_open = function()
--       vim.cmd("startinsert!")
--     end,
--   })
--   return term.bufnr, term.window
-- 	-- return bufnr, winnr
-- end
dap.defaults.fallback.force_external_terminal = false
dap.defaults.fallback.external_terminal = {
	command = "tmux",
	args = { "split-pane", "-p", "20", "-c", vim.fn.getcwd(), "';'", "set", "-p", "remain-on-exit", "on" },
	-- args = { "split-pane", "-c", vim.fn.getcwd() },
}

-- autocomplete in repl
vim.cmd([[au FileType dap-repl lua require('dap.ext.autocompl').attach()]])
-- sign for breakpoints
vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "❓", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "❌", texthl = "", linehl = "", numhl = "" })

-- dap default configuration values per language
DEBUG_CONFIGS_BASE = {
	typescript = {
		type = "node2",
		request = "launch",
		cwd = vim.fn.getcwd(),
		outFiles = {
			"${workspaceFolder}/dist/**/*.js",
			"${workspaceFolder}/dist/*.js",
			"${workspaceFolder}/lib/**/*.js",
			"${workspaceFolder}/lib/*.js",
		},
		sourceMaps = true,
		protocol = "inspector",
		console = "integratedTerminal",
	},
	javascript = {
		type = "node2",
		request = "launch",
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		protocol = "inspector",
		console = "integratedTerminal",
	},
}

-- merge workspace configs with base configs
local M = {}

local function add_debug_configs(new_configs)
	if vim.tbl_count(new_configs) == 0 then
		return
	end
	for lang, configs in pairs(new_configs) do
		if dap.configurations[lang] == nil then
			dap.configurations[lang] = {}
		end
		local merged_configs = {}
		merged_configs[lang] = {}
		-- merge base lang config with all workspace configs
		for _, config in pairs(configs) do
			table.insert(merged_configs[lang], vim.tbl_deep_extend("force", {}, DEBUG_CONFIGS_BASE[lang] or {}, config))
		end
		-- insert all merged configs into dap.configurations.language
		U.tbl_insert_all(dap.configurations[lang], merged_configs[lang])
	end
end

for _, conf in ipairs(DEBUG_CONFIGS) do
	add_debug_configs(conf)
end

-- load a subset of vscode configurations that are supported
if vim.loop.fs_stat(vim.fn.getcwd() .. "/launch.json") then
	require("dap.ext.vscode").load_launchjs(
		vim.fn.getcwd() .. "/launch.json",
		{ ["pwa-node"] = { "javascript", "typescript" } }
	)
end
-- require("dap.ext.vscode").load_launchjs(nil, { ["pwa-node"] = { "javascript", "typescript" } })

M.add_debug_configs = add_debug_configs

return M
