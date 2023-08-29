
" settings for vim-plug
" Automatically install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  " For all files (*), after doing all the startup stuff (VimEnter), PlugInstall --sync and source ~/.vimrc
  autocmd VimEnter * PlugInstall --sync | source $HOME/.vimrc
endif

call plug#begin()
    " The default plugin directory will be as follows:
    "   - Vim (Linux/macOS): '~/.vim/plugged'
    "   - Vim (Windows): '~/vimfiles/plugged'
    "   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
    " You can specify a custom plugin directory by passing it as the argument
    "   - e.g. `call plug#begin('~/.vim/plugged')`
    "   - Avoid using standard Vim directory names like 'plugin'
    " Plug 'hogehoge', { 'on': Command, 'for': filetype } "on-demand loading
Plug 'dracula/vim'
Plug 'williamboman/mason.nvim'
call plug#end()

set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set fileformats=unix,dos,mac

set backspace=indent,eol,start " BSを空白、行末、行頭でも使えるようにする
set matchpairs& matchpairs+=<:> " 対応括弧に'<'と'>'のペアを追加
autocmd BufWritePre * :%s/\s\+$//ge "保存時に行末の空白を削除

set tabstop=4
set expandtab
set shiftwidth=4

set nowritebackup
set nobackup
set noswapfile

let OSTYPE = system('uname')
if OSTYPE == "Linux\n"
    set clipboard+=unnamedplus " clipboard
elseif OSTYPE == "Darwin\n"
    set clipboard+=unnamed " clipboard
endif

"--------------------------------------------
" view
"--------------------------------------------

set number
set ruler
set showcmd
set laststatus=2
set nowrap
set noerrorbells

syntax on

" show invidible char
set list
set listchars=tab:>-,trail:-,precedes:«,extends:» ",eol:↲

function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme * call ZenkakuSpace()
        autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
    augroup END
    call ZenkakuSpace()
endif

" Returns the list of available color schemes
function! GetColorSchemes()
   return uniq(sort(map(globpath(&runtimepath, "colors/*.vim", 0, 1), 'fnamemodify(v:val, ":t:r")')))
endfunction
let s:schemes=GetColorSchemes()
if index(s:schemes, 'dracula') >= 0
    colorscheme dracula
else
    colorscheme elflord
endif
set background=dark

set smartindent
set autoindent

set scrolloff=4 " 上下8行の視界を確保
set sidescrolloff=2 " 左右スクロール時の視界を確保
set sidescroll=1 "左右スクロールは一文字ずつ行う

set splitbelow
set splitright

"--------------------------------------------
" search
"--------------------------------------------

set ignorecase
set smartcase
set wrapscan
set incsearch
set hlsearch

"--------------------------------------------
" others
"--------------------------------------------

set virtualedit=block
set autoread
set hidden

"--------------------------------------------
" key mapping
"--------------------------------------------

nnoremap <Esc><Esc> :nohlsearch<CR><ESC>

nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

nnoremap <C-w><S-h> <C-w><<CR>
nnoremap <C-w><S-l> <C-w>><CR>
nnoremap <C-w><S-j> <C-w>-<CR>
nnoremap <C-w><S-k> <C-w>+<CR>

nnoremap ; :
vnoremap ; :

nnoremap gl gt
nnoremap gh gT

command! Zsh :vsplit term://zsh

if filereadable("local.vim")
    source local.vim
endif
