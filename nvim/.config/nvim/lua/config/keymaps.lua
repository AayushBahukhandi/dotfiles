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

vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Obsidian: switch note" })
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<cr>",      { desc = "Obsidian: search vault" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>",         { desc = "Obsidian: new note" })
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianToday<cr>",       { desc = "Obsidian: today" })
vim.keymap.set("n", "<leader>oy", "<cmd>ObsidianYesterday<cr>",   { desc = "Obsidian: yesterday" })
vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>",   { desc = "Obsidian: backlinks" })
vim.keymap.set("n", "<leader>ol", "<cmd>ObsidianLinks<cr>",       { desc = "Obsidian: links out" })
vim.keymap.set("n", "<leader>oT", "<cmd>ObsidianTags<cr>",        { desc = "Obsidian: tags" })
vim.keymap.set("n", "<leader>or", "<cmd>ObsidianRename<cr>",      { desc = "Obsidian: rename (safe)" })
vim.keymap.set("n", "<leader>op", "<cmd>ObsidianPasteImg<cr>",    { desc = "Obsidian: paste image" })
