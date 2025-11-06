{
  rev,
  shortRev,
  lastModified,
  foliobinding ? false,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  chroma_code = pkgs.rustPlatform.buildRustPackage {
    pname = "chromacode";
    version = "1.1.0";

    src = inputs.chromacode-src;

    cargoHash = "sha256-zqqu+a1tLkFlPQuo0qzXtBIPUL5yBOUOBWwnypLVSI8=";
  };
  tree-sitter = inputs.tree-sitter-wrapped.packages.${pkgs.system}.default;

  thesis = pkgs.stdenv.mkDerivation {
    pname = "thesis";
    version = "0.1.0";

    src = ./.;

    buildInputs = [
      pkgs.quarto
      pkgs.texliveFull
      pkgs.tzdata
      chroma_code
      tree-sitter
    ];

    patchPhase = ''
      runHook prePatch

      patchShebangs template/prelims/cleanup.bash

      runHook postPatch
    '';

    buildPhase = ''
      runHook preBuild

      DATE="$(TZ='America/Los_Angeles' ${pkgs.lib.getExe' pkgs.coreutils "date"} -d '@${toString lastModified}' +'%B %-d, %Y at %-I:%M%P (%z)')"

      echo "Calculated last commit date of flake as $DATE"

      mkdir $out

      echo "Created output directory"

      export HOME=$(mktemp -d)

      echo "Overriding HOME to avoid complaints from quarto"

      quarto render --to pdf --no-cache -M "commitRev:${rev}" -M "commitShortRev:${shortRev}" -M "commitDate:''${DATE}" ${lib.optionalString foliobinding "-M classoption:foliobinding"} -o thesis.pdf --output-dir $out

      runHook postBuild
    '';
  };
in
  # pkgs.runCommandNoCC "thesis.pdf" { } ''
  #   ln -s ${thesis}/thesis.pdf $out
  # ''
  thesis
