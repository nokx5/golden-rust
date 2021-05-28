{
  description = "A simple Rust flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    naersk = {
      url = "github:nmattia/naersk/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mozillapkgs = {
      url = "github:mozilla/nixpkgs-mozilla";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, utils, naersk, mozillapkgs }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";

        # Get a specific rust version
        mozilla = pkgs.callPackage (mozillapkgs + "/package-set.nix") { };
        rust = (mozilla.rustChannelOf {
          date = "2021-05-28"; # get the current date with `date -I`
          channel = "nightly";
          sha256 = "sha256:pjq7CPjCVwiXG/0IS6l1FEdoXoaCvIhgYvJTQCAWsu8=";
        }).rust;

        # Override the version used in naersk
        naersk-lib = naersk.lib."${system}".override {
          cargo = rust;
          rustc = rust;
        };

        # golden rust
        project = with naersk.lib."${system}";
          buildPackage {
            pname = "golden-rust";
            root = ./.;
          };
        # golden rust nightly
        project_nightly = with naersk-lib;
          buildPackage {
            pname = "golden-rust-nightly";
            root = ./.;
          };

        # project devShell

      in rec {

        packages = {
          golden_rust = project;
          golden_rust_nightly = project_nightly;
        };
        defaultPackage = self.packages.${system}.golden_rust;

        apps = {
          cli_golden = {
            type = "app";
            program =
              "${self.defaultPackage.${system}}/bin/golden_rust"; # cli_golden
          };
        };

        defaultApp = self.apps.${system}.cli_golden;

        devShell = pkgs.project_dev;
      });
}
