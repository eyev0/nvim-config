require("lspconfig").rust_analyzer.setup(Lsp.make_config({
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        allFeatures = true,
        overrideCommand = {
          "cargo",
          "clippy",
          "--workspace",
          "--message-format=json",
          "--all-targets",
          "--all-features",
        },
      },
    },
  },
}))

-- autocmd({ "InsertLeave", "TextChanged" }, {
--   group = augroup("RustAutoSave", {}),
--   pattern = "*.rs",
--   callback = function()
--     vim.cmd("silent! w")
--   end,
-- })
