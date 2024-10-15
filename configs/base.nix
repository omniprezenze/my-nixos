{pkgs, inputs, ...}: {
  system.stateVersion = "24.05";

  boot = {
    initrd = {
      systemd.enable = true;
    };

    kernelPackages = pkgs.linuxPackages_latest;
    consoleLogLevel = 3;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    tmp.cleanOnBoot = true;
  };

  networking.hostName = "omnipc";
  networking = {
    networkmanager.enable = true;
  };
  networking.wireless.iwd = {
    enable = true;
    settings = {
      General = {
        EnableNetworkConfiguration = true;
      };
      Network = {
        EnableIPv6 = true;
      };
      Scan = {
        DisablePeriodicScan = true;
      };
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
  };

  environment = {
    systemPackages = with pkgs; [
      impala
      vim
      fastfetch
      btop
      firefox
      kitty # terminal emulator 
      nil
      nomacs # basic image editor
      ripgrep # command-line search tool that recursively searches directories for regex patterns
      unrar
      unzip
      vulkan-tools
      helvum
      qpwgraph
      tree
      lm_sensors
    ];
  };

  environment = {
    shells = [pkgs.zsh];
    variables = {
      EDITOR = "vim";
      XDG_SESSION_TYPE = "wayland";
    };
  };

  services.udisks2.enable = true;

  programs = {
    git.enable = true;
    ssh.startAgent = true;
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [
          "direnv"
          "fancy-ctrl-z"
          ];
        };
      };
    direnv.enable = true;
  };

  time.timeZone = "Europe/Warsaw";

  console = {
    font = "Lat2-Terminus16";
  };

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
  ];
  
  i18n.defaultLocale = "en_US.UTF-8";

  users = {
    defaultUserShell = pkgs.zsh;
    users.omni = {
      isNormalUser = true;
      home = "/home/omni";
      extraGroups = [
        "wheel" "networkmanager" "docker" 
        "video" "gamemode" "corectrl" "input"
      ];
    };
  };

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Noto Serif" "Noto Color Emoji"];
        sansSerif = ["Noto Sans" "Noto Color Emoji"];
        monospace = ["Fira Code" "MesloLGS NF" "Noto Color Emoji"];
        emoji = ["Noto Sans" "Noto Color Emoji"];
      };
    };
    packages = [
      pkgs.dejavu_fonts
      pkgs.fira-code
      pkgs.meslo-lgs-nf
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-emoji
    ];
  };

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
      substituters = ["https://nix-gaming.cachix.org"];
      trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };
}
