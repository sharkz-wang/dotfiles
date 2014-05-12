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
set statusline +=%1*\ [%{&ff}]%*                            " file format
set statusline +=%1*\ [%{''.(&fenc!=''?&fenc:&enc).''}]     " encoding
set statusline +=%1*%=%5l%*                                 " current line
set statusline +=%1*/%L%*                                   " total lines
set statusline +=%1*%4v\ %*                                 " virtual column number
hi User1 ctermfg=250 ctermbg=236 cterm=bold

nnoremap <C-l> gt
nnoremap <C-h> gT

nnoremap <silent> <f2> :NERDTreeTabsToggle<CR>
nnoremap <silent> <f3> :TlistToggle<CR>
let Tlist_Use_Right_Window = 1

nnoremap <silent> <f5> :w<CR>:make<CR>

nmap <silent> <F9> :SCCompile<cr>
nmap <silent> <F10> :SCCompileRun<cr>
nnoremap <silent> <f11> :cw<CR>

map cn <esc>:cn<cr>
map cp <esc>:cp<cr>

map <expr> tb ':tabe %<CR>'.line(".").'G'.(col(".") - 1 == 0 ? '' : (col(".") - 1).'l')

nnoremap <C-s> :w<CR>
nnoremap <C-q> :q<CR>

if filereadable("./.vimrclocal")
    source .vimrclocal
endif
