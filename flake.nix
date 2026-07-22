{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixpkgsveryold.url = "github:NixOS/nixpkgs/nixos-24.05";
    };

    outputs = { self, nixpkgs, nixpkgsveryold }:
        let
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            pkgsold = nixpkgsveryold.legacyPackages.x86_64-linux;
        in 
        {
            packages.x86_64-linux.hello = pkgs.hello;
            packages.x86_64-linux.default = pkgs.hello;

            devShells.x86_64-linux.default = pkgs.mkShell {
                buildInputs = with pkgs; [
                    pkgs.neovim pkgsold.krita
                ];
            };
        };
}