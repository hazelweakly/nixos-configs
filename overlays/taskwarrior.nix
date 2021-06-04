final: prev: {
  taskwarrior = prev.taskwarrior.overrideAttrs (
    o: rec {
      version = "2.6.0";
      src = final.inputs.taskwarrior;
      postInstall = ''
        mkdir -p "$out/share/bash-completion/completions"
        ln -s "../../doc/task/scripts/bash/task.sh" "$out/share/bash-completion/completions/task.bash"
        mkdir -p "$out/share/fish/vendor_completions.d"
        ln -s "../../../share/doc/task/scripts/fish/task.fish" "$out/share/fish/vendor_completions.d/task.fish"
        mkdir -p "$out/share/zsh/site-functions"
        ln -s "../../../share/doc/task/scripts/zsh/_task" "$out/share/zsh/site-functions/_task"
      '';
    }
  );
}
