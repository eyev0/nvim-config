local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local c = require("rc.configs.heirline.components")

local WinBars = {
  fallthrough = false,
  { -- A special winbar for terminals
    condition = function()
      return conditions.buffer_matches({ buftype = { "terminal" } })
    end,
    utils.surround({ "", "" }, "dark_red", {
      c.FileType,
      c.Space,
      c.TerminalName,
    }),
  },
  { -- An inactive winbar for regular files
    condition = function()
      return not conditions.is_active()
    end,
    utils.surround(
      { "", "" },
      "bright_bg",
      { hl = { fg = "gray", force = true }, c.FileNameBlockFactory(false) }
    ),
  },
  { -- A winbar for regular files
    utils.surround({ "", "" }, "bright_bg", c.FileNameBlockFactory(false)),
    {
      -- update = { "OptionSet", "BufEnter" },
      update = { "OptionSet", "BufEnter" },
      condition = function()
        return vim.g.heirline_show_winbufnrs == true
      end,
      utils.surround({ "", "" }, "bright_bg", c.WinBufNrs),
    },
    c.Space,
    -- c.Navic,
  },
}

return WinBars
