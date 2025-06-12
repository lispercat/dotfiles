return {
  { "mhinz/vim-startify" },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    -- After opening a #c file for the first time install roslyn by running :MasonInstall roslyn
    -- Also if something goes wrong, check :LspLogs for more information, I found that I had to increase fs.inotify.max_user_instances to 8192
    -- Syntax highlighting is handled not by treesitter but by the roslyn server
    "seblyng/roslyn.nvim",
    ft = "cs",
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        pyright = {},
        gopls = {},
        ts_ls = {},
        lua_ls = {},
        helm_ls = {},
        yamlls = {},
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            -- '.git',
            -- '.DS_Store',
            -- 'thumbs.db',
          },
          never_show = {},
        },
      },
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
  -- {
  --   "Olical/conjure",
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "nvim-treesitter/nvim-treesitter-textobjects",
  --   },
  --   config = function()
  --     vim.g["conjure#log#fold#enabled"] = true
  --     vim.g["conjure#log#wrap"] = true
  --     vim.g["conjure#highlight#enabled"] = true
  --     vim.g["conjure#client#python#stdio#prompt_pattern"] = ">>> "
  --
  --     -- vim.g["conjure#log#diagnostics"] = true
  --     -- vim.g["conjure#debug"] = true
  --   end,
  -- },
  -- {
  --   "jpalardy/vim-slime",
  --   keys = {
  --     { "<leader>rc", "<cmd>SlimeConfig<cr>", desc = "Slime Config" },
  --     { "<leader>rr", "<Plug>SlimeSendCell<BAR>/^# %%<CR>", desc = "Slime Send Cell" },
  --   },
  --   config = function()
  --     vim.g.slime_target = "wezterm"
  --     vim.g.slime_default_config = { socket_name = "default", target_pane_id = "{1}" }
  --     vim.g.slime_input_pid = 1
  --     vim.g.slime_cell_delimiter = "# %%"
  --     vim.g.slime_bracketed_paste = 1
  --   end,
  -- },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      "mfussenegger/nvim-dap-python", --optional
      { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    event = "VeryLazy",
    branch = "regexp", -- This is the regexp branch, use this for the new version
    config = function()
      require("venv-selector").setup()
    end,
    keys = {
      { ",v", "<cmd>VenvSelect<cr>" },
    },
  },
  {
    "nvim-java/nvim-java",
    config = function() end,
    dependencies = {
      "nvim-java/lua-async-await",
      "nvim-java/nvim-java-core",
      "nvim-java/nvim-java-test",
      "nvim-java/nvim-java-dap",
      "MunifTanjim/nui.nvim",
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
      {
        "williamboman/mason.nvim",
        opts = {
          registries = {
            "github:nvim-java/mason-registry",
            "github:mason-org/mason-registry",
          },
        },
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    opts = {},
  },
  {
    "gbprod/substitute.nvim",
    config = function()
      vim.keymap.set("n", "s", require("substitute").operator, { noremap = true })
      vim.keymap.set("n", "ss", require("substitute").line, { noremap = true })
      vim.keymap.set("n", "S", require("substitute").eol, { noremap = true })
      vim.keymap.set("x", "s", require("substitute").visual, { noremap = true })
    end,
  },

  {
    "svban/YankAssassin.nvim",
    config = function()
      require("YankAssassin").setup({
        auto_normal = true, -- if true, autocmds are used. Whenever y is used in normal mode, the cursor doesn't move to start
        auto_visual = true, -- if true, autocmds are used. Whenever y is used in visual mode, the cursor doesn't move to start
      })
      -- Optional Mappings
      vim.keymap.set({ "x", "n" }, "gy", "<Plug>(YADefault)", { silent = true })
      vim.keymap.set({ "x", "n" }, "<leader>y", "<Plug>(YANoMove)", { silent = true })
    end,
  },
  {
    "ysmb-wtsg/in-and-out.nvim",
    keys = {
      {
        "<C-l>",
        function()
          require("in-and-out").in_and_out()
        end,
        mode = "i",
      },
    },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon.setup()
      vim.keymap.set("n", "<leader>a", function()
        harpoon:list():add()
      end)
      vim.api.nvim_set_keymap("n", "<Leader>h", "<Cmd>Telescope harpoon marks<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>hq", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)
    end,
  },
  {
    "leath-dub/snipe.nvim",
    keys = {
      {
        "<leader>hs",
        function()
          require("snipe").open_buffer_menu()
        end,
        desc = "Open Snipe buffer menu",
      },
    },
    opts = {},
  },
  { "Olical/nfnl", ft = "fennel" },
  { "junegunn/vim-easy-align" },
  { "towolf/vim-helm", ft = "helm" },
  -- {
  --   -- Install "pip install jupytext" to use this plugin
  --   "GCBallesteros/jupytext.nvim",
  --   config = true,
  -- },
  {
    -- Install "pip install jupytext" to use this plugin
    "goerz/jupytext.nvim",
    version = "0.2.0",
    opts = {}, -- see Options
  },
  {
    "folke/snacks.nvim",
    opts = {
      bigfile = {
        size = 100 * 1024 * 1024, -- 100MB
        line_length = 10000000,
      },
    },
  },

  {
    "hkupty/iron.nvim",
    config = function()
      local iron = require("iron.core")
      local view = require("iron.view")
      local common = require("iron.fts.common")

      iron.setup({
        config = {
          preferred = "bash",
          repl_open_cmd = "vnew",
          repl_definition = {
            sh = {
              command = { "bash" },
            },
            python = {
              command = { "python3" }, -- or { "ipython", "--no-autoindent" }
              format = common.bracketed_paste_python,
              block_dividers = { "# %%", "#%%" },
            },
            javascript = {
              command = { "node" },
              format = common.bracketed_paste_python,
            },
          },
        },
        keymaps = {
          send_motion = "<localleader>sc",
          visual_send = "<localleader>sc",
          send_file = "<localleader>sf",
          send_line = "<localleader>sl",
          send_code_block = "<localleader>sb",
          send_mark = "<localleader>sm",
          mark_motion = "<localleader>mc",
          mark_visual = "<localleader>mc",
          remove_mark = "<localleader>md",
          cr = "<localleader>s<cr>",
          interrupt = "<localleader>s<localleader>",
          exit = "<localleader>sq",
          clear = "<localleader>cl",
        },
      })

      vim.keymap.set("n", "<localleader>rs", "<cmd>IronRepl<cr>")
      vim.keymap.set("n", "<localleader>rr", "<cmd>IronRestart<cr>")
      vim.keymap.set("n", "<localleader>rf", "<cmd>IronFocus<cr>")
      vim.keymap.set("n", "<localleader>rh", "<cmd>IronHide<cr>")
    end,
  },
}
