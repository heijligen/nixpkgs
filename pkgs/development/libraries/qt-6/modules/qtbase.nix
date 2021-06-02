{stdenv , lib
, version, cmakeFlags

, fetchgit, cmake, pkg-config, ninja, perl, xmlstarlet, breakpointHook

, libudev, zlib, zstd # Base
, double-conversion, glib, icu, libb2, systemd, pcre, pcre2, dbus, lttng-ust # core
, libproxy, openssl, brotli # network
, sqlite # sql
, vulkan-headers, vulkan-loader, harfbuzz, libinput, libjpeg, libpng, wayland, at-spi2-core, libxkbcommon, freetype, glslang # gui
, libdrm, mesa, fontconfig, mtdev, directfb, md4c, valgrind
, libGL, xorg
}:

stdenv.mkDerivation rec {
  inherit version cmakeFlags;

  pname = "qtbase";

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
    libudev zlib zstd
    double-conversion glib icu libb2 systemd pcre pcre2 dbus lttng-ust
    libproxy openssl brotli
    sqlite
    vulkan-headers vulkan-loader harfbuzz libinput libjpeg libpng wayland at-spi2-core libxkbcommon freetype glslang
    libdrm mesa fontconfig mtdev directfb md4c valgrind
    libGL xorg.libxcb xorg.libX11 xorg.libXau xorg.libXdmcp xorg.libXtst xorg.xrandr xorg.libXext xorg.libXi
    xorg.libXft xorg.libICE xorg.libSM xorg.libXres xorg.libXaw xorg.libXcomposite xorg.libXcursor xorg.libXinerama xorg.libXmu xorg.libXpm
    xorg.libXrandr xorg.libXt xorg.libXv xorg.libXxf86misc xorg.libxkbfile
    xorg.xcbproto xorg.xcbutilcursor xorg.xcbutilimage xorg.xcbutil xorg.xcbutilwm xorg.xcbutilrenderutil xorg.xcbutilerrors xorg.xcbutilkeysyms
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