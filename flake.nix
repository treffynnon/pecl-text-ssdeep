{
  description = "php/pecl-text-ssdeep";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.03";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        overlays = [
        ];

        pkgs = import nixpkgs {
          inherit system overlays;
          config = {
            allowUnfree = false;
            allowBroken = false;
          };
        };

        nativeBuildInputs = with pkgs; [];

        lintNix = pkgs.writeScriptBin "lint-nix" ''
          #!${pkgs.bash}/bin/bash
          ${pkgs.statix}/bin/statix check ./ -i .direnv
        '';
        formatNix = pkgs.writeScriptBin "format-nix" ''
          #!${pkgs.bash}/bin/bash
          ${pkgs.alejandra}/bin/alejandra --exclude .direnv .
        '';
        ciFormatNix = pkgs.writeScriptBin "ci-format-nix" ''
          #!${pkgs.bash}/bin/bash
          ${pkgs.alejandra}/bin/alejandra --check --exclude .direnv .
        '';

        buildInputs = with pkgs; [
          alejandra
          statix

          php

          lintNix
          formatNix
          ciFormatNix
        ];

        shellHook = ''
        '';
      in
        with pkgs; {
          devShells.default = mkShell {
            name = "php/pecl-text-ssdeep";
            inherit buildInputs nativeBuildInputs shellHook;
          }
        }
    )
}
