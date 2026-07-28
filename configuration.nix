{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
	
	#kernelPackages = pkgs.linuxPackages_latest;
	#kernelPackages = pkgs.linuxPackagesFor (pkgs.linuxKernel.kernels.linux_6_19.override {
	#	argsOverride = rec {
	#		src = pkgs.fetchurl {
	#		    url = "mirror://kernel/linux/kernel/v6.x/linux-6.19.tar.xz";
	#		    sha256 = "303079a8250b8f381f82b03f90463d12ac98d4f6b149b761ea75af1323521357";
	#		};
	#		version = "6.19";
	#		modDirVersion = "6.19";
	#	};
	#});
    
    #kernelPatches = [
	#{
	#	name = "CVE-2026-31431-copy-fail";
	#	patch = ./kernel-security-patches/CVE-2026-31431-copy-fail.patch;
	#	structuredExtraConfig.CVE-2026-31431-copy-fail = lib.kernel.yes;
	#	features.CVE-2026-31431-copy-fail = true;
	#}
    #];
  };

  networking.networkmanager.enable = true;

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd GNOME";
        user = "greeter";
      };
    };
    
    xserver = {
      enable = true;
      layout = "us, ru";
      xkbOptions = "grp:alt_shift_toggle";
      libinput = {
      	enable = true;
      };
    };

    desktopManager.gnome.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  users.users = {
    Gabimaru = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      packages = with pkgs; [
        git gh python3 python313Packages.pip pipx zed-editor android-tools 	# Develop
        androidStudioPackages.stable clang					# 
        
        fastfetch gparted pavucontrol   					# Linux
        mesa                            					# Drivers
        firefox tor-browser             					# Browsers
        telegram-desktop							# etc
      ];
    };
  };


  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  system.stateVersion = "25.11";
}
