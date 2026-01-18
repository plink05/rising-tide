# rising-tide flake context
{
  lib,
  risingTideLib,
  ...
}:
# project context
{
  config,
  pkgs,
  toolsPkgs,
  ...
}:
let
  inherit (lib) types;
  getCfg = projectConfig: projectConfig.languages.rust;
  cfg = getCfg config;
  enabledIn = projectConfig: (getCfg projectConfig).enable;
in
{
  options = {
    languages.rust = {
      enable = lib.mkEnableOption "Enable rust package configuration";
      callPackageFunction = lib.mkOption {
        description = ''
          The function to call to build the rust package. 
        '';
        type = types.nullOr risingTideLib.types.callPackageFunction;
        default = null;
      };
      crateName = lib.mkOption {
        type = types.nullOr types.str;
        description = ''
          name of crate to build
        '';
        default = null;
      };
      rustPlatform = lib.mkOption {
        type = types.attrs;
        description = ''
          Rust platform
        '';
        default = toolsPkgs.rustPlatform;
      };
      cargoHooks = lib.mkOption {
        type = types.package;
        default = pkgs.makeSetupHook {
          name = "cargo-hook";
          substitutions = {
            rustLib = cfg.rustPlatform.rustLibSrc;
          };
          
          
        } ./cargo-hook.sh;
      };
      prost = lib.mkOption {
        type = types.submodule {
          options = {
            enable = lib.mkEnableOption "enable prost support";
            protoc = lib.mkOption {
              type = types.package;
              default = pkgs.protobuf;
            };
            protoSrc = lib.mkOption {
              type = types.listOf types.path;
              default = [ ];
            };
            protoEnv = lib.mkOption {
              type = types.package;
              default = pkgs.buildEnv {
                name = "protoEnv";
                paths = cfg.prost.protoSrc;
              };
              readOnly = true;
            };
            hook = lib.mkOption {
              type = types.package;
              default = pkgs.makeSetupHook {
                name = "prost-hook";
                substitutions = {
                  protoc = cfg.prost.protoc;
                  protoSrc = cfg.prost.protoEnv;
                };
              } ./prost-hook.sh;
            };
          };
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.callPackageFunction != null) {
      callPackageFunction = 
      let
        f = cfg.callPackageFunction;
        mirrorArgs = lib.mirrorFunctionArgs f;
      in
      mirrorArgs (
        origArgs:
        let
          result = f origArgs;
          resultWithOverrides = result.overrideAttrs (prev: {
              nativeBuildInputs = (prev.nativeBuildInputs or [ ]) ++ [ cfg.cargoHooks ] ++ (if cfg.prost.enable then [ cfg.prost.hook ] else [ ]);
          });
        in
          resultWithOverrides
      );

      callPackageFunctionArgs = {
        crateName = cfg.crateName;
        rustPlatform = cfg.rustPlatform;
      };
    })
  ];


}
