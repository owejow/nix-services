{ pkgs, lib, config, ... }:
let cfg = config.stripe-mock;
in {
  options = {
    stripe-mock = {
      enabled = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to include stripe-mock in the development environment
        '';
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.callPackage ./stripe-mock.nix { };
      };
    };
  };

  config = lib.mkIf cfg.enabled {
    moduleBuildInputs = [ cfg.package ];
    setup =
      # bash
      ''
        export STRIPE_MOCK_PID=$NIX_SHELL_DIR/stripe-mock.pid
      '';

    startService =
      # bash
      ''
        if ! test -f $STRIPE_MOCK_PID; then
          echo "Starting stripe-mock"
          stripe-mock >/dev/null 2>&1 < /dev/null & echo $! > $STRIPE_MOCK_PID
        fi
      '';

    stopService =
      # bash
      ''
        if test -f $STRIPE_MOCK_PID; then
          echo "Stopping stripe-mock"
          kill "$(cat $STRIPE_MOCK_PID)" 
          rm $STRIPE_MOCK_PID
        fi
      '';
  };
}
