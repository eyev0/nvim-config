local api = vim.api

-- diagnostics
local diag_float_winid = nil
local function open_diag_float()
  _, diag_float_winid = vim.diagnostic.open_float({
    bufnr = 0,
    scope = "cursor",
    severity_sort = true,
    -- source = "if_many",
    source = true,
    focusable = false,
    close_events = {
      "CursorMoved",
      "CursorMovedI",
      "BufHidden",
      "InsertCharPre",
      "WinLeave",
      "BufLeave",
      "InsertEnter",
      "InsertLeave",
      "TextYankPost",
      "CmdlineChanged",
      "CmdlineEnter",
      "CmdlineLeave",
      "BufModifiedSet",
    },
  })
end

local diagnostic_aug_id = nil
local function diagnostic_toggle_float_aug(flag)
  if flag then
    diagnostic_aug_id = augroup("DiagnosticFloatPreview", { clear = true })
    autocmd({ "CursorHold" }, {
      group = diagnostic_aug_id,
      callback = open_diag_float,
    })
  else
    if diagnostic_aug_id ~= nil then
      api.nvim_del_augroup_by_id(diagnostic_aug_id)
    end
  end
end

local diagnostic_float_active = false
Lsp.diagnostic_toggle_float = function()
  diagnostic_float_active = not diagnostic_float_active
  if not diagnostic_float_active and diag_float_winid ~= nil then
    api.nvim_win_close(diag_float_winid, false)
  end
  diagnostic_toggle_float_aug(diagnostic_float_active)
end

local diagnostics_virt_lines_switch = false
Lsp.diagnostic_toggle_virt_lines = function()
  if diagnostics_virt_lines_switch then
    vim.diagnostic.config({ virtual_lines = false })
  else
    vim.diagnostic.config({ virtual_lines = true })
  end
  diagnostics_virt_lines_switch = not diagnostics_virt_lines_switch
end

local function print_severity()
  require("noice").redirect(function()
    print("Lsp.diagnostic_min_severity is", vim.diagnostic.severity[Lsp.diagnostic_min_severity])
  end, { { filter = { event = "msg_show" }, view = "mini" } })
end
local default_severity = vim.diagnostic.severity.WARN
Lsp.diagnostic_min_severity = default_severity
Lsp.diagnostic_up_min_severity = function()
  Lsp.diagnostic_min_severity = math.max(Lsp.diagnostic_min_severity - 1, vim.diagnostic.severity.ERROR)
  print_severity()
end
Lsp.diagnostic_down_min_severity = function()
  Lsp.diagnostic_min_severity = math.min(Lsp.diagnostic_min_severity + 1, vim.diagnostic.severity.HINT)
  print_severity()
end
Lsp.diagnostic_shift_min_severity = function()
  Lsp.diagnostic_min_severity = Lsp.diagnostic_min_severity + 1
  if Lsp.diagnostic_min_severity > vim.diagnostic.severity.HINT then
    Lsp.diagnostic_min_severity = vim.diagnostic.severity.ERROR
  end
  print_severity()
end
Lsp.diagnostic_reset_min_severity = function()
  Lsp.diagnostic_min_severity = default_severity
  print_severity()
end

-- disable updating diagnostics in insert
vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  virtual_lines = false,
  virtual_text = false,
  float = {
    source = "always",
  },
})
