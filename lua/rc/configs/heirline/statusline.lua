local conditions = require("heirline.conditions")
local c = require("rc.configs.heirline.components")

local DefaultStatusline = {
  c.ModeBlock,
  -- c.Space,
  -- c.WorkDir,
  -- c.Space,
  c.FileNameBlockFactory(true, 0.20),
  c.Space,
  c.Git,
  c.Diagnostics,
  c.Align,
  -- c.Navic,
  c.Align,
  c.DAPMessages,
  c.ShowCmd,
  c.SearchCount,
  c.LSPActive,
  c.Space,
  c.Space,
  c.FileType,
  c.Space,
  c.FileSize,
  -- Space,
  -- FileLastModified,
  c.Space,
  c.Ruler,
  c.Space,
  c.ScrollBar,
}

local InactiveStatusline = {
  condition = conditions.is_not_active,
  c.FileType,
  c.Space,
  c.FileNameBlockFactory(true, 0.30),
  c.Align,
}

local SpecialStatusline = {
  condition = function()
    return conditions.buffer_matches({
      buftype = { "nofile", "prompt", "help", "quickfix" },
      filetype = { "^git.*", "fugitive" },
    })
  end,
  c.ModeBlock,
  c.Space,
  c.FileNameBlockFactory(false),
  c.Space,
  c.FileType,
  c.Space,
  c.Align,
  c.ShowCmd,
  c.SearchCount,
  c.FileSize,
  c.Space,
  c.Ruler,
  c.Space,
  c.ScrollBar,
  c.Space,
}

local TerminalStatusline = {
  condition = function()
    return conditions.buffer_matches({ buftype = { "terminal" } })
  end,
  hl = { bg = "dark_red" },
  -- Quickly add a condition to the ViMode to only show it when buffer is active!
  { condition = conditions.is_active, c.ModeBlock, c.Space },
  c.FileType,
  c.Space,
  c.Align,
  c.ShowCmd,
  c.SearchCount,
  c.Ruler,
  c.Space,
}

local StatusLines = {
  hl = function()
    if conditions.is_active() then
      return "StatusLine"
    else
      return "StatusLineNC"
    end
  end,
  -- the first statusline with no condition, or which condition returns true is used.
  -- think of it as a switch case with breaks to stop fallthrough.
  fallthrough = false,
  SpecialStatusline,
  TerminalStatusline,
  InactiveStatusline,
  DefaultStatusline,
}

return StatusLines
