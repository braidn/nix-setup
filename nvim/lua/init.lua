local lspconfig = require("lspconfig")

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

vim.g.mapleader = ' '
map("i", "jj", "<ESC>", opt)

local cmp = require('cmp')
M.cmp_mappings = {
	['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
	['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
	['<C-Space>'] = cmp.mapping.complete(),
	['<C-d>'] = cmp.mapping.scroll_docs(-4),
	['<C-f>'] = cmp.mapping.scroll_docs(4),
	['<C-e>'] = cmp.mapping.close(),
	['<CR>'] = cmp.mapping.confirm({
		behavior = cmp.ConfirmBehavior.Insert,
		select = true,
	}),
}

-- map("n", "<Leader>ff", [[<Cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({}))<CR>]], opt)
map("n", "<Leader>pf", [[<Cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({}))<CR>]], opt)
map("n", "<Leader>pg", [[<Cmd>lua require('telescope.builtin').git_files(require('telescope.themes').get_dropdown({}))<CR>]], opt)
map("n", "<Leader>fb", [[<Cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({}))<CR>]], opt)
map("n", "<Leader>fa", [[<Cmd>lua require('telescope.builtin').live_grep(require('telescope.themes').get_dropdown({}))<CR>]], opt)
map("n", "<Leader>fq", [[<Cmd>lua require('telescope.builtin').quickfix(require('telescope.themes').get_dropdown({}))<CR>]], opt)
map("n", "<Leader>ca", [[<Cmd>lua require('telescope.builtin').lsp_code_actions(require('telescope.themes').get_cursor({}))<CR>]], opt)
map("n", "<Leader>fm", [[<Cmd>:Telescope harpoon marks<CR>]], opt)
map("n", "<Leader>am", [[<Cmd>lua require("harpoon.mark").add_file()<CR>]], opt)
map("n", "<Leader><Leader>", [[<Cmd>lua require('telescope.builtin').command_history(require('telescope.themes').get_dropdown({}))<CR>]], opt)

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
local icons = require "nvim-nonicons"
icons.get("file")
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
require('neoclip').setup({
  history = 100,
  enable_macro_history = true
})
require("telescope").load_extension('harpoon')
require('telescope').load_extension('neoclip')
require('telescope').load_extension('macroscope')
require('leap').add_default_mappings()
lspconfig.tsserver.setup{
  on_attach = function(client, bufnr)
    -- disable tsserver formatting if you plan on formatting via null-ls
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    local ts_utils = require("nvim-lsp-ts-utils")

    -- defaults
    ts_utils.setup {
      debug = false,
      disable_commands = false,
      enable_import_on_completion = false,

      -- import all
      import_all_timeout = 5000, -- ms
      -- lower numbers indicate higher priority
      import_all_priorities = {
        same_file = 1, -- add to existing import statement
        local_files = 2, -- git files or files with relative path markers
        buffer_content = 3, -- loaded buffer content
        buffers = 4, -- loaded buffer names
      },
      import_all_scan_buffers = 100,
      import_all_select_source = false,

      eslint_enable_code_actions = true,
      eslint_enable_disable_comments = true,
      eslint_bin = "eslint",
      eslint_enable_diagnostics = false,
      eslint_opts = {},

      enable_formatting = false,
      formatter = "prettierd",
      formatter_opts = {},

      update_imports_on_move = false,
      require_confirmation_on_move = false,
      watch_dir = nil,

      filter_out_diagnostics_by_severity = {},
      filter_out_diagnostics_by_code = {},

      auto_inlay_hints = true,
      inlay_hints_highlight = "Comment",
    }

    ts_utils.setup_client(client)

  end,
  capabilities = capabilities
}

require("luasnip")
require("luasnip/loaders/from_vscode").lazy_load()

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    signs = true,
    update_in_insert = false,
  }
)

vim.opt.list = true
vim.opt.listchars:append("space:⋅")

require("indent_blankline").setup {
  space_char_blankline = " ",
  indent_blankline_use_treesitter = true,
  buftype_exclude = {"terminal"}
}

local lspkind = require('lspkind').init({ preset = 'codicons' })
-- Setup nvim-cmp.
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'treesitter' },
  }, {
      { name = 'buffer' },
    })
})

require('gitsigns').setup()
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' },
  }, {
      { name = 'buffer' },
    })
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
      { name = 'cmdline' }
    })
})

local buf_map = function(bufnr, mode, lhs, rhs, opts)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or {
    silent = true,
  })
end

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  vim.api.nvim_create_user_command("LspFormat",
    function()
      vim.lsp.buf.format({ async = true })
    end
    , { bang = true, desc = 'Language Server Formatting' })
  vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
  vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
  vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
  vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
  vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
  vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
  vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
  vim.cmd("command! LspDiagPrev lua vim.diagnostic.goto_prev()")
  vim.cmd("command! LspDiagNext lua vim.diagnostic.goto_next()")
  vim.cmd("command! LspDiagList lua vim.diagnostic.setqflist()")
  vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")

  local opts = { noremap = true, silent = true }

  buf_map(bufnr, "n", ",de", ":LspDef<CR>")
  buf_map(bufnr, "n", ",fm", ":LspFormat<CR>")
  buf_map(bufnr, "n", ",rn", ":LspRename<CR>")
  buf_map(bufnr, "n", ",td", ":LspTypeDef<CR>")
  buf_map(bufnr, "n", ",h", ":LspHover<CR>")
  buf_map(bufnr, "n", "g[", ":LspDiagPrev<CR>")
  buf_map(bufnr, "n", "g]", ":LspDiagNext<CR>")
  buf_map(bufnr, "n", "ga", ":LspCodeAction<CR>")
  buf_map(bufnr, "n", ",di", ":LspDiagLine<CR>")
  buf_map(bufnr, "i", "<C-x><C-x>", "<cmd> LspSignatureHelp<CR>")

  if client.server_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
    augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]],
      false
    )
  end
end

local null_ls = require("null-ls")
local sources = {
  null_ls.builtins.diagnostics.shellcheck,
  null_ls.builtins.diagnostics.erb_lint,
  null_ls.builtins.formatting.erb_lint
}
null_ls.setup({ sources = sources, on_attach = on_attach, debug = true })
lspconfig.ruby_ls.setup{
  capabilities = capabilities
}
lspconfig.syntax_tree.setup{
  capabilities = capabilities
}
lspconfig.jsonls.setup{
  capabilities = capabilities
}
lspconfig.terraformls.setup{
  capabilities = capabilities
}
lspconfig.scry.setup{
  capabilities = capabilities
}
lspconfig.html.setup{
  capabilities = capabilities
}
lspconfig.rls.setup{
  capabilities = capabilities
}
lspconfig.zls.setup{
  capabilities = capabilities
}
lspconfig.denols.setup{autostart = false, capabilities = capabilities}
lspconfig.rome.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = { "npx", "rome", "lsp-proxy" }
}
require'lspconfig'.marksman.setup{
  capabilities = capabilities
}
require('nvim-autopairs').setup({
  disable_filetype = { 'telescopeprompt', 'vim' },
})
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done())
require('nvim_comment').setup()
require'nvim-treesitter.install'.compilers = { "clang" }
require"nvim-treesitter.configs".setup {
  ignore_install = { "haskell, phpdoc" },
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

require('lualine').setup({
  options = {
    component_separators = '',
    section_separators = '',
  }
})
local actions = require("diffview.actions")
require("diffview").setup({
  diff_binaries = false,    -- Show diffs for binaries
  enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
  git_cmd = { "git" },      -- The git executable followed by default args.
  use_icons = true,         -- Requires nvim-web-devicons
  icons = {                 -- Only applies when use_icons is true.
    folder_closed = "",
    folder_open = "",
  },
  signs = {
    fold_closed = "",
    fold_open = "",
  },
  file_panel = {
    listing_style = "tree",             -- One of 'list' or 'tree'
    tree_options = {                    -- Only applies when listing_style is 'tree'
      flatten_dirs = true,              -- Flatten dirs that only contain one single dir
      folder_statuses = "only_folded",  -- One of 'never', 'only_folded' or 'always'.
    },
    win_config = {                      -- See ':h diffview-config-win_config'
      position = "left",
      width = 35,
    },
  },
  file_history_panel = {
    log_options = {   -- See ':h diffview-config-log_options'
      single_file = {
        diff_merges = "combined",
      },
      multi_file = {
        diff_merges = "first-parent",
      },
    },
    win_config = {    -- See ':h diffview-config-win_config'
      position = "bottom",
      height = 16,
    },
  },
  commit_log_panel = {
    win_config = {},  -- See ':h diffview-config-win_config'
  },
  default_args = {    -- Default args prepended to the arg-list for the listed commands
    DiffviewOpen = {},
    DiffviewFileHistory = {},
  },
  hooks = {},         -- See ':h diffview-config-hooks'
  keymaps = {
    disable_defaults = false, -- Disable the default keymaps
    view = {
      -- The `view` bindings are active in the diff buffers, only when the current
      -- tabpage is a Diffview.
      ["<tab>"]      = actions.select_next_entry, -- Open the diff for the next file
      ["<s-tab>"]    = actions.select_prev_entry, -- Open the diff for the previous file
      ["gf"]         = actions.goto_file,         -- Open the file in a new split in the previous tabpage
      ["<C-w><C-f>"] = actions.goto_file_split,   -- Open the file in a new split
      ["<C-w>gf"]    = actions.goto_file_tab,     -- Open the file in a new tabpage
      ["<leader>e"]  = actions.focus_files,       -- Bring focus to the files panel
      ["<leader>b"]  = actions.toggle_files,      -- Toggle the files panel.
    },
    file_panel = {
      ["j"]             = actions.next_entry,         -- Bring the cursor to the next file entry
      ["<down>"]        = actions.next_entry,
      ["k"]             = actions.prev_entry,         -- Bring the cursor to the previous file entry.
      ["<up>"]          = actions.prev_entry,
      ["<cr>"]          = actions.select_entry,       -- Open the diff for the selected entry.
      ["o"]             = actions.select_entry,
      ["<2-LeftMouse>"] = actions.select_entry,
      ["-"]             = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
      ["S"]             = actions.stage_all,          -- Stage all entries.
      ["U"]             = actions.unstage_all,        -- Unstage all entries.
      ["X"]             = actions.restore_entry,      -- Restore entry to the state on the left side.
      ["R"]             = actions.refresh_files,      -- Update stats and entries in the file list.
      ["L"]             = actions.open_commit_log,    -- Open the commit log panel.
      ["<c-b>"]         = actions.scroll_view(-0.25), -- Scroll the view up
      ["<c-f>"]         = actions.scroll_view(0.25),  -- Scroll the view down
      ["<tab>"]         = actions.select_next_entry,
      ["<s-tab>"]       = actions.select_prev_entry,
      ["gf"]            = actions.goto_file,
      ["<C-w><C-f>"]    = actions.goto_file_split,
      ["<C-w>gf"]       = actions.goto_file_tab,
      ["i"]             = actions.listing_style,        -- Toggle between 'list' and 'tree' views
      ["f"]             = actions.toggle_flatten_dirs,  -- Flatten empty subdirectories in tree listing style.
      ["<leader>e"]     = actions.focus_files,
      ["<leader>b"]     = actions.toggle_files,
    },
    file_history_panel = {
      ["g!"]            = actions.options,          -- Open the option panel
      ["<C-A-d>"]       = actions.open_in_diffview, -- Open the entry under the cursor in a diffview
      ["y"]             = actions.copy_hash,        -- Copy the commit hash of the entry under the cursor
      ["L"]             = actions.open_commit_log,
      ["zR"]            = actions.open_all_folds,
      ["zM"]            = actions.close_all_folds,
      ["j"]             = actions.next_entry,
      ["<down>"]        = actions.next_entry,
      ["k"]             = actions.prev_entry,
      ["<up>"]          = actions.prev_entry,
      ["<cr>"]          = actions.select_entry,
      ["o"]             = actions.select_entry,
      ["<2-LeftMouse>"] = actions.select_entry,
      ["<c-b>"]         = actions.scroll_view(-0.25),
      ["<c-f>"]         = actions.scroll_view(0.25),
      ["<tab>"]         = actions.select_next_entry,
      ["<s-tab>"]       = actions.select_prev_entry,
      ["gf"]            = actions.goto_file,
      ["<C-w><C-f>"]    = actions.goto_file_split,
      ["<C-w>gf"]       = actions.goto_file_tab,
      ["<leader>e"]     = actions.focus_files,
      ["<leader>b"]     = actions.toggle_files,
    },
    option_panel = {
      ["<tab>"] = actions.select_entry,
      ["q"]     = actions.close,
    },
  },
})
-- /Plugins

-- Set Current Theme
vim.cmd[[colorscheme catppuccin]]

-- Set Icons
local icons = require "nvim-nonicons"
icons.get("file")
