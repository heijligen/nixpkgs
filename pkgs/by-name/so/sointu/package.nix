{
  lib,
  buildGo123Module,
  fetchFromGitHub,
  pkg-config,

  alsa-lib,
  libGL,
  libxkbcommon,
  vulkan-headers,
  wayland,
  xorg,
}:
# v0.4.1 cannot be build with go > 1.23.
# As of 2025.06.10 the master branch can.
buildGo123Module rec {
  pname = "sonitu";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "vsariola";
    repo = "sointu";
    tag = "v${version}";
    hash = "sha256-3+EsooD6a52ycrdG3VYPoHJfHYU4YakDRLQxbL6jbw4=";
  };

  vendorHash = "sha256-6AUiIQYU3VSNAjhbFX/WXotfVVTDFzhdhkJWjobh8DI=";
 
  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    libGL
    libxkbcommon
    vulkan-headers
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXfixes
  ];

  subPackages = [
    "cmd/sointu-track"
  ];

  meta = {
    description = "A cross-architecture and cross-platform modular software synthesizer for small intros";
    homepage = "https://github.com/vsariola/sointu";
    changelog = "${meta.homepage}/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "sointu-track";
  };
}
