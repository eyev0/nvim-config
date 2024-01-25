local nvim_lsp = require("lspconfig")
local ts_utils = require("nvim-lsp-ts-utils")
-- local util = require("lspconfig.util")

local init_options = {
  hostInfo = "neovim",
  preferences = {
    includeInlayParameterNameHints = "all",
    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayVariableTypeHints = true,
    includeInlayPropertyDeclarationTypeHints = true,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayEnumMemberValueHints = true,
  },
}

local function on_attach_factory(enable_formatting)
  local function on_attach(client, bufnr)
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    if enable_formatting ~= true then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
    -- defaults
    ts_utils.setup({
      debug = false,
      disable_commands = false,
      enable_import_on_completion = true,

      -- import all
      import_all_timeout = 5000, -- ms
      -- lower numbers = higher priority
      import_all_priorities = {
        same_file = 1, -- add to existing import statement
        local_files = 2, -- git files or files with relative path markers
        buffer_content = 3, -- loaded buffer content
        buffers = 4, -- loaded buffer names
      },
      import_all_scan_buffers = 100,
      import_all_select_source = true,
      -- if false will avoid organizing imports
      always_organize_imports = true,

      -- filter diagnostics
      filter_out_diagnostics_by_severity = {},
      filter_out_diagnostics_by_code = { 80001 },

      -- inlay hints
      auto_inlay_hints = true,
      inlay_hints_highlight = "Comment",
      inlay_hints_priority = 1, -- priority of the hint extmarks
      inlay_hints_throttle = vim.o.updatetime, -- throttle the inlay hint request
      inlay_hints_format = { -- format options for individual hint kind
        Parameter = {
          highlight = "Comment",
          text = function(text)
            return "p:" .. text:sub(0, -2)
          end,
        },
        Enum = {},
        Type = {
          highlight = "Comment",
          text = function(text)
            return "t:" .. text:sub(3)
          end,
        },
      },
      -- update imports on file move
      update_imports_on_move = true,
      require_confirmation_on_move = false,
      watch_dir = nil,
    })

    -- required to fix code action ranges and filter diagnostics
    ts_utils.setup_client(client)

    -- no default maps, so you may want to define some here
    vim.api.nvim_buf_set_keymap(
      bufnr,
      "n",
      "<leader>lai",
      ":TSLspImportAll<CR>",
      { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lao", ":TSLspOrganize<CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(
      bufnr,
      "n",
      "<leader>lam",
      ":TSLspRenameFile<CR>",
      { noremap = true, silent = true }
    )
    Lsp.on_attach(client, bufnr)
  end
  return on_attach
end

nvim_lsp.tsserver.setup(Lsp.make_config({
  -- Needed for inlayHints. Merge this table with your settings or copy
  -- it from the source if you want to add your own init_options.
  init_options = init_options,
  on_attach = on_attach_factory(false),
  -- root_dir = function(startpath)
  -- 	local r = util.root_pattern(".volar")(startpath)
  -- 	if r == nil then
  -- 		-- NO ROOT_PATTERN .volar, start on these markers
  -- 		return util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")(startpath)
  -- 	else
  -- 		-- HAS ROOT_PATTERN .volar, do not start at all
  -- 		return util.root_pattern()(startpath)
  -- 	end
  -- end,
}))

return { on_attach_factory = on_attach_factory }
