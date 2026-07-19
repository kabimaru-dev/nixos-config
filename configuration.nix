# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:
{
  # # compile kernel with SELinux support - but also support for other LSM modules
  # boot.kernelPatches = [ {
  #   name = "selinux-config";
  #   patch = null;
  #   extraConfig = ''
  #         SECURITY_SELINUX y
  #         SECURITY_SELINUX_BOOTPARAM n
  #         # SECURITY_SELINUX_DISABLE n
  #         SECURITY_SELINUX_DEVELOP y
  #         SECURITY_SELINUX_AVC_STATS y
  #         # SECURITY_SELINUX_CHECKREQPROT_VALUE 0
  #         DEFAULT_SECURITY_SELINUX n
  #       '';
  # } ];

  # boot.kernelModules = [ "selinux" ];

  # security.lsm = [ "selinux" ];

  # # build systemd with SELinux support so it loads policy at boot and supports file labelling
  # systemd.package = pkgs.systemd.override { withSelinux = true; };

  # boot.kernelPackages = inputs.nixpkgs.legacyPackages.${pkgs.system}.linux-cachyos-hardened;
  # hardware.deviceTree.enable = false;
 
  # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest; linux-cachyos-hardened

  # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

  # boot.kernelPackages = inputs.nix-cachyos-kernel.legacyPackages.x86_64-linux.linuxPackages-cachyos-hardened;

  nix.settings.max-jobs = "auto";
  programs.ccache.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # Flakes  

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # policycoreutils is for load_policy, fixfiles, setfiles, setsebool, semodile, and sestatus.
  environment.systemPackages = with pkgs; [ 
    policycoreutils
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

  boot.loader.systemd-boot.enable = true; # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true; # Configure network connections interactively with nmcli or nmtui.
  
  # networking.hostName = "nixos"; # Define your hostname.
  
  time.timeZone = "Europe/Kyiv"; # Set your time zone.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };
  services.xserver.enable = true; # Enable the X11 windowing system.
  services.xserver.layout = "us, ru";
  services.xserver.xkbOptions = "grp:alt_shift_toggle";  
  services.xserver.libinput.enable = true; # Enable touchpad support.
  # services.xserver.displayManager.sddm.enable = true; # Enable the KDE Desktop Environment.
  # services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.displayManager.gdm.wayland = false;
  # services.xserver.windowManager.i3.enable = true;
  services.xserver.desktopManager.gnome = {
    enable = true;
  };
  # services.printing.enable = true; # Enable CUPS to print documents.
  # services.pulseaudio.enable = true; # Enable sound.
  services.pipewire = { # OR
    enable = true;
    pulse.enable = true;
  };
  virtualisation.docker.enable = true;  
  # services.libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).
  users.users.Gabimaru = { # Define a user account. Don't forget to set a password with ‘passwd’.
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      # Sway
      wl-clipboard # Copy/Paste functionality.
      mako # Notification utility.
      
      # Internet Managment Environment
      networkmanager


      
      # Login Managment Environment
      greetd
      tuigreet


      
      # Windows Managment Environment
      swaybg
      swayidle
      swaylock
      rofi
      xdg-desktop-portal-wlr



      # Drivers
      mesa



      # Terminals
      foot
      xterm 



      # Browsers
      tor-browser
      firefox



      # Linux 
      fastfetch
      # Linux Brightness
      brightnessctl 
      # Net
      wget
      # GUI Disk Manager
      gparted



      # Video & Media Environment
      ffmpeg
      mpv
      


      # Code  Managment Envitonment
      git
      gh
      vscodium



      # Passwords Managment
      bitwarden-cli
      rPackages.keyring
      secretspec

      

      # Social Media
      telegram-desktop



      # Etc
      gnumake
      docker
      nodejs_22
      yarn
    ];
    
  };
  users.extraGroups.docker.members = [ "username-with-access-to-socket" ];
  # programs.firefox.enable = true;
  virtualisation.docker.storageDriver = "btrfs";
  services.gnome.gnome-keyring.enable = true; # Enables Gnome Keyring to store secrets for applications. 
  programs.sway = { # Enable Sway.
    enable = true;
    wrapperFeatures.gtk = true;
  };
  services.greetd = {                                                      
    enable = true;                                                         
    settings = {                                                           
      default_session = {                                                  
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";                                                  
      };                                                                   
    };                                                                     
  };
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 6b8e892 (second)
  services.desktopManager.gnome.enable = true; # Enable Gnome
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
      smtp_use_tls = "yes"; # TLS for SendGrid
      smtp_tls_security_level = "encrypt";
      smtp_tls_note_starttls_offer = "yes";
    };
  };
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

# let
#   cfg = config.security.selinux;
# in
  # # security.lsm = [ "selinux" ]; # "landlock" "yama" "bpf" "ima"

  # # boot.kernelPackages = pkgs.linuxPackages_latest; # Use latest kernel.
  # # boot.kernelPatches = [ {
  # #   name = "hardened";
  # #   patch = null;
  # #   extraConfig = ''
  # #     # LOCALVERSION_AUTO is not set
  # #     POSIX_MQUEUE y
  # #     AUDIT y
  # #     NO_HZ y
  # #     HIGH_RES_TIMERS y
  # #     #PREEMPT_VOLUNTARY y
  # #     BSD_PROCESS_ACCT y
  # #     TASKSTATS y
  # #     TASK_DELAY_ACCT y
  # #     TASK_XACCT y
  # #     TASK_IO_ACCOUNTING y
  # #     #LOG_BUF_SHIFT=18
  # #     CGROUPS y
  # #     CGROUP_SCHED y
  # #     CGROUP_FREEZER y
  # #     CPUSETS y
  # #     CGROUP_CPUACCT y
  # #     BLK_DEV_INITRD y
  # #     # COMPAT_BRK is not set
  # #     PROFILING y
  # #     SMP y
  # #     X86_REROUTE_FOR_BROKEN_BOOT_IRQS y
  # #     #MICROCODE_AMD y
  # #     X86_MSR y
  # #     X86_CPUID y
  # #     NUMA y
  # #     X86_CHECK_BIOS_CORRUPTION y
  # #     # MTRR_SANITIZER is not set
  # #     EFI y
  # #     EFI_STUB y
  # #     EFI_MIXED y
  # #     HZ_1000 y
  # #     KEXEC y
  # #     CRASH_DUMP y
  # #     HIBERNATION y
  # #     PM_DEBUG y
  # #     PM_TRACE_RTC y
  # #     ACPI_DOCK y
  # #     ACPI_BGRT y
  # #     #CPU_FREQ_DEFAULT_GOV_USERSPACE y
  # #     CPU_FREQ_GOV_ONDEMAND y
  # #     X86_ACPI_CPUFREQ y
  # #     IA32_EMULATION y
  # #     #EFI_VARS y
  # #     KPROBES y
  # #     JUMP_LABEL y
  # #     MODULES y
  # #     MODULE_UNLOAD y
  # #     MODULE_FORCE_UNLOAD y
  # #     BINFMT_MISC y
  # #     NET y
  # #     PACKET y
  # #     UNIX y
  # #     XFRM_USER y
  # #     INET y
  # #     IP_MULTICAST y
  # #     IP_ADVANCED_ROUTER y
  # #     IP_MULTIPLE_TABLES y
  # #     IP_ROUTE_MULTIPATH y
  # #     IP_ROUTE_VERBOSE y
  # #     IP_PNP y
  # #     IP_PNP_DHCP y
  # #     IP_PNP_BOOTP y
  # #     IP_PNP_RARP y
  # #     IP_MROUTE y
  # #     IP_PIMSM_V1 y
  # #     IP_PIMSM_V2 y
  # #     SYN_COOKIES y
  # #     # INET_DIAG is not set
  # #     TCP_CONG_ADVANCED y
  # #     # TCP_CONG_BIC is not set
  # #     # TCP_CONG_WESTWOOD is not set
  # #     # TCP_CONG_HTCP is not set
  # #     TCP_MD5SIG y
  # #     INET6_AH y
  # #     INET6_ESP y
  # #     NETLABEL y
  # #     NETFILTER y
  # #     # NETFILTER_ADVANCED is not set
  # #     NF_CONNTRACK y
  # #     NF_CONNTRACK_FTP y
  # #     NF_CONNTRACK_IRC y
  # #     NF_CONNTRACK_SIP y
  # #     NF_CT_NETLINK y
  # #     NF_NAT y
  # #     NETFILTER_XT_TARGET_CONNSECMARK y
  # #     NETFILTER_XT_TARGET_NFLOG y
  # #     NETFILTER_XT_TARGET_SECMARK y
  # #     NETFILTER_XT_TARGET_TCPMSS y
  # #     NETFILTER_XT_MATCH_CONNTRACK y
  # #     NETFILTER_XT_MATCH_POLICY y
  # #     NETFILTER_XT_MATCH_STATE y
  # #     IP_NF_IPTABLES y
  # #     #IP_NF_FILTER y
  # #     #IP_NF_TARGET_REJECT y
  # #     #IP_NF_TARGET_MASQUERADE=m
  # #     #IP_NF_MANGLE y
  # #     IP6_NF_IPTABLES y
  # #     IP6_NF_MATCH_IPV6HEADER y
  # #     #IP6_NF_FILTER y
  # #     #IP6_NF_TARGET_REJECT y
  # #     #IP6_NF_MANGLE y
  # #     NET_SCHED y
  # #     NET_EMATCH y
  # #     NET_CLS_ACT y
  # #     CFG80211 y
  # #     MAC80211 y
  # #     MAC80211_LEDS y
  # #     RFKILL y
  # #     PCI y
  # #     PCIEPORTBUS y
  # #     HOTPLUG_PCI y
  # #     PCCARD y
  # #     YENTA y
  # #     DEVTMPFS y
  # #     DEVTMPFS_MOUNT y
  # #     DEBUG_DEVRES y
  # #     CONNECTOR y
  # #     BLK_DEV_LOOP y
  # #     BLK_DEV_SD y
  # #     BLK_DEV_SR y
  # #     CHR_DEV_SG y
  # #     SCSI_CONSTANTS y
  # #     SCSI_SPI_ATTRS y
  # #     # SCSI_LOWLEVEL is not set
  # #     ATA y
  # #     SATA_AHCI y
  # #     ATA_PIIX y
  # #     PATA_AMD y
  # #     PATA_OLDPIIX y
  # #     PATA_SCH y
  # #     MD y
  # #     BLK_DEV_MD y
  # #     #BLK_DEV_DM y
  # #     #DM_MIRROR y
  # #     #DM_ZERO y
  # #     MACINTOSH_DRIVERS y
  # #     MAC_EMUMOUSEBTN y
  # #     NETDEVICES y
  # #     #NETCONSOLE y
  # #     #TIGON3 y
  # #     NET_TULIP y
  # #     E100 y
  # #     E1000 y
  # #     #E1000E y
  # #     SKY2 y
  # #     FORCEDETH y
  # #     8139TOO y
  # #     R8169 y
  # #     #INPUT_POLLDEV y
  # #     INPUT_EVDEV y
  # #     INPUT_JOYSTICK y
  # #     INPUT_TABLET y
  # #     INPUT_TOUCHSCREEN y
  # #     INPUT_MISC y
  # #     # LEGACY_PTYS is not set
  # #     SERIAL_8250 y
  # #     SERIAL_8250_CONSOLE y
  # #     #SERIAL_8250_NR_UARTS=32
  # #     SERIAL_8250_EXTENDED y
  # #     SERIAL_8250_MANY_PORTS y
  # #     SERIAL_8250_SHARE_IRQ y
  # #     SERIAL_8250_DETECT_IRQ y
  # #     SERIAL_8250_RSA y
  # #     SERIAL_NONSTANDARD y
  # #     HW_RANDOM y
  # #     # HW_RANDOM_INTEL is not set
  # #     # HW_RANDOM_AMD is not set
  # #     NVRAM y
  # #     HPET y
  # #     # HPET_MMAP is not set
  # #     I2C_I801 y
  # #     WATCHDOG y
  # #     AGP y
  # #     AGP_AMD64 y
  # #     AGP_INTEL y
  # #     DRM y
  # #     DRM_I915 y
  # #     FB_MODE_HELPERS y
  # #     FB_TILEBLITTING y
  # #     FB_EFI y
  # #     LOGO y
  # #     # LOGO_LINUX_MONO is not set
  # #     # LOGO_LINUX_VGA16 is not set
  # #     SOUND y
  # #     SND y
  # #     SND_HRTIMER y
  # #     SND_SEQUENCER y
  # #     SND_SEQ_DUMMY y
  # #     SND_HDA_INTEL y
  # #     SND_HDA_HWDEP y
  # #     HIDRAW y
  # #     #HID_GYRATION y
  # #     LOGITECH_FF y
  # #     #HID_NTRIG y
  # #     #HID_PANTHERLORD y
  # #     PANTHERLORD_FF y
  # #     #HID_PETALYNX y
  # #     #HID_SAMSUNG y
  # #     #HID_SONY y
  # #     #HID_SUNPLUS y
  # #     #HID_TOPSEED y
  # #     HID_PID y
  # #     USB_HIDDEV y
  # #     USB y
  # #     USB_ANNOUNCE_NEW_DEVICES y
  # #     USB_MON y
  # #     USB_XHCI_HCD y
  # #     USB_EHCI_HCD y
  # #     USB_OHCI_HCD y
  # #     USB_UHCI_HCD y
  # #     USB_PRINTER y
  # #     USB_STORAGE y
  # #     RTC_CLASS y
  # #     # RTC_HCTOSYS is not set
  # #     DMADEVICES y
  # #     EEEPC_LAPTOP y
  # #     AMD_IOMMU y
  # #     INTEL_IOMMU y
  # #     # INTEL_IOMMU_DEFAULT_ON is not set
  # #     EXT4_FS y
  # #     EXT4_FS_POSIX_ACL y
  # #     EXT4_FS_SECURITY y
  # #     QUOTA y
  # #     QUOTA_NETLINK_INTERFACE y
  # #     # PRINT_QUOTA_WARNING is not set
  # #     QFMT_V2 y
  # #     #AUTOFS4_FS y
  # #     ISO9660_FS y
  # #     JOLIET y
  # #     ZISOFS y
  # #     MSDOS_FS y
  # #     VFAT_FS y
  # #     PROC_KCORE y
  # #     TMPFS_POSIX_ACL y
  # #     HUGETLBFS y
  # #     NFS_FS y
  # #     NFS_V3_ACL y
  # #     NFS_V4 y
  # #     ROOT_NFS y
  # #     #NLS_DEFAULT="utf8"
  # #     NLS_CODEPAGE_437 y
  # #     NLS_ASCII y
  # #     NLS_ISO8859_1 y
  # #     NLS_UTF8 y
  # #     SECURITY y
  # #     SECURITY_NETWORK y
  # #     SECURITY_SELINUX y
  # #     SECURITY_SELINUX_BOOTPARAM y
  # #     #SECURITY_SELINUX_DISABLE y
  # #     PRINTK_TIME y
  # #     MAGIC_SYSRQ y
  # #     DEBUG_KERNEL y
  # #     DEBUG_STACK_USAGE y
  # #     # SCHED_DEBUG is not set
  # #     SCHEDSTATS y
  # #     BLK_DEV_IO_TRACE y
  # #     PROVIDE_OHCI1394_DMA_INIT y
  # #     EARLY_PRINTK_DBGP y
  # #     DEBUG_BOOT_PARAMS y
  # #   '';
  # # } ];
  
  # # boot.kernelParams = [   
  # #   "selinux=1"  
  # #   "enforcing=1" # build 53. change to 0 if build 53 is fully fall down
  # # ];

  # # # boot.bootspec.enable = true;

  # # # security.tpm2.enable = true;

  # # systemd.package = pkgs.systemd.override { withSelinux = true; }; # build systemd with SELinux support so it loads policy at boot and supports file labelling

  # # # systemd.tmpfiles.rules = [
  # # #   "Z /etc/nixos - - - - -"
  # # # ];

  # # # environment.systemPackages = with pkgs; [ # policycoreutils is for load_policy, fixfiles, setfiles, setsebool, semodile, and sestatus.
  # # #   policycoreutils
  # # #   selinux-python
  # # #   audit
  # # # ];

  # # # security.audit.enable = true;
  # # # security.audit.rules = [
  # # #   "-w /etc/selinux/ -p wa -k selinux_config"
  # # #   "-w /usr/share/selinux/ -p wa -k selinux_policy"
  # # # ];
  # # security.lsm = [
  # #   "landlock"
  # #   "yama"
  # #   "bpf"
  # # ];
  # # boot.kernelParams = [ "security=selinux" ];

  # # security.lsm = lib.mkForce [ ];
  
  # # compile kernel with SELinux support - but also support for other LSM modules
  # # boot.kernelPatches = [ {
  # #   name = "selinux-config";
  # #   patch = null;
  # #   extraConfig = ''
  # #           SECURITY_SELINUX y
  # #           SECURITY_SELINUX_BOOTPARAM n
  # #           SECURITY_SELINUX_DISABLE n
  # #           SECURITY_SELINUX_DEVELOP y
  # #           SECURITY_SELINUX_AVC_STATS y
  # #           SECURITY_SELINUX_CHECKREQPROT_VALUE 0
  # #           DEFAULT_SECURITY_SELINUX n
  # #         '';
  # # } ];

  # #     boot = {
  # #     kernelPatches = [
  # #       {
  # #         name = "selinux";
  # #         extraStructuredConfig = with lib.kernel; {
  # #           SECURITY_SELINUX = yes;
  # #           SECURITY_SELINUX_BOOTPARAM = yes;
  # #           DEFAULT_SECURITY_APPARMOR = lib.mkForce no;
  # #           DEFAULT_SECURITY_SELINUX = yes;
  # #         };
  # #         patch = null;
  # #       }
  # #     ];
  # #     kernelParams = [ "security=selinux" ];
      
  # # # policycoreutils is for load_policy, fixfiles, setfiles, setsebool, semodile, and sestatus.
  # # environment.systemPackages = with pkgs; [ policycoreutils ];
  # # # build systemd with SELinux support so it loads policy at boot and supports file labelling
  # # systemd.package = pkgs.systemd.override { withSelinux = true; };
















  #   options.security.selinux = {
  #   enable = lib.mkEnableOption "SELinux" // {
  #     default = true;
  #   };
  #   policy = lib.mkOption {
  #     type = lib.types.path;
  #     description = "The path to the SELinux policy";
  #     defaultText = lib.literalExpression ''''${pkgs.selinux-refpolicy.override { inherit (config.security.selinux) policyVersion; }}'';
  #     default = "${
  #       pkgs.selinux-refpolicy.override {
  #         inherit (config.security.selinux) policyVersion;
  #       }
  #     }";
  #   };
  #   policyVersion = lib.mkOption {
  #     type = lib.types.nullOr lib.types.int;
  #     description = "The version of the SELinux policy";
  #     default = 33;
  #   };
  #   type = lib.mkOption {
  #     type = lib.types.str;
  #     description = "The SELinux policy type to load";
  #     default = "refpolicy";
  #   };
  #   mode = lib.mkOption {
  #     type = lib.types.enum [
  #       "enforcing"
  #       "permissive"
  #       "disabled"
  #     ];
  #     description = "The enforcement mode";
  #     default = "permissive";
  #   };
  # };

  # config = lib.mkIf cfg.enable {
  #   boot = {
  #     kernelPatches = [
  #       {
  #         name = "selinux";
  #         extraStructuredConfig = with lib.kernel; {
  #           SECURITY_SELINUX = yes;
  #           SECURITY_SELINUX_BOOTPARAM = yes;
  #           DEFAULT_SECURITY_APPARMOR = lib.mkForce no;
  #           DEFAULT_SECURITY_SELINUX = yes;
  #         };
  #         patch = null;
  #       }
  #     ];
  #     kernelParams = [ "security=selinux" ];
  #   };

  #   system.activationScripts.selinux = {
  #     deps = [ "etc" ];
  #     text = ''
  #       install -d -m0755 /var/lib/selinux
  #       cmd="${lib.getExe' pkgs.policycoreutils "semodule"} -s ${cfg.type} -i ${cfg.policy}/share/selinux/${cfg.type}/*.pp"
  #       skipSELinuxActivation=0

  #       if [ -e /var/lib/selinux/activate-check ]; then
  #         if [ "$(cat /var/lib/selinux/activate-check)" == "$cmd" ]; then
  #           skipSELinuxActivation=1
  #         fi
  #       fi

  #       if [ -z $skipSELinuxActivation ]; then
  #         eval "$cmd"
  #         echo "$cmd" >/var/lib/selinux/activate-check
  #       fi
  #     '';
  #   };

  #   system.build.selinux-policy = pkgs.stdenv.mkDerivation {
  #     name = "selinux-${cfg.type}-modules.img";

  #     nativeBuildInputs = with pkgs; [
  #       policycoreutils
  #       squashfsTools
  #     ];

  #     buildCommand = ''
  #       mkdir -p files/etc/selinux files/var/lib/selinux/final
  #       printf "${config.environment.etc."selinux/semanage.conf".text}" > config
  #       semodule --config config -p files -s ${cfg.type} -i ${cfg.policy}/share/selinux/${cfg.type}/*.pp || true
  #       mksquashfs files $out -b 1048576 -processors $NIX_BUILD_CORES
  #     '';
  #   };

  #   systemd.package = pkgs.systemd.override {
  #     withSelinux = true;
  #   };

  #   environment = {
  #     etc."selinux/config".text = ''
  #       SELINUX=${cfg.mode}
  #       SELINUXTYPE=${cfg.type}
  #     '';
  #     etc."selinux/semanage.conf".text =
  #       lib.optionalString (cfg.policyVersion != null) ''
  #         policy-version = ${toString cfg.policyVersion}
  #       ''
  #       + ''
  #         compiler-directory = ${pkgs.policycoreutils}/libexec/selinux/hll

  #         [load_policy]
  #         path = ${lib.getExe' pkgs.policycoreutils "load_policy"}
  #         [end]

  #         [setfiles]
  #         path = ${lib.getExe' pkgs.policycoreutils "setfiles"}
  #         args = -q -v -c $@ $<
  #         [end]

  #         [sefcontext_compile]
  #         path = ${lib.getExe' pkgs.libselinux "sefcontext_compile"}
  #         args = -v -r $@
  #         [end]
  #       '';
  #     systemPackages = with pkgs; [
  #       libselinux
  #       policycoreutils
  #     ];
  #   };
  # };