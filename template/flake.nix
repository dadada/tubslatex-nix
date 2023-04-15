{
  description = "Thesis";
  inputs.flake-utils.url = github:numtide/flake-utils;
  inputs.devshell.url = github:numtide/devshell;
  inputs.tubslatex.url = "github:dadada/tubslatex-nix";

  outputs = { self, flake-utils, nixpkgs, devshell, tubslatex }@inputs:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          tubslatexOverlay = tubslatex.overlays.default;
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ tubslatexOverlay ];
          };
        in
        {
          devShells.default =
            let
              pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
                overlays = [
                  devshell.overlays.default
                  tubslatexOverlay
                ];
              };
            in
            pkgs.devshell.mkShell {
              imports = [ (pkgs.devshell.importTOML ./devshell.toml) ];
            };

          checks = {
            format = pkgs.runCommand "format" { buildInputs = [ pkgs.nixpkgs-fmt ]; } "nixpkgs-fmt --check ${./.} && touch $out";
          };

          formatter = pkgs.nixpkgs-fmt;

          packages.default = pkgs.callPackage
            ({ lib, texliveWithTubslatex, stdenvNoCC, ... }: stdenvNoCC.mkDerivation {
              pname = "thesis";
              version = "0.1";
              src = ./.;
              nativeBuildInputs = [ texliveWithTubslatex ];
              dontConfigure = true;
              installPhase = ''
                mkdir -p $out
                cp thesis.pdf $out
              '';
              meta = with lib; {
                description = "Master thesis proposal";
                maintainers = [ "dadada" ];
                platforms = platforms.all;
                license = licenses.proprietary;
              };
            })
            { };
        });
}
