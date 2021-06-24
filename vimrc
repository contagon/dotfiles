" vim-plug plugins
call plug#begin('~/.vim/plugged')

    Plug 'sjl/badwolf'
    Plug 'itchyny/lightline.vim'
    Plug 'mengelbrecht/lightline-bufferline'
    Plug 'tomasiser/vim-code-dark'
    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    if has('nvim') || has('patch-8.0.902')
      Plug 'mhinz/vim-signify'
    else
      Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
    endif
    Plug 'tpope/vim-fugitive'
    Plug 'Yggdroot/indentLine'
    Plug 'tpope/vim-commentary'
    Plug 'preservim/nerdtree'
    Plug 'ryanoasis/vim-devicons'

call plug#end()

" lightline
set laststatus=2
set noshowmode
let g:lightline = {
  \   'active': {
  \     'left':[['mode','paste'],['gitbranch','readonly']],
  \     'right': [['lineinfo'], ['percent'], ['filetype']]
  \   },
  \   'component_function': {
  \     'gitbranch': 'fugitive#head',
  \   'filetype': 'MyFiletype',
  \   }
  \}
let g:lightline.separator = {'left': "\ue0b8", 'right': "\ue0be"}
let g:lightline.subseparator = {'left': "\ue0b9", 'right': "\ue0b9"}
set showtabline=2  " Show tabline
function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

" lightline buffer
let g:lightline.tabline          = {'left': [['buffers']], 'right': []}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}
let g:lightline#bufferline#show_number  = 1
let g:lightline#bufferline#shorten_path = 1
let g:lightline#bufferline#enable_devicons = 1
let g:lightline#bufferline#min_buffer_count = 2
let g:lightline#bufferline#icon_position = 'right'

" Edit vimrc file
nnoremap <Leader>vs :source ~/.vim/vimrc<CR>
nnoremap <Leader>ve :e ~/.vim/vimrc<CR>

" FZF
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <Leader>p :Rg<CR>
set grepprg=rg\ --vimgrep\ --smart-case\ --follow

" NERDtree
nnoremap <C-b> :NERDTreeToggle<CR>

" devicons
set encoding=UTF-8
"set guifont=DejaVuSansMono\ Nerd\ Font\ 11
let g:webdevicons_enable_nerdtree = 1


set nocp
filetype plugin on
set nocompatible

" Easier buffer switching
nnoremap gb :ls<CR>:b<Space>

" GitGutter options
set updatetime=100

"Let's viminfo be in .vim folder
set viminfo+=n~/.vim/viminfo

" Colors
syntax enable
colorscheme codedark

" Control Tabs
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4

" misc options
set number
set ruler
set showcmd
set cursorline
filetype plugin indent on
set wildmenu
set showmatch

" Custom bindings
inoremap jk <esc> " remap esc to jk - easier to hit

" Spell Checking
setlocal spell
set spelllang=en
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" indent lines
let g:indentLine_char = '┊'
