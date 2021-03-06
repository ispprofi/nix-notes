{ config, lib, pkgs,
  nix-notes-version,
  ... }:
{
  services.sshd.enable = true;

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  users.users.root.password = "nixos";
  services.openssh.permitRootLogin = lib.mkDefault "yes";
  services.mingetty.autologinUser = lib.mkDefault "root";

  imports = [
    modules/app.nix
    modules/cron.nix
    modules/nginx.nix
    modules/ssmtp.nix
  ];
}
