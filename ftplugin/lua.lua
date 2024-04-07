vim.cmd("setlocal tabstop=2 shiftwidth=2 softtabstop=2")

local surround = require("nvim-surround")
local surround_config = require("nvim-surround.config")

surround.buffer_setup({
  surrounds = {
    c = surround_config.default_opts.surrounds["f"],
    f = {
      add = { { "function() " }, { " end" } },
      find = function()
        return surround_config.get_selection({ motion = "af" })
      end,
      delete = "^(l?o?c?a?l? ?function ?.-%(.-%)%s+)().+(%s+end)()$",
    },
    i = {
      add = function()
        return { { "if true then " }, { " end" } }
      end,
      find = function()
        return surround_config.get_selection({ motion = "ai" })
      end,
      delete = "^(if .- then%s+)().+(%s+end)()$",
    },
    I = {
      add = function()
        return { { "if " }, { " then end" } }
      end,
      find = function()
        return surround_config.get_selection({ motion = "ai" })
      end,
      delete = "^(if )().-( then%s+.+%s+end)()$",
    },
    l = {
      add = function()
        return {
          { "for _, value in ipairs(tbl) do " },
          { " end" },
        }
      end,
      find = function()
        return surround_config.get_selection({ motion = "al" })
      end,
      delete = "^(for .- in i?pairs%(.-%) do%s+)().+(%s+end)()$",
    },
    L = {
      add = function()
        return {
          { "for _, value in ipairs(" },
          { ") do return end" },
        }
      end,
      find = function()
        return surround_config.get_selection({ motion = "al" })
      end,
      delete = "^(for .- in i?pairs%()().-(%) do%s*.+%s*end)()$",
    },
    w = {
      add = function()
        return {
          { "while true do " },
          { " end" },
        }
      end,
      find = function()
        return surround_config.get_selection({ motion = "al" })
      end,
      delete = "^(while .- do%s+)().+(%s+end)()$",
    },
    W = {
      add = function()
        return {
          { "while " },
          { " do return end" },
        }
      end,
      find = function()
        return surround_config.get_selection({ motion = "al" })
      end,
      delete = "^(while )().-( do%s*.+%s*end)()$",
    },
  },
})
