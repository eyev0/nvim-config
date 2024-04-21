return {
  { "tpope/vim-fugitive" },
  {
    "sindrets/diffview.nvim",
    config = function()
      require("rc.configs.diffview")
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("rc.configs.gitsigns")
    end,
    event = "ColorScheme",
  },
  {
    "polarmutex/git-worktree.nvim",
    config = function()
      require("rc.configs.git-worktree")
    end,
    -- dev = true,
    -- dir = O.devpath .. "/git-worktree.nvim",
    -- branch = "local",
  },
  {
    "harrisoncramer/gitlab.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "stevearc/dressing.nvim", -- Recommended but not required. Better UI for pickers.
      "nvim-tree/nvim-web-devicons", -- Recommended but not required. Icons in discussion tree.
    },
    event = "VeryLazy",
    build = function()
      require("gitlab.server").build(true)
    end, -- Builds the Go binary
    config = function()
      require("gitlab").setup({
        discussion_tree = { -- The discussion tree that holds all comments
          switch_view = "S", -- Toggles between the notes and discussions views
          default_view = "discussions", -- Show "discussions" or "notes" by default
          blacklist = {}, -- List of usernames to remove from tree (bots, CI, etc)
          jump_to_file = "o", -- Jump to comment location in file
          jump_to_reviewer = "m", -- Jump to the location in the reviewer window
          edit_comment = "e", -- Edit comment
          delete_comment = "dd", -- Delete comment
          reply = "r", -- Reply to comment
          toggle_node = "t", -- Opens or closes the discussion
          toggle_all_discussions = "T", -- Open or close separately both resolved and unresolved discussions
          toggle_resolved_discussions = "R", -- Open or close all resolved discussions
          toggle_unresolved_discussions = "U", -- Open or close all unresolved discussions
          toggle_resolved = "p", -- Toggles the resolved status of the whole discussion
          position = "bottom", -- "top", "right", "bottom" or "left"
          open_in_browser = "b", -- Jump to the URL of the current note/discussion
          size = "13%", -- Size of split
          toggle_tree_type = "i", -- Toggle type of discussion tree - "simple", or "by_file_name"
        },
      })
    end,
  },
}
