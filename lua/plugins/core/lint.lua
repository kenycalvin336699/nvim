return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile", "BufWritePost" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      c = { "cpplint" },
      java = { "checkstyle" },
      -- rust: rust_analyzer's diagnostics already cover it
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("user-lint", { clear = true }),
      callback = function()
        -- only run linters that are actually installed
        for _, name in ipairs(lint.linters_by_ft[vim.bo.filetype] or {}) do
          local linter = lint.linters[name]
          local cmd = linter and linter.cmd
          if type(cmd) == "function" then cmd = cmd() end
          if cmd and vim.fn.executable(cmd) == 1 then
            lint.try_lint(name)
          end
        end
      end,
    })
  end,
}
