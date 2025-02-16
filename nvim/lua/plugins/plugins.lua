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
  {
    "Olical/conjure",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
  },
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
    opts = {
      config = function()
        vim.keymap.set("n", "s", require("substitute").operator, { noremap = true })
        vim.keymap.set("n", "ss", require("substitute").line, { noremap = true })
        vim.keymap.set("n", "S", require("substitute").eol, { noremap = true })
        vim.keymap.set("x", "s", require("substitute").visual, { noremap = true })
      end,
    },
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
}
