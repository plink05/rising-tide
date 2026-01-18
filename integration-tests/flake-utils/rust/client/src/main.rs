pub mod test {
    include!(concat!(env!("OUT_DIR"), "/test.rs"));
}

fn main() {
    println!("{:?}", test::HelloWorld::default());
    println!("Hello, world!");
}
