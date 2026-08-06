{ config, lib, pkgs, ... }:
let
  cfg = config.custom.services.gnome;
in
{   
  nixpkgs.config.allowUnfree = true;
  # security.pam.services.Gabimaru.enableGnomeKeyring = false;

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
  
  # options.custom.services.gnome = {
  #   enable = lib.mkEnableOption "Setup Gnome";
  #   num-workspaces = lib.mkOption {
  #     type = lib.types.int;
  #     default = 7;
  #     description = "Number of Gnome workspaces";
  #   };
  # };
  
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
    # gnome.gnome-keyring.enable = true;
  };

  users.users = {
    Gabimaru = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      packages = with pkgs; [ cmake vulkan-headers vulkan-loader
        git gh /* python3 python313Packages.pip pipx */ lapce nil android-tools           # Develop
        /* androidStudioPackages.stable */ vulkan-tools cmake clang gnumake 
        vulkan-headers vulkan-loader pkg-config glfw glm
        
        fastfetch gparted pavucontrol tree peazip zip unzip                               # Linux
        mesa                                                                              # Drivers
        firefox tor-browser                                                               # Browsers
        
        
        telegram-desktop obs-studio krita discord                                       # etc
      ];
    };
  };


  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 14d";
    };
    # settings = {
    #   let GB = 1024 * 1024 * 1024; your-default-storage = 2500 * GB; in 
      
    #   # 60%2500GB
    # };
  };
  
  
  # # Automatic Garbage Collection
  # nix = {
  #   gc = {
  #     automatic = true;
  #     dates = "daily";
  #     options = "--delete-older-than 14d";
  #   };
  #   # settings = {
      
  #   #   minimum-GB = 10;
  #   #   maximum-GB = 20;
  #   #   min-free = 1024 * 1024 * 1024;
  #   #   max-free = 5 * 1024 * 1024 * 1024;
  #   # };
  # };

  # let myName = "Gabimaru"; in 
  # let myNameAndOld = "${myName} ${toString 24}"; in
  #     "Hello ${myNameAndOld} years old, you are the best on your OS!!!"

  system.stateVersion = "26.05";
}