# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let 
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    ref = "nixos-23.11";
    });
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      nixvim.nixosModules.nixvim
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos-desktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable xdg portal
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
  # Enable flatpak.
  services.flatpak.enable = true;

  # Enable the XFCE Desktop Environment.
  #services.xserver.displayManager.lightdm.enable = true;
  #services.xserver.desktopManager.xfce.enable = true;

  # Configure keymap in X11
  # Xfce, i3, lightdm
  services.xserver = {
    enable = true;
    #videoDrivers = [ "amdgpu" ];
    displayManager.lightdm = {
      enable = true;
      greeters.slick.enable = true;
      #greeters.gtk.theme.name = "materia-cyberpunk-neon";
    };
    displayManager.defaultSession ="xfce";
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
	noDesktop = false;
	enableXfwm = false;
      };
    };
    windowManager.i3.enable = true;
    layout = "de";
    xkbVariant = "";
  };
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true; 
    settings = {
      blur = {
	method = "gaussian";
	size = 50;
	deviation = 5.0;
      };
    };
  };
  services.blueman.enable = true;

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
    ]; 
    #extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;


  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gerald = {
    isNormalUser = true;
    description = "gerald";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs;
    let
    customR = rWrapper.override{ packages = with rPackages;
    [ 
      ggplot2
      tidyverse
      psych
    ];};
    in
    [
      # Essentials: Browser, editor, terminal, WM, etc.
      firefox
      chromium
      tor-browser
      alacritty
      i3
      i3ipc-glib
      nitrogen
      unzip
      picom
      git
      discord
      element-desktop
      nordic
      rose-pine-gtk-theme
      rose-pine-icon-theme
      # Wacky terminal apps
      neofetch
      fd
      htop
      ranger
      nnn
      pywal
      alacritty-theme
      ueberzugpp
      # Productivity or whatever
      cura
      pandoc
      zathura
      texliveSmall
      libreoffice-fresh

      # Development
      godot_4
      customR
      rstudio
      rstudioWrapper
      elixir
      #python3
      python2
      gnumake
      gcc

      # Multimedia
      youtube-dl
      mpv
      obs-studio
      libsForQt5.kdenlive
      pavucontrol
      mpvScripts.cutter
      ffmpeg
      musescore
      cmus
      audacity

      ## Gaming?
      #wine
      #winetricks
      #protontricks
      #vulkan-tools
      ## Lutris
      ##lutris-unwrapped  # (not needed)
      lutris
      ## Extra dependencies
      ## https://github.com/lutris/docs/
      #gnutls
      #openldap
      #libgpgerror
      #freetype
      #sqlite
      #libxml2
      #xml2
      #SDL2

      # Imaging, partitioning, etc.
      rpi-imager
      gparted
      gnome.gnome-disk-utility
    ];
  };
  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "nix-2.16.2" "python-2.7.18.7" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # neovim
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    basez
    wget
    killall
    ntfs3g
    xfce.xfce4-i3-workspaces-plugin
    xfce.xfce4-whiskermenu-plugin
    xfce.xfce4-panel-profiles
    xfce.xfce4-pulseaudio-plugin
    libgcc
    xclip
    libsForQt5.breeze-icons
    lightdm-slick-greeter
    gst_all_1.gstreamer
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
  ];

  fonts.packages = with pkgs; [
    nerdfonts
  ];  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  #programs.steam = {
    #enable = true;
    #remotePlay.openFirewall = true;
    #dedicatedServer.openFirewall = true;
  #};

  programs.gnupg.agent = {
    enable = true;
  #   enableSSHSupport = true;
  };
  programs.bash = {
    shellAliases = {
     nixcfg = "sudo nvim /etc/nixos/configuration.nix";
     nixrecfg = "sudo nixos-rebuild switch";
    };
    promptInit = ''
      PS1="\[\033[01;32m\]\u \[\033[00m\]\[\033[02;37m\] \w \[\033[00m\] \[\033[01;36m\]» \[\033[00m\]"
    '';
  };
  programs.nixvim = {
    enable = true;
    clipboard.register = "unnamedplus";
    #luaLoader.enable = true;
    #colorschemes.nord.enable = true;
    colorschemes.rose-pine = {
      enable = true;
      transparentBackground = true;
      transparentFloat = true;
    };
    #highlight = {
      #NonText.blend = 0;
      #Normal.blend = 0;
    #};
    options = {
      relativenumber = true;
      shiftwidth = 2;
      showmode = false;
    };
    globals = {
      mapleader = " ";
    };
    keymaps = [
      {
	key = "<leader>0"; 
	action = "<cmd>Alpha<CR>";
	mode = [ "n" "v" ];
      }
      {
	key = "<leader>f";
	action = "<cmd>Telescope fd<CR>";
	mode = [ "n" "v" ];
      }
      {
	key = "<leader>t";
	action = "<cmd>NvimTreeToggle<CR>";
	mode = [ "n" "v" ];
      }
      {
	key = "ää";
	action = "<Esc>";
	mode = [ "i" "v" ];
      }
    ];
    extraPlugins = with pkgs.vimPlugins; [ 
      tabular
      nvim-dap
      nvim-web-devicons
      suda-vim
    ];
    plugins = {
      alpha.enable = true;
      lualine.enable = true;
      telescope.enable = true;
      mkdnflow.enable = true;
      #image = {
	#enable = true;
	#backend = "ueberzug";
      #};
      luasnip.enable = true;
      cmp_luasnip.enable = true;
      nvim-cmp = {
        enable = true;
	autoEnableSources = true;
      	sources = [
	  {name = "luasnip";}
	  {name = "nvim_lsp";}
	  {name = "path";}
	  {name = "buffer";}
	  #{name = "omni";}
	  #{name = "ultisnips";}
	];
	extraOptions = {
	  snippet.expand = 
	  ''
	  '';
	};
	mapping = {
	  "<CR>" = "cmp.mapping.confirm({ select = true })";
	  #"<CR>" = "luasnip.expand()";
	  "<Tab>" = {
      	    action = "cmp.mapping.select_next_item()";
      	    modes = [ "i" "s" ];
      	  };
      	  "<Down>" = {
      	    action = "cmp.mapping.select_next_item()";
      	    modes = [ "i" "s" ];
      	  };
      	  "<S-Tab>" = {
      	    action = "cmp.mapping.select_prev_item()";
      	    modes = [ "i" "s" ];
      	  };
      	  "<Up>" = {
      	    action = "cmp.mapping.select_prev_item()";
      	    modes = [ "i" "s" ];
      	  };
        };
      };	
      cmp-nvim-lsp.enable = true;
      nvim-tree.enable = true;
      treesitter = { 
	enable = true;
	incrementalSelection.enable = true;
      };
      dap.enable = true;
      lsp = {
        enable = true;
	servers = {
	  gdscript.enable = true;
	  gdscript.autostart = true;
	  nixd.enable = true;
	  nixd.autostart = true;
	  elixirls.enable = true;
	  elixirls.autostart = true;
	  pylsp.enable = true;
	  pylsp.autostart = true;
	};
      };
    };
    userCommands = {
      "Nixcfg" = {
	command = ":e /etc/nixos/configuration.nix";
	desc = "Edit configuration.nix";
      };
      "I3config" = {
	command = ":e ~/.config/i3/config";
	desc = "Edit i3 config";
      };
      "Pmd" = {
	command = '':!pandoc -f commonmark_x -t pdf --pdf-engine=xelatex -V mainfont:FreeSans "%" -o /tmp/"%:t:r"'';
	desc = "Compile current markdown file as pdf in /tmp";
      };
      "Zmd" = {
	command = '':!kill $(ps -e | grep zathura | awk '{print $1}'); zathura /tmp/"%:t:r" &'';
	desc = "Read current pdf file in /tmp with Zathura";
      };
      "Pzmd" = {
	command = '':!pandoc -f commonmark_x -t pdf --pdf-engine=xelatex -V mainfont:FreeSans "%" | zathura - &'';
	desc = "Compile current markdown file as pdf and pipe into zathura";
      };
      "Nt" = {
	command = ":NvimTreeToggle";
	desc = "Toggle NvimTree";
      };
      "Ntf" = {
	command = ":NvimTreeFocus";
	desc = "Focus NvimTree";
      };
      "Sw" = {
	command = ":SudaWrite";
	desc = "Write wtih sudo priviliges";
      };
      "Swq" = {
	command = ":SudaWrite|q";
	desc = "Write with sudo privilges and then quit";
      };
    };
    extraConfigLua = ''
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    dashboard.section.header.val = {
      "          ▗▄▄▄       ▗▄▄▄▄    ▄▄▄▖          ",
      "          ▜███▙       ▜███▙  ▟███▛          ",
      "           ▜███▙       ▜███▙▟███▛           ",
      "            ▜███▙       ▜██████▛            ",
      "     ▟█████████████████▙ ▜████▛     ▟▙      ",
      "    ▟███████████████████▙ ▜███▙    ▟██▙     ",
      "           ▄▄▄▄▖           ▜███▙  ▟███▛     ",
      "          ▟███▛             ▜██▛ ▟███▛      ",
      "         ▟███▛               ▜▛ ▟███▛       ",
      "▟███████████▛                  ▟██████████▙ ",
      "▜██████████▛                  ▟███████████▛ ",
      "      ▟███▛ ▟▙               ▟███▛          ",
      "     ▟███▛ ▟██▙             ▟███▛           ",
      "    ▟███▛  ▜███▙           ▝▀▀▀▀            ",
      "    ▜██▛    ▜███▙ ▜██████████████████▛      ",
      "     ▜▛     ▟████▙ ▜████████████████▛       ",
      "           ▟██████▙       ▜███▙             ",
      "          ▟███▛▜███▙       ▜███▙            ",
      "         ▟███▛  ▜███▙       ▜███▙           ",
      "         ▝▀▀▀    ▀▀▀▀▘       ▀▀▀▘           ",
    }
    dashboard.section.buttons.val = {
     dashboard.button( "e", "  New file" , ":ene <BAR> startinsert <CR>"),
     dashboard.button( "f", "  Find file", ":Telescope find_files<CR>"),
     dashboard.button( "r", "  Recent"   , ":Telescope oldfiles<CR>"),
     dashboard.button( "c", "󰜗  Nix Configuration" , ":e /etc/nixos/configuration.nix<CR>"),
     dashboard.button( "q", "󰿅  Quit Nixvim", ":qa!<CR>"),
    }
    alpha.setup(dashboard.opts)
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    do
      local cmp = require('cmp')
      cmp.setup({
      	["snippet"] = {["expand"] = function(args) require('luasnip').lsp_expand(args.body)  end},
      })
    end
    '';
  };
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
