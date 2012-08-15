if v:progname =~? "evim"
	finish
endif

set nocompatible
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" unicode support
if has("multi_byte")
	set encoding=utf-8
	setglobal fileencoding=utf-8
	set bomb
else
	echoerr "this version of (g)Vim was not compiled with +multi_byte"
end

set nobackup		" do not keep a backup file, use versions instead
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set nu

" BEGIN Adam Lowe VIM conf
" http://www.adamlowe.me/2009/12/vim-destroys-all-other-rails-editors.html
filetype off
call pathogen#runtime_append_all_bundles()

syntax on
filetype plugin indent on
set tabstop=2
set smarttab
set shiftwidth=2
set autoindent
set expandtab
" END Adam Lowe VIM conf

runtime! macros/matchit.vim
set mouse=a
set showmatch
set binary noeol
set viminfo^=!

" alt+n or alt+p to navigate between entries in QuickFix
map <silent> <M-p> :cp <CR>
map <silent> <M-n> :cn <CR>

" Minibuffer explorer settings
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

let mapleader = ";"
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>
set sessionoptions=blank,buffers,curdir,folds,help,options,resize,tabpages,winsize,winpos

set grepprg=ack
set grepformat=%f:%l:%m

" mutt
" F1 through F3 rewraps paragraphs
augroup MUTT
	au BufRead ~/.mutt/temp/mutt* set spell " <-- vim 7 required
	au BufRead ~/.mutt/temp/mutt* nmap  <F1>  gqap
	au BufRead ~/.mutt/temp/mutt* nmap  <F2>  gqqj
	au BufRead ~/.mutt/temp/mutt* nmap  <F3>  kgqj
	au BufRead ~/.mutt/temp/mutt* map!  <F1>  <ESC>gqapi
	au BufRead ~/.mutt/temp/mutt* map!  <F2>  <ESC>gqqji
	au BufRead ~/.mutt/temp/mutt* map!  <F3>  <ESC>kgqji
augroup END

" Default.
au VimLeave * exe 'if exists("g:cmd") && g:cmd == "gvims" | if strlen(v:this_session) | exe "wviminfo! " . v:this_session . ".viminfo" | else | exe "wviminfo! " . "~/.vim/session/" . g:myfilename . ".session.viminfo" | endif | endif '
au VimLeave * exe 'if exists("g:cmd") && g:cmd == "gvims" | if strlen(v:this_session) | exe "mksession! " . v:this_session | else | exe "mksession! " . "~/.vim/session/" . g:myfilename . ".session" | endif | endif'

" highlight trailing space
match Todo /\s\+$/
" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
	au!

	" For all text files set 'textwidth' to 80 characters.
	autocmd FileType text setlocal textwidth=80

	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	" (happens when dropping a file on gvim).
	autocmd BufReadPost *
				\ if line("'\"") > 0 && line("'\"") <= line("$") |
				\   exe "normal g`\"" |
				\ endif

	" auto remove trailing whitespace on save
	" autocmd BufWritePre * :%s/\s\+$//e
augroup END
augroup twitvim
	let twitvim_enable_perl = 1
	let twitvim_enable_python = 1
	let twitvim_enable_ruby = 1
	let twitvim_enable_tcl = 1
	"-- let twitvim_browser_cmd = 'uzbl'
augroup END

autocmd BufNewFile,BufRead *.flexi setf ruby
autocmd BufRead,BufNewFile *.scss setf scss

set wildmenu
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

colorscheme railscasts

