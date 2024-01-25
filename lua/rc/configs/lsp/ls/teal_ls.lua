local lsputil = require("lspconfig.util")
require("lspconfig").teal_ls.setup({
  root_dir = lsputil.root_pattern(".git", "tlconfig.lua"),
	on_attach = Lsp.on_attach,
	capabilities = Lsp.capabilities,
})
