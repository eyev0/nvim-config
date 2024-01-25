local cb = require("diffview.config").diffview_callback

local options = {
  diff_binaries = false, -- Show diffs for binaries
  enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
  use_icons = true, -- Requires nvim-web-devicons
  icons = { -- Only applies when use_icons is true.
    folder_closed = "",
    folder_open = "",
  },
  view = {
    merge_tool = {
      -- Config for conflicted files in diff views during a merge or rebase.
      layout = "diff3_mixed",
      disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
      winbar_info = true, -- See |diffview-config-view.x.winbar_info|
    },
  },
  signs = {
    fold_closed = "",
    fold_open = "",
  },
  file_panel = {
    win_config = {
      position = "left",
      width = 35,
      height = 10,
    },
    listing_style = "tree", -- One of 'list' or 'tree'
    tree_options = { -- Only applies when listing_style is 'tree'
      flatten_dirs = true, -- Flatten dirs that only contain one single dir
      folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
    },
  },
  file_history_panel = {
    win_config = {
      position = "bottom",
      width = 35,
      height = 16,
    },
    log_options = {
      git = {
        single_file = {
          max_count = 256, -- Limit the number of commits
          follow = false, -- Follow renames (only for single file)
          all = false, -- Include all refs under 'refs/' including HEAD
          merges = false, -- List only merge commits
          no_merges = false, -- List no merge commits
          reverse = false, -- List commits in reverse order
        },
        multi_file = {
          max_count = 256, -- Limit the number of commits
          follow = false, -- Follow renames (only for single file)
          all = false, -- Include all refs under 'refs/' including HEAD
          merges = false, -- List only merge commits
          no_merges = false, -- List no merge commits
          reverse = false, -- List commits in reverse order
        },
      },
    },
  },
  default_args = { -- Default args prepended to the arg-list for the listed commands
    DiffviewOpen = {},
    DiffviewFileHistory = {},
  },
  hooks = {}, -- See ':h diffview-config-hooks'
  key_bindings = {
    disable_defaults = true, -- Disable the default key bindings
    -- The `view` bindings are active in the diff buffers, only when the current
    -- tabpage is a Diffview.
    view = {
      ["<tab>"] = cb("select_next_entry"), -- Open the diff for the next file
      ["<s-tab>"] = cb("select_prev_entry"), -- Open the diff for the previous file
      ["gf"] = cb("goto_file_edit"), -- Open the file in a new split in previous tabpage
      ["-"] = cb("toggle_stage_entry"), -- Stage / unstage the selected entry.
      ["S"] = cb("stage_all"), -- Stage all entries.
      ["U"] = cb("unstage_all"), -- Unstage all entries.
      ["X"] = cb("restore_entry"), -- Restore entry to the state on the left side.
      ["<C-w><C-f>"] = cb("goto_file_split"), -- Open the file in a new split
      ["<C-w>gf"] = cb("goto_file_tab"), -- Open the file in a new tabpage
      ["<leader>s"] = cb("focus_files"), -- Bring focus to the files panel
      ["<leader>f"] = cb("toggle_files"), -- Toggle the files panel.
    },
    file_panel = {
      ["j"] = cb("next_entry"), -- Bring the cursor to the next file entry
      ["<down>"] = cb("next_entry"),
      ["k"] = cb("prev_entry"), -- Bring the cursor to the previous file entry.
      ["<up>"] = cb("prev_entry"),
      ["<cr>"] = cb("focus_entry"), -- Open the diff for the selected entry.
      ["o"] = cb("focus_entry"),
      ["<2-LeftMouse>"] = cb("focus_entry"),
      ["-"] = cb("toggle_stage_entry"), -- Stage / unstage the selected entry.
      ["S"] = cb("stage_all"), -- Stage all entries.
      ["U"] = cb("unstage_all"), -- Unstage all entries.
      ["X"] = cb("restore_entry"), -- Restore entry to the state on the left side.
      ["R"] = cb("refresh_files"), -- Update stats and entries in the file list.
      ["<tab>"] = cb("select_next_entry"),
      ["<s-tab>"] = cb("select_prev_entry"),
      ["gf"] = cb("goto_file_edit"),
      ["<C-w><C-f>"] = cb("goto_file_split"),
      ["<C-w>gf"] = cb("goto_file_tab"),
      ["i"] = cb("listing_style"), -- Toggle between 'list' and 'tree' views
      ["f"] = cb("toggle_flatten_dirs"), -- Flatten empty subdirectories in tree listing style.
      ["<leader>s"] = cb("focus_files"), -- Bring focus to the files panel
      ["<leader>f"] = cb("toggle_files"), -- Toggle the files panel.
    },
    file_history_panel = {
      ["g!"] = cb("options"), -- Open the option panel
      ["<C-A-d>"] = cb("open_in_diffview"), -- Open the entry under the cursor in a diffview
      ["y"] = cb("copy_hash"), -- Copy the commit hash of the entry under the cursor
      ["zR"] = cb("open_all_folds"),
      ["zM"] = cb("close_all_folds"),
      ["j"] = cb("next_entry"),
      ["<down>"] = cb("next_entry"),
      ["k"] = cb("prev_entry"),
      ["<up>"] = cb("prev_entry"),
      ["<cr>"] = cb("focus_entry"),
      ["o"] = cb("focus_entry"),
      ["<2-LeftMouse>"] = cb("focus_entry"),
      ["<tab>"] = cb("select_next_entry"),
      ["<s-tab>"] = cb("select_prev_entry"),
      ["gf"] = cb("goto_file_edit"),
      ["<C-w><C-f>"] = cb("goto_file_split"),
      ["<C-w>gf"] = cb("goto_file_tab"),
      ["<leader>s"] = cb("focus_files"), -- Bring focus to the files panel
      ["<leader>f"] = cb("toggle_files"), -- Toggle the files panel.
    },
    option_panel = {
      ["<tab>"] = cb("select"),
      ["q"] = cb("close"),
    },
  },
}

vim.cmd([[
augroup DiffViewPanel
  autocmd!
  autocmd BufEnter DiffViewFilePanel,DiffviewFileHistory lua require'diffview'.trigger_event('refresh_files')
augroup end
]])

require("diffview").setup(options)
