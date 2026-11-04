{
  description = "Flake-based Nix devshell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
  outputs =
    { nixpkgs, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f: nixpkgs.lib.genAttrs supportedSystems (system: f { pkgs = import nixpkgs { inherit system; }; });
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShellNoCC {
            env.LUA_PATH = pkgs.luajitPackages.luaLib.genLuaPathAbsStr pkgs.luajitPackages.fennel;
            packages = with pkgs; [ love ];
          };
        }
      );

      packages = forEachSupportedSystem (
        { pkgs }:
        let
          default = pkgs.callPackage ./. { };
        in
        {
          inherit default;
          lovix = default;
        }
      );
    };
}
