{
	inputs = {
		# nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		# nixpkgsold.url = "github:NixOS/nixpkgs/nixos-25.11";
		# nixpkgsveryold.url = "github:NixOS/nixpkgs/nixos-24.05";
		nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
	};

	outputs = { nix-cachyos-kernel, nixpkgs, ... } @ inputs:
	{
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs; };
			modules = [
				./configuration.nix
				(
					{ pkgs, ... }:
					{
						nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ];
						boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-hardened;

						# Binary cache is auto-configured via nixConfig in flake.nix,
						# no additional binary cache config is needed.

						# ... your other configs
					}
				)
			];
		};
	};
}
