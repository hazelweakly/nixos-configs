- https://github.com/bbigras/nix-config/
- https://github.com/nix-community/impermanence
- https://github.com/lovesegfault/nix-config

# nixos-configs

Configurations for my NixOS systems (work/home laptops)

I'm building these with a focus on minimal abstraction and redirection until the need arises.
Essentially, I'm writing the ugly solution and waiting until it's painful before cleaning it up.
This is in hopes that these files and git history can be useful to people just starting with NixOS and trying to make sense of some of the _very_ complicated configuration setups out there.

## Design philosophy

- Avoid channels wherever possible
- System overlays should be available in all nix CLI tools
- Full system can be created from a single command with no incremental bootstrapping needed
- Whenever possible, have declarative configuration of environment.
  - Try to keep configuration in the natural language of that environment. (eg don't fully embed vimrc into nix)
- (Soon) System configuration should be buildable from CI

Future directions:

- Use flakes when possible. https://github.com/nrdxp/nixflk/network/members
- https://github.com/lovesegfault/nix-config/tree/master inspiration from this

## Install Instructions

- Clone somewhere.

### NixOS

- Remove /etc/nixos and symlink this repo to /etc/nixos
- chown /etc/nixos to your user.
- create a configuration.nix that imports the right machine file and the `common.nix` file

This kinda setup assumes it's a single user install, but meh.

The rest is todo. I've used these configs in various states of inspiration on a macOS install and sorta-kinda on a Ubuntu install.
Currently I've just manually created appropriate files and copied the relevant bits where useful.

TODO: Incorporate haskell, rust, etc., setups somehow. Encrypt and store things like `work.nix` somehow.

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
