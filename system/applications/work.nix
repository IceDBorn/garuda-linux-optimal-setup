# PACKAGES INSTALLED ON WORK USER
{ config, pkgs, lib, inputs, ... }:

let
  cfg = config.system.user.work;
  stashLock = if (config.system.update.stashFlakeLock) then "1" else "0";

  # Update the system configuration
  update = import modules/rebuild.nix {
    inherit pkgs config;
    command = "update";
    update = "true";
    stash = config.system.update.stash;
  };

  # Packages to add for a fork of the config
  myPackages = with pkgs; [ ];

  shellScripts = [ update ];

  gitLocation = "${config.system.home}/${cfg.username}/git/";

  multiStoreProjects = {
    vaza = {
      folder = "vaza";

      aliases = {
        one = "burkani";
        two = "beo";
      };
    };

    tosupermou = {
      folder = "tosupermou";
      alias = "tosupermoureal";
    };

    papiros = {
      folder = "papiros";
      alias = "bookmarkt";
    };
  };

  httpdAliases = ''
    Alias /${multiStoreProjects.vaza.aliases.one} ${gitLocation}${multiStoreProjects.vaza.folder}
    Alias /${multiStoreProjects.vaza.aliases.two} ${gitLocation}${multiStoreProjects.vaza.folder}
    Alias /${multiStoreProjects.tosupermou.alias} ${gitLocation}${multiStoreProjects.tosupermou.folder}
    Alias /${multiStoreProjects.papiros.alias} ${gitLocation}${multiStoreProjects.papiros.folder}
  '';
in lib.mkIf cfg.enable {
  users.users.${cfg.username}.packages = with pkgs;
    [
      dbeaver # Database manager
      google-chrome # Dev browser
      php # Programming language for websites
      phpPackages.composer # Package manager for PHP
    ] ++ myPackages ++ shellScripts ++ lib.optional cfg.httpd apacheHttpd;

  services = lib.mkIf cfg.httpd {
    httpd = {
      enable = true;
      user = config.system.user.work.username;
      phpPackage = inputs.phps.packages.x86_64-linux.php73;
      enablePHP = true;
      extraConfig = ''
        <VirtualHost *:80>
          ServerName ${config.system.user.work.username}.localhost
          ServerAdmin ${config.system.user.work.username}@localhost
          DocumentRoot ${gitLocation}
          ${httpdAliases}
          <Directory ${gitLocation}>
            AllowOverride all
            Options Indexes FollowSymLinks MultiViews
            Order Deny,Allow
            Allow from all
            Require all granted
          </Directory>
        </VirtualHost>
      '';
    };

    mysql = {
      enable = true;
      package = pkgs.mysql;
    };
  };
}
