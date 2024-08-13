local M = {}

function M.filter(arr, fn)
  if type(arr) ~= "table" then
    return arr
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

function M.filterReactDTS(value)
  return string.match(value.filename, "react/index.d.ts") == nil
end

function M.on_list(options)
  local items = options.items
  if #items > 1 then
    items = M.filter(items, M.filterReactDTS)
  end

  -- If there are still more than 1 item, handle this with telescope.
  if #items > 1 then
    require("telescope.builtin").lsp_definitions({ reuse_win = false })
  else
    vim.fn.setqflist({}, " ", { title = options.title, items = items, context = options.context })
    vim.api.nvim_command("cfirst") -- or maybe you want 'copen' instead of 'cfirst'
  end
end

return M
