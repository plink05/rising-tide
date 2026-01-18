#/bin/bash

prostHook() {
  echo "Executing prost hook"
  export PROTOC="@protoc@/bin/protoc"
  export PROTOSRC="@protoSrc@"
}

postShellHooks+=(prostHook)
