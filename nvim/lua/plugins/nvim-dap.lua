return {
  {
    'mfussenegger/nvim-dap',
    version = '*',
    event = 'VeryLazy',
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      -- Define the adapter configuration for netcoredbg
      dap.adapters.netcoredbg  = {
        type = 'executable',
        command = '/usr/local/bin/netcoredbg/netcoredbg', -- Update this path to your netcoredbg executable
        args = {'--interpreter=vscode'},
      }

      -- Define the configuration for C# debugging
      dap.configurations.cs = {
        {
          type = 'netcoredbg',
          name = 'launch - netcoredbg',
          request = 'launch',
          program = function()
            local current_file_dir = vim.fn.fnamemodify(vim.fn.expand('%:p'), ':h')

            local function find_dll_files(dir)
              local dll_files = {}
              local handle = vim.loop.fs_scandir(dir)
              if handle then
                while true do
                  local name, type = vim.loop.fs_scandir_next(handle)
                  if not name then break end
                  local full_path = dir .. '/' .. name
                  if type == 'directory' then
                    local found_files = find_dll_files(full_path)
                    for _, file in ipairs(found_files) do
                      table.insert(dll_files, file)
                    end
                  elseif type == 'file' and name:match("%.dll$") and full_path:match("/bin/") then
                    table.insert(dll_files, full_path)
                  end
                end
              end
              return dll_files
            end

            local dll_files = find_dll_files(current_file_dir)

            local dll_file
            if #dll_files == 0 then
              dll_file = vim.fn.input('Path to dll: ', '', 'file')
            else
              if #dll_files == 1 then
                dll_file = dll_files[1]
              else
                print("Multiple .dll files found:")
                for i, file in ipairs(dll_files) do
                  print(i .. ": " .. file)
                end
                local choice = tonumber(vim.fn.input('Select the dll file number: '))
                dll_file = dll_files[choice]
              end
            end
            return vim.fn.input('Path to dll', dll_file, 'file')
          end,
        },
      }

      -- Add Lua debugging configuration
      dap.adapters.nlua = function(callback, config)
        callback({
          type = 'server',
          host = config.host or "127.0.0.1",
          port = config.port or 8086
        })
      end

      dap.configurations.lua = {
        {
          type = 'nlua',
          request = 'attach',
          name = "Attach to running Neovim instance",
          host = function()
            return "127.0.0.1"
          end,
          port = function()
            return 8086
          end,
        },
      }

      -- Optional: Configure dap-ui
      dapui.setup()
      print("DAP UI setup complete")

      -- Key mappings for breakpoints, REPL, and running the last debug session
      vim.api.nvim_set_keymap('n', '<Leader>b', '<Cmd>lua require\'dap\'.toggle_breakpoint()<CR>', { noremap = true, silent = true, desc = 'Toggle breakpoint' })
      vim.api.nvim_set_keymap('n', '<Leader>B', '<Cmd>lua require\'dap\'.set_breakpoint(vim.fn.input("Condition: "))<CR>', { noremap = true, silent = true, desc = 'Set conditional breakpoint' })
      vim.api.nvim_set_keymap('n', '<Leader>lp', '<Cmd>lua require\'dap\'.list_breakpoints()<CR>', { noremap = true, silent = true, desc = 'List breakpoints' })
      vim.api.nvim_set_keymap('n', '<Leader>dr', '<Cmd>lua require\'dap\'.repl.open()<CR>', { noremap = true, silent = true, desc = 'Open REPL' })
      vim.api.nvim_set_keymap('n', '<Leader>dl', '<Cmd>lua require\'dap\'.run_last()<CR>', { noremap = true, silent = true, desc = 'Run last debug session' })

      -- Define a helper function to manage key mappings
      local function set_debug_keymaps()
        vim.api.nvim_set_keymap('n', 'h', '<Cmd>lua require\'dap\'.step_into()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', 'j', '<Cmd>lua require\'dap\'.step_over()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', 'k', '<Cmd>lua require\'dap\'.step_out()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', 'l', '<Cmd>lua require\'dap\'.continue()<CR>', { noremap = true, silent = true })
        -- Map arrow keys for DAP commands
        -- vim.api.nvim_set_keymap('n', '<Left>', '<Cmd>lua require\'dap\'.step_into()<CR>', { noremap = true, silent = true, desc = 'Step into' })
        -- vim.api.nvim_set_keymap('n', '<Down>', '<Cmd>lua require\'dap\'.step_over()<CR>', { noremap = true, silent = true, desc = 'Step over' })
        -- vim.api.nvim_set_keymap('n', '<Up>', '<Cmd>lua require\'dap\'.step_out()<CR>', { noremap = true, silent = true, desc = 'Step out' })
        -- vim.api.nvim_set_keymap('n', '<Right>', '<Cmd>lua Conditional_dap_continue()<CR>', { noremap = true, silent = true, desc = 'Continue' })

      end

      local function remove_debug_keymaps()
        local keymap_exists = vim.api.nvim_get_keymap('n')
        local function keymap_present(lhs)
          for _, map in ipairs(keymap_exists) do
            if map.lhs == lhs then
              return true
            end
          end
          return false
        end

        if keymap_present('h') then vim.api.nvim_del_keymap('n', 'h') end
        if keymap_present('j') then vim.api.nvim_del_keymap('n', 'j') end
        if keymap_present('k') then vim.api.nvim_del_keymap('n', 'k') end
        if keymap_present('l') then vim.api.nvim_del_keymap('n', 'l') end
      end

      -- Automatically open dap-ui when a debug session starts
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
        set_debug_keymaps()
      end

      -- Automatically close dap-ui when the debug session ends or exits
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
        remove_debug_keymaps()
      end

      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
        remove_debug_keymaps()
      end
    end,
  },
  {
    'jbyuki/one-small-step-for-vimkind',
    version = '*',
    config = function()
      local dap = require('dap')
      dap.adapters.nlua = function(callback, config)
        callback({
          type = 'server',
          host = config.host or '127.0.0.1',
          port = config.port or 8086
        })
      end
      dap.configurations.lua = {
        {
          type = 'nlua',
          request = 'attach',
          name = "Attach to running Neovim instance",
        }
      }
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    version = '*',
    event = 'VeryLazy',
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
        mappings = {},
        expand_lines = vim.fn.has("nvim-0.9"),
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "right",
          },
          {
            elements = {
              { id = "repl", size = 1 },
            },
            size = 10,
            position = "bottom",
          },
        },
      })

      -- Automatically open dap-ui when a debug session starts
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end

      -- Automatically close dap-ui when the debug session ends
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end

      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
    end,
  }
}

