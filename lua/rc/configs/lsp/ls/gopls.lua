require("lspconfig").gopls.setup(Lsp.make_config({
  settings = {
    gopls = {
      gofumpt = true,
    },
  },
}))
