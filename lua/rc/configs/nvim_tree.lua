-- local tree_cb = require("nvim-tree.config").nvim_tree_callback
--
-- local keybindings = {
-- 	{ key = { "<CR>", "o", "<2-LeftMouse>" }, cb = tree_cb("edit") },
-- 	{ key = { "<2-RightMouse>", "<C-]>", "i" }, cb = tree_cb("cd") },
-- 	{ key = "<C-v>", cb = tree_cb("vsplit") },
-- 	{ key = "<C-x>", cb = tree_cb("split") },
-- 	{ key = "<C-t>", cb = tree_cb("tabnew") },
-- 	{ key = "<", cb = tree_cb("prev_sibling") },
-- 	{ key = ">", cb = tree_cb("next_sibling") },
-- 	{ key = "P", cb = tree_cb("parent_node") },
-- 	{ key = { "<BS>", "<S-CR>" }, cb = tree_cb("close_node") },
-- 	{ key = "<Tab>", cb = tree_cb("preview") },
-- 	{ key = "K", cb = tree_cb("first_sibling") },
-- 	{ key = "J", cb = tree_cb("last_sibling") },
-- 	{ key = "I", cb = tree_cb("toggle_ignored") },
-- 	{ key = "H", cb = tree_cb("toggle_dotfiles") },
-- 	{ key = "R", cb = tree_cb("refresh") },
-- 	{ key = "a", cb = tree_cb("create") },
-- 	{ key = "d", cb = tree_cb("remove") },
-- 	{ key = "r", cb = tree_cb("rename") },
-- 	{ key = "<C-r>", cb = tree_cb("full_rename") },
-- 	{ key = "x", cb = tree_cb("cut") },
-- 	{ key = "c", cb = tree_cb("copy") },
-- 	{ key = "p", cb = tree_cb("paste") },
-- 	{ key = "y", cb = tree_cb("copy_name") },
-- 	{ key = "Y", cb = tree_cb("copy_path") },
-- 	{ key = "gy", cb = tree_cb("copy_absolute_path") },
-- 	{ key = "[c", cb = tree_cb("prev_git_item") },
-- 	{ key = "]c", cb = tree_cb("next_git_item") },
-- 	{ key = "-", cb = tree_cb("dir_up") },
-- 	{ key = "q", cb = tree_cb("close") },
-- 	{ key = "g?", cb = tree_cb("toggle_help") },
-- }

-- local mappings = {
-- 	{ key = { "<CR>", "o", "<2-LeftMouse>" }, action = "edit" },
-- 	{ key = { "<2-RightMouse>", "<C-]>", "i" }, action = "edit" },
-- 	{ key = "M", action = "bulk_move" },
-- 	{ key = "<C-s>", action = "split" },
-- 	{ key = "<C-x>", action = false },
-- }

local default_width = 30
local width = default_width
local tree_bufnr = nil
local max_reopen_width = 40

local aug_id = vim.api.nvim_create_augroup("NvimTreeCaptureResizeWidth", {})
vim.api.nvim_create_autocmd("WinResized", {
  group = aug_id,
  callback = function()
    if vim.v.event and vim.v.event.windows then
      for _, win in ipairs(vim.v.event.windows) do
        if vim.api.nvim_win_get_buf(win) == tree_bufnr then
          width = vim.api.nvim_win_get_width(win)
        end
      end
    end
  end,
})

local api = require("nvim-tree.api")

require("nvim-tree").setup({
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  -- open_on_setup = false,
  -- ignore_ft_on_setup = {},
  sync_root_with_cwd = true,
  reload_on_bufenter = true,
  on_attach = function(bufnr)
    tree_bufnr = bufnr

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, opts("CD"))
    vim.keymap.set("n", "<C-e>", api.node.open.replace_tree_buffer, opts("Open: In Place"))
    vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts("Info"))
    vim.keymap.set("n", "<C-r>", api.fs.rename_sub, opts("Rename: Omit Filename"))
    vim.keymap.set("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))
    vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Open: Vertical Split"))
    vim.keymap.set("n", "<C-x>", api.node.open.horizontal, opts("Open: Horizontal Split"))
    vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts("Close Directory"))
    vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
    vim.keymap.set("n", ">", api.node.navigate.sibling.next, opts("Next Sibling"))
    vim.keymap.set("n", "<", api.node.navigate.sibling.prev, opts("Previous Sibling"))
    vim.keymap.set("n", ".", api.node.run.cmd, opts("Run Command"))
    vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts("Up"))
    vim.keymap.set("n", "a", api.fs.create, opts("Create File Or Directory"))
    vim.keymap.set("n", "bd", api.marks.bulk.delete, opts("Delete Bookmarked"))
    vim.keymap.set("n", "bt", api.marks.bulk.trash, opts("Trash Bookmarked"))
    vim.keymap.set("n", "bmv", api.marks.bulk.move, opts("Move Bookmarked"))
    vim.keymap.set("n", "B", api.tree.toggle_no_buffer_filter, opts("Toggle Filter: No Buffer"))
    vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
    vim.keymap.set("n", "C", api.tree.toggle_git_clean_filter, opts("Toggle Filter: Git Clean"))
    vim.keymap.set("n", "[c", api.node.navigate.git.prev, opts("Prev Git"))
    vim.keymap.set("n", "]c", api.node.navigate.git.next, opts("Next Git"))
    vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
    vim.keymap.set("n", "D", api.fs.trash, opts("Trash"))
    vim.keymap.set("n", "E", api.tree.expand_all, opts("Expand All"))
    vim.keymap.set("n", "e", api.fs.rename_basename, opts("Rename: Basename"))
    vim.keymap.set("n", "]e", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
    vim.keymap.set("n", "[e", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
    vim.keymap.set("n", "F", api.live_filter.clear, opts("Live Filter: Clear"))
    vim.keymap.set("n", "f", api.live_filter.start, opts("Live Filter: Start"))
    vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))
    vim.keymap.set("n", "gy", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
    vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts("Toggle Filter: Dotfiles"))
    vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts("Toggle Filter: Git Ignore"))
    vim.keymap.set("n", "J", api.node.navigate.sibling.last, opts("Last Sibling"))
    vim.keymap.set("n", "K", api.node.navigate.sibling.first, opts("First Sibling"))
    vim.keymap.set("n", "L", api.node.open.toggle_group_empty, opts("Toggle Group Empty"))
    vim.keymap.set("n", "M", api.tree.toggle_no_bookmark_filter, opts("Toggle Filter: No Bookmark"))
    vim.keymap.set("n", "m", api.marks.toggle, opts("Toggle Bookmark"))
    vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "O", api.node.open.no_window_picker, opts("Open: No Window Picker"))
    vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
    vim.keymap.set("n", "P", api.node.navigate.parent, opts("Parent Directory"))
    vim.keymap.set("n", "q", api.tree.close, opts("Close"))
    vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
    vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
    vim.keymap.set("n", "s", api.node.run.system, opts("Run System"))
    vim.keymap.set("n", "S", api.tree.search_node, opts("Search"))
    vim.keymap.set("n", "u", api.fs.rename_full, opts("Rename: Full Path"))
    vim.keymap.set("n", "U", api.tree.toggle_custom_filter, opts("Toggle Filter: Hidden"))
    vim.keymap.set("n", "W", api.tree.collapse_all, opts("Collapse"))
    vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
    vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
    vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
    vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node, opts("CD"))
  end,
  tab = {
    sync = {
      open = false,
      close = false,
      ignore = {},
    },
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = false,
    severity = {
      min = vim.diagnostic.severity.WARN,
    },
  },
  update_focused_file = {
    enable = true,
    update_root = false,
    ignore_list = {},
  },
  git = {
    enable = true,
    ignore = false,
    show_on_open_dirs = false,
  },
  view = {
    -- adaptive_size = true,
    width = function()
      return math.min(width, max_reopen_width)
    end,
    preserve_window_proportions = true,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
  },
  renderer = {
    indent_markers = {
      enable = true,
    },
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
  actions = {
    open_file = {
      quit_on_open = false,
      resize_window = false,
    },
  },
})

-- mac
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("NvimTreeIlluminateToggleOff", {}),
  callback = function(opts)
    if vim.bo[opts.buf].filetype == "NvimTree" then
      vim.cmd("IlluminatePauseBuf")
      -- vim.cmd("IlluminateResumeBuf")
    end
  end,
})
