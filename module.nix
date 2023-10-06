{ lib, pkgs, config, ...}:

let
  inherit (lib) mkOption mkEnableOption mkPackageOption mdDoc mkIf;
  cfg = config.services.perimeter81;

in
  {
    options = {
      services.perimeter81 = {
        enable = mkEnableOption (mdDoc "Perimeter81 VPN client");
        package = mkPackageOption pkgs "perimeter81" { };
      };
    };

    config = mkIf cfg.enable {

      environment.systemPackages = [ cfg.package ]; 

      systemd.services.perimeter81helper = {
        description = "Perimeter81 Helper Daemon";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          ExecStart = "${cfg.package}/bin/p81-helper-daemon";
          ExecStop = "${cfg.package}/bin/p81-helper-daemon stop";
          Restart = "always";
          SyslogIdentifier = "perimeter81helper";
          User = "root";
          Group = "root";
          StandardOutput = "syslog";
          StandardError = "syslog";
          WorkingDirectory = "/";
        };
      };

    };
  }
