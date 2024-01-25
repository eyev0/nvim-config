local util = require("lspconfig.util")

local function get_typescript_server_path(root_dir)
  local project_root = util.find_node_modules_ancestor(root_dir)

  local local_tsserverlib = project_root ~= nil
    and util.path.join(project_root, "node_modules", "typescript", "lib", "tsserverlibrary.js")
  local global_tsserverlib = vim.fn.expand("$NODE_PATH/typescript/lib/tsserverlibrary.js")
  print("local_tsserverlib", local_tsserverlib)
  print("global_tsserverlib", global_tsserverlib)

  if local_tsserverlib and util.path.exists(local_tsserverlib) then
    return local_tsserverlib
  else
    return global_tsserverlib
  end
end

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- u.tprint(capabilities)

require("lspconfig").volar.setup(Lsp.make_config({
  on_attach = require("rc.configs.lsp.tsserver").on_attach_factory(true),
  -- capabilities = capabilities,
  filetypes = { "typescript", "typescriptreact", "vue" },
  config = {
    on_new_config = function(new_config, new_root_dir)
      new_config.init_options.typescript.serverPath = get_typescript_server_path(new_root_dir)
    end,
  },
  root_dir = util.root_pattern(".volar"),
}))
