{ config, lib, pkgs, ... }:

{
  # nixpkgs.config.allowUnfree = true;

  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
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
      layout = "us,ru";
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
        git gh /* python3 python313Packages.pip pipx */ lapce nil android-tools         # Develop
        #androidStudioPackages.stable clang                                             # 
        
        fastfetch gparted pavucontrol tree                                              # Linux
        mesa                                                                            # Drivers
        firefox tor-browser                                                             # Browsers
        telegram-desktop obs-studio krita                                               # etc
      ];
    };
  };


  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  system.stateVersion = "25.11";
}
