return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      workspaces = {
        {
          name = "aayush_notes",
          path = "~/Library/Mobile Documents/com~apple~CloudDocs/aayush_notes",
        },
      },
      completion = { nvim_cmp = false, blink = true, min_chars = 2 },
      ui = { enable = false },
      mappings = {
        ["gf"] = {
          action = function() return require("obsidian").util.gf_passthrough() end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ["<leader>ch"] = {
          action = function() return require("obsidian").util.toggle_checkbox() end,
          opts = { buffer = true },
        },
      },
    },
  },
}
