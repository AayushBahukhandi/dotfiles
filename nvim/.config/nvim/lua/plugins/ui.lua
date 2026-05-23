return {
  -- Floating filename pill at the top-right of each window (craftzdog signature)
  {
    "b0o/incline.nvim",
    dependencies = { "craftzdog/solarized-osaka.nvim" },
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local colors = require("solarized-osaka.colors").setup()
      require("incline").setup({
        highlight = {
          groups = {
            InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
            InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
          },
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = { cursorline = true },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[no name]"
          end
          if vim.bo[props.buf].modified then
            filename = "[+] " .. filename
          end
          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon or "", guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },

  -- Snacks: keep dashboard/picker/etc, but disable the modules that crash on
  -- markdown under Neovim 0.12.x (node:range() nil regression).
  -- See https://github.com/neovim/neovim/issues/39032
  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
      scope = { enabled = false },
      indent = { enabled = false },
      quickfile = { enabled = false },
      dashboard = {
        preset = {
          header = [[
       ██████╗ ███╗   ██╗███████╗    ██████╗ ██╗███████╗ ██████╗███████╗
      ██╔═══██╗████╗  ██║██╔════╝    ██╔══██╗██║██╔════╝██╔════╝██╔════╝
      ██║   ██║██╔██╗ ██║█████╗      ██████╔╝██║█████╗  ██║     █████╗
      ██║   ██║██║╚██╗██║██╔══╝      ██╔═══╝ ██║██╔══╝  ██║     ██╔══╝
      ╚██████╔╝██║ ╚████║███████╗    ██║     ██║███████╗╚██████╗███████╗
       ╚═════╝ ╚═╝  ╚═══╝╚══════╝    ╚═╝     ╚═╝╚══════╝ ╚═════╝╚══════╝
]],
        },
      },
    },
  },
}
