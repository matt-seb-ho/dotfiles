--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- ------------------------------------
-- general
vim.opt.title = true
vim.opt.titlestring = "%t - nvim"
vim.opt.relativenumber = true
vim.opt.timeoutlen = 50

lvim.log.level = "warn"
lvim.format_on_save.enabled = false
lvim.colorscheme = "gruvbox-flat"
--[[ lvim.colorscheme = "lunar" ]]
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
-- lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- vim.keymap.del("i", "<C-p>")
-- vim.keymap.del("i", "<C-n>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Change theme settings
-- lvim.builtin.theme.options.dim_inactive = true
-- lvim.builtin.theme.options.style = "storm"

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
-- }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true

lvim.builtin.lualine.style = "lvim"
lvim.builtin.lualine.sections.lualine_a = { "mode" }
lvim.builtin.lualine.sections.lualine_b = { "branch" }
lvim.builtin.lualine.sections.lualine_c = { "filename" }
lvim.builtin.bufferline.options.show_buffer_close_icons = false


-- ------------------------------------
-- Additional Plugins

vim.g.gruvbox_flat_style = "hard"
vim.g.gruvbox_colors = {
  blue = "#83a598",
  green = "#b8bb26",
  aqua = "#8ec07c",
  red = "#fb4934"
  -- bg = "#282828",
  -- bg2 = "#0e1116"
}


vim.g.gruvbox_theme = {
  -- Special = {fg = "blue"},
  Special = {fg = "blue"},
  TSKeyword = {fg = "red"},
  Statement = {fg = "red"},
  Function = {fg = "aqua"},
  TSKeywordFunction = {fg = "red"},
  TSParameter = {fg = "fg"},
  TSPunctBracket = {fg = "fg"},
  Constant = {fg = "purple"},
  TSOperator = {fg = "yellow"},
  TSVariableBuiltin = {fg = "yellow"},
  TSProperty = {fg = "blue"},
  -- TSField = {fg = "blue"},
  -- TSField = {fg = "fg"},
  NvimTreeNormal = {fg = "fg", bg="bg_sidebar"},
  NvimTreeFolderName = {fg = "aqua"},
  NvimTreeGitNew = {fg = "green"}
}

lvim.plugins = {
  { 'Yazeed1s/oh-lucy.nvim' },
  {
    'VonHeikemen/fine-cmdline.nvim',
    requires = {
      {'MunifTanjim/nui.nvim'}
    },
  },
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end
  },
  --[[ {
    "giusgad/pets.nvim",
    requires = {
      "giusgad/hologram.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("pets").setup({
        row = 1, -- the row (height) to display the pet at (higher row means the pet is lower on the screen), must be 1<=row<=10
        col = 0, -- the column to display the pet at (set to high number to have it stay still on the right side)
        speed_multiplier = 1, -- you can make your pet move faster/slower. If slower the animation will have lower fps.
        default_pet = "dog", -- the pet to use for the PetNew command
        default_style = "brown", -- the style of the pet to use for the PetNew command
        random = true, -- whether to use a random pet for the PetNew command, ovverides default_pet and default_style
        -- death_animation = true, -- animate the pet's death, set to false to feel less guilt -- currently no animations are available
        popup = { -- popup options, try changing these if you see a rectangle around the pets
          width = "30%", -- can be a string with percentage like "45%" or a number of columns like 45
          winblend = 100, -- winblend value - see :h 'winblend' - only used if avoid_statusline is false
          hl = { Normal = "Normal" }, -- hl is only set if avoid_statusline is true, you can put any hl group instead of "Normal"
          avoid_statusline = false, -- if winblend is 100 then the popup is invisible and covers the statusline, if that
          -- doesn't work for you then set this to true and the popup will use hl and will be spawned above the statusline (hopefully)
        }
      });
    end,
  }, ]]
  { 'eddyekofo94/gruvbox-flat.nvim' },
  {
    "neanias/everforest-nvim",
    -- Optional; default configuration will be used if setup isn't called.
    config = function()
      require("everforest").setup()
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    -- event = { "VimEnter" },
    event = { "InsertEnter" },
    config = function ()
      -- vim.defer_fn(function()
      vim.schedule(function()
        require("copilot").setup({
          suggestion = {
            -- enabled = true,
            auto_trigger = true,
            keymap = {
              accept = "<C-o>",
              next = "<C-n>",
              prev = "<C-p>",
              dismiss = "<C-i>"
            }
          },
          filetypes = {
            python = true,
            cpp = true,
            java = true,
            javascript = true,
            typescript = true,
            rust = true,
            ["."] = false
          }
        })
      end, 100)
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function ()
      require("copilot_cmp").setup()
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && yarn install",
    setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = {"markdown"}
  }
}

-- vim.g.copilot_no_tab_map = true
-- vim.g.copilot_assume_mapped = true
lvim.builtin.which_key.mappings["P"] = {
  "<cmd>lua require(\"copilot.suggestion\").toggle_auto_trigger()<CR>",
  "Toggle Copilot"
}

lvim.builtin.which_key.mappings["i"] = {
  "<cmd>lua require(\"fine-cmdline\").open({default_value = \"\"})<CR>",
  "Open Command"
}


-- new greet banner
-- from: https://emojicombos.com/my-neighbor-totoro-text-art
local toto_banner2 = {
  "⠀⠀⠀⠀⡇⠀⠀⡶⠀⠀⠐⢿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡟⡀⢀⡞⠁⠀⠀⠀⠀⢸⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⡇⠀⠀⢿⠀⠀⠀⠀⡿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⡀⠡⡾⠀⠀⠀⠀⠀⠀⡾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⣿⠀⠀⣾⡄⠀⠀⠀⠀⠘⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡀⠀⠀⠀⣘⣿⣿⣿⣷⣘⣧⠀⠀⠀⠀⣀⣾⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⣿⠀⠀⠘⡇⠀⠀⠀⠀⠀⠸⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⡶⠶⠟⠛⠛⠛⠋⠉⠉⠉⠉⠉⠉⠉⠉⠛⠛⠿⠿⠿⠀⢀⣼⣿⣿⣤⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⣿⠀⠀⠀⢷⠀⠀⠀⠀⢀⣴⣿⡄⠀⠀⢀⣠⣤⡶⠾⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⠿⣆⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⢸⡀⠀⠀⠘⣇⠀⠀⠀⢾⣿⣏⣄⣴⣾⡿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠢⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠈⢿⣆⣀⣠⣿⣤⠀⠀⣨⣿⣿⡿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣷⡤⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠤⢞⣿⣧⣾⣷⠾⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢦⡀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⣐⣿⢿⣿⡟⢁⡾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠞⠉⠁⠈⠙⠲⡄⠀⠀⠀⠀⠀⠀⠀⢻⣦⡀⠀⠀",
  "⠀⠀⠀⠀⠀⠈⠉⣰⡿⢁⡴⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⣤⣤⣤⣤⣀⠀⠀⠀⠀⠀⢰⡏⠀⠀⠀⠀⠀⠀⢹⡄⠀⠀⠀⠀⠀⠀⠀⠛⢧⣀⣀",
  "⠀⠀⠀⠀⠀⣐⣿⣿⣧⡿⠃⠀⠀⠀⢀⡤⠖⠚⠓⠲⡄⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠘⠻⡇⠀⣾⣿⣦⠀⠀⢀⣿⠀⠀⠀⠀⣀⣠⣤⠶⠛⠛⣧",
  "⠀⠀⠀⠀⠀⣼⠻⣵⡟⠀⠀⠀⠀⣰⠋⠀⠀⠀⠀⠀⢻⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⠁⠀⠀⠀⠀⠙⢦⡙⠻⠛⣀⣠⠞⠁⠀⢰⣶⠿⠋⠉⠀⠀⠀⣀⣨",
  "⠀⠀⠀⢠⣾⡇⢀⡟⠁⠀⠀⠀⢸⡇⠀⠀⢠⣾⣿⡆⢸⠀⠀⠀⠀⠀⠀⠙⠋⠉⠛⠛⠛⠻⠿⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠁⠀⠀⠀⣀⣈⡁⠀⠀⠀⢶⡾⠛⠋⠁",
  "⠀⠀⢠⣾⣿⡀⡾⠁⠀⠀⠀⠀⠸⣇⠀⠀⠘⠛⢛⡵⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠉⣹⣿⣛⣻⡿⠓⠶⠶⠶⡗⠀⠀⠈⠳⠶⠶⠚⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⠉",
  "⢺⡿⠉⢸⡟⠁⠀⠀⠀⠀⢰⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠟⠁⠀⣾⣁⣀⣠⣤⡆⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠶⠾⡟⠛⠉⠉⢁⣤⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⣀⣈⣁⣤⡶⡟⠛⢉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀                          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "                               nvim                              ",
}

local banner = toto_banner2
if vim.o.lines < 36 then
  banner = vim.list_slice(banner, 16, 22)
end
local dash_sections = require("lvim.core.alpha.dashboard").get_sections()
dash_sections.header = {
  type = "text",
  val = banner,
  opts = {
    position = "center",
    hl = "Label",
  },
}
dash_sections.footer = nil
lvim.builtin.alpha.dashboard = {
  config = {},
  section = dash_sections
}


-- ------------------------------------
-- LSP, Formatters, Linters

-- fix clangd issue:
--  >> on every key press in insert mode, get "warning: multiple offset_encodings detected for this buffer"
--  - I think it might be the interaction between copilot and clangd
--  - the initial fix that worked (but will be overrided with lvim updates), 
--    - before: offsetEncoding = { 'utf-8', 'utf-16' },
--    + after:  offsetEncoding = 'utf-8',
--    in /Users/matthewho/.local/share/lunarvim/site/pack/packer/start/nvim-lspconfig/lua/lspconfig/server_configurations/clangd.lua

-- attempting to fix this in a way robust to lvim update (writing the change here)
-- link: https://github.com/LunarVim/LunarVim/issues/2597#issuecomment-1254764973

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "clangd" })
local capabilities = require("lvim.lsp").common_capabilities()
capabilities.offsetEncoding = { "utf-16" }
local opts = {capabilities = capabilities}
require("lvim.lsp.manager").setup("clangd", opts)


-- -- make sure server will always be installed even if the server is in skipped_servers list
-- lvim.lsp.installer.setup.ensure_installed = {
--     "sumneko_lua",
--     "jsonls",
-- }
-- -- change UI setting of `LspInstallInfo`
-- -- see <https://github.com/williamboman/nvim-lsp-installer#default-configuration>
-- lvim.lsp.installer.setup.ui.check_outdated_servers_on_open = false
-- lvim.lsp.installer.setup.ui.border = "rounded"
-- lvim.lsp.installer.setup.ui.keymaps = {
--     uninstall_server = "d",
--     toggle_server_expand = "o",
-- }

-- ---@usage disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "black", filetypes = { "python" } },
--   { command = "isort", filetypes = { "python" } },
--   {
--     -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "prettier",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--print-with", "100" },
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }


-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.json", "*.jsonc" },
--   -- enable wrap mode for json files only
--   command = "setlocal wrap",
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })

