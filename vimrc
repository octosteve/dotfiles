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

filetype plugin indent on
set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2
set smartindent

let g:mapleader=','
set number
set encoding=utf-8

set hlsearch
set incsearch
set ignorecase
set smartcase
set mouse=
set tags=tags

if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

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
nnoremap <C-P> :FZF<CR>
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
call minpac#add('junegunn/fzf', {'do': { -> fzf#install()}})
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
  let test#strategy = "vimterminal"
call minpac#add('tpope/vim-projectionist')
call minpac#add('tpope/vim-dispatch')
call minpac#add('asux/vim-capybara')
call minpac#add('tpope/vim-bundler')
call minpac#add('tpope/vim-rails')
call minpac#add('tpope/vim-rake')
call minpac#add('radenling/vim-dispatch-neovim')
call minpac#add('ekalinin/Dockerfile.vim')
call minpac#add('vim-crystal/vim-crystal')
  let g:crystal_auto_format = 1

call minpac#add('honza/vim-snippets')
call minpac#add('stefandtw/quickfix-reflector.vim')
call minpac#add('ziglang/zig.vim')
call minpac#add('github/copilot.vim')
call minpac#add('neoclide/coc.nvim', {'branch': 'release', 'do': 'yarn install --frozen-lockfile'})
  nnoremap <silent> <leader>co  :<C-u>CocList outline<CR>
	" Use <c-space> to trigger completion.
	if has('nvim')
		inoremap <silent><expr> <c-space> coc#refresh()
	else
		inoremap <silent><expr> <c-@> coc#refresh()
	endif

	" Make <CR> auto-select the first completion item and notify coc.nvim to
	" format on enter, <cr> could be remapped by other vim plugin
	inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
																\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

	" Use `[g` and `]g` to navigate diagnostics
	" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
	nmap <silent> [g <Plug>(coc-diagnostic-prev)
	nmap <silent> ]g <Plug>(coc-diagnostic-next)

	" GoTo code navigation.
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)
	" Use K to show documentation in preview window.
	nnoremap <silent> K :call <SID>show_documentation()<CR>

	function! s:show_documentation()
		if (index(['vim','help'], &filetype) >= 0)
			execute 'h '.expand('<cword>')
		elseif (coc#rpc#ready())
			call CocActionAsync('doHover')
		else
			execute '!' . &keywordprg . " " . expand('<cword>')
		endif
	endfunction

	" Highlight the symbol and its references when holding the cursor.
	autocmd CursorHold * silent call CocActionAsync('highlight')

	" Symbol renaming.
	nmap <leader>rn <Plug>(coc-rename)

	" Formatting selected code.
	xmap <leader>f  <Plug>(coc-format-selected)
	nmap <leader>f  <Plug>(coc-format-selected)

	augroup mygroup
		autocmd!
		" Setup formatexpr specified filetype(s).
		autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
		" Update signature help on jump placeholder.
		autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
	augroup end

	" Applying codeAction to the selected region.
	" Example: `<leader>aap` for current paragraph
	xmap <leader>a  <Plug>(coc-codeaction-selected)
	nmap <leader>a  <Plug>(coc-codeaction-selected)

	" Remap keys for applying codeAction to the current buffer.
	nmap <leader>ac  <Plug>(coc-codeaction)
	" Apply AutoFix to problem on the current line.
	nmap <leader>qf  <Plug>(coc-fix-current)

	" Map function and class text objects
	" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
	xmap if <Plug>(coc-funcobj-i)
	omap if <Plug>(coc-funcobj-i)
	xmap af <Plug>(coc-funcobj-a)
	omap af <Plug>(coc-funcobj-a)
	xmap ic <Plug>(coc-classobj-i)
	omap ic <Plug>(coc-classobj-i)
	xmap ac <Plug>(coc-classobj-a)
	omap ac <Plug>(coc-classobj-a)

	" Remap <C-f> and <C-b> for scroll float windows/popups.
	if has('nvim-0.4.0') || has('patch-8.2.0750')
		nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
		nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
		inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
		inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
		vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
		vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	endif

	" Use CTRL-S for selections ranges.
	" Requires 'textDocument/selectionRange' support of language server.
	nmap <silent> <C-s> <Plug>(coc-range-select)
	xmap <silent> <C-s> <Plug>(coc-range-select)

	" Add `:Format` command to format current buffer.
	command! -nargs=0 Format :call CocAction('format')

	" Add `:Fold` command to fold current buffer.
	command! -nargs=? Fold :call     CocAction('fold', <f-args>)

	" Add `:OR` command for organize imports of the current buffer.
	command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

	" Add (Neo)Vim's native statusline support.
	" NOTE: Please see `:h coc-status` for integrations with external plugins that
	" provide custom statusline: lightline.vim, vim-airline.
	set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

	" Mappings for CoCList
	" Show all diagnostics.
	nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
	" Manage extensions.
	nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
	" Show commands.
	nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
	" Find symbol of current document.
	nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
	" Search workspace symbols.
	nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
	" Do default action for next item.
	nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
	" Do default action for previous item.
	nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
	" Resume latest coc list.
	nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

  let g:coc_global_extensions = ['coc-solargraph']

call minpac#add('dense-analysis/ale')
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
  let g:ale_ruby_rubocop_executable = 'bin/rubocop'
  let g:ale_ruby_rubocop_auto_correct_all = 1

  let g:ale_fixers.elixir = ['mix_format']
  let g:ale_fixers.xml = ['xmllint']
  let g:ale_fix_on_save = 1

  let g:ale_sign_column_always = 1
  let g:ale_elixir_credo_strict = 1
  "
  " Required, tell ALE where to find Elixir LS
  let g:ale_elixir_elixir_ls_release = expand("~/.elixir-ls/release/language_server.sh")

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
silent! colorscheme molokai
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
command! PackUpdate call minpac#update()
command! PackClean call minpac#clean()
