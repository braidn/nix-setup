-- Keymaps
local function map(mode, bind, exec, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend('force', options, opts)
	end
	vim.api.nvim_set_keymap(mode, bind, exec, opts)
end

local opt = {} --empty opt for maps with no extra options
local M = {}

vim.g.fzf_lua = {
  default_command = 'sk --ansi --preview "bat --style=numbers --color=always {} | head -n 100"'
}

require('fzf-lua')

vim.g.mapleader = ' '
map("i", "jj", "<ESC>", opt)
map("n", "<Leader>ff", [[<Cmd>:FzfLua files<CR>]], opt)
map("n", "<Leader>pg", [[<Cmd>:FzfLua git_files<CR>]], opt)
map("n", "<Leader>fb", [[<Cmd>:FzfLua buffers<CR>]], opt)
map("n", "<Leader>fa", [[<Cmd>:FzfLua live_grep<CR>]], opt)
map("n", "<Leader>fq", [[<Cmd>:FzfLua quickfix<CR>]], opt)
map("n", "<Leader>ca", [[<Cmd>:FzfLua lsp_code_actions<CR>]], opt)
map("n", "<Leader><Leader>", [[<Cmd>:FzfLua command_history<CR>]], opt)
map("n", "<Leader>cl", [[<Cmd>:let @+ = expand('%:p')<CR>]], opt)
map("n", "<Leader>cb", [[<Cmd>:lua require('neoclip.fzf')('a')<CR>]], opt)

-- /Keymaps

-- Options
local cmd = vim.cmd
local opt = vim.opt
local g = vim.g
local o = vim.o

cmd('syntax on') 	-- syntax highlighting
o.rnu = true         	-- relative line numbers
o.nu = true         	-- line numbers
o.modeline = true   	-- modline
o.modelines = 5

o.errorbells = false 	-- auditory stimulation annoying

opt.ruler = false
opt.hidden = true 		-- keeps buffers loaded in the background
opt.ignorecase = true
opt.scrolloff = 8   	-- buffer starts scrolling 8 lines from the end of view

-- Tab settings
o.tabstop = 2 			-- 4 tabstop
o.shiftwidth = 2
o.expandtab = true    	-- tabs -> spaces
o.smartindent = true    -- nice indenting

o.foldmethod = 'marker' 	-- set fold method to marker

-- backup/swap files
opt.swapfile = false  	-- have files saved to swap
opt.undofile = true		-- file undo history preserved outside current session
opt.wrap = false -- Nowrap

-- new win split options
opt.splitbelow = true
opt.splitright = true
o.completeopt = 'menuone,noselect'

opt.termguicolors = true

-- Netrw
g.netrw_banner = 0
g.netrw_browse_split = 4
g.netrw_altv = 1
g.netrw_winsize = 25
g.netrw_liststyle=3
g.netrw_chgwin=2
g.netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
g.netrw_localrmdir='rm -r'
g.python3_host_prog='~/.pyenv/shims/python3'
g.loaded_perl_provider = 0

-- /Options

-- Plugins
require("nvim-web-devicons").setup{ default = true }
require('neoclip').setup({
  history = 100,
  enable_macro_history = true
})
require('leap').add_default_mappings()

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    signs = true,
    update_in_insert = false,
  }
)

vim.opt.list = true
vim.opt.listchars:append("space:⋅")

require('ibl').setup({
  whitespace = {
    remove_blankline_trail = true
  },
  exclude = {
    filetypes = {
      "lspinfo",
      "packer",
      "checkhealth",
      "help",
      "man",
      "",
    }    
  },
  scope = {
    enabled = true,
    highlight = { "SpecialKey", "SpecialKey", "SpecialKey" },
    show_start = false
  }
})

local gen_loader = require('mini.snippets').gen_loader
require('mini.snippets').setup({
  snippets = {
    -- Load custom file with global snippets first (adjust for Windows)
    gen_loader.from_file('~/.config/nvim/snippets/global.json'),

    -- Load snippets based on current language by reading files from
    -- "snippets/" subdirectories from 'runtimepath' directories.
    gen_loader.from_lang(),
  },
})

local lspkind = require('lspkind')

require("blink-cmp").setup({
    keymap = { preset = "default" },
    appearance = {
      nerd_font_variant = "mono"
    },
    sources = {
        default = {'lsp', 'path', 'snippets', 'buffer', 'copilot'},
        per_filetype = { },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
        }
    },
    snippets = { preset = 'mini_snippets' },
    signature = { enabled = true }
})

require("copilot").setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})

require("codecompanion").setup({
  strategies = {
    inline = {
      adapter = "copilot",
      keymaps = {
        accept_change = {
          modes = { n = "ga" },
          description = "Accept the suggested change",
        },
        reject_change = {
          modes = { n = "gr" },
          description = "Reject the suggested change",
        },
      },
    },
  },
})

require("aerial").setup()

require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map('n', '<leader>hs', gs.stage_hunk)
    map('n', '<leader>hr', gs.reset_hunk)
    map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'si', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', 'td', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'di', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', 'dq', vim.diagnostic.setloclist, opts)
    vim.keymap.set('n', 'rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'ft', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

vim.lsp.enable('ts_ls')
vim.lsp.enable('syntax_tree')
vim.lsp.enable('ruby_lsp')
vim.lsp.enable('standardrb')
vim.lsp.enable('jsonls')
vim.lsp.enable('html')
vim.lsp.enable('gopls')
vim.lsp.enable('zls')
vim.lsp.enable('vale_ls')
vim.lsp.enable('astro')
vim.lsp.enable('marksman')
require('nvim-autopairs').setup({
  disable_filetype = { 'telescopeprompt', 'vim' },
})

require('nvim_comment').setup()
require"nvim-treesitter.configs".setup {
  autotag = {
    enable = true
  },
  highlight = {
    enable = true
  },
  indent = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  },
  matchup = {
    enable = true,
  },
  context_commentstring = {
    enable = true
  }
}
require('mini.git').setup()
require('mini.statusline').setup()
-- /Plugins

require('kanso').setup({
    theme = "zen",              -- Load "zen" theme
})
-- Set Current Theme
vim.cmd[[colorscheme kanso]]
