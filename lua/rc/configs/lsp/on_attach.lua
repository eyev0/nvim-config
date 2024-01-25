local map = vim.keymap.set
local function set_lsp_buf_shortcuts(_, bufnr)
  local function buf_map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    return map(mode, lhs, rhs, opts)
  end
  buf_map("n", "gd", function()
    vim.lsp.buf.definition({
      reuse_win = true,
      on_list = function(options)
        Lsp.on_list(options, options.items and #options.items > 1, true)
      end,
    })
  end, { noremap = true, silent = true, desc = "Goto Definition" })
  buf_map("n", "gr", function()
    vim.lsp.buf.references({ includeDeclaration = false }, { on_list = Lsp.on_list })
  end, { noremap = true, silent = true, desc = "List References" })
  buf_map("n", "gI", function()
    vim.lsp.buf.implementation({ on_list = Lsp.on_list })
  end, { noremap = true, silent = true, desc = "List Implementations" })
  buf_map(
    "n",
    "gCi",
    vim.lsp.buf.incoming_calls,
    { noremap = true, silent = true, desc = "List Incoming Calls" }
  )
  buf_map(
    "n",
    "gCo",
    vim.lsp.buf.outgoing_calls,
    { noremap = true, silent = true, desc = "List Outgoing Calls" }
  )
  buf_map("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true, desc = "Hover docs" })
  buf_map(
    { "n", "i" },
    "<M-k>",
    vim.lsp.buf.signature_help,
    { noremap = true, silent = true, desc = "Signature help" }
  )
  buf_map("n", "<leader>lar", vim.lsp.buf.rename, { noremap = true, silent = true, desc = "Rename symbol" })
  buf_map(
    { "n", "v" },
    "<leader>lac",
    vim.lsp.buf.code_action,
    { noremap = true, silent = true, desc = "Code action" }
  )
end

Lsp.on_attach = function(client, bufnr)
  vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
  set_lsp_buf_shortcuts(client, bufnr)
  Lsp.inlay_hints_update_autocmd()
end

