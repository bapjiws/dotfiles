let g:airline_powerline_fonts = 1
let g:airline_theme='sonokai'

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" Hiding 'x' (filetype), 'y' (file encoding), errors and warnings.
let g:airline#extensions#default#layout = [
      \ [ 'a', 'b', 'c' ],
      \ [ 'z']
      \ ]

let g:airline_section_z = airline#section#create(['%3p%% ', 'linenr', ':%2v'])
let g:airline#extensions#branch#displayed_head_limit = 30
let g:airline#extensions#branch#vcs_checks = []
