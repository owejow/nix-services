# Nix Services

Nix Services is a flake designed to help you manage services in your development environment.
Nix services will group all of your enabled services into a single command: `startServices`.
This will allow you to start all necessary services at once. You can later run `stopServices`
to stop all running services. Currently this is built for Phoenix development, but it can be
expanded to work for any type of develpment that requires services to be running.

## Setup

Here is a simple nix flake that will set up a development environment for Phoenix

```nix
{
  description = "A flake for phoenix server development";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";

    nix-services.url = "github:Sapo-Dorado/nix-services/main";
  };

  outputs = { nixpkgs, flake-utils, nix-services, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        utils = nix-services.utils {
          inherit pkgs;
          module = nix-services.exampleConfigs.phoenixDev;
        };
      in { devShells.default = utils.devShell; });
}
```

This is equivalent to:

```nix
{
  description = "A flake for phoenix server development";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";

    nix-services.url = "github:Sapo-Dorado/nix-services/main";
  };

  outputs = { nixpkgs, flake-utils, nix-services, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        utils = nix-services.utils {
          inherit pkgs;
          module = {
            elixir.enabled = true;
            postgres.enabled = true;
          };
        };
      in { devShells.default = utils.devShell; });
}
```

## Usage

- `startServices`: Starts all enabled services
- `stopServices`: Stops all running services

Running the dev shell will create a folder called `.nix-shell` for files
related to the services. Warning: don't delete this directory without stopping
all services first or some may not stop properly.

Note:
This is compatible with `dir-env`

## Coming Soon

- Documentation of the available modules
- Developer documentation for configuring additional services
