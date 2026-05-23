return {
  -- Discord Rich Presence — actively maintained; no Rust toolchain needed
  -- (auto-downloads server binary on first run, only requires `curl`).
  {
    "vyfor/cord.nvim",
    event = "VeryLazy",
    opts = {
      display = {
        theme = "default",
      },
      editor = {
        client = "neovim",
        tooltip = "The Cooler Vim",
      },
      idle = {
        enabled = true,
        timeout = 300000, -- 5 min idle
        show_status = true,
        details = "Idling",
      },
      text = {
        viewing = function(opts) return "Reading " .. opts.filename end,
        editing = function(opts) return "Editing " .. opts.filename end,
        workspace = function(opts) return "In " .. opts.workspace end,
      },
    },
  },
}
