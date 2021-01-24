call sandwich#util#addlocal([
            \ { 'buns': ["''", "''"], 'input': ['q'], 'cursor': 'keep' },
            \ { 'buns': ["''","''"],  'input': ['Q'], 'linewise': 1, 'cursor': 'keep' },
            \ { 'buns': ['${','}'],  'input': ['$'] },
            \ ])

" TODO: figure this out later
" {'buns': ['\(^\s*\)\?' . "\'\'" . '\(\s*$\)', '\(^\s*\)' . "\'\'" . '\(\s*$\)\?'], 'regex': 1, 'kind': ['delete', 'replace', 'textobj'], 'action': ['delete'], 'input': ['q'], 'cursor': 'keep'},
