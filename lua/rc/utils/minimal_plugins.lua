return {
  "tpope/vim-repeat",
  {
    "kylechui/nvim-surround",
    config = function()
      require("rc.configs.nvim-surround")
    end,
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("rc.configs.comment")
    end,
  },
  {
    "gbprod/yanky.nvim",
    config = function()
      require("rc.configs.yanky")
    end,
  },
  {
    "gbprod/substitute.nvim",
    config = function()
      require("rc.configs.substitute")
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("rc.configs.autopairs")
    end,
  },
  { "sgur/vim-textobj-parameter", dependencies = { "kana/vim-textobj-user" } },
  -- shortcuts helper
  {
    "folke/which-key.nvim",
    config = function()
      require("rc.configs.which-key")
    end,
  },
  -- file tree
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("rc.configs.nvim_tree")
    end,
    tag = "nightly",
    event = "VimEnter",
  },
  -- treesitter - syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("rc.configs.treesitter")
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  {
    "RRethy/vim-illuminate",
    config = function()
      require("rc.configs.illuminate")
    end,
  },
  -- lsp
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("rc.configs.lsp")
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("rc.configs.lsp.ls.null-ls")
    end,
  },
  -- completion
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/cmp-omni" },
  { "hrsh7th/cmp-nvim-lsp-document-symbol" },
  { "hrsh7th/cmp-nvim-lua" },
  { "hrsh7th/cmp-nvim-lsp-signature-help" },
  {
    "github/copilot.vim",
    init = function()
      vim.g.copilot_no_tab_map = true
    end,
  },
  {
    "hrsh7th/cmp-copilot",
  },
  { "hrsh7th/cmp-vsnip" },
  { "hrsh7th/vim-vsnip" },
  { "rcarriga/cmp-dap" },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("rc.configs.cmp")
    end,
  },
  -- git
  { "tpope/vim-fugitive" },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("rc.configs.gitsigns")
    end,
    event = "ColorScheme",
  },
}
