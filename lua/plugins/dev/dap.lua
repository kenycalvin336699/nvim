local env = require("config.env")
local uv = vim.uv or vim.loop
local unity = env.optional("unity")

-- prefer a Mason-installed binary, otherwise whatever is on PATH
local function bin(name)
  local p = vim.fn.stdpath("data") .. "/mason/bin/" .. name
  return uv.fs_stat(p) and p or name
end

local dap_deps = {
  "rcarriga/nvim-dap-ui",
  "nvim-neotest/nvim-nio",
  "theHamsta/nvim-dap-virtual-text",
}
if env.use_mason then table.insert(dap_deps, "jay-babu/mason-nvim-dap.nvim") end

local specs

specs = {
  {
    "mfussenegger/nvim-dap",
    dependencies = dap_deps,
    keys = {
      { "<F5>",       function() require("dap").continue() end,          desc = "Debug: Continue" },
      { "<F10>",      function() require("dap").step_over() end,         desc = "Debug: Step Over" },
      { "<F11>",      function() require("dap").step_into() end,         desc = "Debug: Step Into" },
      { "<F12>",      function() require("dap").step_out() end,          desc = "Debug: Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,          desc = "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end,     desc = "Run to Cursor" },
      { "<leader>dt", function() require("dap").terminate() end,         desc = "Terminate" },
      { "<leader>du", function() require("dapui").toggle() end,          desc = "Toggle DAP UI" },
      { "<leader>dr", function() require("dap").repl.toggle() end,       desc = "Toggle REPL" },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      dapui.setup()
      require("nvim-dap-virtual-text").setup()

      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine" })

      local function ask_program()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end

      -- ===== C / C++ / Rust via codelldb =====
      dap.adapters.codelldb = function(callback)
        local exe = bin("codelldb")
        if vim.fn.executable(exe) ~= 1 then
          vim.notify("codelldb not found (install it with :MasonInstall codelldb)", vim.log.levels.WARN)
          return
        end
        local port = 13000 + math.random(0, 500) -- avoid clashing with a leftover process
        local stdout = uv.new_pipe(false)
        local handle

        handle = uv.spawn(exe, {
          args = { "--port", tostring(port) },
          stdio = { nil, stdout, nil },
          detached = true,
        }, function()
          stdout:close()
          if handle then handle:close() end
        end)

        stdout:read_start(function(err, chunk)
          assert(not err, err)
          if chunk then
            vim.schedule(function() require("dap.repl").append(chunk) end)
          end
        end)

        -- give codelldb time to bind the port before nvim-dap connects
        vim.defer_fn(function()
          callback({ type = "server", host = "127.0.0.1", port = port })
        end, 400)
      end

      local native = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = ask_program,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      dap.configurations.c = native
      dap.configurations.cpp = native
      dap.configurations.rust = native

      -- ===== Assembly via gdb =====
      dap.adapters.gdb = { type = "executable", command = "gdb", args = { "-i", "dap" } }
      dap.configurations.asm = {
        {
          name = "Launch (gdb)",
          type = "gdb",
          request = "launch",
          program = ask_program,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = true,
        },
      }

      -- ===== C# / Unity via netcoredbg =====
      dap.adapters.coreclr = {
        type = "executable",
        command = bin("netcoredbg"),
        args = { "--interpreter=vscode" },
      }
      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Attach to Unity",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
      }
    end,
  },

}

if env.use_mason then
  table.insert(specs, {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "mason-org/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      ensure_installed = unity and { "codelldb", "netcoredbg" } or { "codelldb" },
      handlers = {
        -- we register codelldb ourselves above to avoid the port-race
        -- in mason-nvim-dap's built-in adapter
        codelldb = function() end,
      },
    },
  })
end

return specs
