# golden_rust

This is a skeleton for a rust project template (called a golden project).

## My development tools are
- nix <3
- vscode (IDE) with 
    - under discovery

## nix

1. Enter a nixpkgs shell (deprecated)
   ```bash
   nix-shell --pure -p rustc -p cargo
   ```

2. Enter [nokxpkgs](https://github.com/nokx5/nokxpkgs#add-nokxpkgs-to-your-nix-channel) workflow
    ```bash
    # you can avoid this export by adding nokxpkgs to your channels
    export NIX_PATH=nokxpkgs=https://github.com/nokx5/nokxpkgs/archive/main.tar.gz
    
    # option 1: develop the local software
    nix-shell -A dev
    $ exit
    
    # option 2: build the local software
    nix-build -A dev
    unlink result*
    
    # option 3: use your local changes
    nix-shell -I nixpkgs=$PWD -p dev
    $ exit
    ```
