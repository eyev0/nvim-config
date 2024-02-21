require("treesitter-context").setup({
  max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  mode = "cursor",
})

local ok, aucmd_ids = pcall(
  vim.api.nvim_get_autocmds,
  { group = "treesitter_context_update", event = { "CursorMoved", "WinScrolled" } }
)

if ok then
  for _, au in pairs(aucmd_ids) do
    -- print(au.id)
    vim.api.nvim_del_autocmd(au.id)
    -- print("Deleted autocmd")
    vim.api.nvim_create_autocmd("CursorHold", { group = au.group, callback = au.callback })
  end
else
  print("Could not delete autocmd")
end
