require("git-worktree").setup({
  change_directory_command = "tcd", -- default: "cd",
})
local Worktree = require("git-worktree")
-- op = Operations.Switch, Operations.Create, Operations.Delete
-- metadata = table of useful values (structure dependent on op)
--      Switch
--          path = path you switched to
--          prev_path = previous worktree path
--      Create
--          path = path where worktree created
--          branch = branch name
--          upstream = upstream remote name
--      Delete
--          path = path where worktree deleted
Worktree.on_tree_change(function(op, metadata)
  if op == Worktree.Operations.Switch then
    print("Switched from " .. metadata.prev_path .. " to " .. metadata.path)
    if O.git_worktree_post_switch_hook ~= nil then
      print(("Running post_hook_cmd: %s"):format(O.git_worktree_post_switch_hook))
      O.git_worktree_post_switch_hook(metadata)
    end
  elseif op == Worktree.Operations.Create then
    print(("Created worktree for branch %s, path %s"):format(metadata.branch, metadata.path))
    if O.git_worktree_post_create_hook ~= nil then
      print(("Running post_hook_cmd: %s"):format(O.git_worktree_post_create_hook))
      O.git_worktree_post_create_hook(metadata)
    end
  end
end)
