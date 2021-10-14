{ self, inputs, ... }:
let lib = inputs.digga.lib; in
{
  users = lib.rakeLeaves ./users;
}
