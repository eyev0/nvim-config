local M = {}
local jumplist = require("rc.utils.jumplist")

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
    jumplist.mark()
    aerial.prev()
  end, opts)
  map("n", "}", function()
    jumplist.mark()
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

M.config_sideview = vim.tbl_deep_extend("force", {}, default_config, { filter_kind = M.filter_sideview })
M.config_telescope = vim.tbl_deep_extend("force", {}, default_config, { filter_kind = M.filter_telescope })

---@param mode "sideview" | "telescope"
function M.setup(mode)
  require("aerial").setup(M["config_" .. mode])
end

M.setup("telescope")

return M
