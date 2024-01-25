local dap = require("dap")

dap.adapters.nlua = function(callback, config)
	callback({ type = "server", host = config.host, port = config.port })
end

local default_host = "127.0.0.1"
local default_port = 8086

dap.configurations.lua = {
	{
		type = "nlua",
		request = "attach",
		name = "Attach to running Neovim instance",
		host = function()
			-- local value = vim.fn.input({ prompt = "Host [127.0.0.1]: " })
			-- if value ~= "" then
			-- 	return value
			-- end
			return default_host
		end,
		port = function()
			-- local value = tonumber(vim.fn.input({ prompt = "Port [8086]: " }))
			-- if value ~= nil then
			-- 	return value
			-- end
			return default_port
		end,
	},
}
