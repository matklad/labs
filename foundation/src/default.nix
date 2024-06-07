let
  modules = {
    builderBash = builders/bash;
    builderFileText = ./builders/file/text;
    builderKaem = ./builders/kaem;
    builderRaw = ./builders/raw;
    exports = ./exports;
    platform = ./platform;
    stage0 = ./stages/stage0;
    stage1 = ./stages/stage1;
    system = ./system;
  };
in
  modules
