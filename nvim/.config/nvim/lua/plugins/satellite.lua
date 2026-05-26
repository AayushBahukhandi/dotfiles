return {
  {
    "lewis6991/satellite.nvim",
    event = "BufReadPost",
    opts = {
      current_only = false,
      winblend = 50,
      handlers = {
        cursor = { enable = true },
        search = { enable = true },
        diagnostic = { enable = true },
        gitsigns = { enable = true },
        marks = { enable = true },
      },
    },
  },
}
