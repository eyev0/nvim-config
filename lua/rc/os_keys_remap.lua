local f_keys_remap = {
  Darwin = {
    ["<F27>"] = "<C-F3>",
    ["<F39>"] = "<C-S-F3>",
    ["<F13>"] = "<F13>", -- <S-F1>
    ["<F20>"] = "<F20>", -- <S-F8>
    ["<F25>"] = "<F25>", -- <C-F1>
    ["<F26>"] = "<F26>", -- <C-F2>
    ["<F28>"] = "<F28>", -- <C-F4>
    ["<F32>"] = "<F32>", -- <C-F8>
    ["<F36>"] = "<F36>", -- <C-F12>
    ["<F38>"] = "<F38>", -- <C-S-F2>
  },
  Linux = {
    ["<F27>"] = "<F27>",
    ["<F39>"] = "<F39>",
    ["<F13>"] = "<F13>",
    ["<F20>"] = "<F20>",
    ["<F25>"] = "<F25>",
    ["<F26>"] = "<F26>",
    ["<F28>"] = "<F28>",
    ["<F32>"] = "<F32>",
    ["<F36>"] = "<F36>",
    ["<F38>"] = "<F38>",
  },
}

-- TODO:
--- @param f_map string
local function transform_f(f_map)
  local offset = 0
  for m in f_map:gmatch([[<C-S-F.+>]]) do
    local t = { m:match([[\-F(\d+)]]) }
    tprint(t)
    return t
  end
end

local this_os = vim.loop.os_uname().sysname

function F_map(key)
  return f_keys_remap[this_os][key]
end
