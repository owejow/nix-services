{ lib, ... }:
with lib; {
  imports = [ ./elixir.nix ];

  options = {
    buildInputs = mkOption {
      type = types.listOf types.package;
      internal = true;
    };
  };
}
