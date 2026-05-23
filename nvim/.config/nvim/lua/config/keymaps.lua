-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Custom helpers — exposed as :commands so they don't override LazyVim defaults.
vim.api.nvim_create_user_command("ReplaceHexWithHSL", function()
  require("aayush.hsl").replaceHexWithHSL()
end, { desc = "Replace hex colors on current line with HSL" })

vim.api.nvim_create_user_command("ToggleInlayHints", function()
  require("aayush.lsp").toggleInlayHints()
end, { desc = "Toggle LSP inlay hints" })

vim.api.nvim_create_user_command("ToggleAutoformat", function()
  require("aayush.lsp").toggleAutoformat()
end, { desc = "Toggle format-on-save" })
