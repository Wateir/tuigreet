{
  mkShell,
  rustc,
  cargo,
  rust-analyzer-unwrapped,
  rustfmt,
  clippy,
  taplo,
  rustPlatform,
}:
mkShell {
  name = "rust";

  strictDeps = true;
  packages = [
    rustc
    cargo

    # Tools
    (rustfmt.override {asNightly = true;})
    clippy
    cargo
    taplo

    # LSP
    rust-analyzer-unwrapped
  ];

  RUST_SRC_PATH = "${rustPlatform.rustLibSrc}";
}
