local pluginspath = vim.fn.stdpath("data") .. "/lazy"

--- options
---@class Options
---@field scrolloff number
---@field sidescrolloff number
---@field colorscheme ColorschemeOption
O = {
  scrolloff = 9,
  sidescrolloff = 15,
  signcolumn = "yes:2",
  -- keep this many lines in terminal buffer
  scrollback = 20000,
  colorscheme = "gruvbox-material",
  background = "light",
  lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
  pluginspath = pluginspath,
  devpath = vim.env.HOME .. "/dev/nvim/plugins",
  inlay_hints = false,
  -- copilot = true,
  ft = {
    go = {
      shiftwidth = 4,
      tabstop = 4,
      softtabstop = 4,
    }
  }
}

ENV = {
  PYTHON_MODULE = "app",
}

require("rc")
