local buftype = {
  help = nil,
  quickfix = "buftype",
}

local filetype = {
  -- NvimTree = "filetype",
  httpResult = "filetype",
  fugitive = "filetype",
  DiffviewFiles = "filetype",
  aerial = "filetype",
}

require("stickybuf").setup({
  get_auto_pin = function(bufnr)
    local pin_type = buftype[vim.bo[bufnr].buftype] or filetype[vim.bo[bufnr].filetype]
    if pin_type ~= nil then
      return pin_type
    end
  end,
})
