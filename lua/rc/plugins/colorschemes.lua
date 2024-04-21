return {
  -- colorschemes
  {
    "sainnhe/gruvbox-material",
    init = function()
      require("rc.colorscheme")
    end,
    config = function()
      if O.colorscheme == "gruvbox-material" then
        -- gruvbox-material
        vim.g.gruvbox_material_foreground = "mix" -- mix, material, original
        vim.g.gruvbox_material_background = "soft" -- soft, medium, hard
        vim.g.gruvbox_material_better_performance = 1
        vim.g.gruvbox_material_transparent_background = 0
        vim.g.gruvbox_material_enable_italic = 1
        vim.g.gruvbox_material_visual = "reverse"
        vim.g.gruvbox_material_current_word = "grey background"

        vim.cmd("autocmd ColorScheme * highlight! link WinBar Normal")
        vim.cmd("autocmd ColorScheme * highlight! link TabLineFill Normal")
        vim.cmd("colorscheme gruvbox-material")
      end
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin.nvim",
    init = function()
      require("rc.colorscheme")
    end,
    config = function()
      if O.colorscheme == "catppuccin" then
        require("catppuccin").setup({
          ---@type "mocha" | "macchiato" | "frappe" | "latte"
          flavour = "frappe",
          background = {
            -- light = "latte",
            -- dark = "mocha",
          },
          term_colors = false,
          transparent_background = false,
          integrations = {
            aerial = true,
            notify = true,
            noice = true,
            indent_blankline = {
              enabled = true,
              colored_indent_levels = false,
            },
          },
        })
        autocmd("ColorScheme", {
          group = augroup("NoiceVisibleCmdlineCursor", {}),
          callback = function()
            vim.api.nvim_set_hl(0, "NoiceCursor", { link = "Cursor" })
            vim.api.nvim_set_hl(0, "NoiceHiddenCursor", { link = "Cursor" })
          end,
        })
        vim.cmd("colorscheme catppuccin")
      end
    end,
  },
}
