{ inputs, lib, config, pkgs, ... }: 
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  
  time.timeZone = "Europe/Kyiv";

  # Enter keyboard layout
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "altgr-intl";

  # Define user accounts
  users.users.Gabimaru = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [
      fastfetch
    ];
  };
<<<<<<< HEAD

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

=======
  
>>>>>>> 99bb00b (sixth)
  system.stateVersion = "26.05";
}