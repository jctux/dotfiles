" ----------------------------------------------------------------------------
"  Modern Vim Config (vim-plug version)
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
Plug 'tiagoflatre/vim-multiple-cursors'

" Development Tools
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/tagbar'
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Modern LSP support
Plug 'dense-analysis/ale'                       " Async Lint Engine

" Language Support
Plug 'sheerun/vim-polyglot'                     " One stop shop for all syntax
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
set relativenumber    " Modern hybrid line numbers
set cursorline
set termguicolors     " True color support
set ruler
set hlsearch
set incsearch
set ignorecase
set smartcase
set laststatus=2
set noswapfile
set autoread
set updatetime=300    " Faster response for gitgutter/LSP

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

" --- Plugin Config ---
let g:molokai_original = 1
colorscheme molokai

" Airline
let g:airline_theme='molokai'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" Strip whitespace on save
autocmd BufWritePre * StripWhitespace
