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
set tags=tags

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

call minpac#add('k-takata/minpac', {'type': 'opt'})
call minpac#add('junegunn/fzf.vim')
call minpac#add('Shougo/deoplete.nvim')
call minpac#add('mattn/emmet-vim')
call minpac#add('elixir-editors/vim-elixir')
call minpac#add('roman/golden-ratio')
call minpac#add('tomasr/molokai')
call minpac#add('janko-m/vim-test')
  nmap <silent> <leader>t :TestNearest<CR>
  nmap <silent> <leader>T :TestFile<CR>
  nmap <silent> <leader>a :TestSuite<CR>
  nmap <silent> <leader>l :TestLast<CR>
  nmap <silent> <leader>g :TestVisit<CR>
  let test#strategy = "neovim"
call minpac#add('jremmen/vim-ripgrep')
call minpac#add('tpope/vim-projectionist')
call minpac#add('tpope/vim-dispatch')
call minpac#add('tpope/vim-bundler')
call minpac#add('tpope/vim-rails')
call minpac#add('tpope/vim-rake')
call minpac#add('radenling/vim-dispatch-neovim')
call minpac#add('dense-analysis/ale')
call minpac#add('ekalinin/Dockerfile.vim')
call minpac#add('vim-crystal/vim-crystal')
let g:crystal_auto_format = 1

call minpac#add('SirVer/ultisnips')
call minpac#add('honza/vim-snippets')
call minpac#add('stefandtw/quickfix-reflector.vim')
call minpac#add('neoclide/coc.nvim')
call minpac#add('amiralies/coc-elixir')
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> <leader>co  :<C-u>CocList outline<CR>
let g:coc_global_extensions = ['coc-solargraph']
call minpac#add('w0rp/ale')
let g:ale_linters = {
\ 'javascript': ['eslint'],
\ 'elixir': ['elixir-ls', 'credo'],
\ 'ruby': ['rubocop', 'ruby', 'solargraph'],
\ }


let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace']}
let g:ale_fixers.javascript = ['eslint', 'prettier']
let g:ale_fixers.html = ['prettier']
let g:ale_fixers.scss = ['stylelint']
let g:ale_fixers.css = ['stylelint']
let g:ale_fixers.ruby = ['rubocop']
let g:ale_ruby_rubocop_executable = 'bundle'
let g:ale_fixers.elixir = ['mix_format']
let g:ale_fixers.xml = ['xmllint']
let g:ale_fix_on_save = 1

let g:ale_sign_column_always = 1
let g:ale_elixir_credo_strict = 1
"
" Required, tell ALE where to find Elixir LS
let g:ale_elixir_elixir_ls_release = expand("/home/steven/Development/elixir-ls/rel")

" Optional, you can disable Dialyzer with this setting
let g:ale_elixir_elixir_ls_config = {'elixirLS': {'dialyzerEnabled': v:false}}


" Mappings in the style of unimpaired-next
nmap <silent> [W <Plug>(ale_first)
nmap <silent> [w <Plug>(ale_previous)
nmap <silent> ]w <Plug>(ale_next)
nmap <silent> ]W <Plug>(ale_last)


set background=dark
set rtp+=~/.fzf
syntax enable
colorscheme molokai
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
command! PackUpdate call minpac#update()
command! PackClean call minpac#clean()
