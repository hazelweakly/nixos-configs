augroup neoformat
  au! * <buffer>
  au BufWritePre <buffer> try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
augroup END

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \ .(empty(get(b:, 'undo_ftplugin', '')) ? '' : '|')
      \ ."
      \|  exe 'au! neoformat * <buffer>'
      \  "
