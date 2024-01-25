require("lspconfig").eslint.setup(Lsp.make_config({
  on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
    Lsp.on_attach(client, bufnr)
  end,
}))
