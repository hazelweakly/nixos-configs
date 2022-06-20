{ self, inputs, ... }@args: self.lib.mkDarwinSystem (args // {
  system = "x86_64-darwin";
})
