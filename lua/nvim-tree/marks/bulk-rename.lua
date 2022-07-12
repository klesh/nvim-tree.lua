local Marks = require "nvim-tree.marks"
local Core = require "nvim-tree.core"
local utils = require "nvim-tree.utils"
local FsRename = require "nvim-tree.actions.fs.rename-file"

local M = {}

function M.bulk_rename()
  vim.ui.input({ prompt = "Location: ", default = Core.get_cwd(), completion = "dir" }, function(location)
    if not location or location == "" then
      return
    end
    if vim.fn.filewritable(location) ~= 2 then
      utils.warn(location .. " is not writable, cannot perform bulk action.")
      return
    end

    local marks = Marks.get_marks()
    for _, node in pairs(marks) do
      local head = vim.fn.fnamemodify(node.absolute_path, ":t")
      local to = utils.path_join { location, head }
      FsRename.rename(node, to)
    end

    if M.enable_reload then
      require("nvim-tree.actions.reloaders.reloaders").reload_explorer()
    end
  end)
end

function M.setup(opts)
  M.enable_reload = not opts.filesystem_watchers.enable
end

return M
