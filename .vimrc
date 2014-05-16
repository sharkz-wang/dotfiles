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

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Start loading bundles
" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

Bundle 'Lokaltog/vim-easymotion'
Bundle 'kshenoy/vim-signature'

Bundle 'scrooloose/nerdtree'
Bundle 'jistr/vim-nerdtree-tabs'
Bundle 'taglist.vim'
Bundle 'wolfpython/cscope_map.vim'
Bundle 'SingleCompile'

Bundle 'c9s/gsession.vim'

Bundle 'tpope/vim-surround'
Bundle 'michaeljsmith/vim-indent-object'

Bundle 'tpope/vim-fugitive'

Bundle 'Valloric/YouCompleteMe'

Bundle 'ap/vim-css-color'

Bundle 'molokai'
" End loading bundles

filetype plugin indent on     " required!
"End vundle configurations

" Automatically install all loaded bundles when vundle is newly installed
if first_time_install == 1
	echo "Installing Bundles, please ignore key map error messages\n"
	:BundleInstall
endif
" End installing bundles

set nu
set ai
set ignorecase
set hlsearch
set splitright
set splitbelow
"set expandtab
set tabstop=4
set shiftwidth=4
set background=dark
set t_Co=256

syntax on

let g:ycm_collect_identifiers_from_tag_files = 1
let g:ycm_global_ycm_extra_conf = expand('~/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py')

colorscheme molokai
hi Normal ctermfg=252 cterm=bold

set showtabline=2

hi TabLine      ctermfg=250 ctermbg=236 cterm=bold
hi TabLineSel   ctermfg=201 ctermbg=236 cterm=bold
hi TabLineFill  ctermfg=236 

set laststatus =2
set statusline =
set statusline +=%1*\ %t%*								" file basename
set statusline +=%1*\ \ %y%*							" file type
set statusline +=%1*[%{&ff},							" file format
set statusline +=%1*%{strlen(&fenc)?&fenc:'none'}]%*	" file encoding
set statusline +=%1*%m%*								" dirty flag
set statusline +=%1*%r%*								" read-only flag
set statusline +=%1*%=									" separator
set statusline +=%1*(%c,%*								" cursor column
set statusline +=%1*%l)/%L%*							" cursor row/total rows
set statusline +=%1*\ \ \ %P%*							" current row/total rows percentage
hi User1 ctermfg=250 ctermbg=236 cterm=bold

nnoremap <C-l> gt
nnoremap <C-h> gT

map <expr> vs ':vs %<cr>'
map <expr> sp ':sp %<cr>'

map <expr> sh '<C-w>h'
map <expr> sl '<C-w>l'
map <expr> sk '<C-w>k'
map <expr> sj '<C-w>j'

nnoremap <silent> <f2> :NERDTreeTabsToggle<cr>
nnoremap <silent> <f3> :TlistToggle<cr><C-w>b
let Tlist_Use_Right_Window = 1

nnoremap <silent> <f5> :w<cr>:make<cr>

nmap <silent> <F9> :SCCompile<cr>
nmap <silent> <F10> :SCCompileRun<cr>
nnoremap <silent> <f11> :cw<cr>

map cn <esc>:cn<cr>
map cp <esc>:cp<cr>

map <expr> tb ':tabe %<cr>:cal cursor('.line(".").', '.col(".").')<cr>'

nnoremap <C-s> :w<cr>
nnoremap <C-q> :q<cr>

if filereadable("./.vimrclocal")
    source .vimrclocal
endif
