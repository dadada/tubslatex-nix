{
  description = "tubslatex";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, flake-utils, nixpkgs }@inputs:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        {
          packages = rec {
            default = tubslatex;
            tubslatex = pkgs.tubslatex;
          };

          checks = {
            format = pkgs.runCommand "format" { buildInputs = [ pkgs.nixpkgs-fmt ]; } "nixpkgs-fmt --check ${./.} && touch $out";
            testOverlay = pkgs.mkShell {
              buildInputs = [ pkgs.texliveWithTubslatex ];
              shellHook = ''Shell created'';
            };
          };

          formatter = pkgs.nixpkgs-fmt;
        }) // {
      overlays.default = final: prev: {
        tubslatex = prev.callPackage ./tubslatex.nix { };

        texliveWithTubslatex =
          let
            postCombineOverride = oldAttrs: {
              postBuild = oldAttrs.postBuild + ''
                updmap --sys --enable Map=NexusProSerif.map --enable Map=NexusProSans.map
                updmap --sys
              '';
            };

            tubslatexAttrs = { pkgs = [ final.tubslatex ]; };

            combined = prev.texlive.combine {
              inherit (prev.texlive) scheme-full;
              inherit tubslatexAttrs;
            };
          in
          combined.overrideAttrs postCombineOverride;
      };
    };
}
