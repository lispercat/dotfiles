return {
  "nvim-neotest/neotest",
  dependencies = {
    "Issafalcon/neotest-dotnet",
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-neotest/neotest-python",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-dotnet")({
        }),
      },
    })
  end,
}
