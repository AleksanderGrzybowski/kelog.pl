vim.g.mapleader = ','
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = false

vim.o.number = true
vim.o.mouse = 'a'
vim.o.showmode = false

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true
vim.o.undofile = false
vim.o.ignorecase = true
vim.o.signcolumn = 'auto'
vim.o.updatetime = 250
vim.o.timeoutlen = 1000
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = false
vim.o.inccommand = 'nosplit'

vim.o.cursorline = true
vim.o.scrolloff = 5

vim.o.confirm = false

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font }
    },
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup {
        defaults = {
          mappings = {
            i = { ['<esc>'] = actions.close },
          },
        },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '' })
      vim.keymap.set('n', '<leader>fs', builtin.grep_string, { desc = '' })
      vim.keymap.set('n', '<leader>fz', builtin.current_buffer_fuzzy_find, { desc = '' })

      vim.keymap.set('n', '<leader>fb', builtin.git_branches, { desc = '' })
      vim.keymap.set('n', '<leader>fc', builtin.git_commits, { desc = '' })
    end,
  },
  'shaunsingh/solarized.nvim',
  'calind/selenized.nvim',
  'tpope/vim-fugitive',
  'scrooloose/nerdtree',
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      require('blame').setup {
        colors = "#53676d"
      }
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          icons_enabled = false,
          theme = 'auto',
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = { 'nerdtree' }, winbar = { 'nerdtree' },
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = false,
          refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
          }
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'branch', 'diff'},
          lualine_y = {},
          lualine_z = {}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {'branch', 'diff'},
          lualine_c = {'filename'},
          lualine_x = {},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      })
    end
  },
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {},
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  }
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = {}
  },
})

vim.cmd.colorscheme 'solarized' -- selenized doesn't work otherwise
vim.cmd.colorscheme 'selenized'

vim.opt.shortmess:append("I")

local opts = { noremap = true, silent = true }

vim.keymap.set('n', 'Y', 'yy', opts)
vim.keymap.set('i', 'jk', '<esc>', opts)
vim.keymap.set('n', "'", "`", opts)
vim.keymap.set('n', "`", "'", opts)
vim.keymap.set('n', "gg", "gg0", opts)
vim.keymap.set('v', "gg", "gg0", opts)

vim.api.nvim_buf_set_keymap(0, 'n', 'k', 'gk', opts)
vim.api.nvim_buf_set_keymap(0, 'n', 'j', 'gj', opts)
vim.api.nvim_buf_set_keymap(0, 'n', '0', 'g0', opts)
vim.api.nvim_buf_set_keymap(0, 'n', '$', 'g$', opts)

vim.keymap.set('n', '<leader>n', ':NERDTreeToggle<CR>', opts)
vim.keymap.set('n', '<leader>w', ':w<CR>', opts)
vim.keymap.set('n', '<leader>x', ':x<CR>', opts)

vim.keymap.set('n', '<leader>gb', ':BlameToggle<CR>', opts)
vim.keymap.set('n', '<leader>ga', ':wa<CR>:Git add .<CR>', opts)
vim.keymap.set('n', '<leader>gc', ':Git commit<CR>', opts)
vim.keymap.set('n', '<leader>gd', ':wa<CR>:Git diff<CR>', opts)
vim.keymap.set('n', '<leader>gp', ':Git push<CR>', opts)
vim.keymap.set('n', '<leader>gl', ':Git pull<CR>', opts)
vim.keymap.set('n', '<leader>gs', ':Git status<CR>', opts)
vim.keymap.set('n', '<leader>go', ':Git log --all --oneline --graph --decorate<CR>', opts)


if vim.fn.filereadable(vim.fn.expand("~/.light")) == 1 then
  vim.o.background = "light"
end
if vim.fn.filereadable(vim.fn.expand("~/.dark")) == 1 then
  vim.o.background = "dark"
end


-- fix for colorschemes issue with NerdTree
vim.defer_fn(function()
  vim.cmd.colorscheme 'selenized'

  if vim.fn.filereadable(vim.fn.expand("~/.light")) == 1 then
    vim.cmd [[highlight Directory guifg=#006DCE]]
  end

  if vim.fn.filereadable(vim.fn.expand("~/.dark")) == 1 then
    vim.cmd [[highlight Directory guifg=#58a3ff]]
    vim.cmd [[highlight Visual guibg=#275966]]
  end
end, 1000)

vim.fn.timer_start(2000, function()
  vim.schedule(function()
    vim.cmd("NERDTreeRefreshRoot")
  end)
end, { ['repeat'] = -1 })

-- vim: ts=2 sts=2 sw=2 et
