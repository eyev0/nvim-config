vim.cmd([[
au BufRead,BufNewFile *.graphql,*.graphqls,*.gql setfiletype graphql

" json
" autocmd BufNewFile,BufRead *.json set filetype=json

augroup json_autocmd
  autocmd!
  autocmd FileType json setlocal autoindent
  autocmd FileType json setlocal formatoptions=tcq2l
  autocmd FileType json setlocal foldmethod=syntax
augroup END
]])
