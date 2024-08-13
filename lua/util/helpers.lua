---@class util.helpers
local M = {}

---Feeds the term_code to vim api.
---
---@param term_code string
---@param mode string
M.perform_term_code = function(term_code, mode)
  local termCodes = vim.api.nvim_replace_termcodes(term_code, true, false, true)
  vim.api.nvim_feedkeys(termCodes, mode, true)
end

M.move_cursor_to_eol = function()
  local win = vim.api.nvim_get_current_win()
  local line = vim.api.nvim_get_current_line()
  local cursor = vim.api.nvim_win_get_cursor(win)

  vim.api.nvim_win_set_cursor(win, { cursor[1], #line })
end

M.new_line_upward = function()
  -- This upward new line doesn't make sense when
  -- it's clear the character before the cursor intends
  -- to open a new scope.
  local charsOpening = { "{", "(", "[", "<", ">" }
  local charsClosing = { "}", ")", "]", ">", "<" }

  local currentWindow = vim.api.nvim_get_current_win()
  local currentLine = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(currentWindow)[2]
  local charPrevious = currentLine:sub(col, col)
  local charAfter = currentLine:sub(col + 1, col + 1)

  local didFindScopeChars = false
  local didNeedUpwardAfter = false

  for i, charOpening in ipairs(charsOpening) do
    local closingChar = charsClosing[i]
    if charOpening == charPrevious and closingChar == charAfter then
      didFindScopeChars = true
      didNeedUpwardAfter = charOpening == ">" and closingChar == "<"
      break
    end
  end

  local command = didFindScopeChars and "<Enter>" or "<Esc>O"

  if didFindScopeChars and didNeedUpwardAfter then
    command = command .. "<Esc>O"
  end

  M.perform_term_code(command, "i")
end

return M
