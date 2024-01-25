if (exists('b:gql_did_ftplugin'))
  finish
endif
let b:gql_did_ftplugin = 1

setlocal tabstop=2 shiftwidth=2 softtabstop=2
setlocal comments=:#
setlocal commentstring=#\ %s
setlocal formatoptions-=t
setlocal iskeyword+=$,@-@
