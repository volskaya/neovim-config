return {
  {
    "volskaya/irrelevant.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      style = "vaatu",
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    event = "VeryLazy",
    priority = 1000,
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    event = "VeryLazy",
    priority = 1000,
    opts = {
      variant = "main", -- auto, main, moon, or dawn
      dark_variant = "main", -- main, moon, or dawn
      dim_inactive_windows = false,
      extend_background_behind_borders = true,

      enable = {
        terminal = true,
        legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
        migrations = true, -- Handle deprecated options automatically
      },

      styles = {
        bold = false,
        italic = false,
        transparency = true,
      },

      groups = {
        border = "muted",
        link = "iris",
        panel = "surface",

        error = "love",
        hint = "iris",
        info = "foam",
        note = "pine",
        todo = "rose",
        warn = "gold",

        git_add = "foam",
        git_change = "rose",
        git_delete = "love",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        git_untracked = "subtle",

        h1 = "iris",
        h2 = "foam",
        h3 = "rose",
        h4 = "gold",
        h5 = "pine",
        h6 = "foam",
      },
    },
  },
}
