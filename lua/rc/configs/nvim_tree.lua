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

require("nvim-tree").setup({
	disable_netrw = false,
	hijack_netrw = false,
	hijack_cursor = true,
	open_on_setup = false,
	ignore_ft_on_setup = {},
	sync_root_with_cwd = true,
	reload_on_bufenter = true,
	on_attach = function(bufnr)
		tree_bufnr = bufnr
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
			return width
		end,
		preserve_window_proportions = true,
		mappings = {
			-- custom_only = false,
			-- list = mappings,
		},
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
