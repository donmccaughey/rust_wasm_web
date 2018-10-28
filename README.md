# rust\_wasm\_web

An exploration of [Rust][11] and [WebAssembly][12] (wasm) for web clients.

[11]: https://www.rust-lang.org/ "The Rust Programming Language"
[12]: https://webassembly.org/ "WebAssembly"

## License

`rust_wasm_web` is available under a BSD-style license; see the `LICENSE` 
file for details.

## Dependencies

Building `rust_wasm_web` requires Rust <em>nightly</em>, [`wasm-bindgen`][31]
and GNU `make`. Running `rust_wasm_web` requires a web server. This example was
created on macOS High Sierra 10.13; installation details may differ on other
platforms.

[31]: https://github.com/rustwasm/wasm-bindgen "wasm-bindgen"

### Installing Dependencies

Install Rust using `rustup`:

    curl https://sh.rustup.rs -sSf | sh

See the [Install Rust][41] page for complete details.

Install the Rust <em>nightly</em> toolchain:

    rustup toolchain install nightly

Add the WebAssembly target to your Rust toolchains:

    rustup target add wasm32-unknown-unknown

Download, build and install the `wasm-bindgen` command line tool:

    cargo install wasm-bindgen-cli

(If this fails, try `cargo +nightly` in place of `cargo`.)

Install GNU `make`. On macOS, this is included if you have [Xcode][42]
installed, or can be installed independently using [Homebrew][43].

[41]: https://www.rust-lang.org/install.html "Install Rust"
[42]: https://itunes.apple.com/us/app/xcode/id497799835?mt=12 "Xcode"
[43]: https://brew.sh "Homebrew"

### Building

From the project root, run `make`:

    make

This will generate temporary files in the `tmp` directory and final output
in the `wwwroot` directory.

To remove generated files, run:

    make clean

### Running

Unfortunately, current web browsers are unable to load the generated `.wasm`
file when viewing the provided `index.html` page via a `file:` URL; you need a
local web server to run the generated web client.

If you have a web server installed, configure it to serve the generated
`wwwroot` directory. On macOS and most Linux systems, you can use Python's
`SimpleHTTPServer` to do the trick:

    cd wwwroot
    python -m SimpleHTTPServer 8000

Where `8000` is the port. The web client will appear at [localhost:8000][61].

[61]: http://localhost:8000 "Web Client"

