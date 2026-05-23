return {
  -- Edit the filesystem as a buffer. `-` opens the parent dir; type/edit/delete
  -- lines and `:w` to apply changes. Faster than a file browser once habit forms.
  {
    "stevearc/oil.nvim",
    lazy = false, -- needed so opening a directory route hands off to oil
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Oil: open parent dir" },
      { "<leader>fo", "<cmd>Oil<cr>", desc = "Oil (filesystem buffer)" },
    },
    opts = {
      default_file_explorer = false, -- keep neo-tree as the primary tree
      view_options = { show_hidden = true },
      delete_to_trash = true,
    },
  },

  -- Telescope: keep LazyVim's default config, add the file-browser extension
  -- with a "browse at current file's directory" keybind.
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-telescope/telescope-file-browser.nvim" },
    keys = {
      {
        "<leader>fB",
        function()
          local telescope = require("telescope")
          local buf_dir = vim.fn.expand("%:p:h")
          telescope.extensions.file_browser.file_browser({
            path = "%:p:h",
            cwd = buf_dir,
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            previewer = false,
            initial_mode = "normal",
            layout_config = { height = 40 },
          })
        end,
        desc = "File Browser (cwd of current file)",
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("file_browser")
    end,
  },
}
