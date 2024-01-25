require("nvim-lightbulb").setup({
  ignore = { clients = { "lua_ls", "jdtls" } },
})

vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]])
