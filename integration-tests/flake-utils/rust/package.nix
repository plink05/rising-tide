{
  rustPlatform,
  crateName,
  ...
}:
rustPlatform.buildRustPackage {
    pname = "${crateName}";
    version = "0.1.0";

    # Point to the current directory
    src = ./.;

    # Use the local Cargo.lock file
    cargoLock.lockFile = ./Cargo.lock;

    # Optional: skip tests if needed
    # doCheck = false;

}
