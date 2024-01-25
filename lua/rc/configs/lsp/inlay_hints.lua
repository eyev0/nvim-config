local inlay_hints_aug = augroup("LspInlayHints", {})
local inlay_hints_au = nil

local fts = {
  lua = true,
  rust = true,
  go = true,
  java = true,
  javascript = false,
  typescript = true,
  python = true,
}

local client_names = {
  lua = "lua_ls",
  rust = "rust_analyzer",
  go = "gopls",
  typescript = "tsserver",
  javascript = "tsserver",
  java = "jdtls",
  python = "pyright",
}

Lsp.inlay_hints_update_autocmd = function()
  if inlay_hints_au ~= nil then
    vim.api.nvim_del_autocmd(inlay_hints_au)
  end

  inlay_hints_au = autocmd({ "BufEnter" }, {
    group = inlay_hints_aug,
    callback = function(opts)
      local client_attached = vim.tbl_count(
        vim.lsp.get_clients({ bufnr = opts.buf, name = client_names[vim.bo.filetype] })
      ) > 0
      if vim.tbl_contains(vim.tbl_keys(fts), vim.bo.filetype) and client_attached then
        -- print(vim.api.nvim_buf_get_name(opts.buf), opts.buf, vim.bo.buftype)
        vim.lsp.inlay_hint.enable(opts.buf, fts[vim.bo.filetype])
      end
    end,
  })
end

Lsp.inlay_hints_toggle = function()
  local enabled = fts[vim.bo.filetype] or false
  fts[vim.bo.filetype] = not enabled

  vim.lsp.inlay_hint.enable(0, fts[vim.bo.filetype])

  Lsp.inlay_hints_update_autocmd()
end
