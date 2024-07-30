{ pkgs, lib, config, ... }: {
  imports = [ ./elixir.nix ./postgres.nix ];

  options = {
    # These options can be configured in each module
    moduleBuildInputs = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      internal = true;
    };

    startService = lib.mkOption {
      type = lib.types.lines;
      default = "";
      internal = true;
    };

    stopService = lib.mkOption {
      type = lib.types.lines;
      default = "";
      internal = true;
    };

    setup = lib.mkOption {
      type = lib.types.lines;
      default = "";
      internal = true;
    };

    # This will be constructed in this file
    buildInputs = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      internal = true;
    };

    shellHook = lib.mkOption {
      type = lib.types.lines;
      internal = true;
    };
  };

  config = {
    buildInputs = config.moduleBuildInputs ++ [
      (pkgs.writeShellScriptBin "startServices" "${config.startService}")
      (pkgs.writeShellScriptBin "stopServices" "${config.stopService}")
    ];

    shellHook =
      # bash
      ''
        # Ensure temporary directory for artifacts is created
        if ! test -d .nix-shell; then
          mkdir .nix-shell
        fi

        export NIX_SHELL_DIR=$PWD/.nix-shell

      '' + config.setup;

  };
}
