" First time setup
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" "open vim
" gvim
" :PlugInstall
" " check
" :echo exists('*plug#begin')
" "    If it returns 1 → you're good.
" "    If it returns 0 → vim-plug still isn't loaded.


set runtimepath+=$HOME/src/git_scripts/vimrcs

source $HOME/src/git_scripts/vimrcs/basic.vim
source $HOME/src/git_scripts/vimrcs/filetypes.vim

call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }


" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
"Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
"Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" ctags
Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Unmanaged plugin (manually installed and updated)
Plug '~/my-prototype-plugin'


Plug 'ycm-core/YouCompleteMe'
Plug 'ycm-core/ycmd'
" Using a non-default branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
Plug 'tenfyzhong/CompleteParameter.vim'

Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'

Plug 'sheerun/vim-polyglot'

" Initialize plugin system
call plug#end()





source $HOME/src/git_scripts/vimrcs/plugs.vim
source $HOME/src/git_scripts/vimrcs/extended.vim
"source $HOME/src/git_scripts/vimrcs/plugfull.vim
"source $HOME/src/git_scripts/vimrcs/plugins_config.vim

try
source $runtimepath/my_configs.vim
catch
endtry
