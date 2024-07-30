{ pkgs, lib, config, ... }:
let cfg = config.postgres;
in {
  options = {
    postgres = {
      enabled = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to include postgres in the development environment.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enabled {
    buildInputs = [
      pkgs.postgresql_16
      (pkgs.writeShellApplication {
        name = "show-nixos-org";

        runtimeInputs = [ pkgs.curl pkgs.w3m ];

        text = ''
          curl -s 'https://nixos.org' | w3m -dump -T text/html
        '';
      })
    ];
  };
}
