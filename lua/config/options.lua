vim.g.mapleader = " "
vim.g.trouble_lualine = false
vim.g.lazygit_config = false
vim.g.lazyvim_php_lsp = "intelephense"

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.shell = "fish"
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }
vim.opt.inccommand = "split"
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false -- No Wrap lines
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.path:append({ "**" }) -- Finding files - Search down into subfolders
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.splitkeep = "topline" -- "cursor" | "screen"
vim.opt.mouse = ""
vim.opt.pumblend = 0
vim.opt.sessionoptions = {
  -- Windovigation required options.
  "buffers",
  "help",
  "blank",
  "terminal",
  "winsize",
  "tabpages",
  -- Other options.
  "curdir",
  "globals",
  "folds",
}

vim.opt.listchars:append({
  space = "·",
})

-- Neovide options.
if vim.g.neovide then
  vim.o.guifont = "Maple Mono NF:h22:w-1"
  -- vim.o.guifont = "PragmataPro:h21:b"
  -- vim.o.guifont = "Cartograph CF:h21:w-1"

  vim.g.neovide_remember_window_size = true
  vim.g.neovide_input_macos_alt_is_meta = false
  vim.opt.linespace = -5

  vim.g.neovide_transparency = 0.92
  vim.g.transparency = 0
  -- vim.g.neovide_window_floating_opacity = 1

  vim.g.neovide_window_blurred = true
  vim.g.neovide_window_floating_blur = 0
  vim.g.neovide_window_floating_opacity = 0
  vim.g.neovide_window_floating_transparency = 0
  vim.g.neovide_floating_opacity = 1
  vim.g.neovide_floating_transparency = 1
  vim.g.neovide_floating_blur = 0
  vim.g.neovide_floating_blur_amount_x = 0.0
  vim.g.neovide_floating_blur_amount_y = 0.0

  vim.g.neovide_floating_shadow = false
  vim.g.neovide_show_border = false

  vim.g.neovide_scroll_animation_length = 0.2
  vim.g.neovide_unlink_border_highlights = true

  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_animate_in_insert_mode = true
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_cursor_vfx_particle_speed = 20.0

  vim.g.neovide_padding_top = 16
  vim.g.neovide_padding_bottom = 16
  vim.g.neovide_padding_right = 24
  vim.g.neovide_padding_left = 24
end

-- Undercurl.
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Add asterisks in block comments.
vim.opt.formatoptions:append({ "r" })

vim.cmd([[au BufNewFile,BufRead *.astro setf astro]])
vim.cmd([[au BufNewFile,BufRead Podfile setf ruby]])

if vim.fn.has("nvim-0.8") == 1 then
  vim.opt.cmdheight = 0
end

vim.keymap.set("i", "<A-j>", "<Nop>", { noremap = true })
vim.keymap.set("i", "<A-k>", "<Nop>", { noremap = true })
vim.keymap.set("n", "<A-j>", "<Nop>", { noremap = true })
vim.keymap.set("n", "<A-k>", "<Nop>", { noremap = true })
vim.keymap.set("v", "<A-j>", "<Nop>", { noremap = true })
vim.keymap.set("v", "<A-k>", "<Nop>", { noremap = true })
vim.keymap.set("v", "J", "<Nop>", { noremap = true })
vim.keymap.set("v", "K", "<Nop>", { noremap = true })
