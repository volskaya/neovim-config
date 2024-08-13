return {
  {
    "folke/flash.nvim",
    enabled = true,
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      search = {
        forward = true,
        multi_window = false,
        wrap = false,
        incremental = false,
      },
      modes = {
        search = {
          enabled = false,
        },
        char = {
          jump_labels = false,
        },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },

  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = {
      highlighters = {
        hsl_color = {
          pattern = "hsl%(%d+,? %d+%%?,? %d+%%?%)",
          group = function(_, match)
            ---@diagnostic disable-next-line: no-unknown
            local utils = require("acccento.hsl")
            --- @type string, string, string
            local nh, ns, nl = match:match("hsl%((%d+),? (%d+)%%?,? (%d+)%%?%)")
            --- @type number?, number?, number?
            local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)
            --- @type string
            local hex_color = utils.hslToHex(h, s, l)
            return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
          end,
        },
      },
    },
  },

  {
    "dinhhuy258/git.nvim",
    event = "BufReadPre",
    opts = {
      keymaps = {
        blame = "<Leader>gb", -- Open blame window.
        browse = "<Leader>go", -- Open file/folder in git repository.
      },
    },
  },

  {
    "telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-file-browser.nvim",
      "famiu/bufdelete.nvim",
    },
    keys = {
      { "<leader>/", false },
      { "<leader> ", false },
      { "]b", false },
      { "[b", false },
      {
        "<leader>fP",
        function()
          require("telescope.builtin").find_files({
            cwd = require("lazy.core.config").options.root,
            attach_mappings = require("windovigation.telescope-utils").attach_mappings,
          })
        end,
        desc = "Find Plugin File",
      },
      {
        ";f",
        function()
          require("telescope.builtin").find_files({
            cwd = require("util.telescope").get_better_root(),
            no_ignore = false,
            hidden = true,
            attach_mappings = require("windovigation.telescope-utils").attach_mappings,
            file_ignore_patterns = {
              "node_modules",
              ".git",
              "ios/Pods",
              "macos/Pods",
              "build",
            },
          })
        end,
        desc = "Lists files from other projects.",
      },
      {
        ";/",
        function()
          require("util.telescope_pickers").pretty_grep_picker({
            picker = "live_grep",
            options = {
              search_dirs = { require("util.telescope").get_better_root() },
              disable_coordinates = true,
              only_sort_text = true,
              attach_mappings = require("windovigation.telescope-utils").attach_mappings,
              additional_args = {
                -- "--hidden"
                "--max-columns=180",
                "--max-columns-preview",
                "--trim",
                -- '-g="!**node_modules/**"',
                -- '-g="!**.git/**"',
                -- "--smart-case",
                -- "--regexp",
              },
              file_ignore_patterns = {
                "*lock%.json",
                "**lock%.json",
                "**node_modules/**",
                "**.git/**",
                "**ios/Pods**",
                "**ios/Pods**",
                "**build/**",
              },
            },
          })
        end,
        desc = "Search for a string in your current working directory and get results live as you type, respects .gitignore",
      },
      {
        ";b",
        function()
          require("telescope.builtin").buffers({
            attach_mappings = require("windovigation.telescope-utils").attach_mappings,
          })
        end,
        desc = "Lists open buffers",
      },
      {
        ";t",
        function()
          require("telescope.builtin").help_tags({
            attach_mappings = require("windovigation.telescope-utils").attach_mappings,
          })
        end,
        desc = "Lists available help tags and opens a new window with the relevant help info on <cr>",
      },
      {
        ";;",
        function()
          require("telescope.builtin").resume({
            attach_mappings = require("windovigation.telescope-utils").attach_mappings,
          })
        end,
        desc = "Resume the previous telescope picker",
      },
      {
        ";e",
        function()
          require("telescope.builtin").diagnostics({
            attach_mappings = require("windovigation.telescope-utils").attach_mappings,
          })
        end,
        desc = "Lists Diagnostics for all open buffers or a specific buffer",
      },
      {
        ";s",
        function()
          require("telescope.builtin").treesitter({
            attach_mappings = require("windovigation.telescope-utils").attach_mappings,
          })
        end,
        desc = "Lists Function names, variables, from Treesitter",
      },
      {
        ";r",
        function()
          require("util.telescope_pickers").pretty_files_picker({
            path = vim.fn.expand("%:p:h"),
            cwd = require("util.telescope").get_better_root() or vim.fn.expand("%:p:h"),
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            previewer = false,
            initial_mode = "normal",
            hide_parent_dir = true,
            layout_config = { height = 40, prompt_position = "bottom" },
            layout_strategy = "horizontal",
            border = true,
            attach_mappings = require("windovigation.telescope-utils").attach_mappings,
          })
        end,
        desc = "Open File Browser with the path of the current buffer",
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local fb_actions = telescope.extensions.file_browser.actions ---@diagnostic disable-line: no-unknown

      local actions = require("telescope.actions")
      local action_set = require("telescope.actions.set")

      local edit_old = action_set.edit
      action_set.edit:replace(function(prompt_bufnr, command)
        vim.notify("Replace file edit action")
        return edit_old(prompt_bufnr, command)
      end)

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
        wrap_results = true,
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        border = true,
        borderchars = {
          prompt = require("util.visuals").border_chars_outer_thin_telescope,
          results = require("util.visuals").border_chars_outer_thin_telescope,
          preview = require("util.visuals").border_chars_outer_thin_telescope,
        },
        mappings = {
          n = {},
          i = {
            ["<Esc>"] = "close",
            ["<C-c>"] = false,
          },
        },
      })

      opts.pickers = {
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
          layout_config = {
            preview_cutoff = 9999,
          },
        },
        live_grep = {
          only_sort_text = true,
        },
      }

      opts.extensions = {
        file_browser = {
          theme = "dropdown",
          hijack_netrw = true, -- disables netrw.
          mappings = {
            ["n"] = {
              ["h"] = fb_actions.goto_parent_dir,
              -- ["l"] = actions.select_default,
              ["l"] = require("windovigation.telescope-file-picker-utils").open_dir_or_file_action,
              ["<Enter>"] = require("windovigation.telescope-file-picker-utils").open_dir_or_file_action,
              -- ["l"] = require("windovigation.telescope-file-picker-utils").open_dir_or_file_action,
              ["/"] = function()
                vim.cmd("startinsert")
              end,
              ["<C-u>"] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_previous(prompt_bufnr)
                end
              end,
              ["<C-d>"] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_next(prompt_bufnr)
                end
              end,
              ["<PageUp>"] = actions.preview_scrolling_up,
              ["<PageDown>"] = actions.preview_scrolling_down,
            },
          },
        },
        fzf = {
          fuzzy = true, -- False will only do exact matching.
          override_generic_sorter = true, -- Override the generic sorter.
          override_file_sorter = true, -- Override the file sorter.
          case_mode = "smart_case", -- "ignore_case" | "respect_case" | "smart_case".
        },
        frecency = {
          disable_devicons = true,
        },
      }

      telescope.setup(opts)
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("file_browser")
    end,
  },

  {
    "mg979/vim-visual-multi",
    event = "BufReadPre",
    keys = {
      {
        "<C-S-Down>",
        ":call vm#commands#add_cursor_down(0, v:count1)<cr>",
        desc = "Add Cursor Down",
        mode = { "n" },
        noremap = true,
        silent = true,
      },
      {
        "<C-S-Up>",
        ":call vm#commands#add_cursor_up(0, v:count1)<cr>",
        desc = "Add Cursor Up",
        mode = { "n" },
        noremap = true,
        silent = true,
      },
      {
        "<M-S-j>",
        ":call vm#commands#add_cursor_down(0, v:count1)<cr>",
        desc = "Add Cursor Down",
        mode = { "n" },
        noremap = true,
        silent = true,
      },
      {
        "<M-S-k>",
        ":call vm#commands#add_cursor_up(0, v:count1)<cr>",
        desc = "Add Cursor Down",
        mode = { "n" },
        noremap = true,
        silent = true,
      },
      {
        "<M-d>",
        ":call vm#commands#ctrln(v:count1)<cr>",
        desc = "Multi Edit Next",
        mode = { "n" },
        noremap = true,
        silent = true,
      },
    },
    config = function()
      vim.g.VM_default_mappings = 0
      vim.g.VM_silent_exit = 1
      vim.g.VM_set_statusline = 0
      vim.g.VM_maps = {
        ["Find Under"] = "",
      }

      vim.g.VM_maps["I BS"] = ""
      vim.g.VM_maps["I CtrlC"] = ""
      vim.g.VM_maps["I CtrlN"] = ""
    end,
  },

  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "LazyFile",
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
    opts = {
      keywords = {
        FIX = {
          icon = " ",
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO", "VALIDATE" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      highlight = {
        keyword = "wide",
      },
    },
  },

  {
    "barrett-ruth/import-cost.nvim",
    enabled = false, -- The comments are in the wrong positions after formatting.
    build = "sh install.sh npm",
    config = function()
      require("import-cost").setup({})
    end,
  },

  {
    -- Keybinds for the split navigation in tmux / wezterm multiplexer.
    "mrjones2014/smart-splits.nvim",
  },

  {
    "folke/persistence.nvim",
    enabled = true,
    event = "BufReadPre",
    opts = {
      pre_save = function()
        require("windovigation.actions").persist_state()
      end,
    },
  },

  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      default_file_explorer = true,
      columns = {
        -- "icon",
        -- "permissions",
        -- "size",
        "mtime",
      },
      buf_options = { buflisted = true, bufhidden = "hide" },
      skip_confirm_for_simple_edits = true,
      prompt_save_on_select_new_entry = false,
      cleanup_delay_ms = 0,
      view_options = {
        show_hidden = true,
      },
      float = {
        -- Padding around the floating window.
        padding = 4,
        max_width = 90,
        max_height = 0,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["q"] = "actions.close",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
    },
  },

  {
    "nvim-pack/nvim-spectre",
  },

  {
    "volskaya/windovigation.nvim",
    lazy = false,
    opts = {
      no_close_buftype = {},
    },
  },
}
