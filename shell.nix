{ pkgs, inputs, ... }:

let
  chroma_code = pkgs.rustPlatform.buildRustPackage {
    pname = "chromacode";
    version = "1.1.0";

    src = inputs.chromacode-src;

    cargoHash = "sha256-zqqu+a1tLkFlPQuo0qzXtBIPUL5yBOUOBWwnypLVSI8=";
  };
  tree-sitter = inputs.tree-sitter-wrapped.packages.${pkgs.system}.default;
in

pkgs.mkShell {
  packages = [
    pkgs.texliveFull
    pkgs.quarto
    chroma_code
    tree-sitter
    pkgs.nix-output-monitor
  ];

  name = "sam's thesis shell";

  shellHook = ''
    echo "Thanks for building my thesis!"
  '';
}
