final: prev: {
  _1password = prev._1password.overrideAttrs (o: {
    nativeBuildInputs = (o.nativeBuildInputs or [ ]) ++ [ prev.installShellFiles ];
    installPhase = (o.installPhase or "") + ''
      installShellCompletion --cmd op \
        --bash <($out/bin/op completion bash) \
        --zsh  <($out/bin/op completion zsh)
    '';
  });
}
