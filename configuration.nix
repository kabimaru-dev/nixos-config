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

  services.pipewire.enable = true;
  services.pipewire.pulse.enable = true;

  programs.sway.enable = true;
  programs.sway.wrapperFeatures.gtk = true;

  services.greetd = {
    enable = true;
    settings.default_session = {                                                  
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd GNOME";
      user = "greeter";                                                  
    };
  };

  services.desktopManager.gnome.enable = true;
  services.gnome.gnome-keyring.enable = true;

  users.users.Gabimaru = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      # Software Environment
      git gh vscodium

      # Linux Environment
      fastfetch

      # Browsers
      firefox tor-browser 

      # Drivers
      mesa

      # Volume
      pavucontrol
    ];
  };

  system.stateVersion = "25.11";
}

