let g:airline#themes#mine#palette = {}

" Normal mode
let s:N1 = [ '#000000', '#000000', 11 , 239 ]
let s:N2 = [ '#000000', '#000000', 15 , 237 ]
let s:N3 = [ '#000000', '#000000', 7  , 0  , 'bold' ]
let g:airline#themes#mine#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#mine#palette.normal_modified = {
      \ 'airline_c': [ '#000000', '#000000', 3  , 234, 'bold' ],
      \ }

" Insert mode
let s:I1 = [ '#000000', '#000000', 10 , 239 ]
let s:I2 = s:N2
let s:I3 = s:N3
let g:airline#themes#mine#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#mine#palette.insert_modified = g:airline#themes#mine#palette.normal_modified

" Replace mode
let g:airline#themes#mine#palette.replace = copy(g:airline#themes#mine#palette.insert)
let g:airline#themes#mine#palette.replace.airline_a = [ '#000000', '#000000', 10, 1, '' ]
let g:airline#themes#mine#palette.replace_modified = g:airline#themes#mine#palette.insert_modified

" Visual mode
let s:V1 = [ '#000000', '#000000', 13 , 239 ]
let s:V2 = s:N2
let s:V3 = s:N3
let g:airline#themes#mine#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)

" Command mode
let s:C1 = [ '#000000', '#000000', 12 , 239 ]
let s:C2 = s:N2
let s:C3 = s:N3
let g:airline#themes#mine#palette.commandline = airline#themes#generate_color_map(s:C1, s:C2, s:C3)
