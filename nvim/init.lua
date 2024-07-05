-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
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
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = true })
vim.opt.fileformat = "unix"
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
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
--require("java").setup()
--require("lspconfig").jdtls.setup({})
