-- editing
return {
  "tpope/vim-repeat",
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
        keymaps = {
          insert = false,
          insert_line = false,
        },
      })
    end,
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
    event = "VeryLazy",
  },
  {
    "gbprod/substitute.nvim",
    config = function()
      require("substitute").setup({
        -- on_substitute = function(event)
        -- 	require("yanky").init_ring("p", event.register, event.count, event.vmode:match("[vV�]"))
        -- end,
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      -- cmp.event:on("confirm_done", function(...)
      -- 	local a = { ... }
      -- 	return cmp_autopairs.on_confirm_done({ map_char = { tex = "" } })(...)
      -- end)
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt", "vim" },
        check_ts = true,
      })
    end,
    commit = "7b3eb9b5813a22188c4dbb248475fcbaf9f4d195",
    -- branch = "local",
    -- branch = "master",
    event = "VeryLazy",
  },
  { "mbbill/undotree" },
  "lambdalisue/suda.vim",
  -- filetype-specific
  { "gpanders/editorconfig.nvim" },
  {
    "toppair/peek.nvim", -- markdown preview
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
    event = "VeryLazy",
  },
  -- keyboard layout
  {
    "keaising/im-select.nvim",
    config = function()
      require("im_select").setup({})
    end,
    -- enabled = false,
  },
}
