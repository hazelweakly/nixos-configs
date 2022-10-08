final: prev: {
  # kitty = prev.kitty.overridePythonAttrs (o: {
  #   doCheck = false;
  #   # Doesn't work because kitty uses a test.py file
  #   disabledTests = (o.disabledTests or [ ])
  #     ++ prev.lib.optionals (prev.stdenv.isDarwin) [ "test_ssh_shell_integration" "test_ssh_copy" ];
  # });
}
