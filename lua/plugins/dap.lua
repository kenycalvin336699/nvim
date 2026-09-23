-- lua/plugins/dap.lua
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",       -- required by dap-ui
      "jay-babu/mason-nvim-dap.nvim",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      { "<F5>",      function() require("dap").continue() end,          desc = "Debug: Continue" },
      { "<F10>",     function() require("dap").step_over() end,         desc = "Debug: Step Over" },
      { "<F11>",     function() require("dap").step_into() end,         desc = "Debug: Step Into" },
      { "<F12>",     function() require("dap").step_out() end,          desc = "Debug: Step Out" },
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

      -- auto open/close the UI with the session
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- breakpoint signs
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine" })

      -- ===== C / C++ / Rust via codelldb =====
	  local codelldb_path = vim.fn.stdpath("data") .. "/mason/bin/codelldb"

	  dap.adapters.codelldb = function(callback, config)
  		  local port = 13000 + math.random(0, 500) -- avoid clashing with a leftover process
  		  local stdout = vim.loop.new_pipe(false)
  		  local handle

  		  handle = vim.loop.spawn(codelldb_path, {
    		  args = { "--port", tostring(port) },
    		  stdio = { nil, stdout, nil },
    		  detached = true,
  		  }, function(code)
    		  stdout:close()
    		  if handle then handle:close() end
  		  end)

  		  stdout:read_start(function(err, chunk)
    		  assert(not err, err)
    		  if chunk then
      			  vim.schedule(function()
        			  require("dap.repl").append(chunk)
      			  end)
    		  end
  		  end)

  -- give codelldb time to actually bind the port before nvim-dap connects
  vim.defer_fn(function()
    callback({ type = "server", host = "127.0.0.1", port = port })
  end, 400)
end
      local cpp_rust_config = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      dap.configurations.c = cpp_rust_config
      dap.configurations.cpp = cpp_rust_config
      dap.configurations.rust = cpp_rust_config

      -- ===== Raw Assembly via gdb =====
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "-i", "dap" },
      }
      dap.configurations.asm = {
        {
          name = "Launch (gdb)",
          type = "gdb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = true,
        },
      }

      -- ===== C# / Unity via netcoredbg =====
      dap.adapters.coreclr = {
        type = "executable",
        command = "/usr/bin/netcoredbg", -- confirm path: `which netcoredbg`
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

	 {
	  "jay-babu/mason-nvim-dap.nvim",
	  dependencies = { "mason.nvim", "mfussenegger/nvim-dap" },
	  opts = {
	    ensure_installed = { "codelldb", "netcoredbg" },
	    automatic_installation = true,
	    handlers = {
	      -- disable the default handler for codelldb specifically —
	      -- we register the adapter and configurations ourselves in
	      -- the nvim-dap config() function above, to avoid the
	      -- port-race issue in mason-nvim-dap's built-in adapter.
	      codelldb = function() end,
	    },
	  },
	},
}
