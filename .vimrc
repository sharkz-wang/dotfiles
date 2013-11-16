set nu
set ai
set ignorecase
set hlsearch
set expandtab
set tabstop=4
set shiftwidth=4
set background=dark

syntax on

hi Normal ctermfg=White cterm=bold
hi Comment cterm=bold
hi Constant cterm=bold
hi Identifier cterm=bold
hi Statement cterm=bold
hi PreProc ctermfg=Cyan cterm=bold
hi Type cterm=bold
hi Special cterm=bold
hi Underlined cterm=bold
hi Error cterm=bold

set showtabline=2

hi TabLine      ctermfg=White cterm=bold
hi TabLineSel   ctermfg=Magenta cterm=bold
hi TabLineFill  cterm=none

set laststatus=2
set statusline=
set statusline +=%1*\ [%{&ff}]%*                            "file format
set statusline +=%1*\ [%{''.(&fenc!=''?&fenc:&enc).''}]     "Encoding
set statusline +=%1*%=%5l%*                                 "current line
set statusline +=%1*/%L%*                                   "total lines
set statusline +=%1*%4v\ %*                                 "virtual column number
hi User1 ctermfg=White ctermbg=none

nnoremap <C-l> gt<CR>
nnoremap <C-h> gT<CR>

nnoremap <silent> <f1> :NERDTreeToggle<CR>

nnoremap <silent> <f2> :TlistToggle<CR>
let Tlist_Use_Right_Window  = 1

nnoremap <silent> <f5> :w<CR>:make<CR>
nnoremap <silent> <f6> :w<CR>:sh<CR>
nnoremap <silent> <f10> :copen<CR>

nnoremap <C-s> :w<CR>
nnoremap <C-q> :q<CR>

if filereadable("./.vimrclocal")
    source .vimrclocal
endif
