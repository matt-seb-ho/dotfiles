local use_gruvbox = true 

if use_gruvbox then
  vim.cmd [[
  try
    colorscheme gruvbox
  catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme default
    set background=dark
  endtry
  ]]
else 
  local catppuccin = require("catppuccin")


  -- configure it
  catppuccin.setup({transparent_background = true, term_colors = true,})

  -- Lua
  -- vim.g.catppuccin_flavour = "frappe" -- latte, frappe, macchiato, mocha
  vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
  vim.cmd[[colorscheme catppuccin]]
end
