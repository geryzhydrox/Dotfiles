{ config, lib, pkgs, ... }:
let 
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in 
{
  home-manager.users.gerald.programs.emacs = {
      enable = true;
      package = pkgs.emacs-gtk;
      extraPackages = epkgs: [
	epkgs.meow 
	epkgs.nord-theme
	epkgs.sudo-edit 
	epkgs.eglot 
	epkgs.dashboard
	epkgs.elixir-mode
	epkgs.company
	epkgs.transient
	epkgs.magit 
      ];
      extraConfig = (builtins.readFile ./init.el);
  };
}
