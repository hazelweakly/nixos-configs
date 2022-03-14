{ config, lib, pkgs, ... }:
# vendored from home-manager so that I can add one last thing that's bugging me

with lib;

let

  cfg = config.programs.myneovim;

  jsonFormat = pkgs.formats.json { };

  extraPython3PackageType = mkOptionType {
    name = "extra-python3-packages";
    description = "python3 packages in python.withPackages format";
    check = with types;
      (x: if isFunction x then isList (x pkgs.python3Packages) else false);
    merge = mergeOneOption;
  };

  extraLuaPackageType = mkOptionType {
    name = "extra-lua-packages";
    description = "lua packages in programs.neovim.package.lua.withPackages format";
    check = with types;
      (x: if isFunction x then isList (x cfg.program.lua.pkgs) else false);
    merge = mergeOneOption;
  };

  pluginWithConfigType = types.submodule {
    options = {
      config = mkOption {
        type = types.lines;
        description =
          "Script to configure this plugin. The scripting language should match type.";
        default = "";
      };

      type = mkOption {
        type =
          types.either (types.enum [ "lua" "viml" "teal" "fennel" ]) types.str;
        description =
          "Language used in config. Configurations are aggregated per-language.";
        default = "viml";
      };

      optional = mkEnableOption "optional" // {
        description = "Don't load by default (load with :packadd)";
      };

      plugin = mkOption {
        type = types.package;
        description = "vim plugin";
      };
    };
  };

  # A function to get the configuration string (if any) from an element of 'plugins'
  pluginConfig = p:
    if p ? plugin && (p.config or "") != "" then ''
      " ${p.plugin.pname or p.plugin.name} {{{
      ${p.config}
      " }}}
    '' else
      "";

  moduleConfigure = {
    packages.home-manager = {
      start = remove null (map
        (x: if x ? plugin && x.optional == true then null else (x.plugin or x))
        cfg.plugins);
      opt = remove null
        (map (x: if x ? plugin && x.optional == true then x.plugin else null)
          cfg.plugins);
    };
    beforePlugins = "";
  };

  extraMakeWrapperArgs = lib.optionalString (cfg.extraPackages != [ ])
    ''--suffix PATH : "${lib.makeBinPath cfg.extraPackages}"'';
in
{
  options = {
    programs.myneovim = {
      enable = mkEnableOption "Neovim";

      viAlias = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Symlink <command>vi</command> to <command>nvim</command> binary.
        '';
      };

      vimAlias = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Symlink <command>vim</command> to <command>nvim</command> binary.
        '';
      };

      vimdiffAlias = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Alias <command>vimdiff</command> to <command>nvim -d</command>.
        '';
      };

      withNodeJs = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable node provider. Set to <literal>true</literal> to
          use Node plugins.
        '';
      };

      withRuby = mkOption {
        type = types.nullOr types.bool;
        default = true;
        description = ''
          Enable ruby provider.
        '';
      };

      withPython3 = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable Python 3 provider. Set to <literal>true</literal> to
          use Python 3 plugins.
        '';
      };

      manifestRc = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether or not to use the generated rc file.
        '';
      };

      extraPython3Packages = mkOption {
        type = with types; either extraPython3PackageType (listOf package);
        default = (_: [ ]);
        defaultText = "ps: []";
        example = literalExpression "(ps: with ps; [ python-language-server ])";
        description = ''
          A function in python.withPackages format, which returns a
          list of Python 3 packages required for your plugins to work.
        '';
      };

      extraLuaPackages = mkOption {
        type = with types; extraLuaPackageType;
        default = (_: [ ]);
        defaultText = "ps: []";
        example = literalExpression "(ps: with ps; [ luautf8 ])";
        description = ''
          A function in neovim-unwrapped.lua.withPackages format, which returns a
          list of Lua packages required for your plugins to work.
        '';
      };

      generatedConfigViml = mkOption {
        type = types.lines;
        visible = true;
        readOnly = true;
        description = ''
          Generated vimscript config.
        '';
      };

      generatedConfigs = mkOption {
        type = types.attrsOf types.lines;
        visible = true;
        readOnly = true;
        example = literalExpression ''
          {
            viml = '''
              " Generated by home-manager
              set packpath^=/nix/store/cn8vvv4ymxjf8cfzg7db15b2838nqqib-vim-pack-dir
              set runtimepath^=/nix/store/cn8vvv4ymxjf8cfzg7db15b2838nqqib-vim-pack-dir
            ''';

            lua = '''
              -- Generated by home-manager
              vim.opt.background = "dark"
            ''';
          }'';
        description = ''
          Generated configurations with as key their language (set via type).
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.neovim-unwrapped;
        defaultText = literalExpression "pkgs.neovim-unwrapped";
        description = "The package to use for the neovim binary.";
      };

      finalPackage = mkOption {
        type = types.package;
        visible = false;
        readOnly = true;
        description = "Resulting customized neovim package.";
      };

      configure = mkOption {
        type = types.attrsOf types.anything;
        default = { };
        example = literalExpression ''
          configure = {
              customRC = $''''
              " here your custom configuration goes!
              $'''';
              packages.myVimPackage = with pkgs.vimPlugins; {
                # loaded on launch
                start = [ fugitive ];
                # manually loadable by calling `:packadd $plugin-name`
                opt = [ ];
              };
            };
        '';
        description = ''
          Deprecated. Please use the other options.

          Generate your init file from your list of plugins and custom commands,
          and loads it from the store via <command>nvim -u /nix/store/hash-vimrc</command>

          </para><para>

          This option is mutually exclusive with <varname>extraConfig</varname>
          and <varname>plugins</varname>.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          set nocompatible
          set nobackup
        '';
        description = ''
          Custom vimrc lines.

          </para><para>

          This option is mutually exclusive with <varname>configure</varname>.
        '';
      };

      extraPackages = mkOption {
        type = with types; listOf package;
        default = [ ];
        example = "[ pkgs.shfmt ]";
        description = "Extra packages available to nvim.";
      };

      plugins = mkOption {
        type = with types; listOf (either package pluginWithConfigType);
        default = [ ];
        example = literalExpression ''
          with pkgs.vimPlugins; [
            yankring
            vim-nix
            { plugin = vim-startify;
              config = "let g:startify_change_to_vcs_root = 0";
            }
          ]
        '';
        description = ''
          List of vim plugins to install optionally associated with
          configuration to be placed in init.vim.

          </para><para>

          This option is mutually exclusive with <varname>configure</varname>.
        '';
      };

      coc = {
        enable = mkEnableOption "Coc";

        settings = mkOption {
          type = jsonFormat.type;
          default = { };
          example = literalExpression ''
            {
              "suggest.noselect" = true;
              "suggest.enablePreview" = true;
              "suggest.enablePreselect" = false;
              "suggest.disableKind" = true;
              languageserver = {
                haskell = {
                  command = "haskell-language-server-wrapper";
                  args = [ "--lsp" ];
                  rootPatterns = [
                    "*.cabal"
                    "stack.yaml"
                    "cabal.project"
                    "package.yaml"
                    "hie.yaml"
                  ];
                  filetypes = [ "haskell" "lhaskell" ];
                };
              };
            };
          '';
          description = ''
            Extra configuration lines to add to
            <filename>$XDG_CONFIG_HOME/nvim/coc-settings.json</filename>
            See
            <link xlink:href="https://github.com/neoclide/coc.nvim/wiki/Using-the-configuration-file" />
            for options.
          '';
        };
      };

      preWrapperArgs = mkOption {
        type = with types; listOf lines;
        default = [ ];
        example = ''
          ["--run" "echo 'running this command before any others in the wrapper'"]
        '';
        description = ''
          Custom arguments to prepend to makeWrapper

          <para></para>

          These are not wrapped in escapeShellArgs or otherwise modified in any way.
        '';
      };
      postWrapperArgs = mkOption {
        type = with types; listOf lines;
        default = [ ];
        example = ''
          ["--set" "VAR" "$PATH"]
        '';
        description = ''
          Custom arguments to append to makeWrapper. They execute after all other modifications in the wrapper.

          <para></para>

          These are not wrapped in escapeShellArgs or otherwise modified in any way.
        '';
      };
    };
  };

  config =
    let
      # transform all plugins into an attrset
      pluginsNormalized = map
        (x:
          if (x ? plugin) then
            x
          else {
            type = x.type or "viml";
            plugin = x;
            config = "";
            optional = false;
          })
        cfg.plugins;
      suppressNotVimlConfig = p:
        if p.type != "viml" then p // { config = ""; } else p;

      neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
        inherit (cfg)
          extraPython3Packages extraLuaPackages withPython3 withNodeJs withRuby viAlias vimAlias;
        configure = cfg.configure // moduleConfigure;
        plugins = (map suppressNotVimlConfig pluginsNormalized)
          ++ optionals cfg.coc.enable [{ plugin = pkgs.vimPlugins.coc-nvim; }];
        customRC = cfg.extraConfig;
      };

    in
    mkIf cfg.enable {
      warnings = optional (cfg.configure != { }) ''
        programs.neovim.configure is deprecated.
        Other programs.neovim options can override its settings or ignore them.
        Please use the other options at your disposal:
          configure.packages.*.opt  -> programs.neovim.plugins = [ { plugin = ...; optional = true; }]
          configure.packages.*.start  -> programs.neovim.plugins = [ { plugin = ...; }]
          configure.customRC -> programs.neovim.extraConfig
      '';

      programs.myneovim.generatedConfigViml = neovimConfig.neovimRcContent;

      programs.myneovim.generatedConfigs =
        let
          grouped = lib.lists.groupBy (x: x.type) pluginsNormalized;
          concatConfigs = lib.concatMapStrings (p: p.config);
        in
        mapAttrs (name: vals: concatConfigs vals) grouped;

      home.packages = [ cfg.finalPackage ];

      xdg.configFile."nvim/init.vim" = mkIf (cfg.manifestRc && neovimConfig.neovimRcContent != "") {
        text =
          if hasAttr "lua" config.programs.myneovim.generatedConfigs then
            neovimConfig.neovimRcContent + ''

          lua require('init-home-manager')''
          else
            neovimConfig.neovimRcContent;
      };
      xdg.configFile."nvim/lua/init-home-manager.lua" =
        mkIf (cfg.manifestRc && hasAttr "lua" config.programs.myneovim.generatedConfigs) {
          text = config.programs.myneovim.generatedConfigs.lua;
        };
      xdg.configFile."nvim/coc-settings.json" = mkIf (cfg.manifestRc && cfg.coc.enable) {
        source = jsonFormat.generate "coc-settings.json" cfg.coc.settings;
      };

      programs.myneovim.finalPackage = pkgs.wrapNeovimUnstable cfg.package
        (neovimConfig // {
          wrapperArgs = (builtins.concatStringsSep " " cfg.preWrapperArgs) + " "
            + (lib.escapeShellArgs neovimConfig.wrapperArgs) + " "
            + extraMakeWrapperArgs + " "
            + (builtins.concatStringsSep " " cfg.postWrapperArgs);
          wrapRc = false;
        });

      programs.bash.shellAliases = mkIf cfg.vimdiffAlias { vimdiff = "nvim -d"; };
      programs.fish.shellAliases = mkIf cfg.vimdiffAlias { vimdiff = "nvim -d"; };
      programs.zsh.shellAliases = mkIf cfg.vimdiffAlias { vimdiff = "nvim -d"; };
    };
}
