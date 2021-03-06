{ lib
, pkgs
, mavenbuild
, maven
, jdk8
}:

with pkgs.javaPackages;

let
  poms = import ../poms.nix { inherit fetchMaven; };
  mavenbuild-jdk8 = mavenbuild.override {
    maven = maven.override {
      jdk = jdk8;
    };
  };
in rec {
  mavenHelloRec = { mavenDeps, mavenbuild, sha512, version, skipTests ? true, quiet ? true }: mavenbuild {
    inherit mavenDeps sha512 version skipTests quiet;

    name = "maven-hello-${version}";
    src = pkgs.fetchFromGitHub {
      inherit sha512;
      owner = "NeQuissimus";
      repo = "maven-hello";
      rev = "v${version}";
    };
    m2Path = "/com/nequissimus/maven-hello/${version}";

    meta = {
      homepage = "https://github.com/NeQuissimus/maven-hello/";
      description = "Maven Hello World";
      license = lib.licenses.unlicense;
      platforms = lib.platforms.all;
      maintainers = with lib.maintainers;
        [ nequissimus ];
    };
  };

  mavenHello_1_0 = mavenHelloRec {
    mavenDeps = [];
    sha512 = "3kv5z1i02wfb0l5x3phbsk3qb3wky05sqn4v3y4cx56slqfp9z8j76vnh8v45ydgskwl2vs9xjx6ai8991mzb5ikvl3vdgmrj1j17p2";
    version = "1.0";
    mavenbuild = mavenbuild-jdk8;
  };

  mavenHello_1_1 = mavenHelloRec {
    mavenDeps = [ junit_4_12 mavenSurefireJunit4_2_12_4 hamcrestCore_1_3 ] ++ (with poms; [ surefireProviders_2_12_4 ]);
    sha512 = "2f13592blvfgwad61174fza99ncb5jlch4sjjindk1pcaixqw26fnjfxb4ck80cknkihvcsylhviyfvhpm1ivvpg0zkicxva37cr4ri";
    version = "1.1";
    skipTests = false;
    quiet = false;
    mavenbuild = mavenbuild-jdk8;
  };
}
