-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc", "markdown" },
	callback = function()
		vim.opt.conceallevel = 0
	end,
})

-- WORKAROUND: Neovim 0.12.x has a treesitter regression where injected language
-- predicates call node:range() on a nil node — see neovim/neovim#39032. Markdown
-- with fenced code blocks triggers it on every redraw. Disable TS highlighting
-- for markdown buffers; vim's regex syntax takes over. Remove once nvim ships a fix.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		pcall(vim.treesitter.stop, 0)
	end,
})
