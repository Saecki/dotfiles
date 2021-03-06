" ============================================================
" # Editor settings
" ============================================================
set shell=/bin/bash
let mapleader = "\<space>"

" General
set number relativenumber
set linebreak
set showbreak=
set textwidth=0
set wrapmargin=0
set fillchars=vert:│

" Indentation
set autoindent
set smartindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Search
set incsearch
set ignorecase
set smartcase
set hlsearch
set showmatch
set gdefault

" Spell checking
set spelllang=en_us,de_de,es_es

" File type detection
syntax enable
filetype plugin indent on

" Completion
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect
" Avoid showing extra messages when using completion
set shortmess+=c

" Undo
set undolevels=1000
set undodir=~/.config/nvim/vimdid
set undofile

" Splits
set splitright
set splitbelow

" Miscellaneous
set updatetime=300
set cmdheight=1
set background=dark
if has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif

" # Shortcuts
" ------------------------------------------------------------

" Resize
nmap <c-left> :vertical resize -5<cr>
nmap <c-down> :resize +5<cr>
nmap <c-up> :resize -5<cr>
nmap <c-right> :vertical resize +5<cr>

" Quick save
nmap <leader>w :w<cr>

" Text navigation
nnoremap j gj
nnoremap k gk

" Ctrl+h to stop searching
vnoremap <s-h> :nohlsearch<cr>
nnoremap <s-h> :nohlsearch<cr>

" Ctrl+c copies to system clipboard
vnoremap <c-c> "+y
" Ctrl+v pastes system clipboard
inoremap <c-v> <c-r>+

" Toggle between buffers
nnoremap <leader><leader> <c-^>

" I don't need your help
map <F1> <esc>
imap <F1> <esc>


" # Colorscheme
" ------------------------------------------------------------

runtime! colors.vim


" ============================================================
" # Plugins
" ============================================================

call plug#begin()
" Gui enhancements
Plug 'vim-airline/vim-airline'
Plug '~/.config/nvim/mine-airline' " Load custom airline themes
Plug 'vim-airline/vim-airline-themes'
" Wait for 0.5.0
"Plug 'wfxr/minimap.vim', {'do': ':!cargo install --locked code-minimap'}

Plug 'machakann/vim-highlightedyank'
Plug 'preservim/nerdtree'
Plug 'mbbill/undotree'

" Fuzzy finding
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf.vim'

" Multicursor
Plug 'terryma/vim-multiple-cursors'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Semantic Language support
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'ycm-core/YouCompleteMe'

" Syntactic Language support
Plug 'rust-lang/rust.vim'
Plug 'udalov/kotlin-vim'
Plug 'igankevich/mesonic'
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'plasticboy/vim-markdown'

" Miscellaneous
Plug 'dhruvasagar/vim-table-mode'
Plug '907th/vim-auto-save'
Plug 'farmergreg/vim-lastplace'

" Browser Integration
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
call plug#end()

" ============================================================
" # Plugin config
" ============================================================

" # vim-gitgutter
" ------------------------------------------------------------
let g:gitgutter_diff_base = 'HEAD'

nmap g{ <Plug>(GitGutterPrevHunk)
nmap g} <Plug>(GitGutterNextHunk)
nmap gu <Plug>(GitGutterUndoHunk)
nmap gs <Plug>(GitGutterPreviewHunk)

" # rust.vim
" ------------------------------------------------------------
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_recommended_style = 0

" Markdown
let g:vim_markdown_folding_disabled = 1

" # nvim-compe
" ------------------------------------------------------------
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.resolve_timeout = 800
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.ultisnips = v:false
let g:compe.source.luasnip = v:false
let g:compe.source.emoji = v:false

inoremap <silent><expr> <c-space> compe#complete()
inoremap <silent><expr> <cr>      compe#confirm('<cr>')
inoremap <silent><expr> <c-e>     compe#close('<c-e>')
inoremap <silent><expr> <c-u>     compe#scroll({ 'delta': +4 }) " TODO fix
inoremap <silent><expr> <c-d>     compe#scroll({ 'delta': -4 }) " TODO fix

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" # lspconfig
" ------------------------------------------------------------

lua <<EOF
local lsp = require'lspconfig'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    }
}

lsp.rust_analyzer.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "plain",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    }
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
        signs = true,
        update_in_insert = true,
    }
)
EOF

" Show info popup
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<cr>

" Show diagnostic popup
nnoremap <C-k>      <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>

" Code actions
nnoremap <silent> <leader>a <cmd>lua vim.lsp.buf.code_action()<cr>
nnoremap <silent> <leader>r <cmd>lua vim.lsp.buf.rename()<cr>

" Goto previous/next diagnostic warning/error
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<cr>
nnoremap <silent> gy   <cmd>lua vim.lsp.buf.type_definition()<cr>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<cr>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<cr>
nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<cr>


" # lsp_extensions
" ------------------------------------------------------------

" Show inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }

" # coc.nvim
" ------------------------------------------------------------

"let g:coc_global_extensions = ['coc-rust-analyzer', 'coc-json', 'coc-git']

" Completion
"inoremap <silent><expr> <c-space> coc#refresh()

" Code action
"xmap <leader>a <Plug>(coc-codeaction-selected)
"nmap <leader>a <Plug>(coc-codeaction-selected)

" Quick fix
"nmap <leader>f <Plug>(coc-fix-current)

" GoTo Code navigation
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)
"nmap <silent> g[  <Plug>(coc-diagnostic-prev)
"nmap <silent> g]  <Plug>(coc-diagnostic-next)

" Floating window scrolling
"if has('nvim-0.4.0') || has('patch-8.2.0750')
"  nnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1, 8) : "\<C-d>"
"  nnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0, 8) : "\<C-u>"
"  inoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1, 8)\<cr>" : "\<Right>"
"  inoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0, 8)\<cr>" : "\<Left>"
"endif


" RefactorRename
"nmap <silent> <leader>r <Plug>(coc-rename)

" Documentation
"nnoremap <silent> K :call <SID>show_documentation()<cr>
"function! s:show_documentation()
"  if (index(['vim','help'], &filetype) >= 0)
"    execute 'h '.expand('<cword>')
"  else
"    call CocAction('doHover')
"  endif
"endfunction

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<c-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<c-p>" : "\<c-h>"

"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction

" Make enter select the first completion item
"inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"


" Highlight the symbol and its references when holding the cursor.
"autocmd CursorHold * silent call CocActionAsync('highlight')

" coc-git
"nmap g{ <Plug>(coc-git-prevchunk)
"nmap g} <Plug>(coc-git-nextchunk)
"nmap gs <plug>(coc-git-chunkinfo)
"nmap gu :CocCommand git.chunkUndo<cr>

" # YouCompleteMe
" ------------------------------------------------------------

" Documentation
"nnoremap <silent> K :YcmCompleter GetDoc<cr>

" GoTo Code navigation
"nmap <silent> gd :YcmCompleter GoTo
"nmap <silent> gy :YcmCompleter GoToType
"nmap <silent> gi :YcmCompleter GoToImplementation
"nmap <silent> gr :YcmCompleter GoToReference
"nmap <silent> g: <Plug>(coc-diagnostic-prev)
"nmap <silent> g. <Plug>(coc-diagnostic-next)

" RefactorRename
"nmap <silent> <leader>r :YcmCompleter RefactorRename

" # FZF
" ------------------------------------------------------------

" Search
noremap <leader>s :Rg<cr>

" Open hotkeys
map <a-p>      :Files<cr>
map <c-p>      :GFiles<cr>
nmap <leader>; :Buffers<cr>

" # Multicursor
" ------------------------------------------------------------
let g:multi_cursor_use_default_mapping = 0

let g:multi_cursor_start_word_key   = '<a-j>'
let g:multi_cursor_next_key         = '<a-j>'
let g:multi_cursor_skip_key         = '<c-a-j>'
let g:multi_cursor_prev_key         = '<a-k>'
let g:multi_cursor_quit_key         = '<esc>'

" # Undotree
" ------------------------------------------------------------

" Toggle
nnoremap <f5> :UndotreeToggle<cr>:UndotreeFocus<cr>

" # firenvim
" ------------------------------------------------------------
if exists('g:started_by_firenvim')
  set guifont=Monospace:h8
endif

