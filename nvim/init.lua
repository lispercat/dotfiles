-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.cmd.colorscheme("catppuccin-mocha")

-- Set indentation to 2 spaces
vim.g.autoformat = false
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.smartindent = true -- Enable smart indentation
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.jumpoptions:append("stack")


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
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = true })
vim.opt.fileformat = "unix"
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

local function is_dap_server_running(port)
  local handle = io.popen("nc -zv 127.0.0.1 " .. port .. " 2>&1")
  local result = handle:read("*a")
  handle:close()
  return result:find("succeeded") ~= nil
end

-- Function to conditionally run DAP based on file type

vim.keymap.set("n", "s", require("substitute").operator, { noremap = true })
vim.keymap.set("n", "ss", require("substitute").line, { noremap = true })
vim.keymap.set("n", "S", require("substitute").eol, { noremap = true })
vim.keymap.set("x", "s", require("substitute").visual, { noremap = true })
