{ config, lib, pkgs, ... }:
let
  portproton-src = builtins.fetchTarball {
    url = "https://github.com/Redm00use/PortProton-NixOS/archive/main.tar.gz";
  };
in
{
  # Choose WM
  # services.desktopManager.gnome.enable = true;
  # services.xserver.desktopManager.cinnamon.enable = true;
  # services.xserver.desktopManager.enlightenment.enable = true;
  # services.xserver.windowManager.qtile.enable = true;
  # services.dbus.enable = true;

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = with pkgs; [
  #     xdg-desktop-portal-hyprland
  #   ];
  # };

  # Imports
  imports = [
    ./hardware-configuration.nix
  ];

  # PortProton
  nixpkgs.overlays = [
    (import "${portproton-src}/overlay.nix")
  ];


  # Boot
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  };


  # Services
  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    # displayManager.ly.enable = true;
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
        user = "greeter";
      };
    };

    xserver = {
      videoDrivers = [ "nvidia" ];
      enable = true;
      xkb.layout = "us,ru";
      xkb.options = "grp:alt_shift_toggle";
    };

    power-profiles-daemon = {
      enable = true;
    };

    upower = {
      enable = true;
    };

    libinput = {
      enable = true;
    };

    # gnome.gnome-keyring.enable = true;
  };


  # Insecure Packages
  nixpkgs.config = { allowUnfree = true; permittedInsecurePackages = [ 
      "electron-39.8.10"
    ];
  };
  # All Packages
  users.users = {
    user = {
      isNormalUser = true;
      extraGroups = [ "wheel" "input" ];
      packages = with pkgs; [
        # Niri
        # niri alacritty kitty swaylock grim slurp foot cliphist fuzzel mako swaybg 
        # xwayland-satellite noctalia-shell

        alacritty kitty foot swaylock swaybg noctalia-shell

        waydroid ollama flameshot balsa labwc hyprland
        
        python313Packages.uv python314Packages.uv uv

        # xdg-desktop-portal-xapp gpu-screen-recorder gpu-screen-recorder-gtk 
        xdg-desktop-portal-hyprland

        # Keyboard
        ibus 

        # Portproton & Steam-Run & Wine &
        portproton steam-run wine winetricks dxvk wine-staging


        git gh /* python3 python313Packages.pip pipx */ vscodium nil android-tools            # Develop
        /* androidStudioPackages.stable */ vulkan-tools cmake clang gnumake                   #
        vulkan-headers vulkan-loader pkg-config glfw glm docker nodejs                        #
        wayland-scanner libxcb libX11 libXau libXdmcp libXrandr wayland 
        wayland-protocols mesa-demos virtualgl virtualglLib vulkan-validation-layers
        libGL (lib.getDev glfw) libglvnd (lib.getDev libglvnd) glfw3 libgcc gcc
        gdb gdbHostCpuOnly shaderc glslang 


        fastfetch gparted pavucontrol tree peazip zip unzip gnome-extension-manager           # Linux
        gnome-tweaks busybox-sandbox-shell pciutils yad coreutils gnutar gnused bash
        wget curl xdg-utils gtk3 gdk-pixbuf glib libinput wev libxkbcommon ffmpeg-full
        mpv gamescope

        
        mesa                                                                                  # Drivers
        firefox tor-browser                                                                   # Browsers
        
        
        telegram-desktop obs-studio krita qbittorrent inkscape element-desktop blender        # etc
        audacity yt-dlp steam-run-free bitwarden-desktop electron


        gnomeExtensions.forge gnomeExtensions.blur-my-shell
      ];
    };
  };

  # Programs
  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    niri = {
      enable = true;
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        pango cairo
        glib gtk3 atk gdk-pixbuf
        freetype libx11 libxcursor libxrandr libxinerama
        fontconfig libXext libXcomposite
        wayland libxkbcommon
        zlib glibc
        mesa libGL libglvnd
      ];
    };

    # obs-studio = {
    #   enable = true;

    #   plugins = with pkgs.obs-studio-plugins; [
    #     wlrobs
    #     obs-pipewire-audio-capture
    #   ];
    # };

    gpu-screen-recorder = {
      enable = true;
    };
  };

  # Nix
  nix = {
    # i should to change it
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 14d";
    };
    
    # i should to delete it 
    settings = 
      let GB = 1024 * 1024 * 1024; in # 1GB
      let total_storage = 175 * GB; in # 175GB
      let if_forty_percent_free__clean_it = total_storage / 100 * 5; in # 175%*5 = 8.75GB
      {
      # if storage is less than 40% free in total_storage - clean it!
      min-free = if_forty_percent_free__clean_it;
    };
  };

  # Hardware
  hardware = {
    nvidia = {
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
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
  };

  # Env
  environment = {
    variables = {
      __NV_PRIME_RENDER_OFFLOAD = "1";
      __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
    sessionVariables = {  
      XDG_SESSION_TYPE = "wayland";
      XKB_DEFAULT_LAYOUT = "us,ru";  
      XKB_DEFAULT_OPTIONS = "grp:alt_shift_toggle";
    };
  };







  # Allow Additional Settings
  virtualisation.docker.enable = true;
  # security.pam.services.user.enableGnomeKeyring = false;
  security.polkit.enable = true;
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.flatpak.enable = false;

  system.stateVersion = "26.05";
}

####### CURSOR-GNOME #######
# gsettings set org.gnome.desktop.interface cursor-size 24
# gsettings set org.gnome.desktop.interface cursor-theme Adwaita


####### KEYBOARD-CINNAMON #######
# gsettings set org.cinnamon.desktop.keybindings.wm switch-input-source "['<Alt>Shift_L']"
# gsettings set org.cinnamon.desktop.keybindings.wm switch-input-source-backward "['<Shift><Alt>Shift_L']"

# rm -f ~/.config/autostart/ibus.desktop

# gsettings set org.freedesktop.ibus.general.hotkey triggers "@as []"
# gsettings set org.freedesktop.ibus.general.hotkey trigger "@as []"
# gsettings set org.freedesktop.ibus.general.hotkey next-engine "@as []"

# killall ibus-daemon 2>/dev/null

# gsettings get org.cinnamon.desktop.keybindings.wm switch-input-source
# pgrep -a ibus

# gsettings set org.cinnamon.desktop.keybindings.wm switch-input-source "['<Alt>Shift_L', '<Shift>Alt_L']"