" vim, not vi, ignore quirks
set nocompatible

" move cursor freely
set virtualedit=all

" Handling lhs line numbers (on, relative except while editing)
set cursorline
set number
set relativenumber
autocmd FocusLost * :set nornu
autocmd FocusGained * :set relativenumber
autocmd InsertEnter * :set nornu
autocmd InsertLeave * :set relativenumber

" enabling syntax highlighting
syntax on

" 4 except for puppet dev
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
au BufNewFile,BufRead *.pp,*.rb set tabstop=2
au BufNewFile,BufRead *.pp,*.rb set shiftwidth=2
au BufNewFile,BufRead *.pp,*.rb set softtabstop=2

" tab indent in visual mode
vmap <tab> >gv
vmap <s-tab> <gv

" theme: solarized, dark by default
set background=dark
let g:solarized_termcolors=256
let g:solarized_hitrail=0
colorscheme solarized
hi CursorLineNr ctermfg=239 ctermbg=235 guifg=Yellow
hi CursorLineNr ctermfg=254 ctermbg=245 guifg=Yellow
hi SignColumn ctermbg=234 guibg=Yellow
hi ChangesSignTextAdd ctermbg=119 ctermfg=gray
hi ChangesSignTextCh ctermbg=33 ctermfg=white
set colorcolumn=72,80

" smart search choices
noremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set incsearch

" shortcuts and remaps
let mapleader=","
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

" edit / reload .vimrc
nnoremap <leader>ev <C-w>v<C-w>l:e $MYVIMRC<cr>
nnoremap <leader>sv :so $MYVIMRC<cr>

" split windows handling
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" tabs handling
" does not work with putty, keys not allowed
nnoremap <C-tab> :tabnext<CR>
inoremap <C-tab> <C-o>:tabnext<CR>
nnoremap <C-S-tab> :tabprev<CR>
inoremap <C-S-tab> <C-o>:tabprev<CR>

" file cleanups (remove trailing spaces)
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" esc alternative in insert mode
inoremap jj <ESC>

" ? (bof)
set wildmenu
set wildmode=longest:full,full
set showcmd

" hjkl (up and down over long lines)
nnoremap j gj
nnoremap k gk
nnoremap <up> gk
nnoremap <down> gj

" c-v in insert mode
inoremap <C-v> <C-o>P

" mouse
set mouse=a

" puppet (?)
" set runtimepath^=~/.vim/bundle/puppet.vim

" ctrlp (sublimetext-like, nice)
let g:ctrlp_root_markers=['metadata.json']
set runtimepath^=~/.vim/bundle/ctrlp.vim

" changesplugin (not that bad, testing...)
set runtimepath^=~/.vim/bundle/changesPlugin.vim
let g:changes_fixed_sign_column=1
let g:changes_respect_SignColumn=1

" lightline
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active':  {
      \   'left': [ [ 'mode', 'paste' ], ['readonly', 'filename', 'modified'], ['ctrlpmark'] ]
      \ },
      \ 'component': { 'label': ' Tab ' },
      \ 'component_function': {
      \   'ctrlpmark': 'CtrlPMark',
      \   'readonly': 'LightlineReadonly',
      \   'modified': 'LightlineModified',
      \   'filename': 'LightlineFilename'
      \ },
      \ 'tabline': {
      \   'right': [ [ 'close' ], [ 'label' ] ]
      \ },
      \ 'tab': {
      \   'active': [ 'tabnum', 'filename', 'modified', 'bufnum' ],
      \   'inactive': [ 'tabnum', 'filename', 'modified', 'bufnum' ]
      \ },
      \ 'tab_component_function': {
      \   'bufnum': 'LightlineBufnum'
      \ },
      \ 'component_type': {
      \   'label': 'raw',
      \   'bufnum': 'error'
      \ }
      \ }
set runtimepath^=~/.vim/bundle/lightline.vim

function! LightlineFilename()
  let fname = expand('%')
  return fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != fname ? fname : '[No Name]')
endfunction

function! LightlineModified()
  return &ft =~ 'help\|vimfiler\|gundo\|netrw' || expand('%:t') == 'ControlP' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'RO' : ''
endfunction

function! LightlineBufnum(t)
  return len(tabpagebuflist(a:t)) == 1 ? '' : ('<' . len(tabpagebuflist(a:t)) . '>')
endfunction

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP' && has_key(g:lightline, 'ctrlp_item')
    " couleur changeante selon regexp actives ou non
    call lightline#link('cR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev 
          \ , g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

let g:ctrlp_status_func = {
  \ 'main': 'CtrlPStatusFunc_1',
  \ 'prog': 'CtrlPStatusFunc_2',
  \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type <leader>, (,,) to toggle highlighting on/off.
nnoremap <leader>, :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=500
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction
