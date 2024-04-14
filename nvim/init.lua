-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("python")
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
vim.g.slime_bracketed_paste = 1
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = true })
vim.opt.fileformat = "unix"
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.g.config_dir = vim.fn.stdpath("config")
function Reload_required_modules()
  local required_modules = {
    "python",
  }
  for _, module in ipairs(required_modules) do
    package.loaded[module] = nil
    require(module)
  end

  vim.api.nvim_command(":luafile " .. vim.g.config_dir .. "/init.lua")
end

-- Bind a keymap to reload required modules and init.lua
vim.api.nvim_set_keymap("n", "<LocalLeader>r", ":lua Reload_required_modules()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<LocalLeader>e", ":e " .. vim.g.config_dir .. "/init.lua<CR>", { noremap = true, silent = true })
