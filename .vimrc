syntax on
set guifont=Monospace\ 22
set guioptions-=T

au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

set cul

hi Normal       gui=bold guifg=white  guibg=black 
"hi Comment
"hi Constant
"hi Identifier
"hi Statement
"hi PreProc
"hi Type
"hi Special
"hi Underlined
"hi Error
"hi Todo

"hi Cursor
hi CursorLine                         guibg=grey5
"hi ColorColumn
"hi Directory
"hi DiffAdd
"hi DiffChange
"hi DiffDelete
"hi DiffText
"hi ErrorMsg
"hi Folded
"hi FoldColumn
"hi SignColumn
"hi IncSearch
hi LineNr                guifg=yellow guibg=grey10
hi CursorLineNr gui=bold guifg=yellow guibg=grey15
"hi MatchParen
"hi Visual

"hi link markdownHeadingDelimiter Ignore

set nocompatible
set showcmd
set foldmethod=syntax

filetype on
filetype plugin on
syntax enable

set breakindent
set linebreak

set autoindent
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4

if version >= 700
   set spl=en spell
endif

set backspace=2
set mouse=a
set number
set ignorecase
set incsearch
set hlsearch
nnoremap <silent> /<CR> :nohlsearch<CR>

set clipboard^=unnamed
set clipboard^=unnamedplus

set nohidden

set laststatus=2
set statusline=%F%m%r%h%w\ (%{&ff}){%Y}\ [%l,%v][%p%%]

" TODO C-Tab and C-S-Tab to change tabs
nnoremap <silent> <C-t> :tabnew<CR>
" TODO can I do the below without dipping into insert mode?
nnoremap <silent> <Tab> a<C-t><Esc>
nnoremap <silent> <S-Tab> a<C-d><Esc>
inoremap <silent> jj <Esc>
inoremap <silent> <Tab> <C-t>
inoremap <silent> <S-Tab> <C-d>
inoremap <silent> <CR> <Esc>o
 
" Insert a single character
nnoremap <silent> <Home> i_<Esc>r
nnoremap <silent> <End> a_<Esc>r

" Create Blank Newlines and stay in Normal mode
" TODO figure out how to return to column
nnoremap <silent> zj o<Esc>gk
nnoremap <silent> zk O<Esc>gj

" Space will toggle folds!
nnoremap <space> za

" Up and down are more logical with g..
nnoremap <silent> k gk
nnoremap <silent> j gj
inoremap <silent> <Up> <Esc>gka
inoremap <silent> <Down> <Esc>gja

set autochdir

set completeopt=longest,menuone,preview

" Swap ; and :  Convenient.
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" TODO figure out whether I want this. Pretty sure it has something to do with pop up messages
" inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
" inoremap <expr> <c-n> pumvisible() ? "\<lt>c-n>" : "\<lt>c-n>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"
" inoremap <expr> <m-;> pumvisible() ? "\<lt>c-n>" : "\<lt>c-x>\<lt>c-o>\<lt>c-n>\<lt>c-p>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"

set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp
au BufWritePre * let &bex = '-' . strftime("%Y%m%d-%H%M%S") . '.vimbackup'

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" https://vim.fandom.com/wiki/Restore_screen_size_and_position
if has("gui_running")
  function! ScreenFilename()
    if has('amiga')
      return "s:.vimsize"
    elseif has('win32')
      return $HOME.'\_vimsize'
    else
      return $HOME.'/.vimsize'
    endif
  endfunction

  function! ScreenRestore()
    " Restore window size (columns and lines) and position
    " from values stored in vimsize file.
    " Must set font first so columns and lines are based on font size.
    let f = ScreenFilename()
    if has("gui_running") && g:screen_size_restore_pos && filereadable(f)
      let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
      for line in readfile(f)
        let sizepos = split(line)
        if len(sizepos) == 5 && sizepos[0] == vim_instance
          silent! execute "set columns=".sizepos[1]." lines=".sizepos[2]
          silent! execute "winpos ".sizepos[3]." ".sizepos[4]
          return
        endif
      endfor
    endif
  endfunction

  function! ScreenSave()
    " Save window size and position.
    if has("gui_running") && g:screen_size_restore_pos
      let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
      let data = vim_instance . ' ' . &columns . ' ' . &lines . ' ' .
            \ (getwinposx()<0?0:getwinposx()) . ' ' .
            \ (getwinposy()<0?0:getwinposy())
      let f = ScreenFilename()
      if filereadable(f)
        let lines = readfile(f)
        call filter(lines, "v:val !~ '^" . vim_instance . "\\>'")
        call add(lines, data)
      else
        let lines = [data]
      endif
      call writefile(lines, f)
    endif
  endfunction

  if !exists('g:screen_size_restore_pos')
    let g:screen_size_restore_pos = 1
  endif
  if !exists('g:screen_size_by_vim_instance')
    let g:screen_size_by_vim_instance = 1
  endif
  autocmd VimEnter * if g:screen_size_restore_pos == 1 | call ScreenRestore() | endif
  autocmd VimLeavePre * if g:screen_size_restore_pos == 1 | call ScreenSave() | endif
endif
