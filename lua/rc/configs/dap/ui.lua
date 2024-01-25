local dap, dapui = require("dap"), require("dapui")

dapui.setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<2-LeftMouse>", "o" },
    open = "<CR>",
    remove = "d",
    edit = "e",
    toggle = "t",
    repl = "r",
  },
  layouts = {
    {
      elements = {
        { id = "stacks", size = 0.6 },
        { id = "watches", size = 0.2 },
        { id = "breakpoints", size = 0.2 },
      },
      size = 0.15,
      position = "left",
    },
    {
      elements = {
        { id = "scopes", size = 0.7 },
        { id = "repl", size = 0.3 },
        -- "console",
      },
      size = 0.26,
      position = "bottom",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

dap.defaults.fallback.terminal_win_cmd = "tabnew DapConsole"
