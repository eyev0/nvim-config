require("lspconfig").clangd.setup(Lsp.make_config({
  capabilities = {
    offsetEncoding = "utf-16",
  },
  filetypes = {
    "c",
    "cpp",
    "objc",
    "objcpp",
    "cuda",
  },
}))
