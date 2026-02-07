vim.g.mapleader = ','

vim.g.have_nerd_font = false

vim.o.number = true
vim.o.mouse = 'a'
vim.o.showmode = false

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = false
vim.o.undofile = false
vim.o.ignorecase = true
vim.o.signcolumn = 'auto'
vim.o.updatetime = 250
vim.o.timeoutlen = 1000
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = false
vim.o.inccommand = 'nosplit'

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.o.cursorline = true
vim.o.scrolloff = 5
vim.o.sidescrolloff = 5

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
      vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '' })
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '' })
      vim.keymap.set('n', '<leader>fG', function()
        builtin.live_grep { prompt_title = "Grep (regex)"}
      end)
      vim.keymap.set('n', '<leader>fz', builtin.current_buffer_fuzzy_find, { desc = '' })
      vim.keymap.set('n', '<leader>fs', builtin.grep_string, { desc = '' })

      vim.keymap.set('n', '<leader>fb', builtin.git_branches, { desc = '' })
      vim.keymap.set('n', '<leader>fc', builtin.git_commits, { desc = '' })

      vim.keymap.set('n', '<leader>fg', function()
        require('telescope.builtin').grep_string {
          search = '',
          only_sort_text = true,
          use_regex = false,
          prompt_title = "Grep (fzf)"
        }

      end)
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
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
        { "<leader>l", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
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

vim.keymap.set('n', '<leader>n', ':Neotree toggle<CR>', opts)
vim.keymap.set('n', '<leader>Nf', ':Neotree reveal<CR>', opts)

vim.keymap.set('n', '<leader>w', ':w<CR>', opts)
vim.keymap.set('n', '<leader>x', ':x<CR>', opts)
vim.keymap.set('n', '<leader>q', ':qa!<CR>', opts)

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
  vim.cmd [[highlight NeoTreeTitleBar guifg=#ffffff]]
  vim.cmd [[highlight NeoTreeDirectoryName guifg=#58a3ff]]
  vim.cmd [[highlight NeoTreeDirectoryIcon guifg=#58a3ff]]
end, 1000)




require("neo-tree").setup({
  close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
  popup_border_style = "NC", -- or "" to use 'winborder' on Neovim v0.11+
  clipboard = {
    sync = "none", -- or "global"/"universal" to share a clipboard for each/all Neovim instance(s), respectively
  },
  enable_git_status = true,
  enable_diagnostics = true,
  open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
  open_files_using_relative_paths = false,
  sort_case_insensitive = false, -- used when sorting files and directories in the tree
  sort_function = nil, -- use a custom function for sorting files and directories in the tree
  -- sort_function = function (a,b)
  --       if a.type == b.type then
  --           return a.path > b.path
  --       else
  --           return a.type > b.type
  --       end
  --   end , -- this sorts files and directories descendantly
  default_component_configs = {
    container = {
      enable_character_fade = true,
    },
    indent = {
      indent_size = 1,
      padding = 1, -- extra padding on left hand side
      -- indent guides
      with_markers = false,
      indent_marker = "│",
      last_indent_marker = "└",
      highlight = "NeoTreeIndentMarker",
      -- expander config, needed for nesting files
      with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
    icon = {
      folder_closed = "▸",
      folder_open = "▾",
      folder_empty = "▸",
      provider = function(icon, node, state) -- default icon provider utilizes nvim-web-devicons if available
        if node.type == "file" or node.type == "terminal" then
          local success, web_devicons = pcall(require, "nvim-web-devicons")
          local name = node.type == "terminal" and "terminal" or node.name
          if success then
            local devicon, hl = web_devicons.get_icon(name)
            icon.text = devicon or icon.text
            icon.highlight = hl or icon.highlight
          end
        end
      end,
      -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
      -- then these will never be used.
      default = " ",
      highlight = "NeoTreeFileIcon",
      use_filtered_colors = true, -- Whether to use a different highlight when the file is filtered (hidden, dotfile, etc.).
    },
    modified = {
      symbol = "",
      highlight = "NeoTreeModified",
    },
    name = {
      trailing_slash = false,
      use_filtered_colors = true, -- Whether to use a different highlight when the file is filtered (hidden, dotfile, etc.).
      use_git_status_colors = true,
      highlight = "NeoTreeFileName",
    },
    git_status = {
      symbols = {
        -- Change type
        added = "", -- or "✚"
        modified = "", -- or ""
        deleted = "", -- this can only be used in the git_status source
        renamed = "", -- this can only be used in the git_status source
        -- Status type
        untracked = "",
        ignored = "",
        unstaged = "",
        staged = "",
        conflict = "",
      },
    },
    -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
    file_size = {
      enabled = true,
      width = 12, -- width of the column
      required_width = 64, -- min width of window required to show this column
    },
    type = {
      enabled = true,
      width = 10, -- width of the column
      required_width = 122, -- min width of window required to show this column
    },
    last_modified = {
      enabled = true,
      width = 20, -- width of the column
      required_width = 88, -- min width of window required to show this column
    },
    created = {
      enabled = true,
      width = 20, -- width of the column
      required_width = 110, -- min width of window required to show this column
    },
    symlink_target = {
      enabled = false,
    },
  },
  -- A list of functions, each representing a global custom command
  -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
  -- see `:h neo-tree-custom-commands-global`
  commands = {},
  window = {
    position = "left",
    width = 40,
    mapping_options = {
      noremap = true,
      nowait = true,
    },
    mappings = {
      ["<space>"] = {
        "toggle_node",
        nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
      },
      ["<2-LeftMouse>"] = "open",
      ["go"] = "open_nofocus",
      ["<esc>"] = "cancel", -- close preview or floating neo-tree window
      ["P"] = {
        "toggle_preview",
        config = {
          use_float = true,
          use_snacks_image = true,
          use_image_nvim = true,
        },
      },
      -- Read `# Preview Mode` for more information
      ["l"] = "focus_preview",
      ["S"] = "open_split",
      ["s"] = "open_vsplit",
      -- ["S"] = "split_with_window_picker",
      -- ["s"] = "vsplit_with_window_picker",
      ["t"] = "open_tabnew",
      -- ["<cr>"] = "open_drop",
      -- ["t"] = "open_tab_drop",
      ["w"] = "open_with_window_picker",
      --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
      ["C"] = "close_node",
      -- ['C'] = 'close_all_subnodes',
      ["z"] = "close_all_nodes",
      --["Z"] = "expand_all_nodes",
      --["Z"] = "expand_all_subnodes",
      ["a"] = {
        "add",
        -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
        -- some commands may take optional config options, see `:h neo-tree-mappings` for details
        config = {
          show_path = "none", -- "none", "relative", "absolute"
        },
      },
      ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
      ["d"] = "delete",
      ["r"] = "rename",
      ["b"] = "rename_basename",
      ["y"] = "copy_to_clipboard",
      ["x"] = "cut_to_clipboard",
      ["p"] = "paste_from_clipboard",
      ["<C-r>"] = "noop",
      ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
      -- ["c"] = {
      --  "copy",
      --  config = {
      --    show_path = "none" -- "none", "relative", "absolute"
      --  }
      --}
      ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
      ["q"] = "close_window",
      ["R"] = "refresh",
      ["?"] = "show_help",
      ["<"] = "prev_source",
      [">"] = "next_source",
      ["i"] = "show_file_details",
      -- ["i"] = {
      --   "show_file_details",
      --   -- format strings of the timestamps shown for date created and last modified (see `:h os.date()`)
      --   -- both options accept a string or a function that takes in the date in seconds and returns a string to display
      --   -- config = {
      --   --   created_format = "%Y-%m-%d %I:%M %p",
      --   --   modified_format = "relative", -- equivalent to the line below
      --   --   modified_format = function(seconds) return require('neo-tree.utils').relative_date(seconds) end
      --   -- }
      -- },
    },
  },
  nesting_rules = {},
  filesystem = {
    filtered_items = {
      show_hidden_count = false,
      visible = false, -- when true, they will just be displayed differently than normal items
      hide_dotfiles = true,
      hide_gitignored = true,
      hide_ignored = true, -- hide files that are ignored by other gitignore-like files
      -- other gitignore-like files, in descending order of precedence.
      ignore_files = {
        ".neotreeignore",
        ".ignore",
        -- ".rgignore"
      },
      hide_hidden = true, -- only works on Windows for hidden files/directories
      hide_by_name = {
        --"node_modules"
      },
      hide_by_pattern = { -- uses glob style patterns
        --"*.meta",
        --"*/src/*/tsconfig.json",
      },
      always_show = { -- remains visible even if other settings would normally hide it
        --".gitignored",
      },
      always_show_by_pattern = { -- uses glob style patterns
        --".env*",
      },
      never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
        --".DS_Store",
        --"thumbs.db"
      },
      never_show_by_pattern = { -- uses glob style patterns
        --".null-ls_*",
      },
    },
    follow_current_file = {
      enabled = false, -- This will find and focus the file in the active buffer every time
      --               -- the current file is changed while the tree is open.
      leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
    },
    group_empty_dirs = false, -- when true, empty folders will be grouped together
    hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
    -- in whatever position is specified in window.position
    -- "open_current",  -- netrw disabled, opening a directory opens within the
    -- window like netrw would, regardless of window.position
    -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
    use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
    -- instead of relying on nvim autocmd events.
    window = {
      mappings = {
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
        ["H"] = "toggle_hidden",
        ["/"] = "fuzzy_finder",
        ["D"] = "fuzzy_finder_directory",
        ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
        -- ["D"] = "fuzzy_sorter_directory",
        ["f"] = "filter_on_submit",
        ["<c-x>"] = "clear_filter",
        ["[g"] = "prev_git_modified",
        ["]g"] = "next_git_modified",
        ["o"] = "open",
        ["oc"] = "noop",
        ["od"] = "noop",
        ["og"] = "noop",
        ["om"] = "noop",
        ["on"] = "noop",
        ["os"] = "noop",
        ["ot"] = "noop",
        -- ['<key>'] = function(state) ... end,
      },
      fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
        ["<down>"] = "move_cursor_down",
        ["<C-n>"] = "move_cursor_down",
        ["<up>"] = "move_cursor_up",
        ["<C-p>"] = "move_cursor_up",
        ["<esc>"] = "close",
        ["<S-CR>"] = "close_keep_filter",
        ["<C-CR>"] = "close_clear_filter",
        ["<C-w>"] = { "<C-S-w>", raw = true },
        {
          -- normal mode mappings
          n = {
            ["j"] = "move_cursor_down",
            ["k"] = "move_cursor_up",
            ["<S-CR>"] = "close_keep_filter",
            ["<C-CR>"] = "close_clear_filter",
            ["<esc>"] = "close",
          }
        }
        -- ["<esc>"] = "noop", -- if you want to use normal mode
        -- ["key"] = function(state, scroll_padding) ... end,
      },
    },

    commands = {
        open_nofocus = function(state)
          require("neo-tree.sources.filesystem.commands").open(state)
          vim.schedule(function()
            vim.cmd([[Neotree focus]])
          end)
        end,
      },
  },
  buffers = {
    follow_current_file = {
      enabled = true, -- This will find and focus the file in the active buffer every time
      --              -- the current file is changed while the tree is open.
      leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
    },
    group_empty_dirs = true, -- when true, empty folders will be grouped together
    show_unloaded = true,
    window = {
      mappings = {
        ["d"] = "buffer_delete",
        ["bd"] = "buffer_delete",
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
        ["o"] = "noop",
        ["oc"] = "noop",
        ["od"] = "noop",
        ["om"] = "noop",
        ["on"] = "noop",
        ["os"] = "noop",
        ["ot"] = "noop",
      },
    },
  },
  git_status = {
    window = {
      position = "float",
      mappings = {
        ["A"] = "git_add_all",
        ["gu"] = "git_unstage_file",
        ["gU"] = "git_undo_last_commit",
        ["ga"] = "git_add_file",
        ["gr"] = "git_revert_file",
        ["gc"] = "git_commit",
        ["gp"] = "git_push",
        ["gg"] = "git_commit_and_push",
        ["o"] = "noop",
        ["oc"] = "noop",
        ["od"] = "noop",
        ["om"] = "noop",
        ["on"] = "noop",
        ["os"] = "noop",
        ["ot"] = "noop",
      },
    },
  },
})


-- vim: ts=2 sts=2 sw=2 et
-- -- Enable autoread and set up checking triggers
vim.o.autoread = true
vim.go.autoread = true
vim.api.nvim_create_autocmd("FocusGained", {
  desc = "Reload files from disk when we focus vim",
  pattern = "*",
  command = "if getcmdwintype() == '' | checktime | endif",
  group = aug,
})
vim.api.nvim_create_autocmd({"BufEnter", "CursorHold", "CursorHoldI", "FocusGained"},  {
  desc = "Every time we enter an unmodified buffer, check if it changed on disk",
  pattern = "*",
  command = "if &buftype == '' && !&modified && expand('%') != '' | exec 'checktime ' . expand('<abuf>') | endif",
  group = aug,
})
