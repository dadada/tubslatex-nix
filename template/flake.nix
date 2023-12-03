{
  description = "Thesis";
  inputs.flake-utils.url = github:numtide/flake-utils;
  inputs.tubslatex.url = "github:dadada/tubslatex-nix";

  outputs = { self, flake-utils, nixpkgs, devshell, tubslatex }@inputs:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            # Allow use of tubslatex although it is under an unfree license
            config.allowUnfree = true;
            overlays = [ tubslatex.overlays.default ];
          };
        in
        {
          devShells.default = pkgs.mkShell {
            packages = [ pkgs.texliveWithTubslatex ];
            shellHook = ''
              echo 'Run `make` to build the thesis.pdf or `make watch` to continuously watch for changes.'
            '';
          };
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
                description = "Master thesis";
                platforms = platforms.all;
                license = licenses.proprietary;
              };
            })
            { };
        });
}
