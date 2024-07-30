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
      user = lib.mkOption {
        type = lib.types.string;
        default = "postgres";
        description = ''
          The name of the postgres user.
        '';
      };
      password = lib.mkOption {
        type = lib.types.string;
        default = "postgres";
        description = ''
          The password for the postgres user (For dev only!).
        '';
      };

      dbName = lib.mkOption {
        type = lib.types.string;
        default = "postgres";
        description = ''
          The name of the postgres database
        '';

      };
    };
  };

  config = lib.mkIf cfg.enabled {
    moduleBuildInputs = [ pkgs.postgresql_16 ];
    setup =
      # bash
      ''
        export PGDATA=$NIX_SHELL_DIR/postgres
      '';

    startService =
      # bash
      ''
        if ! test -d $PGDATA; then
          pg_ctl initdb -D  $PGDATA
          echo "listen_addresses = ${"'"}${"'"}" >> $PGDATA/postgresql.conf
          echo "unix_socket_directories = '$PGDATA'" >> $PGDATA/postgresql.conf
          echo "CREATE USER ${cfg.user} WITH PASSWORD '${cfg.password}' CREATEDB SUPERUSER;" | postgres --single -E ${cfg.dbName}
        fi

        # Don't try to start postgres if it is already running
        if test -f $PGDATA/postmaster.pid; then
          exit 1
        fi

        pg_ctl                                                  \
          -D $PGDATA                                            \
          -l $PGDATA/postgres.log                               \
          -o "-c unix_socket_directories='$PGDATA'"             \
          -o "-c listen_addresses='*'"                          \
          -o "-c log_destination='stderr'"                      \
          -o "-c logging_collector=on"                          \
          -o "-c log_directory='log'"                           \
          -o "-c log_filename='postgresql-%Y-%m-%d_%H%M%S.log'" \
          -o "-c log_min_messages=info"                         \
          -o "-c log_min_error_statement=info"                  \
          -o "-c log_connections=on"                            \
          start

        exit 0
      '';

    stopService =
      # bash
      ''
        pg_ctl -D $PGDATA -U postgres stop
      '';
  };
}
