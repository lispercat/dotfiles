return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
    },
    version = "*",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dap.set_log_level("TRACE")

      require("nvim-dap-virtual-text").setup({})
      local function get_last_path_file()
        local project_folder = vim.fn.getcwd()
        local data_path = vim.fn.stdpath("data")
        local project_dir = data_path .. "/dap_last_dll_paths/" .. vim.fn.fnamemodify(project_folder, ":p:h:t")
        vim.fn.mkdir(project_dir, "p")
        return project_dir .. "/.last_dll_path.txt"
      end
      -- Define the adapter configuration for netcoredbg
      dap.adapters.netcoredbg = {
        type = "executable",
        command = "/usr/local/bin/netcoredbg/netcoredbg", -- Update this path to your netcoredbg executable
        args = { "--interpreter=vscode" },
      }
      -- Define the configuration for C# debugging
      dap.configurations.cs = {
        {
          -- Launch configuration
          justMyCode = false,
          type = "netcoredbg",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            local last_path_file = get_last_path_file()
            local last_path = ""
            if vim.fn.filereadable(last_path_file) == 1 then
              last_path = vim.fn.readfile(last_path_file)[1] or ""
            end
            local file_path = vim.fn.input("Enter path to .exe or .dll: ", last_path)

            if file_path and file_path ~= "" then
              vim.fn.writefile({ file_path }, last_path_file)
              return file_path
            else
              error("Invalid path. Debugging aborted.")
            end
          end,
        },
        {
          -- Attach configuration
          type = "netcoredbg",
          name = "attach - netcoredbg",
          request = "attach",
          processId = function()
            local lines = vim.fn.systemlist("ps -eo pid,args | grep bin/Debug | grep -v grep | grep -v sh")
            local choices = {}

            for _, line in ipairs(lines) do
              local pid, cmd = line:match("^(%s*%d+)%s+(.+)$")
              local cwd_output = vim.fn.system(string.format("pwdx %s", pid))
              local cwd = cwd_output:match(": (.+)\n") or "unknown"
              table.insert(choices, {
                pid = pid,
                label = string.format("%s - %s [%s]", pid, cmd, cwd),
              })
            end

            return coroutine.create(function(coro)
              if #choices == 0 then
                error("No matching processes found in bin/Debug.")
              end

              vim.ui.select(choices, {
                prompt = "Select .NET Debug process:",
                format_item = function(item)
                  return item.label
                end,
              }, function(choice)
                if choice then
                  coroutine.resume(coro, tonumber(choice.pid))
                else
                  error("No process selected")
                end
              end)
            end)
          end,
        },
      }

      -- Add Lua debugging configuration
      dap.adapters.nlua = function(callback, config)
        callback({
          type = "server",
          host = config.host or "127.0.0.1",
          port = config.port or 8086,
        })
      end

      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance",
          host = function()
            return "127.0.0.1"
          end,
          port = function()
            return 8086
          end,
        },
      }

      -- Add Python debugging configuration
      dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}", -- This configuration will launch the current file if used.
          pythonPath = function()
            local venv_path = os.getenv("VIRTUAL_ENV")
            if venv_path then
              return venv_path .. "/bin/python"
            else
              return "/usr/bin/python" -- Update this to your Python path if needed
            end
          end,
        },
      }

      function Conditional_dap_continue()
        local filetype = vim.bo.filetype
        if filetype == "cs" then
          require("dap").continue()
        elseif filetype == "lua" then
          if not is_dap_server_running(8086) then
            print("launching the OSV server for lua")
            require("osv").launch({ port = 8086, blocking = true })
          else
            print("OSV server is running")
            require("dap").continue()
          end
        elseif filetype == "python" then
          require("dap").continue()
        else
          print("Unsupported file type for debugging: " .. filetype)
        end
      end

      function is_dap_server_running(port)
        local handle = io.popen("nc -zv 127.0.0.1 " .. port .. " 2>&1")
        local result = handle:read("*a")
        handle:close()
        return result:find("succeeded") ~= nil
      end

      -- Optional: Configure dap-ui
      dapui.setup()
      print("DAP UI setup complete")

      -- Key mappings for breakpoints, REPL, and running the last debug session
      vim.api.nvim_set_keymap("n", "<Leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true, desc = "Toggle breakpoint" })
      vim.api.nvim_set_keymap(
        "n",
        "<Leader>B",
        "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input(\"Condition: \"))<CR>",
        { noremap = true, silent = true, desc = "Set conditional breakpoint" }
      )
      vim.api.nvim_set_keymap("n", "<Leader>lp", "<Cmd>lua require'dap'.list_breakpoints()<CR>", { noremap = true, silent = true, desc = "List breakpoints" })
      vim.api.nvim_set_keymap("n", "<Leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", { noremap = true, silent = true, desc = "Open REPL" })
      vim.api.nvim_set_keymap("n", "<Leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", { noremap = true, silent = true, desc = "Run last debug session" })

      -- Key mappings for starting and stopping debug sessions
      vim.api.nvim_set_keymap("n", "<F5>", "<Cmd>lua Conditional_dap_continue()<CR>", { noremap = true, silent = true, desc = "Conditional DAP Continue" })
      vim.api.nvim_set_keymap("n", "<F6>", "<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>", { noremap = true, silent = true })

      -- Define a helper function to manage key mappings
      local function set_debug_keymaps()
        -- Map arrow keys for DAP commands
        vim.api.nvim_set_keymap("n", "<Left>", "<Cmd>lua require'dap'.step_into()<CR>", { noremap = true, silent = true, desc = "Step into" })
        vim.api.nvim_set_keymap("n", "<Down>", "<Cmd>lua require'dap'.step_over()<CR>", { noremap = true, silent = true, desc = "Step over" })
        vim.api.nvim_set_keymap("n", "<Up>", "<Cmd>lua require'dap'.step_out()<CR>", { noremap = true, silent = true, desc = "Step out" })
        vim.api.nvim_set_keymap("n", "<Right>", "<Cmd>lua Conditional_dap_continue()<CR>", { noremap = true, silent = true, desc = "Continue" })
        vim.keymap.set("n", "<space>?", function()
          require("dapui").eval(nil, { enter = true })
        end)
      end

      local function remove_debug_keymaps()
        local keymap_exists = vim.api.nvim_get_keymap("n")
        local function keymap_present(lhs)
          for _, map in ipairs(keymap_exists) do
            if map.lhs == lhs then
              return true
            end
          end
          return false
        end

        if keymap_present("h") then
          vim.api.nvim_del_keymap("n", "h")
        end
        if keymap_present("j") then
          vim.api.nvim_del_keymap("n", "j")
        end
        if keymap_present("k") then
          vim.api.nvim_del_keymap("n", "k")
        end
        if keymap_present("l") then
          vim.api.nvim_del_keymap("n", "l")
        end
      end

      -- Automatically open dap-ui when a debug session starts
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
        set_debug_keymaps()
      end

      -- Automatically close dap-ui when the debug session ends or exits
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
        remove_debug_keymaps()
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
        remove_debug_keymaps()
      end
    end,
  },
}
