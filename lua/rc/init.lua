---@alias ColorschemeOption "gruvbox-material" | "catppuccin"

--- options
---@class Options
---@field git_worktree_open_file_on_switch string | nil
---@field git_worktree_post_switch_hook function
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
  inlay_hints = true,
  git_rev = "master",
  git_worktree_pre_create_hook = function(_)
    vim.cmd.tabnew()
  end,
  git_worktree_pre_switch_hook = function(_)
    vim.cmd.tabnew()
  end,
  git_worktree_post_create_hook = nil,
  git_worktree_post_switch_hook = function(_)
    vim.cmd("vsplit +enew")
    vim.cmd("NvimTreeClose")
  end,
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
  vis_modes = { "v", "V", "vs", "Vs", "CTRL-V", "CTRL-Vs" },
  ins_modes = { "i", "ic", "ix" },
}

IS_FIRENVIM = vim.g.started_by_firenvim ~= nil or vim.env.NVIM_FIRENVIM == 1

-- disable highlighting matching parens
vim.g.loaded_matchparen = 1

-- map leader to space
pcall(vim.keymap.del, "", "<Space>")
vim.keymap.set("", "<Space>", "<NOP>", { noremap = true, silent = true })
vim.g.mapleader = " "

-- set some global functions
_G.autocmd = vim.api.nvim_create_autocmd
_G.augroup = vim.api.nvim_create_augroup
_G.feedkeys = function(keys, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), mode, false)
end
_G.pprint = function(...)
  print(vim.inspect(...))
end

-- utils
U = require("rc.utils")
_G.tprint = U.tprint

-- DEBUG_CONFIGS should have following structure:
-- { typescript = {{ config1 }, { config2 }, ... }, lua = { { ... }, { ... } }}
DEBUG_CONFIGS = {}

-- set options
require("rc.options")
-- init os-specific f-keys remaps
require("rc.os_keys_remap")
-- require("rc.terminfo")

-- plugins
-- init lazy
if not vim.loop.fs_stat(O.lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    O.lazypath,
  })
end
vim.opt.rtp:prepend(O.lazypath)
local opts = {
  root = O.pluginspath,
  defaults = { lazy = false },
  install = { missing = true },
  dev = {
    path = O.devpath,
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = {}, -- For example {"folke"}
    fallback = false, -- Fallback to git when local plugin doesn't exist
  },
  performance = {
    rtp = {
      disabled_plugins = {
        -- "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        -- "tarPlugin",
        "tohtml",
        "tutor",
        -- "zipPlugin",
      },
    },
  },
}

local plugins
plugins = require("rc.plugins")
require("lazy").setup(plugins, opts)

-- U.clear_reg_marks()
-- keymaps are set in ./after/plugin/keymappings.lua
