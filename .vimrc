call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
call plug#end()
syntax enable

set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set expandtab

set number
set showcmd
set cursorline

filetype indent on

set lazyredraw

nnoremap j gj
nnoremap k gk

set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
colorscheme solarized

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

nnoremap <leader>n :NERDTreeFocus<CR>

