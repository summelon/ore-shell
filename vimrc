" Install vim-plug if not exist-------------------------------------------
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


" Function---------------------------------------------------------------
function! BuildYCM(info)
    " info is a dictionary with 3 fields
    " - name:   name of the plugin
    " - status: 'installed', 'updated', or 'unchanged'
    " - force:  set on PlugInstall! or PlugUpdate!
    if a:info.status == 'installed' || a:info.force
        !git submodule update --init --recursive
        !python3 ./install.py --clangd-completer
        !cp ./third_party/ycmd/.ycm_extra_conf.py ~/.
    endif
endfunction


" Plugin list----------------------------------------
call plug#begin('~/.vim/plugged')
" Code format
Plug 'Chiel92/vim-autoformat'
" Folder tree
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
" Vim-ariline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Bracket color
Plug 'luochen1990/rainbow'
" Run .cpp
Plug 'skywind3000/asyncrun.vim'
" Auto Complete
Plug 'valloric/youcompleteme', { 'do': function('BuildYCM')}
" Code folding
Plug 'tmhedberg/SimpylFold'
" Show white space
Plug 'ntpeters/vim-better-whitespace'
" Syntastic checking
Plug 'w0rp/ale'
" Color Scheme
Plug 'flazz/vim-colorschemes'
" Markdown previewer
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
" Tagbar
Plug 'majutsushi/tagbar'
" vim-gutentags
Plug 'ludovicchabant/vim-gutentags'
" Auto pair
" rm -rf .vim/view
" Plug 'jiangmiao/auto-pairs'
" Smooth motion
Plug 'yuttie/comfortable-motion.vim'
" Hihglight for search
Plug 'easymotion/vim-easymotion'
" Menubar from skywind
Plug 'skywind3000/vim-quickui'
" Table format
Plug 'vim-scripts/Align'
" HTML5
Plug 'mattn/emmet-vim'
" Customize icon
Plug 'ryanoasis/vim-devicons'
" Cmake syntax
Plug 'vhdirk/vim-cmake'
call plug#end()


" Basic setting------------------------------------------------
" Set tab equal to 4 space
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smartindent
set expandtab

" Highlight the curson column and line
set cursorcolumn
set cursorline

" Some else
set number
set background=dark
set clipboard=unnamed
set encoding=utf-8

" Add (command line like) wild menu to vim
set wildmenu
set wildmode=list:longest,full
"highlight clear SignColumn

set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set hidden		" Hide buffers when they are abandoned
set tags=./.tags;,.tags

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" Enable local vimrc
set exrc
set secure

" File type alias
source $HOME/.vim/filetype.vim

" Language setting---------------------------------------------
" For cpp
autocmd FileType cpp set cindent

autocmd FileType cpp nnoremap <silent> <F8> <ESC> :w <cr> :AsyncRun g++ -std=c++11 -Wall -O2 "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <cr>
autocmd FileType cpp nnoremap <silent> <F9> :AsyncRun -raw -cwd=$(VIM_FILEDIR) "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <cr>

" For python
autocmd FileType python nnoremap <silent> <F8> :AsyncRun -raw python % <cr>
autocmd FileType python let $PYTHONUNBUFFERED=1
nnoremap <C-H> :cn <cr>
nnoremap <C-L> :cp <cr>


" Plugin setting--------------------------------------------------------------
" Plug 'luochen1990/rainbow'
let g:rainbow_conf = {
            \   'separately': { 'cmake': 0 }
            \}
let g:rainbow_active = 1


" Plug 'flazz/vim-colorschemes'
set t_Co=256
colorscheme gruvbox
highlight Normal ctermbg=None
" let g:CSApprox_attr_map = { 'bold' : 'bold', 'italic' : '', 'sp' : '' }
highlight comment guifg=#928374 ctermfg=189 cterm=italic
highlight SignColumn ctermbg=None
highlight LineNr ctermfg=11
highlight Folded cterm=bold ctermfg=DarkCyan ctermbg=None


" Plug 'dense-analysis/ale'
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0
let g:ale_echo_msg_format = '[#%linter%#] %s [%severity%]'
let g:ale_statusline_format = ['E•%d', 'W•%d', 'OK']
let g:ale_sign_error = '▶'
let g:ale_sign_warning = '▶'
let g:ale_echo_msg_error_str = '✹ Error'
let g:ale_echo_msg_warning_str = '⚠ Warning'
highlight GruvboxRedSign ctermfg=167 ctermbg=None guifg=#fb4934 guibg=#3c3836
highlight GruvboxYellowSign ctermfg=214 ctermbg=None guifg=#fabd2f guibg=#3c3836

let g:ale_completion_delay = 500
let g:ale_echo_delay = 20
let g:ale_lint_delay = 500
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_linters_explicit=0
let g:airline#extensions#lae#enabled=1
let g:ale_c_parse_makefile=1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

let g:ale_python_pylint_options='--rffile=~/.pylintrc'
let g:ale_linters = {
            \   'python': ['flake8', 'pylint'],
            \   'javascript': ['eslint'],
            \   'cpp': ['cc', 'cppcheck'],
            \   'cuda': ['nvcc']}
    " C++ in ALE
let g:ale_c_cc_options = '-Wall -O2 -std=c99'
let g:ale_cpp_cc_options = '-Wall -O2 -std=c++17'
let g:ale_c_cppcheck_options = ''
let g:ale_cpp_cppcheck_options = ''


" Plug 'valloric/youcompleteme'
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings = 1
set completeopt+=popup
let g:ycm_semantic_triggers =  {
            \ 'c,cpp,cuda,python,java,go,erlang,perl': ['re!\w{2}'],
            \ 'cs,lua,javascript': ['re!\w{2}'],
            \ }


" Plug 'vim-airline/vim-airline'
let g:airline_theme='fruit_punch'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#right_sep = ' '
let g:airline_left_sep = ' '
let g:airline_right_sep = ' '
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'


" Plug 'tmhedberg/SimpylFold'
let g:SimpylFold_docstring_preview = 1
set foldmethod=indent
set foldlevel=99
" Auto-save folded code when exist
augroup remember_folds
  autocmd!
  autocmd BufWinLeave * mkview
  autocmd BufWinEnter * silent! loadview
augroup END


" Plug 'easymotion/vim-easymotion'
hi EasyMotionTarget ctermbg=none ctermfg=208
hi EasyMotionShade ctermbg=none ctermfg=gray
hi EasymotionTarget2First ctermbg=none ctermfg=208
hi EasymotionTarget2Second ctermbg=none ctermfg=208


" Plug 'iamcco/markdown-preview.nvim'
" let g:mkdp_echo_preview_url = 1 to check if mkdp can work or not
let g:mkdp_auto_start=1


" Plug 'mattn/emmet-vim'
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
let g:user_emmet_leader_key=','


" Plug 'skywind3000/vim-quickui'---------------------------------------------
call quickui#menu#reset()

"hi! link BGon 235
"hi! link BGoff None
"\ ['Highlight &Normal %{&color? "235":"None"}', 'highlight Normal ctermbg=']

" Plug 'scrooloose/nerdtree'
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Plug 'majutsushi/tagbar'
" apt install exuberant-ctags
" Plug 'ludovicchabant/vim-gutentags'
" gutentags search upper recursively, stop if meet these files / folders
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

" Ctags file name
let g:gutentags_ctags_tagfile = '.tags'

" vim nmap put all tag files into ~/.cache/tags
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags

" Ctags argument
let g:gutentags_ctags_extra_args = []
let g:gutentags_ctags_extra_args += ['--fields=+niazS', '--extras=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
nmap <C-]> :YcmCompleter GoTo<CR>


" Plug 'skywind3000/asyncrun.vim'
let g:asyncrun_open = 6
let g:asyncrun_bell = 1
autocmd FileType cpp nnoremap <silent> <Plug>(close_quickfix) :call asyncrun#quickfix_toggle(6)<cr>
autocmd FileType cpp nnoremap <silent> <Plug>(build_cpp) <ESC> :w <cr> :AsyncRun -mode=term g++ -std=c++11 -Wall -O2 "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <cr>
autocmd FileType cpp nnoremap <silent> <Plug>(run_cpp) :AsyncRun -mode=term -raw -cwd=$(VIM_FILEDIR) "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <cr>
autocmd FileType cpp nnoremap <silent> <Plug>(run_and_build) <ESC> :w <cr> :AsyncRun -post=q\ <bar>\ execute\ "normal\ \<Plug>(run_cpp)" -mode=term g++ -std=c++11 -Wall -O2 "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <cr>


" Create ~/.cache/tags if it not exists
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

" Plug 'Chiel92/vim-autoformat'
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0


call quickui#menu#install('&Plugin', [
            \ ["&NERDTree", 'NERDTreeToggle', ''],
            \ ["&Tagbar", 'TagbarToggle', ''],
            \ ["&Autoformat", 'Autoformat', '']
            \ ])
call quickui#menu#install('&Hotkey', [
            \ ["&Resize", 'vertical resize 85', '']
            \ ])


call quickui#menu#install('&C++', [
            \ ["Build", 'execute "normal \<Plug>(build_cpp)"', ''],
            \ ["&Run", 'execute "normal \<Plug>(run_cpp)"', ''],
            \ ["&Build and Run", 'execute "normal \<Plug>(run_and_build)"', ''],
            \ ["&Close Quickfix", 'execute "normal \<Plug>(close_quickfix)"', '']])

" install a 'File' menu, use [text, command] to represent an item.
call quickui#menu#install('&File', [
            \ [ "&New File\tCtrl+n", 'echo 0' ],
            \ [ "&Open File\t(F3)", 'echo 1' ],
            \ [ "&Close", 'echo 2' ],
            \ [ "--", '' ],
            \ [ "&Save\tCtrl+s", 'echo 3'],
            \ [ "Save &As", 'echo 4' ],
            \ [ "Save All", 'echo 5' ],
            \ [ "--", '' ],
            \ [ "E&xit\tAlt+x", 'echo 6' ],
            \ ])

" items containing tips, tips will display in the cmdline
call quickui#menu#install('&Edit', [
            \ [ '&Copy', 'echo 1', 'help 1' ],
            \ [ '&Paste', 'echo 2', 'help 2' ],
            \ [ '&Find', 'echo 3', 'help 3' ],
            \ ])

" script inside %{...} will be evaluated and expanded in the string
call quickui#menu#install("&Option", [
			\ ['Set &Spell %{&spell? "Off":"On"}', 'set spell!'],
			\ ['Set &Cursor Line %{&cursorline? "Off":"On"}', 'set cursorline!'],
			\ ['Set &Paste %{&paste? "Off":"On"}', 'set paste!'],
			\ ])

" register HELP menu with weight 10000
call quickui#menu#install('H&elp', [
			\ ["&Cheatsheet", 'help index', ''],
			\ ['T&ips', 'help tips', ''],
			\ ['--',''],
			\ ["&Tutorial", 'help tutor', ''],
			\ ['&Quick Reference', 'help quickref', ''],
			\ ['&Summary', 'help summary', ''],
			\ ], 10000)

" enable to display tips in the cmdline
let g:quickui_show_tip = 1
let g:quickui_color_scheme = 'gruvbox'
" hit space twice to open menu
noremap <space><space> :call quickui#menu#open()<cr>


" Plug 'vim-scripts/Align'
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" " Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
