fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Compile all .proto files in the "src" directory
    // and treat the "src" directory as the root for paths

    let proto_src = std::env!("PROTOSRC");

    prost_build::compile_protos(&["test.proto"], &[proto_src])?;

    Ok(())
}
