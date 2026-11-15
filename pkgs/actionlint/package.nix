{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  python3Packages,
  shellcheck,
}:

buildGoModule (finalAttrs: {
  pname = "actionlint";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "kjanat";
    repo = "actionlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fVtZX7sxU48gk98A5RFCu12sYCW3kLsXQk5KXKm7WGM=";
  };

  vendorHash = "sha256-PVEf1pJvwQu/2dFS0YhWoXahnTqvqmRdYjVfujjs04k=";

  subPackages = [ "cmd/actionlint" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/actionlint" \
      --prefix PATH : ${
        lib.makeBinPath [
          python3Packages.pyflakes
          shellcheck
        ]
      }
  '';

  ldflags = [
    "-s"
    "-w"
    "-X actionlint.kjanat.dev.version=${finalAttrs.version}"
  ];

  meta = {
    homepage = "https://github.com/kjanat/actionlint";
    description = "Static checker for GitHub Actions workflow files (maintained fork)";
    license = lib.licenses.mit;
    mainProgram = "actionlint";
  };
})
