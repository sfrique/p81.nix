{
  stdenv,
  dpkg,
  writeText,
}:
stdenv.mkDerivation rec {
  pname = "perimeter81";
  version = "10.0.2.915";
  src = builtins.fetchurl {
    url = "https://static.perimeter81.com/agents/linux/Perimeter81_${version}.deb";
    sha256 = "sha256:d6dcebce86e87a873758232c9bb7b64ac69581d542312678ba393b416236961f";
  };

  nativeBuildInputs = [ dpkg ];

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x $src .

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp -R "opt" "$out"
    cp -R "usr/share" "$out/share"
    chmod -R g-w "$out"

    # Desktop file
    mkdir -p "$out/share/applications"

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/share/applications/perimeter81.desktop \
      --replace-fail '/opt/Perimeter81/perimeter81 %U' 'perimeter81 %U'
  '';

}
