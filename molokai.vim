
" Vim color file
"
" Author: Tomas Restrepo <tomas@winterdom.com>
"
" Note: Based on the monokai theme for textmate
" by Wimer Hazenberg and its darker variant
" by Hamish Stuart Macpherson
"

hi clear

set background=dark
if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif
let g:colors_name="molokai"

if exists("g:molokai_original")
    let s:molokai_original = g:molokai_original
else
    let s:molokai_original = 0
endif


hi Boolean         guifg=#AE81FF gui=bold
hi Character       guifg=#E6DB74 gui=bold
hi Number          guifg=#AE81FF gui=bold
hi String          guifg=#E6DB74 gui=bold
hi Conditional     guifg=#F92672               gui=bold 
hi Constant        guifg=#AE81FF               gui=bold 
hi Cursor          guifg=#000000 guibg=#F8F8F0 gui=bold
hi iCursor         guifg=#000000 guibg=#F8F8F0 gui=bold
hi Debug           guifg=#BCA3A3               gui=bold
hi Define          guifg=#66D9EF gui=bold
hi Delimiter       guifg=#8F8F8F gui=bold
hi DiffAdd                       guibg=#13354A gui=bold
hi DiffChange      guifg=#89807D guibg=#4C4745 gui=bold
hi DiffDelete      guifg=#960050 guibg=#1E0010 gui=bold
hi DiffText                      guibg=#4C4745 gui=italic,bold

hi Directory       guifg=#A6E22E               gui=bold
hi Error           guifg=#E6DB74 guibg=#1E0010 gui=bold
hi ErrorMsg        guifg=#F92672 guibg=#232526 gui=bold
hi Exception       guifg=#A6E22E               gui=bold
hi Float           guifg=#AE81FF gui=bold
hi FoldColumn      guifg=#465457 guibg=#000000 gui=bold
hi Folded          guifg=#465457 guibg=#000000 gui=bold
hi Function        guifg=#A6E22E gui=bold
hi Identifier      guifg=#FD971F gui=bold
hi Ignore          guifg=#808080 guibg=bg gui=bold
hi IncSearch       guifg=#C4BE89 guibg=#000000 gui=bold

hi Keyword         guifg=#F92672               gui=bold gui=bold
hi Label           guifg=#E6DB74               gui=bold
hi Macro           guifg=#C4BE89               gui=italic,bold
hi SpecialKey      guifg=#66D9EF               gui=italic,bold

hi MatchParen      guifg=#000000 guibg=#FD971F gui=bold
hi ModeMsg         guifg=#E6DB74 gui=bold
hi MoreMsg         guifg=#E6DB74 gui=bold
hi Operator        guifg=#F92672 gui=bold

" complete menu
hi Pmenu           guifg=#66D9EF guibg=#000000 gui=bold
hi PmenuSel                      guibg=#808080 gui=bold
hi PmenuSbar                     guibg=#080808 gui=bold
hi PmenuThumb      guifg=#66D9EF gui=bold

hi PreCondit       guifg=#A6E22E               gui=bold
hi PreProc         guifg=#A6E22E gui=bold
hi Question        guifg=#66D9EF gui=bold
hi Repeat          guifg=#F92672               gui=bold
hi Search          guifg=#FFFFFF guibg=#455354 gui=bold
" marks
hi SignColumn      guifg=#A6E22E guibg=#232526 gui=bold
hi SpecialChar     guifg=#F92672               gui=bold
hi SpecialComment  guifg=#7E8E91               gui=bold
hi Special         guifg=#66D9EF guibg=bg      gui=italic,bold
if has("spell")
    hi SpellBad    guisp=#FF0000 gui=undercurl,bold
    hi SpellCap    guisp=#7070F0 gui=undercurl,bold
    hi SpellLocal  guisp=#70F0F0 gui=undercurl,bold
    hi SpellRare   guisp=#FFFFFF gui=undercurl,bold
endif
hi Statement       guifg=#F92672               gui=bold
hi StatusLine      guifg=#455354 guibg=fg gui=bold
hi StatusLineNC    guifg=#808080 guibg=#080808 gui=bold
hi StorageClass    guifg=#FD971F               gui=italic,bold
hi Structure       guifg=#66D9EF gui=bold
hi Tag             guifg=#F92672               gui=italic,bold
hi Title           guifg=#ef5939 gui=bold
hi Todo            guifg=#FFFFFF guibg=bg      gui=bold

hi Typedef         guifg=#66D9EF gui=bold
hi Type            guifg=#66D9EF               gui=bold
hi Underlined      guifg=#808080               gui=underline,bold

hi VertSplit       guifg=#808080 guibg=#080808 gui=bold,bold
hi VisualNOS                     guibg=#403D3D gui=bold
hi Visual                        guibg=#403D3D gui=bold
hi WarningMsg      guifg=#FFFFFF guibg=#333333 gui=bold
hi WildMenu        guifg=#66D9EF guibg=#000000 gui=bold

hi TabLineFill     guifg=#1B1D1E guibg=#1B1D1E gui=bold
hi TabLine         guibg=#1B1D1E guifg=#808080 gui=bold

if s:molokai_original == 1
   hi Normal          guifg=#F8F8F2 guibg=#272822 gui=bold
   hi Comment         guifg=#75715E gui=bold
   hi CursorLine                    guibg=#3E3D32 gui=bold
   hi CursorLineNr    guifg=#FD971F               gui=bold
   hi CursorColumn                  guibg=#3E3D32 gui=bold
   hi ColorColumn                   guibg=#3B3A32 gui=bold
   hi LineNr          guifg=#BCBCBC guibg=#3B3A32 gui=bold
   hi NonText         guifg=#75715E gui=bold
   hi SpecialKey      guifg=#75715E gui=bold
else
   hi Normal          guifg=#F8F8F2 guibg=#1B1D1E gui=bold
   hi Comment         guifg=#7E8E91 gui=bold
   hi CursorLine                    guibg=#293739 gui=bold
   hi CursorLineNr    guifg=#FD971F               gui=bold
   hi CursorColumn                  guibg=#293739 gui=bold
   hi ColorColumn                   guibg=#232526 gui=bold
   hi LineNr          guifg=#465457 guibg=#232526 gui=bold
   hi NonText         guifg=#465457 gui=bold
   hi SpecialKey      guifg=#465457 gui=bold
end

"
" Support for 256-color terminal
"
if &t_Co > 255
   if s:molokai_original == 1
      hi Normal                   ctermbg=234 cterm=bold
      hi CursorLine               ctermbg=235   cterm=bold
      hi CursorLineNr ctermfg=208               cterm=bold
   else
      hi Normal       ctermfg=252 ctermbg=233 cterm=bold
      hi CursorLine               ctermbg=234   cterm=bold
      hi CursorLineNr ctermfg=208               cterm=bold
   endif
   hi Boolean         ctermfg=135 cterm=bold
   hi Character       ctermfg=144 cterm=bold
   hi Number          ctermfg=135 cterm=bold
   hi String          ctermfg=144 cterm=bold
   hi Conditional     ctermfg=161               cterm=bold
   hi Constant        ctermfg=135               cterm=bold
   hi Cursor          ctermfg=16  ctermbg=253 cterm=bold
   hi Debug           ctermfg=225               cterm=bold
   hi Define          ctermfg=81 cterm=bold
   hi Delimiter       ctermfg=241 cterm=bold

   hi DiffAdd                     ctermbg=24 cterm=bold
   hi DiffChange      ctermfg=181 ctermbg=239 cterm=bold
   hi DiffDelete      ctermfg=162 ctermbg=53 cterm=bold
   hi DiffText                    ctermbg=102 cterm=bold

   hi Directory       ctermfg=118               cterm=bold
   hi Error           ctermfg=219 ctermbg=89 cterm=bold
   hi ErrorMsg        ctermfg=199 ctermbg=16    cterm=bold
   hi Exception       ctermfg=118 ctermbg=236   cterm=bold
   hi Float           ctermfg=135 cterm=bold
   hi FoldColumn      ctermfg=67  ctermbg=16 cterm=bold
   hi Folded          ctermfg=67  ctermbg=16 cterm=bold
   hi Function        ctermfg=118 cterm=bold
   hi Identifier      ctermfg=208               cterm=bold
   hi Ignore          ctermfg=244 ctermbg=232 cterm=bold
   hi IncSearch       ctermfg=193 ctermbg=16 cterm=bold

   hi keyword         ctermfg=161               cterm=bold
   hi Label           ctermfg=229               cterm=bold
   hi Macro           ctermfg=193 cterm=bold
   hi SpecialKey      ctermfg=81 cterm=bold

   hi MatchParen      ctermfg=208  ctermbg=233 cterm=bold
   hi ModeMsg         ctermfg=229 cterm=bold
   hi MoreMsg         ctermfg=229 cterm=bold
   hi Operator        ctermfg=161 cterm=bold

   " complete menu
   hi Pmenu           ctermfg=81  ctermbg=16 cterm=bold
   hi PmenuSel        ctermfg=81  ctermbg=244 cterm=bold
   hi PmenuSbar                   ctermbg=232 cterm=bold
   hi PmenuThumb      ctermfg=81 cterm=bold

   hi PreCondit       ctermfg=118               cterm=bold
   hi PreProc         ctermfg=118 cterm=bold
   hi Question        ctermfg=81 cterm=bold
   hi Repeat          ctermfg=161               cterm=bold
   hi Search          ctermfg=253 ctermbg=66 cterm=bold

   " marks column
   hi SignColumn      ctermfg=118 ctermbg=236 cterm=bold
   hi SpecialChar     ctermfg=161               cterm=bold
   hi SpecialComment  ctermfg=245               cterm=bold
   hi Special         ctermfg=81 cterm=bold
   if has("spell")
       hi SpellBad                ctermbg=52 cterm=bold
       hi SpellCap                ctermbg=17 cterm=bold
       hi SpellLocal              ctermbg=17 cterm=bold
       hi SpellRare  ctermfg=none ctermbg=none  cterm=reverse,bold
   endif
   hi Statement       ctermfg=161               cterm=bold
   hi StatusLine      ctermfg=238 ctermbg=253 cterm=bold
   hi StatusLineNC    ctermfg=244 ctermbg=232 cterm=bold
   hi StorageClass    ctermfg=208 cterm=bold
   hi Structure       ctermfg=81 cterm=bold
   hi Tag             ctermfg=161 cterm=bold
   hi Title           ctermfg=166 cterm=bold
   hi Todo            ctermfg=231 ctermbg=232   cterm=bold

   hi Typedef         ctermfg=81 cterm=bold
   hi Type            ctermfg=81                cterm=bold
   hi Underlined      ctermfg=244               cterm=underline,bold

   hi VertSplit       ctermfg=244 ctermbg=232   cterm=bold
   hi VisualNOS                   ctermbg=238 cterm=bold
   hi Visual                      ctermbg=236 cterm=bold
   hi WarningMsg      ctermfg=231 ctermbg=238   cterm=bold
   hi WildMenu        ctermfg=81  ctermbg=16 cterm=bold

   hi Comment         ctermfg=59 cterm=bold
   hi CursorColumn                ctermbg=236 cterm=bold
   hi ColorColumn                 ctermbg=236 cterm=bold
   hi LineNr          ctermfg=250 ctermbg=236 cterm=bold
   hi NonText         ctermfg=59 cterm=bold

   hi SpecialKey      ctermfg=59 cterm=bold

   if exists("g:rehash256") && g:rehash256 == 1
       hi Normal       ctermfg=252 ctermbg=234 cterm=bold
       hi CursorLine               ctermbg=236   cterm=bold
       hi CursorLineNr ctermfg=208               cterm=bold

       hi Boolean         ctermfg=141 cterm=bold
       hi Character       ctermfg=222 cterm=bold
       hi Number          ctermfg=141 cterm=bold
       hi String          ctermfg=222 cterm=bold
       hi Conditional     ctermfg=197               cterm=bold
       hi Constant        ctermfg=141               cterm=bold

       hi DiffDelete      ctermfg=125 ctermbg=233 cterm=bold

       hi Directory       ctermfg=154               cterm=bold
       hi Error           ctermfg=222 ctermbg=233 cterm=bold
       hi Exception       ctermfg=154               cterm=bold
       hi Float           ctermfg=141 cterm=bold
       hi Function        ctermfg=154 cterm=bold
       hi Identifier      ctermfg=208 cterm=bold

       hi Keyword         ctermfg=197               cterm=bold
       hi Operator        ctermfg=197 cterm=bold
       hi PreCondit       ctermfg=154               cterm=bold
       hi PreProc         ctermfg=154 cterm=bold
       hi Repeat          ctermfg=197               cterm=bold

       hi Statement       ctermfg=197               cterm=bold
       hi Tag             ctermfg=197 cterm=bold
       hi Title           ctermfg=203 cterm=bold
       hi Visual                      ctermbg=238 cterm=bold

       hi Comment         ctermfg=244 cterm=bold
       hi LineNr          ctermfg=239 ctermbg=235 cterm=bold
       hi NonText         ctermfg=239 cterm=bold
       hi SpecialKey      ctermfg=239 cterm=bold
   endif
end
