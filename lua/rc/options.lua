-- neovim python api
vim.g.python3_host_prog = "$HOME/.venvs/neovim/bin/python"
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

vim.o.completeopt = "menuone,noselect,preview"

vim.opt.whichwrap:append("<,>,[,],h,l") -- move to next line with theses keys
-- vim.cmd('syntax on') -- syntax highlighting
vim.o.pumheight = 10 -- Makes popup menu smaller

vim.o.confirm = true
vim.o.swapfile = false
vim.o.autowrite = true
vim.o.writebackup = false
vim.o.undofile = true
vim.opt.undodir = vim.fn.expand("$HOME/.vim/undodir")
vim.o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"
vim.o.updatetime = 100
vim.o.timeoutlen = 300
vim.o.ttimeout = false
vim.o.shiftround = true
vim.o.mouse = "a"
vim.o.laststatus = 3
vim.o.cmdheight = 2
vim.o.title = true
vim.o.wrap = false
vim.o.linebreak = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.startofline = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.ttyfast = true
vim.o.report = 0
vim.o.synmaxcol = 300
vim.wo.cursorline = true
vim.o.scrolloff = O.scrolloff
vim.o.sidescrolloff = O.sidescrolloff
-- vim.wo.colorcolumn = "80"
vim.o.showmode = false
-- vim.opt.signcolumn = "number"
vim.opt.clipboard:prepend({ "unnamedplus" })
vim.opt.shortmess:append("c")
vim.opt.iskeyword:append("-")
vim.o.termguicolors = true
vim.o.conceallevel = 0
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
-- vim.o.autoindent = true
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevelstart = 99
vim.o.splitkeep = "screen"
vim.o.switchbuf = "usetab,uselast"
vim.o.jumpoptions = "stack"
-- vim.o.statuscolumn = "%=%{v:relnum?v:relnum:0} %{v:lnum}│"
-- vim.o.statuscolumn = "%s%=%{v:relnum?v:relnum:v:lnum} "
vim.o.relativenumber = true
vim.o.number = true
vim.o.signcolumn = "yes:2"
vim.o.fillchars = "eob: "

-- langmap
local function escape(str)
  -- You need to escape these characters to work correctly
  local escape_chars = [[;,."|\]]
  return vim.fn.escape(str, escape_chars)
end
-- Recommended to use lua template string
local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm,.]]
local ru = [[ёйцукенгшщзхъфывапролджэячсмитьбю]]
local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]
vim.opt.langmap = vim.fn.join({
  -- | `to` should be first     | `from` should be second
  escape(ru_shift) .. ";" .. escape(en_shift),
  escape(ru) .. ";" .. escape(en),
}, ",")

-- disable statuscolumn in non-file buffers
local relnum_ignore_filetypes = { "NvimTree", "fugitive", "DiffviewFiles", "DiffviewFileHistory" }
autocmd("BufEnter", {
  callback = function(opts)
    if vim.tbl_contains(relnum_ignore_filetypes, vim.bo[opts.buf].filetype) then
      vim.wo.number = false
      vim.wo.relativenumber = false
      vim.wo.signcolumn = "yes:1"
    end
  end,
})

local function set_wo(window, name, value)
  local eventignore = vim.opt.eventignore:get()
  vim.opt.eventignore:append("OptionSet")
  vim.api.nvim_set_option_value(name, value, { win = window })
  vim.opt.eventignore = eventignore
end

-- terminal buffer/window options
autocmd("BufEnter", {
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.bo.scrollback = O.scrollback
      vim.wo.scrolloff = O.scrolloff
      vim.wo.number = true
    end
  end,
})

-- hide cursorline on WinLeave
autocmd("WinLeave", {
  callback = function()
    set_wo(vim.api.nvim_get_current_win(), "cursorlineopt", "number")
  end,
})
autocmd("WinEnter", {
  callback = function()
    set_wo(vim.api.nvim_get_current_win(), "cursorlineopt", "screenline,number") -- "both"
  end,
})

autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "CurSearch", timeout = 200 })
  end,
})

-- tmux italics
vim.cmd([[let &t_ZH="\e[3m"]])
vim.cmd([[let &t_ZR="\e[23m"]])

-- gui stuff
vim.cmd([[au UIEnter * let g:has_gui=1]])
vim.cmd([[
set guioptions-=T
set guioptions-=m
set guioptions-=r
set guioptions-=L
set guifont=Source\ Code\ Pro\ Medium:h13
]])

local M = {}

-- toggle options
function M.get_value(option)
  print("STORED_" .. string.upper(option), " ", vim.g["STORED_" .. string.upper(option)])
  return vim.g["STORED_" .. string.upper(option)]
end
function M.set_value(option, value)
  vim.g["STORED_" .. string.upper(option)] = value
end
function M.toggle_or_set_scoped(option, scope, value)
  return pcall(function()
    local new_value
    if scope == "o" then
      new_value = vim.F.if_nil(value, not vim[scope][option])
      vim[scope][option] = new_value
      M.set_value(option, new_value)
    elseif scope == "wo" then
      new_value = vim.F.if_nil(value, not vim[scope][vim.api.nvim_get_current_win()][option])
      vim[scope][vim.api.nvim_get_current_win()][option] = new_value
    elseif scope == "bo" then
      new_value = vim.F.if_nil(value, not vim[scope][vim.api.nvim_get_current_buf()][option])
      vim[scope][vim.api.nvim_get_current_buf()][option] = new_value
    end
    return new_value
  end)
end
function M.toggle_or_set(option, value)
  return function()
    local ok, new_value, scope
    for _, _scope in ipairs({ "bo", "wo", "o" }) do
      ok, new_value = M.toggle_or_set_scoped(option, _scope, value)
      -- vim.notify(("%s %s"):format(scope, tostring(new_value)))
      if ok then
        scope = _scope
        break
      end
    end
    if not ok then
      vim.notify("Option not found: " .. option)
      return
    else
      vim.notify(("Option set: %s.%s=%s"):format(scope, option, tostring(new_value)))
    end
  end
end
-- restore options from shada
function M.restore_options()
  local options = {
    "wrap",
    "cursorcolumn",
    "cursorline",
    "ignorecase",
    "list",
    "number",
    "relativenumber",
    "spell",
  }
  for _, option in ipairs(options) do
    if M.get_value(option) ~= nil then
      M.toggle_or_set(option, M.get_value(option))
    end
  end
end

-- not working
-- autocmd("User", {
--   pattern = "VeryLazy",
--   group = augroup("CustomRestoreOptions", {}),
--   callback = M.restore_options,
-- })

return M
