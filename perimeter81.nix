{ stdenv, dpkg, writeText }:
stdenv.mkDerivation rec {
  pname = "perimeter81";
  version = "8.0.4.735";
  src = builtins.fetchurl {
    url =
      "https://static.perimeter81.com/agents/linux/Perimeter81_${version}.deb";
    sha256 = "sha256:0zavg1m2ywd0gk48jm3k29k8795vxbplfwr8ai4wlxc0959i4fq6";
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
 
}
