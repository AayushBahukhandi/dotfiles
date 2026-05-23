-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- WORKAROUND: Neovim 0.12.x has a treesitter regression where injected-language
-- predicates call node:range() on a nil node. Markdown with fenced code blocks
-- triggers it on every redraw. Stop TS on markdown buffers; vim regex syntax
-- + render-markdown.nvim take over. Remove once nvim ships a fix.
-- See: https://github.com/neovim/neovim/issues/39032
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "mdx" },
  callback = function()
    pcall(vim.treesitter.stop, 0)
  end,
})
