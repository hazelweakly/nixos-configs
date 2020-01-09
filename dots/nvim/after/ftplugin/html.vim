setl iskeyword+=-

if exists('b:undo_ftplugin')
    let b:undo_ftplugin .= '|setl iskeyword<'
else
    let b:undo_ftplugin = 'setl iskeyword<'
endif
