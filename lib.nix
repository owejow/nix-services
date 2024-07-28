{
  mkPhoenixDevShell = { pkgs, module ? { } }:
    let
      inherit (pkgs.lib.evalModules {
        modules = [ ./modules module ];
        specialArgs = { inherit pkgs; };
      })
        config;
    in pkgs.mkShell { inherit (config) buildInputs; }

  ;
}
