-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.cmd.colorscheme("catppuccin-mocha")

-- Autocmd for C# files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  callback = function()
    vim.opt.tabstop = 4 -- Set tabstop to 4 for C# files
    vim.opt.shiftwidth = 4 -- Set shiftwidth to 4 for C# files
  end,
})
-- Autocmd for Python files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
  end,
})

vim.cmd("set modifiable")
--Write file to disk upon change
vim.api.nvim_create_autocmd({
  "InsertLeave",
  "TextChanged",
}, {
  pattern = {
    "*",
  },
  command = "silent! wall",
  nested = true,
})
vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Auto select virtualenv Nvim open",
  pattern = "*.py",
  callback = function()
    print("See if we need to activate python environment")
    local pyfiles = vim.fn.globpath(vim.fn.getcwd(), "*.py", true, true)
    if #pyfiles > 0 then
      require("venv-selector").retrieve_from_cache()
    end
  end,
  once = true,
})

