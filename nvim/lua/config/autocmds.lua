-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.keymap.set("n", "<leader>U", vim.cmd.UndotreeToggle, { desc = "Toggle UndoTree" })
vim.keymap.set("n", "<leader>ta", vim.cmd.ASToggle, { desc = "Toggle ASToggle" })
