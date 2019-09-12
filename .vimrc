set nocompatible
""execute pathogen#infect()
syntax on
filetype indent plugin on

set history=500
set wildmenu
set showcmd

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif



set hlsearch
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start
set autoindent

"set nostartofline

set ruler
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm


" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=5


set visualbell
set t_vb=

" Enable use of the mouse for all modes
set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>

"------------------------------------------------------------
set smartindent
set shiftwidth=4
set softtabstop=4
set expandtab
" Indentation settings for using hard tabs for indent. Display tabs as
" four characters wide.
"set tabstop=4

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
"map Y y$

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

let acp_enableAtStartup=0

" pathogen install
" mkdir -p ~/.vim/autoload ~/.vim/bundle && \
" curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
"
" synastic install
" cd ~/.vim/bundle && \
" git clone --depth=1 https://github.com/vim-syntastic/syntastic.git
"
" SuperTab install
" cd ~/.vim/bundle && \
" git clone --depth=1 https://github.com/ervandew/supertab.git
"
" Tagbar install
" cd ~/.vim/bundle && \
" git clone --depth=1 git clone git://github.com/majutsushi/tagbar
"
" install universal-ctags
" git clone https://github.com/universal-ctags/ctags.git
" cd ctags
" ./autogen.sh
" ./configure
" make
" sudo make install
"
" synastic settings

"" if installed pathogen then uncomment below
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0


command! -nargs=? Filter let @a='' | execute 'g/<args>/y A' | new | setlocal bt=nofile | put! a

"nnoremap <silent> <F3> :redir @a<CR>:g//<CR>:redir END<CR>:new<CR>:put! a<CR>

"nnoremap <silent> <F4> :redir >>matches.tmp<CR>:g//<CR>:redir END<CR>:new matches.tmp<CR>
":redir @a         redirect output to register a
":%g/OpenSSH 7.2p2/-3,. p
":redir END        end redirection
":new              create new window
":put! a           paste register a into new window
