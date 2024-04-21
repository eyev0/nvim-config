-- dependency packages
return {
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",
  "rktjmp/lush.nvim",
  "nvim-neotest/nvim-nio",
  "MunifTanjim/nui.nvim",
  "rcarriga/nvim-notify",
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    opts = {
      rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" },
    },
    config = true,
  },
}
