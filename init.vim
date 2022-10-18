" link ~/.config/nvim to nvim/

" No Vi Compatibility
set nocompatible

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive' " git

Plug 'morhetz/gruvbox'

Plug 'justinmk/vim-dirvish'
Plug 'mileszs/ack.vim'

Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'leafgarland/typescript-vim' " TypeScript syntax
Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax

call plug#end()

syntax on

" Load plugins for filetypes
filetype plugin indent on

" For custom mappings
let mapleader = ","

" Wrapping
set wrap

" Highlight the line the cursor is on
set cursorline

" Show possible command line completions
set wildmenu
set wildmode=list:longest

" Line numbers
set number

" Longer history (default is 20)
set history=1000

" Basic tab behavior
set autoindent
set expandtab
set smarttab
set shiftwidth=2
set tabstop=2

" Split toward the bottom right
set splitbelow
set splitright

" Strip trailing whitespace
"autocmd BufWritePre * :%s/\s\+$//e

" recognize Capfile, Gemfile, treetop
" autocmd BufRead,BufNewFile *.ru set filetype=ruby
" autocmd BufRead,BufNewFile Capfile set filetype=ruby
" autocmd BufRead,BufNewFile Gemfile set filetype=ruby
" autocmd BufRead,BufNewFile *.treetop set filetype=treetop

" Reveal current file in tree
map <leader>R :NERDTreeFind<CR>

" Open tree on current directory
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

" Because I love these from TM
" imap <C-L> <space>=><space>
" imap <D-Return> <ESC>o

" Because it works everywhere else, and I don't know of a better way to do
" forward delete, and I don't really need un-tab in insert mode.
imap <C-D> <DEL>

" Symbols andstrings
" nmap <leader>: ds"i:<Esc>e
" nmap <leader>" bhxcsw"

" Make Y consistent with D, C
nnoremap Y y$

" Prev/Next Buffer
nmap <C-n> :bn<CR>
nmap <C-p> :bp<CR>

" Scroll shortcuts
nmap <C-h> zH
nmap <C-l> zL
nmap <C-j> <C-d>
nmap <C-k> <C-u>

" Store temporary files in a central spot
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Make C-w o (only window) reversible by opening a tab
nnoremap <C-W>O :tabnew %<CR>
nnoremap <C-W>o :tabnew %<CR>
nnoremap <C-W><C-O> :tabnew %<CR>

" Text object for indented code
onoremap <silent>ai :<C-u>call IndTxtObj(0)<CR>
onoremap <silent>ii :<C-u>call IndTxtObj(1)<CR>
vnoremap <silent>ai :<C-u>call IndTxtObj(0)<CR><Esc>gv
vnoremap <silent>ii :<C-u>call IndTxtObj(1)<CR><Esc>gv

function! IndTxtObj(inner)
  if &filetype == 'haml' || &filetype == 'sass' || &filetype == 'python'
    let meaningful_indentation = 1
  else
    let meaningful_indentation = 0
  endif
  let curline = line(".")
  let lastline = line("$")
  let i = indent(line(".")) - &shiftwidth * (v:count1 - 1)
  let i = i < 0 ? 0 : i
  if getline(".") =~ "^\\s*$"
    return
  endif
  let p = line(".") - 1
  let nextblank = getline(p) =~ "^\\s*$"
  while p > 0 && (nextblank || indent(p) >= i )
    -
    let p = line(".") - 1
    let nextblank = getline(p) =~ "^\\s*$"
  endwhile
  if (!a:inner)
    -
  endif
  normal! 0V
  call cursor(curline, 0)
  let p = line(".") + 1
  let nextblank = getline(p) =~ "^\\s*$"
  while p <= lastline && (nextblank || indent(p) >= i )
    +
    let p = line(".") + 1
    let nextblank = getline(p) =~ "^\\s*$"
  endwhile
  if (!a:inner && !meaningful_indentation)
    +
  endif
  normal! $
endfunction

" git blame
vmap <Leader>g :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

" Remap TAB to keyword completion
function! InsertTabWrapper(direction)
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  elseif "backward" == a:direction
    return "\<c-p>"
  elseif "forward" == a:direction
    return "\<c-n>"
  else
    return "\<c-x>\<c-k>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper ("forward")<CR>
inoremap <s-tab> <c-r>=InsertTabWrapper ("backward")<CR>
inoremap <c-tab> <c-r>=InsertTabWrapper ("startkey")<CR>

" < allows left cursor / h to move from beginning of one line to end of previous line when in normal or visual mode
" > allows right cursor / l to move from end of one line to beginning of next line when in normal or visual mode
" [ allows left cursor to move from beginning of one line to end of previous line when in insert or replace mode
" ] allows right cursor to move from end of one line to beginning of next line when in insert or replace mode
:set whichwrap+=<>[]

" Press F4 to toggle highlighting on/off.
noremap <leader>hs :set hls!<CR>

" Always display the status line
set laststatus=2

" statusline
" cf the default statusline: %<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" format markers:
"   %< truncation point
"   %n buffer number
"   %f relative path to file
"   %m modified flag [+] (modified), [-] (unmodifiable) or nothing
"   %r readonly flag [RO]
"   %y filetype [ruby]
"   %= split point for left and right justification
"   %-35. width specification
"   %l current line number
"   %L number of lines in buffer
"   %c current column number
"   %V current virtual column number (-n), if different from %c
"   %P percentage through buffer
"   %) end of width specification
set statusline=%{fugitive#statusline()}
set statusline+=%<\ %n:%f\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)

"set background=light
"set background=dark
" colorscheme jellybeans
"let g:solarized_termcolors=256
"colorscheme solarized
colorscheme gruvbox
"set background=light
"set termguicolors

"let NERDTreeShowLineNumbers=1

" selecting text with mouse does not enter visual mode
set mouse=v

" Clear highlighting on escape in normal mode
nnoremap <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[

imap jj <esc>
