# Things I need to do:

## Enhancements

- Make a bunch of the stuff (like null-ls) smartly configured based on existance of binaries
  - remove more binaries from neovim.nix and make it more minimal. Its closure is currently massive.
  - add wget, apparently
- Purge out some macos included stuff from the neovim path? maybe?
- See if I'm doing thing wrong, idk, like should I enable syntax if I treesitter?
- Improve large file detection and turning-off-of-shit
- re-evaluate targets.vim again
- keybind of : doesn't pop up in the right spot.
- Better insert bindings for commandline and telescope prompt?
- nerdsnipe on the packer config again

## Random Errors to Fix

- packer.nvim: Error running config for gitsigns.nvim: ...ck/packer/start/plenary.nvim/lua/plenary/async/async.lua:14: The coroutine failed with this message: ...nvim/site/pack/packer/opt/gitsigns.nvim/lua/gitsigns.lua:452: Failed to create user command
- fix my disgusting colors hack thing

```
line   28:
E684: list index out of range: 0
Error detected while processing function 5:
```

pretty sure this is the same one as above

```
Error detected while processing function <SNR>66_timer_callback[15]..6[118]..matchup#transmute#tick[11]..matchup#transmute#dochange:
line   39:
E716: Key not present in Dictionary: "regexone[l:corr.side]).'\)'"
```

Error detected while processing function <SNR>32_timer_callback[20]..4[118]..matchup#transmute#tick[11]..matchup#transmute#dochange:
line 39:
E716: Key not present in Dictionary: "regexone[l:corr.side]).'\)'"
Error detected while processing function <SNR>32_timer_callback[20]..4[118]..matchup#transmute#tick[11]..matchup#transmute#dochange:
line 42:
E716: Key not present in Dictionary: "groups)"
Error detected while processing function <SNR>32_timer_callback[20]..4[118]..matchup#transmute#tick[11]..matchup#transmute#dochange:
line 42:
E116: Invalid arguments for function copy
Error detected while processing function <SNR>32_timer_callback[20]..4[118]..matchup#transmute#tick[11]..matchup#transmute#dochange:
line 43:
E121: Undefined variable: l:groups
Error detected while processing function <SNR>32_timer_callback[20]..4[118]..matchup#transmute#tick[11]..matchup#transmute#dochange:
line 43:
E116: Invalid arguments for function keys

```
{'all': {'regex': [{'augments': {}, 'mid': '', 'open': '(', 'close': ')', 'mid_list': []}, {'a
ugments': {}, 'mid': '', 'open': '{', 'close': '}', 'mid_list': []}, {'augments': {}, 'mid': '
', 'open': '\[', 'close': ']', 'mid_list': []}], 'regex_capture': [{'extra_info': {'has_zs': 0
}, 'extra_list': [{}, {}], 'mid': '', 'has_zs': 0, 'open': '(', 'aug_comp': {}, 'need_grp': {}
, 'close': ')', 'grp_renu': {}, 'mid_list': []}, {'extra_info': {'has_zs': 0}, 'extra_list': [
{}, {}], 'mid': '', 'has_zs': 0, 'open': '{', 'aug_comp': {}, 'need_grp': {}, 'close': '}', 'g
rp_renu': {}, 'mid_list': []}, {'extra_info': {'has_zs': 0}, 'extra_list': [{}, {}], 'mid': ''
, 'has_zs': 0, 'open': '\[', 'aug_comp': {}, 'need_grp': {}, 'close': ']', 'grp_renu': {}, 'mi
d_list': []}]}, 'delim_tex': {'regex': [{'augments': {}, 'mid': '', 'open': '(', 'close': ')',
 'mid_list': []}, {'augments': {}, 'mid': '', 'open': '{', 'close': '}', 'mid_list': []}, {'au
gments': {}, 'mid': '', 'open': '\[', 'close': ']', 'mid_list': []}], 'regex_capture': [{'extr
a_info': {'has_zs': 0}, 'extra_list': [{}, {}], 'mid': '', 'has_zs': 0, 'open': '(', 'aug_comp
': {}, 'need_grp': {}, 'close': ')', 'grp_renu': {}, 'mid_list': []}, {'extra_info': {'has_zs'
: 0}, 'extra_list': [{}, {}], 'mid': '', 'has_zs': 0, 'open': '{', 'aug_comp': {}, 'need_grp':
 {}, 'close': '}', 'grp_renu': {}, 'mid_list': []}, {'extra_info': {'has_zs': 0}, 'extra_list'
: [{}, {}], 'mid': '', 'has_zs': 0, 'open': '\[', 'aug_comp': {}, 'need_grp': {}, 'close': ']'
, 'grp_renu': {}, 'mid_list': []}]}, 'delim_all': {'regex': [{'augments': {}, 'mid': '', 'open
': '(', 'close': ')', 'mid_list': []}, {'augments': {}, 'mid': '', 'open': '{', 'close': '}',
'mid_list': []}, {'augments': {}, 'mid': '', 'open': '\[', 'close': ']', 'mid_list': []}], 're
gex_capture': [{'extra_info': {'has_zs': 0}, 'extra_list': [{}, {}], 'mid': '', 'has_zs': 0, '
open': '(', 'aug_comp': {}, 'need_grp': {}, 'close': ')', 'grp_renu': {}, 'mid_list': []}, {'e
xtra_info': {'has_zs': 0}, 'extra_list': [{}, {}], 'mid': '', 'has_zs': 0, 'open': '{', 'aug_c
omp': {}, 'need_grp': {}, 'close': '}', 'grp_renu': {}, 'mid_list': []}, {'extra_info': {'has_
zs': 0}, 'extra_list': [{}, {}], 'mid': '', 'has_zs': 0, 'open': '\[', 'aug_comp': {}, 'need_g
rp': {}, 'close': ']', 'grp_renu': {}, 'mid_list': []}]}}
```

```
{'all': {'both_all': '\m\C\%()\|(\|}\|{\|]\|\[\)', 'open_mid': '\m\C\%((\|{\|\[\)', 'mid': '',
 '_engine_info': {'has_zs': {'both_all': 0, 'open_mid': 0, 'mid': 0, 'open': 0, 'close': 0, 'b
oth': 0}}, 'open': '\m\C\%((\|{\|\[\)', 'close': '\m\C\%()\|}\|]\)', 'both': '\m\C\%()\|(\|}\|
{\|]\|\[\)'}, 'delim_tex': {'both_all': '\m\C\%()\|(\|}\|{\|]\|\[\)', 'open_mid': '\m\C\%((\|{
\|\[\)', 'mid': '', '_engine_info': {'has_zs': {'both_all': 0, 'open_mid': 0, 'mid': 0, 'open'
: 0, 'close': 0, 'both': 0}}, 'open': '\m\C\%((\|{\|\[\)', 'close': '\m\C\%()\|}\|]\)', 'both'
: '\m\C\%()\|(\|}\|{\|]\|\[\)'}, 'delim_all': {'both_all': '\m\C\%()\|(\|}\|{\|]\|\[\)', 'open
_mid': '\m\C\%((\|{\|\[\)', 'mid': '', '_engine_info': {'has_zs': {'both_all': 0, 'open_mid':
0, 'mid': 0, 'open': 0, 'close': 0, 'both': 0}}, 'open': '\m\C\%((\|{\|\[\)', 'close': '\m\C\%
()\|}\|]\)', 'both': '\m\C\%()\|(\|}\|{\|]\|\[\)'}}
```

lua matchwords

```regex
\<\%(do\|function\|if\)\>:\<\%(return\|else\|elseif\)\>:\<end\>,\<repeat\>:\<until\>,\%(--\)\=\[\(=*\)\[:]\1],--\[\(=*\)\[:]\1]
```
