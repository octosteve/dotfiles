packadd minpac
call minpac#init()

function! TrimWhiteSpace()
  %s/\s*$//
  ''
endfunction

" Don't fall back to vi mode
set nocompatible

" Always assume decimals when using <C-a> and <C-x>
set nrformats=

set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2

let g:mapleader=','
set number
set encoding=utf-8

set hlsearch
set incsearch
set ignorecase
set smartcase
set mouse=

" Mappings
map <F3> :call TrimWhiteSpace()<CR>
" Format file
map <F4> mzgg=G`z
inoremap jk <ESC>
inoremap jj <ESC>
inoremap kj <ESC>
inoremap kj <ESC>
inoremap kk <ESC>
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <Leader>e :e <C-R>=expand('%:p:h') . '/'<CR>
nnoremap <Leader>r :r <C-R>=expand('%:p:h') . '/'<CR>
nnoremap <Leader><space> :nohlsearch<CR>
nnoremap <Leader>f :Rg<space>
nnoremap <C-p> :<C-u>FZF<CR>
if has("nvim")
  " Make escape work in the Neovim terminal.
  tmap <C-o> <C-\><C-n>

  " Make navigation into and out of Neovim terminal splits nicer.
  tnoremap <C-h> <C-\><C-N><C-w>h
  tnoremap <C-j> <C-\><C-N><C-w>j
  tnoremap <C-k> <C-\><C-N><C-w>k
  tnoremap <C-l> <C-\><C-N><C-w>l

  " I like relative numbering when in normal mode.
  autocmd TermOpen * setlocal conceallevel=0 colorcolumn=0 relativenumber

  " Prefer Neovim terminal insert mode to normal mode.
  autocmd BufEnter term://* startinsert
endif

set title
set pastetoggle=<F2>

call minpac#add('Shougo/deoplete.nvim')
call minpac#add('sheerun/vim-polyglot')
call minpac#add('mattn/emmet-vim')
call minpac#add('roman/golden-ratio')
call minpac#add('slashmili/alchemist.vim')
call minpac#add('tomasr/molokai')
call minpac#add('tpope/vim-bundler')
call minpac#add('tpope/vim-rails')
call minpac#add('tpope/vim-sensible')
call minpac#add('tpope/vim-commentary')
call minpac#add('pangloss/vim-javascript')
call minpac#add('mxw/vim-jsx')
call minpac#add('janko-m/vim-test')
  nmap <silent> <leader>t :TestNearest<CR>
  nmap <silent> <leader>T :TestFile<CR>
  nmap <silent> <leader>a :TestSuite<CR>
  nmap <silent> <leader>l :TestLast<CR>
  nmap <silent> <leader>g :TestVisit<CR>
  let test#strategy = "neovim"
call minpac#add('MarcWeber/vim-addon-mw-utils')
call minpac#add('tomtom/tlib_vim')
call minpac#add('garbas/vim-snipmate')
call minpac#add('honza/vim-snippets')
call minpac#add('elixir-lang/vim-elixir')
call minpac#add('jremmen/vim-ripgrep')
call minpac#add('rust-lang/rust.vim')

set background=dark
set rtp+=~/.fzf
syntax enable
colorscheme molokai
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
