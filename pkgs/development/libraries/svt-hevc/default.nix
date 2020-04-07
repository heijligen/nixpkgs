{ stdenv
, cmake
, fetchFromGitHub
, yasm
}:

stdenv.mkDerivation rec {
  pname = "svt-hevc";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "OpenVisualCloud";
    repo = "SVT-HEVC";
    rev = "v${version}";
    sha256 = "1sqh3dciqm2p1b66kngcpxqy5fx3ramxlxy8gfcbdwn2i3rsqhs7";
  };

  patches = [ ./0001-pkg-config-use-CMAKE_INSTALL_FULL-for-prefix.patch ];

  nativeBuildInputs = [
    cmake
    yasm
  ];

  outputs = [ "out" "bin" "dev" ];

  meta = with stdenv.lib; {
    description = "Scalable Video Technology for HEVC Encoder (SVT-HEVC Encoder)";
    homepage = https://github.com/OpenVisualCloud/SVT-HEVC/;
    longDescription = ''
      The Scalable Video Technology for HEVC Encoder (SVT-HEVC Encoder) is an
      HEVC-compliant encoder library core that achieves excellent density-quality
      tradeoffs, and is highly optimized for Intel® Xeon™ Scalable Processor and
      Xeon™ D processors.
      The whitepaper for SVT-HEVC can be found here: https://01.org/svt
      This encoder has been optimized to achieve excellent performance levels using
      12 density-quality presets.
    '';
    license = licenses.bsd2patent;
    platforms = platforms.all;
  };
}
