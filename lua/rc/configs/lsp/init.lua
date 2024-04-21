Lsp = {}

require("rc.configs.lsp.inlay_hints")
require("rc.configs.lsp.on_attach")
require("rc.configs.lsp.diagnostic")
require("rc.configs.lsp.util")

require("neoconf").setup()

require("neodev").setup({
  library = {
    enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
    -- these settings will be used for your Neovim config directory
    runtime = true, -- runtime path
    types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
    -- plugins = true, -- installed opt or start plugins in packpath
    -- you can also specify the list of plugins to make available as a workspace library
    plugins = {
      "noice.nvim",
      -- "spaceless.nvim",
      -- "nvim-cmp",
      -- "telescope.nvim",
      "nvim-surround",
      "toggleterm.nvim",
      -- "heirline.nvim",
      -- "nvim-tree.lua",
      "nvim-lspconfig",
      -- "jumplist.nvim",
      -- "import.nvim",
      -- "nvim-dap",
      "nvim-dap-ui",
    },
    -- plugins = {
    -- 	"nvim-treesitter",
    -- 	"plenary.nvim",
    -- 	"telescope.nvim",
    -- 	"nvim-cmp",
    -- "nvim-jdtls",
    -- 	"neodev.nvim",
    -- 	-- "gitsigns.nvim",
    -- 	-- "dressing.nvim",
    -- 	-- "rest.nvim",
    -- 	-- "nvim-dap",
    -- },
  },
  setup_jsonls = true,
  -- override = function(root_dir, options) end,
  lspconfig = true,
})

require("rc.configs.lsp.ls.vuels")
-- require("rc.configs.lsp.ls.eslint")
require("rc.configs.lsp.ls.tsserver")
-- require("rc.configs.lsp.ls.volar")
require("rc.configs.lsp.ls.lua_ls")
-- require("rc.configs.lsp.ls.teal_ls")
-- require("rc.configs.lsp.ls.rust_analyzer")
-- require("rc.configs.lsp.ls.rls")
require("rc.configs.lsp.ls.solidity")
require("rc.configs.lsp.ls.jdtls")
require("rc.configs.lsp.ls.pyright")
-- require("rc.configs.lsp.ls.pylsp")
-- require("rc.configs.lsp.ls.jedi")
-- require("rc.configs.lsp.ls.pylyzer")
require("rc.configs.lsp.ls.jsonls")
require("rc.configs.lsp.ls.bashls")
require("rc.configs.lsp.ls.yamlls")
-- require("rc.configs.lsp.ls.taplo")
require("rc.configs.lsp.ls.dockerls")
require("rc.configs.lsp.ls.html")
require("rc.configs.lsp.ls.clangd")
require("rc.configs.lsp.ls.gopls")
require("rc.configs.lsp.ls.graphql")
