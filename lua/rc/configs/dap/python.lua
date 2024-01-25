local dap = require("dap")

dap.adapters.python = {
  type = "executable",
  command = vim.fn.expand("$HOME") .. "/.venvs/debugpy/bin/python",
  args = { "-m", "debugpy.adapter" },
}

local function get_python_path()
  -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
  -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
  -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
  local cwd = vim.fn.getcwd(-1, 0)
  if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
    return cwd .. "/venv/bin/python"
  elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
    return cwd .. "/.venv/bin/python"
  else
    return "/usr/bin/python"
  end
end

table.insert(DEBUG_CONFIGS, {
  python = {
    {
      -- The first three options are required by nvim-dap
      type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
      request = "launch",
      name = "Launch file",
      -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
      program = "${file}", -- This configuration will launch the current file if used.
      -- module = "app.${fileBasenameNoExtension}",
      cwd = function()
        vim.fn.getcwd(-1, 0)
      end,
      console = "integratedTerminal",
      -- console = "externalTerminal",
      justMyCode = false,
      stopOnEntry = false,
      pythonPath = get_python_path,
    },
    {
      -- The first three options are required by nvim-dap
      type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
      request = "launch",
      name = "Launch module",
      -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
      -- program = "${file}", -- This configuration will launch the current file if used.
      module = function()
        return ENV.PYTHON_MODULE
      end,
      cwd = function()
        return vim.fn.getcwd(-1, 0)
      end,
      console = "integratedTerminal",
      -- console = "externalTerminal",
      justMyCode = false,
      stopOnEntry = false,
      pythonPath = get_python_path,
    },
  },
})
