local M = { "raspirat/vimtex" }

M.lazy = false

M.init = function()
  vim.g.vimtex_view_general_viewer = 'okular'
  vim.g.vimtex_view_general_options = '--unique file:@pdf#src:@line@tex'
  vim.g.vimtex_view_automatic = 1
end

local E = { "micangl/cmp-vimtex" }

E.dependencies = {
  "saghen/blink.compat",
  version = "*",
  lazy = true,
  opts = {},
}

return { M, E }
