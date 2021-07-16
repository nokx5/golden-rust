{
  description = "A devShell example";

  inputs = {
    nixpkgs.url      = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, rust-overlay, ... }:

  let
      forCustomSystems = custom: f: nixpkgs.lib.genAttrs custom (system: f system);
      allSystems = [ "x86_64-linux" "i686-linux" "aarch64-linux" "x86_64-darwin" ];
      devSystems = [ "x86_64-linux" "x86_64-darwin" ];
      forAllSystems = forCustomSystems allSystems;
      forDevSystems = forCustomSystems devSystems;

      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ rust-overlay self.overlay ];
        }
      );

      repoName = "golden-rust";
      repoVersion = nixpkgsFor.x86_64-linux.golden-rust.version;
      repoDescription = "golden-rust - A simple Rust flake";
    in {

      overlay = final: prev: {
        golden-rust = prev.callPackage ./derivation.nix {
	rustPlatform = prev.makeRustPlatform { inherit (final) rustc cargo; };
	src = self;
        };
        golden-rust-nightly = prev.callPackage ./derivation.nix {
	rustPlatform = prev.makeRustPlatform { inherit (final.rust-bin.stable.latest) rustc cargo; };
	src = self;
        };
      };

      devShell = forDevSystems (system:
        let pkgs = nixpkgsFor.${system}; in pkgs.callPackage ./shell.nix { }
      );

    #   hydraJobs = {

    #     build = forDevSystems (system: nixpkgsFor.${system}.golden-rust);
    #     build-nightly = forDevSystems (system: nixpkgsFor.${system}.golden-rust);

    #     release = forDevSystems (system:
    #       with nixpkgsFor.${system}; releaseTools.aggregate
    #         {
    #           name = "${repoName}-release-${repoVersion}";
    #           constituents =
    #             [
    #               self.hydraJobs.build.${system}
    #               self.hydraJobs.build-nightly.${system}
    #               #self.hydraJobs.docker.${system}
    #             ] ++ lib.optionals (hostPlatform.isLinux) [
    #               self.hydraJobs.build.x86_64-linux
    #               #self.hydraJobs.deb.x86_64-linux
    #               #self.hydraJobs.rpm.x86_64-linux
    #               #self.hydraJobs.coverage.x86_64-linux
    #             ];
    #           meta.description = "hydraJobs: ${repoDescription}";
    #         });
    #   };

    #   packages = forAllSystems (system:
    #     {
    #       inherit (nixpkgsFor.${system}) golden-rust golden-rust-nightly;
    #     });

    #   defaultPackage = forAllSystems (system:
    #     self.packages.${system}.golden-rust);

    #   apps = forAllSystems (system: {
    #     golden-rust = {
    #       type = "app";
    #       program = "${self.packages.${system}.golden-rust}/bin/cli_golden";
    #     };
    #     golden-rust-nightly = {
    #       type = "app";
    #       program = "${self.packages.${system}.golden-rust-nightly}/bin/cli_golden";
    #     };
    #   }
    #   );

    #   defaultApp = forAllSystems (system: self.apps.${system}.golden-rust);

    #   templates = {
    #     golden-rust = {
    #       description = "template - ${repoDescription}";
    #       path = ./.;
    #     };
    #   };

    #   defaultTemplate = self.templates.golden-rust;
    };

}