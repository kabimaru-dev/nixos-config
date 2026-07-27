{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_hardened;
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

    desktopManager.gnome.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  users.users = {
    Gabimaru = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      packages = with pkgs; [
        git gh zed-editor               # Develop
        fastfetch gparted pavucontrol   # Linux
        mesa                            # Drivers
        firefox tor-browser             # Browsers
      ];
    };
  };


  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  system.stateVersion = "25.11";
}
