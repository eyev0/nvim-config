-- Setup nvim-cmp.
local cmp = require("cmp")
local compare = require("cmp.config.compare")
-- local default_config = require("cmp.config.default")
local lspkind = require("lspkind")
local types = require("cmp.types")
local str = require("cmp.utils.str")

---@diagnostic disable-next-line: unused-local, unused-function
local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function feedkey(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local first_condition = function(prioritize_expand, direction)
  if prioritize_expand then
    if direction == "next" then
      return vim.fn["vsnip#available"](1) == 1
    else
      return vim.fn["vsnip#available"](-1) == 1
    end
  else
    return cmp.visible()
  end
end
local second_condition = function(prioritize_expand, direction)
  if prioritize_expand then
    return cmp.visible()
  else
    if direction == "next" then
      return vim.fn["vsnip#available"](1) == 1
    else
      return vim.fn["vsnip#available"](-1) == 1
    end
  end
end
local first_action = function(prioritize_expand, direction)
  if prioritize_expand then
    if direction == "next" then
      feedkey("<Plug>(vsnip-expand-or-jump)", "")
    else
      feedkey("<Plug>(vsnip-jump-prev)", "")
    end
  else
    if direction == "next" then
      cmp.select_next_item()
    else
      cmp.select_prev_item()
    end
  end
end
local second_action = function(prioritize_expand, direction)
  if prioritize_expand then
    if direction == "next" then
      cmp.select_next_item()
    else
      cmp.select_prev_item()
    end
  else
    if direction == "next" then
      feedkey("<Plug>(vsnip-expand-or-jump)", "")
    else
      feedkey("<Plug>(vsnip-jump-prev)", "")
    end
  end
end

local next_item = function(prioritize_expand)
  return cmp.mapping(function(fallback)
    prioritize_expand = prioritize_expand ~= nil and prioritize_expand or false
    if first_condition(prioritize_expand, "next") then
      first_action(prioritize_expand, "next")
    elseif second_condition(prioritize_expand, "next") then
      second_action(prioritize_expand, "next")
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end, { "i", "s" })
end

local prev_item = function(prioritize_expand)
  return cmp.mapping(function(fallback)
    prioritize_expand = prioritize_expand ~= nil and prioritize_expand or false
    if first_condition(prioritize_expand, "prev") then
      first_action(prioritize_expand, "prev")
    elseif second_condition(prioritize_expand, "prev") then
      second_action(prioritize_expand, "prev")
    else
      fallback()
    end
  end, { "i", "s" })
end

local confirm = cmp.mapping(function(fallback)
  if cmp.visible() then
    if vim.bo.filetype == "DressingInput" then
      cmp.confirm({ select = false })
      feedkey("<Esc>", "n")
      fallback()
    else
      cmp.confirm({ select = true })
    end
  else
    fallback()
  end
end)

local function scroll_docs(offset)
  return cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.scroll_docs(offset)
    else
      fallback()
    end
  end, { "i", "c" })
end
-- no tags please
vim.keymap.set("i", "<C-n>", "<NOP>")
vim.keymap.set("i", "<C-p>", "<NOP>")
vim.keymap.set("i", "<C-y>", "<NOP>")
-- remap omnifunc
vim.keymap.set("i", "<C-x><C-o>", cmp.complete, { noremap = true, silent = true })

local mappings = {
  ["<C-d>"] = scroll_docs(4),
  ["<C-u>"] = scroll_docs(-4),
  ["<C-Space>"] = cmp.mapping(cmp.mapping.complete({}), { "i", "c" }),
  ["<C-y>"] = cmp.config.disable,
  ["<C-e>"] = cmp.mapping(function()
    if cmp.visible() then
      cmp.abort()
    else
      cmp.complete()
    end
  end),
  ["<CR>"] = confirm,
  ["<C-n>"] = next_item(false),
  ["<Tab>"] = next_item(false),
  ["<C-p>"] = prev_item(false),
  ["<S-Tab>"] = prev_item(false),
}

if pcall(require, "langmapper") then
  local keymap = require("cmp.utils.keymap")
  local origin_set_map = keymap.set_map
  local utils = require("langmapper.utils")
  keymap.set_map = function(bufnr, mode, lhs, rhs, opts)
    origin_set_map(bufnr, mode, lhs, rhs, opts)
    origin_set_map(bufnr, mode, utils.translate_keycode(lhs, "default", "ru"), rhs, opts)
  end
end

local function merge(a, b)
  return vim.tbl_deep_extend("force", {}, a, b)
end

local sources = {
  -- { name = "codeium", group_index = 1, priority = 17 },
  { name = "copilot", group_index = 1, priority = 20 },
  { name = "nvim_lsp", group_index = 1, priority = 15 },
  { name = "vsnip", group_index = 1, priority = 10 },
  -- { name = "rg", group_index = 2, priority = 5, max_item_count = 2, keyword_length = 3 },
  { name = "buffer", group_index = 2, priority = 5, max_item_count = 3, keyword_length = 3 },
  { name = "path", group_index = 2, priority = 3 },
  { name = "crates", group_index = 2, priority = 3 },
  -- { name = "nvim_lsp_signature_help", group_index = 3, priority = 1 },
  -- { name = "npm", group_index = 4, keyword_length = 4 },
}

cmp.setup({
  enabled = function()
    return not (
        vim.api.nvim_buf_get_option(0, "buftype") == "prompt"
        or vim.api.nvim_buf_get_option(0, "filetype") == "no-neck-pain"
      ) or require("cmp_dap").is_dap_buffer()
  end,
  preselect = cmp.PreselectMode.Item,
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  performance = {
    debounce = 10,
    throttle = 20,
    fetching_timeout = 100,
  },
  mapping = mappings,
  sorting = {
    priority_weight = 3,
    comparators = {
      compare.offset,
      compare.exact,
      compare.score,
      compare.recently_used,
      compare.locality,
      -- require("cmp-under-comparator").under,
      compare.kind,
      compare.length,
      compare.order,
    },
  },
  sources = cmp.config.sources(sources),
  window = {
    documentation = merge(cmp.config.window.bordered(), {
      max_height = 15,
      max_width = 75,
    }),
  },
  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = lspkind.cmp_format({
      mode = "symbol_text",
      preset = "codicons",
      symbol_map = {
        copilot = "",
        Codeium = "",
      },
      maxwidth = 62, -- prevent the popup from showing more than provided characters
      ellipsis_char = "..",
      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function(entry, item)
        -- Get the full snippet (and only keep first line)
        local word = entry:get_insert_text()
        if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
          word = vim.lsp.util.parse_snippet(word)
        end
        word = str.oneline(word)
        if
          entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
          and string.sub(item.abbr, -1, -1) == "~"
        then
          word = "~" .. word .. "~"
        end
        if string.len(word) > 0 then
          item.abbr = word
        end
        return item
      end,
    }),
  },
})

cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "buffer" },
  }),
})

cmp.setup.cmdline({ "/", "?" }, {
  sources = cmp.config.sources({
    { name = "buffer" },
    -- { name = "rg", keyword_length = 3, max_item_count = 5 },
  }),
  mapping = cmp.mapping.preset.cmdline(mappings),
})

cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
    { name = "cmdline", group_index = 1, priority = 4 },
    { name = "nvim_lua", group_index = 1, priority = 3 },
    { name = "path", group_index = 2, priority = 2 },
  }),
  mapping = cmp.mapping.preset.cmdline(mappings),
})

cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
  sources = {
    { name = "dap" },
  },
})
