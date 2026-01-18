# rising-tide context
{
  injector,
  ...
}:
# project context
{ ... }:
{
  imports = injector.injectModules [
    ./cpp
    ./mavlink.nix
    ./protobuf.nix
    ./python.nix
    ./rust/default.nix
  ];
}
