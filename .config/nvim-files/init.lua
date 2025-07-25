-- NOTE: MUST BE AT THE TOP START
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- NOTE: MUST BE AT THE TOP END

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Setup Oil.nvim plugin
require("oil").setup({
  default_file_explorer = true,
  delete_to_trash = true,
  view_options = {
    show_hidden = true,
  },
  columns = {
    "icon",
    "permission",
    "size",
  },
})
