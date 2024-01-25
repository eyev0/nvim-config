vim.g.auto_save = 0
vim.g.auto_save_events = { "InsertLeave", "TextChanged", "CursorHold" }
vim.g.auto_save_silent = 1
vim.cmd([[
augroup autosave_rust
  au!
  " au FileType rust let b:auto_save = 1
augroup END
]])
