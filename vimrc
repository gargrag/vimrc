set nocompatible               " be iMproved
filetype off                   " required!
 
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
 
Bundle 'tpope/vim-sensible'
Bundle 'vim-scripts/ini-syntax-definition'
Bundle 'taglist.vim'
Bundle 'phpcomplete.vim'
Bundle 'jamessan/vim-gnupg'
Bundle 'jelera/vim-javascript-syntax'

"Syntax
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-markdown.git'
Bundle 'gargrag/vim-phpcolors'

"GIT
Bundle 'tpope/vim-fugitive'
Bundle 'airblade/vim-gitgutter'

"Utilities
Bundle 'Conque-Shell'
Bundle 'L9'

"File Management
Bundle 'majutsushi/tagbar'
Bundle 'scrooloose/nerdtree'
Bundle 'vim-scripts/mru.vim'
Bundle 'FuzzyFinder'

"Color themes
Bundle 'xoria256.vim'
Bundle 'desert.vim'
Bundle 'jellybeans.vim'
Bundle 'wombat256.vim'
Bundle 'cschlueter/vim-mustang'
Bundle 'godlygeek/csapprox.git'

Bundle 'flazz/vim-colorschemes'
 
filetype plugin indent on
 
" basic autocomplete Ctrl+X Ctrl+O
 
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
" autocmd FileType c set omnifunc=ccomplete#Complete
 
" drupal 
 
if has("autocmd")
	augroup module
		autocmd BufRead,BufNewFile *.module set filetype=php
		autocmd BufRead,BufNewFile *.install set filetype=php
		autocmd BufRead,BufNewFile *.test set filetype=php
		autocmd BufRead,BufNewFile *.inc set filetype=php
		autocmd BufRead,BufNewFile *.profile set filetype=php
		autocmd BufRead,BufNewFile *.view set filetype=php
		autocmd BufRead,BufNewFile *.make set filetype=ini
		autocmd BufRead,BufNewFile *.info set filetype=ini
	augroup END
	endif
 
" no error bell
set noerrorbells
set novisualbell
set tm=500

" visual
set so=7            " Set 7 lines to the curors - when moving vertical..
set ruler           "Always show current position
set hid             "Change buffer - without saving
set nohidden
	
set number
set nowrap
set ts=2
set sw=2
set background=dark
set mouse=a

set t_Co=256
let g:CSApprox_attr_map = { 'bold' : 'bold', 'italic' : '', 'sp' : '' }
colorscheme mustang

set history=1000

"read automatically when file changed from outside
set autowrite

"http://vim.wikia.com/wiki/Simplifying_regular_expressions_using_magic_and_no-magic
set magic


let php_sql_query=1                                                                                        
let php_htmlInStrings=1

" for Syntastic
let g:syntastic_auto_loc_list=1 "Auto open errors window upon detection
let g:syntastic_enable_signs=1
let g:syntastic_auto_jump=1
let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
let g:syntastic_enable_balloons=1 

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*


nmap <leader>l :set list!<CR>
set listchars=tab:▸\ ,eol:¬

" Open TagBar and NERDtree togeter
function! ToggleNERDTreeAndTagbar()
    let w:jumpbacktohere = 1

    " Detect which plugins are open
    if exists('t:NERDTreeBufName')
        let nerdtree_open = bufwinnr(t:NERDTreeBufName) != -1
    else
        let nerdtree_open = 0
    endif
    let tagbar_open = bufwinnr('__Tagbar__') != -1

    " Perform the appropriate action
    if nerdtree_open && tagbar_open
        NERDTreeClose
        TagbarClose
    elseif nerdtree_open
        TagbarOpen
    elseif tagbar_open
        NERDTree
    else
        NERDTree
        TagbarOpen
    endif

    " Jump back to the original window
    for window in range(1, winnr('$'))
        execute window . 'wincmd w'
        if exists('w:jumpbacktohere')
            unlet w:jumpbacktohere
            break
        endif
    endfor
endfunction
" now you can open NERDTree and Tagbar using F8
" http://stackoverflow.com/questions/6624043/how-to-open-or-close-nerdtree-and-tagbar-with-leader
nmap <F8> :call ToggleNERDTreeAndTagbar()<CR>

"COMMIT_EDITMSG and push to current branch
function! PushToCurrentBranch()
	  exe ":Gwrite"
		  let branch = fugitive#statusline()
			  let branch = substitute(branch, '\c\v\[?GIT\(([a-z0-9\-_\./:]+)\)\]?', $BRANCH.' \1', 'g')
				  exe ":Git push origin" . branch
				endfunction

				" Map gwp keys to call the function
nmap <F9> :call PushToCurrentBranch()<CR>



" quit nerdtree if it's the last window
function! NERDTreeQuit()
  redir => buffersoutput
  silent buffers
  redir END
"                     1BufNo  2Mods.     3File           4LineNo
  let pattern = '^\s*\(\d\+\)\(.....\) "\(.*\)"\s\+line \(\d\+\)$'
  let windowfound = 0

  for bline in split(buffersoutput, "\n")
    let m = matchlist(bline, pattern)

    if (len(m) > 0)
      if (m[2] =~ '..a..')
        let windowfound = 1
      endif
    endif
  endfor

  if (!windowfound)
    quitall
  endif
endfunction
autocmd WinEnter * call NERDTreeQuit()

