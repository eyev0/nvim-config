local map = vim.keymap.set
local cmd = vim.cmd

-- handy to move around on the line
map("", "H", [[^]], { noremap = true, silent = true })
map("", "L", [[$]], { noremap = true, silent = true })
-- 'whole buffer' operator
map(
  { "o", "v" },
  "ie",
  "<cmd>exec 'normal! ggVG'<cr>",
  { noremap = true, silent = true, desc = "Whole buffer" }
)
-- easier navigation, powered by tmux plugin
map({ "n", "t" }, "<C-h>", "<C-w>h", { noremap = true, silent = true })
map({ "n", "t" }, "<C-j>", "<C-w>j", { noremap = true, silent = true })
map({ "n", "t" }, "<C-k>", "<C-w>k", { noremap = true, silent = true })
map({ "n", "t" }, "<C-l>", "<C-w>l", { noremap = true, silent = true })
-- redraw screen
map("n", "<M-l>", [[<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>]], { noremap = true, silent = true })
-- delete buffer
map("n", "<C-w>d", [[:bdelete<CR>]], { noremap = true, silent = true })
-- tabs stuff
map("n", "<C-w>tn", [[:tabnew<CR>]], { noremap = true, silent = true })
map("n", "<C-w>to", [[:tabonly<CR>]], { noremap = true, silent = true })
map("n", "<C-w>tq", [[:tabc<CR>]], { noremap = true, silent = true })
-- tabs navigation
map({ "n", "t" }, "<C-w><C-j>", function()
  vim.cmd("tabprevious")
end, { noremap = true, silent = true })
map({ "n", "t" }, "<C-w><C-k>", function()
  vim.cmd("tabnext")
end, { noremap = true, silent = true })
map({ "n", "t" }, "<C-w><C-h>", function()
  pcall(vim.cmd, "-tabmove")
end, { noremap = true, silent = true })
map({ "n", "t" }, "<C-w><C-l>", function()
  pcall(vim.cmd, "+tabmove")
end, { noremap = true, silent = true })
-- resize with C-arrows
map({ "", "t" }, "<C-Up>", function()
  vim.cmd("resize -3")
end, { noremap = true, silent = true })
map({ "", "t" }, "<C-Down>", function()
  vim.cmd("resize +3")
end, { noremap = true, silent = true })
map({ "", "t" }, "<C-Left>", function()
  vim.cmd("vertical resize -4")
end, { noremap = true, silent = true })
map({ "", "t" }, "<C-Right>", function()
  vim.cmd("vertical resize +4")
end, { noremap = true, silent = true })
-- better indenting
map("v", "<", "<gv", { noremap = true, silent = true })
map("v", ">", ">gv", { noremap = true, silent = true })
-- clear last search
map("n", "<C-c>", cmd.nohlsearch, { noremap = false, silent = true })
-- delete to blackhole register
map({ "n", "x" }, "c", [["_c]], { noremap = true, silent = true })
map({ "n", "x" }, "d", [["_d]], { noremap = true, silent = true })
map("n", "dd", [["_dd]], { noremap = true, silent = true })
map({ "n", "x" }, "D", [["_D]], { noremap = true, silent = true })
-- cut
map({ "n", "x" }, "x", [[d]], { noremap = true, silent = true })
map("n", "xx", [[dd]], { noremap = true, silent = true })
map("n", "X", [[D]], { noremap = true, silent = true })
-- substitute
local substitute = require("substitute")
map("n", "s", substitute.operator, { noremap = true, silent = true })
map("n", "ss", substitute.line, { noremap = true, silent = true })
map("n", "S", substitute.eol, { noremap = true, silent = true })
map("x", "s", substitute.visual, { noremap = true, silent = true })
-- yank maps
map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
map({ "n", "x" }, "y", "<Plug>(YankyYank)")
-- cycle through yank history
map("n", "<PageUp>", [[<plug>(YankyCycleBackward)]], { silent = true })
map("n", "<PageDown>", [[<plug>(YankyCycleForward)]], { silent = true })
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
