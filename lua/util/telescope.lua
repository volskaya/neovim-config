-- telescope-config.lua
local M = {}

---Attempt to get a better root cwd.
---
---1. Tries to base it off of LSP root dir.
---2. Tries to base it off of git toplevel dir.
---
---@return string?
M.get_better_root = function()
  local lsp_clients = vim.lsp.get_clients()
  local lsp_clients_first = lsp_clients[1]
  local lsp_root = lsp_clients_first and lsp_clients_first.root_dir
  local root = nil ---@type string?

  if lsp_root ~= nil then
    root = lsp_root
  else
    local git_rev_parse = vim.fn.system("git rev-parse --show-toplevel")
    local git_root = string.gsub(git_rev_parse, "\n", "")
    if vim.v.shell_error == 0 then
      root = git_root
    end
  end

  return root
end

return M
