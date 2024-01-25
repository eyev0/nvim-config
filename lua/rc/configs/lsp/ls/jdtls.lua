local setup = require("jdtls.setup")
local jdtls = require("jdtls")
local dap = require("dap")
local root_markers = { "build.gradle", "gradle.build", "pom.xml" }
local root_dir = setup.find_root(root_markers)
local home = vim.env.HOME
local workspace_folder = home .. "/.local/share/eclipse.jdt.ls/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

vim.cmd([[command! JdtClearWorkspaceFolder !rm -rf ]] .. workspace_folder)
vim.cmd(
  [[command! JdtClearWorkspaceLocalFiles !rm -rf .settings .project .classpath .gradle gradlew gradlew.bat bin/]]
)

jdtls.jol_path = home .. "/dev/nvim/java/jol/jol-cli-latest.jar"

local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local initialized = false

local config = {
  -- filetypes = { "java" },
  flags = {
    allow_incremental_sync = true,
  },
  handlers = {
    ["language/status"] = function() end,
  },
  on_attach = function(client, bufnr)
    jdtls.setup_dap({ hotcodereplace = "auto" })
    -- u.tprint(require("dap").adapters)
    if not initialized then
      local java_adapter = dap.adapters.java
      dap.adapters.java = function(callback, config)
        if config.preLaunchTask ~= nil then
          vim.cmd("!" .. config.preLaunchTask)
        end
        return java_adapter(callback, config)
      end
      initialized = true
    end
    setup.add_commands()
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    Lsp.on_attach(client, bufnr)
    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.buffer = bufnr
      return vim.keymap.set(mode, lhs, rhs, opts)
    end
    -- map("n", "gd", function()
    --   vim.lsp.buf.definition({ reuse_win = true })
    -- end, { noremap = true, silent = true, desc = "Goto Definition" })
    -- map("n", "gr", function()
    --   vim.lsp.buf.references({ includeDeclaration = false })
    -- end, { noremap = true, silent = true, desc = "List References" })
    map(
      "n",
      "<leader>lao",
      "<Cmd>lua require('jdtls').organize_imports()<CR>",
      { noremap = true, silent = true, desc = "Organize imports" }
    )
    map("n", "<leader>laev", function()
      require("jdtls").extract_variable()
    end, { noremap = true, silent = true, desc = "jdtls: extract_variable" })
    map("v", "<leader>laec", function()
      vim.api.nvim_input("<Esc>")
      require("jdtls").extract_constant(true)
    end, { noremap = true, silent = true, desc = "jdtls: extract_constant" })
    map(
      "v",
      "<leader>laem",
      "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
      { noremap = true, silent = true, desc = "jdtls: extract_method" }
    )
    map(
      "n",
      "<leader>ljb",
      "<Cmd>lua require('jdtls').compile('full')<CR>",
      { noremap = true, silent = true }
    )
    map(
      "n",
      "<leader>ljuc",
      "<Cmd>lua require('jdtls').update_project_config()<CR>",
      { noremap = true, silent = true, desc = "jdtls: update_project_config" }
    )
    map("n", "<leader>ljcw", function()
      vim.cmd("JdtClearWorkspaceFolder")
      vim.cmd("JdtClearWorkspaceLocalFiles")
      vim.cmd("JdtRestart")
    end, { noremap = true, silent = true, desc = "Clear workspace and build files" })
    map("n", "<leader>ljr", "<Cmd>JdtRestart<CR>", { noremap = true, silent = true, desc = "Restart jdtls" })
  end,
  init_options = {
    extendedClientCapabilities = extendedClientCapabilities,
  },
  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      completion = {
        favoriteStaticMembers = {
          -- "org.hamcrest.MatcherAssert.assertThat",
          -- "org.hamcrest.Matchers.*",
          -- "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
      },
      project = {
        referencedLibraries = {
          -- "/home/yev/dev/sbl/core/java/build/libs/java-5.0.70a5b053-sources.jar",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
    },
  },
}

local jdtls_version = 1.31
local jdtls_home = home .. ("/.local/lsp/jdtls-prebuilt/%s"):format(jdtls_version)
local lombok_jar = home .. "/.local/jar/lombok-1.18.30.jar"
local java_version = "17.0.10"
local java_provider = "oracle"
local java_executable = home .. ("/.sdkman/candidates/java/%s-%s/bin/java"):format(java_version, java_provider)

vim.env.GRADLE_HOME = home .. "/.sdkman/candidates/gradle/current"

config.cmd = {
  -- 'GRADLE_HOME="$HOME/.sdkman/candidates/gradle/current"',
  java_executable,
  "-javaagent:" .. lombok_jar,
  "-Xbootclasspath/a:" .. lombok_jar,
  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.protocol=true",
  "-Dlog.level=ALL",
  "-Xmx4G",
  "--add-modules=ALL-SYSTEM",
  "--add-opens",
  "java.base/java.util=ALL-UNNAMED",
  "--add-opens",
  "java.base/java.lang=ALL-UNNAMED",
  "-jar",
  vim.fn.glob(jdtls_home .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
  "-configuration",
  jdtls_home .. "/config_linux",
  "-data",
  workspace_folder,
}

local jar_patterns = {
  "/dev/nvim/java/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
  "/dev/nvim/java/vscode-java-decompiler/server/*.jar",
  "/dev/nvim/java/vscode-java-test/java-extension/com.microsoft.java.test.plugin/target/*.jar",
  "/dev/nvim/java/vscode-java-test/java-extension/com.microsoft.java.test.runner/target/*.jar",
  "/dev/nvim/java/vscode-java-test/java-extension/com.microsoft.java.test.runner/lib/*.jar",
  -- '/dev/nvim/java/testforstephen/vscode-pde/server/*.jar'
}
-- npm install broke for me: https://github.com/npm/cli/issues/2508
-- So gather the required jars manually; this is based on the gulpfile.js in the vscode-java-test repo
local plugin_path =
  "/dev/nvim/java/vscode-java-test/java-extension/com.microsoft.java.test.plugin.site/target/repository/plugins/"
local bundle_list = vim.tbl_map(function(x)
  return require("jdtls.path").join(plugin_path, x)
end, {
  "org.eclipse.jdt.junit4.runtime_*.jar",
  "org.eclipse.jdt.junit5.runtime_*.jar",
  "org.junit.jupiter.api*.jar",
  "org.junit.jupiter.engine*.jar",
  "org.junit.jupiter.migrationsupport*.jar",
  "org.junit.jupiter.params*.jar",
  "org.junit.vintage.engine*.jar",
  "org.opentest4j*.jar",
  "org.junit.platform.commons*.jar",
  "org.junit.platform.engine*.jar",
  "org.junit.platform.launcher*.jar",
  "org.junit.platform.runner*.jar",
  "org.junit.platform.suite.api*.jar",
  "org.apiguardian*.jar",
})
vim.list_extend(jar_patterns, bundle_list)
local bundles = {}
for _, jar_pattern in ipairs(jar_patterns) do
  local expanded_jar_pattern = vim.fn.glob(home .. jar_pattern)
  if expanded_jar_pattern:len() > 0 then
    for _, bundle in ipairs(vim.split(expanded_jar_pattern, "\n")) do
      table.insert(bundles, bundle)
      -- if
      --   not vim.endswith(bundle, "com.microsoft.java.test.runner-jar-with-dependencies.jar")
      --   and not vim.endswith(bundle, "com.microsoft.java.test.runner.jar")
      -- then
      --   table.insert(bundles, bundle)
      -- end
    end
  end
end

-- java debug tests
config.init_options = {
  bundles = bundles,
}

vim.cmd([[command! JdtStartOrAttach lua require("rc.configs.lsp.ls.jdtls").setup()]])

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("JdtInit", {}),
  callback = function(opts)
    if opts.match == "java" then
      vim.cmd("JdtStartOrAttach")
    end
  end,
})

return {
  setup = function()
    require("jdtls").start_or_attach(Lsp.make_config(config))
  end,
}
