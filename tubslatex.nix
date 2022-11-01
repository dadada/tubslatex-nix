{ lib
, stdenvNoCC
, texlive
, unzip
, requireFile
, ...
}:
let
  pname = "tubslatex";
  version = "1.3.4";
  tubslatexDownload = requireFile {
    name = "${pname}_${version}.tds.zip";
    sha256 = "18adp73l1iqn050ivzjmnp6rgpihkl1278x4ip93xjpicd7mrnlv";
    url = "https://www.tu-braunschweig.de/latex-vorlagen";
  };
in
stdenvNoCC.mkDerivation {
  inherit version pname;
  src = tubslatexDownload;
  passthru.tlType = "run";
  nativeBuildInputs = [ unzip texlive.combined.scheme-small ];
  dontConfigure = true;
  unpackPhase = ''
    runHook preUnpack
    unzip "$src"
    runHook postUnpack
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r * $out/
    runHook postInstall
  '';
  meta = with lib; {
    description = "TU Braunschweig Corporate Design";
    maintainers = [ "dadada" ];
    platforms = platforms.all;
    license = licenses.unfree;
  };
}
