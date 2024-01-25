local api = vim.api
-- local cmd = vim.cmd
local has_jumplist_nvim, jumplist_nvim = pcall(require, "jumplist.jump")

local M = {}

local use_cmd = true

function M.mark(buf, line, col)
  if use_cmd then
    vim.cmd("normal! m`")
  else
    local cursor
    if line == nil and col == nil then
      cursor = api.nvim_win_get_cursor(0)
    else
      cursor = { line, col }
    end
    buf = buf or api.nvim_win_get_buf(api.nvim_get_current_win())
    if has_jumplist_nvim then
      jumplist_nvim.mark({ window = api.nvim_get_current_win(), line = line, col = col })
    end
    return api.nvim_buf_set_mark(buf, "`", cursor[1], cursor[2], {})
  end
end

return M
