# Volskaya's Neovim Config 🚀

This config is inspired by VSCode and Emacs, tailored for use with keyboard only, in the terminal, with focus on speed and minimalism.

See my macos dotfiles for a Wezterm & Yabai setup: [volskaya/dotfiles](https://github.com/volskaya/dotfiles).

See [lazy.nvim](http://lazy.folke.io) on which this config is built on.

## Features ✨

- **Window Scoped Buffer Switching** 🪟: Replaces default buffer keymaps with [windovigation.nvim](https://github.com/volskaya/windovigation.nvim) to switch based on file history in the active window split, like VSCode.
- **Oil File Manager** 🛠️: Files are managed using the [oil.nvim](https://github.com/stevearc/oil.nvim) by pressing `Space > e`.
- **Lazygit** 🌀: Git management is done using [lazygit](https://github.com/kdheepak/lazygit.nvim) by pressing `Space > g > g`.
- **Multiplexer Support** 🔀: Switching between splits with `Meta + hjkl` supports switching into Wezterm & Tmux panes.
- **Github Copilot** 🤖: Copilot functionality under `Space > p`.
- **Telescope Pickers** 🔭: Customized telescope pickers under `;`.
- **Multicursors** ✏️: Multicursor mode with `Meta + jk` or `Meta + d`.
- **Bigfile Antilag** 🚀: Automatically disables expensive operations for large files.
- **Sessions** 💾: Session restoration based on the directory nvim was opened.
- **Cmp** 🧩: Customized auto completion with LSP, copilot, native snippets, custom weights and more. Tooltip visual customized similar to VSCode.

## Colorscheme 🎨

Uses the neon themes from [irrelevant](https://github.com/volskaya/irrelevant) and by default, this config has a transparent background, expecting that the terminal is already using its own dark gray background.

## Installation 🛠️

1. **Clone the Repository**:

   ```sh
   git clone https://github.com/volskaya/neovim-config.git ~/.config/nvim
   ```

2. **Install Plugins**:
   Open Neovim and press `Space+l` > `Shift+I` to install plugins.

3. **Restart Neovim**:
   Press `Space > q > q` to quit and restart Neovim to load all plugins and you're good to go.
