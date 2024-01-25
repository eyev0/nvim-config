local rt = require("rust-tools")
local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.9.2"
local codelldb_path = extension_path .. "/adapter/codelldb"
local liblldb_path = extension_path .. "/lldb/lib/liblldb"
local this_os = vim.loop.os_uname().sysname
-- The liblldb extension is .so for linux and .dylib for macOS
liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
rt.setup({
  dap = {
    adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
  },
  server = {
    standalone = false,
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          buildScripts = {
            enable = true,
          },
        },
        procMacro = {
          enable = true,
        },
        checkOnSave = {
          allFeatures = true,
          overrideCommand = {
            "cargo",
            "clippy",
            "--workspace",
            "--message-format=json",
            "--all-targets",
            "--all-features",
          },
        },
      },
    },
    on_attach = function(_, bufnr)
      -- Hover actions
      -- vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      -- vim.keymap.set("n", "<leader>lac", rt.code_action_group.code_action_group, { buffer = bufnr })
      vim.keymap.set(
        "n",
        "<leader>lro",
        ":!cargo fix --offline --allow-dirty --broken-code --quiet<CR>",
        { buffer = bufnr, desc = "cargo fix" }
      )
      vim.keymap.set("n", "<leader>lrb", function()
        vim.cmd("wa")
        require("noice").redirect("!cargo build", { { filter = { event = "msg_show" }, view = "split" } })
      end, { buffer = bufnr, desc = "cargo build" })
      vim.keymap.set("n", "<leader>lrf", function()
        vim.cmd("wa")
        require("noice").redirect(
          "!cargo fmt -- ./**/*.rs",
          { { filter = { event = "msg_show" }, view = "split" } }
        )
      end, { buffer = bufnr, desc = "cargo fmt" })
    end,
  },
  tools = {
    inlay_hints = {
      auto = false,
    },
  },
})
