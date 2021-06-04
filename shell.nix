{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let
  emacsExt = let
    emacsWithPackages =
      (pkgs.emacsPackagesGen pkgs.emacs-nox).emacsWithPackages;
  in emacsWithPackages (epkgs:
    (with epkgs.melpaStablePackages; [
      magit # ; Integrate git <C-x g>
      zerodark-theme # ; Nicolas' theme
    ]) ++ (with epkgs.melpaPackages;
      [
        # undohist
        # zoom-frm # ; increase/decrease font size for all buffers %lt;C-x C-+>
      ]) ++ (with epkgs.elpaPackages; [
        undo-tree # ; <C-x u> to show the undo tree
        # auctex # ; LaTeX mode
        beacon # ; highlight my cursor when scrolling
        nameless # ; hide current package name everywhere in elisp code
      ]) ++ [
        pkgs.notmuch # From main packages set
      ]);
  vscodeExt = vscode-with-extensions.override {
    vscodeExtensions = with vscode-extensions;
      [ bbenoist.Nix eamodio.gitlens ]
      ++ vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "emacs-mcx";
          publisher = "tuttieee";
          version = "0.31.0";
          sha256 = "McSWrOSYM3sMtZt48iStiUvfAXURGk16CHKfBHKj5Zk=";
        }
        # {
        #   name = "rust";
        #   publisher = "rust-lang";
        #   version = "0.7.8";
        #   sha256 = "Y33agSNMVmaVCQdYd5mzwjiK5JTZTtzTkmSGTQrSNg0=";
        # }
        # {
        #   name = "vscode-lldb";
        #   publisher = "vadimcn";
        #   version = "1.6.3";
        #   sha256 = "5V7KMwv3/4C8N7wZCTq0RbQKuAshpWlLBHM3fRBc0PA=";
        # }
        {
          name = "vscode-lldb";
          publisher = "vadimcn";
          version = "1.6.3";
          sha256 = "5V7KMwv3/4C8N7wZCTq0RbQKuAshpWlLBHM3fRBc0PA=";
        }

      ];
  };
in mkShell {
  nativeBuildInputs = [ rustc cargo ] ++ [
    bashCompletion
    cacert
    git
    gnumake
    nixfmt
    pkg-config
    rustfmt
    emacsExt
    vscodeExt
  ] ++ [ typora ];

  shellHook = ''
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
  '';

}
