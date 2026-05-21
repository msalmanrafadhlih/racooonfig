# ./default.nix
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "desktopify-lite";
  version = "unstable-2026-03-23";

  src = fetchFromGitHub {
    owner = "miniguys";
    repo = "desktopify-lite";
    rev = "2c0d77217257d122278593bc2be0f425f9317802";
    hash = "sha256-AipUGhxwL3kyw08fEP1iXLwG2PxIIcqNaoU69LIfnGk=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  env = {
    CGO_ENABLED = 0;
  };

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Turn websites into desktop apps";
    homepage = "https://github.com/miniguys/desktopify-lite";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
