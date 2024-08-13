-- stylua: ignore start

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Switch to next or previous file based on windovigation history.
keymap.set("n", "{", function() require("windovigation.actions").move_to_previous_file() end, { desc = "Previous File", remap = true })
keymap.set("n", "}", function() require("windovigation.actions").move_to_next_file() end, { desc = "Previous File", remap = true })

-- Open oil in current cwd.
keymap.set("n", "<leader>e", function() require("oil").open() end, { desc = "Oil", silent = true, noremap = true })

-- Open oil in project root.
keymap.set("n", "<leader>E", function() require("oil").open(require("util.telescope").get_better_root()) end, { desc = "Oil", silent = true, noremap = true })

-- Find and replace current word in the project.
keymap.set("n", "<leader>r", function() require("spectre").open_visual({ select_word = true, cwd = require("util.telescope").get_better_root() }) end, { desc = "Search current word", noremap = true, silent = true })

-- Jump to the end of line while in insert mode.
keymap.set("i", "<C-e>", function()
  local cmp = require("cmp")
  if cmp.visible() then
    cmp.close()
  end

  require("util.helpers").move_cursor_to_eol()
end, { desc = "Jump to EOL" })

-- Delete word backwards.
keymap.set("i", "<C-w>", "<Esc>vbc", { desc = "Delete Word Backwards" })

-- Picker shortcuts.
keymap.set("n", "<leader>/", ";/", { remap = true, desc = "Live Grep" })
keymap.set("n", "<leader><leader>", ";f", { remap = true, desc = "Find Files" })

-- Newline upwards from insert mode.
keymap.set("i", "<S-Enter>", function() require("util.helpers").new_line_upward() end, { noremap = true, desc = "Upward New Line" })

-- Disable vertical line movement with alt.
keymap.set({ "i", "n" }, "<A-j>", "<Nop>", { noremap = true })
keymap.set({ "i", "n" }, "<A-k>", "<Nop>", { noremap = true })

-- Code actions.
keymap.set("n", "<M-.>", "<Leader>ca", { desc = "Code Action", remap = true })
keymap.set("n", "<M-S-.>", "<Leader>cA", { desc = "Code Action", remap = true })
keymap.set("n", "<D-.>", "<Leader>ca", { desc = "Code Action", remap = true })
keymap.set("n", "<D-S-.>", "<Leader>cA", { desc = "Code Action", remap = true })

keymap.set("n", "<M-n>", "<Cmd>:nohlsearch<CR>", { desc = "Unhighlight search", noremap = true })
keymap.set("n", "<C-n>", "<Cmd>:nohlsearch<CR>", { desc = "Unhighlight search", noremap = true })
keymap.set("v", "<M-/>", "gc", { desc = "Comment", remap = true })
keymap.set("n", "<M-/>", "gcc", { desc = "Comment", remap = true })
keymap.set("n", "<C-q>", "<leader>qq", { desc = "Quit", remap = true })

keymap.set("v", "<D-/>", "gc", { desc = "Comment", remap = true })
keymap.set("n", "<D-/>", "gcc", { desc = "Comment", remap = true })

-- Organize imports.
keymap.set("n", "<M-S-o>", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.organizeImports" },
      diagnostics = {},
    },
  })

  vim.cmd.write()
end, { desc = "Organize and remove unused imports", remap = true })

-- Add missing imports.
keymap.set("n", "<M-S-i>", function()
  require("util.lsp_code_actions").perform_code_actions_sync({
    "source.addMissingImports.ts",
    -- "source.organizeImports", -- FIXME: Has started throwing errors.
  })

  -- FIXME: Race condition possible with the perform_code_actions_sync above.
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.organizeImports" },
      diagnostics = {},
    },
  })
  vim.cmd.write()
end, { desc = "Add missing imports", remap = true })

-- Save file.
keymap.set("n", "<Leader>fs", "<Cmd>:w<CR>", { desc = "Save file" })
keymap.set("n", "<M-s>", "<Cmd>:w<CR>", { desc = "Save file" })
keymap.set("n", "<D-s>", "<Cmd>:w<CR>", { desc = "Save file" })

-- Highlight all.
keymap.set("n", "<M-a>", "gg<S-v>G", { remap = true })
keymap.set("n", "<D-a>", "gg<S-v>G", { noremap = true })

-- Disable continuations.
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- New tab.
keymap.set("n", "<M-t>", "<cmd>:tabedit<CR>")
keymap.set("n", "<M-w>", "<C-w>c")

-- Window switching with terminal multiplexer support.
keymap.set("n", "<C-h>", function() require("smart-splits").move_cursor_left() end)
keymap.set("n", "<M-h>", function() require("smart-splits").move_cursor_left() end)
keymap.set("n", "<C-j>", function() require("smart-splits").move_cursor_down() end)
keymap.set("n", "<M-j>", function() require("smart-splits").move_cursor_down() end)
keymap.set("n", "<C-k>", function() require("smart-splits").move_cursor_up() end)
keymap.set("n", "<M-k>", function() require("smart-splits").move_cursor_up() end)
keymap.set("n", "<C-l>", function() require("smart-splits").move_cursor_right() end)
keymap.set("n", "<M-l>", function() require("smart-splits").move_cursor_right() end)

-- Resize window with arrows.
keymap.set("n", "<C-w><left>", "<C-w>>")
keymap.set("n", "<C-w><right>", "<C-w><")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- Toggle inlay hints.
keymap.set("n", "<leader>i", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
end)

-- Terminal.
keymap.set("n", "<leader>t", "<leader>fT", { desc = "Terminal (cwd)" })
keymap.set("n", "<leader>T", "<leader>ft", { desc = "Terminal (Root Dir)" })

-- Copilot ask with input field above code.
keymap.set({ "n", "v" }, "<leader>cp", function()
  vim.ui.input({ prompt = "Copilot" }, function(input)
    if not input then
      return
    end

    require("CopilotChat").ask(input, {
      window = { layout = "vertical", title = "Copilot" },
    })
  end)
end, { desc = "Chat with Copilot" })

-- Copilot reset and ask with input field above code.
keymap.set({ "n", "v" }, "<leader>cP", function()
  vim.ui.input({ prompt = "Copilot" }, function(input)
    if not input then
      return
    end

    local chat = require("CopilotChat")
    chat.reset()
    chat.ask(input, {
      window = { layout = "vertical", title = "Copilot" },
    })
  end)
end, { desc = "Chat with Copilot (Resetted)" })

-- Copilot keys.
keymap.set({ "n", "v" }, "<leader>p", "", { desc = "copilot" })
keymap.set({ "n", "v" }, "<leader>pp", function() require("CopilotChat").toggle({ window = { layout = "vertical", title = "Copilot" }, }) end, { desc = "Copilot Chat" })
keymap.set({ "n", "v" }, "<leader>pe", "<Cmd>:CopilotChatExplain<CR>", { desc = "Explain" })
keymap.set({ "n", "v" }, "<leader>pd", "<Cmd>:CopilotChatDocs<CR>", { desc = "Docs" })
keymap.set({ "n", "v" }, "<leader>pr", "<Cmd>:CopilotChatReview<CR>", { desc = "Review" })
keymap.set({ "n", "v" }, "<leader>pf", "<Cmd>:CopilotChatTests<CR>", { desc = "Tests" })
keymap.set({ "n", "v" }, "<leader>pf", "<Cmd>:CopilotChatFix<CR>", { desc = "Fix" })
keymap.set({ "n", "v" }, "<leader>px", "<Cmd>:CopilotChatFixDiagnostics<CR>", { desc = "Fix diagnostics" })
keymap.set({ "n", "v" }, "<leader>pc", "<Cmd>:CopilotChatCommit<CR>", { desc = "Commit message" })
keymap.set({ "n", "v" }, "<leader>ps", "<Cmd>:CopilotChatCommitStaged<CR>", { desc = "Commit message /w convention" })
keymap.set({ "n", "v" }, "<leader>pm", "<Cmd>:CopilotChatModels<CR>", { desc = "Models" })
keymap.set({ "n", "v" }, "<leader>pP", function () 
  require("CopilotChat").reset()
  vim.notify("Copilot chat reset.")
end, { desc = "Reset" })
