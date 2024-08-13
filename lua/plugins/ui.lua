return {
  -- messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })

      -- I don't know why, but saw another dude extenin
      local oldRoutes = opts.routes

      opts.routes = {
        {
          -- Filters out the lsp analyzing notification.
          --
          -- Seems to be spammed on every key press in lua and dart.
          -- But would be better to still show the initial notification.
          filter = { event = "lsp", kind = "progress" },
        },
        {
          filter = { event = "notify", find = "No information available" },
          opts = { skip = true },
        },
        {
          filter = { event = "notify", find = "[VM]" }, -- FIXME: Doesn't work.
          opts = { skip = true },
        },
        {
          filter = { event = "msg_show", find = "%dL" },
          opts = { skip = true },
        },
        {
          filter = {
            cond = function()
              return not focused
            end,
          },
          view = "notify_send",
          opts = { stop = false },
        },
      }

      -- table.insert(opts.routes, {
      --   filter = { event = "notify", find = "No information available" },
      --   opts = { skip = true },
      -- })
      --
      -- -- Filter out virtual motion notification.
      -- -- FIXME: Doesn't work.
      -- table.insert(opts.routes, {
      --   filter = { event = "notify", find = "[VM]" },
      --   opts = { skip = true },
      -- })
      --
      -- -- Filter out file written messages.
      -- table.insert(opts.routes, {
      --   filter = { event = "msg_show", find = "%dL" },
      --   opts = { skip = true },
      -- })
      --
      -- table.insert(opts.routes, 1, {
      --   filter = {
      --     cond = function()
      --       return not focused
      --     end,
      --   },
      --   view = "notify_send",
      --   opts = { stop = false },
      -- })

      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }

      opts.views = {
        notify = {
          position = {
            row = 2,
          },
        },
        mini = {
          backend = "mini",
          relative = "editor",
          align = "message-right",
          timeout = 2000,
          reverse = true,
          focusable = false,
          position = {
            row = -2,
            col = "100%",
          },
          size = "auto",
          border = {
            style = "rounded",
          },
          zindex = 60,
          win_options = {
            winbar = "",
            foldenable = false,
            winblend = 0, -- 30 default
            winhighlight = {
              -- Normal = "NoiceMini",
              IncSearch = "",
              CurSearch = "",
              Search = "",
              Normal = "NormalFloat",
              FloatBorder = "FloatBorder",
            },
          },
        },
      }

      opts.win_options = {
        winhighlight = {
          Normal = "NormalFloat",
          FloatBorder = "FloatBorder",
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            pcall(function()
              require("noice.text.markdown").keys(event.buf)
            end)
          end)
        end,
      })

      opts.presets.lsp_doc_border = true
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
      { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git Explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer Explorer",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.uv.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      hide_root_node = true,
      -- auto_clean_after_session_restore = true,
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = {
        mappings = {
          ["<space>"] = "none",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy Path to Clipboard",
          },
          ["O"] = {
            function(state)
              require("lazy.util").open(state.tree:get_node().path, { system = true })
            end,
            desc = "Open with System Application",
          },
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
          with_markers = true,
          indent_marker = "¦",
          last_indent_marker = "¦",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "󰜌",
          -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
          -- then these will never be used.
          default = "*",
          highlight = "NeoTreeFileIcon",
        },
        modified = {
          -- symbol = "[+]",
          symbol = "", -- Disabled because it pushes git symbols.
          highlight = "NeoTreeModified",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = false,
          highlight = "NeoTreeFileName",
        },
        git_status = {
          highlight = "NeoTreeGitStatus",
          symbols = {
            -- Change type
            added = "✚", -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
            deleted = "✖", -- this can only be used in the git_status source
            renamed = "󰁕", -- this can only be used in the git_status source
            -- Status type
            untracked = "", -- or ""
            ignored = "",
            unstaged = "", -- or "󰄱"
            staged = "",
            conflict = "",
          },
        },
      },
    },
    config = function(_, opts)
      local function on_move(data)
        LazyVim.lsp.on_rename(data.source, data.destination)
      end

      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },

  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   opts = {},
  -- },

  {

    "nvim-tree/nvim-web-devicons",
    opts = {
      default = false,
      color_icons = false,
    },
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 5000,
      render = "minimal",
    },
  },

  -- animations
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.scroll = {
        enable = false,
      }
    end,
  },

  -- buffer line
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    keys = {
      -- { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      -- { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
      { "[b", false },
      { "]b", false },
    },
    opts = {
      options = {
        mode = "tabs",
        style_preset = require("bufferline").style_preset.no_italic,
        themable = true,
        indicator = {
          style = "none",
        },
        name_formatter = function(buf)
          return buf.name
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "",
            text_align = "left",
            separator = true,
          },
        },
        color_icons = false,
        show_buffer_icons = false,
        show_close_icons = false,
        show_duplicate_prefix = false,
        show_tab_indicators = false,
        separator_style = { "", "" },
        diagnostics = false,

        -- separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
    setup = function(_, opts)
      require("bufferline").setup(opts)
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        globalstatus = true,
        theme = "irrelevant",
        component_separators = "",
        section_separators = { left = "", right = "" },
        -- section_separators = { left = "", right = "" },
        -- section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_b = {
          {
            "branch",
            fmt = function(branch)
              -- Show visual_multi info, when the multi cursor mode is toggled.
              if vim.b["visual_multi"] then
                local ret = vim.api.nvim_exec2("call b:VM_Selection.Funcs.infoline()", { output = true })
                return string.match(ret.output, "M.*")
              end

              return branch
            end,
          },
        },
      },
      tabline = {},
      extensions = {},
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 1000
    end,
    opts = {},
  },

  -- Filename in the corner of the buffer.
  {
    "b0o/incline.nvim",
    dependencies = {
      "volskaya/irrelevant.nvim", -- For the custom accent color.
    },
    event = "BufReadPre",
    priority = 1200,
    opts = function()
      local Path = require("plenary.path")

      return {
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = { cursorline = false },
        render = function(props)
          local buf_name = vim.api.nvim_buf_get_name(props.buf)
          local file_name = buf_name

          -- Show relative path for oil buffers.
          if vim.startswith(buf_name, "oil://") then
            local path = string.sub(buf_name, 7)
            local root = require("util.telescope").get_better_root()

            local parent = Path:new(root):parent().filename ---@type string
            local path_relative = Path:new(path):make_relative(parent) ---@type string

            file_name = path_relative:len() > 1 and path_relative or path
          else
            file_name = vim.fn.fnamemodify(buf_name, ":t")
          end

          if vim.bo[props.buf].modified then
            file_name = " " .. file_name
          end

          return { file_name }
        end,
      }
    end,
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      plugins = {
        gitsigns = true,
        tmux = true,
        kitty = { enabled = false, font = "+2" },
      },
    },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },

  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function(_, opts)
      local logo = [[
MMMMMMWWXOOxc;.                      ...... ...................kMMMMMMMMMMMMMMMM
MMMMMMWNxdl.                     ........... .    .............:WMMMMMMMMWMMMMMM
MMMMMMMMMWl    .;.                  ........  .   .. ...... ....0MMMMMMMW0MMMMMM
MMMMMMMMWMMN0d:.   .c,.'.....       .             .. .......,,,';kOONMMMMMMMMMMM
MMMMMMMXxXMMMMMWO. 'OXd. 'xKWNXKOkl',       .'.   ..       .......cOXMMMMMMMMMMM
MMMMMMMMMMMMMMMM0.  kN0.  .x0WMMMMMNl    .:....               ...,;xXWWMMMMMMMMM
MMMMMMMMMMMMMMXk0.  odx;   ;'KMMMWd:O.  ..xcxXkl...             .':dNWMMMMMMMMMM
MMMMMMMMMMMMMMWWc   'NKo   ,XMMWX0WWN:   .OMMMNd;;'.. .             'KMMMMMMMMMM
MMWMMMMMMMMMMMWd     dNox,'lWMMMWWMMKkl..ck;NMMMN.  ......        .  .0MMMMWMMWM
WMMMMMMMMMMMMMl     .':ONNNkNMMNxNMWxoXWWMXOKMMXx.  . .......  .;:::ccoKNddoooox
WWWWMMWOO00OOd',,;;,'  .;.:NMMWc;'dMMMMW0o'.'o,.;;;. ......     ........:XMMMMMM
WWWWWMWOkkkx, .......      kXo0NMMMMMMKXMo    .........    .   ..;clol'..'0WMMWW
WWWxoNWWMMMk               .l.ONkMWoNM:,:.  ...   ';:;. .    ..............x00KW
WWWWWWWNNNXxl...    ..        .l'00.,'       ..             .. .......   ..KWWWW
WWWWWWWWNXXK0Ox'   .c:                                              .. .lKNWWWWx
WWWWWWWWWWWWWWN0Oxxo.              .                                .,oxk0NNWWWW
WWWWWWWWWWOONWWNXXXOl                .                    ..',:::... .....:x0KXN
WWWWWWWWWXOolll:...      ;.              .                ..,'.''.. ........'':l
WWWWWWN0:cxNWWX.                                               .....  .cNWWWWWWW
      ]]

      logo = string.rep("\n", 8) .. logo .. "\n"
      opts.config.header = vim.split(logo, "\n")
      opts.config.center = {
        {
          action = "ene | startinsert",
          desc = " New file",
          icon = " ",
          key = "n",
        },
        {
          action = 'lua require("persistence").load()',
          desc = " Restore Session",
          icon = " ",
          key = "l",
        },
        {
          action = "qa",
          desc = " Quit",
          icon = " ",
          key = "q",
        },
      }
    end,
  },

  {
    "echasnovski/mini.animate",
    enabled = false,
    event = "VeryLazy",
    opts = function()
      -- Don't use animate when scrolling with the mouse.
      local mouse_scrolled = false
      for _, scroll in ipairs({ "Up", "Down" }) do
        local key = "<ScrollWheel" .. scroll .. ">"
        vim.keymap.set({ "", "i" }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end

      local animate = require("mini.animate")
      return {
        resize = {
          timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
        },
        scroll = {
          timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
          subscroll = animate.gen_subscroll.equal({
            predicate = function(total_scroll)
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return total_scroll > 1
            end,
          }),
        },
      }
    end,
  },

  -- Active indent guide and indent text objects. When you're browsing
  -- code, this highlights the current level of indentation, and animates
  -- the highlighting.
  {
    "echasnovski/mini.indentscope",
    enabled = false, -- Kinda don't like it, so disabled.
    version = false, -- Wait till new 0.7.0 release to put it back on semver.
    event = "LazyFile",
    opts = {
      symbol = "¦", -- "│", "▏"
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = {
      signs = {
        -- add = { text = "▎" },
        -- change = { text = "▎" },
        -- delete = { text = "" },
        -- topdelete = { text = "" },
        -- changedelete = { text = "▎" },
        -- untracked = { text = "▎" },

        -- add = { text = "+" },
        -- change = { text = "~" },
        -- delete = { text = "-" },
        -- topdelete = { text = "-" },
        -- changedelete = { text = "-" },
        -- untracked = { text = "·" },

        add = { text = "¦" },
        change = { text = "~" },
        delete = { text = "-" },
        topdelete = { text = "-" },
        changedelete = { text = "-" },
        untracked = { text = "·" },
      },
      signs_staged = {
        add = { text = "¦" },
        change = { text = "~" },
        delete = { text = "-" },
        topdelete = { text = "-" },
        changedelete = { text = "-" },
        untracked = { text = "·" },
      },
      signs_staged_enable = false,
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  -- Indent guides for Neovim.
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = true,
    event = "LazyFile",
    opts = {
      indent = {
        -- char = "|",
        -- tab_char = "|",
        char = "¦",
        tab_char = "¦",
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },
      whitespace = { highlight = { "Whitespace" } },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
    main = "ibl",
  },

  {
    "shellRaining/hlchunk.nvim",
    enabled = false, -- Disabled since it was not redrawing in a lot of cases, but it looks good.
    event = { "UIEnter" },
    config = function()
      local colors = require("irrelevant.colors").setup()
      local ft = require("hlchunk.utils.filetype")

      require("hlchunk").setup({
        indent = {
          chars = { "¦", "¦", "¦", "¦" }, -- More code can be found in https://unicodeplus.com.

          style = {
            colors.divider,
          },
        },
        chunk = {
          enable = true,
          notify = true,
          use_treesitter = true,
          -- details about support_filetypes and exclude_filetypes in https://github.com/shellRaining/hlchunk.nvim/blob/main/lua/hlchunk/utils/filetype.lua
          support_filetypes = ft.support_filetypes,
          exclude_filetypes = ft.exclude_filetypes,
          chars = {
            -- horizontal_line = "─",
            -- vertical_line = "│",
            -- left_top = "╭",
            -- left_bottom = "╰",
            -- right_arrow = "─",

            horizontal_line = "-",
            vertical_line = "¦",
            left_top = "+",
            left_bottom = "+",
            right_arrow = "-",
          },
          style = {
            { fg = colors.irrelevant },
            { fg = colors.danger }, -- this fg is used to highlight wrong chunk
          },
          textobject = "",
          max_file_size = 1024 * 1024,
          error_sign = true,
        },
        line_num = {
          enable = false,
          use_treesitter = true,
          style = colors.accent,
        },
        blank = {
          enable = true,
        },
      })
    end,
  },
}
