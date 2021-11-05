final: prev:
let pkgs = import final.inputs.latest.outPath { inherit (prev) config system; }; in
{
  asciidoctor = pkgs.asciidoctor;
}
