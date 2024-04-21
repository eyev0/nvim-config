return {
  -- lsp/lsp-based editing/highlighting
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("rc.configs.lsp")
    end,
  },
  { "mfussenegger/nvim-jdtls" },
  {
    "nvimtools/none-ls.nvim",
    config = function()
      require("rc.configs.lsp.ls.null-ls")
    end,
    event = "VeryLazy",
    dependencies = { "neovim/nvim-lspconfig" },
  },
  { "jose-elias-alvarez/nvim-lsp-ts-utils" },
  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    ft = { "rust" },
    config = function()
      require("rc.configs.rustaceanvim")
    end,
  },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    config = function()
      local fidget = require("fidget")
      fidget.setup({
        text = {
          commenced = "Start", -- message shown when task starts
          completed = "Done", -- message shown when task completes
        },
        window = {
          relative = "editor",
          blend = 0,
        },
        timer = {
          fidget_decay = 1300, -- how long to keep around empty fidget, in ms
          task_decay = 1000, -- how long to keep around completed task, in ms
        },
        fmt = {
          stack_upwards = true, -- list of tasks grows upwards
          max_width = 38, -- maximum width of the fidget box
        },
        sources = {
          ["null-ls"] = {
            ignore = true,
          },
        },
      })
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
      local ignore_modes = vim.tbl_extend("keep", O.vis_modes, { "i" })

      require("illuminate").configure({
        delay = 90,
        large_file_cutoff = 2000,
        modes_denylist = ignore_modes,
        min_count_to_highlight = 2,
        under_cursor = true,
      })

      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("illuminateSetHl", {}),
        callback = function()
          vim.api.nvim_set_hl(0, "IlluminatedWordText", {
            underline = true,
          })
          vim.api.nvim_set_hl(0, "IlluminatedWordRead", {
            underline = true,
          })
          vim.api.nvim_set_hl(0, "IlluminatedWordWrite", {
            bold = true,
            -- italic = true,
            underline = true,
          })
        end,
      })
    end,
    event = "VeryLazy",
  },
  {
    "stevearc/aerial.nvim",
    config = function()
      local M = {}

      M.filter_telescope = {
        "Array",
        "Boolean",
        "Class",
        "Constant",
        "Constructor",
        "Enum",
        "EnumMember",
        "Event",
        "Field",
        "File",
        "Function",
        "Interface",
        "Key",
        "Method",
        "Module",
        "Namespace",
        "Null",
        "Number",
        "Object",
        "Operator",
        "Package",
        "Property",
        "String",
        "Struct",
        "TypeParameter",
        "Variable",
      }

      M.filter_sideview = {
        "Class",
        "Constructor",
        "Enum",
        "Function",
        "Interface",
        "Module",
        "Method",
        "Struct",
      }

      local aerial = require("aerial")
      local map = vim.keymap.set

      local function set_aerial_buf_shortcuts(bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        -- Jump forwards/backwards with '{' and '}'
        map("n", "{", function()
          vim.cmd("normal! m`")
          aerial.prev()
        end, opts)
        map("n", "}", function()
          vim.cmd("normal! m`")
          aerial.next()
        end, opts)
      end

      local default_config = {
        -- optionally use on_attach to set keymaps when aerial has attached to a buffer
        on_attach = function(bufnr)
          set_aerial_buf_shortcuts(bufnr)
        end,
        backends = {
          ["_"] = { "lsp", "treesitter", "markdown", "man" },
          lua = { "lsp", "treesitter" },
          go = { "treesitter", "lsp" },
        },
        layout = {
          default_direction = "prefer_left",
          placement = "edge",
        },
        disable_max_lines = 15000, -- default 10000
        disable_max_size = 4000000, -- Default 2MB
        autojump = true,
        -- filter_kind = M.filter_sideview,
      }

      M.config_sideview = vim.tbl_deep_extend(
        "force",
        {},
        default_config,
        { filter_kind = M.filter_sideview }
      )
      M.config_telescope = vim.tbl_deep_extend(
        "force",
        {},
        default_config,
        { filter_kind = M.filter_telescope }
      )

      ---@param mode "sideview" | "telescope"
      function M.setup(mode)
        require("aerial").setup(M["config_" .. mode])
      end

      M.setup("telescope")

      return M
    end,
    event = "VeryLazy",
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    -- name = "lsp_lines.nvim",
    -- dir = O.devpath .. "/lsp_lines.nvim",
    -- dev = true,
    config = true,
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
    dependencies = { "nvim-nio" },
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
  {
    "leoluz/nvim-dap-go",
    config = true,
    -- dev = true,
    -- dir = O.devpath .. "/nvim-dap-go",
  },
  -- tests
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
  -- REST
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    dependencies = { "luarocks.nvim" },
    config = function()
      require("rest-nvim").setup({
        -- Open request results in a horizontal split
        result_split_horizontal = false,
        -- Keep the http file buffer above|left when split horizontal|vertical
        result_split_in_place = true,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = false,
        -- Encode URL before making request
        encode_url = true,
        -- Highlight request on run
        highlight = {
          enabled = true,
          timeout = 200,
        },
        result = {
          -- toggle showing URL, HTTP info, headers at top the of result window
          show_url = true,
          show_http_info = true,
          show_headers = true,
          -- executables or functions for formatting response body [optional]
          -- set them to nil if you want to disable them
          formatters = {
            json = "jq",
            html = function(body)
              return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
            end,
          },
        },
        -- Jump to request line on run
        jump_to_request = false,
        env_file = "dev.env",
        custom_dynamic_variables = {
          ["$date"] = function()
            local os_date = os.date("%Y-%m-%d")
            return os_date
          end,
        },
        yank_dry_run = true,
      })

      vim.cmd([[command! -nargs=0 RestNvimRun :lua require('rest-nvim').run()]])
      vim.cmd([[command! -nargs=0 RestNvimPreview :lua require('rest-nvim').run(true)]])
      vim.cmd([[command! -nargs=0 RestNvimRunLast :lua require('rest-nvim').last()]])

      autocmd("BufWinEnter", {
        group = augroup("RestNvimSplitRight", {}),
        callback = function()
          if vim.bo.filetype == "httpResult" then
            vim.api.nvim_win_call(0, function()
              vim.cmd("wincmd L")
            end)
          end
        end,
      })
    end,
  },
}
