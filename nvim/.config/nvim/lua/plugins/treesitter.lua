return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        -- Skip TS highlight for markdown/mdx until nvim 0.12 injection bug
        -- is fixed upstream. See neovim/neovim#39032.
        disable = { "markdown", "markdown_inline", "mdx" },
      },
      ensure_installed = {
        "bash",
        "css",
        "diff",
        "go",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
    },
  },
}
