/**
  # pktz

  pktz is an eBPF-powered network traffic monitor: per process, per
  connection, live. Built on eBPF for traffic accounting, with `/proc`
  used to map sockets back to processes. No packet sampling.

  Requires root (or `cap_bpf`, `cap_perfmon`, `cap_dac_read_search`)
  to load eBPF programs and read `/proc/<pid>/fd/`.

  ## 🛠️ Tech Stack

  - [pktz @ GitHub](https://github.com/immanuwell/pktz)
*/
{
  buildGoModule,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:
buildGoModule (final: {
  pname = "pktz";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "immanuwell";
    repo = "pktz";
    tag = final.version;
    hash = "sha256-ZN93HibeBxy+DgJKP9Q7opj94s1hUJbVh2O8Zf4NdDE=";
  };

  vendorHash = "sha256-2Z5iTX87sCwa28FKshy8fCi1NSBQ0XodP4Qrus4Nj3A=";

  subPackages = [ "." ];

  # Upstream hardcodes `const version = "0.1.0"` in main.go and never bumps
  # it, so `pktz --version` reports a stale version. It is a const, not a
  # var, so `-X main.version=...` in ldflags cannot override it.
  # `--replace-warn` so a future upstream fix degrades to a warning.
  postPatch = ''
    substituteInPlace main.go \
      --replace-warn 'const version = "0.1.0"' 'const version = "${final.version}"'
  '';

  # The eBPF objects are pre-compiled, committed and embedded via
  # `go:embed`, so no clang / bpftool / libbpf is needed and the
  # `go generate` step of upstream's Makefile must not run.
  #
  # Tests attach eBPF programs and read other processes' /proc entries,
  # neither of which works in the build sandbox.
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "eBPF-powered network traffic monitor: per process, per connection, live";
    homepage = "https://github.com/immanuwell/pktz";
    changelog = "https://github.com/immanuwell/pktz/releases/tag/${final.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "pktz";
    platforms = lib.platforms.linux;
  };
})
