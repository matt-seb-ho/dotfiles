" -- table of contents ------------------------------------
" - basic settings
" - theming and appearance
" - navigation 
" - plugins
"   - fzf keybindings
"   - lightline
"   - language server (CoC)
" - kitty terminal compatibility


" -- basic settings ---------------------------------------
" line numbers, syntax highlighting
set rnu
set nu
syntax on
" show actual line numbers while in insert mode 
autocmd InsertEnter * :set number 
autocmd InsertLeave * :set relativenumber

" indentation, tabs -> spaces
" - note: -1 and 0 make softtabstop and shiftwidth read tabstop val
set tabstop=4 softtabstop=-1 shiftwidth=0 expandtab
set autoindent

" set leader key to SPACE
let mapleader = " "
"
" incremental search: show results as you type query
set incsearch



" -- theming and appearance -------------------------------
set background=light
set termguicolors



" -- navigation -------------------------------------------
" shortcuts for cycling through buffers
map gn :bn<cr>
map gp :bp<cr>

" switch between different windows by their direction`
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

" in terminal mode, go to normal mode with escape
tnoremap <Esc> <C-\><C-n>
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l
tnoremap <C-h> <C-w>h
" ignore terminal buffers while cycling
" augroup termIgnore
"     autocmd!
"     autocmd TerminalOpen * set nobuflisted
" augroup END



" -- plugins ----------------------------------------------
call plug#begin()
" fuzzy finder 
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" lightline + buffer line
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'

" color scheme
Plug 'rose-pine/vim'

" language server integration
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()


" -- plugins -- rose pine theme ----------------------------
colo rosepine_dawn


" -- plugins -- fzf ----------------------------------------
" define command
autocmd VimEnter * command! -bang -nargs=? Files call fzf#vim#files(<q-args>, {'options': '--no-preview'}, <bang>0)
autocmd VimEnter * command! -bang -nargs=? Buffers call fzf#vim#buffers(<q-args>, {'options': '--no-preview'}, <bang>0)
autocmd VimEnter * command! -bang -nargs=? GFiles call fzf#vim#gitfiles(<q-args>, {'options': '--no-preview'}, <bang>0)
" bind command to keys
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>g :GFiles<CR>
" match fzf colors to colorscheme
" seems highlighted entry is marked by fg+, bg+
"  - original values:
"  \ 'hl':      ['fg', 'Normal'],
"  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
"  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Normal'],
  \ 'fg+':     ['fg', 'Comment'],
  \ 'bg+':     ['bg', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }


" -- plugins -- lightline ---------------------------------
" always show lightline status line
" show tab (buffer) line
set laststatus=2
set showtabline=2

" let g:lightline#bufferline#show_number  = 1
let g:lightline#bufferline#shorten_path = 0
let g:lightline#bufferline#unnamed      = '[No Name]'

" let g:lightline = {}
let g:lightline = { 'colorscheme': 'rosepine', }
" let g:lightline = { 'colorscheme': 'rosepine_dawn', }
" with close (x) icon on the right
" let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
let g:lightline.tabline          = {'left': [['buffers']], 'right': []} 
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}

" let g:lightline = { 'colorscheme': 'rosepine_dawn' }
" let g:lightline = {
"       \ 'colorscheme': 'rosepine_dawn',
"       \ 'active': {
"       \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ]
"       \ },
"       \ 'tabline': {
"       \   'left': [ ['buffers'] ],
"       \   'right': [ ['close'] ]
"       \ },
"       \ 'component_expand': {
"       \   'buffers': 'lightline#bufferline#buffers'
"       \ },
"       \ 'component_type': {
"       \   'buffers': 'tabsel'
"       \ }
"       \ }


" -- plugins -- language server (CoC) ----------------------
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" 
" inoremap <silent><expr> <Tab>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<Tab>" :
"       \ coc#refresh()



" -- kitty terminal compatibility -------------------------
" vim has poor out-of-the-box detection for modern terminal features,
" however it allows lots of low-level config to work.
" - https://sw.kovidgoyal.net/kitty/faq/
" Mouse support
" set mouse=a
" set ttymouse=sgr
" set balloonevalterm
" Styled and colored underline support
let &t_AU = "\e[58:5:%dm"
let &t_8u = "\e[58:2:%lu:%lu:%lum"
let &t_Us = "\e[4:2m"
let &t_Cs = "\e[4:3m"
let &t_ds = "\e[4:4m"
let &t_Ds = "\e[4:5m"
let &t_Ce = "\e[4:0m"
" Strikethrough
let &t_Ts = "\e[9m"
let &t_Te = "\e[29m"
" Truecolor support
let &t_8f = "\e[38:2:%lu:%lu:%lum"
let &t_8b = "\e[48:2:%lu:%lu:%lum"
let &t_RF = "\e]10;?\e\\"
let &t_RB = "\e]11;?\e\\"
" Bracketed paste
let &t_BE = "\e[?2004h"
let &t_BD = "\e[?2004l"
let &t_PS = "\e[200~"
let &t_PE = "\e[201~"
" Cursor control
let &t_RC = "\e[?12$p"
let &t_SH = "\e[%d q"
let &t_RS = "\eP$q q\e\\"
let &t_SI = "\e[5 q"
let &t_SR = "\e[3 q"
let &t_EI = "\e[1 q"
let &t_VS = "\e[?12l"
" Focus tracking
let &t_fe = "\e[?1004h"
let &t_fd = "\e[?1004l"
execute "set <FocusGained>=\<Esc>[I"
execute "set <FocusLost>=\<Esc>[O"
" Window title
let &t_ST = "\e[22;2t"
let &t_RT = "\e[23;2t"

" vim hardcodes background color erase even if the terminfo file does
" not contain bce. This causes incorrect background rendering when
" using a color theme with a background color in terminals such as
" kitty that do not support background color erase.
let &t_ut=''
