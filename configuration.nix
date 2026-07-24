{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.Gabimaru = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      # Window Managers
      sway

      # Software Environment
      git gh vscodium

      # Browsers
      firefox tor-browser 

      # Login
      greetd tuigreet

      # Drivers
      mesa

      # Terminals
      foot

      # Volume
      pavucontrol
      
      # Brightness
      brightnessctl
    ];
  };

  system.stateVersion = "25.11";
}

