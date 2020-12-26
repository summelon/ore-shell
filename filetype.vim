" my filetype file
" if exists("did_load_filetypes")
"     finish
" endif
" augroup filetypedetect
"     au BufRead,BufNewFile *.cu setfiletype cpp
" augroup END
autocmd BufEnter *cc :setlocal filetype=cpp
autocmd BufEnter *cu,*.cuh :setlocal filetype=cuda
autocmd BufNewFile,BufRead CMakeLists.txt set filetype=cmake
" autocmd BufEnter CMakeLists.txt :setlocal filetype=cmake
