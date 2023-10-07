{
  description = "Perimeter81 on Nix";
  inputs = { nixpkgs = { url = "nixpkgs/nixos-unstable"; }; };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    rec {
      packages.${system} = {
        perimeter81-unwrapped = pkgs.callPackage ./perimeter81.nix { };
        perimeter81 = pkgs.callPackage ./fhsenv.nix { perimeter81-unwrapped = packages.${system}.perimeter81-unwrapped; };
      };
      defaultPackage.${system} = packages.${system}.perimeter81;

      overlays = {
        default = final: prev: {
          perimeter81 = defaultPackage.${system};
        };
      };

      nixosModules = {
        perimeter81 = {
          imports = [
            ./module.nix
          ];
          nixpkgs.overlays = [
            self.overlays.default
          ];
        };
      };
    };
}
