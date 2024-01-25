local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local qf = require("rc.utils.qf")
local jumplist = require("rc.utils.jumplist")

-- LSP Snippet Support
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local on_init = function(client, _)
  if client.config.settings then
    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  end
end

function Lsp.make_config(config)
  local defaults = {
    flags = {
      debounce_text_changes = 80,
      allow_incremental_sync = true,
    },
    handlers = {},
    capabilities = capabilities,
    on_init = on_init,
    on_attach = Lsp.on_attach,
    init_options = {},
    settings = {},
  }
  if config then
    return vim.tbl_deep_extend("force", defaults, config)
  else
    return defaults
  end
end

---@param options table qf {what} table, see :h setqflist-what
---@param open boolean? Open quickfix? (default = true)
---@param jump boolean? Jump to first entry? (default = true)
function Lsp.on_list(options, open, jump)
  -- pprint("on_list", options, open, jump)
  if options.items == nil or #options.items == 0 then
    vim.notify("No items")
    return
  end
  local n_items = #options.items
  local entry = options.items[1]
  open = vim.F.if_nil(open, true) and n_items > 1
  jump = vim.F.if_nil(jump, true)
  jumplist.mark()
  fn.setqflist({}, " ", options)
  -- print(vim.inspect(options))
  if jump then
    -- Here we try to reuse open window containing first item
    -- Find window containing first item
    -- if such window exists, open first item there (could be another tab),
    -- then open qf window and return to prev window position.
    -- If such window doesn't exist, use cfirst to jump
    local win
    while true do
      -- current window contains buffer containing first item?
      if qf.win_has_item(entry, api.nvim_get_current_win()) then
        win = api.nvim_get_current_win()
        break
      end
      -- check all open windows
      for _, open_win in ipairs(api.nvim_list_wins()) do
        if qf.win_has_item(entry, open_win) then
          win = open_win
          break
        end
      end
      break
    end
    if win ~= nil then
      -- found window containing first item
      -- go to window, open qf, refocus window, set cursor position
      fn.win_gotoid(win)
    else
      win = api.nvim_get_current_win()
    end
    if open then
      qf.open(n_items, false, false, false)
    end
    if entry.filename:find("jdt://") ~= nil then
      -- for java
      -- filename is a jdt:// link which gets processed by jdt when opening qf entry
      cmd("cfirst")
    else
      if entry.filename ~= api.nvim_buf_get_name(api.nvim_win_get_buf(win)) then
        cmd("edit " .. entry.filename)
      end
      api.nvim_win_set_cursor(win, { entry.lnum, entry.col - 1 })
      jumplist.mark()
    end
    -- qf.set_jumplist(entry.bufnr, entry.lnum, entry.col - 1)
    -- jumplist.mark()
  elseif open then
    qf.open(n_items, false, false, false)
  end
end
