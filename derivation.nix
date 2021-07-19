{ rustPlatform, src, pkg-config }:

rustPlatform.buildRustPackage {
  pname = "golden-rust";
  version = (builtins.fromTOML (builtins.readFile "${src}/Cargo.toml")).package.version;
  inherit src;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  nativeBuildInputs = [
    # cmake
    pkg-config
  ];

  buildInputs = [
    # sqlite
  ];

  cargoTestFlags = [ ];

}
