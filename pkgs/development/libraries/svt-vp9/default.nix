{ stdenv
, cmake
, fetchFromGitHub
, yasm
}:

stdenv.mkDerivation rec {
  pname = "svt-vp9";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "OpenVisualCloud";
    repo = "SVT-VP9";
    rev = "v${version}";
    sha256 = "1vxzqwyynl65xz3vrc8kff5hzhrjs1cmslvlvb869kr6aidjw0dm";
  };

  patches = [ ./0001-pkg-config-use-CMAKE_INSTALL_FULL-for-prefix.patch ];

  nativeBuildInputs = [
    cmake
    yasm
  ];

  outputs = [ "out" "bin" "dev" ];

  meta = with stdenv.lib; {
    description = "Scalable Video Technology for VP9 (SVT-VP9 Encoder)";
    homepage = https://github.com/OpenVisualCloud/SVT-AV1/;
    longDescription = ''
      SVT VP9 encoder. Scalable Video Technology (SVT) is a software-based
      video coding technology that is highly optimized for Intel® Xeon® processors.
      Using the open source SVT-VP9 encoder, it is possible to spread video
      encoding processing across multiple Intel® Xeon® processors to achieve
      a real advantage of processing efficiency.
    '';
    license = licenses.bsd2patent;
    platforms = platforms.all;
  };
}
