{ pkgs ? import <nixpkgs> { config = { allowUnfree = true; }; } }:
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
in
mkShell {
  nativeBuildInputs = [ rustup ] ++ [ openssl pkgconfig ] ++ [ exa fd ] ++ [ less more] ++ [
      bashCompletion
      cacert
      gcc
      gdb
      git
      gnumake
      nixpkgs-fmt
      # pkg-config
      # rustfmt
      emacs-nox
    ] ++ lib.optionals (hostPlatform.isLinux) [ typora vscodeExt ];

  shellHook = ''
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
    export RUSTUP_HOME=$PWD/.rustup
    alias ls=exa
    alias find=fd
    echo ""
    echo "# You may need to install a rust compiler using rustup :"
    echo "rustup override set stable # nightly"
    echo "# # clean the environment :"
    echo "# rm -rf $PWD/.rustup"
  '';

}
