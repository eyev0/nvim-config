---@alias ColorschemeOption "gruvbox-material" | "catppuccin"

--- options
---@class Options
O = {
  scrolloff = 9,
  sidescrolloff = 15,
  signcolumn = "auto:1-2",
  -- keep this many lines in terminal buffer
  scrollback = 20000,
  ---@type ColorschemeOption
  colorscheme = "gruvbox-material",
  background = "dark",
  lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
  pluginspath = vim.fn.stdpath("data") .. "/lazy",
  devpath = vim.env.HOME .. "/dev/personal/neovim-plugins",
  inlay_hints = false,
  git_rev = "master",
  git_worktree_open_file_on_switch = "",
  git_worktree_post_hook_cmd = "",
  -- copilot = true,
  ft = {
    go = {
      expandtab = false,
      shiftwidth = 4,
      tabstop = 4,
      softtabstop = 4,
    },
  },
  python_module = "app",
}

require("rc")
