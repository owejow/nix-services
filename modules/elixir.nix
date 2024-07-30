{ pkgs, lib, config, ... }:
let cfg = config.elixir;
in with lib; {
  options = {
    elixir = {
      enabled = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to include elixir packages in the development environment.
        '';
      };
    };
  };

  config = {
    buildInputs = mkIf cfg.enabled (with pkgs; [
      erlang_26
      beam.packages.erlang_26.elixir_1_14

    ]);
  };
}
