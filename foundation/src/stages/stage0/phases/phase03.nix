{
  lib,
  config,
}: let
  cfg = config.aux.foundation.stages.stage0.catm;
  hex0 = config.aux.foundation.stages.stage0.hex0;
  hex1 = config.aux.foundation.stages.stage0.hex1;
  hex2-0 = config.aux.foundation.stages.stage0.hex2-0;

  system = config.aux.system;
  builders = config.aux.foundation.builders;
  sources = config.aux.foundation.stages.stage0.sources;
  architecture = config.aux.foundation.stages.stage0.architecture;
in {
  options.aux.foundation.stages.stage0.catm = {
    meta = {
      description = lib.options.create {
        type = lib.types.string;
        description = "Description for the package.";
        default.value = "Collection of tools for use in bootstrapping.";
      };

      homepage = lib.options.create {
        type = lib.types.string;
        description = "Homepage for the package.";
        default.value = "https://github.com/oriansj/stage0-posix";
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
      description = "The package to use for catm.";
    };
  };

  config = {
    aux.foundation.stages.stage0.catm = {
      package = lib.modules.overrides.default (builders.raw.build {
        pname = "catm";
        version = "1.6.0";

        meta = cfg.meta;

        executable =
          if architecture.base == "AArch64"
          then hex1.package
          else hex2-0.package;

        args =
          if architecture.base == "AArch64"
          then [
            "${sources.base}/catm_${architecture.base}.hex1"
            (builtins.placeholder "out")
          ]
          else [
            "${sources.base}/catm_${architecture.base}.hex2"
            (builtins.placeholder "out")
          ];
      });
    };
  };
}
