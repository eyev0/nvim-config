return {
  -- ui/input
  {
    "folke/noice.nvim",
    config = function()
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
                -- {
                --   event = "msg_show",
                --   kind = "",
                --   find = "error list",
                -- },
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
    end,
    tag = "v2.0.0",
  },
  {
    "rebelot/heirline.nvim",
    config = function()
      require("rc.configs.heirline")
    end,
    cond = not IS_FIRENVIM,
    event = "ColorScheme",
  },
  {
    "0x00-ketsu/maximizer.nvim",
    config = true,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      vim.g.indent_blankline_show_first_indent_level = false

      require("ibl").setup({
        exclude = {
          filetypes = {
            "lspinfo",
            "packer",
            "checkhealth",
            "help",
            "",
            "noice",
            "notify",
            "ImportManager",
          },
          buftypes = { "terminal", "quickfix" },
        },
      })

      -- replace CursorMoved(I) with CursorHold(I)
      local ok, aucmd_ids = pcall(
        vim.api.nvim_get_autocmds,
        { group = "IndentBlankline", event = { "CursorMoved", "CursorMovedI" } }
      )
      if ok then
        for _, au in pairs(aucmd_ids) do
          -- print(au.id)
          vim.api.nvim_del_autocmd(au.id)
          -- print("Deleted autocmd")
          vim.api.nvim_create_autocmd(au.event, { group = au.group, callback = au.callback })
        end
      else
        print("Could not delete autocmd")
      end

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
            vim.tbl_contains(set_threshold_filetypes, vim.bo[opts.buf].filetype)
            and vim.fn.line("$") > max_lines
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
    end,
    enabled = true,
  },
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({
        input = {
          -- Set to false to disable the vim.ui.input implementation
          enabled = true,
          -- Default prompt string
          default_prompt = "Input:",
          -- Can be 'left', 'right', or 'center'
          prompt_align = "left",
          -- When true, <Esc> will close the modal
          insert_only = false,
          -- When true, input will start in insert mode.
          start_in_insert = true,
          -- These are passed to nvim_open_win
          override = function(conf)
            -- This is the config that will be passed to nvim_open_win.
            -- Change values here to customize the layout
            return vim.tbl_extend("force", conf, {
              anchor = "SW",
              border = "rounded",
            })
          end,
          -- 'editor' and 'win' will default to being centered
          relative = "editor",
          -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          prefer_width = 0.5,
          width = nil,
          -- min_width and max_width can be a list of mixed types.
          -- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
          max_width = 0.9,
          min_width = 20,
          mappings = {
            -- Set to `false` to disable
            n = {
              ["<Esc>"] = "Close",
              ["<CR>"] = "Confirm",
            },
            i = {
              ["<C-c>"] = "Close",
              ["<CR>"] = "Confirm",
              ["<Up>"] = "HistoryPrev",
              ["<C-p>"] = "HistoryPrev",
              ["<Down>"] = "HistoryNext",
              ["<C-n>"] = "HistoryNext",
            },
          },
          -- see :help dressing_get_config
          get_config = function(opts)
            local config = {}
            local extra_width = 20
            opts.prompt = opts.prompt or ""
            opts.default = opts.default or ""
            local w = math.max(opts.prompt:len(), opts.default:len()) + extra_width
            if opts.prompt:find("New Name") ~= nil or opts.prompt:find("Rename to") ~= nil then
              config.start_in_insert = false
              w = math.max(w, 40)
            end
            config.width = w
            return config
          end,
        },
        select = {
          -- Set to false to disable the vim.ui.select implementation
          enabled = true,
          -- Priority list of preferred vim.select implementations
          backend = { "nui", "telescope", "builtin", "fzf_lua", "fzf" },
          -- Trim trailing `:` from prompt
          telescope = require("telescope.themes").get_cursor({
            wrap_results = true,
            initial_mode = "normal",
            layout_config = {
              height = 0.4,
            },
          }),
          trim_prompt = true,
          -- Options for nui Menu
          -- Used to override format_item. See :help dressing-format
          format_item_override = {
            codeaction = function(action_tuple)
              if action_tuple == nil then
                return nil
              end
              local title = action_tuple.action.title:gsub("\r\n", "\\r\\n")
              local client = vim.lsp.get_client_by_id(action_tuple.ctx.client_id)
              return string.format("%s\t[%s]", title:gsub("\n", "\\n"), client and client.name)
            end,
          },
        },
      })
    end,
    event = "VeryLazy",
  },
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({
        plugins = {
          -- registers = false,
        },
        show_help = false,
        show_keys = false,
      })
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("rc.configs.nvim_tree")
    end,
    tag = "v1",
    event = "VimEnter",
  },
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup({
        skip_confirm_for_simple_edits = true,
        restore_win_options = false,
        keymaps = {
          ["<C-s>"] = false,
          ["<C-w>s"] = "actions.select_split",
          ["<C-h>"] = false,
          ["<C-w>v"] = "actions.select_vsplit",
          -- ["<C-p>"] = "actions.preview",
          ["<C-p>"] = false,
          -- ["<C-c>"] = "actions.close",
          ["<Esc>"] = "actions.close",
          ["<C-c>"] = false,
          ["<C-l>"] = false,
          ["R"] = "actions.refresh",
          ["-"] = false,
          ["<BS>"] = "actions.parent",
        },
        view_options = {
          show_hidden = true,
        },
      })
    end,
    enabled = false,
  },
  {
    "folke/todo-comments.nvim",
    config = function()
      require("todo-comments").setup({
        highlight = {
          exclude = { "help", "man" },
          max_line_len = 300,
        },
      })
    end,
  },
  { "chentoast/marks.nvim", config = true },
  {
    "kevinhwang91/nvim-bqf",
    config = function()
      require("bqf").setup({
        auto_resize_height = false,
        preview = {
          auto_preview = false,
          win_height = 999,
          win_vheight = 22,
          border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        },
        filter = {
          fzf = {
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--exact" },
          },
        },
      })
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
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      local mappings = {
        i = {
          ["<Esc>"] = actions.close,
          ["<C-c"] = false,
          ["<C-/>"] = actions.which_key,
          ["<C-s>"] = actions.select_horizontal + actions.center,
          ["<C-v>"] = actions.select_vertical + actions.center,
          ["<CR>"] = actions.select_default + actions.center,
          -- ["<C-s>"] = actions.toggle_selection,
          ["<C-f>"] = actions.to_fuzzy_refine,
          -- ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          ["<C-q>"] = actions.smart_send_to_qflist,
        },
        n = {
          ["<C-q>"] = actions.smart_send_to_qflist,
          ["<C-n>"] = actions.move_selection_next,
          ["<C-p>"] = actions.move_selection_previous,
        },
      }

      require("telescope").setup({
        defaults = {
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          winblend = 0,
          mappings = mappings,
          path_display = { truncate = 5 },
          hidden = true,
          no_ignore = true,
          follow = true,
          -- wrap_results = true,
        },
        extensions = {
          -- handled by dressing.nvim
          -- ["ui-select"] = {
          -- 	-- require("telescope.themes").get_dropdown({}),
          -- 	-- require("telescope.themes").get_ivy({}),
          -- 	require("telescope.themes").get_cursor({ wrap_results = true }),
          -- },
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          },
          tmuxinator = {
            select_action = "switch", -- | 'stop' | 'kill'
            stop_action = "stop", -- | 'kill'
            disable_icons = false,
          },
          aerial = {
            -- Display symbols as <root>.<parent>.<symbol>
            show_nesting = {
              ["_"] = true, -- This key will be the default
              json = true, -- You can set the option for specific filetypes
            },
          },
        },
      })

      pcall(telescope.load_extension, "fzf")
      -- telescope.load_extension("ui-select")
      pcall(telescope.load_extension, "dap")
      pcall(telescope.load_extension, "harpoon")
      pcall(telescope.load_extension, "notify")
      pcall(telescope.load_extension, "noice")
      pcall(telescope.load_extension, "yank_history")
      pcall(telescope.load_extension, "aerial")
      pcall(telescope.load_extension, "persisted")
      pcall(telescope.load_extension, "tmuxinator")
      pcall(telescope.load_extension, "git_worktree")
      -- telescope.load_extension("git_worktree")

      vim.cmd([[autocmd User TelescopePreviewerLoaded setlocal wrap]])
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
    "farmergreg/vim-lastplace",
    config = function()
      vim.g.lastplace_ignore = "gitcommit,gitrebase,svn,hgcommit"
      vim.g.lastplace_ignore_buftype = "quickfix,nofile,help"
      vim.g.lastplace_open_folds = true
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
  -- nvim in browser
  {
    "glacambre/firenvim",
    -- cond = IS_FIRENVIM,
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
      vim.o.guifont = "Source Code Pro Medium:h20"
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
}
