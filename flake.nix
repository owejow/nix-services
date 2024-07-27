{
  description = "A flake for phoenix server development";

  outputs = _: { lib = import ./lib.nix; };
}
