require("neodev").setup({
	library = {
		enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
		-- these settings will be used for your Neovim config directory
		runtime = true, -- runtime path
		types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
		-- plugins = true, -- installed opt or start plugins in packpath
		-- you can also specify the list of plugins to make available as a workspace library
		plugins = {
			"noice.nvim",
			-- "spaceless.nvim",
			-- "nvim-cmp",
			-- "telescope.nvim",
			"nvim-surround",
      "toggleterm.nvim",
      -- "heirline.nvim",
      -- "nvim-tree.lua",
      "nvim-lspconfig",
      -- "jumplist.nvim",
      -- "import.nvim",
      -- "nvim-dap",
      "nvim-dap-ui",
		},
		-- plugins = {
		-- 	"nvim-treesitter",
		-- 	"plenary.nvim",
		-- 	"telescope.nvim",
		-- 	"nvim-cmp",
		-- "nvim-jdtls",
		-- 	"neodev.nvim",
		-- 	-- "gitsigns.nvim",
		-- 	-- "dressing.nvim",
		-- 	-- "rest.nvim",
		-- 	-- "nvim-dap",
		-- },
	},
	setup_jsonls = true,
	-- override = function(root_dir, options) end,
	lspconfig = true,
})
