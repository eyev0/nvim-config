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
    prefer_width = 60,
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
      local w = math.max(string.len(opts.prompt or ""), string.len(opts.default or "")) + extra_width
      if
        opts.prompt ~= nil
        and (opts.prompt:find("New Name:") ~= nil or opts.prompt:find("Rename to") ~= nil)
      then
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
    backend = { "telescope", "nui", "builtin", "fzf_lua", "fzf" },
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

-- LATER: hook up lsp completion to rename prompt
-- most useful thing would be buffer source of cmp

-- local group_id = vim.api.nvim_create_augroup("DressingInputSetCompletion", { clear = true })
-- vim.api.nvim_create_autocmd("FileType", {
-- 	group = group_id,
-- 	callback = function(params)
-- 		if params.match == "DressingInput" then
-- 			-- print("set filetype")
-- 			-- vim.bo.filetype = vim.g.lsp_rename_buf_ft
-- 			local c = require("rc.configs.lsp").buffer_clients
-- 			if c ~= nil and c.current_rename_bufnr ~= nil then
-- 				for _, client in ipairs(c.clients[c.current_rename_bufnr]) do
-- 					vim.lsp.buf_attach_client(params.buf, client.id)
-- 				end
-- 				vim.api.nvim_buf_set_option(params.buf, "omnifunc", "v:lua.vim.lsp.omnifunc")
--         c.current_rename_bufnr = nil
-- 			end
-- 		end
-- 	end,
-- })

-- vim.defer_fn(function()
-- 	local has_cmp, cmp = pcall(require, "cmp")
-- 	if has_cmp then
-- 		cmp.setup.filetype("DressingInput", {
-- 			sources = cmp.config.sources({
-- 				-- { name = "copilot", group_index = 1, priority = 20 },
-- 				{ name = "omni", group_index = 1 },
-- 				{ name = "nvim_lsp", group_index = 1, priority = 15 },
-- 				{ name = "buffer", group_index = 2, priority = 4, max_item_count = 3, keyword_length = 4 },
-- 				{ name = "path", group_index = 2, priority = 3 },
-- 			}),
-- 		})
-- 	end
-- end, 50)
