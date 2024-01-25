local M = {}

local aug_id = augroup("jumplist", {})

---@type table<integer>
local list = {}

local idx = 0

function M.setup_jump_hooks()
  autocmd("WinLeave", {
    group = aug_id,
    callback = function()
      -- record jumps after VimEnter
      if vim.v.vim_did_enter then
        -- TODO record jump
        M.add_entry(vim.api.nvim_get_current_win())
      end
    end,
  })
end

function M.add_entry(window)
  if idx < table.maxn(list) then
    local tail_n = table.maxn(list) - idx
    for _ = 0, tail_n, 1 do
      table.remove(list, idx + 1)
    end
  end
  table.insert(list, window)
  idx = table.maxn(list)
end

function M.jump_prev()
  if idx < 1 then
    return
  end
  local result_idx = idx - 1
  while not vim.api.nvim_win_is_valid(result_idx) do
    table.remove(list, result_idx)
    result_idx = result_idx - 1
  end
  if result_idx > 0 then
    vim.fn.win_gotoid(result_idx)
    idx = result_idx
  end
end

function M.jump_next()
if idx >= table.maxn(list) then
    idx = table.maxn(list)
    return
  end
  local result_idx = idx + 1
  while not vim.api.nvim_win_is_valid(result_idx) do
    table.remove(list, result_idx)
    -- result_idx = result_idx - 1
  end
  if result_idx <= table.maxn(list) then
    vim.fn.win_gotoid(result_idx)
    idx = result_idx
  end
end

return M
