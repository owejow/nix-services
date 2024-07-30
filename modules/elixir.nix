{ pkgs, lib, config, ... }:
let cfg = config.elixir;
in {
  options = {
    elixir = {
      enabled = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description =
          "Whether to include elixir packages in the development environment.";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.beam.packages.erlang_26.elixir_1_14;
      };

      erlPackage = lib.mkOption {
        type = lib.types.package;
        default = pkgs.erlang_26;
      };

      enableFileWatchers = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description =
          "Whether to include file watcher utils for Phoenix development";
      };
    };
  };

  config = lib.mkIf cfg.enabled {
    moduleBuildInputs = [ cfg.package cfg.erlPackage ]
      ++ lib.optionals cfg.enableFileWatchers
      (lib.optionals pkgs.stdenv.isLinux [
        # For ExUnit Notifier on Linux.
        pkgs.libnotify

        # For file_system on Linux.
        pkgs.inotify-tools

        # necessary for alpine linux to work properly
        pkgs.glibcLocales
      ] ++ lib.optionals pkgs.stdenv.isDarwin [
        # For ExUnit Notifier on macOS.
        pkgs.terminal-notifier

        # For file_system on macOS.
        pkgs.darwin.apple_sdk.frameworks.CoreFoundation
        pkgs.darwin.apple_sdk.frameworks.CoreServices
      ]);

    setup =
      # bash
      ''
        # Put mix related data in nix shell dir
        export MIX_HOME=$NIX_SHELL_DIR/.mix
        export MIX_ARCHIVES=$MIX_HOME/archives
        export HEX_HOME=$NIX_SHELL_DIR/.hex

        export PATH=$MIX_HOME/bin:$PATH
        export PATH=$HEX_HOME/bin:$PATH
        export PATH=$MIX_HOME/escripts:$PATH
      '';
  };
}
