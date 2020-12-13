" Sections 
" 1. Encoding settings
" 2. VIM settings
" 3. Code formatting
" 4. Key mapping
" 5. Clipboard settings 
" 6. Window settings

" Encoding settings 

set encoding=utf-8
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
set smarttab
set textwidth=120
set t_Co=256
set mouse=nicr
syntax on 

set number 
set relativenumber 
set showmatch 
set comments=sl:/*,mb:\ *,elx:\ */
" highlight 

colorscheme gruvbox 
set background=dark
highlight Pmenu ctermbg=none ctermfg=white 
highlight Normal ctermbg=none

" Key mapping
nmap <F2> :w<CR>
imap <F2> <ESC>:w<CR>i

map <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>

map <F6> :Dox<CR>

set makeprg=make\ -C\ build\ -j8

noremap <silent> <F7> :make <bar> bo copen<CR>

"  -- clipboard management
nnoremap <Leader>y "*y
nnoremap <Leader>p "*p 
nnoremap <Leader>Y "+y 
nnoremap <Leader>P "+p
"  -- Window management
nmap <C-h> <C-w>h
nmap <C-l> <C-w>l
nmap <C-j> <C-w>j 
nmap <C-k> <C-w>k
nmap <C-r-h> :res +5<CR>
" Remove trailing whitespace 

" Terminal 
nnoremap <C-q> :FloatermNew<CR>

"tnoremap <Esc> <C-\><C-n>

" VUNDLE 
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vundle plugins manager
Plugin 'VundleVim/Vundle.vim'

" VIM file system explorer
Plugin 'scrooloose/nerdtree'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'jremmen/vim-ripgrep'
Plugin 'voldikss/vim-floaterm'
Plugin 'preservim/nerdcommenter' 

" C++ Code Completion
"Plugin 'valloric/youcompleteme'
Plugin 'neoclide/coc.nvim'
" Hex values colorizing
Plugin 'lilydjwg/colorizer'
Plugin 'octol/vim-cpp-enhanced-highlight'
" ORG mode 
Plugin 'jceb/vim-orgmode'
Plugin 'utl.vim'
Plugin 'tpope/vim-repeat'
Plugin 'taglist.vim'
Plugin 'majutsushi/tagbar'
Plugin 'tpope/vim-speeddating'
Plugin 'chrisbra/nrrwrgn'
Plugin 'itchyny/calendar.vim'
Plugin 'SyntaxRange'

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

" Colorschemes 
Plugin 'branwright1/salvation-vim'
Plugin 'morhetz/gruvbox'

call vundle#end()
filetype plugin indent on 

" Floaterm 
nnoremap   <silent>   <F12>   :FloatermToggle<CR>
tnoremap   <silent>   <F12>   <C-\><C-n>:FloatermToggle<CR>

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

noremap <F11> :bn<CR>
noremap <F10> :bp<CR>
noremap <Leader><Tab> :Bw<CR>
noremap <Leader><S-Tab> :Bw!<CR>
noremap <C-t> :tabnew split<CR>
noremap <C-k><C-c> :bd <cr>

" Ultisnip 
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<m-n>"
let g:UltiSnipsJumpBackwardTrigger="<m-b>"

" GUI font 

set guifont=DroidSansMono\ Nerd\ Font\ 11

" Files fuzzy search
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

nnoremap <silent> <C-f> :Rg<CR>
nnoremap <silent> <C-p> :Files<cr> 
nnoremap <silent> <Leader>b :Buffers<cr>
nnoremap <silent> <Leader>/ :BLines<cr>

" coc.nvim configuration 

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <localleader>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <localleader>e  :<C-u>CocList extensions<cr>
" Show commands.
" nnoremap <silent><nowait> <localleader>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" Keybindings 

let maplocalleader = "\<space>"

" C++ coloring 

let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_experimental_simple_template_highlight = 1
let g:cpp_concepts_highlight = 1
let g:cpp_no_function_highlight = 1

