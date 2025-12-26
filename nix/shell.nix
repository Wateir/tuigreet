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
    rustfmt
    clippy
    cargo
    taplo

    # LSP
    rust-analyzer-unwrapped
  ];

  RUST_SRC_PATH = "${rustPlatform.rustLibSrc}";
}
