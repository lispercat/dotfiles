return {
  "nvim-neotest/neotest",
  lazy = true,
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
    "Issafalcon/neotest-dotnet",  -- Add your dotnet adapter
    "nvim-neotest/neotest-python", -- Add your python adapter
    "nvim-neotest/neotest-jest",   -- If you need jest support (optional)
  },
  config = function()
    -- Setup neotest with the dotnet adapter
    require('neotest').setup({
      adapters = {
        -- Add your custom dotnet adapter here
        require("neotest-dotnet")({}),
      },
      -- Rest of the configuration
      diagnostic = {
        enabled = false,
        severity = vim.diagnostic.severity.WARN,  -- Added severity field
      },
      floating = {
        border = "rounded", -- Default border style (can be customized)
        max_height = 0.6,
        max_width = 0.6,
        options = {}  -- Added options field for floating windows
      },
      highlights = {
        adapter_name = "NeotestAdapterName",
        border = "NeotestBorder",
        dir = "NeotestDir",
        expand_marker = "NeotestExpandMarker",
        failed = "NeotestFailed",
        file = "NeotestFile",
        focused = "NeotestFocused",
        indent = "NeotestIndent",
        namespace = "NeotestNamespace",
        passed = "NeotestPassed",
        running = "NeotestRunning",
        skipped = "NeotestSkipped",
        test = "NeotestTest"
      },
      icons = {
        child_indent = "│",
        child_prefix = "├",
        collapsed = "─",
        expanded = "╮",
        failed = "✖",
        final_child_indent = " ",
        final_child_prefix = "╰",
        non_collapsible = "─",
        passed = "✔",
        running = "",
        skipped = "ﰸ",
        unknown = "?"
      },
      output = {
        enabled = true,
        open_on_run = true,
      },
      run = {
        enabled = true,
      },
      status = {
        enabled = true,
        virtual_text = true,  -- Added virtual_text
        signs = true,         -- Added signs
      },
      strategies = {
        integrated = {
          height = 40,
          width = 120
        }
      },
      summary = {
        enabled = true,
        expand_errors = true,
        follow = true,
        animated = false,  -- Added animated
        open = true,       -- Added open
        count = true,      -- Added count
        mappings = {
          attach = "a",
          expand = { "<CR>", "<2-LeftMouse>" },
          expand_all = "e",
          jumpto = "i",
          output = "o",
          run = "r",
          short = "O",
          stop = "u",
          debug = "d",  -- Added debug
          mark = "m",   -- Added mark
          run_marked = "r", -- Added run_marked
          debug_marked = "D", -- Added debug_marked
          clear_marked = "c", -- Added clear_marked
          target = "t",  -- Added target
          clear_target = "T",  -- Added clear_target
          next_failed = "]", -- Added next_failed
          prev_failed = "[", -- Added prev_failed
          watch = "w", -- Added watch
        }
      },
      log_level = "debug",  -- Added log_level (default)
      consumers = {},  -- Added consumers (can be configured as needed)
      output_panel = {
        enabled = true,  -- Added output_panel
        open_on_run = true,  -- Added open_on_run
      },
      quickfix = {
        enabled = false,  -- Disabled quickfix (can be enabled if needed)
      },
      state = {},  -- Added state (empty by default)
      watch = {},  -- Added watch configuration (can be customized)
      projects = {},  -- Added projects (can be customized)
      discovery = {
        enabled = true,  -- Enable test discovery
      },
      running = {
        enabled = true,  -- Enable running tests
      },
      default_strategy = "integrated",  -- Set default strategy for test running
    })
  end
}

