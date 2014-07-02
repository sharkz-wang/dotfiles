" Fetch vundle repo into .vim if it hasn't been installed yet
let first_time_install = 0
let vundle_readme = expand('~/.vim/bundle/vundle/README.md')

if !filereadable(vundle_readme)
	echo "Installing Vundle..\n"
	silent !mkdir -p ~/.vim/bundle
	silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
	let first_time_install = 1 
endif
" End installing vundle

" Configurations for vundle
set nocompatible              " be improved
filetype off                  " required!

set rtp+=~/.vim/bundle/vundle
call vundle#begin()

" Start loading bundles
" let Vundle manage Vundle
" required!
Plugin 'gmarik/vundle'

Plugin 'Lokaltog/vim-easymotion'
Plugin 'kshenoy/vim-signature'

Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'zhaocai/GoldenView.Vim'
Plugin 'viewdoc'

Plugin 'wolfpython/cscope_map.vim'
Plugin 'taglist.vim'
Plugin 'a.vim'

Plugin 'c9s/gsession.vim'

Plugin 'SingleCompile'

Plugin 'tpope/vim-surround'
Plugin 'michaeljsmith/vim-indent-object'

Plugin 'tpope/vim-fugitive'

"Plugin 'Valloric/YouCompleteMe'
Plugin 'Shougo/neocomplete.vim'
Plugin 'Shougo/neosnippet'
Plugin 'Rip-Rip/clang_complete'

"Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

Plugin 'ap/vim-css-color'

Plugin 'molokai'
" End loading bundles

call vundle#end()

filetype plugin indent on     " required!
"End vundle configurations

" Automatically install all loaded bundles when vundle is newly installed
if first_time_install == 1
	echo "Installing Bundles, please ignore key map error messages\n"
	:BundleInstall
endif
" End installing bundles

set number
set wildmenu

set autoindent
set smartindent

set ignorecase
set hlsearch
set incsearch

set splitright
set splitbelow

set backspace=2

set tabstop=4
set shiftwidth=4
"set expandtab

set background=dark
set t_Co=256

syntax on

" Disable auto commenting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

let g:ycm_collect_identifiers_from_tag_files = 1
let g:ycm_global_ycm_extra_conf = expand('~/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py')

colorscheme molokai
hi Normal ctermfg=252 cterm=bold

set laststatus =2
set statusline =
"set statusline +=%1*\ %t%*								" file basename
set statusline +=%1*\ %f%*								" file relative path
set statusline +=%1*\ \ %y%*							" file type
set statusline +=%1*[%{&ff},							" file format
set statusline +=%1*%{strlen(&fenc)?&fenc:'none'}]%*	" file encoding
set statusline +=%1*%m%*								" dirty flag
set statusline +=%1*%r%*								" read-only flag
set statusline +=%1*%=									" separator
set statusline +=%1*(%l,%*								" cursor row
set statusline +=%1*%c)/%L%*							" cursor column/total rows
set statusline +=%1*\ \ \ %P%*							" current row/total rows percentage
hi User1 ctermfg=250 ctermbg=236 cterm=bold

nnoremap <C-l> gt
nnoremap <C-h> gT

nnoremap k gk
nnoremap j gj

let g:goldenview__enable_default_mapping = 0
nmap <silent> <C-N>  <Plug>GoldenViewNext
nmap <silent> <C-P>  <Plug>GoldenViewPrevious

map <expr> vs 'z.:vs %<cr>:cal cursor('.line(".").', '.col(".").')<cr>z.'
map <expr> sp 'z.:sp %<cr>:cal cursor('.line(".").', '.col(".").')<cr>z.'

map <expr> sh '<C-w>h'
map <expr> sl '<C-w>l'
map <expr> sk '<C-w>k'
map <expr> sj '<C-w>j'

inoremap <M-h> <C-o>h
inoremap <M-l> <C-o>l
inoremap <M-k> <C-o>k
inoremap <M-j> <C-o>j

inoremap <M-w> <C-o>w
inoremap <M-b> <C-o>b
inoremap <M-e> <C-o>e

nnoremap <silent> <f2> :NERDTreeTabsToggle<cr>
let Tlist_Use_Right_Window = 1
nnoremap <silent> <f3> :TlistToggle<cr><C-w>b

nnoremap <silent> <f5> :w<cr>:make<cr>

nmap <silent> <F9> :SCCompile<cr>
nmap <silent> <F10> :SCCompileRun<cr>
nnoremap <silent> <f11> :cw<cr>

map cn <esc>:cn<cr>
map cp <esc>:cp<cr>

map <expr> tb ':tabe %<cr>:cal cursor('.line(".").', '.col(".").')<cr>'

nnoremap <C-s> :w<cr>
nnoremap <C-q> :q<cr>

nnoremap <C-w> :call system('ctags -R && cscope -Rkbq && (find . -name "*.h" -exec echo "-include {}" \; > .clang_complete)')<cr>

if filereadable("./.vimrclocal")
    source .vimrclocal
endif

set showtabline =2
set tabline =%!GenTabLine()

hi TabLine      ctermfg=250 ctermbg=236 cterm=bold
hi TabLineSel   ctermfg=201 ctermbg=236 cterm=bold
hi TabLineFill  ctermfg=236 

function GenTabLine()
	let result = '   '
	let curr_page = tabpagenr()

	let i = 1
	while i <= tabpagenr('$')
		let buflist = tabpagebuflist(i)
		let winnr = tabpagewinnr(i)

		let result .= ' %*'
		let result .= (i == curr_page ? '%#TabLineSel#' : '%#TabLine#')

		let file = bufname(buflist[winnr - 1])
		let file = fnamemodify(file, ':t')

		let is_mod = getbufvar(file, "&modified")
		if is_mod > 0
			let result .= '+ '
		endif

		if file == ''
			let file = '[No Name]'
		endif
		let result .= file . ' '

		let i = i + 1
	endwhile

	let result .= '%T%#TabLineFill#%='
	"let result .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
	return result
endfunction

" Shougo/neocomplete.vim setting
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  " return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
inoremap <expr><Space> pumvisible() ? neocomplete#close_popup()."\<Space>" : "\<Space>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType cpp set omnifunc=cppcomplete#Complete

" Enable omni completion.
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_overwrite_completefunc = 1
let g:neocomplete#force_omni_input_patterns.c =
	  \ '[^.[:digit:] *\t]\%(\.\|->\)\w*'
let g:neocomplete#force_omni_input_patterns.cpp =
	  \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
let g:neocomplete#force_omni_input_patterns.objc =
	  \ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)'
let g:neocomplete#force_omni_input_patterns.objcpp =
	  \ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)\|\h\w*::\w*'
let g:clang_complete_auto = 0
let g:clang_auto_select = 0
"let g:clang_use_library = 1

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
"let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
" End Shougo/neocomplete.vim setting

" Shougo/neosnippet setting
let g:neosnippet#enable_snipmate_compatibility = 1
" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
	set conceallevel=2 concealcursor=i
endif
" End Shougo/neosnippet setting
