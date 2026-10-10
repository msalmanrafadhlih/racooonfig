{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  makeWrapper,
  yt-dlp,
  ffmpeg,
  mpv,
}:

buildGo126Module {
  pname = "xytz";
  version = "rev-201a6b1c0262f3b6880663b48f97625fa049cbef";

  src = fetchFromGitHub {
    owner = "TQ-See";
    repo = "xytz";
    rev = "201a6b1c0262f3b6880663b48f97625fa049cbef";
    hash = "sha256-c0aj9KL++dxweAFl+FWM5ii5kWgAaSxzBeex1r1wf3g=";
  };


  vendorHash = "sha256-vCJJ0aBSBANk2eVn7Vq7hPz0V32s7xmeIfSg0jy/Dzk=";
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram "$out/bin/xytz" \
      --prefix PATH : ${
        lib.makeBinPath [
          yt-dlp
          ffmpeg
          mpv
        ]
      }
  '';

  meta = with lib; {
    description = "a beautiful TUI YouTube Downloader";
    homepage = "https://github.com/xdagiz/xytz";
    license = licenses.mit;
    mainProgram = "xytz";
  };
}
