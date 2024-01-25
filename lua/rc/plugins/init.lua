return {
  -- docs in neovim
  { "paretje/nvim-man", enabled = false },
  -- dependency packages
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",
  "rktjmp/lush.nvim",
  -- "MunifTanjim/nui.nvim",
  -- "rcarriga/nvim-notify",
  -- neovim/lua development
  { "folke/neodev.nvim" },
  { "folke/neoconf.nvim" },
  { "jbyuki/one-small-step-for-vimkind" },
  -- {
  --   "miversen33/import.nvim",
  --   config = function()
  --     require("import")
  --   end,
  -- },
  {
    "rafcamlet/nvim-luapad",
    config = function()
      require("rc.configs.luapad")
    end,
  },
  "nanotee/luv-vimdocs",
  "milisims/nvim-luaref",
  -- editing
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
    event = "VeryLazy",
  },
  -- {
  --   "gbprod/yanky.nvim",
  --   config = function()
  --     require("rc.configs.yanky")
  --   end,
  -- },
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
    -- commit = "7b3eb9b5813a22188c4dbb248475fcbaf9f4d195",
    branch = "local",
    -- branch = "master",
    event = "VeryLazy",
  },
  { "mbbill/undotree" },
  "lambdalisue/suda.vim",
  -- filetype-specific
  {
    "nathom/filetype.nvim",
    config = function()
      require("rc.configs.filetype")
    end,
  },
  { "gpanders/editorconfig.nvim" },
  -- {
  --   "epwalsh/obsidian.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   opts = {
  --     workspaces = {
  --       {
  --         name = "personal",
  --         path = "~/dev/self/obsidian/personal",
  --       },
  --       {
  --         name = "work",
  --         path = "~/dev/self/obsidian/work",
  --       },
  --     },
  --     daily_notes = {
  --       folder = "notes/dailies",
  --     },
  --     -- disable_frontmatter = true,
  --     note_frontmatter_func = function(note)
  --       return { id = note.id, aliases = note.aliases, tags = note.tags }
  --     end,
  --   },
  -- },
  { "chrisbra/csv.vim", ft = "csv" },
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
  -- ui/input
  {
    "folke/noice.nvim",
    config = function()
      require("rc.configs.noice")
    end,
    tag = "v2.0.0",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    -- dev = true,
    -- dir = O.devpath .. "/noice.nvim",
    -- branch = "local",
    -- enabled = false,
  },
  {
    "rebelot/heirline.nvim",
    config = function()
      require("rc.configs.heirline")
    end,
    cond = not IS_FIRENVIM,
    event = "ColorScheme",
  },
  -- {
  --   "petertriho/nvim-scrollbar",
  --   config = function()
  --     require("rc.configs.scrollbar")
  --   end,
  --   enabled = false,
  -- },
  -- {
  --   "stevearc/stickybuf.nvim",
  --   config = function()
  --     require("rc.configs.stickybuf")
  --   end,
  --   enabled = false,
  -- },
  "szw/vim-maximizer",
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("rc.configs.indent_blankline")
    end,
    enabled = true,
  },
  {
    "stevearc/dressing.nvim",
    config = function()
      require("rc.configs.dressing")
    end,
    event = "VeryLazy",
  },
  {
    "folke/which-key.nvim",
    config = function()
      require("rc.configs.which-key")
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("rc.configs.nvim_tree")
    end,
    tag = "nightly",
    event = "VimEnter",
  },
  {
    "folke/todo-comments.nvim",
    config = function()
      require("rc.configs.todo-comments")
    end,
  },
  -- treesitter/editing based on treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("rc.configs.treesitter")
    end,
    event = "VeryLazy",
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      require("ts_context_commentstring").setup({})
      vim.g.skip_ts_context_commentstring_module = true
    end,
    event = "VeryLazy",
  },
  { "theHamsta/nvim-treesitter-pairs", event = "VeryLazy" },
  { "windwp/nvim-ts-autotag", event = "VeryLazy" },
  { "nvim-treesitter/nvim-treesitter-textobjects", event = "VeryLazy" },
  { "David-Kunz/treesitter-unit", event = "VeryLazy" },
  {
    "romgrk/nvim-treesitter-context",
    config = function()
      require("rc.configs.treesitter.context")
    end,
    dev = true,
    -- branch = "local",
    event = "VeryLazy",
  },
  {
    "nvim-treesitter/playground",
    build = ":TSInstall query",
    enabled = false,
  },
  -- lsp/lsp-based editing/highlighting
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("rc.configs.lsp")
    end,
  },
  { "mfussenegger/nvim-jdtls" },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("rc.configs.lsp.ls.null-ls")
    end,
    event = "VeryLazy",
    dependencies = { "neovim/nvim-lspconfig" },
  },
  { "jose-elias-alvarez/nvim-lsp-ts-utils" },
  {
    "simrat39/rust-tools.nvim",
    config = function()
      require("rc.configs.rust-tools")
    end,
    enabled = true,
    -- event = "VeryLazy",
  },
  {
    "kosayoda/nvim-lightbulb",
    config = function()
      require("rc.configs.lightbulb")
    end,
    event = "VeryLazy",
  },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    config = function()
      require("rc.configs.fidget")
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    config = true,
    event = "VeryLazy",
  },
  {
    "RRethy/vim-illuminate",
    config = function()
      require("rc.configs.illuminate")
    end,
    event = "VeryLazy",
  },
  {
    "stevearc/aerial.nvim",
    config = function()
      require("rc.configs.aerial")
    end,
    event = "VeryLazy",
  },
  {
    -- "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    name = "lsp_lines.nvim",
    dir = O.devpath .. "/lsp_lines.nvim",
    dev = true,
    config = true,
  },
  -- completion/snippets
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/cmp-omni" },
  { "hrsh7th/cmp-nvim-lsp-document-symbol" },
  { "hrsh7th/cmp-nvim-lua" },
  { "hrsh7th/cmp-nvim-lsp-signature-help" },
  { "hrsh7th/cmp-vsnip" },
  { "hrsh7th/vim-vsnip" },
  { "rcarriga/cmp-dap" },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("rc.configs.cmp")
    end,
  },
  {
    "saecki/crates.nvim",
    tag = "v0.3.0",
    event = "VeryLazy",
    config = function()
      require("crates").setup({
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
      })
    end,
  },
  { "onsails/lspkind.nvim" },
  { "rafamadriz/friendly-snippets" },
  -- regex
  {
    "bennypowers/nvim-regexplainer",
    config = function()
      require("rc.configs.regexplainer")
    end,
    enabled = false,
  },
  -- navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    config = function()
      require("harpoon"):setup()
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "unblevable/quick-scope",
    init = function()
      vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }
      vim.g.qs_max_chars = 150
      vim.g.qs_buftype_blacklist = { "terminal", "nofile" }
      vim.g.qs_lazy_highlight = 1
      vim.g.qs_delay = 10
    end,
  },
  -- terminal
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("rc.configs.toggleterm")
    end,
  },
  -- git
  { "tpope/vim-fugitive" },
  {
    "sindrets/diffview.nvim",
    config = function()
      require("rc.configs.diffview")
    end,
  },
  { "tpope/vim-rhubarb" },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("rc.configs.gitsigns")
    end,
    event = "ColorScheme",
  },
  -- quickfix
  {
    "kevinhwang91/nvim-bqf",
    config = function()
      require("rc.configs.bqf")
    end,
    -- enabled = false,
    dependencies = {
      "junegunn/fzf",
      build = function()
        vim.fn["fzf#install"]()
      end,
    },
  },
  -- cmdline
  {
    "notomo/cmdbuf.nvim",
    config = function()
      autocmd({ "User" }, {
        group = augroup("CmdbufWipeOnHide", {}),
        pattern = "CmdbufNew",
        callback = function(opts)
          vim.bo[opts.buf].bufhidden = "wipe"
        end,
      })
    end,
  },
  -- tmux
  {
    "christoomey/vim-tmux-navigator",
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },
  { "tmux-plugins/vim-tmux" }, -- syntax highlighting for .tmux.conf
  { "danielpieper/telescope-tmuxinator.nvim" },
  -- sql
  -- { "tpope/vim-dadbod" },
  -- { "kristijanhusak/vim-dadbod-ui" },
  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("rc.configs.telescope")
    end,
    dependencies = {
      {
        "folke/trouble.nvim",
        config = true,
      },
      { "nvim-telescope/telescope-dap.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    event = "VimEnter",
  },
  -- workspace/sessions
  {
    "ethanholz/nvim-lastplace",
    config = function()
      require("rc.configs.lastplace")
    end,
  },
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/Downloads", "/" },
      })
    end,
  },
  -- debugging
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("rc.configs.dap")
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function()
      require("rc.configs.dap.ui")
    end,
    event = "VeryLazy",
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("rc.configs.dap.virtual-text")
    end,
  },
  { "leoluz/nvim-dap-go", config = true },
  -- tests
  {
    "David-Kunz/jester",
    config = function()
      require("rc.configs.dap.jester")
    end,
    event = "VeryLazy",
  },
  {
    "nvim-neotest/neotest",
    enabled = false,
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-jest")({
            jestCommand = "npm test --",
            -- jestConfigFile = "custom.jest.config.ts",
            env = { CI = true },
            -- cwd = function(path)
            --   return vim.fn.getcwd(-1, -1)
            -- end,
          }),
        },
      })
    end,
    event = "VeryLazy",
  },
  { "haydenmeade/neotest-jest" },
  -- keyboard layout
  {
    "Wansmer/langmapper.nvim",
    priority = 1, -- High priority is needed if you will use `autoremap()`
    config = function()
      require("langmapper").setup({
        ---@type boolean Add mapping for every CTRL+ binding or not.
        map_all_ctrl = true,
        ---@type string[] Modes to `map_all_ctrl`
        ---Here and below each mode must be specified, even if some of them extend others.
        ---E.g., 'v' includes 'x' and 's', but must be listed separate.
        ctrl_map_modes = { "n", "o", "i", "c", "t", "v" },
        ---@type boolean Wrap all keymap's functions (nvim_set_keymap etc)
        hack_keymap = true,
        ---@type string[] Usually you don't want insert mode commands to be translated when hacking.
        ---This does not affect normal wrapper functions, such as `langmapper.map`
        -- disable_hack_modes = { "i" },
        ---@type table Modes whose mappings will be checked during automapping.
        automapping_modes = { "n", "v", "x", "s", "i" },
      })
    end,
    enabled = false,
  },
  -- colorschemes
  {
    "sainnhe/gruvbox-material",
    init = function()
      require("rc.colorscheme")
    end,
    config = function()
      if O.colorscheme == "gruvbox-material" then
        -- gruvbox-material
        vim.g.gruvbox_material_foreground = "mix" -- mix, material, original
        vim.g.gruvbox_material_background = "soft" -- soft, medium, hard
        vim.g.gruvbox_material_better_performance = 1
        vim.g.gruvbox_material_transparent_background = 0
        vim.g.gruvbox_material_enable_italic = 1
        vim.g.gruvbox_material_visual = "reverse"
        vim.g.gruvbox_material_current_word = "grey background"
        vim.cmd("colorscheme gruvbox-material")
      end
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin.nvim",
    init = function()
      require("rc.colorscheme")
    end,
    config = function()
      if O.colorscheme == "catppuccin" then
        require("catppuccin").setup({
          ---@type "mocha" | "macchiato" | "frappe" | "latte"
          flavour = "latte",
          background = {
            -- light = "latte",
            -- dark = "mocha",
          },
          transparent_background = false,
          integrations = {
            aerial = true,
            notify = true,
            noice = true,
            indent_blankline = {
              enabled = true,
              colored_indent_levels = false,
            },
            navic = {
              enabled = false,
              custom_bg = "NONE",
            },
          },
        })
        autocmd("ColorScheme", {
          group = augroup("NoiceVisibleCmdlineCursor", {}),
          callback = function()
            vim.api.nvim_set_hl(0, "NoiceCursor", { link = "Cursor" })
            vim.api.nvim_set_hl(0, "NoiceHiddenCursor", { link = "Cursor" })
          end,
        })
        vim.cmd("colorscheme catppuccin")
      end
    end,
  },
  -- nvim in browser
  {
    "glacambre/firenvim",
    cond = IS_FIRENVIM,
    build = function()
      require("lazy").load({ plugins = "firenvim", wait = true })
      vim.fn["firenvim#install"](0)
    end,
    config = function()
      vim.g.firenvim_config = {
        -- globalSettings = { takeover = "never", cmdline = "none" },
        localSettings = {
          [".*"] = {
            takeover = "never",
            cmdline = "none",
            filename = "/tmp/{hostname}_{pathname%14}.{extension}",
          },
        },
      }
      vim.o.signcolumn = "auto"
      vim.o.guifont = "Source Code Pro Medium:h10"
      autocmd({ "BufEnter" }, {
        pattern = "github.com_*.txt",
        command = "set filetype=markdown",
      })
      -- autocmd({ "TextChanged", "TextChangedI" }, {
      --   group = augroup("FirenvimConfig", {}),
      --   callback = function()
      --     if vim.g.timer_started == true then
      --       return
      --     end
      --     vim.g.timer_started = true
      --     vim.fn.timer_start(10000, function()
      --       vim.g.timer_started = false
      --       vim.cmd("w")
      --     end)
      --   end,
      -- })
    end,
  },
  -- REST
  {
    "rest-nvim/rest.nvim",
    config = function()
      require("rc.configs.rest")
    end,
  },
  -- games
  { "ThePrimeagen/vim-be-good" },
  -- plugins in dev
  {
    "edementyev/workspace_config.nvim",
    config = true,
    dev = true,
    cond = not IS_FIRENVIM,
    -- enabled = false,
  },
}
