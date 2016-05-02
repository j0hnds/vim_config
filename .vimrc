execute pathogen#infect()
syntax on
filetype plugin indent on

let g:syntastic_javascript_checkers = ['standard']

au BufRead,BufNewFile *.pde,*.ino set filetype=cpp
autocmd BufNewFile,BufRead *.json set ft=javascript
autocmd BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab

" Set up the mapping where ';;' is the same as <esc>
" map! ;; <esc>
inoremap jk <esc>
inoremap ,/ </<C-X><C-O>

" Set up CtrlP
set runtimepath^=~/.vim/bundle/ctrlp.vim

" Set up VimGrep
set grepprg=grep\ -nrI\ --exclude-dir=.git\ --exclude-dir=target\ --exclude-dir=tmp\ --exclude-dir=log\ --exclude="*.min.js"\ --exclude="*.log"\ $*\ /dev/null

function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header.
  " it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" .  l:origft
endfunction
command! PrettyXML call DoPrettyXML()

