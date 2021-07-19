{ pkgs }:

#{ rustPlatform, src ? ./. }:


with pkgs; rustPlatform.buildRustPackage {
  pname = "golden-rust";
  version = (builtins.fromTOML (builtins.readFile ./Cargo.toml)).package.version;

  src = builtins.path {
    name = "golden-rust";
    path = ./.;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    # golden-rust
  ];

  cargoTestFlags = [];

}
