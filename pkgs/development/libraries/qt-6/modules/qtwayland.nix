{stdenv , lib, qt6
, version, cmakeFlags

, fetchgit, cmake, pkg-config, ninja, perl, xmlstarlet, breakpointHook
, wayland, wayland-scanner, wayland-protocols, libGL, libxkbcommon
, vulkan-headers, vulkan-loader, egl-wayland, libffi, openssl
, xorg
}:

stdenv.mkDerivation rec {
  inherit version cmakeFlags;

  pname = "qtwayland";

  src = fetchgit {
      url = "git://code.qt.io/qt/${pname}.git";
      rev = "v${version}";
      sha256 = (lib.importJSON ../version-info.json).${version}.${pname}.sha256;
  };

  patches = (lib.importJSON ../version-info.json).${version}.${pname}.patches;


  nativeBuildInputs = [
      cmake pkg-config ninja perl xmlstarlet
      breakpointHook
  ];

  buildInputs = [
    qt6.qtbase qt6.qtdeclarative
    wayland wayland-scanner wayland-protocols libGL libxkbcommon
    vulkan-loader vulkan-headers egl-wayland libffi openssl
    xorg.libX11
  ];

  dontConfigure = true;
  dontBuild = true;
  dontInstall = true;


  preFixup = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/build/${pname}/build/lib
    echo "----------"
    echo $QT_ADDITIONAL_PACKAGES_PREFIX_PATH
    echo "----------"
  '';
  
  postFixup = ''
    mkdir -p $out/nix-support
    cat > $out/nix-support/setup-hook <<EOF
      add${pname}QtPackagePrefix() {
        echo "SETUP-HOOK ${pname} called"
        export QT_ADDITIONAL_PACKAGES_PREFIX_PATH=\$''\{QT_ADDITIONAL_PACKAGES_PREFIX_PATH:+\$QT_ADDITIONAL_PACKAGES_PREFIX_PATH:}$out
      }

      addEnvHooks "\$hostOffset" add${pname}QtPackagePrefix
    EOF
  '';
}