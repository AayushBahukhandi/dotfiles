-- LazyVim defaults handle the keymap surface. Custom helpers are exposed as
-- ex-commands (no keybindings) so they stay available without overriding
-- LazyVim's bindings.

vim.api.nvim_create_user_command("ReplaceHexWithHSL", function()
  require("aayush.hsl").replaceHexWithHSL()
end, { desc = "Replace hex colors on the current line with HSL" })

vim.api.nvim_create_user_command("ToggleInlayHints", function()
  require("aayush.lsp").toggleInlayHints()
end, { desc = "Toggle LSP inlay hints" })

vim.api.nvim_create_user_command("ToggleAutoformat", function()
  require("aayush.lsp").toggleAutoformat()
end, { desc = "Toggle format-on-save" })
