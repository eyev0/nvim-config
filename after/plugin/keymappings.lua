local map = vim.keymap.set
local utils = require("rc.utils.keymap")
local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local qf = require("rc.utils.qf")
local jumplist = require("rc.utils.jumplist")

-- debug
-- if DEBUG_CONFIG ~= nil then
--   return
-- end
-- casual save
map({ "n", "i" }, "<C-s>", function()
  if utils.is_ins_mode() then
    feedkeys("<C-o>:w<CR>", "n")
  else
    cmd("w")
  end
end, { noremap = true, silent = true })
-- save all
map({ "n", "i" }, "<C-S-S>", function()
  if utils.is_ins_mode() then
    feedkeys("<C-o>:wa<CR>", "n")
  else
    cmd("wa")
  end
end, { noremap = true, silent = true })
-- lazy
map("n", "<leader>ps", [[:Lazy sync<CR>]], { noremap = true, silent = true })
map("n", "<leader>pp", [[:Lazy profile<CR>]], { noremap = true, silent = true })
-- silent dot
map("n", ".", ".", { noremap = true, silent = true })
-- silent & - repeat last substitution (:s/)
map("n", "&", ":&&<CR>", { noremap = true, silent = true })
-- handy to move around on the line
-- map("", "H", [[^]], { noremap = true, silent = true })
-- map("", "L", [[$]], { noremap = true, silent = true })
-- 'whole buffer' operator
map("o", "ie", "<cmd>execute 'normal! ggVG'<cr>", { noremap = true, silent = true, desc = "Whole buffer" })
-- quit with <C-F12>
map({ "n", "t" }, "<F36>", function()
  pcall(cmd, "wa")
  cmd("qa")
end, { noremap = true, silent = true }) --<C-F12>
-- easier navigation, powered by tmux plugin
map({ "n", "t" }, "<C-h>", function()
  cmd("TmuxNavigateLeft")
end, { noremap = true, silent = true })
map({ "n", "t" }, "<C-j>", function()
  cmd("TmuxNavigateDown")
end, { noremap = true, silent = true })
map({ "n", "t" }, "<C-k>", function()
  cmd("TmuxNavigateUp")
end, { noremap = true, silent = true })
map({ "n", "t" }, "<C-l>", function()
  cmd("TmuxNavigateRight")
end, { noremap = true, silent = true })
-- redraw screen
map("n", "<M-l>", [[<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>]], { noremap = true, silent = true })
map("n", "<C-w>d", [[:bdelete<CR>]], { noremap = true, silent = true })
-- tabs stuff
map("n", "<C-w>tn", [[:tabnew<CR>]], { noremap = true, silent = true })
map("n", "<C-w>to", [[:tabonly<CR>]], { noremap = true, silent = true })
map("n", "<C-w>tq", [[:tabc<CR>]], { noremap = true, silent = true })
-- Arrows switch tabs
map({ "n", "t" }, "<C-w><C-j>", function()
  cmd("tabprevious")
end, { noremap = true, silent = true })
map({ "n", "t" }, "<C-w><C-k>", function()
  cmd("tabnext")
end, { noremap = true, silent = true })
map({ "n", "t" }, "<C-w><C-h>", function()
  pcall(cmd, "-tabmove")
end, { noremap = true, silent = true })
map({ "n", "t" }, "<C-w><C-l>", function()
  pcall(cmd, "+tabmove")
end, { noremap = true, silent = true })
map("t", "<C-PageUp>", function()
  cmd("tabprevious")
end, { noremap = true, silent = true })
map("t", "<C-PageDown>", function()
  cmd("tabnext")
end, { noremap = true, silent = true })
-- resize with C-arrows
map({ "", "t" }, "<C-S-Up>", function()
  cmd("resize -3")
end, { noremap = true, silent = true })
map({ "", "t" }, "<C-S-Down>", function()
  cmd("resize +3")
end, { noremap = true, silent = true })
map({ "", "t" }, "<C-S-Left>", function()
  cmd("vertical resize -4")
end, { noremap = true, silent = true })
map({ "", "t" }, "<C-S-Right>", function()
  cmd("vertical resize +4")
end, { noremap = true, silent = true })
-- better indenting
map("v", "<", "<gv", { noremap = true, silent = true })
map("v", ">", ">gv", { noremap = true, silent = true })
map("n", "<C-c>", function()
  -- fn.setreg("/", "")
  cmd.nohlsearch()
end, { noremap = false, silent = true })
-- map({ "n", "x", "o" }, "n", function()
--   if fn.getreg("/") ~= "" then
--     cmd("'Nn'[v:searchforward]")
--     cmd("normal! zzzv")
--   end
-- end, { noremap = true, silent = true })
-- map({ "n", "x", "o" }, "N", function()
--   if fn.getreg("/") ~= "" then
--     cmd("'nN'[v:searchforward]")
--     cmd("normal! zzzv")
--   end
-- end, { noremap = true, silent = true })
-- after positioning J fix
map("n", "J", [[mzJ`z]], { noremap = true, silent = true })
-- jumplist mutation
map("n", "k", [[(v:count > 5 ? "m'" . v:count : "") . 'k']], { noremap = true, silent = true, expr = true })
map("n", "j", [[(v:count > 5 ? "m'" . v:count : "") . 'j']], { noremap = true, silent = true, expr = true })
-- s for substitute
local substitute = require("substitute")
map("n", "s", substitute.operator, { noremap = true, silent = true })
map("n", "ss", substitute.line, { noremap = true, silent = true })
map("n", "S", substitute.eol, { noremap = true, silent = true })
map("x", "s", substitute.visual, { noremap = true, silent = true })
-- yank-delete
map({ "n", "x" }, "c", [["_c]], { noremap = true, silent = true })
map({ "n", "x" }, "d", [["_d]], { noremap = true, silent = true })
map("n", "dd", [["_dd]], { noremap = true, silent = true })
map({ "n", "x" }, "D", [["_D]], { noremap = true, silent = true })
map({ "n", "x" }, "x", [[d]], { noremap = true, silent = true })
map("n", "xx", [[dd]], { noremap = true, silent = true })
map("n", "X", [[D]], { noremap = true, silent = true })
-- yank maps
-- map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
-- map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
-- map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
-- map("n", "<PageUp>", [[<plug>(YankyCycleBackward)]], { silent = true })
-- map("n", "<PageDown>", [[<plug>(YankyCycleForward)]], { silent = true })
-- map({ "n", "x" }, "y", "<Plug>(YankyYank)")
-- like unimpaired
-- map("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
-- map("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
-- map("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
-- map("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")
-- map("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)")
-- map("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
-- map("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
-- map("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")
-- map("n", "=p", "<Plug>(YankyPutAfterFilter)")
-- map("n", "=P", "<Plug>(YankyPutBeforeFilter)")
-- exchange
local exchange = require("substitute.exchange")
map("n", "cx", exchange.operator, { noremap = true, silent = true })
map("n", "cxx", exchange.line, { noremap = true, silent = true })
map("x", "X", exchange.visual, { noremap = true, silent = true })
map("n", "cxc", exchange.cancel, { noremap = true, silent = true })
-- search-replace
map(
  "n",
  "<leader>sr",
  ":%s/<C-r><C-w>//gcI<Left><Left><Left><Left>",
  { silent = false, desc = "Search and replace cword" }
)
map(
  "v",
  "<leader>sr",
  'y:%s/<C-R>"//gcI<Left><Left><Left><Left>',
  { silent = false, desc = "Search and replace selection" }
)
-- Maximizer
map("n", "<C-w>m", [[:MaximizerToggle!<CR>]], { noremap = true, silent = true })
-- undo streak breakers
map("i", ",", [[,<C-g>u]], { noremap = true, silent = true })
map("i", ".", [[.<C-g>u]], { noremap = true, silent = true })
map("i", "!", [[!<C-g>u]], { noremap = true, silent = true })
map("i", "?", [[?<C-g>u]], { noremap = true, silent = true })
map("i", "(", [[(<C-g>u]], { noremap = true, silent = true })
map("i", ")", [[)<C-g>u]], { noremap = true, silent = true })
map("i", "[", [[[<C-g>u]], { noremap = true, silent = true })
map("i", "]", [[]<C-g>u]], { noremap = true, silent = true })
map("i", "{", [[{<C-g>u]], { noremap = true, silent = true })
map("i", "}", [[}<C-g>u]], { noremap = true, silent = true })
map("i", "<", [[<<C-g>u]], { noremap = true, silent = true })
map("i", ">", [[><C-g>u]], { noremap = true, silent = true })
map("i", ":", [[:<C-g>u]], { noremap = true, silent = true })
map("i", "<CR>", [[<CR><C-g>u]], { noremap = true, silent = true })
-- hacking search with visual mode
-- search within current selection (prompt)
map("x", "/i", [[<Esc>/\%V]], { noremap = true, silent = true })
-- jj to escape
-- map("i", "jj", "<ESC>", { noremap = true, silent = true })
map("t", "<C-]>", "<C-\\><C-n>", { noremap = true, silent = true })
-- Move selected line / block of text in visual mode
map("x", "K", ":move '<-2<CR>gv=gv", { noremap = true, silent = true })
map("x", "J", ":move '>+1<CR>gv=gv", { noremap = true, silent = true })
-- treesitter unit (node)
map(
  "x",
  "in",
  ':lua require"treesitter-unit".select()<CR>',
  { noremap = true, silent = true, desc = "Select treesitter node's inner scope" }
)
map(
  "x",
  "an",
  ':lua require"treesitter-unit".select(true)<CR>',
  { noremap = true, silent = true, desc = "Select treesitter node's outer scope" }
)
map(
  "o",
  "in",
  ':<c-u>lua require"treesitter-unit".select()<CR>',
  { noremap = true, silent = true, desc = "Select treesitter node's inner scope" }
)
map(
  "o",
  "an",
  ':<c-u>lua require"treesitter-unit".select(true)<CR>',
  { noremap = true, silent = true, desc = "Select treesitter node's outer scope" }
)
map(
  "n",
  "tn",
  require("illuminate").goto_next_reference,
  { noremap = true, silent = true, desc = "Go to next node reference" }
)
map(
  "n",
  "tp",
  require("illuminate").goto_prev_reference,
  { noremap = true, silent = true, desc = "Go to prev node reference" }
)
-- quickfix stuff
-- Open quickfix list at the bottom of the screen
map("n", "<C-q><C-q>", [[:cclose<CR>]], { noremap = true, silent = true })
map("n", "<C-q><C-o>", qf.open, { noremap = true, silent = true, desc = "Open quickfix" })
map("n", "<C-q><C-n>", function()
  cmd("cnewer")
end, { noremap = true, silent = true, desc = "Next qf list" })
map("n", "<C-q><C-p>", function()
  cmd("colder")
end, { noremap = true, silent = true, desc = "Prev qf list" })
-- TODO: C-S-O/I - previous/next window jump
local w_win_list = {}
local w_threshold = 100
local w_current_pos = table.maxn(w_win_list)
local function push_win(win)
  if table.maxn(w_win_list) >= w_threshold then
    table.remove(w_win_list, 0)
  end
  table.insert(w_win_list, win)
end
autocmd("BufWinEnter", {
  group = augroup("RecordVisitedWinIds", {}),
  callback = function()
    local win = api.nvim_get_current_win()
    -- print(win)
    push_win(win)
  end,
})
map("n", "<C-S-O>", function() end, { noremap = true, silent = true })
map("n", "n", function()
  if fn.getreg("/") ~= "" then
    feedkeys("nzzzv", "ni")
  end
end, { noremap = true, silent = true })
map("n", "N", function()
  if fn.getreg("/") ~= "" then
    feedkeys("Nzzzv", "ni")
  end
end, { noremap = true, silent = true })
map("n", "<C-n>", function()
  if #vim.fn.getqflist() == 0 then
    return
  end
  jumplist.mark()
  if #vim.fn.getqflist() == 1 then
    cmd("cfirst")
  elseif not pcall(cmd, "cnext") then
    pcall(cmd, "cfirst")
  end
end, { noremap = true, silent = true, desc = "Go to next item in qf" })
map("n", "<C-p>", function()
  if #vim.fn.getqflist() == 0 then
    return
  end
  jumplist.mark()
  if #vim.fn.getqflist() == 1 then
    cmd("cfirst")
  elseif not pcall(cmd, "cprevious") then
    pcall(cmd, "clast")
  end
end, { noremap = true, silent = true, desc = "Go to prev item in qf" })
map("n", "<C-S-N>", function()
  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(cmd, "cbelow")
end, { noremap = true, silent = true, desc = "Go to next item in qf in this file" })
map("n", "<C-S-P>", function()
  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(cmd, "cabove")
end, { noremap = true, silent = true, desc = "Go to prev item in qf in this file" })
map("n", "<leader>.", function()
  local cursor = api.nvim_win_get_cursor(0)
  fn.setloclist(0, {
    {
      bufnr = api.nvim_get_current_buf(),
      lnum = cursor[1],
      col = cursor[2] + 1,
      ---@diagnostic disable-next-line: param-type-mismatch
      text = fn.getline("."),
    },
  }, "a")
end, { noremap = true, silent = true, desc = "Add cursorpos to loclist" })
-- search-replace within quickfix entries
map({ "v", "n" }, "<C-q><C-r>", function()
  if #fn.getqflist() == 0 then
    cmd("echo 'No quickfix list'")
    return
  end
  local search
  if utils.is_vis_mode() then
    cmd('noau normal! "vy"')
    search = fn.getreg("v")
  else
    search = fn.input({ prompt = "Search: " })
  end
  local replacement = fn.input({ prompt = "Replace with: " })
  if search == nil or #search == 0 or replacement == nil or #replacement == 0 then
    return
  end
  cmd("cdo s/" .. fn.escape(search, "/") .. "/" .. fn.escape(replacement, "/") .. "/gcI")
end, { noremap = true, silent = true, desc = "Replace within quickfix entries" })
-- TODO: construct substitution command in cmdline with preview, then exit and paste it to cdo
--
-- map("c", "<C-q><C-r>", function()
-- 	local c = fn.getcmdline()
-- 	feedkeys("<Esc>", "")
-- 	cmd("cdo " .. c:gsub("%%s/", "s/") .. "gcI")
-- end, { noremap = true, silent = true })
map("n", "<leader>vso", function()
  vim.o.relativenumber = true
  vim.o.number = true
  vim.o.signcolumn = O.signcolumn
  vim.o.scrolloff = O.scrolloff
  vim.o.sidescrolloff = O.sidescrolloff
end, { noremap = true, silent = true, desc = "Reset scrolloff" })
-- noice scrolling through hover docs
local has_noice = pcall(require, "noice")
map("n", "<c-d>", function()
  if not has_noice or not require("noice.lsp").scroll(4) then
    return "<c-d>"
  end
end, { silent = true, expr = true })
map("n", "<c-u>", function()
  if not has_noice or not require("noice.lsp").scroll(-4) then
    return "<c-u>"
  end
end, { silent = true, expr = true })
-- lsp
-- toggle diagnostics
map(
  "n",
  "<F2>",
  Lsp.diagnostic_toggle_virt_lines,
  { noremap = true, silent = true, desc = "Diagnostics: toggle virtual lines" }
)
map(
  "n",
  "<F26>",
  Lsp.diagnostic_toggle_float,
  { noremap = true, silent = true, desc = "Diagnostics: toggle float" }
)
map(
  "n",
  "<F38>",
  Lsp.inlay_hints_toggle,
  { noremap = true, silent = true, desc = "Diagnostics: toggle inlay_hints" }
)
map("n", "<leader>le", function()
  vim.diagnostic.setqflist({ severity = { min = Lsp.diagnostic_min_severity, open = false } })
  qf.open()
end, { noremap = true, silent = true, desc = "Diagnostics to qf list" })
map("n", "<F27>", function()
  vim.diagnostic.goto_prev({ severity = { min = Lsp.diagnostic_min_severity } })
end, { noremap = true, silent = true, desc = "Go to previous diagnostic" })
map("n", "<F3>", function()
  vim.diagnostic.goto_next({ severity = { min = Lsp.diagnostic_min_severity } })
end, { noremap = true, silent = true, desc = "Go to next diagnostic" })
map(
  "n",
  "<F39>",
  Lsp.diagnostic_shift_min_severity,
  { noremap = true, silent = true, desc = "Diagnostics: shift severity" }
)
map("n", "<F4>", "]c", { noremap = true, silent = true, desc = "git: Next hunk" })
map(
  "n",
  "<F28>", --<C-F4>
  "[c",
  { noremap = true, silent = true, desc = "git: Prev hunk" }
)
-- formatting without calling on_attach (for null-ls)
map("n", "<leader>laf", function()
  vim.lsp.buf.format({
    async = true,
    filter = function(client)
      return client.name == "null-ls"
    end,
  })
end, { noremap = true, silent = true, desc = "Format file" })
-- refactoring.nvim
local function set_refactor_shortcuts(params)
  local function buf_map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = params.buf
    return map(mode, lhs, rhs, opts)
  end
  buf_map(
    "v",
    "<leader>laef",
    [[<Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
    { noremap = true, silent = true, desc = "refactor: Extract Function" }
  )
  buf_map(
    "v",
    "<leader>laetf",
    [[<Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
    { noremap = true, silent = true, desc = "refactor: Extract Function To File" }
  )
  buf_map({ "n", "v" }, "<leader>laiv", function()
    if utils.is_vis_mode() then
      feedkeys("<Esc>", "n")
    end
    require("refactoring").refactor("Inline Variable")
  end, { noremap = true, silent = true, desc = "refactor: Inline Variable" })
  -- do not map extract variable for java
  if params.file:find(".java") then
    return
  end
  buf_map(
    "v",
    "<leader>laev",
    [[<Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
    { noremap = true, silent = true, desc = "refactor: Extract Variable" }
  )
end
api.nvim_create_autocmd("BufEnter", {
  group = api.nvim_create_augroup("RefactoringNvimShortcuts", {}),
  callback = set_refactor_shortcuts,
})
-- local aerial_config = require("rc.configs.aerial")
map("n", "<leader>ls", function()
  -- aerial_config.setup("sideview")
  cmd("AerialToggle!")
  -- cmd("Navbuddy")
end, { noremap = true, silent = true, desc = "Toggle lsp symbols list" })
-- NvimTree
local nvim_tree = require("nvim-tree.api").tree
map("n", "<leader>n", function()
  nvim_tree.toggle(true, false, fn.getcwd(-1, 0))
end, { noremap = true, silent = true, desc = "NvimTree: Toggle for current scope (global/tab/window)" })
-- floaterm
-- local toggleterm = require("toggleterm")
local terms = require("rc.configs.toggleterm").terms
local term = require("toggleterm.terminal").Terminal:new({
  direction = "float",
  on_create = function()
    cmd("startinsert!")
  end,
  on_open = function()
    cmd("startinsert!")
  end,
})
local function toggleterm(size, direction)
  direction = vim.F.if_nil(direction, "float")
  term:toggle(size, direction)
end
map({ "n", "t" }, "<F1>", toggleterm, { noremap = true, silent = true })
map({ "n", "t" }, "<F25>", function()
  toggleterm(nil, "tab")
end, { noremap = true, silent = true })
-- map({ "n", "t" }, "<C-S-End>", function()
--   toggleterm(16, "horizontal")
-- end, { noremap = true, silent = true })
-- Telescope - opener
local find_files_opts = {
  layout_strategy = "horizontal",
  no_ignore = true,
  hidden = true,
  layout_config = {
    mirror = false,
    prompt_position = "top",
    scroll_speed = 5,
    height = 0.4,
    width = 0.65,
    preview_width = 0.47,
  },
}
local function with_default_opts(opts)
  opts = opts or {}
  return vim.tbl_deep_extend("force", {
    layout_strategy = "center",
    layout_config = {
      mirror = true,
      prompt_position = "top",
      scroll_speed = 7,
      height = 0.45,
      width = 0.6,
    },
  }, opts)
end
local telescope_builtin = require("telescope.builtin")
local telescope = require("telescope")
local default_mode = "git"
local mode = default_mode
map({ "n", "i" }, "<C-g>", function()
  if vim.bo.filetype == "TelescopePrompt" then
    -- toggle mode
    mode = mode == "git" and "files" or "git"
    feedkeys("<C-c>", "n")
  else
    mode = default_mode
  end
  if mode == "git" then
    local has_git =
      pcall(telescope_builtin.git_files, vim.tbl_extend("keep", find_files_opts, { show_untracked = true }))
    if not has_git then
      telescope_builtin.find_files(find_files_opts)
    end
  else
    telescope_builtin.find_files(find_files_opts)
  end
end, { noremap = true, silent = true, desc = "Find files" })
local function get_visual_selection(escaped)
  cmd('noau normal! "vy"')
  local text = fn.getreg("v")
  fn.setreg("v", {})
  text = string.gsub(text, "\n", "")
  if #text > 0 then
    if escaped then
      return fn.escape(text, "/\\(){}[].+*")
    else
      return text
    end
  else
    return ""
  end
end
-- grepping
-- Telescope grep_string search="" only_sort_text=true
map("v", "<C-f>", function()
  telescope_builtin.live_grep(with_default_opts({
    default_text = get_visual_selection(true),
    initial_mode = "normal",
  }))
end, { noremap = true, silent = true, desc = "Grep selected string" })
map("n", "<C-f>", function()
  telescope_builtin.live_grep(with_default_opts())
end, { noremap = true, silent = true, desc = "Live grep" })
map("n", "<C-S-x>", function()
  -- aerial_config.setup("telescope")
  telescope.extensions.aerial.aerial(with_default_opts({
    sorting_strategy = "descending",
    layout_config = {
      height = 0.3,
    },
  }))
end, { noremap = true, silent = true, desc = "Live grep" })
map(
  "n",
  "<leader>mn",
  ":NoiceHistory<CR>",
  { noremap = true, silent = true, desc = "View all noice messages" }
)
map("n", "<leader>mm", ":messages<CR>", { noremap = true, silent = true, desc = "View :messages" })
map("n", "<leader>mf", function()
  telescope.extensions.notify.notify({
    initial_mode = "normal",
    sorting_strategy = "descending",
  })
end, { noremap = true, silent = true, desc = "View notifications" })
-- map("n", "<leader>ovs", function()
-- 	require("telescope").extensions.persisted.persisted(with_default_opts({}))
-- end, { noremap = true, silent = true, desc = "View sessions" })
-- project/sessions
map("n", "<leader>ovsl", [[:SessionLoadLast<CR>]], { noremap = true, silent = true })
map("n", "<leader>ovso", [[:SessionLoad<CR>]], { noremap = true, silent = true })
map("n", "<leader>ovss", [[:SessionStop<CR>]], { noremap = true, silent = true })
-- map("n", "<leader>ssd", [[:SessionDelete<CR>]], { noremap = true, silent = true })
map("n", "<leader>ovsd", [[:SessionDeleteCurrent<CR>]], { noremap = true, silent = true })
map("n", "<leader>ovx", function()
  require("telescope").extensions.tmuxinator.projects(require("telescope.themes").get_dropdown({}))
end, { noremap = true, silent = true, desc = "View tmuxinator projects" })
map("n", "<leader>ovb", function()
  telescope_builtin.buffers(with_default_opts({ initial_mode = "normal" }))
end, { noremap = true, silent = true, desc = "View buffers" })
map("n", "<leader>ovf", function()
  telescope_builtin.oldfiles(with_default_opts({ initial_mode = "normal" }))
end, { noremap = true, silent = true, desc = "View oldfiles" })
map("n", "<leader>ovm", function()
  telescope_builtin.keymaps(with_default_opts())
end, { noremap = true, silent = true, desc = "View keymaps" })
map("n", "<leader>ovn", function()
  vim.ui.input({ prompt = "Show man page for", completion = "shellcmd" }, function(input)
    if input ~= nil then
      cmd("vert Man " .. input)
    end
  end)
end, { noremap = true, silent = true, desc = "Prompt for man page" })
map("n", "<leader>?", function()
  telescope_builtin.help_tags(with_default_opts())
end, { noremap = true, silent = true, desc = "View help tags" })
map("n", "<leader>ovo", function()
  telescope_builtin.vim_options(with_default_opts())
end, { noremap = true, silent = true, desc = "View vim options" })
map("n", "<leader>ovl", function()
  telescope_builtin.highlights(with_default_opts())
end, { noremap = true, silent = true, desc = "View highlights" })
map("n", "<leader>ova", function()
  telescope_builtin.autocommands(with_default_opts())
end, { noremap = true, silent = true, desc = "View autocommands" })
map("n", "<leader>ovc", function()
  telescope_builtin.commands(with_default_opts())
end, { noremap = true, silent = true, desc = "View commands" })
map("n", "<leader>ovr", function()
  telescope_builtin.reloader(with_default_opts())
end, { noremap = true, silent = true, desc = "View reloader" })
-- UndoTree
map(
  "n",
  "<leader>ovu",
  [[:UndotreeToggle <bar> UndotreeFocus<CR>]],
  { noremap = true, silent = true, desc = "View undo tree" }
)
map("n", "<leader>ovtb", function()
  telescope_builtin.builtin(with_default_opts())
end, { noremap = true, silent = true, desc = "View telescope builtin" })
map("n", "<leader>ovts", [[:TSPlaygroundToggle<CR>]], { noremap = true, silent = true })
-- todo
map("n", "<leader>ltd", function()
  -- require("todo-comments.search").setqflist({ open = false })
  require("todo-comments.search").search(function(results)
    fn.setqflist({}, " ", { title = "Todo", id = "$", items = results })
    qf.open(#results, false, false)
  end)
  -- qf.trigger()
end, { noremap = true, silent = true, desc = "Todos" })
-- open config dir
map("n", "<leader>ocp", function()
  cmd("tcd " .. vim.fn.getcwd(-1, -1))
end, { noremap = true, silent = true, desc = "Change current tab's dir to !pwd" })
map("n", "<leader>ocd", function()
  vim.ui.input({ prompt = "Cd to:", completion = "file", default = vim.fn.getcwd(-1, -1) }, function(input)
    if input ~= nil then
      if vim.loop.fs_realpath(input) then
        cmd("cd " .. input)
      else
        vim.notify("Not a directory: " .. input, vim.log.levels.ERROR)
      end
    end
  end)
end, { noremap = true, silent = true, desc = "Prompt to change global directory" })
map("n", "<leader>ods", function()
  require("rc.configs.telescope").pickers.dirs()
end, { noremap = true, silent = true, desc = "Open dir" })
-- debug actions
local dap = require("dap")
local dapui = require("dapui")
map("n", "<F8>", function()
  if vim.bo.filetype == "http" then
    cmd("RestNvimRun")
  elseif vim.bo.filetype == "rust" then
    if dap.session() == nil then
      pcall(dapui.close)
      cmd("RustDebuggables")
    else
      dap.continue()
    end
  else
    if dap.session() == nil then
      pcall(dapui.close)
    end
    dap.continue()
  end
end, { noremap = true, silent = true })
map("n", "<F32>", function()
  pcall(dapui.close)
  dap.run_last()
end, { noremap = true, silent = true })
map("n", "<F20>", function()
  dap.terminate()
  pcall(dapui.close)
end, { noremap = true, silent = true })
-- map("n", "<leader>dr", dap.terminate, { noremap = true, silent = true })
map("n", "<F6>", function()
  if dap.session() ~= nil then
    jumplist.mark()
    dap.step_over()
  end
end, { noremap = true, silent = true })
map("n", "<F5>", function()
  if dap.session() ~= nil then
    jumplist.mark()
    dap.step_into()
  end
end, { noremap = true, silent = true })
map("n", "<F7>", function()
  if dap.session() ~= nil then
    jumplist.mark()
    dap.step_out()
  end
end, { noremap = true, silent = true })
map("n", "<leader>dp", dap.toggle_breakpoint, { noremap = true, silent = true, desc = "Toggle breakpoint" })
-- set breakpoint condition
local cond_breakpoint_expr = nil
map("v", "<leader>dP", function()
  cmd('noau normal! "vy"')
  cond_breakpoint_expr = fn.getreg("v")
  -- fn.setreg("v", {})
end, { noremap = true, silent = true, desc = "Set breakpoint condition" })
-- set breakpoint with condition
local function set_breakpoint_with_condition(s)
  if s == nil then
    return
  end
  dap.set_breakpoint(s)
end
map("n", "<leader>dP", function()
  if cond_breakpoint_expr ~= nil then
    vim.ui.input(
      { prompt = "Breakpoint condition: ", default = cond_breakpoint_expr },
      set_breakpoint_with_condition
    )
    cond_breakpoint_expr = nil
  else
    vim.ui.input({ prompt = "Breakpoint condition: " }, set_breakpoint_with_condition)
  end
end, { noremap = true, silent = true, desc = "Set breakpoint with condition" })
map("n", "<leader>dc", dap.clear_breakpoints, { noremap = true, silent = true, desc = "Clear breakpoints" })
map("n", "<leader>dL", function()
  dap.set_breakpoint(nil, nil, fn.input({ prompt = "Log point message: " }))
end, { noremap = true, silent = true, desc = "Set log point message" })
map("n", "<leader>du", function()
  if dap.session() == nil then
    vim.notify_once("No active debug session", vim.log.levels.WARN)
  end
  dapui.toggle({ reset = true })
end, { noremap = true, silent = true, desc = "dapui: Toggle interface" })
map({ "n", "x" }, "<leader>de", function()
  ---@diagnostic disable-next-line: missing-parameter
  dapui.eval()
end, { noremap = true, silent = true, desc = "dapui: Eval" })
map("n", "<leader>df", function()
  ---@diagnostic disable-next-line: missing-parameter
  dapui.float_element()
end, { noremap = true, silent = true, desc = "dapui: Show element in float" })
-- debug jest
map("n", "<leader>dj", [[:JesterActions<CR>]], { noremap = true, silent = true })
-- telescope dap
map("n", "<leader>dob", [[:Telescope dap list_breakpoints<CR>]], { noremap = true, silent = true })
map("n", "<leader>dov", [[:Telescope dap variables<CR>]], { noremap = true, silent = true })
map("n", "<leader>dof", [[:Telescope dap configurations<CR>]], { noremap = true, silent = true })
map("n", "<leader>doc", [[:Telescope dap commands<CR>]], { noremap = true, silent = true })
-- :Telescope dap commands
-- :Telescope dap configurations
-- :Telescope dap list_breakpoints
-- :Telescope dap variables
-- :Telescope dap frames
-- dadbod
-- map("n", "<leader>ddu", [[:DBUIToggle<CR>]], { noremap = true, silent = true })
-- scratch buffers
map("n", "<leader>llf", [[:vsplit | e /tmp/scratch<CR>]], { noremap = true, silent = true })
map("n", "<leader>llx", [[:Luapad<CR>]], { noremap = true, silent = true, desc = "Toggle Luapad" })
map("n", "<leader>llr", [[:LuaRun<CR>]], { noremap = true, silent = true, desc = "Lua: run current file" })
map(
  "n",
  "<leader>llir",
  [[:Reload jumplist<CR>]],
  { noremap = true, silent = true, desc = "Import: reload jumplist modules" }
)
map(
  "n",
  "<leader>llis",
  [[:ImportStatus<CR>]],
  { noremap = true, silent = true, desc = "Import: show status window" }
)
map("n", "<leader>llds", function()
  require("osv").launch({ port = 8086 })
end, { noremap = true, silent = true, desc = "Debug this instance (launch server at port 8086)" })
map("n", "<leader>lldr", function()
  local log_path = fn.stdpath("data") .. "/osv.log"
  cmd("!rm " .. log_path)
  require("osv").run_this({ log = true })
  -- cmd("vsplit e " .. log_path)
end, { noremap = true, silent = true, desc = "Lua: debug current file with logging" })
-- git stuff
-- status
local esc_tabclose_tabs = {}
local prev_active_tabs = {}
map("n", "<leader>gst", function()
  local prevtabhandle = api.nvim_get_current_tabpage()
  cmd("DiffviewOpen HEAD")
  local ok = pcall(cmd, "Git")
  if not ok then
    return
  end
  cmd("resize -7")
  local current_tab = api.nvim_get_current_tabpage()
  esc_tabclose_tabs[current_tab] = true
  prev_active_tabs[current_tab] = prevtabhandle
  cmd("wincmd k | wincmd l | wincmd l")
end, { noremap = true, silent = true, desc = "Git status: working tree" })
map("n", "<leader>gss", function()
  local prevtabhandle = api.nvim_get_current_tabpage()
  cmd("DiffviewOpen --staged")
  local ok = pcall(cmd, "Git")
  if not ok then
    return
  end
  cmd("resize -7")
  local current_tab = api.nvim_get_current_tabpage()
  esc_tabclose_tabs[current_tab] = true
  prev_active_tabs[current_tab] = prevtabhandle
  cmd("wincmd k | wincmd l | wincmd l")
end, { noremap = true, silent = true, desc = "Git status: index" })
map("n", "<leader>gb", function()
  cmd("G blame")
end, { noremap = true, silent = true, desc = "Git blame" })
-- log
map("n", "<leader>gla", function()
  cmd("DiffviewFileHistory")
  esc_tabclose_tabs[api.nvim_get_current_tabpage()] = true
end, { noremap = true, silent = true, desc = "Git log - all files" })
map("n", "<leader>glf", function()
  cmd("DiffviewFileHistory %")
  esc_tabclose_tabs[api.nvim_get_current_tabpage()] = true
end, { noremap = true, silent = true, desc = "Git log - current file" })
-- diff
map("n", "<leader>gdm", function()
  cmd("tabnew")
  esc_tabclose_tabs[api.nvim_get_current_tabpage()] = true
  cmd("b#")
  cmd("Gvdiffsplit!")
end, { noremap = true, silent = true, desc = "Git merge 3-way diff" })
map("n", "<leader>gdf", function()
  cmd("DiffviewOpen HEAD -- %:p<CR>")
  esc_tabclose_tabs[api.nvim_get_current_tabpage()] = true
  cmd("wincmd l | wincmd l")
end, { noremap = true, silent = true, desc = "Git diff file against index" })
map(
  "n",
  "<leader>gda",
  [[:DiffviewOpen HEAD]],
  { noremap = true, silent = false, desc = "Git diff all against revision (prompts for revision)" }
)
-- git remote
map("n", "<leader>grp", function()
  term:open(nil, "float")
  term:change_dir(fn.getcwd(-1, 0))
  term:send("git push", false)
end, { noremap = true, silent = true, desc = "Git push" })
map("n", "<leader>grl", function()
  term:open(nil, "float")
  term:change_dir(fn.getcwd(-1, 0))
  term:send("git pull", false)
end, { noremap = true, silent = true, desc = "Git pull" })
-- lazygit
map("n", "<leader>gtt", function()
  terms.lazygit:toggle()
end, { noremap = true, silent = true, desc = "Lazygit" })
-- harpoon
local harpoon = require("harpoon")
map("n", "<leader>aa", function()
  harpoon:list():append()
end)
map("n", "<leader>av", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)
map("n", "<M-a>", function()
  harpoon:list():select(1)
end)
map("n", "<M-s>", function()
  harpoon:list():select(2)
end)
map("n", "<M-d>", function()
  harpoon:list():select(3)
end)
map("n", "<M-f>", function()
  harpoon:list():select(4)
end)
map("n", "<M-g>", function()
  harpoon:list():select(5)
end)
map("n", "<M-h>", function()
  harpoon:list():select(6)
end)
map("n", "<M-j>", function()
  harpoon:list():select(7)
end)
map("n", "<M-k>", function()
  harpoon:list():select(8)
end)
-- rest
map("n", "<leader>lhe", [[:RestSelectEnv ]], { noremap = true, silent = false })
local function get_win_by_name(name)
  local win_list = api.nvim_list_wins()
  for _, win in ipairs(win_list) do
    if fn.fnamemodify(api.nvim_buf_get_name(api.nvim_win_get_buf(win)), ":t") == name then
      return win
    end
  end
  return nil
end
map("n", "<leader>lhr", function()
  local win = get_win_by_name("rest_nvim_results")
  -- print(win)
  if win ~= nil then
    -- api.nvim_win_hide(win)
    -- TODO: get a preview here with require("noice").redirect("RestNvimPreview")
    local buf = api.nvim_win_get_buf(win)
    vim.bo[buf].modifiable = true
    api.nvim_buf_set_lines(buf, 0, -1, false, {})
    vim.bo[buf].modifiable = false
  end
  -- redirect not working for this, probably async output
  cmd("RestNvimRun")
end, { noremap = true, silent = true })
-- map("n", "<leader>lhp", [[<cmd>RestNvimPreview<CR>]], { noremap = true, silent = true })
map("n", "<leader>lhp", function()
  require("noice").redirect("RestNvimPreview")
end, { desc = "RestNvimPreview" })
map("n", "<leader>lhl", [[<cmd>RestNvimRunLast<CR>]], { noremap = true, silent = true })
-- prettify json
map("n", "<leader>ljsp", [[:%!jq<CR>]], { noremap = true, silent = true, desc = "Prettify json" })
map("v", "<leader>ljsp", [[:!jq<CR>]], { noremap = true, silent = true, desc = "Prettify json" })
map("n", "<leader>ljsm", [[:%!jq -c<CR>]], { noremap = true, silent = true, desc = "Minify json" })
map("v", "<leader>ljsm", [[:!jq -c<CR>]], { noremap = true, silent = true, desc = "Minify json" })
-- map("c", "<C-t>", function()
-- 	require("noice").redirect(fn.getcmdline())
-- end, { desc = "Redirect Cmdline" })
map("c", "<C-t>", function()
  require("noice").redirect(fn.getcmdline(), { { filter = { event = "msg_show" }, view = "notify" } })
  feedkeys("<C-c>", "n")
end, { desc = "Redirect Cmdline" })
--
local cmdbuf = require("cmdbuf")
map({ "n", "v" }, "qo", function()
  cmdbuf.split_open(vim.o.cmdwinheight)
end, { noremap = true, silent = true, nowait = true })
map("c", "<C-f>", function()
  cmdbuf.split_open(vim.o.cmdwinheight, { line = fn.getcmdline(), column = fn.getcmdpos() })
  feedkeys("<C-c>", "n")
end)
-- open lua command-line window
map("n", "ql", function()
  cmdbuf.split_open(vim.o.cmdwinheight, { type = "lua/cmd" })
end, { noremap = true, silent = true, nowait = true })
local cmdwin_aug_id = api.nvim_create_augroup("CmdwinHacks", {})
local function cmdwin_maps()
  map("n", "<Esc>", [[<Cmd>quit<CR>]], { noremap = true, silent = true, buffer = true })
  map("n", "q", [[<Cmd>quit<CR>]], { nowait = true, buffer = true })
  map(
    { "n", "i" },
    "<C-t>",
    function()
      local cursor = api.nvim_win_get_cursor(0)
      local line = api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], false)[1]
      local command = vim.bo.filetype == "lua" and ("lua " .. line) or line
      vim.notify(command)
      cmd("stopinsert")
      cmd("wincmd p")
      require("noice").redirect(command, { { filter = { event = "msg_show" }, view = "notify" } })
      cmd("wincmd p")
    end,
    { noremap = true, silent = true, desc = "Execute command under cursor in previous buffer", buffer = true }
  )
end
api.nvim_create_autocmd({ "CmdwinEnter" }, {
  group = cmdwin_aug_id,
  callback = function()
    cmdwin_maps()
    map("n", "<C-k>", [[<Cmd>quit<CR>]], { nowait = true, buffer = true })
    cmd("TSBufDisable incremental_selection")
    cmd("TSContextDisable")
  end,
})
api.nvim_create_autocmd({ "CmdwinLeave" }, {
  group = cmdwin_aug_id,
  callback = function()
    cmd("TSContextEnable")
  end,
})
api.nvim_create_autocmd({ "User" }, {
  group = api.nvim_create_augroup("cmdbuf_setting", {}),
  pattern = { "CmdbufNew" },
  callback = function()
    cmdwin_maps()
    map("n", "dd", cmdbuf.delete, { buffer = true })
    vim.wo.winfixheight = true
    local sources = {
      { name = "nvim_lua", group_index = 1, priority = 3 },
      { name = "path", group_index = 2, priority = 2 },
    }
    if vim.bo.filetype == "lua" then
      table.insert(sources, { name = "vsnip", group_index = 1, priority = 10 })
    else
      table.insert(sources, { name = "cmdline", group_index = 1, priority = 4 })
    end
    require("cmp").setup.buffer({
      sources = sources,
    })
  end,
})
-- unicode encode-decode
map(
  "v",
  "]c",
  [[:s/\%V\\u\(\x\{4\}\)/\=nr2char('0x'.submatch(1))/<CR>]],
  { noremap = true, silent = true, desc = "Decode unicode character" }
)
local options = require("rc.options")
map("n", "\\w", options.toggle_or_set("wrap"), { noremap = true, silent = true, desc = "Toggle wrap" })
map(
  "n",
  "\\C",
  options.toggle_or_set("cursorcolumn"),
  { noremap = true, silent = true, desc = "Toggle cursorcolumn" }
)
map("n", "\\c", options.toggle_or_set("cursorline"), {
  noremap = true,
  silent = true,
  desc = "Toggle cursorline",
})
map("n", "\\i", options.toggle_or_set("ignorecase"), {
  noremap = true,
  silent = true,
  desc = "Toggle ignorecase",
})
map("n", "\\l", options.toggle_or_set("list"), { noremap = true, silent = true, desc = "Toggle list" })
map("n", "\\n", options.toggle_or_set("number"), { noremap = true, silent = true, desc = "Toggle number" })
map(
  "n",
  "\\r",
  options.toggle_or_set("relativenumber"),
  { noremap = true, silent = true, desc = "Toggle relativenumber" }
)
map("n", "\\s", options.toggle_or_set("spell"), { noremap = true, silent = true, desc = "Toggle spell" })
map("n", "\\b", function()
  vim.g.heirline_show_winbufnrs = not vim.g.heirline_show_winbufnrs
end, { noremap = true, silent = true, desc = "Toggle show win/buf numbers in winbar" })
map("n", "go", function()
  cmd("normal! o")
  cmd('normal! ^"_D')
  cmd("startinsert")
end, { noremap = true, silent = true, desc = "Add new line after current" })
map("n", "gO", function()
  cmd("normal! O")
  cmd('normal! ^"_D')
  cmd("startinsert")
end, { noremap = true, silent = true, desc = "Add new line before current" })
-- esc
map("n", "<Esc>", function()
  cmd.cclose()
  -- cmd([[Vista!]])
  cmd([[AerialClose]])
  cmd([[NvimTreeClose]])
  cmd([[TroubleClose]])
  pcall(dapui.close)
end, { noremap = true, silent = true })
-- filetype-specific shortcuts
local esc_quit_fts = { "help", "NvimTree", "notify", "aerial", "vista_kind", "httpResult", "man", "Trouble" }
local esc_tabclose_fts = { "fugitive", "DiffviewFiles", "DiffviewFileHistory" }
local q_quit_fts = { "help", "notify", "man", "ImportManager", "qf" }
autocmd("BufWinEnter", {
  group = augroup("CustomFiletypeSettings", {}),
  callback = function(opts)
    -- esc
    local ft = vim.bo[opts.buf].filetype
    local current_tab = api.nvim_get_current_tabpage()
    if vim.tbl_contains(esc_quit_fts, ft) then
      -- close only current buffer with Esc
      if ft == "qf" then
        map("n", "<Esc>", function()
          cmd.wincmd("p")
          cmd.cclose()
        end, { noremap = true, silent = true, nowait = true, buffer = opts.buf })
      else
        map("n", "<Esc>", ":quit<CR>", { noremap = true, silent = true, nowait = true, buffer = opts.buf })
      end
    elseif vim.tbl_contains(esc_tabclose_fts, ft) or esc_tabclose_tabs[current_tab] then
      -- close current tab and focus previously active tab
      map("n", "<Esc>", function()
        local tabnr_to_close = fn.tabpagenr()
        esc_tabclose_tabs[current_tab] = nil
        -- go to parent tabpage
        if prev_active_tabs[current_tab] ~= nil then
          cmd(("normal! %sgt"):format(prev_active_tabs[current_tab]))
        else
          cmd("tabprevious")
        end
        -- close tab
        local ok, res = pcall(cmd, "tabc! " .. tabnr_to_close)
        if not ok then
          vim.notify(("Can not close this tab page: %s"):format(res), vim.log.levels.WARN)
        end
      end, { noremap = true, silent = true, buffer = opts.buf })
    end
    -- other shortcuts
    if vim.tbl_contains(q_quit_fts, ft) then
      if ft == "qf" then
        map("n", "q", function()
          cmd.wincmd("p")
          cmd.cclose()
        end, { noremap = true, silent = true, nowait = true, buffer = opts.buf })
      else
        map("n", "q", ":quit<CR>", { noremap = true, silent = true, nowait = true, buffer = opts.buf })
      end
    end
  end,
})

if pcall(require, "langmapper") then
  require("langmapper").automapping({ global = true, buffer = false })
end

-- vim.api.nvim_set_keymap(
--   "i",
--   "<CR>",
--   vim.api.nvim_replace_termcodes("<CR>}<CMD>normal ====<CR><up><end><CR>", true, true, true),
--   { noremap = true, silent = true }
-- )
