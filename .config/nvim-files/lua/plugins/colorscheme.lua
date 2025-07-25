return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        render_markdown = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
        beacon = true,
      },
    })
  end,
}
