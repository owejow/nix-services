{ pkgs, lib, config, ... }:
let cfg = config.elixir;
in {
  options = {
    elixir = {
      enabled = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to include elixir packages in the development environment.
        '';
      };

      fileWatcherUtils = {
        enabled = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description =
            "Whether to include file watcher utils for Phoenix development";
        };
      };
    };
  };

  config = lib.mkIf cfg.enabled {
    moduleBuildInputs = [
      pkgs.erlang_26
      pkgs.beam.packages.erlang_26.elixir_1_14

    ] ++ lib.optionals cfg.fileWatcherUtils.enabled
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
  };
}
