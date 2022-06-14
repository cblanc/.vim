let mapleader=","
set nocompatible
filetype plugin indent on

set number
set history=1000
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set autoread
set laststatus=2
set winwidth=79
set cmdheight=1
set lazyredraw
set ttyfast
set nobackup
set nowritebackup
set showtabline=2
set incsearch
set hlsearch
set ignorecase smartcase
set wildmenu
set wildmode=longest,list
set foldcolumn=1
set encoding=utf8
set splitbelow
set splitright

" For nvim-cmp
set completeopt=menu,menuone,noselect

" Use login shell (reads in .bash_profile)
set shell=/bin/bash\ -l

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Backspace everything
set backspace=indent,eol,start

" Creates a persistent undofile
set undofile
set undodir=~/.vim/undodir

" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

" STATUS LINE
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

" Plugin Setup Starts here ==============================
call plug#begin(has('nvim') ? '~/.vim/nvim-plugged' : '~/.vim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'

if has("nvim")
  " Easy LSP configs
  Plug 'neovim/nvim-lspconfig'

  " Treesitter
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  
  Plug 'L3MON4D3/LuaSnip'

  " Configure nvim-cmp
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'saadparwaiz1/cmp_luasnip'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/cmp-path'
  Plug 'zbirenbaum/copilot-cmp'

  Plug 'tanvirtin/monokai.nvim'
endif

call plug#end()

" Start nvim specific config =====================
if has("nvim")

lua << EOF

require('monokai').setup {}

-- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
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
      --{ name = 'vsnip' }, -- For vsnip users.
      { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

local nvim_lsp = require('lspconfig')

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "tsserver", "terraformls", "cmake", "yamlls", "dockerls", "bashls", "jsonls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

nvim_lsp.solargraph.setup {
  cmd = { "solargraph", "stdio" },
  filetypes = { "ruby" },
  flags = { debounce_text_changes = 150, },
  on_attach = on_attach,
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Disable virtual_text on file load
        -- Show with vim.lsp.diagnostic.show_line_diagnostics()
        virtual_text = false
      }
    ),
  },
}

nvim_lsp.diagnosticls.setup {
  on_attach = on_attach,
  filetypes = { 'javascript', 'javascriptreact', 'json', 'typescript', 'typescriptreact', 'css', 'less', 'scss', 'markdown', 'pandoc' },
  init_options = {
    linters = {
      eslint = {
        command = 'eslint_d',
        rootPatterns = { '.git' },
        debounce = 100,
        args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
        sourceName = 'eslint_d',
        parseJson = {
          errorsRoot = '[0].messages',
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          message = '[eslint] ${message} [${ruleId}]',
          security = 'severity'
        },
        securities = {
          [2] = 'error',
          [1] = 'warning'
        }
      },
    },
    filetypes = {
      javascript = 'eslint',
      javascriptreact = 'eslint',
      typescript = 'eslint',
      typescriptreact = 'eslint',
    },
    formatters = {
      prettier = {
        command = 'prettier',
        args = { '--stdin-filepath', '%filename' }
      }
    },
    formatFiletypes = {
      css = 'prettier',
      javascript = 'prettier',
      javascriptreact = 'prettier',
      scss = 'prettier',
      yaml = 'prettier',
      less = 'prettier',
      typescript = 'prettier',
      typescriptreact = 'prettier',
      html = 'prettier',
      eruby = 'prettier',
      json = 'prettier',
      markdown = 'prettier',
    }
  }
}

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  ensure_installed = {
    "tsx",
    "javascript",
    "toml",
    "php",
    "bash",
    "hcl",
    "json",
    "make",
    "go",
    "dockerfile",
    "jsdoc",
    "typescript",
    "regex",
    "cmake",
    "ruby",
    "yaml",
    "css",
    "html",
    "scss"
  },
}
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }

EOF
endif

" End nvim config =====================

" Colors
syntax on
colorscheme monokai_pro
set termguicolors

" NerdTree
map <C-o> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let NERDTreeIgnore = ['.DS_Store', '^.git$', '^node_modules$', '.nyc_output$', '.cache$', 'docs$', 'coverage$', '.capistrano$', 'target$', 'undodir$', '.next$']
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" GitGutter
set updatetime=500

" CtrlP
let g:ctrlp_custom_ignore = 'node_modules/\|\.DS_Store\|\.git/\|\.?tmp/\|.nyc_output/\|.cache/\|dist/\|docs/\|coverage/\|target/\|\.next/\|undodir/'
let g:ctrlp_show_hidden = 1

" Use ag with ack.vim
let g:ackprg = 'ag --nogroup --nocolor --column'
