call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'dense-analysis/ale'
Plug '~/.fzf'
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

set mouse=a

filetype indent on

set lazyredraw

nnoremap j gj
nnoremap k gk

colorscheme meta5

nnoremap <leader>! :set invnumber<CR>

let g:netrw_banner = 0

nnoremap <leader>dd :Lexplore %:p:h<CR>
nnoremap <leader>da :Lexplore<CR>

function! NetrwMapping()
  nmap <buffer> H u
  nmap <buffer> h -^
  nmap <buffer> l <CR>

  nmap <buffer> . gh
  nmap <buffer> P <C-w>z

  nmap <buffer> L <CR>:Lexplore<CR>
  nmap <buffer> <Leader>dd :Lexplore<CR>
endfunction

augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END
