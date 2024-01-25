-- do not load heirline if it's not present
if not pcall(require, "heirline") then
  return
end

local utils = require("heirline.utils")
local conditions = require("heirline.conditions")

-- dynamic colors
local function setup_colors()
  return {
    bright_bg = utils.get_highlight("Folded").bg,
    bright_fg = utils.get_highlight("Folded").fg,
    red = utils.get_highlight("DiagnosticError").fg or utils.get_highlight("RedSign").fg,
    dark_red = utils.get_highlight("DiffDelete").bg,
    green = utils.get_highlight("Green").fg, -- String
    blue = utils.get_highlight("Blue").fg, -- Function
    gray = utils.get_highlight("Grey").fg, -- NonText
    orange = utils.get_highlight("Orange").fg, -- Constant
    purple = utils.get_highlight("Purple").fg, -- Statement
    cyan = utils.get_highlight("Aqua").fg, -- Special
    diag_warn = utils.get_highlight("DiagnosticWarn").fg or utils.get_highlight("YellowSign").fg,
    diag_error = utils.get_highlight("DiagnosticError").fg or utils.get_highlight("RedSign").fg,
    diag_hint = utils.get_highlight("DiagnosticHint").fg or utils.get_highlight("GreenSign").fg,
    diag_info = utils.get_highlight("DiagnosticInfo").fg or utils.get_highlight("BlueSign").fg,
    git_del = utils.get_highlight("GitSignsDelete").fg,
    git_add = utils.get_highlight("GitSignsAdd").fg,
    git_change = utils.get_highlight("GitSignsChange").fg,
  }
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    utils.on_colorscheme(setup_colors())
  end,
  group = augroup("Heirline", {}),
})

require("heirline").setup({
  statusline = require("rc.configs.heirline.statusline"),
  winbar = require("rc.configs.heirline.winbar"),
  tabline = require("rc.configs.heirline.tabline"),
  opts = {
    disable_winbar_cb = function(args)
      if vim.api.nvim_buf_is_valid(args.buf) then
        return conditions.buffer_matches({
          buftype = { "prompt", "nofile", "help", "quickfix" },
          filetype = { "^git.*", "fugitive", "Trouble", "noice" },
        }, args.buf)
      else
        return true
      end
    end,
  },
})

-- Yep, with heirline we're driving manual!
-- vim.o.showtabline = 2
vim.cmd([[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])
