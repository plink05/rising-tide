#!/bin/bash

cargoHook() {
  echo "Executing cargo hook"
  export RUST_SRC_PATH="@rustLib@"
}

postShellHooks+=(cargoHook)
