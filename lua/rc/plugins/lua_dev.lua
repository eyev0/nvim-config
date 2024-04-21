-- neovim/lua development
return {
  { "folke/neodev.nvim" },
  { "folke/neoconf.nvim" },
  { "jbyuki/one-small-step-for-vimkind" },
  {
    "rafcamlet/nvim-luapad",
    config = function()
      require("luapad").setup({
        eval_on_move = false,
        eval_on_change = true,
        wipe = false,
      })
    end,
  },
  "nanotee/luv-vimdocs",
  "milisims/nvim-luaref",
}
