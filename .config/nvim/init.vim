" ============================================================
" # Editor settings
" ============================================================

set shell=/bin/bash
let mapleader = "\<space>"

" Visuals
set signcolumn=yes
set number relativenumber
set linebreak
let &showbreak = '⮡   '
set wrap
set textwidth=0
set wrapmargin=0
set fillchars=vert:│
set cmdheight=1
set background=dark

" Indentation
set autoindent
set smartindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Search
set incsearch
set inccommand=nosplit
set ignorecase
set smartcase
set hlsearch
set showmatch
set gdefault

" Completion
set completeopt=menuone,noinsert
set shortmess+=c

" Splits
set splitright
set splitbelow

" Undo
set undolevels=1000
set undodir=~/.local/share/nvim/undo
set undofile

" Spell checking
set spelllang=en,de,es,nl

" Miscellaneous
set updatetime=300
set mouse=a


" ============================================================
" # Key mappings
" ============================================================

" Text navigation
nnoremap j gj
nnoremap k gk

" Resize
nmap <silent> <c-left>  <cmd>vertical resize -5<cr>
nmap <silent> <c-down>  <cmd>resize          +5<cr>
nmap <silent> <c-up>    <cmd>resize          -5<cr>
nmap <silent> <c-right> <cmd>vertical resize +5<cr>

" Quick save
nmap <silent> <leader>w <cmd>w<cr>

" stop searching
vnoremap <silent> <s-h> <cmd>nohlsearch<cr>
nnoremap <silent> <s-h> <cmd>nohlsearch<cr>

" Copy paste
vnoremap <c-c> "+y
inoremap <c-v> <c-r>+

" Toggle between buffers
nnoremap <leader><leader> <c-^>

" I don't need your help
map <F1> <esc>
imap <F1> <esc>

" Highlight trailing whitespace
let g:matchtrailingwhitespace = 0
function ToggleTrailingWhitespace()
    if g:matchtrailingwhitespace == 0
        let g:matchtrailingwhitespace = 1
    else
        let g:matchtrailingwhitespace = 0
    endif
    call HighlightTrailingWhitespace()
endfunction

function HighlightTrailingWhitespace()
    if g:matchtrailingwhitespace == 1
        let w:trailingwhitespaceid = matchadd('Error', '\s\+$')
    else
        call matchdelete(w:trailingwhitespaceid)
    endif
endfunction
autocmd WinEnter * silent! call HighlightTrailingWhitespace()

nnoremap <silent> <leader>h <cmd>call ToggleTrailingWhitespace()<cr>

" Highlight yanked text
autocmd TextYankPost * silent! lua vim.highlight.on_yank { timeout = 250 }


" ============================================================
" # Plugins
" ============================================================

call plug#begin()
" Gui enhancements
Plug 'hoob3rt/lualine.nvim'

" Utilities
Plug 'preservim/nerdtree'
Plug 'mbbill/undotree'

" Fuzzy finding
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf.vim'

" Multicursor
Plug 'terryma/vim-multiple-cursors'

" Git
Plug 'tpope/vim-fugitive'
Plug 'nvim-lua/plenary.nvim' " Dependency for gitsigns
Plug 'lewis6991/gitsigns.nvim'

" Lsp
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'
Plug 'folke/trouble.nvim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-treesitter/playground'
Plug 'romgrk/nvim-treesitter-context'

" Language tools
Plug 'teal-language/vim-teal'
Plug 'rust-lang/rust.vim'
Plug 'dhruvasagar/vim-table-mode'

" Miscellaneous
Plug 'farmergreg/vim-lastplace'
Plug '907th/vim-auto-save'

" Discord rich presence
Plug 'andweeb/presence.nvim'

" Browser Integration
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
call plug#end()


" ============================================================
" # Colors
" ============================================================

lua require('colors').apply()


" ============================================================
" # Plugin config
" ============================================================

" # rust.vim
" ------------------------------------------------------------
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_recommended_style = 0

" # trouble.nvim
" ------------------------------------------------------------
lua << EOF
    require('trouble').setup {
        position = "right",
        icons = false,
        fold_open = "▼",
        fold_closed = "▶",
        use_lsp_diagnostic_signs = true,
    }
EOF

" Toggle
nnoremap <silent> <f7> <cmd>TroubleToggle<cr>

" # gitsigns.nvim
" ------------------------------------------------------------
lua require('config.gitsigns').setup()

" # nvim-compe
" ------------------------------------------------------------
lua require('config.compe').setup()

" # lspconfig
" ------------------------------------------------------------
lua require('config.lsp').setup()

" Diagnostics
sign define LspDiagnosticsSignError       text=  texthl=LspDiagnosticsSignError       linehl= numhl=
sign define LspDiagnosticsSignWarning     text=  texthl=LspDiagnosticsSignWarning     linehl= numhl=
sign define LspDiagnosticsSignHint        text=H  texthl=LspDiagnosticsSignHint        linehl= numhl=
sign define LspDiagnosticsSignInformation text=I  texthl=LspDiagnosticsSignInformation linehl= numhl=

" Highlight occurences
autocmd CursorHold  * silent lua vim.lsp.buf.document_highlight()
autocmd CursorMoved * silent lua vim.lsp.buf.clear_references()

" Show info popup
nnoremap <silent> K <cmd>call <SID>show_documentation()<cr>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    lua vim.lsp.buf.hover()
  endif
endfunction

" Show diagnostic popup
nnoremap <silent> <c-k> <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>

" Code actions
nnoremap <silent> <leader>a <cmd>lua vim.lsp.buf.code_action()<cr>
nnoremap <silent> <leader>r <cmd>lua vim.lsp.buf.rename()<cr>

" Goto actions
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<cr>
nnoremap <silent> gy <cmd>lua vim.lsp.buf.type_definition()<cr>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<cr>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<cr>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<cr>
nnoremap <silent> gw <cmd>lua vim.lsp.buf.document_symbol()<cr>
nnoremap <silent> gW <cmd>lua vim.lsp.buf.workspace_symbol()<cr>
nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<cr>

" signature help
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<cr>

" # lsp_extensions
" ------------------------------------------------------------

" Show inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require('lsp_extensions').inlay_hints{ prefix = '', highlight = "NonText", enabled = {"TypeHint", "ChainingHint"} }

" # nvim-treesitter
" ------------------------------------------------------------
lua require('config.treesitter').setup()

nnoremap <leader>c <cmd>TSContextToggle<cr>
autocmd CursorMoved * silent TSContextDisable

" # fzf.vim
" ------------------------------------------------------------
let g:fzf_layout = { 'window' : { 'width': 0.98, 'height': 0.8, 'highlight': 'Normal' } }
let g:fzf_preview_window = ['right:50%', 'ctrl-/']

" Search
noremap <silent> <leader>s <cmd>Rg<cr>

" Open hotkeys
map  <silent> <a-p>     <cmd>Files<cr>
map  <silent> <c-p>     <cmd>GFiles<cr>
nmap <silent> <leader>; <cmd>Buffers<cr>

" # vim-multiple-cursors
" ------------------------------------------------------------
let g:multi_cursor_use_default_mapping = 0

let g:multi_cursor_start_word_key   = '<a-j>'
let g:multi_cursor_next_key         = '<a-j>'
let g:multi_cursor_skip_key         = '<c-a-j>'
let g:multi_cursor_prev_key         = '<a-k>'
let g:multi_cursor_quit_key         = '<esc>'

" # nerdtree
" ------------------------------------------------------------

" Toggle
nnoremap <silent> <f6> <cmd>NERDTreeToggle<cr>

" # undotree
" ------------------------------------------------------------

" Toggle
nnoremap <silent> <f5> <cmd>UndotreeToggle<cr><cmd>UndotreeFocus<cr>

" # firenvim
" ------------------------------------------------------------
let g:firenvim_config = {
    \ 'globalSettings': {
        \ 'alt': 'all',
    \  },
    \ 'localSettings': {
        \ '.*': {
            \ 'cmdline': 'neovim',
            \ 'content': 'text',
            \ 'priority': 0,
            \ 'selector': 'textarea',
            \ 'takeover': 'never',
        \ },
    \ }
\ }

if exists('g:started_by_firenvim')
  set guifont=Monospace:h8
endif

