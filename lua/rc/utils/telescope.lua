local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")

local dirs = {
  {
    name = "work",
    path = "$HOME/dev/sbl/",
    mode = "tmux",
    prompt = true,
  },
  {
    name = "plugins",
    path = vim.fn.fnamemodify(O.lazypath, ":h") .. "/",
    mode = "tmux",
    prompt = true,
  },
  {
    name = "dev-plugins",
    path = O.devpath .. "/",
    mode = "tmux",
    prompt = true,
  },
  {
    name = "neovim",
    path = "$HOME/.config/nvim/",
    mode = "tmux",
    prompt = false,
  },
  {
    name = "relative",
    path = vim.fn.getcwd(-1, -1),
    mode = "tab",
    prompt = true,
  },
}

local function make_keys_tbl(t)
  local ret = {}
  for i, v in ipairs(t) do
    table.insert(ret, i, v.name)
  end
  return ret
end

local dirs_lookup = vim.tbl_add_reverse_lookup(make_keys_tbl(dirs))

local function open_dir(dir, mode)
  if dir == nil then
    return
  end
  -- trim trailing slash and expand
  dir = vim.fn.expand(string.gsub(dir, "/$", ""))
  if vim.loop.fs_realpath(dir) then
    if mode == "tmux" then
      local name = vim.fn.fnamemodify(dir, ":t")
      if #name == 0 then
        name = "new_window"
      end
      vim.cmd("!tmux new-window -n " .. name .. " -c " .. dir .. " ';' set -w remain-on-exit off")
    elseif mode == "tab" then
      vim.cmd("$tabnew +tcd\\ " .. dir)
    end
  else
    vim.notify("Invalid directory: " .. dir)
  end
end

local _actions = {}

---@param prompt_bufnr number
---@param mode? "tmux" | "tab" | "default"
---@param prompt_modify_dir? boolean
function _actions.open_dir(prompt_bufnr, mode, prompt_modify_dir)
  actions.close(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  if selection == nil then
    vim.notify("No dir selected")
    return false
  end
  -- vim.notify(vim.inspect(dirs_lookup))
  -- vim.notify(selection[1])
  local dir = dirs[dirs_lookup[selection[1]]].path
  prompt_modify_dir = prompt_modify_dir ~= nil and prompt_modify_dir or dirs[dirs_lookup[selection[1]]].prompt
  mode = mode ~= nil and mode or "default"
  if mode == "default" then
    mode = dirs[dirs_lookup[selection[1]]].mode
  end
  if prompt_modify_dir then
    vim.ui.input({
      prompt = "Enter directory to open: ",
      default = vim.fn.expand(dir),
      completion = "file",
    }, function(input)
      open_dir(input, mode)
      vim.cmd("stopinsert")
    end)
  else
    open_dir(dir, mode)
  end
end

return {
  pickers = {
    dirs = function()
      local opts = {
        layout_strategy = "horizontal",
        no_ignore = true,
        hidden = true,
        layout_config = {
          mirror = false,
          prompt_position = "top",
          scroll_speed = 5,
          height = 0.4,
          width = 0.3,
          preview_width = 0.47,
        },
      }
      pickers
        .new(opts, {
          prompt_title = "Open dir",
          finder = finders.new_table({
            results = dirs_lookup,
          }),
          sorter = conf.generic_sorter(opts),
          attach_mappings = function(_, map)
            -- open in new tab
            map("i", "<C-t>", function(prompt_bufnr)
              _actions.open_dir(prompt_bufnr, "tab", false)
            end)
            -- open in tmux window
            map("i", "<C-m>", function(prompt_bufnr)
              _actions.open_dir(prompt_bufnr, "tmux", false)
            end)
            -- open in new tab
            map("i", "<C-S-t>", function(prompt_bufnr)
              _actions.open_dir(prompt_bufnr, "tab", true)
            end)
            -- open in tmux window
            map("i", "<C-S-m>", function(prompt_bufnr)
              _actions.open_dir(prompt_bufnr, "tmux", true)
            end)
            map("i", "<CR>", function(prompt_bufnr)
              _actions.open_dir(prompt_bufnr)
            end)
            return true
          end,
        })
        :find()
    end,
  },
}
