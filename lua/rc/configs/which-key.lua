if pcall(require, "langmapper") then
  local lmu = require("langmapper.utils")
  local view = require("which-key.view")
  local execute = view.execute

  -- wrap `execute()` and translate sequence back
  view.execute = function(prefix_i, mode, buf)
    -- Translate back to English characters
    prefix_i = lmu.translate_keycode(prefix_i, "default", "ru")
    execute(prefix_i, mode, buf)
  end
end

-- local presets = require('which-key.plugins.presets')
-- presets.operators = lmu.trans_dict(presets.operators)
-- presets.objects = lmu.trans_dict(presets.objects)
-- presets.motions = lmu.trans_dict(presets.motions)

require("which-key").setup({
  plugins = {
    -- registers = false,
  },
  show_help = false,
  show_keys = false,
})
