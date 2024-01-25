vim.g.indent_blankline_show_first_indent_level = false

require("ibl").setup({
  exclude = {
    filetypes = {
      "lspinfo",
      "packer",
      "checkhealth",
      "help",
      "",
      "floaterm",
      "noice",
      "notify",
      "ImportManager",
    },
    buftypes = { "terminal", "quickfix" },
  },
})

-- replace CursorMoved with CursorHold
-- local id = augroup("IndentBlanklineContextAutogroup", { clear = true })
-- autocmd("CursorHold", {
--   group = id,
--   callback = function()
--     vim.cmd("IndentBlanklineRefresh")
--   end,
-- })

local hooks = require("ibl.hooks")
hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
-- hooks.register(hooks.type.SKIP_LINE, hooks.builtin.skip_preproc_lines, { bufnr = 0 })

local max_lines = 5000
local aug_id = augroup("IBLDisableOnThreshold", {})

local set_threshold_filetypes = {
  "json",
  "httpResult",
}

autocmd("BufEnter", {
  group = aug_id,
  callback = function(opts)
    if
      vim.tbl_contains(set_threshold_filetypes, vim.bo[opts.buf].filetype) and vim.fn.line("$") > max_lines
    then
      local ok, ibl = pcall(require, "ibl")
      if ok then
        ibl.setup_buffer(0, {
          enabled = false,
        })
      end
    end
  end,
})
