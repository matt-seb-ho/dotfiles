set rnu
set autoindent
" set tabstop=4 shiftwidth=4 expandtab
" set tabstop=4 shiftwidth=4
set tabstop=4 softtabstop=-1 shiftwidth=0 expandtab
" -1 and 0 make softtabstop and shiftwidth read tabstop val
set incsearch



syntax on
let g:gruvbox_contrast_dark = 'hard'
colo gruvbox
set background=dark

" Switch between different windows by their direction`
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>

map gn :bn<cr>
map gp :bp<cr>

" In terminal mode, go to normal mode with escape
tnoremap <Esc> <C-\><C-n>
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l
tnoremap <C-h> <C-w>h

" Ignore terminal buffers
augroup termIgnore
    autocmd!
    autocmd TerminalOpen * set nobuflisted
augroup END

autocmd InsertEnter * :set number 
autocmd InsertLeave * :set relativenumber
