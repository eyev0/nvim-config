local null_ls = require("null-ls")

if EDITOR_CONFIG == nil then
	EDITOR_CONFIG = {
		js = {
			formatter = "prettier",
		},
	}
end

local function has_eslint_config(utils)
	return utils.root_has_file({
		".eslintrc",
		".eslintrc.json",
		".eslintrc.js",
		".eslintrc.cjs",
		".eslintrc.ts",
		".eslintrc.yaml",
	})
end

local sources = {
	-- formatting
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.formatting.prettierd.with({
		condition = function()
			return EDITOR_CONFIG.js.formatter == "prettier"
		end,
	}),
	null_ls.builtins.formatting.eslint_d.with({
		condition = function()
			return EDITOR_CONFIG.js.formatter == "eslint"
		end,
	}),
	null_ls.builtins.formatting.xmllint,
	null_ls.builtins.formatting.google_java_format,
	null_ls.builtins.formatting.rustfmt.with({
    -- command = "cargo-fmt",
  }),
  null_ls.builtins.formatting.gofmt,
  null_ls.builtins.formatting.goimports,
  null_ls.builtins.formatting.goimports_reviser,
	null_ls.builtins.formatting.black,
	-- diagnostics
	null_ls.builtins.diagnostics.eslint_d.with({
		condition = has_eslint_config,
	}),
	-- null_ls.builtins.diagnostics.semgrep.with({
	-- 	extra_args = { "--config", "auto" },
	-- }),
	null_ls.builtins.diagnostics.checkmake,
	-- null_ls.builtins.diagnostics.flake8,
	null_ls.builtins.diagnostics.gitlint,
	null_ls.builtins.diagnostics.editorconfig_checker,
	null_ls.builtins.diagnostics.zsh,
	-- null_ls.builtins.diagnostics.write_good,
	-- null_ls.builtins.diagnostics.tsc,
	-- code actions
	null_ls.builtins.code_actions.eslint_d.with({
		condition = has_eslint_config,
		-- prefer_local = "node_modules/.bin",
		-- only_local = "node_modules/.bin",
	}),
	-- null_ls.builtins.code_actions.gitsigns,
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
