local M = {}

M.vis_modes = { "v", "V", "vs", "Vs", "CTRL-V", "CTRL-Vs" }

M.ins_modes = { "i", "ic", "ix" }

function M.is_vis_mode()
  return vim.tbl_contains(M.vis_modes, vim.api.nvim_get_mode().mode)
end

function M.is_ins_mode()
  return vim.tbl_contains(M.ins_modes, vim.api.nvim_get_mode().mode)
end

return M
