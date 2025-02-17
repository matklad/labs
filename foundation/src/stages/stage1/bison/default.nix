{
  lib,
  config,
}: let
  cfg = config.aux.foundation.stages.stage1.bison;

  platform = config.aux.platform;
  builders = config.aux.foundation.builders;

  stage1 = config.aux.foundation.stages.stage1;
in {
  options.aux.foundation.stages.stage1.bison = {
    meta = {
      description = lib.options.create {
        type = lib.types.string;
        description = "Description for the package.";
        default.value = "Yacc-compatible parser generator.";
      };

      homepage = lib.options.create {
        type = lib.types.string;
        description = "Homepage for the package.";
        default.value = "https://www.gnu.org/software/bison";
      };

      license = lib.options.create {
        # TODO: Add a proper type for licenses.
        type = lib.types.attrs.any;
        description = "License for the package.";
        default.value = lib.licenses.gpl3Plus;
      };

      platforms = lib.options.create {
        type = lib.types.list.of lib.types.string;
        description = "Platforms the package supports.";
        default.value = ["i686-linux"];
      };
    };

    package = lib.options.create {
      type = lib.types.package;
      description = "The package to use for bison.";
    };

    version = lib.options.create {
      type = lib.types.string;
      description = "Version of the package.";
    };

    src = lib.options.create {
      type = lib.types.package;
      description = "Source for the package.";
    };
  };

  config = {
    aux.foundation.stages.stage1.bison = {
      version = "3.8.2";

      src = builtins.fetchurl {
        url = "https://ftpmirror.gnu.org/bison/bison-${cfg.version}.tar.xz";
        sha256 = "m7oCFMz38QecXVkhAEUie89hlRmEDr+oDNOEnP9aW/I=";
      };

      package = builders.bash.build {
        name = "bison-${cfg.version}";
        meta = cfg.meta;

        deps.build.host = [
          stage1.gcc.package
          stage1.musl.package
          stage1.binutils.package
          stage1.gnumake.package
          stage1.gnused.package
          stage1.gnugrep.package
          stage1.gawk.package
          stage1.diffutils.package
          stage1.findutils.package
          stage1.gnutar.package
          stage1.xz.package
          stage1.gnum4.package
        ];

        script = ''
          # Unpack
          tar xf ${cfg.src}
          cd bison-${cfg.version}

          # Configure
          bash ./configure \
            --prefix=$out \
            --build=${platform.build} \
            --host=${platform.host} \
            CC=musl-gcc

          # Build
          make -j $NIX_BUILD_CORES

          # Install
          make -j $NIX_BUILD_CORES install
        '';
      };
    };
  };
}
