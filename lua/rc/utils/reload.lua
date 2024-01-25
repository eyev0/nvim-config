local M = {}

function M.reload(name, children)
  children = children or false
  package.loaded[name] = nil
  if children then
    for pkg_name, _ in pairs(package.loaded) do
      if vim.startswith(pkg_name, name) then
        package.loaded[pkg_name] = nil
      end
    end
  end
  return require(name)
end

M.modules = setmetatable({}, {
  __index = function(_, k)
    return M.reload(k)
  end,
})

function M.activate_reload(name, children)
  name = name or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r")
  children = children or false
  vim.cmd("augroup lua-debug")
  vim.cmd("au!")
  vim.cmd(string.format("autocmd BufWritePost <buffer> lua U.reload('%s', %s)", name, children))
  vim.cmd("augroup end")
end

return M
