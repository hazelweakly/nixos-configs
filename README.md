# nixos-configs

Configurations for my NixOS and macOS systems (work/home laptops)

## Design philosophy

- Avoid channels wherever possible
- System overlays should be available in all nix CLI tools
- Full system can be created from a single command with no incremental bootstrapping needed
- Whenever possible, have declarative configuration of environment.
  - Try to keep configuration in the natural language of that environment. (eg don't fully embed vimrc into nix)
- System configuration should be buildable from CI

## Install Instructions

- lol

1. xcode-select --install
2. sh <(curl -L https://nixos.org/nix/install)
3. curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
4. ssh-keygen
5. clone this repo
6. Manually add the nixConfig stuff to /etc/nix/nix.conf and restart daemon. sigh.
7. zsh dots/zsh/fn/update
8. once it works, remove: /etc/shells, /etc/zshrc, /etc/nix/nix.conf and run again

---

- https://www.lua.org/manual/5.1/manual.html#5.4.1 - patterns
- https://github.com/roginfarrer/dotfiles/blob/main/nvim/.config/nvim/lua/user/packerInit.lua
  - requires plugins from user.plugins
- https://old.reddit.com/r/neovim/comments/rw4imi/what_is_the_most_interesting_part_of_your_lua/hrfrcrn/
  - auto require local config for plugins
- https://github.com/olimorris/dotfiles/blob/main/.config/nvim/init.lua
  - shows how to setup full reload of config
  - https://old.reddit.com/r/neovim/comments/puuskh/how_to_reload_my_lua_config_while_using_neovim/
- https://github.com/ray-x/nvim/tree/master/lua/core
  - Should just look through this.

---

           startup: 324.2
    event                  time percent plot
    opening buffers      138.06   42.58 ██████████████████████████
    packer_compiled.lua   91.96   28.36 █████████████████▍
    loading rtp plugins   24.73    7.63 ████▋
    loading packages      18.85    5.81 ███▌
    init.lua              13.59    4.19 ██▌
    sourcing vimrc file(   7.19    2.22 █▍
    direnv.vim             5.14    1.59 █
    tokyonight.vim         3.44    1.06 ▋
    expanding arguments    3.24    1.00 ▋
    locale set             2.93    0.90 ▌
    done waiting for UI    2.29    0.71 ▍
    rplugin.vim            2.26    0.70 ▍
    reading ShaDa          2.04    0.63 ▍
    BufEnter autocommand   1.76    0.54 ▍
    nvim-treesitter.vim    1.65    0.51 ▎
    syntax.vim             1.35    0.42 ▎
    inits 1                1.20    0.37 ▎
    nvim-ts-autotag.vim    1.17    0.36 ▎
    first screen update    1.00    0.31 ▎
    nvim-treesitter-text   0.76    0.23 ▏
    VimEnter autocommand   0.73    0.23 ▏
    indent_blankline.vim   0.54    0.17 ▏
    scripts.vim            0.46    0.14 ▏
    nvim-treesitter-refa   0.45    0.14 ▏
    rainbow.vim            0.38    0.12 ▏
    conflict_marker.vim    0.36    0.11 ▏
    nvim-treesitter-text   0.33    0.10
    executing command ar   0.32    0.10
    netrwPlugin.vim        0.31    0.10
    scripts.vim            0.30    0.09
    scripts.vim            0.29    0.09
    scripts.vim            0.28    0.09
    init highlight         0.28    0.09
    clipboard.vim          0.26    0.08
    sandwich.vim           0.26    0.08
    sandwich.vim           0.26    0.08
    sandwich.vim           0.25    0.08
    filetype.lua           0.25    0.08
    telescope.vim          0.24    0.07
    direnv.vim             0.24    0.07
    easy_align.vim         0.22    0.07
    sandwich.vim           0.20    0.06
    nvim-web-devicons.vi   0.18    0.06
    synload.vim            0.18    0.05
    nvim-rooter.lua        0.17    0.05
    colorizer.vim          0.17    0.05
    cls.vim                0.16    0.05
    fetch.vim              0.16    0.05
    tutor.vim              0.15    0.05
    fix_cursorhold_nvim.   0.15    0.05
    ftplugin.vim           0.15    0.05
    indent.vim             0.15    0.05
    plenary.vim            0.15    0.05
    tohtml.vim             0.15    0.05
    zipPlugin.vim          0.15    0.05
    detect.vim             0.14    0.04
    gzip.vim               0.14    0.04
    filetype.vim           0.14    0.04
    rplugin.vim            0.14    0.04
    health.vim             0.14    0.04
    matchparen.vim         0.12    0.04
    tikz.vim               0.12    0.04
    rplugin.vim            0.10    0.03
    tex.vim                0.10    0.03
    loading after plugin   0.08    0.02
    man.vim                0.07    0.02
    shada.vim              0.07    0.02
    extra_vimrc.vim        0.05    0.02
    matchit.vim            0.04    0.01
    inits 2                0.04    0.01
    tarPlugin.vim          0.04    0.01
    spellfile.vim          0.03    0.01
    init default autocom   0.03    0.01
    window checked         0.01    0.00
    init default mapping   0.01    0.00
    inits 3                0.01    0.00
    init screen for UI     0.01    0.00
    --- NVIM STARTING --   0.00    0.00
    parsing arguments      0.00    0.00
    editing files in win   0.00    0.00
    UIEnter autocommands   0.00    0.00
    before starting main   0.00    0.00
    --- NVIM STARTED ---   0.00    0.00
    waiting for UI         0.00    0.00



    Total Time:   39.294 -- Flawless Victory


    Slowest 10 plugins (out of 18)~
                        [vimrc]	26.241
                      [runtime]	2.767
                tokyonight.nvim	2.632
                nvim-treesitter	1.869
                     direnv.vim	1.376
    nvim-treesitter-textobjects	1.003
                      [unknown]	0.757
                nvim-ts-autotag	0.669
          indent-blankline.nvim	0.429
       nvim-treesitter-refactor	0.377

    Phase Detail:~

    init default autocommands (10.118)~
    7.406     [vimrc] >
            7.406     /Users/hazelweakly/src/personal/nixos-configs/dots/nvim/init.lua
    <
    2.632     tokyonight.nvim >
            2.632     /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/tokyonight.nvim/colors/tokyonight.vim
    <
    0.080     [runtime] >
            0.052     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/ftplugin.vim
            0.028     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/indent.vim
    <

    sourcing vimrc file(s) (22.425)~
    18.835    [vimrc] >
            18.835    /Users/hazelweakly/.config/nvim/plugin/packer_compiled.lua
    <
    1.580     [runtime] >
            0.347     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/rplugin.vim
            0.347     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/scripts.vim
            0.252     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/syntax/syntax.vim
            0.209     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/netrwPlugin.vim
            0.132     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/filetype.lua
            0.067     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/syntax/synload.vim
            0.040     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/shada.vim
            0.034     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/man.vim
            0.024     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/gzip.vim
            0.021     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/tutor.vim
            0.016     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/health.vim
            0.015     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/zipPlugin.vim
            0.015     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/filetype.vim
            0.014     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/tohtml.vim
            0.014     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/matchparen.vim
            0.012     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/tarPlugin.vim
            0.011     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/matchit.vim
            0.011     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/spellfile.vim
    <
    1.351     direnv.vim >
            1.272     /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/direnv.vim/plugin/direnv.vim
            0.079     /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/direnv.vim/autoload/direnv.vim
    <
    0.257     conflict-marker.vim >
            0.257     /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/conflict-marker.vim/plugin/conflict_marker.vim
    <
    0.174     [unknown] >
            0.112     /Users/hazelweakly/.local/share/nvim/site/pack/packer/start/vim-sandwich/autoload/sandwich.vim
            0.018     /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tikz.vim
            0.015     /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/cls.vim
            0.014     /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim
            0.007     /nix/store/d7a32ws516airg8pn3mkcsdnbhcc4dy0-neovim-master/rplugin.vim
            0.007     /Users/hazelweakly/.local/share/nvim/rplugin.vim
    <
    0.114     telescope.nvim >
            0.114     /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/telescope.nvim/plugin/telescope.vim
    <
    0.092     vim-easy-align >
            0.092     /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/vim-easy-align/plugin/easy_align.vim
    <
    0.023     plenary.nvim >
            0.023     /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/plenary.nvim/plugin/plenary.vim
    <

    loading rtp plugins (0.583)~
    0.583     [unknown] >
            0.154     /Users/hazelweakly/.local/share/nvim/site/pack/packer/start/vim-sandwich/plugin/operator/sandwich.vim
            0.128     /Users/hazelweakly/.local/share/nvim/site/pack/packer/start/vim-sandwich/plugin/sandwich.vim
            0.115     /Users/hazelweakly/.local/share/nvim/site/pack/packer/start/nvim-rooter.lua/plugin/nvim-rooter.lua
            0.080     /Users/hazelweakly/.local/share/nvim/site/pack/packer/start/vim-sandwich/plugin/textobj/sandwich.vim
            0.055     /Users/hazelweakly/.local/share/nvim/site/pack/packer/start/FixCursorHold.nvim/plugin/fix_cursorhold_nvim.vim
            0.051     /Users/hazelweakly/.local/share/nvim/site/pack/packer/start/vim-fetch/plugin/fetch.vim
    <

    clearing screen (6.143)~
    1.869     nvim-treesitter >
            1.869     /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/plugin/nvim-treesitter.vim
    <
    1.107     [runtime] >
            0.969     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/scripts.vim
            0.138     /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/autoload/provider/clipboard.vim
    <
    1.003     nvim-treesitter-textobjects >
            1.003     /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-textobjects/plugin/nvim-treesitter-textobjects.vim
    <
    0.669     nvim-ts-autotag >
            0.669     /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/nvim-ts-autotag/plugin/nvim-ts-autotag.vim
    <
    0.429     indent-blankline.nvim >
            0.429     /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/indent-blankline.nvim/plugin/indent_blankline.vim
    <
    0.377     nvim-treesitter-refactor >
            0.377     /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-refactor/plugin/nvim-treesitter-refactor.vim
    <
    0.361     nvim-treesitter-textsubjects >
            0.361     /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-textsubjects/plugin/nvim-treesitter-textsubjects.vim
    <
    0.241     nvim-ts-rainbow >
            0.241     /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/nvim-ts-rainbow/plugin/rainbow.vim
    <
    0.032     nvim-web-devicons >
            0.032     /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/nvim-web-devicons/plugin/nvim-web-devicons.vim
    <
    0.029     nvim-colorizer.lua >
            0.029     /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/nvim-colorizer.lua/plugin/colorizer.vim
    <
    0.025     conflict-marker.vim >
            0.025     /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/conflict-marker.vim/autoload/conflict_marker/detect.vim
    <

    opening buffers (0.026)~
    0.026     direnv.vim >
            0.026     /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/direnv.vim/autoload/direnv/extra_vimrc.vim
    <


    ================================== FULL LOGS ==================================

    Log 1/10 >
      times in msec
       clock   self+sourced   self:  sourced script
       clock   elapsed:              other lines

      000.003  000.003: --- NVIM STARTING ---
      000.733  000.730: locale set
      001.052  000.319: inits 1
      001.072  000.020: window checked
      001.077  000.004: parsing arguments
      003.857  002.781: expanding arguments
      003.975  000.118: inits 2
      004.615  000.640: init highlight
      004.645  000.030: init default mappings
      004.700  000.055: init default autocommands
      007.674  000.102  000.102: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/ftplugin.vim
      008.070  000.048  000.048: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/indent.vim
      018.786  002.712  002.712: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/tokyonight.nvim/colors/tokyonight.vim
      018.883  010.577  007.865: sourcing /Users/hazelweakly/src/personal/nixos-configs/dots/nvim/init.lua
      018.894  003.467: sourcing vimrc file(s)
      019.214  000.133  000.133: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/filetype.lua
      019.320  000.015  000.015: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/filetype.vim
      019.694  000.057  000.057: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/syntax/synload.vim
      019.745  000.246  000.189: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/syntax/syntax.vim
      021.786  000.025  000.025: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/gzip.vim
      021.913  000.013  000.013: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/health.vim
      022.049  000.033  000.033: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/man.vim
      022.162  000.010  000.010: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/matchit.vim
      022.244  000.010  000.010: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/matchparen.vim
      022.515  000.178  000.178: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/netrwPlugin.vim
      022.833  000.007  000.007: sourcing /nix/store/d7a32ws516airg8pn3mkcsdnbhcc4dy0-neovim-master/rplugin.vim
      022.965  000.006  000.006: sourcing /Users/hazelweakly/.local/share/nvim/rplugin.vim
      022.971  000.325  000.312: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/rplugin.vim
      023.071  000.036  000.036: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/shada.vim
      023.167  000.009  000.009: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/spellfile.vim
      023.276  000.011  000.011: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/tarPlugin.vim
      023.391  000.009  000.009: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/tohtml.vim
      023.492  000.013  000.013: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/tutor.vim
      023.588  000.012  000.012: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/plugin/zipPlugin.vim
      026.031  000.097  000.097: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/vim-easy-align/plugin/easy_align.vim
      029.273  000.264  000.264: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/telescope.nvim/plugin/telescope.vim
      031.323  000.028  000.028: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/plenary.nvim/plugin/plenary.vim
      039.975  000.778  000.778: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/scripts.vim
      040.829  000.113  000.113: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/start/vim-sandwich/autoload/sandwich.vim
      048.009  000.231  000.231: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/conflict-marker.vim/plugin/conflict_marker.vim
      052.714  000.090  000.090: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/direnv.vim/autoload/direnv.vim
      052.744  003.384  003.295: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/direnv.vim/plugin/direnv.vim
      053.541  000.016  000.016: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/cls.vim
      053.674  000.015  000.015: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim
      054.128  000.071  000.071: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tikz.vim
      054.166  030.081  025.084: sourcing /Users/hazelweakly/.config/nvim/plugin/packer_compiled.lua
      055.460  005.408: loading rtp plugins
      057.092  000.123  000.123: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/start/FixCursorHold.nvim/plugin/fix_cursorhold_nvim.vim
      058.333  000.146  000.146: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/start/nvim-rooter.lua/plugin/nvim-rooter.lua
      058.654  000.054  000.054: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/start/vim-fetch/plugin/fetch.vim
      060.526  000.155  000.155: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/start/vim-sandwich/plugin/operator/sandwich.vim
      060.734  000.128  000.128: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/start/vim-sandwich/plugin/sandwich.vim
      061.055  000.201  000.201: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/start/vim-sandwich/plugin/textobj/sandwich.vim
      061.694  005.427: loading packages
      061.780  000.085: loading after plugins
      061.788  000.008: inits 3
      064.070  002.282: reading ShaDa
      064.100  000.030: clearing screen
      069.606  002.062  002.062: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/nvim-treesitter/plugin/nvim-treesitter.vim
      072.739  000.309  000.309: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/scripts.vim
      072.939  000.025  000.025: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/conflict-marker.vim/autoload/conflict_marker/detect.vim
      077.923  000.301  000.301: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/scripts.vim
      078.362  000.120  000.120: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/autoload/provider/clipboard.vim
      080.510  000.454  000.454: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-textsubjects/plugin/nvim-treesitter-textsubjects.vim
      082.523  001.215  001.215: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/nvim-ts-autotag/plugin/nvim-ts-autotag.vim
      085.125  000.437  000.437: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-refactor/plugin/nvim-treesitter-refactor.vim
      086.937  000.937  000.937: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-textobjects/plugin/nvim-treesitter-textobjects.vim
      088.613  000.301  000.301: sourcing /nix/store/7q1215i2idiqymqx14f9df5labshcyn3-neovim-unwrapped-master/share/nvim/runtime/scripts.vim
      090.196  000.362  000.362: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/nvim-ts-rainbow/plugin/rainbow.vim
      092.896  000.082  000.082: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/nvim-web-devicons/plugin/nvim-web-devicons.vim
      105.481  000.438  000.438: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/indent-blankline.nvim/plugin/indent_blankline.vim
      106.786  000.026  000.026: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/nvim-colorizer.lua/plugin/colorizer.vim
      109.843  038.672: opening buffers
      110.981  000.023  000.023: sourcing /Users/hazelweakly/.local/share/nvim/site/pack/packer/opt/direnv.vim/autoload/direnv/extra_vimrc.vim
      111.085  001.218: BufEnter autocommands
      111.087  000.002: editing files in windows
