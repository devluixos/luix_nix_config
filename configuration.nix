{ config, pkgs, lib, inputs, ... }:

{
  # -------- imports --------
  imports = [
    ./hardware-configuration.nix
  ];

  # -------- basics --------
  networking.hostName = "nixos";
  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_GB.UTF-8";
  networking.networkmanager.enable = true;

  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };

  # --- Updates & maintenance ---
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    flake = "/etc/nixos#nixos";
    dates = "daily";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 20d";
  };

  nix.optimise = {
    automatic = true;
    dates = ["weekly"];
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # GNOME on NixOS 25.05 (xserver paths)
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xkb = { layout = "ch"; variant = ""; };
  console.keyMap = "sg";

  # Printing
  services.printing.enable = true;

  # Audio (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # default Shell
  environment.shells = with pkgs; [ zsh ];

  # Users
  users.users.luix = {
    isNormalUser = true;
    description = "luix";
    extraGroups = [ "networkmanager" "wheel" "vboxusers"];
    shell = pkgs.zsh;
  };

  #fonts
  fonts.packages = with pkgs; [
    #nerdfonts
    nerd-fonts.droid-sans-mono
    nerd-fonts.symbols-only
    nerd-fonts.bigblue-terminal
    nerd-fonts.heavy-data
    nerd-fonts.hurmit


    #other fonts
    roboto
    #mulish
    #bebas-neue
    #drois-sans-mono
  ];

  # Program toggles
  programs.firefox.enable = true;
  programs.obs-studio.enable = true;
  programs.steam.enable = true;
  programs.neovim.enable = true;
  programs.git.enable = true;
  programs.tmux.enable = true;
  programs.java.enable = true;
  programs.bazecor.enable = true;
  #programs.zsh.enable = true;
  #programs.zsh.ohMyZsh.enable = true;

  # zsh ohmyzsh and others
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      theme = "robbyrussell";
  };
  };
  # Unfree ok
  nixpkgs.config.allowUnfree = true;

  # --- Hardware & firmware ---
  hardware.cpu.amd.updateMicrocode = true;
  services.fwupd.enable = true;
  services.fstrim.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Graphics (25.05 uses hardware.graphics.*)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Optional AMD OpenCL ICD (you had this earlier)
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];

  # -------- Nix settings + caches --------
  nix.settings = {
    # Keep flakes UX nice everywhere
    experimental-features = [ "nix-command" "flakes" ];

    # Caches from nix-citizen + nix-gaming READMEs
    substituters = [
      "https://nix-citizen.cachix.org"
      "https://nix-gaming.cachix.org"
    ];
    trusted-public-keys = [
      "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
    auto-optimise-store = true;
  };

  # -------- Packages --------
  environment.systemPackages = with pkgs; [
    # your tools
    wget qownnotes davinci-resolve-studio discord nodejs dbeaver-bin
    gimp-with-plugins libreoffice php clinfo freshfetch ffmpeg stow
    gcc gnumake unzip ripgrep luarocks-nix lua lua51Packages.lz-n
    kitty 
    python3
    audacity
    prismlauncher
    orca-slicer
    easyeffects
    yazi

    # Star Citizen from nix-citizen 
    # inputs.nix-citizen.packages.${pkgs.system}.star-citizen
  ];
  system.stateVersion = "25.05";
}

