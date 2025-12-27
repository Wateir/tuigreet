{
  description = "Rust Project Template";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = ["x86_64-linux" "aarch64-linux"];
    forEachSystem = nixpkgs.lib.genAttrs systems;
    pkgsForEach = nixpkgs.legacyPackages;
  in {
    packages = forEachSystem (system: {
      tuigreet = pkgsForEach.${system}.callPackage ./nix/package.nix {};
      default = self.packages.${system}.tuigreet;
    });

    devShells = forEachSystem (system: {
      default = pkgsForEach.${system}.callPackage ./nix/shell.nix {};
    });

    hydraJobs = self.packages;

    checks = forEachSystem (system: let
      pkgs = pkgsForEach.${system};
      tuigreet-pkg = self.packages.${system}.tuigreet;
    in {
      tuigreet-test = pkgs.callPackage ./nix/tests/default.nix {
        inherit tuigreet-pkg;
      };
    });
  };
}
