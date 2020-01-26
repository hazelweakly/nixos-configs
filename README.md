# nixos-configs

Configurations for my NixOS systems (work/home laptops)

Very WIP.

I'm building these with a focus on minimal abstraction and redirection until the need arises.
Essentially, I'm writing the ugly solution and waiting until it's painful before cleaning it up.
This is in hopes that these files and git history can be useful to people just starting with NixOS and trying to make sense of some of the _very_ complicated configuration setups out there.

## Install Instructions

- Clone somewhere.

### NixOS

- Remove /etc/nixos and symlink this repo to /etc/nixos
- chown /etc/nixos to your user.
- symlink the appropriate machine specific file to configuration.nix
  - eg: `ln -s $PWD/precision7740.nix $PWD/configuration.nix`

This kinda setup assumes it's a single user install, but meh.

The rest is todo. I've used these configs in various states of inspiration on a macOS install and sorta-kinda on a Ubuntu install.
Currently I've just manually created appropriate files and copied the relevant bits where useful.
Having home-manager in configuration.nix simplifies things for NixOS but also complicates the non NixOS stuff, so I'll probably split that out?

Misc notes:

home-manager on Linux and macOS wants to live in `~/.config/nixpkgs/home.nix`

nix-darwin currently wants to have its main configuration file live in `~/.nixpkgs/darwin-configuration.nix`.
Life would be simpler if it was `~/.config/nixpkgs/darwin.nix`, so I should probably set that up some time.
nix-darwin's repo has an example file detailing some of the basic steps needed to get that done.

TODO: Incorporate haskell, rust, etc., setups somehow.

Add?:

- <https://github.com/rhysd/git-brws>
- <https://gist.github.com/sn0opy/02baf5fdcfe71d1db4039f1946500928>

haskell:

- haskdogs
- gutenhasktags
- <https://github.com/ChrisPenner/ChrisPenner.github.io/blob/site/app/Main.hs>
- <https://github.com/GuillaumeDesforges/haskell-nix-dev-template>
- Project specific neovim config
  - <https://discourse.nixos.org/t/project-specific-neovim-configuration/3233/3>
  - <https://github.com/teto/home/blob/master/config/nixpkgs/overlays/neovim.nix>
  - <https://git.sr.ht/~rycwo/workspace/blob/39844721282d5a81710b026b71b907c3df20140c/nixos/user/pkgs/neovim/default.nix>
  - <https://github.com/rvolosatovs/infrastructure/blob/8b68427ff259299b94838aa89a2d1036f6d1e099/nixpkgs/neovim/config.nix#L81-L113>

```vim
let g:gutentags_project_info = [ {'type': 'python', 'file': 'setup.py'},
                               \ {'type': 'ruby', 'file': 'Gemfile'},
                               \ {'type': 'haskell', 'file': 'Setup.hs'} ]
let g:gutentags_ctags_executable_haskell = 'gutenhasktag
```
