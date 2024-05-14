{ config, lib, pkgs, ... }:
let 
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in 
{
  home-manager.users.gerald.programs.emacs = {
      enable = true;
      package = pkgs.emacs-gtk;
      extraPackages = epkgs: [
	epkgs.use-package
	epkgs.meow 
	epkgs.nord-theme
	epkgs.ef-themes
	epkgs.sudo-edit 
	epkgs.dashboard
	epkgs.transient

	epkgs.el-easydraw
	epkgs.sketch-mode
	epkgs.pdf-tools
	epkgs.magit 

	epkgs.elixir-mode
	epkgs.python-mode
	epkgs.nix-mode

	epkgs.eglot
	epkgs.yasnippet
	epkgs.company
	epkgs.flymake 
	#epkgs.flycheck 
      ];
      extraConfig = (builtins.readFile ./init.el);
  };
}
