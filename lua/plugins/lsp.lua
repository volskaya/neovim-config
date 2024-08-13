return {
  -- tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "shfmt",
        "tailwindcss-language-server",
        "typescript-language-server",
        "css-lsp",
        "emmet-ls",
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    init = function()
      -- Modify the in memory keymap table of nvim-lspconfig.
      local hardcoded_keys = require("lazyvim.plugins.lsp.keymaps").get()
      local on_list = require("util/lsp_defininion_on_list").on_list
      local keys = {
        { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
        {
          "gd",
          function()
            -- Default behavior:
            -- require("telescope.builtin").lsp_definitions({ reuse_win = true })

            -- This on_list will only jump to the 1st definition.
            vim.lsp.buf.definition({ on_list = on_list })

            -- DO NOT RESUSE WINDOW
            -- require("telescope.builtin").lsp_definitions({ reuse_win = false, on_list = on_list })
          end,
          desc = "Goto Definition",
          has = "definition",
        },
        { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
        { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
        {
          "gI",
          function()
            require("telescope.builtin").lsp_implementations({ reuse_win = true })
          end,
          desc = "Goto Implementation",
        },
        {
          "gy",
          function()
            require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
          end,
          desc = "Goto T[y]pe Definition",
        },
        { "\\", vim.lsp.buf.hover, desc = "Hover" },
        { "<M-\\>", vim.lsp.buf.signature_help, desc = "Signature Help" },
        { "<M-\\>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
        -- { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
        -- { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
        { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
        { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "v" }, has = "codeLens" },
        {
          "<leader>cC",
          vim.lsp.codelens.refresh,
          desc = "Refresh & Display Codelens",
          mode = { "n" },
          has = "codeLens",
        },
        {
          "<leader>cA",
          function()
            vim.lsp.buf.code_action({
              context = {
                only = {
                  "source",
                },
                diagnostics = {},
              },
            })
          end,
          desc = "Source Action",
          has = "codeAction",
        },
        {
          "<leader>cK",
          function()
            require("util.lsp_code_actions").lsp_rename_file()
          end,
          desc = "Rename File",
          has = "rename",
        }, -- Should "has" RenameFile instead.
        { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
        {
          "<leader>cR",
          function()
            local root = require("util.telescope").get_better_root()
            require("spectre").open_visual({ select_word = true, cwd = root })
          end,
          desc = "Search & Replace",
        },
      }

      while #hardcoded_keys > 0 do
        local _ = table.remove(hardcoded_keys, 1)
      end

      for i, v in ipairs(keys) do
        hardcoded_keys[i] = v
      end

      vim.diagnostic.config({
        virtual_text = false,
        float = {
          border = "rounded",
          source = true,
        },
      })
    end,
    opts = {
      inlay_hints = { enabled = false },
      ---@type lspconfig.options
      ---@diagnostic disable-next-line: missing-fields
      servers = {
        gdscript = {},
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                pyflakes = {
                  maxLineLength = 120,
                },
                flake8 = {
                  maxLineLength = 120,
                },
                pycodestyle = {
                  maxLineLength = 120,
                },
              },
            },
          },
        },
        dartls = {
          enabled = false,
          settings = {
            dart = {
              lineLength = 120,
            },
          },
        },
        cssls = {
          settings = { css = { lint = { unknownAtRules = "ignore" } } },
        },
        tailwindcss = {
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
        },
        eslint = {
          -- settings = { eslint = {} },
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
        },
        emmet_ls = {
          -- on_attach = on_attach,
          capabilities = capabilities,
          filetypes = {
            "css",
            "eruby",
            "html",
            "javascript",
            "javascriptreact",
            "less",
            "sass",
            "scss",
            "svelte",
            "pug",
            "typescriptreact",
            "vue",
          },
          init_options = {
            html = {
              options = {
                -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                ["bem.enabled"] = true,
              },
            },
          },
        },
        vtsls = {
          -- explicitly add default filetypes, so that we can extend
          -- them in related extras
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
          keys = {
            {
              "gD",
              function()
                local params = vim.lsp.util.make_position_params()
                LazyVim.lsp.execute({
                  command = "typescript.goToSourceDefinition",
                  arguments = { params.textDocument.uri, params.position },
                  open = true,
                })
              end,
              desc = "Goto Source Definition",
            },
            {
              "gR",
              function()
                LazyVim.lsp.execute({
                  command = "typescript.findAllFileReferences",
                  arguments = { vim.uri_from_bufnr(0) },
                  open = true,
                })
              end,
              desc = "File References",
            },
            {
              "<leader>co",
              LazyVim.lsp.action["source.organizeImports"],
              desc = "Organize Imports",
            },
            {
              "<leader>cM",
              LazyVim.lsp.action["source.addMissingImports.ts"],
              desc = "Add missing imports",
            },
            {
              "<leader>cu",
              LazyVim.lsp.action["source.removeUnused.ts"],
              desc = "Remove unused imports",
            },
            {
              "<leader>cD",
              LazyVim.lsp.action["source.fixAll.ts"],
              desc = "Fix all diagnostics",
            },
            {
              "<leader>cV",
              function()
                LazyVim.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
              end,
              desc = "Select TS workspace version",
            },
          },
        },
        tsserver = {
          enabled = false,
          keys = {},
          root_dir = function(...)
            return require("lspconfig.util").root_pattern(".git")(...)
          end,
          single_file_support = false,
          commands = {
            RenameFile = {
              require("util.lsp_code_actions").lsp_rename_file,
              description = "Rename File",
            },
          },
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
        html = {},
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        lua_ls = {
          -- enabled = false,
          single_file_support = true,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
              },
              misc = {
                parameters = {
                  -- "--log-level=trace",
                },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
              doc = {
                privateName = { "^_" },
              },
              type = {
                castNumberToInteger = true,
              },
              diagnostics = {
                disable = { "incomplete-signature-doc", "trailing-space" },
                -- enable = false,
                groupSeverity = {
                  strong = "Warning",
                  strict = "Warning",
                },
                groupFileStatus = {
                  ["ambiguity"] = "Opened",
                  ["await"] = "Opened",
                  ["codestyle"] = "None",
                  ["duplicate"] = "Opened",
                  ["global"] = "Opened",
                  ["luadoc"] = "Opened",
                  ["redefined"] = "Opened",
                  ["strict"] = "Opened",
                  ["strong"] = "Opened",
                  ["type-check"] = "Opened",
                  ["unbalanced"] = "Opened",
                  ["unused"] = "Opened",
                },
                unusedLocalExclude = { "_*" },
              },
              format = {
                enable = false,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
            },
          },
        },
      },
      setup = {},
    },
  },

  {
    "upperhands/godot-neovim",
    event = "VeryLazy",
    opts = {
      godot_executable = "godot", -- path to godot executable, can be an alias in user shell
      use_default_keymaps = true, -- set to false to disable keymaps below
      keymaps = {
        GdRunMainScene = "<leader>xm", -- run main scene
        GdRunLastScene = "<leader>xl", -- run the most recently executed scene
        GdRunSelectScene = "<leader>xs", -- show all scenes, and run selected
        GdShowDocumentation = "g<C-d>", -- open the documentation for the symbol under cursor in the editor
      },
    },
  },

  {
    "akinsho/flutter-tools.nvim",
    lazy = false, -- Lazy loading this sometimes scuffs, if I restore the session too quick.
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
    },
    config = true,
    enabled = true,
    opts = {
      widget_guides = { enabled = false },
      lsp = {
        color = { -- show the derived colours for dart variables
          enabled = false, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
          background = false, -- highlight the background
          background_color = nil, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
          foreground = false, -- highlight the foreground
          virtual_text = true, -- show the highlight using virtual text
          virtual_text_str = "■", -- the virtual text character to highlight
        },
        settings = {
          lineLength = 120,
          completeFunctionCalls = false,
        },
      },
    },
  },
}
