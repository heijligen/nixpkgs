{ stdenv
, cmake
, fetchFromGitHub
, yasm
}:

stdenv.mkDerivation rec {
  pname = "svt-av1";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "OpenVisualCloud";
    repo = "SVT-AV1";
    rev = "v${version}";
    sha256 = "08sx9zhhks8wzq05f67jqmc1zqmmi7hqkgg2gyjpcsan5qc5476w";
  };

  nativeBuildInputs = [
    cmake
    yasm
  ];

  outputs = [ "out" "bin" "dev" ];

  meta = with stdenv.lib; {
    description = "Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder)";
    homepage = https://github.com/OpenVisualCloud/SVT-AV1/;
    longDescription = ''
      The Scalable Video Technology for AV1 (SVT-AV1 Encoder and Decoder) is an
      AV1-compliant encoder/decoder library core. The SVT-AV1 encoder development 
      is a work-in-progress targeting performance levels applicable to both VOD
      and Live encoding / transcoding video applications. The SVT-AV1 decoder
      implementation is targeting future codec research activities.
    '';
    license = licenses.bsd2patent;
    platforms = platforms.all;
  };
}
