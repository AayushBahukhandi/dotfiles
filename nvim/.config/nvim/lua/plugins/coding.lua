return {
  -- Yank ring: after `p`, <C-n>/<C-p> cycle through recent yanks.
  -- `<leader>p` opens a Telescope picker of paste history.
  {
    "gbprod/yanky.nvim",
    event = { "TextYankPost", "VeryLazy" },
    dependencies = { "kkharji/sqlite.lua" },
    opts = {
      ring = { storage = "sqlite", history_length = 100 },
      highlight = { timer = 150 },
    },
    keys = {
      { "<leader>p", function() require("telescope").extensions.yank_history.yank_history() end, desc = "Yank History" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },
      { "<C-n>", "<Plug>(YankyCycleForward)" },
      { "<C-p>", "<Plug>(YankyCycleBackward)" },
    },
    config = function(_, opts)
      require("yanky").setup(opts)
      pcall(function()
        require("telescope").load_extension("yank_history")
      end)
    end,
  },

  -- todo-comments is included with LazyVim by default; this spec only tweaks
  -- the icon-prefix style (no behavior change to keymaps).
  {
    "folke/todo-comments.nvim",
    opts = {
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
    },
  },

  -- Pretty markdown rendering inside the buffer (replaces what we lose by
  -- having to disable treesitter highlight on markdown for the nvim 0.12 bug).
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    opts = {
      heading = {
        sign = false,
        icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
      },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      checkbox = {
        unchecked = { icon = "󰄱 " },
        checked = { icon = "󰱒 " },
      },
    },
  },
}
