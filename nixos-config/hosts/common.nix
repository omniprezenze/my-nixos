{pkgs, ...}: {
    imports = [
        ./hardware-configuration.nix
        ./packages.nix
        ../../packages/scripts/screenshot.nix
    ];

    boot = {
        kernelPackages = pkgs.linuxPackages_latest;
        loader = {
            systemd-boot = {
                enable = true;
                editor = false;
                configurationLimit = 5;
            };
            timeout = 1;
            efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot";
            };
        };
    };

    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };

    hardware.xone.enable = true;
    networking.hostName = "omnipc";

    hardware = {
        graphics = {
            enable = true;
        };
        bluetooth.enable = true;
    };

    networking = {
        networkmanager.enable = true;
    };
    environment = {
        systemPackages = [
            pkgs.bemoji
            pkgs.bibata-cursors
            pkgs.btop
            pkgs.eza # modern replacement for the ls
            pkgs.diff-so-fancy 
            pkgs.firefox
            pkgs.fuzzel # app launcher
            pkgs.fzf # fuzzy finder 
            pkgs.helix
            pkgs.hyprpaper # wallpaper manager 
            pkgs.kdiff3 # graphical tool for comparing and merging files and directories
            pkgs.kitty # terminal emulator 
            pkgs.git
            pkgs.meld # visual diff and merge tool 
            pkgs.nil
            pkgs.nomacs # basic image editor
            pkgs.pavucontrol # graphical PulseAudio volume control tool 
            pkgs.polkit_gnome
            pkgs.playerctl # control media players 
            pkgs.ripgrep # command-line search tool that recursively searches directories for regex patterns
            pkgs.sd # sed replacer
            pkgs.swaylock-effects # screen locker for sway
            pkgs.swaynotificationcenter # notification center for sway
            pkgs.tldr # simple man
            pkgs.udiskie # management daemon 
            pkgs.unrar
            pkgs.unzip
            pkgs.vlc
            pkgs.waybar # WM top bar
            pkgs.wlogout # logout dialog 
            pkgs.wl-clipboard 
            pkgs.wttrbar # weather information display
            pkgs.xdg-user-dirs
            pkgs.xdg-utils
            pkgs.zoxide # cd replace with fuzzy search
            pkgs.amdgpu_top
        ];
    }

    services = {
        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };
        blueman.enable = true;
        udisks2.enable = true;
    };

    security.pam.services.swaylock.text = "auth include login";

    shells = [pkgs.zsh];
    sessionVariables.NIXOS_OZONE_WL = "1";
    variables = {
        EDITOR = "hx";
        BEMOJI_PICKER_CMD = "fuzzel --dmenu";
    };

    programs = {
        file-roller.enable = true;
        git.enable = true;
        hyprland = {
            enable = true;
            xwayland.enable = true;
        };
        starship.enable = true;
        thunar = {
            enable = true;
            plugins = [
                pkgs.xfce.thunar-archive-plugin
                pkgs.xfce.tumbler
            ];
        };

    services.greetd = {
        enable = true;
        settings = {
            default_session = {
                command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time -r --user-menu --cmd Hyprland";
                user = "greeter";
            };
        };
    };

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
                    "git"
                    "man"
                ];
            };
        };
        direnv.enable = true;
    };

    time.timeZone = "Europe/Warsaw";

    i18n.defaultLocale = "en_IE.UTF-8";
    console = {
        font = "Lat2-Terminus16";
    };

    users = {
        defaultUserShell = pkgs.zsh;
        users.omni = {
            isNormalUser = true;
            home = "/home/omni";
            extraGroups = ["wheel" "networkmanager" "video" "docker" "gamemode"];
        }
    };

    nixpkgs = {
        config.allowUnfree = true;
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
            pkgs.noto-fonts-cjk
            pkgs.noto-fonts-emoji
        ];
    };

    xdg.portal = {
        enable = true;
    };

    nix = {
        settings = {
            experimental-features = ["nix-command" "flakes"];
            warn-dirty = false;
        };
        gc = {
            automatic = true;
            dates = "daily";
            options = "--delete-older-than 7d";
        };
    };
}