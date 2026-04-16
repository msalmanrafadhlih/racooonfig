# ./modules/applications.nix
{ mkSymlink, ... }: let locals = import ./launchers.nix ;
in { home.file = mkSymlink {} locals; }
