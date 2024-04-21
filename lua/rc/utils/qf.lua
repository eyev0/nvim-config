local api = vim.api
local cmd = vim.cmd

local aug_id = augroup("CustomQfHeight", {})

local qf_max_height = 7
local function get_qf_height(n_items)
  return math.min(math.max(n_items, 1), qf_max_height)
end

---@class Qf
local M = {}
---@param n_items? number number of entries in quickfix (default = #vim.fn.getqflist())
---@param jump boolean? Jump to first entry (default = true)
---@param keep_focus boolean? Keep qf window focused (default = false)
---@param set_mark boolean? Before jump, add cursor position to jump list (default = true)
function M.open(n_items, jump, keep_focus, set_mark)
  n_items = vim.F.if_nil(n_items, #vim.fn.getqflist())
  jump = vim.F.if_nil(jump, true)
  keep_focus = vim.F.if_nil(keep_focus, false)
  set_mark = vim.F.if_nil(set_mark, true)
  if n_items > 0 then
    if jump and set_mark then
      vim.cmd("normal! m`")
    end
    cmd("horizontal bo copen " .. get_qf_height(n_items))
    if not keep_focus then
      if jump then
        feedkeys("<CR>", "")
      else
        cmd("wincmd p")
      end
    end
  else
    cmd("cclose")
  end
end

---@param index number
function M.jump(index)
  cmd("cfirst " .. (index or 1))
end

function M.win_has_item(item, win)
  ---@diagnostic disable-next-line: param-type-mismatch
  local bufinfo = vim.fn.getbufinfo(api.nvim_win_get_buf(win))[1]
  return bufinfo and bufinfo.name == item.filename
end

---@type number | nil
M.buf = nil

autocmd("BufWinEnter", {
  group = aug_id,
  callback = function(opts)
    if vim.bo.buftype == "quickfix" then
      -- vim.notify("BufWinEnter hello quickfix")
      M.buf = opts.buf
      --
      vim.bo.modifiable = true
      vim.bo.buflisted = false
      -- vim.bo.errorformat = [[%f\|%l\ col\ %c\|%m]]
      -- TODO: scanf docs
      --
      -- vim.bo.errorformat = [[%f\ *\|\ *%l\:%c\ *\|\ %m]]
      -- setlocal errorformat=%f\|%l\ col\ %c\|%m
      api.nvim_win_set_height(0, get_qf_height(#vim.fn.getqflist()))
      vim.cmd("wincmd J")
      require("todo-comments.highlight").highlight_win(0, true)
    end
  end,
})

-- TODO: qf features:
-- edit qf - modifiable buffer: delete entries (and update qf via :cgetb[uffer])
-- track cursor in qf buffer and update last visited buffer to show current entry

-- do User autocmd when qf is changed
local function hack_setqf()
  local setqflist = vim.fn.setqflist
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.fn.setqflist = function(...)
    local result = setqflist(...)
    M.doautocmd_changed()
    return result
  end
end

local changed_event = "QuickFixChanged"

function M.doautocmd_changed()
  cmd.doautocmd("User " .. changed_event)
end

-- hack_setqf()

function M.pretty_quickfix()
  local fn = vim.fn

  function _G.__quickfixtextfunc(info)
    local items
    local result = {}
    if info.quickfix == 1 then
      items = fn.getqflist({ id = info.id, items = 0 }).items
    else
      items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
    end
    local limit = 50
    -- local delimiter = "│"
    local delimiter = "|"
    local fnameFmt1, fnameFmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
    local validFmt = "%s " .. delimiter .. "%5d:%-3d" .. delimiter .. "%s %s"
    for i = info.start_idx, info.end_idx do
      local e = items[i]
      local fname = ""
      local str
      if e.valid == 1 then
        if e.bufnr > 0 then
          fname = fn.bufname(e.bufnr)
          if fname == "" then
            fname = "[No Name]"
          else
            fname = fname:gsub("^" .. vim.env.HOME, "~")
          end
          -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
          if #fname <= limit then
            fname = fnameFmt1:format(fname)
          else
            fname = fnameFmt2:format(fname:sub(1 - limit))
          end
        end
        local lnum = e.lnum > 99999 and -1 or e.lnum
        local col = e.col > 999 and -1 or e.col
        local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
        str = validFmt:format(fname, lnum, col, qtype, e.text:gsub("^%s*", ""))
      else
        str = e.text
      end
      table.insert(result, str)
    end
    return result
  end
  vim.o.quickfixtextfunc = "{info -> v:lua.__quickfixtextfunc(info)}"
end

-- M.pretty_quickfix()

return M
