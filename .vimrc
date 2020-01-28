" Encoding settings 

set enc=utf-8
set fenc=utf-8
set termencoding=utf-8

" VIM settings 
set nocompatible
filetype off

" Code formatting 
set autoindent 
set smartindent 

set tabstop=4
set shiftwidth=4
set expandtab 
set textwidth=120
set t_Co=256
syntax on 

set number 
set relativenumber 
set showmatch 
set comments=sl:/*,mb:\ *,elx:\ */

" Key mapping
nmap <F2> :w<CR>
imap <F2> <ESC>:w<CR>i

map <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>

map <F6> :Dox<CR>

set makeprg=make\ -C\ build\ -j8

noremap <silent> <F7> :make <bar> bo copen<CR>

"  -- clipboard management
nnoremap <C-y> "+y
vnoremap <C-y> "+y
nnoremap <C-p> "+p
vnoremap <C-p> "+p
"  -- window management
nmap <C-h> <C-w>h
nmap <C-l> <C-w>l
nmap <C-j> <C-w>j 
nmap <C-k> <C-w>k
nmap <C-r-h> :res +5<CR>
" Remove trailing whitespace 

" VUNDLE 
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vundle plugins manager
Plugin 'VundleVim/Vundle.vim'

" VIM file system explorer
Plugin 'scrooloose/nerdtree'

" C++ Code Completion
Plugin 'valloric/youcompleteme'

" Hex values colorizing
Plugin 'lilydjwg/colorizer'

" Snippet
Plugin 'sirver/ultisnips'
Plugin 'honza/vim-snippets'

" VIM TAB management
Plugin 'bling/vim-airline'

" VIM IDE 
Plugin 'thaerkh/vim-workspace'

" DevIcon
Plugin 'ryanoasis/vim-devicons'

" Colorscheme

" Python
Plugin 'klen/python-mode'

" Markdown
Plugin 'shime/vim-livedown'

" CMake 
Plugin 'jalcine/cmake.vim'
Plugin 'tpope/vim-dispatch'

" Files management
Plugin 'wincent/command-t'

" Fast navigation
Plugin 'easymotion/vim-easymotion'


call vundle#end()
filetype plugin indent on 

" NERDtree plugin setting
" Start nerdtree when vim starts up
autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>

" YouCompleteMe 
highlight YcmErrorLine guibg=#3f0000
highlight YcmErrorSection guibg=#aaaa11
highlight YcmWarningSection guibg=#aaaa11

" clang complete 
let g:clang_library_path='/usr/lib/libclang.so'

" Vim Workspace
noremap <leader>s :ToggleWorkspace<CR>

let g:workspace_autosave = 0
let g:workspace_autosave_ignore = ['gitcommit']

" VIM airline 
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif 

let g:airline_symbols.linenr = '≡'

noremap <Tab> :bn<CR>
noremap <S-Tab> :bp<CR>
noremap <Leader><Tab> :Bw<CR>
noremap <Leader><S-Tab> :Bw!<CR>
noremap <C-t> :tabnew split<CR>
noremap <C-k><C-c> :bd <cr>

" Ultisnip 
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<m-n>"
let g:UltiSnipsJumpBackwardTrigger="<m-b>"

