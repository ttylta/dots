call plug#begin()
Plug 'dylanaraps/wal.vim'
Plug 'tpope/vim-vinegar'
Plug 'w0rp/ale'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'Yggdroot/indentLine'
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx', 'html', 'vue'] }
Plug 'dylanaraps/root.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'leafgarland/typescript-vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/denite.nvim'
Plug 'kshenoy/vim-signature'
Plug 'posva/vim-vue'
call plug#end()

syntax enable
set noswapfile
set nowrap
colorscheme wal


set laststatus=0
set noshowmode
set noshowcmd
set noruler
set tabstop=2 shiftwidth=2 expandtab
set autoindent

set clipboard=unnamedplus

set hidden

hi CursorLine   cterm=NONE ctermbg=NONE ctermfg=NONE
hi VertSplit	cterm=NONE ctermbg=NONE ctermfg=NONE
hi TabLineFill cterm=none ctermfg=cyan  ctermbg=none
hi TabLine     cterm=none ctermfg=cyan ctermbg=none
hi TabLineSel  cterm=none ctermfg=black ctermbg=cyan

" ale

let g:ale_sign_column_always = 1
let g:ale_sign_error = '∙ '
let g:ale_sign_warning = '! '
let g:ale_set_highlights = 0

highlight ALEErrorSign ctermfg=yellow
highlight ALEWarningSign ctermfg=blue


" deoplete

let g:deoplete#enable_at_startup = 1

function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#manual_complete()

" indent line

let g:indentLine_leadingSpaceEnabled = 1
let g:indentLine_leadingSpaceChar = '·'

set autochdir

let g:nvim_typescript#vue_support = 1
autocmd BufNewFile,BufRead *.vue set filetype=vue

" Ensures TMUX input characters are correct.

if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
else
    let &t_SI = "\e[5 q"
    let &t_EI = "\e[2 q"
endif
