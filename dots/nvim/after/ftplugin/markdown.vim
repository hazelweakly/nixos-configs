call sandwich#util#addlocal([
            \ { 'buns': ['```', '```'], 'input': ['`'], 'nesting': 0, 'motionwise': ['line'], 'action': ['add'], 'kind': ['add', 'replace'] },
            \ { 'buns': 'Backtick()', 'input': ['`'], 'nesting': 0, 'listexpr': 1, 'linewise': 1, 'action': ['delete'] }
            \ ])

function! Backtick() abort
    let n = 0

    while 1
        let pat = repeat('`', n + 1)
        let pat_s = '\%(^\|[^`]\)\zs' . pat
        let pat_e = pat . '\ze\%([^`]\|$\)'

        let [l_s, c_s] = searchpos(pat_s, 'bcnW')
        let [l_e, c_e] = searchpos(pat_e, 'cnW')

        if !l_s || !l_e
            return ['', '']
        endif

        let past_start = getline(l_s)[c_s + n]
        let before_end = getline(l_e)[c_e - 2]

        if past_start != '`' && before_end != '`'
            return [pat, pat]
        endif

        let n += 1
    endwhile
endfunction
