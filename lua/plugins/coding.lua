return {
  -- Create annotations with one keybind, and jump your cursor in the inserted annotation
  {
    "danymat/neogen",
    keys = {
      {
        "<leader>cD",
        function()
          require("neogen").generate({})
        end,
        desc = "Neogen Comment",
      },
    },
    -- opts = { snippet_engine = "luasnip" },
  },

  -- Multi cursors.
  {
    "brenton-leighton/multiple-cursors.nvim",
    enabled = false,
    version = "*",
    opts = {},
    keys = {
      {
        "<A-j>",
        "<Cmd>MultipleCursorsAddDown<CR>",
        mode = { "n", "i" },
        desc = "Add cursor down",
      },
      {
        "<A-k>",
        "<Cmd>MultipleCursorsAddUp<CR>",
        mode = { "n", "i" },
        desc = "Add cursor up",
      },
      {
        "<A-d>",
        "<Cmd>MultipleCursorsAddJumpNextMatch<CR>",
        mode = { "n", "i" },
        desc = "Add cursor match and jump next",
      },
    },
    setup = function(_, opts)
      require("multiple-cursors").setup(opts)
    end,
  },

  -- Incremental rename
  {
    "smjonas/inc-rename.nvim",
    enabled = false,
    cmd = "IncRename",
    config = true,
  },

  -- Refactoring tool
  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>r",
        function()
          require("refactoring").select_refactor({})
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
      },
    },
    opts = {},
  },

  -- Go forward/backward with square brackets
  {
    "echasnovski/mini.bracketed",
    event = "BufReadPost",
    config = function()
      local bracketed = require("mini.bracketed")
      bracketed.setup({
        file = { suffix = "" },
        window = { suffix = "" },
        quickfix = { suffix = "" },
        yank = { suffix = "" },
        treesitter = { suffix = "n" },
        buffer = { suffix = "" },
      })
    end,
  },

  -- Better increase/descrease
  {
    "monaqa/dial.nvim",
    -- stylua: ignore
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
      { "!", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.constant.new({ elements = { "let", "const" } }),
        },
      })
    end,
  },

  {
    "simrat39/symbols-outline.nvim",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    cmd = "SymbolsOutline",
    opts = {
      position = "right",
    },
  },

  -- {
  --   "L3MON4D3/LuaSnip",
  --   lazy = false,
  --   dependencies = {
  --     {
  --       "rafamadriz/friendly-snippets",
  --       config = function()
  --         require("luasnip.loaders.from_vscode").lazy_load({
  --           -- paths = { "~/.config/friendly_snippets" },
  --           paths = { "~/Library/Application Support/Code/User/snippets/dart.json" },
  --         })
  --       end,
  --     },
  --   },
  --   -- opts = {
  --   --   paths = "~/.config/neovim/snippets",
  --   -- },
  --   config = function()
  --     -- require("luasnip.loaders.from_vscode").load({
  --     --   -- paths = { "~/Library/Application Support/Code/User/snippets/dart.json" },
  --     --   -- include = { "dart" },
  --     --   -- paths = { "~/.config/friendly_snippets" },
  --     --   paths = { "~/.config/friendly_snippets/snippets/dart.json" },
  --     -- })
  --
  --     -- vim.notify("Loaded vscode snippets.")
  --   end,
  -- },

  -- {
  --   "garymjr/nvim-snippets",
  --   opts = {
  --     create_cmp_source = true,
  --     search_paths = {
  --       "~/Library/Application Support/Code/User/snippets",
  --     },
  --   },
  --   lazy = false,
  --   setup = function(_, opts)
  --     -- vim.notify("nvim-snippts aaa")
  --     -- require("snippets").setup(opts)
  --     -- vim.notify("nvim-snippts setup complete")
  --   end,
  -- },

  {
    "onsails/lspkind.nvim",
    event = "VeryLazy",
    init = function(opts)
      require("lspkind").init({
        symbol_map = require("util.visuals").kind_icons,
      })
    end,
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event = "BufReadPost",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim.
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper.
    },
    opts = {
      debug = false, -- Enable debugging
      show_help = false,
    },
  },

  {
    "nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      "onsails/lspkind.nvim",
      -- "L3MON4D3/LuaSnip",
      "uga-rosa/utf8.nvim",
      {
        "garymjr/nvim-snippets",
        dependencies = { "rafamadriz/friendly-snippets" },
        opts = {
          create_cmp_source = true,
          friendly_snippets = true,
          search_paths = {
            vim.fn.expand("~/.config/snippets"),
          },
        },
      },
    },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
      table.insert(opts.sources, { name = "copilot", group_index = 2 })
      -- table.insert(opts.sources, { name = "snippets" })
      -- table.insert(opts.sources, { name = "nvim-snippets" })
      -- table.insert(opts.sources, { name = "orgmode" })

      local has_words_before = function()
        local unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      -- local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<Tab>"] = cmp.mapping(function(fallback)
          -- if cmp.visible() then
          --   cmp.confirm()
          -- -- elseif luasnip.expand_or_jumpable() then
          -- --   luasnip.expand_or_jump()
          -- -- elseif has_words_before() then
          -- --   cmp.complete()
          -- else
          --   fallback()
          -- end

          if cmp.visible() then
            cmp.close()
          end

          fallback()
        end, { "i", "s" }),
        ["<C-e>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.close()
          end

          require("util.helpers").move_cursor_to_eol()
        end, { "i", "s" }),
        ["<S-Enter>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.close()
          end
          require("util.helpers").new_line_upward()
        end, { "i", "s" }),
        ["<Enter>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm()
          else
            fallback()
          end
        end, { "i", "s" }),
        -- ["<Enter>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.close()
        --   end
        --   fallback()
        -- end, { "i", "s" }),
        --
        -- ["<Esc>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.close()
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
        ["<Right>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.close()
          end
          fallback()
        end, { "i", "s" }),
        ["<Left>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.close()
          end
          fallback()
        end, { "i", "s" }),
        ["<S-Down>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            if cmp.visible_docs() then
              cmp.scroll_docs(1)
            else
              cmp.open_docs()
            end
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Up>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            if cmp.visible_docs() then
              cmp.scroll_docs(-1)
            else
              cmp.open_docs()
            end
          else
            fallback()
          end
        end, { "i", "s" }),
      })

      -- opts.mapping = vim.tbl_extend("force", opts.mapping, {
      -- opts.mapping = vim.tbl_extend("force", opts.mapping, {
      --   ["<Tab>"] = cmp.mapping(function(fallback)
      --     if cmp.visible() then
      --       cmp.confirm()
      --     -- elseif luasnip.expand_or_jumpable() then
      --     --   luasnip.expand_or_jump()
      --     -- elseif has_words_before() then
      --     --   cmp.complete()
      --     else
      --       fallback()
      --     end
      --   end, { "i", "s" }),
      --   ["<C-e>"] = cmp.mapping(function(fallback)
      --     if cmp.visible() then
      --       cmp.close()
      --     end
      --
      --     vim.notify("Jumping eol.")
      --     require("util.helpers").move_cursor_to_eol()
      --   end, { "i", "s" }),
      --   ["<S-Enter>"] = cmp.mapping(function(fallback)
      --     if cmp.visible() then
      --       cmp.close()
      --     end
      --     require("util.helpers").new_line_upward()
      --   end, { "i", "s" }),
      --   --
      --   -- TODO: This is sometimes ignored, find out why.
      --   -- ["<Enter>"] = cmp.mapping(function(fallback)
      --   --   if cmp.visible() then
      --   --     cmp.close()
      --   --   end
      --   --   fallback()
      --   -- end, { "i", "s" }),
      --   --
      --   -- ["<Esc>"] = cmp.mapping(function(fallback)
      --   --   if cmp.visible() then
      --   --     cmp.close()
      --   --   else
      --   --     fallback()
      --   --   end
      --   -- end, { "i", "s" }),
      --   ["<Right>"] = cmp.mapping(function(fallback)
      --     if cmp.visible() then
      --       cmp.close()
      --     end
      --     fallback()
      --   end, { "i", "s" }),
      --   ["<Left>"] = cmp.mapping(function(fallback)
      --     if cmp.visible() then
      --       cmp.close()
      --     end
      --     fallback()
      --   end, { "i", "s" }),
      --   ["<S-Down>"] = cmp.mapping(function(fallback)
      --     if cmp.visible() then
      --       if cmp.visible_docs() then
      --         cmp.scroll_docs(1)
      --       else
      --         cmp.open_docs()
      --       end
      --     else
      --       fallback()
      --     end
      --   end, { "i", "s" }),
      --   ["<S-Up>"] = cmp.mapping(function(fallback)
      --     if cmp.visible() then
      --       if cmp.visible_docs() then
      --         cmp.scroll_docs(-1)
      --       else
      --         cmp.open_docs()
      --       end
      --     else
      --       fallback()
      --     end
      --   end, { "i", "s" }),
      -- })

      -- opts.snpipet = {
      --   expand = function(args)
      --     luasnip.lsp_expand(args.body)
      --   end,
      -- }

      -- cmp.setup({
      --   formatting = {
      --     format = function(entry, vim_item)
      --       local docs = entry:get_documentation()
      --       local docLine = next(docs) or ""
      --
      --       return vim_item
      --     end,
      --   },
      -- })

      opts.window = {
        completion = {
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,Search:None",
          col_offset = -3,
          -- side_padding = 4,
          border = "rounded",
        },
        documentation = {
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,Search:None",
          border = "rounded",
        },
      }

      local lspkind = require("lspkind")
      local detail_maxwidth = 50
      local utf8 = require("utf8")

      ---@type cmp.FormattingConfig
      opts.formatting = {
        expandable_indicator = true,
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          local format = lspkind.cmp_format({ mode = "symbol", maxwidth = 50 })
          local formatted_item = format(entry, vim_item) ---@type vim.CompletedItem
          local strings = vim.split(formatted_item.kind, "%s", { trimempty = true })
          local kind_string = (strings[1] or "")
          local detail = entry.completion_item.labelDetails and entry.completion_item.labelDetails.description
            or entry.completion_item.detail

          formatted_item.kind = " " .. kind_string .. " "
          if detail ~= nil and detail ~= "" then
            -- Limit the length of detail text.
            if utf8.len(detail) > detail_maxwidth then
              detail = string.sub(detail, 1, utf8.offset(detail, detail_maxwidth)) .. "…"
            end

            formatted_item.menu = "  " .. detail
          else
            formatted_item.menu = "  "
          end

          return formatted_item
        end,
      }

      local types = require("cmp.types")
      local lspkind_comparator = function(conf)
        local lsp_types = types.lsp
        return function(entry1, entry2)
          if entry1.source.name ~= "nvim_lsp" then
            if entry2.source.name == "nvim_lsp" then
              return false
            else
              return nil
            end
          end
          local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
          local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]
          if kind1 == "Variable" and entry1:get_completion_item().label:match("%w*=") then
            kind1 = "Parameter"
          end
          if kind2 == "Variable" and entry2:get_completion_item().label:match("%w*=") then
            kind2 = "Parameter"
          end

          local priority1 = conf.kind_priority[kind1] or 0
          local priority2 = conf.kind_priority[kind2] or 0
          if priority1 == priority2 then
            return nil
          end
          return priority2 < priority1
        end
      end

      local label_comparator = function(entry1, entry2)
        return entry1.completion_item.label < entry2.completion_item.label
      end

      local score_comparator = function(entry1, entry2)
        local kind1 = entry1:get_kind() --- @type lsp.CompletionItemKind | number
        local kind2 = entry2:get_kind() --- @type lsp.CompletionItemKind | number

        if kind1 ~= kind2 then
          if kind1 == types.lsp.CompletionItemKind.Snippet then
            return false
          end
          if kind2 == types.lsp.CompletionItemKind.Snippet then
            return false
          end
        end

        -- local effectiveEntry1Score = entry1:get_kind() == types.lsp.CompletionItemKind.Snippet and 0 or entry1.score
        -- local effectiveEntry2Score = entry2:get_kind() == types.lsp.CompletionItemKind.Snippet and 0 or entry2.score
        -- local diff = effectiveEntry2Score - effectiveEntry1Score

        local diff = entry2.score - entry1.score
        if diff < 0 then
          return true
        elseif diff > 0 then
          return false
        end

        return nil
      end

      local snippet_comparator = function(entry1, entry2)
        local kind1 = entry1:get_kind() --- @type lsp.CompletionItemKind | number
        local kind2 = entry2:get_kind() --- @type lsp.CompletionItemKind | number

        if kind1 ~= kind2 then
          if kind1 == types.lsp.CompletionItemKind.Snippet then
            return false
          end
          if kind2 == types.lsp.CompletionItemKind.Snippet then
            return true
          end
        end

        return nil
      end

      local lsp_text_comparator = function(entry1, entry2)
        local t1 = entry1.completion_item.sortText
        local t2 = entry2.completion_item.sortText
        if t1 ~= nil and t2 ~= nil and t1 ~= t2 then
          return t1 < t2
        end
      end

      local compare = require("cmp.config.compare")
      local lsp_kind_comparator = lspkind_comparator({
        kind_priority = {
          Parameter = 14,
          Variable = 12,
          Field = 11,
          Property = 11,
          Constant = 10,
          Enum = 10,
          EnumMember = 10,
          Event = 10,
          Function = 10,
          Method = 10,
          Operator = 10,
          Reference = 10,
          Struct = 9,
          File = 8,
          Folder = 8,
          Class = 5,
          Color = 5,
          Module = 5,
          Keyword = 2,
          Constructor = 1,
          Interface = 1,
          Snippet = 0,
          Text = 1,
          TypeParameter = 1,
          Unit = 1,
          Value = 1,
        },
      })

      opts.sorting = {
        comparators = {
          require("copilot_cmp.comparators").prioritize,

          -- compare.exact, -- Enabling "exact" would always put emmet on top in .jsx files.

          --snippet_comparator,
          --compare.offset,
          snippet_comparator,

          -- compare.exact,
          -- score_comparator,
          -- compare.recently_used,
          --
          -- lsp_text_comparator,
          -- lsp_kind_comparator,
          -- snippet_comparator,

          -- compare.offset,
          -- compare.exact,
          --
          -- compare.locality,
          -- compare.score,
          -- compare.length,
          -- label_comparator,
          -- snippet_comparator,
          -- compare.offset,
          -- compare.exact,

          compare.offset,
          compare.exact,
          compare.score,
          compare.recently_used,
          compare.locality,
          -- compare.kind,
          lsp_kind_comparator,
          compare.sort_text,
          compare.length,
          compare.order,
          snippet_comparator,
          -- label_comparator,
        },
      }

      -- opts.sorting = {
      --   priority_weight = 2,
      --   comparators = {
      --     compare.offset,
      --     compare.exact,
      --     -- compare.scopes,
      --     compare.score,
      --     compare.recently_used,
      --     compare.locality,
      --     compare.kind,
      --     -- compare.sort_text,
      --     compare.length,
      --     compare.order,
      --   },
      -- }
    end,
  },
  {
    "nvim-orgmode/orgmode",
    enabled = false,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter", lazy = true },
    },
    event = "VeryLazy",
    config = function()
      -- Load treesitter grammar for org
      require("orgmode").setup_ts_grammar()

      -- Setup treesitter
      -- require("nvim-treesitter.configs").setup({
      --   highlight = {
      --     enable = true,
      --   },
      --   ensure_installed = { "org" },
      -- })

      -- Setup orgmode
      require("orgmode").setup({
        org_agenda_files = "~/orgfiles/**/*",
        org_default_notes_file = "~/orgfiles/refile.org",
      })
    end,
  },

  {
    "LunarVim/bigfile.nvim",
    event = "VeryLazy",
    opts = {
      filesize = 2, -- size of the file in MiB, the plugin round file sizes to the closest MiB
      pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
      features = { -- features to disable
        "indent_blankline",
        "illuminate",
        "lsp",
        "treesitter",
        "syntax",
        "matchparen",
        "vimopts",
        "filetype",
      },
    },
  },

  {
    "nelsyeung/twig.vim",
    event = "VeryLazy",
    config = function()
      --
    end,
  },
}
