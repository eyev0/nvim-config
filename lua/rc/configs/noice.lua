require("notify").setup({
  background_colour = "#000000",
  fps = 30,
  icons = {
    DEBUG = "",
    ERROR = "",
    INFO = "",
    TRACE = "✎",
    WARN = "",
  },
  level = 2,
  minimum_width = 40,
  max_width = 90,
  render = "minimal",
  stages = "static",
  timeout = 2200,
  top_down = true,
})

require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
    progress = {
      enabled = false,
    },
  },
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },
  cmdline = {
    -- view = "cmdline",
  },
  messages = {
    view = "mini",
  },
  views = {},
  routes = {
    {
      filter = {
        any = {
          {
            event = "msg_show",
            kind = "",
            find = "B written",
          },
          {
            event = "msg_show",
            kind = "",
            find = "buffer unloaded",
          },
          {
            event = "msg_show",
            find = "Starting Java Language Server",
          },
          {
            event = "msg_show",
            kind = "emsg",
            find = "E380",
          },
          {
            event = "msg_show",
            kind = "emsg",
            find = "E381",
          },
          {
            event = "msg_show",
            kind = "emsg",
            find = "E553",
          },
          {
            event = "msg_show",
            kind = "emsg",
            find = "E486",
          },
        },
      },
      opts = { skip = true },
    },
    {
      filter = { kind = "confirm_sub" },
      opts = { skip = false, stop = true },
      view = "virtualtext",
    },
    {
      filter = {
        any = {
          {
            event = "msg_show",
            kind = "",
            find = "error list",
          },
          {
            event = "msg_show",
            kind = "emsg",
            find = "E42",
          },
          {
            event = "msg_show",
            kind = "wmsg",
            find = "search hit BOTTOM, continuing at TOP",
          },
          {
            event = "msg_show",
            kind = "wmsg",
            find = "search hit TOP, continuing at BOTTOM",
          },
        },
      },
      view = "mini",
    },
  },
  -- status = {},
})
