-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.maplocalleader = ";"
vim.opt.relativenumber = false -- Relative line numbers
vim.g.autoformat = false
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.smartindent = true -- Enable smart indentation
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.jumpoptions:append("stack")
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = true })
vim.opt.fileformat = "unix"
vim.opt.ignorecase = true
