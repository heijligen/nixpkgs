{ stdenv, lib, newScope
, version
}:
let
  callPackage = newScope self;
  inherit version;

  cmakeFlags = [
    "-GNinja"
    #"-LA"
    "-DFEATURE_libproxy=ON"
    "-DFEATURE_system_sqlite=ON"
    "-DQT_BUILD_EXAMPLES=ON"
    "-DFEATURE_vnc=OFF"
    "-DFEATURE_linuxfb=OFF"
    "-DFEATURE_eglfs=ON"
    #"-DFEATURE_opengles2=ON"
  ];

  self = rec {
      qtbase = callPackage ./modules/qtbase.nix {
          inherit version cmakeFlags;
      };

      qtwayland = callPackage ./modules/qtwayland.nix {
          inherit version cmakeFlags;
      };

      qtdeclarative = callPackage ./modules/qtdeclarative.nix {
          inherit version cmakeFlags;
      };

      qtquickcontrols2 = callPackage ./modules/qtquickcontrols2.nix {
          inherit version cmakeFlags;
      };

  };

in self