let g:airline_powerline_fonts = 1
let g:airline_theme='onedark'

" Avoid showing 'double arrows'
let g:airline_skip_empty_sections = 1

" Hiding 'x' (filetype), 'y' (file encoding), errores and warnings.
let g:airline#extensions#default#layout = [
      \ [ 'a', 'b', 'c' ],
      \ [ 'z']
      \ ]

"let g:airline_section_c = airline#section#create_right(['file'])
let g:airline_section_z = airline#section#create(['%3p%% ', 'linenr', ':%2v'])
let g:airline#extensions#branch#displayed_head_limit = 30
let g:airline#extensions#branch#vcs_checks = []
"let g:airline#extensions#coc#enabled = 0
