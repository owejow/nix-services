{ lib, ... }: {
  options = {
    elixir = {
      enabled = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to include elixir packages in the development environment.
        '';
      };
    };
  };
}
