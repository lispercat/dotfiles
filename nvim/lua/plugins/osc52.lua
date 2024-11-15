return {
  {
    "ojroques/nvim-osc52",
    cond = function()
      return os.getenv("SSH_CONNECTION") ~= nil
    end,
    config = function()
      -- This will only be set up when nvim-osc52 is loaded
      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          if vim.v.event.operator == "y" then
            local content = vim.fn.getreg('"')
            require("osc52").copy(content)
          end
        end,
      })
    end,
  }
}

