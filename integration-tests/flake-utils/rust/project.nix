{
  name = "rust-package";
  languages.rust = {
    enable = true;
    callPackageFunction = import ./package.nix;
    crateName = "rust";
    prost = {
      enable = true;
      protoSrc = [ ./protos ];
    };
  };
}
