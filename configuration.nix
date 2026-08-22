{ config, lib, pkgs, ... }:
{   
  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;

    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      nvidiaBusId = "PCI:1:0:0";
      intelBusId  = "PCI:0:2:0";
    };
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  environment.variables = {
    __NV_PRIME_RENDER_OFFLOAD = "1";
    __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
  # virtualisation.docker.enable = true;
  # security.pam.services.Gabimaru.enableGnomeKeyring = false;
  programs.nix-ld.enable = true;

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
    # gnome.gnome-keyring.enable = true;
  };
  
  users.users = {
    Gabimaru = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      packages = with pkgs; [
        git gh /* python3 python313Packages.pip pipx */ vscodium nil android-tools            # Develop
        /* androidStudioPackages.stable */ vulkan-tools cmake clang gnumake                   #
        vulkan-headers vulkan-loader pkg-config glfw glm docker nodejs                        #
        wayland-scanner libxcb libX11 libXau libXdmcp libXrandr wayland 
        wayland-protocols mesa-demos virtualgl virtualglLib vulkan-validation-layers
        libGL (lib.getDev glfw) libglvnd (lib.getDev libglvnd) glfw3 libgcc gcc
        gdb gdbHostCpuOnly shaderc glslang


        fastfetch gparted pavucontrol tree peazip zip unzip gnome-extension-manager           # Linux
        gnome-tweaks busybox-sandbox-shell pciutils yad coreutils gnutar gnused bash
        wget curl xdg-utils gtk3 gdk-pixbuf glib wine
        
        
        mesa                                                                                  # Drivers
        firefox tor-browser                                                                   # Browsers
        
        
        telegram-desktop obs-studio krita qbittorrent inkscape element-desktop blender        # etc
        audacity yt-dlp steam-run-free


        gnomeExtensions.forge
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
    
    settings = 
      let GB = 1024 * 1024 * 1024; in # 1GB
      let total_storage = 175 * GB; in # 175GB
      let if_forty_percent_free__clean_it = total_storage / 100 * 40; in # 175%*40 = 70GB
      {
      # if storage is less than 40% free in total_storage - clean it!
      min-free = if_forty_percent_free__clean_it;
    };
  };

  system.stateVersion = "26.05";
}