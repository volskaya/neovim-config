local M = {}

---@param action string
---@param buf integer
---@param win integer
M.perform_code_action_sync = function(action, buf, win)
  local encoding = vim.lsp.util._get_offset_encoding(buf)
  local params = vim.lsp.util.make_range_params(win, encoding)
  params.context = { only = { action }, diagnostics = {} }

  local result = vim.lsp.buf_request_sync(buf, "textDocument/codeAction", params, 3000)

  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, encoding)
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

---@param actions string[]
---@param buf integer?
---@param win integer?
M.perform_code_actions_sync = function(actions, buf, win)
  local effective_buf = buf or vim.api.nvim_get_current_buf()
  local effective_win = win or vim.api.nvim_get_current_win()

  for _, action in ipairs(actions) do
    M.perform_code_action_sync(action, effective_buf, effective_win)
  end
end

---Renames the file with LSP action.
M.lsp_rename_file = function()
  local source_file = vim.api.nvim_buf_get_name(0)
  if string.len(source_file) <= 0 then
    return
  end

  vim.ui.input({
    prompt = "Rename File",
    completion = "file",
    default = source_file,
  }, function(input)
    if input == nil then
      return
    end

    local params = {
      command = "_typescript.applyRenameFile",
      arguments = {
        {
          sourceUri = source_file,
          targetUri = input,
        },
      },
      title = "",
    }

    vim.lsp.util.rename(source_file, input)
    vim.lsp.buf.execute_command(params)
  end)
end

return M
