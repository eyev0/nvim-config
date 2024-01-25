local function set_gitsigns_buf_shortcuts(buf_map, gs)
  -- Navigation
  buf_map("n", "<F4>", function()
    if vim.wo.diff then
      return "]c"
    end
    vim.schedule(function()
      gs.next_hunk()
    end)
    return "<Ignore>"
  end, { noremap = true, silent = true, expr = true, desc = "git: Next hunk" })
  buf_map(
    "n",
    "<F28>", --<C-F4>
    function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end,
    { noremap = true, silent = true, expr = true, desc = "git: Prev hunk" }
  )
  -- Actions
  buf_map("n", "<leader>hs", gs.stage_hunk, { noremap = true, silent = true, desc = "git: Stage hunk" })
  buf_map("v", "<leader>hs", function()
    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end)
  buf_map("n", "<leader>hr", gs.reset_hunk, { noremap = true, silent = true, desc = "git: Reset hunk" })
  buf_map("v", "<leader>hr", function()
    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end)
  buf_map("n", "<leader>hS", gs.stage_buffer, { noremap = true, silent = true, desc = "git: Stage buffer" })
  buf_map(
    "n",
    "<leader>hu",
    gs.undo_stage_hunk,
    { noremap = true, silent = true, desc = "git: Undo stage hunk" }
  )
  buf_map("n", "<leader>hR", gs.reset_buffer, { noremap = true, silent = true, desc = "git: Reset buffer" })
  buf_map("n", "<leader>hp", gs.preview_hunk, { noremap = true, silent = true, desc = "git: Preview hunk" })
  buf_map("n", "<leader>hb", function()
    gs.blame_line({ full = true })
  end, { noremap = true, silent = true, desc = "git: Blame line" })
  buf_map(
    "n",
    "<leader>hB",
    gs.toggle_current_line_blame,
    { noremap = true, silent = true, desc = "git: Toggle current line blame" }
  )
  buf_map("n", "<leader>hd", gs.diffthis, { noremap = true, silent = true, desc = "git: Diff to index" })
  buf_map("n", "<leader>hD", function()
    gs.diffthis("HEAD~1")
  end, { noremap = true, silent = true, desc = "git: Diff to previous commit" })
  buf_map(
    "n",
    "<leader>htd",
    gs.toggle_deleted,
    { noremap = true, silent = true, desc = "git: Toggle deleted" }
  )
  -- Text object
  buf_map(
    { "o", "x" },
    "ih",
    ":<C-U>Gitsigns select_hunk<CR>",
    { noremap = true, silent = true, desc = "git: Select hunk" }
  )
end
require("gitsigns").setup({
	signs = {
		add = { hl = "GitSignsAdd", text = "+", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
		change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
		delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		changedelete = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
	},
	watch_gitdir = {
		interval = 1000,
		follow_files = true,
	},
	diff_opts = {
		internal = true,
	},
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	attach_to_untracked = true,
	current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
	},
	current_line_blame_formatter_opts = {
		relative_time = false,
	},
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000,
	preview_config = {
		-- Options passed to nvim_open_win
		border = "single",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
	yadm = {
		enable = false,
	},
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns
		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end
		set_gitsigns_buf_shortcuts(map, gs)
	end,
})
