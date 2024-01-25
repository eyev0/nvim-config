local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
-- cmp.event:on("confirm_done", function(...)
-- 	local a = { ... }
-- 	return cmp_autopairs.on_confirm_done({ map_char = { tex = "" } })(...)
-- end)
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
require("nvim-autopairs").setup({
  disable_filetype = { "TelescopePrompt", "vim" },
  check_ts = true,
})
