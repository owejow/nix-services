{
  mkPhoenixDevShell = { pkgs, module ? { } }:
    let
      inherit (pkgs.lib.evalModules { modules = [ ./modules module ]; }) config;
    in pkgs.mkShell {
      buildInputs = pkgs.lib.optionals config.elixir.enabled [
        pkgs.erlang_26
        pkgs.beam.packages.erlang_26.elixir_1_14
      ];
    }

  ;
}
