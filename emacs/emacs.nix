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
	epkgs.sudo-edit 
	epkgs.dashboard
	epkgs.transient

	epkgs.el-easydraw
	epkgs.magit 

	epkgs.lsp-mode 
	epkgs.yasnippet
	epkgs.elixir-mode
	epkgs.company
	epkgs.flymake 
	epkgs.flycheck 
      ];
      extraConfig = (builtins.readFile ./init.el);
  };
}
