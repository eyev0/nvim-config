local null_ls = require("null-ls")

local sources = {
  -- formatting
  null_ls.builtins.formatting.stylua,
  null_ls.builtins.formatting.prettierd,
  null_ls.builtins.formatting.google_java_format,
  null_ls.builtins.formatting.gofmt,
  null_ls.builtins.formatting.goimports,
  null_ls.builtins.formatting.goimports_reviser,
  -- null_ls.builtins.formatting.golines, -- sad face
  null_ls.builtins.formatting.black,
  null_ls.builtins.formatting.tidy,
  -- diagnostics
  -- null_ls.builtins.diagnostics.semgrep.with({
  -- 	extra_args = { "--config", "auto" },
  -- }),
  null_ls.builtins.diagnostics.golangci_lint,
  null_ls.builtins.diagnostics.checkmake,
  null_ls.builtins.diagnostics.gitlint,
  null_ls.builtins.diagnostics.editorconfig_checker,
  null_ls.builtins.diagnostics.zsh,
  -- code actions
  null_ls.builtins.code_actions.gitsigns,
  -- completion
  -- null_ls.builtins.completion.spell,
}

local defaults = {
  cmd = { "nvim" },
  debounce = 100,
  debug = false,
  default_timeout = 5000,
  diagnostics_format = "#{m}",
  fallback_severity = vim.diagnostic.severity.ERROR,
  log = {
    enable = true,
    level = "warn",
    use_console = "async",
  },
  on_attach = nil,
  on_init = nil,
  on_exit = nil,
  -- root_dir = u.root_pattern(".null-ls-root", "Makefile", ".git", ".nvimrc.lua"),
  update_in_insert = false,
  sources = sources,
}

null_ls.setup(Lsp.make_config(defaults))
