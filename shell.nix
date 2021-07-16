{ pkgs ? import <nixpkgs> { config = { allowUnfree = true; }; }, nightlySupport ? false
}:
with pkgs;
let
  vscodeExt = 
 vscode-with-extensions.override {
    vscodeExtensions = with vscode-extensions;
      [ bbenoist.Nix eamodio.gitlens matklad.rust-analyzer vadimcn.vscode-lldb ]
      ++ vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "emacs-mcx";
          publisher = "tuttieee";
          version = "0.31.0";
          sha256 = "McSWrOSYM3sMtZt48iStiUvfAXURGk16CHKfBHKj5Zk=";
        }
      ];
  };
in mkShell {
   inherit nightlySupport;
  nativeBuildInputs =
  [rustup] ++ [ openssl pkgconfig ] ++ [exa fd] ++ [
    bashCompletion
    cacert
    gcc
    gdb
    git
    gnumake
    nixfmt
    # pkg-config
    # rustfmt
    emacs-nox] ++  lib.optionals (hostPlatform.isLinux) [typora vscodeExt];

  shellHook = ''
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
    alias ls=exa
    alias find=fd
    echo "You may need to install a rust compiler using rustup :"
    echo "rustup toolchain install nightly"
    echo "# or"
    echo "rustup toolchain install stable"
    echo ""
    echo "clean the environment before"
    '';

}
