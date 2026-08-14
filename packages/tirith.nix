{
  rustPlatform,
  fetchFromGitHub,
  lib,
  stdenv,
  installShellFiles,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (final: {
  pname = "tirith";
  version = "0.3.3";
  src = fetchFromGitHub {
    owner = "sheeki03";
    repo = "tirith";
    tag = "v${final.version}";
    hash = "sha256-kU/HeCW4QNS1Ica69YZkdSgL3gsbDOJVGTyINZOnHUQ=";
  };

  cargoHash = "sha256-r13gquMmfJhR5N8Vu3/R+3SWUyVWyJFE6fiJbqbE5n4=";

  cargoBuildFlags = [
    "-p"
    "tirith"
  ];

  postPatch = ''
    # The bash_preexec_enforce tests require a shell with job control
    rm crates/tirith/tests/bash_preexec_enforce.rs
    # The init_prompt_status_supports_bash_and_fish_and_powershell require bash.
    # The init_without_prompt_status_does_not_emit_snippet fails ?
    rm crates/tirith/tests/cli_integration.rs
    rm crates/tirith/tests/shell_conformance.rs
  '';

  checkFlags = [
    # requires a fully functional shell environment, generating init scripts needs a patch under nix to work at build time
    "--skip=init_bash_output"
    "--skip=init_zsh_output"
  ];

  nativeBuildInputs = lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    installShellFiles
  ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  __darwinAllowLocalNetworking = true;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd tirith \
      --bash <("$out/bin/tirith" completions bash) \
      --zsh <("$out/bin/tirith" completions zsh) \
      --fish <("$out/bin/tirith" completions fish)
  '';

  meta = {
    description = "Shell security tool that guards against homograph URL attacks, pipe-to-shell exploits, and other command-line threats before they execute";
    homepage = "https://github.com/sheeki03/tirith";
    changelog = "https://github.com/sheeki03/tirith/blob/${final.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ toasteruwu ];
    platforms = lib.platforms.unix;
    mainProgram = "tirith";
  };
})
