{
  lib,
  rustPlatform,
  installShellFiles,
  scdoc,
}: let
  s = ../.;

  cargoTOML = lib.importTOML (s + /Cargo.toml);
in
  rustPlatform.buildRustPackage (finalAttrs: {
    pname = "tuigreet";
    version = cargoTOML.package.version;

    src = let
      fs = lib.fileset;
    in
      fs.toSource {
        root = s;
        fileset = fs.unions [
          (fs.fileFilter (file: builtins.any file.hasExt ["rs"]) (s + /src))
          (s + /build.rs)
          (s + /Cargo.lock)
          (s + /Cargo.toml)
        ];
      };

    cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";
    enableParallelBuilding = true;

    nativeBuildInputs = [
      installShellFiles
      scdoc
    ];

    postInstall = ''
      scdoc < contrib/man/tuigreet-1.scd > tuigreet.1
      installManPage tuigreet.1
    '';

    meta = {
      description = "Sample Rust project";
      maintainers = with lib.maintainers; [NotAShelf];
    };
  })
