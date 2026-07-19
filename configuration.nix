{ config, lib, pkgs, inputs, ... }:
{
  nix.settings.max-jobs = "auto";
  programs.ccache.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports = [
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [ 
    inputs.nixpkgsveryold.legacyPackages.${pkgs.system}.krita
    inputs.nixpkgsveryold.legacyPackages.${pkgs.system}.qt5.full
    inputs.nixpkgsveryold.legacyPackages.${pkgs.system}.qt6.full
    inputs.nixpkgsveryold.legacyPackages.${pkgs.system}.libglvnd
    inputs.nixpkgsveryold.legacyPackages.${pkgs.system}.qtcreator
    inputs.nixpkgsveryold.legacyPackages.${pkgs.system}.qt6.qtbase
    inputs.nixpkgsveryold.legacyPackages.${pkgs.system}.qt6.qtwebengine
    inputs.nixpkgsveryold.legacyPackages.${pkgs.system}.qt6.qttools
    inputs.nixpkgsveryold.legacyPackages.${pkgs.system}.qt6.qtdeclarative
    inputs.nixpkgsveryold.legacyPackages.${pkgs.system}.qt6.qt5compat
    inputs.nixpkgsveryold.legacyPackages.${pkgs.system}.qt6.qtwebchannel
    inputs.nixpkgsveryold.legacyPackages.${pkgs.system}.qt6.qtpositioning
    inputs.nixpkgsveryold.legacyPackages.${pkgs.system}.wayland
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  
  time.timeZone = "Europe/Kyiv";

  services.xserver.enable = true;
  services.xserver.layout = "us, ru";
  services.xserver.xkbOptions = "grp:alt_shift_toggle"; # Bug Bug Bug Bug Bug Bug Bug
  services.xserver.libinput.enable = true;

  services.xserver.desktopManager.gnome = {
    enable = true;
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  virtualisation.docker.enable = true;

  users.users.Gabimaru = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    packages = with pkgs; [
      wl-clipboard
      mako
      swaybg
      swayidle
      swaylock
      rofi
      xdg-desktop-portal-wlr

      
      networkmanager

      greetd
      tuigreet


      mesa

      foot
      xterm 

      tor-browser
      firefox

      fastfetch
      brightnessctl 
      wget
      gparted

      ffmpeg
      mpv
      
      git
      gh
      vscodium


      bitwarden-cli
      rPackages.keyring
      secretspec

      telegram-desktop

      gnumake
      docker
      nodejs_22
      yarn
      pavucontrol
    ];
    
  };

  users.extraGroups.docker.members = [ "username-with-access-to-socket" ];
  virtualisation.docker.storageDriver = "btrfs";
  services.gnome.gnome-keyring.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  services.greetd = {                                                      
    enable = true;                                                         
    settings = {                                                           
      default_session = {                                                  
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Gnome";
        user = "greeter";                                                  
      };                                                                   
    };                                                                     
  };
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 6b8e892 (second)
  services.desktopManager.gnome.enable = true; # Enable Gnome
=======

  services.desktopManager.gnome.enable = true;

>>>>>>> 10717e1 (fifth)
  services.postfix = {
    enable = true;
    hostname = "nixos.animesakura.net";
    
    settings.main = {
      relayhost = ["[smtp.sendgrid.net]:587"];
    };
    
    config = {
      smtp_sasl_auth_enable = "yes"; # SASL auth
      # change me this <api-key> here: smtp_sasl_password_maps = "inline:{smtp.sendgrid.net=apikey:<api-key>}";
      smtp_sasl_security_options = "noanonymous";
      smtp_use_tls = "yes";
      smtp_tls_security_level = "encrypt";
      smtp_tls_note_starttls_offer = "yes";
    };
  };
<<<<<<< HEAD
  # programs.mtr.enable = true; # Some programs need SUID wrappers, can be configured further or are
  # programs.gnupg.agent = {    # started in user sessions.
<<<<<<< HEAD
=======

  # Enable Gnome
  services.desktopManager.gnome.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
>>>>>>> 9dc6211 (second (very old, alpha))
=======
>>>>>>> 6b8e892 (second)
  #   enable = true;
  #   enableSSHSupport = true;
  # };  
  # services.openssh.enable = true; # List services that you want to enable:  # Enable the OpenSSH daemon.
  # networking.firewall.allowedTCPPorts = [ ... ];                            # Open ports in the firewall.
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;                                       # Or disable the firewall altogether.
  # system.copySystemConfiguration = true; # Copy the NixOS configuration file and link it from the resulting system # (/run/current-system/configuration.nix). This is useful in case you # accidentally delete configuration.nix.
  system.stateVersion = "26.05"; # Do NOT change this value # see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion . # Did you read the comment?
}
=======
>>>>>>> 10717e1 (fifth)

  system.stateVersion = "26.05";
}