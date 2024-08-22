local our_supported_prettier_fts = {
  "php",
  "twig",
}

return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- We check for existing prettier condition, before extending it with our own.
      --
      -- This is to not cancel out lazyvim.plugins.extras.formatting.prettier.
      local prettier_condition = nil ---@type nil | function(self: any, ctx: table): boolean
      pcall(function()
        prettier_condition = opts.formatters.prettier.condition ---@type function(self: any, ctx: table): boolean
      end)

      return vim.tbl_deep_extend("force", opts, {
        notify_on_error = true,
        formatters_by_ft = {
          twig = { "prettier" }, -- djlint formats twig too, but I feel like prettier is the way to go.
          php = { "prettier" },
        },
        formatters = {
          ["php-cs-fixer"] = {
            command = "php-cs-fixer",
            args = { "fix", "--rules=@PSR12", "$FILENAME" },
            stdin = false,
          },
          djlint = {
            args = { "--configuration=.djlintrc", "--reformat", "-" },
            cwd = require("conform.util").root_file({ ".djlintrc" }),
          },
          prettier = {
            condition = function(self, ctx)
              -- Check Lazy's built in config for condition.
              local is_truthy = false
              pcall(function()
                is_truthy = prettier_condition and prettier_condition(self, ctx) == true or false
              end)

              if is_truthy then
                return true
              end

              -- Else check our own.
              return vim.tbl_contains(
                our_supported_prettier_fts,
                vim.bo[ctx.buf].filetype ---@type string
              )
            end,
          },
        },
      })
    end,
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        twig = { "djlint" },
      },
    },
  },
}
