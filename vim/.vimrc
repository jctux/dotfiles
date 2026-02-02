" ----------------------------------------------------------------------------
"  Modern Vim Config (Power-User Version)
" ----------------------------------------------------------------------------

" Automatically install vim-plug if not present
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Visual & UI
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'kshenoy/vim-signature'
Plug 'tomasr/molokai'
Plug 'ryanoasis/vim-devicons'

" Navigation & Fuzzy Finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'mg979/vim-visual-multi', {'branch': 'master'} " Better multiple cursors
Plug 'voldikss/vim-floaterm'                       " Floating terminal

" Development Tools
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/tagbar'
Plug 'neoclide/coc.nvim', {'branch': 'release'}    " Modern LSP support
Plug 'dense-analysis/ale'                          " Async Lint Engine

" Language Support
Plug 'sheerun/vim-polyglot'
Plug 'mattn/emmet-vim'
Plug 'elzr/vim-json'
Plug 'plasticboy/vim-markdown'

" Git & Utils
Plug 'airblade/vim-gitgutter'
Plug 'ntpeters/vim-better-whitespace'
Plug 'benmills/vimux'
Plug 'mbbill/undotree'

call plug#end()

" --- General Settings ---
set nocompatible
filetype plugin indent on
syntax on
set encoding=utf-8
set number
set relativenumber
set cursorline
set termguicolors
set ruler
set hlsearch
set incsearch
set ignorecase
set smartcase
set laststatus=2
set noswapfile
set autoread
set updatetime=300
set mouse=a
set splitbelow
set splitright

" --- Indentation ---
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent

" --- Mappings ---
let mapleader = ","

" Fast saving and exit
nmap <leader>w :w<cr>
nmap <leader>q :q<cr>

" Toggle NERDTree
map <leader>e :NERDTreeToggle<CR>

" FZF (Modern replacement for CtrlP)
nnoremap <leader>p :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>f :Ag<CR>

" Shortcuts for windows
map <Leader>h :vertical resize -5<cr>
map <Leader>j :resize +5<cr>
map <Leader>k :resize -5<cr>
map <Leader>l :vertical resize +5<cr>

" Clear highlights
map <Leader><space> :noh<cr>

" Undotree
nnoremap <leader>u :UndotreeToggle<cr>

" Floaterm
nnoremap <leader>t :FloatermToggle<cr>

" --- Plugin Config ---
let g:molokai_original = 1
try
  colorscheme molokai
catch
  colorscheme elflord
endtry

" Airline
let g:airline_theme='molokai'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" Strip whitespace on save
autocmd BufWritePre * StripWhitespace

" --- CoC Configuration (Sane Defaults) ---
" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackSpace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackSpace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (exists('*coc#rpc#ready') && coc#rpc#ready())
    call coc#refresh()
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
