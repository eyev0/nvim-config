local throttle_time = 550

local is_enabled = false;

local throttled_save = function()
  if not is_enabled then return end
  if vim.g._rust_save_timer ~= nil then
    vim.fn.timer_stop(vim.g._rust_save_timer)
    vim.g._rust_save_timer = nil
    -- vim.g._rust_timer_started = false
    -- return
  end
  vim.g._rust_save_timer = vim.fn.timer_start(throttle_time, function()
    vim.g._rust_save_timer = nil
    vim.cmd("w")
  end)
end

autocmd({ "InsertLeave", "TextChanged" }, {
  group = augroup("RustAuCmds", {}),
  pattern = "*.rs",
  callback = throttled_save,
})
