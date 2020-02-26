augroup neoformat
  au! * <buffer>
  au BufWritePre <buffer> try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
augroup END

if !exists("b:undo_ftplugin")
  let b:undo_ftplugin = '#!'
endif

let b:undo_ftplugin .= " | exe 'au! neoformat * <buffer>' "
